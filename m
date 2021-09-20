Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750D84116A5
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbhITORb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237173AbhITORY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9F5C061574;
        Mon, 20 Sep 2021 07:15:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so34236pjb.1;
        Mon, 20 Sep 2021 07:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9SO3kL5K2fSLEp8aEfH2nqz/JNKO6SY8nNAA+9KbF94=;
        b=CFeXiRwZFkha2+6K5c24ivK4mldUgcZtsl10wijX9jmWIF6CUHyqRqKEFZSr2JRaU2
         nun07B0bROEV03CqQrhh0g8LpGO+tF8BUcrOsKnvvQ3HSlMdvLJgbgQP/NqH2+ADMADn
         Rk2byIiLHYFgUwD0dOmGdgQpL9/a0w8QGTh1zPuZUAamscSb6SiKMasMmAHqUoNe5gPh
         0ihmy59g6gNsKJIWwN4j9tZPaY0XZZVZVCV400zTt/23+m6xQ6d4B1ublbV6chbw+BvW
         mUueEv8GlZIAP+/3njyoo064IVe1aqpiueFDY3hPqIO49Zu6EtLclokkGP/lJeAN3BZ2
         YH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9SO3kL5K2fSLEp8aEfH2nqz/JNKO6SY8nNAA+9KbF94=;
        b=c6nkTRNgvE97k5v4TEF56VvgP0ug/McWfsTttILtR1zeduhXwG9YBMwTC4RM+lxC7V
         OusaaePN4jNl/E2IUfzfKBh3qXiUs1MuNLGl1DxBwPk96/uEuXVoQ9BikwzesHtV4c10
         a7UpeUXGnlqgq+MjJVnzl1T2pi0IiEIg3zd3dRf5Tu8i5EYKjsYRRqwAoA9bElAn454J
         NuXpKdmcr9RU1+eHknE234lJVNkdXVQYKW5xp3r5VxTk3i4nvWZvnTebODurfDEBWuUD
         BQH7DIMNaM+rOKOS9xQrUvTfoWbhLYxjNd3s8BH/kPYS2yv7xcQGSZLBGYGdVG0c1qYr
         d7Bg==
X-Gm-Message-State: AOAM531joYExV6Ralg+eHBr8wdQeTbanyGne5e7YVwkUqzVyjBQ08z3c
        Y3qhtrQal3HLgp0vzPkVqfTbp0fxmeInxA==
X-Google-Smtp-Source: ABdhPJyfbrcR4e4w3gNlo0vjDEfGK1J8JvQFzSOANC+5miaK+T3kNBIPUgn5R31ubcdCjiYWUNJK2Q==
X-Received: by 2002:a17:902:d202:b0:13a:709b:dfb0 with SMTP id t2-20020a170902d20200b0013a709bdfb0mr23057456ply.34.1632147356549;
        Mon, 20 Sep 2021 07:15:56 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id n15sm12850973pjj.36.2021.09.20.07.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:56 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 08/11] libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
Date:   Mon, 20 Sep 2021 19:45:23 +0530
Message-Id: <20210920141526.3940002-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=20790; h=from:subject; bh=9CJC2xQ8mHQae/Vr5ETzWMQvkQtSSCIGi9QHwLsnR3s=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaE59gJH3MXM0Yklle2XZJRrdcX7KlPXwZ6H4pK Da3ewOiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8Ryln7D/ kBsJ3zzlwBE3U9VnUlxD51pQL64PomtIsVXUpR/OcZMO6zXviPHacvT7P1lQNJynZLmGmJY1emtQOC U9cTeXI/Mqx37tGbJNDDyn3xlUibSFKnVg/X2VvUHM4tDzOcfkiflWMbEwfyeBDW5tCpK5GTw+ErhI 1p8LpvT3Lcs1dWz1po5x++NK00rDvI2DHBZr1xjNNH9UWjDkB6LRDQjugRUfHHAx+h3UyNLFgX/YZ9 MOewp70tEmFaw9nQZc1J6gtj8u2QARnW+LzQYRD9G6vxPoVo0Jt+1NRBDYNYSJox/fR1tMgdpevalL xzy/bN9eWKc6G1T+sz9CSnvYzsL8QEptBRRd4ceQ2BpRCcAyzrGaPCYVus8IE/bAOPep/KVvUwfiO+ pGuJKeWcILm4cAu2G7Jhh7hlrWhhg0wGMhPLxxzZpBAXPxzzJwpQNaIkthF+VBpO+3VY8uX9Rg9Bmm 84xPMAckJlTQ9ulVtnABp6sqlIT6eQRqnoctQCqRISO+NCSzerkpkeDAmlBKYUEFvKl8c80RK6rxiW kjhLPtGEcsUGZH1Aoy2KCwFClylM+Y2DgYyIPYjhW/uV/w3KnFilK0DRy/fE4EEO7HdON2eIBIcv+N QszZ3YrLJLgjxF/VnaoTXvysrGd5OLgLYQSOneqvGISls423Nr5NFHrL7mhg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
relocations, with support for weak kfunc relocations. The next commit
adds bpftool supports to set up the fd_array_sz parameter for light
skeleton.

