Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54B2D6BF7
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgLJXdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728530AbgLJXcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:32:10 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE7AC0613CF;
        Thu, 10 Dec 2020 15:31:30 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id f23so9846765ejk.2;
        Thu, 10 Dec 2020 15:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYfPUcduNm8XYKfPgn3cu8eCGF1sKHcURMBcPu0xAeY=;
        b=cQAZIGpY7MwXaxQ2MuPp1eZvLCjB55zPcV0iLUpLDv8ViIKz6ruML0IHgjMd1JUsGL
         CCJbgh2FxP5ByOAUZNl65a8ccjhYB0brXMcy1NMPKIab3BadkfmXq+NQlWQBTCAi/VuB
         oo5LMXaiCptxl1BUJoDdL4hYWcFZUZlRkzy8UEsUlyNndYhQM4b5xyF3PN//mt0rZ3bl
         21kP2kMgAPj9cMMzYmv0brNEVPbQalMza6XNceDBck02ySO6mEHtfHQw56JyQAvgrf9O
         /OeBm5l+8AR2/sg+Be7isqjDhEFZsXTYSGGoGogRESV1YH0kV+McQ0O6uX1WjQ5ZKmAZ
         KJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iYfPUcduNm8XYKfPgn3cu8eCGF1sKHcURMBcPu0xAeY=;
        b=Tg3QbhsBzJRZAuSJX9F0ONAYzZwAW+EmaKWG/QLZNk1su4Jacd7KQndyVueuV8ThH3
         CdSjdTFEq2lqD+t/5heCYxDmKBFQ12Z2XwPr5d1coM2WWRIW2QePuqpTz06K978mBLv8
         2kuZb/GYtWXbfL3CT1+J5TE7yf1d/h+B5nx9oBtiYL1o9zlIHQ8Q4aWk5HdGGXUipKBU
         d5rQOgWOt4O2D7s+iu4WqU7km0Ux8UBg+N9BxQPDBW+/m2pbYuj9OacW9fjGjuiVPXMK
         s46B6EnbVTe6O3LSsy84g0pkBgkjnxsT8mr3RECRFezPLZvsb4i4lwQgZEFgGFPowzOH
         IXzg==
X-Gm-Message-State: AOAM532CngeyB1GXE+9GKHZsLLpnaln9E91FH1Cdu4Nerf6BzSUkpoVl
        +ZYpWeaxT91W5KYwGqPCE4JWPK7gVeApcgfLn6Q=
X-Google-Smtp-Source: ABdhPJyNbPX0ySZNFFSoGmh5ujeh3M1oZ8YwszwG/CxOgKz0GjeB+jA8NOaauZcqxXU2aqSMMVAQJafw60CgC3oCe9k=
X-Received: by 2002:a17:906:52d9:: with SMTP id w25mr8359696ejn.504.1607643086725;
 Thu, 10 Dec 2020 15:31:26 -0800 (PST)
MIME-Version: 1.0
References: <20201209143707.13503-1-erez.geva.ext@siemens.com>
 <20201209143707.13503-2-erez.geva.ext@siemens.com> <CA+FuTScWkYn0Ur+aSuz1cREbQJO0fB6powOm8PFxze4v8JwBaw@mail.gmail.com>
 <VI1PR10MB244654C4B42E47DB5EBE0B05ABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CA+FuTSd7oB0qO707W6htvs=FOJn10cgSQ4_iGFz4Sk9URXtZiw@mail.gmail.com>
 <VI1PR10MB2446ACEACAE1F3671682407FABCC0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <CAF=yD-LkknU3GwJgG_OiMPFONZtO3ECHEX0QfTaUTTX_N0i-KA@mail.gmail.com> <VI1PR10MB24460D805E8091EB09F81199ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <VI1PR10MB24460D805E8091EB09F81199ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Dec 2020 18:30:50 -0500
Message-ID: <CAF=yD-Lf=JpkXvGs=AGtyhCEFcG_8_WgnNbg1cbGownohsHw8g@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
To:     "Geva, Erez" <erez.geva.ext@siemens.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Eyal Birger <eyal.birger@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Ogness <john.ogness@linutronix.de>,
        Jon Rosen <jrosen@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin KaFai Lau <kafai@fb.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrei Vagin <avagin@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Xie He <xie.he.0141@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladis Dronov <vdronov@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If I understand correctly, you are trying to achieve a single delivery time.
