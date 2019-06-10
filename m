Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5833BFF9
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbfFJXiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:20 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:50500
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390773AbfFJXiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJn1M24rEMVs79u/cIy1nScJoBZ0sobEUWxzw/4Sge0=;
 b=FxIjZHZAZ74zJnxRnJzZfCLDrMwPf+VW7uzcZCB0PARiBIyuCYEE4K4s+Ob2GP6G35iNM60jUFj8ibwucOZpUoHNsfJiBKsmVpk0hCOFZsI7vguDQ268es4MY65L/7999ze6PCQod1+2cTFBbgeW+GDzMNVGKVKv5IvoWKZetRs=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:14 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: [PATCH mlx5-next 01/16] net/mlx5: Increase wait time for fw
 initialization
Thread-Topic: [PATCH mlx5-next 01/16] net/mlx5: Increase wait time for fw
 initialization
Thread-Index: AQHVH+WSl/uduzR7XUCraJHVcPKRZQ==
Date:   Mon, 10 Jun 2019 23:38:14 +0000
Message-ID: <20190610233733.12155-2-saeedm@mellanox.com>
References: <20190610233733.12155-1-saeedm@mellanox.com>
In-Reply-To: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eff966c0-49d7-407c-fe76-08d6edfcb487
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB2166C142137D5BEEE96723C7BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(136003)(366004)(199004)(189003)(26005)(71190400001)(76176011)(386003)(7736002)(6506007)(73956011)(66556008)(102836004)(86362001)(66476007)(66946007)(107886003)(71200400001)(305945005)(5660300002)(64756008)(66446008)(316002)(68736007)(66066001)(1076003)(6636002)(110136005)(3846002)(54906003)(6116002)(36756003)(186003)(2616005)(81166006)(256004)(85306007)(450100002)(14454004)(50226002)(53936002)(6512007)(52116002)(25786009)(8936002)(8676002)(476003)(99286004)(6486002)(4326008)(81156014)(478600001)(2906002)(446003)(11346002)(6436002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jELOEdsN6o97EgcXwSQxxPOqAPghk7+p1Eo7Aw9eUg2nPxRElaR/9Yt9Ph603tFUi3GTk4Li/cUDJ6pcy+EGvI9DmKCneg6nk2ShG0r1E6sncXuBMI16twT9UagG+FTwFJP4O+xQ9O6fuXPST4EQ/XbHoSCnEVKRbgP58SC90jefLWmFZUFeH6j625j5S+H7a3Nt3dnjXeVu8ofubcwdMWKl4HgnjZ6ORisoHdzCMCTdPS7ZtqaQGl4dxvxfGoDZpSKTM1aK4nMyb9T/DQfADpNdZIY9avVYYPDA2pImZ5MnT8AFZ3p6raLHu9EnD03PZAIS1HRrrMtHKo5tUqEQpeQ9O6JK1Llz72BmoKH5JXTeqM6k3JZtg8PdU9nIJIHz3Dm0u9KvPs0Aao2pNfBejfS4Oa9CqykjTO0dYjXac7o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff966c0-49d7-407c-fe76-08d6edfcb487
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:14.1981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGFuaWVsIEp1cmdlbnMgPGRhbmllbGpAbWVsbGFub3guY29tPg0KDQpGaXJtd2FyZSBG
TFIgaGFwcGVucyBzZXF1ZW50aWFsbHksIGluIHNvbWUgY2FzZXMsIGxpa2Ugd2hlbiBkZXN0cm95
aW5nDQphIFZNIHRoYXQgaGFkIG1hbnkgVkZzLCBtYXkgcmVxdWlyZSB3YWl0aW5nIG11Y2ggbG9u
Z2VyIHRoYW4gMTAgc2Vjb25kcy4NCkluY3JlYXNlIHRoZSB0aW1lb3V0IHRvIDIgbWludXRlcywg
YW5kIHByaW50IGEgd2FpdCBjb3VudGRvd24gc3RhdHVzDQpldmVyeSAyMCBzZWNvbmRzLg0KDQpT
aWduZWQtb2ZmLWJ5OiBEYW5pZWwgSnVyZ2VucyA8ZGFuaWVsakBtZWxsYW5veC5jb20+DQpTaWdu
ZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgfCAxOCArKysrKysr
KysrKysrKy0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFp
bi5jDQppbmRleCA2MWZhMWQxNjJkMjguLjhlOTZjNDJkM2I4NCAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCkBAIC0xNjksMTggKzE2OSwy
OCBAQCBzdGF0aWMgc3RydWN0IG1seDVfcHJvZmlsZSBwcm9maWxlW10gPSB7DQogDQogI2RlZmlu
ZSBGV19JTklUX1RJTUVPVVRfTUlMSQkJMjAwMA0KICNkZWZpbmUgRldfSU5JVF9XQUlUX01TCQkJ
Mg0KLSNkZWZpbmUgRldfUFJFX0lOSVRfVElNRU9VVF9NSUxJCTEwMDAwDQorI2RlZmluZSBGV19Q
UkVfSU5JVF9USU1FT1VUX01JTEkJMTIwMDAwDQorI2RlZmluZSBGV19JTklUX1dBUk5fTUVTU0FH
RV9JTlRFUlZBTAkyMDAwMA0KIA0KLXN0YXRpYyBpbnQgd2FpdF9md19pbml0KHN0cnVjdCBtbHg1
X2NvcmVfZGV2ICpkZXYsIHUzMiBtYXhfd2FpdF9taWxpKQ0KK3N0YXRpYyBpbnQgd2FpdF9md19p
bml0KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIHUzMiBtYXhfd2FpdF9taWxpLA0KKwkJCXUz
MiB3YXJuX3RpbWVfbWlsaSkNCiB7DQorCXVuc2lnbmVkIGxvbmcgd2FybiA9IGppZmZpZXMgKyBt
c2Vjc190b19qaWZmaWVzKHdhcm5fdGltZV9taWxpKTsNCiAJdW5zaWduZWQgbG9uZyBlbmQgPSBq
aWZmaWVzICsgbXNlY3NfdG9famlmZmllcyhtYXhfd2FpdF9taWxpKTsNCiAJaW50IGVyciA9IDA7
DQogDQorCUJVSUxEX0JVR19PTihGV19QUkVfSU5JVF9USU1FT1VUX01JTEkgPCBGV19JTklUX1dB
Uk5fTUVTU0FHRV9JTlRFUlZBTCk7DQorDQogCXdoaWxlIChmd19pbml0aWFsaXppbmcoZGV2KSkg
ew0KIAkJaWYgKHRpbWVfYWZ0ZXIoamlmZmllcywgZW5kKSkgew0KIAkJCWVyciA9IC1FQlVTWTsN
CiAJCQlicmVhazsNCiAJCX0NCisJCWlmICh3YXJuX3RpbWVfbWlsaSAmJiB0aW1lX2FmdGVyKGpp
ZmZpZXMsIHdhcm4pKSB7DQorCQkJbWx4NV9jb3JlX3dhcm4oZGV2LCAiV2FpdGluZyBmb3IgRlcg
aW5pdGlhbGl6YXRpb24sIHRpbWVvdXQgYWJvcnQgaW4gJWRzXG4iLA0KKwkJCQkgICAgICAgamlm
Zmllc190b19tc2VjcyhlbmQgLSB3YXJuKSAvIDEwMDApOw0KKwkJCXdhcm4gPSBqaWZmaWVzICsg
bXNlY3NfdG9famlmZmllcyh3YXJuX3RpbWVfbWlsaSk7DQorCQl9DQogCQltc2xlZXAoRldfSU5J
VF9XQUlUX01TKTsNCiAJfQ0KIA0KQEAgLTkxMSw3ICs5MjEsNyBAQCBzdGF0aWMgaW50IG1seDVf
ZnVuY3Rpb25fc2V0dXAoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgYm9vbCBib290KQ0KIA0K
IAkvKiB3YWl0IGZvciBmaXJtd2FyZSB0byBhY2NlcHQgaW5pdGlhbGl6YXRpb24gc2VnbWVudHMg
Y29uZmlndXJhdGlvbnMNCiAJICovDQotCWVyciA9IHdhaXRfZndfaW5pdChkZXYsIEZXX1BSRV9J
TklUX1RJTUVPVVRfTUlMSSk7DQorCWVyciA9IHdhaXRfZndfaW5pdChkZXYsIEZXX1BSRV9JTklU
X1RJTUVPVVRfTUlMSSwgRldfSU5JVF9XQVJOX01FU1NBR0VfSU5URVJWQUwpOw0KIAlpZiAoZXJy
KSB7DQogCQltbHg1X2NvcmVfZXJyKGRldiwgIkZpcm13YXJlIG92ZXIgJWQgTVMgaW4gcHJlLWlu
aXRpYWxpemluZyBzdGF0ZSwgYWJvcnRpbmdcbiIsDQogCQkJICAgICAgRldfUFJFX0lOSVRfVElN
RU9VVF9NSUxJKTsNCkBAIC05MjQsNyArOTM0LDcgQEAgc3RhdGljIGludCBtbHg1X2Z1bmN0aW9u
X3NldHVwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIGJvb2wgYm9vdCkNCiAJCXJldHVybiBl
cnI7DQogCX0NCiANCi0JZXJyID0gd2FpdF9md19pbml0KGRldiwgRldfSU5JVF9USU1FT1VUX01J
TEkpOw0KKwllcnIgPSB3YWl0X2Z3X2luaXQoZGV2LCBGV19JTklUX1RJTUVPVVRfTUlMSSwgMCk7
DQogCWlmIChlcnIpIHsNCiAJCW1seDVfY29yZV9lcnIoZGV2LCAiRmlybXdhcmUgb3ZlciAlZCBN
UyBpbiBpbml0aWFsaXppbmcgc3RhdGUsIGFib3J0aW5nXG4iLA0KIAkJCSAgICAgIEZXX0lOSVRf
VElNRU9VVF9NSUxJKTsNCi0tIA0KMi4yMS4wDQoNCg==
