Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02E5E030
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfD2KFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:19 -0400
Received: from mail-eopbgr810055.outbound.protection.outlook.com ([40.107.81.55]:40164
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727938AbfD2KFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEqNA04/Ly2rDim5pzFIuZNuPNbRLrTLyvZk0uHGTKI=;
 b=EA1CGMN2WqKlohN/SCGn1zI5G/S45q49kIrh2sq/W8SKT1FEHKeY/T0yW1HDxx5m2yjFRbkljNac/F9uX+4dMwyXUkvXskzUSc5liaheXoJYQuH3M9S+ezut8wsVztnp90I4ZPaxolD4NJMoZLSVXmKNGF6/LHZSHx+Q4DMLzmg=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3644.namprd11.prod.outlook.com (20.178.230.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 10:04:41 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:04:41 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 03/15] net: aquantia: add link interrupt fields
Thread-Topic: [PATCH v4 net-next 03/15] net: aquantia: add link interrupt
 fields
Thread-Index: AQHU/nL2mDJtjPq4TUi/5HbsSVTuXg==
Date:   Mon, 29 Apr 2019 10:04:40 +0000
Message-ID: <978dfc0ebe824e41eeb294550158ac6f615141ae.1556531633.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: 00582511-a463-4504-df8d-08d6cc8a1850
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3644;
x-ms-traffictypediagnostic: DM6PR11MB3644:
x-microsoft-antispam-prvs: <DM6PR11MB364429992372D8D5E8FF3EA398390@DM6PR11MB3644.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:81;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39840400004)(189003)(199004)(6512007)(2906002)(5660300002)(71200400001)(6486002)(99286004)(53936002)(26005)(25786009)(44832011)(71190400001)(14454004)(50226002)(4326008)(3846002)(66556008)(64756008)(66446008)(36756003)(8936002)(73956011)(72206003)(66946007)(54906003)(66476007)(7736002)(6116002)(6436002)(81166006)(86362001)(6506007)(478600001)(81156014)(8676002)(97736004)(305945005)(107886003)(386003)(316002)(118296001)(68736007)(102836004)(6916009)(76176011)(476003)(186003)(2616005)(486006)(256004)(11346002)(52116002)(446003)(66066001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3644;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +v9gkplQ2JVZXvYRAOS6EwuxT2ixz3LDss3z0WOg6fRtkWos0V237aBHKe18HI2pWD3Hgxk/zFzHl1PpPx6DMY7QT0K0wmuJa6bQ6Hed/vTMng1eB6aPmYATayUUOSPQHltX3J/sRdIN9/PcMwS+p/X2JR5Of4ZVn5ABWRBii8ToYqEulSAtk85WsUHhBA5c0M7yIKGRHssgmSWQbZuc16WXaPo7W581wwPBHk1KfQZyJRNslUJ5dVWRqBklqsGsufnGdwFe/fRNkphe7BqPb9uGO7SpTe4QEeTieLgljymSe6EmiKUbv5ifroJ+PySdKzm6YuTGlaXNd4SSfk+4FFDhiImUZbCf/DJ3Q/sgngAZWUg57Pxn8KQ0H0/GJjbfuBk8Cn1TlYBV/Vcpss0BAG20hN5HZhchGau+V82zL9w=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00582511-a463-4504-df8d-08d6cc8a1850
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:04:40.9233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVjbGFyZSBtYWNyb2VzIGFuZCBuaWMgZmllbGRzIHRvIHN1cHBvcnQgbGluayBpbnRlcnJ1cHQN
CmhhbmRsaW5nDQoNClNpZ25lZC1vZmYtYnk6IE5pa2l0YSBEYW5pbG92IDxuZGFuaWxvdkBhcXVh
bnRpYS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFx
dWFudGlhLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX2h3LmggIHwgMiArKw0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX25pYy5oIHwgMyArKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEv
YXRsYW50aWMvYXFfaHcuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX2h3LmgNCmluZGV4IGYxYmM5NmM2ZjNiOS4uOTVmZDZjODUyYTlkIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfaHcuaA0KKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfaHcuaA0KQEAgLTg4LDYgKzg4
LDggQEAgc3RydWN0IGFxX3N0YXRzX3Mgew0KICNkZWZpbmUgQVFfSFdfSVJRX01TSSAgICAgMlUN
CiAjZGVmaW5lIEFRX0hXX0lSUV9NU0lYICAgIDNVDQogDQorI2RlZmluZSBBUV9IV19TRVJWSUNF
X0lSUVMgICAxVQ0KKw0KICNkZWZpbmUgQVFfSFdfUE9XRVJfU1RBVEVfRDAgICAwVQ0KICNkZWZp
bmUgQVFfSFdfUE9XRVJfU1RBVEVfRDMgICAzVQ0KIA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5oIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmgNCmluZGV4IGIxMzcyNDMwZjYyZi4uMDQwOWNm
NWNhM2FiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50
aWMvYXFfbmljLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGlj
L2FxX25pYy5oDQpAQCAtMjYsNyArMjYsOCBAQCBzdHJ1Y3QgYXFfbmljX2NmZ19zIHsNCiAJdTY0
IGZlYXR1cmVzOw0KIAl1MzIgcnhkczsJCS8qIHJ4IHJpbmcgc2l6ZSwgZGVzY3JpcHRvcnMgIyAq
Lw0KIAl1MzIgdHhkczsJCS8qIHR4IHJpbmcgc2l6ZSwgZGVzY3JpcHRvcnMgIyAqLw0KLQl1MzIg
dmVjczsJCS8qIHZlY3M9PWFsbG9jYXRlZCBpcnFzICovDQorCXUzMiB2ZWNzOwkJLyogYWxsb2Nh
dGVkIHJ4L3R4IHZlY3RvcnMgKi8NCisJdTMyIGxpbmtfaXJxX3ZlYzsNCiAJdTMyIGlycV90eXBl
Ow0KIAl1MzIgaXRyOw0KIAl1MTYgcnhfaXRyOw0KLS0gDQoyLjE3LjENCg0K
