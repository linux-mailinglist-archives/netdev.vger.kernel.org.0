Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5CD13BF82
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbgAOMOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:14:04 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:6101
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731672AbgAOMNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVnfitd+OVjfs8rXtLNZpfdit1nRnDt2AfGepmIjEdCPfKsq9unw3H+mlIJRAQtJ+6+h22M0vuFVSPkMgV21dMJaHUEOjUu05PeNx+awsnC0d7nfF3lg+wNUrpczjxKJjQtFgHfJgGrAxy701oRvfRflM4NtzKjAvS1lhuUaEipNVkvkj38Tw0ANoiqbXIPE1EGkw7fZQmWY/C437jY7F0G8LbVJ+7/I7MyZnDfMPFxMrC0UpJJskOqSwLFOp1J3HHnyISThQWkmlSjeZeHEgxpK4hUy4wxBz1W4uIzMosF47x7JFr4nva2YZMAw1kiIuq/Cgm0+AShh39Wsb+1t1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dZsB0RqG6LXb8hxypQ6AkKcB+Wj+er1SgaAyqW9fPQ=;
 b=fmhFQRliNwquPt5HCZ8iD4loFSv+5V9/Fvbr3MZR7vMSMWIvQRcgGoIULvaPi/9SNJE9kwPcZnjcgP5iwwtItRx1UdVaMkcfgycfLQbfOTepUUq3sIBVNA2OGLFHGW3rLhOzukENv9u5JAyloSi6kY/qtfvgWeyT2ruHNWHSzGI/F5uy50WsCzUi4IQizZ6d7AkkrT9ahuZca0TmLRXVGunZemE11s6tDCS3EN+EM5V8YjHJY91Bcx31U6ce6zyzucSAsCwu0fM/wH4WqMaJaaWEhtvDLd+cjSopEIn8i+bltQKiXB6UQalwvtzx1BRWb3BPa714x7KlZEnKQ1tKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dZsB0RqG6LXb8hxypQ6AkKcB+Wj+er1SgaAyqW9fPQ=;
 b=ZZszIlYeO1B1EawCMkKWsOk9XI8n23Y/JT31NLQUYjm0QWiyfAsRX3we3Q0Xuj8J2iKtY+pMXP3feJdh+a28QMdBI+3edhTvWL0kpQyV9fEHzcLgvsg5d86VqmLzip+kSnJzOXsJoH8r2JeKVo9kLTgMR3nBii/+ygSJ5U+fE3w=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:34 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:19 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 54/65] staging: wfx: sta and dtim
