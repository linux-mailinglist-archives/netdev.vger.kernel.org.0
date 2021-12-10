Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C2470134
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbhLJNG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241447AbhLJNGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:24 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6CCC0617A1;
        Fri, 10 Dec 2021 05:02:50 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id l18so3332657pgj.9;
        Fri, 10 Dec 2021 05:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0H+SFpDipuPYsh8XkEmXGCZW+0yEheTtzHYQkBTHQ4Q=;
        b=MfXPUxvTqMBGw4hmToa56vi6H1Hxn35eGiSDsBjrrnU2JCZ1VmQvpN5GE3hRo0ZvBI
         +tGhd8VDrS2oizwiU+EUg1bGuuC+XrGILoJw6dXZfZKnitOMhEp3uTSsBoEnN1qzw5Ht
         GSKQl1UmvuqAmGbHA3/1sOBWbknAxOJ6lOPLeCNTHpW4vQUj+gMuSr25KZCcfQiVsaAq
         nTiTSPja6aqttaJopDUGc8ulxteq+ylxZ6feWQPbOzzWEBB8KKEb+GwJnGFHYK4pv97+
         8Ccp+Bebh/QAiuqn8TkTjlZz6FYOr+fZoiNnk0AKUIYN1mzrc/O6lu/FKJGKGop/UKc9
         Blsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0H+SFpDipuPYsh8XkEmXGCZW+0yEheTtzHYQkBTHQ4Q=;
        b=RxJqx+4lxubr14dqCgwJEyCx99+f9qDr2hXOUVs7VpHtjuNhZhByjDCcKQbu4ntGz8
         1zXF8yw8SxwEh2VbeJd9UOAbouK2CD+NmQ0aNsLrb0s/cnSQ//22pNAFYi6LW3AfLJTd
         fwEq9b9EjBRKXXF9LunJ+wcWq1by/RQR0jKESDQ/uqL3PS75N170kKRwPhb6Qp9R/gPK
         1aWvTImy4P9ZWq/rHJkdkWcc4jLx2otWlnbPceIYFg5cHR/6dE6kCcETsmela+Ut7QPU
         BnlTDQh0iKMIS+jKR9XUhJF7iZ/VCGYIpP9KVB3ukZJSkuURNiOz8m8ak+E/0jImkZBV
         8pHg==
X-Gm-Message-State: AOAM532e0HxtIRcjg3S5/YyKPNtm/hXSDpZ6A4/PWhS7gSm81yRpmBV8
        G1SUg3JpYIT8GqKC+KUdD8H7blgzqc0=
X-Google-Smtp-Source: ABdhPJxW1z6wB9J+PLS8YOuk3A1JToW22ZjM1qXDKxcur2IWcRTkkvpDabgkDszyiHkVKr8xpntV2A==
X-Received: by 2002:a62:d44f:0:b0:4ad:999d:2306 with SMTP id u15-20020a62d44f000000b004ad999d2306mr17755521pfl.19.1639141369288;
        Fri, 10 Dec 2021 05:02:49 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id 59sm2881856pjz.34.2021.12.10.05.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:48 -0800 (PST)
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
Subject: [PATCH bpf-next v3 5/9] bpf: Add reference tracking support to kfunc
Date:   Fri, 10 Dec 2021 18:32:26 +0530
Message-Id: <20211210130230.4128676-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11685; h=from:subject; bh=RHz3L3B2ci98scRvg5Gv4lNxHl0BK0yeenPvv4x+mp0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/UNXEpPGm2qsT0NLj2nAqQOEII4HrvaBYrLE8a Q6rwzyCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP1AAKCRBM4MiGSL8Ryjn2D/ 0W3Qcq7B1ssYWC2ianyzQa/4/Bjdu4mixxzpjeIdZg4Tgt2PJfxsT4CdFxPqFY5GSIMPWPaw6KSQ5m LSwItxqfHCCp6xzvGRZ/pkuLd44/F8j9iJuMVwnIRpPW41JACtbBI3EoUPn43UTgONeJUYBLcvfP8U m0pOJrZX3YGvZoOi79h7toImvfbI8zcE9q1bYwrIl0i86yun3mQrdEnJqt4cVaNBLE/fYClBL1P0ST +L++vOD6Ka+fOLsFgz7QYXQdAt0Is1fOD1bS42zLaRkxK5DU48t8nE8JInzmm7rN5XW7tKdQL7+Fpp 1esVOdfwDjVcZT9ROUoeT9SCfUXt821veu+HBegGfZotjQZ2Sd+sYhMdTRrS30Bzh94rZxsGF15AsQ KPsNCOKPm2AXT1Ge2g2NA3XkOTs++C2LZtPDUy/VMXHt3ezDAJqntiUvOt/dnOdCtGImOtAY8qcs7U huMeFW10w5mFCdTMuTGOT+a2I9a7hAcpFgnIEU7zANDftePV4nlRMveE64fe5+vsptgJMCr4Oi3QIH gVv5blueXZb/0N3PvnYkQ+xq7eUuKO0p9t1dvW1577sz2K1LSU7tuUzlsSm1CQjKy9IR1WZtzLMG0/ 5CTVaxp0Q+c4BnT/7RS/QxSaEZyjIawflJw1Yz9JgM9w8RUnLnGKZziX2J2A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds verifier support for PTR_TO_BTF_ID return type of kfunc
to be a reference, by reusing acquire_reference_state/release_reference
support for existing in-kernel bpf helpers.

