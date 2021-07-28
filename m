Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89493D88EE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhG1Hgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:36:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30350 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232691AbhG1Hgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:36:35 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S7Ganb006586;
        Wed, 28 Jul 2021 07:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=iUyZsdg71UL/8uTbbAssii/OaMusSXBn/yn5ciEwzi8=;
 b=gY0/+SxgKcwTwXxGPOJ/fe25gNEuPkXyvEOh4bgUGv6hWcPgFK+Cg41zSorjIAO+xTyZ
 k1T/peowZLclkvFP0MvYajkPwSbAqFfirCwBdGp7JNVtJy9qwwxNiYBgmE2piBjSORc6
 D5lAzI7mb5/vX2pCbdB0xhaG/f6gvaKAeSdYeklhZnTC4eOzWvNdbFD4BEPmVJe4xdzZ
 PaYnxxqnf20zGtp0Qzgw2GcDbEf4rhRM6rHC1DvWsdWLjN2aZmDsYabZ1jkrbMP1ce17
 wi2FZqzwwKfN7RRTKGGNRabinlV5MUoV8MIqtQXgMCvgrtfyM4nbXSEdT6i1IGtLueT1 cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=iUyZsdg71UL/8uTbbAssii/OaMusSXBn/yn5ciEwzi8=;
 b=ljPnWkPl26nSs0geomrsojj+//SJtixsyM4QKiMNSRA29197ACzsiqCohhnYuN3zU0C5
 xT7+bb88T+Fp9/zNrrf6O3G1Vt+PFR0BzwDKCQQZdHBvFvb5Wy9E/rclgAMumWHxpSGm
 2J7ldYWH4mXtkeHTAiLMGZl7LwmCF2AKvjJWleH+fqgKtRl6rgttfjE5EO2Ezz9K3eyG
 LF/4IbcB+KrQq7kwgcm8OqPhwVH88uDu9mg44pXypoAeTLh+f68ekSMx/njK5ZYeyXFc
 8vtNOAKUm4vc+aDMELMF05ZX1KOrsA8SP8QmHC4OJkbonFWvo9rAw7EaI61r21cnvHbi Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfa0bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 07:36:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S7Yu9I071526;
        Wed, 28 Jul 2021 07:36:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 3a2354m8gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 07:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea4Zpd2uT0/uYTRhXs3Widgzk0chWwnH615aWSriqLweKkNAEPs9I0iEd2R1ReTm7RjsUYeWR/Dvgrr/LuHWHAzuQkBzodTgkmlqrbLoynyla9TcUl1CSs6z8kJ4tTsl5jK3oBmEw3t7/SP9OrIsF+4jZIHwtiIU7cT+mIpqYJhliQuGCT391Mtc6hZpbyqGQ7tVN5nwbA+F5LyPBDA/pzAexPQBdHkR7v3/a1d8wfPm204pJpmqOipOZJLugcQNF0fytomj6gIWNYY5FHKgFC1239XQxrftg077suDVIs+IJMZHD9GBA/iZoaEzZCbBWqA4YhH6nV89s56nnNi6bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUyZsdg71UL/8uTbbAssii/OaMusSXBn/yn5ciEwzi8=;
 b=MvXVOwWYxn+jBSCwCSRikvgjxGYHNKLPSPbzN4JqiB6zIvIdlzEpjWnJ52BkTh9MOnHUlgeTQqruwJnu1ZH4hSH24b0nz0P7Bd9WWby3PuEwj7EBEDVlOc3IpdzEQFDjccCDFLBxK5Gr+TSHqUmwbVWvhwILgQ42RjV+uk361RCB6Z8TOsmWKgwro8CwGycy8ETuolJOFrV3UDGLk+Y3NpbnzJeNFP0tmY9qRjpjSWn0TDPdMSyEBGynColtfiBFGsKIRlvKXt5n3mUR0T7L0FKHt0KDvlAQpk01s0RJVND7S+jvlewh5j4I9KVTIf+PzkZJ1WHv3JQclbfwM8A2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUyZsdg71UL/8uTbbAssii/OaMusSXBn/yn5ciEwzi8=;
 b=S9sFUDYguRa/BR6/QbooMUAMrz+dB4UuaF0zN8RsyF71M1qaZcQj8v9zvr2vy3/Su4+17wLspnkm1IRB9xzpYuOa3KUN4CviIwamoo1Nb/2PoMY3GvS97UTp/GJE2gUEcHrM/AZGS4mphrDq2K+iOHZugmdO0X/ThWPGPtLNTvA=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1823.namprd10.prod.outlook.com
 (2603:10b6:300:110::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 07:36:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 07:36:20 +0000
Date:   Wed, 28 Jul 2021 10:35:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 02/64] mac80211: Use flex-array for radiotap header bitmap
Message-ID: <20210728073556.GP1931@kadam>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-3-keescook@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-3-keescook@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 07:36:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 528e340e-6c6d-45be-fef6-08d9519a6433
X-MS-TrafficTypeDiagnostic: MWHPR10MB1823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1823366B33655771C9EE841E8EEA9@MWHPR10MB1823.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FM5uyf1RjD2vOqO1Ar5On6BeA9zCWdiHOIvkEpC4CWwfsgWAEUydN8mhKKGRaPyeprxZNgNRUIZ/B7RRVg2DZP/3XbunLyeym+HN/GTZvrpVAfgKlIIYV86UXI25jykTsWWAPOq6gbj5yb4E2Mw3Ve+jrqKTV/AYjdazYKSkjDWpuNI08alUvKJImY+t2S69gi0f1Q1aozgSqJiXShhKEaHDDBek3hYM5+SQzj/w1dkYkIOZ/edOKUrbjc8oAWRF5iWXRkueQdIyah+r3IDADdALSUSF5aCHSL9Ft2P+pD9yoHtIhWVrGhNHU+1KwFl7UCBm0idS89Uke4FYMvg0a00M0/bazNa8AXZo09VKuxIB1I/s3kWFKd+vX4U+E2Tp8WqtBCUNoFU2/mjJECtwRRkyLlzmss3Y6cINAkDSyc9BUhEnjZ5wlDVxk5NAmjSA5QSc+ToLwB6B0GhcoDmfT4gLWkovFMM4f2IL4FDL3VhDiKQmiaLqysHe/MIYh54Ldt+iFJ7uvpGCsmrVT50A1ycxFx1dyXRPVY1A3n+AwzV9sEN2DbFHXUyewJde033S8H0FvD5DF8v0YhNpFuVue4AX38cXE3zW30upz8l9CJJ803nJyj+shMqgiyjJ+FHzfrL05o04Cxu0N8vE0oG2mfvj6OiMRMfWoGbGl+vtsuny+KmTgvj7LpOJBlYZjWTmGQeb2c6WNJXrWcYaZ0tumQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(86362001)(38100700002)(38350700002)(2906002)(7416002)(4326008)(9576002)(8936002)(956004)(54906003)(44832011)(6496006)(52116002)(33656002)(83380400001)(5660300002)(6916009)(316002)(186003)(26005)(6666004)(1076003)(478600001)(66476007)(66556008)(55016002)(66946007)(9686003)(33716001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xJbfF3FtviXJJGzptUJjFXQG0ZEL71Xage6OQv+rLQgb/AShBSWSw7udSdGL?=
 =?us-ascii?Q?VjtnPQxZTxiMR+Ejq3cqK42vOWLWCXZ2x9refSo/K6CALZhmuuWNXlvmUHIU?=
 =?us-ascii?Q?ZvvflN+mvzXgVpwHmMtMuO7qgocT3RXwtzIpdVIwI4Q+7ffam+Ehzm7t7pyA?=
 =?us-ascii?Q?n3vMYhnSAIQ9sxiFbLHj9c+ofTYeKYzr/JSpvPnUP4CX9410eruNbZg11Dcq?=
 =?us-ascii?Q?zzQveuHZvPUMnZFDJcom9sHtYbMljPMDrm8X9w2Aj+1BgkDlovi2Bu95zG5h?=
 =?us-ascii?Q?gUwSyTPvWi/XJp1Pc/ySUCWxLL3+bKBYbgQxSU8odmkWkBEKpvIeP2nK1Nqe?=
 =?us-ascii?Q?RulEVTjpLPss+Aqc0w3rq8EZ8qH35iq0GV7ypjpZAoqix+vyHXrv1PFaBVIq?=
 =?us-ascii?Q?tE8MjviGQIo+Xefx8EpxgUboUoO5GEpG8xKJzde8tbYHxZAQ7v5V4QYcA/r8?=
 =?us-ascii?Q?qrAySJNNFal2dhpFNCibZ2+O6065G5YIbj0YiZtSVY3SoSXEqnGBdGEbuAj6?=
 =?us-ascii?Q?18YV3bRgqM6omfKI8oLx03O/CGi7NrRD81XidG39FGVU+LglPtndsds5kkzn?=
 =?us-ascii?Q?vNUU6h1kCbrl46NnWiwoQvtWpU6AMg4UPcMDj0yJJDRXq1x8U8yVKI0VWJcY?=
 =?us-ascii?Q?BNFSeSJXSS98/WS3UEjcy9cqTVLj52A9Swh6h71fynUMqcSTcacFUNyNW1d9?=
 =?us-ascii?Q?/z4LeMu3AbDENBTV064PB+1THZl1ytGJ5lE8nVJtj7jLpoTBNA2xbMySDRzX?=
 =?us-ascii?Q?kK90lZ+DlbPK0s6Iz0sENfzmFglX1gqaYhhmnV+IN6OVm0rODZZVixAo+4En?=
 =?us-ascii?Q?mX7SDF+yf/9W+9c1mRFS+o1xXtRmaSuAcmR5mXI7FSUFCexx8qFb73JUJs8r?=
 =?us-ascii?Q?qpjEJdErskQ0cK8s+U3AK/ntAPfGeJiVTmlktylPzC0oYvlCvRb/mFQyY1/q?=
 =?us-ascii?Q?RmuHpaFBbzlRixUaWueMN4mpzp/dtUOdREc6dbtZTryUKZ/asdbqmD3SPmw+?=
 =?us-ascii?Q?NlQxzWJvnsirK98Sm7xSxu1JKVCSi5xtxWA6ZUfNkoS2C1MRqVNYpTLIeJcH?=
 =?us-ascii?Q?Cf5cnEV1aFSgi0j86h/DAnE7qkM/9hdpW2+9kBQ/Z+1EDN9+sXVsg+pzecae?=
 =?us-ascii?Q?byTib18ad4XbCnIKU+uVMEsi6/XtzO25Vn0VrBf1GshudkbnoCZLXc3amd07?=
 =?us-ascii?Q?nr7ii1vWmPBPPaIDDMQxWbLTSSLWzsqu5Y19n9v3OrZGW2Tl0/ckuN1scHo0?=
 =?us-ascii?Q?ZNwPTLeTSYG+jHgmGrdR63nEn1LU//9vgewKAsyF692qwxHLAPNRZMIE8vj1?=
 =?us-ascii?Q?R24szslkuZ2PU0FgTOM4wf/1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528e340e-6c6d-45be-fef6-08d9519a6433
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 07:36:20.3165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7VLyOuIi1yC2CeTU41RM+DLp7WL9CtA/GKmkaRbpOlNWzEyuyfTjySFjUWtX8Si+lTU1ceco2P3a3fffEZb6kXVxXd3iJfFiPXb6P7oYNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1823
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280042
X-Proofpoint-GUID: cR4q8qtkwg64r25iE_LSTBA9F0qpqnIx
X-Proofpoint-ORIG-GUID: cR4q8qtkwg64r25iE_LSTBA9F0qpqnIx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:53PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> The it_present member of struct ieee80211_radiotap_header is treated as a
> flexible array (multiple u32s can be conditionally present). In order for
> memcpy() to reason (or really, not reason) about the size of operations
> against this struct, use of bytes beyond it_present need to be treated
> as part of the flexible array. Add a union/struct to contain the new
> "bitmap" member, for use with trailing presence bitmaps and arguments.
> 
> Additionally improve readability in the iterator code which walks
> through the bitmaps and arguments.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/net/ieee80211_radiotap.h | 24 ++++++++++++++++++++----
>  net/mac80211/rx.c                |  2 +-
>  net/wireless/radiotap.c          |  5 ++---
>  3 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
> index c0854933e24f..101c1e961032 100644
> --- a/include/net/ieee80211_radiotap.h
> +++ b/include/net/ieee80211_radiotap.h
> @@ -39,10 +39,26 @@ struct ieee80211_radiotap_header {
>  	 */
>  	__le16 it_len;
>  
> -	/**
> -	 * @it_present: (first) present word
> -	 */
> -	__le32 it_present;
> +	union {
> +		/**
> +		 * @it_present: (first) present word
> +		 */
> +		__le32 it_present;
> +
> +		struct {
> +			/* The compiler makes it difficult to overlap
> +			 * a flex-array with an existing singleton,
> +			 * so we're forced to add an empty named
> +			 * variable here.
> +			 */
> +			struct { } __unused;
> +
> +			/**
> +			 * @bitmap: all presence bitmaps
> +			 */
> +			__le32 bitmap[];
> +		};
> +	};
>  } __packed;

This patch is so confusing...

Btw, after the end of the __le32 data there is a bunch of other le64,
u8 and le16 data so the struct is not accurate or complete.

It might be better to re-write this as something like this:

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index c0854933e24f..0cb5719e9668 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -42,7 +42,10 @@ struct ieee80211_radiotap_header {
 	/**
 	 * @it_present: (first) present word
 	 */
-	__le32 it_present;
+	struct {
+		__le32 it_present;
+		char buff[];
+	} data;
 } __packed;
 
 /* version is always 0 */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 771921c057e8..9cc891364a07 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -328,7 +328,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	rthdr = skb_push(skb, rtap_len);
 	memset(rthdr, 0, rtap_len - rtap.len - rtap.pad);
-	it_present = &rthdr->it_present;
+	it_present = (__le32 *)&rthdr->data;
 
 	/* radiotap header, set always present flags */
 	rthdr->it_len = cpu_to_le16(rtap_len);
@@ -372,7 +372,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			ieee80211_calculate_rx_timestamp(local, status,
 							 mpdulen, 0),
 			pos);
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
 		pos += 8;
 	}
 
