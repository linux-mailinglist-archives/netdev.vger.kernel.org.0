Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343EE21744E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgGGQng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgGGQne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 12:43:34 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA04DC061755;
        Tue,  7 Jul 2020 09:43:33 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id lx13so28618628ejb.4;
        Tue, 07 Jul 2020 09:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xI3EFOdDK97fBdcB1+8EI7de19472Lb47rxMR6f0Teg=;
        b=OQycTV/Tzy5T0/XoAHPBRkBiIhwm/frE69h6Kt9xFNu0JHGwHuTguJ7FYCcx0yD8A/
         0SQQSCw16BqEE6JrgjQiBDRKBVMNK/VEEM03qbebq53LXhj/2RmImYfZYGN3DvOgJvLQ
         ++Y0m08Fs/aODMqbtdyqLFAF9aTh/sKKf/VnQBtBVfsVsJ507Qv+mXYwTAJLWlRxtDHB
         UZ4ORsw6rgE8I75dOxbTmjycH+Xx2dCKXCLKY5cwpbT5pmecTAD3wObT0y8Zz3zBIbi6
         s/a1k/2dkPNuIOSmUv/wHCJzIW897Te9laZtNKdgLek9QkDDAvNCQjrcZylZa14TymhS
         xp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xI3EFOdDK97fBdcB1+8EI7de19472Lb47rxMR6f0Teg=;
        b=RLBwReX0FIbIxiamP5aBLkP3XJJlGKLtWZkHhIQKyhs10OgC6Jivk3joLEZvrN/lgF
         bESzMxQo/s5FspAxgtBxeN+JptoyvrSo7tqM15iHH2jLxu6Rl5qpWOlikpI11i6oCJ7P
         nfbzhV4WaLbas0RQUevVst5YI5ijh8w2fc580KyCMO6H/6hh5//QYwvbTOf9LbByVP+r
         fLuJzcwKE0hkl93667Lpu71iLUkK7CE+CGamiomB5bY9Ziv1tHrs2XveP1eIPk1Fifil
         a9WvGRMIqwVb9EXKVdlfo/eGlqNi7ADNCg8X8i/xSP3IOP1H8syWb9MDticpwbmkRFMh
         tuUw==
X-Gm-Message-State: AOAM532zhuKEmjjNnkW7yqnhVZVDhBQ9jrB98JxY8flc1acK1s2AupL4
        4Tnrkf2sPZvbuLz4NGr13Y0=
X-Google-Smtp-Source: ABdhPJwct8KkIgjJ38GUaqLHn3ulTKB5Tst62f63wHwRtQxaBu8Nc//f90clH0KPQU2H7l55roI5tA==
X-Received: by 2002:a17:906:fa9a:: with SMTP id lt26mr38577976ejb.502.1594140212329;
        Tue, 07 Jul 2020 09:43:32 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x10sm594738ejc.46.2020.07.07.09.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 09:43:31 -0700 (PDT)
Date:   Tue, 7 Jul 2020 19:43:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200707164329.pm4p73nzbsda3sfv@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
 <874kqksdrb.fsf@osv.gnss.ru>
 <20200707063651.zpt6bblizo5r3kir@skbuf>
 <87sge371hv.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sge371hv.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 07:07:08PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> >
> > What do you mean 'no ticking', and what do you mean by 'non-initialized
> > clock' exactly? I don't know if the fec driver is special in any way, do
> > you mean that multiple runs of $(phc_ctl /dev/ptp0 get) from user space
> > all return 0? That is not at all what is to be expected, I think. The
> > PHC is always ticking. Its time is increasing.
> 
> That's how it is right now. My point is that it likely shouldn't. Why is
> it ticking when nobody needs it? Does it draw more power due to that?
> 
> > What would be that initialization procedure that makes it tick, and
> > who is doing it (and when)?
> 
> The user space code that cares, obviously. Most probably some PTP stack
> daemon. I'd say that any set clock time ioctl() should start the clock,
> or yet another ioctl() that enables/disables the clock, whatever.
> 

That ioctl doesn't exist, at least not in PTP land. This also addresses
your previous point.

