Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5893F8ED5
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243504AbhHZTkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:40:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243491AbhHZTke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sLqTTRxVL8xfk55K+9eSTs+Utqi1uRVMWYGVEA7msME=;
        b=J+gunPJmeIbku8bzKRygcTunPznLueaAREQJkQixSJFzDdXsBgtXH2BRQ+JotyqCOB/1Fb
        ZruvFU61zRVKgKhGWPWfT6f4XnEXLTbxfZWZu/AJ9ABTOqj3DCu07v0YkFzXDLiE2I61vO
        PQGmvHxgxsjUgSEjN9XbbFl8o40Jhrw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-ny_1C4h4NEGkbETC0OutnA-1; Thu, 26 Aug 2021 15:39:43 -0400
X-MC-Unique: ny_1C4h4NEGkbETC0OutnA-1
Received: by mail-wm1-f70.google.com with SMTP id j33-20020a05600c48a100b002e879427915so1267234wmp.5
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:39:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sLqTTRxVL8xfk55K+9eSTs+Utqi1uRVMWYGVEA7msME=;
        b=DJ4Dm3YrQ5oUlWebrN95mq7CbuHqE9C/M4QDkSQHaAayVw883LuWE3vRMNyrrjxJ5u
         HArZfRErcq2hOivuqAkgyHDpVyreBnRuiW0DCh1g78uH864LlrEJuIcgjFcslsQxrFTs
         4588cRA/5tgSmDo9aAS4SdAuVvByGKBFfzWUAYk6I1hVkTOXmGNdOX+rTUfiAVRuBq/J
         Z/EjJLr9RAN6hNckeINnd1Vi3PJ+6nUuS9jyWIH2Dq83/SN8uod4VLmuiznrq+uLEj2j
         OBaFsBze/xdk3arBQDyZ+Gmx2N9tNpGOBfZBpptYe3NiLShRxEzqZREYJEr1HX0D1R0A
         QI3w==
X-Gm-Message-State: AOAM533avDcc87Jyhtoss2E+mCBvjn0pSgVlDBerlCD7cwhwiqKKHLdu
        OUbKFRJzDudgFtU5Y/VvdrbXSqHtbOq9Hu9wYrfWeAXOjq7rceKdhzIcS8WxGY0uT1Uc34KJ8g0
        pD1WrJ6AT0me2DO+T
X-Received: by 2002:a05:600c:1ca7:: with SMTP id k39mr5210880wms.162.1630006782217;
        Thu, 26 Aug 2021 12:39:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVCSYcOLJeoO9HAhJSY06pVgY7DESSfJAk8Q4dTP9qnnmFI+O8vT7InR93U6Zg+d5eIZNF4A==
X-Received: by 2002:a05:600c:1ca7:: with SMTP id k39mr5210858wms.162.1630006782038;
        Thu, 26 Aug 2021 12:39:42 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id g76sm8944197wme.16.2021.08.26.12.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:39:41 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 03/27] x86/ftrace: Make function graph use ftrace directly
Date:   Thu, 26 Aug 2021 21:38:58 +0200
Message-Id: <20210826193922.66204-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

We don't need special hook for graph tracer entry point,
but instead we can use graph_ops::func function to install
the return_hooker.

This moves the graph tracing setup _before_ the direct
trampoline prepares the stack, so the return_hooker will
be called when the direct trampoline is finished.

This simplifies the code, because we don't need to take into
account the direct trampoline setup when preparing the graph
tracer hooker and we can allow function graph tracer on entries
registered with direct trampoline.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/include/asm/ftrace.h |  9 +++++++--
 arch/x86/kernel/ftrace.c      | 37 ++++++++++++++++++++++++++++++++---
 arch/x86/kernel/ftrace_64.S   | 29 +--------------------------
 include/linux/ftrace.h        |  6 ++++++
 kernel/trace/fgraph.c         |  6 ++++--
 5 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 9f3130f40807..024d9797646e 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -57,6 +57,13 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
 
 #define ftrace_instruction_pointer_set(fregs, _ip)	\
 	do { (fregs)->regs.ip = (_ip); } while (0)
+
+struct ftrace_ops;
+#define ftrace_graph_func ftrace_graph_func
+void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
+		       struct ftrace_ops *op, struct ftrace_regs *fregs);
+#else
+#define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -65,8 +72,6 @@ struct dyn_arch_ftrace {
 	/* No extra data needed for x86 */
 };
 
-#define FTRACE_GRAPH_TRAMP_ADDR FTRACE_GRAPH_ADDR
-
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index c555624da989..804fcc6ef2c7 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -527,7 +527,7 @@ static void *addr_from_call(void *ptr)
 	return ptr + CALL_INSN_SIZE + call.disp;
 }
 
-void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
+void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
 			   unsigned long frame_pointer);
 
 /*
@@ -541,7 +541,8 @@ static void *static_tramp_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
 	void *ptr;
 
 	if (ops && ops->trampoline) {
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+#if !defined(CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS) && \
+	defined(CONFIG_FUNCTION_GRAPH_TRACER)
 		/*
 		 * We only know about function graph tracer setting as static
 		 * trampoline.
@@ -589,8 +590,9 @@ void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-extern void ftrace_graph_call(void);
 
+#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
+extern void ftrace_graph_call(void);
 static const char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
 {
 	return text_gen_insn(JMP32_INSN_OPCODE, (void *)ip, (void *)addr);
@@ -618,7 +620,17 @@ int ftrace_disable_ftrace_graph_caller(void)
 
 	return ftrace_mod_jmp(ip, &ftrace_stub);
 }
+#else /* !CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS */
+int ftrace_enable_ftrace_graph_caller(void)
+{
+	return 0;
+}
 
