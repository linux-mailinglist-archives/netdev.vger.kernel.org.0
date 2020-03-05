Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF2B179EE2
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgCEFCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:02:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46610 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgCEFCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:02:22 -0500
Received: by mail-pf1-f196.google.com with SMTP id o24so2134775pfp.13
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NV6AEbjaEc8/8IxaZ62CnVxM/2PY2Fk+J8+O53OGrHo=;
        b=Z7Na1A7/J2rmtSrjfm1Pnn1+QgyH7j0byzrFHmqCPAl3EW0uR+YTrABKQv6ENPWDPP
         orDAlfo6BEaSBTg2GuxhH4oU7WQ6o7SCF3PoWH+D20ickxMZ+HiJurAluMVbbhMtGQN1
         N57ao9BCgDLuadL6RK8iHN84HQE8T6C9IrSJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NV6AEbjaEc8/8IxaZ62CnVxM/2PY2Fk+J8+O53OGrHo=;
        b=EGc3NnPG+p4PmjPC1BqnwPZ97e/xNSyjk5SEGZHwqJFz/RMc/atyLwgu0FZU9/FiQt
         tT89vyXT/LH/0VJ6Yd4MU8ySPTVvx2FTtjbO4Hz5JhVHS24+Evodb+PyBvy59na0i/4B
         /XrIegWnFZwGC+0l8bjWGInZ7AnEeY0ZxE/DgJKAH1RvgE5QHFLeDqFSJNX5z0z+5duL
         7PS6++IlrB4pC34SJE5yc0w7Ane4F9guJo+osjDaUoGwJ4D5CU6zEqEp4wdpM69PSiI2
         P2EbHS5QBQMHpDRBQ3XWl93Ag2i9UrTQI+I/OUxoKUFpwTSBK5hkh7tqqkVeY4B30KSa
         aiaQ==
X-Gm-Message-State: ANhLgQ1+73p3G4rhXOCDjizjSqLIqN3/lOT4lcvYOYAEC2lufHUeYr8j
        uMfPvAeFqBM+x/Ok5iyAx5HHWhmu6mEy8Q==
X-Google-Smtp-Source: ADFU+vskwIjVEaOdYxodQPRM/kZw7WAAgHCv+iVAmebCKkcBp2PP5DfZDd7IBll9iaCRz6zkD3rxiw==
X-Received: by 2002:a62:7696:: with SMTP id r144mr6498580pfc.177.1583384539643;
        Wed, 04 Mar 2020 21:02:19 -0800 (PST)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:e9fe:faad:3d84:58ea])
        by smtp.gmail.com with ESMTPSA id y7sm17820466pfq.15.2020.03.04.21.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 21:02:19 -0800 (PST)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v5 2/4] riscv, bpf: add RV32G eBPF JIT
Date:   Wed,  4 Mar 2020 21:02:05 -0800
Message-Id: <20200305050207.4159-3-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305050207.4159-1-luke.r.nels@gmail.com>
References: <20200305050207.4159-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an eBPF JIT for RV32G, adapted from the JIT for RV64G and
the 32-bit ARM JIT.

There are two main changes required for this to work compared to
the RV64 JIT.

First, eBPF registers are 64-bit, while RV32G registers are 32-bit.
BPF registers either map directly to 2 RISC-V registers, or reside
in stack scratch space and are saved and restored when used.

Second, many 64-bit ALU operations do not trivially map to 32-bit
operations. Operations that move bits between high and low words,
such as ADD, LSH, MUL, and others must emulate the 64-bit behavior
in terms of 32-bit instructions.

This patch also makes related changes to bpf_jit.h, such
as adding RISC-V instructions required by the RV32 JIT.

Supported features:

The RV32 JIT supports the same features and instructions as the
RV64 JIT, with the following exceptions:

- ALU64 DIV/MOD: Requires loops to implement on 32-bit hardware.

- BPF_XADD | BPF_DW: There's no 8-byte atomic instruction in RV32.

These features are also unsupported on other BPF JITs for 32-bit
architectures.

Testing:

- lib/test_bpf.c
test_bpf: Summary: 378 PASSED, 0 FAILED, [349/366 JIT'ed]
test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

The tests that are not JITed are all due to use of 64-bit div/mod
or 64-bit xadd.

- tools/testing/selftests/bpf/test_verifier.c
Summary: 1415 PASSED, 122 SKIPPED, 43 FAILED

Tested both with and without BPF JIT hardening.

This is the same set of tests that pass using the BPF interpreter
with the JIT disabled.

Verification and synthesis:

We developed the RV32 JIT using our automated verification tool,
Serval. We have used Serval in the past to verify patches to the
RV64 JIT. We also used Serval to superoptimize the resulting code
through program synthesis.

You can find the tool and a guide to the approach and results here:
https://github.com/uw-unsat/serval-bpf/tree/rv32-jit-v5

Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/Kconfig              |    2 +-
 arch/riscv/net/Makefile         |    8 +-
 arch/riscv/net/bpf_jit.h        |   48 ++
 arch/riscv/net/bpf_jit_comp32.c | 1310 +++++++++++++++++++++++++++++++
 4 files changed, 1366 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/net/bpf_jit_comp32.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 73f029eae0cc..e9791717e006 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -56,7 +56,7 @@ config RISCV
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MMIOWB
 	select ARCH_HAS_DEBUG_VIRTUAL
-	select HAVE_EBPF_JIT if 64BIT
+	select HAVE_EBPF_JIT
 	select EDAC_SUPPORT
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
diff --git a/arch/riscv/net/Makefile b/arch/riscv/net/Makefile
index 018074dbf986..9a1e5f0a94e5 100644
--- a/arch/riscv/net/Makefile
+++ b/arch/riscv/net/Makefile
@@ -1,3 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_BPF_JIT) += bpf_jit_core.o bpf_jit_comp64.o
+obj-$(CONFIG_BPF_JIT) += bpf_jit_core.o
+
+ifeq ($(CONFIG_ARCH_RV64I),y)
+	obj-$(CONFIG_BPF_JIT) += bpf_jit_comp64.o
+else
+	obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
+endif
diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index 23c123331f94..20e235d06f66 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -207,6 +207,8 @@ static inline u32 rv_amo_insn(u8 funct5, u8 aq, u8 rl, u8 rs2, u8 rs1,
 	return rv_r_insn(funct7, rs2, rs1, funct3, rd, opcode);
 }
 
+/* Instructions shared by both RV32 and RV64. */
+
 static inline u32 rv_addi(u8 rd, u8 rs1, u16 imm11_0)
 {
 	return rv_i_insn(imm11_0, rs1, 0, rd, 0x13);
@@ -262,6 +264,11 @@ static inline u32 rv_sub(u8 rd, u8 rs1, u8 rs2)
 	return rv_r_insn(0x20, rs2, rs1, 0, rd, 0x33);
 }
 
+static inline u32 rv_sltu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(0, rs2, rs1, 3, rd, 0x33);
+}
+
 static inline u32 rv_and(u8 rd, u8 rs1, u8 rs2)
 {
 	return rv_r_insn(0, rs2, rs1, 7, rd, 0x33);
@@ -297,6 +304,11 @@ static inline u32 rv_mul(u8 rd, u8 rs1, u8 rs2)
 	return rv_r_insn(1, rs2, rs1, 0, rd, 0x33);
 }
 
