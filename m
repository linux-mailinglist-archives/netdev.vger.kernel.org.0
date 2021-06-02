Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD10398A9C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhFBNdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhFBNc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:32:56 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE52C06175F;
        Wed,  2 Jun 2021 06:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=StHUrZVTyidITaso9MHtdeY9nPrW5Ogz3wqQtaiZ0ws=; b=P6N4rxYRYVyJKXyPv/qWD9zHEM
        ae7/GsDR0G4z0W3zvLFylIHdZxOruBRKoQnWY8N7W1rLQbprQYlZS9dUYXxQLhu4AjsLFXcwYBtlb
        eD49gln0vrb9EAWt9nv02V8yo6iI8t6lfBp4ez+3qPHUG9tGWQq/Ui8PnSuXrhM6rnBI0cO7Swj1I
        3oXGm9LyYJOi4Ch+3FlALr0ysdqMd8mylXs107QW8UAnjvRfZ51B4Hs3PtzRgkCxUTtPW/2AMfCG/
        ndwfk+vKAcWWm7HgBB7G3jkOSIw+UMNaGluyVVk4MLNMCyWDacIRZvLv7nz2KpnM+noLcBRHUzGbP
        FF2fzzTQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loQxX-002toY-D6; Wed, 02 Jun 2021 13:31:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3DD6B300301;
        Wed,  2 Jun 2021 15:31:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 989162C14C594; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.334970485@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 02 Jun 2021 15:12:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH 2/6] sched: Introduce task_is_running()
References: <20210602131225.336600299@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a bunch of 'p->state == TASK_RUNNING' with a new helper:
task_is_running(p).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kernel/process.c |    4 ++--
 block/blk-mq.c            |    2 +-
 include/linux/sched.h     |    2 ++
 kernel/locking/lockdep.c  |    2 +-
 kernel/rcu/tree_plugin.h  |    2 +-
 kernel/sched/core.c       |    6 +++---
 kernel/sched/stats.h      |    2 +-
 kernel/signal.c           |    2 +-
 kernel/softirq.c          |    3 +--
 mm/compaction.c           |    2 +-
 10 files changed, 14 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -931,7 +931,7 @@ unsigned long get_wchan(struct task_stru
 	unsigned long start, bottom, top, sp, fp, ip, ret = 0;
 	int count = 0;
 
-	if (p == current || p->state == TASK_RUNNING)
+	if (p == current || task_is_running(p))
 		return 0;
 
 	if (!try_get_task_stack(p))
@@ -975,7 +975,7 @@ unsigned long get_wchan(struct task_stru
 			goto out;
 		}
 		fp = READ_ONCE_NOCHECK(*(unsigned long *)fp);
-	} while (count++ < 16 && p->state != TASK_RUNNING);
+	} while (count++ < 16 && !task_is_running(p));
 
 out:
 	put_task_stack(p);
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3926,7 +3926,7 @@ int blk_poll(struct request_queue *q, bl
 		if (signal_pending_state(state, current))
 			__set_current_state(TASK_RUNNING);
 
-		if (current->state == TASK_RUNNING)
+		if (task_is_running(current))
 			return 1;
 		if (ret < 0 || !spin)
 			break;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -113,6 +113,8 @@ struct task_group;
 					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
 					 TASK_PARKED)
 
+#define task_is_running(task)		(READ_ONCE((task)->state) == TASK_RUNNING)
+
 #define task_is_traced(task)		((task->state & __TASK_TRACED) != 0)
 
 #define task_is_stopped(task)		((task->state & __TASK_STOPPED) != 0)
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -760,7 +760,7 @@ static void lockdep_print_held_locks(str
 	 * It's not reliable to print a task's held locks if it's not sleeping
 	 * and it's not the current task.
 	 */
-	if (p->state == TASK_RUNNING && p != current)
+	if (p != current && task_is_running(p))
 		return;
 	for (i = 0; i < depth; i++) {
 		printk(" #%d: ", i);
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2768,7 +2768,7 @@ EXPORT_SYMBOL_GPL(rcu_bind_current_to_no
 #ifdef CONFIG_SMP
 static char *show_rcu_should_be_on_cpu(struct task_struct *tsp)
 {
-	return tsp && tsp->state == TASK_RUNNING && !tsp->on_cpu ? "!" : "";
+	return tsp && task_is_running(tsp) && !tsp->on_cpu ? "!" : "";
 }
 #else // #ifdef CONFIG_SMP
 static char *show_rcu_should_be_on_cpu(struct task_struct *tsp)
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5989,7 +5989,7 @@ static inline void sched_submit_work(str
 {
 	unsigned int task_flags;
 
-	if (!tsk->state)
+	if (task_is_running(tsk))
 		return;
 
 	task_flags = tsk->flags;
@@ -7964,7 +7964,7 @@ int __sched yield_to(struct task_struct
 	if (curr->sched_class != p->sched_class)
 		goto out_unlock;
 
-	if (task_running(p_rq, p) || p->state)
+	if (task_running(p_rq, p) || !task_is_running(p))
 		goto out_unlock;
 
 	yielded = curr->sched_class->yield_to_task(rq, p);
@@ -8167,7 +8167,7 @@ void sched_show_task(struct task_struct
 
 	pr_info("task:%-15.15s state:%c", p->comm, task_state_to_char(p));
 
-	if (p->state == TASK_RUNNING)
+	if (task_is_running(p))
 		pr_cont("  running task    ");
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -217,7 +217,7 @@ static inline void sched_info_depart(str
 
 	rq_sched_info_depart(rq, delta);
 
-	if (t->state == TASK_RUNNING)
+	if (task_is_running(t))
 		sched_info_enqueue(rq, t);
 }
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4719,7 +4719,7 @@ void kdb_send_sig(struct task_struct *t,
 	}
 	new_t = kdb_prev_t != t;
 	kdb_prev_t = t;
-	if (t->state != TASK_RUNNING && new_t) {
+	if (!task_is_running(t) && new_t) {
 		spin_unlock(&t->sighand->siglock);
 		kdb_printf("Process is not RUNNING, sending a signal from "
 			   "kdb risks deadlock\n"
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -92,8 +92,7 @@ static bool ksoftirqd_running(unsigned l
 
 	if (pending & SOFTIRQ_NOW_MASK)
 		return false;
-	return tsk && (tsk->state == TASK_RUNNING) &&
-		!__kthread_should_park(tsk);
+	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
 }
 
 #ifdef CONFIG_TRACE_IRQFLAGS
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1955,7 +1955,7 @@ static inline bool is_via_compact_memory
 
 static bool kswapd_is_running(pg_data_t *pgdat)
 {
-	return pgdat->kswapd && (pgdat->kswapd->state == TASK_RUNNING);
+	return pgdat->kswapd && task_is_running(pgdat->kswapd);
 }
 
 /*


