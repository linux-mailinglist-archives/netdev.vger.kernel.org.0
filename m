Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079F15147D9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358167AbiD2LTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358160AbiD2LTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:19:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3F88566B;
        Fri, 29 Apr 2022 04:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl+DdkVMwNbZy526hWtpDS2JMO51zU6OuGE0Bw/IzTY+sIrTEjm/5uLw1/r7nUXCYCiPuL1v5QqVxB9XyqojuR6/HIUOPfaO6Ts0FUh/hp5v/6CjW4MGi5n9LKcYxo6w+upUAGOhoL6EOAdPbgnDtGmSJrbqltuCaYad4SFPrCElkTp3zQrTR10Irf4Qadyt7n0LHswvZeQ0OWenuPIXPnilhX2tla65vCbgDb9goGBSVnYehOTX7KpZ0FWG1MxP9oYWrXL1EzHiTIT6Qt/WLEqCv9n4q5cXClbphAz4DfFDzPtWxE4sn53cgTDyp90Abcs6mYBT5aqc0ZgvbBO1qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQLWZrUb9tyCBCGT9j6Fw67NODhuDHrLbkeqyeR1ndU=;
 b=KpR33M+VtaUHf1wigb+Skm2ay+Fxg2Ltu0DiG/cugbDtG7pKYmosNXlY/qDKLz2AXSvVVd8FIyhoCirnS+YGPm7AgsaL6dX869XqZwISC5ew0ZRPFcymR5Mq9sGNAMJaxTaPXe8pu64JXcyjFkPEQs2FOjM5giQNCApvQ1LUp14IRG/v65o1Df6rA+kH1Gk4amYtms1Kug4w1zCdXGEuhdrG437EbxN5yMwl0hWNUmIi+QkYBo8k+G6sJOkMewn6WOy4EVfDk69xMzzpNKNsBAZyW3C+lZR5pz/Kt8vmqmqrMjadEA84z6Hdf4ouv1N0XFMcubGF9fNQZrqX+z5COA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQLWZrUb9tyCBCGT9j6Fw67NODhuDHrLbkeqyeR1ndU=;
 b=BBIyixs4x3C+7L1Ro4IMPIClQnFU4+NQk9G7+/FHe1o+pnbLIYhYI+wuOPIy01FJHwEua5LUEbLuPi0TVuvNrLWpWz7MaXvPeGKXwREkKcNmnVbRL5Gd4EKcR+Gwl6SgZqLt7YRVyUYiy0BYKvpLzEztFB9Y+VWYp6AidO42NfaEUB1LDjpkNQ5GuovFixYa88QJcC4Xc+6sOfWhf/3D/+ermYxRNLihk6+443JXF4slAgRGWPi5yaPtaRArgFjALBv8c2+nWMjJpJzR3tH3sNhgeeI8VLnWQO2s75yjc0h+by/Ib8qCXQKWdbhNPZS8O+USN6XikLo4WkG33gnG7Q==
Received: from MW3PR06CA0019.namprd06.prod.outlook.com (2603:10b6:303:2a::24)
 by MN2PR12MB4093.namprd12.prod.outlook.com (2603:10b6:208:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 11:16:14 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::e1) by MW3PR06CA0019.outlook.office365.com
 (2603:10b6:303:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20 via Frontend
 Transport; Fri, 29 Apr 2022 11:16:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 11:16:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 29 Apr 2022 11:16:07 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 29 Apr 2022 04:16:06 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Fri, 29 Apr 2022 04:15:59 -0700
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
        Florent Revest <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v8 2/5] bpf: Allow helpers to accept pointers with a fixed size
Date:   Fri, 29 Apr 2022 14:15:38 +0300
Message-ID: <20220429111541.339853-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429111541.339853-1-maximmi@nvidia.com>
References: <20220429111541.339853-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5833d99f-5e04-4abd-f0f8-08da29d1ac6f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4093:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB409308295EE70400FBE6E996DCFC9@MN2PR12MB4093.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVY8k7nOHS71aX+79EU8dcvjJ6/tUWxcaio+Pv0PAm73czzpfWQMIEWQM3AtE4dFlWfmv2qGcioZ5pQgi4Vgb/iBJ0CQ33V+7o2Kqz3/wP/c1OpXhbA7xBITzGRzaMQZOnzNyRoXAcMeLWpbpVdzf/xlcKADBmjZ5KZkLbukFIkUF2g16vc6Nwdwm6BVud+BOJH/2Z+YSX3dEiNlr6jv3UlTz917zQotxlS+ccqHASFo1U9utj5aNUoyhtbrOQ65JuG8EugotlbC13KppBOuhBczXSL0lc7wnDrSSR7HRnHI5c0y0ctL39gCW+TjJHRLfJnS5HGB20XW01MvgxvF0rp4qco60xUN5bH58/v1C28/vmlC0Q8pN7DEoFqOSh9z/ELajvKb0jiiJsw2fjeyRhIc6DyrBuZs//nV4WrKaScdxDrwVGtMCGydu9MKuzPvnaOqxkazHuVy4TJj+A6vL9j3Yze9b2N7tldHcw+4cVWfJm8egtDTbEzsLNBs6nDU4Qk/2EcKMQ43SIjR8j+oVoBjtRhXQM6JjsUx+AXSd3iukh8dbeAH50Jf7WktZeNrC+Owob5KNUDTjFzq4LDEfDlVWW/YaUZ+I43x5mJu2eySXW5MH5MmnuJyvrT+o+MHCEqL0kssygEMG1hbHK1xJ35aPS3DTp+r4PC5wObBMpRjOv3XsHcpp689RFxkwNiQnS2SRMfWvba8UhaxGpZoBuMArrIEIBo4S4tb4wQL6s1sSChvrNX2ZsJ2Q69U85+wF5nrzMcJn3dur4hFakw0tw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(47076005)(508600001)(86362001)(82310400005)(40460700003)(2616005)(107886003)(336012)(426003)(1076003)(26005)(356005)(81166007)(6666004)(36860700001)(2906002)(70206006)(7416002)(316002)(7696005)(186003)(36756003)(5660300002)(8936002)(70586007)(110136005)(54906003)(4326008)(83380400001)(8676002)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:16:14.3173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5833d99f-5e04-4abd-f0f8-08da29d1ac6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4093
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

