Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA8E455A2F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343933AbhKRL3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:29:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343932AbhKRL2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637234736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UExItWiG/aghgot1jOwsBbuLo+xTDuY4lfZqkstoXa0=;
        b=dAGphBc1E5hsjhcCPhHq9pmKEUAxeOkeYxXQX1xKOuo4cCXcSDITDENm7JtO5wccQI1oni
        N8XoH07JRKxgfIdJ/PMDYLUi/Q191UVvkHvN9yMMCNMmH8vz/r3g1LsXue3UC4qiabyKKC
        cOXlvZph8rW+Q0vIhGgE160dU3BlncY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-gG8H2QqPPi-UxW2qMwEvtg-1; Thu, 18 Nov 2021 06:25:34 -0500
X-MC-Unique: gG8H2QqPPi-UxW2qMwEvtg-1
Received: by mail-ed1-f70.google.com with SMTP id v1-20020aa7cd41000000b003e80973378aso3453690edw.14
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UExItWiG/aghgot1jOwsBbuLo+xTDuY4lfZqkstoXa0=;
        b=J+iah5wcVQxxujPWbHJEvP1JlFmErhDOGsH76G7h4XMpjj83IA62J+P8Az+mFKdOeL
         RLM/Z0fYLHLfpfLX831E5yUYr0VXKCML/WIlMk9kHqpC64oARsKRSDxWgDruSoY//WEr
         c8mf3hJyWvTMrmCZUY7nNcPWgRHu7j4s4e6PvWvYVJNLZWi1yQ85ZjW8AHoyjn8m3ofL
         dShsdyMukq4nr0NVDbgk0E2+dChVWo3Qv3f/CqjA4bj37igYPhrKxwYAjSH2CrkZ7wYp
         kR0NESae0C+FFo61oIg1LgRPO7X+HHR5U8Y24aAZ0dCzvsaTEinz2c87BOD5Ixk2zT0O
         0O7A==
X-Gm-Message-State: AOAM533q5VZO88qFUhsVf6mbIkE0+ruhaeb+Abl9GN7HoKcYn6HnFxtK
        dzy0JcSQsxTQ2CrJjFwBnwRzJBNdb/KK1HMZeXfHCkp2jzxfPNNzltxq5Fpu5514aeksXx+XG3H
        90g9+5QTsMO9b7aRn
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr32631661ejf.27.1637234733380;
        Thu, 18 Nov 2021 03:25:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZcB/WXAUH9R6GLkTBNbO00Tm3vdxO5uMqs2WUCXNQSpxdO8nFLE6w7EitJTSQZsOGZ2Twmg==
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr32631601ejf.27.1637234733071;
        Thu, 18 Nov 2021 03:25:33 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id e19sm1451053edu.47.2021.11.18.03.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:25:32 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers for tracing programs
Date:   Thu, 18 Nov 2021 12:24:32 +0100
Message-Id: <20211118112455.475349-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118112455.475349-1-jolsa@kernel.org>
References: <20211118112455.475349-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding bpf_arg/bpf_ret_value helpers for tracing programs
that returns traced function arguments.

Get n-th argument of the traced function:
  long bpf_arg(void *ctx, int n)

Get return value of the traced function:
  long bpf_ret_value(void *ctx)

The trampoline now stores number of arguments on ctx-8
address, so it's easy to verify argument index and find
return value argument.

Moving function ip address on the trampoline stack behind
the number of functions arguments, so it's now stored
on ctx-16 address.

Both helpers are inlined by verifier.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c    | 18 +++++++++++---
 include/uapi/linux/bpf.h       | 14 +++++++++++
 kernel/bpf/verifier.c          | 45 ++++++++++++++++++++++++++++++++--
 kernel/trace/bpf_trace.c       | 38 +++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h | 14 +++++++++++
 5 files changed, 122 insertions(+), 7 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 631847907786..67e8ac9aaf0d 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1941,7 +1941,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				void *orig_call)
 {
 	int ret, i, nr_args = m->nr_args;
-	int stack_size = nr_args * 8;
+	int stack_size = nr_args * 8 + 8 /* nr_args */;
 	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
@@ -1987,12 +1987,22 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE);
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
 
