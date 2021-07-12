Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979113C4083
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhGLAij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhGLAi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 20:38:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA273C0613DD;
        Sun, 11 Jul 2021 17:35:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p4so3994355plo.11;
        Sun, 11 Jul 2021 17:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jw7YhCYvkORE+kKaZ4OGGD3iGi/XtNNMa4bsdRSUdJU=;
        b=qhdAF39A6JSBf8FNNpO7mNHkGRhYz6SraAUZivrN0tfL641UK21X33qE/j508BkNpi
         /fzZgqTm8qh1LU77rnoK39Oy+yN7SDK910x8AAqtK9WFwARJv9y1qNf6pYsKm9RNpTci
         gchty2QZ6PiDb9z633I005BU/nU6BBSrwvtKwhkwQBYX24FX3wjuUTEvadbKGty2i1gv
         cYauEJjJSiGk808DrQY0GV2Sf2UFgeMDxePkwFHIJbFhk6HUuf4fS+Ja1e9wLNxRCZ67
         n6am1CPbuTUXu4im3+MC90lquwylbPLYpHP1DlMpvQcePty6rgIS0C8E1AChVV9wQE16
         6MQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jw7YhCYvkORE+kKaZ4OGGD3iGi/XtNNMa4bsdRSUdJU=;
        b=gRVorBUsFc8ijFbkk3RunWoK7b7AwlNy3tIWfMMewHm05PHtD3JROnX+Ept7TSB8by
         RtPBt0hVk2OjpuFJyJlmYWnLci27EmWJINV1lI4PtTyBBXRjDtiu4tRuJDqdHa8Zvdsa
         1K6wbGn9BrjoUHurNIEUYUTY7j5hh+9RcxpIRpGsnzQe6MSYLICZVKl4civwQj/X8gN6
         qaks3d41juOLwuQzCLAFw+iFnAx82xwDu3jR/h98qRb/XgIGsw0kZHqnhughWRtod3fv
         HeMXUx4kJik4XUXO2Ika7kAWFimZ1L4nc+Rt68+BLOuxHPN/Df8QEUVjX6pNyYK+0l0w
         lrAQ==
X-Gm-Message-State: AOAM532yV5YGEkwx0RF5sxl3XcdQr4QeaA8g1wXBIRmwn8A1NwpdteL6
        toJj+IuLikDyAW6GHBEkNaw=
X-Google-Smtp-Source: ABdhPJwZxh1FtkAyQNLnCkGTnJmXy0K3N9PofEXhfbduE8653nL35X0Joxeygj4r0hySN//vuBGIKA==
X-Received: by 2002:a17:902:d293:b029:12b:1912:2540 with SMTP id t19-20020a170902d293b029012b19122540mr963903plc.76.1626050138521;
        Sun, 11 Jul 2021 17:35:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:4039:6c0e:1168:cc74])
        by smtp.gmail.com with ESMTPSA id c24sm15588447pgj.11.2021.07.11.17.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:35:38 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v1 10/14] MIPS: eBPF: improve and clarify enum 'which_ebpf_reg'
Date:   Sun, 11 Jul 2021 17:34:56 -0700
Message-Id: <a2cb9a208b069eeef12f5ebcd34b8a071d4eb8f1.1625970384.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625970383.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update enum and literals to be more consistent and less confusing. Prior
usage resulted in 'dst_reg' variables and 'dst_reg' enum literals, often
adjacent to each other and hampering maintenance.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 64 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index bba41f334d07..61d7894051aa 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -177,11 +177,11 @@ static u32 b_imm(unsigned int tgt, struct jit_ctx *ctx)
 		(ctx->idx * 4) - 4;
 }
 
