Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0864E4220D0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhJEIdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbhJEIdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:33:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD593C061745;
        Tue,  5 Oct 2021 01:31:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so1857069pjb.0;
        Tue, 05 Oct 2021 01:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3iSI2vxyaOsgRcdG56J0IbiqxH5KKykuTvfOZPZCoc=;
        b=UbVsAMrONqPJTfAXlF5O8lh4M6IZjUdj5jgcD008JzWLNmtFeCHsW8givzreHJAwuM
         qbIXS0y3cAYyW80ttB07CfFxO7knLuOY8OSbn8Ji6Fcv3Uu2AiExBVxmqf3PymGDnFUM
         wmVpvpj8k2Hokkjz/RN+5ak87I/ultBu23ZTFf7HlTdYxnS64Wj1HUKd3SQAiZrFbAR0
         yDkRp9FSWuWlvkrjUcZCV2wXYJGEt0LxPApPziVgwZ/qiCKYtof4fsc3lLf/t/WLTTwR
         s0hw7fZQiCJ3J4oJzE7cvXcwcVfkn3U7TUrl5/N/iSzgpugeEivnx7sqhJfD9xZBBWuE
         dvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3iSI2vxyaOsgRcdG56J0IbiqxH5KKykuTvfOZPZCoc=;
        b=nBlvg1YKA64nyFvFXVCAJQbhDNavU5wrXGYeTm8KYl0lqRHSjBoUcogO/ZXvCMc7Eo
         m0Ivm5UQgJfQZ2aDKp85aKhvQ+UmosA/fLc8pU37rLT7f/kqSP9HEwSRAxIeo43GDPbg
         xe5tanfwLaAMol0mZz4gwZlV9VS27Sak70R2wLIM1hxZhOAT0eTgRrALCznIvs/aM3Jn
         2TcJMKLDaUfLAGS74tz8+jKWJKsbydt6FyyCht+koGOCNqxMmtzI1CQyN09RMMrLqe40
         +3wSshT/O6Rjm8w9i1/h24tPwx8f21rIzL9+TdpROk0Iv/LuAGBg5q5agjigXIwTDQca
         QtnA==
X-Gm-Message-State: AOAM530yegZJEE3dMZj+UDOFsoTkov24ivj/d6c58v947/eKYyCOnDYB
        IYS3ljDbPKHxGdrNUiLcqQk=
X-Google-Smtp-Source: ABdhPJxFmgfBtla3FXGEoqCkSVFjsKdIbKEuMaFlbgBkvejPB4bCdqJaxeDYMac4ELRFRe7kD5HzfA==
X-Received: by 2002:a17:902:fe82:b0:13e:7271:92dc with SMTP id x2-20020a170902fe8200b0013e727192dcmr4193279plm.0.1633422698779;
        Tue, 05 Oct 2021 01:31:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:31:38 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 10/16] MIPS: eBPF: add core support for 32/64-bit systems
Date:   Tue,  5 Oct 2021 01:26:54 -0700
Message-Id: <bf9c5c91f0d638b31499ed196585707316f3e1ba.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update register definitions and flags for both 32/64-bit operation. Add a
common register lookup table, modifying ebpf_to_mips_reg() to use this,
and update enum and literals for ebpf_to_mips_reg() to be more consistent
and less confusing. Add is64bit() and isbigend() common helper functions.

On MIPS32, BPF registers are held in register pairs defined by the base
register. Word-size and endian-aware helper macros select 32-bit registers
from a pair and generate 32-bit word memory storage offsets. The BPF TCC
is stored to the stack due to register pressure.

Update bpf_int_jit_compile() to properly enable BPF2BPF calls, by adding
support for the extra pass needed to fix up function target addresses.
Also provide bpf line info by calling bpf_prog_fill_jited_linfo().
Modify build_int_prologue() and build_int_epilogue() to handle MIPS32
registers and any adjustments needed during program entry/exit/transfer
when transitioning between the native N64/O32 ABI and the BPF 64-bit ABI.
Also ensure ABI-consistent stack alignment and use the verifier-provided
stack depth during setup, saving considerable stack space.

Update emit_const_to_reg() to work across MIPS64 and MIPS32 systems and
optimize gen_imm_to_reg() to only set the lower halfword if needed.

Rework emit_bpf_tail_call() to also support MIPS32 usage and add common
helpers, emit_bpf_call() and emit_push_args(), handling TCC and ABI
variations on MIPS32/MIPS64. Add tail_call_present() and update tailcall
handling to support mixing BPF2BPF subprograms and tailcalls.

Add sign and zero-extension helpers usable with verifier zext insertion,
gen_zext_insn() and gen_sext_insn().

Add common functions emit_caller_save() and emit_caller_restore(), which
push and pop all caller-saved BPF registers to the stack, for use with
JIT-internal kernel calls such as those needed for BPF insns unsupported
by native system ISA opcodes. Since these calls would be hidden from any
BPF C compiler, which would normally spill needed registers during a call,
the JIT must handle save/restore itself.

Adopt a dedicated BPF FP (in MIPS_R_S8), and relax FP usage within insns.
This reduces ad-hoc code doing $sp manipulation with temp registers, and
allows wider usage of BPF FP for comparison and arithmetic. For example,
the following tests from test_verifier are now jited but not previously:

  939/p store PTR_TO_STACK in R10 to array map using BPF_B
  981/p unpriv: cmp pointer with pointer
  984/p unpriv: indirectly pass pointer on stack to helper function
  985/p unpriv: mangle pointer on stack 1
  986/p unpriv: mangle pointer on stack 2
  1001/p unpriv: partial copy of pointer
  1097/p xadd/w check whether src/dst got mangled, 1
  1098/p xadd/w check whether src/dst got mangled, 2

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 1008 +++++++++++++++++++++++++++-----------
 1 file changed, 729 insertions(+), 279 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 7fbd4e371c80..7d8ed8bb19ab 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1,11 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Just-In-Time compiler for eBPF filters on MIPS
- *
- * Copyright (c) 2017 Cavium, Inc.
+ * Just-In-Time compiler for eBPF filters on MIPS32/MIPS64
+ * Copyright (c) 2021 Tony Ambardar <Tony.Ambardar@gmail.com>
  *
  * Based on code from:
  *
+ * Copyright (c) 2017 Cavium, Inc.
+ * Author: David Daney <david.daney@cavium.com>
+ *
  * Copyright (c) 2014 Imagination Technologies Ltd.
  * Author: Markos Chandras <markos.chandras@imgtec.com>
  */
@@ -22,31 +24,42 @@
 #include <asm/isa-rev.h>
 #include <asm/uasm.h>
 
-/* Registers used by JIT */
+/* Registers used by JIT:	  (MIPS32)	(MIPS64) */
 #define MIPS_R_ZERO	0
 #define MIPS_R_AT	1
