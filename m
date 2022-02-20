Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785164BCEC3
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243890AbiBTNtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiBTNs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:59 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63E62DAA5;
        Sun, 20 Feb 2022 05:48:38 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so1167699pja.1;
        Sun, 20 Feb 2022 05:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RnTzyrPN1gycMBmbewX188jeez+a/yeyOEr6gJG3f+Y=;
        b=bFbj9bV6K8a3Rlr4t/RR1IlNRc69Z5gko3EBHgmng6WZoLVW/zBl14o7UOoBXJIvYU
         rGMBDinhff+Z18RVo308Dk2GghtibKLfob/t5a6wvpAWN9ewShhQN+utBMcA3gDzQWSQ
         ARfnZYitF9Z1eXCn1waaRUn0y0OXLhXFVlmQCwrAeKewsQiKEXax9guzWrY4NarbP74A
         Np8IAjEHJXIz3emHLgouLvGSQYK3r3PiGpLc82+DI+6uF98X+Ev76vRpb+w9nrp75reA
         nvmRM7FZ+W2iYGlF20//8V+P2BnPOGzUwgfNzA7HRtqVSgs9KR4KXkIHEJNAPpRNVW4B
         pMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnTzyrPN1gycMBmbewX188jeez+a/yeyOEr6gJG3f+Y=;
        b=NhLDP+jkQdXXBqjQEG2FcpC95AHKnBT9/GY7JrHsXiRWBE3anYzRrK5BWwRLDMZ3+g
         wwg6qtgSetPLZwuYKe6FEcKpFKMkOKpLtF9zpvCy1eM422vCSusl7PUvQdJJfY3LXHND
         GvAVxfRklicXc6oM6DgZBQQuUhJZdcI1EgHaCNrkmzlXjA1Na63Cg+ZtA/A2D6TCkxNQ
         DJ7CmZgmTdg8DMdbmAtSmm7eybkHqIKHHBmnGX26EgsrjoWR3QWc3bPS1xZZDDYy/T9N
         IIbGrC9YfDOb5H/gb8TeGVQZrHfodqbtwsk25Xe5k8+KChdZDdME/9MX52NRpTu8mFCj
         I8gg==
X-Gm-Message-State: AOAM530L6lK87Sf6FL/6yfYJiDaSpv1azJCMfWFqFULr+LF7NZB18pLv
        u0sHFM6+PP2xQA1KLpiH6JTW6cdfV9o=
X-Google-Smtp-Source: ABdhPJxAGalx6+eGvybddHpkcMjL1+QsclhW0mshnpqG7PU2+O5rEmAANH14JVVQV04DwqybtEWXmw==
X-Received: by 2002:a17:90b:28f:b0:1bc:299d:39a8 with SMTP id az15-20020a17090b028f00b001bc299d39a8mr2433231pjb.37.1645364918031;
        Sun, 20 Feb 2022 05:48:38 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id b14sm9348428pfm.17.2022.02.20.05.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:37 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 07/15] bpf: Prevent escaping of pointers loaded from maps
Date:   Sun, 20 Feb 2022 19:18:05 +0530
Message-Id: <20220220134813.3411982-8-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5602; h=from:subject; bh=7UyEom+I59hJQUO2S4Ny604SxmBWVuMgkWYVqDd2Kiw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXytxd+LuA78DGayPrTa0kjZ8Qf3jQquOITi3n MT7H7vKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RymT4EA C+prnpoetmZ72YD4fVgYRw7vM/H8mHwPPhQEzi/SXtSc7BqYZGy4EX1qxtJSYdoi66PtuAMIUszagu 2MFxKzHd1h+XypPkNiE6CzsIaPSspbIsTZR6WqJbHxeLxpPveQm64E6k7lGmA3Muiu4pQDSG9ffKlr Li9Y2IzzIyY01fcj/9xudgSl2zpwm2+tYvpDRhzrdTykWPGvMtE2JMHIP1ygAlzy3+Dv2ZXKzeCcFf Wz2tPizM3t6NXieOcEyMGoBcwa7WFFH8sNPlHviHGWz9V3S23BUw8qAVHdXAr9Uy14QktWpcc4jPE2 u72ShDG7MUY8Tp3cExw12TDqtvY8iNF+8y6t5VMTe8zeA3WjLm5yHu5sxoL8lcZLbPNNwLRS0NjFOY 90Z+1HY0+PiF23tgEccoaF1mOHXGCxAUByPjO6xgZtW8UleikkQ+LQSTj4Zy4SFZDnsuQCLkuDnJdK bKb7aYdXSiQWKiKT0mSxwKGgxYpZ4nRYmkbFVst2j7VquPAjFHkZwfMTQewaBhMRJ39MN/Yw6OIAYx +R4lhuYJA6mHP06v87CuqVcGJwuTW0oVjxo2ACfWUejrqeOq1fb3dmFX+3BKAcAfTSK/DFK3NB6PWQ BqSUl8BrjVTsZiAR6cP1bYt+Z/qWMs1VwyfpP1hgkIC3qnUYn9ARP4SpfEww==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we can guarantee that even for unreferenced pointer, the object
pointer points to being freed etc. can be handled by the verifier's
exception handling (normal load patching to PROBE_MEM loads), we still
cannot allow the user to pass these pointers to BPF helpers and kfunc,
because the same exception handling won't be done for accesses inside
the kernel.

