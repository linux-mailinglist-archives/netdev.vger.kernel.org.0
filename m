Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A31433914
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhJSOup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:50:45 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:50945
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229641AbhJSOun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:50:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnr9RZR4kJhuJoN6t651URio3R+eKVQYPVesBDhJb7IHzGen/Wxw7J9HtqHfNgUCDCMuPlXo6hyd/rIns3OpQRa6+HJTDAilZonWC2+dyBMXGEva9jnuz7rI6yn7Go7RzoHcf9nQJvONVfSRzztFSUer/9Pw4ZiUlq/L3mKE39TAkAVyyWW0a2eP3yOORjup0DtJonq8ePfH0whq7QdEPPevXbv+nb+C1adTHw3HkK70zsDOroRQWosv97DkDL3HYYdQUfevvzyHvFnE3gqSwrAFxRx3iI929a0IsoOD+jqBtlAezcGEvHLf0C+83C8KznCc8EKCNo5wGkAAXpfDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Q7C3HQJGZiVgoIHw6X7iM/39ZDT/tFo1L7k2OMaNa0=;
 b=Jo4C1QKJXe3brPvJtWEqE35ImGdBSqyLAQQr3Dn+A0XaA6sS+4LKX0OUg48PfON5IlC7M7Z6iUA0CIq8ztCuXgDH8NnE6R1ZNpfjn2El9girMSuV0TRVL+3Guf2udPWGSqqClC54Uy9b7JN93kmArHrpZTSQZPNmz1tIY+9ivZKkBhTNwgjQPSgGF+r+uqjtiDqN7GZtUTjpWEDHSv9SRogeuT1RpgilRS1e0acf0DV6cbvD6TETsycWbEHggCygxQFe3Gq/qKASnK1dfC2zlTmuKTcIkmtMJnjrgjSLhxDv9vqIaktAAk16q52hJ6kzNu6BPaNSD32pNypOwgZK3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Q7C3HQJGZiVgoIHw6X7iM/39ZDT/tFo1L7k2OMaNa0=;
 b=tmE5bN3tCJAlnmlSUKXo3SfGNQnWhJNVddoRmLrvgLMJEy1GqkN7s2MVnJyvunasvYPxlo/0TRpBM4IuUCRuac7VWZdS+HrAw+IZxS3A2mA+O7OHB5tU23WWzzEIH9x0ee5GeYUaE5O1XsqpGMuMvxXUmrZvZzyuAMqVtbGBBOvOUG4z5Cn5QrqN70STlIcd0c6TGyfRKh+3Mb67LxFWoDQXDAeHmA39btP6v4grVwI7WGaFfn4JISk1cWVDxS1ZJQqkk3jF1h4vIDftrcbAFImiEJ1DecX9HuziNAarOuOgU6Xp1KFmAO5GA8X/2FqdA8zqdZiQOs8A7UP/IxRdtQ==
Received: from DM6PR12CA0010.namprd12.prod.outlook.com (2603:10b6:5:1c0::23)
 by BYAPR12MB3144.namprd12.prod.outlook.com (2603:10b6:a03:d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 14:48:28 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::7a) by DM6PR12CA0010.outlook.office365.com
 (2603:10b6:5:1c0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Tue, 19 Oct 2021 14:48:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:48:28 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 14:48:27 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 14:48:27 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:48:15 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next 06/10] bpf: Expose struct nf_conn to BPF
