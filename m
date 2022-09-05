Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF45AD9B0
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiIETeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbiIETeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:34:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3167C48C85
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662406448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGOlsWwSa8ZGUxPA20rFqLx1jsDgyftEVjIopoX70IA=;
        b=DJLEyNLv6r8lHZ3iOE81PqqfFeRRotduf7lwETEuEVcQDKeGiVyAjVwk4vGgAUPTdDzb1J
        CoBgtvsckzAvGyLBEqUGHbC865OTbc3t5jsRrZJTG7g0vFc0vHdD7bfP8DrnawuDhPsHMk
        12/hFn/+Pse6qBbm55oS3APqroOJPyU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-205-nk4hqmu3MiCsFGOQ_hT6Vw-1; Mon, 05 Sep 2022 15:34:07 -0400
X-MC-Unique: nk4hqmu3MiCsFGOQ_hT6Vw-1
Received: by mail-ed1-f69.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so6189290eda.19
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 12:34:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fGOlsWwSa8ZGUxPA20rFqLx1jsDgyftEVjIopoX70IA=;
        b=2jvmJeExZNIn1nDXyUcfaeKBySmCDlBd12e7LZOmDO5NP8d9YgGPGp2DGkpfnLVkoH
         3qy/HbVBYBCdaFPclYTjsm7imNPLOjWQCF/HrqVnru1IYvoc+QggvCHyyFknz/Uxstdi
         uBo1w8uQcbNd3NOqUY/6vAwb2ZInshyhyQKH1Dz33OWbZGtiXQxWAlMkOqIS/0f7+R1X
         02SIjQyFvytg8en1v3+h/XzMUvWgzwoDDIHuekQgllDlTHqjDcoWscf5ZVtj8a0n3sbU
         OFatPA0Qh8CNFfjDtzSh54XBBf0AtiDnDxHbf2cWQVEjJC5bL/CmTH2S6HzMG6SVT9HN
         7APQ==
X-Gm-Message-State: ACgBeo0cuv8lDyNCcPLX72cTPa1m8LeSOh4kgyawnSEW01BI5Nqp8IRF
        NKaUEuIqEeJv0z1ZXDqazqO8nu3NOTpqIHtdTFjZ2V03QQl1AZ67OEeaHwfJeLFVinH9KNLYNqZ
        qmcPk1SfvjZCxsvjg
X-Received: by 2002:a17:907:b013:b0:73d:c708:3f22 with SMTP id fu19-20020a170907b01300b0073dc7083f22mr35691646ejc.608.1662406445869;
        Mon, 05 Sep 2022 12:34:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4kjYck+srPVqFYsjNNDOiM6zLxfeRKTo3aLp0Bmn89Bz/3zrtCeqasGL3QMzEPQwisD3cazg==
X-Received: by 2002:a17:907:b013:b0:73d:c708:3f22 with SMTP id fu19-20020a170907b01300b0073dc7083f22mr35691630ejc.608.1662406445545;
        Mon, 05 Sep 2022 12:34:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y2-20020aa7ce82000000b004483a543794sm6889460edv.96.2022.09.05.12.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 12:34:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F2CDC589586; Mon,  5 Sep 2022 21:34:01 +0200 (CEST)
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
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 3/3] bpf: Use 64-bit return value for bpf_prog_run
Date:   Mon,  5 Sep 2022 21:33:59 +0200
Message-Id: <20220905193359.969347-4-toke@redhat.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220905193359.969347-1-toke@redhat.com>
References: <20220905193359.969347-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

BPF ABI always uses 64-bit return value, but so far __bpf_prog_run and
higher level wrappers always truncated the return value to 32-bit. We want
to be able to introduce a new BPF program type that returns a PTR_TO_BTF_ID
or NULL from the BPF program to the caller context in the kernel. To be
able to use this returned pointer value, the bpf_prog_run invocation needs
to be able to return a 64-bit value, so update the definitions to allow
this.

To avoid code churn in the whole kernel, we let the compiler handle
truncation normally, and allow new call sites to utilize the 64-bit
return value, by receiving the return value as a u64.

Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf-cgroup.h | 12 ++++++------
 include/linux/bpf.h        | 14 +++++++-------
 include/linux/filter.h     | 34 +++++++++++++++++-----------------
 kernel/bpf/cgroup.c        | 12 ++++++------
 kernel/bpf/core.c          | 14 +++++++-------
 kernel/bpf/offload.c       |  4 ++--
 net/bpf/test_run.c         | 21 ++++++++++++---------
 net/packet/af_packet.c     |  7 +++++--
 8 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 57e9e109257e..85ae187e5d41 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -23,12 +23,12 @@ struct ctl_table;
 struct ctl_table_header;
 struct task_struct;
 
-unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
-				       const struct bpf_insn *insn);
-unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
-					 const struct bpf_insn *insn);
-unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
-					  const struct bpf_insn *insn);
+u64 __cgroup_bpf_run_lsm_sock(const void *ctx,
+			      const struct bpf_insn *insn);
+u64 __cgroup_bpf_run_lsm_socket(const void *ctx,
+				const struct bpf_insn *insn);
+u64 __cgroup_bpf_run_lsm_current(const void *ctx,
+				 const struct bpf_insn *insn);
 
 #ifdef CONFIG_CGROUP_BPF
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 222cba23e6d9..f32f33f5c827 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -58,8 +58,8 @@ typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
-typedef unsigned int (*bpf_func_t)(const void *,
-				   const struct bpf_insn *);
+typedef u64 (*bpf_func_t)(const void *,
+			  const struct bpf_insn *);
 struct bpf_iter_seq_info {
 	const struct seq_operations *seq_ops;
 	bpf_iter_init_seq_priv_t init_seq_private;
@@ -896,7 +896,7 @@ struct bpf_dispatcher {
 	struct bpf_ksym ksym;
 };
 
-static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
+static __always_inline __nocfi u64 bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
 	bpf_func_t bpf_func)
@@ -925,7 +925,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 }
 
 #define DEFINE_BPF_DISPATCHER(name)					\
-	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
+	noinline __nocfi u64 bpf_dispatcher_##name##_func(		\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func)					\
@@ -936,7 +936,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 	struct bpf_dispatcher bpf_dispatcher_##name =			\
 		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
 #define DECLARE_BPF_DISPATCHER(name)					\
