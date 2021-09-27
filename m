Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7134196FE
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhI0PCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbhI0PBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C78C061575;
        Mon, 27 Sep 2021 08:00:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s11so18013075pgr.11;
        Mon, 27 Sep 2021 08:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sLvD35TQAg5fScK2rABT6UWa0KNMaDbRArip1oGfUE0=;
        b=NneEMaYU6ACjv6QVAKlN0aACQJu5I5U0fxv+hUO8+MmINXgS9RdZA447pv4gn4E0tr
         h3A0KufHQ8zS18eLLjdzfZCAvv1rq/+ZaAczyzRD7FquyJ2HNF3WgJ87XjbtY2vdUU3I
         zyXFWgr9tkPB3WWq+huiDRH5ODW2/dcvV+ohVgthD/e3PWXCz5lHJjqVO4xIzhAmU2CC
         7CPK2OBlrIInL8NFOyLG8swss5O5wGUAm/aKZzyZIBsDpClKF5d4Nl+GnuuYRl/DkhSF
         vHVHp5NcIVzGJ2B18keBuaFghMa9/zy2Oy8Z7vjpTT1GJWH9c+YZOl05Iy09nP679X43
         IZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sLvD35TQAg5fScK2rABT6UWa0KNMaDbRArip1oGfUE0=;
        b=uzgShVC14owOI0M/Wkx0sV7r3jKyPub0nAU2GTQLoWDCj+0NaR4Q3icm4SIGLyEJ0X
         J/U4sJT/yjN1Iqg4/JVlbFN6JUjvyaon1AgaDsfkqdZcOMwUNKjDRfOczqEx5Yj/04Ld
         u57WV00QB7cH2oIgIB9cGvBb4Mg6zMxF7c28sSYZqeQmghm7CPpEK8Toq8GCIZjRdOJu
         3P2KOky0MtuBA1TSCtaMcZfgh563QHwf8H8U3c8NolovGdyw2cdYFPPCbtX7exSd74ld
         Nc2iYip4yBClabhdEd8YhAVcrNk6fjy5ZfrZQcSWeS8Ty/uOgpRPqvkZikd1sYIxgCG4
         1nbw==
X-Gm-Message-State: AOAM532oxnjm5B7h7cTvgEcMfkdMdLWpbYUqM49eZJYUax7uA3/hs8Un
        /ffGTstlFC2gfJGlUQqArSbXuQXFwg0=
X-Google-Smtp-Source: ABdhPJyt7NTHRrsm1kPBDhKnZYluStdhnGC+pdq2Kw8u1rcJsDAQIk/VB2NIEBkG7doexPLE0i6PFQ==
X-Received: by 2002:a62:5f03:0:b0:445:38d5:98bd with SMTP id t3-20020a625f03000000b0044538d598bdmr320324pfb.81.1632754813861;
        Mon, 27 Sep 2021 08:00:13 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id p17sm12381833pfo.9.2021.09.27.08.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:13 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 09/12] libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
Date:   Mon, 27 Sep 2021 20:29:38 +0530
Message-Id: <20210927145941.1383001-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16905; h=from:subject; bh=fnnjeIgaSooClYn9mVCKrfuzISQ0gfK/+IjxZ4XVMlg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxP0/nVWmPtVIlQPIL+j5jLvImsYH76E9JzPLCE WbfQ1iOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTwAKCRBM4MiGSL8Ryv6vEA CLF5do8D7ojJPGa1SbRAPhWYW+iyzRsWfc1tUHbba9w90Yzt8jFRN+L53sE85AHxPrFC5rlRet647T tZEIS39W2F6N0H60FLIJRiyijVZF/7kx6lABjEglEBeieGS46W5DIz9wSWVBZX9gxNy5jAKrglJE6w E1AQOg9yeuZ0vPhIdHuE6PTvwpFJpQ0g+2gvmJGYRCvFqJK3FhGPsmb+61VT8Yr6TCoeIfrKrdxRCz VialSsnZn4GrZFsn//v/WiLti7ymd2u44ZCN8OfFRzBYAlU17I9/RRodgYI7bqbzytzG0o/Kndhs26 R7gOk0Y094tCR68K0YEcdIGMpT7oBwQOztZmaN37eBq2AIfT9DEV9GvbP+T7wK6wdwN+rDzTopOjIy +db3u3YpaYiVwxaa/dMraKTpzig1qDIaNqRyDTISxd0tfgHHpOua6cE2LmqVzLLWFoldO2c38/FvYA 8JJKA/xOhLrApZVBl0kx9kcWyjAcnBXEC/9IQOcDeDTIha1Pv2DkrwPhEctdU2O8KcEna/JyI9qVk8 nQDGPOCvyAaXBt/jPXXOT6uLIYJysBRnV1916mqJMi9ZRLbYri/XLR+7l9/5fxkJGB0SUrVllew/0C +d3RIshOhUBllCXgd4673wbJQqSreGpL/vkuvUIYujnGVZrb2Uvrg4tRpZ3w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
relocations, with support for weak kfunc relocations. The general idea
is to move map_fds to loader map, and also use the data for storing
kfunc BTF fds. Since both reuse the fd_array parameter, they need to be
kept together.

