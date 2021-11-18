Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6E9455A41
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbhKRLb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:31:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58730 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343904AbhKRL3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:29:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJqHmk+ZMyp6K5b8ACnyHPg6ZEhvFJYuOs2AT1VL5MI=;
        b=fMb9m2x4tVYgMIenE/tOHs8nKTnX0XuDWLbkCgOiN0Z5N5MTn+AwCsabiPxbn4EdXInqEp
        Jl2xN2EVyWILSzWw7awQ76gghlQj0wdXhIXyvRv8+HAlurkY4y1Qd7i3TumKy+8pi5aDkw
        P/vEouKnZZ0OramkJDoRJNqymIGj0mU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-T94u8MQGNmqPKgeB3ah8HQ-1; Thu, 18 Nov 2021 06:26:28 -0500
X-MC-Unique: T94u8MQGNmqPKgeB3ah8HQ-1
Received: by mail-ed1-f69.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso3026857edq.19
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJqHmk+ZMyp6K5b8ACnyHPg6ZEhvFJYuOs2AT1VL5MI=;
        b=M45cQtcBzMs4iHolFvC2HsApniP35kkcxwCC9Ld2ZAu3d0axmhXQQTGXbmuOIh6HZC
         /GSiRDOwy58Mxv2bwj7CJ7Gi6Y9tDf0RnsyXPAFfo+aLJJizBhxpsDOpIrKw+WpAXmbg
         n0XUtkGbN9RGMChJWSdKTMOYjaqNR+XTO9WMlta3Nv7H+KIWflKR95pVegxTadz4vAxs
         tGjaNG3+326L67xOpWJhjPfuQsRLP0Azmu2+fHuNfbXg+D7YDq0YK9YCsHkAvQ+k0u2n
         Go6gpf+fLUOnPr5pq9eBy+cQUeANNZlY1vZrFWMdbCVLHJFfW8/Fk38/6GcWnNP4zt0z
         OzPQ==
X-Gm-Message-State: AOAM5319mRtfdveKWcJFkBdciOtJhjzWsnrNz6PrOK87QfGR8V7V6anh
        9fHhqyThNohcP/azQYZ/g3gBgVLEB60G/rLCvyd/SkMUmc7yLRlbEC3nfE2Ee7gc51aMnLi8Sk3
        krc0aVPYOI68urMtM
X-Received: by 2002:a50:e089:: with SMTP id f9mr10346388edl.290.1637234787260;
        Thu, 18 Nov 2021 03:26:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjRG3EqPq6/SddZG4kWdHXZSl6WAkMfMmgkquhQDqfXX+KAqWQtWyPEbl+yp/g6O1neegfYw==
X-Received: by 2002:a50:e089:: with SMTP id f9mr10346357edl.290.1637234787106;
        Thu, 18 Nov 2021 03:26:27 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id l26sm1403725eda.20.2021.11.18.03.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:26:26 -0800 (PST)
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
Subject: [PATCH bpf-next 15/29] bpf: Add support to store multiple addrs in bpf_tramp_id object
Date:   Thu, 18 Nov 2021 12:24:41 +0100
Message-Id: <20211118112455.475349-16-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to store multiple addrs in bpf_tramp_id object,
to provide address values for id values stored in the object.

The id->addr[idx] returns address value for id->id[idx] id.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  2 +-
 kernel/bpf/syscall.c    |  2 +-
 kernel/bpf/trampoline.c | 20 ++++++++++++--------
 kernel/bpf/verifier.c   |  2 +-
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 47e25d8be600..13e9dcfd47e7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -676,7 +676,7 @@ struct bpf_tramp_id {
 	u32 cnt;
 	u32 obj_id;
 	u32 *id;
-	void *addr;
+	void **addr;
 };
 
 struct bpf_tramp_node {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 216fcce07326..0ae3b5b7419a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2853,7 +2853,7 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		if (err)
 			goto out_unlock;
 
-		id->addr = (void *) tgt_info.tgt_addr;
+		id->addr[0] = (void *) tgt_info.tgt_addr;
 
 		attach = bpf_tramp_attach(id, tgt_prog, prog);
 		if (IS_ERR(attach)) {
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index d65f463c532d..d9675d619963 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -92,7 +92,10 @@ struct bpf_tramp_id *bpf_tramp_id_alloc(u32 max)
 	id = kzalloc(sizeof(*id), GFP_KERNEL);
 	if (id) {
 		id->id = kzalloc(sizeof(u32) * max, GFP_KERNEL);
-		if (!id->id) {
+		id->addr = kzalloc(sizeof(*id->addr) * max, GFP_KERNEL);
+		if (!id->id || !id->addr) {
+			kfree(id->id);
+			kfree(id->addr);
 			kfree(id);
 			return NULL;
 		}
@@ -117,6 +120,7 @@ void bpf_tramp_id_free(struct bpf_tramp_id *id)
 {
 	if (!id)
 		return;
+	kfree(id->addr);
 	kfree(id->id);
 	kfree(id);
 }
@@ -159,7 +163,7 @@ static int bpf_trampoline_module_get(struct bpf_trampoline *tr)
 	int err = 0;
 
 	preempt_disable();
-	mod = __module_text_address((unsigned long) tr->id->addr);
+	mod = __module_text_address((unsigned long) tr->id->addr[0]);
 	if (mod && !try_module_get(mod))
 		err = -ENOENT;
 	preempt_enable();
@@ -187,7 +191,7 @@ static int is_ftrace_location(void *ip)
 
 static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 {
-	void *ip = tr->id->addr;
+	void *ip = tr->id->addr[0];
 	int ret;
 
 	if (tr->func.ftrace_managed)
@@ -202,7 +206,7 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
 
 static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_addr)
 {
-	void *ip = tr->id->addr;
+	void *ip = tr->id->addr[0];
 	int ret;
 
 	if (tr->func.ftrace_managed)
@@ -215,7 +219,7 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
 /* first time registering */
 static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 {
-	void *ip = tr->id->addr;
+	void *ip = tr->id->addr[0];
 	int ret;
 
 	ret = is_ftrace_location(ip);
@@ -434,7 +438,7 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 
 	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
 					  &tr->func.model, flags, tprogs,
-					  tr->id->addr);
+					  tr->id->addr[0]);
 	if (err < 0)
 		goto out;
 
@@ -503,7 +507,7 @@ int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline
 			goto out;
 		}
 		tr->extension_prog = prog;
-		err = bpf_arch_text_poke(tr->id->addr, BPF_MOD_JUMP, NULL,
+		err = bpf_arch_text_poke(tr->id->addr[0], BPF_MOD_JUMP, NULL,
 					 prog->bpf_func);
 		goto out;
 	}
@@ -539,7 +543,7 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampolin
 	mutex_lock(&tr->mutex);
 	if (kind == BPF_TRAMP_REPLACE) {
 		WARN_ON_ONCE(!tr->extension_prog);
-		err = bpf_arch_text_poke(tr->id->addr, BPF_MOD_JUMP,
+		err = bpf_arch_text_poke(tr->id->addr[0], BPF_MOD_JUMP,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
 		goto out;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1903d5d256b6..56c518efa2d2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14000,7 +14000,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -ENOMEM;
 
 	bpf_tramp_id_init(id, tgt_prog, prog->aux->attach_btf, btf_id);
-	id->addr = (void *) tgt_info.tgt_addr;
+	id->addr[0] = (void *) tgt_info.tgt_addr;
 
 	attach = bpf_tramp_attach(id, tgt_prog, prog);
 	if (IS_ERR(attach)) {
-- 
2.31.1

