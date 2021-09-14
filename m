Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E0A40ADF9
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhINMjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbhINMjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22BFC061764;
        Tue, 14 Sep 2021 05:38:24 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d18so8079665pll.11;
        Tue, 14 Sep 2021 05:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tS94kaQlG2vX4CT1TvfjfE1uI4gq2voa3SQwROtG5wc=;
        b=b5G9hIirCbdJ/3Zpq7fldi8IQEFjpKdtzYOqyGd1681B/uUzJ4SxuxosuJbxb610Iw
         XMyQDSQV/Rin+jMbcY6Vg7873V6rqorory1LDA5eSs0v3GMxrHR23WBjyNhdeRngmGXD
         b1GZs4T/ncoQ+XGZCU4oT65y2k81/LuNIYtYYQZEuTtR6kDZB4DOSSUQtagq123gXAEh
         fFJwX7n1DV9ZgqVlncWbuMj3DC4eLD87fBY8b8Dv4aJeI1UCdFWRy21JRRqE3sxp7H0a
         1FfYQi3YzeV7Pis0zztKfOENO7l85wnKl1uQC5qYDaSNC2TK4+Dwj7s+y0TWPw8EpCsw
         zfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tS94kaQlG2vX4CT1TvfjfE1uI4gq2voa3SQwROtG5wc=;
        b=0UT8oITjuG3u1diiyDLWyYNmQYFrYSn2A3NdBo9/X6YU6xWy138vFKogVdLLGSCxMS
         mJkf2TlH7kxUXEZ9hEkqMa/fQfjpxDQGWI8DUOCKdGylrBThRpbFPY9FRJnehBlrVBsB
         ZRD4jOJDxcKdbU9kZSJa64wUT5mPpwjCkna00pXPPQ6Qp6+yBoMJhvzswH7RMrvknbW3
         xZ8+TKu3AB+438cmOcxbXgwwX5T6e7dEdCCVVRwvqgq1O0G6oedXWSVloSzgctlqzrI5
         OlDUSR2kyNUUM/JAN2u9iuFXZrIkZb1WnPOlBdhLVLe2jDOwchdJxhqgax4HMgNp6Mca
         jDXQ==
X-Gm-Message-State: AOAM531XgnvUr8NeCn3RYaKn/PJ8/thVzwEaD+lPSVCTtsdMtBrhx6JC
        6Se4Zdq4Izow/j0pTvh7g1EQcKawJUVI/w==
X-Google-Smtp-Source: ABdhPJxKYLisnvSRl6u5hpUvWHqXyxbBghOJym7Mid+DLuD8BDg9mTlme4CUaZJ1QL231Lo/QjAGfg==
X-Received: by 2002:a17:902:cec8:b0:13b:9ce1:b3ef with SMTP id d8-20020a170902cec800b0013b9ce1b3efmr6281355plg.4.1631623104042;
        Tue, 14 Sep 2021 05:38:24 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id d13sm10306514pfn.114.2021.09.14.05.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:23 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 09/10] libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
Date:   Tue, 14 Sep 2021 18:07:48 +0530
Message-Id: <20210914123750.460750-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8801; h=from:subject; bh=DPIbJoKg4frzr51LEaLuHgculBnpynYjSGmMs82hyAI=; b=owEBbAKT/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdXfipYss2uGEW+VK8l2VJWU0BAyvrpo1hpu3bK yLqvJQiJAjIEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVwAKCRBM4MiGSL8RyjT9D/ imFI5HeSOYi2Wf0l5TXvwG1TWloofB9zuTbZyDeoFNk1kluMGiZ1/CK1Mh11yzxkYjalCO+SB5NiII EpufBvkHTo9+FnviN7qAchxXYHLpEUzRl6NxVaQBA6cnR1I0z3pTircCE18TcXTRqQgZtdQLLrhIML uq3X1ji6q4wrGgf7tC63w2+a/I15I6MYZ0zv1LllpKRl/nhfxMs7yGVxqpDNdfpvB7u5lJe1atHjUC rVChKlv5pH78gi7HXywy+4h6Q70vkkdSJa6CDPn9lAC34gEhHMqFfWtiUrxNq6EXwpxOGaAnTc6LAN wXr8So4qX/4pX7oqe7ltRPxHe5RxIFtmDtrMjvZWC6gXN43es39/GHFBoIUkyfzMueIAAGY96woslp KP1hZTNVY4EUlzAlHbH/4fUdB7cLWMUNaFdcSM7JPkOmetyZSf1OIQuxfzS8MtO1cQtFmUIv9Co4pt 3U05+w0uYWbBy2s9y/lRUN2YdZUZw3IlpJZx1lgLG9NpnVY2Wvz0TycPu7bt+HHZBkSp7Rmx2fdViQ jq+hxlb4endsSzpj2jqS9IleTJZwaouHhgwXV0f043E5OxgIFekFwiu4fGu/WymeZYloqIn3Rae2+O LBmHF/RZkO/R99ohm5tMxW2PCJnePlGm/o/M1CFajUptEDHGV7OTYu9sAx
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
relocations, with support for weak kfunc relocations.

