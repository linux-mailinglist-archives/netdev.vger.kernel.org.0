Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3703F8EFE
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbhHZTmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:42:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243599AbhHZTmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZxI6wOoaWT81ALa8QkvdxqAQKY5lKnGUs6cJrU25Fs=;
        b=RRgn1bKlERf8XUV/0EPJaSSTK9ZiwOWppz0HKpv5Vg6SEw4hd7aEJM3kA5B661quNMCPiW
        jPV/4wJg6bMs08qknVPmPQ4/9erUF75egxAJA3/6nv1J8XnlWoJX3sdXZ88aWmmGSuCDPb
        StP2/y95AhwQmdoqwLdLh4r9Kweaucw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-uViGV4h_Me2SWFf8yxtXqg-1; Thu, 26 Aug 2021 15:41:17 -0400
X-MC-Unique: uViGV4h_Me2SWFf8yxtXqg-1
Received: by mail-wr1-f71.google.com with SMTP id p10-20020adfce0a000000b001572d05c970so1185906wrn.21
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IZxI6wOoaWT81ALa8QkvdxqAQKY5lKnGUs6cJrU25Fs=;
        b=gqwsHGtbX8d5yP940kLpT2Oq9TYvR1eMZfOjJmIXGojEVeAtXAu+eq7aXwagtYN7dU
         nAzigwNwuxogOWhakGEp1DDAXbcQX9PIvHHS0iJ9iCBlPcLlsS1dBSz/hoIgKRLHAjrv
         JdbWbaw4Ua6fkjDlhAFmNH4QmIhd3AtrNG9toZYxkr6CNKMcjN/EuhTrG3zIK1CqvQ2u
         hdxXnA0JIllJVS55JzU90OKotttIMEMEbSAoxXmdOGO0ZurK6f3/tJO2pcMkb5DExD5W
         GtZXz36Y1wV1I60RTOigfNHKxsNybl+Ke42fA6uxVBzc8ndYwCiTmpWeBRU6PJ88THkk
         ximQ==
X-Gm-Message-State: AOAM532uKVlKn4NdfPKf+rbZMhtHstOUOjBEsjyo8HLQZEL6M/PJaUtY
        8qjOraxvToAjwS63OHRCC8WwA33bp5cOKty60Qg1dTt3yUYIwZRjIW3oNWaJgpxNmIdtK8IExu3
        v1iOgw+hKG0JCVR9X
X-Received: by 2002:adf:9f0d:: with SMTP id l13mr848692wrf.328.1630006875830;
        Thu, 26 Aug 2021 12:41:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwo67KkXMdAPOOGMrz24uHf7y9/tWyscdaPfYgn96pwyBfYz/iJlHc46O9G4R2MLdO7VZ/buQ==
X-Received: by 2002:adf:9f0d:: with SMTP id l13mr848672wrf.328.1630006875603;
        Thu, 26 Aug 2021 12:41:15 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id n14sm4018343wrx.10.2021.08.26.12.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:41:15 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 18/27] bpf, x64: Store properly return value for trampoline with multi func programs
Date:   Thu, 26 Aug 2021 21:39:13 +0200
Message-Id: <20210826193922.66204-19-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have multi func program attached, the trampoline
switched to the function model of the multi func program.

This breaks already attached standard programs, for example
when we attach following program:

  SEC("fexit/bpf_fentry_test2")
  int BPF_PROG(test1, int a, __u64 b, int ret)

the trampoline pushes on stack args 'a' and 'b' and return
value 'ret'.

When following multi func program is attached to bpf_fentry_test2:

  SEC("fexit.multi/bpf_fentry_test*")
  int BPF_PROG(test2, __u64 a, __u64 b, __u64 c, __u64 d,
                       __u64 e, __u64 f, int ret)

the trampoline takes this program model and pushes all 6 args
and return value on stack.

But we still have the original 'test1' program attached, that
expects 'ret' value where there's 'c' argument now:

  test1(a, b, c)

To fix that we simply overwrite 'c' argument with 'ret' value,
so test1 is called as expected and test2 gets called as:

  test2(a, b, ret, d, e, f, ret)

which is ok, because 'c' is not defined for bpf_fentry_test2
anyway.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 40 ++++++++++++++++++++++++++++++-------
 include/linux/bpf.h         |  1 +
 kernel/bpf/trampoline.c     |  1 +
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 9f31197780ae..3f7911a92d62 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1744,7 +1744,7 @@ static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
 }
 
 static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
