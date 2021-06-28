Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B553B5F63
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhF1Nws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbhF1Nwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 09:52:39 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7751C061574;
        Mon, 28 Jun 2021 06:50:12 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id q16so5945017qke.10;
        Mon, 28 Jun 2021 06:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mXC3FkdhPxDYuYzI3537RFiPRTI+dFbNXu8uhPWaU8Y=;
        b=MsF9+pKNK0nQfmeDSM1Exb7gLY8IpP5oELoFkfyqGDqNUSIR5f/sttgEEN6ygp1fER
         5IbEnR/aLuoidceLYoEEdqNkaYEpH/VXmdcGxd9MUL4zlMMrIRDjMhFW97bhWJ9Ap4tS
         bq7S15hpVhTl37Y5iJYQpxw4/BvQS6fqqe/shQxHUaRTrKyI8Vrecl33VHUeYbiK2+yX
         KPV1HdRKCA92LfIvqXWIuKuw9XHD+WRP7W8UVizp4bZwRxnWz9oZQM6srN8gMVCA/1XI
         z3EgoT+1C30UJS+dq7xkJ7FdwehqqFqiaRcMCwjN8vPDqeBC/WxQayjOLxDcz5xzTuqg
         +FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mXC3FkdhPxDYuYzI3537RFiPRTI+dFbNXu8uhPWaU8Y=;
        b=nbbEjFCaliTCE4FpNZx5SSNmy7PGi9eeWP5Sa+UVwsdzIv/T5pY+UiZnFzU8asAdgG
         vPnYXkEsOa9G/5guikXz1HCEPloNeReZrikVuln0nreWfNOhkjHgUhc1+s8LkguRT1Cl
         UBfv2FiWDECrTgaPJzWT/fvL34Q1RZ1t81rKs8tdNhxp/KxYKu+PBhcczVBUK4u32nUG
         WeE+wb1Zv8j7q3bC/byT+6klTmMChkaiZQzc2gEr4XsDxrQRdoGRnrgIWA+C39siVJuy
         +mc+5lOc6CdxbOE0FCHrAnmezwTNDnxiijhq/nUG52HPlRbuTAEwhs7Gbs0kssvuyTH4
         NlmA==
X-Gm-Message-State: AOAM531l5I+TM1WzDPi9mLLI0i/6p+HLGKNPv9/8gCofnj0X2XpXqlSx
        c96GQV8lhq52BL3k2MiRJkroDRqpw3U=
X-Google-Smtp-Source: ABdhPJwX80vF5oNJOYHJQCw85dqifYuexJspeS6wu+PBMWLbKDfzMrRAMoQCvxERHtfJnAhA3FBMAg==
X-Received: by 2002:a37:ac14:: with SMTP id e20mr9647808qkm.362.1624888211942;
        Mon, 28 Jun 2021 06:50:11 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:8502:d4aa:337:d4d])
        by smtp.gmail.com with ESMTPSA id f19sm10760518qkg.70.2021.06.28.06.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 06:50:11 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v3 1/2] once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
Date:   Mon, 28 Jun 2021 09:50:06 -0400
Message-Id: <20210628135007.1358909-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
References: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Certain uses of "do once" functionality reside outside of fast path,
and so do not require jump label patching via static keys, making
existing DO_ONCE undesirable in such cases.

Replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?

This patch changes the return values of xfs_printk_once, printk_once,
and printk_deferred_once. Before, they returned whether the print was
performed, but now, they always return true. This is okay because the
return values of the following macros are entirely ignored throughout
the kernel:
- xfs_printk_once
- xfs_warn_once
- xfs_notice_once
- xfs_info_once
- printk_once
- pr_emerg_once
- pr_alert_once
- pr_crit_once
- pr_err_once
- pr_warn_once
- pr_notice_once
- pr_info_once
- pr_devel_once
- pr_debug_once
- printk_deferred_once
- orc_warn

Changes
v3:
  - Expand commit message to explain why changing return values of
    xfs_printk_once, printk_once, printk_deferred_once is benign
v2:
  - Fix i386 build warnings

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mahesh Bandewar <maheshb@google.com>
---
 fs/xfs/xfs_message.h      | 13 +++----------
 include/asm-generic/bug.h | 37 +++++++------------------------------
 include/linux/once_lite.h | 24 ++++++++++++++++++++++++
 include/linux/printk.h    | 23 +++--------------------
 kernel/trace/trace.h      | 13 +++----------
 5 files changed, 40 insertions(+), 70 deletions(-)
 create mode 100644 include/linux/once_lite.h

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 7ec1a9207517..bb9860ec9a93 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -2,6 +2,8 @@
 #ifndef __XFS_MESSAGE_H
 #define __XFS_MESSAGE_H 1
 
