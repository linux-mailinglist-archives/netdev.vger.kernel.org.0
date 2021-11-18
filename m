Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A78455A3A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344062AbhKRLa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:30:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343938AbhKRL3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:29:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/94uMDhmykTTrRJ70E8PPEqUT/kiBmU37LOMy0UW0k=;
        b=e6lkb8NaLPIx6Vms0DOCWPdoA1wP8UXbp4Uhn966fqi85lMIXMsfXsDyUQf2+gK1xI+4Fw
        n3dgkoUYSSUfRioScDkw7sIFR9+jLFMxY4qfsceV/6kv6DmgzqhsiYZG6dIw8AujFPNonn
        ABvUPsQc7/7Epc3dFcsb4wVF9337Wew=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-gDoV4YSVNo-zsa7vBYAdGA-1; Thu, 18 Nov 2021 06:26:11 -0500
X-MC-Unique: gDoV4YSVNo-zsa7vBYAdGA-1
Received: by mail-ed1-f71.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso3026289edq.19
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:26:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/94uMDhmykTTrRJ70E8PPEqUT/kiBmU37LOMy0UW0k=;
        b=NQjcyCWYZlUQVr6w+mE83Fnx1vHT0/Za6t9x9HdIkhGhAWE5F+UnWfThlaseKp9Iee
         hy+L6/1mbP7GovlA3ucuD+KtVW9/VKasCcnKMYC/cK2zwnVbrg1MaR5+tLdG3t3UUYQ6
         2lI5aDhfnCLwhmq3WMCbDgFQUG9nwRd8oyIDOVEz6qCzZ79ft2EX9/HaKyp15QFW1vNR
         ZX/AIj1dLOoktn0qvuvcpnkeoZAZ6FrHd72Y3cRqHksBBqjLhoUXKz2sXDVoPCAgOxIh
         D0/dOd+mo6V3cF6AAYtMf7XxCklLs+k0KC8cgTJRYgJ9uERJebvEiswrVLOIrIsj1oiJ
         jrLA==
X-Gm-Message-State: AOAM5324+4baCT2aZjMSJ/YDGBPAC4urKUkjDiR8WD/L9u5dM3nvhRx0
        CU9LoAeeOm6PG1lpa/uYxLf+wTYW46+uVLVkY4SuFsu3BY3g9bGebRoeppsMfQX+3p5J6da9fv+
        wh8lpvHbTkBl5B8EP
X-Received: by 2002:a05:6402:44c:: with SMTP id p12mr10133424edw.234.1637234769182;
        Thu, 18 Nov 2021 03:26:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiIhF7LjLYWcPNMq+AEu4aeJP6jDF460Wr6DkNxnkAsEmZPCMFB31tQ81YrNUZjw2dGUdMZA==
X-Received: by 2002:a05:6402:44c:: with SMTP id p12mr10133389edw.234.1637234768986;
        Thu, 18 Nov 2021 03:26:08 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id n1sm1457459edf.45.2021.11.18.03.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:26:08 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 12/29] bpf: Add struct bpf_tramp_node layer
Date:   Thu, 18 Nov 2021 12:24:38 +0100
Message-Id: <20211118112455.475349-13-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
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
index c57141a76e7b..21f8dbcf3f48 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -677,6 +677,11 @@ struct bpf_tramp_id {
 	void *addr;
 };
 
+struct bpf_tramp_node {
+	struct hlist_node hlist_tramp;
+	struct bpf_prog *prog;
+};
+
 struct bpf_trampoline {
 	/* hlist for trampoline_table */
 	struct hlist_node hlist;
@@ -744,8 +749,8 @@ int bpf_tramp_id_is_equal(struct bpf_tramp_id *a, struct bpf_tramp_id *b);
 void bpf_tramp_id_init(struct bpf_tramp_id *id,
 		       const struct bpf_prog *tgt_prog,
 		       struct btf *btf, u32 btf_id);
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr);
+int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
+int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
 struct bpf_trampoline *bpf_trampoline_get(struct bpf_tramp_id *id,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
@@ -794,12 +799,12 @@ void bpf_ksym_del(struct bpf_ksym *ksym);
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
@@ -894,7 +899,7 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool multi_func;
-	struct hlist_node tramp_hlist;
+	struct bpf_tramp_node tramp_node;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b52dc845ecea..2eed91153a3f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -105,6 +105,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux = aux;
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
+	fp->aux->tramp_node.prog = fp;
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f99ea3237f9c..0d916e3b7676 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2665,7 +2665,7 @@ static void bpf_tracing_link_release(struct bpf_link *link)
 	struct bpf_trampoline *tr = link_trampoline(tr_link);
 	struct bpf_prog *prog = link->prog;
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog, tr));
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(&link->prog->aux->tramp_node, tr));
 
 	if (prog->type != BPF_PROG_TYPE_EXT)
 		prog->aux->trampoline = NULL;
@@ -2874,7 +2874,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 	if (err)
 		goto out_unlock;
 
-	err = bpf_trampoline_link_prog(prog, tr);
+	err = bpf_trampoline_link_prog(&prog->aux->tramp_node, tr);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		link = NULL;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index e19c5112be67..b6af3e0982d7 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -216,8 +216,8 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 static struct bpf_tramp_progs *
 bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total, bool *ip_arg)
 {
-	const struct bpf_prog_aux *aux;
 	struct bpf_tramp_progs *tprogs;
+	struct bpf_tramp_node *node;
 	struct bpf_prog **progs;
 	int kind;
 
@@ -231,9 +231,9 @@ bpf_trampoline_get_progs(const struct bpf_trampoline *tr, int *total, bool *ip_a
 		*total += tr->progs_cnt[kind];
 		progs = tprogs[kind].progs;
 
-		hlist_for_each_entry(aux, &tr->progs_hlist[kind], tramp_hlist) {
-			*ip_arg |= aux->prog->call_get_func_ip;
-			*progs++ = aux->prog;
+		hlist_for_each_entry(node, &tr->progs_hlist[kind], hlist_tramp) {
+			*ip_arg |= node->prog->call_get_func_ip;
+			*progs++ = node->prog;
 		}
 	}
 	return tprogs;
@@ -455,8 +455,9 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr)
 {
+	struct bpf_prog *prog = node->prog;
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
 	int cnt;
@@ -486,16 +487,16 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		err = -E2BIG;
 		goto out;
 	}
-	if (!hlist_unhashed(&prog->aux->tramp_hlist)) {
+	if (!hlist_unhashed(&node->hlist_tramp)) {
 		/* prog already linked */
 		err = -EBUSY;
 		goto out;
 	}
-	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
+	hlist_add_head(&node->hlist_tramp, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
 	err = bpf_trampoline_update(tr);
 	if (err) {
-		hlist_del_init(&prog->aux->tramp_hlist);
+		hlist_del_init(&node->hlist_tramp);
 		tr->progs_cnt[kind]--;
 	}
 out:
@@ -504,8 +505,9 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 }
 
 /* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr)
 {
+	struct bpf_prog *prog = node->prog;
 	enum bpf_tramp_prog_type kind;
 	int err;
 
@@ -518,7 +520,7 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		tr->extension_prog = NULL;
 		goto out;
 	}
-	hlist_del_init(&prog->aux->tramp_hlist);
+	hlist_del_init(&node->hlist_tramp);
 	tr->progs_cnt[kind]--;
 	err = bpf_trampoline_update(tr);
 out:
-- 
2.31.1

