Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746063B18CC
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhFWL1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:27:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhFWL1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kJXqD5KL0IbVw3vtc9KeCCi86mQtSwSZ2WOt7GmEWTk=;
        b=NE9E0+DApbSv5ePEgcvQQmtaY4wekKr1EqD0FkUIbr5wiamirNsX0hcZv/EKBmzsZuj2KA
        jh7VSY4uUrRQ3wN4NbjgFme12p54DiSXZ1kEfu5GrMiS4dXyT5vwLWMY+2rmJWMqEFGgdX
        fLEFF9ayheau68oax2RMHgJXyHWpIlk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-QNEi6043OdeLMf5vfUBqSA-1; Wed, 23 Jun 2021 07:25:15 -0400
X-MC-Unique: QNEi6043OdeLMf5vfUBqSA-1
Received: by mail-wr1-f70.google.com with SMTP id i70-20020adf90cc0000b029011a8a299a4dso935046wri.17
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kJXqD5KL0IbVw3vtc9KeCCi86mQtSwSZ2WOt7GmEWTk=;
        b=MP7TrsjFG+PdIFkkSAwwOkRGaIY9s0JXAHd/YucVdeHVZbxQ5feWVsJk+rt21qfgaw
         zzRwf9cBLfo6O6ouLbZWLinC5bobI653V2DwMvXopl0zDjjTycFOzzr/ryP59TQz0Ule
         PLafwsnrK8aNa2Me2KCs1vt4G3lXExieprV+T2Wsob/BWGW6wDdRnmXp1Xms0IXdlBh5
         g8J57/iACSw9fHbQZ9y5Xf+hGBxm4F7DBg6Xx1dqr32z6s0KNlVOCGXOs3VkX44fbHUH
         cAzXOSHdKjBc9CWldSkdI7PnntZ24YpiKyZvG35LZADSF4QPuJBiqk+JglsqxSmdDD/S
         EUEg==
X-Gm-Message-State: AOAM532cdEMtFtP/62ClePhMy3c8i9W/ewqABWRQML4P6yoS7UjrDMc1
        2V5E4ZTEiXJ0GnhzUDhbB8iNTtutsYguEHWK8D1enlY4F9KmpTy/IhZFpP+zIb+fXQpOpQw0W8A
        BQoxBQs4EiNBOIF9H
X-Received: by 2002:adf:d0ca:: with SMTP id z10mr10463255wrh.376.1624447514310;
        Wed, 23 Jun 2021 04:25:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWKIPRZmp2EpzYB2ZX8rES77ZXJ3/moH/ilpRK/4TbvLRncRl5OaVWM8dmQ978zWZohCzWAQ==
X-Received: by 2002:adf:d0ca:: with SMTP id z10mr10463228wrh.376.1624447514072;
        Wed, 23 Jun 2021 04:25:14 -0700 (PDT)
Received: from krava.redhat.com ([5.171.242.166])
        by smtp.gmail.com with ESMTPSA id t64sm5325168wma.44.2021.06.23.04.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:25:13 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next] bpf, x86: Remove unused cnt increase from EMIT macro
Date:   Wed, 23 Jun 2021 13:25:04 +0200
Message-Id: <20210623112504.709856-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing unused cnt increase from EMIT macro together
with cnt declarations. This was introduced in commit [1]
to ensure proper code generation. But that code was
removed in commit [2] and this extra code was left in.

[1] b52f00e6a715 ("x86: bpf_jit: implement bpf_tail_call() helper")
[2] ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 v2 changes:
   - removed cnt also in emit_prologue [David]

 arch/x86/net/bpf_jit_comp.c | 44 ++++++++++---------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 2a2e290fa5d8..db1e83813db5 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -31,7 +31,7 @@ static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 }
 
 #define EMIT(bytes, len) \
