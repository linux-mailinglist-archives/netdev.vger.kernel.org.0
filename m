Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668781D489D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgEOIfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:35:51 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728131AbgEOIeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/dfV2LiQIDjBhXgVNLHVR4J73XmJtBL92BjAh2/2ajRGNkvLTvSPiiu1lK85Ns7TOvAVCkBGBdNoLTDfFB/M2vE0hGVDAlIK9GCuwJnyuDMfj2GcZxcXB9ykwu1qKr+T74o+KOvIjYIkzTV/CtAMTS6xR+ZasD0n9Jz3FJHsTfM/dVHV91Jt191AMhDxQPNHkeVh6aDTXEspf3P9IP0BZO4Rc3aCrX9hAqHWgfKvRvlMa5C/so5Slvw/N0RLBjtV+8m451yePYp+SkoyHmCI7lfemJF60xsNTvSuJ5VFPjLq909oS0CRnKa3tiAp27WICOtwF5wHNVbtxvOuq0/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWXDdKWpwCAYPA7jCIaxh69IDl8y2OAZ+Qb1Xv0M0nc=;
 b=BlmIXtOnWvblwywRoW+N8aGhifpo2sGrgJuL3JW/hO7Hwn+iK9sFmhP5HnM3BpeaY0qZ19QzfDmCCRm9vKy0vseswbLRsmmID96TGGvd1O6xLpsolzl/Dwx5RsRYtH9EYxaLW1+wIUAGuIenLKPyAD6Wnqo/Bw6wd++WC16YuUTN77YJFfV2zbww7wM1erfJQ/iRdKUS6z3qVY3OqaDcVYYELmfImIZ3P3JK1QUUPa18lF0XAZVw9WzdpEsd8Qsg+jBJgpeGH5CTLTwwxutg2daZlvbtzIJjjpkg4lCn0Dn1gY0LOj6LSFbQKCvwWKmkedTSR7QeT0HvhiMo7bNHng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWXDdKWpwCAYPA7jCIaxh69IDl8y2OAZ+Qb1Xv0M0nc=;
 b=ezkSfX2nWfTK6bLnWnT6xMMsugk0yrh6vUvAEs6kc+VWM9BqlU021bKAf7QTVEg0iaYUgPKRs/Y7ZzjNU1QNdDlPZCiOf+FyOpT3bzudWFfxnNnx5c8NNRKQiDlNJM3bRqB3/CURngxcitVtnu711LLPM7gjB1F7y5YFSnGW8zM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:02 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/19] staging: wfx: fix status of dropped frames
Date:   Fri, 15 May 2020 10:33:13 +0200
Message-Id: <20200515083325.378539-8-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f05338b-c248-4f99-82fb-08d7f8aab83a
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB131065F2FEFDB58A6A7AB62393BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cb+cNuPZxnciouXHWucKFcwdLsc4hnXXplRi+LURyQo5R3MEn2hHlmwBhck95R2BQLDgtqPC6pbPkDurushrpnz00IdKt0aSdSMOytGiov2njxniyKXNi39qijJ+sY+i/3J75HWtAhqnFB+yvpnsqa8NvyHD3sAFE4eOXNZmvGxXMud1LlisSpgcakyauYW4KyYnzJ5Pk3vaAY7IyjgkSUvUBNdVDx3cj5Bwq6Toaf8l7TQSZxkbI/NYGgBInnrs9WxbvQJMlKU3nronrifaF15VdjdQmf68mrDESSbcVgaIv5t9yX0OuGZvv83g5uBCdFHnPVoMBY63rUz/r0VQUZkDpKN21EOui7q+7PhPhfREGOzCMrYN2EFOF7fpHS3hE1Ku7g3qc/3X46EnTxzOFsi+tNtuWzbFn9jp+003R5Hn+R0ODqm5eDrVYtLd1LYn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(4744005)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HjseBLukwqMYj9F9KYgEqADtNwslV17udSAZfT1Tvke4LSqQpFRuHJJOQv6Hn2UJdoHmc9BqIojFG0zbXj2ZY4Tf//wWcQBeiVr8BgMkjVCYDI3eyUDLpbRrG+ALK3+xzdSQI8EbNzt2rhhKTKI0+aemzkrz2G43cPP5S+8R4Im5eBda4CH38qhW+22GFHS8AZPqr5FIGRorOUktqUwngVVQHMvxbHdGGptx4yCswvmNrjhF9frZHEQIm9mCNzevQCkghKJtQOI7exG3LsUjDsTfh+9lrQWA1qetqNdM7ESTwCh+mU3tzGQaWBWhs7EoWQLs0tXgfZtXYviWDxXw/u7mlmQ1tjZSfqfCmATIhN4ppF1MD10WZVX+ArSBIDDr6HiRDZz+qXAgHezkwnYHYjqIAO/+SfYWUfFUWiwLDeLZPwbkrXW206HaMOYbiw4+O/h1+3m2r4W68CmnW1DcsOYXlkR8pEempcPNXRDMvcU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f05338b-c248-4f99-82fb-08d7f8aab83a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:01.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oeGhyB5n5PFAbPxPRDYyGCd3//2Pv1Qn+VWPfg9oR5oAo1yKph85r8dREoSUbveeU08unCPT2qw5uPyGZa/Eig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB3ZnhfZmx1c2goKSBpcyBjYWxsZWQsIHRoZSBzdGF0dXMgb2YgcGVuZGluZyBmcmFtZXMgYXJl
IHJlcG9ydGVkIHRvCm1hYzgwMjExIHdpdGggcmFuZG9tIHN0YXR1cy4gbWFjODAyMTEgcHJvYmFi
bHkgd29uJ3QgaW50ZXJwcmV0IHRoaXMKc3RhdHVzIGluIHRoaXMgY2FzZSwgYnV0IGl0IGlzIGNs
ZWFuZXIgdG8gcmV0dXJuIGEgY29ycmVjdGx5IGluaXRpYWxpemVkCnN0YXR1cy4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCBhMTI1OTAyMTRhNWQuLjVkMDI5
YjA3MThlOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTYxMyw2ICs2MTMsNyBAQCB2b2lkIHdm
eF9mbHVzaChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZp
ZiwKIAkJd2Z4X3BlbmRpbmdfZHJvcCh3ZGV2LCAmZHJvcHBlZCk7CiAJd2hpbGUgKChza2IgPSBz
a2JfZGVxdWV1ZSgmZHJvcHBlZCkpICE9IE5VTEwpIHsKIAkJdHhfcHJpdiA9IHdmeF9za2JfdHhf
cHJpdihza2IpOworCQlpZWVlODAyMTFfdHhfaW5mb19jbGVhcl9zdGF0dXMoSUVFRTgwMjExX1NL
Ql9DQihza2IpKTsKIAkJd2Z4X3NrYl9kdG9yKHdkZXYsIHNrYiwgdHhfcHJpdi0+aGFzX3N0YSk7
CiAJfQogfQotLSAKMi4yNi4yCgo=
