Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EDD3764FF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhEGMUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 08:20:48 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:39283 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEGMUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 08:20:44 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 885B92224D;
        Fri,  7 May 2021 14:19:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620389982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/TjBoBx4+w+lrOs4Q7FBL3HI+/cR/xiCytBgu45HrI=;
        b=GSsJciPu7GHlOgh3cx10GpP1xD63BtMRNVqWqLX91JK2OQkTysPWieDa4/zR76N40uPFIV
        QS60NJJ+xhhxRPx5nbGWKGBIFlDLaDMWcC/uyJlt7H5G1gqm9NOr24qBHF840MY+t8lXz/
        SvFeV4RS3Lwsor63ndLg9ftduBdT9hs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 14:19:39 +0200
From:   Michael Walle <michael@walle.cc>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>, davem@davemloft.net,
        idosch@mellanox.com, joergen.andreasen@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>, vinicius.gomes@intel.com
Subject: Re: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
In-Reply-To: <DB8PR04MB5785D01D2F9091FB9267D515F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
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
 <DB8PR04MB5785A6A773FEA4F3E0E77698F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <2898c3ae1319756e13b95da2b74ccacc@walle.cc>
 <DB8PR04MB5785D01D2F9091FB9267D515F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <2744aa489127e6ff23649e40fa6c7df3@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

