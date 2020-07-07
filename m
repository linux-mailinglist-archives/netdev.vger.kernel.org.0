Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862172174C0
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgGGRJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgGGRJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:09:10 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F0EC061755;
        Tue,  7 Jul 2020 10:09:10 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id e8so16529857ljb.0;
        Tue, 07 Jul 2020 10:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=fW8qIZMYPQcc3OyuYOdgmdNlsp/pl4qWLU5HddWAHF4=;
        b=Rz7acAXbi5DEiGxlBsUH1qFLpLJ/crtgC/gCB9a8cLmVSHvAF9getxURh8MDpQd101
         mO6jzWMVQqXPxEtiOdLUX1qRPAJ+/I4jdF+X82a3heeDiyF5WXkYkd/wqL/bUcwDSJGI
         ggr+zeoWmWhRo2FkisOjiTd1hwsfwBBJ+mF/BzO4Ca+i+XDqQ56lTWHW7pQK8N0lkZqt
         YlI3ymoAS8SSYFOPipibX0RVuYGlPVlRrEtcV8h1L9h8kRhh9XA1lCu0+8aJ4IQHYtAg
         VfejyhBaBSam7XYUK0o8qUedxFcGaDAWoMd/gwbsNkW+J2CjwQ0GIE9LtC0gczQDpP0e
         SZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=fW8qIZMYPQcc3OyuYOdgmdNlsp/pl4qWLU5HddWAHF4=;
        b=ba7up5Ct9O4zvqwb1JzNodZG2tC2q4qpX+HKi813+wU7hU5Natp70FOjjWeMtW1ohq
         GO2AWfwunsXJv1iTX4I1brUYDkS/IlxK0QyZ/cdnF3oVumL3Ul+ogU57w0xZAPqAihGm
         8ohzBeut10BZrsT43PLcU0E1TdIBX/mLaZPs0d4W5BLvpJCW3AOfHPNkEznVpUsNjG07
         5FU8ey1FTrkJuGpYlZnYCz51rRzdWwfPpWXR1jJgVGswJDFF2FWRT4tS4Bb0YhrZH0tb
         1HNEvGrVvm8qozZza7jQHChGgJ1w3XlK17M2tcS1TCKjDZuhVCdnZcTABln0KyeIgUS+
         NHCw==
X-Gm-Message-State: AOAM533CNdm8i+US5/PLbZVB5fbkiKiU1Zo5Emmq4IAJuXp1maa+95Cw
        OX2tl7G4JSav7Q9LyoPVkRk=
X-Google-Smtp-Source: ABdhPJxiQQCsFbuYSx5DTEsdZGV4SNWi6C9n6tKEUDeJDvohtgdJPwcKfbQLkBYwoaVqEEwVTHHWzw==
X-Received: by 2002:a2e:880e:: with SMTP id x14mr20497394ljh.218.1594141748764;
        Tue, 07 Jul 2020 10:09:08 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id j2sm277201lji.115.2020.07.07.10.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 10:09:08 -0700 (PDT)
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
        <20200707063651.zpt6bblizo5r3kir@skbuf> <87sge371hv.fsf@osv.gnss.ru>
        <20200707164329.pm4p73nzbsda3sfv@skbuf>
Date:   Tue, 07 Jul 2020 20:09:07 +0300
In-Reply-To: <20200707164329.pm4p73nzbsda3sfv@skbuf> (Vladimir Oltean's
        message of "Tue, 7 Jul 2020 19:43:29 +0300")
Message-ID: <87sge345ho.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Tue, Jul 07, 2020 at 07:07:08PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> >
>> > What do you mean 'no ticking', and what do you mean by 'non-initialized
>> > clock' exactly? I don't know if the fec driver is special in any way, do
>> > you mean that multiple runs of $(phc_ctl /dev/ptp0 get) from user space
>> > all return 0? That is not at all what is to be expected, I think. The
>> > PHC is always ticking. Its time is increasing.
>> 
>> That's how it is right now. My point is that it likely shouldn't. Why is
>> it ticking when nobody needs it? Does it draw more power due to that?
>> 
>> > What would be that initialization procedure that makes it tick, and
>> > who is doing it (and when)?
>> 
>> The user space code that cares, obviously. Most probably some PTP stack
>> daemon. I'd say that any set clock time ioctl() should start the clock,
>> or yet another ioctl() that enables/disables the clock, whatever.
>> 
>
> That ioctl doesn't exist, at least not in PTP land. This also addresses
> your previous point.

struct timespec ts;
...
clock_settime(clkid, &ts)

That's the starting point of my own code, and I bet it's there in PTP
for Linux, as well as in PTPD, as I fail to see how it could possibly
work without it.

