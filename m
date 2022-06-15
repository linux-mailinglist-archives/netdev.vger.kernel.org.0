Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7926B54CA33
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346413AbiFONtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbiFONtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:49:20 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7393A72B;
        Wed, 15 Jun 2022 06:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IB0tuN32IRyP93HuZgTYDv256RSASmtlEb9aC8DoUaEuAg5SINE895Z4eKCHwnE6NXR9JHRN+G1PCf1kHZgt0NqQIiv6GpoLkHDLbelMqBv+ZvwEu/fGL96dq4xOyf4F/FZ5NsdDllcGbqF5Fg4EEi07L8N+DrOHawrXr+LMCYc2dOzPls3VjVs3i6y18muCO0u/j0KhEi6t22YxY9vWfzEYK0wIhb4ZhohoRJNk9masHiqP1QCgzqTz9GV6vJaetmdXbfmXTIl45yfN3iZKbQuCc5zoBNtGq3SWm5pgGhLtXAquCigiP9B5u8MIfLk6X+tZmRnUBFJWZXTgQ2gZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+JqQQwP6+mgWCrSsL6IJu1IlMH1Z92Lc11ORkYhHhY=;
 b=mdH+dPPzIngtUtXwAczawS/TyUMXnCzKDvGjRr2j4sWyqfdyicKQrRR4UMD28L0JMJYfHkY1qvGcTM0DZGbP1QtoYimcQMBL/uWMwiSm2GDyA9qMabD5HQehGGZa0g9fWrgej1IIgN6vY/TFvf527bbi0MGf1/oVlxBzWoc2/KYLVrwVku4bZysaHyy3UnbfDNGJK0hDh4qb/6NOf8s+JQG2mL525ZEUBE5VKbKho6u6Et7wbXOhQHh7UdHy9ckO/fbYFHKR1h5vomkZmPSt43QXW5DCitGu1dRwAZ6hKYF+04wbxJLFNbjfeS9YRWB9OSsc76Do2M1ibDgGnNelAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+JqQQwP6+mgWCrSsL6IJu1IlMH1Z92Lc11ORkYhHhY=;
 b=U/6i3l6+Pn+RhLqAD4hgLIXkZ+Dsu36t3MDlgFBD/tPmQZHstN9XglwRkYgVVuE55QIXdjpdNP/9YKauv3t8MBx0XYxeo/1JnE+S3Xn9KTPvojUksb40hYZb3QAEXLCvK2+bfxKzQt6YdXTdo0c1j0MaLnEukUZ8IPkPfPS7dlggvrU6R6CE7fD1bciNMmCGVG88ucVSYscEsfYzqXGnAAo3OQnrS70yyH8PWg8s3gVX9MEfVDWFglin1SGtXM4VZVo6PmGZ8TWxShqt2tEbDwt9IkO0uY5t1herU2lF9lMTT7cmPxBlh/DYiuqIPkogRtdc9IJbqkRQiNWqZpKCBA==
