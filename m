Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED13D5138AA
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349258AbiD1Pmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349273AbiD1Pm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:42:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A4FB36A8;
        Thu, 28 Apr 2022 08:39:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTMnBxE63yOVh/Xq0jmCAwg0oowowqhteaQVroUxc1g8+CIGXvLX6fg7On6WfKwpzrpEnNBgxjBUbrUGvwuNgSnGrjIGtzKp78fitlajlLMoQWYAxJHgYddC8/cxasRDm3EhAU4TPvECv5fkRqZepImsFDQd+63LZQx6t6YNc4vn2/rS7QE1Yefnr/NoQ/xzr9vDO4QtLauODlSCCJypZ/ROr81HwcLAtwo0+tX/SMKxxtsce2uB+l2snsURvKPEiBFtzELiIUSufjSDZ8pZGQJXp8uuDbPuToNOky2GKDFFcPm5Fm6XWvMrXEm+nmaAtXXQX4GDwaJEfYHyz7084Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2nAdLyFGLcreMKj9eu06H4By/iK19AIgRcqJGzRKAjg=;
 b=CtzTCVscAk2Tkk78kLaZ3gaUg/b0cGiNWT2Wcq3T1YLLosRQS5eqqBBoGorIvYHClEfZQxKwtvP7HWgry4nTLYSH699/xlVxSaVbz8uPsCp5Co/O2hAX3qis3yz7Hx8LlQPlj2ctylc8VpEFRURCYPg+nUHuUqkUX9oghfcnEzSuiHOarsD1/T9sthMZ7xQr0kg93AaQEsQUd7t40esWzLWuG8NPU7i9P+8MCBNq4QnH8jWAR/WHu3rPyGU8fAjch8kgbeL1dF5FUqNFXPgVGfKENlpAwDzmOoqxSQG189uWjwuv6Qw/r6WgIePYdPjLinWVQPEe0v6n62FGbxTJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nAdLyFGLcreMKj9eu06H4By/iK19AIgRcqJGzRKAjg=;
 b=XSJSaDEKG9eGe/x9k1QHxIvTnduuX0Qm8dQVayw2DIkrRNJvrOG3a8to1SxP4Mm7MfQpHXYSsGSuMZser6mcAp82y6AbDVmTj7uPcDbDXy0GDaMwsW+S+KgpVBaM5/z3WSScLPxq+oSkEnRPb8Sy1fDBRk8ltGPjOHR7v+vrxPq3thYKph5G0C1DpjeQ+hKeVZbfu46X2DmNfzrrTfJe7R0igqRb+fHqp+LG98ftCQIflHtfGg//OcHt5r2dqYxgQtLz8QPXkQco0pgdqvmc1dntZ0BXVJmkPLZ+z+vkG6Kv0HO9nNmv4lVfSgHhKRc2TK/qBle1A9omv6eLwQLKUg==
Received: from MW3PR05CA0009.namprd05.prod.outlook.com (2603:10b6:303:2b::14)
 by DM5PR12MB1561.namprd12.prod.outlook.com (2603:10b6:4:b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 15:39:09 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::a1) by MW3PR05CA0009.outlook.office365.com
 (2603:10b6:303:2b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6 via Frontend
 Transport; Thu, 28 Apr 2022 15:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 15:39:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Apr
 2022 15:39:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 28 Apr
 2022 08:39:08 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 28 Apr
 2022 08:39:00 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        "Florent Revest" <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v7 3/6] bpf: Allow helpers to accept pointers with a fixed size
