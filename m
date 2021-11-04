Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB106444D1E
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhKDBxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:53:12 -0400
Received: from mail.loongson.cn ([114.242.206.163]:59068 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230198AbhKDBxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 21:53:10 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx72pVPINh2_EkAA--.41908S2;
        Thu, 04 Nov 2021 09:50:14 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, illusionist.neo@gmail.com,
        zlim.lnx@gmail.com, naveen.n.rao@linux.ibm.com,
        luke.r.nels@gmail.com, xi.wang@gmail.com, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        udknight@gmail.com, davem@davemloft.net
Subject: [PATCH bpf-next v5] bpf: Change value of MAX_TAIL_CALL_CNT from 32 to 33
Date:   Thu,  4 Nov 2021 09:50:10 +0800
Message-Id: <1635990610-4448-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9Dx72pVPINh2_EkAA--.41908S2
X-Coremail-Antispam: 1UD129KBjvAXoW3tFy3XF15Cw17Gw47GryfWFg_yoW8Wry7to
        W8tr1v9a1rK34UWF1akwn3GryDJ3WxKayfAw4IgF4ru3ZFva4YyrW7Xa1DXFyFqa45Gr1D
        Wryfta1UXFsxKFyDn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI
        0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80
        ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4
        AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY
        1x02628vn2kIc2xKxwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbl4EtUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current code, the actual max tail call count is 33 which is greater
than MAX_TAIL_CALL_CNT (defined as 32), the actual limit is not consistent
with the meaning of MAX_TAIL_CALL_CNT, there is some confusion and need to
spend some time to think about the reason at the first glance.

We can see the historical evolution from commit 04fd61ab36ec ("bpf: allow
bpf programs to tail-call other bpf programs") and commit f9dabe016b63
("bpf: Undo off-by-one in interpreter tail call count limit").

In order to avoid changing existing behavior, the actual limit is 33 now,
this is reasonable.

After commit 874be05f525e ("bpf, tests: Add tail call test suite"), we can
see there exists failed testcase.

On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
 # echo 0 > /proc/sys/net/core/bpf_jit_enable
 # modprobe test_bpf
 # dmesg | grep -w FAIL
 Tail call error path, max count reached jited:0 ret 34 != 33 FAIL

On some archs:
 # echo 1 > /proc/sys/net/core/bpf_jit_enable
 # modprobe test_bpf
 # dmesg | grep -w FAIL
 Tail call error path, max count reached jited:1 ret 34 != 33 FAIL

Although the above failed testcase has been fixed in commit 18935a72eb25
("bpf/tests: Fix error in tail call limit tests"), it is still necessary
to change the value of MAX_TAIL_CALL_CNT from 32 to 33 to make the code
more readable, then do some small changes of the related code.

With this patch, it does not change the current limit 33, MAX_TAIL_CALL_CNT
can reflect the actual max tail call count, the related tailcall testcases
in test_bpf and selftests can work well for the interpreter and the JIT.

Here are the test results on x86_64:

 # uname -m
 x86_64
 # echo 0 > /proc/sys/net/core/bpf_jit_enable
 # modprobe test_bpf test_suite=test_tail_calls
 # dmesg | tail -1
 test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [0/8 JIT'ed]
 # rmmod test_bpf
 # echo 1 > /proc/sys/net/core/bpf_jit_enable
 # modprobe test_bpf test_suite=test_tail_calls
 # dmesg | tail -1
 test_bpf: test_tail_calls: Summary: 8 PASSED, 0 FAILED, [8/8 JIT'ed]
 # rmmod test_bpf
 # ./test_progs -t tailcalls
 #142 tailcalls:OK
 Summary: 1/11 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Björn Töpel <bjorn@kernel.org>
---

v5: Use RV_REG_TCC directly to save one move for RISC-V,
    suggested by Björn Töpel, thank you.

v4: Use >= as check condition,
    suggested by Daniel Borkmann, thank you.

 arch/arm/net/bpf_jit_32.c         |  5 +++--
 arch/arm64/net/bpf_jit_comp.c     |  5 +++--
 arch/mips/net/bpf_jit_comp32.c    |  2 +-
 arch/mips/net/bpf_jit_comp64.c    |  2 +-
 arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
 arch/powerpc/net/bpf_jit_comp64.c |  4 ++--
 arch/riscv/net/bpf_jit_comp32.c   |  6 ++----
 arch/riscv/net/bpf_jit_comp64.c   |  7 +++----
 arch/s390/net/bpf_jit_comp.c      |  6 +++---
 arch/sparc/net/bpf_jit_comp_64.c  |  2 +-
 arch/x86/net/bpf_jit_comp.c       | 10 +++++-----
 arch/x86/net/bpf_jit_comp32.c     |  4 ++--
 include/linux/bpf.h               |  2 +-
 include/uapi/linux/bpf.h          |  2 +-
 kernel/bpf/core.c                 |  3 ++-
 lib/test_bpf.c                    |  4 ++--
 tools/include/uapi/linux/bpf.h    |  2 +-
 17 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index eeb6dc0..e59b41e 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1199,7 +1199,8 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 
 	/* tmp2[0] = array, tmp2[1] = index */
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	/*
+	 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 * tail_call_cnt++;
 	 */
@@ -1208,7 +1209,7 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	tc = arm_bpf_get_reg64(tcc, tmp, ctx);
 	emit(ARM_CMP_I(tc[0], hi), ctx);
 	_emit(ARM_COND_EQ, ARM_CMP_I(tc[1], lo), ctx);
-	_emit(ARM_COND_HI, ARM_B(jmp_offset), ctx);
+	_emit(ARM_COND_CS, ARM_B(jmp_offset), ctx);
 	emit(ARM_ADDS_I(tc[1], tc[1], 1), ctx);
 	emit(ARM_ADC_I(tc[0], tc[0], 0), ctx);
 	arm_bpf_put_reg64(tcc, tmp, ctx);
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 3a8a714..356fb21 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -287,13 +287,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	emit(A64_CMP(0, r3, tmp), ctx);
 	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	/*
+	 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
 	 *     goto out;
 	 * tail_call_cnt++;
 	 */
 	emit_a64_mov_i64(tmp, MAX_TAIL_CALL_CNT, ctx);
 	emit(A64_CMP(1, tcc, tmp), ctx);
-	emit(A64_B_(A64_COND_HI, jmp_offset), ctx);
+	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
 	emit(A64_ADD_I(1, tcc, tcc, 1), ctx);
 
 	/* prog = array->ptrs[index];
diff --git a/arch/mips/net/bpf_jit_comp32.c b/arch/mips/net/bpf_jit_comp32.c
index bd996ed..a7b424f 100644
--- a/arch/mips/net/bpf_jit_comp32.c
+++ b/arch/mips/net/bpf_jit_comp32.c
@@ -1382,7 +1382,7 @@ void build_prologue(struct jit_context *ctx)
 	 * calling function jumps into the prologue after these instructions.
 	 */
 	emit(ctx, ori, MIPS_R_T9, MIPS_R_ZERO,
-	     min(MAX_TAIL_CALL_CNT + 1, 0xffff));
+	     min(MAX_TAIL_CALL_CNT, 0xffff));
 	emit(ctx, sw, MIPS_R_T9, 0, MIPS_R_SP);
 
 	/*
diff --git a/arch/mips/net/bpf_jit_comp64.c b/arch/mips/net/bpf_jit_comp64.c
index 815ade7..5ef8778 100644
--- a/arch/mips/net/bpf_jit_comp64.c
+++ b/arch/mips/net/bpf_jit_comp64.c
@@ -552,7 +552,7 @@ void build_prologue(struct jit_context *ctx)
 	 * On a tail call, the calling function jumps into the prologue
 	 * after this instruction.
 	 */
-	emit(ctx, addiu, tc, MIPS_R_ZERO, min(MAX_TAIL_CALL_CNT + 1, 0xffff));
+	emit(ctx, addiu, tc, MIPS_R_ZERO, min(MAX_TAIL_CALL_CNT, 0xffff));
 
 	/* === Entry-point for tail calls === */
 
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 0da31d4..8a4faa0 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -221,13 +221,13 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	PPC_BCC(COND_GE, out);
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
 	 *   goto out;
 	 */
 	EMIT(PPC_RAW_CMPLWI(_R0, MAX_TAIL_CALL_CNT));
 	/* tail_call_cnt++; */
 	EMIT(PPC_RAW_ADDIC(_R0, _R0, 1));
-	PPC_BCC(COND_GT, out);
+	PPC_BCC(COND_GE, out);
 
 	/* prog = array->ptrs[index]; */
 	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 8b5157c..8571aaf 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -228,12 +228,12 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 	PPC_BCC(COND_GE, out);
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
 	 *   goto out;
 	 */
 	PPC_BPF_LL(b2p[TMP_REG_1], 1, bpf_jit_stack_tailcallcnt(ctx));
 	EMIT(PPC_RAW_CMPLWI(b2p[TMP_REG_1], MAX_TAIL_CALL_CNT));
-	PPC_BCC(COND_GT, out);
+	PPC_BCC(COND_GE, out);
 
 	/*
 	 * tail_call_cnt++;
diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index e649742..529a83b 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -799,11 +799,10 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
 
 	/*
-	 * temp_tcc = tcc - 1;
-	 * if (tcc < 0)
+	 * if (--tcc < 0)
 	 *   goto out;
 	 */
-	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
+	emit(rv_addi(RV_REG_TCC, RV_REG_TCC, -1), ctx);
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
 
@@ -829,7 +828,6 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit(rv_lw(RV_REG_T0, off, RV_REG_T0), ctx);
-	emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
 	/* Epilogue jumps to *(t0 + 4). */
 	__build_epilogue(true, ctx);
 	return 0;
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 2ca345c..f4466b7 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -327,12 +327,12 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);
 
-	/* if (TCC-- < 0)
+	/* if (--TCC < 0)
 	 *     goto out;
 	 */
-	emit_addi(RV_REG_T1, tcc, -1, ctx);
+	emit_addi(RV_REG_TCC, tcc, -1, ctx);
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
-	emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
+	emit_branch(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (!prog)
@@ -352,7 +352,6 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit_ld(RV_REG_T3, off, RV_REG_T2, ctx);
-	emit_mv(RV_REG_TCC, RV_REG_T1, ctx);
 	__build_epilogue(true, ctx);
 	return 0;
 }
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 1a374d0..3553cfc 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1369,7 +1369,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 				 jit->prg);
 
 		/*
-		 * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
+		 * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
 		 *         goto out;
 		 */
 
@@ -1381,9 +1381,9 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		EMIT4_IMM(0xa7080000, REG_W0, 1);
 		/* laal %w1,%w0,off(%r15) */
 		EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0, REG_15, off);
