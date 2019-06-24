Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEED550FEF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfFXPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:10:49 -0400
Received: from mail-eopbgr810087.outbound.protection.outlook.com ([40.107.81.87]:22483
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730437AbfFXPKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 11:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSGGHSQ6AM5p+NSTlG5A3O14awBNhuz0hdOV6aANrJw=;
 b=hPOylXbYOr5W0+N1XY96Gb1aYy5DFSSDCI1rvdNvSJ6Kj519ktNMIDB1LeJS/VMnfYAxmdcAJY5NYles+08Fym9bONb0v1BCrJi58l4Spf+3tGkwoHM2GyDLgf6hF9L55pVxIqF9v8Gi3ibz3uxDvVIMGxMGPwobITXskYmH/5A=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1614.namprd11.prod.outlook.com (10.172.56.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 15:10:45 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 15:10:45 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v2 1/8] net: aquantia: replace internal driver
 version code with uts
Thread-Topic: [PATCH net-next v2 1/8] net: aquantia: replace internal driver
 version code with uts
Thread-Index: AQHVKp7/8jq2AWmJOECcP2qm88zlyA==
Date:   Mon, 24 Jun 2019 15:10:45 +0000
Message-ID: <bb06ad821aeb27c31d1370fe7ca4ebdf73d45a06.1561388549.git.igor.russkikh@aquantia.com>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561388549.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4d1d816-e985-4f09-27d4-08d6f8b6214f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1614;
x-ms-traffictypediagnostic: MWHPR11MB1614:
x-microsoft-antispam-prvs: <MWHPR11MB1614F4898891AEF59EEB786B98E00@MWHPR11MB1614.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(366004)(376002)(39840400004)(189003)(199004)(186003)(8676002)(99286004)(26005)(72206003)(102836004)(6916009)(316002)(81156014)(478600001)(2616005)(476003)(66066001)(76176011)(81166006)(52116002)(66446008)(64756008)(73956011)(66946007)(6506007)(386003)(44832011)(50226002)(446003)(11346002)(486006)(8936002)(54906003)(6436002)(5660300002)(71200400001)(68736007)(107886003)(53936002)(6512007)(71190400001)(2906002)(66476007)(66556008)(86362001)(305945005)(36756003)(25786009)(256004)(118296001)(4326008)(14454004)(6116002)(3846002)(6486002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1614;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gW/ot4IvkhNMvPy40pE1dKgKI9doJkbF2nt1EQK5uKVNlzdRccaDiH+1YqcUeqI6PA9OwWDcoPl4qwJDZ9ShVOq9cxmQ/fiP7/6bSQK1v/Dlz0Pz/KSllH83JZaHTmRU2OAEhAvHZb/LCpVPKHqc9Dum9Dp+SGP+a18ixyoYiOV4ISItA4PSv/7Rty9Vy6MIJ4xyEa+zrwDR34pvio3UJDqOF5uy/A4+O5RFrgH6Y64/WErZNU2QAU3kx/m4p0wZcEYlZ2xo8MCtcbHvLwOgBQkFxBx5t6KRs07tk8BN04w8x6K3rTbn/ssJPziD4wrm3+Fg/Orh8n8gY65nY0XTrPJqJdw5IfSNoEwPClHY85gA1trfjiylXjbaQAq9wZeYhIV86C7RON6s1ehquZlksK+KI6g4uPjnQ0gKGOWNaP0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d1d816-e985-4f09-27d4-08d6f8b6214f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:10:45.0139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1614
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgaXQgd2FzIGRpc2N1c3NlZCBzb21lIHRpbWUgcHJldmlvdXNseSwgZHJpdmVyIGlzIGJldHRl
ciB0bw0KcmVwb3J0IGtlcm5lbCB2ZXJzaW9uIHN0cmluZywgYXMgaXQgaW4gYSBiZXN0IHdheSBp
ZGVudGlmaWVzDQp0aGUgY29kZWJhc2UuDQoNClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2gg
PGlnb3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
YXF1YW50aWEvYXRsYW50aWMvYXFfY2ZnLmggfCA3ICsrKy0tLS0NCiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIuaCAgICB8IDUgLS0tLS0NCiAyIGZpbGVzIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2NmZy5oIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfY2ZnLmgNCmluZGV4IDE3M2JlNDU0NjNlZS4u
MDJmMWI3MGM0ZTI1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvYXFfY2ZnLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0
bGFudGljL2FxX2NmZy5oDQpAQCAtOSw2ICs5LDggQEANCiAjaWZuZGVmIEFRX0NGR19IDQogI2Rl
ZmluZSBBUV9DRkdfSA0KIA0KKyNpbmNsdWRlIDxnZW5lcmF0ZWQvdXRzcmVsZWFzZS5oPg0KKw0K
ICNkZWZpbmUgQVFfQ0ZHX1ZFQ1NfREVGICAgOFUNCiAjZGVmaW5lIEFRX0NGR19UQ1NfREVGICAg
IDFVDQogDQpAQCAtODYsMTAgKzg4LDcgQEANCiAjZGVmaW5lIEFRX0NGR19EUlZfQVVUSE9SICAg
ICAgImFRdWFudGlhIg0KICNkZWZpbmUgQVFfQ0ZHX0RSVl9ERVNDICAgICAgICAiYVF1YW50aWEg
Q29ycG9yYXRpb24oUikgTmV0d29yayBEcml2ZXIiDQogI2RlZmluZSBBUV9DRkdfRFJWX05BTUUg
ICAgICAgICJhdGxhbnRpYyINCi0jZGVmaW5lIEFRX0NGR19EUlZfVkVSU0lPTglfX3N0cmluZ2lm
eShOSUNfTUFKT1JfRFJJVkVSX1ZFUlNJT04pIi4iXA0KLQkJCQlfX3N0cmluZ2lmeShOSUNfTUlO
T1JfRFJJVkVSX1ZFUlNJT04pIi4iXA0KLQkJCQlfX3N0cmluZ2lmeShOSUNfQlVJTERfRFJJVkVS
X1ZFUlNJT04pIi4iXA0KLQkJCQlfX3N0cmluZ2lmeShOSUNfUkVWSVNJT05fRFJJVkVSX1ZFUlNJ
T04pIFwNCisjZGVmaW5lIEFRX0NGR19EUlZfVkVSU0lPTglVVFNfUkVMRUFTRSBcDQogCQkJCUFR
X0NGR19EUlZfVkVSU0lPTl9TVUZGSVgNCiANCiAjZW5kaWYgLyogQVFfQ0ZHX0ggKi8NCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIuaCBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL3Zlci5oDQppbmRleCAyMzM3NGJm
ZmE5MmIuLjU5NzY1NGI1MWUwMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Fx
dWFudGlhL2F0bGFudGljL3Zlci5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRp
YS9hdGxhbnRpYy92ZXIuaA0KQEAgLTcsMTEgKzcsNiBAQA0KICNpZm5kZWYgVkVSX0gNCiAjZGVm
aW5lIFZFUl9IDQogDQotI2RlZmluZSBOSUNfTUFKT1JfRFJJVkVSX1ZFUlNJT04gICAgICAgICAg
IDINCi0jZGVmaW5lIE5JQ19NSU5PUl9EUklWRVJfVkVSU0lPTiAgICAgICAgICAgMA0KLSNkZWZp
bmUgTklDX0JVSUxEX0RSSVZFUl9WRVJTSU9OICAgICAgICAgICA0DQotI2RlZmluZSBOSUNfUkVW
SVNJT05fRFJJVkVSX1ZFUlNJT04gICAgICAgIDANCi0NCiAjZGVmaW5lIEFRX0NGR19EUlZfVkVS
U0lPTl9TVUZGSVggIi1rZXJuIg0KIA0KICNlbmRpZiAvKiBWRVJfSCAqLw0KLS0gDQoyLjE3LjEN
Cg0K