Am 2021-05-07 13:09, schrieb Xiaoliang Yang:
> On 2021-05-07 15:35, Michael Walle <michael@walle.cc> wrote:
>> Am 2021-05-07 09:16, schrieb Xiaoliang Yang:
>> > On 2021-05-06 21:25, Michael Walle <michael@walle.cc> wrote:
>> >> Am 2021-05-04 23:33, schrieb Vladimir Oltean:
>> >> > [ trimmed the CC list, as this is most likely spam for most people
>> >> > ]
>> >> >
>> >> > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
>> >> >> Am 2021-05-04 21:17, schrieb Vladimir Oltean:
>> >> >> > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
>> >> >> > > > > > > As explained in another mail in this thread, all
>> >> >> > > > > > > queues are marked as scheduled. So this is actually a
>> >> >> > > > > > > no-op, correct? It doesn't matter if it set or not set
>> >> >> > > > > > > for now. Dunno why
>> >> we even care for this bit then.
>> >> >> > > > > >
>> >> >> > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the
>> >> >> > > > > > available throughput when set.
>> >> >> > > > >
>> >> >> > > > > Ahh, I see now. All queues are "scheduled" but the guard
>> >> >> > > > > band only applies for "non-scheduled" -> "scheduled" transitions.
>> >> >> > > > > So the guard band is never applied, right? Is that really
>> >> >> > > > > what we want?
>> >> >> > > >
>> >> >> > > > Xiaoliang explained that yes, this is what we want. If the
>> >> >> > > > end user wants a guard band they can explicitly add a
>> >> >> > > > "sched-entry 00" in the tc-taprio config.
>> >> >> > >
>> >> >> > > You're disabling the guard band, then. I figured, but isn't
>> >> >> > > that suprising for the user? Who else implements taprio? Do
>> >> >> > > they do it in the same way? I mean this behavior is passed
>> >> >> > > right to the userspace and have a direct impact on how it is
>> >> >> > > configured. Of course a user can add it manually, but I'm not
>> >> >> > > sure that is what we want here. At least it needs to be
>> >> >> > > documented somewhere. Or maybe it should be a switchable option.
>> >> >> > >
>> >> >> > > Consider the following:
>> >> >> > > sched-entry S 01 25000
>> >> >> > > sched-entry S fe 175000
>> >> >> > > basetime 0
>> >> >> > >
>> >> >> > > Doesn't guarantee, that queue 0 is available at the beginning
>> >> >> > > of the cycle, in the worst case it takes up to <begin of
>> >> >> > > cycle> + ~12.5us until the frame makes it through (given
>> >> >> > > gigabit and 1518b frames).
>> >> >> > >
>> >> >> > > Btw. there are also other implementations which don't need a
>> >> >> > > guard band (because they are store-and-forward and cound the
>> >> >> > > remaining bytes). So yes, using a guard band and scheduling is
>> >> >> > > degrading the performance.
>> >> >> >
>> >> >> > What is surprising for the user, and I mentioned this already in
>> >> >> > another thread on this patch, is that the Felix switch overruns
>> >> >> > the time gate (a packet taking 2 us to transmit will start
>> >> >> > transmission even if there is only 1 us left of its time slot,
>> >> >> > delaying the packets from the next time slot by 1 us). I guess
>> >> >> > that this is why the ALWAYS_GUARD_BAND_SCH_Q bit exists, as a
>> >> >> > way to avoid these overruns, but it is a bit of a poor tool for
>> >> >> > that job. Anyway, right now we disable it and live with the overruns.
>> >> >>
>> >> >> We are talking about the same thing here. Why is that a poor tool?
>> >> >
>> >> > It is a poor tool because it revolves around the idea of "scheduled
>> >> > queues" and "non-scheduled queues".
>> >> >
>> >> > Consider the following tc-taprio schedule:
>> >> >
>> >> >       sched-entry S 81 2000 # TC 7 and 0 open, all others closed
>> >> >       sched-entry S 82 2000 # TC 7 and 1 open, all others closed
>> >> >       sched-entry S 84 2000 # TC 7 and 2 open, all others closed
>> >> >       sched-entry S 88 2000 # TC 7 and 3 open, all others closed
>> >> >       sched-entry S 90 2000 # TC 7 and 4 open, all others closed
>> >> >       sched-entry S a0 2000 # TC 7 and 5 open, all others closed
>> >> >       sched-entry S c0 2000 # TC 7 and 6 open, all others closed
>> >> >
>> >> > Otherwise said, traffic class 7 should be able to send any time it
>> >> > wishes.
>> >>
>> >> What is the use case behind that? TC7 (with the highest priority) may
>> >> always take precedence of the other TCs, thus what is the point of
>> >> having a dedicated window for the others.
>> >>
>> >> Anyway, I've tried it and there are no hiccups. I've meassured the
>> >> delta between the start of successive packets and they are always
>> >> ~12370ns for a 1518b frame. TC7 is open all the time, which makes
>> >> sense. It only happens if you actually close the gate, eg. you have a
>> >> sched-entry where a TC7 bit is not set. In this case, I can see a
>> >> difference between ALWAYS_GUARD_BAND_SCH_Q set and not set. If it is
>> >> set, there is up to a ~12.5us delay added (of course it depends on
>> >> when the former frame was scheduled).
>> >>
>> >> It seems that also needs to be 1->0 transition.
>> >>
>> >> You've already mentioned that the switch violates the Qbv standard.
>> >> What makes you think so? IMHO before that patch, it wasn't violated.
>> >> Now it likely is (still have to confirm that). How can this be
>> >> reasonable?
>> >>
>> >> If you have a look at the initial commit message, it is about making
>> >> it possible to have a smaller gate window, but that is not possible
>> >> because of the current guard band of ~12.5us. It seems to be a
>> >> shortcut for not having the MAXSDU (and thus the length of the guard
>> >> band) configurable. Yes (static) guard bands will have a performance
>> >> impact, also described in [1]. You are trading the correctness of the
>> >> TAS for performance. And it is the sole purpose of Qbv to have a
>> >> determisitc way (in terms of timing) of sending the frames.
>> >>
>> >> And telling the user, hey, we know we violate the Qbv standard,
>> >> please insert the guard bands yourself if you really need them is not
>> >> a real solution. As already mentioned, (1) it is not documented
>> >> anywhere, (2) can't be shared among other switches (unless they do
>> >> the same workaround) and (3) what am I supposed to do for TSN
>> >> compliance testing. Modifying the schedule that is about to be
>> >> checked (and thus given by the compliance suite)?
>> >>
>> > I disable the always guard band bit because each gate control list
>> > needs to reserve a guard band slot, which affects performance. The
>> > user does not need to set a guard band for each queue transmission.
>> > For example, "sched-entry S 01 2000 sched-entry S fe 98000". Queue 0
>> > is protected traffic and has smaller frames, so there is no need to
>> > reserve a guard band during the open time of queue 0. The user can add
>> > the following guard band before protected traffic: "sched-entry S 00
>> > 25000 sched-entry S 01 2000 sched-entry S fe 73000"
>> 
>> Again, you're passing the handling of the guard band to the user, 
>> which is an
>> implementation detail for this switch (unless there is a new switch 
>> for it on the
>> qdisc IMHO). And (1), (2) and (3) from above is still valid.
>> 
>> Consider the entry
>>   sched-entry S 01 2000
>>   sched-entry S 02 20000
>> 
>> A user assumes that TC0 is open for 2us. But with your change it is 
>> bascially
>> open for 2us + 12.5us. And even worse, it is not deterministic. A 
>> frame in the
>> subsequent queue (ie TC1) can be scheduled anywhere beteeen 0us and
>> 12.5us after opening the gate, depending on wether there is still a 
>> frame
>> transmitting on TC0.
>> 
> After my change, user need to add a GCL at first: "sched-entry S 00 
> 12500".