-		/* clij %w1,MAX_TAIL_CALL_CNT,0x2,out */
+		/* clij %w1,MAX_TAIL_CALL_CNT-1,0x2,out */
 		patch_2_clij = jit->prg;
-		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1, MAX_TAIL_CALL_CNT,
+		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1, MAX_TAIL_CALL_CNT - 1,
 				 2, jit->prg);
 
 		/*
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 9a2f20c..0bfe1c7 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -867,7 +867,7 @@ static void emit_tail_call(struct jit_ctx *ctx)
 	emit(LD32 | IMMED | RS1(SP) | S13(off) | RD(tmp), ctx);
 	emit_cmpi(tmp, MAX_TAIL_CALL_CNT, ctx);
 #define OFFSET2 13
-	emit_branch(BGU, ctx->idx, ctx->idx + OFFSET2, ctx);
+	emit_branch(BGEU, ctx->idx, ctx->idx + OFFSET2, ctx);
 	emit_nop(ctx);
 
 	emit_alu_K(ADD, tmp, 1, ctx);
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 726700f..6318479 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -412,7 +412,7 @@ static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
  * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
  *   if (index >= array->map.max_entries)
  *     goto out;
- *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
+ *   if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
  *     goto out;
  *   prog = array->ptrs[index];
  *   if (prog == NULL)
@@ -446,14 +446,14 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	EMIT2(X86_JBE, offset);                   /* jbe out */
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
 	EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 
 	offset = ctx->tail_call_indirect_label - (prog + 2 - start);
