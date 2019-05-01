Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407D110ECD
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEAVzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:55:01 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:10321
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfEAVy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GfKqyb80qXb+DvV7OTF1Btx+Jk3weBQqUTmIyax4dY=;
 b=oMvyyU3TZkpIEa7P5zZMMVVIbuakHAqC4e6uxo4hPpJqr2KolxSoJZUYbja154JHTMQwGwyhaTrd1pTSxK6W6xE99+p5sdBYi15LbyrqWGayyKY0DfoVFu88FEGdp4mOYrEGCSbaE8/lOSJBsMKCgscXqlbJwXuhnivw9N7iH4w=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Wed, 1 May 2019 21:54:50 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:54:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 02/15] net/mlx5e: Turn on HW tunnel offload in all TIRs
Thread-Topic: [net-next V2 02/15] net/mlx5e: Turn on HW tunnel offload in all
 TIRs
Thread-Index: AQHVAGh/4cy54xLVZUGb6V/XkIr5WQ==
Date:   Wed, 1 May 2019 21:54:49 +0000
Message-ID: <20190501215433.24047-3-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 891ebd9f-7ab5-46d3-8f16-08d6ce7fa221
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6044;
x-ms-traffictypediagnostic: DB8PR05MB6044:
x-microsoft-antispam-prvs: <DB8PR05MB604444A466249952947A41F3BE3B0@DB8PR05MB6044.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(376002)(346002)(366004)(189003)(199004)(386003)(66946007)(66066001)(76176011)(50226002)(8936002)(25786009)(26005)(186003)(107886003)(3846002)(6116002)(6506007)(73956011)(102836004)(1076003)(6486002)(53936002)(6512007)(2906002)(66556008)(64756008)(66476007)(66446008)(68736007)(6916009)(71190400001)(71200400001)(7736002)(8676002)(476003)(14454004)(2616005)(52116002)(486006)(4326008)(11346002)(54906003)(6436002)(305945005)(316002)(86362001)(478600001)(99286004)(5660300002)(14444005)(81156014)(81166006)(256004)(446003)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6044;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rWpDUJ9EGGlaf2JRysctp7sq01OYGFwbN9Id/QT1ZaMKrRRLX5nd8l/gcqiYKSSz49sK68odSVt0+KvBZ2jaxSesBTE8nKU4CMI3s9AFcbchxDbg/V21Z4ug0GjHeqP6h+Od2IGPW0MvPx0xqBpr/62UsXf8+ZFWWGKF908K0dJTShyJ/ibW94QbBjKSnr0RAoC4NibDL5Jmt8do75N4fgjweD0HSxYVyS0Hj/LAM/0FjedhWlPj1AwHLnPzoBlSMTEj+FEYWp95ULaI/RkmmSR2WGD1YgIX/GqExK7qtdWNeHOjNRgMo5qRQRTrrl8tgewqP04w5ybzyMB09Jz628KPN1Euca1Z/zlCENnZXiCFQRE9OHnUMhVkpMTC/ZicTl52ZI5OdhCUlOdu0ao2u9Ak1pciepECnMKDEpDTIOE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 891ebd9f-7ab5-46d3-8f16-08d6ce7fa221
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:54:49.8842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KDQpIYXJkd2FyZSByZXF1
aXJlcyB0aGF0IGFsbCBUSVJzIHRoYXQgc3RlZXIgdHJhZmZpYyB0byB0aGUgc2FtZSBSUQ0Kc2hv
dWxkIHNoYXJlIGlkZW50aWNhbCB0dW5uZWxlZF9vZmZsb2FkX2VuIHZhbHVlLg0KRm9yIHRoYXQs
IHRoZSB0dW5uZWxlZF9vZmZsb2FkX2VuIGJpdCBzaG91bGQgYmUgc2V0L3Vuc2V0IChhY2NvcmRp
bmcgdG8NCnRoZSBIVyBjYXBhYmlsaXR5KSBmb3IgYWxsIFRJUnMnLCBub3Qgb25seSB0aGUgb25l
cyBkZWRpY2F0ZWQgZm9yDQp0dW5uZWxlZCAoaW5uZXIpIHRyYWZmaWMuDQoNCkZpeGVzOiAxYjIy
M2RkMzkxNjIgKCJuZXQvbWx4NWU6IEZpeCBjaGVja3N1bSBoYW5kbGluZyBmb3Igbm9uLXN0cmlw
cGVkIHZsYW4gcGFja2V0cyIpDQpTaWduZWQtb2ZmLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBt
ZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxh
bm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bi5oICAgICAgICAgIHwgMSArDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX21haW4uYyAgICAgfCA1ICsrKystDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX3JlcC5jICAgICAgfCAxICsNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvaXBvaWIvaXBvaWIuYyB8IDEgKw0KIDQgZmlsZXMgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbi5oDQppbmRleCA3ZTBjM2Q0ZGUxMDguLjNhMTgzZDY5MGUy
MyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bi5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaA0K
QEAgLTI0MCw2ICsyNDAsNyBAQCBzdHJ1Y3QgbWx4NWVfcGFyYW1zIHsNCiAJYm9vbCByeF9jcWVf
Y29tcHJlc3NfZGVmOw0KIAlzdHJ1Y3QgbmV0X2RpbV9jcV9tb2RlciByeF9jcV9tb2RlcmF0aW9u
Ow0KIAlzdHJ1Y3QgbmV0X2RpbV9jcV9tb2RlciB0eF9jcV9tb2RlcmF0aW9uOw0KKwlib29sIHR1
bm5lbGVkX29mZmxvYWRfZW47DQogCWJvb2wgbHJvX2VuOw0KIAl1OCAgdHhfbWluX2lubGluZV9t
b2RlOw0KIAlib29sIHZsYW5fc3RyaXBfZGlzYWJsZTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KaW5kZXggZDcxM2FiMmU3YTJkLi40
NTdjYzM5NDIzZjIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fbWFpbi5jDQpAQCAtMzEwMCw2ICszMTAwLDggQEAgc3RhdGljIHZvaWQgbWx4
NWVfYnVpbGRfaW5kaXJfdGlyX2N0eF9jb21tb24oc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQog
CU1MWDVfU0VUKHRpcmMsIHRpcmMsIHRyYW5zcG9ydF9kb21haW4sIHByaXYtPm1kZXYtPm1seDVl
X3Jlcy50ZC50ZG4pOw0KIAlNTFg1X1NFVCh0aXJjLCB0aXJjLCBkaXNwX3R5cGUsIE1MWDVfVElS
Q19ESVNQX1RZUEVfSU5ESVJFQ1QpOw0KIAlNTFg1X1NFVCh0aXJjLCB0aXJjLCBpbmRpcmVjdF90
YWJsZSwgcnF0bik7DQorCU1MWDVfU0VUKHRpcmMsIHRpcmMsIHR1bm5lbGVkX29mZmxvYWRfZW4s
DQorCQkgcHJpdi0+Y2hhbm5lbHMucGFyYW1zLnR1bm5lbGVkX29mZmxvYWRfZW4pOw0KIA0KIAlt
bHg1ZV9idWlsZF90aXJfY3R4X2xybygmcHJpdi0+Y2hhbm5lbHMucGFyYW1zLCB0aXJjKTsNCiB9
DQpAQCAtMzEyNiw3ICszMTI4LDYgQEAgc3RhdGljIHZvaWQgbWx4NWVfYnVpbGRfaW5uZXJfaW5k
aXJfdGlyX2N0eChzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCiAJbWx4NWVfYnVpbGRfaW5kaXJf
dGlyX2N0eF9jb21tb24ocHJpdiwgcHJpdi0+aW5kaXJfcnF0LnJxdG4sIHRpcmMpOw0KIAltbHg1
ZV9idWlsZF9pbmRpcl90aXJfY3R4X2hhc2goJnByaXYtPnJzc19wYXJhbXMsDQogCQkJCSAgICAg
ICAmdGlyY19kZWZhdWx0X2NvbmZpZ1t0dF0sIHRpcmMsIHRydWUpOw0KLQlNTFg1X1NFVCh0aXJj
LCB0aXJjLCB0dW5uZWxlZF9vZmZsb2FkX2VuLCAweDEpOw0KIH0NCiANCiBpbnQgbWx4NWVfY3Jl
YXRlX2luZGlyZWN0X3RpcnMoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIGJvb2wgaW5uZXJfdHRj
KQ0KQEAgLTQ1NzIsNiArNDU3Myw4IEBAIHZvaWQgbWx4NWVfYnVpbGRfbmljX3BhcmFtcyhzdHJ1
Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwNCiANCiAJLyogUlNTICovDQogCW1seDVlX2J1aWxkX3Jz
c19wYXJhbXMocnNzX3BhcmFtcywgcGFyYW1zLT5udW1fY2hhbm5lbHMpOw0KKwlwYXJhbXMtPnR1
bm5lbGVkX29mZmxvYWRfZW4gPQ0KKwkJbWx4NWVfdHVubmVsX2lubmVyX2Z0X3N1cHBvcnRlZCht
ZGV2KTsNCiB9DQogDQogc3RhdGljIHZvaWQgbWx4NWVfc2V0X25ldGRldl9kZXZfYWRkcihzdHJ1
Y3QgbmV0X2RldmljZSAqbmV0ZGV2KQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9yZXAuYw0KaW5kZXggMmViY2E5YmQ1Y2Y4Li45MWUyNGYxY2VhZDgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
cmVwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9y
ZXAuYw0KQEAgLTEzNzUsNiArMTM3NSw3IEBAIHN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX3JlcF9w
YXJhbXMoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCiAJbWx4NWVfc2V0X3J4X2NxX21vZGVf
cGFyYW1zKHBhcmFtcywgY3FfcGVyaW9kX21vZGUpOw0KIA0KIAlwYXJhbXMtPm51bV90YyAgICAg
ICAgICAgICAgICA9IDE7DQorCXBhcmFtcy0+dHVubmVsZWRfb2ZmbG9hZF9lbiA9IGZhbHNlOw0K
IA0KIAltbHg1X3F1ZXJ5X21pbl9pbmxpbmUobWRldiwgJnBhcmFtcy0+dHhfbWluX2lubGluZV9t
b2RlKTsNCiANCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvaXBvaWIvaXBvaWIuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9pcG9pYi9pcG9pYi5jDQppbmRleCA5YjAzYWUxZTFlMTAuLmFkYTFiN2MwZTBiOCAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9pcG9pYi9p
cG9pYi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaXBv
aWIvaXBvaWIuYw0KQEAgLTY4LDYgKzY4LDcgQEAgc3RhdGljIHZvaWQgbWx4NWlfYnVpbGRfbmlj
X3BhcmFtcyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwNCiANCiAJcGFyYW1zLT5scm9fZW4g
PSBmYWxzZTsNCiAJcGFyYW1zLT5oYXJkX210dSA9IE1MWDVfSUJfR1JIX0JZVEVTICsgTUxYNV9J
UE9JQl9IQVJEX0xFTjsNCisJcGFyYW1zLT50dW5uZWxlZF9vZmZsb2FkX2VuID0gZmFsc2U7DQog
fQ0KIA0KIC8qIENhbGxlZCBkaXJlY3RseSBhZnRlciBJUG9JQiBuZXRkZXZpY2Ugd2FzIGNyZWF0
ZWQgdG8gaW5pdGlhbGl6ZSBTVyBzdHJ1Y3RzICovDQotLSANCjIuMjAuMQ0KDQo=
