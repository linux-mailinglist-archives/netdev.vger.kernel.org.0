Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628A64220D8
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhJEIdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhJEIdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:33:51 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431FBC061755;
        Tue,  5 Oct 2021 01:32:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id np13so3527450pjb.4;
        Tue, 05 Oct 2021 01:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=raomSAqq/0SNS5jx0FmmwAcCbX5cgON15ayIk5USH+k=;
        b=hbof3e598NnjQTLsseHPXr0JhjjW+mKHGxdc3ae3XF1e2LgFS+T34g41CRf6dYseEL
         L3ZyiqTYYSXWz8CCc7rCONfPMUTb0byWzftp7MJgzWvzNJDSRHW2p/4Nz+hQusTp2bcr
         LJbUKPgavN7rhoqSwJcfHLUWKeM/XllEPiEMvUMNlZG1ZlXJdNSvumUg6VSCoStrARYa
         4XVzQNhLsP6rZ0tvm+Cq8UrhhyOtjIs4+ycyyfg7Znlw0EFDtg2VnGJTRc1wyPhRWLaQ
         Uo7SVTzcRQpixrJBvsyxyS+lQAPm/Xiv9KcaYV9yzLi7YpOL2kAI7g9f2B8V/hpgukOE
         8vvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raomSAqq/0SNS5jx0FmmwAcCbX5cgON15ayIk5USH+k=;
        b=D5cGKoGCIEuaS5IaAkO0vRbDmsUBXFO3s5TA8A5cGdnjKtrzo/ULxoqSfKSjCSX5jq
         CRZq8UzoWNZiUzufsBaJ/g1Krea5M4zB3AvbVKBdC9laNR4Y0AGS3phzyt5Hk3Ktza4M
         d00uM9v2eZda+fJCIXiGi5hwAkG0Y6GK8wRCpBp/chd6jRLr+tAdLzszVD54eyk1DRao
         f3xLvET95KnHqBaZlFKbWDe+/+40mL8C2wNScR0miyoCRZPZV+rNzWvwee4NXlOR4VrQ
         SgnD+H7+G2JrYPHbICsKrAGDgL5umxykOntHn5Wh2YTBIZ6Blw71Gt3BWgj9WyexCJRX
         9LQA==
X-Gm-Message-State: AOAM532gMK776PLmhwWRyu6CPbfdTzexxBG0ceuC2+KCWyinAJ4J+dsJ
        MkWUcJfVR3HQTFdSLrpQWayTBBEiIollLA==
X-Google-Smtp-Source: ABdhPJxlNiWNVI/6/Rqd2XUpaETVGe7ea05cNnZ37AKZA9CCKX40im3MSK3H8YVsMN+CP6KLeAWewQ==
X-Received: by 2002:a17:90b:4f88:: with SMTP id qe8mr2220996pjb.223.1633422720675;
        Tue, 05 Oct 2021 01:32:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:32:00 -0700 (PDT)
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
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v2 13/16] MIPS: eBPF64: support BPF_JMP32 conditionals
Date:   Tue,  5 Oct 2021 01:26:57 -0700
Message-Id: <8af45dc454a5f1dcf024e9b511bb65b8600c65be.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify BPF_JGT/JLE/JSGT/JSLE and related code by dropping unneeded usage
of MIPS_R_T8/T9 registers and jump-around branches, and extra comparison
arithmetic. Also reorganize var declarations and add 'bpf_class' helper
constant.

Implement BPF_JMP32 branches using sign or zero-extended temporaries as
needed for comparisons. This enables JITing of many more BPF programs, and
provides greater test coverage by e.g. 'test_verifier'.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit_comp64.c | 206 +++++++++++++++++++-------------
 1 file changed, 122 insertions(+), 84 deletions(-)