Yes and this is not something we want here. Because it is the duty of
the hardware scheduler to be certain the gates aren't overrun.

> Before the change, your example need to be set as " sched-entry S 01
> 14500 sched-entry S 02 20000", TC0 is open for 2us, and TC1 is only
> open for 20us-12.5us.

We have to differentiate two things here:
  (1) with ALWAYS_GUARD_BAND_SCH_Q bit set, this example doesn't even
      work unless you also set MAXSDU to a smaller value. But this is
      expected here.
  (2) with "sched-entry S 01 14500 sched-entry S 02 20000", it is not
      correct that TC0 is only open for 2us, it is open for _up to_
      14.5us. With the current MAXSDU setting, the _beginning_ of the
      transmission has to be within 0us .. 2us. That is, if you send
      a 1518b frame starting at (relative offset) 1us, it will end
      at 13.5us.

> This also need to add guard band time for user.
> So if we do not have this patch, GCL entry will also have a different
> set with other devices.

I don't think so, because that is the expected behavior.

As already mentioned above, but I'll repeat it here: this patch breaks
the assumption that if a window is open for only 2us, only frames < 2us
can be sent. With this patch, the switch happily forwards max sized 
frames
which takes up to 12.5us (at gigabit) even if the gate is only open for
2us. Eg. the IXIA compliance suite has a dedicated test for it "Test
qbv.c.1.7 - Testing rejection of frame due to insufficient window time".

But I'd guess this should be common sense, that you cannot send a frame
bigger than the window.

>> > I checked other devices such as ENETC and it can calculate how long
>> > the frame transmission will take and determine whether to transmit
>> > before the gate is closed. The VSC9959 device does not have this
>> > hardware function. If we implement guard bands on each queue, we need
>> > to reserve a 12.5us guard band for each GCL, even if it only needs to
>> > send a small packet. This confuses customers.
>> 
>> How about getting it right and working on how we can set the MAXSDU 
>> per
>> queue and thus making the guard band smaller?
>> 
> Of course, if we can set maxSDU for each queue, then users can set the
> guard band of each queue. I added this patch to set the guard band by
> adding GCL, which is another way to make the guard band configurable
> for users. But there is no way to set per queue maxSDU now. Do you
> have any ideas on how to set the MAXSDU per queue?

I understand your problem, but this is not the way to go here, you can't
just change the schedule. Unless of course there might be switch for
the qdisc which enables/disables the guard band (and it is enabled by
default). I'd presume every solution will involve adding some parameters
to the taprio qdisc.

>> > actually, I'm not sure if this will violate the Qbv standard. I looked
>> > up the Qbv standard spec, and found it only introduce the guard band
>> > before protected window (Annex Q (informative)Traffic scheduling). It
>> > allows to design the schedule to accommodate the intended pattern of
>> > transmission without overrunning the next gate-close event for the
>> > traffic classes concerned.
>> 
>> Vladimir already quoted "IEEE 802.1Q-2018 clause 8.6.8.4". I didn't 
>> check it,
>> though.
>> 
>> A static guard band is one of the options you have to fulfill that.
>> Granted, it is not that efficient, but it is how the switch handles 
>> it.
>> 
> I'm still not sure if guard band is required for each queue. Maybe
> this patch need revert if it's required. Then there will be a fixed
> non-configurable guard band for each queue, and the user needs to
> calculate the guard band into gate opening time every time when
> designing a schedule. Maybe it's better to revert it and add MAXSDU
> per queue set.

See above.

-michael