A second map for keeping fds is used instead of adding fds to existing
loader.map because of following reasons:

If reserving an area for map and BTF fds, we would waste the remaining
of (MAX_USED_MAPS + MAX_KFUNC_DESCS) * sizeof(int), which in most cases
will be unused by the program. Also, we must place some limit on the
amount of map and BTF fds a program can possibly open.

If setting gen->fd_array to first map_fd offset, and then just finding
the offset relative to this (for later BTF fds), such that they can be
packed without wasting space, we run the risk of unnecessarily running
out of valid offset for emit_relo stage (for kfuncs), because gen map
creation and relocation stages are separated by other steps that can add
lots of data (including bpf_object__populate_internal_map). It is also
prone to break silently if features are added between map and BTF fd
emits that possibly add more data (just ~128KB to break BTF fd, since
insn->off allows for INT16_MAX (32767) * 4 bytes).

Both of these issues are compounded by the fact that data map is shared
by all programs, so it is easy to end up with invalid offset for BTF fd.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h |  16 ++-
 tools/lib/bpf/gen_loader.c       | 222 ++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.c           |   8 +-
 tools/lib/bpf/libbpf.h           |   1 +
 tools/lib/bpf/skel_internal.h    |  27 +++-
 5 files changed, 230 insertions(+), 44 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 615400391e57..c4aa86865b65 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -7,6 +7,16 @@ struct ksym_relo_desc {
 	const char *name;
 	int kind;
 	int insn_idx;
+	bool is_weak;
+};
+
+/* maximum distinct calls */
+#define MAX_KFUNC_DESCS 256
+
+struct kfunc_desc {
+	const char *name;
+	int ref;
+	int off;
 };
 
 struct bpf_gen {
@@ -23,7 +33,10 @@ struct bpf_gen {
 	struct ksym_relo_desc *relos;
 	int relo_cnt;
 	char attach_target[128];
+	struct kfunc_desc kdescs[MAX_KFUNC_DESCS];
 	int attach_kind;
+	__u32 nr_kfuncs;
+	int fd_array_sz;
 };
 
 void bpf_gen__init(struct bpf_gen *gen, int log_level);
@@ -36,6 +49,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
+			    int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 8df718a6b142..c471e0844b22 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -5,6 +5,7 @@
 #include <string.h>
 #include <errno.h>
 #include <linux/filter.h>
+#include <linux/kernel.h>
 #include "btf.h"
 #include "bpf.h"
 #include "libbpf.h"
@@ -13,7 +14,6 @@
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
 
-#define MAX_USED_MAPS 64
 #define MAX_USED_PROGS 32
 
 /* The following structure describes the stack layout of the loader program.
@@ -26,10 +26,10 @@
  * stack - bpf program stack
  * blob - bpf_attr-s, strings, insns, map data.
  *        All the bytes that loader prog will use for read/write.
+ * fd_blob - map fds, kfunc module btf fds
  */
 struct loader_stack {
 	__u32 btf_fd;
-	__u32 map_fd[MAX_USED_MAPS];
 	__u32 prog_fd[MAX_USED_PROGS];
 	__u32 inner_map_fd;
 };
@@ -145,6 +145,16 @@ static int add_data(struct bpf_gen *gen, const void *data, __u32 size)
 	return prev - gen->data_start;
 }
 
