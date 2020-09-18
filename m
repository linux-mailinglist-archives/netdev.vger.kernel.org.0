Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951A926FC39
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIRMMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIRMMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:12:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D94C061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:12:47 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q13so7766963ejo.9
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wx5hAFWWE6GklAYYX7NOKAy5wkpcjpm3lIauyn/nTBg=;
        b=wyWUYKGrO3mzub9ytWuD9wwH/vj2ue0KgxiRuCeHmsrillcgm52px/F+I5A8OURp17
         XeKD9GSs3Zvfz3mH/PmFc6iuTxqLCoftOuPEyHZyRpwn/xu+BQezEGoUH9QXlhvNcPTT
         goFWltEQpFWgCOuMT9K9v1Hk9AemzsMO4DuIpDmyi0FrSm18ecQaJRFltdqRANIJnOEk
         FZkSrr3+tukY9JolU76Y9+cn0jNsE0Pqca+ew8CkT1W6s5pAEX1ad2pqc8XPqnpdGcxm
         +p1xJ2Lx5T4pmQzq77RBTERyTOaH5quoRG6ar+0Ro4CrpJ1k/NXBrarkHlJC5Q+7GQL9
         pVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wx5hAFWWE6GklAYYX7NOKAy5wkpcjpm3lIauyn/nTBg=;
        b=oViA5xt5PK93kDLpFgweQ/lp9Ap1IcjkKEyFIatiIgLcPnUJ0nbsKIl1amVYzet9JC
         KM+tYw+hoU6MF1qpThM0tRpeExKdNui8tR96lHSvImcVrUt2EuS/mteQ5avJAhGMUaW1
         eBWRrK2hvDnhXD9tzOQXJk3xWiNMKqsSbj1lWM8ZfStM2XCE8GTuzJGfEECgVM1RWVjQ
         GynHHEUrPZWwgrh4iioDZDo94huHKG1xV7Tnvp4g5XipKy4a4bcMWiUEE7LCOXqyoGhy
         ouYqt7eQQePLQLCqqzbo49NprvTRTDLJkl1U0KUKWSwPKf0vAPotcphy5tySlVDI/7w+
         fHFg==
X-Gm-Message-State: AOAM532Fk4iVU0vbVzsGVz5kqhZ3YlM+N/DZcOJimOvaHzEjj18VTC7C
        P0dJ85G0SsG3WHyloFKiBad7JA==
X-Google-Smtp-Source: ABdhPJxlArybB/q+VyfEYF7hyYCHnY8Cf8WXJAibZsAlN4wrrMtJ+lAXCmsz/2XjI6nkJZctZf5A1g==
X-Received: by 2002:a17:906:7fcb:: with SMTP id r11mr34438120ejs.519.1600431166133;
        Fri, 18 Sep 2020 05:12:46 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id h64sm2084555edd.50.2020.09.18.05.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:12:45 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH bpf-next v3 3/5] bpf: add 'bpf_mptcp_sock' structure and helper
Date:   Fri, 18 Sep 2020 14:10:42 +0200
Message-Id: <20200918121046.190240-3-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
References: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to precisely identify the parent MPTCP connection of a subflow,
it is required to access the mptcp_sock's token which uniquely identify a
MPTCP connection.

This patch adds a new structure 'bpf_mptcp_sock' exposing the 'token' field
of the 'mptcp_sock' extracted from a subflow's 'tcp_sock'. It also adds the
declaration of a new BPF helper of the same name to expose the newly
defined structure in the userspace BPF API.

This is the foundation to expose more MPTCP-specific fields through BPF.

Currently, it is limited to the field 'token' of the msk but it is
easily extensible.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---
 include/linux/bpf.h            | 33 ++++++++++++++++
 include/uapi/linux/bpf.h       | 14 +++++++
 kernel/bpf/verifier.c          | 30 ++++++++++++++
 net/core/filter.c              |  4 ++
 net/mptcp/Makefile             |  2 +
 net/mptcp/bpf.c                | 72 ++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 +
 tools/include/uapi/linux/bpf.h | 14 +++++++
 8 files changed, 171 insertions(+)
 create mode 100644 net/mptcp/bpf.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d7c5a6ed87e3..fbb3e1629a5e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -305,6 +305,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
