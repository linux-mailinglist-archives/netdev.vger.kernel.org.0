Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE0430090
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfE3RKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:10:50 -0400
Received: from mail-eopbgr20049.outbound.protection.outlook.com ([40.107.2.49]:22327
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726280AbfE3RKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 13:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0G2Q0wmwG70hzM8qDOJl0xTfaihdIBP8Da9nmnwOA8=;
 b=CQzBQ6iau8JQIm8K/hkmqtyFgMr2wq29Kv6jFKMHHMA2rwWPhcrsHDi+f2yey8dZjPA8ctMujIvhO+37eYpr8hAWgIJxL/slu8kzHXi2LN0RW6jTLxf0IqadLzf4+gBxiCgPgUUJnTimGqzmKeLQxk1HVgsbY8w4hKwS8YMS+JQ=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3485.eurprd03.prod.outlook.com (52.134.14.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Thu, 30 May 2019 17:10:43 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 17:10:43 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next] net: sched: act_ctinfo: minor size optimisation
Thread-Topic: [PATCH net-next] net: sched: act_ctinfo: minor size optimisation
Thread-Index: AQHVFwqdlSDYRw2lu0yEl9is22Zgcw==
Date:   Thu, 30 May 2019 17:10:43 +0000
Message-ID: <20190530170951.19250-1-ldir@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0067.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::44) To VI1PR0302MB2750.eurprd03.prod.outlook.com
 (2603:10a6:800:e3::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1 (Apple Git-117)
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bf9de2b-9498-4d9d-26f2-08d6e521bf86
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7193020);SRVR:VI1PR0302MB3485;
x-ms-traffictypediagnostic: VI1PR0302MB3485:
x-microsoft-antispam-prvs: <VI1PR0302MB34854302E75B29B0C48323E9C9180@VI1PR0302MB3485.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(39830400003)(346002)(376002)(199004)(189003)(73956011)(66946007)(6506007)(86362001)(386003)(64756008)(66476007)(66446008)(74482002)(53936002)(102836004)(305945005)(4744005)(107886003)(1076003)(8676002)(25786009)(71190400001)(71200400001)(7736002)(14444005)(2501003)(256004)(36756003)(5660300002)(476003)(52116002)(50226002)(6512007)(2616005)(6486002)(1730700003)(81166006)(5640700003)(68736007)(486006)(81156014)(14454004)(6916009)(186003)(6116002)(46003)(8936002)(2351001)(99286004)(6436002)(316002)(4326008)(2906002)(66556008)(508600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3485;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h+C5Zb+MW4q/tAGqy6tqf/dq+vp3oe4t+hqS03o3yHr7AirS4qa7Xsv9LA5Wwsy5bv6LI3jeUiY8pM0+PLTERWEbx0ICIEADUwYPd15YtPCIQwKEikCkfQvohxVHa5f1OyBzpKNX44vD9JSCkNLPuKbpK3AdTYR/6FHlAGArvEwjcApH9ymcI86WdIONV4r0rJN6Qp3QPmrmR/p15yudb3C9UhtiavBpWnhESGaulE/LYZOgrpZjI+KPMYWFOnQj2sBSCVsMYYgFL6YBx7D+tYtAazZgGl1FjiwExKX6ht55p9CVkTP7KqBRTI4l3oV/ZWVLMKsoU+giqKlCuEvPuQExcVw7kZicgycrLO/m7PaNe1j0rn3Rgdo8RNt5kunJ7IVdacX1bnneqbb6MQwkqUI8skfKznePaBLoEQU6xJc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf9de2b-9498-4d9d-26f2-08d6e521bf86
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 17:10:43.3598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2luY2UgdGhlIG5ldyBwYXJhbWV0ZXIgYmxvY2sgaXMgaW5pdGlhbGlzZWQgdG8gMCBieSBrem1h
bGxvYyB3ZSBkb24ndA0KbmVlZCB0byBtYXNrICYgY2xlYXIgdW51c2VkIG9wZXJhdGlvbmFsIG1v
ZGUgYml0cywgdGhleSBhcmUgYWxyZWFkeQ0KdW5zZXQuDQoNCkRyb3AgdGhlIHBvaW50bGVzcyBj
b2RlLg0KDQpTaWduZWQtb2ZmLWJ5OiBLZXZpbiBEYXJieXNoaXJlLUJyeWFudCA8bGRpckBkYXJi
eXNoaXJlLWJyeWFudC5tZS51az4NCi0tLQ0KIG5ldC9zY2hlZC9hY3RfY3RpbmZvLmMgfCA0IC0t
LS0NCiAxIGZpbGUgY2hhbmdlZCwgNCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL25ldC9z
Y2hlZC9hY3RfY3RpbmZvLmMgYi9uZXQvc2NoZWQvYWN0X2N0aW5mby5jDQppbmRleCA5MjYxMDkx
MzlhODEuLmU3OGI2MGU0N2MwZiAxMDA2NDQNCi0tLSBhL25ldC9zY2hlZC9hY3RfY3RpbmZvLmMN
CisrKyBiL25ldC9zY2hlZC9hY3RfY3RpbmZvLmMNCkBAIC0yMzEsMTYgKzIzMSwxMiBAQCBzdGF0
aWMgaW50IHRjZl9jdGluZm9faW5pdChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBubGF0dHIgKm5s
YSwNCiAJCWNwX25ldy0+ZHNjcG1hc2tzaGlmdCA9IGRzY3BtYXNrc2hpZnQ7DQogCQljcF9uZXct
PmRzY3BzdGF0ZW1hc2sgPSBkc2Nwc3RhdGVtYXNrOw0KIAkJY3BfbmV3LT5tb2RlIHw9IENUSU5G
T19NT0RFX0RTQ1A7DQotCX0gZWxzZSB7DQotCQljcF9uZXctPm1vZGUgJj0gfkNUSU5GT19NT0RF
X0RTQ1A7DQogCX0NCiANCiAJaWYgKHRiW1RDQV9DVElORk9fUEFSTVNfQ1BNQVJLX01BU0tdKSB7
DQogCQljcF9uZXctPmNwbWFya21hc2sgPQ0KIAkJCQlubGFfZ2V0X3UzMih0YltUQ0FfQ1RJTkZP
X1BBUk1TX0NQTUFSS19NQVNLXSk7DQogCQljcF9uZXctPm1vZGUgfD0gQ1RJTkZPX01PREVfQ1BN
QVJLOw0KLQl9IGVsc2Ugew0KLQkJY3BfbmV3LT5tb2RlICY9IH5DVElORk9fTU9ERV9DUE1BUks7
DQogCX0NCiANCiAJc3Bpbl9sb2NrX2JoKCZjaS0+dGNmX2xvY2spOw0KLS0gDQoyLjIwLjEgKEFw
cGxlIEdpdC0xMTcpDQoNCg==