-	do { prog = emit_code(prog, bytes, len); cnt += len; } while (0)
+	do { prog = emit_code(prog, bytes, len); } while (0)
 
 #define EMIT1(b1)		EMIT(b1, 1)
 #define EMIT2(b1, b2)		EMIT((b1) + ((b2) << 8), 2)
@@ -239,7 +239,6 @@ struct jit_context {
 static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	if (callee_regs_used[0])
 		EMIT1(0x53);         /* push rbx */
@@ -255,7 +254,6 @@ static void push_callee_regs(u8 **pprog, bool *callee_regs_used)
 static void pop_callee_regs(u8 **pprog, bool *callee_regs_used)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	if (callee_regs_used[3])
 		EMIT2(0x41, 0x5F);   /* pop r15 */
@@ -277,13 +275,12 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
 			  bool tail_call_reachable, bool is_subprog)
 {
 	u8 *prog = *pprog;
-	int cnt = X86_PATCH_SIZE;
 
 	/* BPF trampoline can be made to work without these nops,
 	 * but let's waste 5 bytes for now and optimize later
 	 */
-	memcpy(prog, x86_nops[5], cnt);
-	prog += cnt;
+	memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
+	prog += X86_PATCH_SIZE;
 	if (!ebpf_from_cbpf) {
 		if (tail_call_reachable && !is_subprog)
 			EMIT2(0x31, 0xC0); /* xor eax, eax */
@@ -303,7 +300,6 @@ static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf,
 static int emit_patch(u8 **pprog, void *func, void *ip, u8 opcode)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 	s64 offset;
 
 	offset = func - (ip + X86_PATCH_SIZE);
@@ -423,7 +419,6 @@ static void emit_bpf_tail_call_indirect(u8 **pprog, bool *callee_regs_used,
 	int off1 = 42;
 	int off2 = 31;
 	int off3 = 9;
-	int cnt = 0;
 
 	/* count the additional bytes used for popping callee regs from stack
 	 * that need to be taken into account for each of the offsets that
@@ -513,7 +508,6 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	int pop_bytes = 0;
 	int off1 = 20;
 	int poke_off;
-	int cnt = 0;
 
 	/* count the additional bytes used for popping callee regs to stack
 	 * that need to be taken into account for jump offset that is used for
@@ -615,7 +609,6 @@ static void emit_mov_imm32(u8 **pprog, bool sign_propagate,
 {
 	u8 *prog = *pprog;
 	u8 b1, b2, b3;
-	int cnt = 0;
 
 	/*
 	 * Optimization: if imm32 is positive, use 'mov %eax, imm32'
@@ -655,7 +648,6 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
 			   const u32 imm32_hi, const u32 imm32_lo)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	if (is_uimm32(((u64)imm32_hi << 32) | (u32)imm32_lo)) {
 		/*
@@ -678,7 +670,6 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
 static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	if (is64) {
 		/* mov dst, src */
@@ -697,7 +688,6 @@ static void emit_mov_reg(u8 **pprog, bool is64, u32 dst_reg, u32 src_reg)
 static void emit_insn_suffix(u8 **pprog, u32 ptr_reg, u32 val_reg, int off)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	if (is_imm8(off)) {
 		/* 1-byte signed displacement.
@@ -720,7 +710,6 @@ static void emit_insn_suffix(u8 **pprog, u32 ptr_reg, u32 val_reg, int off)
 static void maybe_emit_mod(u8 **pprog, u32 dst_reg, u32 src_reg, bool is64)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	if (is64)
 		EMIT1(add_2mod(0x48, dst_reg, src_reg));
@@ -733,7 +722,6 @@ static void maybe_emit_mod(u8 **pprog, u32 dst_reg, u32 src_reg, bool is64)
 static void emit_ldx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	switch (size) {
 	case BPF_B:
@@ -764,7 +752,6 @@ static void emit_ldx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	switch (size) {
 	case BPF_B:
@@ -799,7 +786,6 @@ static int emit_atomic(u8 **pprog, u8 atomic_op,
 		       u32 dst_reg, u32 src_reg, s16 off, u8 bpf_size)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 
 	EMIT1(0xF0); /* lock prefix */
 
@@ -869,10 +855,10 @@ static void detect_reg_usage(struct bpf_insn *insn, int insn_cnt,
 	}
 }
 
-static int emit_nops(u8 **pprog, int len)
+static void emit_nops(u8 **pprog, int len)
 {
 	u8 *prog = *pprog;
-	int i, noplen, cnt = 0;
+	int i, noplen;
 
 	while (len > 0) {
 		noplen = len;
@@ -886,8 +872,6 @@ static int emit_nops(u8 **pprog, int len)
 	}
 
 	*pprog = prog;
-
-	return cnt;
 }
 
 #define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
@@ -902,7 +886,7 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	bool tail_call_seen = false;
 	bool seen_exit = false;
 	u8 temp[BPF_MAX_INSN_SIZE + BPF_INSN_SAFETY];
-	int i, cnt = 0, excnt = 0;
+	int i, excnt = 0;
 	int ilen, proglen = 0;
 	u8 *prog = temp;
 	int err;
@@ -1576,7 +1560,7 @@ st:			if (is_imm8(insn->off))
 						       nops);
 						return -EFAULT;
 					}
-					cnt += emit_nops(&prog, nops);
+					emit_nops(&prog, nops);
 				}
 				EMIT2(jmp_cond, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
@@ -1622,7 +1606,7 @@ st:			if (is_imm8(insn->off))
 						       nops);
 						return -EFAULT;
 					}
