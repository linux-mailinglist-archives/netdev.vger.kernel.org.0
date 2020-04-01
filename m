Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D37919AA31
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbgDALEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:04:55 -0400
Received: from mail-eopbgr750040.outbound.protection.outlook.com ([40.107.75.40]:63459
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732286AbgDALEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOFEOEjVD+QWLRay/yiAxhJvmhKuQCICWdl0aISmrDOqiliTGVfTI9RKhe35ofL2jaWu0/S6OnADSwFlL+HhklZ6zea3jJu3xMdRK5ym7ATul4b6LBPSv8/HHB8k1IJGRjhhXqf0FqYejHDyFeIUpgP1RAJ7AOJ8jqPykNxGQEB+allRj1BtcE/4RuRUFOdwbur/GDpgH7DIrvXSJ3AhjyMbQWVZhD4JxA1dgb1sWV3HZURW15puFpau3eM1dbP+eMjIA/39BCHnW3DMoqTa4YbEUPMPa8ei5OhMWV7PraKHESZhwKIMjybKtgbvSxM1xSMUYI/ngtUaTB2Z6X0f+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCPfkgAy3PBH9pmlJ2GN6+ehAcOpqsxtHV6Sw/Zy33U=;
 b=jWF0xycvMpj5TQwVUq0+p8snX8SjyuJbaEw+JWSysrQ1Y1+iYBy+zotWiU79noQzMGTg7gwIt3QP3xi7CvYrkPGnF+HICvlkwBWw27xGliM6VswGSoaJTmDZEr/D8f6zLH3Yluc2Ogc1VEg8cKsexIgVH5xJghj+tiOaIFqk2qOy1RlZW70R+z3DTUNSHo06p2JUDA+cs61Ttwe0dHOFRUfOQfGn0yYv/EHIGQrfqiapWunh7Tw92szgl2syyd5i8NCzT9kBhKxCqVzEsS49jNLQk/CuJgQ3SUgBSgBdWHO1y1/mx7svGfn5cw9xICvEuLuv4nQ5xDthXRJAbmcsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCPfkgAy3PBH9pmlJ2GN6+ehAcOpqsxtHV6Sw/Zy33U=;
 b=d4WcK8K9Mno8uQsFQdWNlY8wMiZu/CdTvAAYfUlPJjqQWqquhLh6a38/ecA65oavCchAE+Af6KYzOZ3xmwBkkSPmXSG4926sTce702YWG1D9GwGAwX/GPekhbbsL1dRli2sPvqtdLEQlqHI/OWLZXhp8EvYYxya8nMKtgMq4oIo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:28 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/32] staging: wfx: remove "burst" mechanism
