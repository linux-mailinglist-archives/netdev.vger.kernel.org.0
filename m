Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BC525F826
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgIGK10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:27:26 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:35584
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728692AbgIGKQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cog0jtYXG5TjvXB33yqr7/r8D6X1V3zwCJuJNEpG9BGvOGCUyG62fQd3X1IWXpZ7fRTefD7GUQeVsSb1EaxS6pFRsWBEa2ktB9/fWuO9dpugmotFBn0vBXV5sIEZ7OjzyHvWy6ZmqHKx0JmFQKpn2IdmFKv6/T0KF1ecV597bU2iXWnt1sL7qIRosG55MYO7xkYAXfjaUEfoBpN8hN2A8ojLqFNvIgvRYpsZ/yu1qAMyM74mUb9Trjw/LpLYX57snxgSFEyAv+kLHNefBbVT1uEo5SD163CkAFJ6g20Q1oZdw6ShYi31W4XtVY0dQbMYKg7z4LNtP4yFgJwFtJyVRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilR0rgjekR2aMgOmeXO+36DoF+KIVq0pSubOrxlKjvo=;
 b=cBWlxjsaDEKxvtjM4/nuNaJ6QtF2moY0IGN/CPp5Fd8dFfaTzkTyCWcHYIV82Qw1HDTEmujpm55jgW69WQ2Uxo9RgMvhYbpb4CDr8o2vaBUNyclMHSeHBhwbqBjMpA5Gmw7DVYN/lSIjKD7HL+/4UKH3Gb/FLwoYXeB0LS5iwtLNwrkdfF8lCCQsg+tBvmFrhArU5nLEFkfOnD9EkRrRUbcZWkvmQzqKY+sOhwjPu50RQe3nYlb7haFb7zPGoqrbJYFpVBBVfPUGhtC/6OxaDTKFTxfqwS2HcjvfVElv9fi8kBu3ajVvxMgB1z8cbFH90FBzf6oh18ZjXtScfei76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilR0rgjekR2aMgOmeXO+36DoF+KIVq0pSubOrxlKjvo=;
 b=F32IuuHcgzsApz6jQEqT2yD6YL2M1DnXdXLmZzhm0IfMXir2QyvdN9Gx7evBGGnRfxj6lt1i7sfs7YQZ7WnCeC3SS0NEX2DU00J/Bq9mxFmAXOSRfVWsksiDNw8c5KVwZTWgWGRxZgHiICSe80OEjI2/v202RAkPDgldGMFmcCc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:01 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/31] staging: wfx: drop useless struct hif_reset_flags
