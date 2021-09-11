Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032CD407488
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 03:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhIKB56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 21:57:58 -0400
Received: from mail.loongson.cn ([114.242.206.163]:55902 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231864AbhIKB55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 21:57:57 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxJeWxDDxhOA4EAA--.13143S2;
        Sat, 11 Sep 2021 09:56:02 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        davem@davemloft.net,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Chaignon <paul@cilium.io>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, sparclinux@vger.kernel.org
Subject: [PATCH bpf-next v2] bpf: Change value of MAX_TAIL_CALL_CNT from 32 to 33
Date:   Sat, 11 Sep 2021 09:56:01 +0800
Message-Id: <1631325361-9851-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxJeWxDDxhOA4EAA--.13143S2
X-Coremail-Antispam: 1UD129KBjvJXoW3tFy3XF15Cw17Gw47GryfWFg_yoWkKr17pr
        18twnakrWvqw1rAa4xta1UXw4UKF4v9F47KFs5CrWSy3ZFvr9rWF13Kw15ZFZ0vrW8Jw1r
        XFZ0kry3C3WkXwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY
        04v7MxkIecxEwVAFwVWkMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI
        8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
        xVWrXVW8Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07b0GQgUUUUU=
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

So it is necessary to change the value of MAX_TAIL_CALL_CNT from 32 to 33,
then do some small changes of the related code.

With this patch, it does not change the current limit 33, MAX_TAIL_CALL_CNT
can reflect the actual max tail call count, the tailcall selftests can work
well, and also the above failed testcase in test_bpf can be fixed for the
interpreter (all archs) and the JIT (all archs except for x86).

 # uname -m
 x86_64
 # echo 1 > /proc/sys/net/core/bpf_jit_enable
 # modprobe test_bpf
 # dmesg | grep -w FAIL
 Tail call error path, max count reached jited:1 ret 33 != 34 FAIL

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

v2:
  -- fix the typos in the commit message and update the commit message.
  -- fix the failed tailcall selftests for x86 jit.
     I am not quite sure the change on x86 is proper, with this change,
     tailcall selftests passed, but tailcall limit test in test_bpf.ko
     failed, I do not know the reason now, I think this is another issue,
     maybe someone more versed in x86 jit could take a look.

 arch/arm/net/bpf_jit_32.c         | 11 ++++++-----
 arch/arm64/net/bpf_jit_comp.c     |  7 ++++---
 arch/mips/net/ebpf_jit.c          |  4 ++--
 arch/powerpc/net/bpf_jit_comp32.c |  4 ++--
 arch/powerpc/net/bpf_jit_comp64.c | 12 ++++++------
 arch/riscv/net/bpf_jit_comp32.c   |  4 ++--
 arch/riscv/net/bpf_jit_comp64.c   |  4 ++--
 arch/sparc/net/bpf_jit_comp_64.c  |  8 ++++----
 arch/x86/net/bpf_jit_comp.c       | 10 +++++-----
 include/linux/bpf.h               |  2 +-
 kernel/bpf/core.c                 |  4 ++--
 11 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index a951276..39d9ae9 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1180,18 +1180,19 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 
 	/* tmp2[0] = array, tmp2[1] = index */
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
-	 *	goto out;
+	/*
 	 * tail_call_cnt++;
+	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 *	goto out;
 	 */
+	tc = arm_bpf_get_reg64(tcc, tmp, ctx);
+	emit(ARM_ADDS_I(tc[1], tc[1], 1), ctx);
+	emit(ARM_ADC_I(tc[0], tc[0], 0), ctx);
 	lo = (u32)MAX_TAIL_CALL_CNT;
 	hi = (u32)((u64)MAX_TAIL_CALL_CNT >> 32);
-	tc = arm_bpf_get_reg64(tcc, tmp, ctx);
 	emit(ARM_CMP_I(tc[0], hi), ctx);
 	_emit(ARM_COND_EQ, ARM_CMP_I(tc[1], lo), ctx);
 	_emit(ARM_COND_HI, ARM_B(jmp_offset), ctx);
-	emit(ARM_ADDS_I(tc[1], tc[1], 1), ctx);
-	emit(ARM_ADC_I(tc[0], tc[0], 0), ctx);
 	arm_bpf_put_reg64(tcc, tmp, ctx);
 
 	/* prog = array->ptrs[index]
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 41c23f4..5d6c843 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -286,14 +286,15 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	emit(A64_CMP(0, r3, tmp), ctx);
 	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
 
-	/* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
-	 *     goto out;
+	/*
 	 * tail_call_cnt++;
+	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
+	 *     goto out;
 	 */
+	emit(A64_ADD_I(1, tcc, tcc, 1), ctx);
 	emit_a64_mov_i64(tmp, MAX_TAIL_CALL_CNT, ctx);
 	emit(A64_CMP(1, tcc, tmp), ctx);
 	emit(A64_B_(A64_COND_HI, jmp_offset), ctx);
-	emit(A64_ADD_I(1, tcc, tcc, 1), ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (prog == NULL)
diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 3a73e93..029fc34 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -617,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 	b_off = b_imm(this_idx + 1, ctx);
 	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
 	/*
-	 * if (TCC-- < 0)
+	 * if (--TCC < 0)
 	 *     goto out;
 	 */
 	/* Delay slot */
 	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
 	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, bltz, tcc_reg, b_off);
+	emit_instr(ctx, bltz, MIPS_R_T5, b_off);
 	/*
 	 * prog = array->ptrs[index];
 	 * if (prog == NULL)
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index beb12cb..b5585ad 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -221,12 +221,12 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	PPC_BCC(COND_GE, out);
 
 	/*
+	 * tail_call_cnt++;
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *   goto out;
 	 */
-	EMIT(PPC_RAW_CMPLWI(_R0, MAX_TAIL_CALL_CNT));
-	/* tail_call_cnt++; */
 	EMIT(PPC_RAW_ADDIC(_R0, _R0, 1));
+	EMIT(PPC_RAW_CMPLWI(_R0, MAX_TAIL_CALL_CNT));
 	PPC_BCC(COND_GT, out);
 
 	/* prog = array->ptrs[index]; */
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index b87a63d..bb15cc4 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -227,6 +227,12 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	PPC_BCC(COND_GE, out);
 
 	/*
+	 * tail_call_cnt++;
+	 */
+	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], b2p[TMP_REG_1], 1));
+	PPC_BPF_STL(b2p[TMP_REG_1], 1, bpf_jit_stack_tailcallcnt(ctx));
+
+	/*
 	 * if (tail_call_cnt > MAX_TAIL_CALL_CNT)
 	 *   goto out;
 	 */
