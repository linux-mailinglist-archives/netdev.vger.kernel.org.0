Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F5E40ADE7
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhINMjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhINMjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9F9C061574;
        Tue, 14 Sep 2021 05:38:01 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso2000935pjh.5;
        Tue, 14 Sep 2021 05:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Myd4YXzv22aL42IZTVuAouvq2pjYEs71DALuk1TgQ4s=;
        b=BdsNYN6AVMt1fwB5Mrwg6BTIcv2FSHin8tPvxCKVdfp+mgHooyfoCZZdYg6/4RjWRP
         ZQduzDzEanzko7pxf+uh+QWLZLOM56X3+i6X9IfE+LhijbgTnlIvyvogj9jXMpjN7RZd
         k0iKLyQT6PMek8HEVZR+oKfRiTmLLMLRsI2EMx24IVc5417WOm6WXYB3P7dWJRr0RlJf
         QKnMglgVCwZMUg6ttVGAksgCocrP2F9nHvbYPN3awtaNibyK3812sYeVmxhdhdCH2upO
         jW8jqIrtwMO7aofoxsJ0+Z3z4mLCzqEatWnm7elqJzmXZhQs9DevQClJE5VNkfSXXcdY
         PuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Myd4YXzv22aL42IZTVuAouvq2pjYEs71DALuk1TgQ4s=;
        b=38FoCSZ9BEBWauBlef3aDGfY4RAU82wLaAMBUXaqrJOo9biERdboWE8mx5qtWk6oG5
         lUE+90ZWxTCB0Vj1BfUwJzRDkXmnaMzNlfBPXY0vELszymMTylaPMS3maQSLbu4bmktT
         j5rERd61RZIoLRN7cj0puKn0wYdr2oPZ6UPWbIMQjoKyPTvUgxjQY9G3+p3xSFMr8+A3
         S3ABr2F9GzbOqMq0OI8J/sQtj5grPnQWNwW56CxmwA0bMDSqhPadFq9N3NhnWDGRZFE4
         VaN3HP+1WJx1X6rO9ZlSBpStRQB+jwXVb3p85r/iTcZdwnyQj9cjVZkDEkD+r1rr6Lh1
         RS3w==
X-Gm-Message-State: AOAM530gRI5bspS+ZkFortURO8i4z/JgvKjl886eZUkDURoxLUW5C2Tp
        f9KWE4kG0YbdE7dttz7Fk5+g887lhwXcOw==
X-Google-Smtp-Source: ABdhPJwPHWN3F9MPLDPlASDPa5ReAe3izHP+iAVX3nbvOceyCBYmLbwfFxXxq25pgv5QfT1Z5fTZng==
X-Received: by 2002:a17:902:760b:b0:13b:122:5ff0 with SMTP id k11-20020a170902760b00b0013b01225ff0mr14732068pll.22.1631623080250;
        Tue, 14 Sep 2021 05:38:00 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id y25sm8311656pfe.28.2021.09.14.05.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:00 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 01/10] bpf: Introduce BPF support for kernel module function calls
Date:   Tue, 14 Sep 2021 18:07:40 +0530
Message-Id: <20210914123750.460750-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16566; h=from:subject; bh=doZCWeYxbS+gEiVXiHHZlHeZ/xFk1Q9odBs67zUbcxk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdVg89EIwmclx9K7P8aZc1kThrkyK6oQ9ubVSCE BrstwJyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVQAKCRBM4MiGSL8RygdKD/ 0bUDwbZJQxF0sBbd6NgkwgXQKJ+b7HLR/QbcUZdHh7i+QSuLyBVuvwY4DJyg+IfsAvE7cMMFb3kGf4 TgpJB4FE3gublAQpQURsUhtnbnrGczT989tP8Q7MZq095hsNHWwluf8BrKUpJLSlcOIH+MjrDCSZPR A0SQoNjVzPHq+vKnrTev0AA2ZzMMddVfkg7dun9gFRcw1GzU/tTArX7EjeiXcgWEGuaKYVSXwJCsW+ rX/E9pA1p17rU02Pk9BgF3jZL35VQU6b095ry/YjMSwZYoQdqiOxgjzq7D7X4l/Zcb1vhWR1yIj6YL Q5nNIyJGq7ABXwNkUOx+Fi6AF8bZtV+NS8i8zbUCrCo9xqLMaVc10HAJCPRYcSfpMinufOzwF5h3av EG95nkExjUa0uhJbDROW1bL2pjPpWa8l5Iankw6pcdZ6E85WLbSfLjMVWLbwaTZEmdrRsr6jf521GL TQVxSAHd2Ekh/4NguuwXZeZf5Rr2E1USSrdwqmLL6x5Mmlwkq8WhmpFrLLx8WGFJq0cP/m999Kg3Lr /99jXMK8Z5sTuIJqTrOU3hJdV3P4W/QWYVl3hzEvUTjcL0zPvv06UkfVeNuZoMOmrHekRauEuJl1TA 7q9fTIJeCpUDeOxITocusomlgTT/+0g0+2eCU8qEFR7Eoaqj022jTZLxM3BA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support on the kernel side to allow for BPF programs to
call kernel module functions. Userspace will prepare an array of module
BTF fds that is passed in during BPF_PROG_LOAD using fd_array parameter.
In the kernel, the module BTFs are placed in the auxilliary struct for
bpf_prog, and loaded as needed.