> >
> >> > Whatever the default value of the clock may be, it's bound to be
> >> > confusing for some reason, _if_ the reason why you're investigating it
> >> > in the first place is a driver bug. Also, I don't really see how your
> >> > change to use Jan 1st 1970 makes it any less confusing.
> >> 
> >> When I print the clocks in application, I see seconds and milliseconds
> >> part since epoch. With this patch seconds count from 0, that simply
> >> match uptime. Easy to tell from any other (malfunctioning) clock.
> >> 
> >
> > It doesn't really match uptime (CLOCK_MONOTONIC). Instead, it is just
> > initialized with zero. If you have fec built as module and you insmod it
> > after a few days of uptime, it will not track CLOCK_MONOTONIC at all.
> >
> > Not to say that there's anything wrong with initializing it with 0. It's
> > just that I don't see why it would be objectively better.
> 
> Well, it would have been better for me in my particular quest to find
> the problem, so it rather needs to be shown where initializing with
> kernel time is objectively better.
> 
> Moreover, everything else being equal, 0 is always better, just because
> of simplicity.
> 
> >
> >> Here is the description of confusion and improvement. I spent half a day
> >> not realizing that I sometimes get timestamps from the wrong PTP clock.
> >
> > There is a suite of tests in tools/testing/selftests/ptp/ which is
> > useful in debugging problems like this.
> >
> > Alternatively, you can write to each individual clock using $(phc_ctl
> > /dev/ptpN set 0) and check your timestamps again. If the timestamps
> > don't nudge, it's clear that the timestamps you're getting are not from
> > the PHC you've written to. Much simpler.
> 
> Maybe. Once you do figure there is another clock in the system and/or
> that that clock is offending. In my case /that/ was the hard part, not
> changing that offending clock, once found, to whatever.
> 

And my point was that you could have been in a different situation, when
all of your clocks could have been ticking in 1970, so this wouldn't
have been a distiguishing point. So this argument is poor. Using
phc_ctl, or scripts around that, is much more dynamic.

> >
> >> Part of the problem is that kernel time at startup, when it is used for
> >> initialization of the PTP clock, is in fact somewhat random, and it
> >> could be off by a few seconds.
> >
> > Yes, the kernel time at startup is exactly random (not traceable to any
> > clock reference). And so is the PHC.
> >
> >> Now, when in application I get time stamp
> >> that is almost right, and then another one that is, say, 9 seconds off,
> >> what should I think? Right, that I drive PTP clock wrongly.
> >> 
> >> Now, when one of those timestamps is almost 0, I see immediately I got
> >> time from wrong PTP clock, rather than wrong time from correct PTP
> >> clock.
> >> 
> >
> > There are 2 points to be made here:
> >
> > 1. There are simpler ways to debug your issue than to leave a patch in
> >    the kernel, like the "phc_ctl set 0" I mentioned above. This can be
> >    considered a debugging patch which is also going to have consequences
> >    for the other users of the driver, if applied. We need to consider
> >    whether the change in behavior is useful in general.
> 
> This does not apply to my particular case as I explained above, and then
> ease with debug is just a nice side-effect of code simplification.
> 
> >
> > 2. There are boards out there which don't have any battery-backed RTC,
> >    so CLOCK_REALTIME could be ticking in Jan 1970 already, and therefore
> >    the PHC would be initialized with a time in 1970. Or your GM might be
> >    configured to be ticking in Jan 1970 (there are some applications
> >    that only require the network to be synchronized, but not for the
> >    time to be traceable to TAI). How does your change make a difference
> >    to eliminate confusion there, when all of your clocks are going to be
> >    in 1970? It doesn't make a net difference. Bottom line, a clock
> >    initialized with 0 doesn't mean it's special in any way. You _could_
> >    make that change in your debugging environment, and it _could_ be
> >    useful to your debugging, but if it's not universally useful, I
> >    wouldn't try to patch the kernel with this change.
> 
> If there is nothing special about any value, 0 is the value to choose,
> because of simplicity. Once again, I only explained debugging advantages
> because you've asked about it. It's just a nice side-effect, as it
> often happens to be when one keeps things as simple as possible.
> 
> > Please note that, although my comments appear to be in disagreement with
> > your idea, they are in fact not at all. It's just that, if there's a a
> > particular answer to "what time to initialize a PHC with" that is more
> > favourable than the rest (even though the question itself is a bit
> > irrelevant overall), then that answer ought to be enforced kernel-wide,
> > I think.
> 
> As everybody, I believe in a set of generic programming principles that
> are not to be violated lightly. KISS is one of the principles I believe,
> and trying to be clever with no apparent reason is one way of violating
> it.
> 
> Overall, here is my argument: 0 is simpler than kernel time, so how is
> it useful to initialize PTP with kernel time that is as wrong as a value
> for PTP time as 0?
> 

And overall, my argument is: you are making a user-visible change, for
basically no strong reason, other than the fact that you like zero
better. You're trying to reduce confusion, not increase it, right?

I agree with the basic fact that zero is a simpler and more consistent
value to initialize a PHC with, than the system time. As I've already
shown to you, I even attempted to make a similar change to the ptp_qoriq
driver which was rejected. So I hoped that you could bring some better
arguments than "I believe 0 is simpler". Since no value is right, no
value is wrong either, so why make a change in the first place? The only
value in _changing_ to zero would be if all drivers were changed to use
it consistently, IMO.

But I will stop here and let the PTP maintainer make a choice. I only
intervened because I knew what the default answer was going to be.

> Thanks,
> -- Sergey.

Thanks,
-Vladimir