For map_fds, we reserve MAX_USED_MAPS slots in a region, and for kfunc,
we reserve MAX_KFUNC_DESCS. This is done so that insn->off has more
chances of being <= INT16_MAX than treating data map as a sparse array
and adding fd as needed.

When the MAX_KFUNC_DESCS limit is reached, we fall back to the sparse
array model, so that as long as it does remain <= INT16_MAX, we pass an
index relative to the start of fd_array.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h |  14 +-
 tools/lib/bpf/gen_loader.c       | 243 +++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.c           |   8 +-
 3 files changed, 228 insertions(+), 37 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 615400391e57..b278293599f6 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -7,6 +7,13 @@ struct ksym_relo_desc {
 	const char *name;
 	int kind;
 	int insn_idx;
+	bool is_weak;
+};
+
+struct kfunc_desc {
+	const char *name;
+	int ref;
+	int off;
 };
 
 struct bpf_gen {
@@ -24,6 +31,10 @@ struct bpf_gen {
 	int relo_cnt;
 	char attach_target[128];
 	int attach_kind;
+	struct kfunc_desc *kfuncs;
+	__u32 nr_kfuncs;
+	int fd_array;
+	int nr_fd_array;
 };
 
 void bpf_gen__init(struct bpf_gen *gen, int log_level);
@@ -36,6 +47,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
+			    int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 80087b13877f..4656c6412601 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -16,6 +16,8 @@
 
 #define MAX_USED_MAPS 64
 #define MAX_USED_PROGS 32
+#define MAX_KFUNC_DESCS 256
+#define MAX_FD_ARRAY_SZ (MAX_USED_PROGS + MAX_KFUNC_DESCS)
 
 /* The following structure describes the stack layout of the loader program.
  * In addition R6 contains the pointer to context.
@@ -30,7 +32,6 @@
  */
 struct loader_stack {
 	__u32 btf_fd;
-	__u32 map_fd[MAX_USED_MAPS];
 	__u32 prog_fd[MAX_USED_PROGS];
 	__u32 inner_map_fd;
 };
@@ -143,13 +144,58 @@ static int add_data(struct bpf_gen *gen, const void *data, __u32 size)
 	if (realloc_data_buf(gen, size8))
 		return 0;
 	prev = gen->data_cur;
-	memcpy(gen->data_cur, data, size);
+	if (data)
+		memcpy(gen->data_cur, data, size);
 	gen->data_cur += size;
 	memcpy(gen->data_cur, &zero, size8 - size);
 	gen->data_cur += size8 - size;
 	return prev - gen->data_start;
 }
 
