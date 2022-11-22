Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738A76342D7
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiKVRpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbiKVRpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:45:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7198A781B1;
        Tue, 22 Nov 2022 09:44:57 -0800 (PST)
Message-ID: <20221122173648.501792201@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669139096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=ZX6HSxA/fzywS26fdVBXIAqlyqEavuJZwMJ+1GlZUJE=;
        b=Uq4N/5Kq2rTIh2JXEZXuPxfOVWS0gFxZtIFLQc1pSPfWuTvNNfJy/Dzq0QImJxGBfq3fE0
        Hp33OrEiK7oR/iq2UpBNbmnrMG+CbxXTXhMR+MILa5NCR01AM6FinflhMsLZbVqz+jPN7N
        yFVY/emNB3uUOawQJkWUCd309mv4+aZSPPkEth6ImxrVW+xRnqFZevwIccbdfrv344grqR
        Pe1cyBe3BQ0vjiRFOnm0e/V7/Ca9jt/4PiBZ6uTKCq3CGruqXVcaEv/+CQ8NdAOWhmk3sL
        3SLgNEp52MlPuIHolCVLCvGkDCFB9pbm8aJ4IqOU/nFttAHoSFJLByEbA1ihxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669139096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=ZX6HSxA/fzywS26fdVBXIAqlyqEavuJZwMJ+1GlZUJE=;
        b=WLEMe+0gph+V95PFjvurR1K3iNHD9ctXojNI4KVxnvllVDftjqDzYWtAaGM5k4yl6EXTC5
        0KC6PcZutiuYevDw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [patch V2 07/17] timers: Update kernel-doc for various functions
