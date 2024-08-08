import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class TabScreen extends StatelessWidget {
  const TabScreen({super.key});

@override
Widget build(BuildContext context) {
return DefaultTabController(
length: 2, // Number of tabs
child: Scaffold(
appBar: AppBar(
title: Text('Tab Menu'),
bottom: TabBar(
tabs: [
Tab(icon: Icon(Icons.person), text: 'Users'),
Tab(icon: Icon(Icons.info), text: 'About'),
],
),
),
body: TabBarView(
children: [
UsersTab(),
AboutTab(),
],
),
),
);
}
}
class UsersTab extends StatelessWidget {
Future<List<User>> fetchUsers() async {
final response =
await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
if (response.statusCode == 200) {
final List<dynamic> data = json.decode(response.body)['data'];
return data.map((user) => User.fromJson(user)).toList();
} else {
throw Exception('Failed to load users');
}
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('User List'),
),
body: FutureBuilder<List<User>>(
future: fetchUsers(),
builder: (context, snapshot) {
final users = snapshot.data!;
return ListView.builder(
itemCount: users.length,
itemBuilder: (context, index) {
final user = users[index];
return ListTile(
title: Text(user.firstName),
subtitle: Text(user.email),
);
},
);
},
),
);
}
}
class AboutTab extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Center(
child: Text('About information goes here'),
);
}
}
class User {
final String firstName;
final String email;
User({required this.firstName, required this.email});
factory User.fromJson(Map<String, dynamic> json) {
return User(
firstName: json['first_name'],
email: json['email'],
);
}
}