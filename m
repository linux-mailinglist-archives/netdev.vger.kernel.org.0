Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25E546F108
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242528AbhLIRNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242492AbhLIRNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:15 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A37C061746;
        Thu,  9 Dec 2021 09:09:42 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 133so5611817pgc.12;
        Thu, 09 Dec 2021 09:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Iq4G9uq7WxgaVe3DHhuWFowgRFvmeNkjD/eBvmvludk=;
        b=qEThOzLv3J6EgxWibMtxtcCP0OHdHbBxNEbbwJ5N5EBrmQU01CMMGmfRmHP07D40uT
         hZiXOAd+sgC66H1DdUpKmzNPpLvTN1T2gpwOqqo9lle4qAdmlYSePZfYcmsZahIVHSSA
         dwZpSjvdsrGhkoxnDpUsmdzBdwOpEPzGmnH0mkP2l4u9k+kBV6/lakN499kqUTKzw4sU
         57WvzEq9ZwUhumAg+l+Ul68+qxyRlmRTNo9L7VsRT1S5y+ZIDDK9oJlzEyPhcYzzfYjs
         t+i3dYBN8L/aoxaLzFZN4bzW8qMFW83yJ/WLa0qVfAOccp3buX4BZnytezcu5ocKileL
         LjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Iq4G9uq7WxgaVe3DHhuWFowgRFvmeNkjD/eBvmvludk=;
        b=J7UdJU04cAhRw9d6bD3M202rk7DbhUvHZX4BVKczTZrhVIUrNA/gBAwUApWWVtJKPn
         VatpBT/sncLWzSqiBM5KYpauFxgg/+DGE/RWbQ/NPZim/3Xdlwyqa7G5aKZ2J14PcvJ4
         TWN5vAt/LeQhrajBMoOPopEzJF0lcnR2nYs5Hfnqmov5oyVKz5KcrKfMmYX+6gKwqyRf
         77Pkyt2IWU9VzMrfx7fBESpV0Mae0Cw6juuylcKb2lYajpJPTRezcMpCtBd11PGsAchl
         zooYr8+nVntERep3TTZJa0pVjyJ0375jc+/0XUV6P3862jObWxGPFniDkSaIuAYMN2p3
         RboQ==
X-Gm-Message-State: AOAM531Xs6UBTGVRkSB3jSGoETqw+5cVh2Hmrd83MqZEHKJLNYz7YeBk
        mpXUOIIRq7OArSl55E+qpnR7QbO2uOU=
X-Google-Smtp-Source: ABdhPJw/1+B26Nw3lFnG8+m9Cp6rtgmTR2MFa+G7BDDwJRCpZ9O/Uyim/LMNg88nlA1tev5RsiReJQ==
X-Received: by 2002:a63:455f:: with SMTP id u31mr24023018pgk.426.1639069781635;
        Thu, 09 Dec 2021 09:09:41 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id q89sm232606pjk.50.2021.12.09.09.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:41 -0800 (PST)
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
Subject: [PATCH bpf-next v2 3/9] bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support
Date:   Thu,  9 Dec 2021 22:39:23 +0530
Message-Id: <20211209170929.3485242-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6475; h=from:subject; bh=giSb7fdikArvvvTn6n+5i1NroHkB1wXNqQSKlzP7+cc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgHRe0YjJqKecetxM87Jg2e8FNu9Piy9oS4R+uC KTsd91eJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8RytlUEA CayyfOzxup7UpzdDgRbGzG9xv3FV04Ozf8fGO0tpXKgcYDvYMAaQrAI1xfLt1hSN9qsQgzB96AafHd fqAqINV30PlgQx54zxvNUkwRvk4FK/5JFqpP0srut5kq6FuQ1ZsexU6p1eYYtIjZyJp134g9Eji9CL PmOnAlR3MEnis/YZb0keKPYEA6m1++iJmek9mnLlAjcjC86k96jSfDco2p9TiEp4UZSXLfDOySLkOP STx3IMp5WI9tSHaqjWKKBAkI9AB4hgMtOxTlzwxxplWPAZZUQ1M7MxgTR3SIpn+P74VBeVIp5m2vo8 bYkGOBzqiYWIwrh0qqtp7VTiibMucVWWpS630qXdNv7c8eN5JhJZzxCOxaq2Q88H17C49bvdlq6DQK FImbsWjywTGy0D9hBNl8JCCaj5/F1A+L3+ZnlobzhUfqMYt34PHtBQuB7BlzRqz6wC2n/xnY3th1Yd QUvL13Ezh0NFjVJN5EYGQoVlRRf+tbylUeA4A0lR9CKQATUbJdK4XcX6F0GRa2Qlqir0uSj/+rIp5r ht2XMtItI4ap4WFhQZLqJMghvHEQQ3jkK4PzlIteev+aXcmfNPJCiH7mDZfd7eMvT2JA1wh1yrZFdK 2n1tXRvwVoDxZKbRdQTdJqid7DngzOqBQZ33sRs4IYC7x/QTgeD0b582IAwQ==
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