-#define MIPS_R_V0	2	/* BPF_R0 */
-#define MIPS_R_V1	3
-#define MIPS_R_A0	4	/* BPF_R1 */
-#define MIPS_R_A1	5	/* BPF_R2 */
-#define MIPS_R_A2	6	/* BPF_R3 */
-#define MIPS_R_A3	7	/* BPF_R4 */
-#define MIPS_R_A4	8	/* BPF_R5 */
-#define MIPS_R_T4	12	/* BPF_AX */
-#define MIPS_R_T5	13
-#define MIPS_R_T6	14
-#define MIPS_R_T7	15
-#define MIPS_R_S0	16	/* BPF_R6 */
-#define MIPS_R_S1	17	/* BPF_R7 */
-#define MIPS_R_S2	18	/* BPF_R8 */
-#define MIPS_R_S3	19	/* BPF_R9 */
-#define MIPS_R_S4	20	/* BPF_TCC */
-#define MIPS_R_S5	21
-#define MIPS_R_S6	22
-#define MIPS_R_S7	23
-#define MIPS_R_T8	24
-#define MIPS_R_T9	25
+#define MIPS_R_V0	2	/* BPF_R0	BPF_R0 */
+#define MIPS_R_V1	3	/* BPF_R0	BPF_TCC */
+#define MIPS_R_A0	4	/* BPF_R1	BPF_R1 */
+#define MIPS_R_A1	5	/* BPF_R1	BPF_R2 */
+#define MIPS_R_A2	6	/* BPF_R2	BPF_R3 */
+#define MIPS_R_A3	7	/* BPF_R2	BPF_R4 */
+
+/* MIPS64 replaces T0-T3 scratch regs with extra arguments A4-A7. */
+#ifdef CONFIG_64BIT
+#  define MIPS_R_A4	8	/* (n/a)	BPF_R5 */
+#else
+#  define MIPS_R_T0	8	/* BPF_R3	(n/a)  */
+#  define MIPS_R_T1	9	/* BPF_R3	(n/a)  */
+#  define MIPS_R_T2	10	/* BPF_R4	(n/a)  */
+#  define MIPS_R_T3	11	/* BPF_R4	(n/a)  */
+#endif
+
+#define MIPS_R_T4	12	/* BPF_R5	BPF_AX */
+#define MIPS_R_T5	13	/* BPF_R5	(free) */
+#define MIPS_R_T6	14	/* BPF_AX	(used) */
+#define MIPS_R_T7	15	/* BPF_AX	(free) */
+#define MIPS_R_S0	16	/* BPF_R6	BPF_R6 */
+#define MIPS_R_S1	17	/* BPF_R6	BPF_R7 */
+#define MIPS_R_S2	18	/* BPF_R7	BPF_R8 */
+#define MIPS_R_S3	19	/* BPF_R7	BPF_R9 */
+#define MIPS_R_S4	20	/* BPF_R8	BPF_TCC */
+#define MIPS_R_S5	21	/* BPF_R8	(free) */
+#define MIPS_R_S6	22	/* BPF_R9	(free) */
+#define MIPS_R_S7	23	/* BPF_R9	(free) */
+#define MIPS_R_T8	24	/* (used)	(used) */
+#define MIPS_R_T9	25	/* (used)	(used) */
 #define MIPS_R_SP	29
+#define MIPS_R_S8	30	/* BPF_R10	BPF_R10 */
 #define MIPS_R_RA	31
 
 /* eBPF flags */
@@ -55,10 +68,117 @@
 #define EBPF_SAVE_S2	BIT(2)
 #define EBPF_SAVE_S3	BIT(3)
 #define EBPF_SAVE_S4	BIT(4)
-#define EBPF_SAVE_RA	BIT(5)
-#define EBPF_SEEN_FP	BIT(6)
-#define EBPF_SEEN_TC	BIT(7)
-#define EBPF_TCC_IN_V1	BIT(8)
+#define EBPF_SAVE_S5	BIT(5)
+#define EBPF_SAVE_S6	BIT(6)
+#define EBPF_SAVE_S7	BIT(7)
+#define EBPF_SAVE_S8	BIT(8)
+#define EBPF_SAVE_RA	BIT(9)
+#define EBPF_SEEN_FP	BIT(10)
+#define EBPF_SEEN_TC	BIT(11)
+#define EBPF_TCC_IN_RUN	BIT(12)
+
+/*
+ * Extra JIT registers dedicated to holding TCC during runtime or saving
+ * across calls.
+ */
+enum {
+	JIT_RUN_TCC = MAX_BPF_JIT_REG,
+	JIT_SAV_TCC
+};
+/* Temporary register for passing TCC if nothing dedicated. */
+#define TEMP_PASS_TCC MIPS_R_T8
+
+/*
+ * Word-size and endianness-aware helpers for building MIPS32 vs MIPS64
+ * tables and selecting 32-bit subregisters from a register pair base.
+ * Simplify use by emulating MIPS_R_SP and MIPS_R_ZERO as register pairs
+ * and adding HI/LO word memory offsets.
+ */
+#ifdef CONFIG_64BIT
+#  define HI(reg) (reg)
+#  define LO(reg) (reg)
+#  define OFFHI(mem) (mem)
+#  define OFFLO(mem) (mem)
+#else	/* CONFIG_32BIT */
+#  ifdef __BIG_ENDIAN
+#    define HI(reg) ((reg) == MIPS_R_SP ? MIPS_R_ZERO : \
+		     (reg) == MIPS_R_S8 ? MIPS_R_ZERO : \
+		     (reg))
+#    define LO(reg) ((reg) == MIPS_R_ZERO ? (reg) : \
+		     (reg) == MIPS_R_SP ? (reg) : \
+		     (reg) == MIPS_R_S8 ? (reg) : \
+		     (reg) + 1)
+#    define OFFHI(mem) (mem)
+#    define OFFLO(mem) ((mem) + sizeof(long))
+#  else	/* __LITTLE_ENDIAN */
+#    define HI(reg) ((reg) == MIPS_R_ZERO ? (reg) : \
+		     (reg) == MIPS_R_SP ? MIPS_R_ZERO : \
+		     (reg) == MIPS_R_S8 ? MIPS_R_ZERO : \
+		     (reg) + 1)
+#    define LO(reg) (reg)
+#    define OFFHI(mem) ((mem) + sizeof(long))
+#    define OFFLO(mem) (mem)
+#  endif
+#endif
+
+#ifdef CONFIG_64BIT
+#  define M(expr32, expr64) (expr64)
+#else
+#  define M(expr32, expr64) (expr32)
+#endif
+const struct {
+	/* Register or pair base */
+	int reg;
+	/* Register flags */
+	u32 flags;
+	/* Usage table:   (MIPS32)			 (MIPS64) */
+} bpf2mips[] = {
+	/* Return value from in-kernel function, and exit value from eBPF. */
+	[BPF_REG_0] =  {M(MIPS_R_V0,			MIPS_R_V0)},
+	/* Arguments from eBPF program to in-kernel/BPF functions. */
+	[BPF_REG_1] =  {M(MIPS_R_A0,			MIPS_R_A0)},
+	[BPF_REG_2] =  {M(MIPS_R_A2,			MIPS_R_A1)},
+	[BPF_REG_3] =  {M(MIPS_R_T0,			MIPS_R_A2)},
+	[BPF_REG_4] =  {M(MIPS_R_T2,			MIPS_R_A3)},
+	[BPF_REG_5] =  {M(MIPS_R_T4,			MIPS_R_A4)},
+	/* Callee-saved registers preserved by in-kernel/BPF functions. */
+	[BPF_REG_6] =  {M(MIPS_R_S0,			MIPS_R_S0),
+			M(EBPF_SAVE_S0|EBPF_SAVE_S1,	EBPF_SAVE_S0)},
+	[BPF_REG_7] =  {M(MIPS_R_S2,			MIPS_R_S1),
+			M(EBPF_SAVE_S2|EBPF_SAVE_S3,	EBPF_SAVE_S1)},
+	[BPF_REG_8] =  {M(MIPS_R_S4,			MIPS_R_S2),
+			M(EBPF_SAVE_S4|EBPF_SAVE_S5,	EBPF_SAVE_S2)},
+	[BPF_REG_9] =  {M(MIPS_R_S6,			MIPS_R_S3),
+			M(EBPF_SAVE_S6|EBPF_SAVE_S7,	EBPF_SAVE_S3)},
+	[BPF_REG_10] = {M(MIPS_R_S8,			MIPS_R_S8),
+			M(EBPF_SAVE_S8|EBPF_SEEN_FP,	EBPF_SAVE_S8|EBPF_SEEN_FP)},
+	/* Internal register for rewriting insns during JIT blinding. */
+	[BPF_REG_AX] = {M(MIPS_R_T6,			MIPS_R_T4)},
+	/*
+	 * Internal registers for TCC runtime holding and saving during
+	 * calls. A zero save register indicates using scratch space on
+	 * the stack for storage during calls. A zero hold register means
+	 * no dedicated register holds TCC during runtime (but a temp reg
+	 * still passes TCC to tailcall or bpf2bpf call).
+	 */
+	[JIT_RUN_TCC] =	{M(0,				MIPS_R_V1)},
+	[JIT_SAV_TCC] =	{M(0,				MIPS_R_S4),
+			 M(0,				EBPF_SAVE_S4)}
+};
+#undef M
+
+static inline bool is64bit(void)
+{
+	return IS_ENABLED(CONFIG_64BIT);
+}
+
+static inline bool isbigend(void)
+{
+	return IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
+}
+
+/* Stack region alignment under N64 and O32 ABIs */
+#define STACK_ALIGN (2 * sizeof(long))
 
 /*
  * For the mips64 ISA, we need to track the value range or type for
@@ -89,17 +209,21 @@ enum reg_val_type {
 
 /**
  * struct jit_ctx - JIT context
- * @skf:		The sk_filter
+ * @prog:		The program
  * @stack_size:		eBPF stack size
+ * @bpf_stack_off:	eBPF FP offset
+ * @prolog_skip:	Prologue insns to skip by BPF caller
  * @idx:		Instruction index
  * @flags:		JIT flags
  * @offsets:		Instruction offsets
- * @target:		Memory location for the compiled filter
- * @reg_val_types	Packed enum reg_val_type for each register.
+ * @target:		Memory location for compiled instructions
+ * @reg_val_types:	Packed enum reg_val_type for each register
  */
 struct jit_ctx {
-	const struct bpf_prog *skf;
+	const struct bpf_prog *prog;
 	int stack_size;
+	int bpf_stack_off;
+	int prolog_skip;
 	u32 idx;
 	u32 flags;
 	u32 *offsets;
@@ -177,132 +301,192 @@ static u32 b_imm(unsigned int tgt, struct jit_ctx *ctx)
 		(ctx->idx * 4) - 4;
 }
 
