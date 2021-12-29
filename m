Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD2481719
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 22:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhL2ViY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 16:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhL2ViX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 16:38:23 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6C0C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 13:38:23 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id o2so12712832vkn.0
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 13:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fq2x58hT4Q+K2NWoqGsrO4sJzuJrd8oVEc9hnDVJrrI=;
        b=qN8a21hhVLnOXfvRan29H6yBOFjtUzc/bBnWLK+LQuFaFfanR1AbD3Q21jwmCQdzCm
         SsZE953C9HW855bPj6zNgteqyezVFklL8jrS0U1LKuo/VOn/PIilakiSxW/7Th4Cj9P9
         olHbWY6gfA/+PeI1+YYvVOm6Ax81B0uTgI8rLgVpd402tuAc3OEaqbpcGF5I10FAxhmX
         +RTTI+T+/3ZkAXJVjEyLAJbyo1zGF+x/1R5IuK/di/vUzIDXD3tVzz6Ek99PMF8Jqv9O
         4GNkfo9laigVNnJAFnJMmSC9VThl7yoMvBL+lK7KEaX9w47EO5cK+tK5rkAExffNdaQi
         +pVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fq2x58hT4Q+K2NWoqGsrO4sJzuJrd8oVEc9hnDVJrrI=;
        b=I6vUOxPQfgcey+Blkngyz3ZzpeDutFwLWy4P8+eYeewVyObAbKcwcfZ9YvgkEf7gVd
         cj6TxJqzAlyB59y1m7ZBddsG7qqJlGrQtgYAzmx4XDz7W5jKM3ym85rTTaITf5b76tud
         ZBHB3vNV1tt+S4o84bVxW0wOAHzgVbKpscdYMWUx5b/ywQ7HopGFzE05XDosg4DumN7M
         dGN4ZHeF8TcABgkDwAa0De44TDz6JRPOIXpuTm2RODrMa1kUJYI1/nOkRuWJe/SAFSxG
         XmXEmNUVjhl3A/L7idMs5By0h+OBQnAz2hOm8OhQFB0JGWzO4gc9Fyl1V+I5wR/5fm2Q
         gMdA==
X-Gm-Message-State: AOAM5303OyMxyjOc+VW35T/jf34jCiIbrPYAcdOzv2f7MIraHNdIDYL3
        V1Q6+6JHwUoAtypc46Tu/FCYrMZvk/aWNmVUUZfSsg==
X-Google-Smtp-Source: ABdhPJwpvBUW7HxqhIaJTjSM4MHjTquSHeGScyW8gh0zMwm6QK53r8IKi3btgB+JSPisbrthQDCS2Xxo28UTV1g4dmo=
X-Received: by 2002:a05:6122:7c6:: with SMTP id l6mr9413664vkr.20.1640813901950;
 Wed, 29 Dec 2021 13:38:21 -0800 (PST)
MIME-Version: 1.0
References: <CANr-f5x0_RDAfVQiqpcWOG2iVAtson0F6arQMSbrBXjB73kw+A@mail.gmail.com>
 <87bl1150rj.fsf@intel.com>
In-Reply-To: <87bl1150rj.fsf@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 29 Dec 2021 22:38:10 +0100
Message-ID: <CANr-f5xtGh_gChnbvWxeUFxk5txEPB5bujvU9bP0ayHc4cgCkA@mail.gmail.com>
Subject: Re: RFC: tsnep: ETF, AF_XDP, UIO or driver specific interface for real-time
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn@kernel.org,
        magnus.karlsson@intel.com, gregkh@linuxfoundation.org,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 8:03 PM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi Gerhard,
