Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A09398AB3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhFBNdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFBNdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:33:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE20C06174A;
        Wed,  2 Jun 2021 06:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=6JgI0A9Q5yslyW9254b7p7OoWTCf+lfJk3kZOBm4DKU=; b=geAxFOPZ8wEKCZ6AyPdUDs8Cq5
        2kuMbk6gy01OMLNH0IaMq8UKvrVL96WWcGjyPX2duvNVkPipR3pHdacvXulUbaWbfDXOzlLH2+nx5
        xqsqFCdpwfCDRvHincElO3Jj3FV67A3re2ZMzQOKuyZTIhBW8anoD6fHeT8CD4U3jmbdGroojOQzW
        r/l86rnnHw7tX81oAvfBf13/AMFARgWu9Ot0Olo1xvytxZ3Idu3rTXJo2D3BCX+2ucgJFGXYrdixd
        ClTHz3/7V4OE+BMdXCclMXPBPkUJvOf0YfTApj3m6od9Pc4BRqsSv3dpwQW9OEbVh/CrsOW5IYFXE
        goQCc3xA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1loQxh-00B8o3-C9; Wed, 02 Jun 2021 13:31:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 60F60300553;
        Wed,  2 Jun 2021 15:31:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id AF31A2C1AB5EB; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.587042016@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 02 Jun 2021 15:12:31 +0200
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
Subject: [PATCH 6/6] sched: Change task_struct::state
References: <20210602131225.336600299@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the type and name of task_struct::state. Drop the volatile and
shrink it to an 'unsigned int'. Rename it in order to find all uses
such that we can use READ_ONCE/WRITE_ONCE as appropriate.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 block/blk-mq.c                 |    2 -
 drivers/md/dm.c                |    6 ++--
 fs/binfmt_elf.c                |    8 +++---
 fs/userfaultfd.c               |    4 +--
 include/linux/sched.h          |   31 +++++++++++------------
 include/linux/sched/debug.h    |    2 -
 include/linux/sched/signal.h   |    2 -
 init/init_task.c               |    2 -
 kernel/cgroup/cgroup-v1.c      |    2 -
 kernel/debug/kdb/kdb_support.c |   18 +++++++------
 kernel/fork.c                  |    4 +--
 kernel/hung_task.c             |    2 -
 kernel/kthread.c               |    4 +--
 kernel/locking/mutex.c         |    6 ++--
 kernel/locking/rtmutex.c       |    4 +--
 kernel/locking/rwsem.c         |    2 -
 kernel/ptrace.c                |   12 ++++-----
 kernel/rcu/rcutorture.c        |    4 +--
 kernel/rcu/tree_stall.h        |   12 ++++-----
 kernel/sched/core.c            |   53 +++++++++++++++++++++--------------------
 kernel/sched/deadline.c        |   10 +++----
 kernel/sched/fair.c            |   11 +++++---
 lib/syscall.c                  |    4 +--
 net/core/dev.c                 |    2 -
 24 files changed, 108 insertions(+), 99 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3886,7 +3886,7 @@ static bool blk_mq_poll_hybrid(struct re
 int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
 	struct blk_mq_hw_ctx *hctx;
-	long state;
+	unsigned int state;
 
 	if (!blk_qc_t_valid(cookie) ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2328,7 +2328,7 @@ static bool md_in_flight_bios(struct map
 	return sum != 0;
 }
 
-static int dm_wait_for_bios_completion(struct mapped_device *md, long task_state)
+static int dm_wait_for_bios_completion(struct mapped_device *md, unsigned int task_state)
 {
 	int r = 0;
 	DEFINE_WAIT(wait);
@@ -2351,7 +2351,7 @@ static int dm_wait_for_bios_completion(s
 	return r;
 }
 
-static int dm_wait_for_completion(struct mapped_device *md, long task_state)
+static int dm_wait_for_completion(struct mapped_device *md, unsigned int task_state)
 {
 	int r = 0;
 
@@ -2478,7 +2478,7 @@ static void unlock_fs(struct mapped_devi
  * are being added to md->deferred list.
  */
 static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
-			unsigned suspend_flags, long task_state,
+			unsigned suspend_flags, unsigned int task_state,
 			int dmf_suspended_flag)
 {
 	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1537,7 +1537,8 @@ static int fill_psinfo(struct elf_prpsin
 {
 	const struct cred *cred;
 	unsigned int i, len;
-	
+	unsigned int state;
+
 	/* first copy the parameters from user space */
 	memset(psinfo, 0, sizeof(struct elf_prpsinfo));
 
@@ -1559,7 +1560,8 @@ static int fill_psinfo(struct elf_prpsin
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
-	i = p->state ? ffz(~p->state) + 1 : 0;
+	state = READ_ONCE(p->__state);
+	i = state ? ffz(~state) + 1 : 0;
 	psinfo->pr_state = i;
 	psinfo->pr_sname = (i > 5) ? '.' : "RSDTZW"[i];
 	psinfo->pr_zomb = psinfo->pr_sname == 'Z';
@@ -1571,7 +1573,7 @@ static int fill_psinfo(struct elf_prpsin
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
 	strncpy(psinfo->pr_fname, p->comm, sizeof(psinfo->pr_fname));
-	
+
 	return 0;
 }
 
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -337,7 +337,7 @@ static inline bool userfaultfd_must_wait
 	return ret;
 }
 
-static inline long userfaultfd_get_blocking_state(unsigned int flags)
+static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
 {
 	if (flags & FAULT_FLAG_INTERRUPTIBLE)
 		return TASK_INTERRUPTIBLE;
@@ -370,7 +370,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	struct userfaultfd_wait_queue uwq;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool must_wait;
-	long blocking_state;
+	unsigned int blocking_state;
 
 	/*
 	 * We don't do userfault handling for the final child pid update.
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -113,13 +113,13 @@ struct task_group;
 					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
 					 TASK_PARKED)
 
-#define task_is_running(task)		(READ_ONCE((task)->state) == TASK_RUNNING)
+#define task_is_running(task)		(READ_ONCE((task)->__state) == TASK_RUNNING)
 
-#define task_is_traced(task)		((task->state & __TASK_TRACED) != 0)
+#define task_is_traced(task)		((READ_ONCE(task->__state) & __TASK_TRACED) != 0)
 
-#define task_is_stopped(task)		((task->state & __TASK_STOPPED) != 0)
+#define task_is_stopped(task)		((READ_ONCE(task->__state) & __TASK_STOPPED) != 0)
 
-#define task_is_stopped_or_traced(task)	((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
+#define task_is_stopped_or_traced(task)	((READ_ONCE(task->__state) & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 
@@ -134,14 +134,14 @@ struct task_group;
 	do {							\
 		WARN_ON_ONCE(is_special_task_state(state_value));\
 		current->task_state_change = _THIS_IP_;		\
-		current->state = (state_value);			\
+		WRITE_ONCE(current->__state, (state_value));	\
 	} while (0)
 
 #define set_current_state(state_value)				\
 	do {							\
 		WARN_ON_ONCE(is_special_task_state(state_value));\
 		current->task_state_change = _THIS_IP_;		\
-		smp_store_mb(current->state, (state_value));	\
+		smp_store_mb(current->__state, (state_value));	\
 	} while (0)
 
 #define set_special_state(state_value)					\
@@ -150,7 +150,7 @@ struct task_group;
 		WARN_ON_ONCE(!is_special_task_state(state_value));	\
 		raw_spin_lock_irqsave(&current->pi_lock, flags);	\
 		current->task_state_change = _THIS_IP_;			\
-		current->state = (state_value);				\
+		WRITE_ONCE(current->__state, (state_value));		\
 		raw_spin_unlock_irqrestore(&current->pi_lock, flags);	\
 	} while (0)
 #else
@@ -192,10 +192,10 @@ struct task_group;
  * Also see the comments of try_to_wake_up().
  */
 #define __set_current_state(state_value)				\
-	current->state = (state_value)
+	WRITE_ONCE(current->__state, (state_value))
 
 #define set_current_state(state_value)					\
-	smp_store_mb(current->state, (state_value))
+	smp_store_mb(current->__state, (state_value))
 
 /*
  * set_special_state() should be used for those states when the blocking task
@@ -207,13 +207,13 @@ struct task_group;
 	do {								\
 		unsigned long flags; /* may shadow */			\
 		raw_spin_lock_irqsave(&current->pi_lock, flags);	\
-		current->state = (state_value);				\
+		WRITE_ONCE(current->__state, (state_value));		\
 		raw_spin_unlock_irqrestore(&current->pi_lock, flags);	\
 	} while (0)
 
 #endif
 
-#define get_current_state()	READ_ONCE(current->state)
+#define get_current_state()	READ_ONCE(current->__state)
 
 /* Task command name length: */
 #define TASK_COMM_LEN			16
@@ -658,8 +658,7 @@ struct task_struct {
 	 */
 	struct thread_info		thread_info;
 #endif
-	/* -1 unrunnable, 0 runnable, >0 stopped: */
-	volatile long			state;
+	unsigned int			__state;
 
 	/*
 	 * This begins the randomizable portion of task_struct. Only
@@ -1524,7 +1523,7 @@ static inline pid_t task_pgrp_nr(struct
 
 static inline unsigned int task_state_index(struct task_struct *tsk)
 {
-	unsigned int tsk_state = READ_ONCE(tsk->state);
+	unsigned int tsk_state = READ_ONCE(tsk->__state);
 	unsigned int state = (tsk_state | tsk->exit_state) & TASK_REPORT;
 
 	BUILD_BUG_ON_NOT_POWER_OF_2(TASK_REPORT_MAX);
@@ -1832,10 +1831,10 @@ static __always_inline void scheduler_ip
 	 */
 	preempt_fold_need_resched();
 }
-extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
+extern unsigned long wait_task_inactive(struct task_struct *, unsigned int match_state);
 #else
 static inline void scheduler_ipi(void) { }
-static inline unsigned long wait_task_inactive(struct task_struct *p, long match_state)
+static inline unsigned long wait_task_inactive(struct task_struct *p, unsigned int match_state)
 {
 	return 1;
 }
--- a/include/linux/sched/debug.h
+++ b/include/linux/sched/debug.h
@@ -14,7 +14,7 @@ extern void dump_cpu_task(int cpu);
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
-extern void show_state_filter(unsigned long state_filter);
+extern void show_state_filter(unsigned int state_filter);
 
 static inline void show_state(void)
 {
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -382,7 +382,7 @@ static inline int fatal_signal_pending(s
 	return task_sigpending(p) && __fatal_signal_pending(p);
 }
 
-static inline int signal_pending_state(long state, struct task_struct *p)
+static inline int signal_pending_state(unsigned int state, struct task_struct *p)
 {
 	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
 		return 0;
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -71,7 +71,7 @@ struct task_struct init_task
 	.thread_info	= INIT_THREAD_INFO(init_task),
 	.stack_refcount	= REFCOUNT_INIT(1),
 #endif
-	.state		= 0,
+	.__state	= 0,
 	.stack		= init_stack,
 	.usage		= REFCOUNT_INIT(2),
 	.flags		= PF_KTHREAD,
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -713,7 +713,7 @@ int cgroupstats_build(struct cgroupstats
 
 	css_task_iter_start(&cgrp->self, 0, &it);
 	while ((tsk = css_task_iter_next(&it))) {
-		switch (tsk->state) {
+		switch (READ_ONCE(tsk->__state)) {
 		case TASK_RUNNING:
 			stats->nr_running++;
 			break;
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -609,23 +609,25 @@ unsigned long kdb_task_state_string(cons
  */
 char kdb_task_state_char (const struct task_struct *p)
 {
-	int cpu;
-	char state;
+	unsigned int p_state;
 	unsigned long tmp;
+	char state;
+	int cpu;
 
 	if (!p ||
 	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
 		return 'E';
 
 	cpu = kdb_process_cpu(p);
-	state = (p->state == 0) ? 'R' :
-		(p->state < 0) ? 'U' :
-		(p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
-		(p->state & TASK_STOPPED) ? 'T' :
-		(p->state & TASK_TRACED) ? 'C' :
+	p_state = READ_ONCE(p->__state);
+	state = (p_state == 0) ? 'R' :
+		(p_state < 0) ? 'U' :
+		(p_state & TASK_UNINTERRUPTIBLE) ? 'D' :
+		(p_state & TASK_STOPPED) ? 'T' :
+		(p_state & TASK_TRACED) ? 'C' :
 		(p->exit_state & EXIT_ZOMBIE) ? 'Z' :
 		(p->exit_state & EXIT_DEAD) ? 'E' :
-		(p->state & TASK_INTERRUPTIBLE) ? 'S' : '?';
+		(p_state & TASK_INTERRUPTIBLE) ? 'S' : '?';
 	if (is_idle_task(p)) {
 		/* Idle task.  Is it really idle, apart from the kdb
 		 * interrupt? */
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -425,7 +425,7 @@ static int memcg_charge_kernel_stack(str
 
 static void release_task_stack(struct task_struct *tsk)
 {
-	if (WARN_ON(tsk->state != TASK_DEAD))
+	if (WARN_ON(READ_ONCE(tsk->__state) != TASK_DEAD))
 		return;  /* Better to leak the stack than to free prematurely */
 
 	account_kernel_stack(tsk, -1);
@@ -2392,7 +2392,7 @@ static __latent_entropy struct task_stru
 	atomic_dec(&p->cred->user->processes);
 	exit_creds(p);
 bad_fork_free:
-	p->state = TASK_DEAD;
+	WRITE_ONCE(p->__state, TASK_DEAD);
 	put_task_stack(p);
 	delayed_free_task(p);
 fork_out:
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -196,7 +196,7 @@ static void check_hung_uninterruptible_t
 			last_break = jiffies;
 		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
-		if (t->state == TASK_UNINTERRUPTIBLE)
+		if (READ_ONCE(t->__state) == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, timeout);
 	}
  unlock:
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -457,7 +457,7 @@ struct task_struct *kthread_create_on_no
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
-static void __kthread_bind_mask(struct task_struct *p, const struct cpumask *mask, long state)
+static void __kthread_bind_mask(struct task_struct *p, const struct cpumask *mask, unsigned int state)
 {
 	unsigned long flags;
 
@@ -473,7 +473,7 @@ static void __kthread_bind_mask(struct t
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
-static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
+static void __kthread_bind(struct task_struct *p, unsigned int cpu, unsigned int state)
 {
 	__kthread_bind_mask(p, cpumask_of(cpu), state);
 }
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -923,7 +923,7 @@ __ww_mutex_add_waiter(struct mutex_waite
  * Lock a mutex (possibly interruptible), slowpath:
  */
 static __always_inline int __sched
-__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
+__mutex_lock_common(struct mutex *lock, unsigned int state, unsigned int subclass,
 		    struct lockdep_map *nest_lock, unsigned long ip,
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
@@ -1098,14 +1098,14 @@ __mutex_lock_common(struct mutex *lock,
 }
 
 static int __sched
-__mutex_lock(struct mutex *lock, long state, unsigned int subclass,
+__mutex_lock(struct mutex *lock, unsigned int state, unsigned int subclass,
 	     struct lockdep_map *nest_lock, unsigned long ip)
 {
 	return __mutex_lock_common(lock, state, subclass, nest_lock, ip, NULL, false);
 }
 
 static int __sched
-__ww_mutex_lock(struct mutex *lock, long state, unsigned int subclass,
+__ww_mutex_lock(struct mutex *lock, unsigned int state, unsigned int subclass,
 		struct lockdep_map *nest_lock, unsigned long ip,
 		struct ww_acquire_ctx *ww_ctx)
 {
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1135,7 +1135,7 @@ void __sched rt_mutex_init_waiter(struct
  *
  * Must be called with lock->wait_lock held and interrupts disabled
  */
-static int __sched __rt_mutex_slowlock(struct rt_mutex *lock, int state,
+static int __sched __rt_mutex_slowlock(struct rt_mutex *lock, unsigned int state,
 				       struct hrtimer_sleeper *timeout,
 				       struct rt_mutex_waiter *waiter)
 {
@@ -1190,7 +1190,7 @@ static void __sched rt_mutex_handle_dead
 /*
  * Slow path lock function:
  */
-static int __sched rt_mutex_slowlock(struct rt_mutex *lock, int state,
+static int __sched rt_mutex_slowlock(struct rt_mutex *lock, unsigned int state,
 				     struct hrtimer_sleeper *timeout,
 				     enum rtmutex_chainwalk chwalk)
 {
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -889,7 +889,7 @@ rwsem_spin_on_owner(struct rw_semaphore
  * Wait for the read lock to be granted
  */
 static struct rw_semaphore __sched *
-rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
+rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int state)
 {
 	long adjustment = -RWSEM_READER_BIAS;
 	long rcnt = (count >> RWSEM_READER_SHIFT);
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -197,7 +197,7 @@ static bool ptrace_freeze_traced(struct
 	spin_lock_irq(&task->sighand->siglock);
 	if (task_is_traced(task) && !looks_like_a_spurious_pid(task) &&
 	    !__fatal_signal_pending(task)) {
-		task->state = __TASK_TRACED;
+		WRITE_ONCE(task->__state, __TASK_TRACED);
 		ret = true;
 	}
 	spin_unlock_irq(&task->sighand->siglock);
@@ -207,7 +207,7 @@ static bool ptrace_freeze_traced(struct
 
 static void ptrace_unfreeze_traced(struct task_struct *task)
 {
-	if (task->state != __TASK_TRACED)
+	if (READ_ONCE(task->__state) != __TASK_TRACED)
 		return;
 
 	WARN_ON(!task->ptrace || task->parent != current);
@@ -217,11 +217,11 @@ static void ptrace_unfreeze_traced(struc
 	 * Recheck state under the lock to close this race.
 	 */
 	spin_lock_irq(&task->sighand->siglock);
-	if (task->state == __TASK_TRACED) {
+	if (READ_ONCE(task->__state) == __TASK_TRACED) {
 		if (__fatal_signal_pending(task))
 			wake_up_state(task, __TASK_TRACED);
 		else
-			task->state = TASK_TRACED;
+			WRITE_ONCE(task->__state, TASK_TRACED);
 	}
 	spin_unlock_irq(&task->sighand->siglock);
 }
@@ -256,7 +256,7 @@ static int ptrace_check_attach(struct ta
 	 */
 	read_lock(&tasklist_lock);
 	if (child->ptrace && child->parent == current) {
-		WARN_ON(child->state == __TASK_TRACED);
+		WARN_ON(READ_ONCE(child->__state) == __TASK_TRACED);
 		/*
 		 * child->sighand can't be NULL, release_task()
 		 * does ptrace_unlink() before __exit_signal().
@@ -273,7 +273,7 @@ static int ptrace_check_attach(struct ta
 			 * ptrace_stop() changes ->state back to TASK_RUNNING,
 			 * so we should not worry about leaking __TASK_TRACED.
 			 */
-			WARN_ON(child->state == __TASK_TRACED);
+			WARN_ON(READ_ONCE(child->__state) == __TASK_TRACED);
 			ret = -ESRCH;
 		}
 	}
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1831,10 +1831,10 @@ rcu_torture_stats_print(void)
 		srcutorture_get_gp_data(cur_ops->ttype, srcu_ctlp,
 					&flags, &gp_seq);
 		wtp = READ_ONCE(writer_task);
-		pr_alert("??? Writer stall state %s(%d) g%lu f%#x ->state %#lx cpu %d\n",
+		pr_alert("??? Writer stall state %s(%d) g%lu f%#x ->state %#x cpu %d\n",
 			 rcu_torture_writer_state_getname(),
 			 rcu_torture_writer_state, gp_seq, flags,
-			 wtp == NULL ? ~0UL : wtp->state,
+			 wtp == NULL ? ~0U : wtp->__state,
 			 wtp == NULL ? -1 : (int)task_cpu(wtp));
 		if (!splatted && wtp) {
 			sched_show_task(wtp);
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -460,12 +460,12 @@ static void rcu_check_gp_kthread_starvat
 
 	if (rcu_is_gp_kthread_starving(&j)) {
 		cpu = gpk ? task_cpu(gpk) : -1;
-		pr_err("%s kthread starved for %ld jiffies! g%ld f%#x %s(%d) ->state=%#lx ->cpu=%d\n",
+		pr_err("%s kthread starved for %ld jiffies! g%ld f%#x %s(%d) ->state=%#x ->cpu=%d\n",
 		       rcu_state.name, j,
 		       (long)rcu_seq_current(&rcu_state.gp_seq),
 		       data_race(rcu_state.gp_flags),
 		       gp_state_getname(rcu_state.gp_state), rcu_state.gp_state,
-		       gpk ? gpk->state : ~0, cpu);
+		       gpk ? gpk->__state : ~0, cpu);
 		if (gpk) {
 			pr_err("\tUnless %s kthread gets sufficient CPU time, OOM is now expected behavior.\n", rcu_state.name);
 			pr_err("RCU grace-period kthread stack dump:\n");
@@ -503,12 +503,12 @@ static void rcu_check_gp_kthread_expired
 	    time_after(jiffies, jiffies_fqs + RCU_STALL_MIGHT_MIN) &&
 	    gpk && !READ_ONCE(gpk->on_rq)) {
 		cpu = task_cpu(gpk);
-		pr_err("%s kthread timer wakeup didn't happen for %ld jiffies! g%ld f%#x %s(%d) ->state=%#lx\n",
+		pr_err("%s kthread timer wakeup didn't happen for %ld jiffies! g%ld f%#x %s(%d) ->state=%#x\n",
 		       rcu_state.name, (jiffies - jiffies_fqs),
 		       (long)rcu_seq_current(&rcu_state.gp_seq),
 		       data_race(rcu_state.gp_flags),
 		       gp_state_getname(RCU_GP_WAIT_FQS), RCU_GP_WAIT_FQS,
-		       gpk->state);
+		       gpk->__state);
 		pr_err("\tPossible timer handling issue on cpu=%d timer-softirq=%u\n",
 		       cpu, kstat_softirqs_cpu(TIMER_SOFTIRQ, cpu));
 	}
@@ -735,9 +735,9 @@ void show_rcu_gp_kthreads(void)
 	ja = j - data_race(rcu_state.gp_activity);
 	jr = j - data_race(rcu_state.gp_req_activity);
 	jw = j - data_race(rcu_state.gp_wake_time);
-	pr_info("%s: wait state: %s(%d) ->state: %#lx delta ->gp_activity %lu ->gp_req_activity %lu ->gp_wake_time %lu ->gp_wake_seq %ld ->gp_seq %ld ->gp_seq_needed %ld ->gp_flags %#x\n",
+	pr_info("%s: wait state: %s(%d) ->state: %#x delta ->gp_activity %lu ->gp_req_activity %lu ->gp_wake_time %lu ->gp_wake_seq %ld ->gp_seq %ld ->gp_seq_needed %ld ->gp_flags %#x\n",
 		rcu_state.name, gp_state_getname(rcu_state.gp_state),
-		rcu_state.gp_state, t ? t->state : 0x1ffffL,
+		rcu_state.gp_state, t ? t->__state : 0x1ffff,
 		ja, jr, jw, (long)data_race(rcu_state.gp_wake_seq),
 		(long)data_race(rcu_state.gp_seq),
 		(long)data_race(rcu_get_root()->gp_seq_needed),
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2643,7 +2643,7 @@ static int affine_move_task(struct rq *r
 		return -EINVAL;
 	}
 
-	if (task_running(rq, p) || p->state == TASK_WAKING) {
+	if (task_running(rq, p) || READ_ONCE(p->__state) == TASK_WAKING) {
 		/*
 		 * MIGRATE_ENABLE gets here because 'p == current', but for
 		 * anything else we cannot do is_migration_disabled(), punt
@@ -2786,19 +2786,20 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 #ifdef CONFIG_SCHED_DEBUG
+	unsigned int state = READ_ONCE(p->__state);
+
 	/*
 	 * We should never call set_task_cpu() on a blocked task,
 	 * ttwu() will sort out the placement.
 	 */
-	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!p->on_rq);
+	WARN_ON_ONCE(state != TASK_RUNNING && state != TASK_WAKING && !p->on_rq);
 
 	/*
 	 * Migrating fair class task must have p->on_rq = TASK_ON_RQ_MIGRATING,
 	 * because schedstat_wait_{start,end} rebase migrating task's wait_start
 	 * time relying on p->on_rq.
 	 */
-	WARN_ON_ONCE(p->state == TASK_RUNNING &&
+	WARN_ON_ONCE(state == TASK_RUNNING &&
 		     p->sched_class == &fair_sched_class &&
 		     (p->on_rq && !task_on_rq_migrating(p)));
 
@@ -2970,7 +2971,7 @@ int migrate_swap(struct task_struct *cur
  * smp_call_function() if an IPI is sent by the same process we are
  * waiting to become inactive.
  */
-unsigned long wait_task_inactive(struct task_struct *p, long match_state)
+unsigned long wait_task_inactive(struct task_struct *p, unsigned int match_state)
 {
 	int running, queued;
 	struct rq_flags rf;
@@ -2998,7 +2999,7 @@ unsigned long wait_task_inactive(struct
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state))
+			if (match_state && unlikely(READ_ONCE(p->__state) != match_state))
 				return 0;
 			cpu_relax();
 		}
@@ -3013,7 +3014,7 @@ unsigned long wait_task_inactive(struct
 		running = task_running(rq, p);
 		queued = task_on_rq_queued(p);
 		ncsw = 0;
-		if (!match_state || p->state == match_state)
+		if (!match_state || READ_ONCE(p->__state) == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, p, &rf);
 
@@ -3322,7 +3323,7 @@ static void ttwu_do_wakeup(struct rq *rq
 			   struct rq_flags *rf)
 {
 	check_preempt_curr(rq, p, wake_flags);
-	p->state = TASK_RUNNING;
+	WRITE_ONCE(p->__state, TASK_RUNNING);
 	trace_sched_wakeup(p);
 
 #ifdef CONFIG_SMP
@@ -3711,12 +3712,12 @@ try_to_wake_up(struct task_struct *p, un
 		 *  - we're serialized against set_special_state() by virtue of
 		 *    it disabling IRQs (this allows not taking ->pi_lock).
 		 */
-		if (!(p->state & state))
+		if (!(READ_ONCE(p->__state) & state))
 			goto out;
 
 		success = 1;
 		trace_sched_waking(p);
-		p->state = TASK_RUNNING;
+		WRITE_ONCE(p->__state, TASK_RUNNING);
 		trace_sched_wakeup(p);
 		goto out;
 	}
@@ -3729,7 +3730,7 @@ try_to_wake_up(struct task_struct *p, un
 	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	smp_mb__after_spinlock();
-	if (!(p->state & state))
+	if (!(READ_ONCE(p->__state) & state))
 		goto unlock;
 
 	trace_sched_waking(p);
@@ -3795,7 +3796,7 @@ try_to_wake_up(struct task_struct *p, un
 	 * TASK_WAKING such that we can unlock p->pi_lock before doing the
 	 * enqueue, such as ttwu_queue_wakelist().
 	 */
-	p->state = TASK_WAKING;
+	WRITE_ONCE(p->__state, TASK_WAKING);
 
 	/*
 	 * If the owning (remote) CPU is still in the middle of schedule() with
@@ -3888,7 +3889,7 @@ bool try_invoke_on_locked_down_task(stru
 			ret = func(p, arg);
 		rq_unlock(rq, &rf);
 	} else {
-		switch (p->state) {
+		switch (READ_ONCE(p->__state)) {
 		case TASK_RUNNING:
 		case TASK_WAKING:
 			break;
@@ -4101,7 +4102,7 @@ int sched_fork(unsigned long clone_flags
 	 * nobody will actually run it, and a signal or other external
 	 * event cannot wake it up and insert it on the runqueue either.
 	 */
-	p->state = TASK_NEW;
+	p->__state = TASK_NEW;
 
 	/*
 	 * Make sure we do not leak PI boosting priority to the child.
@@ -4207,7 +4208,7 @@ void wake_up_new_task(struct task_struct
 	struct rq *rq;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
-	p->state = TASK_RUNNING;
+	WRITE_ONCE(p->__state, TASK_RUNNING);
 #ifdef CONFIG_SMP
 	/*
 	 * Fork balancing, do it here and not earlier because:
@@ -4569,7 +4570,7 @@ static struct rq *finish_task_switch(str
 	 * running on another CPU and we could rave with its RUNNING -> DEAD
 	 * transition, resulting in a double drop.
 	 */
-	prev_state = prev->state;
+	prev_state = READ_ONCE(prev->__state);
 	vtime_task_switch(prev);
 	perf_event_task_sched_in(prev, current);
 	finish_task(prev);
@@ -5263,7 +5264,7 @@ static inline void schedule_debug(struct
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-	if (!preempt && prev->state && prev->non_block_count) {
+	if (!preempt && READ_ONCE(prev->__state) && prev->non_block_count) {
 		printk(KERN_ERR "BUG: scheduling in a non-blocking section: %s/%d/%i\n",
 			prev->comm, prev->pid, prev->non_block_count);
 		dump_stack();
@@ -5889,10 +5890,10 @@ static void __sched notrace __schedule(b
 	 *  - we form a control dependency vs deactivate_task() below.
 	 *  - ptrace_{,un}freeze_traced() can change ->state underneath us.
 	 */
-	prev_state = prev->state;
+	prev_state = READ_ONCE(prev->__state);
 	if (!preempt && prev_state) {
 		if (signal_pending_state(prev_state, prev)) {
-			prev->state = TASK_RUNNING;
+			WRITE_ONCE(prev->__state, TASK_RUNNING);
 		} else {
 			prev->sched_contributes_to_load =
 				(prev_state & TASK_UNINTERRUPTIBLE) &&
@@ -6064,7 +6065,7 @@ void __sched schedule_idle(void)
 	 * current task can be in any other state. Note, idle is always in the
 	 * TASK_RUNNING state.
 	 */
-	WARN_ON_ONCE(current->state);
+	WARN_ON_ONCE(current->__state);
 	do {
 		__schedule(false);
 	} while (need_resched());
@@ -8191,26 +8192,28 @@ EXPORT_SYMBOL_GPL(sched_show_task);
 static inline bool
 state_filter_match(unsigned long state_filter, struct task_struct *p)
 {
+	unsigned int state = READ_ONCE(p->__state);
+
 	/* no filter, everything matches */
 	if (!state_filter)
 		return true;
 
 	/* filter, but doesn't match */
-	if (!(p->state & state_filter))
+	if (!(state & state_filter))
 		return false;
 
 	/*
 	 * When looking for TASK_UNINTERRUPTIBLE skip TASK_IDLE (allows
 	 * TASK_KILLABLE).
 	 */
-	if (state_filter == TASK_UNINTERRUPTIBLE && p->state == TASK_IDLE)
+	if (state_filter == TASK_UNINTERRUPTIBLE && state == TASK_IDLE)
 		return false;
 
 	return true;
 }
 
 
-void show_state_filter(unsigned long state_filter)
+void show_state_filter(unsigned int state_filter)
 {
 	struct task_struct *g, *p;
 
@@ -8267,7 +8270,7 @@ void __init init_idle(struct task_struct
 	raw_spin_lock_irqsave(&idle->pi_lock, flags);
 	raw_spin_rq_lock(rq);
 
-	idle->state = TASK_RUNNING;
+	idle->__state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 	/*
 	 * PF_KTHREAD should already be set at this point; regardless, make it
@@ -9582,7 +9585,7 @@ static int cpu_cgroup_can_attach(struct
 		 * has happened. This would lead to problems with PELT, due to
 		 * move wanting to detach+attach while we're not attached yet.
 		 */
-		if (task->state == TASK_NEW)
+		if (READ_ONCE(task->__state) == TASK_NEW)
 			ret = -EINVAL;
 		raw_spin_unlock_irq(&task->pi_lock);
 
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -348,10 +348,10 @@ static void task_non_contending(struct t
 	if ((zerolag_time < 0) || hrtimer_active(&dl_se->inactive_timer)) {
 		if (dl_task(p))
 			sub_running_bw(dl_se, dl_rq);
-		if (!dl_task(p) || p->state == TASK_DEAD) {
+		if (!dl_task(p) || READ_ONCE(p->__state) == TASK_DEAD) {
 			struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
 
-			if (p->state == TASK_DEAD)
+			if (READ_ONCE(p->__state) == TASK_DEAD)
 				sub_rq_bw(&p->dl, &rq->dl);
 			raw_spin_lock(&dl_b->lock);
 			__dl_sub(dl_b, p->dl.dl_bw, dl_bw_cpus(task_cpu(p)));
@@ -1355,10 +1355,10 @@ static enum hrtimer_restart inactive_tas
 	sched_clock_tick();
 	update_rq_clock(rq);
 
-	if (!dl_task(p) || p->state == TASK_DEAD) {
+	if (!dl_task(p) || READ_ONCE(p->__state) == TASK_DEAD) {
 		struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
 
-		if (p->state == TASK_DEAD && dl_se->dl_non_contending) {
+		if (READ_ONCE(p->__state) == TASK_DEAD && dl_se->dl_non_contending) {
 			sub_running_bw(&p->dl, dl_rq_of_se(&p->dl));
 			sub_rq_bw(&p->dl, dl_rq_of_se(&p->dl));
 			dl_se->dl_non_contending = 0;
@@ -1722,7 +1722,7 @@ static void migrate_task_rq_dl(struct ta
 {
 	struct rq *rq;
 
-	if (p->state != TASK_WAKING)
+	if (READ_ONCE(p->__state) != TASK_WAKING)
 		return;
 
 	rq = task_rq(p);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -993,11 +993,14 @@ update_stats_dequeue(struct cfs_rq *cfs_
 
 	if ((flags & DEQUEUE_SLEEP) && entity_is_task(se)) {
 		struct task_struct *tsk = task_of(se);
+		unsigned int state;
 
-		if (tsk->state & TASK_INTERRUPTIBLE)
+		/* XXX racy against TTWU */
+		state = READ_ONCE(tsk->__state);
+		if (state & TASK_INTERRUPTIBLE)
 			__schedstat_set(se->statistics.sleep_start,
 				      rq_clock(rq_of(cfs_rq)));
-		if (tsk->state & TASK_UNINTERRUPTIBLE)
+		if (state & TASK_UNINTERRUPTIBLE)
 			__schedstat_set(se->statistics.block_start,
 				      rq_clock(rq_of(cfs_rq)));
 	}
@@ -6830,7 +6833,7 @@ static void migrate_task_rq_fair(struct
 	 * min_vruntime -- the latter is done by enqueue_entity() when placing
 	 * the task on the new runqueue.
 	 */
-	if (p->state == TASK_WAKING) {
+	if (READ_ONCE(p->__state) == TASK_WAKING) {
 		struct sched_entity *se = &p->se;
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 		u64 min_vruntime;
@@ -11012,7 +11015,7 @@ static inline bool vruntime_normalized(s
 	 *   waiting for actually being woken up by sched_ttwu_pending().
 	 */
 	if (!se->sum_exec_runtime ||
-	    (p->state == TASK_WAKING && p->sched_remote_wakeup))
+	    (READ_ONCE(p->__state) == TASK_WAKING && p->sched_remote_wakeup))
 		return true;
 
 	return false;
--- a/lib/syscall.c
+++ b/lib/syscall.c
@@ -68,13 +68,13 @@ static int collect_syscall(struct task_s
  */
 int task_current_syscall(struct task_struct *target, struct syscall_info *info)
 {
-	long state;
 	unsigned long ncsw;
+	unsigned int state;
 
 	if (target == current)
 		return collect_syscall(target, info);
 
-	state = target->state;
+	state = READ_ONCE(target->__state);
 	if (unlikely(!state))
 		return -EAGAIN;
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4363,7 +4363,7 @@ static inline void ____napi_schedule(str
 			 * makes sure to proceed with napi polling
 			 * if the thread is explicitly woken from here.
 			 */
-			if (READ_ONCE(thread->state) != TASK_INTERRUPTIBLE)
+			if (READ_ONCE(thread->__state) != TASK_INTERRUPTIBLE)
 				set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
 			wake_up_process(thread);
 			return;


