Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756D521F07
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfEQUUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:20:01 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729201AbfEQUUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRwiwWhL0JfAvo3mqfD8ZuZitOkVIjqEaW2yWl2W5WU=;
 b=SKZWH7qG8yM1pPoEB8czZaJ7uKPAl24L/bPOP4tnDru15WZDa4loPjwezdLiuR6+Msbma5IMJI+MUQnw74yVPtAkXWORogDYqRacejjFfxkSNc/UIKNhBV1ZDnRR2qk4ManNfAQRHk/qjIHZBbU0bJSNnRzNDIp2mq0czQz4PTA=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:51 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/11] net/mlx5e: Fix ethtool rxfh commands when
 CONFIG_MLX5_EN_RXNFC is disabled
Thread-Topic: [net 06/11] net/mlx5e: Fix ethtool rxfh commands when
 CONFIG_MLX5_EN_RXNFC is disabled
Thread-Index: AQHVDO3hl3bZWzRJdkiOsBmzfnOJPw==
Date:   Fri, 17 May 2019 20:19:50 +0000
Message-ID: <20190517201910.32216-7-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11084717-958c-41a6-1dc1-08d6db0500ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB61386C1C38D9DA103F615DD0BE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AbeRT1AsABFXo4rlNxyp6J5KcKz7t1mOc+B3oIkaK2rFjcPVp8YSeiN45HoDmfvBf8F2r8bqo+HAqGRxv40zifcKEVsSfANAEQE84WCECAI02viOsDF+QmPvnSnoHnuFZRlhgSEtA2yqPoqFmuunfo1qbTqnV5O32o/GwROqDjyouCOtEdJvMVf0M5gQOQsYwHq7gXonf0T5FNI+MW/7nAa1DlXl3QOajqjrzyQxFOp2UNZbFHrnaWxXGeGuk7GvcApjOHEFyUANPFBaqoabIdsK7HYjrewqSzHUa9GsZtYWqDeewBgxFkW8G+lCTk5SgRZHK121HmSfx/coZEP1mT9QkXKUG5NQP4zKdDL9IBWX1l+U26ZNMsZoXCSNTbS038RyeH6CCa0N0baGARqyO9FYQeaCjHJTVb+9ckNxCzc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11084717-958c-41a6-1dc1-08d6db0500ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:50.8309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZXRodG9vbCB1c2VyIHNwYWNlcyBuZWVkcyB0byBrbm93IHJpbmcgY291bnQgdmlhIEVUSFRPT0xf
R1JYUklOR1Mgd2hlbg0KZXhlY3V0aW5nIChldGh0b29sIC14KSB3aGljaCBpcyByZXRyaWV2ZWQg
dmlhIGV0aHRvb2wgZ2V0X3J4bmZjIGNhbGxiYWNrLA0KaW4gbWx4NSB0aGlzIGNhbGxiYWNrIGlz
IGRpc2FibGVkIHdoZW4gQ09ORklHX01MWDVfRU5fUlhORkM9bi4NCg0KVGhpcyBwYXRjaCBhbGxv
d3Mgb25seSBFVEhUT09MX0dSWFJJTkdTIGNvbW1hbmQgb24gbWx4NWVfZ2V0X3J4bmZjKCkgd2hl
bg0KQ09ORklHX01MWDVfRU5fUlhORkMgaXMgZGlzYWJsZWQsIHNvIGV0aHRvb2wgLXggd2lsbCBj
b250aW51ZSB3b3JraW5nLg0KDQpGaXhlczogZmU2ZDg2YjNjMzE2ICgibmV0L21seDVlOiBBZGQg
Q09ORklHX01MWDVfRU5fUlhORkMgZm9yIGV0aHRvb2wgcnggbmZjIikNClNpZ25lZC1vZmYtYnk6
IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9ldGh0b29sLmMgICB8IDE4ICsrKysrKysrKysrKysrKysr
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRo
dG9vbC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2V0aHRv
b2wuYw0KaW5kZXggN2VmYWE1OGFlMDM0Li5kZDc2NGUwNDcxZjIgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jDQorKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jDQpAQCAt
MTkwMSw2ICsxOTAxLDIyIEBAIHN0YXRpYyBpbnQgbWx4NWVfZmxhc2hfZGV2aWNlKHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYsDQogCXJldHVybiBtbHg1ZV9ldGh0b29sX2ZsYXNoX2RldmljZShwcml2
LCBmbGFzaCk7DQogfQ0KIA0KKyNpZm5kZWYgQ09ORklHX01MWDVfRU5fUlhORkMNCisvKiBXaGVu
IENPTkZJR19NTFg1X0VOX1JYTkZDPW4gd2Ugb25seSBzdXBwb3J0IEVUSFRPT0xfR1JYUklOR1MN
CisgKiBvdGhlcndpc2UgdGhpcyBmdW5jdGlvbiB3aWxsIGJlIGRlZmluZWQgZnJvbSBlbl9mc19l
dGh0b29sLmMNCisgKi8NCitzdGF0aWMgaW50IG1seDVlX2dldF9yeG5mYyhzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LCBzdHJ1Y3QgZXRodG9vbF9yeG5mYyAqaW5mbywgdTMyICpydWxlX2xvY3MpDQor
ew0KKwlzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQorDQorCWlm
IChpbmZvLT5jbWQgIT0gRVRIVE9PTF9HUlhSSU5HUykNCisJCXJldHVybiAtRU9QTk9UU1VQUDsN
CisJLyogcmluZ19jb3VudCBpcyBuZWVkZWQgYnkgZXRodG9vbCAteCAqLw0KKwlpbmZvLT5kYXRh
ID0gcHJpdi0+Y2hhbm5lbHMucGFyYW1zLm51bV9jaGFubmVsczsNCisJcmV0dXJuIDA7DQorfQ0K
KyNlbmRpZg0KKw0KIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBtbHg1ZV9ldGh0b29sX29wcyA9
IHsNCiAJLmdldF9kcnZpbmZvICAgICAgID0gbWx4NWVfZ2V0X2RydmluZm8sDQogCS5nZXRfbGlu
ayAgICAgICAgICA9IGV0aHRvb2xfb3BfZ2V0X2xpbmssDQpAQCAtMTkxOSw4ICsxOTM1LDggQEAg
Y29uc3Qgc3RydWN0IGV0aHRvb2xfb3BzIG1seDVlX2V0aHRvb2xfb3BzID0gew0KIAkuZ2V0X3J4
ZmhfaW5kaXJfc2l6ZSA9IG1seDVlX2dldF9yeGZoX2luZGlyX3NpemUsDQogCS5nZXRfcnhmaCAg
ICAgICAgICA9IG1seDVlX2dldF9yeGZoLA0KIAkuc2V0X3J4ZmggICAgICAgICAgPSBtbHg1ZV9z
ZXRfcnhmaCwNCi0jaWZkZWYgQ09ORklHX01MWDVfRU5fUlhORkMNCiAJLmdldF9yeG5mYyAgICAg
ICAgID0gbWx4NWVfZ2V0X3J4bmZjLA0KKyNpZmRlZiBDT05GSUdfTUxYNV9FTl9SWE5GQw0KIAku
c2V0X3J4bmZjICAgICAgICAgPSBtbHg1ZV9zZXRfcnhuZmMsDQogI2VuZGlmDQogCS5mbGFzaF9k
ZXZpY2UgICAgICA9IG1seDVlX2ZsYXNoX2RldmljZSwNCi0tIA0KMi4yMS4wDQoNCg==
