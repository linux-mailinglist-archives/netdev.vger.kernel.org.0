Return-Path: <netdev+bounces-6225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B693E71548F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03E29281045
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D676D81D;
	Tue, 30 May 2023 04:45:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3497E9;
	Tue, 30 May 2023 04:45:58 +0000 (UTC)
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563DDE8;
	Mon, 29 May 2023 21:45:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 98e67ed59e1d1-2553f2706bfso2783797a91.1;
        Mon, 29 May 2023 21:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685421956; x=1688013956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WnRzpYkB9J7f0YSKLddiyloDnl+jPqIem2lDhPLL95Y=;
        b=WeBTNA1M8N9vQSWalw3Whyi1jgvP6gJVGzHbFCpL+UTxifP1tfltwIiMX0p4SMdREV
         Rou94laqsyo/lD4QhIJXF2F1xOPdP50tEUzlVyRbet1/l4iGc5vbH8tFyqzR+6silN8L
         5h1dijcPS2w8q4ATa4kCkIvyDzR7l6f5rQPPZYxqI6RDYB1Mvd7Yth72U26EALNU5n9w
         31PDC/OCg2frnR+/liItmpPalaRjeBYWXs0v2gyoYLH1vqlRQLlbQmjo57OvgS9HTJ3r
         XTHJoy3nr2Ik/oFGOJlAvHGTi9T5bpjKbrdlGsaFJvQwKteuLTU0g3hPkmnYfzE7KQ6B
         32Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685421956; x=1688013956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnRzpYkB9J7f0YSKLddiyloDnl+jPqIem2lDhPLL95Y=;
        b=DOQBqEYP8wn1xWue9qr+N5AmmwWFJdHoHVvtdj0rXj/0czMwshCA3PvxylzTq3GW9F
         mOf5jHvsqyYcW42HP/GVeKT/9rNcWxgn1ZWUk9wAlicT1jwFpO7b59PSOeMA35iKVPAj
         NTxZpm077bGQCL06Zds3Vezg3WILC6OdW6v41PYmZP6BmrBn9Jh/r3McmUJaqWgEIcCc
         D+5WN2m0QUCDiicG+hud+zCUnT3HrdSj4ZuPY8DW/7UFPh+Ttf8dS/eljlsjJ87R6DLT
         jTE6bc48odRrfX8UHVmABdFZVdYdRWiBGy9GLZfgrEMrRrs0P5NgNFHeqnDM+yrUs7nT
         sIiA==
X-Gm-Message-State: AC+VfDzpcmzuBqnOmjX4sUtasyhHoguJqT4kDzm7FHS3CWEHfFXblbn9
	maVCQqdwABNldA0O6sN9B7A=
X-Google-Smtp-Source: ACHHUZ4bgwVFXkIcdsn6WzBDoLP77ZigpEk/ogM9lTySeRFcEoJAKzM/AL2SxFkhZTHHPtJUB5NLlA==
X-Received: by 2002:a17:90a:55c7:b0:253:3eb5:3ade with SMTP id o7-20020a17090a55c700b002533eb53ademr1210937pjm.8.1685421955618;
        Mon, 29 May 2023 21:45:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id e23-20020a17090ab39700b00247601ce2aesm5701811pjr.20.2023.05.29.21.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 21:45:55 -0700 (PDT)
From: menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To: dsahern@kernel.org,
	andrii@kernel.org
Cc: davem@davemloft.net,
	ast@kernel.org,
	daniel@iogearbox.net,
	martin.lau@linux.dev,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: [PATCH] bpf, x86: allow function arguments up to 12 for TRACING
Date: Tue, 30 May 2023 12:44:23 +0800
Message-Id: <20230530044423.3897681-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Menglong Dong <imagedong@tencent.com>

For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
on the kernel functions whose arguments count less than 6. This is not
friendly at all, as too many functions have arguments count more than 6.

Therefore, let's enhance it by increasing the function arguments count
allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.

For the case that we don't need to call origin function, which means
without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
that stored in the frame of the caller to current frame. The arguments
of arg6-argN are stored in "$rbp + 0x18", we need copy them to
"$rbp - regs_off + (6 * 8)".

For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
in stack before call origin function, which means we need alloc extra
"8 * (arg_count - 6)" memory in the top of the stack. Note, there should
not be any data be pushed to the stack before call the origin function.
Then, we have to store rbx with 'mov' instead of 'push'.

It works well for the FENTRY and FEXIT, I'm not sure if there are other
complicated cases.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 arch/x86/net/bpf_jit_comp.c | 88 ++++++++++++++++++++++++++++++++-----
 1 file changed, 77 insertions(+), 11 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 1056bbf55b17..a3bc7e86ca19 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1868,7 +1868,7 @@ static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 	 * mov QWORD PTR [rbp-0x10],rdi
 	 * mov QWORD PTR [rbp-0x8],rsi
 	 */
