Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADAF375520
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbhEFNvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 09:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbhEFNvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 09:51:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCF0C061574;
        Thu,  6 May 2021 06:50:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g14so6241685edy.6;
        Thu, 06 May 2021 06:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z4rPTM6cUAQd7LseyW5s02IBur/NO3fRdYb6ZmXR4KY=;
        b=ge5omxkM4BpLLO9nC5NU08E0SkxVPtdw783pkBAY2GBv3qtgXJPpR9vhLM6XAkNL0g
         KCGxin4kJKf8/wSRmRI86IhnnqeVoxbG5IzdX65nzKDiwYIzzcIU4qDn/0uIftXaq5jR
         ZXIGgIdqayAKgFcN22sYB1nkPRSWWHUxgy7NeSwPxYbhYp/Vk8kYdc+Iz9NDeeQFgCFD
         PpWBC53BBIQ/szJEoz4aioFc3Ir7UR2tBDh6UTCR0Q7R7ekeonkPmq1tNaLjUOnJ9XnY
         OuZFsPcK7FscKglMxTaEnAQ++jnj8UrKnDJCyIz++Et9Bkf6QHwlmElU36HdfQ2Odkkq
         u7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z4rPTM6cUAQd7LseyW5s02IBur/NO3fRdYb6ZmXR4KY=;
        b=LtqR2AoUVzYpzGoTODpkb0hbDwJUMvnqDNgPmakAsa4dJkp1aGlvfMuyBrWfm9TeZE
         FEMjBg9r7O0xEga5d86rNkpIlcv/2I5KsuEbsTEttIFfxNjsSmbif2715M/WZxTBre28
         vMe/PgVWLH6a7GYkYhEG8qv7r0PP1ku+KMxvAlnLmmVzqN8lFJFgkqEg+lJyHsMd99TA
         i97+/QqrT2wCvtpkU//q1Lt5vbH6p36y0cHZyrAmmL52+3hx9YrBYglPdilHgNywJ2Es
         D9xnxx+lDQbAzyfACfhXIeTV7ACrXY2JB5eJx6DaE/zjB/LVh1EFKCO1bT9e8UoCgBiy
         sThw==
X-Gm-Message-State: AOAM5307CI/P9YSLUo9dhT+tigKXyfz0vEqSxuPyhHBgl2NsuyYSvP+B
        jNXADTaEuISPIvipCX8G2Lz1lHIe1q4=
X-Google-Smtp-Source: ABdhPJw5n9gHeopjVBr88Cj78qmolzNT9OSl0IM7dxK5eLIN1Z40UDg4xEDFUiVq/hEs3u/YyecxPA==
X-Received: by 2002:aa7:c9c9:: with SMTP id i9mr5321256edt.17.1620309009707;
        Thu, 06 May 2021 06:50:09 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id t22sm1708143edw.29.2021.05.06.06.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:50:09 -0700 (PDT)
Date:   Thu, 6 May 2021 16:50:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>, davem@davemloft.net,
        idosch@mellanox.com, joergen.andreasen@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>, vinicius.gomes@intel.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for
 TAS config
