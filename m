Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AFB4409B1
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhJ3Osw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhJ3Osv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:48:51 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BC6C061570;
        Sat, 30 Oct 2021 07:46:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n23so2102491pgh.8;
        Sat, 30 Oct 2021 07:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xzj3JZ3QmAJDLjL71cYc0mgBwKbbEBtcTkhduwsniY4=;
        b=QgWMXhjZgbYg8KKCLL1ifUUlrIwboKm/cPFFPIgKg76uo54w8pOpHA2nngLrzqBVg6
         Dj49AvfddsP1m0f6THSUWbRVieBaYV/NFIYs/Frgv+5dHeL0mcT2CU5VL2k3KULpv4ff
         kZ3TnmOt/CtkBk63rBow/Ss/b6dGsgdOkBeqEZAP0/a8qJnkE0KZ7Us9w4ahVhMgWqBv
         80HzEPRHj8V+tv14+2Av5nxnPUs5BHHwrfrdJlyWJgVBE7hA7+p8aBrCOMxsA4gw+HEM
         QAKn3GxdvYBY+PlSeBTS3k3xG3Ph8cdhr5ghM2xHytMNmI4tVJAb6hjQrdyEipuQZWEa
         73YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xzj3JZ3QmAJDLjL71cYc0mgBwKbbEBtcTkhduwsniY4=;
        b=uOB+ygd9tBcR0lIZtP73IgPL7M3hRgz2vxyX8e14u1PZGMdZhZkTDsXIt8EOw5yhTV
         ipPbnaWIakyxvdbuVGHmFRtYigXI3sKP2aSucVxsn2+cHnxR9Ua+xuRVaMAtTGGG1c5A
         18OgZSH/ID0Ypv0EOf+0Z0BpTNStV1Csm3+T9zptHR6oVbGxWffaxLHymJdH6dZ/0wfl
         4plzQzwfgJWHBDIb7lzwYoROQADvYG4wsErtWHJ1r/GhUq23WhIoBaVxeWlMLaA1VjF7
         /bfTBWWMXQvXbKtOFWOMO5SiAcz6T6NyRSxgIMfJ7cyBTqyyI2ZO2RwVlWE9pS7wqdK/
         XRTw==
X-Gm-Message-State: AOAM533r2iKWDAR3L6nl9xfe8xzjv4yQcGbuqGGMZTxGoBJP5hIvn6a1
        jdIucRr9ltpfmva4iYWlxCxl4mPG5LbuKA==
X-Google-Smtp-Source: ABdhPJwtKQX+80D6Jyv83Y21ScBFklAk7+6vYTJQWlvn1PpUqaiM6+qxca0BT8LqF9Edv069/xjV+A==
X-Received: by 2002:a05:6a00:15d0:b0:47c:30f0:7fee with SMTP id o16-20020a056a0015d000b0047c30f07feemr17468047pfu.45.1635605180891;
        Sat, 30 Oct 2021 07:46:20 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id a10sm8346767pgw.25.2021.10.30.07.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:46:20 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH RFC bpf-next v1 3/6] bpf: Extend kfunc with PTR_TO_CTX and PTR_TO_MEM arguments
Date:   Sat, 30 Oct 2021 20:16:06 +0530
Message-Id: <20211030144609.263572-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211030144609.263572-1-memxor@gmail.com>
References: <20211030144609.263572-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6340; h=from:subject; bh=oEvZsgMsBOncGMW6GqXX+B/HA0OEhUGGfzcrnVXiCiw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhfVoR950gnubdX0pjB3YcqK48hN+VJjkMtRsZC2gI r8YhNqKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYX1aEQAKCRBM4MiGSL8RyjxaD/ 44tZQDostolgebGDN0bNo0r4rlZR2wmTzWJANfpd02lFa9ylG4tr7X6aNepIyeE94tjyzNrbjsVPcW ZUyZLLcdFs/BYu1gIr0TzOlWu7wEOaa64k44L3dJeCqSjTIEcjYSPyGyJarUNkBnYxUN2wkWmyfY0c YTlWd/WfT4+bYYNaSK9a1E8zGisXOVb+8WJM43AN8RSFZtrNyJTBx7NDRPSiui3pPkXEyhHTsUTta/ eL+RjcoQn28NVoaUjSVXBo8EobdxqxmvvjFMn3mXSMgB0B8Ab72sl+QU+3jaAyevTX1ulTpDLeDRxU G6PnAiqL5w3aLStnO8QDD7ANtPS76pUZy/zBmqojBk274b4nJv6hJztTouQ5pCEOK03LbqzGTZehpN /Jk3ICuczazYu+d6UoAFtAuskvP/d8EDjV46F0m62M8+MyW6dt0bZPad2RjmuU1TwpL65ogXSogULi 6/Ea9038r/5Kc4XzZ/qBOlOjVDlVDLcAbv8LL75PcZ83K8B49wpsSPHVpi6S+nAk/+FR0nGiQOUgmV u9Vzdaga09Ur0jVK19GdUmkRjwH7DlfOO6aWDYr5EzSxKGgZH4pJCbg1tL1wQQO+TcyFyJBgVQNh4s DCw5h0toN+P3ME09OW2RAZs+BveoXnWKzSe6hKKfCmb9g2IzlA6SRYm30FNg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow passing PTR_TO_CTX, if the kfunc expects a matching struct type,
and punt to ptr_to_mem block if reg->type does not fall in one BTF ID
types. This will be used by future commits to get access to XDP and TC
PTR_TO_CTX.

