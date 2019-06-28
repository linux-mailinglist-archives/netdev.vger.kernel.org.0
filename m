Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186C75A6FE
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfF1WgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:21 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbfF1WgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=tsOTHVqWChvR0Wblo5jp+kILmKwE4JcP2RstOYu5Ju05JGujkRxfk/CTiX7u6WSyJm/k2EMFn/Wb3lWePOWjWwHICQTxwAx6qMD+hmSNXwqglVjWy2wEimfyVDlLrkMZu3jxdyQsk2BAP7Tppu4h3sgZgfERLOsxFFjk+JJbNjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoC74JWyGjr2mPqPfXGUpHKq3LBJ0kTZ9Hj5p+EqFa4=;
 b=lgfsyTuaN9z5mFO8n80jR9/YvZFCiK/aaM3KKT37iYu5Ti+bIuqvnnV8DS5MyiMxM1h548HwIfRxAmMSYwI2bGuOfIalisXrzEeSbjE2jCde26XJWOWTpX33PXtJC9RxTkcj8huhJ5rNs9kHmk7IAKYSAHa96mKow9NupwVB2QQ=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoC74JWyGjr2mPqPfXGUpHKq3LBJ0kTZ9Hj5p+EqFa4=;
 b=gIjcKhlVAoUR5Z1CCOYeqNF85AkcmayN4QqUpS8vDHHvKjAtzDPZ0W9M3TN/x/ehO2BT5q+SQbB4S0Uu4cduygwPDnZYwt4q1WgD8MABZQ2M8MQ8vjeTOFG9YcQY8NwMkXab376ZrbNUtfGoEuGKDRCeWYJ+a8RveVtMhq2i1qk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:36:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:36:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 10/18] net/mlx5: Reduce dependency on enabled_vfs
 counter and num_vfs
Thread-Topic: [PATCH mlx5-next 10/18] net/mlx5: Reduce dependency on
 enabled_vfs counter and num_vfs
