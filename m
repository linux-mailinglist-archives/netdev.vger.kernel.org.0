Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976948AA0E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfHLVxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:53:04 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:48557 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbfHLVxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:53:03 -0400
Received: by mail-yb1-f201.google.com with SMTP id s17so40630014ybg.15
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BvdjllFJec+jnIcbVyaNPdSiqXqeyTxUF0Oq2y0JBBs=;
        b=trJf4uh35Q+jM8xrFmCBx5akz0qigqRqbkG0gq6EWNOOLO/cOfUvRg1zYN5Krgv3CZ
         Tp1oZIRrBLfLcNZzy6SSSUo71Csv7Y3cFXPmmR7rvXmaWdO9mbsawI7DguqmCmrmbVpj
         OelkWG7IFbyN9AnUs4BQf674u45J6BxNK95owQBiAxsnXJTFtmC3i4b2KMu/kGOCGuWe
         ZqNuQbhRnOMtQHz25dSaqwt4Ubu+FdRkdDanK3J5max+fpx6beFdYmlXC9cOmr4gj4af
         p2l+5noMg0PDkQDUNn0/RkENSN49fNvUA25zUQaYBr0wEjs6uYeq7Va+qoI/9WmON+TA
         96Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BvdjllFJec+jnIcbVyaNPdSiqXqeyTxUF0Oq2y0JBBs=;
        b=rYXcVKrSGg/y4AA3OqO0TXEdAYGKvXx1hLCBjkbUaV3ipBYUbAvXXW5ZtLmCdh8FWM
         ka/MrA0JViuViVVJ/06Phaet/tEvaq7U4plx11Ob1h8b9Zi36sceNr80KJWa3T+0ADPf
         6EN18AA/ipU0eHNv1SGQVOeaS0BXet9EO4vvkRXmTj+rZV/Y4J3+1cV7EkuS5iUyrtbx
         0RMpU1RnxTacS/GS7EMRn/Vjo+dufKtkRYztSVuAegcikKxRKV6FMhgEaIlUSDh+cEWq
         HozDiCKTZo/OhGtJTerIIxyebKq5tyh3OLDh/VSEWn+ZRwunU6OPlX5613rUvhbATKUL
         0I3A==
X-Gm-Message-State: APjAAAUXj5NUe9tuo+IvF5db8T5qdITcQmtn6RsIWPr4mEDljVWjFQ/j
        /Ta4MCdRFGITnhyUO5dmMYxvhCVOjjDqUWUI5Jk=
X-Google-Smtp-Source: APXvYqzdrNVqqM5QUhyk1i8bOe2OLz5Nx2ebt2vknIaukQDHhNvZesBvUdRvlKbq1TzEAKfk3lldP11tUWbgLH1Fk5Q=
X-Received: by 2002:a81:4858:: with SMTP id v85mr13462571ywa.370.1565646782523;
 Mon, 12 Aug 2019 14:53:02 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:47 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-14-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 14/16] include/linux: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        David Windsor <dwindsor@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Dou Liyang <douliyangs@gmail.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, rcu@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link: https://github.com/ClangBuiltLinux/linux/issues/619
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/linux/cache.h       | 6 +++---
 include/linux/compiler.h    | 8 ++++----
 include/linux/cpu.h         | 2 +-
 include/linux/export.h      | 2 +-
 include/linux/init_task.h   | 4 ++--
 include/linux/interrupt.h   | 5 ++---
 include/linux/sched/debug.h | 2 +-
 include/linux/srcutree.h    | 2 +-
 8 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/cache.h b/include/linux/cache.h
index 750621e41d1c..3f4df9eef1e1 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -28,7 +28,7 @@
  * but may get written to during init, so can't live in .rodata (via "const").
  */
 #ifndef __ro_after_init
-#define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
+#define __ro_after_init __section(.data..ro_after_init)
 #endif
 
 #ifndef ____cacheline_aligned
@@ -45,8 +45,8 @@
 
 #ifndef __cacheline_aligned
 #define __cacheline_aligned					\
-  __attribute__((__aligned__(SMP_CACHE_BYTES),			\
-		 __section__(".data..cacheline_aligned")))
+	__aligned(SMP_CACHE_BYTES)				\
+	__section(.data..cacheline_aligned)
 #endif /* __cacheline_aligned */
 
 #ifndef __cacheline_aligned_in_smp
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f0fd5636fddb..5e88e7e33abe 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -24,7 +24,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 			long ______r;					\
 			static struct ftrace_likely_data		\
 				__aligned(4)				\
