Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2BF4234F1
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhJFAa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbhJFAay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:30:54 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D83CC061762;
        Tue,  5 Oct 2021 17:29:03 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so950997pjb.4;
        Tue, 05 Oct 2021 17:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uh/Ou0s/CMNDG6mn/Axnv2eioDOJrkUwiVyx/o94Fl0=;
        b=T1Ds1AEIhXHNuFfK6prnn7mWThF2AZSrSJ0pSP0xqHEV/vs0YPwIKvIwtF3uUTtHNw
         rAVztRnnBrCixFMPmdpBh8/+61g2ez04HpvnOiGrSDsJZIk3WeRmRFCjqrreHkWFS9db
         78XRzkWqAhauBiLX5nT1gM1Mh8wcQNeGj60gG72bw1GjJVKKhwBz0fuBgoV12xUzKRP6
         lGAVDFe2QVcUNnErdJo3AUEcTy5DDSyNknc/88+aj6ubaUck6Bw8z/sbaFU3CiR8lRTK
         WSithvBkXaxOfHHpDOzYEX3yKir6axsHg/3UHd9IpNEdDS08mnCRkScjGdqEzMysEGha
         DXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uh/Ou0s/CMNDG6mn/Axnv2eioDOJrkUwiVyx/o94Fl0=;
        b=prUwBYHwjfqCn29IqjzWHIEWrgRyR5xmeAL+u43QId3Zn6cKLzbd/7EmMdmVT2qcxa
         Xk3a8LeRaD2GPLN+4wd3I/IizI5DDdGAWTKPgg3E6OfrKrk+bga47GUmUd4BmfCE7pyF
         S80Oz7eSq7GC6jtHUyN02wQibIuf/xo3WLEeQ2AYr8ns6vDcDhNvq0cw/pjiKfPFAUKy
         SxlGbIQlPLMUO0cGWYRgtDJOg3BCvD0TrCbCpammlLMHIfbhrdbPk0GbFTHvSHklOOxG
         x5evHS9jibiEKi8CaL+QcKeM4pu6YIukxfaAU+JE+YjBu4MRhnpDvUEbQi+8oD/TrNtV
         scOQ==
X-Gm-Message-State: AOAM5320C5oJCTAiHVt1LDXMN3j9r147Cs+tYqgavP9JzJHSlhjmds5C
        TCvJD66NFtjcSO72wVMw4TFjMKPYDVI=
X-Google-Smtp-Source: ABdhPJwu5uXDQXKJDi6dYxcNuBDojVNCWMGx3o4jZaIXJUxPrO20jvxE8t0NlzbxbxWi/Le0pPyG3Q==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr7435966pjs.48.1633480142559;
        Tue, 05 Oct 2021 17:29:02 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id 139sm18583339pfz.35.2021.10.05.17.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:29:02 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 2/6] libbpf: Add typeless and weak ksym support to gen_loader
Date:   Wed,  6 Oct 2021 05:58:49 +0530
Message-Id: <20211006002853.308945-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006002853.308945-1-memxor@gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11735; h=from:subject; bh=DR1QI2yh+aSqpVAYNgwwUlnqqIaXbxa7jiFlgZcLvzA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxPKMl2qOVMhuXjWP1BHGcE8E6/g0SJ4Rvt8k6E 9b9nw6qJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsTwAKCRBM4MiGSL8RygwkD/ 4sBkFmrXb9GtjBH1QrQ8PPYboWmPSfhhs+HD6sKaMVwcoLa8aAB25EzCopzwYdGIEPZnzwJw6p05PW gAsbiFykpDUoY3XsX7c3umY5Im7X+bdq4jjVo8X58ZtSYqOoDQLltxecSivjRNLqorm1fIsQa1NWY7 8xBbVoznyqQTHc59CkqntL3rHBdOENX47v1VA1RR5lrxDol90BG0QoMUQAT335u2wGMnTWT7WS58L5 WHockMQN4uTlZKJok0ApJJyZBT541SjED5eJvfC34HevZTjKF8ZQSqmI7aeJ9szHMbt1IRXao/VEZT a0sygVLd4tgzSmJp2ZB1xO1BI0QdTg179PS3H8bDKlHBJkpxMa1QjPoHG/NTvMgejmOvNqmaygasat up356cJbGEgZLoy1TccmR1GuABF5QmwplptGYTAI7VsJK7eoXepqaWFCwWFd4xgBBxbaoaDg5XK8Xh 27tL6sJhQIo33tmKWQWl7sGPchtS3eime+D1x8kYQmoWXEvV7dssgiFudY/05GBy3pbUwmh4BWMcm/ 8MWNR01CpBZGpuK1iVRslit93wPcZmxTRsxSDbR/uqbqsm3vMoE+JzzOBzQ5lKUMpaNYn/hzSBDuPa ezJo9Nr/VgA1KH1FRdi2mRv21ZA7FdGuqDBDnqc5rPIpGRHlD71G038cKF/Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds typeless and weak ksym support to BTF_KIND_VAR
relocation code in gen_loader. For typeless ksym, we use the newly added
bpf_kallsyms_lookup_name helper.

