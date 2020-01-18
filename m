Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E227D141501
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 01:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgARACG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 19:02:06 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37418 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730232AbgARACG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 19:02:06 -0500
Received: by mail-oi1-f194.google.com with SMTP id z64so23820453oia.4;
        Fri, 17 Jan 2020 16:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=64TW///3TRDRG1az2FaPqi7q4JLjIQS8lQu334/RHgA=;
        b=TAv5B45TSP0cSE7f8TLXp8zg53wovvuTOXwCn1BQQPyk3C+N3JJypaysy3ACKlev6G
         1SUBRrxfMS9ZLjQJoXnxGbGDXcfTZlxl3g501AXflUR0VL0pnPmeaoTWWeg2oklC0YVy
         uOu7LvXT+MlKdWCnhH10iTyCO/DQGCHslb3fCB89W4sKpZKAgxLdz4b/RFjf4fp9qJcm
         HHm7RbLjeBOn7d5cumGHYitHpDrwlwYiLe3w0n5bp0SPOEnhJCikU/N79c7MUfn0uGdr
         DqSHGiQ8tiuwoHnN9FxVCC440MibUWV5q0WDmH4wkmNOC+6k3iy3oL2CWyXj7HEhIAPx
         zDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=64TW///3TRDRG1az2FaPqi7q4JLjIQS8lQu334/RHgA=;
        b=Gq/7sYAnnwzaoAL5vy1g12HqWBsWcFTent7L6V8gs5gWJu+DcBAPXRSFkFoNZyCyVP
         svqTPpoI32rYvanW3bLsFFx1BPhvqEDf/4HVuE1c9nX9kPdj7HevdB18hZe3jQT3rClp
         UL1uRULCiKktOHye1GCN8HEF6R14DJGBT5UH4pYfvyaAkuPmoXF6aDrYlUn4alOCp3hA
         mRpWNx+Kaeok3XnfSiSh3rsBlpHLzrFqnq20CPz/lshYqYQDi9FD6ayM8/ZhP1TqT6U/
         A4/u7ZW+8gbNUb6pCE92GN6BXAm6Vx9pD7gtvF248bNLDuEq8mg0OSw1r6oSkzgfAmKe
         uI8Q==
X-Gm-Message-State: APjAAAVFHbA+554Wbmr0Z4rfQxOUmSIsneu79xt36E3XlS7nl/QdPZmG
        V6nR2O3vqWq8COYR9U35hgc=
X-Google-Smtp-Source: APXvYqy+7Z6gfnpT3mnTAV+sodDFCDiFZW/AFFICOD937anvPngOqwIbyzg/SUpnD3QWDvH/6lVr4w==
X-Received: by 2002:aca:4309:: with SMTP id q9mr5441418oia.158.1579305723983;
        Fri, 17 Jan 2020 16:02:03 -0800 (PST)
Received: from localhost.localdomain (ip24-56-44-135.ph.ph.cox.net. [24.56.44.135])
        by smtp.gmail.com with ESMTPSA id 17sm9423597oty.48.2020.01.17.16.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jan 2020 16:02:03 -0800 (PST)
From:   Matthew Cover <werekraken@gmail.com>
X-Google-Original-From: Matthew Cover <matthew.cover@stackpath.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jiong Wang <jiong.wang@netronome.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
Date:   Fri, 17 Jan 2020 17:01:28 -0700
Message-Id: <20200118000128.15746-1-matthew.cover@stackpath.com>
X-Mailer: git-send-email 2.15.2 (Apple Git-101.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow looking up an nf_conn. This allows eBPF programs to leverage
nf_conntrack state for similar purposes to socket state use cases,
as provided by the socket lookup helpers. This is particularly
useful when nf_conntrack state is locally available, but socket
state is not.

Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
---
 include/linux/bpf.h                                |  28 +++
 include/uapi/linux/bpf.h                           | 111 ++++++++-
 kernel/bpf/verifier.c                              | 105 +++++++-
 net/core/filter.c                                  | 277 +++++++++++++++++++++
 scripts/bpf_helpers_doc.py                         |   4 +
 tools/include/uapi/linux/bpf.h                     | 111 ++++++++-
 tools/testing/selftests/bpf/test_verifier.c        |  18 ++
 .../testing/selftests/bpf/verifier/ref_tracking.c  |  48 ++++
 8 files changed, 694 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e3b8f4..28d35c3 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -239,6 +239,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
 	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
+	ARG_PTR_TO_NF_CONN,	/* pointer to bpf_nf_conn */
 };
 
 /* type of values returned from helper functions */
@@ -250,6 +251,7 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCKET_OR_NULL,	/* returns a pointer to a socket or NULL */
 	RET_PTR_TO_TCP_SOCK_OR_NULL,	/* returns a pointer to a tcp_sock or NULL */
 	RET_PTR_TO_SOCK_COMMON_OR_NULL,	/* returns a pointer to a sock_common or NULL */
