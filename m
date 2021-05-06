Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D40375638
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhEFPIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235036AbhEFPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 11:08:20 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1DBC061574;
        Thu,  6 May 2021 08:07:21 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id b19-20020a05600c06d3b029014258a636e8so3236307wmn.2;
        Thu, 06 May 2021 08:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VJvzLtj6GnQ/oN29bUzouxUFpiZG8Jw7sIzM1dlTRAI=;
        b=TJyy0YUt0cu7Nz7O4qFnyqhM0OaJgobZpIJOE4Pyt02doVgxdILqJUQrHK/jJD98Ax
         Lc29r/SXWpDnE8g1f0FZbz1dP//EfgaGxhbFuZwCGlYwv1bd7ExJaV+4xq/LkfPUTJ18
         YHly27EqjbaK7mAd8QLIjD1eOoqka+5ailsypm3tIP3eWclozOBD7Zge75784GlVv79s
         w2uButLdGrP+/g7mrYNC2DQ5/G5rjH2XZRWEcsB+Zb3ww2L/BVfIHQp8xrG/3ZdPbzK4
         e8WtB32Hy7ah8On+BPNCMk8jsWcASiHW8YbprS8HPEsl2+AxhS5wEk00MDUQkI3CQCUP
         olGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VJvzLtj6GnQ/oN29bUzouxUFpiZG8Jw7sIzM1dlTRAI=;
        b=px2Iq8eNS9chmrp6fASuSKC7+8naeFwW46f4xTSCkZ7yo6lfZlBRlg3Vwcab1JyeuP
         lei05Mk/UorYIx8iIY1+Wo7Iz2ufX9UfxDrwl61RGhI6PCc0TD2lry3QaK9DbQBFap54
         2xAgZjgbNQUJpTefUkeBaupRrG9WIDIFv3g8aNeKh4s0HIIiBRqsobFbqMEiiWXycwh9
         Sk6dc0V2t3cZhptkGmwUcK6+Dm6QhSw5mBG+peJZnaFB7vSKkY+gMArMpTKf73V1bzrr
         1sHy6QVDK/F30SCNHoTrZZ65t0KYu+pqiFGupkMqoIVSAv0hm8sOxM298NIxwJ7+NloZ
         lLVg==
X-Gm-Message-State: AOAM533tfWUuAchf3VKs+cskfeds2/mcleP6tsurlf74WP95r3cCANkz
        PDul1WcUb7CjAUcCcdu8+7o=
X-Google-Smtp-Source: ABdhPJy1CWpVAR4whTiKwF7t52yA4nWQig2Y7F52GwfZwOrcEFAUGjUPi8urZhnS8qes6n3XnPYLrw==
X-Received: by 2002:a7b:cf38:: with SMTP id m24mr4516661wmg.174.1620313640552;
        Thu, 06 May 2021 08:07:20 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id v15sm10151692wmj.39.2021.05.06.08.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 08:07:20 -0700 (PDT)
Date:   Thu, 6 May 2021 18:07:18 +0300
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
Message-ID: <20210506150718.on5ivo3zqpsf6uab@skbuf>
References: <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
 <20210506135007.ul3gpdecq427tvgr@skbuf>
 <879df38ab1fb6d8fb8f371bfd5e8c213@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <879df38ab1fb6d8fb8f371bfd5e8c213@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 04:41:51PM +0200, Michael Walle wrote:
> Am 2021-05-06 15:50, schrieb Vladimir Oltean:
> > On Thu, May 06, 2021 at 03:25:07PM +0200, Michael Walle wrote:
> > > Am 2021-05-04 23:33, schrieb Vladimir Oltean:
> > > > [ trimmed the CC list, as this is most likely spam for most people ]
> > > >
> > > > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
> > > > > Am 2021-05-04 21:17, schrieb Vladimir Oltean:
> > > > > > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
> > > > > > > > > > > As explained in another mail in this thread, all queues are marked as
> > > > > > > > > > > scheduled. So this is actually a no-op, correct? It doesn't matter if
> > > > > > > > > > > it set or not set for now. Dunno why we even care for this bit then.
> > > > > > > > > >
> > > > > > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available
> > > > > > > > > > throughput when set.
> > > > > > > > >
> > > > > > > > > Ahh, I see now. All queues are "scheduled" but the guard band only
> > > > > > > > > applies
> > > > > > > > > for "non-scheduled" -> "scheduled" transitions. So the guard band is
> > > > > > > > > never
> > > > > > > > > applied, right? Is that really what we want?
> > > > > > > >
> > > > > > > > Xiaoliang explained that yes, this is what we want. If the end user
> > > > > > > > wants a guard band they can explicitly add a "sched-entry 00" in the
> > > > > > > > tc-taprio config.
> > > > > > >
> > > > > > > You're disabling the guard band, then. I figured, but isn't that
> > > > > > > suprising for the user? Who else implements taprio? Do they do it in
> > > > > > > the
> > > > > > > same way? I mean this behavior is passed right to the userspace and
> > > > > > > have
> > > > > > > a direct impact on how it is configured. Of course a user can add it
> > > > > > > manually, but I'm not sure that is what we want here. At least it
> > > > > > > needs
> > > > > > > to be documented somewhere. Or maybe it should be a switchable option.
> > > > > > >
> > > > > > > Consider the following:
> > > > > > > sched-entry S 01 25000
> > > > > > > sched-entry S fe 175000
> > > > > > > basetime 0
> > > > > > >
> > > > > > > Doesn't guarantee, that queue 0 is available at the beginning of
> > > > > > > the cycle, in the worst case it takes up to
> > > > > > > <begin of cycle> + ~12.5us until the frame makes it through (given
> > > > > > > gigabit and 1518b frames).
> > > > > > >
> > > > > > > Btw. there are also other implementations which don't need a guard
> > > > > > > band (because they are store-and-forward and cound the remaining
> > > > > > > bytes). So yes, using a guard band and scheduling is degrading the
> > > > > > > performance.
> > > > > >
> > > > > > What is surprising for the user, and I mentioned this already in another
> > > > > > thread on this patch, is that the Felix switch overruns the time gate (a
> > > > > > packet taking 2 us to transmit will start transmission even if there is
> > > > > > only 1 us left of its time slot, delaying the packets from the next time
> > > > > > slot by 1 us). I guess that this is why the ALWAYS_GUARD_BAND_SCH_Q bit
> > > > > > exists, as a way to avoid these overruns, but it is a bit of a poor tool
> > > > > > for that job. Anyway, right now we disable it and live with the
> > > > > > overruns.
> > > > >
> > > > > We are talking about the same thing here. Why is that a poor tool?
> > > >
> > > > It is a poor tool because it revolves around the idea of "scheduled
> > > > queues" and "non-scheduled queues".
> > > >
> > > > Consider the following tc-taprio schedule:
> > > >
> > > > 	sched-entry S 81 2000 # TC 7 and 0 open, all others closed
> > > > 	sched-entry S 82 2000 # TC 7 and 1 open, all others closed
> > > > 	sched-entry S 84 2000 # TC 7 and 2 open, all others closed
> > > > 	sched-entry S 88 2000 # TC 7 and 3 open, all others closed
> > > > 	sched-entry S 90 2000 # TC 7 and 4 open, all others closed
> > > > 	sched-entry S a0 2000 # TC 7 and 5 open, all others closed
> > > > 	sched-entry S c0 2000 # TC 7 and 6 open, all others closed
> > > >
> > > > Otherwise said, traffic class 7 should be able to send any time it
> > > > wishes.
> > > 
> > > What is the use case behind that? TC7 (with the highest priority)
> > > may always take precedence of the other TCs, thus what is the point
> > > of having a dedicated window for the others.
> > 
> > Worst case latency is obviously better for an intermittent stream (not
> > more than one packet in flight at a time) in TC7 than it is for any
> > stream in TC6-TC0. But intermittent streams in TC6-TC0 also have their
> > own worst case guarantees (assuming that 2000 ns is enough to fit one
> > TC 7 frame and one frame from the TC6-TC0 range).
> 
> Oh and I missed that, TC0-TC6 probably won't work because that gate is
> too narrow (12.5us guard band) unless of course you set MAXSDU to a
> smaller value. Which would IMHO be the correct thing to do here.

I'm not sure that this is exactly true. I know that I tested once, and
the switch is happy to send a packet as long as the time window is 33 ns
or larger (Idon't . Can't remember if the ALWAYS_GUARD_BAND_SCH_Q bit was set or
not, and I'm traveling right now so I don't have an LS1028A board handy
to re-test.
