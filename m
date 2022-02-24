Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674B14C2F1B
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiBXPN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiBXPNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:13:25 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2080.outbound.protection.outlook.com [40.107.212.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499520BCFC;
        Thu, 24 Feb 2022 07:12:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egGp9E9ogBwdXEQii6GG8wJLt/4m9LCQoKSv5aGrHAqu198jYvbGdONdYf6Weq8cIsgTXTEMCgi32C7NYxAEhwrM7V9G9k9xrG5/qFev0RL/aogHQVnjxCIvpMAuaNMo7P0UPd8MbmyJ1a+sZTEZu3ek2HD2QlXZsTLt/QWQZMDyomeaer4QMctoYUC1H+ffIIDsa2afcEPVO09zuRL5Yyo6L7/g3eII5seaSvHbJQcyFaaFO7IVFRzfjooHU8/9Xav/33Un3cK5jUXfFRQ+kHCrxzGEBGJlz/jTXT9gId4qxPb5t/ecmGGWCYWg8I5QgZmQD7Ibb0Zhu9FYUN5o4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oELeKbrlfkmR3PwXUwLTU7tkxlOYPs21ZTKQSyJxGLk=;
 b=Z/xG3+WMCNIoJ/xS+8lMbtpijKzCWkxugyiWxTlXP66Z4kBYELcneoIvbCUxkWggaDWsZoCjpLnrKHys62lYmBUQf9KqNewn2mGqy26v+RoswnKlCzTH+/7LxxauI2X5uSMrAt5O90O3DVddukK08GZCa9tnUIcP4vYpxD4CGIdqJvz3+sFprb7kg1i+r+69s+/RU2Ira2AuotNt8g18UlaQpKTIgmEkT1IjJTLgKm7qJ7hWhIMrUEKZWwljMMt21SEceb8x1oicgAK9tKzz4a+eWMjrHzzWa3/2/bvv8Bk73DUSujWTACarxcoqyvZix7Kw2Fk8uKjG+layzb/wwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oELeKbrlfkmR3PwXUwLTU7tkxlOYPs21ZTKQSyJxGLk=;
 b=oU9C0cCnsWcFlO6XdhBAEIkrFzdWVxFh2Xd5x4rBxR+RVVMdwGzph4vZ83iHP2zNDWqjWZdrBRaVsG4nGjQanZaBWp/cgkQx/Y/5PJYf94tcUexO4S78hMS+8MAGgMkqgB0+qoIZ5n0JtOdP6wZZ0q2/ciA8xAJBR7EkXeDmgOG2unJPXMLRhCcO7UoBtbsoRw7c4Xcmnq06441aSMvNtKt6qwe5mA6/nwmkAED7OnFKAS/KLjCQg4+ZgpxMv2+rRih5Enibmn2W4QQw3EUde9t2Db2uC1WhFwvTHPx+cieG/MSrhB1epHsFDVgT0lxWfYNhPyh/dQkOHLURXoNxoA==
Received: from BN6PR14CA0035.namprd14.prod.outlook.com (2603:10b6:404:13f::21)
 by MN2PR12MB3758.namprd12.prod.outlook.com (2603:10b6:208:169::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 15:12:49 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::75) by BN6PR14CA0035.outlook.office365.com
 (2603:10b6:404:13f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 15:12:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 15:12:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 15:12:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 07:12:46 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 07:12:39 -0800
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
Subject: [PATCH bpf-next v3 3/5] bpf: Allow helpers to accept pointers with a fixed size
Date:   Thu, 24 Feb 2022 17:11:43 +0200
Message-ID: <20220224151145.355355-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224151145.355355-1-maximmi@nvidia.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 062c68ff-6fb6-4fd0-abf0-08d9f7a81f17
X-MS-TrafficTypeDiagnostic: MN2PR12MB3758:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB375803891D67B2D408BA227BDC3D9@MN2PR12MB3758.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i92NPjHDHAXATWybO0cDl0q3R3M/mhi2k73O1OompGEzY8zw3xYMNaD3R11uVaQNzBDDDoP7pko+Xq/9D1KJkBEO4wEndu5spsE3DNfvy0oSKFntXPJ1Pkv1MbbZNXaF9X4DVEYEYivIHdiWRJ3Rvir2sqwP3jhh+gugC9rShIu8wgypfy37vQ1C5ZQcJ3zP/GSxbQFhwc7CHcO+YjDAKYlLC/f42YH6axqtVuLNl+qgmVLDifZU/QDdGKevfNhSZHHVgsIV5UH8ju/aceAefKmEc1uQYsrATnXTKIFsRy6bbuIy5sqT19fKtmFk4xDsMkLbZdzn7+gcZfBKyQpfKZTePat2JqrbA5pHWKG3+Jo/xeDX8KZA5xqwjyH6GCDRnpARo5KlNQTxu86eJplmJN3E6E6T5LGySNmxx4YTymwnf6AjOSfzMNCOvu4QluVRFunivqtPNlRJtXA0FfwKyEt3kIa4b4+yyihOBgGOP1u9e7UYsbmnlo9jfsQpzVUnCzK1gKjJ13mScFjsPeElV4BBNDPmi9wSH41iSG1Fq6EYJM9FsatL8ICn7ruiI3jDCFyQYIqPXFCm4Z/tgkt/FtcPLOjrqX5+wLU5ll11mpjPsYLRpG0HI6LqyB6/heSKx5fEdg7qe6Zjnt74egTHeeGPA8pIOfn9TWYM7pAPpJ2GzuKuOT4mY2XmcebOgqgd8wNyfjqCig1XLBaCBCzFRsd+SaNZ5ci1+A/VyDMrYqD05EsTP7Y4wu3W/FHvgcxb7iXcAFMYFGKqbVmC5qo62g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2906002)(26005)(36756003)(40460700003)(186003)(1076003)(4326008)(316002)(70586007)(2616005)(107886003)(356005)(81166007)(86362001)(70206006)(8676002)(8936002)(54906003)(36860700001)(47076005)(7416002)(5660300002)(110136005)(82310400004)(7696005)(508600001)(6666004)(83380400001)(336012)(426003)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:12:49.5659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 062c68ff-6fb6-4fd0-abf0-08d9f7a81f17
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3758
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f19abc59b6cd..19715994f919 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -457,6 +457,16 @@ struct bpf_func_proto {
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
index d7473fee247c..f00e516acbbe 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5529,6 +5529,11 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
 
@@ -5868,13 +5873,12 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
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
@@ -5885,11 +5889,11 @@ static bool check_arg_pair_ok(const struct bpf_func_proto *fn)
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

