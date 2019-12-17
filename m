Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5346412323B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfLQQOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:14:33 -0500
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:1089
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728179AbfLQQOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZhUu+G831Gl5KMwiE3x+G/UpOSnHboyHGF16wDcX7J/s+IYeTqEgtLweKOKtgcxnEN5kfyu2DF+8BbwupQzyDT1YAof1M7ZkkQzX0UGmj9dnMule9B02BUP+oUa5dZ6mHpbkhLFRlbc6HZfG/t0lqdI/sRnuEiSFzcQ8icMsZ4x/Ajdq1GzSKm/KwqWEMx+vP8iyAB0jDZ9E/4QyqcsMw4sTdYalhWh3FiFMvKh8OTU7GFK8aloOjnTAxPlQj13DRIHm7IYqCgBWnriyPK0YpnLmoaPv4sJKvlu7j3uUC+xvYCZy13TciVNsLHKAIKFsTb8evxWHcc4IVHc38uVGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SllwR4vG+YkzqlvlRssm7wQtcW6OikqRtUGCUbcX9As=;
 b=Rgw6bueztnsMBB0MIltHGU/R1tBBdYVYBrvk3DBYp+SJFKGN1AxUjlgJH26UJZehcfFHeQ1yvHh1fD0GX7fN2mwICU7AJ2721e67WQ36yEYpehdJUj5J6jW0bx7V+f/zQ+Fdxu/Q6+VEeunKp6P0BKqQQRx7EP3smLQM7dPgS8+jXAcSzN/ZUM7X35pFxBo1E8DD1x7d5jgS1DdbgQ6AXGkBdMP2waGMQaQRo1hIENJBiOKu2O3mUzf+RjuDVxosW+oVlTwPg75vrS8IM8gtqsuDAIaEIcEHqk5aKSdG5Iu85rrupUDv45d3sqG48imp+qnhGNJPHvghW4DaEqWDLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SllwR4vG+YkzqlvlRssm7wQtcW6OikqRtUGCUbcX9As=;
 b=GfXM8Db9BOX6/TiG1sQeE5iQn3fCZJAmBWoUO1DpBNOzwQJD8htpejtwsmCqiEjNLpMvfcLFECEbvraoJ85aZuf857WfdzZo18ApEn4RaUmfoAzfSn6ewzl7gFC68nEG73DFCPhuTs8U/JHbLHgvEe4AeWGmjPlq88ZKohp7/WU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:28 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 01/55] staging: wfx: fix the cache of rate policies on
 interface reset
Thread-Topic: [PATCH v2 01/55] staging: wfx: fix the cache of rate policies on
 interface reset