Hence introduce a new type flag, PTR_UNTRUSTED, which is used to mark
all registers loading unreferenced PTR_TO_BTF_ID from BPF maps, and
ensure they can never escape the BPF program and into the kernel by way
of calling stable/unstable helpers.

Adjust the check in check_mem_access so that we allow calling
check_ptr_to_btf_access only when no or PTR_UNTRUSTED type flag is set.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  7 +++++++
 kernel/bpf/verifier.c | 29 ++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 37ca92f4c7b7..ae599aaf8d4c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -364,6 +364,13 @@ enum bpf_type_flag {
 	/* MEM is in user address space. */
 	MEM_USER		= BIT(3 + BPF_BASE_TYPE_BITS),
 
+	/* PTR is not trusted. This is only used with PTR_TO_BTF_ID, to mark
+	 * unrefcounted pointers loaded from map value, so that they can only
+	 * be dereferenced but not escape the BPF program into the kernel (i.e.
+	 * cannot be passed as arguments to kfunc or bpf helpers).
+	 */
+	PTR_UNTRUSTED		= BIT(4 + BPF_BASE_TYPE_BITS),
+
 	__BPF_TYPE_LAST_FLAG	= MEM_USER,
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 28da858bb921..0a2cd21d9ec1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -582,6 +582,8 @@ static const char *reg_type_str(struct bpf_verifier_env *env,
 		strncpy(prefix, "alloc_", 32);
 	if (type & MEM_USER)
 		strncpy(prefix, "user_", 32);
+	if (type & PTR_UNTRUSTED)
+		strncpy(prefix, "untrusted_", 32);
 
 	snprintf(env->type_str_buf, TYPE_STR_BUF_LEN, "%s%s%s",
 		 prefix, str[base_type(type)], postfix);
@@ -3490,10 +3492,17 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 		if (reg->type != PTR_TO_PERCPU_BTF_ID &&
 		    reg->type != (PTR_TO_PERCPU_BTF_ID | PTR_MAYBE_NULL))
 			goto end;
-	} else { /* referenced and unreferenced case */
+	} else if (off_desc->flags & BPF_MAP_VALUE_OFF_F_REF) {
+		/* register state (ref_obj_id) must be checked by caller */
 		if (reg->type != PTR_TO_BTF_ID &&
 		    reg->type != (PTR_TO_BTF_ID | PTR_MAYBE_NULL))
 			goto end;
+	} else { /* only unreferenced case accepts untrusted pointers */
+		if (reg->type != PTR_TO_BTF_ID &&
+		    reg->type != (PTR_TO_BTF_ID | PTR_MAYBE_NULL) &&
+		    reg->type != (PTR_TO_BTF_ID | PTR_UNTRUSTED) &&
+		    reg->type != (PTR_TO_BTF_ID | PTR_MAYBE_NULL | PTR_UNTRUSTED))
+			goto end;
 	}
 
 	if (!btf_is_kernel(reg->btf)) {
@@ -3597,10 +3606,13 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 	ref_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_REF;
 	percpu_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU;
 	user_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_USER;
+
 	if (percpu_ptr)
 		reg_type = PTR_TO_PERCPU_BTF_ID;
 	else if (user_ptr)
 		reg_flags |= MEM_USER;
+	else
+		reg_flags |= PTR_UNTRUSTED;
 
 	if (is_xchg_insn(insn)) {
 		/* We do checks and updates during register fill call for fetch case */
@@ -3629,6 +3641,10 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 			if (ret < 0)
 				return ret;
 			ref_obj_id = ret;
+			/* Unset PTR_UNTRUSTED, so that it can be passed to bpf
+			 * helpers or kfunc.
+			 */
+			reg_flags &= ~PTR_UNTRUSTED;
 		}
 		/* val_reg might be NULL at this point */
 		mark_btf_ld_reg(env, cur_regs(env), value_regno, reg_type, off_desc->btf,
@@ -4454,6 +4470,12 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (ret < 0)
 		return ret;
 
+	/* If this is an untrusted pointer, all btf_id pointers formed by
+	 * walking it also inherit the untrusted flag.
+	 */
+	if (type_flag(reg->type) & PTR_UNTRUSTED)
+		flag |= PTR_UNTRUSTED;
+
 	if (atype == BPF_READ && value_regno >= 0)
 		mark_btf_ld_reg(env, regs, value_regno, ret, reg->btf, btf_id, flag);
 
@@ -4804,7 +4826,7 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		err = check_tp_buffer_access(env, reg, regno, off, size);
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
-	} else if (reg->type == PTR_TO_BTF_ID) {
+	} else if (base_type(reg->type) == PTR_TO_BTF_ID && !(type_flag(reg->type) & ~PTR_UNTRUSTED)) {
 		err = check_ptr_to_btf_access(env, regs, regno, off, size, t,
 					      value_regno);
 	} else if (reg->type == CONST_PTR_TO_MAP) {
@@ -13041,7 +13063,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		if (!ctx_access)
 			continue;
 
-		switch (env->insn_aux_data[i + delta].ptr_type) {
+		switch ((int)env->insn_aux_data[i + delta].ptr_type) {
 		case PTR_TO_CTX:
 			if (!ops->convert_ctx_access)
 				continue;
@@ -13058,6 +13080,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			convert_ctx_access = bpf_xdp_sock_convert_ctx_access;
 			break;
 		case PTR_TO_BTF_ID:
+		case PTR_TO_BTF_ID | PTR_UNTRUSTED:
 			if (type == BPF_READ) {
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
-- 
2.35.1