-		/* Continue with stack_size for regs storage, stack will
-		 * be correctly restored with 'leave' instruction.
-		 */
+		/* Continue with stack_size for 'nr_args' storage */
 		stack_size -= 8;
 	}
 
+	/* Store number of arguments of the traced function:
+	 *   mov rax, nr_args
+	 *   mov QWORD PTR [rbp - stack_size], rax
+	 */
+	emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_args);
+	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
+
+	/* Continue with stack_size for regs storage, stack will
+	 * be correctly restored with 'leave' instruction.
+	 */
+	stack_size -= 8;
+
 	save_regs(m, &prog, nr_args, stack_size);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a69e4b04ffeb..fc8b344eecba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4957,6 +4957,18 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * long bpf_arg(void *ctx, int n)
+ *	Description
+ *		Get n-th argument of the traced function (for tracing programs).
+ *	Return
+ *		Value of the argument.
+ *
+ * long bpf_ret_value(void *ctx)
+ *	Description
+ *		Get return value of the traced function (for tracing programs).
+ *	Return
+ *		Return value of the traced function.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5140,6 +5152,8 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(arg),			\
+	FN(ret_value),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fac0c3518add..d4249ef6ca7e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13246,11 +13246,52 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
+		/* Implement bpf_arg inline. */
+		if (prog_type == BPF_PROG_TYPE_TRACING &&
+		    insn->imm == BPF_FUNC_arg) {
+			/* Load nr_args from ctx - 8 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+			insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
+			insn_buf[2] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
+			insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
+			insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
+			insn_buf[5] = BPF_JMP_A(1);
+			insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 7);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += 6;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
+		/* Implement bpf_ret_value inline. */
+		if (prog_type == BPF_PROG_TYPE_TRACING &&
+		    insn->imm == BPF_FUNC_ret_value) {
+			/* Load nr_args from ctx - 8 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -8);
+			insn_buf[1] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
+			insn_buf[2] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
+			insn_buf[3] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 4);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += 3;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
 		/* Implement bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
-			/* Load IP address from ctx - 8 */
-			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
+			/* Load IP address from ctx - 16 */
+			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -16);
 
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
 			if (!new_prog)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 25ea521fb8f1..3844cfb45490 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1012,7 +1012,7 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
 BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
 {
 	/* This helper call is inlined by verifier. */
-	return ((u64 *)ctx)[-1];
+	return ((u64 *)ctx)[-2];
 }
 
 static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
@@ -1091,6 +1091,38 @@ static const struct bpf_func_proto bpf_get_branch_snapshot_proto = {
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_2(bpf_arg, void *, ctx, int, n)
+{
+	/* This helper call is inlined by verifier. */
+	u64 nr_args = ((u64 *)ctx)[-1];
+
+	if ((u64) n >= nr_args)
+		return 0;
+	return ((u64 *)ctx)[n];
+}
+
+static const struct bpf_func_proto bpf_arg_proto = {
+	.func		= bpf_arg,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg1_type	= ARG_ANYTHING,
+};
+
+BPF_CALL_1(bpf_ret_value, void *, ctx)
+{
+	/* This helper call is inlined by verifier. */
+	u64 nr_args = ((u64 *)ctx)[-1];
+
+	return ((u64 *)ctx)[nr_args];
+}
+
+static const struct bpf_func_proto bpf_ret_value_proto = {
+	.func		= bpf_ret_value,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+};
+
 static const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1212,6 +1244,10 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_find_vma_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
+	case BPF_FUNC_arg:
+		return &bpf_arg_proto;
+	case BPF_FUNC_ret_value:
+		return &bpf_ret_value_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a69e4b04ffeb..fc8b344eecba 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4957,6 +4957,18 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * long bpf_arg(void *ctx, int n)
+ *	Description
+ *		Get n-th argument of the traced function (for tracing programs).
+ *	Return
+ *		Value of the argument.
+ *
+ * long bpf_ret_value(void *ctx)
+ *	Description
+ *		Get return value of the traced function (for tracing programs).
+ *	Return
+ *		Return value of the traced function.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5140,6 +5152,8 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(arg),			\
+	FN(ret_value),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.31.1