@@ -234,12 +240,6 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	EMIT(PPC_RAW_CMPLWI(b2p[TMP_REG_1], MAX_TAIL_CALL_CNT));
 	PPC_BCC(COND_GT, out);
 
-	/*
-	 * tail_call_cnt++;
-	 */
-	EMIT(PPC_RAW_ADDI(b2p[TMP_REG_1], b2p[TMP_REG_1], 1));
-	PPC_BPF_STL(b2p[TMP_REG_1], 1, bpf_jit_stack_tailcallcnt(ctx));
-
 	/* prog = array->ptrs[index]; */
 	EMIT(PPC_RAW_MULI(b2p[TMP_REG_1], b2p_index, 8));
 	EMIT(PPC_RAW_ADD(b2p[TMP_REG_1], b2p[TMP_REG_1], b2p_bpf_array));
diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index e649742..1608d94 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -800,12 +800,12 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 
 	/*
 	 * temp_tcc = tcc - 1;
-	 * if (tcc < 0)
+	 * if (temp_tcc < 0)
 	 *   goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
 	off = ninsns_rvoff(tc_ninsn - (ctx->ninsns - start_insn));
-	emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);
+	emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
 
 	/*
 	 * prog = array->ptrs[index];
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 3af4131..6e9ba83 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -311,12 +311,12 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
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
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index 9a2f20c..50d914c 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -863,6 +863,10 @@ static void emit_tail_call(struct jit_ctx *ctx)
 	emit_branch(BGEU, ctx->idx, ctx->idx + OFFSET1, ctx);
 	emit_nop(ctx);
 
+	emit_alu_K(ADD, tmp, 1, ctx);
+	off = BPF_TAILCALL_CNT_SP_OFF;
+	emit(ST32 | IMMED | RS1(SP) | S13(off) | RD(tmp), ctx);
+
 	off = BPF_TAILCALL_CNT_SP_OFF;
 	emit(LD32 | IMMED | RS1(SP) | S13(off) | RD(tmp), ctx);
 	emit_cmpi(tmp, MAX_TAIL_CALL_CNT, ctx);
@@ -870,10 +874,6 @@ static void emit_tail_call(struct jit_ctx *ctx)
 	emit_branch(BGU, ctx->idx, ctx->idx + OFFSET2, ctx);
 	emit_nop(ctx);
 
-	emit_alu_K(ADD, tmp, 1, ctx);
-	off = BPF_TAILCALL_CNT_SP_OFF;
-	emit(ST32 | IMMED | RS1(SP) | S13(off) | RD(tmp), ctx);
-
 	emit_alu3_K(SLL, bpf_index, 3, tmp, ctx);
 	emit_alu(ADD, bpf_array, tmp, ctx);
 	off = offsetof(struct bpf_array, ptrs);
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 0fe6aac..74a9e61 100644
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
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f4c16f1..224cc7e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1046,7 +1046,7 @@ struct bpf_array {
 };
 
 #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
-#define MAX_TAIL_CALL_CNT 32
+#define MAX_TAIL_CALL_CNT 33
 
 #define BPF_F_ACCESS_MASK	(BPF_F_RDONLY |		\
 				 BPF_F_RDONLY_PROG |	\
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9f4636d..8edb1c3 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1564,10 +1564,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
-			goto out;
 
 		tail_call_cnt++;
+		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+			goto out;
 
 		prog = READ_ONCE(array->ptrs[index]);
 		if (!prog)
-- 
2.1.0

