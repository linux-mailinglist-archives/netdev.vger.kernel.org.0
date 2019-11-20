Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F53103126
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfKTBaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:30:10 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46677 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfKTBaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 20:30:09 -0500
Received: by mail-pf1-f194.google.com with SMTP id 193so13323723pfc.13;
        Tue, 19 Nov 2019 17:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PXW/h+WTRsdBO6GKj8hQL0d3nGyD2Rle+NB8gBC0mzg=;
        b=BbLQCNd9zz3FBV2zLTaDxzS1J6EtLmhgWusmnwOVN2Bw8ST276K4L2deF8netV/IU0
         +LLRMmd2Q1hISFAs4xcYUtZFmwQX115iDD+qsbriufRVh6Hp0IzOG6STwVEqiX4CUHFJ
         SzEr0k31Vv2G2d/1fEzaFqMqdsLCAENla1PpUzX3TbdUxLyAZWkRtk1Y/hi9LTVbRLmr
         N7W6DQhtCmXF/LVJei5rLqtHxcG+QKlc4gTMNkQKQmd1Ik6lrXYmB9KGYzyzgFHKZ2Mc
         Ln4v2YcQHQaW/WEp7/eY33NkwNtesuzyGLhEnp083RgZXe73WYj60CRCzyvXuWS2AAfe
         qu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PXW/h+WTRsdBO6GKj8hQL0d3nGyD2Rle+NB8gBC0mzg=;
        b=ipFMyRkqX74mJVMQf2qNaTvjlQ4BpSHpQH45UkKvjR0bjBIIzXSLeNVwpyVNR7D/kT
         79n43Vxd9Nx+AMyKzXnjLeOVZJ+cMTN4/dM1nTUBv5v7YzZEH2cw1GDiXsvApJJrEHIY
         6Amh9qUXhCftXLbKM145/xi1Je1qVNHLiPhgZPNJX/5e27LeeTXLrxwtcfjxQwna0baY
         bv9MPfy9Brg9N8p2U+U9DZDLC07bVpF67c7Pcnk19rbOVRSgYQm31dFJtpOXztNNBRcu
         4RvMKH4V9CKg9wi0MEWRHkWx8UV8ubTBtnAaZ34V9RwnzvRfPA8qMVwsca3SDh1ND9sW
         eTpA==
X-Gm-Message-State: APjAAAXdDRb+s3E3rH1i1iHWGxgfshbzsWyfp3/HLjnkhXfq6qpVYBh7
        l5p4174145t1M+IosYgfde15KcDV
X-Google-Smtp-Source: APXvYqzYN7MZQOmxRg5MR1TTxNDprl/Lsf3VARfSzYyNGJD2EsqHp8+p5S4fAFReL+CF6aSJSnyMWA==
X-Received: by 2002:a62:1ac6:: with SMTP id a189mr774301pfa.96.1574213408446;
        Tue, 19 Nov 2019 17:30:08 -0800 (PST)
