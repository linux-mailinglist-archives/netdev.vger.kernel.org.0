Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578E2573536
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiGMLSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiGMLS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:18:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C013100CF0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657711106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FxD0L2l12FH/a0DfiV9dWaAAQqWE+U6eSaGfcg0Nk74=;
        b=HgNnjXR6k2aVlD+FEm3gkbnmkmR6w6VghQq6U6F5gj8T63ulrA6rS512oOaycDcdGFzOyt
        UoRecI7jHf+XmJPsksug6Ss8uFZqg4OV1ywmjFZsm7vIlHF8+KV5LZRvsjc+VZdENCmWbY
        nXoL9QOvF/1xihiY9Vqyv18PrHzcVBc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-s9spLwBCPkm9zU6HpFxhTw-1; Wed, 13 Jul 2022 07:18:25 -0400
X-MC-Unique: s9spLwBCPkm9zU6HpFxhTw-1
Received: by mail-ed1-f71.google.com with SMTP id z5-20020a05640235c500b0043ae18edeeeso4514739edc.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxD0L2l12FH/a0DfiV9dWaAAQqWE+U6eSaGfcg0Nk74=;
        b=VUVc3D67a8r3zp2Rws7c2tmSOpoLX0eHZ9H94kpgK8FDm0UdbGAyQ+dwaiDve+FjSU
         wfhPGs1+lV27d6Q3VwM1Ie87uZvobPa7ulRk7UFzzTcmCXbh5VTKRm+ABs1Mth2+drzj
         A5hF4L8ecvxHcNR+OW9ahetCNYzvCSn96a/ufdy/a6RL0/VDHkA1YGyNCN9JmPSPBUY+
         9W5iHLZRfqDf4yuvp3GMdVo6G571/lbjhnKU5SxPIOXDZMhqT14lJGqL2A2sv7Os4Jte
         LiXuzUXDMOrY/2LZ1Gda0yq3zUEGLWdJmRCIvJTa0fLNf18sFEdH7xkVCX858kLzkDIy
         Fa2A==
X-Gm-Message-State: AJIora+Ys97TTjOLyLqM6JJAsKoRjkcH9UO6pOnOAJx6vJENZ92VwpeN
        Fb+81COyKmtxd4xo/RCiQRA4etmB6FjUoAiNj52kecaZ+kmYvD6/I7oKRe0LWyAtwacsyGhWmlF
        VwFrjOj6ocXpY+84u
X-Received: by 2002:a17:906:8448:b0:72b:5659:9873 with SMTP id e8-20020a170906844800b0072b56599873mr2932620ejy.117.1657711103803;
        Wed, 13 Jul 2022 04:18:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s3NAhQCtaD2tuuQb7KOxl0OQCSd+4E01o5/hEQ2yTHvV//3Nd2VaTRKAyDHWZZSxHLCskNsw==
X-Received: by 2002:a17:906:8448:b0:72b:5659:9873 with SMTP id e8-20020a170906844800b0072b56599873mr2932584ejy.117.1657711103429;
        Wed, 13 Jul 2022 04:18:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ks6-20020a170906f84600b0072ae8fb13e6sm4808330ejb.126.2022.07.13.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 04:18:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BBC984D990F; Wed, 13 Jul 2022 13:14:37 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [RFC PATCH 10/17] bpf: Implement direct packet access in dequeue progs
Date:   Wed, 13 Jul 2022 13:14:18 +0200
Message-Id: <20220713111430.134810-11-toke@redhat.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
References: <20220713111430.134810-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Allow user to obtain packet pointers from dequeued xdp_md BTF pointer,
by allowing convert_ctx_access implementation for PTR_TO_BTF_ID, and
then tagging loads as packet pointers in verifier context.

Previously, convert_ctx_access was limited to just PTR_TO_CTX, but now
it will also be used to translate access into PTR_TO_BTF_ID of xdp_md
obtained from bpf_packet_dequeue, so it works like xdp_md ctx in XDP
programs. We must also remember that while xdp_buff backs ctx in XDP
programs, xdp_frame backs xdp_md in dequeue programs.

Next, we use pkt_uid support and transfer ref_obj_id on load data,
data_end, and data_meta fields, to make verifier aware of provenance of
these packet pointers, so that comparison can be rejected for unsafe
cases.

In the end, user can reuse their code meant for XDP ctx in deqeueue
programs as well, and don't have to do things differently.

