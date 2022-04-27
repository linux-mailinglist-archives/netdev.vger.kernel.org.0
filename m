Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F16512695
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiD0XAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiD0W7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:59:05 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9360F8C7C7;
        Wed, 27 Apr 2022 15:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oI9b5duO8OJ5vQDZCcg8/YSfwN8M5sfdHxH8XUnmtlk=; b=Dl2B7pSVJp25fe7IfIs24mmkq8
        hNWQZdfuE5b8NzwyHqbjR/6C1jbxbEv8wNNcNdcZK+x2mWiNzNr+u6ej0RkZPoYhNEHBCsZ6UD+6G
        UKVT1x0W1ctGqUC1Gq0pKfbBSIn3/AQDQpBwhuyH0wupCzlBVEy+S+oaSi7mTGACgenSYzi35Memm
        cwNrE6VLPhA8HIa6SL7ijwVZV/Cmf5guYFGY1etNEWb16ALz0OIjrK84zUZZaRulPOC47prAFsrmC
        8jtFSnfk5SwoqCho0RbgOB8YFry+V3AQ6FT8GxIeK9uuEGFeYv+qjRy2g8pgwIU4Wj4/dnNONMvQE
        5U+RG0NQ==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqYG-0002IR-Ki; Thu, 28 Apr 2022 00:54:29 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
Subject: [PATCH 18/30] notifier: Show function names on notifier routines if DEBUG_NOTIFIERS is set
Date:   Wed, 27 Apr 2022 19:49:12 -0300
Message-Id: <20220427224924.592546-19-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we have a debug infrastructure in the notifiers file, but
it's very simple/limited. This patch extends it by:

(a) Showing all registered/unregistered notifiers' callback names;

(b) Adding a dynamic debug tuning to allow showing called notifiers'
function names. Notice that this should be guarded as a tunable since
it can flood the kernel log buffer.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

We have some design decisions that worth discussing here:

(a) First of call, using C99 helps a lot to write clear and concise code, but
due to commit 4d94f910e79a ("Kbuild: use -Wdeclaration-after-statement") we
have a warning if mixing variable declarations with code. For this patch though,
doing that makes the code way clear, so decision was to add the debug code
inside brackets whenever this warning pops up. We can change that, but that'll
cause more ifdefs in the same function.

(b) In the symbol lookup helper function, we modify the parameter passed but
even more, we return it as well! This is unusual and seems unnecessary, but was
the strategy taken to allow embedding such function in the pr_debug() call.

Not doing that would likely requiring 3 symbol_name variables to avoid
concurrency (registering notifier A while calling notifier B) - we rely in
local variables as a serialization mechanism.

We're open for suggestions in case this design is not appropriate;
thanks in advance!

 kernel/notifier.c | 48 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index ba005ebf4730..21032ebcde57 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -7,6 +7,22 @@
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
 
+#ifdef CONFIG_DEBUG_NOTIFIERS
+#include <linux/kallsyms.h>
+
+/*
+ *	Helper to get symbol names in case DEBUG_NOTIFIERS is set.
+ *	Return the modified parameter is a strategy used to achieve
+ *	the pr_debug() functionality - with this, function is only
+ *	executed if the dynamic debug tuning is effectively set.
+ */
+static inline char *notifier_name(struct notifier_block *nb, char *sym_name)
+{
+	lookup_symbol_name((unsigned long)(nb->notifier_call), sym_name);
+	return sym_name;
+}
+#endif
+
 /*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
@@ -34,20 +50,41 @@ static int notifier_chain_register(struct notifier_block **nl,
 	}
 	n->next = *nl;
 	rcu_assign_pointer(*nl, n);
+
+#ifdef CONFIG_DEBUG_NOTIFIERS
+	{
+		char sym_name[KSYM_NAME_LEN];
+
+		pr_info("notifiers: registered %s()\n",
+			notifier_name(n, sym_name));
+	}
+#endif
 	return 0;
 }
 
 static int notifier_chain_unregister(struct notifier_block **nl,
 		struct notifier_block *n)
 {
+	int ret = -ENOENT;
+
 	while ((*nl) != NULL) {
 		if ((*nl) == n) {
 			rcu_assign_pointer(*nl, n->next);
-			return 0;
+			ret = 0;
+			break;
 		}
 		nl = &((*nl)->next);
 	}
-	return -ENOENT;
+
+#ifdef CONFIG_DEBUG_NOTIFIERS
+	if (!ret) {
+		char sym_name[KSYM_NAME_LEN];
+
+		pr_info("notifiers: unregistered %s()\n",
+			notifier_name(n, sym_name));
+	}
+#endif
+	return ret;
 }
 
 /**
@@ -80,6 +117,13 @@ static int notifier_call_chain(struct notifier_block **nl,
 			nb = next_nb;
 			continue;
 		}
+
+		{
+			char sym_name[KSYM_NAME_LEN];
+
+			pr_debug("notifiers: calling %s()\n",
+				 notifier_name(nb, sym_name));
+		}
 #endif
 		ret = nb->notifier_call(nb, val, v);
 
-- 
2.36.0

