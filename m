Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10393518AD7
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 19:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240177AbiECRSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 13:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiECRSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 13:18:39 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35993BBD0;
        Tue,  3 May 2022 10:15:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACj3jR/arkow1skn/Wv5F5TmRSt14pMBdWN/djqTKlWVxyU4Ynx9haKo7uCoGqCdL5fm8Zrwx8wTRSU4LM/V8w53RTc4tVZ7PCQetVxkTTJ4z3o2h/p2ERe/J5cPe0guRq+uFwSU/1A9tXIidacexrODBAfkr6UC/1T/upTo23ijhaKxAhwr2U21TOfqKeTTS7n7NAJLA9nhc7pQE5OTNpH9ZuO03SEBkHQBfiBSh8aY6mRpZRDE1+R56tMcgBOF+IysOvvkhf7IMJ4aoTmxJ3Na7Su1Quj33rliipsk1mEdoBgzoGCOI7HzIgQSIlLJUR+37fPMTN/kzYrUrp45kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQLWZrUb9tyCBCGT9j6Fw67NODhuDHrLbkeqyeR1ndU=;
 b=ZQirF0XaKjZsEOw76m/xcwb7q4I1apKjA4lTWND0W1NLOBquoABiBAEtTBlMVheyDWubekaXrNFo87RhMw8eKKeXfDDnI/qbmgPptzNKfwbFRshPqOho1krqWzWkUxxBfiRIgtIFwKAr2u/iaZOk5J6xd5eRgAZf1RAIHUFPiFQqvCjUU0wQ4QSs2CWpNe06jvYqTmPCRJ5VgO1gYdgnG6qDsH+iRk5dRCbU2HjEf+6gkbcwOs6xkawVlnRbG9alwBpYvImFWy0NtSgJvfoH//XM8hiiElpPutg/1cE75Kom3xXDvmCDC/IBRVVEj4RHWQ3j2li7pabcSY362c+j9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQLWZrUb9tyCBCGT9j6Fw67NODhuDHrLbkeqyeR1ndU=;
 b=jWDBhXPssG7XwUOIhCbK7OYjVeIET3Wtg+LMqrQW9SAIcy/a5AGYx12RpSHupxKdKy6sXszmkeBpY+OU46aPegi4+pHjACTAWIodM589hnsHLkl9MOb4SjH7ocpSMTlP6dj4EgjZPM/PQuHAjEWfLnf9SBD3zHsrs/LP0xDIrwDBT/nR0opYjiKy4KAsqtwQD5PsExhjIkgTuaMF40EWy0MWgyP1I6hkoZghhI3cnUkiPdi5cxbnxT7xnFvmyUcILau6w3GbvApK5FPsyp0Ull6OByukh0tHKJZMa58erEY/j2kA5AUc2eUnGT1qSA4LNRldbNSZ9fvf4c1FfMHozg==
Received: from BN1PR14CA0012.namprd14.prod.outlook.com (2603:10b6:408:e3::17)
 by DM5PR1201MB0027.namprd12.prod.outlook.com (2603:10b6:4:59::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 17:15:04 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::4b) by BN1PR14CA0012.outlook.office365.com
 (2603:10b6:408:e3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Tue, 3 May 2022 17:15:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 3 May 2022 17:15:03 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 3 May
 2022 17:15:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 3 May 2022
 10:15:02 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 3 May
 2022 10:14:55 -0700
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
Subject: [PATCH bpf-next v9 2/5] bpf: Allow helpers to accept pointers with a fixed size
Date:   Tue, 3 May 2022 20:14:34 +0300
Message-ID: <20220503171437.666326-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503171437.666326-1-maximmi@nvidia.com>
References: <20220503171437.666326-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d43ba90e-ac20-48b9-428c-08da2d28769e
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0027:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0027A75449269B66866545C3DCC09@DM5PR1201MB0027.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQPC4qMTbRF/ne9kycMXW/AhtR1LWWtEfDKKppk3nHERVn6JtdBMg21YFw4ivca2T/4EdEIVyBiKBv5S1KQbw/PLWg1FyHOp2g6nu46LbZ/h47lVIOScCLhcn9DudFIsNmD5/VlmZoMcKTNsyyzVOhoeCTJKLfTejzD7azJhZ62KhoJlffvsDqVLN6/tWKA5c9zxBI4BpscKwGMsTCvJiD2bqON2cHEeKALqXVkDrPULLgW6Z6QGkM5N/TIP5gHESrFNyYscOPHuuT7UzErQ0v0JvHuMV3JNnAXOVU3Vn5lNb6cKEEceNsSJaVPbkKG3z+gubJ0S+XTjISxeVlDf/3Z0ipf0dslXTvzITF06p1vIdRD4XQZSNih20LcWhvEQC0dGUTaK4Zs09lilwKJyA++jNh9jpUoHq7sdDCOGZ445r/FSYOexKEPwy7PuCCIZukV6ZOL39zvdmKXffDgViqsLCz11l+qAIUonGaad9A93siZImqNpXYCARwFh5UW0O/kI77z4yAghSJYLqoLUiHV7u/UkqZ04wl9Cgl1H+h+armxtjX6Itls948e3bBOGHn7Ao99tMCN2Mx5aS8NuJj9/vU49RqJiPkvy1Vq8Tzo/rcxbtq8O4XNX2MPXLxxFsInvnRu9zf/VtZFIh6FEHt8Y4vUYwJJuDfPxzcHL6jJm9LtFmLQJRCcfyGGJcJ69troBJ9yXERB2T/U+f3szNWMQzWBSFrxZLlSR/zZ9voGGYE52pyxrvKUKdYHEF+viWO0umW6NGOzWeFo4by2k3Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70206006)(4326008)(8676002)(70586007)(316002)(5660300002)(83380400001)(8936002)(54906003)(110136005)(508600001)(82310400005)(36756003)(2906002)(7416002)(86362001)(36860700001)(26005)(7696005)(6666004)(107886003)(1076003)(40460700003)(47076005)(336012)(2616005)(186003)(426003)(81166007)(356005)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 17:15:03.6652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d43ba90e-ac20-48b9-428c-08da2d28769e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0027
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/bpf.h   | 10 ++++++++++
 kernel/bpf/verifier.c | 26 +++++++++++++++-----------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index be94833d390a..255ae3652225 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -514,6 +514,16 @@ struct bpf_func_proto {
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
index 813f6ee80419..57fcf2e82f30 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5843,6 +5843,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
 
@@ -6186,13 +6191,12 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
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
@@ -6203,11 +6207,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
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