> > The need for two separate timestamps passed along is only because the
> > kernel is unable to do the time base conversion.
>
> Yes, a correct point.
>
> >
> > Else, ETF could program the qdisc watchdog in system time and later,
> > on dequeue, convert skb->tstamp to the h/w time base before
> > passing it to the device.
>
> Or the skb->tstamp is HW time-stamp and the ETF convert it to system clock based.
>
> >
> > It's still not entirely clear to me why the packet has to be held by
> > ETF initially first, if it is held until delivery time by hardware
> > later. But more on that below.
>
> Let plot a simple scenario.
> App A send a packet with time-stamp 100.
> After arrive a second packet from App B with time-stamp 90.
> Without ETF, the second packet will have to wait till the interface hardware send the first packet on 100.
> Making the second packet late by 10 + first packet send time.
> Obviously other "normal" packets are send to the non-ETF queue, though they do not block ETF packets
> The ETF delta is a barrier that the application have to send the packet before to ensure the packet do not tossed.

Got it. The assumption here is that devices are FIFO. That is not
necessarily the case, but I do not know whether it is in practice,
e.g., on the i210.

>
> >
> > So far, the use case sounds a bit narrow and the use of two timestamp
> > fields for a single delivery event a bit of a hack.
>
> The definition of a hack is up to you

Fair enough :) That wasn't very constructive feedback on my part.

> > And one that does impose a cost in the hot path of many workloads
> > by adding a field the ip cookie, cork and writing to (possibly cold)
> > skb_shinfo for every packet.
>
> Most packets do not use skb->tstamp either, probably the cost of testing is higher then just copying.
> But perhaps if we copy 2 time-stamp we can add a condition for both.
> What do you think?

I'd need to take a closer look at the skb_hwtstamps, which unlike
skb->tstamp lie in the skb_shared_data. If that is an otherwise cold
cacheline, then access would be expensive.

The ipcm and cork are admittedly cheap and not worth a branch. But
still it is good to understand that this situation of unsynchronized
clocks is a common operation condition for the foreseeable future, not
an unfortunate constraint of a single piece of hardware.

An extreme option would be moving everything behind a static_branch as
most hot paths will not have the feature enabled. But I'm not
seriously suggesting that for a few assignments.

> The cookie and the cork are just intermediate from application to SKB, I do not think they cost much.
> Both writes of time stamp to the cookie and the cork are conditioned.
>
> >
> >>>>> Indeed, we want pacing offload to work for existing applications.
> >>>>>
> >>>> As the conversion of the PHC and the system clock is dynamic over time.
> >>>> How do you propse to achive it?
> >>>
> >>> Can you elaborate on this concern?
> >>
> >> Using single time stamp have 3 possible solutions:
> >>
> >> 1. Current solution, synchronize the system clock and the PHC.
> >>      Application uses the system clock.
> >>      The ETF can use the system clock for ordering and pass the packet to the driver on time
> >>      The network interface hardware compare the time-stamp to the PHC.
> >>
> >> 2. The application convert the PHC time-stamp to system clock based.
> >>       The ETF works as solution 1
> >>       The network driver convert the system clock time-stamp back to PHC time-stamp.
> >>       This solution need a new Net-Link flag and modify the relevant network drivers.
> >>       Yet this solution have 2 problems:
> >>       * As applications today are not aware that system clock and PHC are not synchronized and
> >>          therefore do not perform any conversion, most of them only use the system clock.
> >>       * As the conversion in the network driver happens ~300 - 600 microseconds after
> >>          the application send the packet.
> >>          And as the PHC and system clock frequencies and offset can change during this period.
> >>          The conversion will produce a different PHC time-stamp from the application original time-stamp.
> >>          We require a precession of 1 nanoseconds of the PHC time-stamp.
> >>
> >> 3. The application uses PHC time-stamp for skb->tstamp
> >>      The ETF convert the  PHC time-stamp to system clock time-stamp.
> >>      This solution require implementations on supporting reading PHC clocks
> >>      from IRQ/kernel thread context in kernel space.
> >
> > ETF has to release the packet well in advance of the hardware
> > timestamp for the packet to arrive at the device on time. In practice
> > I would expect this delta parameter to be at least at usec timescale.
> > That gives some wiggle room with regard to s/w tstamp, at least.
>
> Yes, the author of the ETF uses a delta of 300 usec.
> The interface I use for testing, Intel I210 need around 100 usec to 150 usec.
> I believe it is related to PCIe speed of transferring the data on time and probably similar to other interfaces using PCIe.
> If you overflow the interface hardware with high traffic the delta is much higher.
> The clocks conversion error of the application is characteristic around ~1 usec to 5 usec for up to 10 ms sending a head.
>
> >
> > If changes in clock distance are relatively infrequent, could this
> > clock diff be a qdisc parameter, updated infrequently outside the
> > packet path?
>
> As the clocks are updating of both frequency and offset dynamically make it very hard to perform.
> The rate of the update of the PHC depends on PTP setting (usually around 1 second).
> The rate of the update of the system clock depends how you synchronize it ( I assume it is similar or slower).
> But user may require and use higher rates. It is only penalty by more traffic and CPU.
> Bare in mind the 2 clocks synchronization are independent, the cross can be unpredictable.
>
> The ETF would have to "know" on which packets we use the previous update and which are the last update.
> And hope we do not "miss" updates.
>
> And we would need a "service" to update these values with proper configuration, sound like overhead to me.

