Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6033FBB08
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbhH3Rfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbhH3Rf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:28 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A04CC06175F;
        Mon, 30 Aug 2021 10:34:34 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u1so5160158plq.5;
        Mon, 30 Aug 2021 10:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K5cq3ITD1cfF+ztNNUFbtlqiEu6d9XvUJN2jwcM08J4=;
        b=To9RAbtuLqECfVSOYEkumdLxk5WGgl6Sjb5CcBHkg5N189Dmk9SCqjpu8Iqv4G21Ge
         0KOcnF7aYZG7Ev2ogowCz3UKeJcYsDV47ozkmwiO1CxI/jHwb954u9Y4QEq2wimGyMam
         nul9l41kCjfWzNYYOR0FWzQHzSAUu10KiQx2igLtoIxniUYRY+NOWjm7bOXq7tq9S2xS
         siNMbTBfddV4t9aU4XJYyiX0s18XZxwjEXOHDXsrTPlLq5VlWSkZ/r7V9qMVdaPSKU5n
         PG3zGNB/0ds+iJ3BF87AUHNsgU8FA1Zg/zVHuw5Xs7QlcI8Q4GbIf5Uel7hvRBvCqoum
         MPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K5cq3ITD1cfF+ztNNUFbtlqiEu6d9XvUJN2jwcM08J4=;
        b=CFX9o/3kbkBaqA2KUsJlBiz0pwDMfQKMG76QMjs3cIX0FMfnQJsRjehNzt0xtOdpcT
         exSz9SMlfKy5iPf0sEssDtsmXgEIvtoufZcEoBEtHE3LEdJGomRxsZUv1Ow39uW7uvph
         7HaFOTPspp3AKw9M813xbpl/v5TYyNf+DVXymb38FlyiDQppfoT0viyVXbooPuJ06oCV
         t4GlbntVO5HquOfdU5gyEnjtjn+ZxJmPCIdTgSlTgdv8Z3iwJVB06Utx3sHvi4KyNihv
         TiO9XWxYKTkhS9xhhmlJiLZ6UCDDh7JI8PVYU/F58jmz2cIsvQN2vxzRR3plNcIEnyAT
         GQMw==
X-Gm-Message-State: AOAM530mXxveB1SN+h9w5oJv7cVfHFg4zqRHmlII1CuSz7lSxCfWStV4
        DSC1SQqM5FGBD/BFEjdRqlXbyk/8jKFOSg==
X-Google-Smtp-Source: ABdhPJwtgkcWKIw7zPEE2iZtUtKG+Q9LbhajhTE/azKkMgGIJKW8CDfUo15sp8u2fBdHAwKwU+QUpQ==
X-Received: by 2002:a17:902:7484:b0:135:8c25:d33a with SMTP id h4-20020a170902748400b001358c25d33amr664020pll.83.1630344873791;
        Mon, 30 Aug 2021 10:34:33 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id k3sm14540717pfc.16.2021.08.30.10.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:33 -0700 (PDT)
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
Subject: [PATCH bpf-next RFC v1 1/8] bpf: Introduce BPF support for kernel module function calls
Date:   Mon, 30 Aug 2021 23:04:17 +0530
Message-Id: <20210830173424.1385796-2-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15018; h=from:subject; bh=j2skxd1DWGnmyG1yn9IaiA+KLdmbZHDLfDIgAt6hYv8=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX9O2tGNtGap/T0Fu0mmE9JIUBocNBfVfVGn0TC hvx0+UKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8RyixUD/ 91WSUE0SLEILreVthPZMXlgTtuQp3ImmazoznoQAijiLxv/oSzY7KKQURnK+5UdZ9CaZYWCblWofBL K7cRaKgrl4qEA2MInojuPP6WqEOJTZLeROfM2oaHZ/Et+xC9WGT+yAyAzpxUwCSEeNp7Mcx0V+3MRY kJGC2QDyybL0TZZOoZja36ZWCKL8CY73PFfGQNHOTLECx0YstjpTeXAA8iHbOSrGurW/jYC3qrDSKF 2xs2ch+KWYD9wiozphl92mVyMXBISgru0h4E2j/aywUB61D5in1uQ4RC6ipv7H4ofi5PQsgpcvICgu bd6PoFQtDhvVKZZSXiea5y3AiLsVMj3lpeJStq2cZeqTPiKaXqqGm/D4mJrYzJ9iwIoAYYKsrKO6JW PWbiuoFpSGMfvdQVan7q37mKUEpQdNwXd0YQu0/XhtHJ4gDTZvBFS/SxOPINFA1utZnWsScOCq1cnH brQqKxcAOWisHjthSF185/euzV2i5yqOTiKRqXqk0aFqLvKM65OZv1AgNLlObNQ7hi+gjl0C+MOCLq tJ6My4H+A2UWICZJZ0mQHz8DniNn3jxFn+pZu9VbMlJqj5bRc2tSJZbtYiBnBF1tODPxNGqZq5+UJ+ TwTegMXS8IMhA01zX0IINcsIiaRJ59RRZhHdVA/IZpwBT7c6CQk4WL/C6lBw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support on the kernel side to allow for BPF programs to
call kernel module functions. Userspace will prepare an array of module
BTF fds that is passed in during BPF_PROG_LOAD. In the kernel, the
module BTF array is placed in the auxilliary struct for bpf_prog.

