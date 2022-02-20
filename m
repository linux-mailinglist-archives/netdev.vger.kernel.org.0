Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A04BCEAB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243888AbiBTNtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiBTNsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:54 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E14E2D1EA;
        Sun, 20 Feb 2022 05:48:32 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id m1-20020a17090a668100b001bc023c6f34so2660062pjj.3;
        Sun, 20 Feb 2022 05:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=le4LIxEm3r82lu6hJpPIFi0Z4KJGRcY5KDu3riF/uWI=;
        b=FLTk51NkcubhThZoBeGCRC/yBW+JAJHZF3/lQvXmhPNHeMdJDeNuteSVjtR50cG9Ve
         BQjh6n4reZ1gKjr4gzkYzX6dbc/x3yfJNITspAFXWnk4mTGfW9qUjmXmmPPr9+T4q+dx
         0YyA8dkem3PIGsCxdNzQwka9jq+XhY8/mlrMWddBZYQaONzO9mNIlURgB0H/lcJSLg97
         6n/VSCN85SJOeKEEIllx75ubueDbKvhGYFcPzFca2w5+j1PBWy6S2iLTKibsgTKrjU7y
         R4ivFiQlNdqg7nS7UErOi2SyInBlR8xLkWJkfGaWVnGD92FhWsFKDv/APv8NNdoV98Vc
         0jQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=le4LIxEm3r82lu6hJpPIFi0Z4KJGRcY5KDu3riF/uWI=;
        b=4+eQlpagsnuKCs8N8elTX3fPZbqvCkUQXI8ByA60jYVjrwShjO6QQ8WAPtOO4ENaaF
         c/1p5AF09NMc6WFn/aYGjpvDhP5gS4y/rt1aX1BVCL/VyEHKsc06toEOVjAreUTMjlGW
         ZMvdRyjasAp/bpvpjxskCcOVyLVFnOFbbhrRejTqRfRlAMvIT6ibcgD7bWLE3FBhKc8k
         8oqIWEL6xzfznmanVxY6j24lJPQjVjiqZM32u1L4YLW2xwPmraCvMpMz8aeP3DD6Zcqk
         TBlPWihi4ySsU1MXYJqtN4VcrgQFC0O312+meRx4HSiRlD5ocIsQ7xhEJuWl59OA3XeP
         6MuA==
X-Gm-Message-State: AOAM532guvcLSTgKMiKI13xOYgcP/yHKKzwOfSImT3J/3HC1JU1oyvrG
        l0ejuzwmsFq4Q17fDdXMq491kayNSWc=
X-Google-Smtp-Source: ABdhPJz6wfKXAihBFvMHy5nDZ3ylshSNW228U4y465R/Mp0DZs9vIJD8z2IAzL7emyi5HNXRCWw1nQ==
X-Received: by 2002:a17:902:b701:b0:14d:b457:e506 with SMTP id d1-20020a170902b70100b0014db457e506mr15085464pls.32.1645364911953;
        Sun, 20 Feb 2022 05:48:31 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id c20sm1137425pfl.131.2022.02.20.05.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:31 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Hao Luo <haoluo@google.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 05/15] bpf: Allow storing PTR_TO_PERCPU_BTF_ID in map
Date:   Sun, 20 Feb 2022 19:18:03 +0530
Message-Id: <20220220134813.3411982-6-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7909; h=from:subject; bh=mX65qkyAv1vHKbst+MgKHGZ+AuS+wXKig4npj53xi00=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXBVGDFD789R/fe7Q/K3EyQLh7xNIUGlE0moqg m7v1KbqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RyppqD/ 9bSYN2FPBZDa4dBU4dx5B6GFJaaKRC9/g0ovDxrOSLZbO+5a7ocJypUyCARDgHZlxgtgqrTuNAYDl7 GAN9PQx6E3DzTLMalQk5+kBwUSXJWgaZuci2OaTh/EmFS9lvNZRd5zAFeSoyx8Ff4Or1oIVxYFHa29 2QotkqzVdAsF6f0gNR04kXr5/sjxbDs+PWAy1X21b6llUvF0zUCArE1eB7WyqipBaFHtNE9bjw0aua ADwnfqkfdJIQR/R2YZmBUUjTDnvXuzexN7Ab2ONrhh5QzdND2k3SVgJDsMyLinYVJr5m6kabWtHgN6 es96bAxaJsa+RzO8YgYo1tA48GPXhG8z9UDoBFZsZPb7SHO62iuYMKWUFmcQkF2gesN3mhULa1G7tL xOzisaZNRND29ewYTakKnQLVk6GVlVQkZpWVPKbGg1S7/aoKgJ85oKr7qB59rfdMH0jKlyjiNSin59 mbalug/0Bf8iPyV94ZSdYE2w+cI99IPCJWStpoxtQbciiHSE8745BD9zwo0iCsIPuUZ4FYKA5dNu6P FiBEblXE5yaLCnjs4IuIs2HHq/I8f0m8pDoSZg59db565ZTOGa9fAPL1QZZus4eB9UCjd2vncfA3aD CtkSsfNdi5Nk5B2Wi5TeBIbtOOi1x5VF01MOfhhj5o8nCj3UFvZCwnAHP8Eg==
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

