Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F31A632E1F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiKUUoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKUUoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:44:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2FCB978;
        Mon, 21 Nov 2022 12:44:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9E4961471;
        Mon, 21 Nov 2022 20:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF58C433C1;
        Mon, 21 Nov 2022 20:43:59 +0000 (UTC)
Date:   Mon, 21 Nov 2022 15:43:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [patch 06/15] timers: Update kernel-doc for various functions
Message-ID: <20221121154358.36856ca6@gandalf.local.home>
In-Reply-To: <20221115202117.323694948@linutronix.de>
References: <20221115195802.415956561@linutronix.de>
        <20221115202117.323694948@linutronix.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 21:28:43 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> The kernel-doc of timer related functions is partially uncomprehensible
> word salad. Rewrite it to make it useful.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/timer.c |  131 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 77 insertions(+), 54 deletions(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1121,14 +1121,16 @@ static inline int
>  }
>  
>  /**
> - * mod_timer_pending - modify a pending timer's timeout
> - * @timer: the pending timer to be modified
> - * @expires: new timeout in jiffies
> + * mod_timer_pending - Modify a pending timer's timeout
> + * @timer:	The pending timer to be modified
> + * @expires:	New timeout in jiffies
>   *
> - * mod_timer_pending() is the same for pending timers as mod_timer(),
> - * but will not re-activate and modify already deleted timers.
> + * mod_timer_pending() is the same for pending timers as mod_timer(), but
> + * will not activate inactive timers.
>   *
> - * It is useful for unserialized use of timers.
> + * Return:
> + * * %0 - The timer was inactive and not modified
> + * * %1 - The timer was active and requeued to expire at @expires

I didn't know of the '%' option in kernel-doc.

Looking it up, I see it's for constants. Although it's missing in the
examples for return values:

  Documentation/doc-guide/kernel-doc.rst:

```
Return values
~~~~~~~~~~~~~

The return value, if any, should be described in a dedicated section
named ``Return``.

.. note::

  #) The multi-line descriptive text you provide does *not* recognize
     line breaks, so if you try to format some text nicely, as in::

        * Return:
        * 0 - OK
        * -EINVAL - invalid argument
        * -ENOMEM - out of memory

     this will all run together and produce::

        Return: 0 - OK -EINVAL - invalid argument -ENOMEM - out of memory

     So, in order to produce the desired line breaks, you need to use a
     ReST list, e. g.::

      * Return:
      * * 0             - OK to runtime suspend the device
      * * -EBUSY        - Device should not be runtime suspended
```

Should this be updated?


>   */
>  int mod_timer_pending(struct timer_list *timer, unsigned long expires)
>  {
> @@ -1137,9 +1139,9 @@ int mod_timer_pending(struct timer_list
>  EXPORT_SYMBOL(mod_timer_pending);
>  
>  /**
> - * mod_timer - modify a timer's timeout
> - * @timer: the timer to be modified
> - * @expires: new timeout in jiffies
> + * mod_timer - Modify a timer's timeout
> + * @timer:	The timer to be modified
> + * @expires:	New timeout in jiffies
>   *
>   * mod_timer() is a more efficient way to update the expire field of an

BTW, one can ask, "more efficient" than what?

If you are updating this, perhaps swap it around a little.

 * mod_timer(timer, expires) is equivalent to:
 *
 *     del_timer(timer); timer->expires = expires; add_timer(timer);
 *
 * mod_timer() is a more efficient way to update the expire field of an
 * active timer (if the timer is inactive it will be activated)
 *

As seeing the equivalent first and then seeing "more efficient" makes a bit
more sense.

>   * active timer (if the timer is inactive it will be activated)
> @@ -1152,9 +1154,11 @@ EXPORT_SYMBOL(mod_timer_pending);
>   * same timer, then mod_timer() is the only safe way to modify the timeout,
>   * since add_timer() cannot modify an already running timer.
>   *
> - * The function returns whether it has modified a pending timer or not.
> - * (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
> - * active timer returns 1.)
> + * Return:
> + * * %0 - The timer was inactive and started
> + * * %1 - The timer was active and requeued to expire at @expires or
> + *	  the timer was active and not modified because @expires did
> + *	  not change the effective expiry time
>   */
>  int mod_timer(struct timer_list *timer, unsigned long expires)
>  {
> @@ -1168,8 +1172,15 @@ EXPORT_SYMBOL(mod_timer);
>   * @expires:	New timeout in jiffies
>   *
>   * timer_reduce() is very similar to mod_timer(), except that it will only
> - * modify a running timer if that would reduce the expiration time (it will
> - * start a timer that isn't running).
> + * modify an enqueued timer if that would reduce the expiration time. If
> + * @timer is not enqueued it starts the timer.
> + *
> + * Return:
> + * * %0 - The timer was inactive and started
> + * * %1 - The timer was active and requeued to expire at @expires or
> + *	  the timer was active and not modified because @expires
> + *	  did not change the effective expiry time such that the
> + *	  timer would expire earlier than already scheduled
>   */
>  int timer_reduce(struct timer_list *timer, unsigned long expires)
>  {
> @@ -1178,18 +1189,18 @@ int timer_reduce(struct timer_list *time
>  EXPORT_SYMBOL(timer_reduce);
>  
>  /**
> - * add_timer - start a timer
> - * @timer: the timer to be added
> + * add_timer - Start a timer
> + * @timer:	The timer to be started
>   *
> - * The kernel will do a ->function(@timer) callback from the
> - * timer interrupt at the ->expires point in the future. The
> - * current time is 'jiffies'.
> + * Start @timer to expire at @timer->expires in the future. @timer->expires
> + * is the absolute expiry time measured in 'jiffies'. When the timer expires
> + * timer->function(timer) will be invoked from soft interrupt context.
>   *
> - * The timer's ->expires, ->function fields must be set prior calling this
> - * function.
> + * The @timer->expires and @timer->function fields must be set prior
> + * calling this function.

 "set prior to calling this function"

>   *
> - * Timers with an ->expires field in the past will be executed in the next
> - * timer tick.
> + * If @timer->expires is already in the past @timer will be queued to
> + * expire at the next timer tick.
>   */
>  void add_timer(struct timer_list *timer)
>  {
> @@ -1200,11 +1211,12 @@ void add_timer(struct timer_list *timer)
>  EXPORT_SYMBOL(add_timer);
>  
>  /**
> - * add_timer_on - start a timer on a particular CPU
> - * @timer: the timer to be added
> - * @cpu: the CPU to start it on
> + * add_timer_on - Start a timer on a particular CPU
> + * @timer:	The timer to be started
> + * @cpu:	The CPU to start it on
>   *
> - * This is not very scalable on SMP. Double adds are not possible.
> + * This can only operate on an inactive timer. Attempts to invoke this on
> + * an active timer are rejected with a warning.
>   */
>  void add_timer_on(struct timer_list *timer, int cpu)
>  {
> @@ -1240,15 +1252,17 @@ void add_timer_on(struct timer_list *tim
>  EXPORT_SYMBOL_GPL(add_timer_on);
>  
>  /**
> - * del_timer - deactivate a timer.
> - * @timer: the timer to be deactivated
> - *
> - * del_timer() deactivates a timer - this works on both active and inactive
> - * timers.
> + * del_timer - Deactivate a timer.
> + * @timer:	The timer to be deactivated
>   *
> - * The function returns whether it has deactivated a pending timer or not.
> - * (ie. del_timer() of an inactive timer returns 0, del_timer() of an
> - * active timer returns 1.)
> + * Contrary to del_timer_sync() this function does not wait for an
> + * eventually running timer callback on a different CPU and it neither

I'm a little confused with the "eventually running timer". Does that simply
mean one that is about to run next (that is, it doesn't handle race
conditions and the timer is in the process of starting), but will still
deactivate one that has not been started and the timer code for that CPU
hasn't triggered yet?

> + * prevents rearming of the timer.  If @timer can be rearmed concurrently
> + * then the return value of this function is meaningless.
> + *
> + * Return:
> + * * %0 - The timer was not pending
> + * * %1 - The timer was pending and deactivated
>   */
>  int del_timer(struct timer_list *timer)
>  {
> @@ -1270,10 +1284,16 @@ EXPORT_SYMBOL(del_timer);
>  
>  /**
>   * try_to_del_timer_sync - Try to deactivate a timer
> - * @timer: timer to delete
> + * @timer:	Timer to deactivate
>   *
> - * This function tries to deactivate a timer. Upon successful (ret >= 0)
> - * exit the timer is not queued and the handler is not running on any CPU.
> + * This function cannot guarantee that the timer cannot be rearmed right
> + * after dropping the base lock. That needs to be prevented by the calling
> + * code if necessary.


Hmm, you seemed to have deleted the description of what the function does
and replaced it with only what it cannot do.

The rest looks good.

-- Steve

> + *
> + * Return:
> + * * %0  - The timer was not pending
> + * * %1  - The timer was pending and deactivated
> + * * %-1 - The timer callback function is running on a different CPU
>   */
>  int try_to_del_timer_sync(struct timer_list *timer)
>  {
> @@ -1369,23 +1389,19 @@ static inline void del_timer_wait_runnin
>  
>  #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
>  /**
> - * del_timer_sync - deactivate a timer and wait for the handler to finish.
> - * @timer: the timer to be deactivated
> - *
> - * This function only differs from del_timer() on SMP: besides deactivating
> - * the timer it also makes sure the handler has finished executing on other
> - * CPUs.
> + * del_timer_sync - Deactivate a timer and wait for the handler to finish.
> + * @timer:	The timer to be deactivated
>   *
>   * Synchronization rules: Callers must prevent restarting of the timer,
>   * otherwise this function is meaningless. It must not be called from
>   * interrupt contexts unless the timer is an irqsafe one. The caller must
> - * not hold locks which would prevent completion of the timer's
> - * handler. The timer's handler must not call add_timer_on(). Upon exit the
> - * timer is not queued and the handler is not running on any CPU.
> - *
> - * Note: For !irqsafe timers, you must not hold locks that are held in
> - *   interrupt context while calling this function. Even if the lock has
> - *   nothing to do with the timer in question.  Here's why::
> + * not hold locks which would prevent completion of the timer's callback
> + * function. The timer's handler must not call add_timer_on(). Upon exit
> + * the timer is not queued and the handler is not running on any CPU.
> + *
> + * For !irqsafe timers, the caller must not hold locks that are held in
> + * interrupt context. Even if the lock has nothing to do with the timer in
> + * question.  Here's why::
>   *
>   *    CPU0                             CPU1
>   *    ----                             ----
> @@ -1399,10 +1415,17 @@ static inline void del_timer_wait_runnin
>   *    while (base->running_timer == mytimer);
>   *
>   * Now del_timer_sync() will never return and never release somelock.
> - * The interrupt on the other CPU is waiting to grab somelock but
> - * it has interrupted the softirq that CPU0 is waiting to finish.
> + * The interrupt on the other CPU is waiting to grab somelock but it has
> + * interrupted the softirq that CPU0 is waiting to finish.
>   *
> - * The function returns whether it has deactivated a pending timer or not.
> + * This function cannot guarantee that the timer is not rearmed again by
> + * some concurrent or preempting code, right after it dropped the base
> + * lock. If there is the possibility of a concurrent rearm then the return
> + * value of the function is meaningless.
> + *
> + * Return:
> + * * %0	- The timer was not pending
> + * * %1	- The timer was pending and deactivated
>   */
>  int del_timer_sync(struct timer_list *timer)
>  {

