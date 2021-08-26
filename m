Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14C03F8EEB
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbhHZTl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243554AbhHZTlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XL7EGdnRDnjROM7SJL/BtZcDUjirQCAXAUSG27AzLfg=;
        b=Whvi/GPUV1G0RsYoAfag96W8yZVC4kfCTcbGWTU12q22QFP3BLbYMwhJRzWxGV2/HR4lp4
        69pGVmZTVILLJKGllrN5ypSjbxptc6KRm3xV6tR5iYDb2GpfFy4DyIlM+JLbHaphRkQJCK
        7VXOdXzuBZuaWvY6PyaxXU8awEwv3Hk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-OVAYtAHgNgyzLOhJZ9UWag-1; Thu, 26 Aug 2021 15:40:27 -0400
X-MC-Unique: OVAYtAHgNgyzLOhJZ9UWag-1
Received: by mail-wr1-f71.google.com with SMTP id n10-20020a5d660a0000b02901551ef5616eso1184933wru.20
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XL7EGdnRDnjROM7SJL/BtZcDUjirQCAXAUSG27AzLfg=;
        b=tLCF301h470To+nKxjlTgTatM5oAv22MJVHcjLZQ3inJWfPRjerIMJZhW5gFjherNA
         oXELyP9vV0KNden8wKEPMiL7vvtxpXNasa1B+WtOs9XW0SmQfEVv2JUJuFFHMm12ahqw
         5yPfkuITyBULjHV46egAy0rhHDqwAzgtVLD4dKwBcf0V4QkvXnp0bnZH//bH6tbKVPXh
         C+Ue187g2y+XPFMXwlWsOeJ7l0apeyRAPB/tutDFtE3KoHA3byM2uPbPWWFWnsnXDUkX
         kRNYS8pGL3ge0Q7Q8Ztg6pEY/5NeOebx4NxVIDJ5yj4Oa2OhCM3miUKV7aM9iuSGZ2sv
         0bqg==
X-Gm-Message-State: AOAM531hBSNwJioqq+8oePLHvP1EeZYNzyWy4LB++6Mc1I4jj+On+44l
        BoWMycamJeymNN387r1ptGPSlvitX+odJS2wmOElmtPEE34O/4q5C3DtNsWO7M0mNUNfrEiH6vn
        zYTneqCJUFhIQpYZU
X-Received: by 2002:adf:c442:: with SMTP id a2mr6178149wrg.228.1630006825874;
        Thu, 26 Aug 2021 12:40:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4ThkcoabbL1tyL3cMS54Eqzkexu+Sh11dVw2PpPP3/j80quT+iIshaVRguUeFAaNNH5Joaw==
X-Received: by 2002:adf:c442:: with SMTP id a2mr6178127wrg.228.1630006825695;
        Thu, 26 Aug 2021 12:40:25 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id 18sm10264579wmv.27.2021.08.26.12.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:25 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 10/27] bpf: Add struct bpf_tramp_node layer
Date:   Thu, 26 Aug 2021 21:39:05 +0200
Message-Id: <20210826193922.66204-11-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently each trampoline holds a list of programs that
are attached to it. With multi func attach support we need
a way for a single program to be connected to multiple
trampolines.

Adding struct bpf_tramp_node object that holds bpf_prog
pointer, so it can be resolved directly. We can now
have multiple struct bpf_tramp_node being attached to
different trampolines pointing to single bpf_prog.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     | 15 ++++++++++-----
 kernel/bpf/core.c       |  1 +
 kernel/bpf/syscall.c    |  4 ++--
 kernel/bpf/trampoline.c | 22 ++++++++++++----------
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index dc9838d741ac..f0f548f8f391 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -656,6 +656,11 @@ struct bpf_tramp_image {
 	};
 };
 
+struct bpf_tramp_node {
+	struct hlist_node hlist;
+	struct bpf_prog *prog;
+};
+
 struct bpf_trampoline {
 	/* hlist for trampoline_table */
 	struct hlist_node hlist;
@@ -717,8 +722,8 @@ static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 	return bpf_func(ctx, insnsi);
 }
 #ifdef CONFIG_BPF_JIT
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
+int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -767,12 +772,12 @@ void bpf_ksym_del(struct bpf_ksym *ksym);
 int bpf_jit_charge_modmem(u32 pages);
 void bpf_jit_uncharge_modmem(u32 pages);
 #else
-static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
+static inline int bpf_trampoline_link_prog(struct bpf_tramp_node *node,
 					   struct bpf_trampoline *tr)
 {
 	return -ENOTSUPP;
 }
-static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
+static inline int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node,
 					     struct bpf_trampoline *tr)
 {
 	return -ENOTSUPP;
@@ -866,7 +871,7 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool multi_func;
-	struct hlist_node tramp_hlist;
+	struct bpf_tramp_node tramp_node;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9f4636d021b1..bad03dde97a2 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -104,6 +104,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux = aux;
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
+	fp->aux->tramp_node.prog = fp;
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fa3f93c423d8..e667d392cc33 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2625,7 +2625,7 @@ static void bpf_tracing_link_release(struct bpf_link *link)
 	struct bpf_tracing_link *tr_link =
 		container_of(link, struct bpf_tracing_link, link);
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&link->prog->aux->tramp_node,
 						tr_link->trampoline));
 
 	bpf_trampoline_put(tr_link->trampoline);
@@ -2813,7 +2813,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	if (err)
 		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(prog, tr);
+	err = bpf_trampoline_link_prog(&prog->aux->tramp_node, tr);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index fe1e857324e6..525fa74c2f62 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -174,8 +174,8 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 static struct bpf_tramp_progs *
 bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total, bool *ip_arg)
 {
-	const struct bpf_prog_aux *aux;
 	struct bpf_tramp_progs *tprogs;
+	struct bpf_tramp_node *node;
 	struct bpf_prog **progs;
 	int kind;
 
@@ -189,9 +189,9 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total, bool *ip_a
 		*total += tr->progs_cnt[kind];
 		progs = tprogs[kind].progs;
 
-		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
-			*ip_arg |= aux->prog->call_get_func_ip;
-			*progs++ = aux->prog;
+		hlist_for_each_entry(node, &tr->progs_hlist[kind], hlist) {
+			*ip_arg |= node->prog->call_get_func_ip;
+			*progs++ = node->prog;
 		}
 	}
 	return tprogs;
@@ -410,8 +410,9 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr)
 {
+	struct bpf_prog *prog = node->prog;
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
 	int cnt;
@@ -441,16 +442,16 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		err = -E2BIG;
 		goto out;
 	}
-	if (!hlist_unhashed(&prog->aux->tramp_hlist)) {
+	if (!hlist_unhashed(&node->hlist)) {
 		/* prog already linked */
 		err = -EBUSY;
 		goto out;
 	}
-	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
+	hlist_add_head(&node->hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
 	err = bpf_trampoline_update(tr);
 	if (err) {
-		hlist_del_init(&prog->aux->tramp_hlist);
+		hlist_del_init(&node->hlist);
 		tr->progs_cnt[kind]--;
 	}
 out:
@@ -459,8 +460,9 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr)
 {
+	struct bpf_prog *prog = node->prog;
 	enum bpf_tramp_prog_type kind;
 	int err;
 
@@ -473,7 +475,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		tr->extension_prog = NULL;
 		goto out;
 	}
-	hlist_del_init(&prog->aux->tramp_hlist);
+	hlist_del_init(&node->hlist);
 	tr->progs_cnt[kind]--;
 	err = bpf_trampoline_update(tr);
 out:
-- 
2.31.1