+/* return offset in fd_blob */
+static int add_fd(struct bpf_gen *gen)
+{
+	int prev;
+
+	prev = gen->fd_array_sz;
+	gen->fd_array_sz += sizeof(int);
+	return prev;
+}
+
 static int insn_bytes_to_bpf_size(__u32 sz)
 {
 	switch (sz) {
@@ -166,16 +176,34 @@ static void emit_rel_store(struct bpf_gen *gen, int off, int data)
 	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
 }
 
-/* *(u64 *)(blob + off) = (u64)(void *)(%sp + stack_off) */
-static void emit_rel_store_sp(struct bpf_gen *gen, int off, int stack_off)
+/* *(u64 *)(blob + off) = (u64)(void *)(fd_blob + data) */
+static void emit_rel_store_fd(struct bpf_gen *gen, int off, int data)
 {
-	emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_10));
-	emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, stack_off));
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 1, data));
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
 					 0, 0, 0, off));
 	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
 }
 
+static void move_fd_blob2blob(struct bpf_gen *gen, int off, int size, int blob_off)
+{
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, off));
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_7, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 1, blob_off));
+	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_7, 0));
+	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_1, BPF_REG_0, 0));
+}
+
+static void move_fd_blob2ctx(struct bpf_gen *gen, int off, int size, int blob_off)
+{
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 1, blob_off));
+	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_1, 0));
+	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_6, BPF_REG_0, off));
+}
+
 static void move_ctx2blob(struct bpf_gen *gen, int off, int size, int ctx_off,
 				   bool check_non_zero)
 {
@@ -300,14 +328,24 @@ static void emit_sys_close_stack(struct bpf_gen *gen, int stack_off)
 	__emit_sys_close(gen);
 }
 
-static void emit_sys_close_blob(struct bpf_gen *gen, int blob_off)
+static void __emit_sys_close_blob(struct bpf_gen *gen, int blob_idx, int blob_off)
 {
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
-					 0, 0, 0, blob_off));
+					 0, 0, blob_idx, blob_off));
 	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0));
 	__emit_sys_close(gen);
 }
 
+static void emit_sys_close_blob(struct bpf_gen *gen, int blob_off)
+{
+	__emit_sys_close_blob(gen, 0, blob_off);
+}
+
+static void emit_sys_close_fd_blob(struct bpf_gen *gen, int blob_off)
+{
+	__emit_sys_close_blob(gen, 1, blob_off);
+}
+
 int bpf_gen__finish(struct bpf_gen *gen)
 {
 	int i;
@@ -321,11 +359,11 @@ int bpf_gen__finish(struct bpf_gen *gen)
 			       offsetof(struct bpf_prog_desc, prog_fd), 4,
 			       stack_off(prog_fd[i]));
 	for (i = 0; i < gen->nr_maps; i++)
-		move_stack2ctx(gen,
-			       sizeof(struct bpf_loader_ctx) +
-			       sizeof(struct bpf_map_desc) * i +
-			       offsetof(struct bpf_map_desc, map_fd), 4,
-			       stack_off(map_fd[i]));
+		move_fd_blob2ctx(gen,
+			      sizeof(struct bpf_loader_ctx) +
+			      sizeof(struct bpf_map_desc) * i +
+			      offsetof(struct bpf_map_desc, map_fd), 4,
+			      sizeof(int) * i);
 	emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
 	emit(gen, BPF_EXIT_INSN());
 	pr_debug("gen: finish %d\n", gen->error);
@@ -336,6 +374,7 @@ int bpf_gen__finish(struct bpf_gen *gen)
 		opts->insns_sz = gen->insn_cur - gen->insn_start;
 		opts->data = gen->data_start;
 		opts->data_sz = gen->data_cur - gen->data_start;
+		opts->fd_array_sz = gen->fd_array_sz;
 	}
 	return gen->error;
 }
@@ -385,7 +424,7 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 {
 	int attr_size = offsetofend(union bpf_attr, btf_vmlinux_value_type_id);
 	bool close_inner_map_fd = false;
-	int map_create_attr;
+	int map_create_attr, off;
 	union bpf_attr attr;
 
 	memset(&attr, 0, attr_size);
@@ -462,8 +501,10 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 		gen->error = -EDOM; /* internal bug */
 		return;
 	} else {
-		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
-				      stack_off(map_fd[map_idx])));
+		off = add_fd(gen);
+		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+						 0, 0, 1, off));
+		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_7, 0));
 		gen->nr_maps++;
 	}
 	if (close_inner_map_fd)