For weak ksym, we simply skip error check, and fix up the srg_reg for
the insn, as keeping it as BPF_PSEUDO_BTF_ID for weak ksym with its
insn[0].imm and insn[1].imm set as 0 will cause a failure.  This is
consistent with how libbpf relocates these two cases of BTF_KIND_VAR.

We also modify cleanup_relos to check for typeless ksyms in fd closing
loop, since those have no fd associated with the ksym. For this we can
reuse the unused 'off' member of ksym_desc.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h |  12 ++-
 tools/lib/bpf/gen_loader.c       | 123 ++++++++++++++++++++++++++++---
 tools/lib/bpf/libbpf.c           |  13 ++--
 3 files changed, 128 insertions(+), 20 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 70eccbffefb1..9f328d044636 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -8,13 +8,19 @@ struct ksym_relo_desc {
 	int kind;
 	int insn_idx;
 	bool is_weak;
+	bool is_typeless;
 };
 
 struct ksym_desc {
 	const char *name;
 	int ref;
 	int kind;
-	int off;
+	union {
+		/* used for kfunc */
+		int off;
+		/* used for typeless ksym */
+		bool typeless;
+	};
 	int insn;
 };
 
@@ -49,7 +55,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
-			    int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    bool is_typeless, int kind, int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 937bfc7db41e..da1fcb0e3bcb 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -13,6 +13,7 @@
 #include "hashmap.h"
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
+#include <asm/byteorder.h>
 
 #define MAX_USED_MAPS	64
 #define MAX_USED_PROGS	32
@@ -559,7 +560,7 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 }
 
 void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
-			    int kind, int insn_idx)
+			    bool is_typeless, int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -572,6 +573,7 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
 	relo += gen->relo_cnt;
 	relo->name = name;
 	relo->is_weak = is_weak;
+	relo->is_typeless = is_typeless;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
@@ -621,6 +623,33 @@ static void emit_bpf_find_by_name_kind(struct bpf_gen *gen, struct ksym_relo_des
 	debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
 }
 
+/* Overwrites BPF_REG_{0, 1, 2, 3, 4, 7}
+ * Returns result in BPF_REG_7
+ * Returns u64 symbol addr in BPF_REG_9
+ */
+static void emit_bpf_kallsyms_lookup_name(struct bpf_gen *gen, struct ksym_relo_desc *relo)
+{
+	int name_off, len = strlen(relo->name) + 1, res_off;
+
+	name_off = add_data(gen, relo->name, len);
+	if (!name_off)
+		return;
+	res_off = add_data(gen, NULL, 8); /* res is u64 */
+	if (!res_off)
+		return;
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, name_off));
+	emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
+	emit(gen, BPF_MOV64_IMM(BPF_REG_3, 0));
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_4, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, res_off));
+	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_4));
+	emit(gen, BPF_EMIT_CALL(BPF_FUNC_kallsyms_lookup_name));
+	emit(gen, BPF_LDX_MEM(BPF_DW, BPF_REG_9, BPF_REG_7, 0));
+	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
+	debug_ret(gen, "kallsyms_lookup_name(%s,%d)", relo->name, relo->kind);
+}
+
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  *
@@ -703,7 +732,8 @@ static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo
 /* Expects:
  * BPF_REG_8 - pointer to instruction
  */
-static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
+static void emit_relo_ksym_typeless(struct bpf_gen *gen,
+				    struct ksym_relo_desc *relo, int insn)
 {
 	struct ksym_desc *kdesc;
 
@@ -718,25 +748,96 @@ static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo,
 			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
 		goto log;
 	}
+	/* remember insn offset, so we can copy ksym addr later */
+	kdesc->insn = insn;
+	/* skip typeless ksym_desc in fd closing loop in cleanup_relos */
+	kdesc->typeless = true;
+	emit_bpf_kallsyms_lookup_name(gen, relo);
+	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, -ENOENT, 1));
+	emit_check_err(gen);
+	/* store lower half of addr into insn[insn_idx].imm */
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9, offsetof(struct bpf_insn, imm)));
+	/* store upper half of addr into insn[insn_idx + 1].imm */
+	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_9,
+		      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
+log:
+	if (!gen->log_level)
+		return;
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
+			      offsetof(struct bpf_insn, imm)));
+	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
+			      offsetof(struct bpf_insn, imm)));
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=0 w=%d (%s:count=%d): imm[0]: %%d, imm[1]: %%d",
+		   relo->is_weak, relo->name, kdesc->ref);
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	debug_regs(gen, BPF_REG_9, -1, " var t=0 w=%d (%s:count=%d): insn.reg",
+		   relo->is_weak, relo->name, kdesc->ref);
+}
+
+/* Expects:
+ * BPF_REG_8 - pointer to instruction
+ */
+static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
+{
+	struct ksym_desc *kdesc;
+	__u32 reg_mask;
+
+	kdesc = get_ksym_desc(gen, relo);
+	if (!kdesc)
+		return;
+	/* try to copy from existing ldimm64 insn */
+	if (kdesc->ref > 1) {
+		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + offsetof(struct bpf_insn, imm));
+		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_9, BPF_REG_8, offsetof(struct bpf_insn, imm)));
+		/* jump over src_reg adjustment if imm is not 0 */
+		emit(gen, BPF_JMP_IMM(BPF_JNE, BPF_REG_9, 0, 3));
+		goto clear_src_reg;
+	}
 	/* remember insn offset, so we can copy BTF ID and FD later */
 	kdesc->insn = insn;
 	emit_bpf_find_by_name_kind(gen, relo);
