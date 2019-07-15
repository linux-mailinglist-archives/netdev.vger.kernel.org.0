Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C0D69394
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391840AbfGOOpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:45:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43834 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404463AbfGOOhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 10:37:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so1437177pld.10
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 07:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CJEwPPrtJyDTV3piEkDE+ONyRMH9m2RDRbmoV5ZEGS8=;
        b=IozIr9z+GIb5mPdKiPaf5UHiYIz+Oat0gqj58xKeNgOqIcav4VXtm41dS18QhgHWuP
         08bOfzHsvFlkA1+slmz0mYgCQced6RM3EOenJJaGW8k4oiXykx/eoqvUaynExjS780ga
         gIRPex9R8tFcEqFj6fn/uCxhibShb2XLfLQao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CJEwPPrtJyDTV3piEkDE+ONyRMH9m2RDRbmoV5ZEGS8=;
        b=eVtX65vn290JjErJF4JiAGRsqugI3BP6s8EhWtZ8yNZiAImUsAtBXH40YlfUy6BIZk
         ar5TQ1kbUvwJ1KggwC4GLCHUmVUq9TJoOBDw8kAmOpEoLHzsi2hsvrWfykqlEcj9o6vG
         a36h3s1rNRHkyuncP8LEENEX2Bbr+/DDfGKtumY1G7RQVjs47p7om9C/AOxgMwL8jN0p
         g0BW5YcZd08inXcuQodJIlVrYKHXiOrtGFDbrkLfd72BnJB7+YDOUv4HfrYb9ktUFyzI
         SyIHF5L1mC4ibTxFAuFsNIpVuYRwOKKzaoUTs9hx72aKjvoUjzfVxjBtBagx7H3Hjjv0
         bPIQ==
X-Gm-Message-State: APjAAAXRxzpZAHH5fwNcOflqcaBoHlCCu79UJJplCqNIf2Fa9i04430S
        6zngdU+CBLA42dcZ6j6dACg=
X-Google-Smtp-Source: APXvYqzrTtDshfHRTIApwfR2uw8rmwlBdmV5rfV/lQ/WFFtfVs/RxHxaLHWVf+yG1vS25zf50JO+qA==
X-Received: by 2002:a17:902:290b:: with SMTP id g11mr28300017plb.26.1563201442188;
        Mon, 15 Jul 2019 07:37:22 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id s66sm18381852pfs.8.2019.07.15.07.37.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 07:37:21 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH 2/9] rcu: Add support for consolidated-RCU reader checking (v3)
Date:   Mon, 15 Jul 2019 10:36:58 -0400
Message-Id: <20190715143705.117908-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for checking RCU reader sections in list
traversal macros. Optionally, if the list macro is called under SRCU or
other lock/mutex protection, then appropriate lockdep expressions can be
passed to make the checks pass.

Existing list_for_each_entry_rcu() invocations don't need to pass the
optional fourth argument (cond) unless they are under some non-RCU
protection and needs to make lockdep check pass.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rculist.h  | 28 ++++++++++++++++++++-----
 include/linux/rcupdate.h |  7 +++++++
 kernel/rcu/Kconfig.debug | 11 ++++++++++
 kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
 4 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e91ec9ddcd30..1048160625bb 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
  */
 #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
 
+/*
+ * Check during list traversal that we are within an RCU reader
+ */
+
+#ifdef CONFIG_PROVE_RCU_LIST
+#define __list_check_rcu(dummy, cond, ...)				\
+	({								\
+	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
+			 "RCU-list traversed in non-reader section!");	\
+	 })
+#else
+#define __list_check_rcu(dummy, cond, ...) ({})
+#endif
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
@@ -343,14 +357,16 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the list_head within the struct.
+ * @cond:	optional lockdep expression if called from non-RCU protection.
  *
  * This list-traversal primitive may safely run concurrently with
  * the _rcu list-mutation primitives such as list_add_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
-		&pos->member != (head); \
+#define list_for_each_entry_rcu(pos, head, member, cond...)		\
+	for (__list_check_rcu(dummy, ## cond, 0),			\
+	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
+		&pos->member != (head);					\
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 /**
@@ -616,13 +632,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
+ * @cond:	optional lockdep expression if called from non-RCU protection.
  *
  * This list-traversal primitive may safely run concurrently with
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(pos, head, member)			\
-	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
+#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
+	for (__list_check_rcu(dummy, ## cond, 0),			\
+	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
 			typeof(*(pos)), member);			\
 		pos;							\
 		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8f7167478c1d..f3c29efdf19a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -221,6 +221,7 @@ int debug_lockdep_rcu_enabled(void);
 int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
 int rcu_read_lock_sched_held(void);
+int rcu_read_lock_any_held(void);
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -241,6 +242,12 @@ static inline int rcu_read_lock_sched_held(void)
 {
 	return !preemptible();
 }
+
+static inline int rcu_read_lock_any_held(void)
+{
+	return !preemptible();
+}
+
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 #ifdef CONFIG_PROVE_RCU
diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
index 5ec3ea4028e2..7fbd21dbfcd0 100644
--- a/kernel/rcu/Kconfig.debug
+++ b/kernel/rcu/Kconfig.debug
@@ -8,6 +8,17 @@ menu "RCU Debugging"
 config PROVE_RCU
 	def_bool PROVE_LOCKING
 
+config PROVE_RCU_LIST
+	bool "RCU list lockdep debugging"
+	depends on PROVE_RCU
+	default n
+	help
+	  Enable RCU lockdep checking for list usages. By default it is
+	  turned off since there are several list RCU users that still
+	  need to be converted to pass a lockdep expression. To prevent
+	  false-positive splats, we keep it default disabled but once all
+	  users are converted, we can remove this config option.
+
 config TORTURE_TEST
 	tristate
 	default n
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 9dd5aeef6e70..b7a4e3b5fa98 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -91,14 +91,18 @@ module_param(rcu_normal_after_boot, int, 0);
  * Similarly, we avoid claiming an SRCU read lock held if the current
  * CPU is offline.
  */
+#define rcu_read_lock_held_common()		\
+	if (!debug_lockdep_rcu_enabled())	\
+		return 1;			\
+	if (!rcu_is_watching())			\
+		return 0;			\
+	if (!rcu_lockdep_current_cpu_online())	\
+		return 0;
+
 int rcu_read_lock_sched_held(void)
 {
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
+	rcu_read_lock_held_common();
+
 	return lock_is_held(&rcu_sched_lock_map) || !preemptible();
 }
 EXPORT_SYMBOL(rcu_read_lock_sched_held);
@@ -257,12 +261,8 @@ NOKPROBE_SYMBOL(debug_lockdep_rcu_enabled);
  */
 int rcu_read_lock_held(void)
 {
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
+	rcu_read_lock_held_common();
+
 	return lock_is_held(&rcu_lock_map);
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_held);
@@ -284,16 +284,24 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_held);
  */
 int rcu_read_lock_bh_held(void)
 {
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
+	rcu_read_lock_held_common();
+
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
+int rcu_read_lock_any_held(void)
+{
+	rcu_read_lock_held_common();
+
+	if (lock_is_held(&rcu_lock_map) ||
+	    lock_is_held(&rcu_bh_lock_map) ||
+	    lock_is_held(&rcu_sched_lock_map))
+		return 1;
+	return !preemptible();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
+
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
-- 
2.22.0.510.g264f2c817a-goog