Verifier ops struct is extended with three callbacks:

- is_acquire_kfunc
  Return true if kfunc_btf_id, module pair is an acquire kfunc.  This
  will acquire_reference_state for the returned PTR_TO_BTF_ID (this is
  the only allow return value). Note that acquire kfunc must always
  return a PTR_TO_BTF_ID{_OR_NULL}, otherwise the program is rejected.

- is_release_kfunc
  Return true if kfunc_btf_id, module pair is a release kfunc.  This
  will release the reference to the passed in PTR_TO_BTF_ID which has a
  reference state (from earlier acquire kfunc).
  The btf_check_func_arg_match returns the regno (of argument register,
  hence > 0) if the kfunc is a release kfunc, and a proper referenced
  PTR_TO_BTF_ID is being passed to it.
  This is similar to how helper call check uses bpf_call_arg_meta to
  store the ref_obj_id that is later used to release the reference.
  Similar to in-kernel helper, we only allow passing one referenced
  PTR_TO_BTF_ID as an argument. It can also be passed in to normal
  kfunc, but in case of release kfunc there must always be one
  PTR_TO_BTF_ID argument that is referenced.

- is_kfunc_ret_type_null
  For kfunc returning PTR_TO_BTF_ID, tells if it can be NULL, hence
  force caller to mark the pointer not null (using check) before
  accessing it. Note that taking into account the case fixed by commit
  93c230e3f5bd6, we assign a non-zero id for mark_ptr_or_null_reg logic.
  Later, if more return types are supported by kfunc, which have a
  _OR_NULL variant, it might be better to move this id generation under
  a common reg_type_may_be_null check, similar to the case in the
  commit.

Later patches will implement these callbacks.

Referenced PTR_TO_BTF_ID is currently only limited to kfunc, but can be
extended in the future to other BPF helpers as well.  For now, we can
rely on the btf_struct_ids_match check to ensure we get the pointer to
the expected struct type. In the future, care needs to be taken to avoid
ambiguity for reference PTR_TO_BTF_ID passed to release function, in
case multiple candidates can release same BTF ID.

e.g. there might be two release kfuncs (or kfunc and helper):

foo(struct abc *p);
bar(struct abc *p);

... such that both release a PTR_TO_BTF_ID with btf_id of struct abc. In
this case we would need to track the acquire function corresponding to
the release function to avoid type confusion, and store this information
in the register state so that an incorrect program can be rejected. This
is not a problem right now, hence it is left as an exercise for the
future patch introducing such a case in the kernel.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  6 ++++-
 kernel/bpf/btf.c      | 42 ++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 54 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8bbf08fbab66..6a14072c72a0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -521,6 +521,9 @@ struct bpf_verifier_ops {
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
 	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
@@ -1717,7 +1720,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
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
index df9a3f77fc4a..a790ba6d93d8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5640,14 +5640,17 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
-				    bool ptr_to_mem_ok)
+				    bool ptr_to_mem_ok,
+				    struct module *btf_mod)
 {
 	struct bpf_verifier_log *log = &env->log;
+	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
-	u32 i, nargs, ref_id;
+	int ref_regno = 0;
+	bool rel = false;
 
 	t = btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
@@ -5725,6 +5728,16 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
+				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
+				if (reg->ref_obj_id) {
+					if (ref_obj_id) {
+						bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
+							regno, reg->ref_obj_id, ref_obj_id);
+						return -EFAULT;
+					}
+					ref_regno = regno;
+					ref_obj_id = reg->ref_obj_id;
+				}
 			} else {
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[reg->type];
@@ -5794,7 +5807,23 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		}
 	}
 