-enum which_ebpf_reg {
-	src_reg,
-	src_reg_no_fp,
-	dst_reg,
-	dst_reg_fp_ok
+/* Sign-extend dst register or HI 32-bit reg of pair. */
+static inline void gen_sext_insn(int dst, struct jit_ctx *ctx)
+{
+	if (is64bit())
+		emit_instr(ctx, sll, dst, dst, 0);
+	else
+		emit_instr(ctx, sra, HI(dst), LO(dst), 31);
+}
+
+/*
+ * Zero-extend dst register or HI 32-bit reg of pair, if either forced
+ * or the BPF verifier does not insert its own zext insns.
+ */
+static inline void gen_zext_insn(int dst, bool force, struct jit_ctx *ctx)
+{
+	if (!ctx->prog->aux->verifier_zext || force) {
+		if (is64bit())
+			emit_instr(ctx, dinsu, dst, MIPS_R_ZERO, 32, 32);
+		else
+			emit_instr(ctx, and, HI(dst), MIPS_R_ZERO, MIPS_R_ZERO);
+	}
+}
+
+static inline bool tail_call_present(struct jit_ctx *ctx)
+{
+	return ctx->flags & EBPF_SEEN_TC || ctx->prog->aux->tail_call_reachable;
+}
+
+enum reg_usage {
+	REG_SRC_FP_OK,
+	REG_SRC_NO_FP,
+	REG_DST_FP_OK,
+	REG_DST_NO_FP
 };
 
 /*
  * For eBPF, the register mapping naturally falls out of the
- * requirements of eBPF and the MIPS n64 ABI.  We don't maintain a
- * separate frame pointer, so BPF_REG_10 relative accesses are
- * adjusted to be $sp relative.
+ * requirements of eBPF and the MIPS N64/O32 ABIs. We also maintain
+ * a separate frame pointer, setting BPF_REG_10 relative to $sp.
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
 	case BPF_REG_0:
-		return MIPS_R_V0;
 	case BPF_REG_1:
-		return MIPS_R_A0;
 	case BPF_REG_2:
-		return MIPS_R_A1;
 	case BPF_REG_3:
-		return MIPS_R_A2;
 	case BPF_REG_4:
-		return MIPS_R_A3;
 	case BPF_REG_5:
-		return MIPS_R_A4;
 	case BPF_REG_6:
-		ctx->flags |= EBPF_SAVE_S0;
-		return MIPS_R_S0;
 	case BPF_REG_7:
-		ctx->flags |= EBPF_SAVE_S1;
-		return MIPS_R_S1;
 	case BPF_REG_8:
-		ctx->flags |= EBPF_SAVE_S2;
-		return MIPS_R_S2;
 	case BPF_REG_9:
-		ctx->flags |= EBPF_SAVE_S3;
-		return MIPS_R_S3;
+	case BPF_REG_AX:
+		ctx->flags |= bpf2mips[ebpf_reg].flags;
+		return bpf2mips[ebpf_reg].reg;
 	case BPF_REG_10:
-		if (w == dst_reg || w == src_reg_no_fp)
+		if (u == REG_DST_NO_FP || u == REG_SRC_NO_FP)
 			goto bad_reg;
-		ctx->flags |= EBPF_SEEN_FP;
-		/*
-		 * Needs special handling, return something that
-		 * cannot be clobbered just in case.
-		 */
-		return MIPS_R_ZERO;
-	case BPF_REG_AX:
-		return MIPS_R_T4;
+		ctx->flags |= bpf2mips[ebpf_reg].flags;
+		return bpf2mips[ebpf_reg].reg;
 	default:
 bad_reg:
 		WARN(1, "Illegal bpf reg: %d\n", ebpf_reg);
 		return -EINVAL;
 	}
 }
+
 /*
  * eBPF stack frame will be something like:
  *
  *  Entry $sp ------>   +--------------------------------+
  *                      |   $ra  (optional)              |
  *                      +--------------------------------+
- *                      |   $s0  (optional)              |
+ *                      |   $s8  (optional)              |
  *                      +--------------------------------+
- *                      |   $s1  (optional)              |
+ *                      |   $s7  (optional)              |
  *                      +--------------------------------+
- *                      |   $s2  (optional)              |
+ *                      |   $s6  (optional)              |
  *                      +--------------------------------+
- *                      |   $s3  (optional)              |
+ *                      |   $s5  (optional)              |
  *                      +--------------------------------+
  *                      |   $s4  (optional)              |
  *                      +--------------------------------+
- *                      |   tmp-storage  (if $ra saved)  |
- * $sp + tmp_offset --> +--------------------------------+ <--BPF_REG_10
+ *                      |   $s3  (optional)              |
+ *                      +--------------------------------+
+ *                      |   $s2  (optional)              |
+ *                      +--------------------------------+
+ *                      |   $s1  (optional)              |
+ *                      +--------------------------------+
+ *                      |   $s0  (optional)              |
+ *                      +--------------------------------+
+ *                      |   tmp-storage  (optional)      |
+ * $sp + bpf_stack_off->+--------------------------------+ <--BPF_REG_10
  *                      |   BPF_REG_10 relative storage  |
  *                      |    MAX_BPF_STACK (optional)    |
  *                      |      .                         |
  *                      |      .                         |
  *                      |      .                         |
- *     $sp -------->    +--------------------------------+
+ *        $sp ------>   +--------------------------------+
  *
  * If BPF_REG_10 is never referenced, then the MAX_BPF_STACK sized
  * area is not allocated.
  */