-	EMIT2(X86_JA, offset);                    /* ja out */
+	EMIT2(X86_JAE, offset);                   /* jae out */
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
 
@@ -504,14 +504,14 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	int offset;
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
 	EMIT2_off32(0x8B, 0x85, tcc_off);             /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
 
 	offset = ctx->tail_call_direct_label - (prog + 2 - start);
-	EMIT2(X86_JA, offset);                        /* ja out */
+	EMIT2(X86_JAE, offset);                       /* jae out */
 	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, tcc_off);             /* mov dword ptr [rbp - tcc_off], eax */
 
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index da9b7cf..429a89c 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1323,7 +1323,7 @@ static void emit_bpf_tail_call(u8 **pprog, u8 *ip)
 	EMIT2(IA32_JBE, jmp_label(jmp_label1, 2));
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
 	 *     goto out;
 	 */
 	lo = (u32)MAX_TAIL_CALL_CNT;
@@ -1337,7 +1337,7 @@ static void emit_bpf_tail_call(u8 **pprog, u8 *ip)
 	/* cmp ecx,lo */
 	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
 
-	/* ja out */
+	/* jae out */
 	EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
 
 	/* add eax,0x1 */
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2be6dfd..4bce7ee 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1075,7 +1075,7 @@ struct bpf_array {
 };
 
 #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