Thread-Index: AQHVLgHfjRIy9uQUO0eFLfRabkExxA==
Date:   Fri, 28 Jun 2019 22:36:06 +0000
Message-ID: <20190628223516.9368-11-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59ffda7c-09ca-4993-38d5-08d6fc19023e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB235779787B46D14286883CDBBEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(5024004)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5RpBROWLfbeOzbmD9Ywymi/UnujBIz5zpRDcdenbm5QVdPpbG2c2QxwFzOo6Zb+W+aw+R+LtjCXJ7r5t4Ksk5DBJ4yhZofOTaqnYJiyLo6BhToN54IRnNu00M+uhhTvI0P5PGAfswp9ioDksLHz2KULEe0SKRbFPr0o+rqOO9dPpPKuuJ1Yd3n7mu7I8ODVZLbn0GpYY6qJPtGcLnWZo4IQMt09y554D+KyyXk26MkiHN1r/gCVy4CxMizk8byQrv/pfFu+VIzKxJFWsagdauJbnB9ltNEXWmr/PcK1b0wgvI09vpywCzvQfbhjStgq986RqVot6deleTAgYAYBSdKF/6eNIHvfMVk5ROF85Ol+fm4caOUTA4RAwvxESIHQOpKHoikT+WBqAECLxjcgHik0j/L0dFTFeUEcC6/JJsGA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ffda7c-09ca-4993-38d5-08d6fc19023e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:36:06.5251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCldoaWxlIGVuYWJsaW5n
IFNSLUlPViwgUENJIGNvcmUgYWxyZWFkeSBjaGVja3MgdGhhdCBpZiBTUi1JT1YgaXMgYWxyZWFk
eQ0KZW5hYmxlZCwgaXQgcmV0dXJucyBmYWlsdXJlIGVycm9yIGNvZGUuDQpIZW5jZSwgcmVtb3Zl
IHN1Y2ggZHVwbGljYXRlIGNoZWNrIGZyb20gbWx4NV9jb3JlIGRyaXZlci4NCg0KV2hpbGUgYXQg
aXQsIG1ha2UgbWx4NV9kZXZpY2VfZGlzYWJsZV9zcmlvdigpIHRvIHBlcmZvcm0gY2xlYW51cCBv
ZiBWRnMgaW4NCnJldmVyc2Ugb3JkZXIgb2YgbWx4NV9kZXZpY2VfZW5hYmxlX3NyaW92KCkuDQoN
ClNpZ25lZC1vZmYtYnk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KU2lnbmVk
LW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiAuLi4v
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zcmlvdi5jICAgfCAyMiArKysrLS0tLS0t
LS0tLS0tLS0tDQogaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oICAgICAgICAgICAgICAgICAg
IHwgIDEgLQ0KIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMo
LSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9zcmlvdi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3NyaW92
LmMNCmluZGV4IDJlZWNiODMxYzQ5OS4uOWQ5ZmY0NTExMzA2IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3NyaW92LmMNCisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9zcmlvdi5jDQpAQCAtNzQsMTMgKzc0LDYg
QEAgc3RhdGljIGludCBtbHg1X2RldmljZV9lbmFibGVfc3Jpb3Yoc3RydWN0IG1seDVfY29yZV9k
ZXYgKmRldiwgaW50IG51bV92ZnMpDQogCWludCBlcnI7DQogCWludCB2ZjsNCiANCi0JaWYgKHNy
aW92LT5lbmFibGVkX3Zmcykgew0KLQkJbWx4NV9jb3JlX3dhcm4oZGV2LA0KLQkJCSAgICAgICAi
ZmFpbGVkIHRvIGVuYWJsZSBTUklPViBvbiBkZXZpY2UsIGFscmVhZHkgZW5hYmxlZCB3aXRoICVk
IHZmc1xuIiwNCi0JCQkgICAgICAgc3Jpb3YtPmVuYWJsZWRfdmZzKTsNCi0JCXJldHVybiAtRUJV
U1k7DQotCX0NCi0NCiAJaWYgKCFNTFg1X0VTV0lUQ0hfTUFOQUdFUihkZXYpKQ0KIAkJZ290byBl
bmFibGVfdmZzX2hjYTsNCiANCkBAIC05OSw3ICs5Miw2IEBAIHN0YXRpYyBpbnQgbWx4NV9kZXZp
Y2VfZW5hYmxlX3NyaW92KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIGludCBudW1fdmZzKQ0K
IAkJCWNvbnRpbnVlOw0KIAkJfQ0KIAkJc3Jpb3YtPnZmc19jdHhbdmZdLmVuYWJsZWQgPSAxOw0K
LQkJc3Jpb3YtPmVuYWJsZWRfdmZzKys7DQogCQlpZiAoTUxYNV9DQVBfR0VOKGRldiwgcG9ydF90
eXBlKSA9PSBNTFg1X0NBUF9QT1JUX1RZUEVfSUIpIHsNCiAJCQllcnIgPSBzcmlvdl9yZXN0b3Jl
X2d1aWRzKGRldiwgdmYpOw0KIAkJCWlmIChlcnIpIHsNCkBAIC0xMTgsMTMgKzExMCwxMSBAQCBz
dGF0aWMgaW50IG1seDVfZGV2aWNlX2VuYWJsZV9zcmlvdihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2LCBpbnQgbnVtX3ZmcykNCiBzdGF0aWMgdm9pZCBtbHg1X2RldmljZV9kaXNhYmxlX3NyaW92
KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogew0KIAlzdHJ1Y3QgbWx4NV9jb3JlX3NyaW92
ICpzcmlvdiA9ICZkZXYtPnByaXYuc3Jpb3Y7DQorCWludCBudW1fdmZzID0gcGNpX251bV92Zihk
ZXYtPnBkZXYpOw0KIAlpbnQgZXJyOw0KIAlpbnQgdmY7DQogDQotCWlmICghc3Jpb3YtPmVuYWJs
ZWRfdmZzKQ0KLQkJZ290byBvdXQ7DQotDQotCWZvciAodmYgPSAwOyB2ZiA8IHNyaW92LT5udW1f
dmZzOyB2ZisrKSB7DQorCWZvciAodmYgPSBudW1fdmZzIC0gMTsgdmYgPj0gMDsgdmYtLSkgew0K
IAkJaWYgKCFzcmlvdi0+dmZzX2N0eFt2Zl0uZW5hYmxlZCkNCiAJCQljb250aW51ZTsNCiAJCWVy
ciA9IG1seDVfY29yZV9kaXNhYmxlX2hjYShkZXYsIHZmICsgMSk7DQpAQCAtMTMzLDEwICsxMjMs
OCBAQCBzdGF0aWMgdm9pZCBtbHg1X2RldmljZV9kaXNhYmxlX3NyaW92KHN0cnVjdCBtbHg1X2Nv
cmVfZGV2ICpkZXYpDQogCQkJY29udGludWU7DQogCQl9DQogCQlzcmlvdi0+dmZzX2N0eFt2Zl0u
ZW5hYmxlZCA9IDA7DQotCQlzcmlvdi0+ZW5hYmxlZF92ZnMtLTsNCiAJfQ0KIA0KLW91dDoNCiAJ
aWYgKE1MWDVfRVNXSVRDSF9NQU5BR0VSKGRldikpDQogCQltbHg1X2Vzd2l0Y2hfZGlzYWJsZV9z
cmlvdihkZXYtPnByaXYuZXN3aXRjaCk7DQogDQpAQCAtMTkxLDEzICsxNzksMTEgQEAgaW50IG1s
eDVfY29yZV9zcmlvdl9jb25maWd1cmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGludCBudW1fdmZz
KQ0KIA0KIGludCBtbHg1X3NyaW92X2F0dGFjaChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0K
IHsNCi0Jc3RydWN0IG1seDVfY29yZV9zcmlvdiAqc3Jpb3YgPSAmZGV2LT5wcml2LnNyaW92Ow0K
LQ0KLQlpZiAoIW1seDVfY29yZV9pc19wZihkZXYpIHx8ICFzcmlvdi0+bnVtX3ZmcykNCisJaWYg
KCFtbHg1X2NvcmVfaXNfcGYoZGV2KSB8fCAhcGNpX251bV92ZihkZXYtPnBkZXYpKQ0KIAkJcmV0
dXJuIDA7DQogDQogCS8qIElmIHNyaW92IFZGcyBleGlzdCBpbiBQQ0kgbGV2ZWwsIGVuYWJsZSB0
aGVtIGluIGRldmljZSBsZXZlbCAqLw0KLQlyZXR1cm4gbWx4NV9kZXZpY2VfZW5hYmxlX3NyaW92
KGRldiwgc3Jpb3YtPm51bV92ZnMpOw0KKwlyZXR1cm4gbWx4NV9kZXZpY2VfZW5hYmxlX3NyaW92
KGRldiwgcGNpX251bV92ZihkZXYtPnBkZXYpKTsNCiB9DQogDQogdm9pZCBtbHg1X3NyaW92X2Rl
dGFjaChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGlu
dXgvbWx4NS9kcml2ZXIuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KaW5kZXggMTU1
YjhjYmUxY2M5Li43NjU4YTQ5MDg0MzEgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUv
ZHJpdmVyLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KQEAgLTQ2OCw3ICs0
NjgsNiBAQCBzdHJ1Y3QgbWx4NV92Zl9jb250ZXh0IHsNCiBzdHJ1Y3QgbWx4NV9jb3JlX3NyaW92
IHsNCiAJc3RydWN0IG1seDVfdmZfY29udGV4dAkqdmZzX2N0eDsNCiAJaW50CQkJbnVtX3ZmczsN
Ci0JaW50CQkJZW5hYmxlZF92ZnM7DQogCXUxNgkJCW1heF92ZnM7DQogfTsNCiANCi0tIA0KMi4y
MS4wDQoNCg==