One of the disadvantages of gen_loader is that due to stack size
limitation, BTF fd array size is clamped to a smaller limit than what
the kernel allows. Also, finding an existing BTF fd's slot is not
trivial, because that would require to open all module BTFs and match on
the open fds (like we do for libbpf), so we do the next best thing:
deduplicate slots for the same symbol.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h | 12 ++++-
 tools/lib/bpf/gen_loader.c       | 93 ++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.c           |  8 +--
 3 files changed, 99 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 615400391e57..4826adf18d7b 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -7,8 +7,15 @@ struct ksym_relo_desc {
 	const char *name;
 	int kind;
 	int insn_idx;
+	bool is_weak;
 };
 
+struct kfunc_desc {
+	const char *name;
+	int index;
+};
+
+#define MAX_KFUNC_DESCS 94
 struct bpf_gen {
 	struct gen_loader_opts *opts;
 	void *data_start;
@@ -24,6 +31,8 @@ struct bpf_gen {
 	int relo_cnt;
 	char attach_target[128];
 	int attach_kind;
+	struct kfunc_desc kfunc_descs[MAX_KFUNC_DESCS];
+	__u32 nr_kfuncs;
 };
 
 void bpf_gen__init(struct bpf_gen *gen, int log_level);
@@ -36,6 +45,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
+			    int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 8df718a6b142..5e8c15e36c46 100644
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
@@ -13,6 +14,7 @@
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
 
+/* MAX_BPF_STACK is 768 bytes, so (64 + 32 + 94 (MAX_KFUNC_DESCS) + 2) * 4 */
 #define MAX_USED_MAPS 64
 #define MAX_USED_PROGS 32
 
@@ -31,6 +33,8 @@ struct loader_stack {
 	__u32 btf_fd;
 	__u32 map_fd[MAX_USED_MAPS];
 	__u32 prog_fd[MAX_USED_PROGS];
+	/* Update insn->off store when reordering kfunc_btf_fd */
+	__u32 kfunc_btf_fd[MAX_KFUNC_DESCS];
 	__u32 inner_map_fd;
 };
 
@@ -506,8 +510,8 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 	 */
 }
 
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
-			    int insn_idx)
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -519,14 +523,39 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
 	gen->relos = relo;
 	relo += gen->relo_cnt;
 	relo->name = name;
+	relo->is_weak = is_weak;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
 }
 
+static struct kfunc_desc *find_kfunc_desc(struct bpf_gen *gen, const char *name)
+{
+	/* Try to reuse BTF fd index for repeating symbol */
+	for (int i = 0; i < gen->nr_kfuncs; i++) {
+		if (!strcmp(gen->kfunc_descs[i].name, name))
+			return &gen->kfunc_descs[i];
+	}
+	return NULL;
+}
+
+static struct kfunc_desc *add_kfunc_desc(struct bpf_gen *gen, const char *name)
+{
+	struct kfunc_desc *kdesc;
+
+	if (gen->nr_kfuncs == ARRAY_SIZE(gen->kfunc_descs))
+		return NULL;
+	kdesc = &gen->kfunc_descs[gen->nr_kfuncs];
+	kdesc->name = name;
+	kdesc->index = gen->nr_kfuncs++;
+	return kdesc;
+}
+
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
 {
 	int name, insn, len = strlen(relo->name) + 1;
+	int off = MAX_USED_MAPS + MAX_USED_PROGS;
+	struct kfunc_desc *kdesc;
 
 	pr_debug("gen: emit_relo: %s at %d\n", relo->name, relo->insn_idx);
 	name = add_data(gen, relo->name, len);
@@ -539,18 +568,64 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
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
+		kdesc = find_kfunc_desc(gen, relo->name);
+		if (!kdesc)
+			kdesc = add_kfunc_desc(gen, relo->name);
+		if (kdesc) {
+			/* store btf_obj_fd in index in kfunc_btf_fd array
+			 * but skip storing fd if ret < 0
+			 */
+			emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_10,
+			     stack_off(kfunc_btf_fd[kdesc->index]), 0));
+			emit(gen, BPF_MOV64_REG(BPF_REG_8, BPF_REG_7));
+			emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
+			emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
+			/* if vmlinux BTF, skip store */
+			emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, 0, 1));
+			emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
+			     stack_off(kfunc_btf_fd[kdesc->index])));
+			emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_8));
+			/* remember BTF obj fd */
+			emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_8, 32));
+		} else {
+			pr_warn("Out of BTF fd slots (total: %u), skipping for %s\n",
+				gen->nr_kfuncs, relo->name);
+			emit(gen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_7));
+			emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 32));
+			__emit_sys_close(gen);
+		}
+		/* store index + 1 into insn[insn_idx].off */
+		off = kdesc ? off + kdesc->index + 1 : 0;
+		off = off > INT16_MAX ? 0 : off;
+		/* set a default value */
+		emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), 0));
+		/* skip success case store if ret < 0 */
+		emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
+		/* skip if vmlinux BTF */
+		emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_8, 0, 1));
+		/* store offset */
+		emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), off));
+		/* log relocation */
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_0, offsetof(struct bpf_insn, imm)));
+		emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_8, BPF_REG_0, offsetof(struct bpf_insn, off)));
+		debug_regs(gen, BPF_REG_7, BPF_REG_8, "sym (%s): imm: %%d, off: %%d", relo->name);
 	}
 }
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9c6c1aa73e35..6a100c2e7d1c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6240,12 +6240,12 @@ static int bpf_program__record_externs(struct bpf_program *prog)
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

