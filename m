Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5746F10F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbhLIRNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242523AbhLIRNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:19 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8717EC061A32;
        Thu,  9 Dec 2021 09:09:45 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id v19so4360775plo.7;
        Thu, 09 Dec 2021 09:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMPN5NboE7ttVzSw8Pr3McAJ1fVnDFUlXm6XcH4nmOc=;
        b=PlR+yfHLiuXIrbw2YFHnh2TT5s0VtS+xlUn+Dhe/v+hGHZxEXFbszTXr4tQOPxAdDT
         fDeKHqtC6Qar1fzUCgvfGXhjnfPYEtdPA1HDvKennsoj0jkf9j3r+4d2wumAOHuYepKe
         OJIE8AbCSJuGLWNpWynZafjFaZnUv17UetOedWQNEbbIiZBryUV9tojwReZXDnv0bgZK
         l8E/7LsDuU6Ob4xATZwmMUslHPhdnFG90KdRZL7sNUmvYhwO/B3cGvH/ehV2bmfswE2d
         1HIYmuoOqcku0hkOOqSkBHVxx3QvYsjFWlMHZGlxHmYx1RqMr5A50fbfKvTbR0Lp5q2j
         qjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMPN5NboE7ttVzSw8Pr3McAJ1fVnDFUlXm6XcH4nmOc=;
        b=pxVQNFPKIuueaxEXqAdaUQaX/xOULvVGFUCvrYkZjyZ6d6iiJVosyCCodTp8n3JfiU
         vWdzkBK0lFteVIjVIHevCQSpgyQosTbDndDG7uf+0K2b1d5CBlyYsUahB8/LE185ik96
         +SeFp7bygz8SySq+spu7f+hkSwnkRj/8MBXQwaZ2K1WZNI9BRGc4Zv8iH59riu7Q5nYw
         XO+L0evRBtSffunc5yo7v8WLzAO6Hb9wpRuu6PMf2xZSBQlPlRhRpr+omD9wAg0rJfID
         01COXbbdhIDNEbG2XGkeFBgJojxnDSZ5hHzoZ+La+WQsSoXFBYQm3CVHrGgQbs5X1WHk
         hluA==
X-Gm-Message-State: AOAM532RUEdKy1Oh0H/Phv6Ki3e+MWwwJZzOiSU3Gi74vr3VI71KWVtt
        AgxpQ6jfktnyEEiFOnMa2T+kfYM+xPA=
X-Google-Smtp-Source: ABdhPJxi0b9Fxa53rOWoZLfikephnCUfVsWMdVC1jqeAtT0WpQmyRlNXZf5+lgbW0b+efT+KD+12mg==
X-Received: by 2002:a17:902:c086:b0:142:7169:1573 with SMTP id j6-20020a170902c08600b0014271691573mr68510204pld.13.1639069784816;
        Thu, 09 Dec 2021 09:09:44 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id u3sm295705pfk.32.2021.12.09.09.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:44 -0800 (PST)
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
Subject: [PATCH bpf-next v2 4/9] bpf: Introduce mem, size argument pair support for kfunc
Date:   Thu,  9 Dec 2021 22:39:24 +0530
Message-Id: <20211209170929.3485242-5-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9574; h=from:subject; bh=k00q37zj6ANMSDLKtBZN55/lRGZxiN877CI3cU7NYxM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgHinhv4Q9gIHGgqdJiA+ziYYihlPec5k+OwtZY IK9Lvh+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8Rygj9D/ 9y00PUJyIFtFz4s0q+phF4Y6poAjBcrsMgYWKvWTd4bDisj8dpgsxc/MFLNC+2pNa1BoQtGeVNoy33 cF8uqtqkuvfwD1LxqAL11X5MSZFkFk19PyUFThDGlcp/YaSUirPTXNQcgnYkE5MEsiwzmNyrOmwLw0 HB/wCwo18f4dwDJSYgPWE7Lp55znTUALVKffoxb/LSFeUPDdtJ8WZTYZ3RjvVxwOvAQ7Wv0EaYYrEO V0Cg0NA3KKcELleU/+YYsXoZeYgDx5fDU+Rcgxc64ueOmB6E66uGoCPD5SkZ5YcMKgKIIJBIDdTjag OWo9n8uLE7Uufja4m5cdj4RVPHoYTeyGO6QjInPJcyd22ywHRtkGHG8R6QXH124QPIuiKvxJIK4vJv 7Kz9aGCCqPAivWhd9MjeSnWsol5kuHCu+tbKSvC14c5MKUJ7UMLsh8jfxzwtHY81iC+B0akPAtBcXE HpbIiLG/SUz+dsZv/KTtEf7ai92k/Exisr8UcHEtzviQQdvzZBj5CS78fKhAHZOm30Dq+AvAfwaQhG v0J9NrwCz7tmhQ2uu6TKf5R/wwzRuJHPki8r74kjDImAVOkEimkhy41ECb1YnjMIs4D+5VXDJ0G4LJ TAjUu01YsAZbXh9huEGSN6zsy9JoSXG3Ef6Q2BgfBkKwzauVFbJqDNQ22g8g==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF helpers can associate two adjacent arguments together to pass memory
of certain size, using ARG_PTR_TO_MEM and ARG_CONST_SIZE arguments.
Since we don't use bpf_func_proto for kfunc, we need to leverage BTF to
implement similar support.