diff --git a/arch/mips/net/ebpf_jit_comp64.c b/arch/mips/net/ebpf_jit_comp64.c
index c38d93d37ce3..842e516ce749 100644
--- a/arch/mips/net/ebpf_jit_comp64.c
+++ b/arch/mips/net/ebpf_jit_comp64.c
@@ -167,12 +167,13 @@ static int gen_imm_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		   int this_idx, int exit_idx)
 {
-	int src, dst, r, td, ts, mem_off, b_off;
+	const int bpf_class = BPF_CLASS(insn->code);
+	const int bpf_op = BPF_OP(insn->code);
 	bool need_swap, did_move, cmp_eq;
 	unsigned int target = 0;
+	int src, dst, r, td, ts;
+	int mem_off, b_off;
 	u64 t64;
-	s64 t64s;
-	int bpf_op = BPF_OP(insn->code);
 
 	switch (insn->code) {
 	case BPF_ALU64 | BPF_ADD | BPF_K: /* ALU64_IMM */
@@ -500,7 +501,9 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 	case BPF_JMP | BPF_JEQ | BPF_K: /* JMP_IMM */
-	case BPF_JMP | BPF_JNE | BPF_K: /* JMP_IMM */
+	case BPF_JMP | BPF_JNE | BPF_K:
+	case BPF_JMP32 | BPF_JEQ | BPF_K: /* JMP_IMM */
+	case BPF_JMP32 | BPF_JNE | BPF_K:
 		cmp_eq = (bpf_op == BPF_JEQ);
 		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
@@ -511,6 +514,16 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			gen_imm_to_reg(insn, MIPS_R_AT, ctx);
 			src = MIPS_R_AT;
 		}
+		if (bpf_class == BPF_JMP32) {
+			emit_instr(ctx, move, MIPS_R_T8, dst);
+			emit_instr(ctx, dinsu, MIPS_R_T8, MIPS_R_ZERO, 32, 32);
+			dst = MIPS_R_T8;
+			if (src != MIPS_R_ZERO) {
+				emit_instr(ctx, move, MIPS_R_T9, src);
+				emit_instr(ctx, dinsu, MIPS_R_T9, MIPS_R_ZERO, 32, 32);
+				src = MIPS_R_T9;
+			}
+		}
 		goto jeq_common;
 	case BPF_JMP | BPF_JEQ | BPF_X: /* JMP_REG */
 	case BPF_JMP | BPF_JNE | BPF_X:
@@ -523,18 +536,46 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JGT | BPF_X:
 	case BPF_JMP | BPF_JGE | BPF_X:
 	case BPF_JMP | BPF_JSET | BPF_X:
+	case BPF_JMP32 | BPF_JEQ | BPF_X: /* JMP_REG */
+	case BPF_JMP32 | BPF_JNE | BPF_X:
+	case BPF_JMP32 | BPF_JSLT | BPF_X:
+	case BPF_JMP32 | BPF_JSLE | BPF_X:
+	case BPF_JMP32 | BPF_JSGT | BPF_X:
+	case BPF_JMP32 | BPF_JSGE | BPF_X:
+	case BPF_JMP32 | BPF_JLT | BPF_X:
+	case BPF_JMP32 | BPF_JLE | BPF_X:
+	case BPF_JMP32 | BPF_JGT | BPF_X:
+	case BPF_JMP32 | BPF_JGE | BPF_X:
+	case BPF_JMP32 | BPF_JSET | BPF_X:
 		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
 		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
 		ts = get_reg_val_type(ctx, this_idx, insn->src_reg);
-		if (td == REG_32BIT && ts != REG_32BIT) {
-			emit_instr(ctx, sll, MIPS_R_AT, src, 0);
-			src = MIPS_R_AT;
-		} else if (ts == REG_32BIT && td != REG_32BIT) {
-			emit_instr(ctx, sll, MIPS_R_AT, dst, 0);
-			dst = MIPS_R_AT;
+		if (bpf_class == BPF_JMP) {
+			if (td == REG_32BIT && ts != REG_32BIT) {
+				emit_instr(ctx, sll, MIPS_R_AT, src, 0);
+				src = MIPS_R_AT;
+			} else if (ts == REG_32BIT && td != REG_32BIT) {
+				emit_instr(ctx, sll, MIPS_R_AT, dst, 0);
+				dst = MIPS_R_AT;
+			}
+		} else { /* BPF_JMP32 */
+			if (bpf_op == BPF_JSGT || bpf_op == BPF_JSLT ||
+			    bpf_op == BPF_JSGE || bpf_op == BPF_JSLE) {
+				emit_instr(ctx, sll, MIPS_R_T8, dst, 0);
+				emit_instr(ctx, sll, MIPS_R_T9, src, 0);
+				dst = MIPS_R_T8;
+				src = MIPS_R_T9;
+			} else {
+				emit_instr(ctx, move, MIPS_R_T8, dst);
+				emit_instr(ctx, move, MIPS_R_T9, src);
+				emit_instr(ctx, dinsu, MIPS_R_T8, MIPS_R_ZERO, 32, 32);
+				emit_instr(ctx, dinsu, MIPS_R_T9, MIPS_R_ZERO, 32, 32);
+				dst = MIPS_R_T8;
+				src = MIPS_R_T9;
+			}
 		}
 		if (bpf_op == BPF_JSET) {
 			emit_instr(ctx, and, MIPS_R_AT, dst, src);
@@ -542,48 +583,20 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			dst = MIPS_R_AT;
 			src = MIPS_R_ZERO;
 		} else if (bpf_op == BPF_JSGT || bpf_op == BPF_JSLE) {
-			emit_instr(ctx, dsubu, MIPS_R_AT, dst, src);
-			if ((insn + 1)->code == (BPF_JMP | BPF_EXIT) && insn->off == 1) {
-				b_off = b_imm(exit_idx, ctx);
-				if (is_bad_offset(b_off))
-					return -E2BIG;
-				if (bpf_op == BPF_JSGT)
-					emit_instr(ctx, blez, MIPS_R_AT, b_off);
-				else
-					emit_instr(ctx, bgtz, MIPS_R_AT, b_off);
-				emit_instr(ctx, nop);
-				return 2; /* We consumed the exit. */
-			}
-			b_off = b_imm(this_idx + insn->off + 1, ctx);
-			if (is_bad_offset(b_off))
-				return -E2BIG;
-			if (bpf_op == BPF_JSGT)
-				emit_instr(ctx, bgtz, MIPS_R_AT, b_off);
-			else
-				emit_instr(ctx, blez, MIPS_R_AT, b_off);
-			emit_instr(ctx, nop);
-			break;
+			/* swap dst and src to simplify comparison */
+			emit_instr(ctx, slt, MIPS_R_AT, src, dst);
+			cmp_eq = bpf_op == BPF_JSLE;
+			dst = MIPS_R_AT;
+			src = MIPS_R_ZERO;
 		} else if (bpf_op == BPF_JSGE || bpf_op == BPF_JSLT) {
 			emit_instr(ctx, slt, MIPS_R_AT, dst, src);
 			cmp_eq = bpf_op == BPF_JSGE;
 			dst = MIPS_R_AT;
 			src = MIPS_R_ZERO;
 		} else if (bpf_op == BPF_JGT || bpf_op == BPF_JLE) {
-			/* dst or src could be AT */
-			emit_instr(ctx, dsubu, MIPS_R_T8, dst, src);
-			emit_instr(ctx, sltu, MIPS_R_AT, dst, src);
-			/* SP known to be non-zero, movz becomes boolean not */
-			if (MIPS_ISA_REV >= 6) {
-				emit_instr(ctx, seleqz, MIPS_R_T9,
-						MIPS_R_SP, MIPS_R_T8);
-			} else {
-				emit_instr(ctx, movz, MIPS_R_T9,
-						MIPS_R_SP, MIPS_R_T8);
-				emit_instr(ctx, movn, MIPS_R_T9,
-						MIPS_R_ZERO, MIPS_R_T8);
-			}
-			emit_instr(ctx, or, MIPS_R_AT, MIPS_R_T9, MIPS_R_AT);
-			cmp_eq = bpf_op == BPF_JGT;
+			/* swap dst and src to simplify comparison */
+			emit_instr(ctx, sltu, MIPS_R_AT, src, dst);
+			cmp_eq = bpf_op == BPF_JLE;
 			dst = MIPS_R_AT;
 			src = MIPS_R_ZERO;
 		} else if (bpf_op == BPF_JGE || bpf_op == BPF_JLT) {
@@ -650,14 +663,20 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 	case BPF_JMP | BPF_JSGT | BPF_K: /* JMP_IMM */
-	case BPF_JMP | BPF_JSGE | BPF_K: /* JMP_IMM */
-	case BPF_JMP | BPF_JSLT | BPF_K: /* JMP_IMM */
-	case BPF_JMP | BPF_JSLE | BPF_K: /* JMP_IMM */
-		cmp_eq = (bpf_op == BPF_JSGE);
+	case BPF_JMP | BPF_JSGE | BPF_K:
+	case BPF_JMP | BPF_JSLT | BPF_K:
+	case BPF_JMP | BPF_JSLE | BPF_K:
+	case BPF_JMP32 | BPF_JSGT | BPF_K: /* JMP_IMM */
+	case BPF_JMP32 | BPF_JSGE | BPF_K:
+	case BPF_JMP32 | BPF_JSLT | BPF_K:
+	case BPF_JMP32 | BPF_JSLE | BPF_K:
 		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
-
+		if (bpf_class == BPF_JMP32) {
+			emit_instr(ctx, sll, MIPS_R_T8, dst, 0);
+			dst = MIPS_R_T8;
+		}
 		if (insn->imm == 0) {
 			if ((insn + 1)->code == (BPF_JMP | BPF_EXIT) && insn->off == 1) {
 				b_off = b_imm(exit_idx, ctx);
@@ -700,26 +719,24 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			emit_instr(ctx, nop);
 			break;
 		}
-		/*
-		 * only "LT" compare available, so we must use imm + 1
-		 * to generate "GT" and imm -1 to generate LE
-		 */
-		if (bpf_op == BPF_JSGT)
-			t64s = insn->imm + 1;
-		else if (bpf_op == BPF_JSLE)
-			t64s = insn->imm + 1;
-		else
-			t64s = insn->imm;
 
-		cmp_eq = bpf_op == BPF_JSGT || bpf_op == BPF_JSGE;
-		if (t64s >= S16_MIN && t64s <= S16_MAX) {
-			emit_instr(ctx, slti, MIPS_R_AT, dst, (int)t64s);
-			src = MIPS_R_AT;
-			dst = MIPS_R_ZERO;
-			goto jeq_common;
+		gen_imm_to_reg(insn, MIPS_R_T9, ctx);
+		src = MIPS_R_T9;
+		cmp_eq = bpf_op == BPF_JSLE || bpf_op == BPF_JSGE;
+		switch (bpf_op) {
+		case BPF_JSGE:
+			emit_instr(ctx, slt, MIPS_R_AT, dst, src);
+			break;
+		case BPF_JSLT:
+			emit_instr(ctx, slt, MIPS_R_AT, dst, src);
+			break;
+		case BPF_JSGT:
+			emit_instr(ctx, slt, MIPS_R_AT, src, dst);
+			break;
+		case BPF_JSLE:
+			emit_instr(ctx, slt, MIPS_R_AT, src, dst);
+			break;
 		}
-		emit_const_to_reg(ctx, MIPS_R_AT, (u64)t64s);
-		emit_instr(ctx, slt, MIPS_R_AT, dst, MIPS_R_AT);
 		src = MIPS_R_AT;
 		dst = MIPS_R_ZERO;
 		goto jeq_common;
@@ -728,33 +745,52 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JGE | BPF_K:
 	case BPF_JMP | BPF_JLT | BPF_K:
 	case BPF_JMP | BPF_JLE | BPF_K:
-		cmp_eq = (bpf_op == BPF_JGE);
+	case BPF_JMP32 | BPF_JGT | BPF_K:
+	case BPF_JMP32 | BPF_JGE | BPF_K:
+	case BPF_JMP32 | BPF_JLT | BPF_K:
+	case BPF_JMP32 | BPF_JLE | BPF_K:
 		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
-		/*
-		 * only "LT" compare available, so we must use imm + 1
-		 * to generate "GT" and imm -1 to generate LE
-		 */
-		if (bpf_op == BPF_JGT)
-			t64s = (u64)(u32)(insn->imm) + 1;
-		else if (bpf_op == BPF_JLE)
-			t64s = (u64)(u32)(insn->imm) + 1;
-		else
-			t64s = (u64)(u32)(insn->imm);
-
-		cmp_eq = bpf_op == BPF_JGT || bpf_op == BPF_JGE;
+		if (bpf_class == BPF_JMP32) {
+			emit_instr(ctx, move, MIPS_R_T8, dst);
+			gen_zext_insn(MIPS_R_T8, true, ctx);
+			dst = MIPS_R_T8;
+		}
+		gen_imm_to_reg(insn, MIPS_R_T9, ctx);
+		if (bpf_class == BPF_JMP32 && insn->imm < 0)
+			gen_zext_insn(MIPS_R_T9, true, ctx);
+		src = MIPS_R_T9;
 
-		emit_const_to_reg(ctx, MIPS_R_AT, (u64)t64s);
-		emit_instr(ctx, sltu, MIPS_R_AT, dst, MIPS_R_AT);
+		cmp_eq = bpf_op == BPF_JLE || bpf_op == BPF_JGE;
+		switch (bpf_op) {
+		case BPF_JGE:
+			emit_instr(ctx, sltu, MIPS_R_AT, dst, src);
+			break;
+		case BPF_JLT:
+			emit_instr(ctx, sltu, MIPS_R_AT, dst, src);
+			break;
+		case BPF_JGT:
+			emit_instr(ctx, sltu, MIPS_R_AT, src, dst);
+			break;
+		case BPF_JLE:
+			emit_instr(ctx, sltu, MIPS_R_AT, src, dst);
+			break;
+		}
 		src = MIPS_R_AT;
 		dst = MIPS_R_ZERO;
 		goto jeq_common;
 
 	case BPF_JMP | BPF_JSET | BPF_K: /* JMP_IMM */
+	case BPF_JMP32 | BPF_JSET | BPF_K: /* JMP_IMM */
 		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
+		if (bpf_class == BPF_JMP32) {
+			emit_instr(ctx, move, MIPS_R_T8, dst);
+			emit_instr(ctx, dinsu, MIPS_R_T8, MIPS_R_ZERO, 32, 32);
+			dst = MIPS_R_T8;
+		}
 
 		if (ctx->use_bbit_insns && hweight32((u32)insn->imm) == 1) {
 			if ((insn + 1)->code == (BPF_JMP | BPF_EXIT) && insn->off == 1) {
@@ -774,6 +810,8 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		t64 = (u32)insn->imm;
 		emit_const_to_reg(ctx, MIPS_R_AT, t64);
+		if (bpf_class == BPF_JMP32)
+			emit_instr(ctx, dinsu, MIPS_R_AT, MIPS_R_ZERO, 32, 32);
 		emit_instr(ctx, and, MIPS_R_AT, dst, MIPS_R_AT);
 		src = MIPS_R_AT;
 		dst = MIPS_R_ZERO;
-- 
2.25.1