-	emit_check_err(gen);
+	if (!relo->is_weak)
+		emit_check_err(gen);
+	/* set default values as 0 */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, offsetof(struct bpf_insn, imm), 0));
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 0));
+	/* skip success case stores if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
 	/* store btf_id into insn[insn_idx].imm */
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
 	/* store btf_obj_fd into insn[insn_idx + 1].imm */
 	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
 	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
 			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
-log:
+	emit(gen, BPF_JMP_IMM(BPF_JSGE, BPF_REG_7, 0, 3));
+clear_src_reg:
+	/* clear bpf_object__relocate_data's src_reg assignment, otherwise we get a verifier failure */
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	reg_mask = 0x0f; /* src_reg,dst_reg,... */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	reg_mask = 0xf0; /* dst_reg,src_reg,... */
+#else
+#error "Unsupported bit endianness, cannot proceed"
+#endif
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	emit(gen, BPF_ALU32_IMM(BPF_AND, BPF_REG_9, reg_mask));
+	emit(gen, BPF_STX_MEM(BPF_B, BPF_REG_8, BPF_REG_9, offsetofend(struct bpf_insn, code)));
+
 	if (!gen->log_level)
 		return;
 	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
 			      offsetof(struct bpf_insn, imm)));
 	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
 			      offsetof(struct bpf_insn, imm)));
-	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var (%s:count=%d): imm: %%d, fd: %%d",
-		   relo->name, kdesc->ref);
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var t=1 w=%d (%s:count=%d): imm[0]: %%d, imm[1]: %%d",
+		   relo->is_weak, relo->name, kdesc->ref);
+	emit(gen, BPF_LDX_MEM(BPF_B, BPF_REG_9, BPF_REG_8, offsetofend(struct bpf_insn, code)));
+	debug_regs(gen, BPF_REG_9, -1, " var t=1 w=%d (%s:count=%d): insn.reg",
+		   relo->is_weak, relo->name, kdesc->ref);
 }
 
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
@@ -748,7 +849,10 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
 	switch (relo->kind) {
 	case BTF_KIND_VAR:
-		emit_relo_ksym_btf(gen, relo, insn);
+		if (relo->is_typeless)
+			emit_relo_ksym_typeless(gen, relo, insn);
+		else
+			emit_relo_ksym_btf(gen, relo, insn);
 		break;
 	case BTF_KIND_FUNC:
 		emit_relo_kfunc_btf(gen, relo, insn);
@@ -773,12 +877,13 @@ static void cleanup_relos(struct bpf_gen *gen, int insns)
 	int i, insn;
 
 	for (i = 0; i < gen->nr_ksyms; i++) {
-		if (gen->ksyms[i].kind == BTF_KIND_VAR) {
+		/* only close fds for typed ksyms and kfuncs */
+		if (gen->ksyms[i].kind == BTF_KIND_VAR && !gen->ksyms[i].typeless) {
 			/* close fd recorded in insn[insn_idx + 1].imm */
 			insn = gen->ksyms[i].insn;
 			insn += sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm);
 			emit_sys_close_blob(gen, insn);
-		} else { /* BTF_KIND_FUNC */
+		} else if (gen->ksyms[i].kind == BTF_KIND_FUNC) {
 			emit_sys_close_blob(gen, blob_fd_array_off(gen, gen->ksyms[i].off));
 			if (gen->ksyms[i].off < MAX_FD_ARRAY_SZ)
 				gen->nr_fd_array--;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f32fa51b1e63..d286dec73b5f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6355,17 +6355,14 @@ static int bpf_program__record_externs(struct bpf_program *prog)
 		case RELO_EXTERN_VAR:
 			if (ext->type != EXT_KSYM)
 				continue;
-			if (!ext->ksym.type_id) {
-				pr_warn("typeless ksym %s is not supported yet\n",
-					ext->name);
-				return -ENOTSUP;
-			}
-			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
+			bpf_gen__record_extern(obj->gen_loader, ext->name,
+					       ext->is_weak, !ext->ksym.type_id,
 					       BTF_KIND_VAR, relo->insn_idx);
 			break;
 		case RELO_EXTERN_FUNC:
-			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
-					       BTF_KIND_FUNC, relo->insn_idx);
+			bpf_gen__record_extern(obj->gen_loader, ext->name,
+					       ext->is_weak, 0, BTF_KIND_FUNC,
+					       relo->insn_idx);
 			break;
 		default:
 			continue;
-- 
2.33.0

