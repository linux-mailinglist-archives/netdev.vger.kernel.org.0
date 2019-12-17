Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C07A123230
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfLQQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:52 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:52522
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728992AbfLQQUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:20:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVT181hVC4wEFV5pPpYm7O76Qpj3HnEIJQ6wFXN/6ovOysNKgwLkOQrsnGHn03TGyUT/IyQwiLoapOEDc0lII0d/pqDCWLRFmfrOECM05DC3Pi2NtWDrzu8jRevCVnW4t/Zx13dTprnKiZOQ5R3+0MI+5TSr13c1XrZoo22eci6w/fRlRzOSy2r2etog+XqyfIUuhOw0IXe6YC2hOQNxdcx0eY8oZzIk1cJn6VB+BnZBdsWtK5Zf6alJI613yPcdkvUTSEAdMG8wsD3Cb087kkxXvZGrDOw1uVaZxbQAt+zxppW5ZjGH2ERo9ZrOsAt9DafOR0oLUS56/+M1c29YMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KlWAfKbih8P3/+2oUMH/tWItKTWaFXue9vNnQ7rL/w=;
 b=OB3FRsstsnMs7/3JOD/HW9NqNYLG7i6KgruvNlJhalk34vx5v7hvuO2HEUzmux6RweutKmKfw2e8LmMSVEl+MYIFsliXtzaVw40mv3wPMXorQ+Voa1nqEe8vQpgotTDWFRMouwXoIbodvRlLAHaymWpP2F6K9DkK48C1W7nCnRjTmZkxXCXQgpwuEehmrMmXTdT0WSGIAiUL59n2Slkl61d4mo8S1XY9SDcZLEEUJuNcFihncL2XvXTeF0E2nR6OEgt7Iv5MbyW5dAWz2UghtUEHtd7tBsTKozaqWmDI30lO9c6jl37qy73aSpSkNIUruGztnqL8YSDcIasHj+oAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KlWAfKbih8P3/+2oUMH/tWItKTWaFXue9vNnQ7rL/w=;
 b=eImyKBFlGEC4Z5XncqYHDSqiY8OQL0rfDaqwN6y++KDClkbnqkSGEPVKrUo3pRXFr2fyH9AZpQmq8MVY3Ip6eGnEBrZgdLDybNOvPKqy2KSJFQsoR2oIkQg8JJUpSudJNfYz7IWO9vPt5CW4K9V64x3C+Wj1tBV4t/tKeXwQvJ0=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4259.eurprd05.prod.outlook.com (52.134.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:20:45 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:20:45 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf v2 3/4] net/i40e: Fix concurrency issues between config
 flow and XSK
Thread-Topic: [PATCH bpf v2 3/4] net/i40e: Fix concurrency issues between
 config flow and XSK
