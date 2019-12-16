Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5412109F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfLPREt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:04:49 -0500
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:49121
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727101AbfLPRD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dY77xjOTH6+vmiBbtzsxb9rL4ulBpD6bbx/kQ8eykVQZdIDPZMZqHMxsxdn7iapUpMwQPZUZVYoiL2aaceVGuoQZ2S7KHPuXWPII1mXeWP+nTv57o0IJQCFCzdret5ohgzn5pNeimRY1CN0Ffq1UY6MZagP6VewuaEMzSdWXGEXkMJzHd6sPxrbobD0f7d9knQTNLRe6JyXMoOZ4EKqusG7lpsFHeOChFf7DOgIPIluRQqtXuzc/D/gu15eiw6pGJSEae+RHF/W2BbJQlBS95lt/dU23DoanvKgFJHNPLS8uYyItWydjji8sWADcP2/6/jySOxYffm4zMyz06yr2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euFpjFGMFrP1rz1eUi+D/CNOMsvPYPcV3xsIVRhW5Ok=;
 b=mAL2eKmXUBmkoqDEa0l+AuYrlkjI0H23eFyBY+jpFgnyhmF40wRjswT1DUmCbbKIEMNuFXM8dn63hHDCgBm/FVAzB3GuUFP4lY5tXfilQbcLbvptOrj1iQTV1RVDBRPTLPFuksCAexrV11ScyDNV60l5ss/3h6UNHk9yAES42d2vSIvLL5PQB3AQVayUBaWKkkYlKbF5CUkk8B9tz7sGABHpcqSiksXLK417+Rl/venroBMECqe7iuCWJapJFw4MetxJTUTSXs4A++6N5f5x6XKp/sbfqjuDx8wC8LuliTl5BdU5wQ10KnhJu+xXQ92Te/KVZEMa+zyvm3zksV/FBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euFpjFGMFrP1rz1eUi+D/CNOMsvPYPcV3xsIVRhW5Ok=;
 b=GtiYvdsPBuTvKGquLSLWH/nYdyTOgl5GZEirueDXxi44HBukhcT+gZkEnxrzi64pyQGsh2X+0dHiRsDJfpQHZ264zkLMDtBkysZwXQmzPyxw+cKTy5XGxFZpwkAQTZIVs3nJR3n6kSGYEdijCD3K6kx3w+omk8Yn0kw0OuGdtic=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:51 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 20/55] staging: wfx: make conditions easier to read