Thread-Topic: [PATCH 54/65] staging: wfx: sta and dtim
Thread-Index: AQHVy50toUATEVqARUSRYKOv/KUFlA==
Date:   Wed, 15 Jan 2020 12:13:21 +0000
Message-ID: <20200115121041.10863-55-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66e5c17a-22ff-46de-86ab-08d799b44fd1
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB393443A96E2429FF58AAC2EB93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(6666004)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nzFn41BV1QrhCP9+43CEPdaESivtsAtGXGStCihuT6NJXMtaGiv/WRz6UC+SGziXFqFwXpQnaZzFah0w7Ny5qZyqPT2mKUJUo/aGn7RFO9kIEYPrQFx0CoBgLjhJRRe01vjJqYX5xsbEQxOsvja+WhfAzPSfbdLA3gyXqBryc01UgxcVGoJsbwrVh2Xab1So+jQGwf1arB38b9bSJDeCmxAwaMAJslb4WvOiXmUJjNeZFVyteULt1XGqRynlibWBSadalByNwIC0yHoi+uhLJLRwJdiRDGvKjKQ+cdOAlYXuEs+SxOKDMdQ3VLxdQy3rIeFUsltEk7bAIQ1fNFRZaV/O+ARQ58VU55wOXbeK9KbR1BJf3Tp2y4R4iP0GVroUZlspTHQZBEDYYiPqq/WEldxuvH62sRtv6ARSZ7kP0JsZZT4Yqoi+oTUgVPBbuie
Content-Type: text/plain; charset="utf-8"
Content-ID: <65101027284F0643AD35FD3FDF3B6E6E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e5c17a-22ff-46de-86ab-08d799b44fd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:21.0457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yQ3f+9S4fL6ncjYYGtnjrc/aPrKagIBv2oRIisEx1f4gFrJBXLF0LYeaqFyJwR3p+DjZhSX/IzTsJl/ClggepQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3BzX25vdGlmeSgpIGlzIGNhbGxlZCBmb3IgYW55IGNoYW5nZXMgaW4gdGhlIFRJTS4gSG93ZXZl
ciwKYXNzb2NpYXRpb24gSUQgMCBpcyBhIHZlcnkgc3BlY2lhbCBjYXNlIHRoYXQgc2hvdWxkIGJl
IGhhbmRsZWQKaW5kZXBlbmRlbnRseS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jIHwgMzMgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNjY5
N2M3MzZhMDU0Li5kNGMxMWIwNzQ5N2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtODM5LDIxICs4MzksMTMg
QEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJ
d2Z4X2RvX2pvaW4od3ZpZik7CiB9CiAKLXN0YXRpYyB2b2lkIHdmeF9wc19ub3RpZnkoc3RydWN0
IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlmeV9jbWQgbm90aWZ5X2NtZCwKLQkJCSAgaW50
IGxpbmtfaWQpCitzdGF0aWMgdm9pZCB3ZnhfcHNfbm90aWZ5X3N0YShzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwKKwkJCSAgICAgIGVudW0gc3RhX25vdGlmeV9jbWQgbm90aWZ5X2NtZCwgaW50IGxpbmtf
aWQpCiB7CiAJdTMyIGJpdCwgcHJldjsKIAogCXNwaW5fbG9ja19iaCgmd3ZpZi0+cHNfc3RhdGVf
bG9jayk7Ci0JLyogWmVybyBsaW5rIGlkIG1lYW5zICJmb3IgYWxsIGxpbmsgSURzIiAqLwotCWlm
IChsaW5rX2lkKSB7Ci0JCWJpdCA9IEJJVChsaW5rX2lkKTsKLQl9IGVsc2UgaWYgKG5vdGlmeV9j
bWQgIT0gU1RBX05PVElGWV9BV0FLRSkgewotCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJ1
bnN1cHBvcnRlZCBub3RpZnkgY29tbWFuZFxuIik7Ci0JCWJpdCA9IDA7Ci0JfSBlbHNlIHsKLQkJ
Yml0ID0gd3ZpZi0+bGlua19pZF9tYXAgJiB+MTsKLQl9CisJYml0ID0gQklUKGxpbmtfaWQpOwog
CXByZXYgPSB3dmlmLT5zdGFfYXNsZWVwX21hc2sgJiBiaXQ7CiAKIAlzd2l0Y2ggKG5vdGlmeV9j
bWQpIHsKQEAgLTg2Nyw3ICs4NTksNyBAQCBzdGF0aWMgdm9pZCB3ZnhfcHNfbm90aWZ5KHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQsCiAJY2FzZSBT
VEFfTk9USUZZX0FXQUtFOgogCQlpZiAocHJldikgewogCQkJd3ZpZi0+c3RhX2FzbGVlcF9tYXNr
ICY9IH5iaXQ7Ci0JCQlpZiAobGlua19pZCAmJiAhd3ZpZi0+c3RhX2FzbGVlcF9tYXNrKQorCQkJ
aWYgKCF3dmlmLT5zdGFfYXNsZWVwX21hc2spCiAJCQkJc2NoZWR1bGVfd29yaygmd3ZpZi0+bWNh
c3Rfc3RvcF93b3JrKTsKIAkJCXdmeF9iaF9yZXF1ZXN0X3R4KHd2aWYtPndkZXYpOwogCQl9CkBA
IC04ODIsNyArODc0LDcgQEAgdm9pZCB3Znhfc3RhX25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9
IChzdHJ1Y3Qgd2Z4X3ZpZiAqKSB2aWYtPmRydl9wcml2OwogCXN0cnVjdCB3Znhfc3RhX3ByaXYg
KnN0YV9wcml2ID0gKHN0cnVjdCB3Znhfc3RhX3ByaXYgKikgJnN0YS0+ZHJ2X3ByaXY7CiAKLQl3
ZnhfcHNfbm90aWZ5KHd2aWYsIG5vdGlmeV9jbWQsIHN0YV9wcml2LT5saW5rX2lkKTsKKwl3Znhf
cHNfbm90aWZ5X3N0YSh3dmlmLCBub3RpZnlfY21kLCBzdGFfcHJpdi0+bGlua19pZCk7CiB9CiAK
IHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV90aW0oc3RydWN0IHdmeF92aWYgKnd2aWYpCkBAIC05OTMs
NiArOTg1LDE0IEBAIGludCB3ZnhfYW1wZHVfYWN0aW9uKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3
LAogCXJldHVybiAtRU5PVFNVUFA7CiB9CiAKK3N0YXRpYyB2b2lkIHdmeF9kdGltX25vdGlmeShz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xv
Y2spOworCXd2aWYtPnN0YV9hc2xlZXBfbWFzayA9IDA7CisJd2Z4X2JoX3JlcXVlc3RfdHgod3Zp
Zi0+d2Rldik7CisJc3Bpbl91bmxvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xvY2spOworfQorCiB2
b2lkIHdmeF9zdXNwZW5kX3Jlc3VtZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCWNvbnN0IHN0
cnVjdCBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4ICphcmcpCiB7CkBAIC0xMDEzLDEyICsxMDEz
LDkgQEAgdm9pZCB3Znhfc3VzcGVuZF9yZXN1bWUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCWlm
IChjYW5jZWxfdG1vKQogCQkJZGVsX3RpbWVyX3N5bmMoJnd2aWYtPm1jYXN0X3RpbWVvdXQpOwog
CX0gZWxzZSBpZiAoYXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5yZXN1bWUpIHsKLQkJLy8gRklY
TUU6IHNob3VsZCBjaGFuZ2UgZWFjaCBzdGF0aW9uIHN0YXR1cyBpbmRlcGVuZGVudGx5Ci0JCXdm
eF9wc19ub3RpZnkod3ZpZiwgU1RBX05PVElGWV9BV0FLRSwgMCk7Ci0JCXdmeF9iaF9yZXF1ZXN0
X3R4KHd2aWYtPndkZXYpOworCQl3ZnhfZHRpbV9ub3RpZnkod3ZpZik7CiAJfSBlbHNlIHsKLQkJ
Ly8gRklYTUU6IHNob3VsZCBjaGFuZ2UgZWFjaCBzdGF0aW9uIHN0YXR1cyBpbmRlcGVuZGVudGx5
Ci0JCXdmeF9wc19ub3RpZnkod3ZpZiwgU1RBX05PVElGWV9TTEVFUCwgMCk7CisJCWRldl93YXJu
KHd2aWYtPndkZXYtPmRldiwgInVuc3VwcG9ydGVkIHN1c3BlbmQvcmVzdW1lIG5vdGlmaWNhdGlv
blxuIik7CiAJfQogfQogCi0tIAoyLjI1LjAKCg==
