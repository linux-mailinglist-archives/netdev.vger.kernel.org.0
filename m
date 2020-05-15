Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B448E1D4897
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgEOIfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:35:21 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728270AbgEOIeY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScwwXEfV/KkR54B7d8ErHT/5b7sOVDm1FnGgOSG2KliRqaUQK42ecsdQ728o/MfHocwWGzN+52D8SkwCVTb46qptnh46hMVXfo6xogOEko3qpKD6eV3u+3+poqLO6FImWXQcDfwYH+OSbRWpC7zFa6yXlFoADta0cWI3KG8b4kAQtYeJ+Z4APnhzIbeCuGL5taOzCkCEUQmQzuTMT1vnCFdVyct315z2+tFtT/nT9fKHiQ0GT0W05PB4gcwV5vxmxI3F7zjAmZgwYchAfN7uqhbeFqdBDOXPhJjd9SiEcBZAbsGK+sgwmjDfjwpunCgYU9vTkXW5ptuoY3H8a62law==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1KsEeVqMBr+/ebPyiN3ljP2PGoIgoaLYOBcpxbcrOw=;
 b=eT8ack5uarry2KRXNC0qy9jfdxm7WOXJoPq4RJ9fN67+ST1IcHdOmHTaUh1J6BFrxwXTp1+GbfScwPRO6mLNSVebYXJmuAkocqMumuXYYo3FRz80CmuSpK4NuPAVQV7P5wqaSGhiK3y5RBPxpFHy2GgZFAREe6G6WTDLgbDDHhdxj0qqyD41rDLlbULiBjwcmRMU1eBrwr1sIuQC2DtFbP/whvRaC7QacDVN1D0PG6lkJkoX8gmxlRTaexVVRsCGBYUJsN0xM7NpZ9hejF8M8mi57pnwXmr+dN7cKwrfFZ6VQn/Ar6EAhdmwgGnKqJqpVz6+v9QFAzP9MLkPlXNRNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1KsEeVqMBr+/ebPyiN3ljP2PGoIgoaLYOBcpxbcrOw=;
 b=kdTav/fZy1uOgfHjQ64vxncOqS1aw4lG18OYwl4bBt6zaUjBLK0V0tMorbrPahyVlAHmD7FxXB7BW6ZEnSA/1Ke5i6qQJq3IxzCrzzUiNluQmj/2n+Dw9SXeJM35ds+oLCY6AGEMghxsxifHK0sBiU239brCPqj/Clgm0fgRP9s=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:09 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/19] staging: wfx: rename wfx_do_unjoin() into wfx_reset()