The ARG_CONST_SIZE processing for helpers is refactored into a common
check_mem_size_reg helper that is shared with kfunc as well. kfunc
ptr_to_mem support follows logic similar to global functions, where
verification is done as if pointer is not null, even when it may be
null.

This leads to a simple to follow rule for writing kfunc: always check
the argument pointer for NULL, except when it is PTR_TO_CTX.

Currently, we require the size argument to be prefixed with "len__" in
the parameter name. This information is then recorded in kernel BTF and
verified during function argument checking. In the future we can use BTF
tagging instead, and modify the kernel function definitions. This will
be a purely kernel-side change.

This allows us to have some form of backwards compatibility for
structures that are passed in to the kernel function with their size,
and allow variable length structures to be passed in if they are
accompanied by a size parameter.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf_verifier.h |   2 +
 kernel/bpf/btf.c             |  41 +++++++++++-
 kernel/bpf/verifier.c        | 124 ++++++++++++++++++++++-------------
 3 files changed, 119 insertions(+), 48 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 182b16a91084..b80fe5bf2a02 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -507,6 +507,8 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
 
 int check_ctx_reg(struct bpf_verifier_env *env,
 		  const struct bpf_reg_state *reg, int regno);
+int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
+			     u32 regno);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 63b22ff73550..df9a3f77fc4a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5618,6 +5618,25 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
 	return true;
 }
 
+static bool is_kfunc_arg_mem_size(const struct btf *btf,
+				  const struct btf_param *arg,
+				  const struct bpf_reg_state *reg)
+{
+	const struct btf_type *t;
+	const char *param_name;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	/* In the future, this can be ported to use BTF tagging */
+	param_name = btf_name_by_offset(btf, arg->name_off);
+	if (strncmp(param_name, "len__", sizeof("len__") - 1))
+		return false;
+
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
@@ -5729,16 +5748,32 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			u32 type_size;
 
 			if (is_kfunc) {
+				bool arg_mem_size = i + 1 < nargs && is_kfunc_arg_mem_size(btf, &args[i + 1], &regs[regno + 1]);
+
 				/* Permit pointer to mem, but only when argument
 				 * type is pointer to scalar, or struct composed
 				 * (recursively) of scalars.
+				 * When arg_mem_size is true, the pointer can be
+				 * void *.
 				 */
-				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0)) {
+				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0) &&
+				    (arg_mem_size ? !btf_type_is_void(ref_t) : 1)) {
 					bpf_log(log,
-						"arg#%d pointer type %s %s must point to scalar or struct with scalar\n",
-						i, btf_type_str(ref_t), ref_tname);
+						"arg#%d pointer type %s %s must point to %sscalar, or struct with scalar\n",
+						i, btf_type_str(ref_t), ref_tname, arg_mem_size ? "void, " : "");
 					return -EINVAL;
 				}
+
+				/* Check for mem, len pair */
+				if (arg_mem_size) {
+					if (check_kfunc_mem_size_reg(env, &regs[regno + 1], regno + 1)) {
+						bpf_log(log, "arg#%d arg#%d memory, len pair leads to invalid memory access\n",
+							i, i + 1);
+						return -EINVAL;
+					}
+					i++;
+					continue;
+				}
 			}
 
 			resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1126b75fe650..074a78a0efa4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4780,6 +4780,62 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 	}
 }
 