Once packet pointers are obtained, regular verifier logic kicks in where
pointers from same xdp_frame can be compared to modify the range and
perform access into the packet.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h          |  26 +++++--
 include/linux/bpf_verifier.h |   6 ++
 kernel/bpf/verifier.c        |  48 +++++++++---
 net/core/filter.c            | 143 +++++++++++++++++++++++++++++++++++
 4 files changed, 206 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6ea5d6d188cf..a568ddc1f1ea 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -653,6 +653,12 @@ struct bpf_prog_ops {
 			union bpf_attr __user *uattr);
 };
 
+typedef u32 (*bpf_convert_ctx_access_t)(enum bpf_access_type type,
+					const struct bpf_insn *src,
+					struct bpf_insn *dst,
+					struct bpf_prog *prog,
+					u32 *target_size);
+
 struct bpf_verifier_ops {
 	/* return eBPF function prototype for verification */
 	const struct bpf_func_proto *
@@ -678,6 +684,9 @@ struct bpf_verifier_ops {
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id, enum bpf_type_flag *flag);
+	bpf_convert_ctx_access_t (*get_convert_ctx_access)(struct bpf_verifier_log *log,
+							   const struct btf *btf,
+							   u32 btf_id);
 };
 
 struct bpf_prog_offload_ops {
@@ -1360,11 +1369,6 @@ const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void);
 
 typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
 					unsigned long off, unsigned long len);
-typedef u32 (*bpf_convert_ctx_access_t)(enum bpf_access_type type,
-					const struct bpf_insn *src,
-					struct bpf_insn *dst,
-					struct bpf_prog *prog,
-					u32 *target_size);
 
 u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 		     void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy);
@@ -2180,6 +2184,18 @@ static inline bool unprivileged_ebpf_enabled(void)
 	return false;
 }
 
+static inline struct btf *bpf_get_btf_vmlinux(void)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline int btf_struct_access(struct bpf_verifier_log *log, const struct btf *btf,
+				    const struct btf_type *t, int off, int size,
+				    enum bpf_access_type atype __maybe_unused,
+				    u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_BPF_SYSCALL */
 
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 93b69dbf3d19..640f92fece12 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -532,8 +532,14 @@ __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
 				      const char *fmt, va_list args);
 __printf(2, 3) void bpf_verifier_log_write(struct bpf_verifier_env *env,
 					   const char *fmt, ...);
+#ifdef CONFIG_BPF_SYSCALL
 __printf(2, 3) void bpf_log(struct bpf_verifier_log *log,
 			    const char *fmt, ...);
+#else
+static inline void bpf_log(struct bpf_verifier_log *log, const char *fmt, ...)
+{
+}
+#endif
 
 static inline struct bpf_func_state *cur_func(struct bpf_verifier_env *env)
 {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f319e9392587..7edc2b834d9b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1707,7 +1707,7 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *regs, u32 regno,
 			    enum bpf_reg_type reg_type,
-			    struct btf *btf, u32 btf_id,
+			    struct btf *btf, u32 reg_id,
 			    enum bpf_type_flag flag)
 {
 	if (reg_type == SCALAR_VALUE) {
@@ -1715,9 +1715,14 @@ static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 		return;
 	}
 	mark_reg_known_zero(env, regs, regno);
-	regs[regno].type = PTR_TO_BTF_ID | flag;
+	regs[regno].type = (int)reg_type | flag;
+	if (type_is_pkt_pointer_any(reg_type)) {
+		regs[regno].pkt_uid = reg_id;
+		return;
+	}
+	WARN_ON_ONCE(base_type(reg_type) != PTR_TO_BTF_ID);
 	regs[regno].btf = btf;
-	regs[regno].btf_id = btf_id;
+	regs[regno].btf_id = reg_id;
 }
 
 #define DEF_NOT_SUBREG	(0)
@@ -4479,13 +4484,14 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 				   struct bpf_reg_state *regs,
 				   int regno, int off, int size,
 				   enum bpf_access_type atype,
-				   int value_regno)
+				   int value_regno, int insn_idx)
 {
 	struct bpf_reg_state *reg = regs + regno;
 	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
 	const char *tname = btf_name_by_offset(reg->btf, t->name_off);
+	struct bpf_insn_aux_data *aux = &env->insn_aux_data[insn_idx];
 	enum bpf_type_flag flag = 0;
-	u32 btf_id;
+	u32 reg_id;
 	int ret;
 
 	if (off < 0) {
@@ -4520,7 +4526,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 
 	if (env->ops->btf_struct_access) {
 		ret = env->ops->btf_struct_access(&env->log, reg->btf, t,
-						  off, size, atype, &btf_id, &flag);
+						  off, size, atype, &reg_id, &flag);
 	} else {
 		if (atype != BPF_READ) {
 			verbose(env, "only read is supported\n");
@@ -4528,7 +4534,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		}
 
 		ret = btf_struct_access(&env->log, reg->btf, t, off, size,
-					atype, &btf_id, &flag);
+					atype, &reg_id, &flag);
 	}
 
 	if (ret < 0)
