Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F35124D85E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgHUPSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgHUPS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:18:29 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CF7C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:18:29 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w17so1712817edt.8
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qp+IvPt9siLMIiICExlCypmGKVhYNZIXdw92BsiuWt8=;
        b=OCZFyhNcE7mIGhGb6YvmGLv4ON3jYPV2/Put2q4q/oIQyy1/NcVtQszrPkfJjC30Oz
         vrHzhuWOzvpDw77bOD0YV4w9r1uGSdzdLR+KUpPpQcp9KYZVrBLACiVbmKkFKj2iAZoA
         H398lgdF1mSK+u3IEWu55dgCgtTbWJMfFWXloxFR9MsCEUwysOhGE0OShh2P5iWNpK2x
         LymDqlHdG8IMXjFrpHCjxEjRmun40lFdeFPgFS66poC1jBgKf14hN4dL1n3hhEHaLWMH
         MMwgn6xFuXLDz4cAGflhKU+KQZ6BE0MN6zWySSUh7ELp7+PaiPg4kKxrCmgQEro0JUWn
         zDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qp+IvPt9siLMIiICExlCypmGKVhYNZIXdw92BsiuWt8=;
        b=mNUAF3OpxMSkxuIs1yVSutrlQufUw+Sx1SdDGbsJJYFrag0xeOxNg52NTlZ7gHiF2w
         KL4y1tKK1FuvOggkBcORiN4bIOrFvLlPvtOURVz3NWZNvG4VAoWErXe3X+U6tdDHQpuz
         +hcBrMxoXn9kVezQHy/1+Jv/w3XWiLGS40zf6HF51TGo+rKpk27PfC5yx1+fzZxCiyGF
         NwzutDq3KfFsCWjakWrivZl/Scoy0oH79rlJdcVk2InxaSCWVEY0iey+t7TtaFq1CYIv
         Dy/hokZgRJ8OUlYFeQGT6Ycz36jLqVQMvFcqUkqxwdwVWc/gOphNWCoBhMAKHCfloUDb
         p6ug==
X-Gm-Message-State: AOAM530XOJk97Q+RVCGl/+NWQUvz5JxVVqL0JoIGva73rIUfwmLPkdBV
        8evR67SGmAu0Z8RlqKs5y1+Prg==
X-Google-Smtp-Source: ABdhPJyLo8mj3nnDOBfYfLfYora9xT+HvJH3pVftN4vFbkxZ3gEqz4L/Uyc1IRWM3WHxv4N5IcC2Yg==
X-Received: by 2002:a05:6402:486:: with SMTP id k6mr3339348edv.83.1598023107886;
        Fri, 21 Aug 2020 08:18:27 -0700 (PDT)
Received: from localhost.localdomain (223.60-242-81.adsl-dyn.isp.belgacom.be. [81.242.60.223])
        by smtp.gmail.com with ESMTPSA id qp16sm1482709ejb.89.2020.08.21.08.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 08:18:27 -0700 (PDT)
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
Subject: [PATCH bpf-next 3/3] bpf: add 'bpf_mptcp_sock' structure and helper
Date:   Fri, 21 Aug 2020 17:15:41 +0200
Message-Id: <20200821151544.1211989-4-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
References: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---
 include/linux/bpf.h            | 33 ++++++++++++++++
 include/uapi/linux/bpf.h       | 13 ++++++
 kernel/bpf/verifier.c          | 30 ++++++++++++++
 net/core/filter.c              |  4 ++
 net/mptcp/Makefile             |  2 +
 net/mptcp/bpf.c                | 72 ++++++++++++++++++++++++++++++++++
 scripts/bpf_helpers_doc.py     |  2 +
 tools/include/uapi/linux/bpf.h | 13 ++++++
 8 files changed, 169 insertions(+)
 create mode 100644 net/mptcp/bpf.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a9b7185a6b37..b4d6a80a653c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -281,6 +281,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
 	RET_PTR_TO_ALLOC_MEM_OR_NULL,	/* returns a pointer to dynamically allocated memory or NULL */
 	RET_PTR_TO_BTF_ID_OR_NULL,	/* returns a pointer to a btf_id or NULL */
