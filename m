Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99283403C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfFDHeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:34:36 -0400
Received: from mail-eopbgr00119.outbound.protection.outlook.com ([40.107.0.119]:36579
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726943AbfFDHef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXYEfjnbBzhepVaauY/kg2YOiSxsmWOTMut1zUqkphQ=;
 b=lF58WK94wLo9KkpyiWS/aEK/U3Gg1pcjOtSCoYyzuGgDsofw2GADNUsgje+g49vAuBKUo0sUdkWlKUrAvXaWWr3/bxN+0JgadlkSptomQc0lCSfyum5lH9OkeY6t3tJD4XDYFy9xkcKBtEPzdCInrUbtJUr9tKQ7y6lh1USQguU=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM (10.255.19.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:29 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:29 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 06/10] net: dsa: mv88e6xxx: implement
 port_set_speed for mv88e6250
Thread-Topic: [PATCH net-next v4 06/10] net: dsa: mv88e6xxx: implement
 port_set_speed for mv88e6250
Thread-Index: AQHVGqfxcO61plHJuEu5G5SwWOLAqg==
Date:   Tue, 4 Jun 2019 07:34:29 +0000
Message-ID: <20190604073412.21743-7-rasmus.villemoes@prevas.dk>
References: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0030.eurprd03.prod.outlook.com (2603:10a6:20b::43)
 To DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 386b6a83-978c-451f-899c-08d6e8bf141a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3068;
x-ms-traffictypediagnostic: DB8PR10MB3068:
x-microsoft-antispam-prvs: <DB8PR10MB3068C02D29D16894DB3FBC958A150@DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(136003)(376002)(396003)(346002)(189003)(199004)(4326008)(8976002)(8936002)(71200400001)(71190400001)(6436002)(6486002)(68736007)(446003)(486006)(2616005)(11346002)(81156014)(8676002)(66066001)(50226002)(36756003)(81166006)(42882007)(476003)(53936002)(186003)(52116002)(73956011)(76176011)(66946007)(66476007)(66556008)(64756008)(66446008)(99286004)(7736002)(44832011)(25786009)(72206003)(305945005)(478600001)(74482002)(1076003)(256004)(6512007)(102836004)(3846002)(26005)(6116002)(386003)(6506007)(316002)(14454004)(54906003)(5660300002)(2906002)(110136005)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3068;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yaFPtQYoyVXjm1NG2SV5h6t22b/OFQVz1DAPq50UjKblCUmwBTN3vyEXA1uKjkot2KwRS7ri08r2pCUtekV3bTrz3UWF/0agpMsPhb97SqIzirmns8yJmoT41EiPws/2P4OE9MorojGHxLs7S0oIBQPf3vJhCQSGk5l1DJrxiQjm1JHXrH+NrYW/KzX8aZlhrixlkcs0IuM9gltR5gzz9Bfp0KsC7Sa2D4j8mZvJObs7qQxkVQdpfRGK1yE0sm7mLgpYoSpZJsjYEYBsSKpDKU6OjKe6s86qq0aao9OEEe+6ciDNuZLHcIyyNtf82KFUbbsmUNgNpX5FmG4Xfa0I4bqfEL9a2yyqxpwOOGa2F0K+JggHnbSSW4hOGkzdYrte1cy1jzzmX8Bt/ar3+pK16SNgn1juJRtHkGvyRBCgcRg=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 386b6a83-978c-451f-899c-08d6e8bf141a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:29.7132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGRhdGEgc2hlZXQgYWxzbyBtZW50aW9ucyB0aGUgcG9zc2liaWxpdHkgb2Ygc2VsZWN0aW5n
IDIwMCBNYnBzIGZvcg0KdGhlIE1JSSBwb3J0cyAocG9ydHMgNSBhbmQgNikgYnkgc2V0dGluZyB0
aGUgRm9yY2VTcGQgZmllbGQgdG8NCjB4MiAoYWthIE1WODhFNjA2NV9QT1JUX01BQ19DVExfU1BF
RURfMjAwKS4gSG93ZXZlciwgdGhlcmUncyBhIG5vdGUNCnRoYXQgImFjdHVhbCBzcGVlZCBpcyBk
ZXRlcm1pbmVkIGJ5IGJpdCA4IGFib3ZlIiwgYW5kIGZsaXBwaW5nIGJhY2sgYQ0KcGFnZSwgb25l
IGZpbmRzIHRoYXQgYml0cyAxMzo4IGFyZSByZXNlcnZlZC4uLg0KDQpTbyB3aXRob3V0IGZ1cnRo
ZXIgaW5mb3JtYXRpb24gb24gd2hhdCBiaXQgOCBtZWFucywgbGV0J3Mgc3RpY2sgdG8NCnN1cHBv
cnRpbmcganVzdCAxMCBhbmQgMTAwIE1icHMgb24gYWxsIHBvcnRzLg0KDQpSZXZpZXdlZC1ieTog
QW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KU2lnbmVkLW9mZi1ieTogUmFzbXVzIFZpbGxl
bW9lcyA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+DQotLS0NCiBkcml2ZXJzL25ldC9kc2Ev
bXY4OGU2eHh4L3BvcnQuYyB8IDEyICsrKysrKysrKysrKw0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4
ZTZ4eHgvcG9ydC5oIHwgIDEgKw0KIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9wb3J0LmMgYi9kcml2ZXJz
L25ldC9kc2EvbXY4OGU2eHh4L3BvcnQuYw0KaW5kZXggYzQ0YjI4MjJlNGRkLi5hNDFiY2ExN2Ni
YTEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3BvcnQuYw0KKysrIGIv
ZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9wb3J0LmMNCkBAIC0yOTQsNiArMjk0LDE4IEBAIGlu
dCBtdjg4ZTYxODVfcG9ydF9zZXRfc3BlZWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLCBp
bnQgcG9ydCwgaW50IHNwZWVkKQ0KIAlyZXR1cm4gbXY4OGU2eHh4X3BvcnRfc2V0X3NwZWVkKGNo
aXAsIHBvcnQsIHNwZWVkLCBmYWxzZSwgZmFsc2UpOw0KIH0NCiANCisvKiBTdXBwb3J0IDEwLCAx
MDAgTWJwcyAoZS5nLiA4OEU2MjUwIGZhbWlseSkgKi8NCitpbnQgbXY4OGU2MjUwX3BvcnRfc2V0
X3NwZWVkKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQsIGludCBzcGVlZCkN
Cit7DQorCWlmIChzcGVlZCA9PSBTUEVFRF9NQVgpDQorCQlzcGVlZCA9IDEwMDsNCisNCisJaWYg
KHNwZWVkID4gMTAwKQ0KKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKw0KKwlyZXR1cm4gbXY4OGU2
eHh4X3BvcnRfc2V0X3NwZWVkKGNoaXAsIHBvcnQsIHNwZWVkLCBmYWxzZSwgZmFsc2UpOw0KK30N
CisNCiAvKiBTdXBwb3J0IDEwLCAxMDAsIDIwMCwgMTAwMCwgMjUwMCBNYnBzIChlLmcuIDg4RTYz
NDEpICovDQogaW50IG12ODhlNjM0MV9wb3J0X3NldF9zcGVlZChzdHJ1Y3QgbXY4OGU2eHh4X2No
aXAgKmNoaXAsIGludCBwb3J0LCBpbnQgc3BlZWQpDQogew0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvcG9ydC5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9wb3J0
LmgNCmluZGV4IDM5Yzg1ZTk4ZmI5Mi4uMTk1N2UzZTFjZjQ3IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9wb3J0LmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvcG9ydC5oDQpAQCAtMjc5LDYgKzI3OSw3IEBAIGludCBtdjg4ZTZ4eHhfcG9ydF9zZXRfZHVw
bGV4KHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQsIGludCBkdXApOw0KIA0K
IGludCBtdjg4ZTYwNjVfcG9ydF9zZXRfc3BlZWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlw
LCBpbnQgcG9ydCwgaW50IHNwZWVkKTsNCiBpbnQgbXY4OGU2MTg1X3BvcnRfc2V0X3NwZWVkKHN0
cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQsIGludCBzcGVlZCk7DQoraW50IG12
ODhlNjI1MF9wb3J0X3NldF9zcGVlZChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsIGludCBw
b3J0LCBpbnQgc3BlZWQpOw0KIGludCBtdjg4ZTYzNDFfcG9ydF9zZXRfc3BlZWQoc3RydWN0IG12
ODhlNnh4eF9jaGlwICpjaGlwLCBpbnQgcG9ydCwgaW50IHNwZWVkKTsNCiBpbnQgbXY4OGU2MzUy
X3BvcnRfc2V0X3NwZWVkKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgaW50IHBvcnQsIGlu
dCBzcGVlZCk7DQogaW50IG12ODhlNjM5MF9wb3J0X3NldF9zcGVlZChzdHJ1Y3QgbXY4OGU2eHh4
X2NoaXAgKmNoaXAsIGludCBwb3J0LCBpbnQgc3BlZWQpOw0KLS0gDQoyLjIwLjENCg0K
