Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B83145563D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732661AbfFYRsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:15 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:51759
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732645AbfFYRsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4u4qDIwkne0pOm+cAxmPi0htUlP2oDQ1wZ27hqFQHQ=;
 b=RM4rADpCtiHoGcN7e9Miyy2piOpWsYJs1zcEn2gMAbhgcCYkYeT3broSwJEKu3PPp5pp0NFc+531kMwH0DziOiGadhCFc5x9yVXCXur+UM5/4Hkp9YJibFT/1vmNOfJGYo+FpKUduZoJGyjdGAiVNNHgcgbIBU0M7yUIvSElArQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:48:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:48:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 09/13] net/mlx5: E-Switch, Add query and modify
 esw vport context functions
Thread-Topic: [PATCH V2 mlx5-next 09/13] net/mlx5: E-Switch, Add query and
 modify esw vport context functions
Thread-Index: AQHVK34kq+VbI+mG8U+cuw/TSkuo+Q==
Date:   Tue, 25 Jun 2019 17:48:05 +0000
Message-ID: <20190625174727.20309-10-saeedm@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6661f687-eb48-4f83-beda-08d6f99546ed
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB221692C73AB53F41547F71C6BEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N1i6TSq8L+oESEBWTeokXtzfe8ss6W61oF3OqAhoJYanedQXzEsLriWwjtKhk/QniAh4ODobJLwR+ueesWtpn3xLQws/cah9BRob/De8LleKXE0dFn4/BNc6XqsoH0ecwt4PpwwvjJbymy3iEkawPZoO26ABjSX+9HFh2k1RtIMlptAIxsdnV9NOJMGJ9fzYVd/L8fa8fQbM3q9tyZGCyoDE9olF+dVr5K+Jo4m0Vs0Cpv6BtU2sTNKN0j6t3Hc3GBWmIEuNMlwNzJ1SBnxi/352kQdJIW9DqWaE6J++uEEDckIZ1AWcZMecD9CWVe60DOtN2Uk0XOPmEKb2JYZUJbagjNRDwuVZwagg9omGfAAJ4tfKK1N0Uz9KRzEj8Ty03RzWCedM8/EU+UMkdioPfQsZMZlkUVdhJYYPeAN4JRM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6661f687-eb48-4f83-beda-08d6f99546ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:48:06.0037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCkFkZCBlc3cgdnBvcnQg
cXVlcnkgYW5kIG1vZGlmeSBmdW5jdGlvbnMsIGFuZCBleHBvc2luZyB0aGVtIGlzIG5lZWRlZCBm
b3INCmVuYWJsaW5nIG9yIGRpc2FibGluZyByZWdpc3RlcnMgcGFzc2VkIGFzIG1ldGF0ZGF0YSB0
byB2cG9ydCBOSUNfUlggdGFibGUNCmluIHNsb3cgcGF0aC4NCg0KU2lnbmVkLW9mZi1ieTogSmlh
bmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogUm9pIERheWFuIDxy
b2lkQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5v
eC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNv
bT4NCi0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyB8
IDI0ICsrKysrKysrKysrKysrKysrKysNCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lc3dpdGNoLmggfCAgNSArKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZXN3aXRjaC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2guYw0KaW5kZXggMTIzNWZkODRhZTNhLi42NzU5ODI3MmQ0YTkgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQorKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQpAQCAtMTM0
LDYgKzEzNCwzMCBAQCBzdGF0aWMgaW50IG1vZGlmeV9lc3dfdnBvcnRfY29udGV4dF9jbWQoc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTE2IHZwb3J0LA0KIAlyZXR1cm4gbWx4NV9jbWRfZXhl
YyhkZXYsIGluLCBpbmxlbiwgb3V0LCBzaXplb2Yob3V0KSk7DQogfQ0KIA0KK2ludCBtbHg1X2Vz
d2l0Y2hfbW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywg
dTE2IHZwb3J0LA0KKwkJCQkJICB2b2lkICppbiwgaW50IGlubGVuKQ0KK3sNCisJcmV0dXJuIG1v
ZGlmeV9lc3dfdnBvcnRfY29udGV4dF9jbWQoZXN3LT5kZXYsIHZwb3J0LCBpbiwgaW5sZW4pOw0K
K30NCisNCitzdGF0aWMgaW50IHF1ZXJ5X2Vzd192cG9ydF9jb250ZXh0X2NtZChzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2LCB1MTYgdnBvcnQsDQorCQkJCSAgICAgICB2b2lkICpvdXQsIGludCBv
dXRsZW4pDQorew0KKwl1MzIgaW5bTUxYNV9TVF9TWl9EVyhxdWVyeV9lc3dfdnBvcnRfY29udGV4
dF9pbildID0ge307DQorDQorCU1MWDVfU0VUKHF1ZXJ5X2Vzd192cG9ydF9jb250ZXh0X2luLCBp
biwgb3Bjb2RlLA0KKwkJIE1MWDVfQ01EX09QX1FVRVJZX0VTV19WUE9SVF9DT05URVhUKTsNCisJ
TUxYNV9TRVQobW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0X2luLCBpbiwgdnBvcnRfbnVtYmVyLCB2
cG9ydCk7DQorCU1MWDVfU0VUKG1vZGlmeV9lc3dfdnBvcnRfY29udGV4dF9pbiwgaW4sIG90aGVy
X3Zwb3J0LCAxKTsNCisJcmV0dXJuIG1seDVfY21kX2V4ZWMoZGV2LCBpbiwgc2l6ZW9mKGluKSwg
b3V0LCBvdXRsZW4pOw0KK30NCisNCitpbnQgbWx4NV9lc3dpdGNoX3F1ZXJ5X2Vzd192cG9ydF9j
b250ZXh0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywgdTE2IHZwb3J0LA0KKwkJCQkJIHZvaWQg
Km91dCwgaW50IG91dGxlbikNCit7DQorCXJldHVybiBxdWVyeV9lc3dfdnBvcnRfY29udGV4dF9j
bWQoZXN3LT5kZXYsIHZwb3J0LCBvdXQsIG91dGxlbik7DQorfQ0KKw0KIHN0YXRpYyBpbnQgbW9k
aWZ5X2Vzd192cG9ydF9jdmxhbihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB1MTYgdnBvcnQs
DQogCQkJCSAgdTE2IHZsYW4sIHU4IHFvcywgdTggc2V0X2ZsYWdzKQ0KIHsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaA0KaW5kZXggNTFl
NzFiODI0YWJmLi4zMzVjYmVlZTFiOWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQpAQCAtMjc2LDYgKzI3NiwxMSBAQCBpbnQg
bWx4NV9lc3dpdGNoX2dldF92cG9ydF9zdGF0cyhzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQog
CQkJCSBzdHJ1Y3QgaWZsYV92Zl9zdGF0cyAqdmZfc3RhdHMpOw0KIHZvaWQgbWx4NV9lc3dpdGNo
X2RlbF9zZW5kX3RvX3Zwb3J0X3J1bGUoc3RydWN0IG1seDVfZmxvd19oYW5kbGUgKnJ1bGUpOw0K
IA0KK2ludCBtbHg1X2Vzd2l0Y2hfbW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0KHN0cnVjdCBtbHg1
X2Vzd2l0Y2ggKmVzdywgdTE2IHZwb3J0LA0KKwkJCQkJICB2b2lkICppbiwgaW50IGlubGVuKTsN
CitpbnQgbWx4NV9lc3dpdGNoX3F1ZXJ5X2Vzd192cG9ydF9jb250ZXh0KHN0cnVjdCBtbHg1X2Vz
d2l0Y2ggKmVzdywgdTE2IHZwb3J0LA0KKwkJCQkJIHZvaWQgKm91dCwgaW50IG91dGxlbik7DQor
DQogc3RydWN0IG1seDVfZmxvd19zcGVjOw0KIHN0cnVjdCBtbHg1X2Vzd19mbG93X2F0dHI7DQog
DQotLSANCjIuMjEuMA0KDQo=