-	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
+	for (i = 0, j = 0; i < min(nr_regs, 12); i++) {
 		/* The arg_size is at most 16 bytes, enforced by the verifier. */
 		arg_size = m->arg_size[j];
 		if (arg_size > 8) {
@@ -1876,10 +1876,22 @@ static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 			next_same_struct = !next_same_struct;
 		}
 
-		emit_stx(prog, bytes_to_bpf_size(arg_size),
-			 BPF_REG_FP,
-			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
-			 -(stack_size - i * 8));
+		if (i <= 5) {
+			/* store function arguments in regs */
+			emit_stx(prog, bytes_to_bpf_size(arg_size),
+				 BPF_REG_FP,
+				 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
+				 -(stack_size - i * 8));
+		} else {
+			/* store function arguments in stack */
+			emit_ldx(prog, bytes_to_bpf_size(arg_size),
+				 BPF_REG_0, BPF_REG_FP,
+				 (i - 6) * 8 + 0x18);
+			emit_stx(prog, bytes_to_bpf_size(arg_size),
+				 BPF_REG_FP,
+				 BPF_REG_0,
+				 -(stack_size - i * 8));
+		}
 
 		j = next_same_struct ? j : j + 1;
 	}
@@ -1913,6 +1925,41 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 	}
 }
 
+static void prepare_origin_stack(const struct btf_func_model *m, u8 **prog,
+				 int nr_regs, int stack_size)
+{
+	int i, j, arg_size;
+	bool next_same_struct = false;
+
+	if (nr_regs <= 6)
+		return;
+
+	/* Prepare the function arguments in stack before call origin
+	 * function. These arguments must be stored in the top of the
+	 * stack.
+	 */
+	for (i = 0, j = 0; i < min(nr_regs, 12); i++) {
+		/* The arg_size is at most 16 bytes, enforced by the verifier. */
+		arg_size = m->arg_size[j];
+		if (arg_size > 8) {
+			arg_size = 8;
+			next_same_struct = !next_same_struct;
+		}
+
+		if (i > 5) {
+			emit_ldx(prog, bytes_to_bpf_size(arg_size),
+				 BPF_REG_0, BPF_REG_FP,
+				 (i - 6) * 8 + 0x18);
+			emit_stx(prog, bytes_to_bpf_size(arg_size),
+				 BPF_REG_FP,
+				 BPF_REG_0,
+				 -(stack_size - (i - 6) * 8));
+		}
+
+		j = next_same_struct ? j : j + 1;
+	}
+}
+
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 			   struct bpf_tramp_link *l, int stack_size,
 			   int run_ctx_off, bool save_ret)
@@ -2136,7 +2183,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				void *func_addr)
 {
 	int i, ret, nr_regs = m->nr_args, stack_size = 0;
-	int regs_off, nregs_off, ip_off, run_ctx_off;
+	int regs_off, nregs_off, ip_off, run_ctx_off, arg_stack_off, rbx_off;
 	struct bpf_tramp_links *fentry = &tlinks[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_links *fexit = &tlinks[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
@@ -2150,8 +2197,10 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
 			nr_regs += (m->arg_size[i] + 7) / 8 - 1;
 
-	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
-	if (nr_regs > 6)
+	/* x86-64 supports up to 12 arguments. 1-6 are passed through
+	 * regs, the remains are through stack.
+	 */
+	if (nr_regs > 12)
 		return -ENOTSUPP;
 
 	/* Generated trampoline stack layout:
@@ -2170,7 +2219,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	 *
 	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
 	 *
+	 * RBP - rbx_off   [ rbx value       ]  always
+	 *
 	 * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
+	 *
+	 *                     [ stack_argN ]  BPF_TRAMP_F_CALL_ORIG
+	 *                     [ ...        ]
+	 *                     [ stack_arg2 ]
+	 * RBP - arg_stack_off [ stack_arg1 ]
 	 */
 
 	/* room for return value of orig_call or fentry prog */
@@ -2190,9 +2246,17 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 
 	ip_off = stack_size;
 
+	stack_size += 8;
+	rbx_off = stack_size;
+
 	stack_size += (sizeof(struct bpf_tramp_run_ctx) + 7) & ~0x7;
 	run_ctx_off = stack_size;
 
+	if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG))
+		stack_size += (nr_regs - 6) * 8;
+
+	arg_stack_off = stack_size;
+
 	if (flags & BPF_TRAMP_F_SKIP_FRAME) {
 		/* skip patched call instruction and point orig_call to actual
 		 * body of the kernel function.
@@ -2212,8 +2276,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	x86_call_depth_emit_accounting(&prog, NULL);
 	EMIT1(0x55);		 /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
-	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
-	EMIT1(0x53);		 /* push rbx */
+	EMIT3_off32(0x48, 0x81, 0xEC, stack_size); /* sub rsp, stack_size */
+	/* mov QWORD PTR [rbp - rbx_off], rbx */
+	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_6, -rbx_off);
 
 	/* Store number of argument registers of the traced function:
 	 *   mov rax, nr_regs
@@ -2262,6 +2327,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		restore_regs(m, &prog, nr_regs, regs_off);
+		prepare_origin_stack(m, &prog, nr_regs, arg_stack_off);
 
 		if (flags & BPF_TRAMP_F_ORIG_STACK) {
 			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
@@ -2321,7 +2387,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (save_ret)
 		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
 
-	EMIT1(0x5B); /* pop rbx */
+	emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, -rbx_off);
 	EMIT1(0xC9); /* leave */
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
 		/* skip our return address and return to parent */
-- 
2.40.1


