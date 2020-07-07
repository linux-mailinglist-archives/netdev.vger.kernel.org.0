Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FE7216685
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGGGgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGGgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 02:36:55 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A20CC061755;
        Mon,  6 Jul 2020 23:36:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b15so37412945edy.7;
        Mon, 06 Jul 2020 23:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UqHBVR7AXZDr8T2/3H+3Cgz/DiUUwV80s3AgwVzbVKM=;
        b=BlIpBGKbjCnSc3zlkfkIV1p6o+uMLbizbKtDJN6h4kwPfMYxqNUqDVKTWYbzw7F630
         MuJ/OIHpFVBMIyAEQZFcTTU64YBOpNuerg5Zqun6JHoSi10RPLiLdzOd6Yjh69zwnNxq
         equCfdzFaCFSGeT2knqly3Rw08AzalaJrVYG8sLjiZeU6FspkhlvlZgXsGwEtQ0PUAjW
         N8vhU60FbnR1eYvr5+02hZ5GQvyZv3S+FWQ7ZbbMezdGmKr3WTEZeuAjNeXcD2MoXbT9
         LPxxEts1SqPi5GNajwdkYbb/dOSd13HUUC2HvfhCb/VSYNOnqWwMuN83tdRb/IHmsTui
         UXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UqHBVR7AXZDr8T2/3H+3Cgz/DiUUwV80s3AgwVzbVKM=;
        b=gRIeSfe9N+v2AKCrxTqI+A9GwH3tGOZdw692JwvVs+zw2FU8UaHdqCJFhJiU4BLjw3
         mfIQ1YfuI73ap9qUMZCfuRZR1ns3cU7yi69HAsK8k53xNU1l77oHShJoEiioTHDyVFdb
         PQwEFh3facdoNM7pCAN+tHz1Dzhl7DyOp5/KesnUgOSSJGw6KWZuBBMVtOtI9VkYnc4E
         Zq8KFEB+sSWugApngdolRMpMtlhn79DlZEgfiAkn0Is9obQ+K+gPmdCRbYgAz1GmWZz0
         Zakf/5dC53JL5bmaqljSTTESp9GnTiY61aqMlYiJkr0dy7L5C8FlhKanCG4VTX6exO7r
         qpAA==
X-Gm-Message-State: AOAM531pE20EPSDb4g/Cqh5WvRXdpkHvGJr5sNQmrDXq+oknQDdJgUzC
        J1WnUhq8F0CAjWzpj87k+eE=
X-Google-Smtp-Source: ABdhPJyOr5m9jp1BfArrJlPJLAfSJgog/3YcIqDdyt4omeI4sskZSBPxp8UVzURxEwT4fNtbo/R/Vw==
X-Received: by 2002:a05:6402:1246:: with SMTP id l6mr28526205edw.224.1594103813627;
        Mon, 06 Jul 2020 23:36:53 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id q24sm27226852edg.51.2020.07.06.23.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 23:36:53 -0700 (PDT)
Date:   Tue, 7 Jul 2020 09:36:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200707063651.zpt6bblizo5r3kir@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
 <874kqksdrb.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kqksdrb.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 09:24:24PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > Hi Sergey,
> >
> > On Mon, Jul 06, 2020 at 05:26:14PM +0300, Sergey Organov wrote:
> >> Initializing with 0 makes it much easier to identify time stamps from
> >> otherwise uninitialized clock.
> >> 
> >> Initialization of PTP clock with current kernel time makes little sense as
> >> PTP time scale differs from UTC time scale that kernel time represents.
> >> It only leads to confusion when no actual PTP initialization happens, as
> >> these time scales differ in a small integer number of seconds (37 at the
> >> time of writing.)
> >> 
> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> >> ---
> >
> > Reading your patch, I got reminded of my own attempt of making an
> > identical change to the ptp_qoriq driver:
> >
> > https://www.spinics.net/lists/netdev/msg601625.html
> >
> > Could we have some sort of kernel-wide convention, I wonder (even though
> > it might be too late for that)? After your patch, I can see equal
> > amounts of confusion of users expecting some boot-time output of
> > $(phc_ctl /dev/ptp0 get) as it used to be, and now getting something
> > else.
> >
> > There's no correct answer, I'm afraid.
> 
> IMHO, the correct answer would be keep non-initialized clock at 0. No
> ticking.
> 