+static inline u32 rv_mulhu(u8 rd, u8 rs1, u8 rs2)
+{
+	return rv_r_insn(1, rs2, rs1, 3, rd, 0x33);
+}
+
 static inline u32 rv_divu(u8 rd, u8 rs1, u8 rs2)
 {
 	return rv_r_insn(1, rs2, rs1, 5, rd, 0x33);
@@ -332,21 +344,46 @@ static inline u32 rv_bltu(u8 rs1, u8 rs2, u16 imm12_1)
 	return rv_b_insn(imm12_1, rs2, rs1, 6, 0x63);
 }
 
+static inline u32 rv_bgtu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_bltu(rs2, rs1, imm12_1);
+}
+
 static inline u32 rv_bgeu(u8 rs1, u8 rs2, u16 imm12_1)
 {
 	return rv_b_insn(imm12_1, rs2, rs1, 7, 0x63);
 }
 
+static inline u32 rv_bleu(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_bgeu(rs2, rs1, imm12_1);
+}
+
 static inline u32 rv_blt(u8 rs1, u8 rs2, u16 imm12_1)
 {
 	return rv_b_insn(imm12_1, rs2, rs1, 4, 0x63);
 }
 
+static inline u32 rv_bgt(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_blt(rs2, rs1, imm12_1);
+}
+
 static inline u32 rv_bge(u8 rs1, u8 rs2, u16 imm12_1)
 {
 	return rv_b_insn(imm12_1, rs2, rs1, 5, 0x63);
 }
 
