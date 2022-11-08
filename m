Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0276F621EE7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiKHWOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKHWOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:14:14 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CBD20988
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:14:12 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-37342ba89dbso146625677b3.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 14:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gwp7L+qQKXaqA7geIZEuwP4QfHGnl4DLTQFp6ghNvT8=;
        b=aLjQa8qfPqpvZwoTS5O6mxtwWHfK4/McRlefvIGwFcCVxaC45Wy+SJAOivIcoPknB7
         hrhoGLezDmVYA1dJ8KwFOJDTgW/tbNO9xW+kWEpd938+BVGRg8ouIl4EiBR4P4f2NyAt
         hLd6oYkaRLItw4mfDNG6F6qr5g7oqIXegTbE+XIXb3iaB5c+zpyMWbWwr2lJSoZ38Cdv
         FLFhECl1iZLWkHj0FBX8sA4Gk3eSP5mrnKBOa/55Jcw4hR50PfWvN+9qQx4pDYUef9W3
         j7cHNCycwHPHu3d5BT97S/w2+tn8OdSjQ5XaEXibNvUU8lkb0fUsk90jpAV7fgoZnAqp
         r3Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gwp7L+qQKXaqA7geIZEuwP4QfHGnl4DLTQFp6ghNvT8=;
        b=0DlgRxbcb2bYguzsRa37+TdiBjbIWQzbhTRgGLM6NYGGKFyOmjZ9NnTWm760RmioUN
         D1CA5zEx50MC5y43dKLx33WZD7/V3T2i7Iko7e+Q4XI2jfTo11rhFOLcRUmnN5JY874t
         1DA/rqFL3270yLKr8gLUUxLKcX8wYGlThLmDg2eZ7Zs5icKlwV701H4inNBvnZ7/CvJh
         2d4fX6GUvzYWPwgSI3CwjpfWn3iGQf3je+ctQ8LJJqQszf39JbxRpmGBq2Cmdlzlro1R
         fJ7y0f0V0oQitXfOHS8rj6jNAkFM1gn9m1DwMORh5abR1nb1HbaxMar1K0yL75wKUtTN
         lvNA==
X-Gm-Message-State: ACrzQf3GGjVnFx062vOJQG/nBAim3tH/qi9THWUnB/YXhy+Jk05oxEW/
        u1N2LRzoQJqbarYws6m4qB9T03NRjHo=
X-Google-Smtp-Source: AMsMyM5lZrMM39odaW022CEg0155nBEULeUYazvbQYuwJW9HmNWQ0vzydbEGgsojtBDT2wIOh4OyXjENvNw=
X-Received: from soheil4.nyc.corp.google.com ([2620:0:1003:32a:131c:366c:edb3:a050])
 (user=soheil job=sendgmr) by 2002:a25:1d43:0:b0:6ca:1935:f928 with SMTP id
 d64-20020a251d43000000b006ca1935f928mr53408703ybd.589.1667945651744; Tue, 08
 Nov 2022 14:14:11 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:14:10 -0500
In-Reply-To: <20221030220203.31210-7-axboe@kernel.dk>
Mime-Version: 1.0
References: <20221030220203.31210-1-axboe@kernel.dk> <20221030220203.31210-7-axboe@kernel.dk>
Message-ID: <Y2rUsi5yrhDZYpf/@google.com>
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
From:   Soheil Hassas Yeganeh <soheil@google.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 30, 2022 at 04:02:03PM -0600, Jens Axboe wrote:
> Rather than just have a timeout value for waiting on events, add
> EPOLL_CTL_MIN_WAIT to allow setting a minimum time that epoll_wait()
> should always wait for events to arrive.
> 
> For medium workload efficiencies, some production workloads inject
> artificial timers or sleeps before calling epoll_wait() to get
> better batching and higher efficiencies. While this does help, it's
> not as efficient as it could be. By adding support for epoll_wait()
> for this directly, we can avoids extra context switches and scheduler
> and timer overhead.
> 
> As an example, running an AB test on an identical workload at about
> ~370K reqs/second, without this change and with the sleep hack
> mentioned above (using 200 usec as the timeout), we're doing 310K-340K
> non-voluntary context switches per second. Idle CPU on the host is 27-34%.
> With the the sleep hack removed and epoll set to the same 200 usec
> value, we're handling the exact same load but at 292K-315k non-voluntary
> context switches and idle CPU of 33-41%, a substantial win.
> 
> Basic test case:
> 
> struct d {
>         int p1, p2;
> };
> 
> static void *fn(void *data)
> {
>         struct d *d = data;
>         char b = 0x89;
> 
> 	/* Generate 2 events 20 msec apart */
>         usleep(10000);
>         write(d->p1, &b, sizeof(b));
>         usleep(10000);
>         write(d->p2, &b, sizeof(b));
> 
>         return NULL;
> }
> 
> int main(int argc, char *argv[])
> {
>         struct epoll_event ev, events[2];
>         pthread_t thread;
>         int p1[2], p2[2];
>         struct d d;
>         int efd, ret;
> 
>         efd = epoll_create1(0);
>         if (efd < 0) {
>                 perror("epoll_create");
>                 return 1;
>         }
> 
>         if (pipe(p1) < 0) {
>                 perror("pipe");
>                 return 1;
>         }
>         if (pipe(p2) < 0) {
>                 perror("pipe");
>                 return 1;
>         }
> 
>         ev.events = EPOLLIN;
>         ev.data.fd = p1[0];
>         if (epoll_ctl(efd, EPOLL_CTL_ADD, p1[0], &ev) < 0) {
>                 perror("epoll add");
>                 return 1;
>         }
>         ev.events = EPOLLIN;
>         ev.data.fd = p2[0];
>         if (epoll_ctl(efd, EPOLL_CTL_ADD, p2[0], &ev) < 0) {
>                 perror("epoll add");
>                 return 1;
>         }
> 
> 	/* always wait 200 msec for events */
>         ev.data.u64 = 200000;
>         if (epoll_ctl(efd, EPOLL_CTL_MIN_WAIT, -1, &ev) < 0) {
>                 perror("epoll add set timeout");
>                 return 1;
>         }
> 
>         d.p1 = p1[1];
>         d.p2 = p2[1];
>         pthread_create(&thread, NULL, fn, &d);
> 
> 	/* expect to get 2 events here rather than just 1 */
>         ret = epoll_wait(efd, events, 2, -1);
>         printf("epoll_wait=%d\n", ret);
> 
>         return 0;
> }