Thread-Index: AQHVtPXvYaIGaoLTAkO9XurGqw6UTQ==
Date:   Tue, 17 Dec 2019 16:20:45 +0000
Message-ID: <20191217162023.16011-4-maximmi@mellanox.com>
References: <20191217162023.16011-1-maximmi@mellanox.com>
In-Reply-To: <20191217162023.16011-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd6eaf22-2b0c-4aa9-f473-08d7830d11e0
x-ms-traffictypediagnostic: AM0PR05MB4259:|AM0PR05MB4259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB42595C665EB4C684638B2A5ED1500@AM0PR05MB4259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(54906003)(26005)(66556008)(6506007)(110136005)(66476007)(2906002)(7416002)(64756008)(186003)(5660300002)(66446008)(36756003)(52116002)(1076003)(8676002)(81166006)(71200400001)(86362001)(81156014)(6486002)(107886003)(2616005)(478600001)(316002)(66946007)(6512007)(8936002)(4326008)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4259;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rHv0mdZTbgNfRAJqUgqjZU9mkeQ2JJXVeBDS26Sy9pueCr9fQ4oB1tCjiuvVOGcX3GUaBnxaaNn6mpGRs3OvICg1lKTFQcXbOuHcH6OgAyaq9yyr20cLeHQbS/qkRAymq5zbD1AScnhLTpyFn8+JTVyR8tujTqJTXptHrdnUJUYjl0Fwy84pIEbEnAJKzTG/7BWs7RME52s+4WV5xDIxQ7ta4y1Uwq7ahRuqm95R20Tg0xToxYwmwsUQA1HTdn2VopNluv2xj+qAfEct3KZBFTHNP38hDANPFVOHOkzmwHK8KeNAAjktEXxEOrC78Zcf2hpxLrPLSmAV6dW9uGP53TFoKIknmvB5z3UmcADlug3tpBYWNQkSRex19uzqF6Ptk31EwhDzo/9E2jRsrZQa1rizVVY7/GcUEQoOcz067Ay9ANooBKjJa45btmt96JnP8LU7oliz8czrGoq1LShjBRLzPyLnn7sLTAf7rCcDqK0VD3ffrd6HmVqsdcwzsgar
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2CB0C71F956E84F83386B97707A73E3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6eaf22-2b0c-4aa9-f473-08d7830d11e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:20:45.5892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jXYWSqLL3EU95j104HSIzEM+LAzaL7SyScJ86+nJl/ZjMlJhTsdHFM0qMHlpg2DXp4lkRuLwvO1Ls25WU5rM9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VXNlIHN5bmNocm9uaXplX3JjdSB0byB3YWl0IHVudGlsIHRoZSBYU0sgd2FrZXVwIGZ1bmN0aW9u
IGZpbmlzaGVzDQpiZWZvcmUgZGVzdHJveWluZyB0aGUgcmVzb3VyY2VzIGl0IHVzZXM6DQoNCjEu
IGk0MGVfZG93biBhbHJlYWR5IGNhbGxzIHN5bmNocm9uaXplX3JjdS4gT24gaTQwZV9kb3duIGVp
dGhlcg0KX19JNDBFX1ZTSV9ET1dOIG9yIF9fSTQwRV9DT05GSUdfQlVTWSBpcyBzZXQuIENoZWNr
IHRoZSBsYXR0ZXIgaW4NCmk0MGVfeHNrX3dha2V1cCAodGhlIGZvcm1lciBpcyBhbHJlYWR5IGNo
ZWNrZWQgdGhlcmUpLg0KDQoyLiBBZnRlciBzd2l0Y2hpbmcgdGhlIFhEUCBwcm9ncmFtLCBjYWxs
IHN5bmNocm9uaXplX3JjdSB0byBsZXQNCmk0MGVfeHNrX3dha2V1cCBleGl0IGJlZm9yZSB0aGUg
WERQIHByb2dyYW0gaXMgZnJlZWQuDQoNCjMuIENoYW5naW5nIHRoZSBudW1iZXIgb2YgY2hhbm5l
bHMgYnJpbmdzIHRoZSBpbnRlcmZhY2UgZG93biAoc2VlDQppNDBlX3ByZXBfZm9yX3Jlc2V0IGFu
ZCBpNDBlX3BmX3F1aWVzY2VfYWxsX3ZzaSkuDQoNCjQuIERpc2FibGluZyBVTUVNIHNldHMgX19J
NDBFX0NPTkZJR19CVVNZLCB0b28uDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tp
eSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBCasO2cm4gVMO2cGVsIDxi
am9ybi50b3BlbEBpbnRlbC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
NDBlL2k0MGUuaCAgICAgIHwgIDIgKy0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBl
L2k0MGVfbWFpbi5jIHwgMTAgKysrKysrKy0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2k0MGUvaTQwZV94c2suYyAgfCAgNCArKysrDQogMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRp
b25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaTQwZS9pNDBlLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0
MGUuaA0KaW5kZXggY2I2MzY3MzM0Y2E3Li40ODMzMTg3YmQyNTkgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGUuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaTQwZS9pNDBlLmgNCkBAIC0xMTUyLDcgKzExNTIsNyBAQCB2b2lkIGk0MGVf
c2V0X2ZlY19pbl9mbGFncyh1OCBmZWNfY2ZnLCB1MzIgKmZsYWdzKTsNCiANCiBzdGF0aWMgaW5s
aW5lIGJvb2wgaTQwZV9lbmFibGVkX3hkcF92c2koc3RydWN0IGk0MGVfdnNpICp2c2kpDQogew0K
LQlyZXR1cm4gISF2c2ktPnhkcF9wcm9nOw0KKwlyZXR1cm4gISFSRUFEX09OQ0UodnNpLT54ZHBf
cHJvZyk7DQogfQ0KIA0KIGludCBpNDBlX2NyZWF0ZV9xdWV1ZV9jaGFubmVsKHN0cnVjdCBpNDBl
X3ZzaSAqdnNpLCBzdHJ1Y3QgaTQwZV9jaGFubmVsICpjaCk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMNCmluZGV4IDFjY2FiZWFmYTQ0Yy4uMmM1YWY2ZDRh
NmIxIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21h
aW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYw0K
QEAgLTY4MjMsOCArNjgyMyw4IEBAIHZvaWQgaTQwZV9kb3duKHN0cnVjdCBpNDBlX3ZzaSAqdnNp
KQ0KIAlmb3IgKGkgPSAwOyBpIDwgdnNpLT5udW1fcXVldWVfcGFpcnM7IGkrKykgew0KIAkJaTQw
ZV9jbGVhbl90eF9yaW5nKHZzaS0+dHhfcmluZ3NbaV0pOw0KIAkJaWYgKGk0MGVfZW5hYmxlZF94
ZHBfdnNpKHZzaSkpIHsNCi0JCQkvKiBNYWtlIHN1cmUgdGhhdCBpbi1wcm9ncmVzcyBuZG9feGRw
X3htaXQNCi0JCQkgKiBjYWxscyBhcmUgY29tcGxldGVkLg0KKwkJCS8qIE1ha2Ugc3VyZSB0aGF0
IGluLXByb2dyZXNzIG5kb194ZHBfeG1pdCBhbmQNCisJCQkgKiBuZG9feHNrX3dha2V1cCBjYWxs
cyBhcmUgY29tcGxldGVkLg0KIAkJCSAqLw0KIAkJCXN5bmNocm9uaXplX3JjdSgpOw0KIAkJCWk0
MGVfY2xlYW5fdHhfcmluZyh2c2ktPnhkcF9yaW5nc1tpXSk7DQpAQCAtMTI1NDYsOCArMTI1NDYs
MTIgQEAgc3RhdGljIGludCBpNDBlX3hkcF9zZXR1cChzdHJ1Y3QgaTQwZV92c2kgKnZzaSwNCiAN
CiAJb2xkX3Byb2cgPSB4Y2hnKCZ2c2ktPnhkcF9wcm9nLCBwcm9nKTsNCiANCi0JaWYgKG5lZWRf
cmVzZXQpDQorCWlmIChuZWVkX3Jlc2V0KSB7DQorCQlpZiAoIXByb2cpDQorCQkJLyogV2FpdCB1
bnRpbCBuZG9feHNrX3dha2V1cCBjb21wbGV0ZXMuICovDQorCQkJc3luY2hyb25pemVfcmN1KCk7
DQogCQlpNDBlX3Jlc2V0X2FuZF9yZWJ1aWxkKHBmLCB0cnVlLCB0cnVlKTsNCisJfQ0KIA0KIAlm
b3IgKGkgPSAwOyBpIDwgdnNpLT5udW1fcXVldWVfcGFpcnM7IGkrKykNCiAJCVdSSVRFX09OQ0Uo
dnNpLT5yeF9yaW5nc1tpXS0+eGRwX3Byb2csIHZzaS0+eGRwX3Byb2cpOw0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYw0KaW5kZXggZDA3ZTFhODkwNDI4Li5mNzNj
ZDkxN2M0NGYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0
MGVfeHNrLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2su
Yw0KQEAgLTc4Nyw4ICs3ODcsMTIgQEAgaW50IGk0MGVfeHNrX3dha2V1cChzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LCB1MzIgcXVldWVfaWQsIHUzMiBmbGFncykNCiB7DQogCXN0cnVjdCBpNDBlX25l
dGRldl9wcml2ICpucCA9IG5ldGRldl9wcml2KGRldik7DQogCXN0cnVjdCBpNDBlX3ZzaSAqdnNp
ID0gbnAtPnZzaTsNCisJc3RydWN0IGk0MGVfcGYgKnBmID0gdnNpLT5iYWNrOw0KIAlzdHJ1Y3Qg
aTQwZV9yaW5nICpyaW5nOw0KIA0KKwlpZiAodGVzdF9iaXQoX19JNDBFX0NPTkZJR19CVVNZLCBw
Zi0+c3RhdGUpKQ0KKwkJcmV0dXJuIC1FTkVURE9XTjsNCisNCiAJaWYgKHRlc3RfYml0KF9fSTQw
RV9WU0lfRE9XTiwgdnNpLT5zdGF0ZSkpDQogCQlyZXR1cm4gLUVORVRET1dOOw0KIA0KLS0gDQoy
LjIwLjENCg0K