Thread-Index: AQHVtPUOtYz/qB8C10GcnNR+XQOQZw==
Date:   Tue, 17 Dec 2019 16:14:27 +0000
Message-ID: <20191217161318.31402-2-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76c97594-eb8a-4699-3cb5-08d7830c30c5
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3678E67E47F62B156E3B719A93500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39840400004)(366004)(136003)(199004)(189003)(6512007)(66574012)(1076003)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BktBOETnIazi5wmIIE9TPJ+0C/4p7xtGqcD4fII041sQ1wdOkflSWPTPwQzPIDf19v6lxuFDl5shtXHsMiJmrkKuaMfIjpYexV9EFdv8c9XBtkPC7+Tiq94RYrgQvxakPOso2T61xIjx+hkjSzHmAH4pvbP5YGqlu3EVVd0kjuL8DDFS1OYl+LGB0h7fQqYoIQZs9X/mlm+YJBvzj6R6tgh6otGBDPCtoiQiW4Tz3C5BFIQEDV9LVlz0Y21qbJC8CBoW0IzJRtRAXDDmGITweStS7vzdSn/fNaP47fIgOHZV063VHRl0yRFYDi3J8SqZk4qL7AdCfk251Kx3mR7bf2ARJ0kry6ep74kczPkp4I3/weWQK+RMgAs1+aP9m7j2UFIRrhL4xrMvyMvAdRgzK37gsjzOMCkQ4rN99LL2Znp4wxN5VGmdbHqgrX84kQLw
Content-Type: text/plain; charset="utf-8"
Content-ID: <BECE46EEA888DE4192FFD6E77BD0E523@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c97594-eb8a-4699-3cb5-08d7830c30c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:27.8792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: orAHwmr4CgWPJ/yebH6MexxxpaqbwyRbe7a7JvgxXt0106oV1E/lPsIxMiGH7aXtEqVx9Zup+xX7IUvVsxUbVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRGV2
aWNlIGFuZCBkcml2ZXIgbWFpbnRhaW4gYSBjYWNoZSBvZiByYXRlIHBvbGljaWVzIChha2EuCnR4
X3JldHJ5X3BvbGljeSBpbiBoYXJkd2FyZSBBUEkpLgoKV2hlbiBoaWZfcmVzZXQoKSBpcyBzZW50
IHRvIGhhcmR3YXJlLCBkZXZpY2UgcmVzZXRzIGl0cyBjYWNoZSBvZiByYXRlCnBvbGljaWVzLiBJ
biBvcmRlciB0byBrZWVwIGRyaXZlciBpbiBzeW5jLCBpdCBpcyBuZWNlc3NhcnkgdG8gZG8gdGhl
CnNhbWUgb24gZHJpdmVyLgoKTm90ZSwgd2hlbiBkcml2ZXIgdHJpZXMgdG8gdXNlIGEgcmF0ZSBw
b2xpY3kgdGhhdCBoYXMgbm90IGJlZW4gZGVmaW5lZApvbiBkZXZpY2UsIGRhdGEgaXMgc2VudCBh
dCAxTWJwcy4gU28sIHRoaXMgcGF0Y2ggc2hvdWxkIGZpeCBhYm5vcm1hbAp0aHJvdWdocHV0IG9i
c2VydmVkIHNvbWV0aW1lIGFmdGVyIGEgcmVzZXQgb2YgdGhlIGludGVyZmFjZS4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDMgKy0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguaCB8IDEgKwogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgfCA2ICsr
KysrLQogMyBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYwppbmRleCBiNzIyZTk3NzMyMzIuLjAyZjAwMWRhYjYyYiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3R4LmMKQEAgLTI0OSw3ICsyNDksNyBAQCBzdGF0aWMgaW50IHdmeF90eF9wb2xp
Y3lfdXBsb2FkKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCXJldHVybiAwOwogfQogCi1zdGF0aWMg
dm9pZCB3ZnhfdHhfcG9saWN5X3VwbG9hZF93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykK
K3ZvaWQgd2Z4X3R4X3BvbGljeV91cGxvYWRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
CiB7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPQogCQljb250YWluZXJfb2Yod29yaywgc3RydWN0
IHdmeF92aWYsIHR4X3BvbGljeV91cGxvYWRfd29yayk7CkBAIC0yNzAsNyArMjcwLDYgQEAgdm9p
ZCB3ZnhfdHhfcG9saWN5X2luaXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJc3Bpbl9sb2NrX2lu
aXQoJmNhY2hlLT5sb2NrKTsKIAlJTklUX0xJU1RfSEVBRCgmY2FjaGUtPnVzZWQpOwogCUlOSVRf
TElTVF9IRUFEKCZjYWNoZS0+ZnJlZSk7Ci0JSU5JVF9XT1JLKCZ3dmlmLT50eF9wb2xpY3lfdXBs
b2FkX3dvcmssIHdmeF90eF9wb2xpY3lfdXBsb2FkX3dvcmspOwogCiAJZm9yIChpID0gMDsgaSA8
IEhJRl9NSUJfTlVNX1RYX1JBVEVfUkVUUllfUE9MSUNJRVM7ICsraSkKIAkJbGlzdF9hZGQoJmNh
Y2hlLT5jYWNoZVtpXS5saW5rLCAmY2FjaGUtPmZyZWUpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9kYXRhX3R4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAppbmRl
eCAyOWZhYTU2NDA1MTYuLmEwZjlhZTY5YmFmNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3R4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgKQEAgLTYx
LDYgKzYxLDcgQEAgc3RydWN0IHdmeF90eF9wcml2IHsKIH0gX19wYWNrZWQ7CiAKIHZvaWQgd2Z4
X3R4X3BvbGljeV9pbml0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKK3ZvaWQgd2Z4X3R4X3BvbGlj
eV91cGxvYWRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwogCiB2b2lkIHdmeF90eChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV90eF9jb250cm9sICpjb250
cm9sLAogCSAgICBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDI5ODQ4YTIw
MmFiNC4uNDcxZGQxNWIyMjdmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTU5Miw2ICs1OTIsNyBAQCBzdGF0
aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCXdmeF90eF9mbHVz
aCh3dmlmLT53ZGV2KTsKIAloaWZfa2VlcF9hbGl2ZV9wZXJpb2Qod3ZpZiwgMCk7CiAJaGlmX3Jl
c2V0KHd2aWYsIGZhbHNlKTsKKwl3ZnhfdHhfcG9saWN5X2luaXQod3ZpZik7CiAJaGlmX3NldF9v
dXRwdXRfcG93ZXIod3ZpZiwgd3ZpZi0+d2Rldi0+b3V0cHV0X3Bvd2VyICogMTApOwogCXd2aWYt
PmR0aW1fcGVyaW9kID0gMDsKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgd3ZpZi0+dmlmLT5hZGRy
KTsKQEAgLTg4MCw4ICs4ODEsMTAgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX2JlYWNvbmluZyhz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAkJaWYgKHd2aWYtPnN0YXRlICE9IFdGWF9TVEFURV9BUCB8
fAogCQkgICAgd3ZpZi0+YmVhY29uX2ludCAhPSBjb25mLT5iZWFjb25faW50KSB7CiAJCQl3Znhf
dHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKLQkJCWlmICh3dmlmLT5zdGF0ZSAhPSBXRlhfU1RB
VEVfUEFTU0lWRSkKKwkJCWlmICh3dmlmLT5zdGF0ZSAhPSBXRlhfU1RBVEVfUEFTU0lWRSkgewog
CQkJCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7CisJCQkJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYp
OworCQkJfQogCQkJd3ZpZi0+c3RhdGUgPSBXRlhfU1RBVEVfUEFTU0lWRTsKIAkJCXdmeF9zdGFy
dF9hcCh3dmlmKTsKIAkJCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CkBAIC0xNTY3LDYgKzE1
NzAsNyBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiAJSU5JVF9XT1JLKCZ3dmlmLT5zZXRfY3RzX3dvcmss
IHdmeF9zZXRfY3RzX3dvcmspOwogCUlOSVRfV09SSygmd3ZpZi0+dW5qb2luX3dvcmssIHdmeF91
bmpvaW5fd29yayk7CiAKKwlJTklUX1dPUksoJnd2aWYtPnR4X3BvbGljeV91cGxvYWRfd29yaywg
d2Z4X3R4X3BvbGljeV91cGxvYWRfd29yayk7CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211
dGV4KTsKIAogCWhpZl9zZXRfbWFjYWRkcih3dmlmLCB2aWYtPmFkZHIpOwotLSAKMi4yNC4wCgo=