Also add a btf_mod module parameter, so that the kfunc_id's owner module
can be used in future commit adding reference tracking for
PTR_TO_BTF_ID.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  3 ++-
 kernel/bpf/btf.c      | 61 +++++++++++++++++++++----------------------
 kernel/bpf/verifier.c |  4 +--
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6deebf8bf78f..f8be80f748fc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1665,7 +1665,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 				struct bpf_reg_state *regs);
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs);
+			      struct bpf_reg_state *regs,
+			      struct module *btf_mod);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
 int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1773f91fff10..9099ef64b077 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5566,7 +5566,8 @@ static u32 *reg2btf_ids[__BPF_REG_TYPE_MAX] = {
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
-				    bool ptr_to_mem_ok)
+				    bool ptr_to_mem_ok,
+				    struct module *btf_mod)
 {
 	struct bpf_verifier_log *log = &env->log;
 	const char *func_name, *ref_tname;
@@ -5602,8 +5603,10 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 	 * verifier sees.
 	 */
 	for (i = 0; i < nargs; i++) {
+		const struct btf_type *resolve_ret;
 		u32 regno = i + 1;
 		struct bpf_reg_state *reg = &regs[regno];
+		u32 type_size;
 
 		t = btf_type_skip_modifiers(btf, args[i].type, NULL);
 		if (btf_type_is_scalar(t)) {
@@ -5621,19 +5624,25 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
-		if (btf_is_kernel(btf)) {
+		if (btf_get_prog_ctx_type(log, btf, t,
+					  env->prog->type, i)) {
+			/* If function expects ctx type in BTF check that caller
+			 * is passing PTR_TO_CTX.
+			 */
+			if (reg->type != PTR_TO_CTX) {
+				bpf_log(log,
+					"arg#%d expected pointer to ctx, but got %s\n",
+					i, btf_type_str(t));
+				return -EINVAL;
+			}
+			if (check_ctx_reg(env, reg, regno))
+				return -EINVAL;
+		} else if (btf_is_kernel(btf)) {
 			const struct btf_type *reg_ref_t;
 			const struct btf *reg_btf;
 			const char *reg_ref_tname;
 			u32 reg_ref_id;
 
-			if (!btf_type_is_struct(ref_t)) {
-				bpf_log(log, "kernel function %s args#%d pointer type %s %s is not supported\n",
-					func_name, i, btf_type_str(ref_t),
-					ref_tname);
-				return -EINVAL;
-			}
-
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
@@ -5641,9 +5650,13 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[reg->type];
 			} else {
-				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s but R%d is not a pointer to btf_id\n",
-					func_name, i,
-					btf_type_str(ref_t), ref_tname, regno);
+				goto ptr_to_mem;
+			}
+
+			if (!btf_type_is_struct(ref_t)) {
+				bpf_log(log, "kernel function %s args#%d pointer type %s %s is not supported\n",
+					func_name, i, btf_type_str(ref_t),
+					ref_tname);
 				return -EINVAL;
 			}
 
@@ -5660,23 +5673,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 					reg_ref_tname);
 				return -EINVAL;
 			}
-		} else if (btf_get_prog_ctx_type(log, btf, t,
-						 env->prog->type, i)) {
-			/* If function expects ctx type in BTF check that caller
-			 * is passing PTR_TO_CTX.
-			 */
-			if (reg->type != PTR_TO_CTX) {
-				bpf_log(log,
-					"arg#%d expected pointer to ctx, but got %s\n",
-					i, btf_type_str(t));
-				return -EINVAL;
-			}
-			if (check_ctx_reg(env, reg, regno))
-				return -EINVAL;
 		} else if (ptr_to_mem_ok) {
-			const struct btf_type *resolve_ret;
-			u32 type_size;
-
+ptr_to_mem:
 			resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
 			if (IS_ERR(resolve_ret)) {
 				bpf_log(log,
@@ -5723,7 +5721,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -5736,9 +5734,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs)
+			      struct bpf_reg_state *regs,
+			      struct module *btf_mod)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, false);
+	return btf_check_func_arg_match(env, btf, func_id, regs, false, btf_mod);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c8aa7df1773..ca4627f81b75 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6713,8 +6713,8 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	}
 
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
-	if (err)
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, btf_mod);
+	if (err < 0)
 		return err;
 
 	for (i = 0; i < CALLER_SAVED_REGS; i++)
-- 
2.33.1