-enum which_ebpf_reg {
-	src_reg,
-	src_reg_no_fp,
-	dst_reg,
-	dst_reg_fp_ok
+enum reg_usage {
+	REG_SRC_FP_OK,
+	REG_SRC_NO_FP,
+	REG_DST_FP_OK,
+	REG_DST_NO_FP
 };
 
 /*
@@ -192,9 +192,9 @@ enum which_ebpf_reg {
  */
 static int ebpf_to_mips_reg(struct jit_ctx *ctx,
 			    const struct bpf_insn *insn,
-			    enum which_ebpf_reg w)
+			    enum reg_usage u)
 {
-	int ebpf_reg = (w == src_reg || w == src_reg_no_fp) ?
+	int ebpf_reg = (u == REG_SRC_FP_OK || u == REG_SRC_NO_FP) ?
 		insn->src_reg : insn->dst_reg;
 
 	switch (ebpf_reg) {
@@ -223,7 +223,7 @@ static int ebpf_to_mips_reg(struct jit_ctx *ctx,
 		ctx->flags |= EBPF_SAVE_S3;
 		return MIPS_R_S3;
 	case BPF_REG_10:
-		if (w == dst_reg || w == src_reg_no_fp)
+		if (u == REG_DST_NO_FP || u == REG_SRC_NO_FP)
 			goto bad_reg;
 		ctx->flags |= EBPF_SEEN_FP;
 		/*
@@ -423,7 +423,7 @@ static int gen_imm_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			int idx)
 {
 	int upper_bound, lower_bound;
-	int dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+	int dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 
 	if (dst < 0)
 		return dst;
@@ -696,7 +696,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			return r;
 		break;
 	case BPF_ALU64 | BPF_MUL | BPF_K: /* ALU64_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -712,7 +712,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 	case BPF_ALU64 | BPF_NEG | BPF_K: /* ALU64_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -720,7 +720,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_instr(ctx, dsubu, dst, MIPS_R_ZERO, dst);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_K: /* ALU_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -739,7 +739,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 	case BPF_ALU | BPF_NEG | BPF_K: /* ALU_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -753,7 +753,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU | BPF_MOD | BPF_K: /* ALU_IMM */
 		if (insn->imm == 0)
 			return -EINVAL;
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -784,7 +784,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU64 | BPF_MOD | BPF_K: /* ALU_IMM */
 		if (insn->imm == 0)
 			return -EINVAL;
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -821,8 +821,8 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU64 | BPF_LSH | BPF_X: /* ALU64_REG */
 	case BPF_ALU64 | BPF_RSH | BPF_X: /* ALU64_REG */
 	case BPF_ALU64 | BPF_ARSH | BPF_X: /* ALU64_REG */
-		src = ebpf_to_mips_reg(ctx, insn, src_reg);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -917,8 +917,8 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU | BPF_LSH | BPF_X: /* ALU_REG */
 	case BPF_ALU | BPF_RSH | BPF_X: /* ALU_REG */
 	case BPF_ALU | BPF_ARSH | BPF_X: /* ALU_REG */
-		src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -1008,7 +1008,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JEQ | BPF_K: /* JMP_IMM */
 	case BPF_JMP | BPF_JNE | BPF_K: /* JMP_IMM */
 		cmp_eq = (bpf_op == BPF_JEQ);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 		if (insn->imm == 0) {
@@ -1029,8 +1029,8 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JGT | BPF_X:
 	case BPF_JMP | BPF_JGE | BPF_X:
 	case BPF_JMP | BPF_JSET | BPF_X:
-		src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -1160,7 +1160,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JSLT | BPF_K: /* JMP_IMM */
 	case BPF_JMP | BPF_JSLE | BPF_K: /* JMP_IMM */
 		cmp_eq = (bpf_op == BPF_JSGE);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 
@@ -1235,7 +1235,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JLT | BPF_K:
 	case BPF_JMP | BPF_JLE | BPF_K:
 		cmp_eq = (bpf_op == BPF_JGE);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 		/*
@@ -1258,7 +1258,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		goto jeq_common;
 
 	case BPF_JMP | BPF_JSET | BPF_K: /* JMP_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 
@@ -1303,7 +1303,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_instr(ctx, nop);
 		break;
 	case BPF_LD | BPF_DW | BPF_IMM:
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		t64 = ((u64)(u32)insn->imm) | ((u64)(insn + 1)->imm << 32);
@@ -1326,7 +1326,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 
 	case BPF_ALU | BPF_END | BPF_FROM_BE:
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -1369,7 +1369,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			dst = MIPS_R_SP;
 			mem_off = insn->off + MAX_BPF_STACK;
 		} else {
-			dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+			dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 			if (dst < 0)
 				return dst;
 			mem_off = insn->off;
@@ -1400,12 +1400,12 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			src = MIPS_R_SP;
 			mem_off = insn->off + MAX_BPF_STACK;
 		} else {
-			src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
+			src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
 			if (src < 0)
 				return src;
 			mem_off = insn->off;
 		}
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		switch (BPF_SIZE(insn->code)) {
@@ -1435,12 +1435,12 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			dst = MIPS_R_SP;
 			mem_off = insn->off + MAX_BPF_STACK;
 		} else {
-			dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+			dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 			if (dst < 0)
 				return dst;
 			mem_off = insn->off;
 		}
-		src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
 		if (src < 0)
 			return src;
 		if (BPF_MODE(insn->code) == BPF_ATOMIC) {
-- 
2.25.1

