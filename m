Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4224047012E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhLJNGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241243AbhLJNGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:18 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C6CC061746;
        Fri, 10 Dec 2021 05:02:43 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 137so8048703pgg.3;
        Fri, 10 Dec 2021 05:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iq4G9uq7WxgaVe3DHhuWFowgRFvmeNkjD/eBvmvludk=;
        b=mxWf0Ll51q5cAIwD3ioiq5vu+FJnV4yE5vGsuKpkQRNbXr0uflZQczc95YXKWOx1W2
         WGT3YzSrkhbOs0l1F3tEybI3v40eWdZsHe2Q/l1hAvSfQbMj8EhQfhKw1YR6xRXWPcZ1
         TbL+chIKSkLF3wFm6ucT1/YpV+IEk7Ha83c5L8rOVbBBmIV5NTbFFUx7u33asLWfM0Ic
         2PYcX7JvbEBiwmWflnZnYWBwYl6L7FPOdrVq3Dlg91k8ennCs9RcXg+QhA5AvWDtlq4t
         +zPuCq615xq65c2RzDT5UK1iy7oc+YmTDHnVka90ST3eJJWybBiyRsr6RtpZ/ZtxD1Q8
         mB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iq4G9uq7WxgaVe3DHhuWFowgRFvmeNkjD/eBvmvludk=;
        b=VL5glvAW4XaZ6qVPO3WcnBQkBKsqckyw6GososseWzJtVNHArHQJzV3lG/WxF6XpsW
         30DoqMnhCgO6kl41jrcNIIg+PVG4BKOoO3mdkIcyhSU5/okFnOdeXghyctIPE3Pd/JeO
         brUPzPDUTruOaTKd9CLw6Yu23zqmNg2+WyeZdnxZ6ORv1dBBFpg1S+OZ7uK7YgGCJUsz
         nqtInD/7dxSlFCX1u1C0QAi22jNGTEq/sSHlfKBqiWBcCFMDJsAgjGIYSWsCfZodpVg4
         f9l+ob4YW7FFaXuTwPjx5x33+yHPB3TrM5RpqY5xC3+mAg5r/99ibbyEvBPlbph/qsB5
         twyw==
X-Gm-Message-State: AOAM532jegVwRtY10tYlrjRKoEkFQt1UgQOp7lbxi8yuAUWCwiuPgvw8
        7u8Fbd0KN9tASwbHDehApIt9MfySrjU=
X-Google-Smtp-Source: ABdhPJw+p3qlpQgr4IeXcJ1CS54M5F3R/k78POTqS8OvJvZQNYbBjUvDftSxSEwC8UH4+khXclGnSQ==
X-Received: by 2002:a63:a705:: with SMTP id d5mr15658332pgf.556.1639141362511;
        Fri, 10 Dec 2021 05:02:42 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h13sm3284592pfv.84.2021.12.10.05.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:42 -0800 (PST)
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
Subject: [PATCH bpf-next v3 3/9] bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support
Date:   Fri, 10 Dec 2021 18:32:24 +0530
Message-Id: <20211210130230.4128676-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6475; h=from:subject; bh=giSb7fdikArvvvTn6n+5i1NroHkB1wXNqQSKlzP7+cc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/URe0YjJqKecetxM87Jg2e8FNu9Piy9oS4R+uC KTsd91eJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP1AAKCRBM4MiGSL8RyqFkD/ 9f/5Gf8qVojHea56xT3MoZwt3xQmDQIFfMRpkcXcUPSWpae5lqfFHfMOwNcZRNeAGr1Eg+ZwzqwDLo wmwBya7seykmEZNbssfkpDvsYB0+VCOxniwPTfQIavYJ6RGfXhirJsnpA2T/E7Klvq2rUQhEOr2v4W +ETp+up/bHIcu3KBUUjKDbHinykL+8jG6Lpc288UeMtwxYXGX9UV2/iBHcbaiC4tgcokPO4ixGeFst 9a1dIMp3YfE3mro+ajxMvPUdM2EklUPKH2fkrmmdbGZEQX5o+bEkOyPNqfr8xRYeMrgtKnWqfj/Q/W qXp96MgxhnG4BMWp4gJLzEsbnMfwZDOSwUB9nJk1m/YZBMxOeGU7oe9S8c8GzqszPStwtGdnkIGJqw p0C1jLD7UUZJoZVnpApMbfOi2mZ5w4mGdZb2t+2O0iWMdFYqHsCdHbyqzaKoJ8XD1K06Imn1q73bD7 MzBkU4GhCqCc/b2EfDHwZ4HGFJqQy9Q/GPEvHk2qwhwuqyPcz4qrjblnOmp1pktAVQsd0hTkT32+rs f7sAKxaKAlf/G7QLc9JfBmgvhgc7Pu07V2htGxeTbzEWZSrdYPXyWgQx8UZVqf9P1YrZDG1jvvWrc3 FfwIpfPoM3XuSxId0bbvC63/WxbeCTCTjEOzhs7sarBRSB36DyfJvA3DQUdQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow passing PTR_TO_CTX, if the kfunc expects a matching struct type,
and punt to PTR_TO_MEM block if reg->type does not fall in one of
PTR_TO_BTF_ID or PTR_TO_SOCK* types. This will be used by future commits
to get access to XDP and TC PTR_TO_CTX, and pass various data (flags,
tuple, netns_id, etc.) encoded in opts struct as a pointer to the kfunc.

