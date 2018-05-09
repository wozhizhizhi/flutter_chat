import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // IOS的Cupertino控件库
import 'package:flutter/foundation.dart'; //一个用于识别操作系统的工具库，其内的defaultTargetPlatform值可帮助我们识别操作系统

void main() => runApp(new FriendlyChatApp());
const String NAME = "ZHANG";
//Cupertino主题风格
final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

//默认的Material主题风格
final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

class FriendlyChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "FriendlyChat",
        // 用于判断是否是IOS手机
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new ChatScreen());
  }
}

// 聊天页面的主界面
class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

// 单个聊天的界面无状态
class ChatMessage extends StatelessWidget {
  final String text;
  final AnimationController animationController;
  ChatMessage({this.text, this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: new CircleAvatar(child: new Text(NAME[0]))),
              new Expanded(
                  child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(NAME, style: Theme.of(context).textTheme.subhead),
                  new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text))
                ],
              ))
            ],
          ),
        ));
  }
}

// 聊天页面的主界面的状态更新
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // 存放聊天的数组
  final List<ChatMessage> chatMessages = <ChatMessage>[];
  // 聊天文本输入的控件
  final TextEditingController textEditingController =
      new TextEditingController();
  bool _isComposing = false;

  // 定义文本参数的处理函数
  void handleSubmitted(String text) {
    textEditingController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage chatMessage = new ChatMessage(
        text: text,
        animationController: new AnimationController(
            duration: new Duration(milliseconds: 2000), vsync: this));
    setState(() {
      chatMessages.insert(0, chatMessage);
    });
    chatMessage.animationController.forward();
  }

  // 定义文本输入框的控件
  Widget _fixTextWeight() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 子控件可柔性填充，如果下方弹出输入框，使消息记录列表可适当缩小高度
            new Flexible(
                child: new TextField(
                    controller: textEditingController,
                    onChanged: (String text) {
                      setState(() {
                        //  如果文本输入框中的字符串长度大于0则允许发送消息
                        _isComposing = text.length > 0;
                      });
                    },
                    decoration: new InputDecoration.collapsed(
                        hintText: "Send a message"),
                    onSubmitted: handleSubmitted)),
            new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: defaultTargetPlatform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => handleSubmitted(textEditingController.text)
                            : null)
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => handleSubmitted(textEditingController.text)
                            : null))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 适配IOS的扁平化无阴影效果
        appBar: new AppBar(
            title: new Text("Friendlychat"),
            elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 4.0),
        body: new Column(children: <Widget>[
          // 子控件可柔性填充，如果下方弹出输入框，使消息记录列表可适当缩小高度
          new Flexible(
              child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) =>
                      chatMessages[index],
                  itemCount: chatMessages.length)),
          new Divider(height: 1.0),
          new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _fixTextWeight())
        ]));
  }
}