Date:   Thu, 28 Apr 2022 18:38:30 +0300
Message-ID: <20220428153833.278064-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428153833.278064-1-maximmi@nvidia.com>
References: <20220428153833.278064-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0eba05f-cc4f-443b-f556-08da292d3cb2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1561:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB15616F936E15AA693809793BDCFD9@DM5PR12MB1561.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7LkZplAj7MadPPkOLqDaJmRsDNuiCfAct4xsWsCqI8SvWBQWxXZhRw9xYs7VhYE6I539BXQgn9ouyY0FQWNNNRRXMHWdZybdDqx4GO9ENMlrz4riCOw/XDlct0mOtVZgakPAcJeLGy6IjIsq7Ra0E9zXSxn8tzae+UjfPu9/wFPiNTMODnZi0laSCMmhZZ8j4u/ahx2En+855LKiUL/gLMMw2Y//zq6m/PgCzc72LaFbZI/cXD2RTUAcj0FxeoltykBZ7PYUqJIZZfC26bpmmlFU0iv2lkrg48oYTJqRkArk8xez4XNzIRk/41+NVupHFMWSJmJ9udnGp2xTKc+qTjdXjHk3B6yXzXJsZ8Z/Km5znZ+Fvepe95n1bvCsvz5eMJRE0Me6M3M11iLw4lLYM8svRtsddlv27MYrO6eEtxwRYfPUmC/cGb2UA/u3Vlfc5bPb0jx6ct+n2Cd0PYepGjPffhjj3XhFqsodZr3YdBuEz8H7lJVyt5RrADRhKXg8O6aH7djwG7UqdIjPnIIMQY4+11hmGPk6t40y0fuAQIsm7KI1d+Ra3oIo7h1WfaxYfpS/KbstXSF+AFVks7kArotNJQIJkr7Fexa+xoqFJNU7QUmfN1ANzSYOWpcLfYFqEcw9fcUYjFPYdU49lWX8n8XtBG4c0ZOmKqERQeOofhhAkBBPReybeOl+fEwP/HFho9PJMdkDuPCzzmY4BZqqASLtFDgJ83CJOChiLYjvpJzLl2mtii1cmR4tYojdF+U9heMg/kvv8PWQ/aRL6Kp9A==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7696005)(1076003)(83380400001)(2906002)(356005)(70586007)(70206006)(26005)(186003)(54906003)(110136005)(336012)(36756003)(316002)(4326008)(47076005)(8676002)(6666004)(426003)(86362001)(36860700001)(7416002)(107886003)(40460700003)(5660300002)(508600001)(8936002)(2616005)(82310400005)(81166007)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 15:39:09.3568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0eba05f-cc4f-443b-f556-08da292d3cb2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1561
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this commit, the BPF verifier required ARG_PTR_TO_MEM arguments
to be followed by ARG_CONST_SIZE holding the size of the memory region.
The helpers had to check that size in runtime.

There are cases where the size expected by a helper is a compile-time
constant. Checking it in runtime is an unnecessary overhead and waste of
BPF registers.

This commit allows helpers to accept ARG_PTR_TO_MEM arguments without
the corresponding ARG_CONST_SIZE, given that they define the memory
region size in struct bpf_func_proto.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/verifier.c | 26 +++++++++++++++-----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7bf441563ffc..914b571bbf3a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -465,6 +465,16 @@ struct bpf_func_proto {
 		};
 		u32 *arg_btf_id[5];
 	};
+	union {
+		struct {
+			size_t arg1_size;
+			size_t arg2_size;
+			size_t arg3_size;
+			size_t arg4_size;
+			size_t arg5_size;
+		};
+		size_t arg_size[5];
+	};
 	int *ret_btf_id; /* return value btf_id */
 	bool (*allowed)(const struct bpf_prog *prog);
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 71827d14724a..49e1cff422cf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5602,6 +5602,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 * next is_mem_size argument below.
 		 */
 		meta->raw_mode = (arg_type == ARG_PTR_TO_UNINIT_MEM);
+		if (fn->arg_size[arg]) {
+			err = check_helper_mem_access(env, regno,
+						      fn->arg_size[arg], false,
+						      meta);
+		}
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
@@ -5941,13 +5946,12 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
 	return count <= 1;
 }
 
-static bool check_args_pair_invalid(enum bpf_arg_type arg_curr,
-				    enum bpf_arg_type arg_next)
+static bool check_args_pair_invalid(const struct bpf_func_proto *fn, int arg)
 {
-	return (arg_type_is_mem_ptr(arg_curr) &&
-	        !arg_type_is_mem_size(arg_next)) ||
-	       (!arg_type_is_mem_ptr(arg_curr) &&
-		arg_type_is_mem_size(arg_next));
+	if (arg_type_is_mem_ptr(fn->arg_type[arg]))
+		return arg_type_is_mem_size(fn->arg_type[arg + 1]) ==
+			!!fn->arg_size[arg];
+	return arg_type_is_mem_size(fn->arg_type[arg + 1]) || fn->arg_size[arg];
 }
 
 static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
@@ -5958,11 +5962,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
 	 * helper function specification.
 	 */
 	if (arg_type_is_mem_size(fn->arg1_type) ||
-	    arg_type_is_mem_ptr(fn->arg5_type)  ||
-	    check_args_pair_invalid(fn->arg1_type, fn->arg2_type) ||
-	    check_args_pair_invalid(fn->arg2_type, fn->arg3_type) ||
-	    check_args_pair_invalid(fn->arg3_type, fn->arg4_type) ||
-	    check_args_pair_invalid(fn->arg4_type, fn->arg5_type))
+	    (arg_type_is_mem_ptr(fn->arg5_type) && !fn->arg5_size) ||
+	    check_args_pair_invalid(fn, 0) ||
+	    check_args_pair_invalid(fn, 1) ||
+	    check_args_pair_invalid(fn, 2) ||
+	    check_args_pair_invalid(fn, 3))
 		return false;
 
 	return true;
-- 
2.30.2

