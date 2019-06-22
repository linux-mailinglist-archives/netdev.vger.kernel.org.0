Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB14F4F601
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 15:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbfFVNpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 09:45:31 -0400
Received: from mail-eopbgr790084.outbound.protection.outlook.com ([40.107.79.84]:40384
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfFVNpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 09:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTET7zX8KlomxvzJM6ppGWTekFmkegE+xtyeqOPDtKc=;
 b=n0wGt+odKFNsdTT5yIxVKPGkVGs7aHQpm7/viSHl0Ht5PB6waiWsQmHs0m/aMA55TA03a/KG9d8vykJbrFDRThUEYSDDCw/8z9qiLGZChy+XaN6MCkbiyH3aTNOkxJqdxRS13ED4xlZt7LIKPRREbKqngDdm3roFKzdEAqQotic=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1389.namprd11.prod.outlook.com (10.169.235.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sat, 22 Jun 2019 13:45:27 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.014; Sat, 22 Jun 2019
 13:45:27 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 7/7] net: aquantia: implement vlan offload
 configuration
Thread-Topic: [PATCH net-next 7/7] net: aquantia: implement vlan offload
 configuration
Thread-Index: AQHVKQC/CtFE1DZr/0CNG4Mfgx0LaA==
Date:   Sat, 22 Jun 2019 13:45:26 +0000
Message-ID: <71715424c3a2f3ae0fb0a40d0f0f21010df205f6.1561210852.git.igor.russkikh@aquantia.com>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561210852.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::32) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab7158b4-3b62-4db4-30fc-08d6f717e143
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1389;
x-ms-traffictypediagnostic: MWHPR11MB1389:
x-microsoft-antispam-prvs: <MWHPR11MB13891E7447C96CA84B2D14AE98E60@MWHPR11MB1389.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:78;
x-forefront-prvs: 0076F48C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(346002)(136003)(39840400004)(199004)(189003)(478600001)(68736007)(8676002)(486006)(7736002)(81166006)(2616005)(44832011)(81156014)(66066001)(14444005)(3846002)(256004)(72206003)(6116002)(118296001)(50226002)(2906002)(99286004)(64756008)(66446008)(36756003)(86362001)(6916009)(66556008)(66476007)(73956011)(71190400001)(71200400001)(476003)(11346002)(446003)(66946007)(54906003)(76176011)(6486002)(53936002)(6512007)(52116002)(386003)(6506007)(5660300002)(25786009)(107886003)(305945005)(6436002)(316002)(8936002)(14454004)(4326008)(186003)(26005)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1389;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rLnK0X6bQ03egSpy18Luz1WdbEMWOJvkAjo4p2bKCpMCzl9wiM+VMpP1p0SGUkaPXJcVs+nGa4Tzoi5M5H+QvzxuN++iTf07fiTNyBaomhM8CpvXwLUyC7VWUK3jXwmkwiXc+P3Orgq9dmKm8RpRtUYQzRCCJQgXeWMqH//+fnybdl0qB9a0j2klAxtq/F0934ND9p+sTG+eg/p6jDRSEmV0N306sJKpDjPEDo9ZlYycbrvU5we1LLUcB3cmX2fhUtYATHTpq3yVWn+GHQlGwS9PM1pyfU9id3tNtrt1wo6t6TX6KBNq0mfwzYp9To2iCjEPOM6pZ4QsP3MOT8/kSlpdsriEbi+QgyxhiDZHk3/sTGqyIlKBRgR1v4Bv0Nwe87RI3CWmT3phb6Ddt6OMLTqro8rQpYbnIwULLHySYH0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7158b4-3b62-4db4-30fc-08d6f717e143
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2019 13:45:26.0884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1389
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c2V0X2ZlYXR1cmVzIHNob3VsZCB1cGRhdGUgZmxhZ3MgYW5kIHJlaW5pdCBoYXJkd2FyZSBpZg0K
dmxhbiBvZmZsb2FkIHNldHRpbmdzIHdlcmUgY2hhbmdlZC4NCg0KU2lnbmVkLW9mZi1ieTogSWdv
ciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVhbnRpYS5jb20+DQpUZXN0ZWQtYnk6IE5pa2l0
YSBEYW5pbG92IDxuZGFuaWxvdkBhcXVhbnRpYS5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0
L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYyAgfCAzNCArKysrKysrKysrKysrKystLS0tDQog
MSBmaWxlIGNoYW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmMNCmluZGV4
IDFlYThiNzdmYzFhNy4uODcxMTJlNTBlZTYwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9tYWluLmMNCkBAIC0xMTEsMTEgKzExMSwxNiBAQCBz
dGF0aWMgaW50IGFxX25kZXZfY2hhbmdlX210dShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgaW50
IG5ld19tdHUpDQogc3RhdGljIGludCBhcV9uZGV2X3NldF9mZWF0dXJlcyhzdHJ1Y3QgbmV0X2Rl
dmljZSAqbmRldiwNCiAJCQkJbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpDQogew0KKwlib29s
IGlzX3ZsYW5fcnhfc3RyaXAgPSAhIShmZWF0dXJlcyAmIE5FVElGX0ZfSFdfVkxBTl9DVEFHX1JY
KTsNCisJYm9vbCBpc192bGFuX3R4X2luc2VydCA9ICEhKGZlYXR1cmVzICYgTkVUSUZfRl9IV19W
TEFOX0NUQUdfVFgpOw0KIAlzdHJ1Y3QgYXFfbmljX3MgKmFxX25pYyA9IG5ldGRldl9wcml2KG5k
ZXYpOw0KLQlzdHJ1Y3QgYXFfbmljX2NmZ19zICphcV9jZmcgPSBhcV9uaWNfZ2V0X2NmZyhhcV9u
aWMpOw0KKwlib29sIG5lZWRfbmRldl9yZXN0YXJ0ID0gZmFsc2U7DQorCXN0cnVjdCBhcV9uaWNf
Y2ZnX3MgKmFxX2NmZzsNCiAJYm9vbCBpc19scm8gPSBmYWxzZTsNCiAJaW50IGVyciA9IDA7DQog
DQorCWFxX2NmZyA9IGFxX25pY19nZXRfY2ZnKGFxX25pYyk7DQorDQogCWlmICghKGZlYXR1cmVz
ICYgTkVUSUZfRl9OVFVQTEUpKSB7DQogCQlpZiAoYXFfbmljLT5uZGV2LT5mZWF0dXJlcyAmIE5F
VElGX0ZfTlRVUExFKSB7DQogCQkJZXJyID0gYXFfY2xlYXJfcnhuZmNfYWxsX3J1bGVzKGFxX25p
Yyk7DQpAQCAtMTM4LDE3ICsxNDMsMzIgQEAgc3RhdGljIGludCBhcV9uZGV2X3NldF9mZWF0dXJl
cyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwNCiANCiAJCWlmIChhcV9jZmctPmlzX2xybyAhPSBp
c19scm8pIHsNCiAJCQlhcV9jZmctPmlzX2xybyA9IGlzX2xybzsNCi0NCi0JCQlpZiAobmV0aWZf
cnVubmluZyhuZGV2KSkgew0KLQkJCQlhcV9uZGV2X2Nsb3NlKG5kZXYpOw0KLQkJCQlhcV9uZGV2
X29wZW4obmRldik7DQotCQkJfQ0KKwkJCW5lZWRfbmRldl9yZXN0YXJ0ID0gdHJ1ZTsNCiAJCX0N
CiAJfQ0KLQlpZiAoKGFxX25pYy0+bmRldi0+ZmVhdHVyZXMgXiBmZWF0dXJlcykgJiBORVRJRl9G
X1JYQ1NVTSkNCisNCisJaWYgKChhcV9uaWMtPm5kZXYtPmZlYXR1cmVzIF4gZmVhdHVyZXMpICYg
TkVUSUZfRl9SWENTVU0pIHsNCiAJCWVyciA9IGFxX25pYy0+YXFfaHdfb3BzLT5od19zZXRfb2Zm
bG9hZChhcV9uaWMtPmFxX2h3LA0KIAkJCQkJCQlhcV9jZmcpOw0KIA0KKwkJaWYgKHVubGlrZWx5
KGVycikpDQorCQkJZ290byBlcnJfZXhpdDsNCisJfQ0KKw0KKwlpZiAoYXFfY2ZnLT5pc192bGFu
X3J4X3N0cmlwICE9IGlzX3ZsYW5fcnhfc3RyaXApIHsNCisJCWFxX2NmZy0+aXNfdmxhbl9yeF9z
dHJpcCA9IGlzX3ZsYW5fcnhfc3RyaXA7DQorCQluZWVkX25kZXZfcmVzdGFydCA9IHRydWU7DQor
CX0NCisJaWYgKGFxX2NmZy0+aXNfdmxhbl90eF9pbnNlcnQgIT0gaXNfdmxhbl90eF9pbnNlcnQp
IHsNCisJCWFxX2NmZy0+aXNfdmxhbl90eF9pbnNlcnQgPSBpc192bGFuX3R4X2luc2VydDsNCisJ
CW5lZWRfbmRldl9yZXN0YXJ0ID0gdHJ1ZTsNCisJfQ0KKw0KKwlpZiAobmVlZF9uZGV2X3Jlc3Rh
cnQgJiYgbmV0aWZfcnVubmluZyhuZGV2KSkgew0KKwkJYXFfbmRldl9jbG9zZShuZGV2KTsNCisJ
CWFxX25kZXZfb3BlbihuZGV2KTsNCisJfQ0KKw0KIGVycl9leGl0Og0KIAlyZXR1cm4gZXJyOw0K
IH0NCi0tIA0KMi4xNy4xDQoNCg==
