Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3031B4F5FB
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFVNpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 09:45:17 -0400
Received: from mail-eopbgr790059.outbound.protection.outlook.com ([40.107.79.59]:57275
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbfFVNpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 09:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpq7W3UEacnVbAkSMZG9qoP0hfQIsrqY7Mdj3dIEGEU=;
 b=m9LBEfEfD0wkwbow2K6fFwHylA4uzzB8349qQ+lCRBBeJMG0hAieE1zX9J37+ubi9YyG5CkCSZ4O3PfwCgbiNRTDpR4ZK65FVVoqXM3FSDQYTwoLZ29crbACcU484mILqLbDrFClQ0Wcb3F2DDnLaSIyltQfB04oXGe4kWdk6X8=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1389.namprd11.prod.outlook.com (10.169.235.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sat, 22 Jun 2019 13:45:12 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.014; Sat, 22 Jun 2019
 13:45:12 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 1/7] net: aquantia: replace internal driver version
 code with uts
Thread-Topic: [PATCH net-next 1/7] net: aquantia: replace internal driver
 version code with uts
Thread-Index: AQHVKQC320Yt1wWfIE+V6I6UeKytHw==
Date:   Sat, 22 Jun 2019 13:45:12 +0000
Message-ID: <f5f346ff5f727f1ccf0f889e358261a792397210.1561210852.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: a7ad9010-04da-434c-d63e-08d6f717d955
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1389;
x-ms-traffictypediagnostic: MWHPR11MB1389:
x-microsoft-antispam-prvs: <MWHPR11MB138910DF55552CDD7BF11EC298E60@MWHPR11MB1389.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0076F48C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(346002)(136003)(39840400004)(199004)(189003)(478600001)(68736007)(8676002)(486006)(7736002)(81166006)(2616005)(44832011)(81156014)(66066001)(3846002)(256004)(72206003)(6116002)(118296001)(50226002)(2906002)(99286004)(64756008)(66446008)(36756003)(86362001)(6916009)(66556008)(66476007)(73956011)(71190400001)(71200400001)(476003)(11346002)(446003)(66946007)(54906003)(76176011)(6486002)(53936002)(6512007)(52116002)(386003)(6506007)(5660300002)(25786009)(107886003)(305945005)(6436002)(316002)(8936002)(14454004)(4326008)(186003)(26005)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1389;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oxKGhOZleDy3JlBTTw4D+JMpWo/zrBCAXJBW2bKVfnq8G3D4am6cdw1n11dDS8V0KH/od1BToyFuNkkZL0dqh1RTyUa9oGprRKWfyhDWuoXfcsb4ewE1AP7txrMQEyHzys8K6yXeALXVsSOWV/hz2f/GFlkQUTDWtcpWni+gU8WAJ3vIOIsgoKg7dnI0SVMTWzll6EDfzPBo7xA92Pm9pr1q9SdFt3m2HzKnarHaUhXrRYxjVpAnYkJtRkZwxNdceaho3xR1Sm/rqbP89QyLMWgFGEwXmKFcEuin3ZV5/2bevTNBE49d1VtS1xM5Al1ZB5qmtBBb9wLbEFgpRgRwqGVxbbw3Kzi9gWBYD0cZ7QOvuR9QJxmLzHFTwlOkiNpR7Zd4MI7Z5t3PvYP5Y3ACZZ5nAgSwH2hgwxHWi5w95Co=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ad9010-04da-434c-d63e-08d6f717d955
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2019 13:45:12.6977
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

QXMgaXQgd2FzIGRpc2N1c3NlZCBzb21lIHRpbWUgcHJldmlvdXNseSwgZHJpdmVyIGlzIGJldHRl
ciB0bw0KcmVwb3J0IGtlcm5lbCB2ZXJzaW9uIHN0cmluZywgYXMgaXQgaW4gYSBiZXN0IHdheSBp
ZGVudGlmaWVzDQp0aGUgY29kZWJhc2UuDQoNClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2gg
PGlnb3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQv
YXF1YW50aWEvYXRsYW50aWMvYXFfY2ZnLmggfCA3ICsrKy0tLS0NCiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIuaCAgICB8IDUgLS0tLS0NCiAyIGZpbGVzIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2NmZy5oIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfY2ZnLmgNCmluZGV4IDhmMzVjM2Y4ODNmMC4u
ZDg5MGMzNmQzMDJiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvYXFfY2ZnLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0
bGFudGljL2FxX2NmZy5oDQpAQCAtMTIsNiArMTIsOCBAQA0KICNpZm5kZWYgQVFfQ0ZHX0gNCiAj
ZGVmaW5lIEFRX0NGR19IDQogDQorI2luY2x1ZGUgPGdlbmVyYXRlZC91dHNyZWxlYXNlLmg+DQor
DQogI2RlZmluZSBBUV9DRkdfVkVDU19ERUYgICA4VQ0KICNkZWZpbmUgQVFfQ0ZHX1RDU19ERUYg
ICAgMVUNCiANCkBAIC04OSwxMCArOTEsNyBAQA0KICNkZWZpbmUgQVFfQ0ZHX0RSVl9BVVRIT1Ig
ICAgICAiYVF1YW50aWEiDQogI2RlZmluZSBBUV9DRkdfRFJWX0RFU0MgICAgICAgICJhUXVhbnRp
YSBDb3Jwb3JhdGlvbihSKSBOZXR3b3JrIERyaXZlciINCiAjZGVmaW5lIEFRX0NGR19EUlZfTkFN
RSAgICAgICAgImF0bGFudGljIg0KLSNkZWZpbmUgQVFfQ0ZHX0RSVl9WRVJTSU9OCV9fc3RyaW5n
aWZ5KE5JQ19NQUpPUl9EUklWRVJfVkVSU0lPTikiLiJcDQotCQkJCV9fc3RyaW5naWZ5KE5JQ19N
SU5PUl9EUklWRVJfVkVSU0lPTikiLiJcDQotCQkJCV9fc3RyaW5naWZ5KE5JQ19CVUlMRF9EUklW
RVJfVkVSU0lPTikiLiJcDQotCQkJCV9fc3RyaW5naWZ5KE5JQ19SRVZJU0lPTl9EUklWRVJfVkVS
U0lPTikgXA0KKyNkZWZpbmUgQVFfQ0ZHX0RSVl9WRVJTSU9OCVVUU19SRUxFQVNFIFwNCiAJCQkJ
QVFfQ0ZHX0RSVl9WRVJTSU9OX1NVRkZJWA0KIA0KICNlbmRpZiAvKiBBUV9DRkdfSCAqLw0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL3Zlci5oIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvdmVyLmgNCmluZGV4IGI0ODI2
MDExNGRhMy4uNGUxMmVhMzA0YzQwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
YXF1YW50aWEvYXRsYW50aWMvdmVyLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFu
dGlhL2F0bGFudGljL3Zlci5oDQpAQCAtMTAsMTEgKzEwLDYgQEANCiAjaWZuZGVmIFZFUl9IDQog
I2RlZmluZSBWRVJfSA0KIA0KLSNkZWZpbmUgTklDX01BSk9SX0RSSVZFUl9WRVJTSU9OICAgICAg
ICAgICAyDQotI2RlZmluZSBOSUNfTUlOT1JfRFJJVkVSX1ZFUlNJT04gICAgICAgICAgIDANCi0j
ZGVmaW5lIE5JQ19CVUlMRF9EUklWRVJfVkVSU0lPTiAgICAgICAgICAgNA0KLSNkZWZpbmUgTklD
X1JFVklTSU9OX0RSSVZFUl9WRVJTSU9OICAgICAgICAwDQotDQogI2RlZmluZSBBUV9DRkdfRFJW
X1ZFUlNJT05fU1VGRklYICIta2VybiINCiANCiAjZW5kaWYgLyogVkVSX0ggKi8NCi0tIA0KMi4x
Ny4xDQoNCg==
