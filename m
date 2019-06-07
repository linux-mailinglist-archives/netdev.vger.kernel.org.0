Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A567739807
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbfFGVsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:48:02 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731225AbfFGVsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DptzrfBidmPB9fyYZU1ASo+cluQQbAn3gDtaX49NC5g=;
 b=Ev158BQO/lxiCXy13F5R4BcX4HMy7TWFMocvnGz7z3Q28kU3DQu2djh5WKRGbBmnDQffeffz9U+k8br9chrxRn49jLqH1/MhBQpiyMM0GpG2ENmBi5lNcNFK2NRdmuB/vAgaYXREEBAl/nex9JUxE/0msLt9IZMkOk4fL0SFnr0=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:41 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Mi <chrism@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/7] net/mlx5e: Add ndo_set_feature for uplink representor
Thread-Topic: [net 3/7] net/mlx5e: Add ndo_set_feature for uplink representor
Thread-Index: AQHVHXqh04FRkPkmTkuksHg8koTqwQ==
Date:   Fri, 7 Jun 2019 21:47:40 +0000
Message-ID: <20190607214716.16316-4-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b82e15e-3bb6-46ec-b729-08d6eb91c3b5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB6139B35FE40EDF28C2183C42BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j5elvRbOAnqZiRs62WREd2+oNeB8WM+O1NdSr0aZcF8hhJE5y/5W51Sx4LpZPG3IiXmMC9YBLR1BymM1QVdyuXCtI/5w6zTR8SiQanpF0Wp6wB5WaffuImJYXNwmhl5X87ygVTlUBleHOxCMWBSaHNMEEqIbOQMG+r2tW1VYfaYThsHao2ohfo6eht/Mak483jWhD6uM86moBy9zYW0OdGPoftDTdGqR+T6Fxt5jlid3v2GE1RxuwdYPYWnhELBFb7U2f6xHzBCiJz3XdGNAEQU7fhTFMdQv4OqicePv7+hpix7vJZVAkc0OSbEQuMY60UYV0C8bbqJ5aiGrlk/3RmvAIPIiSnlqQrSBiesZ6JOLRDTC1BNV4zQAfWHjdx0mYAbdla11/y498C0G3NTLxa6JpHptiBmy/GWwugh2o3Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b82e15e-3bb6-46ec-b729-08d6eb91c3b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:40.8893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWkgPGNocmlzbUBtZWxsYW5veC5jb20+DQoNCkFmdGVyIHdlIGhhdmUgYSBk
ZWRpY2F0ZWQgdXBsaW5rIHJlcHJlc2VudG9yLCB0aGUgbmV3IG5ldGRldiBvcHMNCmRvZXNuJ3Qg
c3VwcG9ydCBuZG9fc2V0X2ZlYXR1cmUuIEJlY2F1c2Ugb2YgdGhhdCwgd2UgY2FuJ3QgY2hhbmdl
DQpzb21lIGZlYXR1cmVzLCBlZy4gcnh2bGFuLiBOb3cgYWRkIGl0IGJhY2suDQoNCkluIHRoaXMg
cGF0Y2gsIEkgYWxzbyBkbyBhIGNsZWFudXAgZm9yIHRoZSBmZWF0dXJlcyBmbGFnIGhhbmRsaW5n
LA0KZWcuIHJlbW92ZSBkdXBsaWNhdGUgTkVUSUZfRl9IV19UQyBmbGFnIHNldHRpbmcuDQoNCkZp
eGVzOiBhZWMwMDJmNmY4MmMgKCJuZXQvbWx4NWU6IFVuaW5zdGFudGlhdGUgZXN3IG1hbmFnZXIg
dnBvcnQgbmV0ZGV2IG9uIHN3aXRjaGRldiBtb2RlIikNClNpZ25lZC1vZmYtYnk6IENocmlzIE1p
IDxjaHJpc21AbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxs
YW5veC5jb20+DQpSZXZpZXdlZC1ieTogVmxhZCBCdXNsb3YgPHZsYWRidUBtZWxsYW5veC5jb20+
DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0t
LQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oICAgICAgfCAg
MSArDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyB8
ICAzICstLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAu
YyAgfCAxMCArKysrKystLS0tDQogMyBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDYg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW4uaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi5oDQppbmRleCAzYTE4M2Q2OTBlMjMuLmFiMDI3ZjU3NzI1YyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaA0KQEAgLTExMTIsNiArMTExMiw3
IEBAIHZvaWQgbWx4NWVfZGVsX3Z4bGFuX3BvcnQoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiwg
c3RydWN0IHVkcF90dW5uZWxfaW5mbyAqdGkpDQogbmV0ZGV2X2ZlYXR1cmVzX3QgbWx4NWVfZmVh
dHVyZXNfY2hlY2soc3RydWN0IHNrX2J1ZmYgKnNrYiwNCiAJCQkJICAgICAgIHN0cnVjdCBuZXRf
ZGV2aWNlICpuZXRkZXYsDQogCQkJCSAgICAgICBuZXRkZXZfZmVhdHVyZXNfdCBmZWF0dXJlcyk7
DQoraW50IG1seDVlX3NldF9mZWF0dXJlcyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBuZXRk
ZXZfZmVhdHVyZXNfdCBmZWF0dXJlcyk7DQogI2lmZGVmIENPTkZJR19NTFg1X0VTV0lUQ0gNCiBp
bnQgbWx4NWVfc2V0X3ZmX21hYyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBpbnQgdmYsIHU4ICpt
YWMpOw0KIGludCBtbHg1ZV9zZXRfdmZfcmF0ZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBpbnQg
dmYsIGludCBtaW5fdHhfcmF0ZSwgaW50IG1heF90eF9yYXRlKTsNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KaW5kZXggYzY1Y2VmZDg0
ZWRhLi5jZDQ5MGFlMzMwZDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQpAQCAtMzYzNSw4ICszNjM1LDcgQEAgc3RhdGljIGlu
dCBtbHg1ZV9oYW5kbGVfZmVhdHVyZShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LA0KIAlyZXR1
cm4gMDsNCiB9DQogDQotc3RhdGljIGludCBtbHg1ZV9zZXRfZmVhdHVyZXMoc3RydWN0IG5ldF9k
ZXZpY2UgKm5ldGRldiwNCi0JCQkgICAgICBuZXRkZXZfZmVhdHVyZXNfdCBmZWF0dXJlcykNCitp
bnQgbWx4NWVfc2V0X2ZlYXR1cmVzKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIG5ldGRldl9m
ZWF0dXJlc190IGZlYXR1cmVzKQ0KIHsNCiAJbmV0ZGV2X2ZlYXR1cmVzX3Qgb3Blcl9mZWF0dXJl
cyA9IG5ldGRldi0+ZmVhdHVyZXM7DQogCWludCBlcnIgPSAwOw0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KaW5kZXggOWFlYTljNWIyY2U4
Li4yZjQwNmIxNjFiY2YgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuYw0KQEAgLTEzNTEsNiArMTM1MSw3IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgbmV0X2RldmljZV9vcHMgbWx4NWVfbmV0ZGV2X29wc191cGxpbmtfcmVwID0gew0KIAku
bmRvX2dldF92Zl9zdGF0cyAgICAgICAgPSBtbHg1ZV9nZXRfdmZfc3RhdHMsDQogCS5uZG9fc2V0
X3ZmX3ZsYW4gICAgICAgICA9IG1seDVlX3VwbGlua19yZXBfc2V0X3ZmX3ZsYW4sDQogCS5uZG9f
Z2V0X3BvcnRfcGFyZW50X2lkCSA9IG1seDVlX3JlcF9nZXRfcG9ydF9wYXJlbnRfaWQsDQorCS5u
ZG9fc2V0X2ZlYXR1cmVzICAgICAgICA9IG1seDVlX3NldF9mZWF0dXJlcywNCiB9Ow0KIA0KIGJv
b2wgbWx4NWVfZXN3aXRjaF9yZXAoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCkBAIC0xNDI1
LDEwICsxNDI2LDkgQEAgc3RhdGljIHZvaWQgbWx4NWVfYnVpbGRfcmVwX25ldGRldihzdHJ1Y3Qg
bmV0X2RldmljZSAqbmV0ZGV2KQ0KIA0KIAluZXRkZXYtPndhdGNoZG9nX3RpbWVvICAgID0gMTUg
KiBIWjsNCiANCisJbmV0ZGV2LT5mZWF0dXJlcyAgICAgICB8PSBORVRJRl9GX05FVE5TX0xPQ0FM
Ow0KIA0KLQluZXRkZXYtPmZlYXR1cmVzCSB8PSBORVRJRl9GX0hXX1RDIHwgTkVUSUZfRl9ORVRO
U19MT0NBTDsNCi0JbmV0ZGV2LT5od19mZWF0dXJlcyAgICAgIHw9IE5FVElGX0ZfSFdfVEM7DQot
DQorCW5ldGRldi0+aHdfZmVhdHVyZXMgICAgfD0gTkVUSUZfRl9IV19UQzsNCiAJbmV0ZGV2LT5o
d19mZWF0dXJlcyAgICB8PSBORVRJRl9GX1NHOw0KIAluZXRkZXYtPmh3X2ZlYXR1cmVzICAgIHw9
IE5FVElGX0ZfSVBfQ1NVTTsNCiAJbmV0ZGV2LT5od19mZWF0dXJlcyAgICB8PSBORVRJRl9GX0lQ
VjZfQ1NVTTsNCkBAIC0xNDM3LDcgKzE0MzcsOSBAQCBzdGF0aWMgdm9pZCBtbHg1ZV9idWlsZF9y
ZXBfbmV0ZGV2KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpDQogCW5ldGRldi0+aHdfZmVhdHVy
ZXMgICAgfD0gTkVUSUZfRl9UU082Ow0KIAluZXRkZXYtPmh3X2ZlYXR1cmVzICAgIHw9IE5FVElG
X0ZfUlhDU1VNOw0KIA0KLQlpZiAocmVwLT52cG9ydCAhPSBNTFg1X1ZQT1JUX1VQTElOSykNCisJ
aWYgKHJlcC0+dnBvcnQgPT0gTUxYNV9WUE9SVF9VUExJTkspDQorCQluZXRkZXYtPmh3X2ZlYXR1
cmVzIHw9IE5FVElGX0ZfSFdfVkxBTl9DVEFHX1JYOw0KKwllbHNlDQogCQluZXRkZXYtPmZlYXR1
cmVzIHw9IE5FVElGX0ZfVkxBTl9DSEFMTEVOR0VEOw0KIA0KIAluZXRkZXYtPmZlYXR1cmVzIHw9
IG5ldGRldi0+aHdfZmVhdHVyZXM7DQotLSANCjIuMjEuMA0KDQo=