Make adjustments to the code to allow storing PTR_TO_PERCPU_BTF_ID in a
map. Note that these are not yet supported as referenced pointers, so
that is explicitly disallowed during BTF tag parsing. Similar to 'ref'
tag, a new 'percpu' tag composes with 'btf_id' tag on the pointed to
type to hint that it is a percpu btf_id pointer.

Cc: Hao Luo <haoluo@google.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  3 ++-
 kernel/bpf/btf.c      | 27 ++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 37 ++++++++++++++++++++++++++++---------
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 923b9f36c275..843c8c01cf9d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -161,7 +161,8 @@ enum {
 };
 
 enum {
-	BPF_MAP_VALUE_OFF_F_REF = (1U << 0),
+	BPF_MAP_VALUE_OFF_F_REF    = (1U << 0),
+	BPF_MAP_VALUE_OFF_F_PERCPU = (1U << 1),
 };
 
 struct bpf_map_value_off_desc {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 20124f4a421c..eb57584ee0a8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3146,12 +3146,12 @@ static s32 btf_find_by_name_kind_all(const char *name, u32 kind, struct btf **bt
 static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 			       u32 off, int sz, void *data)
 {
-	bool btf_id_tag = false, ref_tag = false;
+	bool btf_id_tag = false, ref_tag = false, percpu_tag = false;
 	struct bpf_map_value_off *tab;
 	struct bpf_map *map = data;
+	int nr_off, ret, flags = 0;
 	struct module *mod = NULL;
 	struct btf *kernel_btf;
-	int nr_off, ret;
 	s32 id;
 
 	/* For PTR, sz is always == 8 */
@@ -3174,6 +3174,13 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 				goto end;
 			}
 			ref_tag = true;
+		} else if (!strcmp("kernel.bpf.percpu", __btf_name_by_offset(btf, t->name_off))) {
+			/* repeated tag */
+			if (percpu_tag) {
+				ret = -EINVAL;
+				goto end;
+			}
+			percpu_tag = true;
 		} else if (!strncmp("kernel.", __btf_name_by_offset(btf, t->name_off),
 			   sizeof("kernel.") - 1)) {
 			/* TODO: Should we reject these when loading BTF? */
@@ -3185,13 +3192,18 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 		t = btf_type_by_id(btf, t->type);
 	}
 	if (!btf_id_tag) {
-		/* 'ref' tag must be specified together with 'btf_id' tag */
-		if (ref_tag) {
+		/* 'ref' or 'percpu' tag must be specified together with 'btf_id' tag */
+		if (ref_tag || percpu_tag) {
 			ret = -EINVAL;
 			goto end;
 		}
 		return 0;
 	}
+	/* referenced percpu btf_id pointer is not yet supported */
+	if (ref_tag && percpu_tag) {
+		ret = -EINVAL;
+		goto end;
+	}
 
 	/* Get the base type */
 	if (btf_type_is_modifier(t))
@@ -3241,11 +3253,16 @@ static int btf_find_field_kptr(const struct btf *btf, const struct btf_type *t,
 		}
 	}
 
+	if (ref_tag)
+		flags |= BPF_MAP_VALUE_OFF_F_REF;
+	else if (percpu_tag)
+		flags |= BPF_MAP_VALUE_OFF_F_PERCPU;
+
 	tab->off[nr_off].offset = off;
 	tab->off[nr_off].btf_id = id;
 	tab->off[nr_off].btf    = kernel_btf;
 	tab->off[nr_off].module = mod;