Date:   Tue, 19 Oct 2021 17:46:51 +0300
Message-ID: <20211019144655.3483197-7-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e02ee8ae-e9b9-45b4-12b7-08d9930f832c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR12MB31446B0154F78972CC8E0EE5DCBD9@BYAPR12MB3144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l39e7abl2KTVCFZjlVuzq972ZihpuaZHAQYT4bZ9qNpbcrSysJE9G/A9+DZk0bi8LVkKjPPCB2IbZvSHsRXlN4yfd08HnRu70b7ZiC7b55vGfaJoKp87G9PuHEUgX22xj7w/zKLtN//tOY3kwUajxKb+1lzlKptkVmcmLvQoEiU0U+kgIwPq0KcyAyZjLyjX7dXCLcQ8jzmVowUvmNoFppe9LnYt8lqASgPF3AY/KTAV63w0i/J3EoA12EikB0y4QZPim72LE2eaxbLmCbBEYSu/zeo2bObMK9zebOuyGhqE3Ds7eXLyBLTrmVhMrR8eRCTkNs+HbemrCO38IBI3vI0rSbuDLJmKNN0YNNRZ2ym4Q8PoS8NiyDuWiQUnRRtJY0ZdyipC2/bIA6VRP7zTNHXrB5eBM7EhQ1G5osppodcGMVVh/8P2EX2EpSdg8mdbUCTZ4Q1s+J3y7ZjK/JMY9GijgMxMMR8PpvUKiXNB9FmBYuyz2QkDZ/DZdJowvJ0sGT0RO+3TVzherNnLsCWCJOLhxpJIf39Gj66Kvian76DEYEIOjKxGx+VWNizL1tQ7JW51NVftnaFCcH8Iff4W4qZSEH4YcFI5QqdXFrIHwmkGcqvldG7Ysd3TlWV+CCJeNkLYpnlHVU9q3PWreTPMXDG2291z0pHF04gTMYn1EVJIxIVkM/NlpSmZP3z2Xx99xzF/ZhuYHBreZ8EQj8Be0g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(2906002)(336012)(426003)(86362001)(36756003)(107886003)(356005)(7636003)(7696005)(70206006)(70586007)(6666004)(7416002)(8676002)(8936002)(186003)(508600001)(36906005)(4326008)(316002)(36860700001)(54906003)(110136005)(5660300002)(30864003)(83380400001)(47076005)(1076003)(82310400003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:48:28.3004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e02ee8ae-e9b9-45b4-12b7-08d9930f832c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds struct nf_conn as a new type to BPF. For now, only the
status field is mapped. It will allow to add helpers that will expose
conntrack information to BPF programs.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/bpf.h            | 46 ++++++++++++++++
 include/uapi/linux/bpf.h       |  4 ++
 kernel/bpf/verifier.c          | 95 ++++++++++++++++++++++++++++++++--
 net/core/filter.c              | 41 +++++++++++++++
 scripts/bpf_doc.py             |  1 +
 tools/include/uapi/linux/bpf.h |  4 ++
 6 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d604c8251d88..21ca6e1f0f7a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -341,6 +341,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_STACK_OR_NULL,	/* pointer to stack or NULL */
 	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
 	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
+	ARG_PTR_TO_NF_CONN,	/* pointer to nf_conn */
 	__BPF_ARG_TYPE_MAX,
 };
 
@@ -358,6 +359,7 @@ enum bpf_return_type {
 	RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, /* returns a pointer to a valid memory or a btf_id or NULL */
 	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
+	RET_PTR_TO_NF_CONN_OR_NULL,	/* returns a pointer to a nf_conn or NULL */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -459,6 +461,8 @@ enum bpf_reg_type {
 	PTR_TO_PERCPU_BTF_ID,	 /* reg points to a percpu kernel variable */
 	PTR_TO_FUNC,		 /* reg points to a bpf program function */
 	PTR_TO_MAP_KEY,		 /* reg points to a map element key */
+	PTR_TO_NF_CONN,		 /* reg points to struct nf_conn */
+	PTR_TO_NF_CONN_OR_NULL,	 /* reg points to struct nf_conn or NULL */
 	__BPF_REG_TYPE_MAX,
 };
 
@@ -2127,6 +2131,32 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 				struct bpf_insn *insn_buf,
 				struct bpf_prog *prog,
 				u32 *target_size);
