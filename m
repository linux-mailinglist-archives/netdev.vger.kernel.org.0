Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41E413C473
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbgAON71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:59:27 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:4897
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729837AbgAONz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZ3WiSt2lNXC2TfkCn5ifztIX7LKKeQ4Edi+jrKCf319HLUY+yCmCLuwvn9CeB0cyOLjCCgCYBk6xoe4V3tv5TsAEwLsE/ztPiKsZOIgbCiPZjZ4YDEWsPD3RZ2g7jsQawH/cY3DwwvSzRSZxW89wHA5nF9c07uO2BwfN5z7bsUoBNgxLZQ6zBV16o5NYDYe2VMdvcGDeNGgUlqE/2Tg+JHvwvv01Y7ZryP4PNCualgWf4Y8NxAVHbuOU/l1Xuygaa6kx2B57T0W8UkHEP4YSyI+zGq3bPabcZjP5gGISwOZykkYAPqZxl/XZtFbXJNNsS7fi3saVOL2u4hdtFPrtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7xw4WCj2d15OmRXMql5kVmIrhFJ5wVO8llOWfUVcAg=;
 b=e1Fxg1Ns4ZBqm1Gl5+ZMqfwjepC4bM4zC8hHZbzgutf538vSrCJ3hpny3K3IJtkfvaGb0mkjyvUa9DQtSOM3GUBvdkozkHqVSvffiOLG3kalNGzvqFSZY8GdcxGMsTn7tIamD0mc4iWpdoWHqmbU6ITnSX4j0p7kjzbhH9VAv2SdlMrSiqQRglNYjZfoTllV5m382CTWW/e6lN1pBdS7WG2bfkngJOZ23gZ3KT5hLITgt+ATbB+EJ9qUokb4LsEF2piLamSEtylS/p2GO/V8cMBY6oYuVdmEvs29cqbcvggMebgCVifU90W1ogMIXXf7WnOeg7jxdU011FwMPSfauw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7xw4WCj2d15OmRXMql5kVmIrhFJ5wVO8llOWfUVcAg=;
 b=mFqhm4upwxfTZAj78mOY6tziyIsDBOZUXam7A5637bhtD8b9kBXTpCBieM24MYK3cW2LtImcoOQ2Xj5MPlCsCB31prYrnSCzCo4UHPwxljq4vjIEqnS4WwGgfcVk9XfOKUEDWQ1GxbQrS5BBXhnTfPCtir3eUpr94redFbAnLrA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:21 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:21 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:58 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 39/65] staging: wfx: simplify wfx_scan_complete()