+	RET_PTR_TO_MPTCP_SOCK_OR_NULL,	/* returns a pointer to mptcp_sock or NULL */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -385,6 +386,8 @@ enum bpf_reg_type {
 	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
 	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
 	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
+	PTR_TO_MPTCP_SOCK,	 /* reg points to struct mptcp_sock */
+	PTR_TO_MPTCP_SOCK_OR_NULL, /* reg points to struct mptcp_sock or NULL */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -1790,6 +1793,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
 extern const struct bpf_func_proto bpf_copy_from_user_proto;
+extern const struct bpf_func_proto bpf_mptcp_sock_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
@@ -1846,6 +1850,35 @@ struct sk_reuseport_kern {
 	u32 reuseport_id;
 	bool bind_inany;
 };
+
+#ifdef CONFIG_MPTCP
+bool bpf_mptcp_sock_is_valid_access(int off, int size,
+				    enum bpf_access_type type,
+				    struct bpf_insn_access_aux *info);
+
+u32 bpf_mptcp_sock_convert_ctx_access(enum bpf_access_type type,
+				      const struct bpf_insn *si,
+				      struct bpf_insn *insn_buf,
+				      struct bpf_prog *prog,
+				      u32 *target_size);
+#else /* CONFIG_MPTCP */
+static inline bool bpf_mptcp_sock_is_valid_access(int off, int size,
+						  enum bpf_access_type type,
+						  struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+static inline u32 bpf_mptcp_sock_convert_ctx_access(enum bpf_access_type type,
+						    const struct bpf_insn *si,
+						    struct bpf_insn *insn_buf,
+						    struct bpf_prog *prog,
+						    u32 *target_size)
+{
+	return 0;
+}
+#endif /* CONFIG_MPTCP */
+
 bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info);
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 351b3d0a6ca8..da86553ac841 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3586,6 +3586,15 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * struct bpf_mptcp_sock *bpf_mptcp_sock(struct bpf_sock *sk)
+ *	Description
+ *		This helper gets a **struct bpf_mptcp_sock** pointer from a
+ *		**struct bpf_sock** pointer.
+ *	Return
+ *		A **struct bpf_mptcp_sock** pointer on success, or **NULL** in
+ *		case of failure.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3746,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(mptcp_sock),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4070,6 +4080,10 @@ struct bpf_tcp_sock {
 	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
+struct bpf_mptcp_sock {
+	__u32 token;		/* msk token */
+};
+
 struct bpf_sock_tuple {
 	union {
 		struct {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4161b6c406bc..c96538cf4521 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -392,6 +392,7 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_SOCK_COMMON ||
 		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_MPTCP_SOCK ||
 		type == PTR_TO_XDP_SOCK;
 }
 
@@ -399,6 +400,7 @@ static bool reg_type_not_null(enum bpf_reg_type type)
 {
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_MPTCP_SOCK ||
 		type == PTR_TO_MAP_VALUE ||
 		type == PTR_TO_SOCK_COMMON;
 }
@@ -409,6 +411,7 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
 	       type == PTR_TO_SOCKET_OR_NULL ||
 	       type == PTR_TO_SOCK_COMMON_OR_NULL ||
 	       type == PTR_TO_TCP_SOCK_OR_NULL ||
+	       type == PTR_TO_MPTCP_SOCK_OR_NULL ||
 	       type == PTR_TO_BTF_ID_OR_NULL ||
 	       type == PTR_TO_MEM_OR_NULL ||
 	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
@@ -427,6 +430,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_SOCKET_OR_NULL ||
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
+		type == PTR_TO_MPTCP_SOCK ||
+		type == PTR_TO_MPTCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
 		type == PTR_TO_MEM_OR_NULL;
 }
@@ -500,6 +505,8 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_SOCK_COMMON_OR_NULL] = "sock_common_or_null",
 	[PTR_TO_TCP_SOCK]	= "tcp_sock",
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
+	[PTR_TO_MPTCP_SOCK]	= "mptcp_sock",
+	[PTR_TO_MPTCP_SOCK_OR_NULL] = "mptcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 	[PTR_TO_BTF_ID]		= "ptr_",
@@ -2184,6 +2191,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
@@ -2793,6 +2802,9 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	case PTR_TO_TCP_SOCK:
 		valid = bpf_tcp_sock_is_valid_access(off, size, t, &info);
 		break;
+	case PTR_TO_MPTCP_SOCK:
+		valid = bpf_mptcp_sock_is_valid_access(off, size, t, &info);
+		break;
 	case PTR_TO_XDP_SOCK:
 		valid = bpf_xdp_sock_is_valid_access(off, size, t, &info);
 		break;
@@ -2951,6 +2963,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 		pointer_desc = "tcp_sock ";
 		break;
+	case PTR_TO_MPTCP_SOCK:
+		pointer_desc = "mptcp_sock ";
+		break;
 	case PTR_TO_XDP_SOCK:
 		pointer_desc = "xdp_sock ";
 		break;
@@ -5049,6 +5064,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
+	} else if (fn->ret_type == RET_PTR_TO_MPTCP_SOCK_OR_NULL) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type = PTR_TO_MPTCP_SOCK_OR_NULL;
+		regs[BPF_REG_0].id = ++env->id_gen;
 	} else if (fn->ret_type == RET_PTR_TO_ALLOC_MEM_OR_NULL) {
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
@@ -5380,6 +5399,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
@@ -7100,6 +7121,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 			reg->type = PTR_TO_SOCK_COMMON;
 		} else if (reg->type == PTR_TO_TCP_SOCK_OR_NULL) {
 			reg->type = PTR_TO_TCP_SOCK;
+		} else if (reg->type == PTR_TO_MPTCP_SOCK_OR_NULL) {
+			reg->type = PTR_TO_MPTCP_SOCK;
 		} else if (reg->type == PTR_TO_BTF_ID_OR_NULL) {
 			reg->type = PTR_TO_BTF_ID;
 		} else if (reg->type == PTR_TO_MEM_OR_NULL) {
@@ -8489,6 +8512,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
@@ -9016,6 +9041,8 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type type)
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
@@ -10167,6 +10194,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		case PTR_TO_TCP_SOCK:
 			convert_ctx_access = bpf_tcp_sock_convert_ctx_access;
 			break;
