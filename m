Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B304148E5C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfFQTXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:51 -0400
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:28142
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728920AbfFQTXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgZKc7/BjEz2drpfZCbmmG1UWuf3r9kc07oRMRLJgXc=;
 b=hUsoaH/20z5vaj3z+27fh9T3IHrNk2vjFWv8rNkoNW4HM6VtgjYCgR40jI7kKFE2uVU4lCNmbyJ9WQKw7wgk65NrAMJWfZ2vgkXPhylAOL7ROQo3ucISgej6YDDvgP2ES2iIgGTWCWQkxULkR7qAwvAby2wHZQHiEmEIA6bTwso=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:37 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of rep
 for vport to IB port mapping
Thread-Topic: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Index: AQHVJUIpGI7fvdRK1U+ZsqwPxYsEnA==
Date:   Mon, 17 Jun 2019 19:23:37 +0000
Message-ID: <20190617192247.25107-15-saeedm@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29b85980-36ff-45a6-e1b3-08d6f3594b9f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB278976057FFE518151379AAEBEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(14444005)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K007fGJeHl/bcdluRvIU5NSdYegoxC/p3pQB+dM9SWW6N05cOOsUeGlPbBs1zzjRzBKWU65YJ6xDgkXpOuRPjRKOp/XSbRRmqyXkwqa33vozTj9FdD9jdJqo7zGThBPdoP1mVsweKTakHn+BilOXn2lykwjawpFK8xl7eygWOhzVDD3/Z8Mhmnlqga1retYIBoPPc4Nfprk6mzsEaj/t9xW7RFEpO384BMoanuj/GjHyhcYIiycPYpsTGL03HW55Vf86qC2LS1s2SR+b3OD5HRj8pQHSRpG0AD4gcML7nDDt+evWOlRzbYFxsQfEolsyImjJzeoImlyZBsGgWPQxhKckfMVrsPcTbPWJa4r8UfvUVaGRbVmyB0WN1MLO+tTkOLzoSFq1g5HxpVbgEEQjfrw1RPgpTAHBDX5QE+rRLHc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b85980-36ff-45a6-e1b3-08d6f3594b9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:37.0275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCkluIHRoZSBzaW5nbGUg
SUIgZGV2aWNlIG1vZGUsIHRoZSBtYXBwaW5nIGJldHdlZW4gdnBvcnQgbnVtYmVyIGFuZA0KcmVw
IHJlbGllcyBvbiBhIGNvdW50ZXIuIEhvd2V2ZXIgZm9yIGR5bmFtaWMgdnBvcnQgYWxsb2NhdGlv
biwgaXQgaXMNCmRlc2lyZWQgdG8ga2VlcCBjb25zaXN0ZW50IG1hcCBvZiBlc3dpdGNoIHZwb3J0
IGFuZCBJQiBwb3J0Lg0KDQpIZW5jZSwgc2ltcGxpZnkgY29kZSB0byByZW1vdmUgdGhlIGZyZWUg
cnVubmluZyBjb3VudGVyIGFuZCBpbnN0ZWFkDQp1c2UgdGhlIGF2YWlsYWJsZSB2cG9ydCBpbmRl
eCBkdXJpbmcgbG9hZC91bmxvYWQgc2VxdWVuY2UgZnJvbSB0aGUNCmVzd2l0Y2guDQoNClNpZ25l
ZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxib2RvbmdAbWVsbGFub3guY29tPg0KU3VnZ2VzdGVkLWJ5
OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJhdiBQ
YW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJr
YkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jICAg
ICAgICAgICAgICAgICAgICAgICAgfCA0ICsrLS0NCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4
NS9tbHg1X2liLmggICAgICAgICAgICAgICAgICAgICAgIHwgMSAtDQogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyB8IDEgKw0KIGluY2x1
ZGUvbGludXgvbWx4NS9lc3dpdGNoLmggICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAy
ICsrDQogNCBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYyBiL2RyaXZl
cnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5jDQppbmRleCBkNGVkNjExZGUzNWQuLmRhNGI5
MzZiMzIxOSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5j
DQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0KQEAgLTE0LDcgKzE0
LDcgQEAgbWx4NV9pYl9zZXRfdnBvcnRfcmVwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHN0
cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICpyZXApDQogCWludCB2cG9ydF9pbmRleDsNCiANCiAJaWJk
ZXYgPSBtbHg1X2liX2dldF91cGxpbmtfaWJkZXYoZGV2LT5wcml2LmVzd2l0Y2gpOw0KLQl2cG9y
dF9pbmRleCA9IGliZGV2LT5mcmVlX3BvcnQrKzsNCisJdnBvcnRfaW5kZXggPSByZXAtPnZwb3J0
X2luZGV4Ow0KIA0KIAlpYmRldi0+cG9ydFt2cG9ydF9pbmRleF0ucmVwID0gcmVwOw0KIAl3cml0
ZV9sb2NrKCZpYmRldi0+cG9ydFt2cG9ydF9pbmRleF0ucm9jZS5uZXRkZXZfbG9jayk7DQpAQCAt
NTAsNyArNTAsNyBAQCBtbHg1X2liX3Zwb3J0X3JlcF9sb2FkKHN0cnVjdCBtbHg1X2NvcmVfZGV2
ICpkZXYsIHN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICpyZXApDQogCX0NCiANCiAJaWJkZXYtPmlz
X3JlcCA9IHRydWU7DQotCXZwb3J0X2luZGV4ID0gaWJkZXYtPmZyZWVfcG9ydCsrOw0KKwl2cG9y
dF9pbmRleCA9IHJlcC0+dnBvcnRfaW5kZXg7DQogCWliZGV2LT5wb3J0W3Zwb3J0X2luZGV4XS5y
ZXAgPSByZXA7DQogCWliZGV2LT5wb3J0W3Zwb3J0X2luZGV4XS5yb2NlLm5ldGRldiA9DQogCQlt
bHg1X2liX2dldF9yZXBfbmV0ZGV2KGRldi0+cHJpdi5lc3dpdGNoLCByZXAtPnZwb3J0KTsNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmggYi9kcml2ZXJz
L2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmgNCmluZGV4IDFjMjA1YzJiZDQ4Ni4uZWU3M2Rj
MTIyZDI4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9pYi5o
DQorKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tbHg1X2liLmgNCkBAIC05NzgsNyAr
OTc4LDYgQEAgc3RydWN0IG1seDVfaWJfZGV2IHsNCiAJdTE2CQkJZGV2eF93aGl0ZWxpc3RfdWlk
Ow0KIAlzdHJ1Y3QgbWx4NV9zcnFfdGFibGUgICBzcnFfdGFibGU7DQogCXN0cnVjdCBtbHg1X2Fz
eW5jX2N0eCAgIGFzeW5jX2N0eDsNCi0JaW50CQkJZnJlZV9wb3J0Ow0KIH07DQogDQogc3RhdGlj
IGlubGluZSBzdHJ1Y3QgbWx4NV9pYl9jcSAqdG9fbWliY3Eoc3RydWN0IG1seDVfY29yZV9jcSAq
bWNxKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lc3dpdGNoX29mZmxvYWRzLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQppbmRleCBmMjliOWUxZjQ5YWUuLjdmZGVhNTYwMDM4
MyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
c3dpdGNoX29mZmxvYWRzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCkBAIC0xNDExLDYgKzE0MTEsNyBAQCBpbnQgZXN3
X29mZmxvYWRzX2luaXRfcmVwcyhzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cpDQogDQogCW1seDVf
ZXN3X2Zvcl9hbGxfcmVwcyhlc3csIHZwb3J0X2luZGV4LCByZXApIHsNCiAJCXJlcC0+dnBvcnQg
PSBtbHg1X2Vzd2l0Y2hfaW5kZXhfdG9fdnBvcnRfbnVtKGVzdywgdnBvcnRfaW5kZXgpOw0KKwkJ
cmVwLT52cG9ydF9pbmRleCA9IHZwb3J0X2luZGV4Ow0KIAkJZXRoZXJfYWRkcl9jb3B5KHJlcC0+
aHdfaWQsIGh3X2lkKTsNCiANCiAJCWZvciAocmVwX3R5cGUgPSAwOyByZXBfdHlwZSA8IE5VTV9S
RVBfVFlQRVM7IHJlcF90eXBlKyspDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2Vz
d2l0Y2guaCBiL2luY2x1ZGUvbGludXgvbWx4NS9lc3dpdGNoLmgNCmluZGV4IGQ3MjlmNWU0ZDcw
YS4uZDI5YWJlZmEwM2M2IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2gu
aA0KKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2guaA0KQEAgLTQ2LDYgKzQ2LDggQEAg
c3RydWN0IG1seDVfZXN3aXRjaF9yZXAgew0KIAl1MTYJCSAgICAgICB2cG9ydDsNCiAJdTgJCSAg
ICAgICBod19pZFtFVEhfQUxFTl07DQogCXUxNgkJICAgICAgIHZsYW47DQorCS8qIE9ubHkgSUIg
cmVwIGlzIHVzaW5nIHZwb3J0X2luZGV4ICovDQorCXUxNgkJICAgICAgIHZwb3J0X2luZGV4Ow0K
IAl1MzIJCSAgICAgICB2bGFuX3JlZmNvdW50Ow0KIH07DQogDQotLSANCjIuMjEuMA0KDQo=
