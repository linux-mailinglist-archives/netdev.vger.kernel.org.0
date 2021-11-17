Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B62454715
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbhKQNYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 08:24:17 -0500
Received: from mail-psaapc01on2091.outbound.protection.outlook.com ([40.107.255.91]:58816
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232163AbhKQNYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 08:24:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc6tVO23DQKg1ZINErCla6TkTlyQ5WgmytkX2yuMirZu7g4St9JDD6kAMd7IO4OfT550tLj/BYPx+bADQeyzhu8hvfOyVrA3bf7/9laDRHI0QLeiLOgf5gVRQ9t2B2eV/7z/q0MN0WI2qGzJwae+fP1q6uwxsHb3um93L/nALKUyJwj4ljv42AuJmsRXtWZpf0+re+6ARDkXQNPxgm1goyuIlvOy1v3ohdC306Kn4O61v5zc4V0GYu5SGTap1F6+Z0uL3CKgMHEgh3hvQb4IJhgcyIhqNgyJbpmksl0oXndzvQMlXJF/cgQV5K3awH8/6Fo3b2SqqE2J2LT9r8yfGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2NvRqKMLckh2uVHLfaiTqUvJOhUzJ9lTZUSF5eCNuQ=;
 b=n4YQ67X9CVC0cOuXTPg/eQR7kFqLkqDGp4EynIX/mk1TylDm81SsPAeHlxnCEytUO9nNrnzGXaEZ65mcvToDRr/8gNvMCd5A6DXzDmMkA9IaekMSBfRV5Q3bMIOdYIx4Cpygm4t4HBQAylvXkomgHflLDdEjI+0ASsjE/deDRIzgkmsgMFIfXqQ/zpdQc/7A/rI5g0Oyi6rohqMYJLz2Ia4xSLAWtliUYKRiylMwwcVXHlE5mOLwMvAXmygDRKiWWj72lNzPYi5cRlphL4q4RQ/MD/TRmvvm8a6wbcgWCV+H/dVnsvpEsvyzzUBrPicm1XXkGjQ+u0ZZ1xhjlyJt9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2NvRqKMLckh2uVHLfaiTqUvJOhUzJ9lTZUSF5eCNuQ=;
 b=kSpKbKenPWnOq3tcdeh/PIHFsasZZS+mTofGtCqZvPX5F5NZng+BqDfOYVlE1EuBz9PqW687Inf607ySKswNCLJbr//HxL09fjotWig+ubEN3omAxelVPTicbko6QvLr23e5KnBVdG0vl41fGXfhZm/lPLVlEZ5iCT+AWx8niQQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK0PR06MB3841.apcprd06.prod.outlook.com (2603:1096:203:be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 13:21:14 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768%7]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 13:21:14 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com
Subject: [PATCH] selftests/bpf: fix array_size.cocci warning:
Date:   Wed, 17 Nov 2021 21:20:21 +0800
Message-Id: <20211117132024.11509-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:203:d0::12) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HKAPR04CA0002.apcprd04.prod.outlook.com (2603:1096:203:d0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Wed, 17 Nov 2021 13:21:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0f05955-5f96-4827-24b3-08d9a9cd212f
X-MS-TrafficTypeDiagnostic: HK0PR06MB3841:
X-Microsoft-Antispam-PRVS: <HK0PR06MB38419ABFF5F458DE7F0F3FCBC79A9@HK0PR06MB3841.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6iZpdEqWdfGjHfhCWx/IckwHUZOeDhPDBN2er+oJgGJUmZ1PWeP2firPSbckiJE5wKnq/sZaCbm3G/WjNWKdgZDKqeMnclB7HLHAXJBowF4lRpFdcDU2OCDOXgdvnboH22bviT2HzoithmvfpjNqC9kSSsb4j/0AYY4rkwG5SqxoEK5DqyWP2+mOlQjZmv+JZ39TW9xUQ/cVuNG9g4SrUftFOKG68MSBKU6kRUKOfoRvV44ti9P96gtET16VYsPQD69KT0Vs7QfRmvO9IfcYjQPXLc8UTh0Lp/4w2Hvro1jIgS8dqVSXpyRMFj4s59OITCKpQ9Fwl+7MRQeb2ITa8L+wYfPNySEg/KcE+7/en7/jM1I9jeyB2PonPOwem7nxWg0SmWyyy3GmpvazCqgNa95pA4nRNiX431ymN8X0iwTWMusTnqMGeqXft6nhjbgL0XGSFXKn9mCcij0vf9SnueaNTSnMGwFMLKXD/Z4+HmdpuA3e3YzyPSL+CiUwMd62pK6btzMHEDzkNRKVYCGfOmzig8owq+5WuL56X5Bj63bMHP196qDaDAMqmjFy4u7gVAcz1tWJF+YxqDTfO9glY/QdBVQkX8frKKYpLQMv1NMVfN0HvwJcuLMTNbPdxrhRn9fFnjtb2EkfdHz18w1rMGdiVTYhaxTsnM4x52BPIOC6ixl4dS7F9G01jgSbzKhhLJa0ejWYZbZSCwWFNsc7H47epy9pP+Yz0Tj+f3XicRM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(186003)(6512007)(1076003)(66946007)(921005)(110136005)(956004)(2906002)(38100700002)(38350700002)(316002)(107886003)(6506007)(4326008)(83380400001)(7416002)(8676002)(52116002)(6486002)(508600001)(66556008)(66476007)(8936002)(86362001)(36756003)(26005)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l7kOTOTdkNtT2/z4sq0HQijwHP0J8dmfenCY5g9K6q20o91JQ96pPwtQNtPn?=
 =?us-ascii?Q?ohHHadScgo9WPG7IIh9kbM9G9Y+s9H6XbNlOChDT0WrTbkwL2waPs3y5XucE?=
 =?us-ascii?Q?qciIc9NA9+nJ3gIQzrqtPzBzWth21CNPQ6EhqnpKh/5uQ6OEdDB6fanKqTu5?=
 =?us-ascii?Q?ETzWekiuCrfcPEsfdjFX3eKtdIgrrK15Thz6+Kj5z2PpatU4+986uqCopmyz?=
 =?us-ascii?Q?DaIX4OUhWC1vsgPclkIodjBxViRjJRUIxCtB4Zw+QnBABdv898l2rKidJ8kn?=
 =?us-ascii?Q?cjL+TGvuB9F/3VycAs22yCIhk1LUx34Yk8LbKcdXuBMWpfsYanX4jnS3ZZ5F?=
 =?us-ascii?Q?Uel8jy44XdMLUG6KG+Zk4EThCz7jF1zFqewFUSBBRgmaJHApNpuVkliq5Dmg?=
 =?us-ascii?Q?LNf1/ns5U0KjQtXq8bnQ5aX6ZvC+w5bOfSnyf4KRvWILa0c47LxLlH1f2dge?=
 =?us-ascii?Q?lWlEjVsclEu19F0Z7+T1rhEp06e6zDNpDipmmNgCw/bjutOiqUeO719bPeIk?=
 =?us-ascii?Q?KaQMplKYduBVMVi4j+GWXVqtXf39IUfh9XS5Y4U+1TIhSS2P0m41eIV7EJ6+?=
 =?us-ascii?Q?wbVx/Os2jvLX0p5YqBl2wzaPGJ7hJLeAgn6TgB3l7O0vXkjz2mpwd7rxc7bN?=
 =?us-ascii?Q?USXp+mftcNnHUQCIAC5zYPVecZDLNBVtsEI435qFLXsbswFni7LA9aTI0C/F?=
 =?us-ascii?Q?uReR+CDoGFQe09cmXvOOoUhqCFVxDcBa6l+nII5r8jJsrd1JrFbWI66wDDoN?=
 =?us-ascii?Q?mxiEFZXHNr6lpHUWoOQsLS5dKqt2k01HTr9unqBovqSEzLZyi8/myinpaaNJ?=
 =?us-ascii?Q?AqRM/353nqj+GjOXmP1wUuTuXmG6Un9PIfcVYoXI48D3uNyK+4/T60KBkmFb?=
 =?us-ascii?Q?Si9Qedvv5duYmrd0s5abAx1z3M689RJjrARQaSdAL1NkbftLCYBXJo7SKf8D?=
 =?us-ascii?Q?0wjWjS4EQRO95srRL7w/Hm/gVNF2lmszLgJjDNux7QLjIuVKzq0hcJfwC9Ez?=
 =?us-ascii?Q?OMRmWMqS9xPVCV7MeNN4B8MBRW4Neit5hk3KNe+8TTbAICY7QjT8rM9pIzcr?=
 =?us-ascii?Q?WNGwUmxNP1ohxww7nO+Lg6up5MAvDoQDqMWAcNlWqrzuQ8A0+AcGZ2truApc?=
 =?us-ascii?Q?H9a2RcaZSFaZ5H2fv4VoaeOhuFy2CNJeR/wZZoYlzRt/A+8Oh3D9fS9jYdxD?=
 =?us-ascii?Q?K9r6aJw7eIhBjh3TxlKp+3mU1Jo0qUY7SH9JP+h1KsI5hKSWjv40MGktSog3?=
 =?us-ascii?Q?lMZFxpYFeVJvj41BJ31mEGPqf0Cgw2zLejjOpBJvMr2aJZTgkgfKyyUJNrAA?=
 =?us-ascii?Q?yipirs66TqIiC8IWZC5mq6JcshnMc6PPHiQpHQ7mkldl0ML/TGill0QWlbO8?=
 =?us-ascii?Q?c4zah1SiwekiON2oi7NxwQkgkKxNZibf4tY+MI55fHkAWnwglKMxrBO5W7f4?=
 =?us-ascii?Q?54L2a5FRj8hROcDB14pdO/cB7tQJeqJtN770ijm+xdpOWmO2viip+hyHLmct?=
 =?us-ascii?Q?G6A/TvsResvg6VkaI5JRYbkpCHzEjRSajG6V+PHxSqnFJRA+iZcMoxGgLDsM?=
 =?us-ascii?Q?uM5o6ahNKxuxGUVcycFPkOPjoPO0iP+AbGoiQtZacGJzK052OL7ocEIhF4hV?=
 =?us-ascii?Q?DHkj1/zifXRRrnwcIWQctSE=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f05955-5f96-4827-24b3-08d9a9cd212f
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 13:21:14.1462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PH1TmmeZClLozx3v/KBYBy5ISOlYuOa7pwmY/rfsZ0QNsDy7F/tRKHvKQqtUi0GR+j2yXlO3V8xeJuu30IgmUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB3841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ARRAY_SIZE() because it uses __must_be_array(arr) to make sure
arr is really an array.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 .../testing/selftests/bpf/prog_tests/cgroup_attach_override.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
index 356547e849e2..1921c5040d8c 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/kernel.h>
 #include <test_progs.h>
 
 #include "cgroup_helpers.h"
@@ -16,10 +17,9 @@ static int prog_load(int verdict)
 		BPF_MOV64_IMM(BPF_REG_0, verdict), /* r0 = verdict */
 		BPF_EXIT_INSN(),
 	};
-	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
 
 	return bpf_test_load_program(BPF_PROG_TYPE_CGROUP_SKB,
-			       prog, insns_cnt, "GPL", 0,
+			       prog, ARRAY_SIZE(prog), "GPL", 0,
 			       bpf_log_buf, BPF_LOG_BUF_SIZE);
 }
 
-- 
2.20.1

