Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DD613C3B1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAONy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:27 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:8538
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729078AbgAONy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpDnZyHJy5dqRf8UGe4jqSOblB39+8xBuuvT5q42yMRUABiPVdRLRk5kGD7yzBTQBI1hhZkReM0gXsBXarzycKSU9otsvZ6fpoJ1PSVnx2fDuevnl4idnCgSpm10CBYtthbHH2P929eMPx9Z/TbTEIDN1m85Bo9NryE18TA+VadTX8nmGbb/EKB7w0v4yR1ybBRf3afJlTw0r8agXMpjMgXlNMq1LkXcdYMCrd0kkbr5xvMwneJyGC+n9SyLu4bgnZKm8jidInMewVkkBhvrrQRPmQbSyNxe8kH1rtjqlMq70IZRmxSXCpT58RVl5HJPg/zAVu+QI5EqqPNzLybWRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlkiUJxQPHorVMQBL0ZcjgHGbnm7YMMbP4keAThtSs4=;
 b=fA1qXM4WMOr2mfj1Tpp41ntuJFeD3GN1ITZUx8LhdHx1ATwapkSLjwRu5UfiIwN4cOnZMtHH7ws0dAVojbb2mNZk0/haimRGjPtbR9Okn43OPafTpbHVAvXUOTdIY7XXYnThjw1g6mOYOPDNcYHONKs5Z1BwBfJDucpPORiAaB54XfRAmvplZxJQaKJBT3x3MRqrI3tXpCLTMezMAMxjvWtthT0r/DpJ9wPWC0IIQRUGHEZ0oPJIWHt4SMvAgv5e8C2BW76lwgqx8IgtM/xIu9Ds1pOsCsA3fio2eqhwE+M94mUdNQKYPy9V2Ol23j2m0YYWznf+eZZaqjVwm0bueg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NlkiUJxQPHorVMQBL0ZcjgHGbnm7YMMbP4keAThtSs4=;
 b=ZcrZgCx4pSJ3Y5LUWqbx85V/7lvp1Qrt/8/OJ0Y9wv20KpDCOoaIA5NNEHjLfl8A3MmjYqLDR5IwgaePJjl8fHiJeXba8GFGXZc8s/u4V+MYhjzTRwJ/R0s8bPjEFIMW+dAzwPqZB4xQZWEeBKbUJWcApMFP4vZk4pvwl2crrsw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:22 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:20 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 14/65] staging: wfx: drop wdev->output_power