>
> Gerhard Engleder <gerhard@engleder-embedded.com> writes:
>
> > Hello,
> >
> > the driver for my FPGA based TSN endpoint Ethernet MAC is now in net-next. As
> > a first step, it supports a single TX/RX queue pair for normal Ethernet
> > communication. For TSN it supports hardware timestamps (PTP) and TAPRIO (gate
> > control). The next step is the user space interface for real-time communication
> > over additional TX/RX queue pairs.
> >
> > Multiple interfaces are used for real-time communication in user space:
> > A) ETF for timed transmit
> > B) AF_XDP for direct access omitting the network stack
> > C) UIO for mapping devices to user space
> > D) driver specific interfaces for direct access to DMA buffers and IO memory
> >    (out of tree)
> >
> > The additional TX/RX queue pairs of my Ethernet MAC are optimized for real-time
> > communication. The mapping to ETF or AF_XDP is not straightforward. I know a
> > little about UIO and ETF and I have read Documentation/networking/af_xdp.rst,
> > but that does not qualify me as an expert. So I want to discuss if ETF, AF_XDP,
> > UIO or any other standard Linux user space interface is the right choice for my
> > driver?
> >
> > First I want to describe the main real-time feature of the device, the periodic
> > TX schedule:
> >
> > The data exchange between hardware and software is done similarly to other
> > Ethernet MACs. Descriptor rings are used and the ownership of descriptors
> > is transferred from software to hardware and vice versa during operation.
> >
> > Usually TX descriptor rings are queues, which transfer data from RAM to
> > Ethernet MAC as fast as possible. This is the case for the first TX/RX queue
> > pair, which is used by the Ethernet driver. For real-time communication
> > transmission at defined points in time is a requirement. Additionally, the
> > transmitted data shall be as up-to-data as possible. Therefore, the data shall
> > be transferred to the Ethernet MAC as late as possible. This enables minimal
> > reaction time for closed loop control. So there are actually two points in time.
> > First, the start of the DMA transfer of data from RAM to Ethernet MAC. Second,
> > the start of the transmission over Ethernet.
> >
> > Therefore, the TX descriptor ring of additional TX/RX queue pairs is enhanced
> > with timing information. This timing information defines both points in time.
> > As a result, the TX descriptor ring is processed at defined points in time and
> > not as fast as possible.
> >
> > Real-time communication is usually periodic. The timing pattern repeats after
> > the least common multiple of all cycle times. The relative timing information
> > of two consecutive TX descriptors is constant. So relative timing information
> > is used within the TX descriptor ring. There is no need to update this relative
> > timing information during operation. Only transmitted data and ownership must
> > be updated. The TAPRIO gate control list is good example for a periodic
> > schedule.
> >
> > The periodic nature of real-time communication has another side effect. The
> > timing is known in advance. So a TX descriptor is able to define the timing of
> > the next TX descriptor. As a result, the hardware knows the timing of the next
> > TX descriptor without fetching it from RAM. This prevents a chicken egg problem:
> > the TX descriptor cannot define its own DMA timing, because DMA would be needed
> > to read this timing.
> >
> > All these properties lead to a periodic TX schedule implemented with an
> > enhanced TX descriptor ring. Let's describe the details with an example:
> >
> > - two cycle times
> >   - single Ethernet frame every 100us, first TX at absolute time 7000us
> >     - TX times: 7000us, 7100us, 7200us, ...
> >   - single Ethernet frame every 200us, first TX at absolute time 7050us
> >     - TX times: 7050us, 7250us, 7450us, ...
> > - DMA shall be done as late as possible for 100us cycle time
> > - DMA of 200us cycle time shall be done directly after DMA of 100us cycle time
> >
> > The perdiodic TX schedule for this example looks like this:
> >
> > +-------------<-------------------------<-------------------------<------------+
> > |                                                                              |
> > +-->+-------------------+---->+-------------------+---->+-------------------+->+
> >     | TX desc 1 @0x1000 |     | TX desc 2 @0x2000 |     | TX desc 3 @0x3000 |
> >     |                   |     |                   |     |                   |
> >     | next_desc=0x2000  |     | next_desc=0x3000  |     | next_desc=0x1000  |
> >     | dma_incr=10us     |     | dma_incr=90us     |     | dma_incr=100us    |
> >     | tx_incr=50us      |     | tx_incr=50us      |     | tx_incr=100us     |
> >     +-------------------+     +-------------------+     +-------------------+
> >
> > "next_desc" is the address of the next TX descriptor. "dma_incr" defines the
> > DMA start time of the next TX descriptor:
> >
> > "DMA start time" = "Current DMA start time" + dma_incr
> >
> > Similar "tx_incr" defines the Ethernet TX start time of the next TX descriptor:
> >
> > "Ethernet TX start time" = "Current Ethernet TX start time" + tx_incr
> >
> > The TX descriptor processing needs initial values for the address of the first
> > descriptor, the DMA start time of the first descriptor, and the Ethernet TX
> > start time of the first descriptor. These initial values are written to
> > registers:
> >
> > - "TX descriptor address" register  = 0x1000
> > - "DMA start time" register         =   6980us
> > - "Ethernet TX start time" register =   7000us
> >
> > These three registers always hold information about the next TX descriptor. The
> > location in the RAM, the point it time when it shall be read by DMA, the point
> > in time when it shall be transmitted.
> >
> > The least common multiple of the cycle times is 200us. Thus, the sum of all
> > "tx_incr" values must be 200us. Also the sum of all "dma_incr" values must be
> > 200us. Otherwise DMA and TX timing would drift away from each other.
> >
> > TX descriptors 1 and 3 belong to the 100us cycle time. TX descriptor 2
> > belongs to
> > the 200us cycle time. The TX schedule is processed in the following steps:
> >
> >               cycle time | DMA read | Ethernet TX
> > 1) TX desc 1       100us |  @6980us |     @7000us
> > 2) TX desc 2       200us |  @6990us |     @7050us
> > 3) TX desc 3       100us |  @7080us |     @7100us
> > 4) TX desc 1       100us |  @7180us |     @7200us
> > 5) TX desc 2       200us |  @7190us |     @7250us
> > 6) TX desc 3       100us |  @7280us |     @7300us
> > 7) TX desc 1       100us |  @7380us |     @7400us
> > 8) TX desc 2       200us |  @7390us |     @7450us
> > 9) TX desc 3       100us |  @7480us |     @7500us
> > ...
> >
> > First DMA read is done at 6980us. This point in time is defined with the initial
> > value of the "DMA start time" register. The following DMA reads are
> > determined by
> > the "dma_incr" values of the TX descriptors. Every DMA read is started before
> > the Ethernet TX.
> >
> > First Ethernet TX is done at 7000us. This point in time is defined with the
> > initial value of the "Ethernet TX start time" register. The following Ethernet
> > TX times are determined by the "tx_incr" values of the TX descriptors.
> >
> > So the periodic TX schedule actually contains two schedules. One for DMA read
> > and another one for Ethernet TX. As a result, the timing of DMA and Ethernet TX
> > can be optimized independently from each other. The only restriction is that
> > DMA has to be done before the corresponding Ethernet TX.
>
> At the risk of repeating what you said, here's what I could gather that
> you would need.
>
>  1. Exclusive access of one application (or closely cooperating group of
>     applications) to one TX ring;
>  2. Direct access to the device DMA mapped memory;
>  3. A way to configure the {DMA,TX} start times and the {DMA,TX}
>     increments;

