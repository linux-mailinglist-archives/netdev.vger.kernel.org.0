Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F461010C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfD3UkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:40:24 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:37375
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727245AbfD3UkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:40:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eKhtQhG73/bs7XS8YsiL44ljF/kqN58Aq36Id4RllI=;
 b=hAxNlB6ojBTu+o38zeEbJDWwQaQDwvFygqRa7iHnP+xn+A05zDMHgdQlu1xm47WXb/+t8yd/r1z05Tl2iXoGNBo+yl7f7+qM7FlCD8e1jQpCczr87Nq/JVswwSsipC3mrdPUOpM8xI0/nhz+oR7sLqSFFttjZx8Za5JCXf4GAtY=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:40:10 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:40:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5: E-Switch, Use getter to access all vport
 array
Thread-Topic: [net-next 13/15] net/mlx5: E-Switch, Use getter to access all
 vport array
Thread-Index: AQHU/5TnWxff6GYL6kK1+xeEzWb1Mw==
Date:   Tue, 30 Apr 2019 20:40:09 +0000
Message-ID: <20190430203926.19284-14-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1d01be1c-19d4-475d-5dc0-08d6cdac0966
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB65423E39251DC902173BB6B0BE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(14444005)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r8vI20j9GvZRgmPEv8aTMCvwnQxHBHsTror0zww3MCIspfX7fanR3yXJ6mxYRCdbqV8jYSihzWkqeZyGcEJMpqy/S9uq0SWUNulCV7M212I0BTMONiL5a+xZWhaDyGwFR9HhqdRRrLqF+/u8lDQnr5tkdtcvk70FOJTiIPZZir+f7uFPt20f7hZ2H1/I/RepAwNsdQ9NfZHwgDIpLfb1bwx+w8ZWtKUXZJ4WIMiAtoEi6LzpPI4rpw85vURMfyVwB1BOUcvI8BEAADtDUhJUycFDdftYeY+ZlDrtUNXUNPGKfGUYPg0mSQ7uAEWetndRwdvkGKBtXsN8nJCNqm1NxjtNhR48Vwhohz6BVgxMwo5xZ1G8pxR3voQQiZnW0EDY9IcrBwSZuj9BkNklIg+ee6eBGDOLXSf2Fwq+SiQcy7M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d01be1c-19d4-475d-5dc0-08d6cdac0966
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:40:09.9069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNClNvbWUgZnVuY3Rpb25z
IGlzc3VlIHZwb3J0IGNvbW1hbmRzIGFuZCBhY2Nlc3MgdnBvcnQgYXJyYXkgdXNpbmcNCnZwb3J0
X2luZGV4L3Zwb3J0X251bSBpbnRlcmNoYW5nZWFibHkgd2hpY2ggaXMgT0sgZm9yIFZGcyB2cG9y
dHMuDQpIb3dldmVyLCB0aGlzIGNyZWF0ZXMgcG90ZW50aWFsIGJ1ZyBpZiB0aG9zZSB2cG9ydHMg
YXJlIG5vdCBWRnMNCihFLmcsIHVwbGluaywgc2YpIHdoZXJlIHRoZWlyIHZwb3J0X2luZGV4IGRv
bid0IGVxdWFsIHRvIHZwb3J0X251bS4NCg0KUHJlcGFyZSBjb2RlIHRvIGFjY2VzcyBtbHg1X3Zw
b3J0IHN0cnVjdHVyZSB1c2luZyBhIGdldHRlciBmdW5jdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTog
Qm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBWdSBQaGFt
IDx2dWh1b25nQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2
QG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3
aXRjaC5jICB8IDE4ICsrKysrKysrKy0tLS0tLS0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCAgfCAgMiArKw0KIDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5z
ZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQppbmRleCA0MWFmYzdiZjhiZDguLjAxMDdj
ZThiZjY1OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lc3dpdGNoLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lc3dpdGNoLmMNCkBAIC03Miw4ICs3Miw4IEBAIHN0YXRpYyB2b2lkIGVzd19jbGVhbnVw
X3ZlcGFfcnVsZXMoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KTsNCiAJCQkgICAgTUNfQUREUl9D
SEFOR0UgfCBcDQogCQkJICAgIFBST01JU0NfQ0hBTkdFKQ0KIA0KLXN0YXRpYyBzdHJ1Y3QgbWx4
NV92cG9ydCAqbWx4NV9lc3dpdGNoX2dldF92cG9ydChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cs
DQotCQkJCQkJIHUxNiB2cG9ydF9udW0pDQorc3RydWN0IG1seDVfdnBvcnQgKm1seDVfZXN3aXRj
aF9nZXRfdnBvcnQoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LA0KKwkJCQkJICB1MTYgdnBvcnRf
bnVtKQ0KIHsNCiAJdTE2IGlkeCA9IG1seDVfZXN3aXRjaF92cG9ydF9udW1fdG9faW5kZXgoZXN3
LCB2cG9ydF9udW0pOw0KIA0KQEAgLTE5MTYsNyArMTkxNiw3IEBAIGludCBtbHg1X2Vzd2l0Y2hf
c2V0X3Zwb3J0X21hYyhzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQogCQlyZXR1cm4gLUVJTlZB
TDsNCiANCiAJbXV0ZXhfbG9jaygmZXN3LT5zdGF0ZV9sb2NrKTsNCi0JZXZwb3J0ID0gJmVzdy0+
dnBvcnRzW3Zwb3J0XTsNCisJZXZwb3J0ID0gbWx4NV9lc3dpdGNoX2dldF92cG9ydChlc3csIHZw
b3J0KTsNCiANCiAJaWYgKGV2cG9ydC0+aW5mby5zcG9vZmNoayAmJiAhaXNfdmFsaWRfZXRoZXJf
YWRkcihtYWMpKQ0KIAkJbWx4NV9jb3JlX3dhcm4oZXN3LT5kZXYsDQpAQCAtMTk2MCw3ICsxOTYw
LDcgQEAgaW50IG1seDVfZXN3aXRjaF9zZXRfdnBvcnRfc3RhdGUoc3RydWN0IG1seDVfZXN3aXRj
aCAqZXN3LA0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQogCW11dGV4X2xvY2soJmVzdy0+c3RhdGVf
bG9jayk7DQotCWV2cG9ydCA9ICZlc3ctPnZwb3J0c1t2cG9ydF07DQorCWV2cG9ydCA9IG1seDVf
ZXN3aXRjaF9nZXRfdnBvcnQoZXN3LCB2cG9ydCk7DQogDQogCWVyciA9IG1seDVfbW9kaWZ5X3Zw
b3J0X2FkbWluX3N0YXRlKGVzdy0+ZGV2LA0KIAkJCQkJICAgIE1MWDVfVlBPUlRfU1RBVEVfT1Bf
TU9EX0VTV19WUE9SVCwNCkBAIC0xOTg5LDcgKzE5ODksNyBAQCBpbnQgbWx4NV9lc3dpdGNoX2dl
dF92cG9ydF9jb25maWcoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LA0KIAlpZiAoIUxFR0FMX1ZQ
T1JUKGVzdywgdnBvcnQpKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogDQotCWV2cG9ydCA9ICZlc3ct
PnZwb3J0c1t2cG9ydF07DQorCWV2cG9ydCA9IG1seDVfZXN3aXRjaF9nZXRfdnBvcnQoZXN3LCB2
cG9ydCk7DQogDQogCW1lbXNldChpdmksIDAsIHNpemVvZigqaXZpKSk7DQogCWl2aS0+dmYgPSB2
cG9ydCAtIDE7DQpAQCAtMjAyMCw3ICsyMDIwLDcgQEAgaW50IF9fbWx4NV9lc3dpdGNoX3NldF92
cG9ydF92bGFuKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywNCiAJCXJldHVybiAtRUlOVkFMOw0K
IA0KIAltdXRleF9sb2NrKCZlc3ctPnN0YXRlX2xvY2spOw0KLQlldnBvcnQgPSAmZXN3LT52cG9y
dHNbdnBvcnRdOw0KKwlldnBvcnQgPSBtbHg1X2Vzd2l0Y2hfZ2V0X3Zwb3J0KGVzdywgdnBvcnQp
Ow0KIA0KIAllcnIgPSBtb2RpZnlfZXN3X3Zwb3J0X2N2bGFuKGVzdy0+ZGV2LCB2cG9ydCwgdmxh
biwgcW9zLCBzZXRfZmxhZ3MpOw0KIAlpZiAoZXJyKQ0KQEAgLTIwNjQsNyArMjA2NCw3IEBAIGlu
dCBtbHg1X2Vzd2l0Y2hfc2V0X3Zwb3J0X3Nwb29mY2hrKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVz
dywNCiAJCXJldHVybiAtRUlOVkFMOw0KIA0KIAltdXRleF9sb2NrKCZlc3ctPnN0YXRlX2xvY2sp
Ow0KLQlldnBvcnQgPSAmZXN3LT52cG9ydHNbdnBvcnRdOw0KKwlldnBvcnQgPSBtbHg1X2Vzd2l0
Y2hfZ2V0X3Zwb3J0KGVzdywgdnBvcnQpOw0KIAlwc2NoayA9IGV2cG9ydC0+aW5mby5zcG9vZmNo
azsNCiAJZXZwb3J0LT5pbmZvLnNwb29mY2hrID0gc3Bvb2ZjaGs7DQogCWlmIChwc2NoayAmJiAh
aXNfdmFsaWRfZXRoZXJfYWRkcihldnBvcnQtPmluZm8ubWFjKSkNCkBAIC0yMjEzLDcgKzIyMTMs
NyBAQCBpbnQgbWx4NV9lc3dpdGNoX3NldF92cG9ydF90cnVzdChzdHJ1Y3QgbWx4NV9lc3dpdGNo
ICplc3csDQogCQlyZXR1cm4gLUVJTlZBTDsNCiANCiAJbXV0ZXhfbG9jaygmZXN3LT5zdGF0ZV9s
b2NrKTsNCi0JZXZwb3J0ID0gJmVzdy0+dnBvcnRzW3Zwb3J0XTsNCisJZXZwb3J0ID0gbWx4NV9l
c3dpdGNoX2dldF92cG9ydChlc3csIHZwb3J0KTsNCiAJZXZwb3J0LT5pbmZvLnRydXN0ZWQgPSBz
ZXR0aW5nOw0KIAlpZiAoZXZwb3J0LT5lbmFibGVkKQ0KIAkJZXN3X3Zwb3J0X2NoYW5nZV9oYW5k
bGVfbG9ja2VkKGV2cG9ydCk7DQpAQCAtMjI5OSw3ICsyMjk5LDcgQEAgaW50IG1seDVfZXN3aXRj
aF9zZXRfdnBvcnRfcmF0ZShzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGludCB2cG9ydCwNCiAJ
CXJldHVybiAtRU9QTk9UU1VQUDsNCiANCiAJbXV0ZXhfbG9jaygmZXN3LT5zdGF0ZV9sb2NrKTsN
Ci0JZXZwb3J0ID0gJmVzdy0+dnBvcnRzW3Zwb3J0XTsNCisJZXZwb3J0ID0gbWx4NV9lc3dpdGNo
X2dldF92cG9ydChlc3csIHZwb3J0KTsNCiANCiAJaWYgKG1pbl9yYXRlID09IGV2cG9ydC0+aW5m
by5taW5fcmF0ZSkNCiAJCWdvdG8gc2V0X21heF9yYXRlOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmggYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQppbmRleCBmYzUxMmE1ZDBjNGMu
LjJlNmIzN2Q0ZmM3ZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lc3dpdGNoLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lc3dpdGNoLmgNCkBAIC00ODgsNiArNDg4LDggQEAgdm9pZCBtbHg1ZV90Y19j
bGVhbl9mZGJfcGVlcl9mbG93cyhzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cpOw0KICNkZWZpbmUg
bWx4NV9lc3dfZm9yX2VhY2hfdmZfdnBvcnRfbnVtX3JldmVyc2UoZXN3LCB2cG9ydCwgbnZmcykJ
XA0KIAlmb3IgKCh2cG9ydCkgPSAobnZmcyk7ICh2cG9ydCkgPj0gTUxYNV9WUE9SVF9GSVJTVF9W
RjsgKHZwb3J0KS0tKQ0KIA0KK3N0cnVjdCBtbHg1X3Zwb3J0ICptbHg1X2Vzd2l0Y2hfZ2V0X3Zw
b3J0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywNCisJCQkJCSAgdTE2IHZwb3J0X251bSk7DQog
I2Vsc2UgIC8qIENPTkZJR19NTFg1X0VTV0lUQ0ggKi8NCiAvKiBlc3dpdGNoIEFQSSBzdHVicyAq
Lw0KIHN0YXRpYyBpbmxpbmUgaW50ICBtbHg1X2Vzd2l0Y2hfaW5pdChzdHJ1Y3QgbWx4NV9jb3Jl
X2RldiAqZGV2KSB7IHJldHVybiAwOyB9DQotLSANCjIuMjAuMQ0KDQo=