+		case PTR_TO_MPTCP_SOCK:
+			convert_ctx_access = bpf_mptcp_sock_convert_ctx_access;
+			break;
 		case PTR_TO_XDP_SOCK:
 			convert_ctx_access = bpf_xdp_sock_convert_ctx_access;
 			break;
diff --git a/net/core/filter.c b/net/core/filter.c
index dab48528dceb..a9d964e4764e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6890,6 +6890,10 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
+#ifdef CONFIG_MPTCP
+	case BPF_FUNC_mptcp_sock:
+		return &bpf_mptcp_sock_proto;
+#endif /* CONFIG_MPTCP */
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index a611968be4d7..aae2ede220ed 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -10,3 +10,5 @@ obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
 mptcp_crypto_test-objs := crypto_test.o
 mptcp_token_test-objs := token_test.o
 obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o mptcp_token_test.o
+
+obj-$(CONFIG_BPF) += bpf.o
diff --git a/net/mptcp/bpf.c b/net/mptcp/bpf.c
new file mode 100644
index 000000000000..5332469fbb28
--- /dev/null
+++ b/net/mptcp/bpf.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2020, Tessares SA.
+ *
+ * Author: Nicolas Rybowski <nicolas.rybowski@tessares.net>
+ *
+ */
+
+#include <linux/bpf.h>
+
+#include "protocol.h"
+
+bool bpf_mptcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
+				    struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= offsetofend(struct bpf_mptcp_sock, token))
+		return false;
+
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	default:
+		return size == sizeof(__u32);
+	}
+}
+
+u32 bpf_mptcp_sock_convert_ctx_access(enum bpf_access_type type,
+				      const struct bpf_insn *si,
+				      struct bpf_insn *insn_buf,
+				      struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+#define BPF_MPTCP_SOCK_GET_COMMON(FIELD)							\
+	do {											\
+		BUILD_BUG_ON(sizeof_field(struct mptcp_sock, FIELD) >				\
+				sizeof_field(struct bpf_mptcp_sock, FIELD));			\
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct mptcp_sock, FIELD),		\
+							si->dst_reg, si->src_reg,		\
+							offsetof(struct mptcp_sock, FIELD));	\
+	} while (0)
+
+	if (insn > insn_buf)
+		return insn - insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct bpf_mptcp_sock, token):
+		BPF_MPTCP_SOCK_GET_COMMON(token);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+BPF_CALL_1(bpf_mptcp_sock, struct sock *, sk)
+{
+	if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_TCP && sk_is_mptcp(sk)) {
+		struct mptcp_subflow_context *mptcp_sfc = mptcp_subflow_ctx(sk);
+
+		return (unsigned long)mptcp_sfc->conn;
+	}
+	return (unsigned long)NULL;
+}
+
+const struct bpf_func_proto bpf_mptcp_sock_proto = {
+	.func           = bpf_mptcp_sock,
+	.gpl_only       = false,
+	.ret_type       = RET_PTR_TO_MPTCP_SOCK_OR_NULL,
+	.arg1_type      = ARG_PTR_TO_SOCK_COMMON,
+};
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 08388173973f..5c3e7aad8faa 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -428,6 +428,7 @@ class PrinterHelpers(Printer):
             'struct tcp_request_sock',
             'struct udp6_sock',
             'struct task_struct',
+            'struct bpf_mptcp_sock',
 
             'struct __sk_buff',
             'struct sk_msg_md',
@@ -474,6 +475,7 @@ class PrinterHelpers(Printer):
             'struct udp6_sock',
             'struct task_struct',
             'struct path',
+            'struct bpf_mptcp_sock',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 351b3d0a6ca8..da86553ac841 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3586,6 +3586,15 @@ union bpf_attr {
  * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * struct bpf_mptcp_sock *bpf_mptcp_sock(struct bpf_sock *sk)
+ *	Description
+ *		This helper gets a **struct bpf_mptcp_sock** pointer from a
+ *		**struct bpf_sock** pointer.
+ *	Return
+ *		A **struct bpf_mptcp_sock** pointer on success, or **NULL** in
+ *		case of failure.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3737,6 +3746,7 @@ union bpf_attr {
 	FN(inode_storage_delete),	\
 	FN(d_path),			\
 	FN(copy_from_user),		\
+	FN(mptcp_sock),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -4070,6 +4080,10 @@ struct bpf_tcp_sock {
 	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
+struct bpf_mptcp_sock {
+	__u32 token;		/* msk token */
+};
+
 struct bpf_sock_tuple {
 	union {
 		struct {
-- 
2.28.0

