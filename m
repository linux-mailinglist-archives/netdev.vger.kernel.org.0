Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715344220E2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhJEIer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhJEIeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:34:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E69BC061745;
        Tue,  5 Oct 2021 01:32:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id on6so2667245pjb.5;
        Tue, 05 Oct 2021 01:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WGzG2E6uBjhCwvl7ERMbgVWMOyPXLCcfpUeO/GgX/OI=;
        b=bzNH7UHFnSWXArXwt2Gi9qEVPORCCJ+mXd7v+IV9gj0sa97KzbjfVIrCnhkHGZV/BK
         FT14uBOBFA/rM26d0fk4y8hgGbHnDgXPp+k9LxQe73nGefjTX84YhMw05XSsV+tMXSTR
         03zdNmo4KDtEYLhFvxkpYT8hwT+tVqtCDcAJ8jzexZ21Ofjm3JksMpEhG1x92vsJ2+Kz
         DzakeNjzu8cf9CeJgz48BeBuNpZuM1S8CnHZPDero0thG9S1bpyTbk1mQzPV5oQowEtX
         Xgey0k8oGYypC3XHyO4w9GEdAEfEacYUGtkFIM6iH6+KUERj4b3RPM4V8hweFoLwDwbz
         kU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WGzG2E6uBjhCwvl7ERMbgVWMOyPXLCcfpUeO/GgX/OI=;
        b=peL9EhxJoBVpbYiC1igO7NtCcd2PYfXUU59y+F3lKg35hO1RF3oZHo8KhMexPX3FsT
         mSeTwDpCETTuR28QtVQSk/t/AKHBpRyIhtW2mYt0x6VhO39uVxiPa/ou25pcW+6RR5TB
         2f/pno3RSt8y5Q5odwUuWl7j6sbLPVci3nNqlE4tWuhb36OaEdEXDoKH7gar8qhb0okn
         JZgzKNWuO0uA+fc2AmcDcD5eNrUDwxAkiPw0P9cwXiHEmwXNmXpozhorw2+qqx3PPGVl
         6+e43+GXfOHIg72wqJHkuRbvpPXUmpVUbITXvZUqhS5CBcm6YEkcfaJjBwDBlmXfOpur
         vaiQ==
X-Gm-Message-State: AOAM531RL/82ewugR1fOcRKnrrhvgmb/lRH0H0NvQHUeeXIRQyMUErIM
        Mk6piJcVH5ZXwFV+TDd8W00=
X-Google-Smtp-Source: ABdhPJyb0a9MkoHkUJDlTMm5dJ8YQ+fs8ELC7Y450w9iejUxC0N9nZLf8ha1yfk3lsok7XH2nT+s5g==
X-Received: by 2002:a17:90b:1c81:: with SMTP id oo1mr2220449pjb.97.1633422775320;
        Tue, 05 Oct 2021 01:32:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:32:55 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next v2 16/16] MIPS: eBPF: add MIPS32 JIT
Date:   Tue,  5 Oct 2021 01:27:00 -0700
Message-Id: <1f04a1d0d303e6690e56eb8c5139d68be4e9280a.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new variant of build_one_insn() supporting MIPS32, leveraging the
previously added common functions, and disable static analysis as unneeded
on MIPS32. Also define bpf_jit_needs_zext() to request verifier zext
insertion. Handle these zext insns, and add conditional zext for all ALU32
and LDX word-size operations for cases where the verifier is unable to do
so (e.g. test_bpf bypasses verifier).

Aside from mapping 64-bit BPF registers to pairs of 32-bit MIPS registers,
notable changes from the MIPS64 version of build_one_insn() include:

  BPF_ALU{,64} | {DIV,MOD} | BPF_K: drop divide-by-zero guard as the insns
  underlying do not raise exceptions.

  BPF_JMP | JSET | BPF_K: drop bbit insns only usable on MIPS64 Octeon.

In addition to BPF_ADD, implement atomic insns AND, OR, XOR, XCHG and
CMPXCHG, together with support for BPF_FETCH, in mode BPF_W.

The MIPS32 ISA does not include 64-bit div/mod or atomic opcodes. Add the
emit_bpf_divmod64() and emit_bpf_atomic64() functions, which use built-in
kernel functions to implement the following BPF insns:

  BPF_STX   | BPF_DW  | BPF_ATOMIC
    (AND, OR, XOR, XCHG, CMPXCHG, FETCH)
  BPF_ALU64 | BPF_DIV | BPF_X
  BPF_ALU64 | BPF_DIV | BPF_K
  BPF_ALU64 | BPF_MOD | BPF_X
  BPF_ALU64 | BPF_MOD | BPF_K

Test and development primarily used LTS kernel 5.10.x and then 5.13.x,
running under QEMU. Test suites included the 'test_bpf' module and the
'test_verifier' program from kselftests. Testing with 'test_progs' from
kselftests was not possible in general since cross-compilation depends on
libbpf/bpftool, which does not support cross-endian builds (see also [1]).

The matrix of test configurations executed for this series covers:
MIPSWORD={64-bit,32-bit} x MIPSISA={R2,R6} x JIT={off,on,hardened}

On MIPS32BE and MIPS32LE there was general parity between the results of
interpreter vs. JIT-backed tests with respect to the numbers of PASSED,
SKIPPED, and FAILED tests.

A sample of results on QEMU/MIPS32LE from kernel 5.13.x:

  root@OpenWrt:~# sysctl net.core.bpf_jit_enable=1
  root@OpenWrt:~# modprobe test_bpf
  ...
  test_bpf: Summary: 378 PASSED, 0 FAILED, [366/366 JIT'ed]
  root@OpenWrt:~# ./test_verifier 0 884
  ...
  Summary: 1231 PASSED, 0 SKIPPED, 20 FAILED
  root@OpenWrt:~# ./test_verifier 886 1184
  ...
  Summary: 459 PASSED, 1 SKIPPED, 2 FAILED
  root@OpenWrt:~# ./test_progs -n 105,106
  ...
  105 subprogs:OK
  106/1 tailcall_1:OK
  106/2 tailcall_2:OK
  106/3 tailcall_3:OK
  106/4 tailcall_4:OK
  106/5 tailcall_5:OK
  106/6 tailcall_bpf2bpf_1:OK
  106/7 tailcall_bpf2bpf_2:OK
  106/8 tailcall_bpf2bpf_3:OK
  106/9 tailcall_bpf2bpf_4:OK
  106 tailcalls:OK
  Summary: 2/9 PASSED, 0 SKIPPED, 0 FAILED

Link: [1] https://lore.kernel.org/bpf/CAEf4BzZCnP3oB81w4BDL4TCmvO3vPw8MucOTbVnjbW8UuCtejw@mail.gmail.com/

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 Documentation/admin-guide/sysctl/net.rst |    6 +-
 Documentation/networking/filter.rst      |    6 +-
 arch/mips/Kconfig                        |    4 +-
 arch/mips/net/Makefile                   |    8 +-
 arch/mips/net/ebpf_jit_comp32.c          | 1398 ++++++++++++++++++++++
 arch/mips/net/ebpf_jit_core.c            |   20 +-
 6 files changed, 1426 insertions(+), 16 deletions(-)
 create mode 100644 arch/mips/net/ebpf_jit_comp32.c

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 4150f74c521a..099e3efbf38e 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -66,14 +66,16 @@ two flavors of JITs, the newer eBPF JIT currently supported on:
   - ppc64
   - ppc32
   - sparc64
-  - mips64
+  - mips64 (R2+)
+  - mips32 (R2+)
   - s390x
   - riscv64
   - riscv32
 
 And the older cBPF JIT supported on the following archs:
 
-  - mips
+  - mips64 (R1)
+  - mips32 (R1)
   - sparc
 
 eBPF JITs are a superset of cBPF JITs, meaning the kernel will
diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index 3e2221f4abe4..31101411da0e 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -637,9 +637,9 @@ skb pointer). All constraints and restrictions from bpf_check_classic() apply
 before a conversion to the new layout is being done behind the scenes!
 
 Currently, the classic BPF format is being used for JITing on most
-32-bit architectures, whereas x86-64, aarch64, s390x, powerpc64,
-sparc64, arm32, riscv64, riscv32 perform JIT compilation from eBPF
-instruction set.
+32-bit architectures, whereas x86-64, aarch64, s390x, powerpc64, sparc64,
+mips64, riscv64, arm32, riscv32, and mips32 perform JIT compilation from
+eBPF instruction set.
 
 Some core changes of the new internal format:
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ed51970c08e7..d096d2332fe4 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -55,7 +55,7 @@ config MIPS
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
 	select HAVE_ASM_MODVERSIONS
