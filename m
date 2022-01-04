Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66481483DC2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiADIKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233980AbiADIKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jYMe7lfz1ar5GbZoHBTiKVhZmhUJ2P1sIXs88W+jgrk=;
        b=XKMNO4ouO+xU/PSLvHb/9q/0tjdkY3Opwjl9+wSv9pvmLBJTKQoKzBxw5nsel0ulZtadUO
        ZD9WNpXVPjyIuCrYaW8+y3ipYGRqV7d3r996lFuPDL208mc6ea4EurDZXWR8QmLkN/LOnu
        HLUyjmRAmrVKkCrhdgcfphNMEoGCcr4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-ZDhFd6bYOMOtRjSU3JWI9w-1; Tue, 04 Jan 2022 03:10:16 -0500
X-MC-Unique: ZDhFd6bYOMOtRjSU3JWI9w-1
Received: by mail-ed1-f72.google.com with SMTP id q15-20020a056402518f00b003f87abf9c37so24636030edd.15
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jYMe7lfz1ar5GbZoHBTiKVhZmhUJ2P1sIXs88W+jgrk=;
        b=2BBRAIb2ko1twpgYJ8T9D3PWdfXJODAYNmQwggQ3WOuBD2ZCcMUZDVk3tGC4lwFaJ6
         R1pfIKO019LZbDQ+pViu5a/T/CobK1baxqSFO3MHoIrVMNZ+fJpV/N4zsDpFep9j2pqd
         Hvh0mDFnPxsCMq2rPzQ+Aaqz/6seIWmXNVzGjYu6s76/hTPE80aVEau9q2my9+5XeXxq
         C2I07uwXO27lg0uy3QWRcKYk8SJjcj6mkA/apthZpAPR4l1Cz71JQSZTih/fLcwDKoQ/
         zp9BObEVnfPyhp4IgEuTT9YoPJr8Gp3Zlp8ora9sU1Klx7gmTPV0GYG3I+RaWly3UOfI
         4Xmg==
X-Gm-Message-State: AOAM532w7Bl5Y60Eu7zNT/iXz9EH9pMRKgqgIVwnSsS8Fmg1t7vUy3zs
        vlsidGGG5N9GaL9HWd+SxwyxlnOp8jWSXx242VpfOKroPW9FUXnOL1rAFZEE8uh3j7Bf8+xVVJZ
        fzszSgtCqrKZsrM++
X-Received: by 2002:a17:907:1b24:: with SMTP id mp36mr40470827ejc.487.1641283815388;
        Tue, 04 Jan 2022 00:10:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJys/NBfmK+oSvUScUuxZvvogGO5lENwe6I7iUMzwZZ9EBfuaQOOl6Y5x9wI3K2lWpQAADJuHA==
X-Received: by 2002:a17:907:1b24:: with SMTP id mp36mr40470817ejc.487.1641283815175;
        Tue, 04 Jan 2022 00:10:15 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id qa41sm11271437ejc.0.2022.01.04.00.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:14 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 05/13] kprobe: Allow to get traced function address for multi ftrace kprobes
Date:   Tue,  4 Jan 2022 09:09:35 +0100
Message-Id: <20220104080943.113249-6-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current bpf_get_func_ip_kprobe helper does not work properly,
when used in ebpf program triggered by the new multi kprobes.

We can't use kprobe's func_addr in bpf_get_func_ip_kprobe helper,
because there are multiple functions registered for single kprobe
object.

Adding new per cpu variable current_ftrace_multi_addr and extra
address in kretprobe_instance object to keep current traced function
address for each cpu for both kprobe handler and kretprobe trampoline.

The address value is set/passed as follows, for kprobe:

  kprobe_ftrace_multi_handler
  {
    old = kprobe_ftrace_multi_addr_set(ip);
    handler..
    kprobe_ftrace_multi_addr_set(old);
  }