+	RET_PTR_TO_MPTCP_SOCK_OR_NULL,	/* returns a pointer to mptcp_sock or NULL */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -360,6 +361,8 @@ enum bpf_reg_type {
 	PTR_TO_RDONLY_BUF_OR_NULL, /* reg points to a readonly buffer or NULL */
 	PTR_TO_RDWR_BUF,	 /* reg points to a read/write buffer */
 	PTR_TO_RDWR_BUF_OR_NULL, /* reg points to a read/write buffer or NULL */
+	PTR_TO_MPTCP_SOCK,	 /* reg points to struct mptcp_sock */
+	PTR_TO_MPTCP_SOCK_OR_NULL, /* reg points to struct mptcp_sock or NULL */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -1737,6 +1740,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
 extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
+extern const struct bpf_func_proto bpf_mptcp_sock_proto;
 
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
@@ -1793,6 +1797,35 @@ struct sk_reuseport_kern {
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
index a9fccfdb3a62..58b6e075537d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3395,6 +3395,14 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
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
@@ -3539,6 +3547,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(mptcp_sock),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -3868,6 +3877,10 @@ struct bpf_tcp_sock {
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
index ef938f17b944..423bbd786eb8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -391,6 +391,7 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_SOCK_COMMON ||
 		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_MPTCP_SOCK ||
 		type == PTR_TO_XDP_SOCK;
 }
 
@@ -398,6 +399,7 @@ static bool reg_type_not_null(enum bpf_reg_type type)
 {
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
+		type == PTR_TO_MPTCP_SOCK ||
 		type == PTR_TO_MAP_VALUE ||
 		type == PTR_TO_SOCK_COMMON;
 }
@@ -408,6 +410,7 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
 	       type == PTR_TO_SOCKET_OR_NULL ||
 	       type == PTR_TO_SOCK_COMMON_OR_NULL ||
 	       type == PTR_TO_TCP_SOCK_OR_NULL ||
+	       type == PTR_TO_MPTCP_SOCK_OR_NULL ||
 	       type == PTR_TO_BTF_ID_OR_NULL ||
 	       type == PTR_TO_MEM_OR_NULL ||
 	       type == PTR_TO_RDONLY_BUF_OR_NULL ||
@@ -426,6 +429,8 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_SOCKET_OR_NULL ||
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
+		type == PTR_TO_MPTCP_SOCK ||
+		type == PTR_TO_MPTCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
 		type == PTR_TO_MEM_OR_NULL;
 }
@@ -499,6 +504,8 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_SOCK_COMMON_OR_NULL] = "sock_common_or_null",
 	[PTR_TO_TCP_SOCK]	= "tcp_sock",
 	[PTR_TO_TCP_SOCK_OR_NULL] = "tcp_sock_or_null",
+	[PTR_TO_MPTCP_SOCK]	= "mptcp_sock",
+	[PTR_TO_MPTCP_SOCK_OR_NULL] = "mptcp_sock_or_null",
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 	[PTR_TO_BTF_ID]		= "ptr_",
@@ -2176,6 +2183,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
@@ -2777,6 +2786,9 @@ static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 	case PTR_TO_TCP_SOCK:
 		valid = bpf_tcp_sock_is_valid_access(off, size, t, &info);
 		break;
+	case PTR_TO_MPTCP_SOCK:
+		valid = bpf_mptcp_sock_is_valid_access(off, size, t, &info);
+		break;
 	case PTR_TO_XDP_SOCK:
 		valid = bpf_xdp_sock_is_valid_access(off, size, t, &info);
 		break;
@@ -2935,6 +2947,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 		pointer_desc = "tcp_sock ";
 		break;
+	case PTR_TO_MPTCP_SOCK:
+		pointer_desc = "mptcp_sock ";
+		break;
 	case PTR_TO_XDP_SOCK:
 		pointer_desc = "xdp_sock ";
 		break;
@@ -4899,6 +4914,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
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
@@ -5226,6 +5245,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
@@ -6880,6 +6901,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 			reg->type = PTR_TO_SOCK_COMMON;
 		} else if (reg->type == PTR_TO_TCP_SOCK_OR_NULL) {
 			reg->type = PTR_TO_TCP_SOCK;
+		} else if (reg->type == PTR_TO_MPTCP_SOCK_OR_NULL) {
+			reg->type = PTR_TO_MPTCP_SOCK;
 		} else if (reg->type == PTR_TO_BTF_ID_OR_NULL) {
 			reg->type = PTR_TO_BTF_ID;
 		} else if (reg->type == PTR_TO_MEM_OR_NULL) {
@@ -8242,6 +8265,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
@@ -8769,6 +8794,8 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type type)
 	case PTR_TO_SOCK_COMMON_OR_NULL:
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
+	case PTR_TO_MPTCP_SOCK:
+	case PTR_TO_MPTCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID_OR_NULL:
@@ -9889,6 +9916,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
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
index eb400aeea282..a103ccc2506d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6560,6 +6560,10 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 5bfa448b4704..4db41a1c344a 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -428,6 +428,7 @@ class PrinterHelpers(Printer):
             'struct tcp_request_sock',
             'struct udp6_sock',
             'struct task_struct',
+            'struct bpf_mptcp_sock',
 
             'struct __sk_buff',
             'struct sk_msg_md',
@@ -472,6 +473,7 @@ class PrinterHelpers(Printer):
             'struct tcp_request_sock',
             'struct udp6_sock',
             'struct task_struct',
+            'struct bpf_mptcp_sock',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a9fccfdb3a62..58b6e075537d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3395,6 +3395,14 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
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
@@ -3539,6 +3547,7 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(mptcp_sock),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -3868,6 +3877,10 @@ struct bpf_tcp_sock {
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