Message-ID: <20210506135007.ul3gpdecq427tvgr@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 03:25:07PM +0200, Michael Walle wrote:
> Am 2021-05-04 23:33, schrieb Vladimir Oltean:
> > [ trimmed the CC list, as this is most likely spam for most people ]
> > 
> > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
> > > Am 2021-05-04 21:17, schrieb Vladimir Oltean:
> > > > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
> > > > > > > > > As explained in another mail in this thread, all queues are marked as
> > > > > > > > > scheduled. So this is actually a no-op, correct? It doesn't matter if
> > > > > > > > > it set or not set for now. Dunno why we even care for this bit then.
> > > > > > > >
> > > > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
> > > > > > > > throughput when set.
> > > > > > >
> > > > > > > Ahh, I see now. All queues are "scheduled" but the guard band only
> > > > > > > applies
> > > > > > > for "non-scheduled" -> "scheduled" transitions. So the guard band is
> > > > > > > never
> > > > > > > applied, right? Is that really what we want?
> > > > > >
> > > > > > Xiaoliang explained that yes, this is what we want. If the end user
> > > > > > wants a guard band they can explicitly add a "sched-entry 00" in the
> > > > > > tc-taprio config.
> > > > >
> > > > > You're disabling the guard band, then. I figured, but isn't that
> > > > > suprising for the user? Who else implements taprio? Do they do it in
> > > > > the
> > > > > same way? I mean this behavior is passed right to the userspace and
> > > > > have
> > > > > a direct impact on how it is configured. Of course a user can add it
> > > > > manually, but I'm not sure that is what we want here. At least it
> > > > > needs
> > > > > to be documented somewhere. Or maybe it should be a switchable option.
> > > > >
> > > > > Consider the following:
> > > > > sched-entry S 01 25000
> > > > > sched-entry S fe 175000
> > > > > basetime 0
> > > > >
> > > > > Doesn't guarantee, that queue 0 is available at the beginning of
> > > > > the cycle, in the worst case it takes up to
> > > > > <begin of cycle> + ~12.5us until the frame makes it through (given
> > > > > gigabit and 1518b frames).
> > > > >
> > > > > Btw. there are also other implementations which don't need a guard
> > > > > band (because they are store-and-forward and cound the remaining
> > > > > bytes). So yes, using a guard band and scheduling is degrading the
> > > > > performance.
> > > >
> > > > What is surprising for the user, and I mentioned this already in another
> > > > thread on this patch, is that the Felix switch overruns the time gate (a
> > > > packet taking 2 us to transmit will start transmission even if there is
> > > > only 1 us left of its time slot, delaying the packets from the next time
> > > > slot by 1 us). I guess that this is why the ALWAYS_GUARD_BAND_SCH_Q bit
> > > > exists, as a way to avoid these overruns, but it is a bit of a poor tool
> > > > for that job. Anyway, right now we disable it and live with the
> > > > overruns.
> > > 
> > > We are talking about the same thing here. Why is that a poor tool?
> > 
> > It is a poor tool because it revolves around the idea of "scheduled
> > queues" and "non-scheduled queues".
> > 
> > Consider the following tc-taprio schedule:
> > 
> > 	sched-entry S 81 2000 # TC 7 and 0 open, all others closed
> > 	sched-entry S 82 2000 # TC 7 and 1 open, all others closed
> > 	sched-entry S 84 2000 # TC 7 and 2 open, all others closed
> > 	sched-entry S 88 2000 # TC 7 and 3 open, all others closed
> > 	sched-entry S 90 2000 # TC 7 and 4 open, all others closed
> > 	sched-entry S a0 2000 # TC 7 and 5 open, all others closed
> > 	sched-entry S c0 2000 # TC 7 and 6 open, all others closed
> > 
> > Otherwise said, traffic class 7 should be able to send any time it
> > wishes.
> 
> What is the use case behind that? TC7 (with the highest priority)
> may always take precedence of the other TCs, thus what is the point
> of having a dedicated window for the others.

Worst case latency is obviously better for an intermittent stream (not
more than one packet in flight at a time) in TC7 than it is for any
stream in TC6-TC0. But intermittent streams in TC6-TC0 also have their
own worst case guarantees (assuming that 2000 ns is enough to fit one
TC 7 frame and one frame from the TC6-TC0 range).

> Anyway, I've tried it and there are no hiccups. I've meassured
> the delta between the start of successive packets and they are
> always ~12370ns for a 1518b frame. TC7 is open all the time,
> which makes sense. It only happens if you actually close the gate,
> eg. you have a sched-entry where a TC7 bit is not set. In this case,
> I can see a difference between ALWAYS_GUARD_BAND_SCH_Q set and not
> set. If it is set, there is up to a ~12.5us delay added (of course
> it depends on when the former frame was scheduled).
> 
> It seems that also needs to be 1->0 transition.
> 
> You've already mentioned that the switch violates the Qbv standard.
> What makes you think so? IMHO before that patch, it wasn't violated.
> Now it likely is (still have to confirm that). How can this
> be reasonable?

Ah, ok, if you need an open->close transition in order for the auto
guard banding to kick in, then it makes more sense. I didn't actually
measure this, it was based just upon my reading of the user manual.

I won't oppose a revert, let's see what Xiaoliang has to object.

