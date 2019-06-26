Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E5E56944
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfFZMfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:35:37 -0400
Received: from mail-eopbgr750071.outbound.protection.outlook.com ([40.107.75.71]:7003
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726297AbfFZMfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/aeKvGn5Abb8G6lIsM3Oel4DIzdJpjZMhB2Mry0khY=;
 b=B4/8UQE5cer4wCXzuKF32rnCRO8tf/zcWJlWAxIBUmcNsS1SnupbinnNuutYSTPXL26n/0vfzSSRhxCacVU+DtJWj0W9WsGcBF6JEngvy6/e8m0aAeWEvvM4dalcUsutr4rPlU+hFDdzYPgErPVKzDp6YbXu8K9nUK/sFEJ9j50=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1549.namprd11.prod.outlook.com (10.172.54.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 12:35:33 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 12:35:33 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v3 1/8] net: aquantia: replace internal driver
 version code with uts
Thread-Topic: [PATCH net-next v3 1/8] net: aquantia: replace internal driver
 version code with uts
Thread-Index: AQHVLBul1duCbcHSv0OAxTbTByEPwg==
Date:   Wed, 26 Jun 2019 12:35:33 +0000
Message-ID: <3626643576c39a54edea6f7ba09626f44951a9f9.1561552290.git.igor.russkikh@aquantia.com>
References: <cover.1561552290.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1561552290.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:7:16::14) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78b460a2-971b-4bf5-b5aa-08d6fa32c7c6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1549;
x-ms-traffictypediagnostic: MWHPR11MB1549:
x-microsoft-antispam-prvs: <MWHPR11MB154906C996507A2DF7CEE40998E20@MWHPR11MB1549.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(136003)(396003)(39850400004)(189003)(199004)(6512007)(99286004)(53936002)(486006)(107886003)(6116002)(71190400001)(478600001)(54906003)(3846002)(71200400001)(6436002)(6486002)(2616005)(316002)(44832011)(476003)(72206003)(66556008)(64756008)(66446008)(86362001)(118296001)(73956011)(66946007)(66476007)(5660300002)(8676002)(6916009)(25786009)(50226002)(14454004)(81156014)(81166006)(2906002)(8936002)(66066001)(186003)(102836004)(7736002)(305945005)(446003)(52116002)(76176011)(68736007)(11346002)(256004)(6506007)(386003)(36756003)(4326008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1549;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i4anAjrK3N7+BbSTJ/EPvBpnPEnwyOcyC11L3a1OVYGstWwY7oMqlxhiGu4q8gFW8zfYCrl0zfEuZXUTrv22Y1+imgc7AEGf0JdI7CADMnJyAadhmTESsQ/ALf4pRbudgw1RZojNb2c+nT7l8dC2Ukl19/AOCVkUTqFMdqMqKgVNPnWXQw8aGLH+n8RcgbsMkxK6FH6vobwCJ8+I8qYehEQIiUBM1UKNWf8Zsa+EEKwRxYnWOMdi5w3jletSsjgjLuPSo4PdnMpnZhSlfuHOIBVuCbbxPBbF4PZLdTfwEzVt/vGLmnz/8DS1rBWWiGNfOvUjAu9LzaPQEHIVyfjQf+wQYVVN2MBFKYY5MU9kkOFX+dcYFVoXpMTdWuv4Ms5e7+iltBtDVnTEK9tm+1WlfyxZFWNKJFz3XuL7ZyhEAJc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b460a2-971b-4bf5-b5aa-08d6fa32c7c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 12:35:33.2706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgaXQgd2FzIGRpc2N1c3NlZCBzb21lIHRpbWUgcHJldmlvdXNseSwgZHJpdmVyIGlzIGJldHRl
ciB0bw0KcmVwb3J0IGtlcm5lbCB2ZXJzaW9uIHN0cmluZywgYXMgaXQgaW4gYSBiZXN0IHdheSBp
ZGVudGlmaWVzDQp0aGUgY29kZWJhc2UuDQoNClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2gg
PGlnb3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0KUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxh
bmRyZXdAbHVubi5jaD4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFu
dGljL2FxX2NmZy5oIHwgNyArKystLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvdmVyLmggICAgfCA1IC0tLS0tDQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDkgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9jZmcuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFu
dGlhL2F0bGFudGljL2FxX2NmZy5oDQppbmRleCAxNzNiZTQ1NDYzZWUuLjAyZjFiNzBjNGUyNSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2Nm
Zy5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9jZmcu
aA0KQEAgLTksNiArOSw4IEBADQogI2lmbmRlZiBBUV9DRkdfSA0KICNkZWZpbmUgQVFfQ0ZHX0gN
CiANCisjaW5jbHVkZSA8Z2VuZXJhdGVkL3V0c3JlbGVhc2UuaD4NCisNCiAjZGVmaW5lIEFRX0NG
R19WRUNTX0RFRiAgIDhVDQogI2RlZmluZSBBUV9DRkdfVENTX0RFRiAgICAxVQ0KIA0KQEAgLTg2
LDEwICs4OCw3IEBADQogI2RlZmluZSBBUV9DRkdfRFJWX0FVVEhPUiAgICAgICJhUXVhbnRpYSIN
CiAjZGVmaW5lIEFRX0NGR19EUlZfREVTQyAgICAgICAgImFRdWFudGlhIENvcnBvcmF0aW9uKFIp
IE5ldHdvcmsgRHJpdmVyIg0KICNkZWZpbmUgQVFfQ0ZHX0RSVl9OQU1FICAgICAgICAiYXRsYW50
aWMiDQotI2RlZmluZSBBUV9DRkdfRFJWX1ZFUlNJT04JX19zdHJpbmdpZnkoTklDX01BSk9SX0RS
SVZFUl9WRVJTSU9OKSIuIlwNCi0JCQkJX19zdHJpbmdpZnkoTklDX01JTk9SX0RSSVZFUl9WRVJT
SU9OKSIuIlwNCi0JCQkJX19zdHJpbmdpZnkoTklDX0JVSUxEX0RSSVZFUl9WRVJTSU9OKSIuIlwN
Ci0JCQkJX19zdHJpbmdpZnkoTklDX1JFVklTSU9OX0RSSVZFUl9WRVJTSU9OKSBcDQorI2RlZmlu
ZSBBUV9DRkdfRFJWX1ZFUlNJT04JVVRTX1JFTEVBU0UgXA0KIAkJCQlBUV9DRkdfRFJWX1ZFUlNJ
T05fU1VGRklYDQogDQogI2VuZGlmIC8qIEFRX0NGR19IICovDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvdmVyLmggYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIuaA0KaW5kZXggMjMzNzRiZmZhOTJiLi41OTc2NTRi
NTFlMDEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRp
Yy92ZXIuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvdmVy
LmgNCkBAIC03LDExICs3LDYgQEANCiAjaWZuZGVmIFZFUl9IDQogI2RlZmluZSBWRVJfSA0KIA0K
LSNkZWZpbmUgTklDX01BSk9SX0RSSVZFUl9WRVJTSU9OICAgICAgICAgICAyDQotI2RlZmluZSBO
SUNfTUlOT1JfRFJJVkVSX1ZFUlNJT04gICAgICAgICAgIDANCi0jZGVmaW5lIE5JQ19CVUlMRF9E
UklWRVJfVkVSU0lPTiAgICAgICAgICAgNA0KLSNkZWZpbmUgTklDX1JFVklTSU9OX0RSSVZFUl9W
RVJTSU9OICAgICAgICAwDQotDQogI2RlZmluZSBBUV9DRkdfRFJWX1ZFUlNJT05fU1VGRklYICIt
a2VybiINCiANCiAjZW5kaWYgLyogVkVSX0ggKi8NCi0tIA0KMi4xNy4xDQoNCg==
