Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0625847F8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiG1WKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiG1WKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:10:04 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3453925598
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:10:02 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ef5380669cso33426927b3.9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m+5dQUsOH9zLDjonJIw+XExCKojB/7gm9Q+lHfpASII=;
        b=io4UOaegywMntg+jQQOHQ0G7pl+OsugyW+9v1m5LezzEZMdXoSzF+frhqPE56eqI7v
         XO8iOW4hxEmXX4mcTLIbwCKf/ANG0fwDG6b18DBE5Ynu+F7GsnFxWqG+Su9R9n6+/CoQ
         y4Yc1FX9mPPV3EiMi88qdwnx+f5A7SqtSH5bYAnoGsmwHpiYpcSiATPc4aIeYpz8/mMK
         Pnr040URoZAj4wq5yX4qurvFYqSBNvov+KfzC/RPHDvV782FudDVsqD34P/alSS3X6l6
         PnKHoE8pHYHoSfC0UWvHwoQoW8IWSvEy5EtB5XKAhP/OXgSXs7LRq6R7cRtDLCTDJsWC
         dd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m+5dQUsOH9zLDjonJIw+XExCKojB/7gm9Q+lHfpASII=;
        b=TAmmIkg+KA13iqiZVmKZsXp0anWuhRlIMCavJH4EB4kZLkV4s5NTddhC2ZWh2cCaHP
         az+1xbiIie2OxJ5mNpHGew9U9V8u9chTdQ9X1lXrgwe7iZ3eb/eLzypL20Vky+OA1K2s
         E5ka0vtGxTk3TZmzZdlrvctsuNRXuFtXpzMEXAVAXp3GL9HDaxs2S6VKNAU39Qdo51GT
         d8rOFgq1sgTvzINQfYFonbExv1V0oipCUlKD2eIyzts0xI2giorN9rKeKSyzEKJGEtew
         SXtNs/al+Lq+saA3I+f2KYcOqsrbfHC74A1rrZy9zphr+J9IuwUfWJLRrgUGMlLh7rXr
         6Ggw==
X-Gm-Message-State: ACgBeo1Loqj0LpytSCY2PIATHEZ3gsThl/zQ2+/pPbKvnYeIifEgjXli
        iwJwdnksrNQOXaNlNw0RQI+W/JfPTKJHwFu9BWrdUY0effc=
X-Google-Smtp-Source: AA6agR4ZfBHpCGqeNy2MF9IFPThhPh6K3z/ymls2nKNav0TyUvlsu+1neSnW4IBpLONvBzrFFfAV7d7KVFoZPVj4AZE=
X-Received: by 2002:a81:1595:0:b0:31f:420f:abe5 with SMTP id
 143-20020a811595000000b0031f420fabe5mr759820ywv.15.1659046201165; Thu, 28 Jul
 2022 15:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf>
In-Reply-To: <20220727224409.jhdw3hqfta4eg4pi@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 29 Jul 2022 00:09:50 +0200
Message-ID: <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thu, Jul 28, 2022 at 12:44 AM Vladimir Oltean <olteanv@gmail.com> wrote:
[...]
> > I am starting with
> > tools/testing/selftests/drivers/net/dsa/local_termination.sh as my
> > understanding is that this contains the most basic tests and should be
> > the first step.
>
> I don't think I've said local_termination.sh contains the most basic
> tests. Some tests are basic, but not all are.
noted, thanks for clarifying this