-	select HAVE_CBPF_JIT if !64BIT && !CPU_MICROMIPS
+	select HAVE_CBPF_JIT if !CPU_MICROMIPS && TARGET_ISA_REV < 2
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_TIF_NOHZ
 	select HAVE_C_RECORDMCOUNT
@@ -63,7 +63,7 @@ config MIPS
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_EBPF_JIT if 64BIT && !CPU_MICROMIPS && TARGET_ISA_REV >= 2
+	select HAVE_EBPF_JIT if !CPU_MICROMIPS && TARGET_ISA_REV >= 2
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/mips/net/Makefile b/arch/mips/net/Makefile
index de42f4a4db56..5f804bc54629 100644
--- a/arch/mips/net/Makefile
+++ b/arch/mips/net/Makefile
@@ -2,4 +2,10 @@
 # MIPS networking code
 
 obj-$(CONFIG_MIPS_CBPF_JIT) += bpf_jit.o bpf_jit_asm.o
-obj-$(CONFIG_MIPS_EBPF_JIT) += ebpf_jit_core.o ebpf_jit_comp64.o
+
+obj-$(CONFIG_MIPS_EBPF_JIT) += ebpf_jit_core.o
+ifeq ($(CONFIG_CPU_MIPS64),y)
+	obj-$(CONFIG_MIPS_EBPF_JIT) += ebpf_jit_comp64.o
+else
+	obj-$(CONFIG_MIPS_EBPF_JIT) += ebpf_jit_comp32.o
+endif
diff --git a/arch/mips/net/ebpf_jit_comp32.c b/arch/mips/net/ebpf_jit_comp32.c
new file mode 100644
index 000000000000..13623224f78e
--- /dev/null
+++ b/arch/mips/net/ebpf_jit_comp32.c
@@ -0,0 +1,1398 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Just-In-Time compiler for eBPF filters on MIPS32/MIPS64
+ * Copyright (c) 2021 Tony Ambardar <Tony.Ambardar@gmail.com>
+ *
+ * Based on code from:
+ *
+ * Copyright (c) 2017 Cavium, Inc.
+ * Author: David Daney <david.daney@cavium.com>
+ *
+ * Copyright (c) 2014 Imagination Technologies Ltd.
+ * Author: Markos Chandras <markos.chandras@imgtec.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/filter.h>
+#include <asm/uasm.h>
+
+#include "ebpf_jit.h"
+
+static int gen_imm_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
+			int idx)
+{
+	int dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+	int upper_bound, lower_bound, shamt;
+	int imm = insn->imm;
+
+	if (dst < 0)
+		return dst;
+
+	switch (BPF_OP(insn->code)) {
+	case BPF_MOV:
+	case BPF_ADD:
+		upper_bound = S16_MAX;
+		lower_bound = S16_MIN;
+		break;
+	case BPF_SUB:
+		upper_bound = -(int)S16_MIN;
+		lower_bound = -(int)S16_MAX;
+		break;
+	case BPF_AND:
+	case BPF_OR:
+	case BPF_XOR:
+		upper_bound = 0xffff;
+		lower_bound = 0;
+		break;
+	case BPF_RSH:
+	case BPF_LSH:
+	case BPF_ARSH:
+		/* Shift amounts are truncated, no need for bounds */
+		upper_bound = S32_MAX;
+		lower_bound = S32_MIN;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Immediate move clobbers the register, so no sign/zero
+	 * extension needed.
+	 */
+	if (lower_bound <= imm && imm <= upper_bound) {
+		/* single insn immediate case */
+		switch (BPF_OP(insn->code) | BPF_CLASS(insn->code)) {
+		case BPF_ALU64 | BPF_MOV:
+			emit_instr(ctx, addiu, LO(dst), MIPS_R_ZERO, imm);
+			if (imm < 0)
+				gen_sext_insn(dst, ctx);
+			else
+				gen_zext_insn(dst, true, ctx);
+			break;
+		case BPF_ALU | BPF_MOV:
+			emit_instr(ctx, addiu, LO(dst), MIPS_R_ZERO, imm);
+			break;
+		case BPF_ALU64 | BPF_AND:
+			if (imm >= 0)
+				gen_zext_insn(dst, true, ctx);
+			fallthrough;
+		case BPF_ALU | BPF_AND:
+			emit_instr(ctx, andi, LO(dst), LO(dst), imm);
+			break;
+		case BPF_ALU64 | BPF_OR:
+			if (imm < 0)
+				emit_instr(ctx, nor, HI(dst),
+						MIPS_R_ZERO, MIPS_R_ZERO);
+			fallthrough;
+		case BPF_ALU | BPF_OR:
+			emit_instr(ctx, ori, LO(dst), LO(dst), imm);
+			break;
+		case BPF_ALU64 | BPF_XOR:
+			if (imm < 0)
+				emit_instr(ctx, nor, HI(dst),
+							HI(dst), MIPS_R_ZERO);
+			fallthrough;
+		case BPF_ALU | BPF_XOR:
+			emit_instr(ctx, xori, LO(dst), LO(dst), imm);
+			break;
+		case BPF_ALU64 | BPF_ADD:
+			emit_instr(ctx, addiu, LO(dst), LO(dst), imm);
+			if (imm < 0)
+				emit_instr(ctx, addiu, HI(dst), HI(dst), -1);
+			emit_instr(ctx, sltiu, MIPS_R_AT, LO(dst), imm);
+			emit_instr(ctx, addu, HI(dst), HI(dst), MIPS_R_AT);
+			break;
+		case BPF_ALU64 | BPF_SUB:
+			emit_instr(ctx, addiu, MIPS_R_AT, LO(dst), -imm);
+			if (imm < 0)
+				emit_instr(ctx, addiu, HI(dst), HI(dst), 1);
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), MIPS_R_AT);
+			emit_instr(ctx, subu, HI(dst), HI(dst), MIPS_R_AT);
+			emit_instr(ctx, addiu, LO(dst), LO(dst), -imm);
+			break;
+		case BPF_ALU64 | BPF_ARSH:
+			shamt = imm & 0x3f;
+			if (shamt >= 32) {
+				emit_instr(ctx, sra, LO(dst),
+							HI(dst), shamt - 32);
+				emit_instr(ctx, sra, HI(dst), HI(dst), 31);
+			} else if (shamt > 0) {
+				emit_instr(ctx, srl, LO(dst), LO(dst), shamt);
+				emit_instr(ctx, ins, LO(dst), HI(dst),
+							32 - shamt, shamt);
+				emit_instr(ctx, sra, HI(dst), HI(dst), shamt);
+			}
+			break;
+		case BPF_ALU64 | BPF_RSH:
+			shamt = imm & 0x3f;
+			if (shamt >= 32) {
+				emit_instr(ctx, srl, LO(dst),
+							HI(dst), shamt - 32);
+				emit_instr(ctx, and, HI(dst),
+							HI(dst), MIPS_R_ZERO);
+			} else if (shamt > 0) {
+				emit_instr(ctx, srl, LO(dst), LO(dst), shamt);
+				emit_instr(ctx, ins, LO(dst), HI(dst),
+							32 - shamt, shamt);
+				emit_instr(ctx, srl, HI(dst), HI(dst), shamt);
+			}
+			break;
+		case BPF_ALU64 | BPF_LSH:
+			shamt = imm & 0x3f;
+			if (shamt >= 32) {
+				emit_instr(ctx, sll, HI(dst),
+							LO(dst), shamt - 32);
+				emit_instr(ctx, and, LO(dst),
+							LO(dst), MIPS_R_ZERO);
+			} else if (shamt > 0) {
+				emit_instr(ctx, srl, MIPS_R_AT,
+							LO(dst), 32 - shamt);
+				emit_instr(ctx, sll, HI(dst), HI(dst), shamt);
+				emit_instr(ctx, sll, LO(dst), LO(dst), shamt);
+				emit_instr(ctx, or, HI(dst),
+							HI(dst), MIPS_R_AT);
+			}
+			break;
+		case BPF_ALU | BPF_RSH:
+			emit_instr(ctx, srl, LO(dst), LO(dst), imm & 0x1f);
+			break;
+		case BPF_ALU | BPF_LSH:
+			emit_instr(ctx, sll, LO(dst), LO(dst), imm & 0x1f);
+			break;
+		case BPF_ALU | BPF_ARSH:
+			emit_instr(ctx, sra, LO(dst), LO(dst), imm & 0x1f);
+			break;
+		case BPF_ALU | BPF_ADD:
+			emit_instr(ctx, addiu, LO(dst), LO(dst), imm);
+			break;
+		case BPF_ALU | BPF_SUB:
+			emit_instr(ctx, addiu, LO(dst), LO(dst), -imm);
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		/* multi insn immediate case */
+		if (BPF_OP(insn->code) == BPF_MOV) {
+			gen_imm_to_reg(insn, LO(dst), ctx);
+			if (BPF_CLASS(insn->code) == BPF_ALU64) {
+				if (imm < 0)
+					gen_sext_insn(dst, ctx);
+				else
+					gen_zext_insn(dst, true, ctx);
+			}
+		} else {
+			gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+			switch (BPF_OP(insn->code) | BPF_CLASS(insn->code)) {
+			case BPF_ALU64 | BPF_AND:
+				if (imm >= 0)
+					gen_zext_insn(dst, true, ctx);
+				fallthrough;
+			case BPF_ALU | BPF_AND:
+				emit_instr(ctx, and, LO(dst), LO(dst),
+								MIPS_R_AT);
+				break;
+			case BPF_ALU64 | BPF_OR:
+				if (imm < 0)
+					emit_instr(ctx, nor, HI(dst),
+						MIPS_R_ZERO, MIPS_R_ZERO);
+			fallthrough;
+			case BPF_ALU | BPF_OR:
+				emit_instr(ctx, or, LO(dst), LO(dst),
+								MIPS_R_AT);
+				break;
+			case BPF_ALU64 | BPF_XOR:
+				if (imm < 0)
+					emit_instr(ctx, nor, HI(dst),
+							HI(dst), MIPS_R_ZERO);
+			fallthrough;
+			case BPF_ALU | BPF_XOR:
+				emit_instr(ctx, xor, LO(dst), LO(dst),
+								MIPS_R_AT);
+				break;
+			case BPF_ALU64 | BPF_ADD:
+				emit_instr(ctx, addu, LO(dst),
+							LO(dst), MIPS_R_AT);
+				if (imm < 0)
+					emit_instr(ctx, addiu, HI(dst), HI(dst), -1);
+				emit_instr(ctx, sltu, MIPS_R_AT,
+							LO(dst), MIPS_R_AT);
+				emit_instr(ctx, addu, HI(dst),
+							HI(dst), MIPS_R_AT);
+				break;
+			case BPF_ALU64 | BPF_SUB:
+				emit_instr(ctx, subu, LO(dst),
+							LO(dst), MIPS_R_AT);
+				if (imm < 0)
+					emit_instr(ctx, addiu, HI(dst), HI(dst), 1);
+				emit_instr(ctx, sltu, MIPS_R_AT,
+							MIPS_R_AT, LO(dst));
+				emit_instr(ctx, subu, HI(dst),
+							HI(dst), MIPS_R_AT);
+				break;
+			case BPF_ALU | BPF_ADD:
+				emit_instr(ctx, addu, LO(dst), LO(dst),
+								MIPS_R_AT);
+				break;
+			case BPF_ALU | BPF_SUB:
+				emit_instr(ctx, subu, LO(dst), LO(dst),
+								MIPS_R_AT);
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Implement 64-bit BPF div/mod insns on 32-bit systems by calling the
+ * equivalent built-in kernel function. The function args may be mixed
+ * 64/32-bit types, unlike the uniform u64 args of BPF kernel helpers.
+ * Func proto: u64 div64_u64_rem(u64 dividend, u64 divisor, u64 *remainder)
+ */
+static int emit_bpf_divmod64(struct jit_ctx *ctx, const struct bpf_insn *insn)
+{
+	const int bpf_src = BPF_SRC(insn->code);
+	const int bpf_op = BPF_OP(insn->code);
+	int rem_off, arg_off;
+	int src, dst, tmp;
+	u32 func_addr;
+
+	ctx->flags |= EBPF_SAVE_RA;
+
+	dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+	if (dst < 0)
+		return -EINVAL;
+
+	if (bpf_src == BPF_X) {
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (src < 0)
+			return -EINVAL;
+		/*
+		 * Use MIPS_R_T8 as temp reg pair to avoid target
+		 * of dst from clobbering src.
+		 */
+		if (src == MIPS_R_A0) {
+			tmp = MIPS_R_T8;
+			emit_instr(ctx, move, LO(tmp), LO(src));
+			emit_instr(ctx, move, HI(tmp), HI(src));
+			src = tmp;
+		}
+	}
+
+	/* Save caller registers */
+	emit_caller_save(ctx);
+	/* Push O32 stack, aligned space for u64, u64, u64 *, u64 */
+	emit_instr(ctx, addiu, MIPS_R_SP, MIPS_R_SP, -32);
+
+	func_addr = (u32) &div64_u64_rem;
+	/* Move u64 dst to arg 1 as needed */
+	if (dst != MIPS_R_A0) {
+		emit_instr(ctx, move, LO(MIPS_R_A0), LO(dst));
+		emit_instr(ctx, move, HI(MIPS_R_A0), HI(dst));
+	}
+	/* Load imm or move u64 src to arg 2 as needed */
+	if (bpf_src == BPF_K) {
+		gen_imm_to_reg(insn, LO(MIPS_R_A2), ctx);
+		gen_sext_insn(MIPS_R_A2, ctx);
+	} else if (src != MIPS_R_A2) { /* BPF_X */
+		emit_instr(ctx, move, LO(MIPS_R_A2), LO(src));
+		emit_instr(ctx, move, HI(MIPS_R_A2), HI(src));
+	}
+	/* Set up stack arg 3 as ptr to u64 remainder on stack */
+	arg_off = 16;
+	rem_off = 24;
+	emit_instr(ctx, addiu, MIPS_R_AT, MIPS_R_SP, rem_off);
+	emit_instr(ctx, sw, MIPS_R_AT, arg_off, MIPS_R_SP);
+
+	emit_const_to_reg(ctx, MIPS_R_T9, func_addr);
+	emit_instr(ctx, jalr, MIPS_R_RA, MIPS_R_T9);
+	/* Delay slot */
+	emit_instr(ctx, nop);
+
+	/* Move return value to dst as needed */
+	switch (bpf_op) {
+	case BPF_DIV:
+		/* Quotient in MIPS_R_V0 reg pair */
+		if (dst != MIPS_R_V0) {
+			emit_instr(ctx, move, LO(dst), LO(MIPS_R_V0));
+			emit_instr(ctx, move, HI(dst), HI(MIPS_R_V0));
+		}
+		break;
+	case BPF_MOD:
+		/* Remainder on stack */
+		emit_instr(ctx, lw, LO(dst), OFFLO(rem_off), MIPS_R_SP);
+		emit_instr(ctx, lw, HI(dst), OFFHI(rem_off), MIPS_R_SP);
+		break;
+	}
+
+	/* Pop O32 call stack */
+	emit_instr(ctx, addiu, MIPS_R_SP, MIPS_R_SP, 32);
+	/* Restore all caller registers except call return value*/
+	emit_caller_restore(ctx, insn->dst_reg);
+
+	return 0;
+}
+
+/*
+ * Implement 64-bit BPF atomic insns on 32-bit systems by calling the
+ * equivalent built-in kernel function. The function args may be mixed
+ * 64/32-bit types, unlike the uniform u64 args of BPF kernel helpers.
+ */
+static int emit_bpf_atomic64(struct jit_ctx *ctx, const struct bpf_insn *insn)
+{
+	/*
+	 * Since CMPXCHG uses R0 implicitly, outside of a passed
+	 * bpf_insn, we fake a lookup to get the MIPS base reg.
+	 */
+	const struct bpf_insn r0_insn = {.src_reg = BPF_REG_0};
+	const int r0 = ebpf_to_mips_reg(ctx, &r0_insn,
+					REG_SRC_NO_FP);
+	int mem_off, arg_off, stack_adj;
+	int src, dst, fetch;
+	u32 func_addr;
+
+
+	ctx->flags |= EBPF_SAVE_RA;
+
+	dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+	src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+	if (src < 0 || dst < 0)
+		return -EINVAL;
+	mem_off = insn->off;
+
+	/* Save caller registers */
+	emit_caller_save(ctx);
+
+	/*
+	 * Push O32 ABI stack, noting CMPXCHG requires 1 u64 arg passed
+	 * on the stack.
+	 */
+	stack_adj = insn->imm == BPF_CMPXCHG ? 24 : 16;
+	emit_instr(ctx, addiu, MIPS_R_SP, MIPS_R_SP, -stack_adj);
+
+	switch (insn->imm) {
+	case BPF_AND | BPF_FETCH:
+		/* void atomic64_fetch_and(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_fetch_and;
+		goto args_common;
+	case BPF_OR | BPF_FETCH:
+		/* void atomic64_fetch_or(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_fetch_or;
+		goto args_common;
+	case BPF_XOR | BPF_FETCH:
+		/* void atomic64_fetch_xor(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_fetch_xor;
+		goto args_common;
+	case BPF_ADD | BPF_FETCH:
+		/* void atomic64_fetch_add(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_fetch_add;
+		goto args_common;
+	case BPF_AND:
+		/* void atomic64_and(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_and;
+		goto args_common;
+	case BPF_OR:
+		/* void atomic64_or(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_or;
+		goto args_common;
+	case BPF_XOR:
+		/* void atomic64_xor(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_xor;
+		goto args_common;
+	case BPF_ADD:
+		/* void atomic64_add(s64 a, atomic64_t *v) */
+		func_addr = (u32) &atomic64_add;
+args_common:
+		fetch = src;
+		/* Set up dst ptr in tmp reg if conflicting */
+		if (dst == MIPS_R_A0) {
+			emit_instr(ctx, move, LO(MIPS_R_T8), LO(dst));
+			dst = MIPS_R_T8;
+		}
+		/* Move s64 src to arg 1 as needed */
+		if (src != MIPS_R_A0) {
+			emit_instr(ctx, move, LO(MIPS_R_A0), LO(src));
+			emit_instr(ctx, move, HI(MIPS_R_A0), HI(src));
+		}
+		/* Set up dst ptr in arg 2 base register*/
+		emit_instr(ctx, addiu, MIPS_R_A2, LO(dst), mem_off);
+		break;
+	case BPF_XCHG:
+		/* s64 atomic64_xchg(atomic64_t *v, s64 i) */
+		func_addr = (u32) &atomic64_xchg;
+		fetch = src;
+		/* Set up dst ptr in tmp reg if conflicting */
+		if (dst == MIPS_R_A2) {
+			emit_instr(ctx, move, LO(MIPS_R_T8), LO(dst));
+			dst = MIPS_R_T8;
+		}
+		emit_instr(ctx, addiu, MIPS_R_AT, LO(dst), mem_off);
+		/* Move s64 src to arg 2 as needed */
+		if (src != MIPS_R_A2) {
+			emit_instr(ctx, move, LO(MIPS_R_A2), LO(src));
+			emit_instr(ctx, move, HI(MIPS_R_A2), HI(src));
+		}
+		/* Set up dst ptr in arg 1 base register*/
+		emit_instr(ctx, addiu, MIPS_R_A0, LO(dst), mem_off);
+		break;
+	case BPF_CMPXCHG:
+		/* s64 atomic64_cmpxchg(atomic64_t *v, s64 old, s64 new) */
+		func_addr = (u32) &atomic64_cmpxchg;
+		fetch = r0;
+		/* Move s64 src to arg 3 on stack */
+		arg_off = 16;
+		emit_instr(ctx, sw, LO(src), OFFLO(arg_off), MIPS_R_SP);
+		emit_instr(ctx, sw, HI(src), OFFHI(arg_off), MIPS_R_SP);
+		/* Set up dst ptr in arg 1 base register*/
+		emit_instr(ctx, addiu, MIPS_R_A0, LO(dst), mem_off);
+		/* Move s64 R0 to arg 2 */
+		emit_instr(ctx, move, LO(MIPS_R_A2), LO(r0));
+		emit_instr(ctx, move, HI(MIPS_R_A2), HI(r0));
+		break;
+	default:
+		pr_err("ATOMIC OP %02x NOT HANDLED\n", insn->imm);
+		return -EINVAL;
+	}
+
+	emit_const_to_reg(ctx, MIPS_R_T9, func_addr);
+	emit_instr(ctx, jalr, MIPS_R_RA, MIPS_R_T9);
+	/* Delay slot */
+	emit_instr(ctx, nop);
+
+	/* Pop O32 stack */
+	emit_instr(ctx, addiu, MIPS_R_SP, MIPS_R_SP, stack_adj);
+
+	if (insn->imm & BPF_FETCH) {
+		/* Set up returned value */
+		if (fetch != MIPS_R_V0) {
+			emit_instr(ctx, move, LO(fetch), LO(MIPS_R_V0));
+			emit_instr(ctx, move, HI(fetch), HI(MIPS_R_V0));
+		}
+		/* Restore all caller registers except one fetched */
+		if (insn->imm == BPF_CMPXCHG)
+			emit_caller_restore(ctx, BPF_REG_0);
+		else
+			emit_caller_restore(ctx, insn->src_reg);
+	} else {
+		/* Restore all caller registers since none clobbered */
+		emit_caller_restore(ctx, BPF_REG_FP);
+	}
+
+	return 0;
+}
+
+/* Returns the number of insn slots consumed. */
+int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
+		   int this_idx, int exit_idx)
+{
+	/*
+	 * Since CMPXCHG uses R0 implicitly, outside of a passed
+	 * bpf_insn, we fake a lookup to get the MIPS base reg.
+	 */
+	const struct bpf_insn r0_insn = {.src_reg = BPF_REG_0};
+	const int r0 = ebpf_to_mips_reg(ctx, &r0_insn,
+					REG_SRC_NO_FP);
+	const int bpf_class = BPF_CLASS(insn->code);
+	const int bpf_size = BPF_SIZE(insn->code);
+	const int bpf_src = BPF_SRC(insn->code);
+	const int bpf_op = BPF_OP(insn->code);
+	int src, dst, r, mem_off, b_off;
+	bool need_swap, cmp_eq;
+	unsigned int target = 0;
+
+	switch (insn->code) {
+	case BPF_ALU64 | BPF_ADD | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_SUB | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_LSH | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_RSH | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_ARSH | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_XOR | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_MOV | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_OR | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_AND | BPF_K: /* ALU64_IMM */
+	case BPF_ALU | BPF_MOV | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_ADD | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_SUB | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_OR | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_AND | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_LSH | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_RSH | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_XOR | BPF_K: /* ALU32_IMM */
+	case BPF_ALU | BPF_ARSH | BPF_K: /* ALU32_IMM */
+		r = gen_imm_insn(insn, ctx, this_idx);
+		if (r < 0)
+			return r;
+		break;
+	case BPF_ALU64 | BPF_MUL | BPF_K: /* ALU64_IMM */
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+		if (insn->imm == 1) /* Mult by 1 is a nop */
+			break;
+		src = MIPS_R_T8; /* Use tmp reg pair for imm */
+		gen_imm_to_reg(insn, LO(src), ctx);
+		emit_instr(ctx, sra, HI(src), LO(src), 31);
+		goto case_alu64_mul_x;
+
+	case BPF_ALU64 | BPF_NEG | BPF_K: /* ALU64_IMM */
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+		emit_instr(ctx, subu, LO(dst), MIPS_R_ZERO, LO(dst));
+		emit_instr(ctx, subu, HI(dst), MIPS_R_ZERO, HI(dst));
+		emit_instr(ctx, sltu, MIPS_R_AT, MIPS_R_ZERO, LO(dst));
+		emit_instr(ctx, subu, HI(dst), HI(dst), MIPS_R_AT);
+		break;
+	case BPF_ALU | BPF_MUL | BPF_K: /* ALU_IMM */
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+		if (insn->imm == 1) /* Mult by 1 is a nop */
+			break;
+		gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+		if (MIPS_ISA_REV >= 6) {
+			emit_instr(ctx, mulu, LO(dst), LO(dst), MIPS_R_AT);
+		} else {
+			emit_instr(ctx, multu, LO(dst), MIPS_R_AT);
+			emit_instr(ctx, mflo, LO(dst));
+		}
+		break;
+	case BPF_ALU | BPF_NEG | BPF_K: /* ALU_IMM */
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+		emit_instr(ctx, subu, LO(dst), MIPS_R_ZERO, LO(dst));
+		break;
+	case BPF_ALU | BPF_DIV | BPF_K: /* ALU_IMM */
+	case BPF_ALU | BPF_MOD | BPF_K: /* ALU_IMM */
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+		if (insn->imm == 1) {
+			/* div by 1 is a nop, mod by 1 is zero */
+			if (bpf_op == BPF_MOD)
+				emit_instr(ctx, move, LO(dst), MIPS_R_ZERO);
+			break;
+		}
+		gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+		if (MIPS_ISA_REV >= 6) {
+			if (bpf_op == BPF_DIV)
+				emit_instr(ctx, divu_r6, LO(dst),
+							LO(dst), MIPS_R_AT);
+			else
+				emit_instr(ctx, modu, LO(dst),
+							LO(dst), MIPS_R_AT);
+			break;
+		}
+		emit_instr(ctx, divu, LO(dst), MIPS_R_AT);
+		if (bpf_op == BPF_DIV)
+			emit_instr(ctx, mflo, LO(dst));
+		else
+			emit_instr(ctx, mfhi, LO(dst));
+		break;
+	case BPF_ALU64 | BPF_DIV | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_MOD | BPF_K: /* ALU64_IMM */
+	case BPF_ALU64 | BPF_DIV | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_MOD | BPF_X: /* ALU64_REG */
+		r = emit_bpf_divmod64(ctx, insn);
+		if (r < 0)
+			return r;
+		break;
+	case BPF_ALU64 | BPF_MUL | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_ADD | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_SUB | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_MOV | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_XOR | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_OR | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_AND | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_LSH | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_RSH | BPF_X: /* ALU64_REG */
+	case BPF_ALU64 | BPF_ARSH | BPF_X: /* ALU64_REG */
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		switch (bpf_op) {
+		case BPF_MOV:
+			emit_instr(ctx, move, LO(dst), LO(src));
+			emit_instr(ctx, move, HI(dst), HI(src));
+			break;
+		case BPF_ADD:
+			emit_instr(ctx, addu, HI(dst), HI(dst), HI(src));
+			emit_instr(ctx, addu, MIPS_R_AT, LO(dst), LO(src));
+			emit_instr(ctx, sltu, MIPS_R_AT, MIPS_R_AT, LO(dst));
+			emit_instr(ctx, addu, HI(dst), HI(dst), MIPS_R_AT);
+			emit_instr(ctx, addu, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_SUB:
+			emit_instr(ctx, subu, HI(dst), HI(dst), HI(src));
+			emit_instr(ctx, subu, MIPS_R_AT, LO(dst), LO(src));
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), MIPS_R_AT);
+			emit_instr(ctx, subu, HI(dst), HI(dst), MIPS_R_AT);
+			emit_instr(ctx, subu, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_XOR:
+			emit_instr(ctx, xor, LO(dst), LO(dst), LO(src));
+			emit_instr(ctx, xor, HI(dst), HI(dst), HI(src));
+			break;
+		case BPF_OR:
+			emit_instr(ctx, or, LO(dst), LO(dst), LO(src));
+			emit_instr(ctx, or, HI(dst), HI(dst), HI(src));
+			break;
+		case BPF_AND:
+			emit_instr(ctx, and, LO(dst), LO(dst), LO(src));
+			emit_instr(ctx, and, HI(dst), HI(dst), HI(src));
+			break;
+		case BPF_MUL:
+case_alu64_mul_x:
+			emit_instr(ctx, mul, HI(dst), HI(dst), LO(src));
+			emit_instr(ctx, mul, MIPS_R_AT, LO(dst), HI(src));
+			emit_instr(ctx, addu, HI(dst), HI(dst), MIPS_R_AT);
+			if (MIPS_ISA_REV >= 6) {
+				emit_instr(ctx, muhu, MIPS_R_AT, LO(dst), LO(src));
+				emit_instr(ctx, mul, LO(dst), LO(dst), LO(src));
+			} else {
+				emit_instr(ctx, multu, LO(dst), LO(src));
+				emit_instr(ctx, mfhi, MIPS_R_AT);
+				emit_instr(ctx, mflo, LO(dst));
+			}
+			emit_instr(ctx, addu, HI(dst), HI(dst), MIPS_R_AT);
+			break;
+		case BPF_LSH:
+			emit_instr(ctx, beqz, LO(src), 11 * 4);
+			emit_instr(ctx, addiu, MIPS_R_AT, LO(src), -32);
+			emit_instr(ctx, bltz, MIPS_R_AT, 4 * 4);
+			emit_instr(ctx, nop);
+			emit_instr(ctx, sllv, HI(dst), LO(dst), MIPS_R_AT);
+			emit_instr(ctx, and, LO(dst), LO(dst), MIPS_R_ZERO);
+			emit_instr(ctx, b, 5 * 4);
+			emit_instr(ctx, subu, MIPS_R_AT, MIPS_R_ZERO, MIPS_R_AT);
+			emit_instr(ctx, srlv, MIPS_R_AT, LO(dst), MIPS_R_AT);
+			emit_instr(ctx, sllv, HI(dst), HI(dst), LO(src));
+			emit_instr(ctx, sllv, LO(dst), LO(dst), LO(src));
+			emit_instr(ctx, or, HI(dst), HI(dst), MIPS_R_AT);
+			break;
+		case BPF_RSH:
+			emit_instr(ctx, beqz, LO(src), 11 * 4);
+			emit_instr(ctx, addiu, MIPS_R_AT, LO(src), -32);
+			emit_instr(ctx, bltz, MIPS_R_AT, 4 * 4);
+			emit_instr(ctx, nop);
+			emit_instr(ctx, srlv, LO(dst), HI(dst), MIPS_R_AT);
+			emit_instr(ctx, and, HI(dst), HI(dst), MIPS_R_ZERO);
+			emit_instr(ctx, b, 5 * 4);
+			emit_instr(ctx, subu, MIPS_R_AT, MIPS_R_ZERO, MIPS_R_AT);
+			emit_instr(ctx, sllv, MIPS_R_AT, HI(dst), MIPS_R_AT);
+			emit_instr(ctx, srlv, HI(dst), HI(dst), LO(src));
+			emit_instr(ctx, srlv, LO(dst), LO(dst), LO(src));
+			emit_instr(ctx, or, LO(dst), LO(dst), MIPS_R_AT);
+			break;
+		case BPF_ARSH:
+			emit_instr(ctx, beqz, LO(src), 11 * 4);
+			emit_instr(ctx, addiu, MIPS_R_AT, LO(src), -32);
+			emit_instr(ctx, bltz, MIPS_R_AT, 4 * 4);
+			emit_instr(ctx, nop);
+			emit_instr(ctx, srav, LO(dst), HI(dst), MIPS_R_AT);
+			emit_instr(ctx, sra, HI(dst), HI(dst), 31);
+			emit_instr(ctx, b, 5 * 4);
+			emit_instr(ctx, subu, MIPS_R_AT, MIPS_R_ZERO, MIPS_R_AT);
+			emit_instr(ctx, sllv, MIPS_R_AT, HI(dst), MIPS_R_AT);
+			emit_instr(ctx, srav, HI(dst), HI(dst), LO(src));
+			emit_instr(ctx, srlv, LO(dst), LO(dst), LO(src));
+			emit_instr(ctx, or, LO(dst), LO(dst), MIPS_R_AT);
+			break;
+		default:
+			pr_err("ALU64_REG NOT HANDLED\n");
+			return -EINVAL;
+		}
+		break;
+	case BPF_ALU | BPF_MOV | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_ADD | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_SUB | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_XOR | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_OR | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_AND | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_MUL | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_DIV | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_MOD | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_LSH | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_RSH | BPF_X: /* ALU_REG */
+	case BPF_ALU | BPF_ARSH | BPF_X: /* ALU_REG */
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		/* Special BPF_MOV zext insn from verifier. */
+		if (insn_is_zext(insn)) {
+			gen_zext_insn(dst, true, ctx);
+			break;
+		}
+		switch (bpf_op) {
+		case BPF_MOV:
+			emit_instr(ctx, move, LO(dst), LO(src));
+			break;
+		case BPF_ADD:
+			emit_instr(ctx, addu, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_SUB:
+			emit_instr(ctx, subu, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_XOR:
+			emit_instr(ctx, xor, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_OR:
+			emit_instr(ctx, or, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_AND:
+			emit_instr(ctx, and, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_MUL:
+			emit_instr(ctx, mul, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_DIV:
+		case BPF_MOD:
+			if (MIPS_ISA_REV >= 6) {
+				if (bpf_op == BPF_DIV)
+					emit_instr(ctx, divu_r6, LO(dst),
+							LO(dst), LO(src));
+				else
+					emit_instr(ctx, modu, LO(dst),
+							LO(dst), LO(src));
+				break;
+			}
+			emit_instr(ctx, divu, LO(dst), LO(src));
+			if (bpf_op == BPF_DIV)
+				emit_instr(ctx, mflo, LO(dst));
+			else
+				emit_instr(ctx, mfhi, LO(dst));
+			break;
+		case BPF_LSH:
+			emit_instr(ctx, sllv, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_RSH:
+			emit_instr(ctx, srlv, LO(dst), LO(dst), LO(src));
+			break;
+		case BPF_ARSH:
+			emit_instr(ctx, srav, LO(dst), LO(dst), LO(src));
+			break;
+		default:
+			pr_err("ALU_REG NOT HANDLED\n");
+			return -EINVAL;
+		}
+		break;
+	case BPF_JMP | BPF_EXIT:
+		if (this_idx + 1 < exit_idx) {
+			b_off = b_imm(exit_idx, ctx);
+			if (is_bad_offset(b_off)) {
+				target = j_target(ctx, exit_idx);
+				if (target == (unsigned int)-1)
+					return -E2BIG;
+				emit_instr(ctx, j, target);
+			} else {
+				emit_instr(ctx, b, b_off);
+			}
+			emit_instr(ctx, nop);
+		}
+		break;
+	case BPF_JMP32 | BPF_JSLT | BPF_X:
+	case BPF_JMP32 | BPF_JSLE | BPF_X:
+	case BPF_JMP32 | BPF_JSGT | BPF_X:
+	case BPF_JMP32 | BPF_JSGE | BPF_X:
+	case BPF_JMP32 | BPF_JSGT | BPF_K:
+	case BPF_JMP32 | BPF_JSGE | BPF_K:
+	case BPF_JMP32 | BPF_JSLT | BPF_K:
+	case BPF_JMP32 | BPF_JSLE | BPF_K:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return -EINVAL;
+
+		if (bpf_src == BPF_X) {
+			src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+			if (src < 0)
+				return -EINVAL;
+		} else if (insn->imm == 0) { /* and BPF_K */
+			src = MIPS_R_ZERO;
+		} else {
+			src = MIPS_R_T8;
+			gen_imm_to_reg(insn, LO(src), ctx);
+		}
+
+		cmp_eq = bpf_op == BPF_JSLE || bpf_op == BPF_JSGE;
+		switch (bpf_op) {
+		case BPF_JSGE:
+			emit_instr(ctx, slt, MIPS_R_AT, LO(dst), LO(src));
+			break;
+		case BPF_JSLT:
+			emit_instr(ctx, slt, MIPS_R_AT, LO(dst), LO(src));
+			break;
+		case BPF_JSGT:
+			emit_instr(ctx, slt, MIPS_R_AT, LO(src), LO(dst));
+			break;
+		case BPF_JSLE:
+			emit_instr(ctx, slt, MIPS_R_AT, LO(src), LO(dst));
+			break;
+		}
+
+		src = MIPS_R_AT;
+		dst = MIPS_R_ZERO;
+		goto jeq_common;
+
+	case BPF_JMP | BPF_JSLT | BPF_X:
+	case BPF_JMP | BPF_JSLE | BPF_X:
+	case BPF_JMP | BPF_JSGT | BPF_X:
+	case BPF_JMP | BPF_JSGE | BPF_X:
+	case BPF_JMP | BPF_JSGT | BPF_K:
+	case BPF_JMP | BPF_JSGE | BPF_K:
+	case BPF_JMP | BPF_JSLT | BPF_K:
+	case BPF_JMP | BPF_JSLE | BPF_K:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return -EINVAL;
+
+		if (bpf_src == BPF_X) {
+			src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+			if (src < 0)
+				return -EINVAL;
+		} else if (insn->imm == 0) { /* and BPF_K */
+			src = MIPS_R_ZERO;
+		} else {
+			src = MIPS_R_T8;
+			gen_imm_to_reg(insn, LO(src), ctx);
+			if (insn->imm < 0)
+				gen_sext_insn(src, ctx);
+			else
+				gen_zext_insn(src, true, ctx);
+		}
+
+		cmp_eq = bpf_op == BPF_JSGT || bpf_op == BPF_JSGE;
+
+		if (bpf_op == BPF_JSGT || bpf_op == BPF_JSLE) {
+			/* Check dst <= src */
+			emit_instr(ctx, bne, HI(dst), HI(src), 4 * 4);
+			/* Delay slot */
+			emit_instr(ctx, slt, MIPS_R_AT, HI(dst), HI(src));
+			emit_instr(ctx, bne, LO(dst), LO(src), 2 * 4);
+			/* Delay slot */
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), LO(src));
+			emit_instr(ctx, nor, MIPS_R_AT, MIPS_R_ZERO, MIPS_R_AT);
+		} else {
+			/* Check dst < src */
+			emit_instr(ctx, bne, HI(dst), HI(src), 2 * 4);
+			/* Delay slot */
+			emit_instr(ctx, slt, MIPS_R_AT, HI(dst), HI(src));
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), LO(src));
+		}
+
+		src = MIPS_R_AT;
+		dst = MIPS_R_ZERO;
+		goto jeq_common;
+
+	case BPF_JMP | BPF_JLT | BPF_X:
+	case BPF_JMP | BPF_JLE | BPF_X:
+	case BPF_JMP | BPF_JGT | BPF_X:
+	case BPF_JMP | BPF_JGE | BPF_X:
+	case BPF_JMP | BPF_JGT | BPF_K:
+	case BPF_JMP | BPF_JGE | BPF_K:
+	case BPF_JMP | BPF_JLT | BPF_K:
+	case BPF_JMP | BPF_JLE | BPF_K:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return -EINVAL;
+
+		if (bpf_src == BPF_X) {
+			src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+			if (src < 0)
+				return -EINVAL;
+		} else if (insn->imm == 0) { /* and BPF_K */
+			src = MIPS_R_ZERO;
+		} else {
+			src = MIPS_R_T8;
+			gen_imm_to_reg(insn, LO(src), ctx);
+			if (insn->imm < 0)
+				gen_sext_insn(src, ctx);
+			else
+				gen_zext_insn(src, true, ctx);
+		}
+
+		cmp_eq = bpf_op == BPF_JGT || bpf_op == BPF_JGE;
+
+		if (bpf_op == BPF_JGT || bpf_op == BPF_JLE) {
+			/* Check dst <= src */
+			emit_instr(ctx, bne, HI(dst), HI(src), 4 * 4);
+			/* Delay slot */
+			emit_instr(ctx, sltu, MIPS_R_AT, HI(dst), HI(src));
+			emit_instr(ctx, bne, LO(dst), LO(src), 2 * 4);
+			/* Delay slot */
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), LO(src));
+			emit_instr(ctx, nor, MIPS_R_AT, MIPS_R_ZERO, MIPS_R_AT);
+		} else {
+			/* Check dst < src */
+			emit_instr(ctx, bne, HI(dst), HI(src), 2 * 4);
+			/* Delay slot */
+			emit_instr(ctx, sltu, MIPS_R_AT, HI(dst), HI(src));
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), LO(src));
+		}
+
+		src = MIPS_R_AT;
+		dst = MIPS_R_ZERO;
+		goto jeq_common;
+
+	case BPF_JMP32 | BPF_JLT | BPF_X:
+	case BPF_JMP32 | BPF_JLE | BPF_X:
+	case BPF_JMP32 | BPF_JGT | BPF_X:
+	case BPF_JMP32 | BPF_JGE | BPF_X:
+	case BPF_JMP32 | BPF_JGT | BPF_K:
+	case BPF_JMP32 | BPF_JGE | BPF_K:
+	case BPF_JMP32 | BPF_JLT | BPF_K:
+	case BPF_JMP32 | BPF_JLE | BPF_K:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return -EINVAL;
+
+		if (bpf_src == BPF_X) {
+			src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+			if (src < 0)
+				return -EINVAL;
+		} else if (insn->imm == 0) { /* and BPF_K */
+			src = MIPS_R_ZERO;
+		} else {
+			src = MIPS_R_T8;
+			gen_imm_to_reg(insn, LO(src), ctx);
+		}
+
+		cmp_eq = bpf_op == BPF_JLE || bpf_op == BPF_JGE;
+		switch (bpf_op) {
+		case BPF_JGE:
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), LO(src));
+			break;
+		case BPF_JLT:
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(dst), LO(src));
+			break;
+		case BPF_JGT:
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(src), LO(dst));
+			break;
+		case BPF_JLE:
+			emit_instr(ctx, sltu, MIPS_R_AT, LO(src), LO(dst));
+			break;
+		}
+
+		src = MIPS_R_AT;
+		dst = MIPS_R_ZERO;
+		goto jeq_common;
+
+	case BPF_JMP | BPF_JEQ | BPF_X: /* JMP_REG */
+	case BPF_JMP | BPF_JNE | BPF_X:
+	case BPF_JMP32 | BPF_JEQ | BPF_X:
+	case BPF_JMP32 | BPF_JNE | BPF_X:
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+
+		cmp_eq = (bpf_op == BPF_JEQ);
+		if (bpf_class == BPF_JMP) {
+			emit_instr(ctx, beq, HI(dst), HI(src), 2 * 4);
+			/* Delay slot */
+			emit_instr(ctx, move, MIPS_R_AT, LO(src));
+			/* Make low words unequal if high word unequal. */
+			emit_instr(ctx, addu, MIPS_R_AT, LO(dst), MIPS_R_SP);
+			dst = LO(dst);
+			src = MIPS_R_AT;
+		} else { /* BPF_JMP32 */
+			dst = LO(dst);
+			src = LO(src);
+		}
+		goto jeq_common;
+
+	case BPF_JMP | BPF_JSET | BPF_X: /* JMP_REG */
+	case BPF_JMP32 | BPF_JSET | BPF_X:
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		emit_instr(ctx, and, MIPS_R_AT, LO(dst), LO(src));
+		if (bpf_class == BPF_JMP) {
+			emit_instr(ctx, and, MIPS_R_T8, HI(dst), HI(src));
+			emit_instr(ctx, or, MIPS_R_AT, MIPS_R_AT, MIPS_R_T8);
+		}
+		cmp_eq = false;
+		dst = MIPS_R_AT;
+		src = MIPS_R_ZERO;
+jeq_common:
+		/*
+		 * If the next insn is EXIT and we are jumping arround
+		 * only it, invert the sense of the compare and
+		 * conditionally jump to the exit.  Poor man's branch
+		 * chaining.
+		 */
+		if ((insn + 1)->code == (BPF_JMP | BPF_EXIT) && insn->off == 1) {
+			b_off = b_imm(exit_idx, ctx);
+			if (is_bad_offset(b_off)) {
+				target = j_target(ctx, exit_idx);
+				if (target == (unsigned int)-1)
+					return -E2BIG;
+				cmp_eq = !cmp_eq;
+				b_off = 4 * 3;
+				if (!(ctx->offsets[this_idx] & OFFSETS_B_CONV)) {
+					ctx->offsets[this_idx] |= OFFSETS_B_CONV;
+					ctx->long_b_conversion = 1;
+				}
+			}
+
+			if (cmp_eq)
+				emit_instr(ctx, bne, dst, src, b_off);
+			else
+				emit_instr(ctx, beq, dst, src, b_off);
+			emit_instr(ctx, nop);
+			if (ctx->offsets[this_idx] & OFFSETS_B_CONV) {
+				emit_instr(ctx, j, target);
+				emit_instr(ctx, nop);
+			}
+			return 2; /* We consumed the exit. */
+		}
+		b_off = b_imm(this_idx + insn->off + 1, ctx);
+		if (is_bad_offset(b_off)) {
+			target = j_target(ctx, this_idx + insn->off + 1);
+			if (target == (unsigned int)-1)
+				return -E2BIG;
+			cmp_eq = !cmp_eq;
+			b_off = 4 * 3;
+			if (!(ctx->offsets[this_idx] & OFFSETS_B_CONV)) {
+				ctx->offsets[this_idx] |= OFFSETS_B_CONV;
+				ctx->long_b_conversion = 1;
+			}
+		}
+
+		if (cmp_eq)
+			emit_instr(ctx, beq, dst, src, b_off);
+		else
+			emit_instr(ctx, bne, dst, src, b_off);
+		emit_instr(ctx, nop);
+		if (ctx->offsets[this_idx] & OFFSETS_B_CONV) {
+			emit_instr(ctx, j, target);
+			emit_instr(ctx, nop);
+		}
+		break;
+
+	case BPF_JMP | BPF_JEQ | BPF_K: /* JMP_IMM */
+	case BPF_JMP | BPF_JNE | BPF_K: /* JMP_IMM */
+	case BPF_JMP32 | BPF_JEQ | BPF_K: /* JMP_IMM */
+	case BPF_JMP32 | BPF_JNE | BPF_K: /* JMP_IMM */
+		cmp_eq = (bpf_op == BPF_JEQ);
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		if (dst < 0)
+			return dst;
+		if (insn->imm == 0) {
+			src = MIPS_R_ZERO;
+			if (bpf_class == BPF_JMP32) {
+				dst = LO(dst);
+			} else { /* BPF_JMP */
+				emit_instr(ctx, or, MIPS_R_AT, LO(dst), HI(dst));
+				dst = MIPS_R_AT;
+			}
+		} else if (bpf_class == BPF_JMP32) {
+			gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+			src = MIPS_R_AT;
+			dst = LO(dst);
+		} else { /* BPF_JMP */
+			gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+			/* If low words equal, check high word vs imm sign. */
+			emit_instr(ctx, beq, LO(dst), MIPS_R_AT, 2 * 4);
+			emit_instr(ctx, nop);
+			/* Make high word signs unequal if low words unequal. */
+			emit_instr(ctx, nor, MIPS_R_AT, MIPS_R_ZERO, HI(dst));
+			emit_instr(ctx, sra, MIPS_R_AT, MIPS_R_AT, 31);
+			src = MIPS_R_AT;
+			dst = HI(dst);
+		}
+		goto jeq_common;
+
+	case BPF_JMP | BPF_JSET | BPF_K: /* JMP_IMM */
+	case BPF_JMP32 | BPF_JSET | BPF_K: /* JMP_IMM */
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+
+		gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+		emit_instr(ctx, and, MIPS_R_AT, LO(dst), MIPS_R_AT);
+		if (bpf_class == BPF_JMP && insn->imm < 0)
+			emit_instr(ctx, or, MIPS_R_AT, MIPS_R_AT, HI(dst));
+		src = MIPS_R_AT;
+		dst = MIPS_R_ZERO;
+		cmp_eq = false;
+		goto jeq_common;
+
+	case BPF_JMP | BPF_JA:
+		/*
+		 * Prefer relative branch for easier debugging, but
+		 * fall back if needed.
+		 */
+		b_off = b_imm(this_idx + insn->off + 1, ctx);
+		if (is_bad_offset(b_off)) {
+			target = j_target(ctx, this_idx + insn->off + 1);
+			if (target == (unsigned int)-1)
+				return -E2BIG;
+			emit_instr(ctx, j, target);
+		} else {
+			emit_instr(ctx, b, b_off);
+		}
+		emit_instr(ctx, nop);
+		break;
+	case BPF_LD | BPF_DW | BPF_IMM:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+		gen_imm_to_reg(insn, LO(dst), ctx);
+		gen_imm_to_reg(insn+1, HI(dst), ctx);
+		return 2; /* Double slot insn */
+
+	case BPF_JMP | BPF_CALL:
+		emit_bpf_call(ctx, insn);
+		break;
+	case BPF_JMP | BPF_TAIL_CALL:
+		if (emit_bpf_tail_call(ctx, this_idx))
+			return -EINVAL;
+		break;
+
+	case BPF_ALU | BPF_END | BPF_FROM_BE:
+	case BPF_ALU | BPF_END | BPF_FROM_LE:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return dst;
+#ifdef __BIG_ENDIAN
+		need_swap = (bpf_src == BPF_FROM_LE);
+#else
+		need_swap = (bpf_src == BPF_FROM_BE);
+#endif
+		if (insn->imm == 16) {
+			if (need_swap)
+				emit_instr(ctx, wsbh, LO(dst), LO(dst));
+			emit_instr(ctx, andi, LO(dst), LO(dst), 0xffff);
+		} else if (insn->imm == 32) {
+			if (need_swap) {
+				emit_instr(ctx, wsbh, LO(dst), LO(dst));
+				emit_instr(ctx, rotr, LO(dst), LO(dst), 16);
+			}
+		} else { /* 64-bit*/
+			if (need_swap) {
+				emit_instr(ctx, wsbh, MIPS_R_AT, LO(dst));
+				emit_instr(ctx, wsbh, LO(dst), HI(dst));
+				emit_instr(ctx, rotr, HI(dst), MIPS_R_AT, 16);
+				emit_instr(ctx, rotr, LO(dst), LO(dst), 16);
+			}
+		}
+		break;
+
+	case BPF_ST | BPF_NOSPEC: /* speculation barrier */
+		break;
+
+	case BPF_ST | BPF_B | BPF_MEM:
+	case BPF_ST | BPF_H | BPF_MEM:
+	case BPF_ST | BPF_W | BPF_MEM:
+	case BPF_ST | BPF_DW | BPF_MEM:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		if (dst < 0)
+			return -EINVAL;
+		mem_off = insn->off;
+		gen_imm_to_reg(insn, MIPS_R_AT, ctx);
+
+		switch (bpf_size) {
+		case BPF_B:
+			emit_instr(ctx, sb, MIPS_R_AT, mem_off, LO(dst));
+			break;
+		case BPF_H:
+			emit_instr(ctx, sh, MIPS_R_AT, mem_off, LO(dst));
+			break;
+		case BPF_W:
+			emit_instr(ctx, sw, MIPS_R_AT, mem_off, LO(dst));
+			break;
+		case BPF_DW:
+			/* Memory order == register order in pair */
+			emit_instr(ctx, sw, MIPS_R_AT, OFFLO(mem_off), LO(dst));
+			if (insn->imm < 0) {
+				emit_instr(ctx, nor, MIPS_R_AT,
+						MIPS_R_ZERO, MIPS_R_ZERO);
+				emit_instr(ctx, sw, MIPS_R_AT,
+						OFFHI(mem_off), LO(dst));
+			} else {
+				emit_instr(ctx, sw, MIPS_R_ZERO,
+						OFFHI(mem_off), LO(dst));
+			}
+			break;
+		}
+		break;
+
+	case BPF_LDX | BPF_B | BPF_MEM:
+	case BPF_LDX | BPF_H | BPF_MEM:
+	case BPF_LDX | BPF_W | BPF_MEM:
+	case BPF_LDX | BPF_DW | BPF_MEM:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		mem_off = insn->off;
+
+		switch (bpf_size) {
+		case BPF_B:
+			emit_instr(ctx, lbu, LO(dst), mem_off, LO(src));
+			break;
+		case BPF_H:
+			emit_instr(ctx, lhu, LO(dst), mem_off, LO(src));
+			break;
+		case BPF_W:
+			emit_instr(ctx, lw, LO(dst), mem_off, LO(src));
+			break;
+		case BPF_DW:
+			/*
+			 * Careful: update HI(dst) first in case dst == src,
+			 * since only LO(src) is the usable pointer.
+			 */
+			emit_instr(ctx, lw, HI(dst), OFFHI(mem_off), LO(src));
+			emit_instr(ctx, lw, LO(dst), OFFLO(mem_off), LO(src));
+			break;
+		}
+		break;
+
+	case BPF_STX | BPF_DW | BPF_ATOMIC:
+		r = emit_bpf_atomic64(ctx, insn);
+		if (r < 0)
+			return r;
+		break;
+	case BPF_STX | BPF_W | BPF_ATOMIC:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		mem_off = insn->off;
+		/*
+		 * Drop reg pair scheme for more efficient temp register usage
+		 * given BPF_W mode.
+		 */
+		dst = LO(dst);
+		src = LO(src);
+		/*
+		 * If mem_off does not fit within the 9 bit ll/sc instruction
+		 * immediate field, use a temp reg.
+		 */
+		if (MIPS_ISA_REV >= 6 &&
+		    (mem_off >= BIT(8) || mem_off < -BIT(8))) {
+			emit_instr(ctx, addiu, MIPS_R_T9, dst, mem_off);
+			mem_off = 0;
+			dst = MIPS_R_T9;
+		}
+		/* Track variable branch offset due to CMPXCHG. */
+		b_off = ctx->idx;
+		emit_instr(ctx, ll, MIPS_R_AT, mem_off, dst);
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
+			emit_instr(ctx, addu, MIPS_R_T8, MIPS_R_AT, src);
+			break;
+		case BPF_XCHG:
+			emit_instr(ctx, move, MIPS_R_T8, src);
+			break;
+		case BPF_CMPXCHG:
+			/*
+			 * If R0 != old_val then break out of LL/SC loop
+			 */
+			emit_instr(ctx, bne, LO(r0), MIPS_R_AT, 4 * 4);
+			/* Delay slot */
+			emit_instr(ctx, move, MIPS_R_T8, src);
+			/* Return old_val in R0 */
+			src = LO(r0);
+			break;
+		default:
+			pr_err("ATOMIC OP %02x NOT HANDLED\n", insn->imm);
+			return -EINVAL;
+		}
+		emit_instr(ctx, sc, MIPS_R_T8, mem_off, dst);
+		/*
+		 * On failure back up to LL (calculate # insns)
+		 */
+		b_off = (b_off - ctx->idx - 1) * 4;
+		emit_instr(ctx, beqz, MIPS_R_AT, b_off);
+		emit_instr(ctx, nop);
+		/*
+		 * Using fetch returns old value in src or R0
+		 */
+		if (insn->imm & BPF_FETCH)
+			emit_instr(ctx, move, src, MIPS_R_AT);
+		break;
+
+	case BPF_STX | BPF_DW | BPF_MEM:
+	case BPF_STX | BPF_B | BPF_MEM:
+	case BPF_STX | BPF_H | BPF_MEM:
+	case BPF_STX | BPF_W | BPF_MEM:
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_FP_OK);
+		src = ebpf_to_mips_reg(ctx, insn, REG_SRC_FP_OK);
+		if (src < 0 || dst < 0)
+			return -EINVAL;
+		mem_off = insn->off;
+
+		switch (bpf_size) {
+		case BPF_B:
+			emit_instr(ctx, sb, LO(src), mem_off, LO(dst));
+			break;
+		case BPF_H:
+			emit_instr(ctx, sh, LO(src), mem_off, LO(dst));
+			break;
+		case BPF_W:
+			emit_instr(ctx, sw, LO(src), mem_off, LO(dst));
+			break;
+		case BPF_DW:
+			emit_instr(ctx, sw, HI(src), OFFHI(mem_off), LO(dst));
+			emit_instr(ctx, sw, LO(src), OFFLO(mem_off), LO(dst));
+			break;
+		}
+		break;
+
+	default:
+		pr_err("NOT HANDLED %d - (%02x)\n",
+		       this_idx, (unsigned int)insn->code);
+		return -EINVAL;
+	}
+	/*
+	 * Handle zero-extension if the verifier is unable to patch and
+	 * insert it's own special zext insns.
+	 */
+	if ((bpf_class == BPF_ALU && !(bpf_op == BPF_END && insn->imm == 64)) ||
+	    (bpf_class == BPF_LDX && bpf_size != BPF_DW)) {
+		dst = ebpf_to_mips_reg(ctx, insn, REG_DST_NO_FP);
+		if (dst < 0)
+			return -EINVAL;
+		gen_zext_insn(dst, false, ctx);
+	}
+	if (insn->code == (BPF_STX|BPF_ATOMIC|BPF_W) && insn->imm & BPF_FETCH) {
+		if (insn->imm == BPF_CMPXCHG) {
+			gen_zext_insn(r0, false, ctx);
+		} else {
+			src = ebpf_to_mips_reg(ctx, insn, REG_SRC_NO_FP);
+			if (src < 0)
+				return -EINVAL;
+			gen_zext_insn(src, false, ctx);
+		}
+	}
+
+	return 1;
+}
+
+/* Enable the verifier to insert zext insn for ALU32 ops as needed. */
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
diff --git a/arch/mips/net/ebpf_jit_core.c b/arch/mips/net/ebpf_jit_core.c
index 37b496f47ddb..6eac8150ce2a 100644
--- a/arch/mips/net/ebpf_jit_core.c
+++ b/arch/mips/net/ebpf_jit_core.c
@@ -637,7 +637,8 @@ static int build_int_body(struct jit_ctx *ctx)
 
 	for (i = 0; i < prog->len; ) {
 		insn = prog->insnsi + i;
-		if ((ctx->reg_val_types[i] & RVT_VISITED_MASK) == 0) {
+		if (is64bit() && (ctx->reg_val_types[i] &
+				  RVT_VISITED_MASK) == 0) {
 			/* dead instruction, don't emit it. */
 			i++;
 			continue;
@@ -1080,14 +1081,17 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		preempt_enable();
 	}
 
-	ctx->reg_val_types = kcalloc(prog->len + 1,
-				     sizeof(*ctx->reg_val_types),
-				     GFP_KERNEL);
-	if (!ctx->reg_val_types)
-		goto out_err;
+	/* Static analysis only used for MIPS64. */
+	if (is64bit()) {
+		ctx->reg_val_types = kcalloc(prog->len + 1,
+					     sizeof(*ctx->reg_val_types),
+					     GFP_KERNEL);
+		if (!ctx->reg_val_types)
+			goto out_err;
 
-	if (reg_val_propagate(ctx))
-		goto out_err;
+		if (reg_val_propagate(ctx))
+			goto out_err;
+	}
 
 	/*
 	 * First pass discovers used resources and instruction offsets
-- 
2.25.1