References: <20221122171312.191765396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 22 Nov 2022 18:44:55 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel-doc of timer related functions is partially uncomprehensible
word salad. Rewrite it to make it useful.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
V2: Refined comments (Steven)
---
 kernel/time/timer.c |  148 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 88 insertions(+), 60 deletions(-)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1121,14 +1121,16 @@ static inline int
 }
 
 /**
- * mod_timer_pending - modify a pending timer's timeout
- * @timer: the pending timer to be modified
- * @expires: new timeout in jiffies
- *
- * mod_timer_pending() is the same for pending timers as mod_timer(),
- * but will not re-activate and modify already deleted timers.
- *
- * It is useful for unserialized use of timers.
+ * mod_timer_pending - Modify a pending timer's timeout
+ * @timer:	The pending timer to be modified
+ * @expires:	New absolute timeout in jiffies
+ *
+ * mod_timer_pending() is the same for pending timers as mod_timer(), but
+ * will not activate inactive timers.
+ *
+ * Return:
+ * * %0 - The timer was inactive and not modified
+ * * %1 - The timer was active and requeued to expire at @expires
  */
 int mod_timer_pending(struct timer_list *timer, unsigned long expires)
 {
@@ -1137,24 +1139,27 @@ int mod_timer_pending(struct timer_list
 EXPORT_SYMBOL(mod_timer_pending);
 
 /**
- * mod_timer - modify a timer's timeout
- * @timer: the timer to be modified
- * @expires: new timeout in jiffies
- *
- * mod_timer() is a more efficient way to update the expire field of an
- * active timer (if the timer is inactive it will be activated)
+ * mod_timer - Modify a timer's timeout
+ * @timer:	The timer to be modified
+ * @expires:	New absolute timeout in jiffies
  *
  * mod_timer(timer, expires) is equivalent to:
  *
  *     del_timer(timer); timer->expires = expires; add_timer(timer);
  *
+ * mod_timer() is more efficient than the above open coded sequence. In
+ * case that the timer is inactive, the del_timer() part is a NOP. The
+ * timer is in any case activated with the new expiry time @expires.
+ *
  * Note that if there are multiple unserialized concurrent users of the
  * same timer, then mod_timer() is the only safe way to modify the timeout,
  * since add_timer() cannot modify an already running timer.
  *
- * The function returns whether it has modified a pending timer or not.
- * (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
- * active timer returns 1.)
+ * Return:
+ * * %0 - The timer was inactive and started
+ * * %1 - The timer was active and requeued to expire at @expires or
+ *	  the timer was active and not modified because @expires did
+ *	  not change the effective expiry time
  */
 int mod_timer(struct timer_list *timer, unsigned long expires)
 {
@@ -1165,11 +1170,18 @@ EXPORT_SYMBOL(mod_timer);
 /**
  * timer_reduce - Modify a timer's timeout if it would reduce the timeout
  * @timer:	The timer to be modified
- * @expires:	New timeout in jiffies
+ * @expires:	New absolute timeout in jiffies
  *
  * timer_reduce() is very similar to mod_timer(), except that it will only
- * modify a running timer if that would reduce the expiration time (it will
- * start a timer that isn't running).
+ * modify an enqueued timer if that would reduce the expiration time. If
+ * @timer is not enqueued it starts the timer.
+ *
+ * Return:
+ * * %0 - The timer was inactive and started
+ * * %1 - The timer was active and requeued to expire at @expires or
+ *	  the timer was active and not modified because @expires
+ *	  did not change the effective expiry time such that the
+ *	  timer would expire earlier than already scheduled
  */
 int timer_reduce(struct timer_list *timer, unsigned long expires)
 {
@@ -1178,18 +1190,18 @@ int timer_reduce(struct timer_list *time
 EXPORT_SYMBOL(timer_reduce);
 
 /**
- * add_timer - start a timer
- * @timer: the timer to be added
+ * add_timer - Start a timer
+ * @timer:	The timer to be started
  *
- * The kernel will do a ->function(@timer) callback from the
- * timer interrupt at the ->expires point in the future. The
- * current time is 'jiffies'.
+ * Start @timer to expire at @timer->expires in the future. @timer->expires
+ * is the absolute expiry time measured in 'jiffies'. When the timer expires
+ * timer->function(timer) will be invoked from soft interrupt context.
  *
- * The timer's ->expires, ->function fields must be set prior calling this
- * function.
+ * The @timer->expires and @timer->function fields must be set prior
+ * to calling this function.
  *
- * Timers with an ->expires field in the past will be executed in the next
- * timer tick.
+ * If @timer->expires is already in the past @timer will be queued to
+ * expire at the next timer tick.
  */
 void add_timer(struct timer_list *timer)
 {
@@ -1200,11 +1212,12 @@ void add_timer(struct timer_list *timer)
 EXPORT_SYMBOL(add_timer);
 
 /**
- * add_timer_on - start a timer on a particular CPU
- * @timer: the timer to be added
- * @cpu: the CPU to start it on
+ * add_timer_on - Start a timer on a particular CPU
+ * @timer:	The timer to be started
+ * @cpu:	The CPU to start it on
  *
- * This is not very scalable on SMP. Double adds are not possible.
+ * This can only operate on an inactive timer. Attempts to invoke this on
+ * an active timer are rejected with a warning.
  */
 void add_timer_on(struct timer_list *timer, int cpu)
 {
@@ -1240,15 +1253,18 @@ void add_timer_on(struct timer_list *tim
 EXPORT_SYMBOL_GPL(add_timer_on);
 
 /**
- * del_timer - deactivate a timer.
- * @timer: the timer to be deactivated
- *
- * del_timer() deactivates a timer - this works on both active and inactive
- * timers.
+ * del_timer - Deactivate a timer.
+ * @timer:	The timer to be deactivated
  *
- * The function returns whether it has deactivated a pending timer or not.
- * (ie. del_timer() of an inactive timer returns 0, del_timer() of an
- * active timer returns 1.)
+ * The function only deactivates a pending timer, but contrary to
+ * del_timer_sync() it does not take into account whether the timers
+ * callback function is concurrently executed on a different CPU or not.
+ * It neither prevents rearming of the timer.  If @timer can be rearmed
+ * concurrently then the return value of this function is meaningless.
+ *
+ * Return:
+ * * %0 - The timer was not pending
+ * * %1 - The timer was pending and deactivated
  */
 int del_timer(struct timer_list *timer)
 {
@@ -1270,10 +1286,19 @@ EXPORT_SYMBOL(del_timer);
 
 /**
  * try_to_del_timer_sync - Try to deactivate a timer
- * @timer: timer to delete
+ * @timer:	Timer to deactivate
  *
- * This function tries to deactivate a timer. Upon successful (ret >= 0)
- * exit the timer is not queued and the handler is not running on any CPU.
+ * This function tries to deactivate a timer. On success the timer is not
+ * queued and the timer callback function is not running on any CPU.
+ *
+ * This function does not guarantee that the timer cannot be rearmed right
+ * after dropping the base lock. That needs to be prevented by the calling
+ * code if necessary.
+ *
+ * Return:
+ * * %0  - The timer was not pending
+ * * %1  - The timer was pending and deactivated
+ * * %-1 - The timer callback function is running on a different CPU
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
@@ -1369,23 +1394,19 @@ static inline void del_timer_wait_runnin
 
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
- * del_timer_sync - deactivate a timer and wait for the handler to finish.
- * @timer: the timer to be deactivated
- *
- * This function only differs from del_timer() on SMP: besides deactivating
- * the timer it also makes sure the handler has finished executing on other
- * CPUs.
+ * del_timer_sync - Deactivate a timer and wait for the handler to finish.
+ * @timer:	The timer to be deactivated
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
  * interrupt contexts unless the timer is an irqsafe one. The caller must
- * not hold locks which would prevent completion of the timer's
- * handler. The timer's handler must not call add_timer_on(). Upon exit the
- * timer is not queued and the handler is not running on any CPU.
- *
- * Note: For !irqsafe timers, you must not hold locks that are held in
- *   interrupt context while calling this function. Even if the lock has
- *   nothing to do with the timer in question.  Here's why::
+ * not hold locks which would prevent completion of the timer's callback
+ * function. The timer's handler must not call add_timer_on(). Upon exit
+ * the timer is not queued and the handler is not running on any CPU.
+ *
+ * For !irqsafe timers, the caller must not hold locks that are held in
+ * interrupt context. Even if the lock has nothing to do with the timer in
+ * question.  Here's why::
  *
  *    CPU0                             CPU1
  *    ----                             ----
@@ -1399,10 +1420,17 @@ static inline void del_timer_wait_runnin
  *    while (base->running_timer == mytimer);
  *
  * Now del_timer_sync() will never return and never release somelock.
- * The interrupt on the other CPU is waiting to grab somelock but
- * it has interrupted the softirq that CPU0 is waiting to finish.
+ * The interrupt on the other CPU is waiting to grab somelock but it has
+ * interrupted the softirq that CPU0 is waiting to finish.
  *
- * The function returns whether it has deactivated a pending timer or not.
+ * This function cannot guarantee that the timer is not rearmed again by
+ * some concurrent or preempting code, right after it dropped the base
+ * lock. If there is the possibility of a concurrent rearm then the return
+ * value of the function is meaningless.
+ *
+ * Return:
+ * * %0	- The timer was not pending
+ * * %1	- The timer was pending and deactivated
  */
 int del_timer_sync(struct timer_list *timer)
 {

