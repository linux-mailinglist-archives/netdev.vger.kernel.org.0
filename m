Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D5FFF94
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfD3SNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:13:23 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:50702
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727176AbfD3SNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWaAWwauXDZYCeYNYLYpSPXNoVnqxjSVPcqtoJQcd6M=;
 b=BOALSggjY5kiZGPnD86aC3VrKyIApWR7GFJvKGJCWs3RQFZ1cz5C2d68i+2oPnzjj1OW3AuaMNzA/wh3iAW41afkj3yT9NiKKCmQT2aU+i+rIHfjBNF2XNPMs6zYRZgPfZeTSZvrPHQl9pjRgSaZR+b25fKt6/8EGvtuk/uxSpE=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:13:07 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:13:07 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v2 15/16] net/mlx5e: Move queue param structs to
 en/params.h
Thread-Topic: [PATCH bpf-next v2 15/16] net/mlx5e: Move queue param structs to
 en/params.h
Thread-Index: AQHU/4BcQXd1rXdF10qzjJLfActZag==
Date:   Tue, 30 Apr 2019 18:13:07 +0000
Message-ID: <20190430181215.15305-16-maximmi@mellanox.com>
References: <20190430181215.15305-1-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0250.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::22) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed2ecf60-0d0f-4fd1-0848-08d6cd977ee1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB55530B4968F9C902D0AB4372D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(50226002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(107886003)(102836004)(68736007)(86362001)(7736002)(186003)(66066001)(6486002)(1076003)(386003)(5660300002)(53936002)(25786009)(6512007)(14454004)(7416002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zLmrujUYiwAEa6mRENmLechi3M6sPY+V7HmOc8IYa5unzqUSP0fhuL7ulqkjc/wpnFvdufyD2wpkVhh7DCG+IvSjEcq9S1wtYYpZdHoQjS1ObJHoSoJYUEUyucr4rJcR7v7YM6G1EMjzrBTS/mQI3lrv5pi8x2kJODRHzgNhF81RvJvTiQyGZgCAkLhHWn7tHEAF20iY4kpBq6PzED+tpg7Ube5PtRwx9+Od2KJ9UIk3zJ6peUzBHGDkUhKK2wGGK74CNYix8djRc2d54QlCRwaY7IHK54HJ2eT4lcbowWpFahHWUUbR5cZ5Z2k88hOoG/s7Gr6S+2Dm1C/L0Iu0h4zIZsuQcHKXQuA1QSvsp2W5CV1rw9uZ27c0d3RKbUC0IhsioZA+ti8qtJC9HRkSuQit+B/V3PotU4v4smUxiaA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed2ecf60-0d0f-4fd1-0848-08d6cd977ee1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:13:07.5198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c3RydWN0cyBtbHg1ZV97cnEsc3EsY3EsY2hhbm5lbH1fcGFyYW0gYXJlIGdvaW5nIHRvIGJlIHVz
ZWQgaW4gdGhlDQp1cGNvbWluZyBYU0sgUlggYW5kIFRYIHBhdGNoZXMuIE1vdmUgdGhlbSB0byBh
IGhlYWRlciBmaWxlIHRvIG1ha2UNCnRoZW0gYWNjZXNzaWJsZSBmcm9tIG90aGVyIEMgZmlsZXMu
DQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5j
b20+DQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KQWNr
ZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9wYXJhbXMuaCAgIHwgMzEgKysrKysrKysrKysr
KysrKysrKw0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyB8
IDI5IC0tLS0tLS0tLS0tLS0tLS0tDQogMiBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCsp
LCAyOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbi9wYXJhbXMuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbi9wYXJhbXMuaA0KaW5kZXggN2YyOWI4MmRkOGMyLi5mODM0MTdiODIy
YmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4vcGFyYW1zLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi9wYXJhbXMuaA0KQEAgLTExLDYgKzExLDM3IEBAIHN0cnVjdCBtbHg1ZV94c2tfcGFyYW0g
ew0KIAl1MTYgY2h1bmtfc2l6ZTsNCiB9Ow0KIA0KK3N0cnVjdCBtbHg1ZV9ycV9wYXJhbSB7DQor
CXUzMiAgICAgICAgICAgICAgICAgICAgICAgIHJxY1tNTFg1X1NUX1NaX0RXKHJxYyldOw0KKwlz
dHJ1Y3QgbWx4NV93cV9wYXJhbSAgICAgICB3cTsNCisJc3RydWN0IG1seDVlX3JxX2ZyYWdzX2lu
Zm8gZnJhZ3NfaW5mbzsNCit9Ow0KKw0KK3N0cnVjdCBtbHg1ZV9zcV9wYXJhbSB7DQorCXUzMiAg
ICAgICAgICAgICAgICAgICAgICAgIHNxY1tNTFg1X1NUX1NaX0RXKHNxYyldOw0KKwlzdHJ1Y3Qg
bWx4NV93cV9wYXJhbSAgICAgICB3cTsNCisJYm9vbCAgICAgICAgICAgICAgICAgICAgICAgaXNf
bXB3Ow0KK307DQorDQorc3RydWN0IG1seDVlX2NxX3BhcmFtIHsNCisJdTMyICAgICAgICAgICAg
ICAgICAgICAgICAgY3FjW01MWDVfU1RfU1pfRFcoY3FjKV07DQorCXN0cnVjdCBtbHg1X3dxX3Bh
cmFtICAgICAgIHdxOw0KKwl1MTYgICAgICAgICAgICAgICAgICAgICAgICBlcV9peDsNCisJdTgg
ICAgICAgICAgICAgICAgICAgICAgICAgY3FfcGVyaW9kX21vZGU7DQorfTsNCisNCitzdHJ1Y3Qg
bWx4NWVfY2hhbm5lbF9wYXJhbSB7DQorCXN0cnVjdCBtbHg1ZV9ycV9wYXJhbSAgICAgIHJxOw0K
KwlzdHJ1Y3QgbWx4NWVfc3FfcGFyYW0gICAgICBzcTsNCisJc3RydWN0IG1seDVlX3NxX3BhcmFt
ICAgICAgeGRwX3NxOw0KKwlzdHJ1Y3QgbWx4NWVfc3FfcGFyYW0gICAgICBpY29zcTsNCisJc3Ry
dWN0IG1seDVlX2NxX3BhcmFtICAgICAgcnhfY3E7DQorCXN0cnVjdCBtbHg1ZV9jcV9wYXJhbSAg
ICAgIHR4X2NxOw0KKwlzdHJ1Y3QgbWx4NWVfY3FfcGFyYW0gICAgICBpY29zcV9jcTsNCit9Ow0K
Kw0KKy8qIFBhcmFtZXRlciBjYWxjdWxhdGlvbnMgKi8NCisNCiB1MTYgbWx4NWVfZ2V0X2xpbmVh
cl9ycV9oZWFkcm9vbShzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsDQogCQkJCSBzdHJ1Y3Qg
bWx4NWVfeHNrX3BhcmFtICp4c2spOw0KIHUzMiBtbHg1ZV9yeF9nZXRfbGluZWFyX2ZyYWdfc3oo
c3RydWN0IG1seDVlX3BhcmFtcyAqcGFyYW1zLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQppbmRleCA5Zjc0YjlmNzIxMzUuLjNiMmQ3
YTFmYTdkZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9tYWluLmMNCkBAIC01NywzNSArNTcsNiBAQA0KICNpbmNsdWRlICJlbi9yZXBvcnRl
ci5oIg0KICNpbmNsdWRlICJlbi9wYXJhbXMuaCINCiANCi1zdHJ1Y3QgbWx4NWVfcnFfcGFyYW0g
ew0KLQl1MzIJCQlycWNbTUxYNV9TVF9TWl9EVyhycWMpXTsNCi0Jc3RydWN0IG1seDVfd3FfcGFy
YW0Jd3E7DQotCXN0cnVjdCBtbHg1ZV9ycV9mcmFnc19pbmZvIGZyYWdzX2luZm87DQotfTsNCi0N
Ci1zdHJ1Y3QgbWx4NWVfc3FfcGFyYW0gew0KLQl1MzIgICAgICAgICAgICAgICAgICAgICAgICBz
cWNbTUxYNV9TVF9TWl9EVyhzcWMpXTsNCi0Jc3RydWN0IG1seDVfd3FfcGFyYW0gICAgICAgd3E7
DQotCWJvb2wgICAgICAgICAgICAgICAgICAgICAgIGlzX21wdzsNCi19Ow0KLQ0KLXN0cnVjdCBt
bHg1ZV9jcV9wYXJhbSB7DQotCXUzMiAgICAgICAgICAgICAgICAgICAgICAgIGNxY1tNTFg1X1NU
X1NaX0RXKGNxYyldOw0KLQlzdHJ1Y3QgbWx4NV93cV9wYXJhbSAgICAgICB3cTsNCi0JdTE2ICAg
ICAgICAgICAgICAgICAgICAgICAgZXFfaXg7DQotCXU4ICAgICAgICAgICAgICAgICAgICAgICAg
IGNxX3BlcmlvZF9tb2RlOw0KLX07DQotDQotc3RydWN0IG1seDVlX2NoYW5uZWxfcGFyYW0gew0K
LQlzdHJ1Y3QgbWx4NWVfcnFfcGFyYW0gICAgICBycTsNCi0Jc3RydWN0IG1seDVlX3NxX3BhcmFt
ICAgICAgc3E7DQotCXN0cnVjdCBtbHg1ZV9zcV9wYXJhbSAgICAgIHhkcF9zcTsNCi0Jc3RydWN0
IG1seDVlX3NxX3BhcmFtICAgICAgaWNvc3E7DQotCXN0cnVjdCBtbHg1ZV9jcV9wYXJhbSAgICAg
IHJ4X2NxOw0KLQlzdHJ1Y3QgbWx4NWVfY3FfcGFyYW0gICAgICB0eF9jcTsNCi0Jc3RydWN0IG1s
eDVlX2NxX3BhcmFtICAgICAgaWNvc3FfY3E7DQotfTsNCi0NCiBib29sIG1seDVlX2NoZWNrX2Zy
YWdtZW50ZWRfc3RyaWRpbmdfcnFfY2FwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICptZGV2KQ0KIHsN
CiAJYm9vbCBzdHJpZGluZ19ycV91bXIgPSBNTFg1X0NBUF9HRU4obWRldiwgc3RyaWRpbmdfcnEp
ICYmDQotLSANCjIuMTkuMQ0KDQo=