-			   struct bpf_prog *p, int stack_size, bool mod_ret)
+			   struct bpf_prog *p, int stack_size, bool mod_ret, int args_off)
 {
 	u8 *prog = *pprog;
 	u8 *jmp_insn;
@@ -1780,9 +1780,14 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
 	/* BPF_TRAMP_MODIFY_RETURN trampolines can modify the return
 	 * of the previous call which is then passed on the stack to
 	 * the next BPF program.
+	 * Store the return value also to original args' end in case
+	 * we have multi func programs in trampoline.
 	 */
-	if (mod_ret)
+	if (mod_ret) {
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
+		if (args_off)
+			emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -args_off);
+	}
 
 	/* replace 2 nops with JE insn, since jmp target is known */
 	jmp_insn[0] = X86_JE;
@@ -1834,7 +1839,7 @@ static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
 	u8 *prog = *pprog;
 
 	for (i = 0; i < tp->nr_progs; i++) {
-		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, false))
+		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, false, 0))
 			return -EINVAL;
 	}
 	*pprog = prog;
@@ -1843,7 +1848,7 @@ static int invoke_bpf(const struct btf_func_model *m, u8 **pprog,
 
 static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 			      struct bpf_tramp_progs *tp, int stack_size,
-			      u8 **branches)
+			      u8 **branches, int args_off)
 {
 	u8 *prog = *pprog;
 	int i;
@@ -1853,8 +1858,15 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 	 */
 	emit_mov_imm32(&prog, false, BPF_REG_0, 0);
 	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
+
+	/* Store the return value also to original args' end in case
+	 * we have multi func programs in trampoline.
+	 */
+	if (args_off)
+		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -args_off);
+
 	for (i = 0; i < tp->nr_progs; i++) {
-		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, true))
+		if (invoke_bpf_prog(m, &prog, tp->progs[i], stack_size, true, args_off))
 			return -EINVAL;
 
 		/* mod_ret prog stored return value into [rbp - 8]. Emit:
@@ -1942,7 +1954,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				struct bpf_tramp_progs *tprogs,
 				void *orig_call)
 {
-	int ret, i, nr_args = m->nr_args;
+	int ret, i, args_off = 0, nr_args = m->nr_args;
 	int stack_size = nr_args * 8;
 	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
@@ -1958,6 +1970,13 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	    (flags & BPF_TRAMP_F_SKIP_FRAME))
 		return -EINVAL;
 
+	/* if m->nr_args_orig != 0, then we have multi prog model and
+	 * we need to also store return value at the end of standard
+	 * trampoline's arguments
+	 */
+	if (m->nr_args_orig && m->nr_args > m->nr_args_orig)
+		args_off = (m->nr_args - m->nr_args_orig) * 8 + 8;
+
 	if (flags & BPF_TRAMP_F_CALL_ORIG)
 		stack_size += 8; /* room for return value of orig_call */
 
@@ -2015,7 +2034,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 			return -ENOMEM;
 
 		if (invoke_bpf_mod_ret(m, &prog, fmod_ret, stack_size,
-				       branches)) {
+				       branches, args_off)) {
 			ret = -EINVAL;
 			goto cleanup;
 		}
@@ -2036,6 +2055,13 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		}
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
+
+		/* store return value also to original args' end in case we have
+		 * multi func programs in trampoline
+		 */
+		if (args_off)
+			emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -args_off);
+
 		im->ip_after_call = prog;
 		memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
 		prog += X86_PATCH_SIZE;
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3ce4656e2057..373f45ae7dce 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -563,6 +563,7 @@ struct btf_func_model {
 	u8 ret_size;
 	u8 nr_args;
 	u8 arg_size[MAX_BPF_FUNC_ARGS];
+	u8 nr_args_orig;
 };
 
 /* Restore arguments before returning from trampoline to let original function
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6ff5c2512f91..308d58e698be 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -398,6 +398,7 @@ static bool needs_multi_model(struct bpf_trampoline *tr, struct btf_func_model *
 	if (tr->func.model.nr_args >= multi->func.model.nr_args)
 		return false;
 	memcpy(new, &multi->func.model, sizeof(*new));
+	new->nr_args_orig = tr->func.model.nr_args;
 	return true;
 }
 
-- 
2.31.1