+/* Get index for map_fd/btf_fd slot in reserved fd_array, or in data relative
+ * to start of fd_array. Caller can decide if it is usable or not.
+ */
+static int fd_array_init(struct bpf_gen *gen)
+{
+	if (!gen->fd_array)
+		gen->fd_array = add_data(gen, NULL, MAX_FD_ARRAY_SZ * sizeof(int));
+	return gen->fd_array;
+}
+
+static int add_map_fd(struct bpf_gen *gen)
+{
+	if (!fd_array_init(gen))
+		return 0;
+	if (gen->nr_maps == MAX_USED_MAPS) {
+		pr_warn("Total maps exceeds %d\n", MAX_USED_MAPS);
+		gen->error = -E2BIG;
+		return 0;
+	}
+	return gen->nr_maps++;
+}
+
+static int add_kfunc_btf_fd(struct bpf_gen *gen)
+{
+	int cur;
+
+	if (!fd_array_init(gen))
+		return 0;
+	if (gen->nr_fd_array == MAX_KFUNC_DESCS) {
+		cur = add_data(gen, NULL, sizeof(int));
+		if (!cur)
+			return 0;
+		return (cur - gen->fd_array) / sizeof(int);
+	}
+	return MAX_USED_MAPS + gen->nr_fd_array++;
+}
+
+static int blob_fd_array_off(struct bpf_gen *gen, int index)
+{
+	if (!gen->fd_array)
+		return 0;
+	return gen->fd_array + (index * sizeof(int));
+}
+
 static int insn_bytes_to_bpf_size(__u32 sz)
 {
 	switch (sz) {
@@ -171,14 +217,22 @@ static void emit_rel_store(struct bpf_gen *gen, int off, int data)
 	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
 }
 
-/* *(u64 *)(blob + off) = (u64)(void *)(%sp + stack_off) */
-static void emit_rel_store_sp(struct bpf_gen *gen, int off, int stack_off)
+static void move_blob2blob(struct bpf_gen *gen, int off, int size, int blob_off)
 {
-	emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_10));
-	emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, stack_off));
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_7, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, blob_off));
+	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_7, 0));
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
 					 0, 0, 0, off));
-	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
+	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_1, BPF_REG_0, 0));
+}
+
+static void move_blob2ctx(struct bpf_gen *gen, int ctx_off, int size, int blob_off)
+{
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, blob_off));
+	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_1, 0));
+	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_6, BPF_REG_0, ctx_off));
 }
 
 static void move_ctx2blob(struct bpf_gen *gen, int off, int size, int ctx_off,
@@ -326,11 +380,11 @@ int bpf_gen__finish(struct bpf_gen *gen)
 			       offsetof(struct bpf_prog_desc, prog_fd), 4,
 			       stack_off(prog_fd[i]));
 	for (i = 0; i < gen->nr_maps; i++)
-		move_stack2ctx(gen,
-			       sizeof(struct bpf_loader_ctx) +
-			       sizeof(struct bpf_map_desc) * i +
-			       offsetof(struct bpf_map_desc, map_fd), 4,
-			       stack_off(map_fd[i]));
+		move_blob2ctx(gen,
+			      sizeof(struct bpf_loader_ctx) +
+			      sizeof(struct bpf_map_desc) * i +
+			      offsetof(struct bpf_map_desc, map_fd), 4,
+			      blob_fd_array_off(gen, i));
 	emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
 	emit(gen, BPF_EXIT_INSN());
 	pr_debug("gen: finish %d\n", gen->error);
@@ -390,7 +444,7 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 {
 	int attr_size = offsetofend(union bpf_attr, btf_vmlinux_value_type_id);
 	bool close_inner_map_fd = false;
-	int map_create_attr;
+	int map_create_attr, idx;
 	union bpf_attr attr;
 
 	memset(&attr, 0, attr_size);
@@ -467,9 +521,11 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 		gen->error = -EDOM; /* internal bug */
 		return;
 	} else {
-		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
-				      stack_off(map_fd[map_idx])));
-		gen->nr_maps++;
+		/* add_map_fd does gen->nr_maps++ */
+		idx = add_map_fd(gen);
+		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+						 0, 0, 0, blob_fd_array_off(gen, idx)));
+		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_7, 0));
 	}
 	if (close_inner_map_fd)
 		emit_sys_close_stack(gen, stack_off(inner_map_fd));
@@ -511,8 +567,8 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 	 */
 }
 
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
-			    int insn_idx)
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -524,11 +580,119 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
 	gen->relos = relo;
 	relo += gen->relo_cnt;
 	relo->name = name;
+	relo->is_weak = is_weak;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
 }
 