The verifier then uses insn->off to index into the fd_array. insn->off
is used by subtracting one from it, as userspace has to set the index of
array in insn->off incremented by 1. This lets us denote vmlinux btf by
insn->off == 0, and the module kfunc using insn->off > 0.  They are
sorted based on offset in an array, and each offset corresponds to one
descriptor, with a max limit up to 256 such module BTFs.

Another change is to check_kfunc_call callback, which now include a
struct module * pointer, this is to be used in later patch such that the
kfunc_id and module pointer are matched for dynamically registered BTF
sets from loadable modules, so that same kfunc_id in two modules doesn't
lead to check_kfunc_call succeeding. For the duration of the
check_kfunc_call, the reference to struct module exists, as it returns
the pointer stored in kfunc_btf_tab.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h          |   8 +-
 include/linux/bpf_verifier.h |   2 +
 kernel/bpf/core.c            |   2 +
 kernel/bpf/verifier.c        | 182 +++++++++++++++++++++++++++++++----
 net/bpf/test_run.c           |   2 +-
 net/ipv4/bpf_tcp_ca.c        |   2 +-
 6 files changed, 173 insertions(+), 25 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f4c16f19f83e..148bd899411e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -511,7 +511,7 @@ struct bpf_verifier_ops {
 				 const struct btf_type *t, int off, int size,
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
-	bool (*check_kfunc_call)(u32 kfunc_btf_id);
+	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
@@ -874,6 +874,7 @@ struct bpf_prog_aux {
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct bpf_jit_poke_descriptor *poke_tab;
 	struct bpf_kfunc_desc_tab *kfunc_tab;
+	struct bpf_kfunc_btf_tab *kfunc_btf_tab;
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
@@ -1635,7 +1636,7 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
 int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 				const union bpf_attr *kattr,
 				union bpf_attr __user *uattr);
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id);
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
@@ -1856,7 +1857,8 @@ static inline int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog,
 	return -ENOTSUPP;
 }
 
-static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
+static inline bool bpf_prog_test_check_kfunc_call(u32 kfunc_id,
+						  struct module *owner)
 {
 	return false;
 }
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5424124dbe36..c8a78e830fca 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -527,5 +527,7 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *tgt_prog,
 			    u32 btf_id,
 			    struct bpf_attach_target_info *tgt_info);
+void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab);
+
 
 #endif /* _LINUX_BPF_VERIFIER_H */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9f4636d021b1..d01eb043b0b8 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -32,6 +32,7 @@
 #include <linux/perf_event.h>
 #include <linux/extable.h>
 #include <linux/log2.h>
+#include <linux/bpf_verifier.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -2255,6 +2256,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	int i;
 
 	aux = container_of(work, struct bpf_prog_aux, work);
+	bpf_free_kfunc_btf_tab(aux->kfunc_btf_tab);
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
 	if (bpf_prog_is_dev_bound(aux))
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 047ac4b4703b..6bbbb98f4ee2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1626,18 +1626,31 @@ static int add_subprog(struct bpf_verifier_env *env, int off)
 	return env->subprog_cnt - 1;
 }
 
