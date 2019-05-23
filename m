Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE69E2746B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfEWCdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:33:37 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:41863
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729758AbfEWCdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 22:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2q4ra9q9Nu35Cwmly5OuixyVs7lPBjEwxFSSaLG/VE=;
 b=d3IwBZhGIp6BGCs3U9uYXl6xM5fwa2z0rMgOaBWYuMAzdubEF+6po8t9MZrBEzWOl/cFB5Sfv5Gd1AnXFTdSwBx/72NLtH5hH57/x5hnGATkteJRh8h+tdzCafZKyN7oJ89ulmrOBGXwtu77yMRraBqpI7NNsvXNGFHQc9AQ09s=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2494.eurprd04.prod.outlook.com (10.168.65.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 02:33:33 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1922.016; Thu, 23 May 2019
 02:33:33 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: [PATCH net-next v2, 2/4] enetc: add get_ts_info interface for ethtool
Thread-Topic: [PATCH net-next v2, 2/4] enetc: add get_ts_info interface for
 ethtool
Thread-Index: AQHVEQ/qWwNzgkPVw0iRjtIX9MK2uQ==
Date:   Thu, 23 May 2019 02:33:33 +0000
Message-ID: <20190523023451.2933-3-yangbo.lu@nxp.com>
References: <20190523023451.2933-1-yangbo.lu@nxp.com>
In-Reply-To: <20190523023451.2933-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK2PR04CA0053.apcprd04.prod.outlook.com
 (2603:1096:202:14::21) To VI1PR0401MB2237.eurprd04.prod.outlook.com
 (2603:10a6:800:27::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5feaf647-1d88-44a0-85bf-08d6df270cbd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2494;
x-ms-traffictypediagnostic: VI1PR0401MB2494:
x-microsoft-antispam-prvs: <VI1PR0401MB2494108FA4C3EE6429733A6BF8010@VI1PR0401MB2494.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(189003)(199004)(2616005)(54906003)(66066001)(86362001)(478600001)(110136005)(26005)(476003)(52116002)(486006)(76176011)(8676002)(66476007)(25786009)(81166006)(81156014)(186003)(66946007)(66556008)(64756008)(66446008)(99286004)(73956011)(2906002)(102836004)(3846002)(6116002)(6512007)(386003)(53936002)(2501003)(6506007)(256004)(36756003)(68736007)(50226002)(305945005)(6486002)(7736002)(8936002)(71200400001)(71190400001)(6636002)(5660300002)(316002)(1076003)(14454004)(446003)(4326008)(11346002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2494;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X6eC/NzyZjLtzXKr56uql+JL9u7c9/T47CpMg6xIYRf12r32FFZj0CTVs4UdRNSbMumgTgfTsIwvdpwFkF5YrWVspqhgDpliAwejJnCpp8ZAXDJ/uGjwnZu1W4Ken9Nsl92xSjCDaCQnpcgPwK23AgpdVOqhpavoy0L/xX86GYi9pNobz0+h8oqImj/OuoldzQ7o6mClMP+A1I0zQmLeWuv567KZzVvocCXGMTpJYd68s+43OjIJjVYgSH21tOJt5jXzMDEENOmdU26VHLCEjjlX1taa6T3Di7cAlhtNyU/BLfVREGs1DevCAnoAFdxOLd7iqRczoYod1xg22o5JrBmAR5cdQRaRhey7s1X6eYTRgPLbIE5/UWVyF757rWEComp0yRWVuxlgJRD7655IWwdT3Ekz4CpAHHB6WyEvzmU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5feaf647-1d88-44a0-85bf-08d6df270cbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 02:33:33.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yangbo.lu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2494
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCBpcyB0byBhZGQgZ2V0X3RzX2luZm8gaW50ZXJmYWNlIGZvciBldGh0b29sDQp0
byBzdXBwb3J0IGdldHRpbmcgdGltZXN0YW1waW5nIGNhcGFiaWxpdHkuDQoNClNpZ25lZC1vZmYt
Ynk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQotLS0NCkNoYW5nZXMgZm9yIHYyOg0K
CS0gTm9uZS4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0
Yy5oICB8ICAzICsrDQogLi4uL2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19ldGh0b29s
LmMgIHwgMzEgKysrKysrKysrKysrKysrKysrKw0KIC4uLi9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2VuZXRjL2VuZXRjX3B0cC5jICB8ICA1ICsrKw0KIDMgZmlsZXMgY2hhbmdlZCwgMzkgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Vu
ZXRjL2VuZXRjLmggYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGMu
aA0KaW5kZXggMjgxYmI0MzY4Yjk4Li5lYTQ0MzI2OGJmNzAgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGMuaA0KKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjLmgNCkBAIC0yMDksNiArMjA5LDkgQEAgc3Ry
dWN0IGVuZXRjX21zZ19jbWRfc2V0X3ByaW1hcnlfbWFjIHsNCiANCiAjZGVmaW5lIEVORVRDX0NC
RFJfVElNRU9VVAkxMDAwIC8qIHVzZWNzICovDQogDQorLyogUFRQIGRyaXZlciBleHBvcnRzICov
DQorZXh0ZXJuIGludCBlbmV0Y19waGNfaW5kZXg7DQorDQogLyogU0kgY29tbW9uICovDQogaW50
IGVuZXRjX3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3QgY2hhciAqbmFtZSwg
aW50IHNpemVvZl9wcml2KTsNCiB2b2lkIGVuZXRjX3BjaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYg
KnBkZXYpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0
Yy9lbmV0Y19ldGh0b29sLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMv
ZW5ldGNfZXRodG9vbC5jDQppbmRleCBiOTUxOWI2YWQ3MjcuLmZjYjUyZWZlYzA3NSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19ldGh0b29s
LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19ldGh0
b29sLmMNCkBAIC01NTUsNiArNTU1LDM1IEBAIHN0YXRpYyB2b2lkIGVuZXRjX2dldF9yaW5ncGFy
YW0oc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsDQogCX0NCiB9DQogDQorc3RhdGljIGludCBlbmV0
Y19nZXRfdHNfaW5mbyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwNCisJCQkgICAgIHN0cnVjdCBl
dGh0b29sX3RzX2luZm8gKmluZm8pDQorew0KKwlpbnQgKnBoY19pZHg7DQorDQorCXBoY19pZHgg
PSBzeW1ib2xfZ2V0KGVuZXRjX3BoY19pbmRleCk7DQorCWlmIChwaGNfaWR4KSB7DQorCQlpbmZv
LT5waGNfaW5kZXggPSAqcGhjX2lkeDsNCisJCXN5bWJvbF9wdXQoZW5ldGNfcGhjX2luZGV4KTsN
CisJfSBlbHNlIHsNCisJCWluZm8tPnBoY19pbmRleCA9IC0xOw0KKwl9DQorDQorI2lmZGVmIENP
TkZJR19GU0xfRU5FVENfSFdfVElNRVNUQU1QSU5HDQorCWluZm8tPnNvX3RpbWVzdGFtcGluZyA9
IFNPRl9USU1FU1RBTVBJTkdfVFhfSEFSRFdBUkUgfA0KKwkJCQlTT0ZfVElNRVNUQU1QSU5HX1JY
X0hBUkRXQVJFIHwNCisJCQkJU09GX1RJTUVTVEFNUElOR19SQVdfSEFSRFdBUkU7DQorDQorCWlu
Zm8tPnR4X3R5cGVzID0gKDEgPDwgSFdUU1RBTVBfVFhfT0ZGKSB8DQorCQkJICgxIDw8IEhXVFNU
QU1QX1RYX09OKTsNCisJaW5mby0+cnhfZmlsdGVycyA9ICgxIDw8IEhXVFNUQU1QX0ZJTFRFUl9O
T05FKSB8DQorCQkJICAgKDEgPDwgSFdUU1RBTVBfRklMVEVSX0FMTCk7DQorI2Vsc2UNCisJaW5m
by0+c29fdGltZXN0YW1waW5nID0gU09GX1RJTUVTVEFNUElOR19SWF9TT0ZUV0FSRSB8DQorCQkJ
CVNPRl9USU1FU1RBTVBJTkdfU09GVFdBUkU7DQorI2VuZGlmDQorCXJldHVybiAwOw0KK30NCisN
CiBzdGF0aWMgY29uc3Qgc3RydWN0IGV0aHRvb2xfb3BzIGVuZXRjX3BmX2V0aHRvb2xfb3BzID0g
ew0KIAkuZ2V0X3JlZ3NfbGVuID0gZW5ldGNfZ2V0X3JlZ2xlbiwNCiAJLmdldF9yZWdzID0gZW5l
dGNfZ2V0X3JlZ3MsDQpAQCAtNTcxLDYgKzYwMCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZXRo
dG9vbF9vcHMgZW5ldGNfcGZfZXRodG9vbF9vcHMgPSB7DQogCS5nZXRfbGlua19rc2V0dGluZ3Mg
PSBwaHlfZXRodG9vbF9nZXRfbGlua19rc2V0dGluZ3MsDQogCS5zZXRfbGlua19rc2V0dGluZ3Mg
PSBwaHlfZXRodG9vbF9zZXRfbGlua19rc2V0dGluZ3MsDQogCS5nZXRfbGluayA9IGV0aHRvb2xf
b3BfZ2V0X2xpbmssDQorCS5nZXRfdHNfaW5mbyA9IGVuZXRjX2dldF90c19pbmZvLA0KIH07DQog
DQogc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBlbmV0Y192Zl9ldGh0b29sX29wcyA9
IHsNCkBAIC01ODYsNiArNjE2LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBl
bmV0Y192Zl9ldGh0b29sX29wcyA9IHsNCiAJLnNldF9yeGZoID0gZW5ldGNfc2V0X3J4ZmgsDQog
CS5nZXRfcmluZ3BhcmFtID0gZW5ldGNfZ2V0X3JpbmdwYXJhbSwNCiAJLmdldF9saW5rID0gZXRo
dG9vbF9vcF9nZXRfbGluaywNCisJLmdldF90c19pbmZvID0gZW5ldGNfZ2V0X3RzX2luZm8sDQog
fTsNCiANCiB2b2lkIGVuZXRjX3NldF9ldGh0b29sX29wcyhzdHJ1Y3QgbmV0X2RldmljZSAqbmRl
dikNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5l
dGNfcHRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcHRw
LmMNCmluZGV4IDhjMTQ5N2U3ZDljNS4uMmZkMjU4NmU0MmJmIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3B0cC5jDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcHRwLmMNCkBAIC03LDYgKzcsOSBA
QA0KIA0KICNpbmNsdWRlICJlbmV0Yy5oIg0KIA0KK2ludCBlbmV0Y19waGNfaW5kZXggPSAtMTsN
CitFWFBPUlRfU1lNQk9MKGVuZXRjX3BoY19pbmRleCk7DQorDQogc3RhdGljIHN0cnVjdCBwdHBf
Y2xvY2tfaW5mbyBlbmV0Y19wdHBfY2FwcyA9IHsNCiAJLm93bmVyCQk9IFRISVNfTU9EVUxFLA0K
IAkubmFtZQkJPSAiRU5FVEMgUFRQIGNsb2NrIiwNCkBAIC05Niw2ICs5OSw3IEBAIHN0YXRpYyBp
bnQgZW5ldGNfcHRwX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KIAlpZiAoZXJyKQ0KIAkJ
Z290byBlcnJfbm9fY2xvY2s7DQogDQorCWVuZXRjX3BoY19pbmRleCA9IHB0cF9xb3JpcS0+cGhj
X2luZGV4Ow0KIAlwY2lfc2V0X2RydmRhdGEocGRldiwgcHRwX3FvcmlxKTsNCiANCiAJcmV0dXJu
IDA7DQpAQCAtMTE5LDYgKzEyMyw3IEBAIHN0YXRpYyB2b2lkIGVuZXRjX3B0cF9yZW1vdmUoc3Ry
dWN0IHBjaV9kZXYgKnBkZXYpDQogew0KIAlzdHJ1Y3QgcHRwX3FvcmlxICpwdHBfcW9yaXEgPSBw
Y2lfZ2V0X2RydmRhdGEocGRldik7DQogDQorCWVuZXRjX3BoY19pbmRleCA9IC0xOw0KIAlwdHBf
cW9yaXFfZnJlZShwdHBfcW9yaXEpOw0KIAlrZnJlZShwdHBfcW9yaXEpOw0KIA0KLS0gDQoyLjE3
LjENCg0K
