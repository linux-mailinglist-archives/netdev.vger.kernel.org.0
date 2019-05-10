Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1276119BE2
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfEJKuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 06:50:07 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:55334
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727147AbfEJKuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 06:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVV114eAug8rqbvq7v9yjlC1paYpW2pcWGPnJajI61w=;
 b=J3JJ5zYOHjqMGIdx2EdqEjYEyoD4go5zI/0uPT2e0GfP0eyVJgCxJCIxN3u8m8yB2rd3fE0MOHzu+gEaYjEjR/ZBk2bELQZV1NBiRRZ33Ejr5fpqxk935Jd27IkUt9uINzr9Qz8pQ6WGScCETZdilYXV9QNN13j8jr/t/BJlXvM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5994.eurprd04.prod.outlook.com (20.178.107.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Fri, 10 May 2019 10:49:59 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::dcff:11e1:ab70:bb81%5]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 10:49:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan-gabriel Mirea <stefan-gabriel.mirea@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 2/7] can: flexcan: use struct canfd_frame for normal CAN
 frame
Thread-Topic: [PATCH V3 2/7] can: flexcan: use struct canfd_frame for normal
 CAN frame
Thread-Index: AQHVBx4cUq8ERXV7F0K+WY5MoX51gQ==
Date:   Fri, 10 May 2019 10:49:58 +0000
Message-ID: <20190510104639.15170-3-qiangqing.zhang@nxp.com>
References: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190510104639.15170-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::31) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aca08e7-535d-4b95-8c09-08d6d5353ef3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5994;
x-ms-traffictypediagnostic: DB7PR04MB5994:
x-microsoft-antispam-prvs: <DB7PR04MB5994C098D71203A9E4E67C79E60C0@DB7PR04MB5994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(54534003)(14454004)(11346002)(478600001)(66066001)(4326008)(66556008)(64756008)(66446008)(53936002)(66476007)(8936002)(81166006)(6436002)(81156014)(25786009)(8676002)(1076003)(6486002)(2501003)(6116002)(3846002)(186003)(2906002)(50226002)(305945005)(73956011)(14444005)(71190400001)(6512007)(71200400001)(446003)(66946007)(5660300002)(54906003)(2616005)(476003)(36756003)(86362001)(26005)(110136005)(7736002)(76176011)(102836004)(386003)(68736007)(99286004)(52116002)(6506007)(486006)(256004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5994;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: txeEJsUmpv6tmmjiQo/lzSVo7x/ufH2dzoMSK/jqqL56xWgdXIkR4rJ19K/yNnMgtWH+Lwp2PKScdUFaoZhdCIiV14/la+/XF6w8kEPbkNU43D65bTVm9+Du++4HjXQ/DnwyAjY//TGVZDb/DYAETgY+MqYCbBd2BZMTBPEA3JGKjgMcs4i8yJ9AGfGrOiAzgbBvd/Fx4RimBbSCDntbBKISLr9XyZokrmcDcXgF5WgDlvtaxAR+9DfbrU1j4myMal2LDoDSEoVV1HkrgTWd7emm0CfAwMZ1gToxDLkXp5i09gcWDPCIP31c5EoW+fBHGZHw35eqIIm1PEzN5QVeBKruUEmOPEHBc8lZNg/rCQKg9TW2YfZhIbrzTz+Y6MhY3Xq1jhiCrCmjHAmR55hr+Ogneu8ejNr+kAqypY7kTZE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aca08e7-535d-4b95-8c09-08d6d5353ef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 10:49:58.9327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5994
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCBwcmVwYXJlcyBmb3IgQ0FOIEZEIG1vZGUsIHVzaW5nIHN0cnVjdCBjYW5mZF9m
cmFtZSBjYW4gYm90aA0KZm9yIG5vcm1hbCBmb3JtYXQgZnJhbWUgYW5kIGZkIGZvcm1hdCBmcmFt
ZS4NCg0KU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNv
bT4NCg0KQ2hhbmdlTG9nOg0KLS0tLS0tLS0tLQ0KVjItPlYzOg0KCSpOZXcgcGF0Y2gsIHNwbGl0
IGZyb20gb3RoZXIgcGF0Y2gNCi0tLQ0KIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgICAgfCAx
NCArKysrKysrLS0tLS0tLQ0KIGRyaXZlcnMvbmV0L2Nhbi9yeC1vZmZsb2FkLmMgfCAgNCArKy0t
DQogMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2Zs
ZXhjYW4uYw0KaW5kZXggZjc0MjA3N2U4ZjkzLi4yMmY1YzI4ZmY5OWYgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQorKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5j
DQpAQCAtNjA5LDEwICs2MDksMTAgQEAgc3RhdGljIGludCBmbGV4Y2FuX2dldF9iZXJyX2NvdW50
ZXIoY29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiBzdGF0aWMgbmV0ZGV2X3R4X3QgZmxl
eGNhbl9zdGFydF94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYpDQogew0KIAljb25zdCBzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYo
ZGV2KTsNCi0Jc3RydWN0IGNhbl9mcmFtZSAqY2YgPSAoc3RydWN0IGNhbl9mcmFtZSAqKXNrYi0+
ZGF0YTsNCisJc3RydWN0IGNhbmZkX2ZyYW1lICpjZiA9IChzdHJ1Y3QgY2FuZmRfZnJhbWUgKilz
a2ItPmRhdGE7DQogCXUzMiBjYW5faWQ7DQogCXUzMiBkYXRhOw0KLQl1MzIgY3RybCA9IEZMRVhD
QU5fTUJfQ09ERV9UWF9EQVRBIHwgKGNmLT5jYW5fZGxjIDw8IDE2KTsNCisJdTMyIGN0cmwgPSBG
TEVYQ0FOX01CX0NPREVfVFhfREFUQSB8IChjZi0+bGVuIDw8IDE2KTsNCiAJaW50IGk7DQogDQog
CWlmIChjYW5fZHJvcHBlZF9pbnZhbGlkX3NrYihkZXYsIHNrYikpDQpAQCAtNjMwLDcgKzYzMCw3
IEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBmbGV4Y2FuX3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRlDQogCWlmIChjZi0+Y2FuX2lkICYgQ0FOX1JUUl9G
TEFHKQ0KIAkJY3RybCB8PSBGTEVYQ0FOX01CX0NOVF9SVFI7DQogDQotCWZvciAoaSA9IDA7IGkg
PCBjZi0+Y2FuX2RsYzsgaSArPSBzaXplb2YodTMyKSkgew0KKwlmb3IgKGkgPSAwOyBpIDwgY2Yt
PmxlbjsgaSArPSBzaXplb2YodTMyKSkgew0KIAkJZGF0YSA9IGJlMzJfdG9fY3B1cCgoX19iZTMy
ICopJmNmLT5kYXRhW2ldKTsNCiAJCXByaXYtPndyaXRlKGRhdGEsICZwcml2LT50eF9tYi0+ZGF0
YVtpIC8gc2l6ZW9mKHUzMildKTsNCiAJfQ0KQEAgLTc5Nyw3ICs3OTcsNyBAQCBzdGF0aWMgdW5z
aWduZWQgaW50IGZsZXhjYW5fbWFpbGJveF9yZWFkKHN0cnVjdCBjYW5fcnhfb2ZmbG9hZCAqb2Zm
bG9hZCwgYm9vbCBkcg0KIAlzdHJ1Y3QgZmxleGNhbl9yZWdzIF9faW9tZW0gKnJlZ3MgPSBwcml2
LT5yZWdzOw0KIAlzdHJ1Y3QgZmxleGNhbl9tYiBfX2lvbWVtICptYjsNCiAJdTMyIHJlZ19jdHJs
LCByZWdfaWQsIHJlZ19pZmxhZzE7DQotCXN0cnVjdCBjYW5fZnJhbWUgKmNmOw0KKwlzdHJ1Y3Qg
Y2FuZmRfZnJhbWUgKmNmOw0KIAlpbnQgaTsNCiANCiAJbWIgPSBmbGV4Y2FuX2dldF9tYihwcml2
LCBuKTsNCkBAIC04MjksNyArODI5LDcgQEAgc3RhdGljIHVuc2lnbmVkIGludCBmbGV4Y2FuX21h
aWxib3hfcmVhZChzdHJ1Y3QgY2FuX3J4X29mZmxvYWQgKm9mZmxvYWQsIGJvb2wgZHINCiAJfQ0K
IA0KIAlpZiAoIWRyb3ApDQotCQkqc2tiID0gYWxsb2NfY2FuX3NrYihvZmZsb2FkLT5kZXYsICZj
Zik7DQorCQkqc2tiID0gYWxsb2NfY2FuX3NrYihvZmZsb2FkLT5kZXYsIChzdHJ1Y3QgY2FuX2Zy
YW1lICoqKSZjZik7DQogDQogCWlmICgqc2tiKSB7DQogCQkvKiBpbmNyZWFzZSB0aW1zdGFtcCB0
byBmdWxsIDMyIGJpdCAqLw0KQEAgLTg0Myw5ICs4NDMsOSBAQCBzdGF0aWMgdW5zaWduZWQgaW50
IGZsZXhjYW5fbWFpbGJveF9yZWFkKHN0cnVjdCBjYW5fcnhfb2ZmbG9hZCAqb2ZmbG9hZCwgYm9v
bCBkcg0KIA0KIAkJaWYgKHJlZ19jdHJsICYgRkxFWENBTl9NQl9DTlRfUlRSKQ0KIAkJCWNmLT5j
YW5faWQgfD0gQ0FOX1JUUl9GTEFHOw0KLQkJY2YtPmNhbl9kbGMgPSBnZXRfY2FuX2RsYygocmVn
X2N0cmwgPj4gMTYpICYgMHhmKTsNCisJCWNmLT5sZW4gPSBnZXRfY2FuX2RsYygocmVnX2N0cmwg
Pj4gMTYpICYgMHgwRik7DQogDQotCQlmb3IgKGkgPSAwOyBpIDwgY2YtPmNhbl9kbGM7IGkgKz0g
c2l6ZW9mKHUzMikpIHsNCisJCWZvciAoaSA9IDA7IGkgPCBjZi0+bGVuOyBpICs9IHNpemVvZih1
MzIpKSB7DQogCQkJX19iZTMyIGRhdGEgPSBjcHVfdG9fYmUzMihwcml2LT5yZWFkKCZtYi0+ZGF0
YVtpIC8gc2l6ZW9mKHUzMildKSk7DQogCQkJKihfX2JlMzIgKikoY2YtPmRhdGEgKyBpKSA9IGRh
dGE7DQogCQl9DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL3J4LW9mZmxvYWQuYyBiL2Ry
aXZlcnMvbmV0L2Nhbi9yeC1vZmZsb2FkLmMNCmluZGV4IDYzMjkxOTQ4NGZmNy4uZmU2NGRmZGRj
NWJhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL3J4LW9mZmxvYWQuYw0KKysrIGIvZHJp
dmVycy9uZXQvY2FuL3J4LW9mZmxvYWQuYw0KQEAgLTU1LDExICs1NSwxMSBAQCBzdGF0aWMgaW50
IGNhbl9yeF9vZmZsb2FkX25hcGlfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGludCBx
dW90YSkNCiANCiAJd2hpbGUgKCh3b3JrX2RvbmUgPCBxdW90YSkgJiYNCiAJICAgICAgIChza2Ig
PSBza2JfZGVxdWV1ZSgmb2ZmbG9hZC0+c2tiX3F1ZXVlKSkpIHsNCi0JCXN0cnVjdCBjYW5fZnJh
bWUgKmNmID0gKHN0cnVjdCBjYW5fZnJhbWUgKilza2ItPmRhdGE7DQorCQlzdHJ1Y3QgY2FuZmRf
ZnJhbWUgKmNmID0gKHN0cnVjdCBjYW5mZF9mcmFtZSAqKXNrYi0+ZGF0YTsNCiANCiAJCXdvcmtf
ZG9uZSsrOw0KIAkJc3RhdHMtPnJ4X3BhY2tldHMrKzsNCi0JCXN0YXRzLT5yeF9ieXRlcyArPSBj
Zi0+Y2FuX2RsYzsNCisJCXN0YXRzLT5yeF9ieXRlcyArPSBjZi0+bGVuOw0KIAkJbmV0aWZfcmVj
ZWl2ZV9za2Ioc2tiKTsNCiAJfQ0KIA0KLS0gDQoyLjE3LjENCg0K
