Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7530EE037
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfD2KF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:27 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727960AbfD2KFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xc9T7ce06ystqvpfcm3JTv+IEDQWyv1prrUB359lYZo=;
 b=lchIg9uLFNHxcrxiMFyuoMePgkr0SX1xWugpHVWowB0mGNSo/7BW/g0vORZEHK3c4JjshMNcA3gKBfJmfZAuiuzIeZEVYngdNdI4uI0h9r19+/+Lj1RuyNUI70HDcSEKoVDf23XxR0gUqTNhy5HOMQLEXPC8G1GYIX8Jnl+c6Zc=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:55 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:55 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 09/15] net: aquantia: user correct MSI irq type
Thread-Topic: [PATCH v4 net-next 09/15] net: aquantia: user correct MSI irq
 type
Thread-Index: AQHU/nL+rLkH1jmTlEaSRL96lIyZ+g==
Date:   Mon, 29 Apr 2019 10:04:55 +0000
Message-ID: <31dbd90bdddd137e70130b3ed37b9f4a6ab15fe3.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2940ef82-0e70-4647-0fb2-08d6cc8a20e9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB3644CCCF8CE73FA9302CAEC598390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(4744005)(256004)(11346002)(52116002)(446003)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q2DnVwN3hs+EBC9El2ThjcidEzN7NTagJ0DkueekCLjYhljCVnHDIvtwwhZhcecpAMK2DXnlGy8Mwxank6fUpdVhXIavzogduJ1hydX+v4JdqGi/f4tfuifaPzQRtMsuHKJcUe2qeaZI7wWlxnPBlfKwPrDAPPvF7FEUZPSSoSJjgES4StSYl/aWFX4gfcE7CKfHdvNesn7q6zASwoeQSCifIjEwDiWrAG4cJgeV2px95xzf4jYpiApKt/GDEFlmkc1ctEHW3Sh9dcOuLdjMHoC9/nJ2INTwQCBCSee3tqC1LA/dZqgH1hK0h75wEm+ysvz8L5ErMe5bx8syZgloXThitXXcJ/+cXrUmjqsm95T3a3KOGCpLBx2ZYv7ewpfp5F1zTjIi5SD+A5GpTZnJnCO1jFliH/eDCwjjN76e/VM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2940ef82-0e70-4647-0fb2-08d6cc8a20e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:55.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VHlwbyBpbiBtc2kgY29kZS4gTm8gbXVjaCBpbXBhY3QgdGhvdWdoLg0KDQpTaWduZWQtb2ZmLWJ5
OiBOaWtpdGEgRGFuaWxvdiA8bmRhbmlsb3ZAYXF1YW50aWEuY29tPg0KU2lnbmVkLW9mZi1ieTog
SWdvciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVhbnRpYS5jb20+DQotLS0NCiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9wY2lfZnVuYy5jIHwgMiArLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1bmMuYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3BjaV9mdW5jLmMNCmlu
ZGV4IDRmMzczZWE4YjY5My4uNzNkNzZmOGVmZTA1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1bmMuYw0KKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1bmMuYw0KQEAgLTE5Myw3ICsx
OTMsNyBAQCB1bnNpZ25lZCBpbnQgYXFfcGNpX2Z1bmNfZ2V0X2lycV90eXBlKHN0cnVjdCBhcV9u
aWNfcyAqc2VsZikNCiAJaWYgKHNlbGYtPnBkZXYtPm1zaXhfZW5hYmxlZCkNCiAJCXJldHVybiBB
UV9IV19JUlFfTVNJWDsNCiAJaWYgKHNlbGYtPnBkZXYtPm1zaV9lbmFibGVkKQ0KLQkJcmV0dXJu
IEFRX0hXX0lSUV9NU0lYOw0KKwkJcmV0dXJuIEFRX0hXX0lSUV9NU0k7DQogCXJldHVybiBBUV9I
V19JUlFfTEVHQUNZOw0KIH0NCiANCi0tIA0KMi4xNy4xDQoNCg==