For PTR_TO_MEM support, arguments are currently limited to pointer to
scalar, or pointer to struct composed of scalars. This is done so that
unsafe scenarios (like passing PTR_TO_MEM where PTR_TO_BTF_ID of
in-kernel valid structure is expected, which may have pointers) are
avoided. kfunc argument checking is based on the passed in register type
and limited argument type matching, hence this limitation is imposed. In
the future, support for PTR_TO_MEM for kfunc can be extended to serve
other usecases. struct may have maximum 8 nested structs, all
recursively composed of scalars or struct with scalars.

Future commits will add negative tests that check whether these
restrictions imposed for kfunc arguments are duly rejected by BPF
verifier or not.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 96 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 450f9e37ceca..63b22ff73550 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5575,12 +5575,56 @@ static u32 *reg2btf_ids[__BPF_REG_TYPE_MAX] = {
 #endif
 };
 
+/* Returns true if struct is composed of scalars, 8 levels of nesting allowed */
+static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
+					const struct btf *btf,
+					const struct btf_type *t, int rec)
+{
+	const struct btf_type *member_type;
+	const struct btf_member *member;
+	u16 i;
+
+	if (rec == 8) {
+		bpf_log(log, "max struct nesting depth 8 exceeded\n");
+		return false;
+	}
+
+	if (!btf_type_is_struct(t))
+		return false;
+
+	for_each_member(i, t, member) {
+		const struct btf_array *array;
+
+		member_type = btf_type_skip_modifiers(btf, member->type, NULL);
+
+		if (btf_type_is_struct(member_type)) {
+			if (!__btf_type_is_scalar_struct(log, btf, member_type, rec + 1))
+				return false;
+			continue;
+		}
+		if (btf_type_is_array(member_type)) {
+			array = btf_type_array(member_type);
+			/* FAM */
+			if (!array->nelems)
+				return false;
+			member_type = btf_type_skip_modifiers(btf, array->type, NULL);
+			if (!btf_type_is_scalar(member_type))
+				return false;
+			continue;
+		}
+		if (!btf_type_is_scalar(member_type))
+			return false;
+	}
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
 	struct bpf_verifier_log *log = &env->log;
+	bool is_kfunc = btf_is_kernel(btf);
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
@@ -5633,7 +5677,20 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
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
+		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID || reg2btf_ids[reg->type])) {
 			const struct btf_type *reg_ref_t;
 			const struct btf *reg_btf;
 			const char *reg_ref_tname;
@@ -5649,14 +5706,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
-			} else if (reg2btf_ids[reg->type]) {
+			} else {
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[reg->type];
-			} else {
-				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s but R%d is not a pointer to btf_id\n",
-					func_name, i,
-					btf_type_str(ref_t), ref_tname, regno);
-				return -EINVAL;
 			}
 
 			reg_ref_t = btf_type_skip_modifiers(reg_btf, reg_ref_id,
@@ -5672,23 +5724,23 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
 			const struct btf_type *resolve_ret;
 			u32 type_size;
 
+			if (is_kfunc) {
+				/* Permit pointer to mem, but only when argument
+				 * type is pointer to scalar, or struct composed
+				 * (recursively) of scalars.
+				 */
+				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0)) {
+					bpf_log(log,
+						"arg#%d pointer type %s %s must point to scalar or struct with scalar\n",
+						i, btf_type_str(ref_t), ref_tname);
+					return -EINVAL;
+				}
+			}
+
 			resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
 			if (IS_ERR(resolve_ret)) {
 				bpf_log(log,
@@ -5701,6 +5753,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (check_mem_reg(env, reg, regno, type_size))
 				return -EINVAL;
 		} else {
+			bpf_log(log, "reg type unsupported for arg#%d %sfunction %s#%d\n", i,
+				is_kfunc ? "kernel " : "", func_name, func_id);
 			return -EINVAL;
 		}
 	}
@@ -5750,7 +5804,7 @@ int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
 			      struct bpf_reg_state *regs)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, false);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
-- 
2.34.1

