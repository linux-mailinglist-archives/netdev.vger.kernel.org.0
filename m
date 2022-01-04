Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA48483DBA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbiADIKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:10:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233779AbiADIKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:10:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641283805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BFEB//ISNWLrFisbkclN0B/NzP/+Sn4aN88iN/SnSE=;
        b=O64QoyJxmrfA5ucp88cN0UMUQeV3iCosmFoTHXds4ydY/G5oBMAqeRe6vSlKiyaG0YurrX
        4qZ8NpBUoWrknC5XPWF+fM0cUhM1Y7hAaOLeEOb4PtwcpL69a7uDhynxMldi0yiA6d6ZR9
        b/Vxbr9RfYtzMljDdrHyETnftrL538M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-UDUetoNgOxyDt7I2iHP_SQ-1; Tue, 04 Jan 2022 03:10:04 -0500
X-MC-Unique: UDUetoNgOxyDt7I2iHP_SQ-1
Received: by mail-ed1-f72.google.com with SMTP id ch27-20020a0564021bdb00b003f8389236f8so24469151edb.19
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:10:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BFEB//ISNWLrFisbkclN0B/NzP/+Sn4aN88iN/SnSE=;
        b=lGDQsxW549KgBS3Yyv4/EdtVw9x9LCmBK7amI4+xMVwE9OZECEBwAvTS6RPZRj+3Gp
         y5d4d0ZqztB1jDFfanBy8eJ8G7TpcwtCq/L1OpWt0Wf3ndKh5DIsTfzJs/+OiOx7pkoI
         NnmibOsbiGR7rsFCPwyXFZlR4Od1Xsc/50dmjOO8dD2c8OdjSwcHpt8ji7+kPGE9d+Xv
         p8KRgOQ3yBCRZ/ozayI25t8OfCHY7ALEK1xqBvG5n3ubfj7PavJ5gbaVbq9eojqThYyD
         RsCSD9V+M5scfAtOSBZAcIt/y56KhNpxYnteUylE2cEyB0mUVObO9x8WeUNHzlgaGviT
         VM4w==
X-Gm-Message-State: AOAM530dzQ0EQ1vykvfzwa4OeunQ7wNx7R3J5GR96Gitg6/1ocu/iMzf
        a4MlEAue+9LZtFySP3wEace5ns/MPjfsgdYsILZPrK77YDHs8Yyw7boFAT9qMsBY/20hmnqG713
        qIqD3mjYNvMFvQfZ6
X-Received: by 2002:aa7:d299:: with SMTP id w25mr48023971edq.269.1641283802978;
        Tue, 04 Jan 2022 00:10:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybPAhyMNJAbOkPpI/5fB1tOEsb49UmlCJ1ODo++dlxof7LW1b5pCI0lsf7ki81kO1IxWQOxg==
X-Received: by 2002:aa7:d299:: with SMTP id w25mr48023957edq.269.1641283802782;
        Tue, 04 Jan 2022 00:10:02 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id hu8sm11296854ejc.32.2022.01.04.00.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 00:10:02 -0800 (PST)
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
Subject: [PATCH 03/13] kprobe: Add support to register multiple ftrace kprobes
Date:   Tue,  4 Jan 2022 09:09:33 +0100
Message-Id: <20220104080943.113249-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220104080943.113249-1-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to register kprobe on multiple addresses within
single kprobe object instance.

It uses the CONFIG_KPROBES_ON_FTRACE feature (so it's only
available for function entry addresses) and separated ftrace_ops
object placed directly in the kprobe object.

There's new CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE config option,
enabled for archs that support multi kprobes.

It registers all the provided addresses in the ftrace_ops object
filter and adds separate ftrace_ops callback.