What do you mean 'no ticking', and what do you mean by 'non-initialized
clock' exactly? I don't know if the fec driver is special in any way, do
you mean that multiple runs of $(phc_ctl /dev/ptp0 get) from user space
all return 0? That is not at all what is to be expected, I think. The
PHC is always ticking. Its time is increasing. What would be that
initialization procedure that makes it tick, and who is doing it (and
when)?

> > Whatever the default value of the clock may be, it's bound to be
> > confusing for some reason, _if_ the reason why you're investigating it
> > in the first place is a driver bug. Also, I don't really see how your
> > change to use Jan 1st 1970 makes it any less confusing.
> 
> When I print the clocks in application, I see seconds and milliseconds
> part since epoch. With this patch seconds count from 0, that simply
> match uptime. Easy to tell from any other (malfunctioning) clock.
> 

It doesn't really match uptime (CLOCK_MONOTONIC). Instead, it is just
initialized with zero. If you have fec built as module and you insmod it
after a few days of uptime, it will not track CLOCK_MONOTONIC at all.

Not to say that there's anything wrong with initializing it with 0. It's
just that I don't see why it would be objectively better.

> Here is the description of confusion and improvement. I spent half a day
> not realizing that I sometimes get timestamps from the wrong PTP clock.

There is a suite of tests in tools/testing/selftests/ptp/ which is
useful in debugging problems like this.

Alternatively, you can write to each individual clock using $(phc_ctl
/dev/ptpN set 0) and check your timestamps again. If the timestamps
don't nudge, it's clear that the timestamps you're getting are not from
the PHC you've written to. Much simpler.

> Part of the problem is that kernel time at startup, when it is used for
> initialization of the PTP clock, is in fact somewhat random, and it
> could be off by a few seconds.

Yes, the kernel time at startup is exactly random (not traceable to any
clock reference). And so is the PHC.

> Now, when in application I get time stamp
> that is almost right, and then another one that is, say, 9 seconds off,
> what should I think? Right, that I drive PTP clock wrongly.
> 
> Now, when one of those timestamps is almost 0, I see immediately I got
> time from wrong PTP clock, rather than wrong time from correct PTP
> clock.
> 

There are 2 points to be made here:

1. There are simpler ways to debug your issue than to leave a patch in
   the kernel, like the "phc_ctl set 0" I mentioned above. This can be
   considered a debugging patch which is also going to have consequences
   for the other users of the driver, if applied. We need to consider
   whether the change in behavior is useful in general.

2. There are boards out there which don't have any battery-backed RTC,
   so CLOCK_REALTIME could be ticking in Jan 1970 already, and therefore
   the PHC would be initialized with a time in 1970. Or your GM might be
   configured to be ticking in Jan 1970 (there are some applications
   that only require the network to be synchronized, but not for the
   time to be traceable to TAI). How does your change make a difference
   to eliminate confusion there, when all of your clocks are going to be
   in 1970? It doesn't make a net difference. Bottom line, a clock
   initialized with 0 doesn't mean it's special in any way. You _could_
   make that change in your debugging environment, and it _could_ be
   useful to your debugging, but if it's not universally useful, I
   wouldn't try to patch the kernel with this change.

Please note that, although my comments appear to be in disagreement with
your idea, they are in fact not at all. It's just that, if there's a a
particular answer to "what time to initialize a PHC with" that is more
favourable than the rest (even though the question itself is a bit
irrelevant overall), then that answer ought to be enforced kernel-wide,
I think.

> Thanks,
> -- Sergey

Cheers,
-Vladimir