Date:   Wed,  1 Apr 2020 13:03:37 +0200
Message-Id: <20200401110405.80282-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:26 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ff242e7-ae5e-4d69-5e79-08d7d62c7259
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB428538B1BD9E853F57C88F7293C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +AY4YG2a8dOuFd4ioDfku/EX98dB6qTeLmwCmln+/BGpR6opoIjHeO9leB7MOj2gtTEavd5tXLhDxdNAAonQRClgFJ9FWYyh7QoNGzC969Y+SxYvpGllFpaAf7BmZY+s3Mg+es8okbx4FjXHjwd28TW2InndHzNduQmkMShjJ8KtwOnFSigzVNfa8kSEl8ptxeMRrOh96f2nGfSfPKfTQekesfcmT9ZhLtIZWBQYXZd65qXjRFz3r1kdFDPSVQ2KMQTEUoUoBva/f+qxpGZ/nN+gzj/zsFIu0NSU9h1dpaGWGr6FDwnzI8rSpPJD3la5mzCOWre9vbI4BTnx+n0AKfjeBqp/EROaGH2++AcFMmu/Dc/fpx3hhPiN/if6q/Yp0YGFPFT089VSdIAurr1zFkjWSjMbNy9oJXNNilQHbAkK40swxjFO/GAh64ES6xhf
X-MS-Exchange-AntiSpam-MessageData: xXe0dl6NfpvRM9BLYGog+973QAiCd7yl19sl2HLy5bsGC2cie/GAxzb1CdhlTbTe4u7qAd+32QCpTJX/XhiiTnp4lA7rIB3QoHVME6FoMHaihHkKtq4YzJ1Tqojp36oII4ZMK7Bv9VmtbzJnCOLazATkuaSLZs3NZ6J9Xah+xnvWnYWlAiR9NpyGmMZW+E1gSBC6s/05Dz9c4j3rJfFiWw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff242e7-ae5e-4d69-5e79-08d7d62c7259
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:28.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D0yk9RTittMVyxHYxdafRTCt6xcfC3Z9XSoNm6X4Be1n+NZ8eDZ9ZEKLaWX4W81nOKhbayuNO90KDjbFqgGwgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIG9sZCBkYXlzLCB0aGUgZHJpdmVyIHRyaWVkIHRvIHJlb3JkZXIgZnJhbWVzIGluIG9yZGVy
IHRvIHNlbmQKZnJhbWVzIGZyb20gdGhlIHNhbWUgcXVldWUgZ3JvdXBlZCB0byB0aGUgZmlybXdh
cmUuIEhvd2V2ZXIsIHRoZQpmaXJtd2FyZSBpcyBhYmxlIHRvIGRvIHRoZSBqb2IgaW50ZXJuYWxs
eSBmb3IgYSBsb25nIHRpbWUuIFRoZXJlIGlzIG5vCnJlYXNvbnMgdG8ga2VlcCB0aGlzIG1lY2hh
bmlzbS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAyMyAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgIHwgIDIgLS0KIGRy
aXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggICB8ICAxIC0KIDMgZmlsZXMgY2hhbmdlZCwgMjYgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGUzYWExZTM0NmM3MC4uNzEyYWM3ODM1MTRi
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0zNjMsOCArMzYzLDYgQEAgc3RhdGljIGJvb2wgaGlmX2hh
bmRsZV90eF9kYXRhKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAog
c3RhdGljIGludCB3ZnhfZ2V0X3ByaW9fcXVldWUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkJ
IHUzMiB0eF9hbGxvd2VkX21hc2ssIGludCAqdG90YWwpCiB7Ci0Jc3RhdGljIGNvbnN0IGludCB1
cmdlbnQgPSBCSVQoV0ZYX0xJTktfSURfQUZURVJfRFRJTSkgfAotCQlCSVQoV0ZYX0xJTktfSURf
VUFQU0QpOwogCWNvbnN0IHN0cnVjdCBpZWVlODAyMTFfdHhfcXVldWVfcGFyYW1zICplZGNhOwog
CXVuc2lnbmVkIGludCBzY29yZSwgYmVzdCA9IC0xOwogCWludCB3aW5uZXIgPSAtMTsKQEAgLTM4
OSwxNCArMzg3LDYgQEAgc3RhdGljIGludCB3ZnhfZ2V0X3ByaW9fcXVldWUoc3RydWN0IHdmeF92
aWYgKnd2aWYsCiAJCX0KIAl9CiAKLQkvKiBvdmVycmlkZSB3aW5uZXIgaWYgYnVyc3RpbmcgKi8K
LQlpZiAod2lubmVyID49IDAgJiYgd3ZpZi0+d2Rldi0+dHhfYnVyc3RfaWR4ID49IDAgJiYKLQkg
ICAgd2lubmVyICE9IHd2aWYtPndkZXYtPnR4X2J1cnN0X2lkeCAmJgotCSAgICAhd2Z4X3R4X3F1
ZXVlX2dldF9udW1fcXVldWVkKCZ3dmlmLT53ZGV2LT50eF9xdWV1ZVt3aW5uZXJdLAotCQkJCQkg
dHhfYWxsb3dlZF9tYXNrICYgdXJnZW50KSAmJgotCSAgICB3ZnhfdHhfcXVldWVfZ2V0X251bV9x
dWV1ZWQoJnd2aWYtPndkZXYtPnR4X3F1ZXVlW3d2aWYtPndkZXYtPnR4X2J1cnN0X2lkeF0sIHR4
X2FsbG93ZWRfbWFzaykpCi0JCXdpbm5lciA9IHd2aWYtPndkZXYtPnR4X2J1cnN0X2lkeDsKLQog
CXJldHVybiB3aW5uZXI7CiB9CiAKQEAgLTQ1NCw3ICs0NDQsNiBAQCBzdHJ1Y3QgaGlmX21zZyAq
d2Z4X3R4X3F1ZXVlc19nZXQoc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJdTMyIHZpZl90eF9hbGxv
d2VkX21hc2sgPSAwOwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmOwogCWludCBub3RfZm91bmQ7Ci0J
aW50IGJ1cnN0OwogCWludCBpOwogCiAJaWYgKGF0b21pY19yZWFkKCZ3ZGV2LT50eF9sb2NrKSkK
QEAgLTUxOCwxOCArNTA3LDYgQEAgc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCQlpZiAoaGlmX2hhbmRsZV90eF9kYXRhKHd2aWYsIHNrYiwg
cXVldWUpKQogCQkJY29udGludWU7ICAvKiBIYW5kbGVkIGJ5IFdTTSAqLwogCi0JCS8qIGFsbG93
IGJ1cnN0aW5nIGlmIHR4b3AgaXMgc2V0ICovCi0JCWlmICh3dmlmLT5lZGNhX3BhcmFtc1txdWV1
ZV9udW1dLnR4b3ApCi0JCQlidXJzdCA9IHdmeF90eF9xdWV1ZV9nZXRfbnVtX3F1ZXVlZChxdWV1
ZSwgdHhfYWxsb3dlZF9tYXNrKSArIDE7Ci0JCWVsc2UKLQkJCWJ1cnN0ID0gMTsKLQotCQkvKiBz
dG9yZSBpbmRleCBvZiBidXJzdGluZyBxdWV1ZSAqLwotCQlpZiAoYnVyc3QgPiAxKQotCQkJd2Rl
di0+dHhfYnVyc3RfaWR4ID0gcXVldWVfbnVtOwotCQllbHNlCi0JCQl3ZGV2LT50eF9idXJzdF9p
ZHggPSAtMTsKLQogCQlyZXR1cm4gaGlmOwogCX0KIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDlkNDMwMzQ2
YTU4Yi4uYTI3NTMzMGY1NTE4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTUzMSw3ICs1MzEsNiBAQCBzdGF0
aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAogCXdmeF9zZXRfbWZw
KHd2aWYsIGJzcyk7CiAKLQl3dmlmLT53ZGV2LT50eF9idXJzdF9pZHggPSAtMTsKIAlyZXQgPSBo
aWZfam9pbih3dmlmLCBjb25mLCB3dmlmLT5jaGFubmVsLCBzc2lkLCBzc2lkbGVuKTsKIAlpZiAo
cmV0KSB7CiAJCWllZWU4MDIxMV9jb25uZWN0aW9uX2xvc3Mod3ZpZi0+dmlmKTsKQEAgLTYyNCw3
ICs2MjMsNiBAQCBzdGF0aWMgaW50IHdmeF9zdGFydF9hcChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikK
IAlpbnQgcmV0OwogCiAJd3ZpZi0+YmVhY29uX2ludCA9IHd2aWYtPnZpZi0+YnNzX2NvbmYuYmVh
Y29uX2ludDsKLQl3dmlmLT53ZGV2LT50eF9idXJzdF9pZHggPSAtMTsKIAlyZXQgPSBoaWZfc3Rh
cnQod3ZpZiwgJnd2aWYtPnZpZi0+YnNzX2NvbmYsIHd2aWYtPmNoYW5uZWwpOwogCWlmIChyZXQp
CiAJCXJldHVybiByZXQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCA4Yjg1YmIxYWJiOWMuLjExNmY0NTZhNWRh
MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3dmeC5oCkBAIC01MSw3ICs1MSw2IEBAIHN0cnVjdCB3ZnhfZGV2IHsKIAlzdHJ1
Y3Qgd2Z4X2hpZl9jbWQJaGlmX2NtZDsKIAlzdHJ1Y3Qgd2Z4X3F1ZXVlCXR4X3F1ZXVlWzRdOwog
CXN0cnVjdCB3ZnhfcXVldWVfc3RhdHMJdHhfcXVldWVfc3RhdHM7Ci0JaW50CQkJdHhfYnVyc3Rf
aWR4OwogCWF0b21pY190CQl0eF9sb2NrOwogCiAJYXRvbWljX3QJCXBhY2tldF9pZDsKLS0gCjIu
MjUuMQoK