+
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+bool bpf_ct_is_valid_access(int off, int size, enum bpf_access_type type,
+			    struct bpf_insn_access_aux *info);
+u32 bpf_ct_convert_ctx_access(enum bpf_access_type type,
+			      const struct bpf_insn *si,
+			      struct bpf_insn *insn_buf,
+			      struct bpf_prog *prog, u32 *target_size);
+#else
+static inline bool bpf_ct_is_valid_access(int off, int size,
+					  enum bpf_access_type type,
+					  struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+static inline u32 bpf_ct_convert_ctx_access(enum bpf_access_type type,
+					    const struct bpf_insn *si,
+					    struct bpf_insn *insn_buf,
+					    struct bpf_prog *prog,
+					    u32 *target_size)
+{
+	return 0;
+}
+#endif
+
 #else
 static inline bool bpf_sock_common_is_valid_access(int off, int size,
 						   enum bpf_access_type type,
@@ -2148,6 +2178,22 @@ static inline u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 {
 	return 0;
 }
+
+static inline bool bpf_ct_is_valid_access(int off, int size,
+					  enum bpf_access_type type,
+					  struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+static inline u32 bpf_ct_convert_ctx_access(enum bpf_access_type type,
+					    const struct bpf_insn *si,
+					    struct bpf_insn *insn_buf,
+					    struct bpf_prog *prog,
+					    u32 *target_size)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_INET
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index efb2750f39c6..a10a44c4f79b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5472,6 +5472,10 @@ struct bpf_xdp_sock {
 	__u32 queue_id;
 };
 
+struct bpf_nf_conn {
+	__u64 status;
+};
+
 #define XDP_PACKET_HEADROOM 256
 
 /* User return codes for XDP prog type.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 20900a1bac12..6eafef35e247 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -436,13 +436,19 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 		type == PTR_TO_XDP_SOCK;
 }
 
+static bool type_is_ct_pointer(enum bpf_reg_type type)
+{
+	return type == PTR_TO_NF_CONN;
+}
+
 static bool reg_type_not_null(enum bpf_reg_type type)
 {
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_MAP_VALUE ||
 		type == PTR_TO_MAP_KEY ||
-		type == PTR_TO_SOCK_COMMON;
+		type == PTR_TO_SOCK_COMMON ||
+		type == PTR_TO_NF_CONN;
 }
 
 static bool reg_type_may_be_null(enum bpf_reg_type type)
@@ -454,7 +460,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
 	       type == PTR_TO_BTF_ID_OR_NULL ||
 	       type == PTR_TO_MEM_OR_NULL ||
 	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
-	       type == PTR_TO_RDWR_BUF_OR_NULL;
+	       type == PTR_TO_RDWR_BUF_OR_NULL ||
+	       type == PTR_TO_NF_CONN_OR_NULL;
 }
 
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -470,12 +477,15 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
-		type == PTR_TO_MEM_OR_NULL;
+		type == PTR_TO_MEM_OR_NULL ||
+		type == PTR_TO_NF_CONN ||
+		type == PTR_TO_NF_CONN_OR_NULL;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
 {
-	return type == ARG_PTR_TO_SOCK_COMMON;
+	return type == ARG_PTR_TO_SOCK_COMMON ||
+		type == ARG_PTR_TO_NF_CONN;
 }
 
 static bool arg_type_may_be_null(enum bpf_arg_type type)
@@ -577,6 +587,8 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_RDWR_BUF_OR_NULL] = "rdwr_buf_or_null",
 	[PTR_TO_FUNC]		= "func",
 	[PTR_TO_MAP_KEY]	= "map_key",
+	[PTR_TO_NF_CONN]	= "nf_conn",
+	[PTR_TO_NF_CONN_OR_NULL] = "nf_conn_or_null",
 };
 
 static char slot_type_char[] = {
@@ -1189,6 +1201,9 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 	case PTR_TO_RDWR_BUF_OR_NULL:
 		reg->type = PTR_TO_RDWR_BUF;
 		break;
+	case PTR_TO_NF_CONN_OR_NULL:
+		reg->type = PTR_TO_NF_CONN;
+		break;
 	default:
 		WARN_ONCE(1, "unknown nullable register type");
 	}
@@ -2748,6 +2763,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_MEM_OR_NULL:
 	case PTR_TO_FUNC:
 	case PTR_TO_MAP_KEY:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -3665,6 +3682,40 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	return -EACCES;
 }
 
+static int check_ct_access(struct bpf_verifier_env *env, int insn_idx,
+			   u32 regno, int off, int size, enum bpf_access_type t)
+{
+	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_reg_state *reg = &regs[regno];
+	struct bpf_insn_access_aux info = {};
+	bool valid;
+
+	if (reg->smin_value < 0) {
+		verbose(env, "R%d min value is negative, either use unsigned index or do a if (index >=0) check.\n",
+			regno);
+		return -EACCES;
+	}
+
+	switch (reg->type) {
+	case PTR_TO_NF_CONN:
+		valid = bpf_ct_is_valid_access(off, size, t, &info);
+		break;
+	default:
+		valid = false;
+	}
+
+	if (valid) {
+		env->insn_aux_data[insn_idx].ctx_field_size =
+			info.ctx_field_size;
+		return 0;
+	}
+
+	verbose(env, "R%d invalid %s access off=%d size=%d\n",
+		regno, reg_type_str[reg->type], off, size);
+
+	return -EACCES;
+}
+
 static bool is_pointer_value(struct bpf_verifier_env *env, int regno)
 {
 	return __is_pointer_value(env->allow_ptr_leaks, reg_state(env, regno));
@@ -3684,6 +3735,13 @@ static bool is_sk_reg(struct bpf_verifier_env *env, int regno)
 	return type_is_sk_pointer(reg->type);
 }
 
+static bool is_ct_reg(struct bpf_verifier_env *env, int regno)
+{
+	const struct bpf_reg_state *reg = reg_state(env, regno);
+
+	return type_is_ct_pointer(reg->type);
+}
+
 static bool is_pkt_reg(struct bpf_verifier_env *env, int regno)
 {
 	const struct bpf_reg_state *reg = reg_state(env, regno);
@@ -3804,6 +3862,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_XDP_SOCK:
 		pointer_desc = "xdp_sock ";
 		break;
+	case PTR_TO_NF_CONN:
+		pointer_desc = "nf_conn ";
+		break;
 	default:
 		break;
 	}
@@ -4478,6 +4539,15 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		err = check_sock_access(env, insn_idx, regno, off, size, t);
 		if (!err && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
+	} else if (type_is_ct_pointer(reg->type)) {
+		if (t == BPF_WRITE) {
+			verbose(env, "R%d cannot write into %s\n",
+				regno, reg_type_str[reg->type]);
+			return -EACCES;
+		}
+		err = check_ct_access(env, insn_idx, regno, off, size, t);
+		if (!err && value_regno >= 0)
+			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_TP_BUFFER) {
 		err = check_tp_buffer_access(env, reg, regno, off, size);
 		if (!err && t == BPF_READ && value_regno >= 0)
@@ -4571,7 +4641,8 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 	if (is_ctx_reg(env, insn->dst_reg) ||
 	    is_pkt_reg(env, insn->dst_reg) ||
 	    is_flow_key_reg(env, insn->dst_reg) ||
-	    is_sk_reg(env, insn->dst_reg)) {
+	    is_sk_reg(env, insn->dst_reg) ||
+	    is_ct_reg(env, insn->dst_reg)) {
 		verbose(env, "BPF_ATOMIC stores into R%d %s is not allowed\n",
 			insn->dst_reg,
 			reg_type_str[reg_state(env, insn->dst_reg)->type]);
@@ -5086,6 +5157,7 @@ static const struct bpf_reg_types func_ptr_types = { .types = { PTR_TO_FUNC } };
 static const struct bpf_reg_types stack_ptr_types = { .types = { PTR_TO_STACK } };
 static const struct bpf_reg_types const_str_ptr_types = { .types = { PTR_TO_MAP_VALUE } };
 static const struct bpf_reg_types timer_types = { .types = { PTR_TO_MAP_VALUE } };
+static const struct bpf_reg_types nf_conn_types = { .types = { PTR_TO_NF_CONN } };
 
 static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_MAP_KEY]		= &map_key_value_types,
@@ -5118,6 +5190,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_PTR_TO_STACK_OR_NULL]	= &stack_ptr_types,
 	[ARG_PTR_TO_CONST_STR]		= &const_str_ptr_types,
 	[ARG_PTR_TO_TIMER]		= &timer_types,
+	[ARG_PTR_TO_NF_CONN]		= &nf_conn_types,
 };
 
 static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
@@ -6586,6 +6659,9 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		 */
 		regs[BPF_REG_0].btf = btf_vmlinux;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
+	} else if (fn->ret_type == RET_PTR_TO_NF_CONN_OR_NULL) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type = PTR_TO_NF_CONN_OR_NULL;
 	} else {
 		verbose(env, "unknown return type %d of func %s#%d\n",
 			fn->ret_type, func_id_name(func_id), func_id);
@@ -7214,6 +7290,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
@@ -10505,6 +10583,8 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
 		 */
@@ -11040,6 +11120,8 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type type)
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		return false;
 	default:
 		return true;
@@ -12462,6 +12544,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				return -EINVAL;
 			}
 			continue;