+#include <linux/once_lite.h>
+
 struct xfs_mount;
 
 extern __printf(2, 3)
@@ -41,16 +43,7 @@ do {									\
 } while (0)
 
 #define xfs_printk_once(func, dev, fmt, ...)			\
-({								\
-	static bool __section(".data.once") __print_once;	\
-	bool __ret_print_once = !__print_once; 			\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		func(dev, fmt, ##__VA_ARGS__);			\
-	}							\
-	unlikely(__ret_print_once);				\
-})
+	DO_ONCE_LITE(func, dev, fmt, ##__VA_ARGS__)
 
 #define xfs_emerg_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index b402494883b6..bafc51f483c4 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/instrumentation.h>
+#include <linux/once_lite.h>
 
 #define CUT_HERE		"------------[ cut here ]------------\n"
 
@@ -140,39 +141,15 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 })
 
 #ifndef WARN_ON_ONCE
-#define WARN_ON_ONCE(condition)	({				\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		WARN_ON(1);					\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ON_ONCE(condition)					\
+	DO_ONCE_LITE_IF(condition, WARN_ON, 1)
 #endif
 
-#define WARN_ONCE(condition, format...)	({			\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		WARN(1, format);				\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ONCE(condition, format...)				\
+	DO_ONCE_LITE_IF(condition, WARN, 1, format)
 
-#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		WARN_TAINT(1, taint, format);			\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_TAINT_ONCE(condition, taint, format...)		\
+	DO_ONCE_LITE_IF(condition, WARN_TAINT, 1, taint, format)
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
diff --git a/include/linux/once_lite.h b/include/linux/once_lite.h
new file mode 100644
index 000000000000..861e606b820f
--- /dev/null
+++ b/include/linux/once_lite.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ONCE_LITE_H
+#define _LINUX_ONCE_LITE_H
+
+#include <linux/types.h>
+
+/* Call a function once. Similar to DO_ONCE(), but does not use jump label
+ * patching via static keys.
+ */
+#define DO_ONCE_LITE(func, ...)						\
+	DO_ONCE_LITE_IF(true, func, ##__VA_ARGS__)
+#define DO_ONCE_LITE_IF(condition, func, ...)				\
+	({								\
+		static bool __section(".data.once") __already_done;	\
+		bool __ret_do_once = !!(condition);			\
+									\
+		if (unlikely(__ret_do_once && !__already_done)) {	\
+			__already_done = true;				\
+			func(__VA_ARGS__);				\
+		}							\
+		unlikely(__ret_do_once);				\
+	})
+
+#endif /* _LINUX_ONCE_LITE_H */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index fe7eb2351610..885379a1c9a1 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -8,6 +8,7 @@
 #include <linux/linkage.h>
 #include <linux/cache.h>
 #include <linux/ratelimit_types.h>
+#include <linux/once_lite.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -436,27 +437,9 @@ extern int kptr_restrict;
 
 #ifdef CONFIG_PRINTK
 #define printk_once(fmt, ...)					\
-({								\
-	static bool __section(".data.once") __print_once;	\
-	bool __ret_print_once = !__print_once;			\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		printk(fmt, ##__VA_ARGS__);			\
-	}							\
-	unlikely(__ret_print_once);				\
-})
+	DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
 #define printk_deferred_once(fmt, ...)				\
-({								\
-	static bool __section(".data.once") __print_once;	\
-	bool __ret_print_once = !__print_once;			\
-								\
-	if (!__print_once) {					\
-		__print_once = true;				\
-		printk_deferred(fmt, ##__VA_ARGS__);		\
-	}							\
-	unlikely(__ret_print_once);				\
-})
+	DO_ONCE_LITE(printk_deferred, fmt, ##__VA_ARGS__)
 #else
 #define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cd80d046c7a5..d5d8c088a55d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -20,6 +20,7 @@
 #include <linux/irq_work.h>
 #include <linux/workqueue.h>
 #include <linux/ctype.h>
+#include <linux/once_lite.h>
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
@@ -99,16 +100,8 @@ enum trace_type {
 #include "trace_entries.h"
 
 /* Use this for memory failure errors */
-#define MEM_FAIL(condition, fmt, ...) ({			\
-	static bool __section(".data.once") __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once && !__warned)) {		\
-		__warned = true;				\
-		pr_err("ERROR: " fmt, ##__VA_ARGS__);		\
-	}							\
-	unlikely(__ret_warn_once);				\
-})
+#define MEM_FAIL(condition, fmt, ...)					\
+	DO_ONCE_LITE_IF(condition, pr_err, "ERROR: " fmt, ##__VA_ARGS__)
 
 /*
  * syscalls are special, and need special handling, this is why
-- 
2.32.0.93.g670b81a890-goog