-#define MAX_TAIL_CALL_CNT 32
+#define MAX_TAIL_CALL_CNT 33
 
 #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
 				 BPF_F_RDONLY_PROG |	\
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ba5af15..b12cfce 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1744,7 +1744,7 @@ union bpf_attr {
  * 		if the maximum number of tail calls has been reached for this
  * 		chain of programs. This limit is defined in the kernel by the
  * 		macro **MAX_TAIL_CALL_CNT** (not accessible to user space),
- * 		which is currently set to 32.
+ *		which is currently set to 33.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 327e399..870881d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1567,7 +1567,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index adae395..0c5cb2d 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -14683,7 +14683,7 @@ static struct tail_call_test tail_call_tests[] = {
 			BPF_EXIT_INSN(),
 		},
 		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
-		.result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
+		.result = (MAX_TAIL_CALL_CNT + 1) * MAX_TESTRUNS,
 	},
 	{
 		"Tail call count preserved across function calls",
@@ -14705,7 +14705,7 @@ static struct tail_call_test tail_call_tests[] = {
 		},
 		.stack_depth = 8,
 		.flags = FLAG_NEED_STATE | FLAG_RESULT_IN_STATE,
-		.result = (MAX_TAIL_CALL_CNT + 1 + 1) * MAX_TESTRUNS,
+		.result = (MAX_TAIL_CALL_CNT + 1) * MAX_TESTRUNS,
 	},
 	{
 		"Tail call error path, NULL target",
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ba5af15..b12cfce 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1744,7 +1744,7 @@ union bpf_attr {
  * 		if the maximum number of tail calls has been reached for this
  * 		chain of programs. This limit is defined in the kernel by the
  * 		macro **MAX_TAIL_CALL_CNT** (not accessible to user space),
- * 		which is currently set to 32.
+ *		which is currently set to 33.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
-- 
2.1.0