Date:   Mon,  7 Sep 2020 12:15:00 +0200
Message-Id: <20200907101521.66082-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:59 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1e467c4-8bf0-44c8-8ba6-08d853170509
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606A38A43285DCDC8143F5B93280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYZY1SIevERO27B0nn47J3y4bG3WmcA8tahIF6hWRl48eC9nQew9tN9SZns8+L0q67BPWoqIfPH9l+ZuXn5adqhNfCHunCwxYqjPQR27UvpKoGlyD4YH8tJlRWlk+ROeaENhAV5VWPAwJtmYRF8i8xjMYm5jLmynZk73GxDjV2CuoJycY+0UIPbS8jt1pY0397FD3Qa131rve5faM7zjqDOAkJ+5myhdegUotKVXb3kmet7sEEZyu0Z6k2kOruVzcszzyFG9rAy1V3oDTNnz+FRu6L2Fimzlw58sIOo17xGs2FCn0ioHz5Pz1ywKKvntKg+uQ3YoYZmkG3BiQ0kbHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fCOTDfmhWpfEupMM5DCZw+xfnYbb/oFP2dsUSRa8vjBH2j/cKhblk6dQiNbuof42LVzpWJIohMVPx2GyzfFIeQEeTgMXeOhJJ5dtIizJZ7BCpkTZjpLRqBSgvRjC04lCjcQuh1rL7qo9Ih/Ibz7whXGd35/Ex+GUT2bNsbHCZUb32B1Fm2GhbQ2pSlkF1cs7bcTd+Z+pXJ36Ips9nYMEDETF1dwonxDQRkQ+WpzFET+g0GaDwe4YWJfvy5IKsddzYpqoMkYPH5YK1SH70bI8f9YFaaUcBdIkILt3E+OiUa+uKZcNJSa+u+zzh88/XGiVP0M+6i1osDI4VRe9v46HwsggcwGE+wtzQ4uR9CEIKeZtWDviLpN2u8/rees6hq6Rb+NhNia/TT7lRfliMxn0ypwK5UlyroNk7Dqb6eACuHqq/X9Hkak0O7jcEYEWsvrz+w7bNA0mgp5LOgX7ILehzUdFA7DRLL/fgYDiWKeeDznqcAydo8LG8WPxxvt/IvGGtTAZzXRovxhy7ce81uPloDYHgRB9+tjtojcj/Lot9bjyK1o0y7xKCw5iPyht+QhsD/Y69aS7jRU4nRiDmyjQoV/TZCycLIZktqlbuEOWTx8w6ZwLYIcJpqYBZn1a4k8fwCDBBgbaSkrbpFrkeQzvpQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e467c4-8bf0-44c8-8ba6-08d853170509
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:00.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uh412PLqwdh44d2ZitLIU1dMQNKSztAfmc67dbkk66L5XttNWG0DegncXNZVm5M5bxboN2I9oRNKcq9VcsXfpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9yZXNldF9mbGFncyBoYXMgbm8gcmVhc29uIHRvIGV4aXN0LiBEcm9wIGl0IGFuZCBz
aW1wbGlmeQphY2Nlc3MgdG8gc3RydWN0IGhpZl9yZXFfcmVzZXQuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIHwgNiArKystLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMgICAgICB8IDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCBjMTMyZDhl
NDNiNTAuLjNkYTczNmRiZjUyYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
YXBpX2NtZC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApAQCAtNjAs
MTUgKzYwLDE1IEBAIGVudW0gaGlmX2luZGljYXRpb25zX2lkcyB7CiAJSElGX0lORF9JRF9FVkVO
VCAgICAgICAgICAgICAgICA9IDB4ODUKIH07CiAKLXN0cnVjdCBoaWZfcmVzZXRfZmxhZ3Mgewor
c3RydWN0IGhpZl9yZXFfcmVzZXQgewogCXU4ICAgICByZXNldF9zdGF0OjE7CiAJdTggICAgIHJl
c2V0X2FsbF9pbnQ6MTsKIAl1OCAgICAgcmVzZXJ2ZWQxOjY7CiAJdTggICAgIHJlc2VydmVkMlsz
XTsKIH0gX19wYWNrZWQ7CiAKLXN0cnVjdCBoaWZfcmVxX3Jlc2V0IHsKLQlzdHJ1Y3QgaGlmX3Jl
c2V0X2ZsYWdzIHJlc2V0X2ZsYWdzOworc3RydWN0IGhpZl9jbmZfcmVzZXQgeworCV9fbGUzMiBz
dGF0dXM7CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX3JlcV9yZWFkX21pYiB7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguYwppbmRleCBmOTFiMTlkZGY4ZTMuLjg3MzZlYjRkNWYxNSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jCkBAIC0xNzAsNyArMTcwLDcgQEAgaW50IGhpZl9yZXNldChzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgYm9vbCByZXNldF9zdGF0KQogCiAJaWYgKCFoaWYpCiAJCXJldHVybiAtRU5PTUVNOwotCWJv
ZHktPnJlc2V0X2ZsYWdzLnJlc2V0X3N0YXQgPSByZXNldF9zdGF0OworCWJvZHktPnJlc2V0X3N0
YXQgPSByZXNldF9zdGF0OwogCXdmeF9maWxsX2hlYWRlcihoaWYsIHd2aWYtPmlkLCBISUZfUkVR
X0lEX1JFU0VULCBzaXplb2YoKmJvZHkpKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2Rl
diwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CiAJa2ZyZWUoaGlmKTsKLS0gCjIuMjguMAoK