Yes, that's a good summary.

> > This periodic TX schedule has been used in a similar way for the
> > EtherCAT fieldbus
> > for nearly 10 years with positive experience. So for OPC UA Pub/Sub TSN it
> > shall be used again.
> >
> > This periodic TX schedule does not fit to ETF, because ETF uses absolute time
> > stamps and the timing is not known in advance. Additionally, the intention of
> > the periodic TX schedule is that the real-time application writes the data
> > directly to the TX descriptor ring. AF_XDP has a similar direction, but does
> > not support any TX timing.
>
> That's the magic of AF_XDP, as it is only a data path abstraction, you
> can move the control path somewhere else. One idea below.

I assume you mean control path stuff like ethtool flow-type ether.

> > I have no knowledge about any other Ethernet MAC which supports timed TX in
> > a similar way like this device.
> >
> > Currently a simple device/driver specific interface is used. Similar to UIO it
> > supports the mapping of registers of TX/RX queue pairs to user space. Every
> > additional TX/RX queue pair has its own register set within a separate 4kB
> > IO-memory. Thus, only the register sets of the additional TX/RX queue pairs are
> > mapped to user space. Every TX/RX queue pair is more less a separate device,
> > which can be operated independent of any other TX/RX queue pair. Additionally,
> > this device/driver specific interface supports the mapping of DMA buffers.
> >
> > A similar approach has been used for years for the periodic TX schedule in
> > combination with the EtherCAT fieldbus (out of tree driver). The main advantage
> > of this approach is that no hard or soft IRQs are needed for operation. There is
> > no need to increase to priority of soft IRQs, which can lead to real-time
> > problems.
> >
> > Which user space interface shall be used for this periodic TX schedule? Is
> > ETF or XDP an option? Shall UIO be used like for other real-time controllers?
> > Is a device/driver specific interface the way to go, because no other Ethernet
> > MAC has an interface like this?
>
> I think that AF_XDP (with zero copy) already has everything you need for
> the data plane, (1) and (2) above.

I'm not sure. AF_XDP ring size is a power of 2, but in my case the
ring size is the
number of Ethernet frames within the least common multiple of all cycle times.
Also AF_XDP works like a FIFO, the Ethernet frames are transmitted one after the
other. In my case every Ethernet frame has to be placed at a certain
position in the
TX ring. This can be done at any time before the transmission and does
not need to
match the transmission order.
To be able to put the Ethernet frame at the right position in the TX
ring additional
information is required. Otherwise, the transmission time cannot be
determined. At
least some reference to the control plane (3) data is needed.

> So what's seems to be really missing is the control plane, (3).

At least for static timing information moving the timing information
like {DMA,TX}
start times and the {DMA,TX} increments out of the data plane should
be possible.
For runtime changes, e.g. add/remove Ethernet frames to/from TX schedule during
operation, I'm not so sure, because data and control is tied together
in the TX descriptor.

> What I would do is something like this, I would add a few debugfs
> entries to the driver allowing me to configure the "extra" per ring
> parameters. This also gives some chance to see what is best format for
> communicating those parameters to the driver.
>
> With that I could see if something is not quite working from the AF_XDP
> side, fix those (I think the community will have some interest in having
> these cases fixed) while discussing where is the best place to put those
> configuration knobs. My first shot would be ethtool.

Is it a possible future goal of AF_XDP to enable TX/RX of Ethernet
frames without
any kernel mode interactions? E.g. a hardware implementation of the AF_XDP
interface, or some VDSO code for descriptor ring handling?

> > I'm looking forward to your comments.
> >
> > Gerhard
>
> Cheers,
> --
> Vinicius
