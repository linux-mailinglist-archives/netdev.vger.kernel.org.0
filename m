Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23FE2E88D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfE2Wun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:50:43 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40056
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfE2Wum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 18:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEFIwB6EcyOtkrG7YkcOm4nLnW3DJpS9GG0cx8r0KRw=;
 b=dW6RuOKiDMHHfEXvD9AYMYXeyN3VWZiN4o4//01wUIftgLaZeAGPAJgSmIOmiJCvj6YkUnaiPMrcPh2tBrPLGa6Q7HcAYKqyKovHbk8F2h4+C9ceJTsHNbTpMUKOxinXM+MO/3UZr3VjA0sIgjV/Rzhgv5KTYj413UL05F20gqU=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB4351.eurprd05.prod.outlook.com (52.133.12.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 22:50:37 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 22:50:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 4/6] net/mlx5: E-Switch, Honor eswitch functions
 changed event cap
Thread-Topic: [PATCH mlx5-next 4/6] net/mlx5: E-Switch, Honor eswitch
 functions changed event cap
Thread-Index: AQHVFnDuNmEn/6aTyUGVTyPlGdHQvg==
Date:   Wed, 29 May 2019 22:50:37 +0000
Message-ID: <20190529224949.18194-5-saeedm@mellanox.com>
References: <20190529224949.18194-1-saeedm@mellanox.com>
In-Reply-To: <20190529224949.18194-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0653c1e4-9cb8-4804-41a6-08d6e488109b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4351;
x-ms-traffictypediagnostic: VI1PR05MB4351:
x-microsoft-antispam-prvs: <VI1PR05MB43515ED56A2109C726F1FF7FBE1F0@VI1PR05MB4351.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(66446008)(73956011)(66946007)(64756008)(186003)(305945005)(76176011)(68736007)(66476007)(52116002)(107886003)(86362001)(1076003)(50226002)(4326008)(450100002)(66556008)(85306007)(6636002)(99286004)(54906003)(53936002)(102836004)(478600001)(6506007)(36756003)(8936002)(6512007)(8676002)(81156014)(110136005)(476003)(3846002)(6486002)(2616005)(256004)(26005)(5660300002)(6436002)(446003)(486006)(25786009)(2906002)(71200400001)(71190400001)(386003)(316002)(14444005)(6116002)(66066001)(11346002)(14454004)(7736002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4351;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ujkIVnTEyyMD1CKmCbealLix6v1WuyeiVj9c2pG2Oyc5IwdZ7FOrJUUPBSnSyAnWcRVbxl9ZdLfU+0sGs/gDV4TsppSSmWTVsWmCa9CSO/KaJ+hV2s0zNSXDKnx3cTjxMOCVfeY3mApQOZNg1rdHZpg2gE7uFEQdmgX4tN09Yytmg7EsakVRLNBI90nYsujEDjvvTe98aJrkbrD3iKbS7W9fiUSdrZ3iNh68+3c2h3h3+GsvkbE8xWfiW3iA1MyWVQjQpf/1H3++qqvMc1S13jDAUoPjIzceWZKNo9JQni4eEe1+G9/VB+et64dBuETsXbPkzOE0OoGwa19cGsGrNTS56dTg+zIPeEhgRDhlBWQF2rqRFrncTI9lGZ66iIno/4Rp7n6wKYtYV/1hyy2TdSpiTD1+21Vue/YQhO7GeaE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0653c1e4-9cb8-4804-41a6-08d6e488109b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 22:50:37.0895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVnUgUGhhbSA8dnVodW9uZ0BtZWxsYW5veC5jb20+DQoNCldoZW5ldmVyIGRldmljZSBz
dXBwb3J0cyBlc3dpdGNoIGZ1bmN0aW9ucyBjaGFuZ2VkIGV2ZW50LCBob25vcg0Kc3VjaCBkZXZp
Y2Ugc2V0dGluZy4gRG8gbm90IGxpbWl0IGl0IHRvIEVDUEYuDQoNClNpZ25lZC1vZmYtYnk6IFBh
cmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogVnUgUGhhbSA8
dnVodW9uZ0BtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lcS5jICAgICAgICB8ICAyICstDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCAgIHwgMTMgKysrKysrKysrKysrKw0KIC4uLi9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jICB8ICA2ICsrKy0tLQ0KIGlu
Y2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAgICAgICAgICAgICAgICB8ICA0ICsr
Ky0NCiA0IGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEu
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jDQppbmRleCAw
NTJiZDcwZTRhYTYuLjVlOTMxOWQzZDkwYyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZXEuYw0KQEAgLTUzMyw3ICs1MzMsNyBAQCBzdGF0aWMgdTY0IGdh
dGhlcl9hc3luY19ldmVudHNfbWFzayhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAlpZiAo
TUxYNV9DQVBfR0VOKGRldiwgbWF4X251bV9vZl9tb25pdG9yX2NvdW50ZXJzKSkNCiAJCWFzeW5j
X2V2ZW50X21hc2sgfD0gKDF1bGwgPDwgTUxYNV9FVkVOVF9UWVBFX01PTklUT1JfQ09VTlRFUik7
DQogDQotCWlmIChtbHg1X2NvcmVfaXNfZWNwZl9lc3dfbWFuYWdlcihkZXYpKQ0KKwlpZiAobWx4
NV9lc3dpdGNoX2lzX2Z1bmNzX2hhbmRsZXIoZGV2KSkNCiAJCWFzeW5jX2V2ZW50X21hc2sgfD0N
CiAJCQkoMXVsbCA8PCBNTFg1X0VWRU5UX1RZUEVfRVNXX0ZVTkNUSU9OU19DSEFOR0VEKTsNCiAN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3
aXRjaC5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2gu
aA0KaW5kZXggMzIwZGQ4M2RkMzAxLi5iNTI0ODEzY2NjYWMgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQpAQCAtNDA2LDYgKzQw
NiwxOCBAQCBzdGF0aWMgaW5saW5lIHUxNiBtbHg1X2Vzd2l0Y2hfbWFuYWdlcl92cG9ydChzdHJ1
Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAkJTUxYNV9WUE9SVF9FQ1BGIDogTUxYNV9WUE9SVF9Q
RjsNCiB9DQogDQorc3RhdGljIGlubGluZSBib29sIG1seDVfZXN3aXRjaF9pc19mdW5jc19oYW5k
bGVyKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQorew0KKwkvKiBJZGVhbGx5IGRldmljZSBz
aG91bGQgaGF2ZSB0aGUgZnVuY3Rpb25zIGNoYW5nZWQgc3VwcG9ydGVkDQorCSAqIGNhcGFiaWxp
dHkgcmVnYXJkbGVzcyBvZiBpdCBiZWluZyBFQ1BGIG9yIFBGIHdoZXJldmVyIHN1Y2gNCisJICog
ZXZlbnQgc2hvdWxkIGJlIHByb2Nlc3NlZCBzdWNoIGFzIG9uIGVzd2l0Y2ggbWFuYWdlciBkZXZp
Y2UuDQorCSAqIEhvd2V2ZXIsIHNvbWUgRUNQRiBiYXNlZCBkZXZpY2UgbWlnaHQgbm90IGhhdmUg
dGhpcyBjYXBhYmlsaXR5DQorCSAqIHNldC4gSGVuY2UgT1IgZm9yIEVDUEYgY2hlY2sgdG8gY292
ZXIgc3VjaCBkZXZpY2UuDQorCSAqLw0KKwlyZXR1cm4gTUxYNV9DQVBfRVNXKGRldiwgZXN3X2Z1
bmN0aW9uc19jaGFuZ2VkKSB8fA0KKwkgICAgICAgbWx4NV9jb3JlX2lzX2VjcGZfZXN3X21hbmFn
ZXIoZGV2KTsNCit9DQorDQogc3RhdGljIGlubGluZSBpbnQgbWx4NV9lc3dpdGNoX3VwbGlua19p
ZHgoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIHsNCiAJLyogVXBsaW5rIGFsd2F5cyBsb2Nh
dGUgYXQgdGhlIGxhc3QgZWxlbWVudCBvZiB0aGUgYXJyYXkuKi8NCkBAIC01MDAsNiArNTEyLDcg
QEAgc3RhdGljIGlubGluZSB2b2lkIG1seDVfZXN3aXRjaF9jbGVhbnVwKHN0cnVjdCBtbHg1X2Vz
d2l0Y2ggKmVzdykge30NCiBzdGF0aWMgaW5saW5lIGludCAgbWx4NV9lc3dpdGNoX2VuYWJsZV9z
cmlvdihzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGludCBudmZzLCBpbnQgbW9kZSkgeyByZXR1
cm4gMDsgfQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBtbHg1X2Vzd2l0Y2hfZGlzYWJsZV9zcmlvdihz
dHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cpIHt9DQogc3RhdGljIGlubGluZSBib29sIG1seDVfZXN3
X2xhZ19wcmVyZXEoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldjAsIHN0cnVjdCBtbHg1X2NvcmVf
ZGV2ICpkZXYxKSB7IHJldHVybiB0cnVlOyB9DQorc3RhdGljIGlubGluZSBib29sIG1seDVfZXN3
aXRjaF9pc19mdW5jc19oYW5kbGVyKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpIHsgcmV0dXJu
IGZhbHNlOyB9DQogDQogI2RlZmluZSBGREJfTUFYX0NIQUlOIDENCiAjZGVmaW5lIEZEQl9TTE9X
X1BBVEhfQ0hBSU4gKEZEQl9NQVhfQ0hBSU4gKyAxKQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQppbmRl
eCA4MzY4OTY3OGI0MDAuLjA1Y2IyZmZmZDg4NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCisrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCkBA
IC0xODM2LDcgKzE4MzYsNyBAQCBzdGF0aWMgaW50IGVzd19mdW5jdGlvbnNfY2hhbmdlZF9ldmVu
dChzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLA0KIHN0YXRpYyB2b2lkIGVzd19mdW5jdGlvbnNf
Y2hhbmdlZF9ldmVudF9pbml0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywNCiAJCQkJCSAgICAg
dTE2IHZmX252cG9ydHMpDQogew0KLQlpZiAoIW1seDVfY29yZV9pc19lY3BmX2Vzd19tYW5hZ2Vy
KGVzdy0+ZGV2KSkNCisJaWYgKCFtbHg1X2Vzd2l0Y2hfaXNfZnVuY3NfaGFuZGxlcihlc3ctPmRl
dikpDQogCQlyZXR1cm47DQogDQogCU1MWDVfTkJfSU5JVCgmZXN3LT5lc3dfZnVuY3MubmIsIGVz
d19mdW5jdGlvbnNfY2hhbmdlZF9ldmVudCwNCkBAIC0xODQ3LDcgKzE4NDcsNyBAQCBzdGF0aWMg
dm9pZCBlc3dfZnVuY3Rpb25zX2NoYW5nZWRfZXZlbnRfaW5pdChzdHJ1Y3QgbWx4NV9lc3dpdGNo
ICplc3csDQogDQogc3RhdGljIHZvaWQgZXN3X2Z1bmN0aW9uc19jaGFuZ2VkX2V2ZW50X2NsZWFu
dXAoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIHsNCi0JaWYgKCFtbHg1X2NvcmVfaXNfZWNw
Zl9lc3dfbWFuYWdlcihlc3ctPmRldikpDQorCWlmICghbWx4NV9lc3dpdGNoX2lzX2Z1bmNzX2hh
bmRsZXIoZXN3LT5kZXYpKQ0KIAkJcmV0dXJuOw0KIA0KIAltbHg1X2VxX25vdGlmaWVyX3VucmVn
aXN0ZXIoZXN3LT5kZXYsICZlc3ctPmVzd19mdW5jcy5uYik7DQpAQCAtMTkwNSw3ICsxOTA1LDcg
QEAgdm9pZCBlc3dfb2ZmbG9hZHNfY2xlYW51cChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cpDQog
DQogCWVzd19mdW5jdGlvbnNfY2hhbmdlZF9ldmVudF9jbGVhbnVwKGVzdyk7DQogDQotCWlmICht
bHg1X2NvcmVfaXNfZWNwZl9lc3dfbWFuYWdlcihlc3ctPmRldikpDQorCWlmIChtbHg1X2Vzd2l0
Y2hfaXNfZnVuY3NfaGFuZGxlcihlc3ctPmRldikpDQogCQludW1fdmZzID0gZXN3LT5lc3dfZnVu
Y3MubnVtX3ZmczsNCiAJZWxzZQ0KIAkJbnVtX3ZmcyA9IGVzdy0+ZGV2LT5wcml2LnNyaW92Lm51
bV92ZnM7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmggYi9pbmNs
dWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KaW5kZXggMDc4MDI0MmE3NTdhLi42NTEzYjk4NWM1
ZTkgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaA0KKysrIGIvaW5j
bHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCkBAIC02NjUsNyArNjY1LDkgQEAgc3RydWN0IG1s
eDVfaWZjX2Vfc3dpdGNoX2NhcF9iaXRzIHsNCiAJdTggICAgICAgICB2cG9ydF9zdmxhbl9pbnNl
cnRbMHgxXTsNCiAJdTggICAgICAgICB2cG9ydF9jdmxhbl9pbnNlcnRfaWZfbm90X2V4aXN0WzB4
MV07DQogCXU4ICAgICAgICAgdnBvcnRfY3ZsYW5faW5zZXJ0X292ZXJ3cml0ZVsweDFdOw0KLQl1
OCAgICAgICAgIHJlc2VydmVkX2F0XzVbMHgxNl07DQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRf
NVsweDE0XTsNCisJdTggICAgICAgICBlc3dfZnVuY3Rpb25zX2NoYW5nZWRbMHgxXTsNCisJdTgg
ICAgICAgICByZXNlcnZlZF9hdF8xYVsweDFdOw0KIAl1OCAgICAgICAgIGVjcGZfdnBvcnRfZXhp
c3RzWzB4MV07DQogCXU4ICAgICAgICAgY291bnRlcl9lc3dpdGNoX2FmZmluaXR5WzB4MV07DQog
CXU4ICAgICAgICAgbWVyZ2VkX2Vzd2l0Y2hbMHgxXTsNCi0tIA0KMi4yMS4wDQoNCg==