>
>> >
>> >> > Whatever the default value of the clock may be, it's bound to be
>> >> > confusing for some reason, _if_ the reason why you're investigating it
>> >> > in the first place is a driver bug. Also, I don't really see how your
>> >> > change to use Jan 1st 1970 makes it any less confusing.
>> >> 
>> >> When I print the clocks in application, I see seconds and milliseconds
>> >> part since epoch. With this patch seconds count from 0, that simply
>> >> match uptime. Easy to tell from any other (malfunctioning) clock.
>> >> 
>> >
>> > It doesn't really match uptime (CLOCK_MONOTONIC). Instead, it is just
>> > initialized with zero. If you have fec built as module and you insmod it
>> > after a few days of uptime, it will not track CLOCK_MONOTONIC at all.
>> >
>> > Not to say that there's anything wrong with initializing it with 0. It's
>> > just that I don't see why it would be objectively better.
>> 
>> Well, it would have been better for me in my particular quest to find
>> the problem, so it rather needs to be shown where initializing with
>> kernel time is objectively better.
>> 
>> Moreover, everything else being equal, 0 is always better, just because
>> of simplicity.
>> 
>> >
>> >> Here is the description of confusion and improvement. I spent half a day
>> >> not realizing that I sometimes get timestamps from the wrong PTP clock.
>> >
>> > There is a suite of tests in tools/testing/selftests/ptp/ which is
>> > useful in debugging problems like this.
>> >
>> > Alternatively, you can write to each individual clock using $(phc_ctl
>> > /dev/ptpN set 0) and check your timestamps again. If the timestamps
>> > don't nudge, it's clear that the timestamps you're getting are not from
>> > the PHC you've written to. Much simpler.
>> 
>> Maybe. Once you do figure there is another clock in the system and/or
>> that that clock is offending. In my case /that/ was the hard part, not
>> changing that offending clock, once found, to whatever.
>> 
>
> And my point was that you could have been in a different situation, when
> all of your clocks could have been ticking in 1970, so this wouldn't
> have been a distiguishing point. So this argument is poor. Using
> phc_ctl, or scripts around that, is much more dynamic.
>
>> >
>> >> Part of the problem is that kernel time at startup, when it is used for
>> >> initialization of the PTP clock, is in fact somewhat random, and it
>> >> could be off by a few seconds.
>> >
>> > Yes, the kernel time at startup is exactly random (not traceable to any
>> > clock reference). And so is the PHC.
>> >
>> >> Now, when in application I get time stamp
>> >> that is almost right, and then another one that is, say, 9 seconds off,
>> >> what should I think? Right, that I drive PTP clock wrongly.
>> >> 
>> >> Now, when one of those timestamps is almost 0, I see immediately I got
>> >> time from wrong PTP clock, rather than wrong time from correct PTP
>> >> clock.
>> >> 
>> >
>> > There are 2 points to be made here:
>> >
>> > 1. There are simpler ways to debug your issue than to leave a patch in
>> >    the kernel, like the "phc_ctl set 0" I mentioned above. This can be
>> >    considered a debugging patch which is also going to have consequences
>> >    for the other users of the driver, if applied. We need to consider
>> >    whether the change in behavior is useful in general.
>> 
>> This does not apply to my particular case as I explained above, and then
>> ease with debug is just a nice side-effect of code simplification.
>> 
>> >
>> > 2. There are boards out there which don't have any battery-backed RTC,
>> >    so CLOCK_REALTIME could be ticking in Jan 1970 already, and therefore
>> >    the PHC would be initialized with a time in 1970. Or your GM might be
>> >    configured to be ticking in Jan 1970 (there are some applications
>> >    that only require the network to be synchronized, but not for the
>> >    time to be traceable to TAI). How does your change make a difference
>> >    to eliminate confusion there, when all of your clocks are going to be
>> >    in 1970? It doesn't make a net difference. Bottom line, a clock
>> >    initialized with 0 doesn't mean it's special in any way. You _could_
>> >    make that change in your debugging environment, and it _could_ be
>> >    useful to your debugging, but if it's not universally useful, I
>> >    wouldn't try to patch the kernel with this change.
>> 
>> If there is nothing special about any value, 0 is the value to choose,
>> because of simplicity. Once again, I only explained debugging advantages
>> because you've asked about it. It's just a nice side-effect, as it
>> often happens to be when one keeps things as simple as possible.
>> 
>> > Please note that, although my comments appear to be in disagreement with
>> > your idea, they are in fact not at all. It's just that, if there's a a
>> > particular answer to "what time to initialize a PHC with" that is more
>> > favourable than the rest (even though the question itself is a bit
>> > irrelevant overall), then that answer ought to be enforced kernel-wide,
>> > I think.
>> 
>> As everybody, I believe in a set of generic programming principles that
>> are not to be violated lightly. KISS is one of the principles I believe,
>> and trying to be clever with no apparent reason is one way of violating
>> it.
>> 
>> Overall, here is my argument: 0 is simpler than kernel time, so how is
>> it useful to initialize PTP with kernel time that is as wrong as a value
>> for PTP time as 0?
>> 
>
> And overall, my argument is: you are making a user-visible change, for
> basically no strong reason, other than the fact that you like zero
> better. You're trying to reduce confusion, not increase it, right?

No, not to increase, and I believe there is no way to increase it by
using the value that at least some of the drivers already use.

> I agree with the basic fact that zero is a simpler and more consistent
> value to initialize a PHC with, than the system time. As I've already
> shown to you, I even attempted to make a similar change to the ptp_qoriq
> driver which was rejected. So I hoped that you could bring some better
> arguments than "I believe 0 is simpler". Since no value is right, no
> value is wrong either, so why make a change in the first place? The only
> value in _changing_ to zero would be if all drivers were changed to use
> it consistently, IMO.
>
> But I will stop here and let the PTP maintainer make a choice. I only
> intervened because I knew what the default answer was going to be.

Thanks, so will I, as I won't care much either way, just wanted to make
life of somebody who might travel my path less painful. That person is
not who is already fluent in all the different opportunities to debug
PTP clocks, for sure.

Thanks,
-- Sergey