It might be worth adding a note in the commit message stating that
EPOLL_CTL_MIN_WAIT is a no-op when timeout is 0. This is a desired
behavior but it's not easy to see in the flow.

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/eventpoll.c                 | 97 +++++++++++++++++++++++++++++-----
>  include/linux/eventpoll.h      |  2 +-
>  include/uapi/linux/eventpoll.h |  1 +
>  3 files changed, 85 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 962d897bbfc6..9e00f8780ec5 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -117,6 +117,9 @@ struct eppoll_entry {
>  	/* The "base" pointer is set to the container "struct epitem" */
>  	struct epitem *base;
>  
> +	/* min wait time if (min_wait_ts) & 1 != 0 */
> +	ktime_t min_wait_ts;
> +
>  	/*
>  	 * Wait queue item that will be linked to the target file wait
>  	 * queue head.
> @@ -217,6 +220,9 @@ struct eventpoll {
>  	u64 gen;
>  	struct hlist_head refs;
>  
> +	/* min wait for epoll_wait() */
> +	unsigned int min_wait_ts;
> +
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  	/* used to track busy poll napi_id */
>  	unsigned int napi_id;
> @@ -1747,6 +1753,32 @@ static struct timespec64 *ep_timeout_to_timespec(struct timespec64 *to, long ms)
>  	return to;
>  }
>  
> +struct epoll_wq {
> +	wait_queue_entry_t wait;
> +	struct hrtimer timer;
> +	ktime_t timeout_ts;
> +	ktime_t min_wait_ts;
> +	struct eventpoll *ep;
> +	bool timed_out;
> +	int maxevents;
> +	int wakeups;
> +};
> +
> +static bool ep_should_min_wait(struct epoll_wq *ewq)
> +{
> +	if (ewq->min_wait_ts & 1) {
> +		/* just an approximation */
> +		if (++ewq->wakeups >= ewq->maxevents)
> +			goto stop_wait;

Is there a way to short cut the wait if the process is being terminated?

We issues in production systems in the past where too many threads were
in epoll_wait and the process got terminated.  It'd be nice if these
threads could exit the syscall as fast as possible.

> +		if (ktime_before(ktime_get_ns(), ewq->min_wait_ts))
> +			return true;
> +	}
> +
> +stop_wait:
> +	ewq->min_wait_ts &= ~(u64) 1;
> +	return false;
> +}
> +
>  /*
>   * autoremove_wake_function, but remove even on failure to wake up, because we
>   * know that default_wake_function/ttwu will only fail if the thread is already
> @@ -1756,27 +1788,37 @@ static struct timespec64 *ep_timeout_to_timespec(struct timespec64 *to, long ms)
>  static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
>  				       unsigned int mode, int sync, void *key)
>  {
> -	int ret = default_wake_function(wq_entry, mode, sync, key);
> +	struct epoll_wq *ewq = container_of(wq_entry, struct epoll_wq, wait);
> +	int ret;
> +
> +	/*
> +	 * If min wait time hasn't been satisfied yet, keep waiting
> +	 */
> +	if (ep_should_min_wait(ewq))
> +		return 0;
>  
> +	ret = default_wake_function(wq_entry, mode, sync, key);
>  	list_del_init(&wq_entry->entry);
>  	return ret;
>  }
>  
> -struct epoll_wq {
> -	wait_queue_entry_t wait;
> -	struct hrtimer timer;
> -	ktime_t timeout_ts;
> -	bool timed_out;
> -};
> -
>  static enum hrtimer_restart ep_timer(struct hrtimer *timer)
>  {
>  	struct epoll_wq *ewq = container_of(timer, struct epoll_wq, timer);
>  	struct task_struct *task = ewq->wait.private;
> +	const bool is_min_wait = ewq->min_wait_ts & 1;
> +
> +	if (!is_min_wait || ep_events_available(ewq->ep)) {
> +		if (!is_min_wait)
> +			ewq->timed_out = true;
> +		ewq->min_wait_ts &= ~(u64) 1;
> +		wake_up_process(task);
> +		return HRTIMER_NORESTART;
> +	}
>  
> -	ewq->timed_out = true;
> -	wake_up_process(task);
> -	return HRTIMER_NORESTART;
> +	ewq->min_wait_ts &= ~(u64) 1;
> +	hrtimer_set_expires_range_ns(&ewq->timer, ewq->timeout_ts, 0);
> +	return HRTIMER_RESTART;
>  }
>  
>  static void ep_schedule(struct eventpoll *ep, struct epoll_wq *ewq, ktime_t *to,
> @@ -1831,12 +1873,16 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  
>  	lockdep_assert_irqs_enabled();
>  
> +	ewq.min_wait_ts = 0;
> +	ewq.ep = ep;
> +	ewq.maxevents = maxevents;
>  	ewq.timed_out = false;
> +	ewq.wakeups = 0;
>  
>  	if (timeout && (timeout->tv_sec | timeout->tv_nsec)) {
>  		slack = select_estimate_accuracy(timeout);
> +		ewq.timeout_ts = timespec64_to_ktime(*timeout);
>  		to = &ewq.timeout_ts;
> -		*to = timespec64_to_ktime(*timeout);
>  	} else if (timeout) {
>  		/*
>  		 * Avoid the unnecessary trip to the wait queue loop, if the
> @@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		ewq.timed_out = true;
>  	}
>  
> +	/*
> +	 * If min_wait is set for this epoll instance, note the min_wait
> +	 * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
> +	 * the state bit for whether or not min_wait is enabled.
> +	 */
> +	if (ep->min_wait_ts) {

Can we limit this block to "ewq.timed_out && ep->min_wait_ts"?
AFAICT, the code we run here is completely wasted if timeout is 0.

> +		ewq.min_wait_ts = ktime_add_us(ktime_get_ns(),
> +						ep->min_wait_ts);
> +		ewq.min_wait_ts |= (u64) 1;
> +		to = &ewq.min_wait_ts;
> +	}
> +
>  	/*
>  	 * This call is racy: We may or may not see events that are being added
>  	 * to the ready list under the lock (e.g., in IRQ callbacks). For cases
> @@ -1913,7 +1971,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		 * important.
>  		 */
>  		eavail = ep_events_available(ep);
> -		if (!eavail) {
> +		if (!eavail || ewq.min_wait_ts & 1) {
>  			__add_wait_queue_exclusive(&ep->wq, &ewq.wait);
>  			write_unlock_irq(&ep->lock);
>  			ep_schedule(ep, &ewq, to, slack);
> @@ -2125,6 +2183,17 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
>  	 */
>  	ep = f.file->private_data;
>  
> +	/*
> +	 * Handle EPOLL_CTL_MIN_WAIT upfront as we don't need to care about
> +	 * the fd being passed in.
> +	 */
> +	if (op == EPOLL_CTL_MIN_WAIT) {
> +		/* return old value */
> +		error = ep->min_wait_ts;
> +		ep->min_wait_ts = epds->data;
> +		goto error_fput;
> +	}
> +
>  	/* Get the "struct file *" for the target file */
>  	tf = fdget(fd);
>  	if (!tf.file)
> @@ -2257,7 +2326,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  {
>  	struct epoll_event epds;
>  
> -	if (ep_op_has_event(op) &&
> +	if ((ep_op_has_event(op) || op == EPOLL_CTL_MIN_WAIT) &&
>  	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
>  		return -EFAULT;
>  
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 3337745d81bd..cbef635cb7e4 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -59,7 +59,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
>  /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
>  static inline int ep_op_has_event(int op)
>  {
> -	return op != EPOLL_CTL_DEL;
> +	return op != EPOLL_CTL_DEL && op != EPOLL_CTL_MIN_WAIT;
>  }
>  
>  #else
> diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
> index 8a3432d0f0dc..81ecb1ca36e0 100644
> --- a/include/uapi/linux/eventpoll.h
> +++ b/include/uapi/linux/eventpoll.h
> @@ -26,6 +26,7 @@
>  #define EPOLL_CTL_ADD 1
>  #define EPOLL_CTL_DEL 2
>  #define EPOLL_CTL_MOD 3
> +#define EPOLL_CTL_MIN_WAIT	4

Have you considered introducing another epoll_pwait sycall variant?

That has a major benefit that min wait can be different per poller,
on the different epollfd.  The usage would also be more readable:

"epoll for X amount of time but don't return sooner than Y."

This would be similar to the approach that willemb@google.com used
when introducing epoll_pwait2.

>  
>  /* Epoll event masks */
>  #define EPOLLIN		(__force __poll_t)0x00000001
> -- 
> 2.35.1
> 
