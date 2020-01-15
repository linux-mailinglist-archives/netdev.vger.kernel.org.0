Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4E13C3B8
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgAONyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:37 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbgAONye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewYPAHVanWYWtQvbST/pxQU3Iqx1TCWkNccjCTnI51DppStWnsaOaYbnYJ/Bf64gspioYrKW///9gsxedIaSqt2nhibfXQcj7CztD/1y/rm600mAY2Kn1Yee+F0Oh8X2k5BHMfrbTODpdzO6fnuGuz5dA2c5jmVNOWQD2SPFftZaYurjcSl6JOjDSXosFH+9Ilggc33d8fKf5bAgNURwALegzZcmNJRLIGatEmMzigQPgmtFr+NdoR0I44DC+Arzi8wrIpjK6L2LKM+ltBDWWdVHxhK1vcW5S1TUY878heH9ftvtgLpFrslhlT4JpTZt2asqzRMazsUviOhykz55kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMWYso2kX8M/LHUfsTraTHNa5REJyaaYdjFoAPnNI5Q=;
 b=oaYQMhr0XFBMG14NYKRDWEUEJmKbLeS4dP/pNKMP1sP1PMZrzjc09M5HYepG5XNCI+uzE7JxGPuP199FpNQPxtviVSqUS+7fOAgREs1AhPGnyvnXKwiCam8UG4p3KVDNAUu7C0nrR4NOSZbdrd4WkpGXS07kx71qFvjMzQIzkmZ5OArlLttvHeZvy4npDjZiXTbqQnqBF9T/o0To4Y9/WK9az9gcc6ofUlQrp9l9O+vIAg+MYMa0EKoS7tz1rsCqVyyFjZyB9uSubQXO1Qq4+Mp9Gb6LfNpcbzJJT9QV7ctul4UO6U717pl20E/SaR+ddQs4GI15zHAoZTm5lfoMnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMWYso2kX8M/LHUfsTraTHNa5REJyaaYdjFoAPnNI5Q=;
 b=m6PiMJn0RTrpF2NY1FDqQaRAJfB5BPb4zy8V3WBMEsmUWQwXilqtneSxXrEvZnK5pLKgk0liEwFnoTGIXnpt4CJdufj6JdTaAu9J2L8Gp6edExb1ZUGjjepowvlInsPh8WnseevNE/RcLuK56OB+4LWU4v4DlSxbUKGLGw5xk5I=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:23 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:23 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:22 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 15/65] staging: wfx: simplify wfx_config()
Thread-Topic: [PATCH v2 15/65] staging: wfx: simplify wfx_config()
Thread-Index: AQHVy6tKzOzr7TEIdUy3z0fqjJniEA==
Date:   Wed, 15 Jan 2020 13:54:23 +0000
Message-ID: <20200115135338.14374-16-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 0ed479fb-c446-4594-69ae-08d799c26d57
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094FEA3E299962CBE8B8AEB93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: POT8kdKON8CACoQUbk9t+uJVHFFYpzhMxV4O5yKTBGPOsGIR75QpvA8V7sJApgVBbHOuOyQlmDoNDcJ7BMTN7AjMJznL41DNLHy3YuHJzMFptaSsmgoXgWGJul7kCAbs5BdHh5bMA5znGhhkjRlWJM+/N4gYfFEJxYLQaxc+7SwK0K6/ughtEZ0Bvizs5BtjSzj01VoeFdBWi1V30uDiinkikXeZuAX68n/RDm/57Xt1CJjIzdXFxQvUSXMeFRRbvW5vmrUv7iqmt2moe+xeX6BTRF/pLSrijg7yLmRANnLLY5YlDpfj3CwfPEQETaRNJUNSoKD+RpPx2Uv35ILQcy5C4oj3uzA8J3fGW/UXW4R/Q7Cabc2KMtEA5DD4H9xXmdeUeS7MoVggbjJZdNVgv+N3RSPQmEdyon51lkoSKwAFCxWdaCUSgXtjXbn773dy
Content-Type: text/plain; charset="utf-8"
Content-ID: <155C5EB774DECD4CB530628BF4575B47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed479fb-c446-4594-69ae-08d799c26d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:23.5163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yv7Ki/DA9TIiUdA5R7k7CaZ0COky6JqQPHxoVUl3uwvxgNv2/RC1qP4NrtZU4bOT0ph3Wxuvld9z9CrpTHKXug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTm93
IHRoYXQgd2Z4X2NvbmZpZygpIG9ubHkgaGFuZGxlcyBJRUVFODAyMTFfQ09ORl9DSEFOR0VfUFMs
IGl0IGNhbiBiZQpzaW1wbGlmaWVkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIg
PGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMgfCAxMyArKy0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAx
MSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhMGYxOWQzM2U5NzIuLjQ1MWQwMTA4YTFi
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCkBAIC0xMjMwLDIyICsxMjMwLDEzIEBAIGludCB3ZnhfY29uZmlnKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1MzIgY2hhbmdlZCkKIAlzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
diA9IGh3LT5wcml2OwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmOwogCi0JLy8gRklYTUU6IEludGVy
ZmFjZSBpZCBzaG91bGQgbm90IGJlZW4gaGFyZGNvZGVkCi0Jd3ZpZiA9IHdkZXZfdG9fd3ZpZih3
ZGV2LCAwKTsKLQlpZiAoIXd2aWYpIHsKLQkJV0FSTigxLCAiaW50ZXJmYWNlIDAgZG9lcyBub3Qg
ZXhpc3QgYW55bW9yZSIpOwotCQlyZXR1cm4gMDsKLQl9Ci0KLQltdXRleF9sb2NrKCZ3ZGV2LT5j
b25mX211dGV4KTsKIAlpZiAoY2hhbmdlZCAmIElFRUU4MDIxMV9DT05GX0NIQU5HRV9QUykgewor
CQltdXRleF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKIAkJd3ZpZiA9IE5VTEw7CiAJCXdoaWxl
ICgod3ZpZiA9IHd2aWZfaXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkKIAkJCXJldCA9IHdm
eF91cGRhdGVfcG0od3ZpZik7Ci0JCXd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgMCk7CisJCW11
dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAJfQotCi0JbXV0ZXhfdW5sb2NrKCZ3ZGV2
LT5jb25mX211dGV4KTsKIAlyZXR1cm4gcmV0OwogfQogCi0tIAoyLjI1LjAKCg==