+#define MAX_KFUNC_DESCS 256
+#define MAX_KFUNC_BTFS	256
+
 struct bpf_kfunc_desc {
 	struct btf_func_model func_model;
 	u32 func_id;
 	s32 imm;
 };
 
-#define MAX_KFUNC_DESCS 256
+struct bpf_kfunc_btf {
+	struct btf *btf;
+	struct module *module;
+	u16 offset;
+};
+
 struct bpf_kfunc_desc_tab {
 	struct bpf_kfunc_desc descs[MAX_KFUNC_DESCS];
 	u32 nr_descs;
 };
 
+struct bpf_kfunc_btf_tab {
+	struct bpf_kfunc_btf descs[MAX_KFUNC_BTFS];
+	u32 nr_descs;
+};
+
 static int kfunc_desc_cmp_by_id(const void *a, const void *b)
 {
 	const struct bpf_kfunc_desc *d0 = a;
@@ -1647,6 +1660,14 @@ static int kfunc_desc_cmp_by_id(const void *a, const void *b)
 	return d0->func_id - d1->func_id;
 }
 
+static int kfunc_btf_cmp_by_off(const void *a, const void *b)
+{
+	const struct bpf_kfunc_btf *d0 = a;
+	const struct bpf_kfunc_btf *d1 = b;
+
+	return d0->offset - d1->offset;
+}
+
 static const struct bpf_kfunc_desc *
 find_kfunc_desc(const struct bpf_prog *prog, u32 func_id)
 {
@@ -1660,18 +1681,113 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id)
 		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_id);
 }
 
