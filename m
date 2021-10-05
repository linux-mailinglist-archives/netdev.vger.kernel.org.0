Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653C94220F9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbhJEIlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbhJEIlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:41:09 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9462C061745;
        Tue,  5 Oct 2021 01:39:18 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id d18so23363401iof.13;
        Tue, 05 Oct 2021 01:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vRAxmubyADiVGnedQuvE2MHzC9GyBk/oPvl54a5kj8k=;
        b=H3/bD4ruK7c89f4rRt0oMJD3H5C6OYZpYeTFmO74MrOWGrYEDs9gx5A0eZKOLHeFfP
         VhXme9AvQalS9rekOpaUf3xVVIe/N774f6tonzu3R/6ZVvUuJ4nnozm4cUId59fA+2cD
         IyuweqfHJmCTL3JpjhiV8E5oG/AEDPTtIi/Yp1pJhNL9RIIHP3/6flaBGurRCOgJdRqr
         UbHz/QLLP0mM3S4CVlN2WxJcNEylO6QorqPLkZrqUABWY6mDLSoclkPFasW+GWOkzpB2
         NPe57of2oibWf1IuaWJSC29MQngnFs5wtSBoJ42F6y28P8qk1KbLsRGQlSCL63D+esSl
         h34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vRAxmubyADiVGnedQuvE2MHzC9GyBk/oPvl54a5kj8k=;
        b=B60fhZe0Lbi55nvWkoxYQDcdGynAsUIAFv4Y14WEEdaLQYAIsJ1lYCdErhTHQ5S9Sv
         KoH+IO8upyY9oOLjIe2XCv8cC6zTNjDyNrZu5yQp7oxmi7jMVNLcX1zeM7AtdwmogU0h
         aoGTAH9Ge945bNHNKtpKXCZpC8R4zLzIxs/F1SnqJH8ecPqFnhEK1ZqIdEFJweyeuINE
         wDmFz8BxbIbkMNsM9mNoXeYCpRE+JUEF9ZZp5xPeJE8FzkdVPm2DQSF/Duloqb0p2OZf
         9jstF320mzFMFwuVlluHKz/J0ghPd64MgXP+3Z8I2yb6jareUWkDCzzD4mZfjP9Qvzsm
         AUgQ==
X-Gm-Message-State: AOAM5316H/9wSFSPm7c8HWDfUd8EwgMr+MYqNBPavyAJo460G8qMcHI/
        YqpQTD0kO5Vc2YCBYeD6gxFiJKsAA3T2Vw==
X-Google-Smtp-Source: ABdhPJyAn4+mgqMuaK99WTG4Qb3Q4N8lzJX6ftX6PCSdMN8k4MrclknyAt1h2SD/t/JgJ3sDw9zZxg==
X-Received: by 2002:a63:b34a:: with SMTP id x10mr14611613pgt.473.1633422728971;
        Tue, 05 Oct 2021 01:32:08 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:32:08 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 14/16] MIPS: eBPF64: implement all BPF_ATOMIC ops
Date:   Tue,  5 Oct 2021 01:26:58 -0700
Message-Id: <3499e013eb8994077c8f642fb1907a49d6a0afd7.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorganize code for BPF_ATOMIC and BPF_MEM, and add the atomic ops AND,
OR, XOR, XCHG and CMPXCHG, with support for BPF_FETCH.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit_comp64.c | 181 +++++++++++++++++++++-----------
 1 file changed, 119 insertions(+), 62 deletions(-)