+static int check_mem_size_reg(struct bpf_verifier_env *env,
+			      struct bpf_reg_state *reg, u32 regno,
+			      bool zero_size_allowed,
+			      struct bpf_call_arg_meta *meta)
+{
+	int err;
+
+	/* This is used to refine r0 return value bounds for helpers
+	 * that enforce this value as an upper bound on return values.
+	 * See do_refine_retval_range() for helpers that can refine
+	 * the return value. C type of helper is u32 so we pull register
+	 * bound from umax_value however, if negative verifier errors
+	 * out. Only upper bounds can be learned because retval is an
+	 * int type and negative retvals are allowed.
+	 */
+	if (meta)
+		meta->msize_max_value = reg->umax_value;
+
+	/* The register is SCALAR_VALUE; the access check
+	 * happens using its boundaries.
+	 */
+	if (!tnum_is_const(reg->var_off))
+		/* For unprivileged variable accesses, disable raw
+		 * mode so that the program is required to
+		 * initialize all the memory that the helper could
+		 * just partially fill up.
+		 */
+		meta = NULL;
+
+	if (reg->smin_value < 0) {
+		verbose(env, "R%d min value is negative, either use unsigned or 'var &= const'\n",
+			regno);
+		return -EACCES;
+	}
+
+	if (reg->umin_value == 0) {
+		err = check_helper_mem_access(env, regno - 1, 0,
+					      zero_size_allowed,
+					      meta);
+		if (err)
+			return err;
+	}
+
+	if (reg->umax_value >= BPF_MAX_VAR_SIZ) {
+		verbose(env, "R%d unbounded memory access, use 'var &= const' or 'if (var < const)'\n",
+			regno);
+		return -EACCES;
+	}
+	err = check_helper_mem_access(env, regno - 1,
+				      reg->umax_value,
+				      zero_size_allowed, meta);
+	if (!err)
+		err = mark_chain_precision(env, regno);
+	return err;
+}
+
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size)
 {
@@ -4803,6 +4859,28 @@ int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 	return check_helper_mem_access(env, regno, mem_size, true, NULL);
 }
 
+int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
+			     u32 regno)
+{
+	struct bpf_reg_state *mem_reg = &cur_regs(env)[regno - 1];
+	bool may_be_null = reg_type_may_be_null(mem_reg->type);
+	struct bpf_reg_state saved_reg;
+	int err;
+
+	WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
+
+	if (may_be_null) {
+		saved_reg = *mem_reg;
+		mark_ptr_not_null_reg(mem_reg);
+	}
+
+	err = check_mem_size_reg(env, reg, regno, true, NULL);
+
+	if (may_be_null)
+		*mem_reg = saved_reg;
+	return err;
+}
+
 /* Implementation details:
  * bpf_map_lookup returns PTR_TO_MAP_VALUE_OR_NULL
  * Two bpf_map_lookups (even with the same key) will have different reg->id.
@@ -5316,51 +5394,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
-		/* This is used to refine r0 return value bounds for helpers
-		 * that enforce this value as an upper bound on return values.
-		 * See do_refine_retval_range() for helpers that can refine
-		 * the return value. C type of helper is u32 so we pull register
-		 * bound from umax_value however, if negative verifier errors
-		 * out. Only upper bounds can be learned because retval is an
-		 * int type and negative retvals are allowed.
-		 */
-		meta->msize_max_value = reg->umax_value;
-
-		/* The register is SCALAR_VALUE; the access check
-		 * happens using its boundaries.
-		 */
-		if (!tnum_is_const(reg->var_off))
-			/* For unprivileged variable accesses, disable raw
-			 * mode so that the program is required to
-			 * initialize all the memory that the helper could
-			 * just partially fill up.
-			 */
-			meta = NULL;
-
-		if (reg->smin_value < 0) {
-			verbose(env, "R%d min value is negative, either use unsigned or 'var &= const'\n",
-				regno);
-			return -EACCES;
-		}
-
-		if (reg->umin_value == 0) {
-			err = check_helper_mem_access(env, regno - 1, 0,
-						      zero_size_allowed,
-						      meta);
-			if (err)
-				return err;
-		}
-
-		if (reg->umax_value >= BPF_MAX_VAR_SIZ) {
-			verbose(env, "R%d unbounded memory access, use 'var &= const' or 'if (var < const)'\n",
-				regno);
-			return -EACCES;
-		}
-		err = check_helper_mem_access(env, regno - 1,
-					      reg->umax_value,
-					      zero_size_allowed, meta);
-		if (!err)
-			err = mark_chain_precision(env, regno);
+		err = check_mem_size_reg(env, reg, regno, zero_size_allowed, meta);
 	} else if (arg_type_is_alloc_size(arg_type)) {
 		if (!tnum_is_const(reg->var_off)) {
 			verbose(env, "R%d is not a known constant'\n",
-- 
2.34.1

