Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3411E20300
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfEPJ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:59:19 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:25221
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727176AbfEPJ7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 05:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLLDSRV3y7e5lrpnJH7HIpdQYx0qclSzKp9Fk5Y13Zs=;
 b=UZ5zokavRNdso/FrVWWMMnYqOmhi6AfLuVd4kWuBFin9wW+eBnm8XuuwkosC8somX5/m7OFfBClytX3as46JKaQbhiyo6lOpKRcnrLEjHZ5RhdtXUVephkv3T2OwY139bdN68PW3+uW3mzdnKD2ETDqXrJ+X76UTZPGrXNPG9tU=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2445.eurprd04.prod.outlook.com (10.168.64.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.24; Thu, 16 May 2019 09:59:12 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 09:59:12 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: [PATCH 2/3] enetc: add get_ts_info interface for ethtool
Thread-Topic: [PATCH 2/3] enetc: add get_ts_info interface for ethtool
Thread-Index: AQHVC84DvLvigxLxdka8Zo2g31ppjA==
Date:   Thu, 16 May 2019 09:59:12 +0000
Message-ID: <20190516100028.48256-3-yangbo.lu@nxp.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
In-Reply-To: <20190516100028.48256-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR0302CA0017.apcprd03.prod.outlook.com
 (2603:1096:202::27) To VI1PR0401MB2237.eurprd04.prod.outlook.com
 (2603:10a6:800:27::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c0328c9-4c9d-4e75-6b4a-08d6d9e525b2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2445;
x-ms-traffictypediagnostic: VI1PR0401MB2445:
x-microsoft-antispam-prvs: <VI1PR0401MB2445171404A8973A05AD27C3F80A0@VI1PR0401MB2445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(376002)(136003)(396003)(346002)(199004)(189003)(6506007)(99286004)(386003)(14454004)(76176011)(52116002)(5660300002)(54906003)(4326008)(478600001)(316002)(102836004)(66066001)(6116002)(3846002)(2906002)(68736007)(36756003)(71200400001)(8936002)(53936002)(256004)(64756008)(66556008)(66476007)(73956011)(66446008)(66946007)(486006)(6512007)(7736002)(446003)(8676002)(186003)(11346002)(476003)(2616005)(71190400001)(305945005)(2501003)(25786009)(26005)(86362001)(6436002)(6486002)(110136005)(81156014)(81166006)(50226002)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2445;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ztUmhjM1CtSH5CL/w+LElH531bkKN+iWk5V50WsejTH2RjvomM1Nhlr2TTspNNiZlqthRyqfLvyjwEqsIGhHef0lCNwlcw0Gy+/vjY1OzgZLn5tjogAPq72U3CkEJNC1/vOsB/ys7H4UlruKY5hz8XeVfinPLyuobjFK7F56JBA2hLFmlxdySNeN3w7ETnio6X8W0iwIKSCE+GwLR2aoj0l3g1IjR+V4C1lMnv7Iec+aDRXH4PjCI8V99UY5rglq9l4IsT/itA/IUYeCPD4fu3ENdVkQM5x+DtCFXV1UZBp+jC83WsYjpoSq/CSpdtc4F/zW/l56FOX64iQx8xKgYQsEiH+zR0KAr8acxV7x/2oIVVM8j4jxAwIKjOcQMthYtJRWtXo+L0J+puiLlHPKH5t8JhCup1QimEXVriZxsIE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0328c9-4c9d-4e75-6b4a-08d6d9e525b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 09:59:12.7355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCBpcyB0byBhZGQgZ2V0X3RzX2luZm8gaW50ZXJmYWNlIGZvciBldGh0b29sDQp0
byBzdXBwb3J0IGdldHRpbmcgdGltZXN0YW1waW5nIGNhcGFiaWxpdHkuDQoNClNpZ25lZC1vZmYt
Ynk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGMuaCAgfCAgMyArKw0KIC4uLi9ldGhlcm5ldC9mcmVl
c2NhbGUvZW5ldGMvZW5ldGNfZXRodG9vbC5jICB8IDMxICsrKysrKysrKysrKysrKysrKysNCiAu
Li4vbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19wdHAuYyAgfCAgNSArKysNCiAz
IGZpbGVzIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5oIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjLmgNCmluZGV4IDhjNjNlYTI1M2FiMi4uZWI3Y2M3NmRj
MGMwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2Vu
ZXRjLmgNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5o
DQpAQCAtMjA4LDYgKzIwOCw5IEBAIHN0cnVjdCBlbmV0Y19tc2dfY21kX3NldF9wcmltYXJ5X21h
YyB7DQogDQogI2RlZmluZSBFTkVUQ19DQkRSX1RJTUVPVVQJMTAwMCAvKiB1c2VjcyAqLw0KIA0K
Ky8qIFBUUCBkcml2ZXIgZXhwb3J0cyAqLw0KK2V4dGVybiBpbnQgZW5ldGNfcGhjX2luZGV4Ow0K
Kw0KIC8qIFNJIGNvbW1vbiAqLw0KIGludCBlbmV0Y19wY2lfcHJvYmUoc3RydWN0IHBjaV9kZXYg
KnBkZXYsIGNvbnN0IGNoYXIgKm5hbWUsIGludCBzaXplb2ZfcHJpdik7DQogdm9pZCBlbmV0Y19w
Y2lfcmVtb3ZlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfZXRodG9vbC5jIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2V0aHRvb2wuYw0KaW5kZXggMWVjYWQ5ZmZh
YmFlLi5lMmU1YTBjYThjNDcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZW5ldGMvZW5ldGNfZXRodG9vbC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZW5ldGMvZW5ldGNfZXRodG9vbC5jDQpAQCAtNTU1LDYgKzU1NSwzNSBAQCBzdGF0
aWMgdm9pZCBlbmV0Y19nZXRfcmluZ3BhcmFtKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KIAl9
DQogfQ0KIA0KK3N0YXRpYyBpbnQgZW5ldGNfZ2V0X3RzX2luZm8oc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYsDQorCQkJICAgICBzdHJ1Y3QgZXRodG9vbF90c19pbmZvICppbmZvKQ0KK3sNCisJaW50
ICpwaGNfaWR4Ow0KKw0KKwlwaGNfaWR4ID0gc3ltYm9sX2dldChlbmV0Y19waGNfaW5kZXgpOw0K
KwlpZiAocGhjX2lkeCkgew0KKwkJaW5mby0+cGhjX2luZGV4ID0gKnBoY19pZHg7DQorCQlzeW1i
b2xfcHV0KGVuZXRjX3BoY19pbmRleCk7DQorCX0gZWxzZSB7DQorCQlpbmZvLT5waGNfaW5kZXgg
PSAtMTsNCisJfQ0KKw0KKyNpZmRlZiBDT05GSUdfRlNMX0VORVRDX0hXX1RJTUVTVEFNUElORw0K
KwlpbmZvLT5zb190aW1lc3RhbXBpbmcgPSBTT0ZfVElNRVNUQU1QSU5HX1RYX0hBUkRXQVJFIHwN
CisJCQkJU09GX1RJTUVTVEFNUElOR19SWF9IQVJEV0FSRSB8DQorCQkJCVNPRl9USU1FU1RBTVBJ
TkdfUkFXX0hBUkRXQVJFOw0KKw0KKwlpbmZvLT50eF90eXBlcyA9ICgxIDw8IEhXVFNUQU1QX1RY
X09GRikgfA0KKwkJCSAoMSA8PCBIV1RTVEFNUF9UWF9PTik7DQorCWluZm8tPnJ4X2ZpbHRlcnMg
PSAoMSA8PCBIV1RTVEFNUF9GSUxURVJfTk9ORSkgfA0KKwkJCSAgICgxIDw8IEhXVFNUQU1QX0ZJ
TFRFUl9BTEwpOw0KKyNlbHNlDQorCWluZm8tPnNvX3RpbWVzdGFtcGluZyA9IFNPRl9USU1FU1RB
TVBJTkdfUlhfU09GVFdBUkUgfA0KKwkJCQlTT0ZfVElNRVNUQU1QSU5HX1NPRlRXQVJFOw0KKyNl
bmRpZg0KKwlyZXR1cm4gMDsNCit9DQorDQogc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29w
cyBlbmV0Y19wZl9ldGh0b29sX29wcyA9IHsNCiAJLmdldF9yZWdzX2xlbiA9IGVuZXRjX2dldF9y
ZWdsZW4sDQogCS5nZXRfcmVncyA9IGVuZXRjX2dldF9yZWdzLA0KQEAgLTU3MCw2ICs1OTksNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IGV0aHRvb2xfb3BzIGVuZXRjX3BmX2V0aHRvb2xfb3BzID0g
ew0KIAkuZ2V0X3JpbmdwYXJhbSA9IGVuZXRjX2dldF9yaW5ncGFyYW0sDQogCS5nZXRfbGlua19r
c2V0dGluZ3MgPSBwaHlfZXRodG9vbF9nZXRfbGlua19rc2V0dGluZ3MsDQogCS5zZXRfbGlua19r
c2V0dGluZ3MgPSBwaHlfZXRodG9vbF9zZXRfbGlua19rc2V0dGluZ3MsDQorCS5nZXRfdHNfaW5m
byA9IGVuZXRjX2dldF90c19pbmZvLA0KIH07DQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0
b29sX29wcyBlbmV0Y192Zl9ldGh0b29sX29wcyA9IHsNCkBAIC01ODQsNiArNjE0LDcgQEAgc3Rh
dGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBlbmV0Y192Zl9ldGh0b29sX29wcyA9IHsNCiAJ
LmdldF9yeGZoID0gZW5ldGNfZ2V0X3J4ZmgsDQogCS5zZXRfcnhmaCA9IGVuZXRjX3NldF9yeGZo
LA0KIAkuZ2V0X3JpbmdwYXJhbSA9IGVuZXRjX2dldF9yaW5ncGFyYW0sDQorCS5nZXRfdHNfaW5m
byA9IGVuZXRjX2dldF90c19pbmZvLA0KIH07DQogDQogdm9pZCBlbmV0Y19zZXRfZXRodG9vbF9v
cHMoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3B0cC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3B0cC5jDQppbmRleCA4YzE0OTdlN2Q5YzUuLjJmZDI1ODZl
NDJiZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9l
bmV0Y19wdHAuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2Vu
ZXRjX3B0cC5jDQpAQCAtNyw2ICs3LDkgQEANCiANCiAjaW5jbHVkZSAiZW5ldGMuaCINCiANCitp
bnQgZW5ldGNfcGhjX2luZGV4ID0gLTE7DQorRVhQT1JUX1NZTUJPTChlbmV0Y19waGNfaW5kZXgp
Ow0KKw0KIHN0YXRpYyBzdHJ1Y3QgcHRwX2Nsb2NrX2luZm8gZW5ldGNfcHRwX2NhcHMgPSB7DQog
CS5vd25lcgkJPSBUSElTX01PRFVMRSwNCiAJLm5hbWUJCT0gIkVORVRDIFBUUCBjbG9jayIsDQpA
QCAtOTYsNiArOTksNyBAQCBzdGF0aWMgaW50IGVuZXRjX3B0cF9wcm9iZShzdHJ1Y3QgcGNpX2Rl
diAqcGRldiwNCiAJaWYgKGVycikNCiAJCWdvdG8gZXJyX25vX2Nsb2NrOw0KIA0KKwllbmV0Y19w
aGNfaW5kZXggPSBwdHBfcW9yaXEtPnBoY19pbmRleDsNCiAJcGNpX3NldF9kcnZkYXRhKHBkZXYs
IHB0cF9xb3JpcSk7DQogDQogCXJldHVybiAwOw0KQEAgLTExOSw2ICsxMjMsNyBAQCBzdGF0aWMg
dm9pZCBlbmV0Y19wdHBfcmVtb3ZlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KIHsNCiAJc3RydWN0
IHB0cF9xb3JpcSAqcHRwX3FvcmlxID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KIA0KKwllbmV0
Y19waGNfaW5kZXggPSAtMTsNCiAJcHRwX3FvcmlxX2ZyZWUocHRwX3FvcmlxKTsNCiAJa2ZyZWUo
cHRwX3FvcmlxKTsNCiANCi0tIA0KMi4xNy4xDQoNCg==
