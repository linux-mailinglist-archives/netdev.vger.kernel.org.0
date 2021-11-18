Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318EB455A44
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344080AbhKRLbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:31:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343978AbhKRL3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3epWTENbvCHtKUodXQN7x8PcsitZYsEe+46k8+JKkuw=;
        b=EqEyLAk8O0/WVdEAJ2VeTODrAzcobb94HE+bQptF1P2Mw8SJDcamdivQW81bTC2gonnCon
        p8MDQxD2+xSQFNnIqYVx1w5phYfYkUUbAKpHPsJ7uPA2mpTEE6il+HpmPd8O2owz4vwqC6
        yaW0n0giq5nv7qjwOduZ0m43G3pR3iE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-fvvMx_mtOcuFwW3UfQKFvA-1; Thu, 18 Nov 2021 06:26:34 -0500
X-MC-Unique: fvvMx_mtOcuFwW3UfQKFvA-1
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso4952926edj.20
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:26:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3epWTENbvCHtKUodXQN7x8PcsitZYsEe+46k8+JKkuw=;
        b=7+PQ42K7yeXwy/2V+1I+zO45OtwxpJUwLDGtn1aSCcpESlMXRrAgiKTE6cHMlGCr7C
         PMCyTY8YzCFm1fCLchxskBSXTejaNR/13LMdzd+CZD2QjSpKgKi1qpXupbhX87lWP0tt
         MjGaHo/pgybXgkNayjdnEiX08iiEmgdqCAMGc9fULPQ0jyLDEv8uXOkqZidSeyzowO4m
         DdziDaqqiWGfheMHw6c/LnBeqHlqpGXjGs6COs2wKGkdmywPjumvn1vvU7eetYKyTiLH
         knyQeksqSbF4ztGJ37MkYdkfSOa/STmPppbOhjruOimehhnBwzAH4oQV6b0+mM4NqpvP
         0lgw==
X-Gm-Message-State: AOAM533tgsH9x1fK1K3nC8nNXLdaMCgjZ7AZKCQAcZHUqT+i0yDDzSvX
        aI6ZRL8ix/NuGge6pC1N13/L/nOiG/3/ygVoI+VApDrCNeU2Ssml6ejeRTRRrcreJ7m/BH+R9fy
        FbAysVmNFLtmKt45q
X-Received: by 2002:a17:906:1b1b:: with SMTP id o27mr32358069ejg.279.1637234793213;
        Thu, 18 Nov 2021 03:26:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwE0ncH346VRzvKTbIPM8QsddzsSDJe16UTcm5Gaf9xaOqpV6H2g4PE0AH7tj4e8F9DksE7A==
X-Received: by 2002:a17:906:1b1b:: with SMTP id o27mr32358042ejg.279.1637234793065;
        Thu, 18 Nov 2021 03:26:33 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id ho30sm1186939ejc.30.2021.11.18.03.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:26:32 -0800 (PST)
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
Subject: [PATCH bpf-next 16/29] bpf: Add bpf_tramp_id_single function
Date:   Thu, 18 Nov 2021 12:24:42 +0100
Message-Id: <20211118112455.475349-17-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_tramp_id_single function as interface to
create trampoline with single ID and grouping together
the trampoline allocation with init that is used on
several places and save us few lines.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h     |  5 ++---
 kernel/bpf/syscall.c    | 18 +++++++-----------
 kernel/bpf/trampoline.c | 11 ++++++++---
 kernel/bpf/verifier.c   |  3 +--
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 13e9dcfd47e7..894ee812e213 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -755,9 +755,8 @@ struct bpf_tramp_id *bpf_tramp_id_alloc(u32 cnt);
 void bpf_tramp_id_free(struct bpf_tramp_id *id);
 bool bpf_tramp_id_is_empty(struct bpf_tramp_id *id);
 int bpf_tramp_id_is_equal(struct bpf_tramp_id *a, struct bpf_tramp_id *b);
-void bpf_tramp_id_init(struct bpf_tramp_id *id,
-		       const struct bpf_prog *tgt_prog,
-		       struct btf *btf, u32 btf_id);
+struct bpf_tramp_id *bpf_tramp_id_single(const struct bpf_prog *tgt_prog,
+					 struct btf *btf, u32 btf_id);
 int bpf_trampoline_link_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
 int bpf_trampoline_unlink_prog(struct bpf_tramp_node *node, struct bpf_trampoline *tr);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0ae3b5b7419a..8109b0fc7d2f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2766,12 +2766,6 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 			goto out_put_prog;
 		}
 
-		id = bpf_tramp_id_alloc(1);
-		if (!id) {
-			err = -ENOMEM;
-			goto out_put_prog;
-		}
-
 		tgt_prog = bpf_prog_get(tgt_prog_fd);
 		if (IS_ERR(tgt_prog)) {
 			err = PTR_ERR(tgt_prog);
@@ -2779,7 +2773,11 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 			goto out_put_prog;
 		}
 
-		bpf_tramp_id_init(id, tgt_prog, NULL, btf_id);
+		id = bpf_tramp_id_single(tgt_prog, NULL, btf_id);
+		if (!id) {
+			err = -ENOMEM;
+			goto out_put_prog;
+		}
 	}
 
 	link = kzalloc(sizeof(*link), GFP_USER);
@@ -2829,14 +2827,12 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 			goto out_unlock;
 		}
 
-		id = bpf_tramp_id_alloc(1);
+		btf_id = prog->aux->attach_btf_id;
+		id = bpf_tramp_id_single(NULL, prog->aux->attach_btf, btf_id);
 		if (!id) {
 			err = -ENOMEM;
 			goto out_unlock;
 		}
-
-		btf_id = prog->aux->attach_btf_id;
-		bpf_tramp_id_init(id, NULL, prog->aux->attach_btf, btf_id);
 	}
 
 	if (!prog->aux->dst_attach ||
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index d9675d619963..4a4ef9396b7e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -104,16 +104,21 @@ struct bpf_tramp_id *bpf_tramp_id_alloc(u32 max)
 	return id;
 }
 
-void bpf_tramp_id_init(struct bpf_tramp_id *id,
-		       const struct bpf_prog *tgt_prog,
-		       struct btf *btf, u32 btf_id)
+struct bpf_tramp_id *bpf_tramp_id_single(const struct bpf_prog *tgt_prog,
+					 struct btf *btf, u32 btf_id)
 {
+	struct bpf_tramp_id *id;
+
+	id = bpf_tramp_id_alloc(1);
+	if (!id)
+		return NULL;
 	if (tgt_prog)
 		id->obj_id = tgt_prog->aux->id;
 	else
 		id->obj_id = btf_obj_id(btf);
 	id->id[0] = btf_id;
 	id->cnt = 1;
+	return id;
 }
 
 void bpf_tramp_id_free(struct bpf_tramp_id *id)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 56c518efa2d2..9914487f2281 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13995,11 +13995,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		return -EINVAL;
 	}
 
-	id = bpf_tramp_id_alloc(1);
+	id = bpf_tramp_id_single(NULL, prog->aux->attach_btf, btf_id);
 	if (!id)
 		return -ENOMEM;
 
-	bpf_tramp_id_init(id, tgt_prog, prog->aux->attach_btf, btf_id);
 	id->addr[0] = (void *) tgt_info.tgt_addr;
 
 	attach = bpf_tramp_attach(id, tgt_prog, prog);
-- 
2.31.1