Ack. Thanks for the operating context. I didn't know these constraints
well enough. Agreed that this is not a very feasible approach then.

> Another point.
> The delta includes the PCIe DMA transfer speed, this is a hardware limitation.
> The idea of TSN is that the application send the packet as closer as possible to the hardware send.
> Increase the error of the clocks conversion defy the purpose of TSN.
>
> A more reasonable is to track the clocks inside the kernel.
> As we mention on solution 3.
>
> >
> > It would even be preferable if the qdisc and core stack could be
> > ignorant of such hardware clocks and the time base is converted by the
> > device driver when encoding skb->tstamp into the tx descriptor. Is the
> > device hardware clock readable by the driver?
>
> All drivers that support PTP (IEEE 1558) have to read the PHC.
> PTP is mandatory for TSN.
> But some drivers might be limited on which context they can read the PHC.
> This is a question to the vendors.
> For example Intel I210 allow reading the PHC.
>
> However the kernel POSIX layer uses application context lockings.
>
> >
> >  From the above, it sounds like this is not trivial.
>
> I am not sure if it so complicated.
> But as the Linux maintainers want to keep the Linux kernel with a single system clock.
> It might be more of a political question, or perhaps a better planning then I did.

This would seem the preferable option to me: use a kernel time base
throughout the stack and limit knowledge of the hardware clock to the
relevant hardware driver.

If that is infeasible, then I don't immediately see an alternative to
the current dual timestamp field variant, either.

> >
> > I don't know which exact device you're targeting. Is it an in-tree driver?
>
> ETF uses ethernet interfaces with IEEE 1558 and 802.1Qbv or 802.1Qbu.
> Interfaces that support TSN, https://en.wikipedia.org/wiki/Time-Sensitive_Networking
> I use Intel I210 at the moment.
> As of 5.10-rc6, there are 4 drivers
> kernel-etf/drivers/net/ethernet (etf-5.10-rc6)$ find -name '*.c' | xargs grep -r TC_SETUP_QDISC_ETF
> ./freescale/enetc/enetc.c:              case TC_SETUP_QDISC_ETF:
> ./stmicro/stmmac/stmmac_main.c: case TC_SETUP_QDISC_ETF:
> ./intel/igc/igc_main.c:                 case TC_SETUP_QDISC_ETF:
> ./intel/igb/igb_main.c:                 case TC_SETUP_QDISC_ETF:
> There are more vendors like
>   Renesas that have a driver for the RZ-G SOC.
>   Broadcom have chips that support TSN, but they do not publish the code.
> I believe that other vendors will add TSN support as it becomes more popular.

Very clear. Thanks.