+		case PTR_TO_NF_CONN:
+			convert_ctx_access = bpf_ct_convert_ctx_access;
+			break;
 		default:
 			continue;
 		}
diff --git a/net/core/filter.c b/net/core/filter.c
index d04988e67640..d2d07ccae599 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -78,6 +78,7 @@
 #include <linux/btf_ids.h>
 #include <net/tls.h>
 #include <net/xdp.h>
+#include <net/netfilter/nf_conntrack.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -8002,6 +8003,24 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	return size == size_default;
 }
 
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+bool bpf_ct_is_valid_access(int off, int size, enum bpf_access_type type,
+			    struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off > sizeof(struct bpf_nf_conn))
+		return false;
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	case offsetof(struct bpf_nf_conn, status):
+		return size == sizeof_field(struct bpf_nf_conn, status);
+	}
+
+	return false;
+}
+#endif
+
 static bool sock_filter_is_valid_access(int off, int size,
 					enum bpf_access_type type,
 					const struct bpf_prog *prog,
@@ -9094,6 +9113,28 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+u32 bpf_ct_convert_ctx_access(enum bpf_access_type type,
+			      const struct bpf_insn *si,
+			      struct bpf_insn *insn_buf,
+			      struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct bpf_nf_conn, status):
+		BUILD_BUG_ON(sizeof_field(struct nf_conn, status) >
+			     sizeof_field(struct bpf_nf_conn, status));
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct nf_conn, status),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct nf_conn, status));
+		break;
+	}
+
+	return insn - insn_buf;
+}
+#endif
+
 static u32 tc_cls_act_convert_ctx_access(enum bpf_access_type type,
 					 const struct bpf_insn *si,
 					 struct bpf_insn *insn_buf,
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 00ac7b79cddb..0c2cd955f5e0 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -596,6 +596,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct bpf_nf_conn',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index efb2750f39c6..a10a44c4f79b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5472,6 +5472,10 @@ struct bpf_xdp_sock {
 	__u32 queue_id;
 };
 
+struct bpf_nf_conn {
+	__u64 status;
+};
+
 #define XDP_PACKET_HEADROOM 256
 
 /* User return codes for XDP prog type.
-- 
2.30.2