Received: from MW4P223CA0023.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::28)
 by BN7PR12MB2724.namprd12.prod.outlook.com (2603:10b6:408:31::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 13:49:16 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::9f) by MW4P223CA0023.outlook.office365.com
 (2603:10b6:303:80::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Wed, 15 Jun 2022 13:49:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 13:49:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 15 Jun 2022 13:49:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 06:49:12 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 06:49:06 -0700
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
Subject: [PATCH bpf-next v10 2/6] bpf: Allow helpers to accept pointers with a fixed size
Date:   Wed, 15 Jun 2022 16:48:43 +0300
Message-ID: <20220615134847.3753567-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220615134847.3753567-1-maximmi@nvidia.com>
References: <20220615134847.3753567-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af3adda7-df12-4f23-7401-08da4ed5d5d4
X-MS-TrafficTypeDiagnostic: BN7PR12MB2724:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB272485B713DBC6953F3B7D36DCAD9@BN7PR12MB2724.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3TP9nRkbfNZH+Juisb0rezEPuQDgTzog2YlHpo0b0Q/9Gst0S+RrMmvetSzSnAl7u3B5FgQZBqn7gorjbLl8fy+nvFrKkSWiVdL4u0anhyYNKsQggUmme1EfVh+4u1GTOwTBcT91oJ9TdINs0cjQZwb3IhbSMIDmiocbTvBQMV+pdrJSrRwBH1kX9/dUJOmjHqgq1bH/yQJeLf1RCOS13l/C3+da3eLt2tv8jUwbyX6w7ia8SCSYMdS0JqbOvYCDpvD/n7M/Bq//AQWfzpfF2tAF1fv9tfqcSVQXxFw0SwCvyO3MIsT/b1KUdREafCumd/Gn6Q56+5x/7OSIPDDKLYGEbFjKPYFPQ2ZUKSC6A1ivkMo6hdPtH0LGOs++sSJRVqcdniV88B2D2H8E+ZcqKX2Jh87H9ZUZNI74jKV/+IAPrFcxbu7sBr6EWNmVkj+8rmwMYFwvFDXGU3H7fZjQaZ+hvlIGa/v7yBFHAsoeqzYxeeg+OPmOQcqlkjPxoIHEFhJgLTCvgKSgabiXCSq+pc5RnyWDBMpLej2T+dSg0c8VExwi1H8hvoqXd46c0gpSZKYHcg3oPkeRNPVgmIMjawrr4aEocYS4njQ7f0ir/ciSu5sJwSIMuBY8J6htGYfeGXOOb1HuC/JZzxay27LkJzvFpulMj44F5DkNhjpCiQe1BHnHWBxdlKa+bUGaXyHvkJu1XUh8BV5bog1csvWw/Bh2iVOXWST+h67ipm79US1o/NlN9Xgt3lCEX7H4Tf5
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(40470700004)(36840700001)(4326008)(8676002)(70586007)(70206006)(2906002)(40460700003)(356005)(86362001)(5660300002)(7416002)(8936002)(81166007)(82310400005)(26005)(186003)(107886003)(47076005)(336012)(508600001)(2616005)(6666004)(7696005)(36860700001)(110136005)(426003)(316002)(1076003)(83380400001)(54906003)(36756003)(461764006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 13:49:14.7255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af3adda7-df12-4f23-7401-08da4ed5d5d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2724
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

This commit allows helpers to accept pointers to memory without the
corresponding ARG_CONST_SIZE, given that they define the memory region
size in struct bpf_func_proto and use ARG_PTR_TO_FIXED_SIZE_MEM type.

arg_size is unionized with arg_btf_id to reduce the kernel image size,
and it's valid because they are used by different argument types.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/bpf.h   | 13 +++++++++++++
 kernel/bpf/verifier.c | 43 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e6092d0ea95..985f9db8f678 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -398,6 +398,9 @@ enum bpf_type_flag {
 	/* DYNPTR points to a ringbuf record. */
 	DYNPTR_TYPE_RINGBUF	= BIT(9 + BPF_BASE_TYPE_BITS),
 
+	/* Size is known at compile time. */
+	MEM_FIXED_SIZE		= BIT(10 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_FLAG_MAX,
 	__BPF_TYPE_LAST_FLAG	= __BPF_TYPE_FLAG_MAX - 1,
 };
@@ -461,6 +464,8 @@ enum bpf_arg_type {
 	 * all bytes or clear them in error case.
 	 */
 	ARG_PTR_TO_UNINIT_MEM		= MEM_UNINIT | ARG_PTR_TO_MEM,
+	/* Pointer to valid memory of size known at compile time. */
+	ARG_PTR_TO_FIXED_SIZE_MEM	= MEM_FIXED_SIZE | ARG_PTR_TO_MEM,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
@@ -526,6 +531,14 @@ struct bpf_func_proto {
 			u32 *arg5_btf_id;
 		};
 		u32 *arg_btf_id[5];
+		struct {
+			size_t arg1_size;
+			size_t arg2_size;
+			size_t arg3_size;
+			size_t arg4_size;
+			size_t arg5_size;
+		};
+		size_t arg_size[5];
 	};
 	int *ret_btf_id; /* return value btf_id */
 	bool (*allowed)(const struct bpf_prog *prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2d2872682278..8c929d899665 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5848,6 +5848,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	enum bpf_arg_type arg_type = fn->arg_type[arg];
 	enum bpf_reg_type type = reg->type;
+	u32 *arg_btf_id = NULL;
 	int err = 0;
 
 	if (arg_type == ARG_DONTCARE)
@@ -5884,7 +5885,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 */
 		goto skip_type_check;
 
-	err = check_reg_type(env, regno, arg_type, fn->arg_btf_id[arg], meta);
+	/* arg_btf_id and arg_size are in a union. */
+	if (base_type(arg_type) == ARG_PTR_TO_BTF_ID)
+		arg_btf_id = fn->arg_btf_id[arg];
+
+	err = check_reg_type(env, regno, arg_type, arg_btf_id, meta);
 	if (err)
 		return err;
 
@@ -6011,6 +6016,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		 * next is_mem_size argument below.
 		 */
 		meta->raw_mode = arg_type & MEM_UNINIT;
+		if (arg_type & MEM_FIXED_SIZE) {
+			err = check_helper_mem_access(env, regno,
+						      fn->arg_size[arg], false,
+						      meta);
+		}
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
@@ -6400,11 +6410,19 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
 	return count <= 1;
 }
 
-static bool check_args_pair_invalid(enum bpf_arg_type arg_curr,
-				    enum bpf_arg_type arg_next)
+static bool check_args_pair_invalid(const struct bpf_func_proto *fn, int arg)
 {
-	return (base_type(arg_curr) == ARG_PTR_TO_MEM) !=
-		arg_type_is_mem_size(arg_next);
+	bool is_fixed = fn->arg_type[arg] & MEM_FIXED_SIZE;
+	bool has_size = fn->arg_size[arg] != 0;
+	bool is_next_size = false;
+
+	if (arg + 1 < ARRAY_SIZE(fn->arg_type))
+		is_next_size = arg_type_is_mem_size(fn->arg_type[arg + 1]);
+
+	if (base_type(fn->arg_type[arg]) != ARG_PTR_TO_MEM)
+		return is_next_size;
+
+	return has_size == is_next_size || is_next_size == is_fixed;
 }
 
 static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
@@ -6415,11 +6433,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
 	 * helper function specification.
 	 */
 	if (arg_type_is_mem_size(fn->arg1_type) ||
-	    base_type(fn->arg5_type) == ARG_PTR_TO_MEM ||
-	    check_args_pair_invalid(fn->arg1_type, fn->arg2_type) ||
-	    check_args_pair_invalid(fn->arg2_type, fn->arg3_type) ||
-	    check_args_pair_invalid(fn->arg3_type, fn->arg4_type) ||
-	    check_args_pair_invalid(fn->arg4_type, fn->arg5_type))
+	    check_args_pair_invalid(fn, 0) ||
+	    check_args_pair_invalid(fn, 1) ||
+	    check_args_pair_invalid(fn, 2) ||
+	    check_args_pair_invalid(fn, 3) ||
+	    check_args_pair_invalid(fn, 4))
 		return false;
 
 	return true;
@@ -6460,7 +6478,10 @@ static bool check_btf_id_ok(const struct bpf_func_proto *fn)
 		if (base_type(fn->arg_type[i]) == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
 			return false;
 
-		if (base_type(fn->arg_type[i]) != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
+		if (base_type(fn->arg_type[i]) != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i] &&
+		    /* arg_btf_id and arg_size are in a union. */
+		    (base_type(fn->arg_type[i]) != ARG_PTR_TO_MEM ||
+		     !(fn->arg_type[i] & MEM_FIXED_SIZE)))
 			return false;
 	}
 
-- 
2.30.2

