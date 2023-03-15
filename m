Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FDB6BBFE1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCOWg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjCOWgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:36:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D80E1A977;
        Wed, 15 Mar 2023 15:36:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id iw3so4856539plb.6;
        Wed, 15 Mar 2023 15:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678919776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFibuvC+RuNZKj+JLga00XkPB0Kr+WsV2xstr+uagnQ=;
        b=h0haTo//ELwMPl2fT3k9nvU568eQVR51q2APdsiJD3zYE0rDec1Hy8ln4HRh0mbGMh
         AG3mmF59IO4omU+FM/2a9YOAbWgznfOuMxOqG6P+HyOdO1NcF2DALdnm7DvcgE2uXM3L
         gyqvy/ZU4ybXl1gCcJ/0C8uEPjAizW3hT/d/vCh53wbeX8XR2vc8+2ACcIdFUWCwE/q1
         eNWEBBJY/GIZTCNs+KtyDFgdYgex8UggPqiwOk5V8qXOOqK+jyBxbQsJeWWLOPRuFe1e
         4JConX4Wb2IqqaopMWkNzhJ2/uSDv3D97QghGhm2zWBbeuvS1wANNS64L1lGEfkMKSyh
         bPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678919776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFibuvC+RuNZKj+JLga00XkPB0Kr+WsV2xstr+uagnQ=;
        b=O5Ud7uGC1m82ZwBt4oXRJL45GDRnLXXf3fQU+DYMDWjipWC1EuoJ5DTAjI9HqnRkkd
         cTWeRHoYlRuzceK6UoHmMxWDYHdxX8P8dGVEqw/POOIFyholeTVwGYg7XoC+06Cbp/up
         iY9z58l73ai1GFH4tXJE470sXxh/8WoWTYkhw0KL1TayVFF0bGjseU+3hHoxT9qQESIq
         uUH7Nz99E41eGGMLYRd+Zq7wEyqdE6WtJH6ks4wb0/YvLvV/WnoJWQ7zyvNu7a3T50q2
         d59sLnv7lLT6Zq4/I0gLQcCHBzX/cY1DN433b7DuxyZf+GYkhRH4dfcclixzrOQEnDd0
         5Ihw==
X-Gm-Message-State: AO0yUKUN8HHZczoeynsyNl6SbXQ2YIHqJXECO3c41YZaEq3xbrbjEA+U
        XeOYHG3rNKDy7SkEeavSLIc=
X-Google-Smtp-Source: AK7set+87adcux6kwUtVk1knr3VfYqDva3hLOySZ4ScmqM3jW3CDBYpQh0jg3vtMqxUSaK/kk7rrKg==
X-Received: by 2002:a05:6a20:699b:b0:d5:a28c:43ef with SMTP id t27-20020a056a20699b00b000d5a28c43efmr1592672pzk.43.1678919776484;
        Wed, 15 Mar 2023 15:36:16 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id h11-20020a63df4b000000b0050b19d24c3bsm3904254pgj.37.2023.03.15.15.36.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Mar 2023 15:36:15 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to kfunc.
Date:   Wed, 15 Mar 2023 15:36:06 -0700
Message-Id: <20230315223607.50803-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfunc.
PTR_MEM is already recognized for NULL-ness by is_branch_taken(),
so unresolved kfuncs will be seen as zero.
This allows BPF programs to detect at load time whether kfunc is present
in the kernel with bpf_kfunc_exists() macro.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c       | 7 +++++--
 tools/lib/bpf/bpf_helpers.h | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 60793f793ca6..4e49d34d8cd6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15955,8 +15955,8 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		goto err_put;
 	}
 
-	if (!btf_type_is_var(t)) {
-		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n", id);
+	if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
+		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR or KIND_FUNC\n", id);
 		err = -EINVAL;
 		goto err_put;
 	}
@@ -15990,6 +15990,9 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 		aux->btf_var.reg_type = PTR_TO_BTF_ID | MEM_PERCPU;
 		aux->btf_var.btf = btf;
 		aux->btf_var.btf_id = type;
+	} else if (!btf_type_is_func(t)) {
+		aux->btf_var.reg_type = PTR_TO_MEM | MEM_RDONLY;
+		aux->btf_var.mem_size = 0;
 	} else if (!btf_type_is_struct(t)) {
 		const struct btf_type *ret;
 		const char *tname;
diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 7d12d3e620cc..43abe4c29409 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -177,6 +177,9 @@ enum libbpf_tristate {
 #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")))
 #define __kptr __attribute__((btf_type_tag("kptr")))
 
+/* pass function pointer through asm otherwise compiler assumes that any function != 0 */
+#define bpf_kfunc_exists(fn) ({ void *__p = fn; asm ("" : "+r"(__p)); __p; })
+
 #ifndef ___bpf_concat
 #define ___bpf_concat(a, b) a ## b
 #endif
-- 
2.34.1