diff --git a/arch/mips/net/ebpf_jit_comp64.c b/arch/mips/net/ebpf_jit_comp64.c
index 842e516ce749..35c8c8307b64 100644
--- a/arch/mips/net/ebpf_jit_comp64.c
+++ b/arch/mips/net/ebpf_jit_comp64.c
@@ -167,7 +167,15 @@ static int gen_imm_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		   int this_idx, int exit_idx)
 {
+	/*
+	 * Since CMPXCHG uses R0 implicitly, outside of a passed
+	 * bpf_insn, we fake a lookup to get the MIPS base reg.
+	 */
+	const struct bpf_insn r0_insn = {.src_reg = BPF_REG_0};
+	const int r0 = ebpf_to_mips_reg(ctx, &r0_insn,
+					REG_SRC_NO_FP);
 	const int bpf_class = BPF_CLASS(insn->code);
+	const int bpf_size = BPF_SIZE(insn->code);
 	const int bpf_op = BPF_OP(insn->code);
 	bool need_swap, did_move, cmp_eq;
 	unsigned int target = 0;
@@ -944,6 +952,32 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_STX | BPF_H | BPF_MEM:
 	case BPF_STX | BPF_W | BPF_MEM:
 	case BPF_STX | BPF_DW | BPF_MEM:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		mem_off = insn->off;
+		switch (BPF_SIZE(insn->code)) {
+		case BPF_B:
+			emit_instr(ctx, sb, src, mem_off, dst);
+			break;
+		case BPF_H:
+			emit_instr(ctx, sh, src, mem_off, dst);
+			break;
+		case BPF_W:
+			emit_instr(ctx, sw, src, mem_off, dst);
+			break;
+		case BPF_DW:
+			if (get_reg_val_type(ctx, this_idx, insn->src_reg) == REG_32BIT) {
+				emit_instr(ctx, daddu, MIPS_R_AT, src, MIPS_R_ZERO);
+				emit_instr(ctx, dinsu, MIPS_R_AT, MIPS_R_ZERO, 32, 32);
+				src = MIPS_R_AT;
+			}
+			emit_instr(ctx, sd, src, mem_off, dst);
+			break;
+		}
+		break;
+
 	case BPF_STX | BPF_W | BPF_ATOMIC:
 	case BPF_STX | BPF_DW | BPF_ATOMIC:
 		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
@@ -951,71 +985,94 @@ int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		mem_off = insn->off;
-		if (BPF_MODE(insn->code) == BPF_ATOMIC) {
-			if (insn->imm != BPF_ADD) {
-				pr_err("ATOMIC OP %02x NOT HANDLED\n", insn->imm);
-				return -EINVAL;
+		/*
+		 * If mem_off does not fit within the 9 bit ll/sc
+		 * instruction immediate field, use a temp reg.
+		 */
+		if (MIPS_ISA_REV >= 6 &&
+		    (mem_off >= BIT(8) || mem_off < -BIT(8))) {
+			emit_instr(ctx, daddiu, MIPS_R_T6, dst, mem_off);
+			mem_off = 0;
+			dst = MIPS_R_T6;
+		}
+		/* Copy or adjust 32-bit src regs based on BPF op size. */
+		ts = get_reg_val_type(ctx, this_idx, insn->src_reg);
+		if (bpf_size == BPF_W) {
+			if (ts == REG_32BIT) {
+				emit_instr(ctx, sll, MIPS_R_T9, src, 0);
+				src = MIPS_R_T9;
 			}
+			/* Ensure proper old == new comparison .*/
+			if (insn->imm == BPF_CMPXCHG)
+				emit_instr(ctx, sll, r0, r0, 0);
+		}
+		if (bpf_size == BPF_DW && ts == REG_32BIT) {
+			emit_instr(ctx, move, MIPS_R_T9, src);
+			emit_instr(ctx, dinsu, MIPS_R_T9, MIPS_R_ZERO, 32, 32);
+			src = MIPS_R_T9;
+		}
+
+/* Helper to simplify using BPF_DW/BPF_W atomic opcodes. */
+#define emit_instr_size(ctx, func64, func32, ...)                              \
+do {                                                                           \
+	if (bpf_size == BPF_DW)                                                \
+		emit_instr(ctx, func64, ##__VA_ARGS__);                        \
+	else                                                                   \
+		emit_instr(ctx, func32, ##__VA_ARGS__);                        \
+} while (0)
+
+		/* Track variable branch offset due to CMPXCHG. */
+		b_off = ctx->idx;
+		emit_instr_size(ctx, lld, ll, MIPS_R_AT, mem_off, dst);
+		switch (insn->imm) {
+		case BPF_AND | BPF_FETCH:
+		case BPF_AND:
+			emit_instr(ctx, and, MIPS_R_T8, MIPS_R_AT, src);
+			break;
+		case BPF_OR | BPF_FETCH:
+		case BPF_OR:
+			emit_instr(ctx, or, MIPS_R_T8, MIPS_R_AT, src);
+			break;
+		case BPF_XOR | BPF_FETCH:
+		case BPF_XOR:
+			emit_instr(ctx, xor, MIPS_R_T8, MIPS_R_AT, src);
+			break;
+		case BPF_ADD | BPF_FETCH:
+		case BPF_ADD:
+			emit_instr_size(ctx, daddu, addu, MIPS_R_T8, MIPS_R_AT, src);
+			break;
+		case BPF_XCHG:
+			emit_instr_size(ctx, daddu, addu, MIPS_R_T8, MIPS_R_ZERO, src);
+			break;
+		case BPF_CMPXCHG:
 			/*
-			 * If mem_off does not fit within the 9 bit ll/sc
-			 * instruction immediate field, use a temp reg.
+			 * If R0 != old_val then break out of LL/SC loop
 			 */
-			if (MIPS_ISA_REV >= 6 &&
-			    (mem_off >= BIT(8) || mem_off < -BIT(8))) {
-				emit_instr(ctx, daddiu, MIPS_R_T6,
-						dst, mem_off);
-				mem_off = 0;
-				dst = MIPS_R_T6;
-			}
-			switch (BPF_SIZE(insn->code)) {
-			case BPF_W:
-				if (get_reg_val_type(ctx, this_idx, insn->src_reg) == REG_32BIT) {
-					emit_instr(ctx, sll, MIPS_R_AT, src, 0);
-					src = MIPS_R_AT;
-				}
-				emit_instr(ctx, ll, MIPS_R_T8, mem_off, dst);
-				emit_instr(ctx, addu, MIPS_R_T8, MIPS_R_T8, src);
-				emit_instr(ctx, sc, MIPS_R_T8, mem_off, dst);
-				/*
-				 * On failure back up to LL (-4
-				 * instructions of 4 bytes each
-				 */
-				emit_instr(ctx, beq, MIPS_R_T8, MIPS_R_ZERO, -4 * 4);
-				emit_instr(ctx, nop);
-				break;
-			case BPF_DW:
-				if (get_reg_val_type(ctx, this_idx, insn->src_reg) == REG_32BIT) {
-					emit_instr(ctx, daddu, MIPS_R_AT, src, MIPS_R_ZERO);
-					emit_instr(ctx, dinsu, MIPS_R_AT, MIPS_R_ZERO, 32, 32);
-					src = MIPS_R_AT;
-				}
-				emit_instr(ctx, lld, MIPS_R_T8, mem_off, dst);
-				emit_instr(ctx, daddu, MIPS_R_T8, MIPS_R_T8, src);
-				emit_instr(ctx, scd, MIPS_R_T8, mem_off, dst);
-				emit_instr(ctx, beq, MIPS_R_T8, MIPS_R_ZERO, -4 * 4);
-				emit_instr(ctx, nop);
-				break;
-			}
-		} else { /* BPF_MEM */
-			switch (BPF_SIZE(insn->code)) {
-			case BPF_B:
-				emit_instr(ctx, sb, src, mem_off, dst);
-				break;
-			case BPF_H:
-				emit_instr(ctx, sh, src, mem_off, dst);
-				break;
-			case BPF_W:
-				emit_instr(ctx, sw, src, mem_off, dst);
-				break;
-			case BPF_DW:
-				if (get_reg_val_type(ctx, this_idx, insn->src_reg) == REG_32BIT) {
-					emit_instr(ctx, daddu, MIPS_R_AT, src, MIPS_R_ZERO);
-					emit_instr(ctx, dinsu, MIPS_R_AT, MIPS_R_ZERO, 32, 32);
-					src = MIPS_R_AT;
-				}
-				emit_instr(ctx, sd, src, mem_off, dst);
-				break;
-			}
+			emit_instr(ctx, bne, r0, MIPS_R_AT, 4 * 4);
+			/* Delay slot */
+			emit_instr_size(ctx, daddu, addu, MIPS_R_T8, MIPS_R_ZERO, src);
+			/* Return old_val in R0 */
+			src = r0;
+			break;
+		default:
+			pr_err("ATOMIC OP %02x NOT HANDLED\n", insn->imm);
+			return -EINVAL;
+		}
+		emit_instr_size(ctx, scd, sc, MIPS_R_T8, mem_off, dst);
+#undef emit_instr_size
+		/*
+		 * On failure back up to LL (calculate # insns)
+		 */
+		b_off = (b_off - ctx->idx - 1) * 4;
+		emit_instr(ctx, beqz, MIPS_R_T8, b_off);
+		emit_instr(ctx, nop);
+		/*
+		 * Using fetch returns old value in src or R0
+		 */
+		if (insn->imm & BPF_FETCH) {
+			if (bpf_size == BPF_W)
+				emit_instr(ctx, dinsu, MIPS_R_AT, MIPS_R_ZERO, 32, 32);
+			emit_instr(ctx, move, src, MIPS_R_AT);
 		}
 		break;
 
-- 
2.25.1