@@ -396,7 +396,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos = 0;
 	} else {
 		int shift = 0;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
 		if (status->bw == RATE_INFO_BW_10)
 			shift = 1;
 		else if (status->bw == RATE_INFO_BW_5)
@@ -432,7 +432,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM) &&
 	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		*pos = status->signal;
-		rthdr->it_present |=
+		rthdr->data.it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
 		pos++;
 	}
@@ -459,7 +459,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->encoding == RX_ENC_HT) {
 		unsigned int stbc;
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
 		*pos++ = local->hw.radiotap_mcs_details;
 		*pos = 0;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
@@ -482,7 +482,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 4 byte alignment */
 		while ((pos - (u8 *)rthdr) & 3)
 			pos++;
-		rthdr->it_present |=
+		rthdr->data.it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_AMPDU_STATUS);
 		put_unaligned_le32(status->ampdu_reference, pos);
 		pos += 4;
@@ -510,7 +510,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->encoding == RX_ENC_VHT) {
 		u16 known = local->hw.radiotap_vht_details;
 
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
 		put_unaligned_le16(known, pos);
 		pos += 2;
 		/* flags */
@@ -553,7 +553,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		u16 accuracy = 0;
 		u8 flags = IEEE80211_RADIOTAP_TIMESTAMP_FLAG_32BIT;
 
-		rthdr->it_present |=
+		rthdr->data.it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_TIMESTAMP);
 
 		/* ensure 8 byte alignment */