+int ftrace_disable_ftrace_graph_caller(void)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS */
 #endif /* !CONFIG_DYNAMIC_FTRACE */
 
 /*
@@ -629,6 +641,7 @@ void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
 			   unsigned long frame_pointer)
 {
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
+	int bit;
 
 	/*
 	 * When resuming from suspend-to-ram, this function can be indirectly
@@ -648,7 +661,25 @@ void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
+	bit = ftrace_test_recursion_trylock(ip, *parent);
+	if (bit < 0)
+		return;
+
 	if (!function_graph_enter(*parent, ip, frame_pointer, parent))
 		*parent = return_hooker;
+
+	ftrace_test_recursion_unlock(bit);
+}
+
+#ifdef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
+void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
+		       struct ftrace_ops *op, struct ftrace_regs *fregs)
+{
+	struct pt_regs *regs = &fregs->regs;
+	unsigned long *stack = (unsigned long *)kernel_stack_pointer(regs);
+
+	prepare_ftrace_return(ip, (unsigned long *)stack, 0);
 }
+#endif
+
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index a8eb084a7a9a..7a879901f103 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -174,11 +174,6 @@ SYM_INNER_LABEL(ftrace_caller_end, SYM_L_GLOBAL)
 SYM_FUNC_END(ftrace_caller);
 
 SYM_FUNC_START(ftrace_epilogue)
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
-	jmp ftrace_stub
-#endif
-
 /*
  * This is weak to keep gas from relaxing the jumps.
  * It is also used to copy the retq for trampolines.
@@ -288,15 +283,6 @@ SYM_FUNC_START(__fentry__)
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 
-fgraph_trace:
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	cmpq $ftrace_stub, ftrace_graph_return
-	jnz ftrace_graph_caller
-
-	cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
-	jnz ftrace_graph_caller
-#endif
-
 SYM_INNER_LABEL(ftrace_stub, SYM_L_GLOBAL)
 	retq
 
@@ -314,25 +300,12 @@ trace:
 	CALL_NOSPEC r8
 	restore_mcount_regs
 
-	jmp fgraph_trace
+	jmp ftrace_stub
 SYM_FUNC_END(__fentry__)
 EXPORT_SYMBOL(__fentry__)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-SYM_FUNC_START(ftrace_graph_caller)
-	/* Saves rbp into %rdx and fills first parameter  */
-	save_mcount_regs
-
-	leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
-	movq $0, %rdx	/* No framepointers needed */
-	call	prepare_ftrace_return
-
-	restore_mcount_regs
-
-	retq
-SYM_FUNC_END(ftrace_graph_caller)
-
 SYM_FUNC_START(return_to_handler)
 	subq  $24, %rsp
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index a69f363b61bf..9b218e59a608 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -614,6 +614,12 @@ void ftrace_modify_all_code(int command);
 extern void ftrace_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
 extern int ftrace_disable_ftrace_graph_caller(void);
+#ifndef ftrace_graph_func
+#define ftrace_graph_func ftrace_stub
+#define FTRACE_OPS_GRAPH_STUB FTRACE_OPS_FL_STUB
+#else
+#define FTRACE_OPS_GRAPH_STUB 0
+#endif
 #else
 static inline int ftrace_enable_ftrace_graph_caller(void) { return 0; }
 static inline int ftrace_disable_ftrace_graph_caller(void) { return 0; }
diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index b8a0d1d564fb..22061d38fc00 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -115,6 +115,7 @@ int function_graph_enter(unsigned long ret, unsigned long func,
 {
 	struct ftrace_graph_ent trace;
 
+#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
 	/*
 	 * Skip graph tracing if the return location is served by direct trampoline,
 	 * since call sequence and return addresses are unpredictable anyway.
@@ -124,6 +125,7 @@ int function_graph_enter(unsigned long ret, unsigned long func,
 	if (ftrace_direct_func_count &&
 	    ftrace_find_rec_direct(ret - MCOUNT_INSN_SIZE))
 		return -EBUSY;
+#endif
 	trace.func = func;
 	trace.depth = ++current->curr_ret_depth;
 
@@ -333,10 +335,10 @@ unsigned long ftrace_graph_ret_addr(struct task_struct *task, int *idx,
 #endif /* HAVE_FUNCTION_GRAPH_RET_ADDR_PTR */
 
 static struct ftrace_ops graph_ops = {
-	.func			= ftrace_stub,
+	.func			= ftrace_graph_func,
 	.flags			= FTRACE_OPS_FL_INITIALIZED |
 				   FTRACE_OPS_FL_PID |
-				   FTRACE_OPS_FL_STUB,
+				   FTRACE_OPS_GRAPH_STUB,
 #ifdef FTRACE_GRAPH_TRAMP_ADDR
 	.trampoline		= FTRACE_GRAPH_TRAMP_ADDR,
 	/* trampoline_size is only needed for dynamically allocated tramps */
-- 
2.31.1