-static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
+/* Expects offset always greater than 0 */
+static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
+					 s16 offset, struct module **btf_modp)
+{
+	struct bpf_kfunc_btf kf_btf = { .offset = offset - 1 };
+	struct bpf_kfunc_btf_tab *tab;
+	struct module *mod = NULL;
+	struct bpf_kfunc_btf *b;
+	struct btf *btf;
+	int btf_fd;
+
+	tab = env->prog->aux->kfunc_btf_tab;
+	b = bsearch(&kf_btf, tab->descs, tab->nr_descs,
+		    sizeof(tab->descs[0]), kfunc_btf_cmp_by_off);
+	if (!b) {
+		if (tab->nr_descs == MAX_KFUNC_BTFS) {
+			verbose(env, "too many different module BTFs\n");
+			return ERR_PTR(-E2BIG);
+		}
+
+		offset -= 1;
+		if (copy_from_bpfptr_offset(&btf_fd, env->fd_array,
+					    offset * sizeof(btf_fd),
+					    sizeof(btf_fd)))
+			return ERR_PTR(-EFAULT);
+
+		btf = btf_get_by_fd(btf_fd);
+		if (IS_ERR(btf))
+			return btf;
+
+		if (!btf_is_module(btf)) {
+			verbose(env, "BTF fd for kfunc is not a module BTF\n");
+			btf_put(btf);
+			return ERR_PTR(-EINVAL);
+		}
+
+		mod = btf_try_get_module(btf);
+		if (!mod) {
+			btf_put(btf);
+			return ERR_PTR(-ENXIO);
+		}
+
+		b = &tab->descs[tab->nr_descs++];
+		b->btf = btf;
+		b->module = mod;
+		b->offset = offset;
+
+		sort(tab->descs, tab->nr_descs, sizeof(tab->descs[0]),
+		     kfunc_btf_cmp_by_off, NULL);
+	}
+	if (btf_modp)
+		*btf_modp = b->module;
+	return b->btf;
+}
+
+void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
+{
+	if (!tab)
+		return;
+
+	while (tab->nr_descs--) {
+		module_put(tab->descs[tab->nr_descs].module);
+		btf_put(tab->descs[tab->nr_descs].btf);
+	}
+	kfree(tab);
+}
+
+static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
+				       u32 func_id, s16 offset,
+				       struct module **btf_modp)
+{
+	struct btf *kfunc_btf;
+
+	if (offset) {
+		if (offset < 0) {
+			/* In the future, this can be allowed to increase limit
+			 * of fd index into fd_array, interpreted as unsigned u16.
+			 */
+			verbose(env, "negative offset disallowed for kernel module function call\n");
+			return ERR_PTR(-EINVAL);
+		}
+
+		kfunc_btf = __find_kfunc_desc_btf(env, offset, btf_modp);
+		if (IS_ERR_OR_NULL(kfunc_btf)) {
+			verbose(env, "cannot find module BTF for func_id %u\n", func_id);
+			return kfunc_btf ?: ERR_PTR(-ENOENT);
+		}
+		return kfunc_btf;
+	}
+	return btf_vmlinux ?: ERR_PTR(-ENOENT);
+}
+
+static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 {
 	const struct btf_type *func, *func_proto;
+	struct bpf_kfunc_btf_tab *btf_tab;
 	struct bpf_kfunc_desc_tab *tab;
 	struct bpf_prog_aux *prog_aux;
 	struct bpf_kfunc_desc *desc;
 	const char *func_name;
+	struct btf *desc_btf;
 	unsigned long addr;
 	int err;
 
 	prog_aux = env->prog->aux;
 	tab = prog_aux->kfunc_tab;
+	btf_tab = prog_aux->kfunc_btf_tab;
 	if (!tab) {
 		if (!btf_vmlinux) {
 			verbose(env, "calling kernel function is not supported without CONFIG_DEBUG_INFO_BTF\n");
@@ -1699,6 +1815,19 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	if (!btf_tab && offset) {
+		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
+		if (!btf_tab)
+			return -ENOMEM;
+		prog_aux->kfunc_btf_tab = btf_tab;
+	}
+
+	desc_btf = find_kfunc_desc_btf(env, func_id, offset, NULL);
+	if (IS_ERR(desc_btf)) {
+		verbose(env, "failed to find BTF for kernel function\n");
+		return PTR_ERR(desc_btf);
+	}
+
 	if (find_kfunc_desc(env->prog, func_id))
 		return 0;
 
@@ -1707,20 +1836,20 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 		return -E2BIG;
 	}
 
-	func = btf_type_by_id(btf_vmlinux, func_id);
+	func = btf_type_by_id(desc_btf, func_id);
 	if (!func || !btf_type_is_func(func)) {
 		verbose(env, "kernel btf_id %u is not a function\n",
 			func_id);
 		return -EINVAL;
 	}
-	func_proto = btf_type_by_id(btf_vmlinux, func->type);
+	func_proto = btf_type_by_id(desc_btf, func->type);
 	if (!func_proto || !btf_type_is_func_proto(func_proto)) {
 		verbose(env, "kernel function btf_id %u does not have a valid func_proto\n",
 			func_id);
 		return -EINVAL;
 	}
 
-	func_name = btf_name_by_offset(btf_vmlinux, func->name_off);
+	func_name = btf_name_by_offset(desc_btf, func->name_off);
 	addr = kallsyms_lookup_name(func_name);
 	if (!addr) {
 		verbose(env, "cannot find address for kernel function %s\n",
@@ -1731,7 +1860,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
 	desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
-	err = btf_distill_func_proto(&env->log, btf_vmlinux,
+	err = btf_distill_func_proto(&env->log, desc_btf,
 				     func_proto, func_name,
 				     &desc->func_model);
 	if (!err)
@@ -1815,7 +1944,7 @@ static int add_subprog_and_kfunc(struct bpf_verifier_env *env)
 		} else if (bpf_pseudo_call(insn)) {
 			ret = add_subprog(env, i + insn->imm + 1);
 		} else {
-			ret = add_kfunc_call(env, insn->imm);
+			ret = add_kfunc_call(env, insn->imm, insn->off);
 		}
 
 		if (ret < 0)
@@ -2152,12 +2281,17 @@ static int get_prev_insn_idx(struct bpf_verifier_state *st, int i,
 static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 {
 	const struct btf_type *func;
+	struct btf *desc_btf;
 
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	func = btf_type_by_id(btf_vmlinux, insn->imm);
-	return btf_name_by_offset(btf_vmlinux, func->name_off);
+	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off, NULL);
+	if (IS_ERR(desc_btf))
+		return "<error>";
+
+	func = btf_type_by_id(desc_btf, insn->imm);
+	return btf_name_by_offset(desc_btf, func->name_off);
 }
 
 /* For given verifier state backtrack_insn() is called from the last insn to
@@ -6485,23 +6619,29 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
+	struct module *btf_mod = NULL;
 	const struct btf_param *args;
+	struct btf *desc_btf;
 	int err;
 
+	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
+	if (IS_ERR(desc_btf))
+		return PTR_ERR(desc_btf);
+
 	func_id = insn->imm;
-	func = btf_type_by_id(btf_vmlinux, func_id);
-	func_name = btf_name_by_offset(btf_vmlinux, func->name_off);
-	func_proto = btf_type_by_id(btf_vmlinux, func->type);
+	func = btf_type_by_id(desc_btf, func_id);
+	func_name = btf_name_by_offset(desc_btf, func->name_off);
+	func_proto = btf_type_by_id(desc_btf, func->type);
 
 	if (!env->ops->check_kfunc_call ||
-	    !env->ops->check_kfunc_call(func_id)) {
+	    !env->ops->check_kfunc_call(func_id, btf_mod)) {
 		verbose(env, "calling kernel function %s is not allowed\n",
 			func_name);
 		return -EACCES;
 	}
 
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, btf_vmlinux, func_id, regs);
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
 	if (err)
 		return err;
 
@@ -6509,15 +6649,15 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		mark_reg_not_init(env, regs, caller_saved[i]);
 
 	/* Check return type */
-	t = btf_type_skip_modifiers(btf_vmlinux, func_proto->type, NULL);
+	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
 	if (btf_type_is_scalar(t)) {
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
 	} else if (btf_type_is_ptr(t)) {
-		ptr_type = btf_type_skip_modifiers(btf_vmlinux, t->type,
+		ptr_type = btf_type_skip_modifiers(desc_btf, t->type,
 						   &ptr_type_id);
 		if (!btf_type_is_struct(ptr_type)) {
-			ptr_type_name = btf_name_by_offset(btf_vmlinux,
+			ptr_type_name = btf_name_by_offset(desc_btf,
 							   ptr_type->name_off);
 			verbose(env, "kernel function %s returns pointer type %s %s is not supported\n",
 				func_name, btf_type_str(ptr_type),
@@ -6525,7 +6665,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			return -EINVAL;
 		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].btf = btf_vmlinux;
+		regs[BPF_REG_0].btf = desc_btf;
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
@@ -6536,7 +6676,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	for (i = 0; i < nargs; i++) {
 		u32 regno = i + 1;
 
-		t = btf_type_skip_modifiers(btf_vmlinux, args[i].type, NULL);
+		t = btf_type_skip_modifiers(desc_btf, args[i].type, NULL);
 		if (btf_type_is_ptr(t))
 			mark_btf_func_reg_size(env, regno, sizeof(void *));
 		else
@@ -11074,7 +11214,8 @@ static int do_check(struct bpf_verifier_env *env)
 			env->jmps_processed++;
 			if (opcode == BPF_CALL) {
 				if (BPF_SRC(insn->code) != BPF_K ||
-				    insn->off != 0 ||
+				    (insn->src_reg != BPF_PSEUDO_KFUNC_CALL
+				     && insn->off != 0) ||
 				    (insn->src_reg != BPF_REG_0 &&
 				     insn->src_reg != BPF_PSEUDO_CALL &&
 				     insn->src_reg != BPF_PSEUDO_KFUNC_CALL) ||
@@ -12430,6 +12571,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->stack_depth = env->subprog_info[i].stack_depth;
 		func[i]->jit_requested = 1;
 		func[i]->aux->kfunc_tab = prog->aux->kfunc_tab;
+		func[i]->aux->kfunc_btf_tab = prog->aux->kfunc_btf_tab;
 		func[i]->aux->linfo = prog->aux->linfo;
 		func[i]->aux->nr_linfo = prog->aux->nr_linfo;
 		func[i]->aux->jited_linfo = prog->aux->jited_linfo;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index fcb2f493f710..fe5c34f414a2 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -241,7 +241,7 @@ BTF_ID(func, bpf_kfunc_call_test2)
 BTF_ID(func, bpf_kfunc_call_test3)
 BTF_SET_END(test_sk_kfunc_ids)
 
-bool bpf_prog_test_check_kfunc_call(u32 kfunc_id)
+bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner)
 {
 	return btf_id_set_contains(&test_sk_kfunc_ids, kfunc_id);
 }
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 0dcee9df1326..b3afd3361f34 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -255,7 +255,7 @@ BTF_ID(func, bbr_set_state)
 #endif	/* CONFIG_X86 */
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
 
-static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
+static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
 {
 	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
 }
-- 
2.33.0