-					cnt += emit_nops(&prog, nops);
+					emit_nops(&prog, nops);
 				}
 				break;
 			}
@@ -1647,7 +1631,7 @@ st:			if (is_imm8(insn->off))
 						       nops);
 						return -EFAULT;
 					}
-					cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
+					emit_nops(&prog, INSN_SZ_DIFF - 2);
 				}
 				EMIT2(0xEB, jmp_offset);
 			} else if (is_simm32(jmp_offset)) {
@@ -1754,7 +1738,6 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 {
 	u8 *prog = *pprog;
 	u8 *jmp_insn;
-	int cnt = 0;
 
 	/* arg1: mov rdi, progs[i] */
 	emit_mov_imm64(&prog, BPF_REG_1, (long) p >> 32, (u32) (long) p);
@@ -1822,7 +1805,6 @@ static void emit_align(u8 **pprog, u32 align)
 static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
 {
 	u8 *prog = *pprog;
-	int cnt = 0;
 	s64 offset;
 
 	offset = func - (ip + 2 + 4);
@@ -1854,7 +1836,7 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 			      u8 **branches)
 {
 	u8 *prog = *pprog;
-	int i, cnt = 0;
+	int i;
 
 	/* The first fmod_ret program will receive a garbage return value.
 	 * Set this to 0 to avoid confusing the program.
@@ -1950,7 +1932,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				struct bpf_tramp_progs *tprogs,
 				void *orig_call)
 {
-	int ret, i, cnt = 0, nr_args = m->nr_args;
+	int ret, i, nr_args = m->nr_args;
 	int stack_size = nr_args * 8;
 	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
@@ -2095,8 +2077,6 @@ static int emit_fallback_jump(u8 **pprog)
 	 */
 	err = emit_jump(&prog, __x86_indirect_thunk_rdx, prog);
 #else
-	int cnt = 0;
-
 	EMIT2(0xFF, 0xE2);	/* jmp rdx */
 #endif
 	*pprog = prog;
@@ -2106,7 +2086,7 @@ static int emit_fallback_jump(u8 **pprog)
 static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
 {
 	u8 *jg_reloc, *prog = *pprog;
-	int pivot, err, jg_bytes = 1, cnt = 0;
+	int pivot, err, jg_bytes = 1;
 	s64 jg_offset;
 
 	if (a == b) {
-- 
2.31.1

