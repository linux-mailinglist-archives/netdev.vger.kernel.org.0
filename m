Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5385CE9E7
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfD2SOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:14:51 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:17742
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729084AbfD2SOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:14:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxEu1NVagfQYa54U3DuoiOJliiFncwQPEnyi1vGr3V4=;
 b=KCoNxcI5meDKdCE+WLhtCs7y35xgamJQNnOlYiJJzEAVyGNHrflW7u7nEJh5K3+wpb63TztMyOKh3DK1lZE3BxPlM2/WhnqH71Mubf8lm6KZRP1Yh8PxGoRwXJXcnKm9363uoy0AoLoDln83IyRCLO4xjjJkK4UyAVSr9fDb2B4=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6619.eurprd05.prod.outlook.com (20.179.12.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Mon, 29 Apr 2019 18:14:18 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:14:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>
Subject: [PATCH V2 mlx5-next 10/11] net/mlx5: Geneve, Add basic Geneve
 encap/decap flow table capabilities
Thread-Topic: [PATCH V2 mlx5-next 10/11] net/mlx5: Geneve, Add basic Geneve
 encap/decap flow table capabilities
Thread-Index: AQHU/rdcwXq20UzPyEW8bH9Xde2ulQ==
Date:   Mon, 29 Apr 2019 18:14:18 +0000
Message-ID: <20190429181326.6262-11-saeedm@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:a03:40::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 558702cf-418a-41c7-c3a7-08d6ccce7ed7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6619;
x-ms-traffictypediagnostic: DB8PR05MB6619:
x-microsoft-antispam-prvs: <DB8PR05MB6619EB116CE07C0135FC3B42BE390@DB8PR05MB6619.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(136003)(376002)(396003)(189003)(199004)(6636002)(316002)(66066001)(386003)(6506007)(7736002)(68736007)(36756003)(305945005)(54906003)(110136005)(6512007)(102836004)(186003)(26005)(99286004)(76176011)(14454004)(52116002)(478600001)(8936002)(85306007)(81156014)(8676002)(81166006)(1076003)(2906002)(5660300002)(86362001)(107886003)(6116002)(71200400001)(71190400001)(66946007)(450100002)(73956011)(4326008)(6436002)(97736004)(66556008)(66446008)(66476007)(64756008)(486006)(476003)(2616005)(25786009)(53936002)(6486002)(3846002)(50226002)(11346002)(446003)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6619;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DWD3Fj+MlMVBV6H75iRKt+V6cUtdVeqMpGIihhyDpioW68s/31rv62KxDVfPUvViiiIx0fzuEMuFb2NbYiJU1JRJa/GzCRx1hCqRb9SrDOlhWKyMLTWaZTCqMAikW8nIvhkp03YEzayaI4a2xFzjgbrm4pvMgR0stdTagsHrbK8FgT79QYcoSfUsXHg/hljPXw+bVMpL1av0+BLvWk/zLLcm4L0fyyxONv5lEHsGMLkZnABrhMkrFq4Pg6l+jW6a/F7aAY+zN+oT6w2HkeahXPkepj76t7nhcsx/5pUWr4bv5B4vzybacVqQHIustKVOKZXva8DW2G1M5oWJtydvflhlzrmBQ4q4GZtcaKoBhId7WzxgGSQKj7J7pZyiAfWpsSJ/TIAdRzNPLK6LUfDPKZH7s6jm5j/GbE4Hy8XMpFo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558702cf-418a-41c7-c3a7-08d6ccce7ed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:14:18.5694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWV2Z2VueSBLbGl0ZXluaWsgPGtsaXRleW5AbWVsbGFub3guY29tPg0KDQpJbnRyb2R1
Y2Ugc3VwcG9ydCBmb3IgR2VuZXZlIGZsb3cgc3BlY2lmaWNhdGlvbiBhbmQgYWxsb3cNCnRoZSBj
cmVhdGlvbiBvZiBydWxlcyB0aGF0IGFyZSBtYXRjaGluZyBvbiBiYXNpYyBHZW5ldmUNCnByb3Rv
Y29sIGZpZWxkczogVk5JLCBPQU0gYml0LCBwcm90b2NvbCB0eXBlLCBvcHRpb25zIGxlbmd0aC4N
Cg0KUmV2aWV3ZWQtYnk6IE96IFNobG9tbyA8b3pzaEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2Zm
LWJ5OiBZZXZnZW55IEtsaXRleW5payA8a2xpdGV5bkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2Zm
LWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGluY2x1ZGUv
bGludXgvbWx4NS9tbHg1X2lmYy5oIHwgMTYgKysrKysrKysrKysrKy0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAxMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggYi9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMu
aA0KaW5kZXggN2Q5MjY0YjI4MmQxLi4yNjhhYzEyNmIzYmIgMTAwNjQ0DQotLS0gYS9pbmNsdWRl
L2xpbnV4L21seDUvbWx4NV9pZmMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZj
LmgNCkBAIC0zMDcsNyArMzA3LDExIEBAIHN0cnVjdCBtbHg1X2lmY19mbG93X3RhYmxlX2ZpZWxk
c19zdXBwb3J0ZWRfYml0cyB7DQogCXU4ICAgICAgICAgb3V0ZXJfZ3JlX3Byb3RvY29sWzB4MV07
DQogCXU4ICAgICAgICAgb3V0ZXJfZ3JlX2tleVsweDFdOw0KIAl1OCAgICAgICAgIG91dGVyX3Z4
bGFuX3ZuaVsweDFdOw0KLQl1OCAgICAgICAgIHJlc2VydmVkX2F0XzFhWzB4NV07DQorCXU4ICAg
ICAgICAgb3V0ZXJfZ2VuZXZlX3ZuaVsweDFdOw0KKwl1OCAgICAgICAgIG91dGVyX2dlbmV2ZV9v
YW1bMHgxXTsNCisJdTggICAgICAgICBvdXRlcl9nZW5ldmVfcHJvdG9jb2xfdHlwZVsweDFdOw0K
Kwl1OCAgICAgICAgIG91dGVyX2dlbmV2ZV9vcHRfbGVuWzB4MV07DQorCXU4ICAgICAgICAgcmVz
ZXJ2ZWRfYXRfMWVbMHgxXTsNCiAJdTggICAgICAgICBzb3VyY2VfZXN3aXRjaF9wb3J0WzB4MV07
DQogDQogCXU4ICAgICAgICAgaW5uZXJfZG1hY1sweDFdOw0KQEAgLTQ4MCw3ICs0ODQsOSBAQCBz
dHJ1Y3QgbWx4NV9pZmNfZnRlX21hdGNoX3NldF9taXNjX2JpdHMgew0KIAl1OCAgICAgICAgIHZ4
bGFuX3ZuaVsweDE4XTsNCiAJdTggICAgICAgICByZXNlcnZlZF9hdF9iOFsweDhdOw0KIA0KLQl1
OCAgICAgICAgIHJlc2VydmVkX2F0X2MwWzB4MjBdOw0KKwl1OCAgICAgICAgIGdlbmV2ZV92bmlb
MHgxOF07DQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfZDhbMHg3XTsNCisJdTggICAgICAgICBn
ZW5ldmVfb2FtWzB4MV07DQogDQogCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfZTBbMHhjXTsNCiAJ
dTggICAgICAgICBvdXRlcl9pcHY2X2Zsb3dfbGFiZWxbMHgxNF07DQpAQCAtNDg4LDcgKzQ5NCwx
MSBAQCBzdHJ1Y3QgbWx4NV9pZmNfZnRlX21hdGNoX3NldF9taXNjX2JpdHMgew0KIAl1OCAgICAg
ICAgIHJlc2VydmVkX2F0XzEwMFsweGNdOw0KIAl1OCAgICAgICAgIGlubmVyX2lwdjZfZmxvd19s
YWJlbFsweDE0XTsNCiANCi0JdTggICAgICAgICByZXNlcnZlZF9hdF8xMjBbMHgyOF07DQorCXU4
ICAgICAgICAgcmVzZXJ2ZWRfYXRfMTIwWzB4YV07DQorCXU4ICAgICAgICAgZ2VuZXZlX29wdF9s
ZW5bMHg2XTsNCisJdTggICAgICAgICBnZW5ldmVfcHJvdG9jb2xfdHlwZVsweDEwXTsNCisNCisJ
dTggICAgICAgICByZXNlcnZlZF9hdF8xNDBbMHg4XTsNCiAJdTggICAgICAgICBidGhfZHN0X3Fw
WzB4MThdOw0KIAl1OAkgICByZXNlcnZlZF9hdF8xNjBbMHgyMF07DQogCXU4CSAgIG91dGVyX2Vz
cF9zcGlbMHgyMF07DQotLSANCjIuMjAuMQ0KDQo=
