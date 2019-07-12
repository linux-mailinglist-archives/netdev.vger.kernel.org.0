Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD5673D8
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfGLRAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:00:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35173 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfGLRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:00:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so4569313pfn.2
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ztK1SoGReZBhwdZ89bE2tj3KKCQLEvHK7oy3z8Z+Xn8=;
        b=yP4qEse42R/bByX9BK8SGILXb5Wt77EgL1NJAsCWrORS0X+47/A1wlZRAGMUp76hRy
         CmHGpOQduNYedmfSLa2MAEs1GRfukRXFpiwZwrWYx+pNcWUsMXhp5CsUVwfhJuzOD4bb
         3DX/JieFW8x/XH4h0XyF0SJABUyC20gApI/ZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztK1SoGReZBhwdZ89bE2tj3KKCQLEvHK7oy3z8Z+Xn8=;
        b=HcsvwbJkzxCihBxu+G1jcm8q6MOjyzvCK8OSw8EERm7sBaYolMM0cbCBS9PT2kEIof
         W6MyokLIDSj1m9OW9AM3S4Z4lw45qucwx/8RgfANtc0+pLUScVebDSbeotLTHl8lVUkV
         80602WvdrnqOICycGkEsncPcQ8yB/cZpSy8VD3l3pF8rSbYUc+dIbPn/hjB7MWcE/TpR
         slPIKeL6JSIEPJ8OYYque4PA+PRLUMuUFdrvbXs5FA7Bx6ATBIIB0l7GxQ7AFfjhfACe
         G0Y9iPNg1CQ/drYodnCUymW7pCL0riwy/iE9eRQu7ILTEBEU07z8em/l14O0/MeZF75Y
         qWwA==
X-Gm-Message-State: APjAAAVs4xsESi4GqJb9bTdY7bG/7ZsCoAhWR8RU1oKQtM07ZFJ92S2R
        mAjKpwZ8nCU7KOdyR/IEci8=
X-Google-Smtp-Source: APXvYqxiMVhL5/bUvAI8iAaiaoWG6pTJu5V5J0XbdvBlQDWwxj7kS9rYgN7m4WPBHurlzZP/Kw2/0Q==
X-Received: by 2002:a17:90a:ad41:: with SMTP id w1mr12826209pjv.52.1562950846214;
        Fri, 12 Jul 2019 10:00:46 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id a15sm7127385pgw.3.2019.07.12.10.00.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 10:00:45 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Oleg Nesterov <oleg@redhat.com>,
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
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v2 3/9] rcu/sync: Remove custom check for reader-section
Date:   Fri, 12 Jul 2019 13:00:18 -0400
Message-Id: <20190712170024.111093-4-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190712170024.111093-1-joel@joelfernandes.org>
References: <20190712170024.111093-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu/sync code was doing its own check whether we are in a reader
section. With RCU consolidating flavors and the generic helper added in
this series, this is no longer need. We can just use the generic helper
and it results in a nice cleanup.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
Please note: Only build and boot tested this particular patch so far.

 include/linux/rcu_sync.h |  5 ++---
 kernel/rcu/sync.c        | 22 ----------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
index 6fc53a1345b3..c954f1efc919 100644
--- a/include/linux/rcu_sync.h
+++ b/include/linux/rcu_sync.h
@@ -39,9 +39,8 @@ extern void rcu_sync_lockdep_assert(struct rcu_sync *);
  */
 static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
 {
-#ifdef CONFIG_PROVE_RCU
-	rcu_sync_lockdep_assert(rsp);
-#endif
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
+			 "suspicious rcu_sync_is_idle() usage");
 	return !rsp->gp_state; /* GP_IDLE */
 }
 
diff --git a/kernel/rcu/sync.c b/kernel/rcu/sync.c
index a8304d90573f..535e02601f56 100644
--- a/kernel/rcu/sync.c
+++ b/kernel/rcu/sync.c
@@ -10,37 +10,25 @@
 #include <linux/rcu_sync.h>
 #include <linux/sched.h>
 
-#ifdef CONFIG_PROVE_RCU
-#define __INIT_HELD(func)	.held = func,
-#else
-#define __INIT_HELD(func)
-#endif
-
 static const struct {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
 	void (*wait)(void);
-#ifdef CONFIG_PROVE_RCU
-	int  (*held)(void);
-#endif
 } gp_ops[] = {
 	[RCU_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
 		.wait = rcu_barrier,
-		__INIT_HELD(rcu_read_lock_held)
 	},
 	[RCU_SCHED_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
 		.wait = rcu_barrier,
-		__INIT_HELD(rcu_read_lock_sched_held)
 	},
 	[RCU_BH_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
 		.wait = rcu_barrier,
-		__INIT_HELD(rcu_read_lock_bh_held)
 	},
 };
 
@@ -49,16 +37,6 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
 #define	rss_lock	gp_wait.lock
 
-#ifdef CONFIG_PROVE_RCU
-void rcu_sync_lockdep_assert(struct rcu_sync *rsp)
-{
-	RCU_LOCKDEP_WARN(!gp_ops[rsp->gp_type].held(),
-			 "suspicious rcu_sync_is_idle() usage");
-}
-
-EXPORT_SYMBOL_GPL(rcu_sync_lockdep_assert);
-#endif
-
 /**
  * rcu_sync_init() - Initialize an rcu_sync structure
  * @rsp: Pointer to rcu_sync structure to be initialized
-- 
2.22.0.510.g264f2c817a-goog