+	RET_PTR_TO_NF_CONN_OR_NULL,	/* returns a pointer to a nf_conn or NULL */
 };
 
 /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
@@ -316,6 +318,8 @@ enum bpf_reg_type {
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
 	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
+	PTR_TO_NF_CONN,		 /* reg points to struct nf_conn */
+	PTR_TO_NF_CONN_OR_NULL,	 /* reg points to struct nf_conn or NULL */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -1513,4 +1517,28 @@ enum bpf_text_poke_type {
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+bool bpf_nf_conn_is_valid_access(int off, int size, enum bpf_access_type type,
+				 struct bpf_insn_access_aux *info);
+
+u32 bpf_nf_conn_convert_ctx_access(enum bpf_access_type type,
+				   const struct bpf_insn *si,
+				   struct bpf_insn *insn_buf,
+				   struct bpf_prog *prog, u32 *target_size);
+#else
+bool bpf_nf_conn_is_valid_access(int off, int size, enum bpf_access_type type,
+				 struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+u32 bpf_nf_conn_convert_ctx_access(enum bpf_access_type type,
+				   const struct bpf_insn *si,
+				   struct bpf_insn *insn_buf,
+				   struct bpf_prog *prog, u32 *target_size)
+{
+	return 0;
+}
+#endif /* CONFIG_NF_CONNTRACK */
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 033d90a..12e16ad 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2885,6 +2885,88 @@ struct bpf_stack_build_id {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * struct bpf_nf_conn *bpf_ct_lookup_tcp(void *ctx, struct bpf_nf_conntrack_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
+ *	Description
+ *		Look for TCP nf_conntrack entry matching *tuple*, optionally in
+ *		a child network namespace *netns*. The return value must be
+ *		checked, and if non-**NULL**, released via
+ *		**bpf_ct_release**\ ().
+ *
+ *		The *ctx* should point to the context of the program, such as
+ *		the skb or xdp_md (depending on the hook in use). This is used
+ *		to determine the base network namespace for the lookup.
+ *
+ *		*tuple_size* must be one of:
+ *
+ *		**sizeof**\ (*tuple*\ **->ipv4**)
+ *			Look for an IPv4 nf_conn.
+ *		**sizeof**\ (*tuple*\ **->ipv6**)
+ *			Look for an IPv6 nf_conn.
+ *
+ *		If the *netns* is a negative signed 32-bit integer, then the
+ *		nf_conn lookup table in the netns associated with the *ctx* will
+ *		will be used. For the TC hooks, this is the netns of the device
+ *		in the skb. For XDP hooks, this is the netns of the device in
+ *		the xdp_md. If *netns* is any other signed 32-bit value greater
+ *		than or equal to zero then it specifies the ID of the netns
+ *		relative to the netns associated with the *ctx*. *netns* values
+ *		beyond the range of 32-bit integers are reserved for future
+ *		use.
+ *
+ *		All values for *flags* are reserved for future usage, and must
+ *		be left at zero.
+ *
+ *		This helper is available only if the kernel was compiled with
+ *		**CONFIG_NF_CONNTRACK=y** configuration option.
+ *	Return
+ *		Pointer to **struct bpf_nf_conn**, or **NULL** in case of
+ *		failure.
+ *
+ * struct bpf_nf_conn *bpf_ct_lookup_udp(void *ctx, struct bpf_nf_conntrack_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
+ *	Description
+ *		Look for UDP nf_conntrack entry matching *tuple*, optionally in
+ *		a child network namespace *netns*. The return value must be
+ *		checked, and if non-**NULL**, released via
+ *		**bpf_ct_release**\ ().
+ *
+ *		The *ctx* should point to the context of the program, such as
+ *		the skb or xdp_md (depending on the hook in use). This is used
+ *		to determine the base network namespace for the lookup.
+ *
+ *		*tuple_size* must be one of:
+ *
+ *		**sizeof**\ (*tuple*\ **->ipv4**)
+ *			Look for an IPv4 nf_conn.
+ *		**sizeof**\ (*tuple*\ **->ipv6**)
+ *			Look for an IPv6 nf_conn.
+ *
+ *		If the *netns* is a negative signed 32-bit integer, then the
+ *		nf_conn lookup table in the netns associated with the *ctx* will
+ *		will be used. For the TC hooks, this is the netns of the device
+ *		in the skb. For XDP hooks, this is the netns of the device in
+ *		the xdp_md. If *netns* is any other signed 32-bit value greater
+ *		than or equal to zero then it specifies the ID of the netns
+ *		relative to the netns associated with the *ctx*. *netns* values
+ *		beyond the range of 32-bit integers are reserved for future
+ *		use.
+ *
+ *		All values for *flags* are reserved for future usage, and must
+ *		be left at zero.
+ *
+ *		This helper is available only if the kernel was compiled with
+ *		**CONFIG_NF_CONNTRACK=y** configuration option.
+ *	Return
+ *		Pointer to **struct bpf_nf_conn**, or **NULL** in case of
+ *		failure.
+ *
+ * int bpf_ct_release(struct bpf_nf_conn *ct)
+ *	Description
+ *		Release the reference held by *ct*. *ct* must be a
+ *		non-**NULL** pointer that was returned from
+ *		**bpf_ct_lookup_xxx**\ ().
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3004,7 +3086,10 @@ struct bpf_stack_build_id {
 	FN(probe_read_user_str),	\
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
-	FN(send_signal_thread),
+	FN(send_signal_thread),		\
+	FN(ct_lookup_tcp),		\
+	FN(ct_lookup_udp),		\
+	FN(ct_release),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3278,6 +3363,30 @@ struct bpf_sock_tuple {
 	};
 };
 
+struct bpf_nf_conn {
+	__u32 cpu;
+	__u32 mark;
+	__u32 status;
+	__u32 timeout;
+};
+
+struct bpf_nf_conntrack_tuple {
+	union {
+		struct {
+			__be32 saddr;
+			__be32 daddr;
+			__be16 sport;
+			__be16 dport;
+		} ipv4;
+		struct {
+			__be32 saddr[4];
+			__be32 daddr[4];
+			__be16 sport;
+			__be16 dport;
+		} ipv6;
+	};
+};
+
 struct bpf_xdp_sock {
 	__u32 queue_id;
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ca17dccc..0ea0ee7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -362,6 +362,11 @@ static const char *ltrim(const char *s)
 	env->prev_linfo = linfo;
 }
 
+static bool type_is_nf_ct_pointer(enum bpf_reg_type type)
+{
+	return type == PTR_TO_NF_CONN;
+}
+
 static bool type_is_pkt_pointer(enum bpf_reg_type type)
 {
 	return type == PTR_TO_PACKET ||
@@ -381,7 +386,8 @@ static bool reg_type_may_be_null(enum bpf_reg_type type)
 	return type == PTR_TO_MAP_VALUE_OR_NULL ||
 	       type == PTR_TO_SOCKET_OR_NULL ||
 	       type == PTR_TO_SOCK_COMMON_OR_NULL ||
-	       type == PTR_TO_TCP_SOCK_OR_NULL;
+	       type == PTR_TO_TCP_SOCK_OR_NULL ||
+	       type == PTR_TO_NF_CONN_OR_NULL;
 }
 
 static bool reg_may_point_to_spin_lock(const struct bpf_reg_state *reg)
@@ -395,12 +401,15 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_SOCKET_OR_NULL ||
 		type == PTR_TO_TCP_SOCK ||
-		type == PTR_TO_TCP_SOCK_OR_NULL;
+		type == PTR_TO_TCP_SOCK_OR_NULL ||
+		type == PTR_TO_NF_CONN ||
+		type == PTR_TO_NF_CONN_OR_NULL;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
 {
-	return type == ARG_PTR_TO_SOCK_COMMON;
+	return type == ARG_PTR_TO_SOCK_COMMON ||
+		type == ARG_PTR_TO_NF_CONN;
 }
 
 /* Determine whether the function releases some resources allocated by another
@@ -409,14 +418,17 @@ static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
  */
 static bool is_release_function(enum bpf_func_id func_id)
 {
-	return func_id == BPF_FUNC_sk_release;
+	return func_id == BPF_FUNC_sk_release ||
+		func_id == BPF_FUNC_ct_release;
 }
 
 static bool is_acquire_function(enum bpf_func_id func_id)
 {
 	return func_id == BPF_FUNC_sk_lookup_tcp ||
 		func_id == BPF_FUNC_sk_lookup_udp ||
-		func_id == BPF_FUNC_skc_lookup_tcp;
+		func_id == BPF_FUNC_skc_lookup_tcp ||
+		func_id == BPF_FUNC_ct_lookup_tcp ||
+		func_id == BPF_FUNC_ct_lookup_udp;
 }
 
 static bool is_ptr_cast_function(enum bpf_func_id func_id)
@@ -447,6 +459,8 @@ static bool is_ptr_cast_function(enum bpf_func_id func_id)
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 	[PTR_TO_BTF_ID]		= "ptr_",
+	[PTR_TO_NF_CONN]	= "nf_conn",
+	[PTR_TO_NF_CONN_OR_NULL] = "nf_conn_or_null",
 };
 
 static char slot_type_char[] = {
@@ -1913,6 +1927,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		return true;
 	default:
 		return false;
@@ -2440,6 +2456,35 @@ static int check_flow_keys_access(struct bpf_verifier_env *env, int off,
 	return 0;
 }
 
+static int check_nf_ct_access(struct bpf_verifier_env *env, int insn_idx,
+			     u32 regno, int off, int size,
+			     enum bpf_access_type t)
+{
+	struct bpf_reg_state *regs = cur_regs(env);
+	struct bpf_reg_state *reg = &regs[regno];
+	struct bpf_insn_access_aux info = {};
+	bool valid;
+
+	switch (reg->type) {
+	case PTR_TO_NF_CONN:
+		valid = bpf_nf_conn_is_valid_access(off, size, t, &info);
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
 static int check_sock_access(struct bpf_verifier_env *env, int insn_idx,
 			     u32 regno, int off, int size,
 			     enum bpf_access_type t)
@@ -2511,6 +2556,13 @@ static bool is_ctx_reg(struct bpf_verifier_env *env, int regno)
 	return reg->type == PTR_TO_CTX;
 }
 
+static bool is_nf_ct_reg(struct bpf_verifier_env *env, int regno)
+{
+	const struct bpf_reg_state *reg = reg_state(env, regno);
+
+	return type_is_nf_ct_pointer(reg->type);
+}
+
 static bool is_sk_reg(struct bpf_verifier_env *env, int regno)
 {
 	const struct bpf_reg_state *reg = reg_state(env, regno);
@@ -2635,6 +2687,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_XDP_SOCK:
 		pointer_desc = "xdp_sock ";
 		break;
+	case PTR_TO_NF_CONN:
+		pointer_desc = "nf_conn ";
+		break;
 	default:
 		break;
 	}
@@ -3050,6 +3105,15 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		err = check_sock_access(env, insn_idx, regno, off, size, t);
 		if (!err && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
+	} else if (type_is_nf_ct_pointer(reg->type)) {
+		if (t == BPF_WRITE) {
+			verbose(env, "R%d cannot write into %s\n",
+				regno, reg_type_str[reg->type]);
+			return -EACCES;
+		}
+		err = check_nf_ct_access(env, insn_idx, regno, off, size, t);
+		if (!err && value_regno >= 0)
+			mark_reg_unknown(env, regs, value_regno);
 	} else if (reg->type == PTR_TO_TP_BUFFER) {
 		err = check_tp_buffer_access(env, reg, regno, off, size);
 		if (!err && t == BPF_READ && value_regno >= 0)
@@ -3099,7 +3163,8 @@ static int check_xadd(struct bpf_verifier_env *env, int insn_idx, struct bpf_ins
 	if (is_ctx_reg(env, insn->dst_reg) ||
 	    is_pkt_reg(env, insn->dst_reg) ||
 	    is_flow_key_reg(env, insn->dst_reg) ||
-	    is_sk_reg(env, insn->dst_reg)) {
+	    is_sk_reg(env, insn->dst_reg) ||
+	    is_nf_ct_reg(env, insn->dst_reg)) {
 		verbose(env, "BPF_XADD stores into R%d %s is not allowed\n",
 			insn->dst_reg,
 			reg_type_str[reg_state(env, insn->dst_reg)->type]);
@@ -3501,6 +3566,19 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 				regno);
 			return -EACCES;
 		}
+	} else if (arg_type == ARG_PTR_TO_NF_CONN) {
+		expected_type = PTR_TO_NF_CONN;
+		if (!type_is_nf_ct_pointer(type))
+			goto err_type;
+		if (reg->ref_obj_id) {
+			if (meta->ref_obj_id) {
+				verbose(env, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
+					regno, reg->ref_obj_id,
+					meta->ref_obj_id);
+				return -EFAULT;
+			}
+			meta->ref_obj_id = reg->ref_obj_id;
+		}
 	} else if (arg_type == ARG_PTR_TO_SPIN_LOCK) {
 		if (meta->func_id == BPF_FUNC_spin_lock) {
 			if (process_spin_lock(env, regno, true))
@@ -4368,6 +4446,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].type = PTR_TO_TCP_SOCK_OR_NULL;
 		regs[BPF_REG_0].id = ++env->id_gen;
+	} else if (fn->ret_type == RET_PTR_TO_NF_CONN_OR_NULL) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type = PTR_TO_NF_CONN_OR_NULL;
+		regs[BPF_REG_0].id = ++env->id_gen;
 	} else {
 		verbose(env, "unknown return type %d of func %s#%d\n",
 			fn->ret_type, func_id_name(func_id), func_id);
@@ -4649,6 +4731,8 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
@@ -5915,6 +5999,8 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 			reg->type = PTR_TO_SOCK_COMMON;
 		} else if (reg->type == PTR_TO_TCP_SOCK_OR_NULL) {
 			reg->type = PTR_TO_TCP_SOCK;
+		} else if (reg->type == PTR_TO_NF_CONN_OR_NULL) {
+			reg->type = PTR_TO_NF_CONN;
 		}
 		if (is_null) {
 			/* We don't need id and ref_obj_id from this point
@@ -7232,6 +7318,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		/* Only valid matches are exact, which memcmp() above
 		 * would have accepted
 		 */
@@ -7760,6 +7848,8 @@ static bool reg_type_mismatch_ok(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
 	case PTR_TO_BTF_ID:
+	case PTR_TO_NF_CONN:
+	case PTR_TO_NF_CONN_OR_NULL:
 		return false;
 	default:
 		return true;
@@ -8867,6 +8957,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				return -EINVAL;
 			}
 			continue;
+		case PTR_TO_NF_CONN:
+			convert_ctx_access = bpf_nf_conn_convert_ctx_access;
+			break;
 		default:
 			continue;
 		}
diff --git a/net/core/filter.c b/net/core/filter.c
index 17de674..39ba965 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -74,6 +74,12 @@
 #include <net/ipv6_stubs.h>
 #include <net/bpf_sk_storage.h>
 
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
 /**
  *	sk_filter_trim_cap - run a packet through a socket filter
  *	@sk: sock associated with &sk_buff
@@ -5122,6 +5128,253 @@ static void bpf_update_srh_state(struct sk_buff *skb)
 };
 #endif /* CONFIG_IPV6_SEG6_BPF */
 
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+bool bpf_nf_conn_is_valid_access(int off, int size, enum bpf_access_type type,
+				 struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= offsetofend(struct bpf_nf_conn,
+					  timeout))
+		return false;
+
+	if (off % size != 0)
+		return false;
+
+	return size == sizeof(__u32);
+}
+
+u32 bpf_nf_conn_convert_ctx_access(enum bpf_access_type type,
+				   const struct bpf_insn *si,
+				   struct bpf_insn *insn_buf,
+				   struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct bpf_nf_conn, cpu):
+		BUILD_BUG_ON(FIELD_SIZEOF(struct nf_conn, cpu) != 2);
+
+		*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->src_reg,
+				      offsetof(struct nf_conn, cpu));
+
+		break;
+
+	case offsetof(struct bpf_nf_conn, mark):
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
+		BUILD_BUG_ON(FIELD_SIZEOF(struct nf_conn, mark) != 4);
+
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      offsetof(struct nf_conn, mark));
+#else
+		*target_size = 4;
+		*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);
+#endif
+		break;
+
+	case offsetof(struct bpf_nf_conn, status):
+		BUILD_BUG_ON(FIELD_SIZEOF(struct nf_conn, status) < 4 ||
+			     __IPS_MAX_BIT > 32);
+
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      offsetof(struct nf_conn, status));
+
+		break;
+
+	case offsetof(struct bpf_nf_conn, timeout):
+		BUILD_BUG_ON(FIELD_SIZEOF(struct nf_conn, timeout) != 4);
+
+		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->src_reg,
+				      offsetof(struct nf_conn, timeout));
+
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+static struct nf_conn *
+ct_lookup(struct net *net, struct bpf_nf_conntrack_tuple *tuple,
+	  u8 family, u8 proto)
+{
+	struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple tup;
+	struct nf_conn *ct = NULL;
+
+	memset(&tup, 0, sizeof(tup));
+
+	tup.dst.protonum = proto;
+	tup.src.l3num = family;
+
+	if (family == AF_INET) {
+		tup.src.u3.ip = tuple->ipv4.saddr;
+		tup.dst.u3.ip = tuple->ipv4.daddr;
+		tup.src.u.tcp.port = tuple->ipv4.sport;
+		tup.dst.u.tcp.port = tuple->ipv4.dport;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		memcpy(tup.src.u3.ip6, tuple->ipv6.saddr, sizeof(tup.src.u3.ip6));
+		memcpy(tup.dst.u3.ip6, tuple->ipv6.daddr, sizeof(tup.dst.u3.ip6));
+		tup.src.u.tcp.port = tuple->ipv6.sport;
+		tup.dst.u.tcp.port = tuple->ipv6.dport;
+#endif
+	}
+
+	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tup);
+	if (!hash)
+		goto out;
+	ct = nf_ct_tuplehash_to_ctrack(hash);
+
+out:
+	return ct;
+}
+
+static struct nf_conn *
+__bpf_ct_lookup(struct sk_buff *skb, struct bpf_nf_conntrack_tuple *tuple, u32 len,
+		struct net *caller_net, u8 proto, u64 netns_id, u64 flags)
+{
+	struct nf_conn *ct = NULL;
+	u8 family = AF_UNSPEC;
+	struct net *net;
+
+	if (len == sizeof(tuple->ipv4))
+		family = AF_INET;
+	else if (len == sizeof(tuple->ipv6))
+		family = AF_INET6;
+	else
+		goto out;
+
+	if (unlikely(family == AF_UNSPEC || flags ||
+		     !((s32)netns_id < 0 || netns_id <= S32_MAX)))
+		goto out;
+
+	if ((s32)netns_id < 0) {
+		net = caller_net;
+		ct = ct_lookup(net, tuple, family, proto);
+	} else {
+		net = get_net_ns_by_id(caller_net, netns_id);
+		if (unlikely(!net))
+			goto out;
+		ct = ct_lookup(net, tuple, family, proto);
+		put_net(net);
+	}
+
+out:
+	return ct;
+}
+
+static struct nf_conn *
+bpf_ct_lookup(struct sk_buff *skb, struct bpf_nf_conntrack_tuple *tuple, u32 len,
+	      u8 proto, u64 netns_id, u64 flags)
+{
+	struct net *caller_net;
+
+	if (skb->dev) {
+		caller_net = dev_net(skb->dev);
+	} else {
+		caller_net = sock_net(skb->sk);
+	}
+
+	return __bpf_ct_lookup(skb, tuple, len, caller_net, proto,
+			       netns_id, flags);
+}
+
+BPF_CALL_5(bpf_ct_lookup_tcp, struct sk_buff *, skb,
+	   struct bpf_nf_conntrack_tuple *, tuple, u32, len, u64, netns_id,
+	   u64, flags)
+{
+	return (unsigned long)bpf_ct_lookup(skb, tuple, len, IPPROTO_TCP,
+					     netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_ct_lookup_tcp_proto = {
+	.func		= bpf_ct_lookup_tcp,
+	.gpl_only	= true,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_NF_CONN_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_5(bpf_xdp_ct_lookup_tcp, struct xdp_buff *, ctx,
+	   struct bpf_nf_conntrack_tuple *, tuple, u32, len, u32, netns_id,
+	   u64, flags)
+{
+	struct net *caller_net = dev_net(ctx->rxq->dev);
+
+	return (unsigned long)__bpf_ct_lookup(NULL, tuple, len, caller_net,
+					      IPPROTO_TCP, netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_xdp_ct_lookup_tcp_proto = {
+	.func		= bpf_xdp_ct_lookup_tcp,
+	.gpl_only	= true,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_NF_CONN_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_5(bpf_ct_lookup_udp, struct sk_buff *, skb,
+	   struct bpf_nf_conntrack_tuple *, tuple, u32, len, u64, netns_id,
+	   u64, flags)
+{
+	return (unsigned long)bpf_ct_lookup(skb, tuple, len, IPPROTO_UDP,
+					     netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_ct_lookup_udp_proto = {
+	.func		= bpf_ct_lookup_udp,
+	.gpl_only	= true,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_NF_CONN_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_5(bpf_xdp_ct_lookup_udp, struct xdp_buff *, ctx,
+	   struct bpf_nf_conntrack_tuple *, tuple, u32, len, u32, netns_id,
+	   u64, flags)
+{
+	struct net *caller_net = dev_net(ctx->rxq->dev);
+
+	return (unsigned long)__bpf_ct_lookup(NULL, tuple, len, caller_net,
+					      IPPROTO_UDP, netns_id, flags);
+}
+
+static const struct bpf_func_proto bpf_xdp_ct_lookup_udp_proto = {
+	.func		= bpf_xdp_ct_lookup_udp,
+	.gpl_only	= true,
+	.pkt_access	= true,
+	.ret_type	= RET_PTR_TO_NF_CONN_OR_NULL,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_ANYTHING,
+	.arg5_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_1(bpf_ct_release, struct nf_conn *, ct)
+{
+	nf_conntrack_put(&ct->ct_general);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_ct_release_proto = {
+	.func		= bpf_ct_release,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_NF_CONN,
+};
+#endif
+
 #ifdef CONFIG_INET
 static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 			      int dif, int sdif, u8 family, u8 proto)
@@ -6139,6 +6392,14 @@ bool bpf_helper_changes_pkt_data(void *func)
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
 #endif
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+	case BPF_FUNC_ct_lookup_tcp:
+		return &bpf_ct_lookup_tcp_proto;
+	case BPF_FUNC_ct_lookup_udp:
+		return &bpf_ct_lookup_udp_proto;
+	case BPF_FUNC_ct_release:
+		return &bpf_ct_release_proto;
+#endif
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6180,6 +6441,14 @@ bool bpf_helper_changes_pkt_data(void *func)
 	case BPF_FUNC_tcp_gen_syncookie:
 		return &bpf_tcp_gen_syncookie_proto;
 #endif
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+	case BPF_FUNC_ct_lookup_tcp:
+		return &bpf_xdp_ct_lookup_tcp_proto;
+	case BPF_FUNC_ct_lookup_udp:
+		return &bpf_xdp_ct_lookup_udp_proto;
+	case BPF_FUNC_ct_release:
+		return &bpf_ct_release_proto;
+#endif
 	default:
 		return bpf_base_func_proto(func_id);
 	}
@@ -6284,6 +6553,14 @@ bool bpf_helper_changes_pkt_data(void *func)
 	case BPF_FUNC_skc_lookup_tcp:
 		return &bpf_skc_lookup_tcp_proto;
 #endif
+#if IS_BUILTIN(CONFIG_NF_CONNTRACK)
+	case BPF_FUNC_ct_lookup_tcp:
+		return &bpf_ct_lookup_tcp_proto;
+	case BPF_FUNC_ct_lookup_udp:
+		return &bpf_ct_lookup_udp_proto;
+	case BPF_FUNC_ct_release:
+		return &bpf_ct_release_proto;
+#endif
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 90baf7d..26f0c2a 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -398,6 +398,8 @@ class PrinterHelpers(Printer):
 
     type_fwds = [
             'struct bpf_fib_lookup',
+            'struct bpf_nf_conn',
+            'struct bpf_nf_conntrack_tuple',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_sock',
@@ -433,6 +435,8 @@ class PrinterHelpers(Printer):
             '__wsum',
 
             'struct bpf_fib_lookup',
+            'struct bpf_nf_conn',
+            'struct bpf_nf_conntrack_tuple',
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_sock',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 033d90a..12e16ad 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2885,6 +2885,88 @@ struct bpf_stack_build_id {
  *		**-EPERM** if no permission to send the *sig*.
  *
  *		**-EAGAIN** if bpf program can try again.
+ *
+ * struct bpf_nf_conn *bpf_ct_lookup_tcp(void *ctx, struct bpf_nf_conntrack_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
+ *	Description
+ *		Look for TCP nf_conntrack entry matching *tuple*, optionally in
+ *		a child network namespace *netns*. The return value must be
+ *		checked, and if non-**NULL**, released via
+ *		**bpf_ct_release**\ ().
+ *
+ *		The *ctx* should point to the context of the program, such as
+ *		the skb or xdp_md (depending on the hook in use). This is used
+ *		to determine the base network namespace for the lookup.
+ *
+ *		*tuple_size* must be one of:
+ *
+ *		**sizeof**\ (*tuple*\ **->ipv4**)
+ *			Look for an IPv4 nf_conn.
+ *		**sizeof**\ (*tuple*\ **->ipv6**)
+ *			Look for an IPv6 nf_conn.
+ *
+ *		If the *netns* is a negative signed 32-bit integer, then the
+ *		nf_conn lookup table in the netns associated with the *ctx* will
+ *		will be used. For the TC hooks, this is the netns of the device
+ *		in the skb. For XDP hooks, this is the netns of the device in
+ *		the xdp_md. If *netns* is any other signed 32-bit value greater
+ *		than or equal to zero then it specifies the ID of the netns
+ *		relative to the netns associated with the *ctx*. *netns* values
+ *		beyond the range of 32-bit integers are reserved for future
+ *		use.
+ *
+ *		All values for *flags* are reserved for future usage, and must
+ *		be left at zero.
+ *
+ *		This helper is available only if the kernel was compiled with
+ *		**CONFIG_NF_CONNTRACK=y** configuration option.
+ *	Return
+ *		Pointer to **struct bpf_nf_conn**, or **NULL** in case of
+ *		failure.
+ *
+ * struct bpf_nf_conn *bpf_ct_lookup_udp(void *ctx, struct bpf_nf_conntrack_tuple *tuple, u32 tuple_size, u64 netns, u64 flags)
+ *	Description
+ *		Look for UDP nf_conntrack entry matching *tuple*, optionally in
+ *		a child network namespace *netns*. The return value must be
+ *		checked, and if non-**NULL**, released via
+ *		**bpf_ct_release**\ ().
+ *
+ *		The *ctx* should point to the context of the program, such as
+ *		the skb or xdp_md (depending on the hook in use). This is used
+ *		to determine the base network namespace for the lookup.
+ *
+ *		*tuple_size* must be one of:
+ *
+ *		**sizeof**\ (*tuple*\ **->ipv4**)
+ *			Look for an IPv4 nf_conn.
+ *		**sizeof**\ (*tuple*\ **->ipv6**)
+ *			Look for an IPv6 nf_conn.
+ *
+ *		If the *netns* is a negative signed 32-bit integer, then the
+ *		nf_conn lookup table in the netns associated with the *ctx* will
+ *		will be used. For the TC hooks, this is the netns of the device
+ *		in the skb. For XDP hooks, this is the netns of the device in
+ *		the xdp_md. If *netns* is any other signed 32-bit value greater
+ *		than or equal to zero then it specifies the ID of the netns
+ *		relative to the netns associated with the *ctx*. *netns* values
+ *		beyond the range of 32-bit integers are reserved for future
+ *		use.
+ *
+ *		All values for *flags* are reserved for future usage, and must
+ *		be left at zero.
+ *
+ *		This helper is available only if the kernel was compiled with
+ *		**CONFIG_NF_CONNTRACK=y** configuration option.
+ *	Return
+ *		Pointer to **struct bpf_nf_conn**, or **NULL** in case of
+ *		failure.
+ *
+ * int bpf_ct_release(struct bpf_nf_conn *ct)
+ *	Description
+ *		Release the reference held by *ct*. *ct* must be a
+ *		non-**NULL** pointer that was returned from
+ *		**bpf_ct_lookup_xxx**\ ().
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3004,7 +3086,10 @@ struct bpf_stack_build_id {
 	FN(probe_read_user_str),	\
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
-	FN(send_signal_thread),
+	FN(send_signal_thread),		\
+	FN(ct_lookup_tcp),		\
+	FN(ct_lookup_udp),		\
+	FN(ct_release),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3278,6 +3363,30 @@ struct bpf_sock_tuple {
 	};
 };
 
+struct bpf_nf_conn {
+	__u32 cpu;
+	__u32 mark;
+	__u32 status;
+	__u32 timeout;
+};
+
+struct bpf_nf_conntrack_tuple {
+	union {
+		struct {
+			__be32 saddr;
+			__be32 daddr;
+			__be16 sport;
+			__be16 dport;
+		} ipv4;
+		struct {
+			__be32 saddr[4];
+			__be32 daddr[4];
+			__be16 sport;
+			__be16 dport;
+		} ipv6;
+	};
+};
+
 struct bpf_xdp_sock {
 	__u32 queue_id;
 };
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 87eaa49..7569db2 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -294,6 +294,24 @@ static void bpf_fill_scale(struct bpf_test *self)
 	}
 }
 
+/* BPF_CT_LOOKUP contains 13 instructions, if you need to fix up maps */
+#define BPF_CT_LOOKUP(func)						\
+	/* struct bpf_nf_conntrack_tuple tuple = {} */			\
+	BPF_MOV64_IMM(BPF_REG_2, 0),					\
+	BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -8),			\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -16),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -24),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -32),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -40),		\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -48),		\
+	/* ct = func(ctx, &tuple, sizeof tuple, 0, 0) */		\
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),				\
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -48),				\
+	BPF_MOV64_IMM(BPF_REG_3, sizeof(struct bpf_nf_conntrack_tuple)),\
+	BPF_MOV64_IMM(BPF_REG_4, 0),					\
+	BPF_MOV64_IMM(BPF_REG_5, 0),					\
+	BPF_EMIT_CALL(BPF_FUNC_ ## func)
+
 /* BPF_SK_LOOKUP contains 13 instructions, if you need to fix up maps */
 #define BPF_SK_LOOKUP(func)						\
 	/* struct bpf_sock_tuple tuple = {} */				\
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 604b461..de5c550a 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -21,6 +21,17 @@
 	.result = REJECT,
 },
 {
+	"reference tracking: leak potential reference to nf_conn",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0), /* leak reference */
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "Unreleased reference",
+	.result = REJECT,
+},
+{
 	"reference tracking: leak potential reference on stack",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
@@ -72,6 +83,17 @@
 	.result = REJECT,
 },
 {
+	"reference tracking: zero potential reference to nf_conn",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	BPF_MOV64_IMM(BPF_REG_0, 0), /* leak reference */
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "Unreleased reference",
+	.result = REJECT,
+},
+{
 	"reference tracking: copy and zero potential references",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
@@ -113,6 +135,20 @@
 	.result = REJECT,
 },
 {
+	"reference tracking: release reference to nf_conn without check",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	/* reference in r0 may be NULL */
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_MOV64_IMM(BPF_REG_2, 0),
+	BPF_EMIT_CALL(BPF_FUNC_ct_release),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "type=nf_conn_or_null expected=nf_conn",
+	.result = REJECT,
+},
+{
 	"reference tracking: release reference",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
@@ -137,6 +173,18 @@
 	.result = ACCEPT,
 },
 {
+	"reference tracking: release reference to nf_conn",
+	.insns = {
+	BPF_CT_LOOKUP(ct_lookup_tcp),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
+	BPF_EMIT_CALL(BPF_FUNC_ct_release),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+},
+{
 	"reference tracking: release reference 2",
 	.insns = {
 	BPF_SK_LOOKUP(sk_lookup_tcp),
-- 
1.8.3.1

