//
//  ViewController.m
//  MySQLiteTest1
//
//  Created by youbenwu on 16/9/7.
//  Copyright © 2016年 youbenwu. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import <MySQLite/MySQLite.h>
#import <sqlite3.h>

@interface User : NSObject

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSString *username;

@property (nonatomic,strong) NSString *phone;

@property (nonatomic,strong) NSDate *time;

@end

@implementation User



@end

@interface ViewController (){

    NSArray* _list;


}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //注册实体类型，传入作为数据库ＩＤ的字段名称和是否自动递增ＩＤ值。autoIncrement如果为ＹＥＳ，则ＩＤ字段必需为整数类型。
    //这个方法只需要执行一次。
    [[SQLManager manager]registerEntityType:[User class] primaryKey:@"userId" autoIncrement:YES];
    
    
    
    //查数据 时间倒序
    _list=[[[SQLManager manager] createSQLQueryWithEntityType:[User class] where:nil orderBy:@"time desc"] listResult];
    
    //分页
    
    //_list=[[[[[SQLManager manager] createSQLQueryWithEntityType:[User class] where:nil orderBy:@"time desc"] setFirstResults:0] setMaxResults:10] listResult];
    
    
    
}
- (IBAction)clickAdds:(id)sender {
    
    [self addUserList];
    
    _list=[[[SQLManager manager] createSQLQueryWithEntityType:[User class] where:nil orderBy:@"time desc"] listResult];
    [_tableView reloadData];
    
}


-(void)addUserList{

    int c=_list?_list.count:0;
    
    
    SQLTransaction* t=[[SQLManager manager] getTransaction];
    //开始事务
    [t begin];
    
    for (int i=0; i<10; i++) {
        User* user=[User new];
        user.username=[NSString stringWithFormat:@"user name %d",(i+c)];
        user.phone=@"1234455678";
        user.time=[NSDate date];
        BOOL r=[[SQLManager manager] insert:user];
        
        if(!r){
            //如果不成功事务回滚
            [t rollback];
            break;
        }
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(_list)
        return [_list count];
    
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    User* user=[_list objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=user.username;
    cell.subtitleLabel.text=user.phone;
    
    
    return cell;


}


@end