-static int gen_int_prologue(struct jit_ctx *ctx)
+static int build_int_prologue(struct jit_ctx *ctx)
 {
+	int tcc_run = bpf2mips[JIT_RUN_TCC].reg ?
+		      bpf2mips[JIT_RUN_TCC].reg :
+		      TEMP_PASS_TCC;
+	int tcc_sav = bpf2mips[JIT_SAV_TCC].reg;
+	const struct bpf_prog *prog = ctx->prog;
+	int r10 = bpf2mips[BPF_REG_10].reg;
+	int r1 = bpf2mips[BPF_REG_1].reg;
 	int stack_adjust = 0;
 	int store_offset;
 	int locals_size;
+	int start_idx;
 
 	if (ctx->flags & EBPF_SAVE_RA)
-		/*
-		 * If RA we are doing a function call and may need
-		 * extra 8-byte tmp area.
-		 */
-		stack_adjust += 2 * sizeof(long);
-	if (ctx->flags & EBPF_SAVE_S0)
 		stack_adjust += sizeof(long);
-	if (ctx->flags & EBPF_SAVE_S1)
+	if (ctx->flags & EBPF_SAVE_S8)
 		stack_adjust += sizeof(long);
-	if (ctx->flags & EBPF_SAVE_S2)
+	if (ctx->flags & EBPF_SAVE_S7)
 		stack_adjust += sizeof(long);
-	if (ctx->flags & EBPF_SAVE_S3)
+	if (ctx->flags & EBPF_SAVE_S6)
+		stack_adjust += sizeof(long);
+	if (ctx->flags & EBPF_SAVE_S5)
 		stack_adjust += sizeof(long);
 	if (ctx->flags & EBPF_SAVE_S4)
 		stack_adjust += sizeof(long);
+	if (ctx->flags & EBPF_SAVE_S3)
+		stack_adjust += sizeof(long);
+	if (ctx->flags & EBPF_SAVE_S2)
+		stack_adjust += sizeof(long);
+	if (ctx->flags & EBPF_SAVE_S1)
+		stack_adjust += sizeof(long);
+	if (ctx->flags & EBPF_SAVE_S0)
+		stack_adjust += sizeof(long);
+	if (tail_call_present(ctx) &&
+	    !(ctx->flags & EBPF_TCC_IN_RUN) && !tcc_sav)
+		/* Allocate scratch space for holding TCC if needed. */
+		stack_adjust += sizeof(long);
+
+	stack_adjust = ALIGN(stack_adjust, STACK_ALIGN);
 
-	BUILD_BUG_ON(MAX_BPF_STACK & 7);
-	locals_size = (ctx->flags & EBPF_SEEN_FP) ? MAX_BPF_STACK : 0;
+	locals_size = (ctx->flags & EBPF_SEEN_FP) ? prog->aux->stack_depth : 0;
+	locals_size = ALIGN(locals_size, STACK_ALIGN);
 
 	stack_adjust += locals_size;
 
 	ctx->stack_size = stack_adjust;
+	ctx->bpf_stack_off = locals_size;
 
 	/*
-	 * First instruction initializes the tail call count (TCC).
-	 * On tail call we skip this instruction, and the TCC is
-	 * passed in $v1 from the caller.
+	 * First instruction initializes the tail call count (TCC) and
+	 * assumes a call from kernel using the native ABI. Calls made
+	 * using the BPF ABI (bpf2bpf or tail call) will skip this insn
+	 * and pass the TCC via register.
 	 */
-	emit_instr(ctx, addiu, MIPS_R_V1, MIPS_R_ZERO, MAX_TAIL_CALL_CNT);
+	start_idx = ctx->idx;
+	emit_instr(ctx, addiu, tcc_run, MIPS_R_ZERO, MAX_TAIL_CALL_CNT);
+
+	/*
+	 * When called from kernel under O32 ABI we must set up BPF R1
+	 * context, since BPF R1 is an endian-order regster pair ($a0:$a1
+	 * or $a1:$a0) but context is always passed in $a0 as a 32-bit
+	 * pointer. As above, bpf2bpf and tail calls will skip these insns
+	 * since all registers are correctly set up already.
+	 */
+	if (!is64bit()) {
+		if (isbigend())
+			emit_instr(ctx, move, LO(r1), MIPS_R_A0);
+		/* Sanitize upper 32-bit reg */
+		gen_zext_insn(r1, true, ctx);
+	}
+	/*
+	 * Calls using BPF ABI (bpf2bpf and tail calls) will skip TCC
+	 * initialization and R1 context fixup needed by kernel calls.
+	 */
+	ctx->prolog_skip = (ctx->idx - start_idx) * 4;
+
 	if (stack_adjust)
 		emit_instr_long(ctx, daddiu, addiu,
 					MIPS_R_SP, MIPS_R_SP, -stack_adjust);
@@ -316,24 +500,24 @@ static int gen_int_prologue(struct jit_ctx *ctx)
 					MIPS_R_RA, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S0) {
+	if (ctx->flags & EBPF_SAVE_S8) {
 		emit_instr_long(ctx, sd, sw,
-					MIPS_R_S0, store_offset, MIPS_R_SP);
+					MIPS_R_S8, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S1) {
+	if (ctx->flags & EBPF_SAVE_S7) {
 		emit_instr_long(ctx, sd, sw,
-					MIPS_R_S1, store_offset, MIPS_R_SP);
+					MIPS_R_S7, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S2) {
+	if (ctx->flags & EBPF_SAVE_S6) {
 		emit_instr_long(ctx, sd, sw,
-					MIPS_R_S2, store_offset, MIPS_R_SP);
+					MIPS_R_S6, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S3) {
+	if (ctx->flags & EBPF_SAVE_S5) {
 		emit_instr_long(ctx, sd, sw,
-					MIPS_R_S3, store_offset, MIPS_R_SP);
+					MIPS_R_S5, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
 	if (ctx->flags & EBPF_SAVE_S4) {
@@ -341,27 +525,95 @@ static int gen_int_prologue(struct jit_ctx *ctx)
 					MIPS_R_S4, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
+	if (ctx->flags & EBPF_SAVE_S3) {
+		emit_instr_long(ctx, sd, sw,
+					MIPS_R_S3, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+	if (ctx->flags & EBPF_SAVE_S2) {
+		emit_instr_long(ctx, sd, sw,
+					MIPS_R_S2, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+	if (ctx->flags & EBPF_SAVE_S1) {
+		emit_instr_long(ctx, sd, sw,
+					MIPS_R_S1, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+	if (ctx->flags & EBPF_SAVE_S0) {
+		emit_instr_long(ctx, sd, sw,
+					MIPS_R_S0, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+
+	/* Store TCC in backup register or stack scratch space if indicated. */
+	if (tail_call_present(ctx) && !(ctx->flags & EBPF_TCC_IN_RUN)) {
+		if (tcc_sav)
+			emit_instr(ctx, move, tcc_sav, tcc_run);
+		else
+			emit_instr_long(ctx, sd, sw,
+					tcc_run, ctx->bpf_stack_off, MIPS_R_SP);
+	}
 
-	if ((ctx->flags & EBPF_SEEN_TC) && !(ctx->flags & EBPF_TCC_IN_V1))
-		emit_instr_long(ctx, daddu, addu,
-					MIPS_R_S4, MIPS_R_V1, MIPS_R_ZERO);
+	/* Prepare BPF FP as single-reg ptr, emulate upper 32-bits as needed.*/
+	if (ctx->flags & EBPF_SEEN_FP)
+		emit_instr_long(ctx, daddiu, addiu, r10,
+						MIPS_R_SP, ctx->bpf_stack_off);
 
 	return 0;
 }
 
 static int build_int_epilogue(struct jit_ctx *ctx, int dest_reg)
 {
-	const struct bpf_prog *prog = ctx->skf;
+	const struct bpf_prog *prog = ctx->prog;
 	int stack_adjust = ctx->stack_size;
 	int store_offset = stack_adjust - sizeof(long);
+	int ax = bpf2mips[BPF_REG_AX].reg;
+	int r0 = bpf2mips[BPF_REG_0].reg;
 	enum reg_val_type td;
-	int r0 = MIPS_R_V0;
 
-	if (dest_reg == MIPS_R_RA) {
-		/* Don't let zero extended value escape. */
-		td = get_reg_val_type(ctx, prog->len, BPF_REG_0);
-		if (td == REG_64BIT)
-			emit_instr(ctx, sll, r0, r0, 0);
+	/*
+	 * As in prologue code, we default to assuming exit to the kernel.
+	 * Returns to the kernel follow the N64 or O32 ABI. For N64, the
+	 * BPF R0 return value may need to be sign-extended, while O32 may
+	 * need fixup of BPF R0 to place the 32-bit return value in MIPS V0.
+	 *
+	 * Returns to BPF2BPF callers consistently use the BPF 64-bit ABI,
+	 * so register usage and mapping between JIT and OS is unchanged.
+	 * Accommodate by saving unmodified R0 register data to allow a
+	 * BPF caller to restore R0 after we return.
+	 */
+	if (dest_reg == MIPS_R_RA) { /* kernel or bpf2bpf function return */
+		if (is64bit()) {
+			/*
+			 * Backup BPF R0 to AX, allowing the caller to
+			 * restore it in case this is a BPF2BPF rather
+			 * than a kernel return.
+			 */
+			emit_instr(ctx, move, ax, r0);
+			/*
+			 * Don't let zero-extended R0 value escape to
+			 * kernel on return, so sign-extend if needed.
+			 */
+			td = get_reg_val_type(ctx, prog->len, BPF_REG_0);
+			if (td == REG_64BIT)
+				gen_sext_insn(r0, ctx);
+		} else if (isbigend()) { /* and 32-bit */
+			/*
+			 * Backup high 32-bit register of BPF R0 to AX,
+			 * since it occupies MIPS_R_V0 which needs to be
+			 * clobbered for a kernel return.
+			 */
+			emit_instr(ctx, move, HI(ax), HI(r0));
+			/*
+			 * O32 ABI specifies 32-bit return value always
+			 * placed in MIPS_R_V0 regardless of the native
+			 * endianness. This would be in the wrong position
+			 * in a BPF R0 reg pair on big-endian systems, so
+			 * we must relocate.
+			 */
+			emit_instr(ctx, move, MIPS_R_V0, LO(r0));
+		}
 	}
 
 	if (ctx->flags & EBPF_SAVE_RA) {
@@ -369,24 +621,24 @@ static int build_int_epilogue(struct jit_ctx *ctx, int dest_reg)
 					MIPS_R_RA, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S0) {
+	if (ctx->flags & EBPF_SAVE_S8) {
 		emit_instr_long(ctx, ld, lw,
-					MIPS_R_S0, store_offset, MIPS_R_SP);
+					MIPS_R_S8, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S1) {
+	if (ctx->flags & EBPF_SAVE_S7) {
 		emit_instr_long(ctx, ld, lw,
-					MIPS_R_S1, store_offset, MIPS_R_SP);
+					MIPS_R_S7, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S2) {
+	if (ctx->flags & EBPF_SAVE_S6) {
 		emit_instr_long(ctx, ld, lw,
-				MIPS_R_S2, store_offset, MIPS_R_SP);
+					MIPS_R_S6, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
-	if (ctx->flags & EBPF_SAVE_S3) {
+	if (ctx->flags & EBPF_SAVE_S5) {
 		emit_instr_long(ctx, ld, lw,
-					MIPS_R_S3, store_offset, MIPS_R_SP);
+					MIPS_R_S5, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
 	if (ctx->flags & EBPF_SAVE_S4) {
@@ -394,8 +646,29 @@ static int build_int_epilogue(struct jit_ctx *ctx, int dest_reg)
 					MIPS_R_S4, store_offset, MIPS_R_SP);
 		store_offset -= sizeof(long);
 	}
+	if (ctx->flags & EBPF_SAVE_S3) {
+		emit_instr_long(ctx, ld, lw,
+					MIPS_R_S3, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+	if (ctx->flags & EBPF_SAVE_S2) {
+		emit_instr_long(ctx, ld, lw,
+					MIPS_R_S2, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+	if (ctx->flags & EBPF_SAVE_S1) {
+		emit_instr_long(ctx, ld, lw,
+					MIPS_R_S1, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
+	if (ctx->flags & EBPF_SAVE_S0) {
+		emit_instr_long(ctx, ld, lw,
+					MIPS_R_S0, store_offset, MIPS_R_SP);
+		store_offset -= sizeof(long);
+	}
 	emit_instr(ctx, jr, dest_reg);
 
+	/* Delay slot */
 	if (stack_adjust)
 		emit_instr_long(ctx, daddiu, addiu,
 					MIPS_R_SP, MIPS_R_SP, stack_adjust);
@@ -415,7 +688,9 @@ static void gen_imm_to_reg(const struct bpf_insn *insn, int reg,
 		int upper = insn->imm - lower;
 
 		emit_instr(ctx, lui, reg, upper >> 16);
-		emit_instr(ctx, addiu, reg, reg, lower);
+		/* lui already clears lower halfword */
+		if (lower)
+			emit_instr(ctx, addiu, reg, reg, lower);
 	}
 }
 
@@ -423,7 +698,7 @@ static int gen_imm_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			int idx)
 {
 	int upper_bound, lower_bound;
-	int dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+	int dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 
 	if (dst < 0)
 		return dst;
@@ -564,12 +839,12 @@ static int gen_imm_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	return 0;
 }
 
-static void emit_const_to_reg(struct jit_ctx *ctx, int dst, u64 value)
+static void emit_const_to_reg(struct jit_ctx *ctx, int dst, unsigned long value)
 {
-	if (value >= 0xffffffffffff8000ull || value < 0x8000ull) {
-		emit_instr(ctx, daddiu, dst, MIPS_R_ZERO, (int)value);
-	} else if (value >= 0xffffffff80000000ull ||
-		   (value < 0x80000000 && value > 0xffff)) {
+	if (value >= S16_MIN || value <= S16_MAX) {
+		emit_instr_long(ctx, daddiu, addiu, dst, MIPS_R_ZERO, (int)value);
+	} else if (value >= S32_MIN ||
+		   (value <= S32_MAX && value > U16_MAX)) {
 		emit_instr(ctx, lui, dst, (s32)(s16)(value >> 16));
 		emit_instr(ctx, ori, dst, dst, (unsigned int)(value & 0xffff));
 	} else {
@@ -601,54 +876,167 @@ static void emit_const_to_reg(struct jit_ctx *ctx, int dst, u64 value)
 	}
 }
 
+/*
+ * Push BPF regs R3-R5 to the stack, skipping BPF regs R1-R2 which are
+ * passed via MIPS register pairs in $a0-$a3. Register order within pairs
+ * and the memory storage order are identical i.e. endian native.
+ */
+static void emit_push_args(struct jit_ctx *ctx)
+{
+	int store_offset = 2 * sizeof(u64); /* Skip R1-R2 in $a0-$a3 */
+	int bpf, reg;
+
+	for (bpf = BPF_REG_3; bpf <= BPF_REG_5; bpf++) {
+		reg = bpf2mips[bpf].reg;
+
+		emit_instr(ctx, sw, LO(reg), OFFLO(store_offset), MIPS_R_SP);
+		emit_instr(ctx, sw, HI(reg), OFFHI(store_offset), MIPS_R_SP);
+		store_offset += sizeof(u64);
+	}
+}
+
+/*
+ * Common helper for BPF_CALL insn, handling TCC and ABI variations.
+ * Kernel calls under O32 ABI require arguments passed on the stack,
+ * while BPF2BPF calls need the TCC passed via register as expected
+ * by the subprog's prologue.
+ *
+ * Under MIPS32 O32 ABI calling convention, u64 BPF regs R1-R2 are passed
+ * via reg pairs in $a0-$a3, while BPF regs R3-R5 are passed via the stack.
+ * Stack space is still reserved for $a0-$a3, and the whole area aligned.
+ */
+#define ARGS_SIZE (5 * sizeof(u64))
+
+void emit_bpf_call(struct jit_ctx *ctx, const struct bpf_insn *insn)
+{
+	int stack_adjust = ALIGN(ARGS_SIZE, STACK_ALIGN);
+	int tcc_run = bpf2mips[JIT_RUN_TCC].reg ?
+		      bpf2mips[JIT_RUN_TCC].reg :
+		      TEMP_PASS_TCC;
+	int tcc_sav = bpf2mips[JIT_SAV_TCC].reg;
+	int ax = bpf2mips[BPF_REG_AX].reg;
+	int r0 = bpf2mips[BPF_REG_0].reg;
+	long func_addr;
+
+	ctx->flags |= EBPF_SAVE_RA;
+
+	/* Ensure TCC passed into BPF subprog */
+	if ((insn->src_reg == BPF_PSEUDO_CALL) &&
+	    tail_call_present(ctx) && !(ctx->flags & EBPF_TCC_IN_RUN)) {
+		/* Set TCC from reg or stack */
+		if (tcc_sav)
+			emit_instr(ctx, move, tcc_run, tcc_sav);
+		else
+			emit_instr_long(ctx, ld, lw, tcc_run,
+						ctx->bpf_stack_off, MIPS_R_SP);
+	}
+
+	/* Push O32 stack args for kernel call */
+	if (!is64bit() && (insn->src_reg != BPF_PSEUDO_CALL)) {
+		emit_instr(ctx, addiu, MIPS_R_SP, MIPS_R_SP, -stack_adjust);
+		emit_push_args(ctx);
+	}
+
+	func_addr = (long)__bpf_call_base + insn->imm;
+
+	/* Skip TCC init and R1 register fixup with BPF ABI. */
+	if (insn->src_reg == BPF_PSEUDO_CALL)
+		func_addr += ctx->prolog_skip;
+
+	emit_const_to_reg(ctx, MIPS_R_T9, func_addr);
+	emit_instr(ctx, jalr, MIPS_R_RA, MIPS_R_T9);
+	/* Delay slot */
+	emit_instr(ctx, nop);
+
+	/* Restore stack */
+	if (!is64bit() && (insn->src_reg != BPF_PSEUDO_CALL))
+		emit_instr(ctx, addiu, MIPS_R_SP, MIPS_R_SP, stack_adjust);
+
+	/*
+	 * Assuming a kernel return, a MIPS64 function epilogue may
+	 * sign-extend R0, while MIPS32BE mangles the R0 register pair.
+	 * Undo both for a bpf2bpf call return.
+	 */
+	if (insn->src_reg == BPF_PSEUDO_CALL) {
+		/* Restore BPF R0 from AX */
+		if (is64bit()) {
+			emit_instr(ctx, move, r0, ax);
+		} else if (isbigend()) { /* and 32-bit */
+			emit_instr(ctx, move, LO(r0), MIPS_R_V0);
+			emit_instr(ctx, move, HI(r0), HI(ax));
+		}
+	}
+}
+
+/*
+ * Tail call helper arguments passed via BPF ABI as u64 parameters. On
+ * MIPS64 N64 ABI systems these are native regs, while on MIPS32 O32 ABI
+ * systems these are reg pairs:
+ *
+ * R1 -> &ctx
+ * R2 -> &array
+ * R3 -> index
+ */
 static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 {
+	int tcc_run = bpf2mips[JIT_RUN_TCC].reg ?
+		      bpf2mips[JIT_RUN_TCC].reg :
+		      TEMP_PASS_TCC;
+	int tcc_sav = bpf2mips[JIT_SAV_TCC].reg;
+	int r2 = bpf2mips[BPF_REG_2].reg;
+	int r3 = bpf2mips[BPF_REG_3].reg;
 	int off, b_off;
-	int tcc_reg;
+	int tcc;
 
 	ctx->flags |= EBPF_SEEN_TC;
 	/*
 	 * if (index >= array->map.max_entries)
 	 *     goto out;
 	 */
-	/* Mask index as 32-bit */
-	emit_instr(ctx, dinsu, MIPS_R_A2, MIPS_R_ZERO, 32, 32);
+	if (is64bit())
+		/* Mask index as 32-bit */
+		gen_zext_insn(r3, true, ctx);
 	off = offsetof(struct bpf_array, map.max_entries);
-	emit_instr(ctx, lwu, MIPS_R_T5, off, MIPS_R_A1);
-	emit_instr(ctx, sltu, MIPS_R_AT, MIPS_R_T5, MIPS_R_A2);
+	emit_instr_long(ctx, lwu, lw, MIPS_R_AT, off, LO(r2));
+	emit_instr(ctx, sltu, MIPS_R_AT, MIPS_R_AT, LO(r3));
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
+	emit_instr(ctx, bnez, MIPS_R_AT, b_off);
 	/*
 	 * if (TCC-- < 0)
 	 *     goto out;
 	 */
 	/* Delay slot */
-	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
-	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
+	tcc = (ctx->flags & EBPF_TCC_IN_RUN) ? tcc_run : tcc_sav;
+	/* Get TCC from reg or stack */
+	if (tcc)
+		emit_instr(ctx, move, MIPS_R_T8, tcc);
+	else
+		emit_instr_long(ctx, ld, lw, MIPS_R_T8,
+						ctx->bpf_stack_off, MIPS_R_SP);
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, bltz, tcc_reg, b_off);
+	emit_instr(ctx, bltz, MIPS_R_T8, b_off);
 	/*
 	 * prog = array->ptrs[index];
 	 * if (prog == NULL)
 	 *     goto out;
 	 */
 	/* Delay slot */
-	emit_instr(ctx, dsll, MIPS_R_T8, MIPS_R_A2, 3);
-	emit_instr(ctx, daddu, MIPS_R_T8, MIPS_R_T8, MIPS_R_A1);
+	emit_instr_long(ctx, dsll, sll, MIPS_R_AT, LO(r3), ilog2(sizeof(long)));
+	emit_instr_long(ctx, daddu, addu, MIPS_R_AT, MIPS_R_AT, LO(r2));
 	off = offsetof(struct bpf_array, ptrs);
-	emit_instr(ctx, ld, MIPS_R_AT, off, MIPS_R_T8);
+	emit_instr_long(ctx, ld, lw, MIPS_R_AT, off, MIPS_R_AT);
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, beq, MIPS_R_AT, MIPS_R_ZERO, b_off);
+	emit_instr(ctx, beqz, MIPS_R_AT, b_off);
 	/* Delay slot */
 	emit_instr(ctx, nop);
 
-	/* goto *(prog->bpf_func + 4); */
+	/* goto *(prog->bpf_func + skip); */
 	off = offsetof(struct bpf_prog, bpf_func);
-	emit_instr(ctx, ld, MIPS_R_T9, off, MIPS_R_AT);
-	/* All systems are go... propagate TCC */
-	emit_instr(ctx, daddu, MIPS_R_V1, MIPS_R_T5, MIPS_R_ZERO);
-	/* Skip first instruction (TCC initialization) */
-	emit_instr(ctx, daddiu, MIPS_R_T9, MIPS_R_T9, 4);
+	emit_instr_long(ctx, ld, lw, MIPS_R_T9, off, MIPS_R_AT);
+	/* All systems are go... decrement and propagate TCC */
+	emit_instr_long(ctx, daddiu, addiu, tcc_run, MIPS_R_T8, -1);
+	/* Skip first instructions (TCC init and R1 fixup) */
+	emit_instr_long(ctx, daddiu, addiu, MIPS_R_T9, MIPS_R_T9, ctx->prolog_skip);
 	return build_int_epilogue(ctx, MIPS_R_T9);
 }
 
@@ -696,7 +1084,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			return r;
 		break;
 	case BPF_ALU64 | BPF_MUL | BPF_K: /* ALU64_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -712,7 +1100,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 	case BPF_ALU64 | BPF_NEG | BPF_K: /* ALU64_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -720,7 +1108,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_instr(ctx, dsubu, dst, MIPS_R_ZERO, dst);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_K: /* ALU_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -739,7 +1127,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 	case BPF_ALU | BPF_NEG | BPF_K: /* ALU_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -753,7 +1141,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU | BPF_MOD | BPF_K: /* ALU_IMM */
 		if (insn->imm == 0)
 			return -EINVAL;
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -784,7 +1172,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU64 | BPF_MOD | BPF_K: /* ALU_IMM */
 		if (insn->imm == 0)
 			return -EINVAL;
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		if (get_reg_val_type(ctx, this_idx, insn->dst_reg) == REG_32BIT)
@@ -821,22 +1209,14 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
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
 			emit_instr(ctx, dinsu, dst, MIPS_R_ZERO, 32, 32);
 		did_move = false;
-		if (insn->src_reg == BPF_REG_10) {
-			if (bpf_op == BPF_MOV) {
-				emit_instr(ctx, daddiu, dst, MIPS_R_SP, MAX_BPF_STACK);
-				did_move = true;
-			} else {
-				emit_instr(ctx, daddiu, MIPS_R_AT, MIPS_R_SP, MAX_BPF_STACK);
-				src = MIPS_R_AT;
-			}
-		} else if (get_reg_val_type(ctx, this_idx, insn->src_reg) == REG_32BIT) {
+		if (get_reg_val_type(ctx, this_idx, insn->src_reg) == REG_32BIT) {
 			int tmp_reg = MIPS_R_AT;
 
 			if (bpf_op == BPF_MOV) {
@@ -917,8 +1297,8 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ALU | BPF_LSH | BPF_X: /* ALU_REG */
 	case BPF_ALU | BPF_RSH | BPF_X: /* ALU_REG */
 	case BPF_ALU | BPF_ARSH | BPF_X: /* ALU_REG */
-		src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -1008,7 +1388,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JEQ | BPF_K: /* JMP_IMM */
 	case BPF_JMP | BPF_JNE | BPF_K: /* JMP_IMM */
 		cmp_eq = (bpf_op == BPF_JEQ);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 		if (insn->imm == 0) {
@@ -1029,8 +1409,8 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JGT | BPF_X:
 	case BPF_JMP | BPF_JGE | BPF_X:
 	case BPF_JMP | BPF_JSET | BPF_X:
-		src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (src < 0 || dst < 0)
 			return -EINVAL;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -1160,7 +1540,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JSLT | BPF_K: /* JMP_IMM */
 	case BPF_JMP | BPF_JSLE | BPF_K: /* JMP_IMM */
 		cmp_eq = (bpf_op == BPF_JSGE);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 
@@ -1235,7 +1615,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP | BPF_JLT | BPF_K:
 	case BPF_JMP | BPF_JLE | BPF_K:
 		cmp_eq = (bpf_op == BPF_JGE);
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 		/*
@@ -1258,7 +1638,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		goto jeq_common;
 
 	case BPF_JMP | BPF_JSET | BPF_K: /* JMP_IMM */
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg_fp_ok);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
 		if (dst < 0)
 			return dst;
 
@@ -1303,7 +1683,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		emit_instr(ctx, nop);
 		break;
 	case BPF_LD | BPF_DW | BPF_IMM:
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		t64 = ((u64)(u32)insn->imm) | ((u64)(insn + 1)->imm << 32);
@@ -1311,12 +1691,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		return 2; /* Double slot insn */
 
 	case BPF_JMP | BPF_CALL:
-		ctx->flags |= EBPF_SAVE_RA;
-		t64s = (s64)insn->imm + (long)__bpf_call_base;
-		emit_const_to_reg(ctx, MIPS_R_T9, (u64)t64s);
-		emit_instr(ctx, jalr, MIPS_R_RA, MIPS_R_T9);
-		/* delay slot */
-		emit_instr(ctx, nop);
+		emit_bpf_call(ctx, insn);
 		break;
 
 	case BPF_JMP | BPF_TAIL_CALL:
@@ -1326,7 +1701,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 
 	case BPF_ALU | BPF_END | BPF_FROM_BE:
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
 		if (dst < 0)
 			return dst;
 		td = get_reg_val_type(ctx, this_idx, insn->dst_reg);
@@ -1367,16 +1742,10 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_ST | BPF_H | BPF_MEM:
 	case BPF_ST | BPF_W | BPF_MEM:
 	case BPF_ST | BPF_DW | BPF_MEM:
-		if (insn->dst_reg == BPF_REG_10) {
-			ctx->flags |= EBPF_SEEN_FP;
-			dst = MIPS_R_SP;
-			mem_off = insn->off + MAX_BPF_STACK;
-		} else {
-			dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
-			if (dst < 0)
-				return dst;
-			mem_off = insn->off;
-		}
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		if (dst < 0)
+			return dst;
+		mem_off = insn->off;
 		gen_imm_to_reg(insn, MIPS_R_AT, ctx);
 		switch (BPF_SIZE(insn->code)) {
 		case BPF_B:
@@ -1398,19 +1767,11 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_LDX | BPF_H | BPF_MEM:
 	case BPF_LDX | BPF_W | BPF_MEM:
 	case BPF_LDX | BPF_DW | BPF_MEM:
-		if (insn->src_reg == BPF_REG_10) {
-			ctx->flags |= EBPF_SEEN_FP;
-			src = MIPS_R_SP;
-			mem_off = insn->off + MAX_BPF_STACK;
-		} else {
-			src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
-			if (src < 0)
-				return src;
-			mem_off = insn->off;
-		}
-		dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
-		if (dst < 0)
-			return dst;
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (dst < 0 || src < 0)
+			return -EINVAL;
+		mem_off = insn->off;
 		switch (BPF_SIZE(insn->code)) {
 		case BPF_B:
 			emit_instr(ctx, lbu, dst, mem_off, src);
@@ -1433,25 +1794,16 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_STX | BPF_DW | BPF_MEM:
 	case BPF_STX | BPF_W | BPF_ATOMIC:
 	case BPF_STX | BPF_DW | BPF_ATOMIC:
-		if (insn->dst_reg == BPF_REG_10) {
-			ctx->flags |= EBPF_SEEN_FP;
-			dst = MIPS_R_SP;
-			mem_off = insn->off + MAX_BPF_STACK;
-		} else {
-			dst = ebpf_to_mips_reg(ctx, insn, dst_reg);
-			if (dst < 0)
-				return dst;
-			mem_off = insn->off;
-		}
-		src = ebpf_to_mips_reg(ctx, insn, src_reg_no_fp);
-		if (src < 0)
-			return src;
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		mem_off = insn->off;
 		if (BPF_MODE(insn->code) == BPF_ATOMIC) {
 			if (insn->imm != BPF_ADD) {
 				pr_err("ATOMIC OP %02x NOT HANDLED\n", insn->imm);
 				return -EINVAL;
 			}
-
 			/*
 			 * If mem_off does not fit within the 9 bit ll/sc
 			 * instruction immediate field, use a temp reg.
@@ -1530,7 +1882,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 
 static int build_int_body(struct jit_ctx *ctx)
 {
-	const struct bpf_prog *prog = ctx->skf;
+	const struct bpf_prog *prog = ctx->prog;
 	const struct bpf_insn *insn;
 	int i, r;
 
@@ -1572,7 +1924,7 @@ static int build_int_body(struct jit_ctx *ctx)
 static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
 				   int start_idx, bool follow_taken)
 {
-	const struct bpf_prog *prog = ctx->skf;
+	const struct bpf_prog *prog = ctx->prog;
 	const struct bpf_insn *insn;
 	u64 exit_rvt = initial_rvt;
 	u64 *rvt = ctx->reg_val_types;
@@ -1773,7 +2125,7 @@ static int reg_val_propagate_range(struct jit_ctx *ctx, u64 initial_rvt,
  */
 static int reg_val_propagate(struct jit_ctx *ctx)
 {
-	const struct bpf_prog *prog = ctx->skf;
+	const struct bpf_prog *prog = ctx->prog;
 	u64 exit_rvt;
 	int reg;
 	int i;
@@ -1832,23 +2184,86 @@ static void jit_fill_hole(void *area, unsigned int size)
 		uasm_i_break(&p, BRK_BUG); /* Increments p */
 }
 
+/*
+ * Save and restore the BPF VM state across a direct kernel call. This
+ * includes the caller-saved registers used for BPF_REG_0 .. BPF_REG_5
+ * and BPF_REG_AX used by the verifier for blinding and other dark arts.
+ * Restore avoids clobbering bpf_ret, which holds the call return value.
+ * BPF_REG_6 .. BPF_REG_10 and TCC are already callee-saved or on stack.
+ */
+static const int bpf_caller_save[] = {
+	BPF_REG_0,
+	BPF_REG_1,
+	BPF_REG_2,
+	BPF_REG_3,
+	BPF_REG_4,
+	BPF_REG_5,
+	BPF_REG_AX,
+};
+
+#define CALLER_ENV_SIZE (ARRAY_SIZE(bpf_caller_save) * sizeof(u64))
+
+void emit_caller_save(struct jit_ctx *ctx)
+{
+	int stack_adj = ALIGN(CALLER_ENV_SIZE, STACK_ALIGN);
+	int i, bpf, reg, store_offset;
+
+	emit_instr_long(ctx, daddiu, addiu, MIPS_R_SP, MIPS_R_SP, -stack_adj);
+
+	for (i = 0; i < ARRAY_SIZE(bpf_caller_save); i++) {
+		bpf = bpf_caller_save[i];
+		reg = bpf2mips[bpf].reg;
+		store_offset = i * sizeof(u64);
+
+		if (is64bit()) {
+			emit_instr(ctx, sd, reg, store_offset, MIPS_R_SP);
+		} else {
+			emit_instr(ctx, sw, LO(reg),
+						OFFLO(store_offset), MIPS_R_SP);
+			emit_instr(ctx, sw, HI(reg),
+						OFFHI(store_offset), MIPS_R_SP);
+		}
+	}
+}
+
+void emit_caller_restore(struct jit_ctx *ctx, int bpf_ret)
+{
+	int stack_adj = ALIGN(CALLER_ENV_SIZE, STACK_ALIGN);
+	int i, bpf, reg, store_offset;
+
+	for (i = 0; i < ARRAY_SIZE(bpf_caller_save); i++) {
+		bpf = bpf_caller_save[i];
+		reg = bpf2mips[bpf].reg;
+		store_offset = i * sizeof(u64);
+		if (bpf == bpf_ret)
+			continue;
+
+		if (is64bit()) {
+			emit_instr(ctx, ld, reg, store_offset, MIPS_R_SP);
+		} else {
+			emit_instr(ctx, lw, LO(reg),
+						OFFLO(store_offset), MIPS_R_SP);
+			emit_instr(ctx, lw, HI(reg),
+						OFFHI(store_offset), MIPS_R_SP);
+		}
+	}
+
+	emit_instr_long(ctx, daddiu, addiu, MIPS_R_SP, MIPS_R_SP, stack_adj);
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
-	struct bpf_prog *orig_prog = prog;
-	bool tmp_blinded = false;
-	struct bpf_prog *tmp;
+	bool tmp_blinded = false, extra_pass = false;
+	struct bpf_prog *tmp, *orig_prog = prog;
 	struct bpf_binary_header *header = NULL;
-	struct jit_ctx ctx;
-	unsigned int image_size;
-	u8 *image_ptr;
+	unsigned int image_size, pass = 3;
+	struct jit_ctx *ctx;
 
 	if (!prog->jit_requested)
-		return prog;
+		return orig_prog;
 
+	/* Attempt blinding but fall back to the interpreter on failure. */
 	tmp = bpf_jit_blind_constants(prog);
-	/* If blinding was requested and we failed during blinding,
-	 * we must fall back to the interpreter.
-	 */
 	if (IS_ERR(tmp))
 		return orig_prog;
 	if (tmp != prog) {
@@ -1856,50 +2271,75 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		prog = tmp;
 	}
 
-	memset(&ctx, 0, sizeof(ctx));
+	ctx = prog->aux->jit_data;
+	if (!ctx) {
+		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+		if (!ctx) {
+			prog = orig_prog;
+			goto out;
+		}
+	}
 
-	preempt_disable();
-	switch (current_cpu_type()) {
-	case CPU_CAVIUM_OCTEON:
-	case CPU_CAVIUM_OCTEON_PLUS:
-	case CPU_CAVIUM_OCTEON2:
-	case CPU_CAVIUM_OCTEON3:
-		ctx.use_bbit_insns = 1;
-		break;
-	default:
-		ctx.use_bbit_insns = 0;
+	/*
+	 * Assume extra pass needed for patching addresses if previous
+	 * ctx exists in saved jit_data, so skip to code generation.
+	 */
+	if (ctx->offsets) {
+		extra_pass = true;
+		pass++;
+		image_size = 4 * ctx->idx;
+		header = bpf_jit_binary_hdr(ctx->prog);
+		goto skip_init_ctx;
 	}
-	preempt_enable();
 
-	ctx.offsets = kcalloc(prog->len + 1, sizeof(*ctx.offsets), GFP_KERNEL);
-	if (ctx.offsets == NULL)
+	ctx->prog = prog;
+	ctx->offsets = kcalloc(prog->len + 1,
+			       sizeof(*ctx->offsets),
+			       GFP_KERNEL);
+	if (!ctx->offsets)
 		goto out_err;
 
-	ctx.reg_val_types = kcalloc(prog->len + 1, sizeof(*ctx.reg_val_types), GFP_KERNEL);
-	if (ctx.reg_val_types == NULL)
-		goto out_err;
+	/* Check Octeon bbit ops only for MIPS64. */
+	if (is64bit()) {
+		preempt_disable();
+		switch (current_cpu_type()) {
+		case CPU_CAVIUM_OCTEON:
+		case CPU_CAVIUM_OCTEON_PLUS:
+		case CPU_CAVIUM_OCTEON2:
+		case CPU_CAVIUM_OCTEON3:
+			ctx->use_bbit_insns = 1;
+			break;
+		default:
+			ctx->use_bbit_insns = 0;
+		}
+		preempt_enable();
+	}
 
-	ctx.skf = prog;
+	ctx->reg_val_types = kcalloc(prog->len + 1,
+				     sizeof(*ctx->reg_val_types),
+				     GFP_KERNEL);
+	if (!ctx->reg_val_types)
+		goto out_err;
 
-	if (reg_val_propagate(&ctx))
+	if (reg_val_propagate(ctx))
 		goto out_err;
 
 	/*
 	 * First pass discovers used resources and instruction offsets
 	 * assuming short branches are used.
 	 */
-	if (build_int_body(&ctx))
+	if (build_int_body(ctx))
 		goto out_err;
 
 	/*
-	 * If no calls are made (EBPF_SAVE_RA), then tail call count
-	 * in $v1, else we must save in n$s4.
+	 * If no calls are made (EBPF_SAVE_RA), then tailcall count located
+	 * in runtime reg if defined, else we backup to save reg or stack.
 	 */
-	if (ctx.flags & EBPF_SEEN_TC) {
-		if (ctx.flags & EBPF_SAVE_RA)
-			ctx.flags |= EBPF_SAVE_S4;
-		else
-			ctx.flags |= EBPF_TCC_IN_V1;
+	if (tail_call_present(ctx)) {
+		if (ctx->flags & EBPF_SAVE_RA)
+			ctx->flags |= bpf2mips[JIT_SAV_TCC].flags;
+		else if (bpf2mips[JIT_RUN_TCC].reg)
+			ctx->flags |= EBPF_TCC_IN_RUN;
 	}
 
 	/*
@@ -1910,59 +2350,69 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	 * necessary.
 	 */
 	do {
-		ctx.idx = 0;
-		ctx.gen_b_offsets = 1;
-		ctx.long_b_conversion = 0;
-		if (gen_int_prologue(&ctx))
+		ctx->idx = 0;
+		ctx->gen_b_offsets = 1;
+		ctx->long_b_conversion = 0;
+		if (build_int_prologue(ctx))
 			goto out_err;
-		if (build_int_body(&ctx))
+		if (build_int_body(ctx))
 			goto out_err;
-		if (build_int_epilogue(&ctx, MIPS_R_RA))
+		if (build_int_epilogue(ctx, MIPS_R_RA))
 			goto out_err;
-	} while (ctx.long_b_conversion);
+	} while (ctx->long_b_conversion);
 
-	image_size = 4 * ctx.idx;
+	image_size = 4 * ctx->idx;
 
-	header = bpf_jit_binary_alloc(image_size, &image_ptr,
+	header = bpf_jit_binary_alloc(image_size, (void *)&ctx->target,
 				      sizeof(u32), jit_fill_hole);
-	if (header == NULL)
+	if (!header)
 		goto out_err;
 
-	ctx.target = (u32 *)image_ptr;
+skip_init_ctx:
 
-	/* Third pass generates the code */
-	ctx.idx = 0;
-	if (gen_int_prologue(&ctx))
+	/* Third pass generates the code (fourth patches call addresses) */
+	ctx->idx = 0;
+	if (build_int_prologue(ctx))
 		goto out_err;
-	if (build_int_body(&ctx))
+	if (build_int_body(ctx))
 		goto out_err;
-	if (build_int_epilogue(&ctx, MIPS_R_RA))
+	if (build_int_epilogue(ctx, MIPS_R_RA))
 		goto out_err;
 
-	/* Update the icache */
-	flush_icache_range((unsigned long)ctx.target,
-			   (unsigned long)&ctx.target[ctx.idx]);
-
 	if (bpf_jit_enable > 1)
 		/* Dump JIT code */
-		bpf_jit_dump(prog->len, image_size, 2, ctx.target);
+		bpf_jit_dump(prog->len, image_size, pass, ctx->target);
+
+	/* Update the icache */
+	flush_icache_range((unsigned long)ctx->target,
+			   (unsigned long)&ctx->target[ctx->idx]);
+
+	if (!prog->is_func || extra_pass)
+		bpf_jit_binary_lock_ro(header);
+	else
+		prog->aux->jit_data = ctx;
 
-	bpf_jit_binary_lock_ro(header);
-	prog->bpf_func = (void *)ctx.target;
+	prog->bpf_func = (void *)ctx->target;
 	prog->jited = 1;
 	prog->jited_len = image_size;
-out_normal:
+
+	if (!prog->is_func || extra_pass) {
+		bpf_prog_fill_jited_linfo(prog, ctx->offsets + 1);
+out_ctx:
+		kfree(ctx->offsets);
+		kfree(ctx->reg_val_types);
+		kfree(ctx);
+		prog->aux->jit_data = NULL;
+	}
+out:
 	if (tmp_blinded)
 		bpf_jit_prog_release_other(prog, prog == orig_prog ?
 					   tmp : orig_prog);
-	kfree(ctx.offsets);
-	kfree(ctx.reg_val_types);
-
 	return prog;
 
 out_err:
 	prog = orig_prog;
 	if (header)
 		bpf_jit_binary_free(header);
-	goto out_normal;
+	goto out_ctx;
 }
-- 
2.25.1

