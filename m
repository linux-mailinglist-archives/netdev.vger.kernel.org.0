Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20721478273
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhLQBup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhLQBuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:44 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9548C061574;
        Thu, 16 Dec 2021 17:50:43 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id c6so541786plg.3;
        Thu, 16 Dec 2021 17:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/c42Tb1IT3hKwdoO6cfSfz5y7JB3ppN6xEVyti5JOns=;
        b=kQ/WPxMQbiQaR29yPBiPraVRoSQsUIRtEyohQJ1zNfallV6IsRBDwSpKVva8/X8v0J
         NprmsMtqDFLgFyTpBYdoehd79VvFOTDwBL+/GyZLz96o5ySjJzF5jK8QLNJjCjLl+LYP
         9CBrdO1Zp3MEBOCxOPs25TM45ViMdbH5vSGjqelhwvplP2aCF7FDVL+SGxgtrKyzSkpF
         hpquGABT6vMsPQhteydOzYpHck+25VDMT0PZVlmB327qk5RAzjYV5k4u2d9uMB1gvD3H
         CFe152U7/qmAX1fhQi2pmZxGpt275SbSXMSD3cdJlC6m53ZmgdXwiyQEi3Rl+jIsOxdg
         2S9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/c42Tb1IT3hKwdoO6cfSfz5y7JB3ppN6xEVyti5JOns=;
        b=QHeYFV10MTlzs9k65vbWa7vtQOq1MIFKhOHOAE/4Y9f0p0eU3gcMCD5W/nn6XG6cx4
         lsVKMY3Xh1ECtbTI0/nfZ3Sc9jJIpFth/aDkaRJ+EvrUM899Q/X7txmtwU36aghNEsfo
         N8t2iyigRNIiJ68EGIDrYEM5LdqCoAj2QbHE5WXd0VXdtHssEHP5UOvvP9uwHrpylkU7
         ruVP6xJQvV8JFrJV7pyPcudhZw/zRCk25LA7mMy3JZ6oXyHUout5eOoaz8d770QITAX8
         ixpCQo6iui230FPq8m+FKnoJR7GgCf5P1eqNumcM44HwoFCKYCPijsA5kUzG9CAoKXC8
         qbUw==
X-Gm-Message-State: AOAM532/9Bnvu/7N37J0cIClKRA83JrwC8VG7Vm02TMdEf3ROwWUZVjf
        Gs/EAXHn325Tk9Qjmtk/a1OVuinHsR4=
X-Google-Smtp-Source: ABdhPJxKSBpGI+zPwbU2Kkt5MBd1+NxSrgBze3/DCL1R10Us5Ih9JNOL/klotBhxMugK702ksTxJlQ==
X-Received: by 2002:a17:902:e54f:b0:148:a2e7:fb2e with SMTP id n15-20020a170902e54f00b00148a2e7fb2emr605264plf.111.1639705842975;
        Thu, 16 Dec 2021 17:50:42 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id h4sm7539961pfi.79.2021.12.16.17.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:42 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 03/10] bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support
Date:   Fri, 17 Dec 2021 07:20:24 +0530
Message-Id: <20211217015031.1278167-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6507; h=from:subject; bh=P8VgMMf8SY/s78fid7fw9QNHmQEigqfdnWJ5UNx2TBI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vFPGPj4Ozv8OHhuBH1iLMDoPqXntq2jrXXTMEd z5dMlvmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8RynhKD/ 9sVEfZoeU8A7Dr6soSxOMk27AnWFhhYoh6SvAsW6Dija4bq+6fEKGK1ZGpcKAR0OyfyqmMJYOo5zPX pGucdajtKDN6IBOsC3W+aGpg7Ib7cNPY17EWovQQA1tZ8OmYmJ8sz16+PuN0TFqTdyodu27MmtKYOG H5jnB/TA4vjXL2OJoXjzO1Rp+2WF5C1S0Y05/QUpr+k60dLEzy+FCExaIhRNaBpxPJb8/7OnEz4YGG xw+0J/HbNFtYvU1VYomJRopj8ZEtAGrfWWX7g3YowuRTmcycvszrBWRNQA8b23LTp+Le05Cux9THgw 3LoKma5GvQgIBhBrRZnWMTaxmP3+fEkYNqYWWYkLR0kFQ7k9tnX8iPD//hJ/q/A8pqc9c5/d5QIM53 eXlu7iqYu7Yt7VH/w5Zhje4WHAFWo/vi6XeK6r0/sIl0KwNhk9F6ezIcIGoV7EbmUB2nP7E85/UDvw pGvgdrraJuDi11my9ElN7LA6QhkdYPnYj3WqrDB9lAIq1BHQIYjPctXwTw4WL3tGx5toyiz8opU+pB 9I8Ek3GK/ZaJg2TJAslOIM57hemJ8oF9souXyFHiO22BgBW185jyzUVjmLKiIx8jSYRr88IKHix5SX WQAxLFDtc9NRJc0v0hU4meZFf0XHEtNKVZxN6XBULU6WQ33qhkvYxk8zXjxg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow passing PTR_TO_CTX, if the kfunc expects a matching struct type,
and punt to PTR_TO_MEM block if reg->type does not fall in one of
PTR_TO_BTF_ID or PTR_TO_SOCK* types. This will be used by future commits
to get access to XDP and TC PTR_TO_CTX, and pass various data (flags,
l4proto, netns_id, etc.) encoded in opts struct passed as pointer to
kfunc.

For PTR_TO_MEM support, arguments are currently limited to pointer to
scalar, or pointer to struct composed of scalars. This is done so that
unsafe scenarios (like passing PTR_TO_MEM where PTR_TO_BTF_ID of
in-kernel valid structure is expected, which may have pointers) are
avoided. Since the argument checking happens basd on argument register
type, it is not easy to ascertain what the expected type is. In the
future, support for PTR_TO_MEM for kfunc can be extended to serve other
usecases. The struct type whose pointer is passed in may have maximum
nesting depth of 4, all recursively composed of scalars or struct with
scalars.

Future commits will add negative tests that check whether these
restrictions imposed for kfunc arguments are duly rejected by BPF
verifier or not.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c | 96 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 575c6a344096..e5ba26367ed9 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5574,12 +5574,56 @@ static u32 *reg2btf_ids[__BPF_REG_TYPE_MAX] = {
 #endif
 };
 
+/* Returns true if struct is composed of scalars, 4 levels of nesting allowed */
+static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
+					const struct btf *btf,
+					const struct btf_type *t, int rec)
+{
+	const struct btf_type *member_type;
+	const struct btf_member *member;
+	u16 i;
+
+	if (rec == 4) {
+		bpf_log(log, "max struct nesting depth 4 exceeded\n");
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
@@ -5632,7 +5676,20 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 
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
@@ -5648,14 +5705,9 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
@@ -5671,23 +5723,23 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
@@ -5700,6 +5752,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (check_mem_reg(env, reg, regno, type_size))
 				return -EINVAL;
 		} else {
+			bpf_log(log, "reg type unsupported for arg#%d %sfunction %s#%d\n", i,
+				is_kfunc ? "kernel " : "", func_name, func_id);
 			return -EINVAL;
 		}
 	}
@@ -5749,7 +5803,7 @@ int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
 			      struct bpf_reg_state *regs)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, false);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
-- 
2.34.1