Thread-Topic: [PATCH 20/55] staging: wfx: make conditions easier to read
Thread-Index: AQHVtDLFk8cqtPACM0yZr2FsSKTnFg==
Date:   Mon, 16 Dec 2019 17:03:43 +0000
Message-ID: <20191216170302.29543-21-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a50ccfe-7b09-440f-0a8e-08d78249ed03
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4351253CA6B7F449FC57757F93510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:376;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(66574012)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 445iGWctoeVkMqCcBgkl2VBTww+nXwSKAB4HbhsDsKlUnfME216ja+01uK8gF4K4VJlMCYmvCn7PLh0YRBJSq09RpFYbBilCBlksmNNP5Vf+IwG/eQ9oxwi7mTxbm4zRrJMRKt2s8mSE5hi3nIViwvqvtOQ46wEcDy+dWGeyryFdDoPUQshQCC8dIl9I/HsABjIhTVIQjM16lunOJxAmnNg9LEzbqw/XBMsd/GaVZYy+ZwDoBLpnhOnd/Z86NjomK+iA6OPytzZjc+oNwkRh0QGbCocbVGVjizeAjFAZ1oi6zF7zCPM9+XEcBW82aoOlMiY38OmGjJqOwGcc/nLRN1YHxD5EPqWhlHLTWj01CMbou2LZSHrOliTDVHCULTWrP3guLHReI/RQZTtTeZkrm6Sd64mOQiY4/oLSu0qKsPse9DtAKVMD/sUCc0mF33K/
Content-Type: text/plain; charset="utf-8"
Content-ID: <9271E5A608BE4A45A3A9D7255EB85666@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a50ccfe-7b09-440f-0a8e-08d78249ed03
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:43.8712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +/8ca0NSd7yzhvBxtXiLQqMDlQyZbD7ws3X7Ab6TKGlsiro1s+9s9URd4FaGu66fPSZp/9qdKoYMW5UzWSce8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpX
ZSBwcmVmZXIgc2VyaWVzIG9mIHNpbXBsZSBib29sZWFuIGNvbmRpdGlvbnMgdGhhbiBjb21wdXRp
bmcgYml0bWFza3MuDQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAy
NyArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0
aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KaW5kZXggNDcxZGQxNWIyMjdm
Li43ZjRlYWE4ZTZkODQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAtMTA1NSw5ICsxMDU1LDExIEBAIHZv
aWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQogCQl9DQog
CX0NCiANCi0JaWYgKGNoYW5nZWQgJg0KLQkgICAgKEJTU19DSEFOR0VEX0JFQUNPTiB8IEJTU19D
SEFOR0VEX0FQX1BST0JFX1JFU1AgfA0KLQkgICAgIEJTU19DSEFOR0VEX0JTU0lEIHwgQlNTX0NI
QU5HRURfU1NJRCB8IEJTU19DSEFOR0VEX0lCU1MpKSB7DQorCWlmIChjaGFuZ2VkICYgQlNTX0NI
QU5HRURfQkVBQ09OIHx8DQorCSAgICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQVBfUFJPQkVfUkVT
UCB8fA0KKwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JTU0lEIHx8DQorCSAgICBjaGFuZ2Vk
ICYgQlNTX0NIQU5HRURfU1NJRCB8fA0KKwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0lCU1Mp
IHsNCiAJCXd2aWYtPmJlYWNvbl9pbnQgPSBpbmZvLT5iZWFjb25faW50Ow0KIAkJd2Z4X3VwZGF0
ZV9iZWFjb25pbmcod3ZpZik7DQogCQl3ZnhfdXBsb2FkX2JlYWNvbih3dmlmKTsNCkBAIC0xMDk1
LDEwICsxMDk3LDExIEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsDQogCQlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JTU0lEKQ0KIAkJCWRvX2pv
aW4gPSB0cnVlOw0KIA0KLQkJaWYgKGNoYW5nZWQgJg0KLQkJICAgIChCU1NfQ0hBTkdFRF9BU1NP
QyB8IEJTU19DSEFOR0VEX0JTU0lEIHwNCi0JCSAgICAgQlNTX0NIQU5HRURfSUJTUyB8IEJTU19D
SEFOR0VEX0JBU0lDX1JBVEVTIHwNCi0JCSAgICAgQlNTX0NIQU5HRURfSFQpKSB7DQorCQlpZiAo
Y2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8DQorCQkgICAgY2hhbmdlZCAmIEJTU19DSEFO
R0VEX0JTU0lEIHx8DQorCQkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0lCU1MgfHwNCisJCSAg
ICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkFTSUNfUkFURVMgfHwNCisJCSAgICBjaGFuZ2VkICYg
QlNTX0NIQU5HRURfSFQpIHsNCiAJCQlpZiAoaW5mby0+YXNzb2MpIHsNCiAJCQkJaWYgKHd2aWYt
PnN0YXRlIDwgV0ZYX1NUQVRFX1BSRV9TVEEpIHsNCiAJCQkJCWllZWU4MDIxMV9jb25uZWN0aW9u
X2xvc3ModmlmKTsNCkBAIC0xMTIwLDkgKzExMjMsOSBAQCB2b2lkIHdmeF9ic3NfaW5mb19jaGFu
Z2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAl9DQogDQogCS8qIEVSUCBQcm90ZWN0aW9u
ICovDQotCWlmIChjaGFuZ2VkICYgKEJTU19DSEFOR0VEX0FTU09DIHwNCi0JCSAgICAgICBCU1Nf
Q0hBTkdFRF9FUlBfQ1RTX1BST1QgfA0KLQkJICAgICAgIEJTU19DSEFOR0VEX0VSUF9QUkVBTUJM
RSkpIHsNCisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fA0KKwkgICAgY2hhbmdl
ZCAmIEJTU19DSEFOR0VEX0VSUF9DVFNfUFJPVCB8fA0KKwkgICAgY2hhbmdlZCAmIEJTU19DSEFO
R0VEX0VSUF9QUkVBTUJMRSkgew0KIAkJdTMyIHByZXZfZXJwX2luZm8gPSB3dmlmLT5lcnBfaW5m
bzsNCiANCiAJCWlmIChpbmZvLT51c2VfY3RzX3Byb3QpDQpAQCAtMTEzOSwxMCArMTE0MiwxMCBA
QCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIAkJ
CXNjaGVkdWxlX3dvcmsoJnd2aWYtPnNldF9jdHNfd29yayk7DQogCX0NCiANCi0JaWYgKGNoYW5n
ZWQgJiAoQlNTX0NIQU5HRURfQVNTT0MgfCBCU1NfQ0hBTkdFRF9FUlBfU0xPVCkpDQorCWlmIChj
aGFuZ2VkICYgQlNTX0NIQU5HRURfQVNTT0MgfHwgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0VSUF9T
TE9UKQ0KIAkJaGlmX3Nsb3RfdGltZSh3dmlmLCBpbmZvLT51c2Vfc2hvcnRfc2xvdCA/IDkgOiAy
MCk7DQogDQotCWlmIChjaGFuZ2VkICYgKEJTU19DSEFOR0VEX0FTU09DIHwgQlNTX0NIQU5HRURf
Q1FNKSkgew0KKwlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBC
U1NfQ0hBTkdFRF9DUU0pIHsNCiAJCXN0cnVjdCBoaWZfbWliX3JjcGlfcnNzaV90aHJlc2hvbGQg
dGggPSB7DQogCQkJLnJvbGxpbmdfYXZlcmFnZV9jb3VudCA9IDgsDQogCQkJLmRldGVjdGlvbiA9
IDEsDQotLSANCjIuMjAuMQ0K