-	tab->off[nr_off].flags  = ref_tag ? BPF_MAP_VALUE_OFF_F_REF : 0;
+	tab->off[nr_off].flags  = flags;
 	tab->nr_off++;
 
 	return 0;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a9d8c0d3c919..00d6ab49033d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1559,12 +1559,13 @@ static void mark_btf_ld_reg(struct bpf_verifier_env *env,
 			    struct btf *btf, u32 btf_id,
 			    enum bpf_type_flag flag)
 {
-	if (reg_type == SCALAR_VALUE) {
+	if (reg_type == SCALAR_VALUE ||
+	    WARN_ON_ONCE(reg_type != PTR_TO_BTF_ID && reg_type != PTR_TO_PERCPU_BTF_ID)) {
 		mark_reg_unknown(env, regs, regno);
 		return;
 	}
 	mark_reg_known_zero(env, regs, regno);
-	regs[regno].type = PTR_TO_BTF_ID | flag;
+	regs[regno].type = reg_type | flag;
 	regs[regno].btf = btf;
 	regs[regno].btf_id = btf_id;
 }
@@ -3478,10 +3479,18 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 					bool ref_ptr)
 {
 	const char *targ_name = kernel_type_name(off_desc->btf, off_desc->btf_id);
+	enum bpf_reg_type reg_type;
 	const char *reg_name = "";
 
-	if (reg->type != PTR_TO_BTF_ID && reg->type != PTR_TO_BTF_ID_OR_NULL)
-		goto end;
+	if (off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU) {
+		if (reg->type != PTR_TO_PERCPU_BTF_ID &&
+		    reg->type != (PTR_TO_PERCPU_BTF_ID | PTR_MAYBE_NULL))
+			goto end;
+	} else { /* referenced and unreferenced case */
+		if (reg->type != PTR_TO_BTF_ID &&
+		    reg->type != (PTR_TO_BTF_ID | PTR_MAYBE_NULL))
+			goto end;
+	}
 
 	if (!btf_is_kernel(reg->btf)) {
 		verbose(env, "R%d must point to kernel BTF\n", regno);
@@ -3524,11 +3533,16 @@ static int map_ptr_to_btf_id_match_type(struct bpf_verifier_env *env,
 	if (!btf_struct_ids_match(&env->log, reg->btf, reg->btf_id, reg->off,
 				  off_desc->btf, off_desc->btf_id))
 		goto end;
+
 	return 0;
 end:
+	if (off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU)
+		reg_type = PTR_TO_PERCPU_BTF_ID | PTR_MAYBE_NULL;
+	else
+		reg_type = PTR_TO_BTF_ID | PTR_MAYBE_NULL;
 	verbose(env, "invalid btf_id pointer access, R%d type=%s%s ", regno,
 		reg_type_str(env, reg->type), reg_name);
-	verbose(env, "expected=%s%s\n", reg_type_str(env, PTR_TO_BTF_ID), targ_name);
+	verbose(env, "expected=%s%s\n", reg_type_str(env, reg_type), targ_name);
 	return -EINVAL;
 }
 
@@ -3543,10 +3557,11 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 {
 	struct bpf_reg_state *reg = reg_state(env, regno), *val_reg;
 	struct bpf_insn *insn = &env->prog->insnsi[insn_idx];
+	enum bpf_reg_type reg_type = PTR_TO_BTF_ID;
+	bool ref_ptr = false, percpu_ptr = false;
 	struct bpf_map_value_off_desc *off_desc;
 	int insn_class = BPF_CLASS(insn->code);
 	struct bpf_map *map = reg->map_ptr;
-	bool ref_ptr = false;
 	u32 ref_obj_id = 0;
 	int ret;
 
@@ -3561,7 +3576,6 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 	off_desc = bpf_map_ptr_off_contains(map, off + reg->var_off.value);
 	if (!off_desc)
 		return 0;
-	ref_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_REF;
 
 	if (WARN_ON_ONCE(size != bpf_size_to_bytes(BPF_DW)))
 		return -EACCES;
@@ -3574,6 +3588,11 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 		return -EPERM;
 	}
 
+	ref_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_REF;
+	percpu_ptr = off_desc->flags & BPF_MAP_VALUE_OFF_F_PERCPU;
+	if (percpu_ptr)
+		reg_type = PTR_TO_PERCPU_BTF_ID;
+
 	if (is_xchg_insn(insn)) {
 		/* We do checks and updates during register fill call for fetch case */
 		if (t != BPF_READ || value_regno < 0)
@@ -3603,7 +3622,7 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 			ref_obj_id = ret;
 		}
 		/* val_reg might be NULL at this point */
-		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, off_desc->btf,
+		mark_btf_ld_reg(env, cur_regs(env), value_regno, reg_type, off_desc->btf,
 				off_desc->btf_id, PTR_MAYBE_NULL);
 		/* __mark_ptr_or_null_regs needs ref_obj_id == id to clear
 		 * reference state for ptr == NULL branch.
@@ -3621,7 +3640,7 @@ static int check_map_ptr_to_btf_id(struct bpf_verifier_env *env, u32 regno, int
 		/* We can simply mark the value_regno receiving the pointer
 		 * value from map as PTR_TO_BTF_ID, with the correct type.
 		 */
-		mark_btf_ld_reg(env, cur_regs(env), value_regno, PTR_TO_BTF_ID, off_desc->btf,
+		mark_btf_ld_reg(env, cur_regs(env), value_regno, reg_type, off_desc->btf,
 				off_desc->btf_id, PTR_MAYBE_NULL);
 		val_reg->id = ++env->id_gen;
 	} else if (insn_class == BPF_STX) {
-- 
2.35.1

