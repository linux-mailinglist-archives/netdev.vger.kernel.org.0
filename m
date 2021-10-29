Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CD43FBD9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhJ2L4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:56:36 -0400
Received: from mail.loongson.cn ([114.242.206.163]:47462 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231131AbhJ2L4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:56:34 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9CxhObP4HthfgwiAA--.60215S2;
        Fri, 29 Oct 2021 19:53:52 +0800 (CST)
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
Subject: [PATCH bpf-next v3] bpf: Change value of MAX_TAIL_CALL_CNT from 32 to 33
Date:   Fri, 29 Oct 2021 19:53:50 +0800
Message-Id: <1635508430-2918-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9CxhObP4HthfgwiAA--.60215S2
X-Coremail-Antispam: 1UD129KBjvAXoW3tFy3XF15Cw17Gw47GryfWFg_yoW8Xw1DGo
        W8tr1v9a1rK34DWF12kwn3GrykJa1xKay8Aa1SgF4ruanFva4ayrW8Zw4DJFyFqa4rGryD
        Wryfta1UXFsxKFyDn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUYh7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20EY4v20xva
        j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
        JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r4kMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjfUOyCJDUUUU
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
 #141 tailcalls:OK
 Summary: 1/11 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/arm/net/bpf_jit_32.c         |  5 +++--
 arch/arm64/net/bpf_jit_comp.c     |  5 +++--
 arch/mips/net/bpf_jit_comp32.c    |  2 +-
 arch/mips/net/bpf_jit_comp64.c    |  2 +-
 arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
 arch/powerpc/net/bpf_jit_comp64.c |  4 ++--
 arch/riscv/net/bpf_jit_comp32.c   |  5 ++---
 arch/riscv/net/bpf_jit_comp64.c   |  4 ++--
 arch/s390/net/bpf_jit_comp.c      |  6 +++---
 arch/sparc/net/bpf_jit_comp_64.c  |  2 +-
 arch/x86/net/bpf_jit_comp.c       | 10 +++++-----
 arch/x86/net/bpf_jit_comp32.c     |  8 ++++----
 include/linux/bpf.h               |  2 +-
 include/uapi/linux/bpf.h          |  2 +-
 kernel/bpf/core.c                 |  3 ++-
 lib/test_bpf.c                    |  4 ++--
 tools/include/uapi/linux/bpf.h    |  2 +-
 17 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index ce75c6b..87c57b2 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1180,7 +1180,8 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 
 	/* tmp2[0] = array, tmp2[1] = index */
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	/*
+	 * if (tail_call_cnt == MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 * tail_call_cnt++;
 	 */
@@ -1189,7 +1190,7 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	tc = arm_bpf_get_reg64(tcc, tmp, ctx);
 	emit(ARM_CMP_I(tc[0], hi), ctx);
 	_emit(ARM_COND_EQ, ARM_CMP_I(tc[1], lo), ctx);
-	_emit(ARM_COND_HI, ARM_B(jmp_offset), ctx);
+	_emit(ARM_COND_EQ, ARM_B(jmp_offset), ctx);
 	emit(ARM_ADDS_I(tc[1], tc[1], 1), ctx);
 	emit(ARM_ADC_I(tc[0], tc[0], 0), ctx);
 	arm_bpf_put_reg64(tcc, tmp, ctx);
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 41c23f4..0648121 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -286,13 +286,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	emit(A64_CMP(0, r3, tmp), ctx);
 	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	/*
+	 * if (tail_call_cnt == MAX_TAIL_CALL_CNT)
 	 *     goto out;
 	 * tail_call_cnt++;
 	 */
 	emit_a64_mov_i64(tmp, MAX_TAIL_CALL_CNT, ctx);
 	emit(A64_CMP(1, tcc, tmp), ctx);
-	emit(A64_B_(A64_COND_HI, jmp_offset), ctx);
+	emit(A64_B_(A64_COND_EQ, jmp_offset), ctx);
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
index beb12cb..a072005 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -221,13 +221,13 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	PPC_BCC(COND_GE, out);
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt == MAX_TAIL_CALL_CNT)
 	 *   goto out;
 	 */
 	EMIT(PPC_RAW_CMPLWI(_R0, MAX_TAIL_CALL_CNT));
 	/* tail_call_cnt++; */
 	EMIT(PPC_RAW_ADDIC(_R0, _R0, 1));
-	PPC_BCC(COND_GT, out);
+	PPC_BCC(COND_EQ, out);
 
 	/* prog = array->ptrs[index]; */
 	EMIT(PPC_RAW_RLWINM(_R3, b2p_index, 2, 0, 29));
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index b87a63d..ff03ccc 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -227,12 +227,12 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	PPC_BCC(COND_GE, out);
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt == MAX_TAIL_CALL_CNT)
 	 *   goto out;
 	 */
 	PPC_BPF_LL(b2p[TMP_REG_1], 1, bpf_jit_stack_tailcallcnt(ctx));
 	EMIT(PPC_RAW_CMPLWI(b2p[TMP_REG_1], MAX_TAIL_CALL_CNT));