Thread-Topic: [PATCH v2 39/65] staging: wfx: simplify wfx_scan_complete()
Thread-Index: AQHVy6tgPdIIv+HZaEOcngYmvApagA==
Date:   Wed, 15 Jan 2020 13:54:59 +0000
Message-ID: <20200115135338.14374-40-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 066b16c5-4c2c-4008-efed-08d799c282e5
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094899A37C02F3E78714C7E93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UGgi1GeeNCKvDZggIbwEIAkynwC0UeojiFqTdOfCGHbK8C5qbQ1jtgKb2UOMSOTtP3XV32N8awn5jrK4B4D3d28J4IZ0njt9YnBvldaUtqiq69NMPKzM0ucyJCRznJwieA5F+GyMDOhKjVbEV/teTSgH1xp12dv9Jd1Mi3ksAkFFdznBpjOpDHUrR54KFm6Ib8cKeRjZ04gkOpU0iYQHHBqQWO6GHnCxRArdg3zpHh5N0XjykE36N+7AMOnRF3FC2AGWBHWGOhhHDh6gmc3sDL3+BjK4gF9+LTHzb8SmHTaMSLmJr3W7B5VWRwPdnuaVyx8o0h8m1giJ46hA5nD+PUJYAvNBEtt2jqm6EpY6PxW5ep40gQ+mQd+Sx8BID9v2z9IePFBpE6vs7ywEVpZZxl28Sh4cTH40CsKbRg4OlvJ5GNbPURRK1tBYcVu5yx+E
Content-Type: text/plain; charset="utf-8"
Content-ID: <91BB3F2FE9A35A4AABAA19359C7A493D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 066b16c5-4c2c-4008-efed-08d799c282e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:59.6825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MhrNL3ynFjGBno/rPmGcKkqfOZpR4VjxowAdh5glv494TMYJsSTvvb7CCAfmi/P5qSTAnPWhsubfyqrTyG2PlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3NjYW5fY29tcGxldGUoKSBkbyBub3RoaW5nIHdpdGggYXJndW1lbnQgaGlmX2luZF9zY2FuX2Nt
cGwuIEluIGFkZCwKaGlmX2luZF9zY2FuX2NtcGwgY29tZSBmcm9tIGhhcmR3YXJlIEFQSSBhbmQg
aXMgbm90IGV4cGVjdGVkIHRvIGJlIHVzZWQKd2l0aCB1cHBlciBsYXllcnMgb2YgdGhlIGRyaXZl
ci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgMyArLS0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgfCAzICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2Fu
LmggICB8IDUgKy0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDQwODk2N2E0YzQ1Ny4uZjA0YWZjNmRiOWE1
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTIwMywxMCArMjAzLDkgQEAgc3RhdGljIGludCBoaWZf
c2Nhbl9jb21wbGV0ZV9pbmRpY2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCQljb25z
dCB2b2lkICpidWYpCiB7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2Rl
diwgaGlmLT5pbnRlcmZhY2UpOwotCWNvbnN0IHN0cnVjdCBoaWZfaW5kX3NjYW5fY21wbCAqYm9k
eSA9IGJ1ZjsKIAogCVdBUk5fT04oIXd2aWYpOwotCXdmeF9zY2FuX2NvbXBsZXRlKHd2aWYsIGJv
ZHkpOworCXdmeF9zY2FuX2NvbXBsZXRlKHd2aWYpOwogCiAJcmV0dXJuIDA7CiB9CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jCmluZGV4IDVjYzlkZjVlYjZhMS4uNmUxZTUwMDQ4NjUxIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAt
MTI3LDggKzEyNyw3IEBAIHZvaWQgd2Z4X2NhbmNlbF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCWhpZl9zdG9wX3NjYW4od3ZpZik7
CiB9CiAKLXZvaWQgd2Z4X3NjYW5fY29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCSAg
ICAgICBjb25zdCBzdHJ1Y3QgaGlmX2luZF9zY2FuX2NtcGwgKmFyZykKK3ZvaWQgd2Z4X3NjYW5f
Y29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJY29tcGxldGUoJnd2aWYtPnNjYW5f
Y29tcGxldGUpOwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmggYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaAppbmRleCBiYmE5ZjE1YTlmZjUuLjJlYjc4NmM5NTcy
YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmgKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zY2FuLmgKQEAgLTEwLDggKzEwLDYgQEAKIAogI2luY2x1ZGUgPG5ldC9tYWM4
MDIxMS5oPgogCi0jaW5jbHVkZSAiaGlmX2FwaV9jbWQuaCIKLQogc3RydWN0IHdmeF9kZXY7CiBz
dHJ1Y3Qgd2Z4X3ZpZjsKIApAQCAtMTksNyArMTcsNiBAQCB2b2lkIHdmeF9od19zY2FuX3dvcmso
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIGludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJc3RydWN0IGllZWU4MDIx
MV9zY2FuX3JlcXVlc3QgKnJlcSk7CiB2b2lkIHdmeF9jYW5jZWxfaHdfc2NhbihzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZik7Ci12b2lkIHdmeF9zY2Fu
X2NvbXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkgICAgICAgY29uc3Qgc3RydWN0IGhp
Zl9pbmRfc2Nhbl9jbXBsICppbmQpOwordm9pZCB3Znhfc2Nhbl9jb21wbGV0ZShzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZik7CiAKICNlbmRpZiAvKiBXRlhfU0NBTl9IICovCi0tIAoyLjI1LjAKCg==