+/* returns existing kfunc_desc with ref incremented, or inserts a new one */
+static struct kfunc_desc *get_kfunc_desc(struct bpf_gen *gen, const char *name)
+{
+	struct kfunc_desc *kdesc;
+
+	for (int i = 0; i < gen->nr_kfuncs; i++) {
+		if (!strcmp(gen->kfuncs[i].name, name)) {
+			gen->kfuncs[i].ref++;
+			return &gen->kfuncs[i];
+		}
+	}
+	kdesc = libbpf_reallocarray(gen->kfuncs, gen->nr_kfuncs + 1, sizeof(*kdesc));
+	if (!kdesc) {
+		gen->error = -ENOMEM;
+		return NULL;
+	}
+	gen->kfuncs = kdesc;
+	kdesc = &gen->kfuncs[gen->nr_kfuncs++];
+	kdesc->name = name;
+	kdesc->ref = 1;
+	kdesc->off = 0;
+	return kdesc;
+}
+
+/* Expects:
+ * BPF_REG_0 - pointer to instruction
+ * BPF_REG_7 - return value of bpf_btf_find_by_name_kind
+ *
+ * We need to reuse BTF fd for same symbol otherwise each relocation takes a new
+ * index, while kernel limits total kfunc BTFs to 256. For duplicate symbols,
+ * this would mean a new BTF fd index for each entry. By pairing symbol name
+ * with index, we get the insn->imm, insn->off pairing that kernel uses for
+ * kfunc_tab, which becomes the effective limit even though all of them may
+ * share same index in fd_array (such that kfunc_btf_tab has 1 element).
+ */
+static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
+{
+	struct kfunc_desc *kdesc;
+	int btf_fd_idx;
+
+	kdesc = get_kfunc_desc(gen, relo->name);
+	if (!kdesc)
+		return;
+
+	btf_fd_idx = kdesc->ref > 1 ? kdesc->off : add_kfunc_btf_fd(gen);
+	if (btf_fd_idx > INT16_MAX) {
+		pr_warn("BTF fd off %d for kfunc %s exceeds INT16_MAX, cannot process relocation\n",
+			btf_fd_idx, relo->name);
+		gen->error = -E2BIG;
+		return;
+	}
+	/* load slot pointer */
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, blob_fd_array_off(gen, btf_fd_idx)));
+	/* Try to map one insn->off to one insn->imm */
+	if (kdesc->ref > 1) {
+		emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
+		goto skip_btf_fd;
+	} else {
+		/* cannot use index == 0 */
+		if (!btf_fd_idx) {
+			btf_fd_idx = add_kfunc_btf_fd(gen);
+			/* shift to next slot */
+			emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_8, sizeof(int)));
+		}
+		kdesc->off = btf_fd_idx;
+	}
+
+	/* set a default value */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, 0, 0));
+	emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
+	/* store BTF fd if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 3));
+	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
+	/* store BTF fd in slot */
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, 0));
+	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_9));
+skip_btf_fd:
+	/* remember BTF fd to skip insn->off store for vmlinux case */
+	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
+	/* set a default value */
+	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), 0));
+	/* skip insn->off store if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
+	/* skip if vmlinux BTF */
+	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_9, 0, 1));
+	/* store index into insn[insn_idx].off */
+	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), btf_fd_idx));
+	/* close fd that we skipped storing in fd_array */
+	if (kdesc->ref > 1) {
+		emit(gen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_9));
+		__emit_sys_close(gen);
+	}
+	if (!gen->log_level)
+		return;
+	/* reload register 0, overwritten by sys_close */
+	if (kdesc->ref > 1)
+		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
+						 0, 0, 0, insn));
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_0,
+			      offsetof(struct bpf_insn, imm)));
+	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_8, BPF_REG_0,
+			      offsetof(struct bpf_insn, off)));
+	debug_regs(gen, BPF_REG_7, BPF_REG_8, "sym (%s:count=%d): imm: %%d, off: %%d",
+		   relo->name, kdesc->ref);
+}
+
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
 {
 	int name, insn, len = strlen(relo->name) + 1;
@@ -544,18 +708,24 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
 	emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
 	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
 	debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
-	emit_check_err(gen);
+	/* if not weak kfunc, emit err check */
+	if (relo->kind != BTF_KIND_FUNC || !relo->is_weak)
+		emit_check_err(gen);
+	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx;
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
+	/* set a default value */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_0, offsetof(struct bpf_insn, imm), 0));
+	/* skip success case store if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 1));
 	/* store btf_id into insn[insn_idx].imm */