To register multi kprobe user provides array of addresses or
symbols with their count, like:

  struct kprobe kp = {};

  kp.multi.symbols = (const char **) symbols;
  kp.multi.cnt = cnt;
  ...

  err = register_kprobe(&kp);

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/Kconfig                     |   3 +
 arch/x86/Kconfig                 |   1 +
 arch/x86/kernel/kprobes/ftrace.c |  48 ++++++--
 include/linux/kprobes.h          |  25 ++++
 kernel/kprobes.c                 | 204 +++++++++++++++++++++++++------
 5 files changed, 235 insertions(+), 46 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index d3c4ab249e9c..0131636e1ef8 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -191,6 +191,9 @@ config HAVE_OPTPROBES
 config HAVE_KPROBES_ON_FTRACE
 	bool
 
+config HAVE_KPROBES_MULTI_ON_FTRACE
+	bool
+
 config ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	bool
 	help
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5c2ccb85f2ef..0c870238016a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -217,6 +217,7 @@ config X86
 	select HAVE_KERNEL_ZSTD
 	select HAVE_KPROBES
 	select HAVE_KPROBES_ON_FTRACE
+	select HAVE_KPROBES_MULTI_ON_FTRACE
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
 	select HAVE_KVM
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index dd2ec14adb77..ac4d256b89c6 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -12,22 +12,14 @@
 
 #include "common.h"
 