-	return 0;
+	/* Either both are set, or neither */
+	WARN_ON_ONCE((ref_obj_id && !ref_regno) || (!ref_obj_id && ref_regno));
+	if (is_kfunc) {
+		rel = env->ops->is_release_kfunc &&
+			env->ops->is_release_kfunc(func_id, btf_mod);
+		/* We already made sure ref_obj_id is set only for one argument */
+		if (rel && !ref_obj_id) {
+			bpf_log(log, "release kernel function %s expects refcounted PTR_TO_BTF_ID\n",
+				func_name);
+			return -EINVAL;
+		}
+		/* Allow (!rel && ref_obj_id), so that passing such referenced PTR_TO_BTF_ID to
+		 * other kfuncs works
+		 */
+	}
+	/* returns argument register number > 0 in case of reference release kfunc */
+	return rel ? ref_regno : 0;
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
@@ -5824,7 +5853,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -5837,9 +5866,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs)
+			      struct bpf_reg_state *regs,
+			      struct module *btf_mod)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, true);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true, btf_mod);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 074a78a0efa4..b8685fb7ff15 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -466,7 +466,9 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
-		type == PTR_TO_MEM_OR_NULL;
+		type == PTR_TO_MEM_OR_NULL ||
+		type == PTR_TO_BTF_ID ||
+		type == PTR_TO_BTF_ID_OR_NULL;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -6753,16 +6755,18 @@ static void mark_btf_func_reg_size(struct bpf_verifier_env *env, u32 regno,
 	}
 }
 
-static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
+static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
+			    int *insn_idx_p)
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
+	int err, insn_idx = *insn_idx_p;
 	struct module *btf_mod = NULL;
 	const struct btf_param *args;
 	struct btf *desc_btf;
-	int err;
+	bool acq;
 
 	/* skip for now, but return error when we find this in fixup_kfunc_call */
 	if (!insn->imm)
@@ -6784,16 +6788,37 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return -EACCES;
 	}
 
+	/* Is this an acquire kfunc? */
+	acq = env->ops->is_acquire_kfunc &&
+		env->ops->is_acquire_kfunc(func_id, btf_mod);
+
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
-	if (err)
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, btf_mod);
+	if (err < 0)
 		return err;
+	/* In case of release function, we get register number of refcounted
+	 * PTR_TO_BTF_ID back from btf_check_kfunc_arg_match, do the release now
+	 */
+	if (err) {
+		err = release_reference(env, regs[err].ref_obj_id);
+		if (err) {
+			verbose(env, "kfunc %s#%d reference has not been acquired before\n",
+				func_name, func_id);
+			return err;
+		}
+	}
 
 	for (i = 0; i < CALLER_SAVED_REGS; i++)
 		mark_reg_not_init(env, regs, caller_saved[i]);
 
 	/* Check return type */
 	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
+
+	if (acq && !btf_type_is_ptr(t)) {
+		verbose(env, "acquire kernel function does not return PTR_TO_BTF_ID\n");
+		return -EINVAL;
+	}
+
 	if (btf_type_is_scalar(t)) {
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
@@ -6808,11 +6833,26 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				ptr_type_name);
 			return -EINVAL;
 		}
+		if (env->ops->is_kfunc_ret_type_null &&
+		    env->ops->is_kfunc_ret_type_null(func_id, btf_mod)) {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
+			/* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
+			regs[BPF_REG_0].id = ++env->id_gen;
+		} else {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].btf = desc_btf;
-		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
+		if (acq) {
+			int id = acquire_reference_state(env, insn_idx);
+
+			if (id < 0)
+				return id;
+			regs[BPF_REG_0].id = id;
+			regs[BPF_REG_0].ref_obj_id = id;
+		}
 	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
 
 	nargs = btf_type_vlen(func_proto);
@@ -11457,7 +11497,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (insn->src_reg == BPF_PSEUDO_CALL)
 					err = check_func_call(env, insn, &env->insn_idx);
 				else if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
-					err = check_kfunc_call(env, insn);
+					err = check_kfunc_call(env, insn, &env->insn_idx);
 				else
 					err = check_helper_call(env, insn, &env->insn_idx);
 				if (err)
-- 
2.34.1

