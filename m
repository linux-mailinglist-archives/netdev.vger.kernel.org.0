Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29445217350
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgGGQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGQHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 12:07:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90003C061755;
        Tue,  7 Jul 2020 09:07:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h22so43393677lji.9;
        Tue, 07 Jul 2020 09:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=+LL0SA4tn6/0BsO1epnijcrURC1kZX0cePtFK/beHQE=;
        b=L0Ic5i7LuOwuJoxssd2Sw0ltj7RXtilv4GvwaLj2efGX3JKvJfq80/10uO9WWs34jU
         uG+YfyqPbwUZM5MLddp6XU6+HLCanBy4LVMQtF1rWnxPIeLO8gg8bDrktb0XenjJ3wF+
         /ZTBJzUp474pvikZeNVEC/uUcS1M9IR0+sBs+pT+uzdq3eLGdJXpryL7sHzril899amZ
         TmsHUGiSwq2otYl1bxdcdpSaQIhclTTy1487E5MtL8PplTHwxLP9zcgFNdGfQ5uREVuG
         +WCiztYYDaoueDmtD9zEwX7ihwjBe5nU3HtYxvNzR5ehomoxnckszoeTLvHUO/M7agA3
         s+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=+LL0SA4tn6/0BsO1epnijcrURC1kZX0cePtFK/beHQE=;
        b=K8ZZGTZhrW692eZpQTfiU7tdLv/BI4VTIgtzCOJnCNDuVxckQf05qVlQcSJ88RhrVt
         VVrI0RRAtEZ5FaymLNIEWWpGN3wn5XLRPajVgwVqNM/GEL7Ow8gqq+XXzwb6dBt7Bc0/
         7r+7uzIWODQrB0k9yYciuwjTdVB9agBhW3aCOQEgpGj52TvcPmj0glBnCty+8nd9LRPv
         K4Q3TZBFgrx21enJ9oEIGPXYe1PJFXnimmZ+FcbJRevYlxy9+O2gxVqhFmThQAHz8nmH
         8d5FRfbNXBzKvmUzFZJ2Oc5apjphrZ6Iaaro++WXSyiHMQT98rzby3j+8Nt+1XMTsD4/
         lz8w==
X-Gm-Message-State: AOAM5306iVWZE29L/O12lLy3WAEYnT1Mm419mvtS+1wVHT5HRRiXRLiD
        eQEKw7Vlqaj1V+kZVnPUZX8=
X-Google-Smtp-Source: ABdhPJxUw+AGC6B8XkLJobkCDQ+myddgDD8F9rXj8qyGYEh1uMHrmjn5+suinm0cqHUP0QseB2tiOA==
X-Received: by 2002:a2e:b5a8:: with SMTP id f8mr29593294ljn.247.1594138030934;
        Tue, 07 Jul 2020 09:07:10 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id r15sm242627ljd.130.2020.07.07.09.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 09:07:09 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-4-sorganov@gmail.com>
        <20200706152721.3j54m73bm673zlnj@skbuf> <874kqksdrb.fsf@osv.gnss.ru>
        <20200707063651.zpt6bblizo5r3kir@skbuf>
Date:   Tue, 07 Jul 2020 19:07:08 +0300
In-Reply-To: <20200707063651.zpt6bblizo5r3kir@skbuf> (Vladimir Oltean's
        message of "Tue, 7 Jul 2020 09:36:51 +0300")
Message-ID: <87sge371hv.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Mon, Jul 06, 2020 at 09:24:24PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > Hi Sergey,
>> >
>> > On Mon, Jul 06, 2020 at 05:26:14PM +0300, Sergey Organov wrote:
>> >> Initializing with 0 makes it much easier to identify time stamps from
>> >> otherwise uninitialized clock.
>> >> 
>> >> Initialization of PTP clock with current kernel time makes little sense as
>> >> PTP time scale differs from UTC time scale that kernel time represents.
>> >> It only leads to confusion when no actual PTP initialization happens, as
>> >> these time scales differ in a small integer number of seconds (37 at the
>> >> time of writing.)
>> >> 
>> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> >> ---
>> >
>> > Reading your patch, I got reminded of my own attempt of making an
>> > identical change to the ptp_qoriq driver:
>> >
>> > https://www.spinics.net/lists/netdev/msg601625.html
>> >
>> > Could we have some sort of kernel-wide convention, I wonder (even though
>> > it might be too late for that)? After your patch, I can see equal
>> > amounts of confusion of users expecting some boot-time output of
>> > $(phc_ctl /dev/ptp0 get) as it used to be, and now getting something
>> > else.
>> >
>> > There's no correct answer, I'm afraid.
>> 
>> IMHO, the correct answer would be keep non-initialized clock at 0. No
>> ticking.
>> 
>
> What do you mean 'no ticking', and what do you mean by 'non-initialized
> clock' exactly? I don't know if the fec driver is special in any way, do
> you mean that multiple runs of $(phc_ctl /dev/ptp0 get) from user space
> all return 0? That is not at all what is to be expected, I think. The
> PHC is always ticking. Its time is increasing.

