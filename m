Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA29010101
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfD3Uj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:39:56 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:9176
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726723AbfD3Ujz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GfKqyb80qXb+DvV7OTF1Btx+Jk3weBQqUTmIyax4dY=;
 b=KHa04/n/zSmmkpkuA/SkoFWxqJjX5oOe8pDpUY82FAUexumWHCOFnNnx5IVk7KpCVJ/E0E0sgZR/BBKSZaaDvifcJObrsUbFjRp6KhI/J9Sh2binj05d8tpzVQW88OvSwRul8KmnbaVSpIPAfdm3R9LRkHkBLo1CsRjkWGKYUmU=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:39:48 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:39:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/15] net/mlx5e: Turn on HW tunnel offload in all TIRs
Thread-Topic: [net-next 02/15] net/mlx5e: Turn on HW tunnel offload in all
 TIRs
Thread-Index: AQHU/5Ta9Wgz5iT3jEaoswDPYVGKFA==
Date:   Tue, 30 Apr 2019 20:39:48 +0000
Message-ID: <20190430203926.19284-3-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7847533-cb08-48a3-b3f1-08d6cdabfcbb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB65422C2452449095DED93D30BE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(14444005)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kEgElR7WkMq1NhOJ+FNITYRVsmTIqdv30p+cNvq2+dt0uqKB/Yt+JVweTu8HYKDXAzg/UWIpRFYHB5oj6okslNXgui3/RYfOsIYJ7X+6TbSCdsjlrYnwWk4bZ5hHLXm+FeUHOhWopUsgYaWC3JaL/FNFoSVncxMRM3hQvm3UZXGuQ6BjSeffp17/r0FVIgqk2UzkAZnqfWlVu3LAjPfEWnInXuF0v3J8UvsytkB6/9061rN2K6pMuRMwkF8TQPxcldTMchjPkMbEmC8ihT+4PZThL0KDoljB8e15bJu15Kv8rEQtf07+/uW4IpvS8cwydqO4z1ptlbKzIbZ9GdGdeCNtsKcdkpGSaAEIrSOEqIW35bkzF8aeYow8y17jImvEpM5Em0cg4Zl+RBWbmreGaW1QR4yQanuWt+hHP4BWn5w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7847533-cb08-48a3-b3f1-08d6cdabfcbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:39:48.5887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
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