-/* Ftrace callback handler for kprobes -- called under preempt disabled */
-void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
-			   struct ftrace_ops *ops, struct ftrace_regs *fregs)
+static void ftrace_handler(struct kprobe *p, unsigned long ip,
+			   struct ftrace_regs *fregs)
 {
 	struct pt_regs *regs = ftrace_get_regs(fregs);
-	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
-	int bit;
 
-	bit = ftrace_test_recursion_trylock(ip, parent_ip);
-	if (bit < 0)
-		return;
-
-	p = get_kprobe((kprobe_opcode_t *)ip);
 	if (unlikely(!p) || kprobe_disabled(p))
-		goto out;
+		return;
 
 	kcb = get_kprobe_ctlblk();
 	if (kprobe_running()) {
@@ -57,11 +49,43 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 		 */
 		__this_cpu_write(current_kprobe, NULL);
 	}
-out:
+}
+
+/* Ftrace callback handler for kprobes -- called under preempt disabled */
+void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+			   struct ftrace_ops *ops, struct ftrace_regs *fregs)
+{
+	struct kprobe *p;
+	int bit;
+
+	bit = ftrace_test_recursion_trylock(ip, parent_ip);
+	if (bit < 0)
+		return;
+
+	p = get_kprobe((kprobe_opcode_t *)ip);
+	ftrace_handler(p, ip, fregs);
+
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(kprobe_ftrace_handler);
 
+void kprobe_ftrace_multi_handler(unsigned long ip, unsigned long parent_ip,
+				 struct ftrace_ops *ops, struct ftrace_regs *fregs)
+{
+	struct kprobe *p;
+	int bit;
+
+	bit = ftrace_test_recursion_trylock(ip, parent_ip);
+	if (bit < 0)
+		return;
+
+	p = container_of(ops, struct kprobe, multi.ops);
+	ftrace_handler(p, ip, fregs);
+
+	ftrace_test_recursion_unlock(bit);
+}
+NOKPROBE_SYMBOL(kprobe_ftrace_multi_handler);
+
 int arch_prepare_kprobe_ftrace(struct kprobe *p)
 {
 	p->ainsn.insn = NULL;
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index a204df4fef96..03fd86ef69cb 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -68,6 +68,16 @@ struct kprobe {
 	/* location of the probe point */
 	kprobe_opcode_t *addr;
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	/* location of the multi probe points */
+	struct {
+		const char **symbols;
+		kprobe_opcode_t **addrs;
+		unsigned int cnt;
+		struct ftrace_ops ops;
+	} multi;
+#endif
+
 	/* Allow user to indicate symbol name of the probe point */
 	const char *symbol_name;
 
@@ -105,6 +115,7 @@ struct kprobe {
 				   * this flag is only for optimized_kprobe.
 				   */
 #define KPROBE_FLAG_FTRACE	8 /* probe is using ftrace */
+#define KPROBE_FLAG_MULTI      16 /* probe multi addresses */
 
 /* Has this kprobe gone ? */
 static inline bool kprobe_gone(struct kprobe *p)
@@ -130,6 +141,18 @@ static inline bool kprobe_ftrace(struct kprobe *p)
 	return p->flags & KPROBE_FLAG_FTRACE;
 }
 
+/* Is this ftrace multi kprobe ? */
+static inline bool kprobe_ftrace_multi(struct kprobe *p)
+{
+	return kprobe_ftrace(p) && (p->flags & KPROBE_FLAG_MULTI);
+}
+
+/* Is this single kprobe ? */
+static inline bool kprobe_single(struct kprobe *p)
+{
+	return !(p->flags & KPROBE_FLAG_MULTI);
+}
+
 /*
  * Function-return probe -
  * Note:
@@ -365,6 +388,8 @@ static inline void wait_for_kprobe_optimizer(void) { }
 #ifdef CONFIG_KPROBES_ON_FTRACE
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				  struct ftrace_ops *ops, struct ftrace_regs *fregs);
+extern void kprobe_ftrace_multi_handler(unsigned long ip, unsigned long parent_ip,
+					struct ftrace_ops *ops, struct ftrace_regs *fregs);
 extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
 #else
 static inline int arch_prepare_kprobe_ftrace(struct kprobe *p)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c4060a8da050..e7729e20d85c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -44,6 +44,7 @@
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
 #include <linux/uaccess.h>
+#include <linux/ftrace.h>
 
 #define KPROBE_HASH_BITS 6
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
@@ -1022,6 +1023,35 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 }
 #endif /* CONFIG_OPTPROBES */
 
+static int check_kprobe_address(unsigned long addr)
+{
+	/* Ensure it is not in reserved area nor out of text */
+	return !kernel_text_address(addr) ||
+		within_kprobe_blacklist(addr) ||
+		jump_label_text_reserved((void *) addr, (void *) addr) ||
+		static_call_text_reserved((void *) addr, (void *) addr) ||
+		find_bug(addr);
+}
+
+static int check_ftrace_location(unsigned long addr, struct kprobe *p)
+{
+	unsigned long ftrace_addr;
+
+	ftrace_addr = ftrace_location(addr);
+	if (ftrace_addr) {
+#ifdef CONFIG_KPROBES_ON_FTRACE
+		/* Given address is not on the instruction boundary */
+		if (addr != ftrace_addr)
+			return -EILSEQ;
+		if (p)
+			p->flags |= KPROBE_FLAG_FTRACE;
+#else	/* !CONFIG_KPROBES_ON_FTRACE */
+		return -EINVAL;
+#endif
+	}
+	return 0;
+}
+
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
@@ -1043,6 +1073,13 @@ static int __arm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
 
 	lockdep_assert_held(&kprobe_mutex);
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	if (kprobe_ftrace_multi(p)) {
+		ret = register_ftrace_function(&p->multi.ops);
+		WARN(ret < 0, "Failed to register kprobe-multi-ftrace (error %d)\n", ret);
+		return ret;
+	}
+#endif
 	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 0, 0);
 	if (WARN_ONCE(ret < 0, "Failed to arm kprobe-ftrace at %pS (error %d)\n", p->addr, ret))
 		return ret;
@@ -1081,6 +1118,13 @@ static int __disarm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
 
 	lockdep_assert_held(&kprobe_mutex);
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	if (kprobe_ftrace_multi(p)) {
+		ret = unregister_ftrace_function(&p->multi.ops);
+		WARN(ret < 0, "Failed to unregister kprobe-ftrace (error %d)\n", ret);
+		return ret;
+	}
+#endif
 	if (*cnt == 1) {
 		ret = unregister_ftrace_function(ops);
 		if (WARN(ret < 0, "Failed to unregister kprobe-ftrace (error %d)\n", ret))
@@ -1103,6 +1147,94 @@ static int disarm_kprobe_ftrace(struct kprobe *p)
 		ipmodify ? &kprobe_ipmodify_ops : &kprobe_ftrace_ops,
 		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
 }
+
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+/*
+ * In addition to standard kprobe address check for multi
+ * ftrace kprobes we also allow only:
+ * - ftrace managed function entry address
+ * - kernel core only address
+ */
+static unsigned long check_ftrace_addr(unsigned long addr)
+{
+	int err;
+
+	if (!addr)
+		return -EINVAL;
+	err = check_ftrace_location(addr, NULL);
+	if (err)
+		return err;
+	if (check_kprobe_address(addr))
+		return -EINVAL;
+	if (__module_text_address(addr))
+		return -EINVAL;
+	return 0;
+}
+
+static int check_ftrace_multi(struct kprobe *p)
+{
+	kprobe_opcode_t **addrs = p->multi.addrs;
+	const char **symbols = p->multi.symbols;
+	unsigned int i, cnt = p->multi.cnt;
+	unsigned long addr, *ips;
+	int err;
+
+	if ((symbols && addrs) || (!symbols && !addrs))
+		return -EINVAL;
+
+	/* do we want sysctl for this? */
+	if (cnt >= 20000)
+		return -E2BIG;
+
+	ips = kmalloc(sizeof(*ips) * cnt, GFP_KERNEL);
+	if (!ips)
+		return -ENOMEM;
+
+	for (i = 0; i < cnt; i++) {
+		if (symbols)
+			addr = (unsigned long) kprobe_lookup_name(symbols[i], 0);
+		else
+			addr = (unsigned long) addrs[i];
+		ips[i] = addr;
+	}
+
+	jump_label_lock();
+	preempt_disable();
+
+	for (i = 0; i < cnt; i++) {
+		err = check_ftrace_addr(ips[i]);
+		if (err)
+			break;
+	}
+
+	preempt_enable();
+	jump_label_unlock();
+
+	if (err)
+		goto out;
+
+	err = ftrace_set_filter_ips(&p->multi.ops, ips, cnt, 0, 0);
+	if (err)
+		goto out;
+
+	p->multi.ops.func = kprobe_ftrace_multi_handler;
+	p->multi.ops.flags = FTRACE_OPS_FL_SAVE_REGS|FTRACE_OPS_FL_DYNAMIC;
+
+	p->flags |= KPROBE_FLAG_MULTI|KPROBE_FLAG_FTRACE;
+	if (p->post_handler)
+		p->multi.ops.flags |= FTRACE_OPS_FL_IPMODIFY;
+
+out:
+	kfree(ips);
+	return err;
+}
+
+static void free_ftrace_multi(struct kprobe *p)
+{
+	ftrace_free_filter(&p->multi.ops);
+}
+#endif
+
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
 static inline int arm_kprobe_ftrace(struct kprobe *p)
 {
@@ -1489,6 +1621,9 @@ static struct kprobe *__get_valid_kprobe(struct kprobe *p)
 
 	lockdep_assert_held(&kprobe_mutex);
 
+	if (kprobe_ftrace_multi(p))
+		return p;
+
 	ap = get_kprobe(p->addr);
 	if (unlikely(!ap))
 		return NULL;
@@ -1520,41 +1655,18 @@ static inline int warn_kprobe_rereg(struct kprobe *p)
 	return ret;
 }
 
-static int check_ftrace_location(struct kprobe *p)
-{
-	unsigned long ftrace_addr;
-
-	ftrace_addr = ftrace_location((unsigned long)p->addr);
-	if (ftrace_addr) {
-#ifdef CONFIG_KPROBES_ON_FTRACE
-		/* Given address is not on the instruction boundary */
-		if ((unsigned long)p->addr != ftrace_addr)
-			return -EILSEQ;
-		p->flags |= KPROBE_FLAG_FTRACE;
-#else	/* !CONFIG_KPROBES_ON_FTRACE */
-		return -EINVAL;
-#endif
-	}
-	return 0;
-}
-
 static int check_kprobe_address_safe(struct kprobe *p,
 				     struct module **probed_mod)
 {
 	int ret;
 
-	ret = check_ftrace_location(p);
+	ret = check_ftrace_location((unsigned long) p->addr, p);
 	if (ret)
 		return ret;
 	jump_label_lock();
 	preempt_disable();
 
-	/* Ensure it is not in reserved area nor out of text */
-	if (!kernel_text_address((unsigned long) p->addr) ||
-	    within_kprobe_blacklist((unsigned long) p->addr) ||
-	    jump_label_text_reserved(p->addr, p->addr) ||
-	    static_call_text_reserved(p->addr, p->addr) ||
-	    find_bug((unsigned long)p->addr)) {
+	if (check_kprobe_address((unsigned long) p->addr)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1599,13 +1711,16 @@ static unsigned long resolve_func_addr(kprobe_opcode_t *addr)
 	return 0;
 }
 
-int register_kprobe(struct kprobe *p)
+static int check_addr(struct kprobe *p, struct module **probed_mod)
 {
 	int ret;
-	struct kprobe *old_p;
-	struct module *probed_mod;
 	kprobe_opcode_t *addr;
 
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	if (p->multi.cnt)
+		return check_ftrace_multi(p);
+#endif
+
 	/* Adjust probe address from symbol */
 	addr = kprobe_addr(p);
 	if (IS_ERR(addr))
@@ -1616,13 +1731,21 @@ int register_kprobe(struct kprobe *p)
 	ret = warn_kprobe_rereg(p);
 	if (ret)
 		return ret;
+	return check_kprobe_address_safe(p, probed_mod);
+}
+
+int register_kprobe(struct kprobe *p)
+{
+	struct module *probed_mod = NULL;
+	struct kprobe *old_p;
+	int ret;
 
 	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
 	p->flags &= KPROBE_FLAG_DISABLED;
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
 
-	ret = check_kprobe_address_safe(p, &probed_mod);
+	ret = check_addr(p, &probed_mod);
 	if (ret)
 		return ret;
 
@@ -1644,14 +1767,21 @@ int register_kprobe(struct kprobe *p)
 	if (ret)
 		goto out;
 
-	INIT_HLIST_NODE(&p->hlist);
-	hlist_add_head_rcu(&p->hlist,
-		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
+	/*
+	 * Multi ftrace kprobes do not have single address,
+	 * so they are not stored in the kprobe_table hash.
+	 */
+	if (kprobe_single(p)) {
+		INIT_HLIST_NODE(&p->hlist);
+		hlist_add_head_rcu(&p->hlist,
+			       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
+	}
 
 	if (!kprobes_all_disarmed && !kprobe_disabled(p)) {
 		ret = arm_kprobe(p);
 		if (ret) {
-			hlist_del_rcu(&p->hlist);
+			if (kprobe_single(p))
+				hlist_del_rcu(&p->hlist);
 			synchronize_rcu();
 			goto out;
 		}
@@ -1778,7 +1908,13 @@ static int __unregister_kprobe_top(struct kprobe *p)
 	return 0;
 
 disarmed:
-	hlist_del_rcu(&ap->hlist);
+	if (kprobe_single(ap))
+		hlist_del_rcu(&ap->hlist);
+
+#ifdef CONFIG_HAVE_KPROBES_MULTI_ON_FTRACE
+	if (kprobe_ftrace_multi(ap))
+		free_ftrace_multi(ap);
+#endif
 	return 0;
 }
 
-- 
2.33.1