> >
> >> Just for clarification:
> >> ETF as all Net-Link, only uses system clock (the TAI)
> >> The network interface hardware only uses the PHC.
> >> Nor Net-Link neither the driver perform any conversions.
> >> The Kernel does not provide and clock conversion beside system clock.
> >> Linux kernel is a single clock system.
> >>
> >>>
> >>> The simplest solution for offloading pacing would be to interpret
> >>> skb->tstamp either for software pacing, or skip software pacing if the
> >>> device advertises a NETIF_F hardware pacing feature.
> >>
> >> That will defy the purpose of ETF.
> >> ETF exist for ordering packets.
> >> Why should the device driver defer it?
> >> Simply do not use the QDISC for this interface.
> >
> > ETF queues packets until their delivery time is reached. It does not
> > order for any other reason than to calculate the next qdisc watchdog
> > event, really.
>
> No, ETF also order the packets on .enqueue = etf_enqueue_timesortedlist()
> Our patch suggest to order them by hardware time stamp.
> And leave the watchdog setting using skb->tstamp that hold system clock TAI time-stamp.
>
> >
> > If h/w can do the same and the driver can convert skb->tstamp to the
> > right timebase, indeed no qdisc is needed for pacing. But there may be
> > a need for selective h/w offload if h/w has additional constraints,
> > such as on the number of packets outstanding or time horizon.
>
> The driver do not order the packets, it send packets in the order of arrival.
> We can add ETF component to each relevant driver, but do we want to add Net-Link features to drivers?
> I think the purpose is to make the drivers as small as possible and leave common intelligence in the Net-Link layer.

I was thinking of devices that implement ETF in hardware for full
pacing hardware offload. Not in the driver.

> >
> >>>
> >>> Clockbase is an issue. The device driver may have to convert to
> >>> whatever format the device expects when copying skb->tstamp in the
> >>> device tx descriptor.
> >>
> >> We do hope our definition is clear.
> >> In the current kernel skb->tstamp uses system clock.
> >> The hardware time-stamp is PHC based, as it is used today for PTP two steps.
> >> We only propose to use the same hardware time-stamp.
> >>
> >> Passing the hardware time-stamp to the skb->tstamp might seems a bit tricky
> >> The gaol is the leave the driver unaware to whether we
> >> * Synchronizing the PHC and system clock
> >> * The ETF pass the hardware time-stamp to skb->tstamp
> >> Only the applications and the ETF are aware.
> >> The application can detect by checking the ETF flag.
> >> The ETF flags are part of the network administration.
> >> That also configure the PTP and the system clock synchronization.
> >>
> >>>
> >>>>
> >>>>> It only requires that pacing qdiscs, both sch_etf and sch_fq,
> >>>>> optionally skip queuing in their .enqueue callback and instead allow
> >>>>> the skb to pass to the device driver as is, with skb->tstamp set. Only
> >>>>> to devices that advertise support for h/w pacing offload.
> >>>>>
> >>>> I did not use "Fair Queue traffic policing".
> >>>> As for ETF, it is all about ordering packets from different applications.
> >>>> How can we achive it with skiping queuing?
> >>>> Could you elaborate on this point?
> >>>
> >>> The qdisc can only defer pacing to hardware if hardware can ensure the
> >>> same invariants on ordering, of course.
> >>
> >> Yes, this is why we suggest ETF order packets using the hardware time-stamp.
> >> And pass the packet based on system time.
> >> So ETF query the system clock only and not the PHC.
> >
> > On which note: with this patch set all applications have to agree to
> > use h/w time base in etf_enqueue_timesortedlist. In practice that
> > makes this h/w mode a qdisc used by a single process?
>
> A single process theoretically does not need ETF, just set the skb-> tstamp and use a pass through queue.
> However the only way now to set TC_SETUP_QDISC_ETF in the driver is using ETF.

Yes, and I'd like to eventually get rid of this constraint.


> The ETF QDISC is per network interface.
> So all application that uses a single network interface have to comply to the QDISC configuration.
> Sound like any other new feature in the NetLink.
>
> Theoretically a single network interface could participate in 2 TSN/PTP domains.
> In that case you can create one QDISC without "use hardware time-stamp" for first TSN/PTP domain and synchronize the PHC to system clock.
> And use the second one with a QDISC that use hardware time-stamp.
> You will need a driver/hardware that support multiple PHCs.
> The separation of the domains could be using VLANs.
>
> Note: A TSN domain is bound to a PTP domain.
>
> >
> >>>
> >>> Btw: this is quite a long list of CC:s
> >>>
> >> I need to update my company colleagues as well as the Linux group.
> >
> > Of course. But even ignoring that this is still quite a large list (> 40).
> >
> > My response yesterday was actually blocked as a result ;) Retrying now.
> >
>
> I left 5 people from Siemens, I hope it improves.
>
>
> Thanks for your comments and enlightenments, they are very useful
>    Erez
