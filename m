Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98104D6686
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349996AbiCKQis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348364AbiCKQip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:38:45 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC80102E;
        Fri, 11 Mar 2022 08:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V406V/+Gx8xomyytESAVtJcayoUsvwzmnePW84Ub6LHKMsUKSdwJA4WB/iW6U7NOdyHUkP1he3Rptns9pmHdxv2KYOgXuMOPsiTDJjeWtygRQ6NkB5A7dxCk/vc9EpfY1+vuKzH05OOmcF6dlBFMAMuXP/B0zdJI1K3w+c6G0o6haFDQEg7DGYjHB43vkVB5sENtEWPODrZK+OSPbQp2gySZr0s0TKosBu+ohCj8sAsjzqxm8ivnKdTZ0GAYg85CpEimZJ9K0szzcqzo/9MjNrHq6CobUyiWLvsYFkyrvc2ZIKe5/RhMNGdyEp0EZmngJpUxrA/sA88UtREt08yuXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnvCcDjuE0qgE6Z7WBk3kPmvdEM+7e3N0sPDQlu9LNk=;
 b=if8p0cYAgjhbOpyiGI+9++mnh7mmFI0mnKRuqoWdlgEbebbi6xQn1fmJDFO3thhpTfsTe9DMJb4ZsNO7vFZtHAIAYuWJlZv+70Sru1z9sK9hoykWG2WtQxGRyojQN1PQRm7d+fkt10Kr4QkDREA9ExMuwlQs1/jM9ON3lZ53fpV0Rl+eDhE0s5jJLfAklbLDEQnh2t9UBLAZNNqdkaTka1uw6iU9aZ0E92QA5kuZrLgIDCjVHIleUPZMMI+iYSq9eKqycCPAT4WCB5pcy5xUkPlltFXQMWh4hi4orKaylYK+/ZhT/F2XVW2URemXbd6lPhSnApjFSSDVYhUTlSnUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnvCcDjuE0qgE6Z7WBk3kPmvdEM+7e3N0sPDQlu9LNk=;
 b=tWYlE5/F4O8xUTZdCg53VQO6ZzsTU+miOORRKQQ9rhfWwZavtcNUwmYEzk3ZZDxPXWOWGpg23I9gHi8WBTxzbmFSiEXyZt/sJTAOu+neAQE541Ojc6e0OwDQviK8uICrE+M7f97EA8iERJNUUgQRo4X1HuWAIZ795N4KD4mejJ40odWF7XeJNwIxZsXb4Ts1do58X/ekCr92+i4ZuvghA2Ht4UryeYtZ1fj8hewflVVkM4AmLIncRVK8Tv/9jchdWQS4CTsMv0pX1E9SR2MT+u5p3HV8sHLIczsZhqPpn/NJhfnlx2o1nsWGphJXuNFL+W5k5QZdUERoQ4C1Ne9BHw==
Received: from BN6PR13CA0032.namprd13.prod.outlook.com (2603:10b6:404:13e::18)
 by DM6PR12MB4332.namprd12.prod.outlook.com (2603:10b6:5:21e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.23; Fri, 11 Mar
 2022 16:37:27 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::20) by BN6PR13CA0032.outlook.office365.com
 (2603:10b6:404:13e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9 via Frontend
 Transport; Fri, 11 Mar 2022 16:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 16:37:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 16:37:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 08:37:14 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 11 Mar
 2022 08:37:07 -0800
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
        Florian Westphal <fw@strlen.de>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH bpf-next v4 3/5] bpf: Allow helpers to accept pointers with a fixed size
Date:   Fri, 11 Mar 2022 18:36:40 +0200
Message-ID: <20220311163642.1003590-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311163642.1003590-1-maximmi@nvidia.com>
References: <20220311163642.1003590-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e70c6698-b337-478d-e4d6-08da037d6d15
X-MS-TrafficTypeDiagnostic: DM6PR12MB4332:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB43328F6D9370BAABD535362DDC0C9@DM6PR12MB4332.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cqo1FyxWoDCpdoE/oEjl5mQ27iqYNbcHA5QlxyCH1aszHVnknHF+DZLBwj+xtPLrzenJbOB6LNH7iT4qI6lvNnbky7to9lpZ0a3RKYppVRKtZn/O50Hq7tVwdJwypm8tQW4RUH3Fvgwkaq8KE9Ep4BvmxrYRxb2VmudNL8Mp4ImokdD4Aqi1iSaUp6ZHGMEtWV+csi30rTk1hcYcwxN3zObYFPcRR21X+7aebHM73obi9SWYNuD0RbkOxoGEJtx3umzJM3vOJGBCxqrjsvuwmjP9DQy3eqMyB9AXlsQOISfA9A6VEd+OhuXX33LRiXarWg/GFfpo0R4cjeu/y5SrGXRDmGnPhw2MhMOxKS7q8jt2WQCELtU2msWL0SJ6LXAgINHloQjA0ulEo3OL1EkRlaDzPAlArN13SuvPx/fPzh+j50S9WxYTwtZr95NDYzPYSGhJ6Z0sRKylwDKEhJ4GUU70/dyv8BlKlVZAH9jMwme1OQzvp0F6+ehvGYx8uJbkQYz51/wstwx2DJAqqKeHZfyt0iJgEcOFIlOdtZLMHcl2uGEyWU7noV+seZnZehEAk2zNtiewkgfuvMHY6Y8Wt8IlUnueGNx73GcgokP38rY+8XpVClJHuQ/5tLRSJTah/O10u9XE9sw5Uh+X9Mwy5Q69Tbm3WQZbauPhc61M95Xc0bCYVR47kjVd8hODK9d543lXEMu7L73HKCzqVL6S0h75EK3Cm9qT1ln2nXud7gxPl+zszea0X5UxdDUkEP90COsmCWpHR8X/OkFJ3GWSg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(86362001)(70586007)(426003)(1076003)(336012)(26005)(2616005)(186003)(8676002)(4326008)(81166007)(2906002)(110136005)(356005)(40460700003)(36756003)(316002)(54906003)(107886003)(82310400004)(5660300002)(508600001)(47076005)(83380400001)(6666004)(7696005)(36860700001)(70206006)(7416002)(8936002)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:37:25.5418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e70c6698-b337-478d-e4d6-08da037d6d15
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4332
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/verifier.c | 26 +++++++++++++++-----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 88449fbbe063..988749057610 100644
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
index 0db6cd8dcb35..73b90427aba7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5573,6 +5573,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
 
@@ -5912,13 +5917,12 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
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
@@ -5929,11 +5933,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
 	 * helper function specification.
 	 */
 	if (arg_type_is_mem_size(fn->arg1_type) ||
-	    arg_type_is_mem_ptr(fn->arg5_type)  ||
-	    check_args_pair_invalid(fn->arg1_type, fn->arg2_type) ||
-	    check_args_pair_invalid(fn->arg2_type, fn->arg3_type) ||
-	    check_args_pair_invalid(fn->arg3_type, fn->arg4_type) ||
-	    check_args_pair_invalid(fn->arg4_type, fn->arg5_type))
+	    (arg_type_is_mem_ptr(fn->arg5_type) && !fn->arg5_size) ||
+	    check_args_pair_invalid(fn, 1) ||
+	    check_args_pair_invalid(fn, 2) ||
+	    check_args_pair_invalid(fn, 3) ||
+	    check_args_pair_invalid(fn, 4))
 		return false;
 
 	return true;
-- 
2.30.2