@@ -642,7 +642,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE);
 		memcpy(pos, &he, sizeof(he));
 		pos += sizeof(he);
 	}
@@ -652,13 +652,13 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE_MU);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_HE_MU);
 		memcpy(pos, &he_mu, sizeof(he_mu));
 		pos += sizeof(he_mu);
 	}
 
 	if (status->flag & RX_FLAG_NO_PSDU) {
-		rthdr->it_present |=
+		rthdr->data.it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_ZERO_LEN_PSDU);
 		*pos++ = status->zero_length_psdu_type;
 	}
@@ -667,7 +667,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
 			pos++;
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_LSIG);
+		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_LSIG);
 		memcpy(pos, &lsig, sizeof(lsig));
 		pos += sizeof(lsig);
 	}
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 36f1b59a78bf..f7852024c011 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -114,11 +114,10 @@ int ieee80211_radiotap_iterator_init(
 	iterator->_rtheader = radiotap_header;
 	iterator->_max_length = get_unaligned_le16(&radiotap_header->it_len);
 	iterator->_arg_index = 0;
-	iterator->_bitmap_shifter = get_unaligned_le32(&radiotap_header->it_present);
+	iterator->_bitmap_shifter = get_unaligned_le32(&radiotap_header->data.it_present);
 	iterator->_arg = (uint8_t *)radiotap_header + sizeof(*radiotap_header);
 	iterator->_reset_on_ext = 0;
-	iterator->_next_bitmap = &radiotap_header->it_present;
-	iterator->_next_bitmap++;
+	iterator->_next_bitmap = (__le32 *)&radiotap_header->data.buff;
 	iterator->_vns = vns;
 	iterator->current_namespace = &radiotap_ns;
 	iterator->is_radiotap_ns = 1;
