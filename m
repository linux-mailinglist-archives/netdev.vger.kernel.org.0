Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E906621F1F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKHWWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKHWVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:21:54 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6369D657E6
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:30 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z26so15037489pff.1
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 14:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MaBBcyVxoSCVclLlGwqZ4IB4E++rGyLP3/v5/h3m1YM=;
        b=yN3Fg8FaHbcuj6QYaUmOjYQ5ORJJmor3qnhqtmEcP0OyrAhuRbbVMVWjiB7mB3Zzxr
         VlScbrOSL6FLWQfRh33W3fTZfcYVclsl+3sBOp0fieuetVlc2eBXxSdT8DG8Yk70s+1u
         K3bXUvlJiVHUJR3Soqmi4oDKE+/JYwIjC/sC6SCluSLbTPWSiv8e733ums8NcTIjnRrS
         MdQxaYKr2YL2rhGyc/+8vZ81gpeZ60X6p/Tv/4ihPrYbQY5QT4TDoRil3DY+VH1trhJa
         VOF3ge/khNQuTdfUY8qigWsBsRpnCiO21pzL22AAnwvEI4eQjMEAeqRcywNDsJ5FF20F
         eekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MaBBcyVxoSCVclLlGwqZ4IB4E++rGyLP3/v5/h3m1YM=;
        b=VGj84jH2e9SKXWP3h8N3c0iYC4CMB4JhFFAwKYtpAI3CphkanGhLz4MBkYVgrwn09i
         zkJAmnfHGni9PFTolGp7QQAnuIcrsg5O9O5v6JkVfqUyqKC0Z/Ay877KiWMsI8uD+ssK
         QJKHdJqJLqR2VWYGHBvvnwXr4nTypcrq6ScI3B425BihlewMLtpnY+xrLuvZAxXEq52L
         sj7uj9L8M0/zBz6zb92WVbJakdwjEbjRpN3nV47Mru8aN2k+I19w9S4a5cAh4lJeY6mx
         4aD168svfB1mbDe8Fp+L2DVc0ykE5E7h8o4XTeAOf87NUXdjSDGpausoAZkTPtMODDy8
         SzeQ==
X-Gm-Message-State: ACrzQf2GZOemaVvsQUV59vsurnMt950EEPC4M8Usy1wzcQnLZ3ZVQmp4
        3PpmKxLi2jnOtxta1jWoDxXKUw==
X-Google-Smtp-Source: AMsMyM5EM8DqCXhZYw53QLV2+8E1GfMMBw+mTknPYza4oGQ1CVXbgdSj70FIEdHBMDe3j4evmQPw7A==
X-Received: by 2002:a63:ce43:0:b0:45b:d6ed:6c2 with SMTP id r3-20020a63ce43000000b0045bd6ed06c2mr49234564pgi.406.1667946029769;
        Tue, 08 Nov 2022 14:20:29 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t4-20020a1709027fc400b0016d5b7fb02esm7415142plb.60.2022.11.08.14.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 14:20:29 -0800 (PST)
Message-ID: <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
Date:   Tue, 8 Nov 2022 15:20:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
To:     Soheil Hassas Yeganeh <soheil@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Shakeel Butt <shakeelb@google.com>
References: <20221030220203.31210-1-axboe@kernel.dk>
 <20221030220203.31210-7-axboe@kernel.dk> <Y2rUsi5yrhDZYpf/@google.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y2rUsi5yrhDZYpf/@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/22 3:14 PM, Soheil Hassas Yeganeh wrote:
> On Sun, Oct 30, 2022 at 04:02:03PM -0600, Jens Axboe wrote:
>> Rather than just have a timeout value for waiting on events, add
>> EPOLL_CTL_MIN_WAIT to allow setting a minimum time that epoll_wait()
>> should always wait for events to arrive.
>>
>> For medium workload efficiencies, some production workloads inject
>> artificial timers or sleeps before calling epoll_wait() to get
>> better batching and higher efficiencies. While this does help, it's
>> not as efficient as it could be. By adding support for epoll_wait()
>> for this directly, we can avoids extra context switches and scheduler
>> and timer overhead.
>>
>> As an example, running an AB test on an identical workload at about
>> ~370K reqs/second, without this change and with the sleep hack
>> mentioned above (using 200 usec as the timeout), we're doing 310K-340K
>> non-voluntary context switches per second. Idle CPU on the host is 27-34%.
>> With the the sleep hack removed and epoll set to the same 200 usec
>> value, we're handling the exact same load but at 292K-315k non-voluntary
>> context switches and idle CPU of 33-41%, a substantial win.
>>
>> Basic test case:
>>
>> struct d {
>>         int p1, p2;
>> };
>>
>> static void *fn(void *data)
>> {
>>         struct d *d = data;
>>         char b = 0x89;
>>
>> 	/* Generate 2 events 20 msec apart */
>>         usleep(10000);
>>         write(d->p1, &b, sizeof(b));
>>         usleep(10000);
>>         write(d->p2, &b, sizeof(b));
>>
>>         return NULL;
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>         struct epoll_event ev, events[2];
>>         pthread_t thread;
>>         int p1[2], p2[2];
>>         struct d d;
>>         int efd, ret;
>>
>>         efd = epoll_create1(0);
>>         if (efd < 0) {
>>                 perror("epoll_create");
>>                 return 1;
>>         }
>>
>>         if (pipe(p1) < 0) {
>>                 perror("pipe");
>>                 return 1;
>>         }
>>         if (pipe(p2) < 0) {
>>                 perror("pipe");
>>                 return 1;
>>         }
>>
>>         ev.events = EPOLLIN;
>>         ev.data.fd = p1[0];
>>         if (epoll_ctl(efd, EPOLL_CTL_ADD, p1[0], &ev) < 0) {
>>                 perror("epoll add");
>>                 return 1;
>>         }
>>         ev.events = EPOLLIN;
>>         ev.data.fd = p2[0];
>>         if (epoll_ctl(efd, EPOLL_CTL_ADD, p2[0], &ev) < 0) {
>>                 perror("epoll add");
>>                 return 1;
>>         }
>>
>> 	/* always wait 200 msec for events */
>>         ev.data.u64 = 200000;
>>         if (epoll_ctl(efd, EPOLL_CTL_MIN_WAIT, -1, &ev) < 0) {
>>                 perror("epoll add set timeout");
>>                 return 1;
>>         }
>>
>>         d.p1 = p1[1];
>>         d.p2 = p2[1];
>>         pthread_create(&thread, NULL, fn, &d);
>>
>> 	/* expect to get 2 events here rather than just 1 */
>>         ret = epoll_wait(efd, events, 2, -1);
>>         printf("epoll_wait=%d\n", ret);
>>
>>         return 0;
>> }
> 
> It might be worth adding a note in the commit message stating that
> EPOLL_CTL_MIN_WAIT is a no-op when timeout is 0. This is a desired
> behavior but it's not easy to see in the flow.

True, will do.

>> +struct epoll_wq {
>> +	wait_queue_entry_t wait;
>> +	struct hrtimer timer;
>> +	ktime_t timeout_ts;
>> +	ktime_t min_wait_ts;
>> +	struct eventpoll *ep;
>> +	bool timed_out;
>> +	int maxevents;
>> +	int wakeups;
>> +};
>> +
>> +static bool ep_should_min_wait(struct epoll_wq *ewq)
>> +{
>> +	if (ewq->min_wait_ts & 1) {
>> +		/* just an approximation */
>> +		if (++ewq->wakeups >= ewq->maxevents)
>> +			goto stop_wait;
> 
> Is there a way to short cut the wait if the process is being terminated?
> 
> We issues in production systems in the past where too many threads were
> in epoll_wait and the process got terminated.  It'd be nice if these
> threads could exit the syscall as fast as possible.

Good point, it'd be a bit racy though as this is called from the waitq
callback and hence not in the task itself. But probably Good Enough for
most use cases?

This should probably be a separate patch though, as it seems this
affects regular waits too without min_wait set?

>> @@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>  		ewq.timed_out = true;
>>  	}
>>  
>> +	/*
>> +	 * If min_wait is set for this epoll instance, note the min_wait
>> +	 * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
>> +	 * the state bit for whether or not min_wait is enabled.
>> +	 */
>> +	if (ep->min_wait_ts) {
> 
> Can we limit this block to "ewq.timed_out && ep->min_wait_ts"?
> AFAICT, the code we run here is completely wasted if timeout is 0.

Yep certainly, I can gate it on both of those conditions.

>> diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
>> index 8a3432d0f0dc..81ecb1ca36e0 100644
>> --- a/include/uapi/linux/eventpoll.h
>> +++ b/include/uapi/linux/eventpoll.h
>> @@ -26,6 +26,7 @@
>>  #define EPOLL_CTL_ADD 1
>>  #define EPOLL_CTL_DEL 2
>>  #define EPOLL_CTL_MOD 3
>> +#define EPOLL_CTL_MIN_WAIT	4
> 
> Have you considered introducing another epoll_pwait sycall variant?
> 
> That has a major benefit that min wait can be different per poller,
> on the different epollfd.  The usage would also be more readable:
> 
> "epoll for X amount of time but don't return sooner than Y."
> 
> This would be similar to the approach that willemb@google.com used
> when introducing epoll_pwait2.

I have, see other replies in this thread, notably the ones with Stefan
today. Happy to do that, and my current branch does split out the ctl
addition from the meat of the min_wait support for this reason. Can't
seem to find a great way to do it, as we'd need to move to a struct
argument for this as epoll_pwait2() is already at max arguments for a
syscall. Suggestions more than welcome.

-- 
Jens Axboe
