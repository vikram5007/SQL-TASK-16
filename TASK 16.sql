create database triggers_task

create table students(
regno int primary key,
name varchar(20)
)

------------------------ 2. Create a DML trigger to restrict delete operations between 11:00AM to 15:00PM. ------------------------------

alter trigger dml_off on students
for delete
as begin
if datepart(hh,getdate())=between 11 and 15
begin print ' ACCESS IS BLOCKED IN THIS TIME ZONE'
ROLLBACK TRAN
END
END

delete from students

------------  1. Create a DML trigger to restrict DML operations on Saturday and Sunday. ------------

CREATE trigger dml_wk on students
for insert,update,delete
as begin 
if datepart(dw,getdate())=1 or datepart(dw,getdate())=7
begin
print'THE DML OPERATIONS ARE BLOCKED IN SATURDAY AND SUNDAY'
rollback tran
end
end

insert into students values(1,'vikram')
insert into students values(2,'vasanth')
insert into students values (3,'hari')

--------- 3. Create a DDL trigger to show notification whenever a CREATE, ALTER, DROP, RENAME operation is performed.-------------

create trigger table_creation on database -- TRIGGER FOR TABLE CREATION ON DATABASE 
for create_table
as begin
print 'TABLE CREATED SUCCESSFULLY '
end


create table staffs(
sid int primary key,
sname varchar(20)
)

create trigger table_alter on database -- TRIGGER FOR TABLE ALTERATION ON DATABASE
for alter_table
as begin
print 'TABLE ALTERED SUCCESSFULLY '
end

ALTER TABLE staffs add Subject varchar(20)

create trigger table_rename on database -- TRIGGER FOR RENAMING TABLE ON DATABASE
for rename
as begin
print 'TABLE RENAMED  SUCCESSFULLY '
end

sp_rename 'staffs','staff'

create trigger table_dropp on database -- TRIGGER FOR DROPPING TABLE ON DATABASE
for DROP_TABLE
as begin
print 'TABLE DROPPED SUCCESSFULLY '
end


drop table staff




----------------- ALL DDL TRIGGERS IN ONE TRIGGER ------------------------

ALTER trigger ddl_commands on database
for CREATE_TABLE,ALTER_TABLE,DROP_TABLE,RENAME
as begin
if EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)')='CREATE_TABLE'
print 'TABLE CREATED SUCCESSFULLY ! '
ELSE IF EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)')='ALTER_TABLE'
print 'TABLE ALTERED SUCCESSFULLY ! '
ELSE IF  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)')='DROP_TABLE'
PRINT 'TABLE DROPPED !! '
ELSE IF  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)')='RENAME'
PRINT 'TABLE HAS BEEN RENAMED '
end

-------------------------------------- END ----------------------------------------