-	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx +
-		offsetof(struct bpf_insn, imm);
-	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
-					 0, 0, 0, insn));
-	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, 0));
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, offsetof(struct bpf_insn, imm)));
 	if (relo->kind == BTF_KIND_VAR) {
 		/* store btf_obj_fd into insn[insn_idx + 1].imm */
 		emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
 		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7,
-				      sizeof(struct bpf_insn)));
+				      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
+	} else if (relo->kind == BTF_KIND_FUNC) {
+		emit_relo_kfunc_btf(gen, relo, insn);
 	}
 }
 
@@ -571,6 +741,16 @@ static void cleanup_relos(struct bpf_gen *gen, int insns)
 {
 	int i, insn;
 
+	for (i = 0; i < gen->nr_kfuncs; i++) {
+		emit_sys_close_blob(gen, blob_fd_array_off(gen, gen->kfuncs[i].off));
+		if (gen->kfuncs[i].off < MAX_FD_ARRAY_SZ)
+			gen->nr_fd_array--;
+	}
+	if (gen->nr_kfuncs) {
+		free(gen->kfuncs);
+		gen->nr_kfuncs = 0;
+		gen->kfuncs = NULL;
+	}
 	for (i = 0; i < gen->relo_cnt; i++) {
 		if (gen->relos[i].kind != BTF_KIND_VAR)
 			continue;
@@ -637,9 +817,8 @@ void bpf_gen__prog_load(struct bpf_gen *gen,
 	/* populate union bpf_attr with a pointer to line_info */
 	emit_rel_store(gen, attr_field(prog_load_attr, line_info), line_info);
 
-	/* populate union bpf_attr fd_array with a pointer to stack where map_fds are saved */
-	emit_rel_store_sp(gen, attr_field(prog_load_attr, fd_array),
-			  stack_off(map_fd[0]));
+	/* populate union bpf_attr fd_array with a pointer to data where map_fds are saved */
+	emit_rel_store(gen, attr_field(prog_load_attr, fd_array), gen->fd_array);
 
 	/* populate union bpf_attr with user provided log details */
 	move_ctx2blob(gen, attr_field(prog_load_attr, log_level), 4,
@@ -706,8 +885,8 @@ void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *pvalue,
 	emit(gen, BPF_EMIT_CALL(BPF_FUNC_copy_from_user));
 
 	map_update_attr = add_data(gen, &attr, attr_size);
-	move_stack2blob(gen, attr_field(map_update_attr, map_fd), 4,
-			stack_off(map_fd[map_idx]));
+	move_blob2blob(gen, attr_field(map_update_attr, map_fd), 4,
+		       blob_fd_array_off(gen, map_idx));
 	emit_rel_store(gen, attr_field(map_update_attr, key), key);
 	emit_rel_store(gen, attr_field(map_update_attr, value), value);
 	/* emit MAP_UPDATE_ELEM command */
@@ -725,8 +904,8 @@ void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx)
 	memset(&attr, 0, attr_size);
 	pr_debug("gen: map_freeze: idx %d\n", map_idx);
 	map_freeze_attr = add_data(gen, &attr, attr_size);
-	move_stack2blob(gen, attr_field(map_freeze_attr, map_fd), 4,
-			stack_off(map_fd[map_idx]));
+	move_blob2blob(gen, attr_field(map_freeze_attr, map_fd), 4,
+		       blob_fd_array_off(gen, map_idx));
 	/* emit MAP_FREEZE command */
 	emit_sys_bpf(gen, BPF_MAP_FREEZE, map_freeze_attr, attr_size);
 	debug_ret(gen, "map_freeze");
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4b2d0511c1e7..b7c11eb40766 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6268,12 +6268,12 @@ static int bpf_program__record_externs(struct bpf_program *prog)
 					ext->name);
 				return -ENOTSUP;
 			}
-			bpf_gen__record_extern(obj->gen_loader, ext->name, BTF_KIND_VAR,
-					       relo->insn_idx);
+			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
+					       BTF_KIND_VAR, relo->insn_idx);
 			break;
 		case RELO_EXTERN_FUNC:
-			bpf_gen__record_extern(obj->gen_loader, ext->name, BTF_KIND_FUNC,
-					       relo->insn_idx);
+			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
+					       BTF_KIND_FUNC, relo->insn_idx);
 			break;
 		default:
 			continue;
-- 
2.33.0