Received: from localhost ([2a00:79e1:abc:f604:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id j21sm26861673pfa.58.2019.11.19.17.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 17:30:07 -0800 (PST)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Wed, 20 Nov 2019 10:30:05 +0900
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20191120013005.GA3191@tigerII.localdomain>
References: <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1573751570.5937.122.camel@lca.pw>
 <20191118152738.az364dczadskgimc@pathway.suse.cz>
 <20191119004119.GC208047@google.com>
 <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119094134.6hzbjc7l5ite6bpg@pathway.suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (19/11/19 10:41), Petr Mladek wrote:
[..]
> > > I do not like this. As a result, normal printk() will always deadlock
> > > in the scheduler code, including WARN() calls. The chance of the
> > > deadlock is small now. It happens only when there is another
> > > process waiting for console_sem.
> > 
> > Why would it *always* deadlock? If this is the case, why we don't *always*
> > deadlock doing the very same wake_up_process() from console_unlock()?
> 
> I speak about _normal_ printk() and not about printk_deferred().
> 
> wake_up_process() is called in console_unlock() only when
> sem->wait_list is not empty, see up() in kernel/locking/semaphore.c.
> printk() itself uses console_trylock() and does not wait.

Sorry, I should have spent more time on this. So here's what I should
have written instead.

console_sem is not for kthreads or kernel only. User space apps can sleep
on it. And on some setups console_sem becomes really congested, with often
times non-empty console_sem->wait_list. All because of user space, we don't
even need printk()-s. For example, when user space uses tty for I/O.

Significantly trimmed logs from my laptop (a simple patch below). Just
to show that user space sleeps on console_sem (IOW, non-empty ->wait_list).

Notice - ls, bash, journalctl, etc. All competing for console_sem.

[..]
 printk: >>> bash WOKEUP console_sem() waiter
 printk: task journalctl couldn't lock console_sem and had to schedule out
 Call Trace:
  dump_stack+0x50/0x70
  console_lock.cold+0x21/0x26
  con_write+0x28/0x50
  n_tty_write+0x12f/0x4c0
  ? wait_woken+0xa0/0xa0
  tty_write+0x1a9/0x2f0
  ? n_tty_read+0x930/0x930
  vfs_write+0xb7/0x1e0

printk: >>> ls WOKEUP console_sem() waiter
printk: task kworker/3:1 couldn't lock console_sem and had to schedule out
Workqueue: events console_callback
Call Trace:
 dump_stack+0x50/0x70
 console_lock.cold+0x21/0x26
 console_callback+0xa/0x150
 ? _cond_resched+0x15/0x50
 process_one_work+0x18b/0x2e0
 worker_thread+0x4e/0x3d0
 ? process_one_work+0x2e0/0x2e0
 kthread+0x119/0x130

printk: >>> kworker/3:1 WOKEUP console_sem() waiter
printk: task ls couldn't lock console_sem and had to schedule out
Call Trace:
 dump_stack+0x50/0x70
 console_lock.cold+0x21/0x26
 con_write+0x28/0x50
 do_output_char+0x191/0x1f0
 n_tty_write+0x17e/0x4c0
 ? __switch_to_asm+0x24/0x60
 ? wait_woken+0xa0/0xa0
 tty_write+0x1a9/0x2f0
 ? n_tty_read+0x930/0x930
 vfs_write+0xb7/0x1e0
[..]

> I believe that this is the rason why printk_sched() was added
> so late in 2012. It was more than 10 years after adding
> the semaphore into console_unlock(). IMHO, the deadlock
> was rare. Of course, it was also hard to debug but it
> would not take 10 years.

Right. I also think scheduler people do pretty nice work avoiding printk
calls under ->rq lock.

What I tried to say - it's really not that hard to have a non-empty
console_sem ->wait_list, any "wrong" printk() call from scheduler
will deadlock us, because we have something to wake_up().

///////////////////////////////////////////////////////////////////////
// A simple patch

---

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 6694d0019a68..c80a631f5f96 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -35,11 +35,11 @@ static inline void sema_init(struct semaphore *sem, int val)
 	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
 }
 
-extern void down(struct semaphore *sem);
+extern bool down(struct semaphore *sem);
 extern int __must_check down_interruptible(struct semaphore *sem);
 extern int __must_check down_killable(struct semaphore *sem);
 extern int __must_check down_trylock(struct semaphore *sem);
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
-extern void up(struct semaphore *sem);
+extern bool up(struct semaphore *sem);
 
 #endif /* __LINUX_SEMAPHORE_H */
diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
index d9dd94defc0a..daefcbe08147 100644
--- a/kernel/locking/semaphore.c
+++ b/kernel/locking/semaphore.c
@@ -50,16 +50,20 @@ static noinline void __up(struct semaphore *sem);
  * Use of this function is deprecated, please use down_interruptible() or
  * down_killable() instead.
  */
-void down(struct semaphore *sem)
+bool down(struct semaphore *sem)
 {
 	unsigned long flags;
+	bool ret = false;
 
 	raw_spin_lock_irqsave(&sem->lock, flags);
 	if (likely(sem->count > 0))
 		sem->count--;
-	else
+	else {
 		__down(sem);
+		ret = true;
+	}
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL(down);
 
@@ -175,16 +179,20 @@ EXPORT_SYMBOL(down_timeout);
  * Release the semaphore.  Unlike mutexes, up() may be called from any
  * context and even by tasks which have never called down().
  */
-void up(struct semaphore *sem)
+bool up(struct semaphore *sem)
 {
 	unsigned long flags;
+	bool ret = false;
 
 	raw_spin_lock_irqsave(&sem->lock, flags);
-	if (likely(list_empty(&sem->wait_list)))
+	if (likely(list_empty(&sem->wait_list))) {
 		sem->count++;
-	else
+	} else {
 		__up(sem);
+		ret = true;
+	}
 	raw_spin_unlock_irqrestore(&sem->lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL(up);
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ca65327a6de8..42ffaaa01859 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -214,12 +214,21 @@ int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
 /* Number of registered extended console drivers. */
 static int nr_ext_console_drivers;
 
+static void ____down(void)
+{
+	bool sched_out = down(&console_sem);
+	if (sched_out) {
+		pr_err("task %s couldn't lock console_sem and had to schedule out\n", current->comm);
+		dump_stack();
+	}
+}
+
 /*
  * Helper macros to handle lockdep when locking/unlocking console_sem. We use
  * macros instead of functions so that _RET_IP_ contains useful information.
  */
 #define down_console_sem() do { \
-	down(&console_sem);\
+	____down();		\
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);\
 } while (0)
 
@@ -244,15 +253,19 @@ static int __down_trylock_console_sem(unsigned long ip)
 }
 #define down_trylock_console_sem() __down_trylock_console_sem(_RET_IP_)
 
-static void __up_console_sem(unsigned long ip)
+static bool __up_console_sem(unsigned long ip)
 {
 	unsigned long flags;
+	bool ret;
 
 	mutex_release(&console_lock_dep_map, 1, ip);
 
 	printk_safe_enter_irqsave(flags);
-	up(&console_sem);
+	ret = up(&console_sem);
+	if (ret)
+		pr_err(">>> %s WOKEUP console_sem() waiter\n", current->comm);
 	printk_safe_exit_irqrestore(flags);
+	return ret;
 }
 #define up_console_sem() __up_console_sem(_RET_IP_)
 
