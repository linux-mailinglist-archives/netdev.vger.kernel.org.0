Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C82655641
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbfFYRsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:20 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:51759
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbfFYRsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USwe6ra9cTa7ctuDC3rKBr4v0qPCY/TuYUNDeHvtofM=;
 b=CHtYgUJURrvDprZ93ju4XAhxMgb4onLPqd556cAx93kMixK8xU57ZmDDmZszDHo3KlHfrYFcqZKXFD9vDw3ecStbTuN1ozUzwlpLEaarajgK3K9cEiHLLyI92JILVViAy5Fuyaa6BDiY3uCGZxlvXz18xfo9NC4gWR3Mp27iWMY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:48:07 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:48:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 10/13] net/mlx5: E-Switch, Pass metadata from FDB
 to eswitch manager
Thread-Topic: [PATCH V2 mlx5-next 10/13] net/mlx5: E-Switch, Pass metadata
 from FDB to eswitch manager
Thread-Index: AQHVK34lqi72UHhFjESo3PF+J428ag==
Date:   Tue, 25 Jun 2019 17:48:07 +0000
Message-ID: <20190625174727.20309-11-saeedm@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a02a2011-1e3b-4e71-b164-08d6f9954817
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB22164F71F9224EBA9F47886DBEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(14444005)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ODCE+1ILTrjp+RKc3pN8Ihq/NH1E6dBxx6bzzpk9W1t4hdTGYDpNHVYoHt/6+uQj5K0ZLWMNb4RQrbg90fNAJ/3JNJenzgyj9DJMcZ8Uv+OO4tscpOa4nV79rqbUcwmuUVGrucQ1odBDcpwvszXSzO3xd1CpimRsnCv9e1RdtxxfXst8xhadjykuvje8X0zxRnfeK7ZfsaVtm3HY8NCSp/aKWNig5GayKF2VgjaFkL9GKnhBcfqogJPtU7NO9jzCcGP21dWfGotCyKdQbUKHh5hMypYlJnf15ifHwMOlzPIi4IK6xYlT0cH3/l+QrVudurtF/9MgIH3WDDpeOMwZCbaznCuGi4ydO3NfHY3vYLfMjiw/UMgErI3x1kEXJmpTO6GA5J4ro6XaTDaZZRUCNFZJiCAGVJXUiZBID6dbScY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02a2011-1e3b-4e71-b164-08d6f9954817
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:48:07.7932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCkluIG9yZGVyIHRvIGRv
IG1hdGNoaW5nIG9uIG1ldGFkYXRhIGluIHNsb3cgcGF0aCB3aGVuIGRlbXV4aW5nIHRyYWZmaWMN
CnRvIHJlcHJlc2VudG9ycywgZXhwbGljaXRseSBlbmFibGUgdGhlIGZlYXR1cmUgdGhhdCBhbGxv
d3MgSFcgdG8gcGFzcw0KbWV0YWRhdGEgUkVHX0NfMCBmcm9tIEZEQiB0byBlc3dpdGNoIG1hbmFn
ZXIgTklDX1JYIHRhYmxlLg0KDQpTaWduZWQtb2ZmLWJ5OiBKaWFuYm8gTGl1IDxqaWFuYm9sQG1l
bGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0K
UmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYt
Ynk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL21lbGxh
bm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgICAgIHwgNjQgKysrKysrKysrKysrKysr
KysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA2NCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9h
ZHMuYw0KaW5kZXggYTNjZjc4NzM4MmVlLi4xNzhmZjliMDUyNTggMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkcy5jDQpAQCAtNTc0LDYgKzU3NCw1OSBAQCB2b2lkIG1seDVfZXN3aXRjaF9kZWxfc2VuZF90
b192cG9ydF9ydWxlKHN0cnVjdCBtbHg1X2Zsb3dfaGFuZGxlICpydWxlKQ0KIAltbHg1X2RlbF9m
bG93X3J1bGVzKHJ1bGUpOw0KIH0NCiANCitzdGF0aWMgaW50IG1seDVfZXN3aXRjaF9lbmFibGVf
cGFzc2luZ192cG9ydF9tZXRhZGF0YShzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cpDQorew0KKwl1
MzIgb3V0W01MWDVfU1RfU1pfRFcocXVlcnlfZXN3X3Zwb3J0X2NvbnRleHRfb3V0KV0gPSB7fTsN
CisJdTMyIGluW01MWDVfU1RfU1pfRFcobW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0X2luKV0gPSB7
fTsNCisJdTggZmRiX3RvX3Zwb3J0X3JlZ19jX2lkOw0KKwlpbnQgZXJyOw0KKw0KKwllcnIgPSBt
bHg1X2Vzd2l0Y2hfcXVlcnlfZXN3X3Zwb3J0X2NvbnRleHQoZXN3LCBlc3ctPm1hbmFnZXJfdnBv
cnQsDQorCQkJCQkJICAgb3V0LCBzaXplb2Yob3V0KSk7DQorCWlmIChlcnIpDQorCQlyZXR1cm4g
ZXJyOw0KKw0KKwlmZGJfdG9fdnBvcnRfcmVnX2NfaWQgPSBNTFg1X0dFVChxdWVyeV9lc3dfdnBv
cnRfY29udGV4dF9vdXQsIG91dCwNCisJCQkJCSBlc3dfdnBvcnRfY29udGV4dC5mZGJfdG9fdnBv
cnRfcmVnX2NfaWQpOw0KKw0KKwlmZGJfdG9fdnBvcnRfcmVnX2NfaWQgfD0gTUxYNV9GREJfVE9f
VlBPUlRfUkVHX0NfMDsNCisJTUxYNV9TRVQobW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0X2luLCBp
biwNCisJCSBlc3dfdnBvcnRfY29udGV4dC5mZGJfdG9fdnBvcnRfcmVnX2NfaWQsIGZkYl90b192
cG9ydF9yZWdfY19pZCk7DQorDQorCU1MWDVfU0VUKG1vZGlmeV9lc3dfdnBvcnRfY29udGV4dF9p
biwgaW4sDQorCQkgZmllbGRfc2VsZWN0LmZkYl90b192cG9ydF9yZWdfY19pZCwgMSk7DQorDQor
CXJldHVybiBtbHg1X2Vzd2l0Y2hfbW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0KGVzdywgZXN3LT5t
YW5hZ2VyX3Zwb3J0LA0KKwkJCQkJCSAgICAgaW4sIHNpemVvZihpbikpOw0KK30NCisNCitzdGF0
aWMgaW50IG1seDVfZXN3aXRjaF9kaXNhYmxlX3Bhc3NpbmdfdnBvcnRfbWV0YWRhdGEoc3RydWN0
IG1seDVfZXN3aXRjaCAqZXN3KQ0KK3sNCisJdTMyIG91dFtNTFg1X1NUX1NaX0RXKHF1ZXJ5X2Vz
d192cG9ydF9jb250ZXh0X291dCldID0ge307DQorCXUzMiBpbltNTFg1X1NUX1NaX0RXKG1vZGlm
eV9lc3dfdnBvcnRfY29udGV4dF9pbildID0ge307DQorCXU4IGZkYl90b192cG9ydF9yZWdfY19p
ZDsNCisJaW50IGVycjsNCisNCisJZXJyID0gbWx4NV9lc3dpdGNoX3F1ZXJ5X2Vzd192cG9ydF9j
b250ZXh0KGVzdywgZXN3LT5tYW5hZ2VyX3Zwb3J0LA0KKwkJCQkJCSAgIG91dCwgc2l6ZW9mKG91
dCkpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJZmRiX3RvX3Zwb3J0X3JlZ19j
X2lkID0gTUxYNV9HRVQocXVlcnlfZXN3X3Zwb3J0X2NvbnRleHRfb3V0LCBvdXQsDQorCQkJCQkg
ZXN3X3Zwb3J0X2NvbnRleHQuZmRiX3RvX3Zwb3J0X3JlZ19jX2lkKTsNCisNCisJZmRiX3RvX3Zw
b3J0X3JlZ19jX2lkICY9IH5NTFg1X0ZEQl9UT19WUE9SVF9SRUdfQ18wOw0KKw0KKwlNTFg1X1NF
VChtb2RpZnlfZXN3X3Zwb3J0X2NvbnRleHRfaW4sIGluLA0KKwkJIGVzd192cG9ydF9jb250ZXh0
LmZkYl90b192cG9ydF9yZWdfY19pZCwgZmRiX3RvX3Zwb3J0X3JlZ19jX2lkKTsNCisNCisJTUxY
NV9TRVQobW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0X2luLCBpbiwNCisJCSBmaWVsZF9zZWxlY3Qu
ZmRiX3RvX3Zwb3J0X3JlZ19jX2lkLCAxKTsNCisNCisJcmV0dXJuIG1seDVfZXN3aXRjaF9tb2Rp
ZnlfZXN3X3Zwb3J0X2NvbnRleHQoZXN3LCBlc3ctPm1hbmFnZXJfdnBvcnQsDQorCQkJCQkJICAg
ICBpbiwgc2l6ZW9mKGluKSk7DQorfQ0KKw0KIHN0YXRpYyB2b2lkIHBlZXJfbWlzc19ydWxlc19z
ZXR1cChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqcGVlcl9kZXYsDQogCQkJCSAgc3RydWN0IG1seDVf
Zmxvd19zcGVjICpzcGVjLA0KIAkJCQkgIHN0cnVjdCBtbHg1X2Zsb3dfZGVzdGluYXRpb24gKmRl
c3QpDQpAQCAtMTk3Nyw2ICsyMDMwLDEyIEBAIGludCBlc3dfb2ZmbG9hZHNfaW5pdChzdHJ1Y3Qg
bWx4NV9lc3dpdGNoICplc3csIGludCB2Zl9udnBvcnRzLA0KIAlpZiAoZXJyKQ0KIAkJcmV0dXJu
IGVycjsNCiANCisJaWYgKG1seDVfZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVk
KGVzdykpIHsNCisJCWVyciA9IG1seDVfZXN3aXRjaF9lbmFibGVfcGFzc2luZ192cG9ydF9tZXRh
ZGF0YShlc3cpOw0KKwkJaWYgKGVycikNCisJCQlnb3RvIGVycl92cG9ydF9tZXRhZGF0YTsNCisJ
fQ0KKw0KIAkvKiBPbmx5IGxvYWQgc3BlY2lhbCB2cG9ydHMgcmVwcy4gVkYgcmVwcyB3aWxsIGJl
IGxvYWRlZCBpbg0KIAkgKiBjb250ZXh0IG9mIGZ1bmN0aW9uc19jaGFuZ2VkIGV2ZW50IGhhbmRs
ZXIgdGhyb3VnaCByZWFsDQogCSAqIG9yIGVtdWxhdGVkIGV2ZW50Lg0KQEAgLTIwMDQsNiArMjA2
Myw5IEBAIGludCBlc3dfb2ZmbG9hZHNfaW5pdChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGlu
dCB2Zl9udnBvcnRzLA0KIAlyZXR1cm4gMDsNCiANCiBlcnJfcmVwczoNCisJaWYgKG1seDVfZXN3
aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVkKGVzdykpDQorCQltbHg1X2Vzd2l0Y2hf
ZGlzYWJsZV9wYXNzaW5nX3Zwb3J0X21ldGFkYXRhKGVzdyk7DQorZXJyX3Zwb3J0X21ldGFkYXRh
Og0KIAllc3dfb2ZmbG9hZHNfc3RlZXJpbmdfY2xlYW51cChlc3cpOw0KIAlyZXR1cm4gZXJyOw0K
IH0NCkBAIC0yMDMzLDYgKzIwOTUsOCBAQCB2b2lkIGVzd19vZmZsb2Fkc19jbGVhbnVwKHN0cnVj
dCBtbHg1X2Vzd2l0Y2ggKmVzdykNCiAJbWx4NV9yZG1hX2Rpc2FibGVfcm9jZShlc3ctPmRldik7
DQogCWVzd19vZmZsb2Fkc19kZXZjb21fY2xlYW51cChlc3cpOw0KIAllc3dfb2ZmbG9hZHNfdW5s
b2FkX2FsbF9yZXBzKGVzdywgZXN3LT5lc3dfZnVuY3MubnVtX3Zmcyk7DQorCWlmIChtbHg1X2Vz
d2l0Y2hfdnBvcnRfbWF0Y2hfbWV0YWRhdGFfZW5hYmxlZChlc3cpKQ0KKwkJbWx4NV9lc3dpdGNo
X2Rpc2FibGVfcGFzc2luZ192cG9ydF9tZXRhZGF0YShlc3cpOw0KIAllc3dfb2ZmbG9hZHNfc3Rl
ZXJpbmdfY2xlYW51cChlc3cpOw0KIH0NCiANCi0tIA0KMi4yMS4wDQoNCg==