Date:   Fri, 15 May 2020 10:33:17 +0200
Message-Id: <20200515083325.378539-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29607120-9d94-4515-4e45-08d7f8aabceb
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB131081B1BA8F140E3CC19FC693BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpacTwfz80ffgfmYG50vIYjWGmVAhIoaeojKEwlNBA65XLiOcVr+MLeBp9iTsYybvTd02IjxPowtFc/GYoCS+oaAyQgsTSLFzbwrOQbZgbSft9GOsHFcUDG5T8qkffoAWu/9C6jBevCnISqvT1UOy0e59KN6lhzjkvN/1dYOpgSf4wQ8U4AZFn7nP+K+nkhK/dSd5m+o7vQenjBGEDAR9A6UkxmXMTBjLX0CZhYDLqouvmalU8Osda6IOeG62zssUzcHmZzz4CnVsBXuc5EHCHwo3D8vbbwnujzeKYLJflVu2xjmE1nUgWByrjq1iZGqujmBr/4TUVjRtuuTDgBUvBF0G0EWqhN87ofHFAPP7EUoOYgwWotmeKNmJwu4DocdKTZA6N+1iCoAyqJQgBsmujPKqUyBeoOKBwJ3Q/gq42COi74e49XMYJnFDMs2F6Ek
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wi4a1l+jRG+ZOG3251G1mTU6LvL8mqfdfTMoIZkLFM+qLbp36giC5o85fqSTDjLqwTLLQ/dRQdlhpFSgtzcO/jSF+uXMGzNUuMgaU/FCGQXIYK/iAwvSOdK3Grg5w4briGv3Jr1xJcq0o1G6FdLxbHHMVThsZIB+Lbv/7xSnysd5meJXp4PUCipsUd4odnO3tp4KGopdzfGoPL79b7sel8SDPJL9EOg68Tgn2ajiaI8PqUOgMnki9QFs1grRRmSN5RwE/zElunYQbqqrcMz7+ALNE9bI5dS+yX1oOHtZO9VuNa/JxZHXTITb/TXPfF0eZQXLpnPBsrntL/82kljGQRPozLC3WI6ChW8WL0WT2qGVN1k9KGhAvm1cd9P7jmWhfdoxsod71q/P5erpFq6tw9ShyPXn5M0jN0Mz+SPuqGEURcmRCQR4FQOkoivriPSVvTdE3ZqAB9TIyi3IW6Lh5mb5KDe2QSu2FGYAYGoRhcw=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29607120-9d94-4515-4e45-08d7f8aabceb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:09.5200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGf9KnfMA7NVDFVfd0Gh/2iMh/9k4KUYYQJtVM/2oNd/LS0i63SQN7H5MH+LnPGsQEZV/CbDdqY9Ly74cLtPig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
ZmFjdCwgd2Z4X2RvX3Vuam9pbigpIHJlc2V0cyB0aGUgaW50ZXJmYWNlLiBUaGlzIG1lY2hhbmlz
bSBjYW4gYmUKdXNlZCBpbiBtb3JlIGNhc2VzIHRoYW4ganVzdCBkaXNhc3NvY2lhdGluZyBmcm9t
IGEgQlNTLiBTbywgcmVuYW1lIGl0IHRvCnJlZmxlY3QgdGhhdCBmYWN0LgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAzMiArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCB8ICAxICsKIDIgZmlsZXMgY2hhbmdlZCwg
MTYgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggMWE4NzZh
MGZhYWY1Li5lMDc3ZjQyYjYyZGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMzE1LDIwICszMTUsNiBAQCB2
b2lkIHdmeF9zZXRfZGVmYXVsdF91bmljYXN0X2tleShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IAloaWZfd2VwX2RlZmF1bHRfa2V5X2lkKHd2aWYsIGlkeCk7CiB9CiAKLS8vIENhbGwgaXQgd2l0
aCB3ZGV2LT5jb25mX211dGV4IGxvY2tlZAotc3RhdGljIHZvaWQgd2Z4X2RvX3Vuam9pbihzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZikKLXsKLQkvKiBVbmpvaW4gaXMgYSByZXNldC4gKi8KLQl3ZnhfdHhf
bG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKLQloaWZfcmVzZXQod3ZpZiwgZmFsc2UpOwotCXdmeF90
eF9wb2xpY3lfaW5pdCh3dmlmKTsKLQlpZiAod3ZpZl9jb3VudCh3dmlmLT53ZGV2KSA8PSAxKQot
CQloaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3kod3ZpZiwgMHhGRiwgMHhGRik7Ci0Jd2Z4X3R4X3Vu
bG9jayh3dmlmLT53ZGV2KTsKLQl3dmlmLT5ic3Nfbm90X3N1cHBvcnRfcHNfcG9sbCA9IGZhbHNl
OwotCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmd3ZpZi0+YmVhY29uX2xvc3Nfd29yayk7Ci19
Ci0KIHN0YXRpYyB2b2lkIHdmeF9zZXRfbWZwKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQkJc3Ry
dWN0IGNmZzgwMjExX2JzcyAqYnNzKQogewpAQCAtMzU5LDYgKzM0NSwxOCBAQCBzdGF0aWMgdm9p
ZCB3Znhfc2V0X21mcChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAloaWZfc2V0X21mcCh3dmlmLCBt
ZnBjLCBtZnByKTsKIH0KIAordm9pZCB3ZnhfcmVzZXQoc3RydWN0IHdmeF92aWYgKnd2aWYpCit7
CisJd2Z4X3R4X2xvY2tfZmx1c2god3ZpZi0+d2Rldik7CisJaGlmX3Jlc2V0KHd2aWYsIGZhbHNl
KTsKKwl3ZnhfdHhfcG9saWN5X2luaXQod3ZpZik7CisJaWYgKHd2aWZfY291bnQod3ZpZi0+d2Rl
dikgPD0gMSkKKwkJaGlmX3NldF9ibG9ja19hY2tfcG9saWN5KHd2aWYsIDB4RkYsIDB4RkYpOwor
CXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7CisJd3ZpZi0+YnNzX25vdF9zdXBwb3J0X3BzX3Bv
bGwgPSBmYWxzZTsKKwljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJnd2aWYtPmJlYWNvbl9sb3Nz
X3dvcmspOworfQorCiBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZikKIHsKIAlpbnQgcmV0OwpAQCAtMzk1LDcgKzM5Myw3IEBAIHN0YXRpYyB2b2lkIHdmeF9kb19q
b2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCXJldCA9IGhpZl9qb2luKHd2aWYsIGNvbmYsIHd2
aWYtPmNoYW5uZWwsIHNzaWQsIHNzaWRsZW4pOwogCWlmIChyZXQpIHsKIAkJaWVlZTgwMjExX2Nv
bm5lY3Rpb25fbG9zcyh3dmlmLT52aWYpOwotCQl3ZnhfZG9fdW5qb2luKHd2aWYpOworCQl3Znhf
cmVzZXQod3ZpZik7CiAJfSBlbHNlIHsKIAkJLyogRHVlIHRvIGJlYWNvbiBmaWx0ZXJpbmcgaXQg
aXMgcG9zc2libGUgdGhhdCB0aGUKIAkJICogQVAncyBiZWFjb24gaXMgbm90IGtub3duIGZvciB0
aGUgbWFjODAyMTEgc3RhY2suCkBAIC01MTMsNyArNTExLDcgQEAgdm9pZCB3ZnhfbGVhdmVfaWJz
cyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIHsK
IAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7
CiAKLQl3ZnhfZG9fdW5qb2luKHd2aWYpOworCXdmeF9yZXNldCh3dmlmKTsKIH0KIAogc3RhdGlj
IHZvaWQgd2Z4X2VuYWJsZV9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxl
KQpAQCAtNTgwLDcgKzU3OCw3IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJCWlmIChpbmZvLT5h
c3NvYyB8fCBpbmZvLT5pYnNzX2pvaW5lZCkKIAkJCXdmeF9qb2luX2ZpbmFsaXplKHd2aWYsIGlu
Zm8pOwogCQllbHNlIGlmICghaW5mby0+YXNzb2MgJiYgdmlmLT50eXBlID09IE5MODAyMTFfSUZU
WVBFX1NUQVRJT04pCi0JCQl3ZnhfZG9fdW5qb2luKHd2aWYpOworCQkJd2Z4X3Jlc2V0KHd2aWYp
OwogCQllbHNlCiAJCQlkZXZfd2Fybih3ZGV2LT5kZXYsICIlczogbWlzdW5kZXJzdG9vZCBjaGFu
Z2U6IEFTU09DXG4iLAogCQkJCSBfX2Z1bmNfXyk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAppbmRleCBjODRjMzc0OWVj
NGYuLjhhMjBhZDlhZTAxNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCkBAIC03MSw2ICs3MSw3IEBAIHZvaWQgd2Z4
X3N1c3BlbmRfcmVzdW1lX21jKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlf
Y21kIGNtZCk7CiB2b2lkIHdmeF9ldmVudF9yZXBvcnRfcnNzaShzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgdTggcmF3X3JjcGlfcnNzaSk7CiAKIC8vIE90aGVyIEhlbHBlcnMKK3ZvaWQgd2Z4X3Jlc2V0
KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKIHUzMiB3ZnhfcmF0ZV9tYXNrX3RvX2h3KHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LCB1MzIgcmF0ZXMpOwogCiAjZW5kaWYgLyogV0ZYX1NUQV9IICovCi0tIAoy
LjI2LjIKCg==
