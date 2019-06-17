Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6BE48E57
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfFQTXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:45 -0400
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:28142
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728855AbfFQTXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqCvRYUx+2QxnPsR+hhrJiU6s6Lm6OLrkDV917F6wb4=;
 b=T9p4Aek2yTbrjsl/3omOGEmK9YpRj2R4CDKYDD2d/jL86ugB26iG4O86dyj7UewgBSmqAWW8eahOQusLHDgZMDHtt7wAOen7pijdvpyshgL09jh4KiFc+5Enf1ecSJkC07uqt/eb8SoFARELSumb2x+HbHExoDax9FdqYQnJ2Cg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:26 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 09/15] net/mlx5: E-Switch, Pass metadata from FDB to
 eswitch manager
Thread-Topic: [PATCH mlx5-next 09/15] net/mlx5: E-Switch, Pass metadata from
 FDB to eswitch manager
Thread-Index: AQHVJUIjgCgCJ+j/akKzMVDeCu7lLw==
Date:   Mon, 17 Jun 2019 19:23:26 +0000
Message-ID: <20190617192247.25107-10-saeedm@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68c2b5f2-dd2c-4ba8-f189-08d6f359453e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB27896847B9A8EA608A64D71EBEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(14444005)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VEotkD/3hUHnE9lefYFaLzK8CgSxoeOr+9tZ+ZI615+PbslGdW7DLAaCpIexRnve/ythw14W1dHAEvmrph3sL6HN1pc+BRqhhXEmYlxVXE8NBILcsnkDhF4HITqLouw9D0K619Rt388ulIfWDmEYHAt0huU3LQU7NOSsPpiRMFTrRmmqclEQ2C9OTq5fvw7o4Wh/2x+9KqPxMm+NWpgDGwp2Y5y1JfZ8Zoep3YnjtjehoSNlJut6dOVpsh2lKCV4vYS8BgpKdgWyApYkovVZX6k5BeRb9Gn7EPyc5MXq/HlH1sJDDGeG6xbaD32HvcTO4PTdOB+wOQLQGo7KF0Er/F1RbZQ3+KAZezT/ax319nFyUFR2hpFNDQahGOLaB1j+y15SDD0HYB9DOLXk6gnsDRKk2ywwmN2ZckUDY6GJSKA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c2b5f2-dd2c-4ba8-f189-08d6f359453e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:26.3879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
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
ZHMuYw0KaW5kZXggZWUxODg5NmRmZDQ2Li5mN2ZkMmFmYWM0NjEgMTAwNjQ0DQotLS0gYS9kcml2
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
c3QpDQpAQCAtMTk4MCw2ICsyMDMzLDEyIEBAIGludCBlc3dfb2ZmbG9hZHNfaW5pdChzdHJ1Y3Qg
bWx4NV9lc3dpdGNoICplc3csIGludCB2Zl9udnBvcnRzLA0KIAlpZiAoZXJyKQ0KIAkJcmV0dXJu
IGVycjsNCiANCisJaWYgKG1seDVfZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVk
KGVzdykpIHsNCisJCWVyciA9IG1seDVfZXN3aXRjaF9lbmFibGVfcGFzc2luZ192cG9ydF9tZXRh
ZGF0YShlc3cpOw0KKwkJaWYgKGVycikNCisJCQlnb3RvIGVycl92cG9ydF9tZXRhZGF0YTsNCisJ
fQ0KKw0KIAkvKiBPbmx5IGxvYWQgc3BlY2lhbCB2cG9ydHMgcmVwcy4gVkYgcmVwcyB3aWxsIGJl
IGxvYWRlZCBpbg0KIAkgKiBjb250ZXh0IG9mIGZ1bmN0aW9uc19jaGFuZ2VkIGV2ZW50IGhhbmRs
ZXIgdGhyb3VnaCByZWFsDQogCSAqIG9yIGVtdWxhdGVkIGV2ZW50Lg0KQEAgLTIwMDcsNiArMjA2
Niw5IEBAIGludCBlc3dfb2ZmbG9hZHNfaW5pdChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGlu
dCB2Zl9udnBvcnRzLA0KIAlyZXR1cm4gMDsNCiANCiBlcnJfcmVwczoNCisJaWYgKG1seDVfZXN3
aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVkKGVzdykpDQorCQltbHg1X2Vzd2l0Y2hf
ZGlzYWJsZV9wYXNzaW5nX3Zwb3J0X21ldGFkYXRhKGVzdyk7DQorZXJyX3Zwb3J0X21ldGFkYXRh
Og0KIAllc3dfb2ZmbG9hZHNfc3RlZXJpbmdfY2xlYW51cChlc3cpOw0KIAlyZXR1cm4gZXJyOw0K
IH0NCkBAIC0yMDM2LDYgKzIwOTgsOCBAQCB2b2lkIGVzd19vZmZsb2Fkc19jbGVhbnVwKHN0cnVj
dCBtbHg1X2Vzd2l0Y2ggKmVzdykNCiAJbWx4NV9yZG1hX2Rpc2FibGVfcm9jZShlc3ctPmRldik7
DQogCWVzd19vZmZsb2Fkc19kZXZjb21fY2xlYW51cChlc3cpOw0KIAllc3dfb2ZmbG9hZHNfdW5s
b2FkX2FsbF9yZXBzKGVzdywgZXN3LT5lc3dfZnVuY3MubnVtX3Zmcyk7DQorCWlmIChtbHg1X2Vz
d2l0Y2hfdnBvcnRfbWF0Y2hfbWV0YWRhdGFfZW5hYmxlZChlc3cpKQ0KKwkJbWx4NV9lc3dpdGNo
X2Rpc2FibGVfcGFzc2luZ192cG9ydF9tZXRhZGF0YShlc3cpOw0KIAllc3dfb2ZmbG9hZHNfc3Rl
ZXJpbmdfY2xlYW51cChlc3cpOw0KIH0NCiANCi0tIA0KMi4yMS4wDQoNCg==
