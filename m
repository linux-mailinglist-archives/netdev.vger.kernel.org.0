Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65513C68
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 02:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfEEAeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 20:34:31 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:8128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbfEEAea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 20:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/OlQYWUJtd/cztl889oc8qsYvaJBo3i0bSZa1DKiWw=;
 b=aiEmr0Ga/GpadWEVpsmhHv5iQB+zzMt8yvjQ93iu3eWmcBF/hlONZFJschAapX5fuD7ow1Po7IVEBNRhJxeJq1RCSrwuV3Vlm3HVOPBaGnyif3LWXDkP4OyY61IPR4HoTzxI5NuJypujbbzFocY8azdPlaWrgbJTB010GnZVZ5o=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5881.eurprd05.prod.outlook.com (20.179.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Sun, 5 May 2019 00:33:23 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 00:33:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Thread-Topic: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Thread-Index: AQHVAtolLdJJy+/cik2B95xXeBcmGA==
Date:   Sun, 5 May 2019 00:33:23 +0000
Message-ID: <20190505003207.1353-10-saeedm@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
In-Reply-To: <20190505003207.1353-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b367b468-ebd6-40a4-c41c-08d6d0f147e0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5881;
x-ms-traffictypediagnostic: DB8PR05MB5881:
x-microsoft-antispam-prvs: <DB8PR05MB5881BF15FA3E8431EEDEBD2BBE370@DB8PR05MB5881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39850400004)(136003)(396003)(199004)(189003)(305945005)(52116002)(76176011)(36756003)(316002)(25786009)(6486002)(478600001)(14454004)(446003)(50226002)(476003)(11346002)(2616005)(26005)(7736002)(4326008)(99286004)(86362001)(6916009)(53936002)(66476007)(186003)(68736007)(66446008)(64756008)(66556008)(6436002)(66946007)(73956011)(6512007)(14444005)(1076003)(66066001)(71190400001)(71200400001)(54906003)(256004)(102836004)(81156014)(81166006)(8936002)(3846002)(6506007)(386003)(107886003)(2906002)(8676002)(5660300002)(6116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5881;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y4hFuP5LANiZkQqaKicdSvpQWK4u/EafxOB0S6t+C5RcfwYUB/nwy+mEcNI7w8MhyK0RoktM3K2wx6C2Sir43GPwO1dXucHekXvTo/9Njwf6tAMx9l2vZ3pCViDxEcCUl1yX3tSdRo7UGxDUZP82olA97CyndrZjYaao57l9iB6IbVSW4xdjTTaW8vXHUVbcxnCn9NBEbJR5LG8dyerVC9fE7oT9Wj9929e68iA+gEOrqCzrO6qNwALvQiX6Vu5YLyT0NcmC0uKW7TvTaoDDZBbCAqbJN2OfXphDQSGqTjIfTWKbzITKHnVCnLTIfja3oOS0e4wzetL0FCXdkL2QIF38cM8qpAbm8jtOh8ndQbab0TSkMCXW9kfFirJGR0karmVeLcILH1SkBnrrFRc6gAVlPcdDIy6Zl3tpkl7RSig=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b367b468-ebd6-40a4-c41c-08d6d0f147e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 00:33:23.4314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpDcmVhdGUgbWx4NV9k
ZXZsaW5rX2hlYWx0aF9yZXBvcnRlciBmb3IgRlcgcmVwb3J0ZXIuIFRoZSBGVyByZXBvcnRlcg0K
aW1wbGVtZW50cyBkZXZsaW5rX2hlYWx0aF9yZXBvcnRlciBkaWFnbm9zZSBjYWxsYmFjay4NCg0K
VGhlIGZ3IHJlcG9ydGVyIGRpYWdub3NlIGNvbW1hbmQgY2FuIGJlIHRyaWdnZXJlZCBhbnkgdGlt
ZSBieSB0aGUgdXNlcg0KdG8gY2hlY2sgY3VycmVudCBmdyBzdGF0dXMuDQpJbiBoZWFsdGh5IHN0
YXR1cywgaXQgd2lsbCByZXR1cm4gY2xlYXIgc3luZHJvbWUuIE90aGVyd2lzZSBpdCB3aWxsIGR1
bXANCnRoZSBoZWFsdGggaW5mbyBidWZmZXIuDQoNCkNvbW1hbmQgZXhhbXBsZSBhbmQgb3V0cHV0
IG9uIGhlYWx0aHkgc3RhdHVzOg0KJCBkZXZsaW5rIGhlYWx0aCBkaWFnbm9zZSBwY2kvMDAwMDo4
MjowMC4wIHJlcG9ydGVyIGZ3DQpTeW5kcm9tZTogMA0KDQpDb21tYW5kIGV4YW1wbGUgYW5kIG91
dHB1dCBvbiBub24gaGVhbHRoeSBzdGF0dXM6DQokIGRldmxpbmsgaGVhbHRoIGRpYWdub3NlIHBj
aS8wMDAwOjgyOjAwLjAgcmVwb3J0ZXIgZncNCmRpYWdub3NlIGRhdGE6DQphc3NlcnRfdmFyWzBd
IDB4ZmMzZmMwNDMNCmFzc2VydF92YXJbMV0gMHgwMDAxYjQxYw0KYXNzZXJ0X3ZhclsyXSAweDAw
MDAwMDAwDQphc3NlcnRfdmFyWzNdIDB4MDAwMDAwMDANCmFzc2VydF92YXJbNF0gMHgwMDAwMDAw
MA0KYXNzZXJ0X2V4aXRfcHRyIDB4MDA4MDMzYjQNCmFzc2VydF9jYWxscmEgMHgwMDgwMzY1Yw0K
ZndfdmVyIDE2LjI0LjEwMDANCmh3X2lkIDB4MDAwMDAyMGQNCmlyaXNjX2luZGV4IDANCnN5bmQg
MHg4OiB1bnJlY292ZXJhYmxlIGhhcmR3YXJlIGVycm9yDQpleHRfc3luZCAweDAwM2QNCnJhdyBm
d192ZXIgMHgxMDE4MDNlOA0KDQpTaWduZWQtb2ZmLWJ5OiBNb3NoZSBTaGVtZXNoIDxtb3NoZUBt
ZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxs
YW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94
LmNvbT4NCi0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0aC5j
ICB8IDU1ICsrKysrKysrKysrKysrKysrKysNCiBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgg
ICAgICAgICAgICAgICAgICAgfCAgMSArDQogMiBmaWxlcyBjaGFuZ2VkLCA1NiBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvaGVhbHRoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVh
bHRoLmMNCmluZGV4IGEzYzdlNDZhYWZkOS4uOWZmYTljN2Y4MWEwIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0aC5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCkBAIC00MjgsNiAr
NDI4LDU4IEBAIHN0YXRpYyB2b2lkIG1seDVfcHJpbnRfaGVhbHRoX2luZm8oc3RydWN0IG1seDVf
Y29yZV9kZXYgKmRldikNCiAJbXV0ZXhfdW5sb2NrKCZoZWFsdGgtPmluZm9fYnVmX2xvY2spOw0K
IH0NCiANCitzdGF0aWMgaW50DQorbWx4NV9md19yZXBvcnRlcl9kaWFnbm9zZShzdHJ1Y3QgZGV2
bGlua19oZWFsdGhfcmVwb3J0ZXIgKnJlcG9ydGVyLA0KKwkJCSAgc3RydWN0IGRldmxpbmtfZm1z
ZyAqZm1zZykNCit7DQorCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBkZXZsaW5rX2hlYWx0
aF9yZXBvcnRlcl9wcml2KHJlcG9ydGVyKTsNCisJc3RydWN0IG1seDVfY29yZV9oZWFsdGggKmhl
YWx0aCA9ICZkZXYtPnByaXYuaGVhbHRoOw0KKwl1OCBzeW5kOw0KKwlpbnQgZXJyOw0KKw0KKwlt
dXRleF9sb2NrKCZoZWFsdGgtPmluZm9fYnVmX2xvY2spOw0KKwltbHg1X2dldF9oZWFsdGhfaW5m
byhkZXYsICZzeW5kKTsNCisNCisJaWYgKCFzeW5kKSB7DQorCQltdXRleF91bmxvY2soJmhlYWx0
aC0+aW5mb19idWZfbG9jayk7DQorCQlyZXR1cm4gZGV2bGlua19mbXNnX3U4X3BhaXJfcHV0KGZt
c2csICJTeW5kcm9tZSIsIHN5bmQpOw0KKwl9DQorDQorCWVyciA9IGRldmxpbmtfZm1zZ19zdHJp
bmdfcGFpcl9wdXQoZm1zZywgImRpYWdub3NlIGRhdGEiLA0KKwkJCQkJICAgaGVhbHRoLT5pbmZv
X2J1Zik7DQorDQorCW11dGV4X3VubG9jaygmaGVhbHRoLT5pbmZvX2J1Zl9sb2NrKTsNCisJcmV0
dXJuIGVycjsNCit9DQorDQorc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZsaW5rX2hlYWx0aF9yZXBv
cnRlcl9vcHMgbWx4NV9md19yZXBvcnRlcl9vcHMgPSB7DQorCQkubmFtZSA9ICJmdyIsDQorCQku
ZGlhZ25vc2UgPSBtbHg1X2Z3X3JlcG9ydGVyX2RpYWdub3NlLA0KK307DQorDQorc3RhdGljIHZv
aWQgbWx4NV9md19yZXBvcnRlcl9jcmVhdGUoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCit7
DQorCXN0cnVjdCBtbHg1X2NvcmVfaGVhbHRoICpoZWFsdGggPSAmZGV2LT5wcml2LmhlYWx0aDsN
CisJc3RydWN0IGRldmxpbmsgKmRldmxpbmsgPSBwcml2X3RvX2RldmxpbmsoZGV2KTsNCisNCisJ
aGVhbHRoLT5md19yZXBvcnRlciA9DQorCQlkZXZsaW5rX2hlYWx0aF9yZXBvcnRlcl9jcmVhdGUo
ZGV2bGluaywgJm1seDVfZndfcmVwb3J0ZXJfb3BzLA0KKwkJCQkJICAgICAgIDAsIGZhbHNlLCBk
ZXYpOw0KKwlpZiAoSVNfRVJSKGhlYWx0aC0+ZndfcmVwb3J0ZXIpKQ0KKwkJbWx4NV9jb3JlX3dh
cm4oZGV2LCAiRmFpbGVkIHRvIGNyZWF0ZSBmdyByZXBvcnRlciwgZXJyID0gJWxkXG4iLA0KKwkJ
CSAgICAgICBQVFJfRVJSKGhlYWx0aC0+ZndfcmVwb3J0ZXIpKTsNCit9DQorDQorc3RhdGljIHZv
aWQgbWx4NV9md19yZXBvcnRlcl9kZXN0cm95KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQor
ew0KKwlzdHJ1Y3QgbWx4NV9jb3JlX2hlYWx0aCAqaGVhbHRoID0gJmRldi0+cHJpdi5oZWFsdGg7
DQorDQorCWlmIChJU19FUlJfT1JfTlVMTChoZWFsdGgtPmZ3X3JlcG9ydGVyKSkNCisJCXJldHVy
bjsNCisNCisJZGV2bGlua19oZWFsdGhfcmVwb3J0ZXJfZGVzdHJveShoZWFsdGgtPmZ3X3JlcG9y
dGVyKTsNCit9DQorDQogc3RhdGljIHVuc2lnbmVkIGxvbmcgZ2V0X25leHRfcG9sbF9qaWZmaWVz
KHZvaWQpDQogew0KIAl1bnNpZ25lZCBsb25nIG5leHQ7DQpAQCAtNTM5LDYgKzU5MSw3IEBAIHZv
aWQgbWx4NV9oZWFsdGhfY2xlYW51cChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIA0KIAlr
ZnJlZShoZWFsdGgtPmluZm9fYnVmKTsNCiAJZGVzdHJveV93b3JrcXVldWUoaGVhbHRoLT53cSk7
DQorCW1seDVfZndfcmVwb3J0ZXJfZGVzdHJveShkZXYpOw0KIH0NCiANCiBpbnQgbWx4NV9oZWFs
dGhfaW5pdChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KQEAgLTU2NSw2ICs2MTgsOCBAQCBp
bnQgbWx4NV9oZWFsdGhfaW5pdChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAkJZ290byBl
cnJfYWxsb2NfYnVmZjsNCiAJbXV0ZXhfaW5pdCgmaGVhbHRoLT5pbmZvX2J1Zl9sb2NrKTsNCiAN
CisJbWx4NV9md19yZXBvcnRlcl9jcmVhdGUoZGV2KTsNCisNCiAJcmV0dXJuIDA7DQogDQogZXJy
X2FsbG9jX2J1ZmY6DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oIGIv
aW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQppbmRleCBkZjhmNGM0ZTIxYzYuLmEzNjJhYTZj
Nzk5YyAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KKysrIGIvaW5j
bHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQpAQCAtNDQ4LDYgKzQ0OCw3IEBAIHN0cnVjdCBtbHg1
X2NvcmVfaGVhbHRoIHsNCiAJaW50CQkJCWluZm9fYnVmX2xlbjsNCiAJLyogcHJvdGVjdCBpbmZv
IGJ1ZiBhY2Nlc3MgKi8NCiAJc3RydWN0IG11dGV4CQkJaW5mb19idWZfbG9jazsNCisJc3RydWN0
IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyICpmd19yZXBvcnRlcjsNCiB9Ow0KIA0KIHN0cnVjdCBt
bHg1X3FwX3RhYmxlIHsNCi0tIA0KMi4yMC4xDQoNCg==