Thread-Topic: [PATCH v2 14/65] staging: wfx: drop wdev->output_power
Thread-Index: AQHVy6tK2hW265uuSE+j56iJFoNI7Q==
Date:   Wed, 15 Jan 2020 13:54:21 +0000
Message-ID: <20200115135338.14374-15-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 1f9d252c-3a98-495b-6999-08d799c26c63
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36610092935C651246F1EFF293370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XcqiTLnmTw9PRs/7yncXm2TnWZZaZG0HEQ3K7f3IolcP+9CMzYqhSP4uw4sfDrk9MIB65t9xosKpEcCC78Fd1RA995tgnbk+TpkznmNsCaZWMSQklpNcj2JrY6HoAgdgnpEqp208FNOZdylZXnD0cU1OF0S64Rtg6IVs0vFS84IDoRyNczX/mzoHI82u8EQ2u79xR28sD0U+FRPihyVk01d8jL4gVxArh+kDWpupPccb2n5+UgKgWlZ9wIsBqmk/5jJXczG8uGimk8JQHBJNuhY62FCDVkAzH4vXiJKHsJPJRpJ9GVA0oMls1Iio8AVHvuBxu1D/RZdLuVjEkqmUVupc7ENNMlZbz55aG92LYRlxkX3nucJXKkKZkik5zCq7B0taCh1JaHmxk5xRc27BY29iixA/SKuQP7HN+L7SOw8Jwvj/Fd0pImeDtdDUHIob
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE3FD50D644B254B9FD2B9EA908B94D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9d252c-3a98-495b-6999-08d799c26c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:21.9263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SoMghZIBvI9jOmweS0QRXSYfS3hf4sOfy0bAkLbgLBWzdvK0o2qtC45jYExdxx7yzpTzNqzdPMTjasdd16ZGbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbWFj
ODAyMTEgYW5kIHRoZSBkZXZpY2UgYXJlIGJvdGggYWJsZSB0byBjb250cm9sIHR4IHBvd2VyIHBl
ciB2aWYuIEJ1dCwKdGhlIGN1cnJlbnQgY29kZSByZXRyaWV2ZSB0eCBwb3dlciBmcm9tIHdmeF9j
b25maWcoKS4gU28sIGl0IGRvZXMgbm90CmFsbG93IHRvIHNldHVwIHRoZSB0eCBwb3dlciBpbmRl
cGVuZGVudGx5IGZvciBlYWNoIHZpZi4gRHJpdmVyIGp1c3QgaGFzCnRvIHJlbHkgb24gYnNzX2Nv
bmYtPnR4cG93ZXIgdG8gZ2V0IHRoZSBjb3JyZWN0IGluZm9ybWF0aW9uLgoKSW4gYWRkLCBpdCBp
cyBubyBtb3JlIG5lY2Vzc2FyeSB0byBwcm90ZWN0IGFjY2VzcyB0byB3ZGV2LT5vdXRwdXRfcG93
ZXIKd2l0aCBzY2FuX2xvY2suCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMg
fCAgNCArKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICB8IDE2ICsrLS0tLS0tLS0tLS0t
LS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggIHwgIDIgLS0KIDMgZmlsZXMgY2hhbmdlZCwg
NCBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCmluZGV4IDhlMGFj
ODlmZDI4Zi4uNWNjOWRmNWViNmExIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3Nj
YW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAtNjAsOCArNjAsOCBAQCBz
dGF0aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJaWYgKHRpbWVv
dXQgPCAwKQogCQlyZXR1cm4gdGltZW91dDsKIAlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3Rp
bWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUsIHRpbWVvdXQpOwotCWlmIChyZXEtPmNoYW5uZWxz
W3N0YXJ0X2lkeF0tPm1heF9wb3dlciAhPSB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIpCi0JCWhp
Zl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHd2aWYtPndkZXYtPm91dHB1dF9wb3dlcik7CisJaWYg
KHJlcS0+Y2hhbm5lbHNbc3RhcnRfaWR4XS0+bWF4X3Bvd2VyICE9IHd2aWYtPnZpZi0+YnNzX2Nv
bmYudHhwb3dlcikKKwkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3ZpZiwgd3ZpZi0+dmlmLT5ic3Nf
Y29uZi50eHBvd2VyKTsKIAl3ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOwogCWlmICghcmV0KSB7
CiAJCWRldl9ub3RpY2Uod3ZpZi0+d2Rldi0+ZGV2LCAic2NhbiB0aW1lb3V0XG4iKTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCmluZGV4IGRkMmQwNDIyYzljYS4uYTBmMTlkMzNlOTcyIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTUw
Myw3ICs1MDMsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3ZnhfdmlmICp3
dmlmKQogCWhpZl9rZWVwX2FsaXZlX3BlcmlvZCh3dmlmLCAwKTsKIAloaWZfcmVzZXQod3ZpZiwg
ZmFsc2UpOwogCXdmeF90eF9wb2xpY3lfaW5pdCh3dmlmKTsKLQloaWZfc2V0X291dHB1dF9wb3dl
cih3dmlmLCB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIpOwogCXd2aWYtPmR0aW1fcGVyaW9kID0g
MDsKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgd3ZpZi0+dmlmLT5hZGRyKTsKIAl3ZnhfZnJlZV9l
dmVudF9xdWV1ZSh3dmlmKTsKQEAgLTk5MCwxMSArOTg5LDggQEAgdm9pZCB3ZnhfYnNzX2luZm9f
Y2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJCQkJICAgIGluZm8tPmNxbV9yc3Np
X2h5c3QpOwogCX0KIAotCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfVFhQT1dFUiAmJgotCSAg
ICBpbmZvLT50eHBvd2VyICE9IHdkZXYtPm91dHB1dF9wb3dlcikgewotCQl3ZGV2LT5vdXRwdXRf
cG93ZXIgPSBpbmZvLT50eHBvd2VyOwotCQloaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3ZGV2
LT5vdXRwdXRfcG93ZXIpOwotCX0KKwlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX1RYUE9XRVIp
CisJCWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIGluZm8tPnR4cG93ZXIpOwogCW11dGV4X3Vu
bG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAKIAlpZiAoZG9fam9pbikKQEAgLTEyMzIsNyArMTIy
OCw2IEBAIGludCB3ZnhfY29uZmlnKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1MzIgY2hhbmdl
ZCkKIHsKIAlpbnQgcmV0ID0gMDsKIAlzdHJ1Y3Qgd2Z4X2RldiAqd2RldiA9IGh3LT5wcml2Owot
CXN0cnVjdCBpZWVlODAyMTFfY29uZiAqY29uZiA9ICZody0+Y29uZjsKIAlzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZjsKIAogCS8vIEZJWE1FOiBJbnRlcmZhY2UgaWQgc2hvdWxkIG5vdCBiZWVuIGhhcmRj
b2RlZApAQCAtMTI0MiwxMyArMTIzNyw3IEBAIGludCB3ZnhfY29uZmlnKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCB1MzIgY2hhbmdlZCkKIAkJcmV0dXJuIDA7CiAJfQogCi0JbXV0ZXhfbG9jaygm
d3ZpZi0+c2Nhbl9sb2NrKTsKIAltdXRleF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLQlpZiAo
Y2hhbmdlZCAmIElFRUU4MDIxMV9DT05GX0NIQU5HRV9QT1dFUikgewotCQl3ZGV2LT5vdXRwdXRf
cG93ZXIgPSBjb25mLT5wb3dlcl9sZXZlbDsKLQkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3ZpZiwg
d2Rldi0+b3V0cHV0X3Bvd2VyKTsKLQl9Ci0KIAlpZiAoY2hhbmdlZCAmIElFRUU4MDIxMV9DT05G
X0NIQU5HRV9QUykgewogCQl3dmlmID0gTlVMTDsKIAkJd2hpbGUgKCh3dmlmID0gd3ZpZl9pdGVy
YXRlKHdkZXYsIHd2aWYpKSAhPSBOVUxMKQpAQCAtMTI1Nyw3ICsxMjQ2LDYgQEAgaW50IHdmeF9j
b25maWcoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFuZ2VkKQogCX0KIAogCW11dGV4
X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7Ci0JbXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xv
Y2spOwogCXJldHVybiByZXQ7CiB9CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
d2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCmluZGV4IGJhNmUwZTkyM2Y0Yi4uMTU1
ZGJlNTcwNGM5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAgLTU5LDggKzU5LDYgQEAgc3RydWN0IHdmeF9kZXYg
ewogCiAJc3RydWN0IGhpZl9yeF9zdGF0cwlyeF9zdGF0czsKIAlzdHJ1Y3QgbXV0ZXgJCXJ4X3N0
YXRzX2xvY2s7Ci0KLQlpbnQJCQlvdXRwdXRfcG93ZXI7CiB9OwogCiBzdHJ1Y3Qgd2Z4X3ZpZiB7
Ci0tIAoyLjI1LjAKCg==
