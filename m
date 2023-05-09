Return-Path: <netdev+bounces-1249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B59486FCEDC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8416F1C20BCD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E8416421;
	Tue,  9 May 2023 19:56:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41033174E8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 19:56:21 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282E43C0C;
	Tue,  9 May 2023 12:56:19 -0700 (PDT)
Date: Tue, 09 May 2023 19:56:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1683662177;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/vEnI/WFdPHZGqXC/3G2/DQm+2OzEhIX3KzqGEKGV0=;
	b=WWeCfinM04pROlGUdsFazYzPo/sHmWF1rxTCgVX0XqZBRZKudUJeWlUvdD2l4I+sGpoEiO
	Xfu/U31CiC/2oI+o4ewfoLNO9UbhWURr82RMzVzyf0/xOvdk6c1XE14S0Ea92QD60Jap6f
	f14SGK/zw8KQ9A8IZF49QhIxMgRJ52mjJ7ZVsQrGSwmP2vhODHPyTe9N4UUGi8ik2CKrQ4
	Fr9X6lIBug1URhSCG8YQ1SN8dL1ySTICcuJQQfzmvp4ZGIiiiU5+9OvlYMwxJieUzxWAt8
	qbiRSFc41hu7z6D6XuGG9DAD5lf1KDTtiZC1OhpZzVrhdsNKBbFBrCAGc8CyCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1683662177;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/vEnI/WFdPHZGqXC/3G2/DQm+2OzEhIX3KzqGEKGV0=;
	b=jkNrt+obk5uJZpjgeqWqBfdwhbBGIEuDQRMWAK0+7IOWxkrQSxWaupXqOkUlxULv+fhH/C
	TBkW2+utiV1lUWDg==
From: "tip-bot2 for Paolo Abeni" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] Revert "softirq: Let ksoftirqd do its job"
Cc: Paolo Abeni <pabeni@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Jason Xing <kerneljasonxing@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 Eric Dumazet <edumazet@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
References: <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <168366217649.404.15332707412932478981.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     d15121be7485655129101f3960ae6add40204463
Gitweb:        https://git.kernel.org/tip/d15121be7485655129101f3960ae6add40204463
Author:        Paolo Abeni <pabeni@redhat.com>
AuthorDate:    Mon, 08 May 2023 08:17:44 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 May 2023 21:50:27 +02:00

Revert "softirq: Let ksoftirqd do its job"

This reverts the following commits:

  4cd13c21b207 ("softirq: Let ksoftirqd do its job")
  3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")
  1342d8080f61 ("softirq: Don't skip softirq execution when softirq thread is parking")

in a single change to avoid known bad intermediate states introduced by a
patch series reverting them individually.

Due to the mentioned commit, when the ksoftirqd threads take charge of
softirq processing, the system can experience high latencies.

In the past a few workarounds have been implemented for specific
side-effects of the initial ksoftirqd enforcement commit:

commit 1ff688209e2e ("watchdog: core: make sure the watchdog_worker is not deferred")
commit 8d5755b3f77b ("watchdog: softdog: fire watchdog even if softirqs do not get to run")
commit 217f69743681 ("net: busy-poll: allow preemption in sk_busy_loop()")
commit 3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")

But the latency problem still exists in real-life workloads, see the link
below.

The reverted commit intended to solve a live-lock scenario that can now be
addressed with the NAPI threaded mode, introduced with commit 29863d41bb6e
("net: implement threaded-able napi poll loop support"), which is nowadays
in a pretty stable status.

While a complete solution to put softirq processing under nice resource
control would be preferable, that has proven to be a very hard task. In
the short term, remove the main pain point, and also simplify a bit the
current softirq implementation.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/netdev/305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com
Link: https://lore.kernel.org/r/57e66b364f1b6f09c9bc0316742c3b14f4ce83bd.1683526542.git.pabeni@redhat.com
---
 kernel/softirq.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 1b72551..807b34c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -80,21 +80,6 @@ static void wakeup_softirqd(void)
 		wake_up_process(tsk);
 }
 
-/*
- * If ksoftirqd is scheduled, we do not want to process pending softirqs
- * right now. Let ksoftirqd handle this at its own rate, to get fairness,
- * unless we're doing some of the synchronous softirqs.
- */
-#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
-static bool ksoftirqd_running(unsigned long pending)
-{
-	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
-
-	if (pending & SOFTIRQ_NOW_MASK)
-		return false;
-	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
-}
-
 #ifdef CONFIG_TRACE_IRQFLAGS
 DEFINE_PER_CPU(int, hardirqs_enabled);
 DEFINE_PER_CPU(int, hardirq_context);
@@ -236,7 +221,7 @@ void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 		goto out;
 
 	pending = local_softirq_pending();
-	if (!pending || ksoftirqd_running(pending))
+	if (!pending)
 		goto out;
 
 	/*
@@ -432,9 +417,6 @@ static inline bool should_wake_ksoftirqd(void)
 
 static inline void invoke_softirq(void)
 {
-	if (ksoftirqd_running(local_softirq_pending()))
-		return;
-
 	if (!force_irqthreads() || !__this_cpu_read(ksoftirqd)) {
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
@@ -468,7 +450,7 @@ asmlinkage __visible void do_softirq(void)
 
 	pending = local_softirq_pending();
 
-	if (pending && !ksoftirqd_running(pending))
+	if (pending)
 		do_softirq_own_stack();
 
 	local_irq_restore(flags);