That's how it is right now. My point is that it likely shouldn't. Why is
it ticking when nobody needs it? Does it draw more power due to that?

> What would be that initialization procedure that makes it tick, and
> who is doing it (and when)?

The user space code that cares, obviously. Most probably some PTP stack
daemon. I'd say that any set clock time ioctl() should start the clock,
or yet another ioctl() that enables/disables the clock, whatever.

>
>> > Whatever the default value of the clock may be, it's bound to be
>> > confusing for some reason, _if_ the reason why you're investigating it
>> > in the first place is a driver bug. Also, I don't really see how your
>> > change to use Jan 1st 1970 makes it any less confusing.
>> 
>> When I print the clocks in application, I see seconds and milliseconds
>> part since epoch. With this patch seconds count from 0, that simply
>> match uptime. Easy to tell from any other (malfunctioning) clock.
>> 
>
> It doesn't really match uptime (CLOCK_MONOTONIC). Instead, it is just
> initialized with zero. If you have fec built as module and you insmod it
> after a few days of uptime, it will not track CLOCK_MONOTONIC at all.
>
> Not to say that there's anything wrong with initializing it with 0. It's
> just that I don't see why it would be objectively better.

Well, it would have been better for me in my particular quest to find
the problem, so it rather needs to be shown where initializing with
kernel time is objectively better.

Moreover, everything else being equal, 0 is always better, just because
of simplicity.

>
>> Here is the description of confusion and improvement. I spent half a day
>> not realizing that I sometimes get timestamps from the wrong PTP clock.
>
> There is a suite of tests in tools/testing/selftests/ptp/ which is
> useful in debugging problems like this.
>
> Alternatively, you can write to each individual clock using $(phc_ctl
> /dev/ptpN set 0) and check your timestamps again. If the timestamps
> don't nudge, it's clear that the timestamps you're getting are not from
> the PHC you've written to. Much simpler.

Maybe. Once you do figure there is another clock in the system and/or
that that clock is offending. In my case /that/ was the hard part, not
changing that offending clock, once found, to whatever.

>
>> Part of the problem is that kernel time at startup, when it is used for
>> initialization of the PTP clock, is in fact somewhat random, and it
>> could be off by a few seconds.
>
> Yes, the kernel time at startup is exactly random (not traceable to any
> clock reference). And so is the PHC.
>
>> Now, when in application I get time stamp
>> that is almost right, and then another one that is, say, 9 seconds off,
>> what should I think? Right, that I drive PTP clock wrongly.
>> 
>> Now, when one of those timestamps is almost 0, I see immediately I got
>> time from wrong PTP clock, rather than wrong time from correct PTP
>> clock.
>> 
>
> There are 2 points to be made here:
>
> 1. There are simpler ways to debug your issue than to leave a patch in
>    the kernel, like the "phc_ctl set 0" I mentioned above. This can be
>    considered a debugging patch which is also going to have consequences
>    for the other users of the driver, if applied. We need to consider
>    whether the change in behavior is useful in general.

This does not apply to my particular case as I explained above, and then
ease with debug is just a nice side-effect of code simplification.

>
> 2. There are boards out there which don't have any battery-backed RTC,
>    so CLOCK_REALTIME could be ticking in Jan 1970 already, and therefore
>    the PHC would be initialized with a time in 1970. Or your GM might be
>    configured to be ticking in Jan 1970 (there are some applications
>    that only require the network to be synchronized, but not for the
>    time to be traceable to TAI). How does your change make a difference
>    to eliminate confusion there, when all of your clocks are going to be
>    in 1970? It doesn't make a net difference. Bottom line, a clock
>    initialized with 0 doesn't mean it's special in any way. You _could_
>    make that change in your debugging environment, and it _could_ be
>    useful to your debugging, but if it's not universally useful, I
>    wouldn't try to patch the kernel with this change.

If there is nothing special about any value, 0 is the value to choose,
because of simplicity. Once again, I only explained debugging advantages
because you've asked about it. It's just a nice side-effect, as it
often happens to be when one keeps things as simple as possible.

> Please note that, although my comments appear to be in disagreement with
> your idea, they are in fact not at all. It's just that, if there's a a
> particular answer to "what time to initialize a PHC with" that is more
> favourable than the rest (even though the question itself is a bit
> irrelevant overall), then that answer ought to be enforced kernel-wide,
> I think.

As everybody, I believe in a set of generic programming principles that
are not to be violated lightly. KISS is one of the principles I believe,
and trying to be clever with no apparent reason is one way of violating
it.

Overall, here is my argument: 0 is simpler than kernel time, so how is
it useful to initialize PTP with kernel time that is as wrong as a value
for PTP time as 0?

Thanks,
-- Sergey.
