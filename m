Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E1550BE9A
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiDVRbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiDVRbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:31:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C320E0AFF;
        Fri, 22 Apr 2022 10:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njGlzrh3rp6FJN8mZL4aR9I4vLI80LjcmDOfFHwVSO8ge02Vd2zlKH/V/9W+PcHuJt2uND8FAJ+C+rnuE1lSsI0WlQfcoue6y3Tlv/6QGEnMD4b5rf5MI9pbaRKzr66j9Zw0s6GE9/wgSWu1stRiouY25dk5QKMXPsfrH5E+k+g+fNvomfYKvPhXHGrc3KBdLqJgXBPukCHVciCRkAtItveQ6RhH4E2x2Shxs/rJa5krGkwlnYSPYCeYSsCi4alCg9r22wGoSMfopT0LywXOPlQqes62gPsSD/aAOoWcUY3AHnIk5STY2EGfOCj2LRWEa3UsneNoCxDazLysyjH5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBxjIJXUpxaypfpvp0DBL33GiDacwKv5E5TgW6IbTLw=;
 b=cEc9KYrtGl2LcjcHDhtQ15oLxThgHA9MSiBSN207K3oNYvB8n/l0t0Cb03iXAEUWSK87kpEy/NdnPaUWwhRpVqTi2SmMmurpytf9LMFgt2UjaQvhP639cL5Mt0UfOOHKjwDPNrbYf0GLWr1u+6ZE4dq39QentI53BtxqA8SOy5O9SNujxnJLVBUi0g4T0mjbFDlm4Ftg2PeWhawS8edwUSDm/kGl0B0LtuTs9/2+0abYTuCh3BIYRCAH+ZYP+WFcqouTOKZbLMv7ONqrlu7tMqF/dWFskv6+wYptaf9qD4q+Gme8ytdFzzC0dcsHPDU/1LcV2STZ7AQC/XGgRWDHrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBxjIJXUpxaypfpvp0DBL33GiDacwKv5E5TgW6IbTLw=;
 b=sYhSVjlwh84YubagawBjQOTPcmcN5GIlmTgQyWCxcoTxQKGFgmYKN4CTxtB1aGlwo7GdOMBNkdUxDdWw1DiaT1huA9pLfrg+wEBh2ACKbCidK6ZfUlug3Ri228k/pmKlOYMQWcFruS9uDetSmYfhaZAtLSJdTzW4ZaZ0PYvVQGuFtVqxGHk9MaHoYuKFxZYL/VU+gGU6BTS6zRfGJxBTlW7zzjCjJ0exzHEkxGZeKOqOfDs25ygvZoqswj86y8nlLVo23tGh9lKcsOP8hfNz7U3Frr+kKojYiJIPBHgUeyCE+4zrpFNmx6bbS603urjICwyFXcr2Bg6cKUl0pEyvkg==
Received: from MW4PR03CA0282.namprd03.prod.outlook.com (2603:10b6:303:b5::17)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 17:24:58 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::4b) by MW4PR03CA0282.outlook.office365.com
 (2603:10b6:303:b5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 17:24:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 17:24:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 17:24:58 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 10:24:57 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 22 Apr
 2022 10:24:50 -0700
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
Subject: [PATCH bpf-next v6 3/6] bpf: Allow helpers to accept pointers with a fixed size
Date:   Fri, 22 Apr 2022 20:24:19 +0300
Message-ID: <20220422172422.4037988-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422172422.4037988-1-maximmi@nvidia.com>
References: <20220422172422.4037988-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e1f77b9-89ec-4057-1411-08da248506ab
X-MS-TrafficTypeDiagnostic: DM6PR12MB4268:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4268900A6BAADB41E3BB2831DCF79@DM6PR12MB4268.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mlcDUITy6TGvIl6ZleNdv7oN3NKYxFwFk8BqzUeNcsA0hYCsE7R8dKIvkdH19sog8fJC9g15AgzUNDUdNyf67Z/ZS6zl5MN/c5YHgMNgeB09YRkgWR2HpvDk9LkSC+vMnT9eAqcGkR4kHDWv+gnQJ/R83LXOCxD6DHWBn7ZT4ZYYUTXjAu8jMNuLhGG9MLVa5ynQ3d9GAJth84hXi4jVQkKtxzHVvbEtOE4I3WVw8baOgiJjqIV7Rr+SuRxO/dEXvhTT+3xJv7YZ+Nlb+uD8WrJFAokf1RYVGDR8x0rIa2pmEVgxwpgb/Yp9M+A+lqvMSOCHkA9xddfXLibJrTW4mWf0FPOTYKkKtEsYF70rf7LVg1rINaON6G0y7Q5X9BCucUOUNfqbfJ/2ssKYh5gG48PAR16ZkcCazQU2+gkbSzAS32djH9TxFSTtVBiCrsA35HSEABFp3fHgvT/EM9idD2cABhBz7sJKr/iOMLoKzIbJZdNMkwKoLUkSFrDjBGictcKjhsS1Fag8WOWTjGslvgpXvCrtGz8AEuA3iCG69ObimU6CagyOdLofenEsX41J4XoXticNyO6BsG8GR2NI+Cwxzml6SXYbsCDgE4Zel5ps8Vn9js/Kq+h0wYCBQG2D7m4wpEmwcsKQDsCNTLOtBj6be1YmqJhM20qJWX1x4HrQSm4JKubPM4uTdNKuv54WESjOcApFiQddWCYo3S2xqme+ctzdH+Urk8JcS5r/pC3Zw9PeKu8OBqPGblUH+FJjVj0zffE9+buLhCpxmXI5wA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(8936002)(7416002)(86362001)(5660300002)(70586007)(2906002)(70206006)(40460700003)(356005)(508600001)(47076005)(54906003)(83380400001)(186003)(8676002)(4326008)(26005)(110136005)(36756003)(426003)(336012)(6666004)(107886003)(7696005)(316002)(36860700001)(82310400005)(2616005)(1076003)(461764006)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:24:58.6378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1f77b9-89ec-4057-1411-08da248506ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4268
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 71827d14724a..368fab3dfca5 100644
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
+	    check_args_pair_invalid(fn, 1) ||
+	    check_args_pair_invalid(fn, 2) ||
+	    check_args_pair_invalid(fn, 3) ||
+	    check_args_pair_invalid(fn, 4))
 		return false;
 
 	return true;
-- 
2.30.2