-				__section("_ftrace_annotated_branch")	\
+				__section(_ftrace_annotated_branch)	\
 				______f = {				\
 				.data.func = __func__,			\
 				.data.file = __FILE__,			\
@@ -60,7 +60,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define __trace_if_value(cond) ({			\
 	static struct ftrace_branch_data		\
 		__aligned(4)				\
-		__section("_ftrace_branch")		\
+		__section(_ftrace_branch)		\
 		__if_trace = {				\
 			.func = __func__,		\
 			.file = __FILE__,		\
@@ -118,7 +118,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	".popsection\n\t"
 
 /* Annotate a C jump table to allow objtool to follow the code flow */
-#define __annotate_jump_table __section(".rodata..c_jump_table")
+#define __annotate_jump_table __section(.rodata..c_jump_table)
 
 #else
 #define annotate_reachable()
@@ -298,7 +298,7 @@ unsigned long read_word_at_a_time(const void *addr)
  * visible to the compiler.
  */
 #define __ADDRESSABLE(sym) \
-	static void * __section(".discard.addressable") __used \
+	static void * __section(.discard.addressable) __used \
 		__PASTE(__addressable_##sym, __LINE__) = (void *)&sym;
 
 /**
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index fcb1386bb0d4..186bbd79d6ce 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -166,7 +166,7 @@ void cpu_startup_entry(enum cpuhp_state state);
 void cpu_idle_poll_ctrl(bool enable);
 
 /* Attach to any functions which should be considered cpuidle. */
-#define __cpuidle	__attribute__((__section__(".cpuidle.text")))
+#define __cpuidle	__section(.cpuidle.text)
 
 bool cpu_in_idle(unsigned long pc);
 
diff --git a/include/linux/export.h b/include/linux/export.h
index fd8711ed9ac4..808c1a0c2ef9 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -104,7 +104,7 @@ struct kernel_symbol {
  * discarded in the final link stage.
  */
 #define __ksym_marker(sym)	\
-	static int __ksym_marker_##sym[0] __section(".discard.ksym") __used
+	static int __ksym_marker_##sym[0] __section(.discard.ksym) __used
 
 #define __EXPORT_SYMBOL(sym, sec)				\
 	__ksym_marker(sym);					\
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6049baa5b8bc..50139505da34 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -51,12 +51,12 @@ extern struct cred init_cred;
 
 /* Attach to the init_task data structure for proper alignment */
 #ifdef CONFIG_ARCH_TASK_STRUCT_ON_STACK
-#define __init_task_data __attribute__((__section__(".data..init_task")))
+#define __init_task_data __section(.data..init_task)
 #else
 #define __init_task_data /**/
 #endif
 
 /* Attach to the thread_info data structure for proper alignment */
-#define __init_thread_info __attribute__((__section__(".data..init_thread_info")))
+#define __init_thread_info __section(.data..init_thread_info)
 
 #endif
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5b8328a99b2a..29debfe4dd0f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -741,8 +741,7 @@ extern int arch_early_irq_init(void);
 /*
  * We want to know which function is an entrypoint of a hardirq or a softirq.
  */
-#define __irq_entry		 __attribute__((__section__(".irqentry.text")))
-#define __softirq_entry  \
-	__attribute__((__section__(".softirqentry.text")))
+#define __irq_entry	__section(.irqentry.text)
+#define __softirq_entry	__section(.softirqentry.text)
 
 #endif
diff --git a/include/linux/sched/debug.h b/include/linux/sched/debug.h
index 95fb9e025247..e17b66221fdd 100644
--- a/include/linux/sched/debug.h
+++ b/include/linux/sched/debug.h
@@ -42,7 +42,7 @@ extern void proc_sched_set_task(struct task_struct *p);
 #endif
 
 /* Attach to any functions which should be ignored in wchan output. */
-#define __sched		__attribute__((__section__(".sched.text")))
+#define __sched		__section(.sched.text)
 
 /* Linker adds these: start and end of __sched functions */
 extern char __sched_text_start[], __sched_text_end[];
diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index 9cfcc8a756ae..9de652f4e1bd 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -124,7 +124,7 @@ struct srcu_struct {
 # define __DEFINE_SRCU(name, is_static)					\
 	is_static struct srcu_struct name;				\
 	struct srcu_struct * const __srcu_struct_##name			\
-		__section("___srcu_struct_ptrs") = &name
+		__section(___srcu_struct_ptrs) = &name
 #else
 # define __DEFINE_SRCU(name, is_static)					\
 	static DEFINE_PER_CPU(struct srcu_data, name##_srcu_data);	\
-- 
2.23.0.rc1.153.gdeed80330f-goog