+static inline u32 rv_ble(u8 rs1, u8 rs2, u16 imm12_1)
+{
+	return rv_bge(rs2, rs1, imm12_1);
+}
+
+static inline u32 rv_lw(u8 rd, u16 imm11_0, u8 rs1)
+{
+	return rv_i_insn(imm11_0, rs1, 2, rd, 0x03);
+}
+
 static inline u32 rv_lbu(u8 rd, u16 imm11_0, u8 rs1)
 {
 	return rv_i_insn(imm11_0, rs1, 4, rd, 0x03);
@@ -377,6 +414,15 @@ static inline u32 rv_amoadd_w(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
 	return rv_amo_insn(0, aq, rl, rs2, rs1, 2, rd, 0x2f);
 }
 
+/*
+ * RV64-only instructions.
+ *
+ * These instructions are not available on RV32.  Wrap them below a #if to
+ * ensure that the RV32 JIT doesn't emit any of these instructions.
+ */
+
+#if __riscv_xlen == 64
+
 static inline u32 rv_addiw(u8 rd, u8 rs1, u16 imm11_0)
 {
 	return rv_i_insn(imm11_0, rs1, 0, rd, 0x1b);
@@ -457,6 +503,8 @@ static inline u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
 	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
 }
 
+#endif /* __riscv_xlen == 64 */
+
 void bpf_jit_build_prologue(struct rv_jit_context *ctx);
 void bpf_jit_build_epilogue(struct rv_jit_context *ctx);
 
diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
new file mode 100644
index 000000000000..302934177760
--- /dev/null
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -0,0 +1,1310 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * BPF JIT compiler for RV32G
+ *
+ * Copyright (c) 2020 Luke Nelson <luke.r.nels@gmail.com>
+ * Copyright (c) 2020 Xi Wang <xi.wang@gmail.com>
+ *
+ * The code is based on the BPF JIT compiler for RV64G by Björn Töpel and
+ * the BPF JIT compiler for 32-bit ARM by Shubham Bansal and Mircea Gherzan.
+ */
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include "bpf_jit.h"
+
+enum {
+	/* Stack layout - these are offsets from (top of stack - 4). */
+	BPF_R6_HI,
+	BPF_R6_LO,
+	BPF_R7_HI,
+	BPF_R7_LO,
+	BPF_R8_HI,
+	BPF_R8_LO,
+	BPF_R9_HI,
+	BPF_R9_LO,
+	BPF_AX_HI,
+	BPF_AX_LO,
+	/* Stack space for BPF_REG_6 through BPF_REG_9 and BPF_REG_AX. */
+	BPF_JIT_SCRATCH_REGS,
+};
+
+#define STACK_OFFSET(k) (-4 - ((k) * 4))
+
+#define TMP_REG_1	(MAX_BPF_JIT_REG + 0)
+#define TMP_REG_2	(MAX_BPF_JIT_REG + 1)
+
+#define RV_REG_TCC		RV_REG_T6
+#define RV_REG_TCC_SAVED	RV_REG_S7
+
+static const s8 bpf2rv32[][2] = {
+	/* Return value from in-kernel function, and exit value from eBPF. */
+	[BPF_REG_0] = {RV_REG_S2, RV_REG_S1},
+	/* Arguments from eBPF program to in-kernel function. */
+	[BPF_REG_1] = {RV_REG_A1, RV_REG_A0},
+	[BPF_REG_2] = {RV_REG_A3, RV_REG_A2},
+	[BPF_REG_3] = {RV_REG_A5, RV_REG_A4},
+	[BPF_REG_4] = {RV_REG_A7, RV_REG_A6},
+	[BPF_REG_5] = {RV_REG_S4, RV_REG_S3},
+	/*
+	 * Callee-saved registers that in-kernel function will preserve.
+	 * Stored on the stack.
+	 */
+	[BPF_REG_6] = {STACK_OFFSET(BPF_R6_HI), STACK_OFFSET(BPF_R6_LO)},
+	[BPF_REG_7] = {STACK_OFFSET(BPF_R7_HI), STACK_OFFSET(BPF_R7_LO)},
+	[BPF_REG_8] = {STACK_OFFSET(BPF_R8_HI), STACK_OFFSET(BPF_R8_LO)},
+	[BPF_REG_9] = {STACK_OFFSET(BPF_R9_HI), STACK_OFFSET(BPF_R9_LO)},
+	/* Read-only frame pointer to access BPF stack. */
+	[BPF_REG_FP] = {RV_REG_S6, RV_REG_S5},
+	/* Temporary register for blinding constants. Stored on the stack. */
+	[BPF_REG_AX] = {STACK_OFFSET(BPF_AX_HI), STACK_OFFSET(BPF_AX_LO)},
+	/*
+	 * Temporary registers used by the JIT to operate on registers stored
+	 * on the stack. Save t0 and t1 to be used as temporaries in generated
+	 * code.
+	 */
+	[TMP_REG_1] = {RV_REG_T3, RV_REG_T2},
+	[TMP_REG_2] = {RV_REG_T5, RV_REG_T4},
+};
+
+static s8 hi(const s8 *r)
+{
+	return r[0];
+}
+
+static s8 lo(const s8 *r)
+{
+	return r[1];
+}
+
+static void emit_imm(const s8 rd, s32 imm, struct rv_jit_context *ctx)
+{
+	u32 upper = (imm + (1 << 11)) >> 12;
+	u32 lower = imm & 0xfff;
+
+	if (upper) {
+		emit(rv_lui(rd, upper), ctx);
+		emit(rv_addi(rd, rd, lower), ctx);
+	} else {
+		emit(rv_addi(rd, RV_REG_ZERO, lower), ctx);
+	}
+}
+
+static void emit_imm32(const s8 *rd, s32 imm, struct rv_jit_context *ctx)
+{
+	/* Emit immediate into lower bits. */
+	emit_imm(lo(rd), imm, ctx);
+
+	/* Sign-extend into upper bits. */
+	if (imm >= 0)
+		emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+	else
+		emit(rv_addi(hi(rd), RV_REG_ZERO, -1), ctx);
+}
+
+static void emit_imm64(const s8 *rd, s32 imm_hi, s32 imm_lo,
+		       struct rv_jit_context *ctx)
+{
+	emit_imm(lo(rd), imm_lo, ctx);
+	emit_imm(hi(rd), imm_hi, ctx);
+}
+
+static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
+{
+	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 4;
+	const s8 *r0 = bpf2rv32[BPF_REG_0];
+
+	store_offset -= 4 * BPF_JIT_SCRATCH_REGS;
+
+	/* Set return value if not tail call. */
+	if (!is_tail_call) {
+		emit(rv_addi(RV_REG_A0, lo(r0), 0), ctx);
+		emit(rv_addi(RV_REG_A1, hi(r0), 0), ctx);
+	}
+
+	/* Restore callee-saved registers. */
+	emit(rv_lw(RV_REG_RA, store_offset - 0, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_FP, store_offset - 4, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S1, store_offset - 8, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S2, store_offset - 12, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S3, store_offset - 16, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S4, store_offset - 20, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S5, store_offset - 24, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S6, store_offset - 28, RV_REG_SP), ctx);
+	emit(rv_lw(RV_REG_S7, store_offset - 32, RV_REG_SP), ctx);
+
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
+
+	if (is_tail_call) {
+		/*
+		 * goto *(t0 + 4);
+		 * Skips first instruction of prologue which initializes tail
+		 * call counter. Assumes t0 contains address of target program,
+		 * see emit_bpf_tail_call.
+		 */
+		emit(rv_jalr(RV_REG_ZERO, RV_REG_T0, 4), ctx);
+	} else {
+		emit(rv_jalr(RV_REG_ZERO, RV_REG_RA, 0), ctx);
+	}
+}
+
+static bool is_stacked(s8 reg)
+{
+	return reg < 0;
+}
+
+static const s8 *bpf_get_reg64(const s8 *reg, const s8 *tmp,
+			       struct rv_jit_context *ctx)
+{
+	if (is_stacked(hi(reg))) {
+		emit(rv_lw(hi(tmp), hi(reg), RV_REG_FP), ctx);
+		emit(rv_lw(lo(tmp), lo(reg), RV_REG_FP), ctx);
+		reg = tmp;
+	}
+	return reg;
+}
+
+static void bpf_put_reg64(const s8 *reg, const s8 *src,
+			  struct rv_jit_context *ctx)
+{
+	if (is_stacked(hi(reg))) {
+		emit(rv_sw(RV_REG_FP, hi(reg), hi(src)), ctx);
+		emit(rv_sw(RV_REG_FP, lo(reg), lo(src)), ctx);
+	}
+}
+
+static const s8 *bpf_get_reg32(const s8 *reg, const s8 *tmp,
+			       struct rv_jit_context *ctx)
+{
+	if (is_stacked(lo(reg))) {
+		emit(rv_lw(lo(tmp), lo(reg), RV_REG_FP), ctx);
+		reg = tmp;
+	}
+	return reg;
+}
+
+static void bpf_put_reg32(const s8 *reg, const s8 *src,
+			  struct rv_jit_context *ctx)
+{
+	if (is_stacked(lo(reg))) {
+		emit(rv_sw(RV_REG_FP, lo(reg), lo(src)), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_sw(RV_REG_FP, hi(reg), RV_REG_ZERO), ctx);
+	} else if (!ctx->prog->aux->verifier_zext) {
+		emit(rv_addi(hi(reg), RV_REG_ZERO, 0), ctx);
+	}
+}
+
+static void emit_jump_and_link(u8 rd, s32 rvoff, bool force_jalr,
+			       struct rv_jit_context *ctx)
+{
+	s32 upper, lower;
+
+	if (rvoff && is_21b_int(rvoff) && !force_jalr) {
+		emit(rv_jal(rd, rvoff >> 1), ctx);
+		return;
+	}
+
+	upper = (rvoff + (1 << 11)) >> 12;
+	lower = rvoff & 0xfff;
+	emit(rv_auipc(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
+}
+
+static void emit_alu_i64(const s8 *dst, s32 imm,
+			 struct rv_jit_context *ctx, const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit_imm32(rd, imm, ctx);
+		break;
+	case BPF_AND:
+		if (is_12b_int(imm)) {
+			emit(rv_andi(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_and(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		if (imm >= 0)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_OR:
+		if (is_12b_int(imm)) {
+			emit(rv_ori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_or(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		if (imm < 0)
+			emit(rv_ori(hi(rd), RV_REG_ZERO, -1), ctx);
+		break;
+	case BPF_XOR:
+		if (is_12b_int(imm)) {
+			emit(rv_xori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_xor(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		if (imm < 0)
+			emit(rv_xori(hi(rd), hi(rd), -1), ctx);
+		break;
+	case BPF_LSH:
+		if (imm >= 32) {
+			emit(rv_slli(hi(rd), lo(rd), imm - 32), ctx);
+			emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
+		} else if (imm == 0) {
+			/* Do nothing. */
+		} else {
+			emit(rv_srli(RV_REG_T0, lo(rd), 32 - imm), ctx);
+			emit(rv_slli(hi(rd), hi(rd), imm), ctx);
+			emit(rv_or(hi(rd), RV_REG_T0, hi(rd)), ctx);
+			emit(rv_slli(lo(rd), lo(rd), imm), ctx);
+		}
+		break;
+	case BPF_RSH:
+		if (imm >= 32) {
+			emit(rv_srli(lo(rd), hi(rd), imm - 32), ctx);
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		} else if (imm == 0) {
+			/* Do nothing. */
+		} else {
+			emit(rv_slli(RV_REG_T0, hi(rd), 32 - imm), ctx);
+			emit(rv_srli(lo(rd), lo(rd), imm), ctx);
+			emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+			emit(rv_srli(hi(rd), hi(rd), imm), ctx);
+		}
+		break;
+	case BPF_ARSH:
+		if (imm >= 32) {
+			emit(rv_srai(lo(rd), hi(rd), imm - 32), ctx);
+			emit(rv_srai(hi(rd), hi(rd), 31), ctx);
+		} else if (imm == 0) {
+			/* Do nothing. */
+		} else {
+			emit(rv_slli(RV_REG_T0, hi(rd), 32 - imm), ctx);
+			emit(rv_srli(lo(rd), lo(rd), imm), ctx);
+			emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+			emit(rv_srai(hi(rd), hi(rd), imm), ctx);
+		}
+		break;
+	}
+
+	bpf_put_reg64(dst, rd, ctx);
+}
+
+static void emit_alu_i32(const s8 *dst, s32 imm,
+			 struct rv_jit_context *ctx, const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *rd = bpf_get_reg32(dst, tmp1, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit_imm(lo(rd), imm, ctx);
+		break;
+	case BPF_ADD:
+		if (is_12b_int(imm)) {
+			emit(rv_addi(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_add(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_SUB:
+		if (is_12b_int(-imm)) {
+			emit(rv_addi(lo(rd), lo(rd), -imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_sub(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_AND:
+		if (is_12b_int(imm)) {
+			emit(rv_andi(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_and(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_OR:
+		if (is_12b_int(imm)) {
+			emit(rv_ori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_or(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_XOR:
+		if (is_12b_int(imm)) {
+			emit(rv_xori(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_xor(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_LSH:
+		if (is_12b_int(imm)) {
+			emit(rv_slli(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_sll(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_RSH:
+		if (is_12b_int(imm)) {
+			emit(rv_srli(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_srl(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_ARSH:
+		if (is_12b_int(imm)) {
+			emit(rv_srai(lo(rd), lo(rd), imm), ctx);
+		} else {
+			emit_imm(RV_REG_T0, imm, ctx);
+			emit(rv_sra(lo(rd), lo(rd), RV_REG_T0), ctx);
+		}
+		break;
+	}
+
+	bpf_put_reg32(dst, rd, ctx);
+}
+
+static void emit_alu_r64(const s8 *dst, const s8 *src,
+			 struct rv_jit_context *ctx, const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+	const s8 *rs = bpf_get_reg64(src, tmp2, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit(rv_addi(lo(rd), lo(rs), 0), ctx);
+		emit(rv_addi(hi(rd), hi(rs), 0), ctx);
+		break;
+	case BPF_ADD:
+		if (rd == rs) {
+			emit(rv_srli(RV_REG_T0, lo(rd), 31), ctx);
+			emit(rv_slli(hi(rd), hi(rd), 1), ctx);
+			emit(rv_or(hi(rd), RV_REG_T0, hi(rd)), ctx);
+			emit(rv_slli(lo(rd), lo(rd), 1), ctx);
+		} else {
+			emit(rv_add(lo(rd), lo(rd), lo(rs)), ctx);
+			emit(rv_sltu(RV_REG_T0, lo(rd), lo(rs)), ctx);
+			emit(rv_add(hi(rd), hi(rd), hi(rs)), ctx);
+			emit(rv_add(hi(rd), hi(rd), RV_REG_T0), ctx);
+		}
+		break;
+	case BPF_SUB:
+		emit(rv_sub(RV_REG_T1, hi(rd), hi(rs)), ctx);
+		emit(rv_sltu(RV_REG_T0, lo(rd), lo(rs)), ctx);
+		emit(rv_sub(hi(rd), RV_REG_T1, RV_REG_T0), ctx);
+		emit(rv_sub(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_AND:
+		emit(rv_and(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_and(hi(rd), hi(rd), hi(rs)), ctx);
+		break;
+	case BPF_OR:
+		emit(rv_or(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_or(hi(rd), hi(rd), hi(rs)), ctx);
+		break;
+	case BPF_XOR:
+		emit(rv_xor(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_xor(hi(rd), hi(rd), hi(rs)), ctx);
+		break;
+	case BPF_MUL:
+		emit(rv_mul(RV_REG_T0, hi(rs), lo(rd)), ctx);
+		emit(rv_mul(hi(rd), hi(rd), lo(rs)), ctx);
+		emit(rv_mulhu(RV_REG_T1, lo(rd), lo(rs)), ctx);
+		emit(rv_add(hi(rd), hi(rd), RV_REG_T0), ctx);
+		emit(rv_mul(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_add(hi(rd), hi(rd), RV_REG_T1), ctx);
+		break;
+	case BPF_LSH:
+		emit(rv_addi(RV_REG_T0, lo(rs), -32), ctx);
+		emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 8), ctx);
+		emit(rv_sll(hi(rd), lo(rd), RV_REG_T0), ctx);
+		emit(rv_addi(lo(rd), RV_REG_ZERO, 0), ctx);
+		emit(rv_jal(RV_REG_ZERO, 16), ctx);
+		emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
+		emit(rv_srli(RV_REG_T0, lo(rd), 1), ctx);
+		emit(rv_sub(RV_REG_T1, RV_REG_T1, lo(rs)), ctx);
+		emit(rv_srl(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
+		emit(rv_sll(hi(rd), hi(rd), lo(rs)), ctx);
+		emit(rv_or(hi(rd), RV_REG_T0, hi(rd)), ctx);
+		emit(rv_sll(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_RSH:
+		emit(rv_addi(RV_REG_T0, lo(rs), -32), ctx);
+		emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 8), ctx);
+		emit(rv_srl(lo(rd), hi(rd), RV_REG_T0), ctx);
+		emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		emit(rv_jal(RV_REG_ZERO, 16), ctx);
+		emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
+		emit(rv_slli(RV_REG_T0, hi(rd), 1), ctx);
+		emit(rv_sub(RV_REG_T1, RV_REG_T1, lo(rs)), ctx);
+		emit(rv_sll(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
+		emit(rv_srl(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+		emit(rv_srl(hi(rd), hi(rd), lo(rs)), ctx);
+		break;
+	case BPF_ARSH:
+		emit(rv_addi(RV_REG_T0, lo(rs), -32), ctx);
+		emit(rv_blt(RV_REG_T0, RV_REG_ZERO, 8), ctx);
+		emit(rv_sra(lo(rd), hi(rd), RV_REG_T0), ctx);
+		emit(rv_srai(hi(rd), hi(rd), 31), ctx);
+		emit(rv_jal(RV_REG_ZERO, 16), ctx);
+		emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 31), ctx);
+		emit(rv_slli(RV_REG_T0, hi(rd), 1), ctx);
+		emit(rv_sub(RV_REG_T1, RV_REG_T1, lo(rs)), ctx);
+		emit(rv_sll(RV_REG_T0, RV_REG_T0, RV_REG_T1), ctx);
+		emit(rv_srl(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(rv_or(lo(rd), RV_REG_T0, lo(rd)), ctx);
+		emit(rv_sra(hi(rd), hi(rd), lo(rs)), ctx);
+		break;
+	case BPF_NEG:
+		emit(rv_sub(lo(rd), RV_REG_ZERO, lo(rd)), ctx);
+		emit(rv_sltu(RV_REG_T0, RV_REG_ZERO, lo(rd)), ctx);
+		emit(rv_sub(hi(rd), RV_REG_ZERO, hi(rd)), ctx);
+		emit(rv_sub(hi(rd), hi(rd), RV_REG_T0), ctx);
+		break;
+	}
+
+	bpf_put_reg64(dst, rd, ctx);
+}
+
+static void emit_alu_r32(const s8 *dst, const s8 *src,
+			 struct rv_jit_context *ctx, const u8 op)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = bpf_get_reg32(dst, tmp1, ctx);
+	const s8 *rs = bpf_get_reg32(src, tmp2, ctx);
+
+	switch (op) {
+	case BPF_MOV:
+		emit(rv_addi(lo(rd), lo(rs), 0), ctx);
+		break;
+	case BPF_ADD:
+		emit(rv_add(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_SUB:
+		emit(rv_sub(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_AND:
+		emit(rv_and(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_OR:
+		emit(rv_or(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_XOR:
+		emit(rv_xor(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_MUL:
+		emit(rv_mul(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_DIV:
+		emit(rv_divu(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_MOD:
+		emit(rv_remu(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_LSH:
+		emit(rv_sll(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_RSH:
+		emit(rv_srl(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_ARSH:
+		emit(rv_sra(lo(rd), lo(rd), lo(rs)), ctx);
+		break;
+	case BPF_NEG:
+		emit(rv_sub(lo(rd), RV_REG_ZERO, lo(rd)), ctx);
+		break;
+	}
+
+	bpf_put_reg32(dst, rd, ctx);
+}
+
+static int emit_branch_r64(const s8 *src1, const s8 *src2, s32 rvoff,
+			   struct rv_jit_context *ctx, const u8 op)
+{
+	int e, s = ctx->ninsns;
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+
+	const s8 *rs1 = bpf_get_reg64(src1, tmp1, ctx);
+	const s8 *rs2 = bpf_get_reg64(src2, tmp2, ctx);
+
+	/*
+	 * NO_JUMP skips over the rest of the instructions and the
+	 * emit_jump_and_link, meaning the BPF branch is not taken.
+	 * JUMP skips directly to the emit_jump_and_link, meaning
+	 * the BPF branch is taken.
+	 *
+	 * The fallthrough case results in the BPF branch being taken.
+	 */
+#define NO_JUMP(idx) (6 + (2 * (idx)))
+#define JUMP(idx) (2 + (2 * (idx)))
+
+	switch (op) {
+	case BPF_JEQ:
+		emit(rv_bne(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bne(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JGT:
+		emit(rv_bgtu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bltu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bleu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JLT:
+		emit(rv_bltu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgtu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgeu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JGE:
+		emit(rv_bgtu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bltu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bltu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JLE:
+		emit(rv_bltu(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgtu(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgtu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JNE:
+		emit(rv_bne(hi(rs1), hi(rs2), JUMP(1)), ctx);
+		emit(rv_beq(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSGT:
+		emit(rv_bgt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_blt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bleu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSLT:
+		emit(rv_blt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgeu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSGE:
+		emit(rv_bgt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_blt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bltu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSLE:
+		emit(rv_blt(hi(rs1), hi(rs2), JUMP(2)), ctx);
+		emit(rv_bgt(hi(rs1), hi(rs2), NO_JUMP(1)), ctx);
+		emit(rv_bgtu(lo(rs1), lo(rs2), NO_JUMP(0)), ctx);
+		break;
+	case BPF_JSET:
+		emit(rv_and(RV_REG_T0, hi(rs1), hi(rs2)), ctx);
+		emit(rv_bne(RV_REG_T0, RV_REG_ZERO, JUMP(2)), ctx);
+		emit(rv_and(RV_REG_T0, lo(rs1), lo(rs2)), ctx);
+		emit(rv_beq(RV_REG_T0, RV_REG_ZERO, NO_JUMP(0)), ctx);
+		break;
+	}
+
+#undef NO_JUMP
+#undef JUMP
+
+	e = ctx->ninsns;
+	/* Adjust for extra insns. */
+	rvoff -= (e - s) << 2;
+	emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
+	return 0;
+}
+
+static int emit_bcc(u8 op, u8 rd, u8 rs, int rvoff, struct rv_jit_context *ctx)
+{
+	int e, s = ctx->ninsns;
+	bool far = false;
+	int off;
+
+	if (op == BPF_JSET) {
+		/*
+		 * BPF_JSET is a special case: it has no inverse so we always
+		 * treat it as a far branch.
+		 */
+		far = true;
+	} else if (!is_13b_int(rvoff)) {
+		op = invert_bpf_cond(op);
+		far = true;
+	}
+
+	/*
+	 * For a far branch, the condition is negated and we jump over the
+	 * branch itself, and the two instructions from emit_jump_and_link.
+	 * For a near branch, just use rvoff.
+	 */
+	off = far ? 6 : (rvoff >> 1);
+
+	switch (op) {
+	case BPF_JEQ:
+		emit(rv_beq(rd, rs, off), ctx);
+		break;
+	case BPF_JGT:
+		emit(rv_bgtu(rd, rs, off), ctx);
+		break;
+	case BPF_JLT:
+		emit(rv_bltu(rd, rs, off), ctx);
+		break;
+	case BPF_JGE:
+		emit(rv_bgeu(rd, rs, off), ctx);
+		break;
+	case BPF_JLE:
+		emit(rv_bleu(rd, rs, off), ctx);
+		break;
+	case BPF_JNE:
+		emit(rv_bne(rd, rs, off), ctx);
+		break;
+	case BPF_JSGT:
+		emit(rv_bgt(rd, rs, off), ctx);
+		break;
+	case BPF_JSLT:
+		emit(rv_blt(rd, rs, off), ctx);
+		break;
+	case BPF_JSGE:
+		emit(rv_bge(rd, rs, off), ctx);
+		break;
+	case BPF_JSLE:
+		emit(rv_ble(rd, rs, off), ctx);
+		break;
+	case BPF_JSET:
+		emit(rv_and(RV_REG_T0, rd, rs), ctx);
+		emit(rv_beq(RV_REG_T0, RV_REG_ZERO, off), ctx);
+		break;
+	}
+
+	if (far) {
+		e = ctx->ninsns;
+		/* Adjust for extra insns. */
+		rvoff -= (e - s) << 2;
+		emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
+	}
+	return 0;
+}
+
+static int emit_branch_r32(const s8 *src1, const s8 *src2, s32 rvoff,
+			   struct rv_jit_context *ctx, const u8 op)
+{
+	int e, s = ctx->ninsns;
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+
+	const s8 *rs1 = bpf_get_reg32(src1, tmp1, ctx);
+	const s8 *rs2 = bpf_get_reg32(src2, tmp2, ctx);
+
+	e = ctx->ninsns;
+	/* Adjust for extra insns. */
+	rvoff -= (e - s) << 2;
+
+	if (emit_bcc(op, lo(rs1), lo(rs2), rvoff, ctx))
+		return -1;
+
+	return 0;
+}
+
+static void emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
+{
+	const s8 *r0 = bpf2rv32[BPF_REG_0];
+	const s8 *r5 = bpf2rv32[BPF_REG_5];
+	u32 upper = ((u32)addr + (1 << 11)) >> 12;
+	u32 lower = addr & 0xfff;
+
+	/* R1-R4 already in correct registers---need to push R5 to stack. */
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, -16), ctx);
+	emit(rv_sw(RV_REG_SP, 0, lo(r5)), ctx);
+	emit(rv_sw(RV_REG_SP, 4, hi(r5)), ctx);
+
+	/* Backup TCC. */
+	emit(rv_addi(RV_REG_TCC_SAVED, RV_REG_TCC, 0), ctx);
+
+	/*
+	 * Use lui/jalr pair to jump to absolute address. Don't use emit_imm as
+	 * the number of emitted instructions should not depend on the value of
+	 * addr.
+	 */
+	emit(rv_lui(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(RV_REG_RA, RV_REG_T1, lower), ctx);
+
+	/* Restore TCC. */
+	emit(rv_addi(RV_REG_TCC, RV_REG_TCC_SAVED, 0), ctx);
+
+	/* Set return value and restore stack. */
+	emit(rv_addi(lo(r0), RV_REG_A0, 0), ctx);
+	emit(rv_addi(hi(r0), RV_REG_A1, 0), ctx);
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, 16), ctx);
+}
+
+static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
+{
+	/*
+	 * R1 -> &ctx
+	 * R2 -> &array
+	 * R3 -> index
+	 */
+	int tc_ninsn, off, start_insn = ctx->ninsns;
+	const s8 *arr_reg = bpf2rv32[BPF_REG_2];
+	const s8 *idx_reg = bpf2rv32[BPF_REG_3];
+
+	tc_ninsn = insn ? ctx->offset[insn] - ctx->offset[insn - 1] :
+		ctx->offset[0];
+
+	/* max_entries = array->map.max_entries; */
+	off = offsetof(struct bpf_array, map.max_entries);
+	if (is_12b_check(off, insn))
+		return -1;
+	emit(rv_lw(RV_REG_T1, off, lo(arr_reg)), ctx);
+
+	/*
+	 * if (index >= max_entries)
+	 *   goto out;
+	 */
+	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
+
+	/*
+	 * if ((temp_tcc = tcc - 1) < 0)
+	 *   goto out;
+	 */
+	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
+	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
+
+	/*
+	 * prog = array->ptrs[index];
+	 * if (!prog)
+	 *   goto out;
+	 */
+	emit(rv_slli(RV_REG_T0, lo(idx_reg), 2), ctx);
+	emit(rv_add(RV_REG_T0, RV_REG_T0, lo(arr_reg)), ctx);
+	off = offsetof(struct bpf_array, ptrs);
+	if (is_12b_check(off, insn))
+		return -1;
+	emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
+	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
+	emit_bcc(BPF_JEQ, RV_REG_T0, RV_REG_ZERO, off, ctx);
+
+	/*
+	 * tcc = temp_tcc;
+	 * goto *(prog->bpf_func + 4);
+	 */
+	off = offsetof(struct bpf_prog, bpf_func);
+	if (is_12b_check(off, insn))
+		return -1;
+	emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
+	emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
+	/* Epilogue jumps to *(t0 + 4). */
+	__build_epilogue(true, ctx);
+	return 0;
+}
+
+static int emit_load_r64(const s8 *dst, const s8 *src, s16 off,
+			 struct rv_jit_context *ctx, const u8 size)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+	const s8 *rs = bpf_get_reg64(src, tmp2, ctx);
+
+	emit_imm(RV_REG_T0, off, ctx);
+	emit(rv_add(RV_REG_T0, RV_REG_T0, lo(rs)), ctx);
+
+	switch (size) {
+	case BPF_B:
+		emit(rv_lbu(lo(rd), 0, RV_REG_T0), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_H:
+		emit(rv_lhu(lo(rd), 0, RV_REG_T0), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_W:
+		emit(rv_lw(lo(rd), 0, RV_REG_T0), ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+		break;
+	case BPF_DW:
+		emit(rv_lw(lo(rd), 0, RV_REG_T0), ctx);
+		emit(rv_lw(hi(rd), 4, RV_REG_T0), ctx);
+		break;
+	}
+
+	bpf_put_reg64(dst, rd, ctx);
+	return 0;
+}
+
+static int emit_store_r64(const s8 *dst, const s8 *src, s16 off,
+			  struct rv_jit_context *ctx, const u8 size,
+			  const u8 mode)
+{
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+	const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+	const s8 *rs = bpf_get_reg64(src, tmp2, ctx);
+
+	if (mode == BPF_XADD && size != BPF_W)
+		return -1;
+
+	emit_imm(RV_REG_T0, off, ctx);
+	emit(rv_add(RV_REG_T0, RV_REG_T0, lo(rd)), ctx);
+
+	switch (size) {
+	case BPF_B:
+		emit(rv_sb(RV_REG_T0, 0, lo(rs)), ctx);
+		break;
+	case BPF_H:
+		emit(rv_sh(RV_REG_T0, 0, lo(rs)), ctx);
+		break;
+	case BPF_W:
+		switch (mode) {
+		case BPF_MEM:
+			emit(rv_sw(RV_REG_T0, 0, lo(rs)), ctx);
+			break;
+		case BPF_XADD:
+			emit(rv_amoadd_w(RV_REG_ZERO, lo(rs), RV_REG_T0, 0, 0),
+			     ctx);
+			break;
+		}
+		break;
+	case BPF_DW:
+		emit(rv_sw(RV_REG_T0, 0, lo(rs)), ctx);
+		emit(rv_sw(RV_REG_T0, 4, hi(rs)), ctx);
+		break;
+	}
+
+	return 0;
+}
+
+static void emit_rev16(const s8 rd, struct rv_jit_context *ctx)
+{
+	emit(rv_slli(rd, rd, 16), ctx);
+	emit(rv_slli(RV_REG_T1, rd, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_add(RV_REG_T1, rd, RV_REG_T1), ctx);
+	emit(rv_srli(rd, RV_REG_T1, 16), ctx);
+}
+
+static void emit_rev32(const s8 rd, struct rv_jit_context *ctx)
+{
+	emit(rv_addi(RV_REG_T1, RV_REG_ZERO, 0), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_slli(RV_REG_T1, RV_REG_T1, 8), ctx);
+	emit(rv_srli(rd, rd, 8), ctx);
+	emit(rv_andi(RV_REG_T0, rd, 255), ctx);
+	emit(rv_add(RV_REG_T1, RV_REG_T1, RV_REG_T0), ctx);
+	emit(rv_addi(rd, RV_REG_T1, 0), ctx);
+}
+
+static void emit_zext64(const s8 *dst, struct rv_jit_context *ctx)
+{
+	const s8 *rd;
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+
+	rd = bpf_get_reg64(dst, tmp1, ctx);
+	emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+	bpf_put_reg64(dst, rd, ctx);
+}
+
+int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
+		      bool extra_pass)
+{
+	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
+		BPF_CLASS(insn->code) == BPF_JMP;
+	int s, e, rvoff, i = insn - ctx->prog->insnsi;
+	u8 code = insn->code;
+	s16 off = insn->off;
+	s32 imm = insn->imm;
+
+	const s8 *dst = bpf2rv32[insn->dst_reg];
+	const s8 *src = bpf2rv32[insn->src_reg];
+	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
+	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
+
+	switch (code) {
+	case BPF_ALU64 | BPF_MOV | BPF_X:
+
+	case BPF_ALU64 | BPF_ADD | BPF_X:
+	case BPF_ALU64 | BPF_ADD | BPF_K:
+
+	case BPF_ALU64 | BPF_SUB | BPF_X:
+	case BPF_ALU64 | BPF_SUB | BPF_K:
+
+	case BPF_ALU64 | BPF_AND | BPF_X:
+	case BPF_ALU64 | BPF_OR | BPF_X:
+	case BPF_ALU64 | BPF_XOR | BPF_X:
+
+	case BPF_ALU64 | BPF_MUL | BPF_X:
+	case BPF_ALU64 | BPF_MUL | BPF_K:
+
+	case BPF_ALU64 | BPF_LSH | BPF_X:
+	case BPF_ALU64 | BPF_RSH | BPF_X:
+	case BPF_ALU64 | BPF_ARSH | BPF_X:
+		if (BPF_SRC(code) == BPF_K) {
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+		}
+		emit_alu_r64(dst, src, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU64 | BPF_NEG:
+		emit_alu_r64(dst, tmp2, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU64 | BPF_DIV | BPF_X:
+	case BPF_ALU64 | BPF_DIV | BPF_K:
+	case BPF_ALU64 | BPF_MOD | BPF_X:
+	case BPF_ALU64 | BPF_MOD | BPF_K:
+		goto notsupported;
+
+	case BPF_ALU64 | BPF_MOV | BPF_K:
+	case BPF_ALU64 | BPF_AND | BPF_K:
+	case BPF_ALU64 | BPF_OR | BPF_K:
+	case BPF_ALU64 | BPF_XOR | BPF_K:
+	case BPF_ALU64 | BPF_LSH | BPF_K:
+	case BPF_ALU64 | BPF_RSH | BPF_K:
+	case BPF_ALU64 | BPF_ARSH | BPF_K:
+		emit_alu_i64(dst, imm, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_MOV | BPF_X:
+		if (imm == 1) {
+			/* Special mov32 for zext. */
+			emit_zext64(dst, ctx);
+			break;
+		}
+		/* Fallthrough. */
+
+	case BPF_ALU | BPF_ADD | BPF_X:
+	case BPF_ALU | BPF_SUB | BPF_X:
+	case BPF_ALU | BPF_AND | BPF_X:
+	case BPF_ALU | BPF_OR | BPF_X:
+	case BPF_ALU | BPF_XOR | BPF_X:
+
+	case BPF_ALU | BPF_MUL | BPF_X:
+	case BPF_ALU | BPF_MUL | BPF_K:
+
+	case BPF_ALU | BPF_DIV | BPF_X:
+	case BPF_ALU | BPF_DIV | BPF_K:
+
+	case BPF_ALU | BPF_MOD | BPF_X:
+	case BPF_ALU | BPF_MOD | BPF_K:
+
+	case BPF_ALU | BPF_LSH | BPF_X:
+	case BPF_ALU | BPF_RSH | BPF_X:
+	case BPF_ALU | BPF_ARSH | BPF_X:
+		if (BPF_SRC(code) == BPF_K) {
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+		}
+		emit_alu_r32(dst, src, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_MOV | BPF_K:
+	case BPF_ALU | BPF_ADD | BPF_K:
+	case BPF_ALU | BPF_SUB | BPF_K:
+	case BPF_ALU | BPF_AND | BPF_K:
+	case BPF_ALU | BPF_OR | BPF_K:
+	case BPF_ALU | BPF_XOR | BPF_K:
+	case BPF_ALU | BPF_LSH | BPF_K:
+	case BPF_ALU | BPF_RSH | BPF_K:
+	case BPF_ALU | BPF_ARSH | BPF_K:
+		/*
+		 * mul,div,mod are handled in the BPF_X case since there are
+		 * no RISC-V I-type equivalents.
+		 */
+		emit_alu_i32(dst, imm, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_NEG:
+		/*
+		 * src is ignored---choose tmp2 as a dummy register since it
+		 * is not on the stack.
+		 */
+		emit_alu_r32(dst, tmp2, ctx, BPF_OP(code));
+		break;
+
+	case BPF_ALU | BPF_END | BPF_FROM_LE:
+	{
+		const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+
+		switch (imm) {
+		case 16:
+			emit(rv_slli(lo(rd), lo(rd), 16), ctx);
+			emit(rv_srli(lo(rd), lo(rd), 16), ctx);
+			/* Fallthrough. */
+		case 32:
+			if (!ctx->prog->aux->verifier_zext)
+				emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+			break;
+		case 64:
+			/* Do nothing. */
+			break;
+		default:
+			pr_err("bpf-jit: BPF_END imm %d invalid\n", imm);
+			return -1;
+		}
+
+		bpf_put_reg64(dst, rd, ctx);
+		break;
+	}
+
+	case BPF_ALU | BPF_END | BPF_FROM_BE:
+	{
+		const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+
+		switch (imm) {
+		case 16:
+			emit_rev16(lo(rd), ctx);
+			if (!ctx->prog->aux->verifier_zext)
+				emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+			break;
+		case 32:
+			emit_rev32(lo(rd), ctx);
+			if (!ctx->prog->aux->verifier_zext)
+				emit(rv_addi(hi(rd), RV_REG_ZERO, 0), ctx);
+			break;
+		case 64:
+			/* Swap upper and lower halves. */
+			emit(rv_addi(RV_REG_T0, lo(rd), 0), ctx);
+			emit(rv_addi(lo(rd), hi(rd), 0), ctx);
+			emit(rv_addi(hi(rd), RV_REG_T0, 0), ctx);
+
+			/* Swap each half. */
+			emit_rev32(lo(rd), ctx);
+			emit_rev32(hi(rd), ctx);
+			break;
+		default:
+			pr_err("bpf-jit: BPF_END imm %d invalid\n", imm);
+			return -1;
+		}
+
+		bpf_put_reg64(dst, rd, ctx);
+		break;
+	}
+
+	case BPF_JMP | BPF_JA:
+		rvoff = rv_offset(i, off, ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		break;
+
+	case BPF_JMP | BPF_CALL:
+	{
+		bool fixed;
+		int ret;
+		u64 addr;
+
+		ret = bpf_jit_get_func_addr(ctx->prog, insn, extra_pass, &addr,
+					    &fixed);
+		if (ret < 0)
+			return ret;
+		emit_call(fixed, addr, ctx);
+		break;
+	}
+
+	case BPF_JMP | BPF_TAIL_CALL:
+		if (emit_bpf_tail_call(i, ctx))
+			return -1;
+		break;
+
+	case BPF_JMP | BPF_JEQ | BPF_X:
+	case BPF_JMP | BPF_JEQ | BPF_K:
+	case BPF_JMP32 | BPF_JEQ | BPF_X:
+	case BPF_JMP32 | BPF_JEQ | BPF_K:
+
+	case BPF_JMP | BPF_JNE | BPF_X:
+	case BPF_JMP | BPF_JNE | BPF_K:
+	case BPF_JMP32 | BPF_JNE | BPF_X:
+	case BPF_JMP32 | BPF_JNE | BPF_K:
+
+	case BPF_JMP | BPF_JLE | BPF_X:
+	case BPF_JMP | BPF_JLE | BPF_K:
+	case BPF_JMP32 | BPF_JLE | BPF_X:
+	case BPF_JMP32 | BPF_JLE | BPF_K:
+
+	case BPF_JMP | BPF_JLT | BPF_X:
+	case BPF_JMP | BPF_JLT | BPF_K:
+	case BPF_JMP32 | BPF_JLT | BPF_X:
+	case BPF_JMP32 | BPF_JLT | BPF_K:
+
+	case BPF_JMP | BPF_JGE | BPF_X:
+	case BPF_JMP | BPF_JGE | BPF_K:
+	case BPF_JMP32 | BPF_JGE | BPF_X:
+	case BPF_JMP32 | BPF_JGE | BPF_K:
+
+	case BPF_JMP | BPF_JGT | BPF_X:
+	case BPF_JMP | BPF_JGT | BPF_K:
+	case BPF_JMP32 | BPF_JGT | BPF_X:
+	case BPF_JMP32 | BPF_JGT | BPF_K:
+
+	case BPF_JMP | BPF_JSLE | BPF_X:
+	case BPF_JMP | BPF_JSLE | BPF_K:
+	case BPF_JMP32 | BPF_JSLE | BPF_X:
+	case BPF_JMP32 | BPF_JSLE | BPF_K:
+
+	case BPF_JMP | BPF_JSLT | BPF_X:
+	case BPF_JMP | BPF_JSLT | BPF_K:
+	case BPF_JMP32 | BPF_JSLT | BPF_X:
+	case BPF_JMP32 | BPF_JSLT | BPF_K:
+
+	case BPF_JMP | BPF_JSGE | BPF_X:
+	case BPF_JMP | BPF_JSGE | BPF_K:
+	case BPF_JMP32 | BPF_JSGE | BPF_X:
+	case BPF_JMP32 | BPF_JSGE | BPF_K:
+
+	case BPF_JMP | BPF_JSGT | BPF_X:
+	case BPF_JMP | BPF_JSGT | BPF_K:
+	case BPF_JMP32 | BPF_JSGT | BPF_X:
+	case BPF_JMP32 | BPF_JSGT | BPF_K:
+
+	case BPF_JMP | BPF_JSET | BPF_X:
+	case BPF_JMP | BPF_JSET | BPF_K:
+	case BPF_JMP32 | BPF_JSET | BPF_X:
+	case BPF_JMP32 | BPF_JSET | BPF_K:
+		rvoff = rv_offset(i, off, ctx);
+		if (BPF_SRC(code) == BPF_K) {
+			s = ctx->ninsns;
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+			e = ctx->ninsns;
+			rvoff -= (e - s) << 2;
+		}
+
+		if (is64)
+			emit_branch_r64(dst, src, rvoff, ctx, BPF_OP(code));
+		else
+			emit_branch_r32(dst, src, rvoff, ctx, BPF_OP(code));
+		break;
+
+	case BPF_JMP | BPF_EXIT:
+		if (i == ctx->prog->len - 1)
+			break;
+
+		rvoff = epilogue_offset(ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		break;
+
+	case BPF_LD | BPF_IMM | BPF_DW:
+	{
+		struct bpf_insn insn1 = insn[1];
+		s32 imm_lo = imm;
+		s32 imm_hi = insn1.imm;
+		const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+
+		emit_imm64(rd, imm_hi, imm_lo, ctx);
+		bpf_put_reg64(dst, rd, ctx);
+		return 1;
+	}
+
+	case BPF_LDX | BPF_MEM | BPF_B:
+	case BPF_LDX | BPF_MEM | BPF_H:
+	case BPF_LDX | BPF_MEM | BPF_W:
+	case BPF_LDX | BPF_MEM | BPF_DW:
+		if (emit_load_r64(dst, src, off, ctx, BPF_SIZE(code)))
+			return -1;
+		break;
+
+	case BPF_ST | BPF_MEM | BPF_B:
+	case BPF_ST | BPF_MEM | BPF_H:
+	case BPF_ST | BPF_MEM | BPF_W:
+	case BPF_ST | BPF_MEM | BPF_DW:
+
+	case BPF_STX | BPF_MEM | BPF_B:
+	case BPF_STX | BPF_MEM | BPF_H:
+	case BPF_STX | BPF_MEM | BPF_W:
+	case BPF_STX | BPF_MEM | BPF_DW:
+	case BPF_STX | BPF_XADD | BPF_W:
+		if (BPF_CLASS(code) == BPF_ST) {
+			emit_imm32(tmp2, imm, ctx);
+			src = tmp2;
+		}
+
+		if (emit_store_r64(dst, src, off, ctx, BPF_SIZE(code),
+				   BPF_MODE(code)))
+			return -1;
+		break;
+
+	/* No hardware support for 8-byte atomics in RV32. */
+	case BPF_STX | BPF_XADD | BPF_DW:
+		/* Fallthrough. */
+
+notsupported:
+		pr_info_once("bpf-jit: not supported: opcode %02x ***\n", code);
+		return -EFAULT;
+
+	default:
+		pr_err("bpf-jit: unknown opcode %02x\n", code);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void bpf_jit_build_prologue(struct rv_jit_context *ctx)
+{
+	/* Make space to save 9 registers: ra, fp, s1--s7. */
+	int stack_adjust = 9 * sizeof(u32), store_offset, bpf_stack_adjust;
+	const s8 *fp = bpf2rv32[BPF_REG_FP];
+	const s8 *r1 = bpf2rv32[BPF_REG_1];
+
+	bpf_stack_adjust = round_up(ctx->prog->aux->stack_depth, 16);
+	stack_adjust += bpf_stack_adjust;
+
+	store_offset = stack_adjust - 4;
+
+	stack_adjust += 4 * BPF_JIT_SCRATCH_REGS;
+
+	/*
+	 * The first instruction sets the tail-call-counter (TCC) register.
+	 * This instruction is skipped by tail calls.
+	 */
+	emit(rv_addi(RV_REG_TCC, RV_REG_ZERO, MAX_TAIL_CALL_CNT), ctx);
+
+	emit(rv_addi(RV_REG_SP, RV_REG_SP, -stack_adjust), ctx);
+
+	/* Save callee-save registers. */
+	emit(rv_sw(RV_REG_SP, store_offset - 0, RV_REG_RA), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 4, RV_REG_FP), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 8, RV_REG_S1), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 12, RV_REG_S2), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 16, RV_REG_S3), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 20, RV_REG_S4), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 24, RV_REG_S5), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 28, RV_REG_S6), ctx);
+	emit(rv_sw(RV_REG_SP, store_offset - 32, RV_REG_S7), ctx);
+
+	/* Set fp: used as the base address for stacked BPF registers. */
+	emit(rv_addi(RV_REG_FP, RV_REG_SP, stack_adjust), ctx);
+
+	/* Set up BPF stack pointer. */
+	emit(rv_addi(lo(fp), RV_REG_SP, bpf_stack_adjust), ctx);
+	emit(rv_addi(hi(fp), RV_REG_ZERO, 0), ctx);
+
+	/* Set up context pointer. */
+	emit(rv_addi(lo(r1), RV_REG_A0, 0), ctx);
+	emit(rv_addi(hi(r1), RV_REG_ZERO, 0), ctx);
+
+	ctx->stack_size = stack_adjust;
+}
+
+void bpf_jit_build_epilogue(struct rv_jit_context *ctx)
+{
+	__build_epilogue(false, ctx);
+}
-- 
2.20.1