-	PPC_BCC(COND_GT, out);
+	PPC_BCC(COND_EQ, out);
 
 	/*
 	 * tail_call_cnt++;
diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index e649742..ead9733 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -799,13 +799,12 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
 
 	/*
-	 * temp_tcc = tcc - 1;
-	 * if (tcc < 0)
+	 * if (--tcc < 0)
 	 *   goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
-	emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
+	emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
 
 	/*
 	 * prog = array->ptrs[index];
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 2ca345c..1bfaeff 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -327,12 +327,12 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
 	emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);
 
-	/* if (TCC-- < 0)
+	/* if (--TCC < 0)
 	 *     goto out;
 	 */
 	emit_addi(RV_REG_T1, tcc, -1, ctx);
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
-	emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);
+	emit_branch(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (!prog)
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 840d859..c04b834 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1369,7 +1369,7 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 				 jit->prg);
 
 		/*
-		 * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
+		 * if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
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
index 9a2f20c..1a0b2bf 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -867,7 +867,7 @@ static void emit_tail_call(struct jit_ctx *ctx)
 	emit(LD32 | IMMED | RS1(SP) | S13(off) | RD(tmp), ctx);
 	emit_cmpi(tmp, MAX_TAIL_CALL_CNT, ctx);
 #define OFFSET2 13
-	emit_branch(BGU, ctx->idx, ctx->idx + OFFSET2, ctx);
+	emit_branch(BE, ctx->idx, ctx->idx + OFFSET2, ctx);
 	emit_nop(ctx);
 
 	emit_alu_K(ADD, tmp, 1, ctx);
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index e474718..51905ad 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -402,7 +402,7 @@ static int get_pop_bytes(bool *callee_regs_used)
  * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
  *   if (index >= array->map.max_entries)
  *     goto out;
- *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
+ *   if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
  *     goto out;
  *   prog = array->ptrs[index];
  *   if (prog == NULL)
@@ -452,13 +452,13 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	EMIT2(X86_JBE, OFFSET1);                  /* jbe out */
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
 	EMIT2_off32(0x8B, 0x85, tcc_off);         /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);     /* cmp eax, MAX_TAIL_CALL_CNT */
 #define OFFSET2 (off2 + RETPOLINE_RCX_BPF_JIT_SIZE)
-	EMIT2(X86_JA, OFFSET2);                   /* ja out */
+	EMIT2(X86_JE, OFFSET2);                   /* je out */
 	EMIT3(0x83, 0xC0, 0x01);                  /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, tcc_off);         /* mov dword ptr [rbp - tcc_off], eax */
 
@@ -530,12 +530,12 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	}
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
 	 *	goto out;
 	 */
 	EMIT2_off32(0x8B, 0x85, tcc_off);             /* mov eax, dword ptr [rbp - tcc_off] */
 	EMIT3(0x83, 0xF8, MAX_TAIL_CALL_CNT);         /* cmp eax, MAX_TAIL_CALL_CNT */
-	EMIT2(X86_JA, off1);                          /* ja out */
+	EMIT2(X86_JE, off1);                          /* je out */
 	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, tcc_off);             /* mov dword ptr [rbp - tcc_off], eax */
 
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 3bfda5f..e943344 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1272,7 +1272,7 @@ static void emit_epilogue(u8 **pprog, u32 stack_depth)
  * ... bpf_tail_call(void *ctx, struct bpf_array *array, u64 index) ...
  *   if (index >= array->map.max_entries)
  *     goto out;
- *   if (++tail_call_cnt > MAX_TAIL_CALL_CNT)
+ *   if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
  *     goto out;
  *   prog = array->ptrs[index];
  *   if (prog == NULL)
@@ -1307,7 +1307,7 @@ static void emit_bpf_tail_call(u8 **pprog)
 	EMIT2(IA32_JBE, jmp_label(jmp_label1, 2));
 
 	/*
-	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 * if (tail_call_cnt++ == MAX_TAIL_CALL_CNT)
 	 *     goto out;
 	 */
 	lo = (u32)MAX_TAIL_CALL_CNT;
@@ -1321,8 +1321,8 @@ static void emit_bpf_tail_call(u8 **pprog)
 	/* cmp ecx,lo */
 	EMIT3(0x83, add_1reg(0xF8, IA32_ECX), lo);
 
-	/* ja out */
-	EMIT2(IA32_JAE, jmp_label(jmp_label1, 2));
+	/* je out */
+	EMIT2(IA32_JE, jmp_label(jmp_label1, 2));
 
 	/* add eax,0x1 */
 	EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 0x01);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6deebf8..fa2c396 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1052,7 +1052,7 @@ struct bpf_array {
 };
 
 #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
-#define MAX_TAIL_CALL_CNT 32
+#define MAX_TAIL_CALL_CNT 33
 
 #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
 				 BPF_F_RDONLY_PROG |	\
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bd0c9f0..92b558fa2 100644
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
index b6c72af..6d10292 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1565,7 +1565,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+
+		if (unlikely(tail_call_cnt == MAX_TAIL_CALL_CNT))
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
index bd0c9f0..92b558fa2 100644
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

