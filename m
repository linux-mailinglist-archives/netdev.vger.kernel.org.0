Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC23D6491B4
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 02:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLKB6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 20:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKB6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 20:58:44 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D008B12750
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 17:58:40 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so12080256pjp.1
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 17:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=92otOsPRb8R49SKL6WOSYt3u7Gy+ETQg9H5sFcSGe+M=;
        b=Vxwc/uOSFFH0NQ7uYkDkBiVNSCF3OM+JBzLa2m3SS3LRzMcuOFqH7R4VnX3G+sspFM
         eRCKtgR8iHmOCdnfmziyLS7/VTri+JChxEzFVEKru4F/SjJ/IeUgOY7+W8lnDspBrOzt
         5jCB4tt2ZngS3USDTMZ40FadlV52KztBuECx8H4jznVmXForYG4i8RIrTZrl4AKHuudr
         sFcUBgs1SOcPxNol7NVjMi8QbZg0xj/cOD2REDPaKkzU/1IhuI6t6cyaGVRmmEI8t/hf
         S91NfCjhw2G8j8Hl82x91y9p3KpgwDrKwkP5z5In+EGPgCvVrrFo/pibh7UcMeZtTOKc
         f2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92otOsPRb8R49SKL6WOSYt3u7Gy+ETQg9H5sFcSGe+M=;
        b=KOs1/BIuweQmyHu+9IvjEpqSxurM+ceqKkz2RyhwcYdhoCJkZcK9nqELvCDmo7SQY8
         COhjfzKWTkL4tjqehPo1lZjdLwktAuE7gy/txwwepjhXYMxFFFHJ/4e9cKAm6K/XK3Jx
         Pf2A6aHmXGIuF1H+CjhfsywA2FCS3HL6sXeLLtxkcTuDRMndXnpUQLZQqq83sgVCIOS7
         78+9pp4soJ7293Mlnm/73b7JOgbYbb+13P4hVZ7AXBA5uVC8diwQbmtt//O3qfbcxFZt
         wQVHJZZV+m0hG7CCXaSgnKH7kef+KI/FoF6P8cZkNi/sH+3Hc335KoWbgxfDVaX7UaFB
         /Mlg==
X-Gm-Message-State: ANoB5plds2qVqzCMw3ngSq2XhN9/F0/bv0QPpQh5P9fhJInVnVBmDaQZ
        gMsDkGQDLRRqn+F7IBEPBqoCdlugX1uBLpqYnIw=
X-Google-Smtp-Source: AA0mqf714/mikg0kgY/2ePdefIrrOj8lZuvE8KQMbd/8zqTSpWqicmhh3lXa3N0P9ZpO0Q4cRl4D7Q==
X-Received: by 2002:a17:90a:5509:b0:218:70b4:b25d with SMTP id b9-20020a17090a550900b0021870b4b25dmr2591229pji.2.1670723920182;
        Sat, 10 Dec 2022 17:58:40 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x8-20020a17090a294800b00219463262desm3017713pjf.39.2022.12.10.17.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 17:58:39 -0800 (PST)
Message-ID: <26c376ac-7239-66fe-9c7e-ec99dfb880cd@kernel.dk>
Date:   Sat, 10 Dec 2022 18:58:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [GIT PULL] Add support for epoll min wait time
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
 <CAHk-=whgzBzTR5t6Dc6gZ_XS1q=UrqeiBf62op_fahbwns+xvQ@mail.gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=whgzBzTR5t6Dc6gZ_XS1q=UrqeiBf62op_fahbwns+xvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/22 11:51?AM, Linus Torvalds wrote:
> On Sat, Dec 10, 2022 at 7:36 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This adds an epoll_ctl method for setting the minimum wait time for
>> retrieving events.
> 
> So this is something very close to what the TTY layer has had forever,
> and is useful (well... *was* useful) for pretty much the same reason.
> 
> However, let's learn from successful past interfaces: the tty layer
> doesn't have just VTIME, it has VMIN too.
> 
> And I think they very much go hand in hand: you want for at least VMIN
> events or for at most VTIME after the last event.

It has been suggested before too. A more modern example is how IRQ
coalescing works on eg nvme or nics. Those generally are of the nature
of "wait for X time, or until Y events are available". We can certainly
do something like that here too, it's just adding a minevents and
passing them in together.

I'll add that, really should be trivial, and resend later in the merge
window once we're happy with that.

> Yes, yes, you have that 'maxevents' thing, but that's not at all the
> same as VMIN. That's just the buffer size.

Right, the fact that maxevents is all we have means it's not very useful
for anything but "don't write beyond this size of array I have for
events". io_uring has minevents as the general interface, and doesn't
really care about maxevents as it obviously doesn't need to copy it
anywhere.

> Also note that the tty layer VTIME is *different* from what I think
> your "minimum wait time" is. VTIME is a "inter event timer", not a
> "minimum total time". If new events keep on coming, the timer resets -
> until either things time out, or you hit VMIN events.

Right, and I don't think that's what we want here. Some of the hw
coalescing works the same time, basically triggering the timeout once we
have received one event. But that makes it hard to manage the latency,
if your budget is XX usec. Now it becomes YY usec + XX usec instead, if
an event isn't immediatly available.

> I get the feeling that the tty layer did this right, and this epoll
> series did not. The tty model certainly feels more flexible, and does
> have decades of experience. tty traffic *used* to be just about the
> lowest-latency traffic machines handled back when, so I think it might
> be worth looking at as a model.
> 
> So I get the feeling that if you are adding some new "timeout for
> multiple events" model to epoll, you should look at previous users.
> 
> And btw, the tty layer most definitely doesn't handle every possible case.
> 
> There are at least three different valid timeouts:
> 
>  (a) the "final timeout" that epoll already has (ie "in no case wait
> more than this, even if there are no events")
> 
>  (b) the "max time we wait if we have at least one event" (your new "min_wait")
> 
>  (c) the "inter-event timeout" (tty layer VTIME)
> 
> and in addition to the timers, there's that whole "if I have gotten X
> events, I have enough, so stop timing out" (tty layer VMIN).

I do like the VMIN and I think it makes sense. Using VMIN == 0 and VTIME
!= 0 would give you the same behavior it has now, having both be
non-zero would be an OR condition for when to exit.

> And again, that "at least X events" should not be "this is my buffer
> size". You may well want to have a *big* buffer for when there are
> events queued up or the machine is just under very heavy load, but may
> well feel like "if I got N events, I have enough to deal with, and
> don't want to time out for any more".

For epoll, the maxevents already exists for this. Any call should reap
anything up to maxevents, not stop if minevents is met but more events
are available. Only maxevents should terminate the reaping for available
events.

> Now, maybe there is some reason why the tty like VMIN/VTIME just isn't
> relevant, but I do think that people have successfully used VMIN/VTIME
> for long enough that it should be at least given some thought.

Ah it's close enough to thing that are available now. As you mentioned,
there are only really that many different ways to do this if you factor
in a VMIN events as well.

-- 
Jens Axboe