-	unsigned int bpf_dispatcher_##name##_func(			\
+	u64 bpf_dispatcher_##name##_func(				\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func);					\
@@ -1140,7 +1140,7 @@ struct bpf_prog {
 	u8			tag[BPF_TAG_SIZE];
 	struct bpf_prog_stats __percpu *stats;
 	int __percpu		*active;
-	unsigned int		(*bpf_func)(const void *ctx,
+	u64			(*bpf_func)(const void *ctx,
 					    const struct bpf_insn *insn);
 	struct bpf_prog_aux	*aux;		/* Auxiliary fields */
 	struct sock_fprog_kern	*orig_prog;	/* Original BPF program */
@@ -1489,7 +1489,7 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
 /* BPF program asks to set CN on the packet. */
 #define BPF_RET_SET_CN						(1 << 0)
 
-typedef u32 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
+typedef u64 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
 
 static __always_inline u32
 bpf_prog_run_array(const struct bpf_prog_array *array,
diff --git a/include/linux/filter.h b/include/linux/filter.h
index eff295509f03..d6c2deffdcc3 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -567,16 +567,16 @@ struct sk_filter {
 
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
-typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
-					  const struct bpf_insn *insnsi,
-					  unsigned int (*bpf_func)(const void *,
-								   const struct bpf_insn *));
+typedef u64 (*bpf_dispatcher_fn)(const void *ctx,
+				 const struct bpf_insn *insnsi,
+				 u64 (*bpf_func)(const void *,
+						 const struct bpf_insn *));
 
-static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
+static __always_inline u64 __bpf_prog_run(const struct bpf_prog *prog,
 					  const void *ctx,
 					  bpf_dispatcher_fn dfunc)
 {
-	u32 ret;
+	u64 ret;
 
 	cant_migrate();
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {
@@ -596,7 +596,7 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 	return ret;
 }
 
-static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
+static __always_inline u64 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
 {
 	return __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
 }
@@ -609,10 +609,10 @@ static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void
  * invocation of a BPF program does not require reentrancy protection
  * against a BPF program which is invoked from a preempting task.
  */
-static inline u32 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
+static inline u64 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
 					  const void *ctx)
 {
-	u32 ret;
+	u64 ret;
 
 	migrate_disable();
 	ret = bpf_prog_run(prog, ctx);
@@ -708,13 +708,13 @@ static inline u8 *bpf_skb_cb(const struct sk_buff *skb)
 }
 
 /* Must be invoked with migration disabled */
-static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
+static inline u64 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 					 const void *ctx)
 {
 	const struct sk_buff *skb = ctx;
 	u8 *cb_data = bpf_skb_cb(skb);
 	u8 cb_saved[BPF_SKB_CB_LEN];
-	u32 res;
+	u64 res;
 
 	if (unlikely(prog->cb_access)) {
 		memcpy(cb_saved, cb_data, sizeof(cb_saved));
@@ -729,10 +729,10 @@ static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 	return res;
 }
 
-static inline u32 bpf_prog_run_save_cb(const struct bpf_prog *prog,
+static inline u64 bpf_prog_run_save_cb(const struct bpf_prog *prog,
 				       struct sk_buff *skb)
 {
-	u32 res;
+	u64 res;
 
 	migrate_disable();
 	res = __bpf_prog_run_save_cb(prog, skb);
@@ -740,11 +740,11 @@ static inline u32 bpf_prog_run_save_cb(const struct bpf_prog *prog,
 	return res;
 }
 
-static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
+static inline u64 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 					struct sk_buff *skb)
 {
 	u8 *cb_data = bpf_skb_cb(skb);
-	u32 res;
+	u64 res;
 
 	if (unlikely(prog->cb_access))
 		memset(cb_data, 0, BPF_SKB_CB_LEN);
@@ -759,14 +759,14 @@ DECLARE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
 
 u32 xdp_master_redirect(struct xdp_buff *xdp);
 
-static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
+static __always_inline u64 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
 	/* Driver XDP hooks are invoked within a single NAPI poll cycle and thus
 	 * under local_bh_disable(), which provides the needed RCU protection
 	 * for accessing map entries.
 	 */
-	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+	u64 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
 
 	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
 		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 121b5a5edb64..9dffd786b541 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -63,8 +63,8 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	return run_ctx.retval;
 }
 
-unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
-				       const struct bpf_insn *insn)
+u64 __cgroup_bpf_run_lsm_sock(const void *ctx,
+			      const struct bpf_insn *insn)
 {
 	const struct bpf_prog *shim_prog;
 	struct sock *sk;
@@ -85,8 +85,8 @@ unsigned int __cgroup_bpf_run_lsm_sock(const void *ctx,
 	return ret;
 }
 
-unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
-					 const struct bpf_insn *insn)
+u64 __cgroup_bpf_run_lsm_socket(const void *ctx,
+				const struct bpf_insn *insn)
 {
 	const struct bpf_prog *shim_prog;
 	struct socket *sock;
@@ -107,8 +107,8 @@ unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
 	return ret;
 }
 
-unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
-					  const struct bpf_insn *insn)
+u64 __cgroup_bpf_run_lsm_current(const void *ctx,
+				 const struct bpf_insn *insn)
 {
 	const struct bpf_prog *shim_prog;
 	struct cgroup *cgrp;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 639437f36928..7549d765f7b6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1999,7 +1999,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
 #define DEFINE_BPF_PROG_RUN(stack_size) \
-static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
+static u64 PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn *insn) \
 { \
 	u64 stack[stack_size / sizeof(u64)]; \
 	u64 regs[MAX_BPF_EXT_REG]; \
@@ -2043,8 +2043,8 @@ EVAL4(DEFINE_BPF_PROG_RUN_ARGS, 416, 448, 480, 512);
 
 #define PROG_NAME_LIST(stack_size) PROG_NAME(stack_size),
 
-static unsigned int (*interpreters[])(const void *ctx,
-				      const struct bpf_insn *insn) = {
+static u64 (*interpreters[])(const void *ctx,
+			     const struct bpf_insn *insn) = {
 EVAL6(PROG_NAME_LIST, 32, 64, 96, 128, 160, 192)
 EVAL6(PROG_NAME_LIST, 224, 256, 288, 320, 352, 384)
 EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
@@ -2069,8 +2069,8 @@ void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
 }
 
 #else
-static unsigned int __bpf_prog_ret0_warn(const void *ctx,
-					 const struct bpf_insn *insn)
+static u64 __bpf_prog_ret0_warn(const void *ctx,
+				const struct bpf_insn *insn)
 {
 	/* If this handler ever gets executed, then BPF_JIT_ALWAYS_ON
 	 * is not working properly, so warn about it!
@@ -2205,8 +2205,8 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
 }
 EXPORT_SYMBOL_GPL(bpf_prog_select_runtime);
 
-static unsigned int __bpf_prog_ret1(const void *ctx,
-				    const struct bpf_insn *insn)
+static u64 __bpf_prog_ret1(const void *ctx,
+			   const struct bpf_insn *insn)
 {
 	return 1;
 }
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 13e4efc971e6..d6a37ab87511 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -246,8 +246,8 @@ static int bpf_prog_offload_translate(struct bpf_prog *prog)
 	return ret;
 }
 
-static unsigned int bpf_prog_warn_on_exec(const void *ctx,
-					  const struct bpf_insn *insn)
+static u64 bpf_prog_warn_on_exec(const void *ctx,
+				 const struct bpf_insn *insn)
 {
 	WARN(1, "attempt to execute device eBPF program on the host!");
 	return 0;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 25d8ecf105aa..f0827d8690f1 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -370,7 +370,7 @@ static int bpf_test_run_xdp_live(struct bpf_prog *prog, struct xdp_buff *ctx,
 }
 
 static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
-			u32 *retval, u32 *time, bool xdp)
+			u64 *retval, u32 *time, bool xdp)
 {
 	struct bpf_prog_array_item item = {.prog = prog};
 	struct bpf_run_ctx *old_ctx;
@@ -757,7 +757,7 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 	struct bpf_fentry_test_t arg = {};
 	u16 side_effect = 0, ret = 0;
 	int b = 2, err = -EFAULT;
-	u32 retval = 0;
+	u64 retval = 0;
 
 	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
@@ -797,7 +797,7 @@ int bpf_prog_test_run_tracing(struct bpf_prog *prog,
 struct bpf_raw_tp_test_run_info {
 	struct bpf_prog *prog;
 	void *ctx;
-	u32 retval;
+	u64 retval;
 };
 
 static void
@@ -1045,15 +1045,15 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
 	bool is_l2 = false, is_direct_pkt_access = false;
+	u32 size = kattr->test.data_size_in, duration;
 	struct net *net = current->nsproxy->net_ns;
 	struct net_device *dev = net->loopback_dev;
-	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
-	u32 retval, duration;
 	int hh_len = ETH_HLEN;
 	struct sk_buff *skb;
 	struct sock *sk;
+	u64 retval;
 	void *data;
 	int ret;
 
@@ -1241,15 +1241,16 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	bool do_live = (kattr->test.flags & BPF_F_TEST_XDP_LIVE_FRAMES);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	u32 batch_size = kattr->test.batch_size;
-	u32 retval = 0, duration, max_data_sz;
 	u32 size = kattr->test.data_size_in;
 	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
 	struct skb_shared_info *sinfo;
+	u32 duration, max_data_sz;
 	struct xdp_buff xdp = {};
 	int i, ret = -EINVAL;
 	struct xdp_md *ctx;
+	u64 retval = 0;
 	void *data;
 
 	if (prog->expected_attach_type == BPF_XDP_DEVMAP ||
@@ -1407,7 +1408,8 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 	struct bpf_flow_keys flow_keys;
 	const struct ethhdr *eth;
 	unsigned int flags = 0;
-	u32 retval, duration;
+	u32 duration;
+	u64 retval;
 	void *data;
 	int ret;
 
@@ -1472,8 +1474,9 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	struct bpf_sk_lookup_kern ctx = {};
 	u32 repeat = kattr->test.repeat;
 	struct bpf_sk_lookup *user_ctx;
-	u32 retval, duration;
 	int ret = -EINVAL;
+	u32 duration;
+	u64 retval;
 
 	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
@@ -1571,8 +1574,8 @@ int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
 	__u32 ctx_size_in = kattr->test.ctx_size_in;
 	void *ctx = NULL;
-	u32 retval;
 	int err = 0;
+	u64 retval;
 
 	/* doesn't support data_in/out, ctx_out, duration, or repeat or flags */
 	if (kattr->test.data_in || kattr->test.data_out ||
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5cbe07116e04..bc4d9ff6f91c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1444,8 +1444,11 @@ static unsigned int fanout_demux_bpf(struct packet_fanout *f,
 
 	rcu_read_lock();
 	prog = rcu_dereference(f->bpf_prog);
-	if (prog)
-		ret = bpf_prog_run_clear_cb(prog, skb) % num;
+	if (prog) {
+		ret = bpf_prog_run_clear_cb(prog, skb);
+		/* For some architectures, we need to do modulus in 32-bit width */
+		ret %= num;
+	}
 	rcu_read_unlock();
 
 	return ret;
-- 
2.37.2

