Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C672428BE3
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 13:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbhJKLZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 07:25:41 -0400
Received: from mail-eopbgr1320120.outbound.protection.outlook.com ([40.107.132.120]:62851
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233913AbhJKLZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 07:25:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHrLPEhTKBZl1VvebL8GYV26DXJwA2XxLE7FEaKVJAeCYu3SBPiDP2J9dHHjozW0Q0IgsRNno3g6th3Ody8qeWM1/XdPOGTWbbWFkcpwa1am8C15jJndmEOT3ztD7fbaC5q9w4XZTRqFZSzPPAUWR/qNQqjEpIRb2vSeaEkSI1amrxG1i2WU+pTEO4e0pinQ7BqcNd/llh1lo9OvpKtBcq5amQW5AltHOOF6HVKkR2seROq6j/rAJ2rmzbplY6ocg8ROZ6P7fNmawbNqx9hyoFI3L4AsfBZ4/gElOs3RNowya+C8C+aHrtw7iFtFJvNK6RB73/mZgGpg+705pS8pSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER/Mx7+nssZ/OpWEVMvGcvUQOIMgFhAF0IkSgo/ER4w=;
 b=C9yCufhiKb3o388NMpL6ujJRzY18deHge2OziB2SlUMJ6d/gS/cQjnGHIZbgd1fja+DMZaMXTgGij+hnyc67bf/jrtcq8PAjUfG4pTYbFOKJ4ZaJT8oHFHwzuh1+V7wooXqLvii52fgWthpbZJrRtScZUX1xKRY2Z4Ub1rsf7WUSXG1IRa/ibKOikw0+e171ZQi/UaSk/O1/cH8l30K1eBCGibKgDsmTUpWkxiGy5U5wtinew0I709/6Jury1ESxRInt5FDa+L6op6Z6rK82CkR5OlWEz07Jdxrdwpdh+3w6pW18w+Rytz99L9BC5eyzFM/EUmY8nyzT3Xi77URNNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER/Mx7+nssZ/OpWEVMvGcvUQOIMgFhAF0IkSgo/ER4w=;
 b=gflFDxlX2taKFMMTKVHkRSl0sGvb4JpaTy2iGG6MpgK9CJCWOIPif1FW2gx9xCYlALZhoFEukuy6rN1uvb+oMczZyjFG0IzTIZAce3XqOR3S0SrUaCAl+4wZm0xXwyHKtn4o2nVNH3agdBNBsNt8qUiF1RtY8CoXqoz9+5GxXD8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB3821.apcprd06.prod.outlook.com (2603:1096:4:df::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.19; Mon, 11 Oct 2021 11:23:33 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 11:23:33 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] selftests: bpf: Remove dumplicated include in cgroup_helpers
Date:   Mon, 11 Oct 2021 19:19:48 +0800
Message-Id: <20211011111948.19301-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0015.apcprd03.prod.outlook.com
 (2603:1096:202::25) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from NJ-11126903.vivo.xyz (203.90.234.87) by HK2PR0302CA0015.apcprd03.prod.outlook.com (2603:1096:202::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 11:23:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee98f123-dd16-4af4-7db7-08d98ca98f2a
X-MS-TrafficTypeDiagnostic: SG2PR06MB3821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB38218BE0155E60F271291E9AABB59@SG2PR06MB3821.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09v7iv6jusmSasLE9dFeMIZEuA9IGFBcztzAUdW0s/FdykYo7PV9WXkjrcVq2hZbgO3jdzpFZIC5cqcga9BvTIHcQpnhTneoelaHLPu4r2mioO2Wy776kNT9zQBSPQBbUP7gtQ7aARSI4wuo2DFIEwxsAlfn/SnVbfuuQaJEpOdj67iWP1gXDAjWSc6yfEopA17V3ywdjAQs4FqyCe03vt8rvSTFnK5Z5RcAjEmcGoXF5dANbeTA7sygKiVMX53evfE1h6ngjCMRWSEdUfhhZl0ul+Y3Kd0l9NazLmziZ/ZgrkS1faGsVbdmcsmGaSazYoiURyBFenKRW1yQ7RuMY0nvgcQG+WgKxziHzGoo9Zmluu787bwRW1axtUumd+IIGf6Mkmg0FfC0LPr4rFNsb/RM6f7wjqOiOu+F1OcpozO/bDOUjQni5+kzfsHHY9MqDJDrRwCLA0OhTJjXvJXTZKAJlrxvreV0tGLHHPL8Yeh0qUcCudAXVCzYvHuQPgwwtE/O163djbzlPeiA69fSU86l7SXHN554UuBxeSCAq+hJxyvKGLcjmfM/o5NxY3UfQNBcfgCVWnUo47OTTathgriJANdaPtXIj2zOY0pQlEN5TP1UgGZ212Eq54+h58Udt6FIERvFvcFNpN254bid0PYHq60/5G+hHFEqghXGY90JUq6bzLjEmeONx/em1vxYQzzjJkhbiz55uvrRPTVdHrNrePXkq/dh3OVo/T8nn/5xzORptIMqjwU5fu+pl+uB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(186003)(4744005)(8936002)(52116002)(26005)(508600001)(2906002)(8676002)(86362001)(36756003)(6506007)(5660300002)(6486002)(4326008)(1076003)(83380400001)(6666004)(110136005)(6512007)(66946007)(956004)(38100700002)(38350700002)(2616005)(921005)(66556008)(66476007)(316002)(7416002)(4730100016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2/PKx8Jq8gWVehCGNknW9vtHAAkRG6AM65mq2kmOKvGVYuKg9gEV2XaYeOMW?=
 =?us-ascii?Q?0nVK2PtEjMOfmhurE3A3L4xHwAE8d3HYrj/IwPO8pMvOmTTm+KDV6p4+BhGa?=
 =?us-ascii?Q?Ny+Rc2QR3eD/fqdVv/wDzZXejPaf1pHGs0DgDcOB8AxcJEMhr8BMEcgYahav?=
 =?us-ascii?Q?wo1em7e4qKHWb48/8E/0S103ZRlcRoVqmZxx9KCZTN5kPDxpGI8SupdqrW5x?=
 =?us-ascii?Q?AvFqgAXAX+PQcyOojCxJu0XIELpKpGhTyGA5pQpDuIOszrTYSzCpdq4/p0pN?=
 =?us-ascii?Q?9j79n8YGk+ZazLWWc18HYbH4FQyiyt7T3Q0EyvevO1aGN7KL0UXNa8eFU/LY?=
 =?us-ascii?Q?w5GDN6VrVxibbmYthTPqj+0D0RVasgl6QuKn3kzfQqmL7NGiYfl2ZlyAnEue?=
 =?us-ascii?Q?3XfttA+FYFesUkxb7SCCnyMtmiFc3sT1ZkWEsgfyCVHNbWyzPh+BwYSU9Ion?=
 =?us-ascii?Q?10ugV9gR37ZGTHvcaN3E8wPjjXBHJMRnUqTkE7hySLfU0jEG5w0boCF2iihl?=
 =?us-ascii?Q?J9HyZnioKH68Rbr5RIQZKzvm1WSWd72UxQ1A3niaXN+avl4QTgNEsy/r+GiI?=
 =?us-ascii?Q?XR38hdVdJYizCRAHxZB3lS9r7ZQITUCBlXSp3bwUtPpRzB3m9r/jgTbD0XQp?=
 =?us-ascii?Q?dlVbAUlA91j38Uog0iTi5TikUJM6JDbr0v9Mr424lQwr1hC5F+Q4r3A1SUBX?=
 =?us-ascii?Q?F61k65sr6ViFizksXkOvzdH90A9yUigmJiqog95JbXrI0VzJ2CODwHYLKf2x?=
 =?us-ascii?Q?zuXIJe/0RRuVGz3YUiFZlzdSxbnzkUFkc6JttwR6mbR5YTuDdy2Eg+3NRdav?=
 =?us-ascii?Q?ZP+y2Pc6PajzA+3E2vOA+MktY/QAXSc3MAkz33Lr9bijSZ+qPqRvhS6j64JK?=
 =?us-ascii?Q?4/BFknEssnwXf+WhL1Qkw1Nl8aKGwofpxltw3E5IykkMOW2aWHm1vmVW2lYs?=
 =?us-ascii?Q?8heVMFhMSw3EM4QnLJqJCNUdXv2rVIe573A7D5cqTT7ksNeBkxkws1y/flB5?=
 =?us-ascii?Q?LUnp3L7k6G/AZcdUPhDAbnVgjtOBHNtB7q9TSxSE3XqQXyRu3MImuN52FNS+?=
 =?us-ascii?Q?cfRqP5CDhkWlNTRJNMw3hcvRZDMWfz7o2ZZNn2Sdz0wIm6lAmPDAmYHPyuS8?=
 =?us-ascii?Q?v4d4TTWQejb260xzyV9SW8D7JNAKmg1FniGasMgsQBTAFmOeI3H9mkqhx+1D?=
 =?us-ascii?Q?YiFhlrTGdSpHO+THxhMs9+1DhusnbpVmq2xSpFt4tNCfaLseiRAgWXXkrky9?=
 =?us-ascii?Q?0qkuOcy73dHwL/ACeqDDrQxCRdar6w6A8LCqd+ZC/jxJ6y5PJr+bL7ffrEB9?=
 =?us-ascii?Q?UKosafgkHGYJdx+1lvvvndoT?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee98f123-dd16-4af4-7db7-08d98ca98f2a
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 11:23:33.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a4EnZGhY4qX6me0btOCes7zhoFgIPphWG+blUEHuclVX5ba5+6t5/xGdcSov48ldprgpq7W2l82jiA1rnLFwRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3821
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following checkincludes.pl warning:
./tools/testing/selftests/bpf/cgroup_helpers.c
12	#include <unistd.h>
    14	#include <unistd.h>

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 8fcd44841bb2..9d59c3990ca8 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -11,7 +11,6 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <ftw.h>
-#include <unistd.h>
 
 #include "cgroup_helpers.h"
 
-- 
2.30.2

