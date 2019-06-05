Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECB0367E9
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfFEXZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:25:02 -0400
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:39078
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbfFEXZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 19:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5k87UTq1xmR+gCNMHgq+wjGM1ey2MjqCKR2qugQRgQ=;
 b=lgEcvl4wbyMl6x688hTr3Igu7DfsrlUqCmSZdhFhGFHKBPnBJRHaeUn0y9F06D1x2rRVNn5eUYfm8zkUDOssktwrN+WXDHwaUV/bWncBKDon3CArRiHyET92DVWgevKyHAgg1EON5OtoMIJ1e52LpERjLq24NqmkrrzO+WSuJJ4=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6105.eurprd05.prod.outlook.com (20.179.10.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 23:24:48 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 23:24:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>
CC:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 7/9] linux/dim: Add completions count to dim_sample
Thread-Topic: [for-next 7/9] linux/dim: Add completions count to dim_sample
Thread-Index: AQHVG/XeSS2GNIe6HEuV009DlJsTcw==
Date:   Wed, 5 Jun 2019 23:24:48 +0000
Message-ID: <20190605232348.6452-8-saeedm@mellanox.com>
References: <20190605232348.6452-1-saeedm@mellanox.com>
In-Reply-To: <20190605232348.6452-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95448b7c-7209-466d-0b00-08d6ea0d0056
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6105;
x-ms-traffictypediagnostic: DB8PR05MB6105:
x-microsoft-antispam-prvs: <DB8PR05MB61058186FC0BE10475A2BA80BE160@DB8PR05MB6105.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:398;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39850400004)(136003)(366004)(376002)(199004)(189003)(4326008)(316002)(5660300002)(2906002)(66946007)(53936002)(186003)(8936002)(66476007)(8676002)(81166006)(66446008)(1076003)(478600001)(86362001)(50226002)(81156014)(66556008)(14454004)(107886003)(6116002)(73956011)(7736002)(305945005)(446003)(11346002)(64756008)(3846002)(14444005)(71190400001)(99286004)(26005)(25786009)(110136005)(71200400001)(486006)(2616005)(68736007)(6512007)(66066001)(6436002)(76176011)(6486002)(54906003)(36756003)(6506007)(386003)(102836004)(256004)(476003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6105;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mrsPeuw6UwR8Zu37DxAHGbgez1lTVL8E07dphKJTvKAgzj+BMA5n7C81eIR4P9v4jmiFjf9fcqlTkZpCzaje/7agLV1Fj9+cokSFre/URBas5jEhKKkO0G1RpczuuiFH2lXqntmhaQjZfDy1fI3mpJMF4VQ2R/wHsSVT07dxSp3waTBqOnBaKYoeBemVIrShu8XndU/4jARqwDeEhOPQcTOk/WcYTAIT9HX943j/4UXibksyA16Sof9rPLMpcG0wSgYTkuOMLbcmBWinqsB9I+khBvuy6vpejdOd4Q2c11xgz3Crn750T/pXOaLDq6gswo8pecXs9wwkgjE5TCOHMQSzQ1RScty0MMSVCAnudaYsmzs8HLrWSxss73KZEvPQ1UXvDEsWSdqlXWHPw3LKMSSdOW7D8m1r3pVZz6WB3uc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95448b7c-7209-466d-0b00-08d6ea0d0056
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 23:24:48.3285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWFtaW4gRnJpZWRtYW4gPHlhbWluZkBtZWxsYW5veC5jb20+DQoNCkFkZGVkIGEgbWVh
c3VyZW1lbnQgb2YgY29tcGxldGlvbnMgcGVyL21zZWMgdG8gYWxsb3cgZm9yIGNvbXBsZXRpb24g
YmFzZWQNCmRpbSBhbGdvcml0aG1zLg0KDQpJbiBvcmRlciB0byB1c2UgZHluYW1pYyBpbnRlcnJ1
cHQgbW9kZXJhdGlvbiB3aXRoIFJETUEgd2UgbmVlZCB0byBoYXZlIGENCmRpZmZlcmVudCBtZWFz
dXJtZW50IHRoYW4gcGFja2V0cyBwZXIgc2Vjb25kLiBUaGlzIGNoYW5nZSBpcyBtZWFudCB0bw0K
cHJlcGFyZSBmb3IgYWRkaW5nIGEgbmV3IERJTSBtZXRob2QuDQoNCkFsbCBkcml2ZXJzIHRoYXQg
dXNlIG5ldF9kaW0gYW5kIHRodXMgZG8gbm90IG5lZWQgYSBjb21wbGV0aW9uIGNvdW50IHdpbGwN
CmhhdmUgdGhlIGNvbXBsZXRpb25zIHNldCB0byAwLg0KDQpTaWduZWQtb2ZmLWJ5OiBZYW1pbiBG
cmllZG1hbiA8eWFtaW5mQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXggR3VydG92b3kg
PG1heGdAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVk
bUBtZWxsYW5veC5jb20+DQotLS0NCiBpbmNsdWRlL2xpbnV4L2RpbS5oIHwgMjggKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLQ0KIGxpYi9kaW0vZGltLmMgICAgICAgfCAgOSArKysrKysrKysN
CiAyIGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2RpbS5oIGIvaW5jbHVkZS9saW51eC9kaW0uaA0KaW5k
ZXggYTZiZjg0ZjYxZGZiLi5lN2IzZjhmNTU0NGQgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4
L2RpbS5oDQorKysgYi9pbmNsdWRlL2xpbnV4L2RpbS5oDQpAQCAtMzcsNiArMzcsNyBAQA0KIHN0
cnVjdCBkaW1fY3FfbW9kZXIgew0KIAl1MTYgdXNlYzsNCiAJdTE2IHBrdHM7DQorCXUxNiBjb21w
czsNCiAJdTggY3FfcGVyaW9kX21vZGU7DQogfTsNCiANCkBAIC01NCw2ICs1NSw3IEBAIHN0cnVj
dCBkaW1fc2FtcGxlIHsNCiAJdTMyIHBrdF9jdHI7DQogCXUzMiBieXRlX2N0cjsNCiAJdTE2IGV2
ZW50X2N0cjsNCisJdTMyIGNvbXBfY3RyOw0KIH07DQogDQogLyoqDQpAQCAtNjUsOSArNjcsMTEg
QEAgc3RydWN0IGRpbV9zYW1wbGUgew0KICAqIEBlcG1zOiBFdmVudHMgcGVyIG1zZWMNCiAgKi8N
CiBzdHJ1Y3QgZGltX3N0YXRzIHsNCi0JaW50IHBwbXM7DQotCWludCBicG1zOw0KLQlpbnQgZXBt
czsNCisJaW50IHBwbXM7IC8qIHBhY2tldHMgcGVyIG1zZWMgKi8NCisJaW50IGJwbXM7IC8qIGJ5
dGVzIHBlciBtc2VjICovDQorCWludCBlcG1zOyAvKiBldmVudHMgcGVyIG1zZWMgKi8NCisJaW50
IGNwbXM7IC8qIGNvbXBsZXRpb25zIHBlciBtc2VjICovDQorCWludCBjcGVfcmF0aW87IC8qIHJh
dGlvIG9mIGNvbXBsZXRpb25zIHRvIGV2ZW50cyAqLw0KIH07DQogDQogLyoqDQpAQCAtODksNiAr
OTMsNyBAQCBzdHJ1Y3QgZGltIHsNCiAJdTggc3RhdGU7DQogCXN0cnVjdCBkaW1fc3RhdHMgcHJl
dl9zdGF0czsNCiAJc3RydWN0IGRpbV9zYW1wbGUgc3RhcnRfc2FtcGxlOw0KKwlzdHJ1Y3QgZGlt
X3NhbXBsZSBtZWFzdXJpbmdfc2FtcGxlOw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsNCiAJ
dTggcHJvZmlsZV9peDsNCiAJdTggbW9kZTsNCkBAIC0yNDYsNCArMjUxLDIxIEBAIGRpbV91cGRh
dGVfc2FtcGxlKHUxNiBldmVudF9jdHIsIHU2NCBwYWNrZXRzLCB1NjQgYnl0ZXMsIHN0cnVjdCBk
aW1fc2FtcGxlICpzKQ0KIAlzLT5ldmVudF9jdHIgPSBldmVudF9jdHI7DQogfQ0KIA0KKy8qKg0K
KyAqCWRpbV91cGRhdGVfc2FtcGxlX3dpdGhfY29tcHMgLSBzZXQgYSBzYW1wbGUncyBmaWVsZHMg
d2l0aCBnaXZlbg0KKyAqCXZhbHVlcyBpbmNsdWRpbmcgdGhlIGNvbXBsZXRpb24gcGFyYW1ldGVy
DQorICoJQGV2ZW50X2N0cjogbnVtYmVyIG9mIGV2ZW50cyB0byBzZXQNCisgKglAcGFja2V0czog
bnVtYmVyIG9mIHBhY2tldHMgdG8gc2V0DQorICoJQGJ5dGVzOiBudW1iZXIgb2YgYnl0ZXMgdG8g
c2V0DQorICoJQGNvbXBzOiBudW1iZXIgb2YgY29tcGxldGlvbnMgdG8gc2V0DQorICoJQHM6IERJ
TSBzYW1wbGUNCisgKi8NCitzdGF0aWMgaW5saW5lIHZvaWQNCitkaW1fdXBkYXRlX3NhbXBsZV93
aXRoX2NvbXBzKHUxNiBldmVudF9jdHIsIHU2NCBwYWNrZXRzLCB1NjQgYnl0ZXMsIHU2NCBjb21w
cywNCisJCQkgICAgIHN0cnVjdCBkaW1fc2FtcGxlICpzKQ0KK3sNCisJZGltX3VwZGF0ZV9zYW1w
bGUoZXZlbnRfY3RyLCBwYWNrZXRzLCBieXRlcywgcyk7DQorCXMtPmNvbXBfY3RyID0gY29tcHM7
DQorfQ0KKw0KICNlbmRpZiAvKiBESU1fSCAqLw0KZGlmZiAtLWdpdCBhL2xpYi9kaW0vZGltLmMg
Yi9saWIvZGltL2RpbS5jDQppbmRleCAxN2Q1MjM2NzU5YmQuLjQzOWQ2NDFlYzc5NiAxMDA2NDQN
Ci0tLSBhL2xpYi9kaW0vZGltLmMNCisrKyBiL2xpYi9kaW0vZGltLmMNCkBAIC02Miw2ICs2Miw4
IEBAIHZvaWQgZGltX2NhbGNfc3RhdHMoc3RydWN0IGRpbV9zYW1wbGUgKnN0YXJ0LCBzdHJ1Y3Qg
ZGltX3NhbXBsZSAqZW5kLA0KIAl1MzIgbnBrdHMgPSBCSVRfR0FQKEJJVFNfUEVSX1RZUEUodTMy
KSwgZW5kLT5wa3RfY3RyLCBzdGFydC0+cGt0X2N0cik7DQogCXUzMiBuYnl0ZXMgPSBCSVRfR0FQ
KEJJVFNfUEVSX1RZUEUodTMyKSwgZW5kLT5ieXRlX2N0ciwNCiAJCQkgICAgIHN0YXJ0LT5ieXRl
X2N0cik7DQorCXUzMiBuY29tcHMgPSBCSVRfR0FQKEJJVFNfUEVSX1RZUEUodTMyKSwgZW5kLT5j
b21wX2N0ciwNCisJCQkgICAgIHN0YXJ0LT5jb21wX2N0cik7DQogDQogCWlmICghZGVsdGFfdXMp
DQogCQlyZXR1cm47DQpAQCAtNzAsNSArNzIsMTIgQEAgdm9pZCBkaW1fY2FsY19zdGF0cyhzdHJ1
Y3QgZGltX3NhbXBsZSAqc3RhcnQsIHN0cnVjdCBkaW1fc2FtcGxlICplbmQsDQogCWN1cnJfc3Rh
dHMtPmJwbXMgPSBESVZfUk9VTkRfVVAobmJ5dGVzICogVVNFQ19QRVJfTVNFQywgZGVsdGFfdXMp
Ow0KIAljdXJyX3N0YXRzLT5lcG1zID0gRElWX1JPVU5EX1VQKERJTV9ORVZFTlRTICogVVNFQ19Q
RVJfTVNFQywNCiAJCQkJCWRlbHRhX3VzKTsNCisJY3Vycl9zdGF0cy0+Y3BtcyA9IERJVl9ST1VO
RF9VUChuY29tcHMgKiBVU0VDX1BFUl9NU0VDLCBkZWx0YV91cyk7DQorCWlmIChjdXJyX3N0YXRz
LT5lcG1zICE9IDApDQorCQljdXJyX3N0YXRzLT5jcGVfcmF0aW8gPQ0KKwkJCQkoY3Vycl9zdGF0
cy0+Y3BtcyAqIDEwMCkgLyBjdXJyX3N0YXRzLT5lcG1zOw0KKwllbHNlDQorCQljdXJyX3N0YXRz
LT5jcGVfcmF0aW8gPSAwOw0KKw0KIH0NCiBFWFBPUlRfU1lNQk9MKGRpbV9jYWxjX3N0YXRzKTsN
Ci0tIA0KMi4yMS4wDQoNCg==