The verifier then uses insn->off to index into this table. insn->off is
used by subtracting one from it, as userspace has to set the index of
array in insn->off incremented by 1. This lets us denote vmlinux btf by
insn->off == 0, and the prog->aux->kfunc_btf_tab[insn->off - 1] for
module BTFs.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h            |  1 +
 include/linux/filter.h         |  9 ++++
 include/uapi/linux/bpf.h       |  3 +-
 kernel/bpf/core.c              | 14 ++++++
 kernel/bpf/syscall.c           | 55 +++++++++++++++++++++-
 kernel/bpf/verifier.c          | 85 ++++++++++++++++++++++++++--------
 tools/include/uapi/linux/bpf.h |  3 +-
 7 files changed, 147 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f4c16f19f83e..39f59e5f3a26 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -874,6 +874,7 @@ struct bpf_prog_aux {
 	void *jit_data; /* JIT specific data. arch dependent */
 	struct bpf_jit_poke_descriptor *poke_tab;
 	struct bpf_kfunc_desc_tab *kfunc_tab;
+	struct bpf_kfunc_btf_tab *kfunc_btf_tab;
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7d248941ecea..46451891633d 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -592,6 +592,15 @@ struct bpf_prog {
 	struct bpf_insn		insnsi[];
 };
 
+#define MAX_KFUNC_DESCS 256
+/* There can only be at most MAX_KFUNC_DESCS module BTFs for kernel module
+ * function calls.
+ */
+struct bpf_kfunc_btf_tab {
+	u32 nr_btfs;
+	struct btf_mod_pair btfs[];
+};
+
 struct sk_filter {
 	refcount_t	refcnt;
 	struct rcu_head	rcu;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 791f31dd0abe..4cbb2082a553 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1334,8 +1334,9 @@ union bpf_attr {
 			/* or valid module BTF object fd or 0 to attach to vmlinux */
 			__u32		attach_btf_obj_fd;
 		};
-		__u32		:32;		/* pad */
+		__u32		kfunc_btf_fds_cnt; /* reuse hole for count of BTF fds below */
 		__aligned_u64	fd_array;	/* array of FDs */
+		__aligned_u64   kfunc_btf_fds;  /* array of BTF FDs for module kfunc support */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9f4636d021b1..73ba6d862df3 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2249,12 +2249,26 @@ static void bpf_free_used_btfs(struct bpf_prog_aux *aux)
 	kfree(aux->used_btfs);
 }
 
+static void bpf_free_kfunc_btf_tab(struct bpf_prog_aux *aux)
+{
+	struct bpf_kfunc_btf_tab *tab = aux->kfunc_btf_tab;
+
+	if (tab) {
+		while (tab->nr_btfs--) {
+			module_put(tab->btfs[tab->nr_btfs].module);
+			btf_put(tab->btfs[tab->nr_btfs].btf);
+		}
+		kfree(tab);
+	}
+}
+
 static void bpf_prog_free_deferred(struct work_struct *work)
 {
 	struct bpf_prog_aux *aux;
 	int i;
 
 	aux = container_of(work, struct bpf_prog_aux, work);
+	bpf_free_kfunc_btf_tab(aux);
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
 	if (bpf_prog_is_dev_bound(aux))
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..bbbd664b2872 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2156,16 +2156,16 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 }
 
 /* last field in 'union bpf_attr' used by this command */
-#define	BPF_PROG_LOAD_LAST_FIELD fd_array
+#define	BPF_PROG_LOAD_LAST_FIELD kfunc_btf_fds
 
 static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 {
 	enum bpf_prog_type type = attr->prog_type;
 	struct bpf_prog *prog, *dst_prog = NULL;
 	struct btf *attach_btf = NULL;
-	int err;
 	char license[128];
 	bool is_gpl;
+	int err;
 
 	if (CHECK_ATTR(BPF_PROG_LOAD))
 		return -EINVAL;
@@ -2204,6 +2204,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 		return -EPERM;
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
+	if (attr->kfunc_btf_fds_cnt > MAX_KFUNC_DESCS)
+		return -E2BIG;
 
 	/* attach_prog_fd/attach_btf_obj_fd can specify fd of either bpf_prog
 	 * or btf, we need to check which one it is
@@ -2254,6 +2256,55 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 		return -ENOMEM;
 	}
 
+	if (attr->kfunc_btf_fds_cnt) {
+		struct bpf_kfunc_btf_tab *tab;
+		int fds[MAX_KFUNC_DESCS], i;
+		bpfptr_t kfunc_btf_fds;
+		u32 kfunc_btf_size, n;
+
+		kfunc_btf_size = min_t(u32, MAX_KFUNC_DESCS, attr->kfunc_btf_fds_cnt);
+		kfunc_btf_fds = make_bpfptr(attr->kfunc_btf_fds, uattr.is_kernel);
+
+		err = -EFAULT;
+		if (copy_from_bpfptr(fds, kfunc_btf_fds, kfunc_btf_size * sizeof(int)))
+			goto free_prog;
+
+		err = -ENOMEM;
+
+		n = kfunc_btf_size;
+		kfunc_btf_size *= sizeof(prog->aux->kfunc_btf_tab->btfs[0]);
+		kfunc_btf_size += sizeof(*prog->aux->kfunc_btf_tab);
+		prog->aux->kfunc_btf_tab = kzalloc(kfunc_btf_size, GFP_KERNEL);
+		if (!prog->aux->kfunc_btf_tab)
+			goto free_prog;
+
+		tab = prog->aux->kfunc_btf_tab;
+		for (i = 0; i < n; i++) {
+			struct btf_mod_pair *p;
+			struct btf *mod_btf;
+
+			mod_btf = btf_get_by_fd(fds[i]);
+			if (IS_ERR(mod_btf)) {
+				err = PTR_ERR(mod_btf);
+				goto free_prog;
+			}
+			if (!btf_is_module(mod_btf)) {
+				err = -EINVAL;
+				btf_put(mod_btf);
+				goto free_prog;
+			}
+
+			p = &tab->btfs[tab->nr_btfs];
+			p->module = btf_try_get_module(mod_btf);
+			if (!p->module) {
+				btf_put(mod_btf);
+				goto free_prog;
+			}
+			p->btf = mod_btf;
+			tab->nr_btfs++;
+		}
+	}
+
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf = attach_btf;
 	prog->aux->attach_btf_id = attr->attach_btf_id;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 206c221453cf..de0670a8b1df 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1632,7 +1632,6 @@ struct bpf_kfunc_desc {
 	s32 imm;
 };
 
-#define MAX_KFUNC_DESCS 256
 struct bpf_kfunc_desc_tab {
 	struct bpf_kfunc_desc descs[MAX_KFUNC_DESCS];
 	u32 nr_descs;
@@ -1660,13 +1659,45 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id)
 		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_id);
 }
 
-static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
+static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
+				       u32 func_id, s16 offset)
+{
+	struct bpf_kfunc_btf_tab *btf_tab;
+
+	btf_tab = env->prog->aux->kfunc_btf_tab;
+	/* offset can be MAX_KFUNC_DESCS, since index into the array is offset - 1,
+	 * as we reserve offset == 0 for btf_vmlinux
+	 */
+	if (offset < 0 || offset > MAX_KFUNC_DESCS) {
+		verbose(env, "offset %d is incorrect for kernel function call\n", (int)offset);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (offset) {
+		if (!btf_tab) {
+			verbose(env,
+				"offset %d for kfunc call but no kernel module BTFs passed\n",
+				(int)offset);
+			return ERR_PTR(-EINVAL);
+		} else if (offset > btf_tab->nr_btfs) {
+			verbose(env,
+				"offset %d incorrect for module BTF array with %u descriptors\n",
+				(int)offset, btf_tab->nr_btfs);
+			return ERR_PTR(-EINVAL);
+		}
+		return btf_tab->btfs[offset - 1].btf;
+	}
+	return btf_vmlinux ?: ERR_PTR(-ENOENT);
+}
+
+static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 {
 	const struct btf_type *func, *func_proto;
 	struct bpf_kfunc_desc_tab *tab;
 	struct bpf_prog_aux *prog_aux;
 	struct bpf_kfunc_desc *desc;
 	const char *func_name;
+	struct btf *desc_btf;
 	unsigned long addr;
 	int err;
 
@@ -1699,6 +1730,12 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	desc_btf = find_kfunc_desc_btf(env, func_id, offset);
+	if (IS_ERR(desc_btf)) {
+		verbose(env, "failed to find BTF for kernel function\n");
+		return PTR_ERR(desc_btf);
+	}
+
 	if (find_kfunc_desc(env->prog, func_id))
 		return 0;
 
@@ -1707,20 +1744,20 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
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
@@ -1731,7 +1768,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
 	desc = &tab->descs[tab->nr_descs++];
 	desc->func_id = func_id;
 	desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
-	err = btf_distill_func_proto(&env->log, btf_vmlinux,
+	err = btf_distill_func_proto(&env->log, desc_btf,
 				     func_proto, func_name,
 				     &desc->func_model);
 	if (!err)
@@ -1815,7 +1852,7 @@ static int add_subprog_and_kfunc(struct bpf_verifier_env *env)
 		} else if (bpf_pseudo_call(insn)) {
 			ret = add_subprog(env, i + insn->imm + 1);
 		} else {
-			ret = add_kfunc_call(env, insn->imm);
+			ret = add_kfunc_call(env, insn->imm, insn->off);
 		}
 
 		if (ret < 0)
@@ -2152,12 +2189,17 @@ static int get_prev_insn_idx(struct bpf_verifier_state *st, int i,
 static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 {
 	const struct btf_type *func;
+	struct btf *desc_btf;
 
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	func = btf_type_by_id(btf_vmlinux, insn->imm);
-	return btf_name_by_offset(btf_vmlinux, func->name_off);
+	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off);
+	if (IS_ERR(desc_btf))
+		return "<error>";
+
+	func = btf_type_by_id(desc_btf, insn->imm);
+	return btf_name_by_offset(desc_btf, func->name_off);
 }
 
 /* For given verifier state backtrack_insn() is called from the last insn to
@@ -6482,12 +6524,17 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
 	const struct btf_param *args;
+	struct btf *desc_btf;
 	int err;
 
+	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off);
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
 	    !env->ops->check_kfunc_call(func_id)) {
@@ -6497,7 +6544,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	}
 
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, btf_vmlinux, func_id, regs);
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
 	if (err)
 		return err;
 
@@ -6505,15 +6552,15 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
@@ -6521,7 +6568,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 			return -EINVAL;
 		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
-		regs[BPF_REG_0].btf = btf_vmlinux;
+		regs[BPF_REG_0].btf = desc_btf;
 		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
@@ -6532,7 +6579,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	for (i = 0; i < nargs; i++) {
 		u32 regno = i + 1;
 
-		t = btf_type_skip_modifiers(btf_vmlinux, args[i].type, NULL);
+		t = btf_type_skip_modifiers(desc_btf, args[i].type, NULL);
 		if (btf_type_is_ptr(t))
 			mark_btf_func_reg_size(env, regno, sizeof(void *));
 		else
@@ -11070,7 +11117,6 @@ static int do_check(struct bpf_verifier_env *env)
 			env->jmps_processed++;
 			if (opcode == BPF_CALL) {
 				if (BPF_SRC(insn->code) != BPF_K ||
-				    insn->off != 0 ||
 				    (insn->src_reg != BPF_REG_0 &&
 				     insn->src_reg != BPF_PSEUDO_CALL &&
 				     insn->src_reg != BPF_PSEUDO_KFUNC_CALL) ||
@@ -12425,6 +12471,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->stack_depth = env->subprog_info[i].stack_depth;
 		func[i]->jit_requested = 1;
 		func[i]->aux->kfunc_tab = prog->aux->kfunc_tab;
+		func[i]->aux->kfunc_btf_tab = prog->aux->kfunc_btf_tab;
 		func[i]->aux->linfo = prog->aux->linfo;
 		func[i]->aux->nr_linfo = prog->aux->nr_linfo;
 		func[i]->aux->jited_linfo = prog->aux->jited_linfo;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 791f31dd0abe..4cbb2082a553 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1334,8 +1334,9 @@ union bpf_attr {
 			/* or valid module BTF object fd or 0 to attach to vmlinux */
 			__u32		attach_btf_obj_fd;
 		};
-		__u32		:32;		/* pad */
+		__u32		kfunc_btf_fds_cnt; /* reuse hole for count of BTF fds below */
 		__aligned_u64	fd_array;	/* array of FDs */
+		__aligned_u64   kfunc_btf_fds;  /* array of BTF FDs for module kfunc support */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
-- 
2.33.0