For kretprobe:

  kprobe_ftrace_multi_handler
  {
    old = kprobe_ftrace_multi_addr_set(ip);
    ...
      pre_handler_kretprobe
      {
        ri->ftrace_multi_addr = kprobe_ftrace_multi_addr
      }
    ...
    kprobe_ftrace_multi_addr_set(old);
  }

  __kretprobe_trampoline_handler
  {
    prev_func_addr = kprobe_ftrace_multi_addr_set(ri->ftrace_multi_addr);
    handler..
    kprobe_ftrace_multi_addr_set(prev_func_addr);
  }

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/kernel/kprobes/ftrace.c |  3 +++
 include/linux/kprobes.h          | 26 ++++++++++++++++++++++++++
 kernel/kprobes.c                 |  6 ++++++
 kernel/trace/bpf_trace.c         |  7 ++++++-
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index ac4d256b89c6..8caaa58c3a64 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -72,6 +72,7 @@ NOKPROBE_SYMBOL(kprobe_ftrace_handler);
 void kprobe_ftrace_multi_handler(unsigned long ip, unsigned long parent_ip,
 				 struct ftrace_ops *ops, struct ftrace_regs *fregs)
 {
+	unsigned long old;
 	struct kprobe *p;
 	int bit;
 
@@ -79,8 +80,10 @@ void kprobe_ftrace_multi_handler(unsigned long ip, unsigned long parent_ip,
 	if (bit < 0)
 		return;
 
+	old = kprobe_ftrace_multi_addr_set(ip);
 	p = container_of(ops, struct kprobe, multi.ops);
 	ftrace_handler(p, ip, fregs);
+	kprobe_ftrace_multi_addr_set(old);
 
 	ftrace_test_recursion_unlock(bit);
 }
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index a31da6202b5c..3f0522b9538b 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -191,6 +191,7 @@ struct kretprobe_instance {
 	struct kretprobe_holder *rph;
 	kprobe_opcode_t *ret_addr;
 	void *fp;
+	unsigned long ftrace_multi_addr;
 	char data[];
 };
 
@@ -387,16 +388,37 @@ static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
 
 #ifdef CONFIG_KPROBES_ON_FTRACE
+DECLARE_PER_CPU(unsigned long, current_ftrace_multi_addr);
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				  struct ftrace_ops *ops, struct ftrace_regs *fregs);
 extern void kprobe_ftrace_multi_handler(unsigned long ip, unsigned long parent_ip,
 					struct ftrace_ops *ops, struct ftrace_regs *fregs);
 extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
+
+static inline unsigned long kprobe_ftrace_multi_addr(void)
+{
+	return __this_cpu_read(current_ftrace_multi_addr);
+}
+static inline unsigned long kprobe_ftrace_multi_addr_set(unsigned long addr)
+{
+	unsigned long old = __this_cpu_read(current_ftrace_multi_addr);
+
+	__this_cpu_write(current_ftrace_multi_addr, addr);
+	return old;
+}
 #else
 static inline int arch_prepare_kprobe_ftrace(struct kprobe *p)
 {
 	return -EINVAL;
 }
+static inline unsigned long kprobe_ftrace_multi_addr_set(unsigned long addr)
+{
+	return 0;
+}
+static inline unsigned long kprobe_ftrace_multi_addr(void)
+{
+	return 0;
+}
 #endif /* CONFIG_KPROBES_ON_FTRACE */
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
@@ -514,6 +536,10 @@ static inline int kprobe_get_kallsym(unsigned int symnum, unsigned long *value,
 {
 	return -ERANGE;
 }
+static inline unsigned long kprobe_ftrace_multi_addr(void)
+{
+	return 0;
+}
 #endif /* CONFIG_KPROBES */
 
 static inline int disable_kretprobe(struct kretprobe *rp)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 04fc411ca30c..6ba249f3a0cb 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1064,6 +1064,8 @@ static bool in_kretprobe_blacklist(void *addr)
 }
 
 #ifdef CONFIG_KPROBES_ON_FTRACE
+DEFINE_PER_CPU(unsigned long, current_ftrace_multi_addr);
+
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
 	.flags = FTRACE_OPS_FL_SAVE_REGS,
@@ -2106,11 +2108,14 @@ unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
 		rp = get_kretprobe(ri);
 		if (rp && rp->handler) {
 			struct kprobe *prev = kprobe_running();
+			unsigned long prev_func_addr;
 
+			prev_func_addr = kprobe_ftrace_multi_addr_set(ri->ftrace_multi_addr);
 			__this_cpu_write(current_kprobe, &rp->kp);
 			ri->ret_addr = correct_ret_addr;
 			rp->handler(ri, regs);
 			__this_cpu_write(current_kprobe, prev);
+			kprobe_ftrace_multi_addr_set(prev_func_addr);
 		}
 		if (first == node)
 			break;
@@ -2161,6 +2166,7 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 	}
 
 	arch_prepare_kretprobe(ri, regs);
+	ri->ftrace_multi_addr = kprobe_ftrace_multi_addr();
 
 	__llist_add(&ri->llist, &current->kretprobe_instances);
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 25631253084a..39f4d476cfca 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1026,7 +1026,12 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
 {
 	struct kprobe *kp = kprobe_running();
 
-	return kp ? (uintptr_t)kp->func_addr : 0;
+	if (!kp)
+		return 0;
+	if (kprobe_ftrace_multi(kp))
+		return (uintptr_t) kprobe_ftrace_multi_addr();
+	else
+		return (uintptr_t) kp->func_addr;
 }
 
 static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
-- 
2.33.1