@@ -4540,8 +4546,19 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (type_flag(reg->type) & PTR_UNTRUSTED)
 		flag |= PTR_UNTRUSTED;
 
-	if (atype == BPF_READ && value_regno >= 0)
-		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id, flag);
+	/* Remember the BTF ID for later use in convert_ctx_accesses */
+	aux->btf_var.btf_id = reg->btf_id;
+	aux->btf_var.btf = reg->btf;
+
+	if (atype == BPF_READ && value_regno >= 0) {
+		/* For pkt pointers, reg_id is set to pkt_uid, which must be the
+		 * ref_obj_id of the referenced register from which they are
+		 * obtained, denoting different packets e.g. in dequeue progs.
+		 */
+		if (type_is_pkt_pointer_any(ret))
+			reg_id = reg->ref_obj_id;
+		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, reg_id, flag);
+	}
 
 	return 0;
 }
@@ -4896,7 +4913,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 	} else if (base_type(reg->type) == PTR_TO_BTF_ID &&
 		   !type_may_be_null(reg->type)) {
 		err = check_ptr_to_btf_access(env, regs, regno, off, size, t,
-					      value_regno);
+					      value_regno, insn_idx);
 	} else if (reg->type == CONST_PTR_TO_MAP) {
 		err = check_ptr_to_map_access(env, regs, regno, off, size, t,
 					      value_regno);
@@ -13515,8 +13532,15 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		case PTR_TO_BTF_ID:
 		case PTR_TO_BTF_ID | PTR_UNTRUSTED:
 			if (type == BPF_READ) {
-				insn->code = BPF_LDX | BPF_PROBE_MEM |
-					BPF_SIZE((insn)->code);
+				if (env->ops->get_convert_ctx_access) {
+					struct btf *btf = env->insn_aux_data[i + delta].btf_var.btf;
+					u32 btf_id = env->insn_aux_data[i + delta].btf_var.btf_id;
+
+					convert_ctx_access = env->ops->get_convert_ctx_access(&env->log, btf, btf_id);
+					if (convert_ctx_access)
+						break;
+				}
+				insn->code = BPF_LDX | BPF_PROBE_MEM | BPF_SIZE((insn)->code);
 				env->prog->aux->num_exentries++;
 			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
 				verbose(env, "Writes through BTF pointers are not allowed\n");
diff --git a/net/core/filter.c b/net/core/filter.c
index 893b75515859..6a4881739e9b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -79,6 +79,7 @@
 #include <net/tls.h>
 #include <net/xdp.h>
 #include <net/mptcp.h>
+#include <linux/bpf_verifier.h>
 
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
@@ -9918,6 +9919,146 @@ static u32 dequeue_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+static int dequeue_btf_struct_access(struct bpf_verifier_log *log,
+				     const struct btf *btf,
+				     const struct btf_type *t, int off, int size,
+				     enum bpf_access_type atype,
+				     u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	const struct btf_type *pkt_type;
+	enum bpf_reg_type reg_type;
+	struct btf *btf_vmlinux;
+
+	btf_vmlinux = bpf_get_btf_vmlinux();
+	if (IS_ERR_OR_NULL(btf_vmlinux) || btf != btf_vmlinux)
+		return -EINVAL;
+
+	if (atype != BPF_READ)
+		return -EACCES;
+
+	pkt_type = btf_type_by_id(btf_vmlinux, xdp_md_btf_ids[0]);
+	if (!pkt_type)
+		return -EINVAL;
+	if (t != pkt_type)
+		return btf_struct_access(log, btf, t, off, size, atype,
+					 next_btf_id, flag);
+
+	switch (off) {
+	case offsetof(struct xdp_md, data):
+		reg_type = PTR_TO_PACKET;
+		break;
+	case offsetof(struct xdp_md, data_meta):
+		reg_type = PTR_TO_PACKET_META;
+		break;
+	case offsetof(struct xdp_md, data_end):
+		reg_type = PTR_TO_PACKET_END;
+		break;
+	default:
+		bpf_log(log, "no read support for xdp_md at off %d\n", off);
+		return -EACCES;
+	}
+
+	if (!__is_valid_xdp_access(off, size))
+		return -EINVAL;
+	return reg_type;
+}
+
+static u32
+dequeue_convert_xdp_md_access(enum bpf_access_type type,
+			      const struct bpf_insn *si, struct bpf_insn *insn_buf,
+			      struct bpf_prog *prog, u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+	int src_reg;
+
+	switch (si->off) {
+	case offsetof(struct xdp_md, data):
+		/* dst_reg = *(src_reg + off(xdp_frame, data)) */
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_frame, data),
+				      si->dst_reg, si->src_reg,
+				      offsetof(struct xdp_frame, data));
+		break;
+	case offsetof(struct xdp_md, data_meta):
+		if (si->dst_reg == si->src_reg) {
+			src_reg = BPF_REG_9;
+			if (si->dst_reg == src_reg)
+				src_reg--;
+			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, src_reg,
+					      offsetof(struct xdp_frame, next));
+			*insn++ = BPF_MOV64_REG(src_reg, si->src_reg);
+		} else {
+			src_reg = si->src_reg;
+		}
+		/* AX = src_reg
+		 * dst_reg = *(src_reg + off(xdp_frame, data))
+		 * src_reg = *(src_reg + off(xdp_frame, metasize))
+		 * dst_reg -= src_reg
+		 * src_reg = AX
+		 */
+		*insn++ = BPF_MOV64_REG(BPF_REG_AX, src_reg);
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_frame, data),
+				      si->dst_reg, src_reg,
+				      offsetof(struct xdp_frame, data));
+		*insn++ = BPF_LDX_MEM(BPF_B, /* metasize == 8 bits */
+				      src_reg, src_reg,
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+				      offsetofend(struct xdp_frame, headroom) + 3);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+				      offsetofend(struct xdp_frame, headroom));
+#endif
+		*insn++ = BPF_ALU64_REG(BPF_SUB, si->dst_reg, src_reg);
+		*insn++ = BPF_MOV64_REG(src_reg, BPF_REG_AX);
+		if (si->dst_reg == si->src_reg)
+			*insn++ = BPF_LDX_MEM(BPF_DW, src_reg, si->src_reg,
+					      offsetof(struct xdp_frame, next));
+		break;
+	case offsetof(struct xdp_md, data_end):
+		if (si->dst_reg == si->src_reg) {
+			src_reg = BPF_REG_9;
+			if (si->dst_reg == src_reg)
+				src_reg--;
+			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, src_reg,
+					      offsetof(struct xdp_frame, next));
+			*insn++ = BPF_MOV64_REG(src_reg, si->src_reg);
+		} else {
+			src_reg = si->src_reg;
+		}
+		/* AX = src_reg
+		 * dst_reg = *(src_reg + off(xdp_frame, data))
+		 * src_reg = *(src_reg + off(xdp_frame, len))
+		 * dst_reg += src_reg
+		 * src_reg = AX
+		 */
+		*insn++ = BPF_MOV64_REG(BPF_REG_AX, src_reg);
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_frame, data),
+				      si->dst_reg, src_reg,
+				      offsetof(struct xdp_frame, data));
+		*insn++ = BPF_LDX_MEM(BPF_H, src_reg, src_reg,
+				      offsetof(struct xdp_frame, len));
+		*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, src_reg);
+		*insn++ = BPF_MOV64_REG(src_reg, BPF_REG_AX);
+		if (si->dst_reg == si->src_reg)
+			*insn++ = BPF_LDX_MEM(BPF_DW, src_reg, si->src_reg,
+					      offsetof(struct xdp_frame, next));
+		break;
+	}
+	return insn - insn_buf;
+}
+
+static bpf_convert_ctx_access_t
+dequeue_get_convert_ctx_access(struct bpf_verifier_log *log,
+			       const struct btf *btf, u32 btf_id)
+{
+	struct btf *btf_vmlinux;
+
+	btf_vmlinux = bpf_get_btf_vmlinux();
+	if (IS_ERR_OR_NULL(btf_vmlinux) || btf != btf_vmlinux)
+		return NULL;
+	if (btf_id != xdp_md_btf_ids[0])
+		return NULL;
+	return dequeue_convert_xdp_md_access;
+}
+
 /* SOCK_ADDR_LOAD_NESTED_FIELD() loads Nested Field S.F.NF where S is type of
  * context Structure, F is Field in context structure that contains a pointer
  * to Nested Structure of type NS that has the field NF.
@@ -10775,6 +10916,8 @@ const struct bpf_verifier_ops dequeue_verifier_ops = {
 	.is_valid_access	= dequeue_is_valid_access,
 	.convert_ctx_access	= dequeue_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.btf_struct_access	= dequeue_btf_struct_access,
+	.get_convert_ctx_access = dequeue_get_convert_ctx_access,
 };
 
 const struct bpf_prog_ops dequeue_prog_ops = {
-- 
2.37.0