[...]
> So the absolute first step would be to control the bridge port flags
> (BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD) and start
> with good defaults for standalone mode (also set skb->offload_fwd_mark
> when appropriate in the tagging protocol driver). I think you can use
> bridge_vlan_aware.sh and bridge_vlan_unaware.sh as starting points to
> check that these flags still work fine after you've offloaded them to
> hardware.
My understanding of "good defaults" is:
- disable learning on all ports
- disable unicast flooding on all ports
- enable broadcast flooding on all ports
- (GSWIP can only enable broadcast and multicast at the same time, so
that's enabled too)

I think skb->offload_fwd_mark needs to be set unless we know that the
hardware wasn't able to forward the frame/packet.
In the vendor sources I was able to find the whole RX tag structure: [0]
I am not sure about the "mirror" bit (I assume this is: packet was
received on this port because this port is configured as a mirroring
target). All other bits seem irrelevant for skb->offload_fwd_mark -
meaning we always have to set skb->offload_fwd_mark.

I have lots of failures in bridge_vlan_aware.sh and
bridge_vlan_unaware.sh - even before any of my changes - which I'll
need to investigate.

> When flooding a packet to find its destination can be achieved without
> involving the CPU (*), the next thing will be to simply disable flooding
> packets of all kind to the CPU (except broadcast). That's when you'll
> enjoy watching how all the local_termination.sh selftests fail, and
> you'll be making them pass again, one by one.
it's called test driven development :-)

> >
> > Full local_termination.sh selftest output:
> > TEST: lan2: Unicast IPv4 to primary MAC address                 [ OK ]
>
> For this to pass, the driver must properly respond to a port_fdb_add()
> on the CPU port, with the MAC address of the $swp1 user port's net device,
> offloaded in the DSA_DB_PORT corresponding to $swp1.
>
> In turn, for DSA to even consider passing you FDB entries in DSA_DB_PORT,
> you must make dsa_switch_supports_uc_filtering() return true.
>
> (if you don't know what the words here mean, I've updated the documentation at
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/Documentation/networking/dsa/dsa.rst)
Three out of four cases for the FDB isolation code are clear to me:
- the DSA_DB_BRIDGE case is easy as this is basically what we had
implemented before and I "just" need to look up the FID based on
db.bridge.dev
- DSA_DB_PORT for a non-CPU/user port: we should use the same FID as
standalone ("single port bridge") ports use (that's port number + 1;
see gswip_add_single_port_br())
- GSWIP doesn't support DSA_DB_LAG currently, so I can handle this
with -EOPNOTSUPP

One case took me a while to figure out but I think I finally
understood it (and now it's clear why the FDB patch I sent earlier
cannot be upstreamed):
- DSA_DB_PORT for the CPU port: the port argument for port_fdb_add is
the CPU port - but we can't map this to a FID (those are always tied
to either a bridge or a user port). So instead I need to look at db.dp
and for example use it's index for getting the FID (for standalone
ports the FID is: port index + 1). That results in: we're requested to
install the CPU ports MAC address on the CPU port (6), but what we
actually do is install the FDB entry with the CPU port's MAC address
on a user port (let's say 4, which we get from db.dp). Now if a
packet/frame should target the CPU port we don't need flooding because
the switch knows the destination port based on the FDB entry we
installed.

Note to myself: I'll also need to look at
assisted_learning_on_cpu_port when I'm at the point where I can do
optimizations (rather than fixing failing tests).

[...]
> Nobody will call port_fdb_add() for the address tested here.
>
> > TEST: lan2: Unicast IPv4 to unknown MAC address, promisc        [ OK ]
>
> Now this passes because the expectation of promiscuous ports is to
> receive all packets regardless of MAC DA, that's the definition of
> promiscuity. The driver currently already floods to the CPU, so why
> wouldn't this pass.
>
> Here, what we actually want to capture is that dsa_slave_manage_host_flood(),
> which responds to changes in the IFF_PROMISC flag on a user port, does
> actually notify the driver via a call to port_set_host_flood() for that
> user port. Through this method, the driver is responsible for turning
> flooding towards the CPU port(s) on or off, from the user port given as
> argument. If CPU flood control does not depend on user port, then you'll
> have to keep CPU flooding enabled as long as any user port wants it.
Thanks for this hint. Indeed, I need to implement it like you did in
felix_port_set_host_flood() because GSWIP can only enable/disable
flooding to the CPU port globally - it can't configure this based on
the source port.

[...]
> > TEST: lan2: Multicast IPv6 to unknown group                     [FAIL]
> >         reception succeeded, but should have failed
> > TEST: lan2: Multicast IPv6 to unknown group, promisc            [ OK ]
> > TEST: lan2: Multicast IPv6 to unknown group, allmulti           [ OK ]
> > TEST: br0: Unicast IPv4 to primary MAC address                  [ OK ]
>
> Here is where things get interesting. I'm going to take a pause and
> explain that the bridge related selftests fail in the same way for me
> too, and that the fixes should go to the bridge driver rather than to
> DSA.
oh, that's good to know - thanks for sharing this info!

[...]
> > TEST: br0: Unicast IPv4 to unknown MAC address                  [FAIL]
> >         reception succeeded, but should have failed
> > TEST: br0: Unicast IPv4 to unknown MAC address, promisc         [ OK ]
> > TEST: br0: Unicast IPv4 to unknown MAC address, allmulti        [FAIL]
> >         reception succeeded, but should have failed
> > TEST: br0: Multicast IPv4 to joined group                       [ OK ]
>
> Just one more small comment to make.
> The addresses in the "br0" tests are also notified through port_mdb_add(),
> but they use DSA_DB_BRIDGE since they come to DSA via switchdev rather
> than via dev_mc_add() - they came _to_the_bridge_ via dev_mc_add().
> DSA drivers are expect to offload these multicast entries to a different
> database than the port_mdb_add() I've described above. This is a
> database that is active only while $swp1 is part of a bridge, while
> DSA_DB_PORT is active only while $swp1 is standalone.
The vendor driver lists a bunch of possible tables: [1]
I'll leave any effort for multicast out for now... it's not the main
use-case I am looking at right now.

As always: thank you for your amazing explanations, hints and pointers!
Also I would like to point out that I am still doing all of this in my
spare time. Whenever you have other conversations to focus on: please
do so! For me it's not critical if you're getting back to me a few
days sooner or later.


Best regards,
Martin


[0] https://github.com/paldier/K3C/blob/ca7353eb397090c363632409d9ca568d3cca09c7/ugw/target/linux/lantiq/patches-3.10/7000-NET-lantiq-adds-eth-drv.patch#L2238-L2259
[1] https://github.com/paldier/K3C/blob/ca7353eb397090c363632409d9ca568d3cca09c7/ugw/target/linux/lantiq/files/drivers/net/ethernet/lantiq/switch-api/ltq_flow_core.h#L164-L192
