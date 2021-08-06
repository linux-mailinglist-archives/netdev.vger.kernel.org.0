Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8C43E2A87
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343672AbhHFM3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:29:35 -0400
Received: from mail-bn8nam12on2121.outbound.protection.outlook.com ([40.107.237.121]:46560
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343657AbhHFM3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 08:29:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXZjD6CNq7o1SsGeEk/zqun/LET0JTspHKWuFXaEe0Ib46qtJpBXOSfkmXdf4XSpawNouqmPRLZeYwYTUEalpK19e61afGOuIrm/3vDoWRvQwr+l+G6iTS0UWrKGmWcV3K1s1N1FH6MKIkiBBm8AQW2WItAXLz4E6YinIy7C9vmp2RGvm9Y23aGJNENI01S1K5TvuxSco+8XsPeuClZV/cxuhzjjE+I+bTd5zHpT8En/Mpp+4h/Tktd3zFvzPg9vkkn/QytSCGV94XGUW6o7w7UexTZ0vn05FSL3W3QNDc5PjPAVclOP9Ac3+KgKwZ0sjKW8eEgzNQtmJf9jyYjO7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qwE5whwQ6oYbe8iuv9rfR7dyx6wZg/uahAkIhoFqy8=;
 b=XKM8CUnLj6K9L1vr3FGCUSzbNhYFkMICgRU1aIVmsVvdtBJ6sgPxlZo1o0rTI4ShYu/kvmZtNJ7M72oqgzREbUO+hSdglESVE4Rcwlgb5xqvlldqoDMf8hq40eF5wZLsStGxw6ZNZNZteeAHEaq1DKTmX8f44Sb3+p5qLvFLa0LoIz26dvQ1JctW3z5wSbPQC8cquvbjl263eFPAiqV7F8C39zk/Kh0fmQAthmKDVxB7+bqgUb2KseMjZrDIP8FXcRJa/5Cs0wJYgyv/eXDTWJfWfsLYyUivZv9/Fmr9hpVWo0OkD5VpVMoC2OL23KR0I81ggRzUq5XlL4STyLQoYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qwE5whwQ6oYbe8iuv9rfR7dyx6wZg/uahAkIhoFqy8=;
 b=CsWvmjAL54XMLt3tZnK7HqwHJxg7H7Bv9bFgHQSCBVUZf5tFs7UeuIe+4R7Oe9JYHs/b+BfePk8odIFMYsPam+ohaqSd3sXTq4r6cYXmnlMq7mYPT3cZ6Kd7ycuJ0gOdtIonSgfh74p45gwczRuI70BpG9uh5DGm/wKaXF6RsKc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4825.namprd13.prod.outlook.com (2603:10b6:510:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.7; Fri, 6 Aug
 2021 12:29:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Fri, 6 Aug 2021
 12:29:17 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH 1/2] samples/bpf: xdpsock: Make the sample more useful outside the tree
Date:   Fri,  6 Aug 2021 14:28:54 +0200
Message-Id: <20210806122855.26115-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806122855.26115-1-simon.horman@corigine.com>
References: <20210806122855.26115-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0141.eurprd07.prod.outlook.com
 (2603:10a6:207:8::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0141.eurprd07.prod.outlook.com (2603:10a6:207:8::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Fri, 6 Aug 2021 12:29:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99778932-a667-4afe-5343-08d958d5cee4
X-MS-TrafficTypeDiagnostic: PH0PR13MB4825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4825D24EC49A296E540A5998E8F39@PH0PR13MB4825.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+5Wj0WofYwdgr5GWaiMADCMko9FRxPzwoH37M9vYo5tWkiegQ06xfxYgk/xGFtt3mH/EWE3q9O13n6CS8y7DWF5V3RbhtpHVYBMGG7WosH7M0UXU2xPLOtBjr9W3nExMnPgul22lQhmvd/zRHWfiBBq0xWoOnZn2J7DgOwFUrFxDHo1BbdwgPJ0xu3i7tu2q0qqxHVdp85/X4KRbNRo035RR2Kcls/T7Yt42V5QjZFDqKmQsUQPGhYf9btSsa+cR6e9IpEhMozSHX54O7uRF8Mgioc9UtHz17Yof/8BwVVy3/FvE6NNiRn10EAr8vsrjo/PB5voeSXCdq8lPAnhXiB9tlViULza2aZFQU5HhvgfpAlCooPVJI6DV2WnJ2mrDWld9NdnMTE8I2SnTf6ZXM1Df6qA3s3lxDIRHWXxFH3Kb9MYapcD9ahcwcY3pupKZciX6p/0O/RVqk1Vi2kO5wHlDRS/00lnL5A7DrgJ3K4kKFqwWzWXS1ghVZWo+AJvNQs+S5cEJhVI+T741TO9zuyV4awThXDuLCk6wOBvgidogkFlJ/jdpoBQbGVmcYFvLG2fJTsUZabKIf8+KiZK1sA+G99h+PoiNJioEc/MZR7munyiUroukHNobUNKW6FfPUV5DreVqWTRV23TX5YtZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39840400004)(346002)(366004)(376002)(38100700002)(6486002)(186003)(5660300002)(478600001)(4326008)(52116002)(6506007)(36756003)(86362001)(83380400001)(110136005)(107886003)(8936002)(54906003)(8676002)(66946007)(44832011)(66556008)(2616005)(66476007)(1076003)(6666004)(2906002)(6512007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmFaRWZ5TG9DZjFRZlNJUmtlOVpyMkt2SmVPUjQxR1o1S3gyNnlUYndOSXhY?=
 =?utf-8?B?S2hGL3dONVIvNHUwRllJWldPV3paMGk5WG5McFNiMnhzSllkcDlSckwwNlJr?=
 =?utf-8?B?d3ZjelZCanpxa2ZqTlBVdHdSbzcvZGt6MkJBcDcvQ3hKbjd6c0czWmhZYVdP?=
 =?utf-8?B?b2o4QnRsWkZPSm1vZk4xcnRYMnYzcUVTZWtkWWYrNFIydUpIZTR5Sm1yUjNv?=
 =?utf-8?B?VWF6bTh1RzBEV0VwWWpiYnorK3BhV1FFanpzODJsL1JOMGpVdU5LTlV4cDRR?=
 =?utf-8?B?bGFxLzM5czNEckswN2YzRmlhMkxqTnpHeGRkcGNTdlgzNkRMWTkyQUNXMTBm?=
 =?utf-8?B?MmhsUXZOQUhxeW4za2ZSbzNJcndqNjZod05IUWZVWTBUYmd0a0F5eXh2Y2Jj?=
 =?utf-8?B?Y3ZtbllMWnBSWE13UFJRYW5LZ2FyMXg5YStJQmVqUXpiRGFWTUFyUHRtQ0di?=
 =?utf-8?B?UmphVVJKV3pJcjEvbzU4aElFZE1aOFc1U2NReFZ3clZLZVV0VE9uZThNcjRN?=
 =?utf-8?B?QjlkOWttRmJLWm1qbjdHQndnN29NTExPNG5ITmw2QmZCT0REbEFtelVxSVZU?=
 =?utf-8?B?N2pnS1FIZDFlVHdXbXRuajJLZ1Fhek02Yms4T00vQTI3eTN6Qk1XS3kzRmpI?=
 =?utf-8?B?VU9LUkgwWmFLWHpYTjh0RjNJK2Q0TUloWUxtQ0x2M1YzeDN1bXg4NmRGSVhz?=
 =?utf-8?B?Uk90TnZGMWtyMFpIVkF1K1J5OHRva0ZXb0YrTHVKY1VObUltdWIvK3AyVjE3?=
 =?utf-8?B?ZlBmOTlLZERDSGJjbDcxdHNEVEJtOUswYU4wWmh3MXF2cis2V0RSQUhKN2d1?=
 =?utf-8?B?Z3ljWVpWbEhrd1ZGYUtwOTV5N0ZmK2trN2NRNHlnQnlVK1pqejBEQSt6ak51?=
 =?utf-8?B?THArNUIzNHhqcHA1eFd1NkMrZU5RcmVSU1BkbmZzdFBCS3VQaFczQkdnQ0xI?=
 =?utf-8?B?S1B6NkUweDZ4WGRLamFWdmJFeWI1Ny9FT2FUamw5NjA1eHRaM3ZhQTlUdlNI?=
 =?utf-8?B?aCtMUnN2cXRzbDVlNndzay9xWTJ2SFlVbGxubUFmdWpWZFdlUW90VVRhSU93?=
 =?utf-8?B?dUtIRHZxVjMrK01QVVFPS3BRRE9PbmNKL2t6WXlBUWl2U3BzSk4yUnByd0FB?=
 =?utf-8?B?cXA5OWd4MjQ4S2dWNzFVcUVoa3piRGxzbWFMUURUNWs3M2l0T3V3MEczZWNL?=
 =?utf-8?B?R3QyL0lpdVZZdmVIa1d1bzNYRmMzeWxQbW5XV1FVc0o4YjhvaVcrcXZCNUdG?=
 =?utf-8?B?K1dXOEIzd0JjbEdpR0FpWUJnTGNNM3NEU0VVRk5FV2dFNEJEMXBnOW82THFu?=
 =?utf-8?B?bkwwVnZRc2FYaFQxVGJoZGZRcDZFYUdBK3NESkhFOEJUdkJkN0VqWDZCVmNl?=
 =?utf-8?B?VmQvcEZXKzVTSWZTMVRmdm9xK2FqTjNkWFIrZ2YvN2kvWVJQaXNLdU1SSmMr?=
 =?utf-8?B?blh5WFhOczhoeTlOV3RqL3dOb09SczlqVHJKYTNjTWVjTXRPaXV6Ly9hNHJp?=
 =?utf-8?B?Sm5SS3Q4WTVzelZpK2VWV2haL1NCTzhzSjhNS1NFMFhpa1BIbEVzSGtrRHBD?=
 =?utf-8?B?WHpUR2xDamJSN001dkttVjRlL1F4bXVVYTAwQmpaUFMxak9xc0UyQXd3c3hj?=
 =?utf-8?B?N1Z3N1ZxUzBMYThMMGIyTFRZN3VDTXF4dmxSN0l1UmZ0MldsTEdyN1NEeVdF?=
 =?utf-8?B?VmtOak41eUNLWGFuOS94LzR3WEI5cW1XTXZoTGZRSUF3SS9wazFKdUVhb1Nl?=
 =?utf-8?B?a1Q5eWRQbC9PaDR4WlBxWjBmR2ZYYS9pRkl5aGtPdnFhbGxoMW9mQmhqQTZp?=
 =?utf-8?B?Uzczd0tCdHM4YWhzbHM1U0V4SDcvY0NJOUh3cEkzS0xrb09lbk50cHRrdzh5?=
 =?utf-8?Q?W1vypCR1hyQQI?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99778932-a667-4afe-5343-08d958d5cee4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 12:29:17.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBSqk97kmRBtZSmIpiZo9e7SIRSVIEx7YgoJi3ih56ESt/qWuSdelRuAK9lh5vkIAYpG6HcaADlr6blY54TQQYaP3n0QtUzh6dXnmU01KfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

The xdpsock sample application is a useful base for experiment's around
AF_XDP sockets. Compiling the sample outside of the kernel tree is made
harder then it has to be as the sample includes two headers and that are
not installed by 'make install_header' nor are usually part of
distributions kernel headers.

The first header asm/barrier.h is not used and can just be dropped.

The second linux/compiler.h are only needed for the decorator __force
and are only used in ip_fast_csum(), csum_fold() and
csum_tcpudp_nofold(). These functions are copied verbatim from
include/asm-generic/checksum.h and lib/checksum.c. While it's fine to
copy and use these functions in the sample application the decorator
brings no value and can be dropped together with the include.

With this change it's trivial to compile the xdpsock sample outside the
kernel tree from xdpsock_user.c and xdpsock.h.

    $ gcc -o xdpsock xdpsock_user.c -lbpf -lpthread

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 samples/bpf/xdpsock_user.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 33d0bdebbed8..7c56a7a784e1 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1,12 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2018 Intel Corporation. */
 
-#include <asm/barrier.h>
 #include <errno.h>
 #include <getopt.h>
 #include <libgen.h>
 #include <linux/bpf.h>
-#include <linux/compiler.h>
 #include <linux/if_link.h>
 #include <linux/if_xdp.h>
 #include <linux/if_ether.h>
@@ -663,7 +661,7 @@ __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
  */
 __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 {
-	return (__force __sum16)~do_csum(iph, ihl * 4);
+	return (__sum16)~do_csum(iph, ihl * 4);
 }
 
 /*
@@ -673,11 +671,11 @@ __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
  */
 static inline __sum16 csum_fold(__wsum csum)
 {
-	u32 sum = (__force u32)csum;
+	u32 sum = (u32)csum;
 
 	sum = (sum & 0xffff) + (sum >> 16);
 	sum = (sum & 0xffff) + (sum >> 16);
-	return (__force __sum16)~sum;
+	return (__sum16)~sum;
 }
 
 /*
@@ -703,16 +701,16 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 			  __u32 len, __u8 proto, __wsum sum)
 {
-	unsigned long long s = (__force u32)sum;
+	unsigned long long s = (u32)sum;
 
-	s += (__force u32)saddr;
-	s += (__force u32)daddr;
+	s += (u32)saddr;
+	s += (u32)daddr;
 #ifdef __BIG_ENDIAN__
 	s += proto + len;
 #else
 	s += (proto + len) << 8;
 #endif
-	return (__force __wsum)from64to32(s);
+	return (__wsum)from64to32(s);
 }
 
 /*
-- 
2.20.1

