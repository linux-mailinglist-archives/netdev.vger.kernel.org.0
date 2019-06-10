Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C23BFFD
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390801AbfFJXi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:27 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:50500
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390795AbfFJXi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oo8rubOh+F3o7i4px3YYI9u37AEyWNlW2kCJ0EXE6oM=;
 b=Qsj2fbdV2djWEIbY7dK54DDuivmlWGRKUdnvx9F+Y1MbYr0j+7JrCwZD1wn20ISCfos7emw87s2B2yo2GRFO2yQjcpn/W7zDOvFfY98XP0Ycb5uO8BdJvESQ4+SktUHhXAh/Z3a/3WHNJGeOSy1U0Oh5U+DzPzesCRkAEBXNSls=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:18 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 03/16] net/mlx5: E-Switch, Return raw output for
 query esw functions
Thread-Topic: [PATCH mlx5-next 03/16] net/mlx5: E-Switch, Return raw output
 for query esw functions
Thread-Index: AQHVH+WUjdqWzzKTNUecwYt453XEDw==
Date:   Mon, 10 Jun 2019 23:38:18 +0000
Message-ID: <20190610233733.12155-4-saeedm@mellanox.com>
References: <20190610233733.12155-1-saeedm@mellanox.com>
In-Reply-To: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 520d6243-0fa8-45b1-1d54-08d6edfcb6fc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB21667158768CA33180181294BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(136003)(366004)(199004)(189003)(26005)(71190400001)(76176011)(386003)(7736002)(6506007)(73956011)(66556008)(102836004)(86362001)(66476007)(66946007)(107886003)(71200400001)(305945005)(5660300002)(64756008)(66446008)(316002)(68736007)(66066001)(1076003)(6636002)(110136005)(3846002)(54906003)(6116002)(36756003)(186003)(2616005)(81166006)(256004)(85306007)(450100002)(14454004)(50226002)(53936002)(6512007)(52116002)(25786009)(8936002)(8676002)(476003)(99286004)(6486002)(4326008)(81156014)(478600001)(2906002)(446003)(11346002)(6436002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d5wMX1rND1PM763vkuktiA7E9JfkNLc/StZsfqh7KcZpFLO9hrK+VkOXE1otmZQXwX6GfUHU7Hp+aztyvQc/NCAebcJ770TnalmmPs/HXrUZewCPY1XWGYsOLKvG/6WyASK2xESUxuzoApcqEbCQQbLkVpz64Ayi/GEeVmoTacvgOXgJmpYY9NSz+NleA7vL3HxvZPllhCudRVWZeek5JPCjJH2NGEgXs500lHKHPjjQxlHDWwDykwUU7sDG0i1UF+85Fz/Ky+37OljclTIapP9w0k/JBOxKyuoxmMydl1IaRh3ohLRddHXXdC8Sii5wrp6xhGr6CCxrIijG0rtTrQAFFFtPbeBPweNRGtJLA5yHAdXDOuqgavYeWIEyFbijss8jDZlTSS1oPLp3GWFHoG4SYLJDnVs7fSFoaX7Av38=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520d6243-0fa8-45b1-1d54-08d6edfcb6fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:18.1665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCkN1cnJlbnQgZnVuY3Rp
b24gb25seSByZXR1cm5zIGhvc3QgbnVtIG9mIFZGcywgbGF0ZXIgcGF0Y2ggcmVxdWlyZXMNCm90
aGVyIHBhcmFtcyBzdWNoIGFzIGhvc3QgbWF4aW11bSBudW0gb2YgVkZzLg0KDQpSZXR1cm4gdGhl
IHJhdyBvdXRwdXQgc28gdGhhdCBjYWxsZXIgY2FuIGV4dHJhY3QgaW5mbyBhcyBuZWVkZWQuDQoN
ClNpZ25lZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxib2RvbmdAbWVsbGFub3guY29tPg0KUmV2aWV3
ZWQtYnk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMgfCAyMSArKy0tLS0tLS0tLS0tLS0tLS0t
DQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oIHwgIDcgKysr
KysrLQ0KIC4uLi9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jICAgICB8ICA1
ICsrKystDQogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMo
LSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lc3dpdGNoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3
aXRjaC5jDQppbmRleCA1MDRjMDQ0MGIwYjAuLmE0ZGYxMDlmYmViNyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCkBAIC0xNjg2
LDEwICsxNjg2LDkgQEAgc3RhdGljIGludCBlc3dpdGNoX3Zwb3J0X2V2ZW50KHN0cnVjdCBub3Rp
Zmllcl9ibG9jayAqbmIsDQogCXJldHVybiBOT1RJRllfT0s7DQogfQ0KIA0KLXN0YXRpYyBpbnQg
cXVlcnlfZXN3X2Z1bmN0aW9ucyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LA0KLQkJCSAgICAg
ICB1MzIgKm91dCwgaW50IG91dGxlbikNCitpbnQgbWx4NV9lc3dfcXVlcnlfZnVuY3Rpb25zKHN0
cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHUzMiAqb3V0LCBpbnQgb3V0bGVuKQ0KIHsNCi0JdTMy
IGluW01MWDVfU1RfU1pfRFcocXVlcnlfZXN3X2Z1bmN0aW9uc19pbildID0gezB9Ow0KKwl1MzIg
aW5bTUxYNV9TVF9TWl9EVyhxdWVyeV9lc3dfZnVuY3Rpb25zX2luKV0gPSB7fTsNCiANCiAJTUxY
NV9TRVQocXVlcnlfZXN3X2Z1bmN0aW9uc19pbiwgaW4sIG9wY29kZSwNCiAJCSBNTFg1X0NNRF9P
UF9RVUVSWV9FU1dfRlVOQ1RJT05TKTsNCkBAIC0xNjk3LDIyICsxNjk2LDYgQEAgc3RhdGljIGlu
dCBxdWVyeV9lc3dfZnVuY3Rpb25zKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsDQogCXJldHVy
biBtbHg1X2NtZF9leGVjKGRldiwgaW4sIHNpemVvZihpbiksIG91dCwgb3V0bGVuKTsNCiB9DQog
DQotaW50IG1seDVfZXN3X3F1ZXJ5X2Z1bmN0aW9ucyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2
LCB1MTYgKm51bV92ZnMpDQotew0KLQl1MzIgb3V0W01MWDVfU1RfU1pfRFcocXVlcnlfZXN3X2Z1
bmN0aW9uc19vdXQpXSA9IHswfTsNCi0JaW50IGVycjsNCi0NCi0JZXJyID0gcXVlcnlfZXN3X2Z1
bmN0aW9ucyhkZXYsIG91dCwgc2l6ZW9mKG91dCkpOw0KLQlpZiAoZXJyKQ0KLQkJcmV0dXJuIGVy
cjsNCi0NCi0JKm51bV92ZnMgPSBNTFg1X0dFVChxdWVyeV9lc3dfZnVuY3Rpb25zX291dCwgb3V0
LA0KLQkJCSAgICBob3N0X3BhcmFtc19jb250ZXh0Lmhvc3RfbnVtX29mX3Zmcyk7DQotCWVzd19k
ZWJ1ZyhkZXYsICJob3N0X251bV9vZl92ZnM9JWRcbiIsICpudW1fdmZzKTsNCi0NCi0JcmV0dXJu
IDA7DQotfQ0KLQ0KIC8qIFB1YmxpYyBFLVN3aXRjaCBBUEkgKi8NCiAjZGVmaW5lIEVTV19BTExP
V0VEKGVzdykgKChlc3cpICYmIE1MWDVfRVNXSVRDSF9NQU5BR0VSKChlc3cpLT5kZXYpKQ0KIA0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5o
DQppbmRleCAxMzVkOWEyOWJiZGYuLmUwMzgxMWJlNzcxZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmgNCisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmgNCkBAIC0zODcsNyArMzg3
LDcgQEAgYm9vbCBtbHg1X2Vzd19sYWdfcHJlcmVxKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYw
LA0KIGJvb2wgbWx4NV9lc3dfbXVsdGlwYXRoX3ByZXJlcShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2MCwNCiAJCQkgICAgICAgc3RydWN0IG1seDVfY29yZV9kZXYgKmRldjEpOw0KIA0KLWludCBt
bHg1X2Vzd19xdWVyeV9mdW5jdGlvbnMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTE2ICpu
dW1fdmZzKTsNCitpbnQgbWx4NV9lc3dfcXVlcnlfZnVuY3Rpb25zKHN0cnVjdCBtbHg1X2NvcmVf
ZGV2ICpkZXYsIHUzMiAqb3V0LCBpbnQgb3V0bGVuKTsNCiANCiAjZGVmaW5lIE1MWDVfREVCVUdf
RVNXSVRDSF9NQVNLIEJJVCgzKQ0KIA0KQEAgLTUxNCw2ICs1MTQsMTEgQEAgc3RhdGljIGlubGlu
ZSBpbnQgIG1seDVfZXN3aXRjaF9lbmFibGVfc3Jpb3Yoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3
LCBpbnQgbnZmcywNCiBzdGF0aWMgaW5saW5lIHZvaWQgbWx4NV9lc3dpdGNoX2Rpc2FibGVfc3Jp
b3Yoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KSB7fQ0KIHN0YXRpYyBpbmxpbmUgYm9vbCBtbHg1
X2Vzd19sYWdfcHJlcmVxKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYwLCBzdHJ1Y3QgbWx4NV9j
b3JlX2RldiAqZGV2MSkgeyByZXR1cm4gdHJ1ZTsgfQ0KIHN0YXRpYyBpbmxpbmUgYm9vbCBtbHg1
X2Vzd2l0Y2hfaXNfZnVuY3NfaGFuZGxlcihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KSB7IHJl
dHVybiBmYWxzZTsgfQ0KK3N0YXRpYyBpbmxpbmUgaW50DQorbWx4NV9lc3dfcXVlcnlfZnVuY3Rp
b25zKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHUzMiAqb3V0LCBpbnQgb3V0bGVuKQ0KK3sN
CisJcmV0dXJuIC1FT1BOT1RTVVBQOw0KK30NCiANCiAjZGVmaW5lIEZEQl9NQVhfQ0hBSU4gMQ0K
ICNkZWZpbmUgRkRCX1NMT1dfUEFUSF9DSEFJTiAoRkRCX01BWF9DSEFJTiArIDEpDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2Zm
bG9hZHMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNo
X29mZmxvYWRzLmMNCmluZGV4IGY4NDNkOGEzNWEyYy4uMTYzOGU0Y2RlYjE2IDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9h
ZHMuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0
Y2hfb2ZmbG9hZHMuYw0KQEAgLTE3NjIsNiArMTc2Miw3IEBAIHN0YXRpYyB2b2lkIGVzd19vZmZs
b2Fkc19zdGVlcmluZ19jbGVhbnVwKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdykNCiANCiBzdGF0
aWMgdm9pZCBlc3dfZnVuY3Rpb25zX2NoYW5nZWRfZXZlbnRfaGFuZGxlcihzdHJ1Y3Qgd29ya19z
dHJ1Y3QgKndvcmspDQogew0KKwl1MzIgb3V0W01MWDVfU1RfU1pfRFcocXVlcnlfZXN3X2Z1bmN0
aW9uc19vdXQpXSA9IHt9Ow0KIAlzdHJ1Y3QgbWx4NV9ob3N0X3dvcmsgKmhvc3Rfd29yazsNCiAJ
c3RydWN0IG1seDVfZXN3aXRjaCAqZXN3Ow0KIAl1MTYgbnVtX3ZmcyA9IDA7DQpAQCAtMTc3MCw3
ICsxNzcxLDkgQEAgc3RhdGljIHZvaWQgZXN3X2Z1bmN0aW9uc19jaGFuZ2VkX2V2ZW50X2hhbmRs
ZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KIAlob3N0X3dvcmsgPSBjb250YWluZXJfb2Yo
d29yaywgc3RydWN0IG1seDVfaG9zdF93b3JrLCB3b3JrKTsNCiAJZXN3ID0gaG9zdF93b3JrLT5l
c3c7DQogDQotCWVyciA9IG1seDVfZXN3X3F1ZXJ5X2Z1bmN0aW9ucyhlc3ctPmRldiwgJm51bV92
ZnMpOw0KKwllcnIgPSBtbHg1X2Vzd19xdWVyeV9mdW5jdGlvbnMoZXN3LT5kZXYsIG91dCwgc2l6
ZW9mKG91dCkpOw0KKwludW1fdmZzID0gTUxYNV9HRVQocXVlcnlfZXN3X2Z1bmN0aW9uc19vdXQs
IG91dCwNCisJCQkgICBob3N0X3BhcmFtc19jb250ZXh0Lmhvc3RfbnVtX29mX3Zmcyk7DQogCWlm
IChlcnIgfHwgbnVtX3ZmcyA9PSBlc3ctPmVzd19mdW5jcy5udW1fdmZzKQ0KIAkJZ290byBvdXQ7
DQogDQotLSANCjIuMjEuMA0KDQo=