@@ -506,8 +547,8 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 	 */
 }
 
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
-			    int insn_idx)
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -519,11 +560,119 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
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
+		if (!strcmp(gen->kdescs[i].name, name)) {
+			gen->kdescs[i].ref++;
+			return &gen->kdescs[i];
+		}
+	}
+	if (gen->nr_kfuncs == ARRAY_SIZE(gen->kdescs))
+		return NULL;
+	kdesc = &gen->kdescs[gen->nr_kfuncs++];
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
+	struct kfunc_desc *kdesc, def_kdesc;
+	int off, btf_fd;
+
+	kdesc = get_kfunc_desc(gen, relo->name);
+	if (!kdesc) {
+		/* Fallback to storing fd in fd_array, and let kernel handle too many BTFs/kfuncs */
+		pr_warn("Out of slots for kfunc %s, disabled BTF fd dedup for relocation\n",
+			relo->name);
+		def_kdesc.name = relo->name;
+		def_kdesc.ref = 1;
+		def_kdesc.off = 0;
+		kdesc = &def_kdesc;
+	}
+
+	btf_fd = kdesc->ref > 1 ? kdesc->off : add_fd(gen);
+	/* load slot pointer */
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 1, btf_fd));
+	/* Try to map one insn->off to one insn->imm */
+	if (kdesc->ref > 1) {
+		emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
+		goto skip_btf_fd;
+	} else {
+		/* cannot use index == 0 */
+		if (!btf_fd) {
+			btf_fd = add_fd(gen);
+			/* shift to next slot */
+			emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_8, sizeof(int)));
+		}
+		kdesc->off = btf_fd;
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
+	/* store index into insn[insn_idx].off */
+	off = btf_fd / sizeof(int);
+	off = off > INT16_MAX ? 0 : off;
+	/* set a default value */
+	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), 0));
+	/* skip insn->off store if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
+	/* skip if vmlinux BTF */
+	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_9, 0, 1));
+	/* store insn->off as the index of BTF fd */
+	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), off));
+	/* close fd that we skipped storing in fd_array map */
+	if (kdesc->ref > 1) {
+		emit(gen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_9));
+		__emit_sys_close(gen);
+	}
+	if (gen->log_level) {
+		/* reload register 0, overwritten by sys_close */
+		if (kdesc->ref > 1)
+			emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
+							 0, 0, 0, insn));
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_0,
+				      offsetof(struct bpf_insn, imm)));
+		emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_8, BPF_REG_0,
+				      offsetof(struct bpf_insn, off)));
+		debug_regs(gen, BPF_REG_7, BPF_REG_8, "sym (%s:%d): imm: %%d, off: %%d",
+			   relo->name, kdesc->ref);
+	}
+}
+
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
 {
 	int name, insn, len = strlen(relo->name) + 1;
@@ -539,18 +688,24 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
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
 
@@ -558,6 +713,8 @@ static void emit_relos(struct bpf_gen *gen, int insns)
 {
 	int i;
 
+	/* clear kfunc_desc table */
+	gen->nr_kfuncs = 0;
 	for (i = 0; i < gen->relo_cnt; i++)
 		emit_relo(gen, gen->relos + i, insns);
 }
@@ -566,6 +723,8 @@ static void cleanup_relos(struct bpf_gen *gen, int insns)
 {
 	int i, insn;
 
+	for (i = 0; i < gen->nr_kfuncs; i++)
+		emit_sys_close_fd_blob(gen, gen->kdescs[i].off);
 	for (i = 0; i < gen->relo_cnt; i++) {
 		if (gen->relos[i].kind != BTF_KIND_VAR)
 			continue;
@@ -632,9 +791,8 @@ void bpf_gen__prog_load(struct bpf_gen *gen,
 	/* populate union bpf_attr with a pointer to line_info */
 	emit_rel_store(gen, attr_field(prog_load_attr, line_info), line_info);
 
-	/* populate union bpf_attr fd_array with a pointer to stack where map_fds are saved */
-	emit_rel_store_sp(gen, attr_field(prog_load_attr, fd_array),
-			  stack_off(map_fd[0]));
+	/* populate union bpf_attr fd_array with a pointer to data where map_fds are saved */
+	emit_rel_store_fd(gen, attr_field(prog_load_attr, fd_array), 0);
 
 	/* populate union bpf_attr with user provided log details */
 	move_ctx2blob(gen, attr_field(prog_load_attr, log_level), 4,
@@ -701,8 +859,8 @@ void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *pvalue,
 	emit(gen, BPF_EMIT_CALL(BPF_FUNC_copy_from_user));
 
 	map_update_attr = add_data(gen, &attr, attr_size);
-	move_stack2blob(gen, attr_field(map_update_attr, map_fd), 4,
-			stack_off(map_fd[map_idx]));
+	move_fd_blob2blob(gen, attr_field(map_update_attr, map_fd), 4,
+			  sizeof(int) * map_idx);
 	emit_rel_store(gen, attr_field(map_update_attr, key), key);
 	emit_rel_store(gen, attr_field(map_update_attr, value), value);
 	/* emit MAP_UPDATE_ELEM command */
@@ -720,8 +878,8 @@ void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx)
 	memset(&attr, 0, attr_size);
 	pr_debug("gen: map_freeze: idx %d\n", map_idx);
 	map_freeze_attr = add_data(gen, &attr, attr_size);
-	move_stack2blob(gen, attr_field(map_freeze_attr, map_fd), 4,
-			stack_off(map_fd[map_idx]));
+	move_fd_blob2blob(gen, attr_field(map_freeze_attr, map_fd), 4,
+			  sizeof(int) * map_idx);
 	/* emit MAP_FREEZE command */
 	emit_sys_bpf(gen, BPF_MAP_FREEZE, map_freeze_attr, attr_size);
 	debug_ret(gen, "map_freeze");
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3c195eaadf56..77dffb66c1fd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6264,12 +6264,12 @@ static int bpf_program__record_externs(struct bpf_program *prog)
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
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c90e3d79e72c..fdcdcfab5bce 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -885,6 +885,7 @@ struct gen_loader_opts {
 	const char *insns;
 	__u32 data_sz;
 	__u32 insns_sz;
+	__u32 fd_array_sz;
 };
 
 #define gen_loader_opts__last_field insns_sz
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index b22b50c1b173..6c0f0adfd42f 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -44,6 +44,7 @@ struct bpf_load_and_run_opts {
 	const void *insns;
 	__u32 data_sz;
 	__u32 insns_sz;
+	__u32 fd_array_sz;
 	const char *errstr;
 };
 
@@ -62,31 +63,41 @@ static inline int skel_closenz(int fd)
 
 static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
 {
-	int map_fd = -1, prog_fd = -1, key = 0, err;
+	int map_fd[2] = {-1, -1}, prog_fd = -1, key = 0, err;
 	union bpf_attr attr;
 
-	map_fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
+	map_fd[0] = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.map", 4,
 				     opts->data_sz, 1, 0);
-	if (map_fd < 0) {
+	if (map_fd[0] < 0) {
 		opts->errstr = "failed to create loader map";
 		err = -errno;
 		goto out;
 	}
 
-	err = bpf_map_update_elem(map_fd, &key, opts->data, 0);
+	err = bpf_map_update_elem(map_fd[0], &key, opts->data, 0);
 	if (err < 0) {
 		opts->errstr = "failed to update loader map";
 		err = -errno;
 		goto out;
 	}
 
+	if (opts->fd_array_sz) {
+		map_fd[1] = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "__loader.fd.map", 4,
+						opts->fd_array_sz, 1, 0);
+		if (map_fd[1] < 0) {
+			opts->errstr = "failed to create loader fd map";
+			err = -errno;
+			goto out;
+		}
+	}
+
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = BPF_PROG_TYPE_SYSCALL;
 	attr.insns = (long) opts->insns;
 	attr.insn_cnt = opts->insns_sz / sizeof(struct bpf_insn);
 	attr.license = (long) "Dual BSD/GPL";
 	memcpy(attr.prog_name, "__loader.prog", sizeof("__loader.prog"));
-	attr.fd_array = (long) &map_fd;
+	attr.fd_array = (long) map_fd;
 	attr.log_level = opts->ctx->log_level;
 	attr.log_size = opts->ctx->log_size;
 	attr.log_buf = opts->ctx->log_buf;
@@ -113,8 +124,10 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
 	}
 	err = 0;
 out:
-	if (map_fd >= 0)
-		close(map_fd);
+	if (map_fd[0] >= 0)
+		close(map_fd[0]);
+	if (map_fd[1] >= 0)
+		close(map_fd[1]);
 	if (prog_fd >= 0)
 		close(prog_fd);
 	return err;
-- 
2.33.0