> If you have a look at the initial commit message, it is about
> making it possible to have a smaller gate window, but that is not
> possible because of the current guard band of ~12.5us. It seems
> to be a shortcut for not having the MAXSDU (and thus the length
> of the guard band) configurable. Yes (static) guard bands will
> have a performance impact, also described in [1]. You are trading
> the correctness of the TAS for performance. And it is the sole
> purpose of Qbv to have a determisitc way (in terms of timing) of
> sending the frames.

Ok, so instead of checking on a per-packet basis whether it's going to
fit at the end of its time slot or not, the guard band is just added for
the maximum SDU.

> And telling the user, hey, we know we violate the Qbv standard,
> please insert the guard bands yourself if you really need them is
> not a real solution. As already mentioned, (1) it is not documented
> anywhere, (2) can't be shared among other switches (unless they do
> the same workaround) and (3) what am I supposed to do for TSN compliance
> testing. Modifying the schedule that is about to be checked (and thus
> given by the compliance suite)?
>
> > With the ALWAYS_GUARD_BAND_SCH_Q bit, there will be hiccups in packet
> > transmission for TC 7. For example, at the end of every time slot,
> > the hardware will insert a guard band for TC 7 because there is a
> > scheduled-queue-to-scheduled-queue transition, and it has been told to
> > do that. But a packet with TC 7 should be transmitted at any time,
> > because that's what we told the port to do!
> > 
> > Alternatively, we could tell the switch that TC 7 is "scheduled", and
> > the others are "not scheduled". Then it would implement the guard band
> > at the end of TCs 0-6, but it wouldn't for packets sent in TC 7. But
> > when you look at the overall schedule I described above, it kinds looks
> > like TCs 0-6 are the ones that are "scheduled" and TC 7 looks like the
> > one which isn't "scheduled" but can send at any time it pleases.
> > 
> > Odd, just odd. It's clear that someone had something in mind, it's just
> > not clear what. I would actually appreciate if somebody from Microchip
> > could chime in and say "no, you're wrong", and then explain.
> 
> If I had to make a bet, the distinction between "scheduled" and
> "non-scheduled" is there to have more control for some traffic classes
> you trust and where you can engineer the traffic, so you don't really
> need the guard band and between arbitrary traffic where you can't really
> say anything about and thus need the guard band.

I still don't know if I understand properly. You mean that "scheduled"
traffic is traffic sent synchronized with the switch's schedule, and
which does not need guard banding at the end of its time slot because
the sender is playing nice?
Yes, but then, do you gain anything at all by disabling that guard band
and allowing the sender to overrun if they want to? I still don't see
why overruns are permitted by the switch in certain configurations.

> > > > FWIW, the ENETC does not overrun the time gate, the SJA1105 does. You
> > > > can't really tell just by looking at the driver code, just by testing.
> > > > It's a bit of a crapshoot.
> > > 
> > > I was speaking of other switches, I see there is also a hirschmann
> > > switch (hellcreek) supported in linux, for example.
> > > 
> > > Shouldn't the goal to make the configuration of the taprio qdisc
> > > independent of the switch. If on one you'll have to manually define
> > > the
> > > guard band by inserting dead-time scheduler entries and on another
> > > this
> > > is already handled by the hardware (like it would be with
> > > ALWAYS_GUARD_BAND_SCH_Q or if it doesn't need it at all), this goal
> > > isn't met.
> > > 
> > > Also what do you expect if you use the following configuration:
> > > sched-entry S 01 5000
> > > sched-entry S fe <some large number>
> > > 
> > > Will queue 0 be able to send traffic? To me, with this patch, it seems
> > > to me that this isn't always the case anymore. If there is a large
> > > packet
> > > just sent at the end of the second cycle, the first might even be
> > > skipped
> > > completely.
> > > Will a user of the taprio (without knowledge of the underlying switch)
> > > assume that it can send traffic up to ~600 bytes? I'd say yes.
> > 
> > Yeah, I think that if a switch overruns a packet's reserved time gate,
> > then the above tc-taprio schedule is as good as not having any. I didn't
> > say that overruns are not a problem, I just said that the
> > ALWAYS_blah_blah
> > bit isn't as silver-bullet for a solution as you think.
> 
> See above.
> 
> -michael
> 
> [1] https://www.belden.com/hubfs/resources/knowledge/white-papers/tsn-time-sensitive-networking.pdf
