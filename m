Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90CC5848DC
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 02:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiG2AFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 20:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiG2AFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 20:05:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1844F19F
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 17:05:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b11so5715209eju.10
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 17:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9uuqCmvKq6BNwZ2d8gPoiDsXhA6Vw0TYGoV9mpf1z8Q=;
        b=cEZV1c88XUZU1N7/kpf38A2266EFH6nLh3KZXU3N1Hk2ejjCKRcExXZH47Nojf/Z7e
         ugpIUODvGuQO9ySR+JWtSQuKDM4YFkha7Fdl8sqWiHVY4VQnAta5kFGOgfCx5RNxEncR
         GKP5S34SkNOKZIc7jR+VJqmqsvDC/7EVFxvsl9xLoLIbRuDrXKbNu2cwEb7LZQdguBYF
         0ug2P5m27QMiZSSHsh3J9dlivdAuJxhRbVkmn79Do8byWWXnslHxL1NP0Kse6zkvFRXE
         blcyZXiDTu1Fuqs4oALYaBI3zErrlYbpdRfZJUYsKbcHJqFV18I/87qS78EIlKsc/rv0
         D0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9uuqCmvKq6BNwZ2d8gPoiDsXhA6Vw0TYGoV9mpf1z8Q=;
        b=EKknjv3fAN0SpP7COzl8uvi2VGQFGLflY+TngeCpKTRft/Nyo1bHVgugo4WaCGZRMV
         paJKTw0WcLxabyIlniqdhdRU/UhGKRGZKWam4Z+HLZ91hsl95cjOz94oIAhtclYSYTJ4
         3x4nFj62zNOgU8b+ukCa0DTHLoYOikGq5LoOa2tB4HsyK/ZGtJHSScbbdN1BVe+H1GIm
         a5Hg8X/fIqD+jMlkrUBTSkWoMuCIXAFLV4SdozwS4aKK/yRePIs8uMtNwMqy/7/0v8sX
         fO1eevRh5DQgjIFtoLfG/xVHDjwn9O/5JLbDMa4WPlVGYO1rcHylx0FsqqPZ1iHfAu9L
         CikQ==
X-Gm-Message-State: AJIora+TlsVFNH9aoR1aaFXLBzgCiY0viyOfKBv6RnsJZVMwQzNRIWhd
        WAMBJfjMWh5bqCoSftSxhfFOuQ3BLA10Fw==
X-Google-Smtp-Source: AGRyM1voHQPKvmQeTYsoOUFIbdeBAyMtJWjmMpqY2RhiMeQMYM0fQJhSeTuNNTnhQzNadDAjwUhyUw==
X-Received: by 2002:a17:907:7d8b:b0:72f:2306:329a with SMTP id oz11-20020a1709077d8b00b0072f2306329amr899137ejc.369.1659053139267;
        Thu, 28 Jul 2022 17:05:39 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906200900b006fe8a4ec62fsm947888ejo.4.2022.07.28.17.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 17:05:38 -0700 (PDT)
Date:   Fri, 29 Jul 2022 03:05:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
Message-ID: <20220729000536.hetgdvufplearurq@skbuf>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf>
 <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 12:09:50AM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
> 
> On Thu, Jul 28, 2022 at 12:44 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> [...]
> > > I am starting with
> > > tools/testing/selftests/drivers/net/dsa/local_termination.sh as my
> > > understanding is that this contains the most basic tests and should be
> > > the first step.
> >
> > I don't think I've said local_termination.sh contains the most basic
> > tests. Some tests are basic, but not all are.
> noted, thanks for clarifying this
> 
> [...]
> > So the absolute first step would be to control the bridge port flags
> > (BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD) and start
> > with good defaults for standalone mode (also set skb->offload_fwd_mark
> > when appropriate in the tagging protocol driver). I think you can use
> > bridge_vlan_aware.sh and bridge_vlan_unaware.sh as starting points to
> > check that these flags still work fine after you've offloaded them to
> > hardware.
> My understanding of "good defaults" is:
> - disable learning on all ports

Yes, here's just one other example of what can go wrong if it's enabled
on standalone ports, if you need to see it:
https://lore.kernel.org/netdev/20220727233249.fpn7gyivnkdg5uhe@skbuf/T/#m2e27a5385f70ee3440ee7f6250aaafdbfdc7446b

Essentially every time when there's a chance that the switch will
receive on one port what another port has sent, learning will be a
problem. This is why it's also problematic for the selftests - because
we intentionally put 2 pairs of ports in loopback.

> - disable unicast flooding on all ports

I am having trouble saying 'yes' or 'no' to this because I don't know
exactly what you mean. By flooding a packet, I understand "if its MAC DA
is unknown to the FDB, deliver it to this set of ports". But flooding,
like learning, is essentially a bridging service concept, so it applies
only to packets coming from a particular bridging domain. In the case of
a standalone port, packets come only from the CPU, via the control
plane. Depending how the hardware is constructed, when you inject a
packet to a port, maybe there won't be any ifs or buts and the switch
will just deliver it there (I call this behavior: "control packets
bypass FDB lookup", or "CPU is in god mode"). So maybe it doesn't matter
whether unicast flooding is enabled on all standalone ports or not, as
long as the macroscopically expected behavior can be observed: if
software xmits a packet to a port, the packet gets delivered regardless
of MAC DA.

> - enable broadcast flooding on all ports

Here I don't understand, why unicast no but broadcast yes? Flooding is
an egress setting, at least in the terminology from 'man bridge'
("Controls whether unicast traffic for which there is no FDB entry will
be flooded towards this given port.")

The same thing applies as for unicast flooding above: maybe it doesn't
matter.

> - (GSWIP can only enable broadcast and multicast at the same time, so
> that's enabled too)

I think the GSWIP would not be the only one in that category. The
mv88e6xxx driver puts the ff:ff:ff:ff:ff:ff address in the FDB and that
controls broadcast flooding, while the single knob that you mention
controls what's left - i.e. multicast.

> I think skb->offload_fwd_mark needs to be set unless we know that the
> hardware wasn't able to forward the frame/packet.
> In the vendor sources I was able to find the whole RX tag structure: [0]
> I am not sure about the "mirror" bit (I assume this is: packet was
> received on this port because this port is configured as a mirroring
> target). All other bits seem irrelevant for skb->offload_fwd_mark -
> meaning we always have to set skb->offload_fwd_mark.
> 
> I have lots of failures in bridge_vlan_aware.sh and
> bridge_vlan_unaware.sh - even before any of my changes - which I'll
> need to investigate.

I don't remember the problems I faced while making these tests pass on
my hardware, and I also don't think they'll be the same as the ones
you'll face.

> > When flooding a packet to find its destination can be achieved without
> > involving the CPU (*), the next thing will be to simply disable flooding
> > packets of all kind to the CPU (except broadcast). That's when you'll
> > enjoy watching how all the local_termination.sh selftests fail, and
> > you'll be making them pass again, one by one.
> it's called test driven development :-)

Yeah, thanks for putting a name on it. It also happens to be the reason
why I haven't resent my patches for multiple CPU ports this kernel cycle;
I still have some bridge-related local_termination.sh tests that fail,
which didn't before. Normally I would have been happy that hey, yay, it
compiles! let me send it to the list! and I would be looking at cases of
failures as reports would come in (or rely on others to have the inspiration
to tell me that this is going to be broken).

> > > Full local_termination.sh selftest output:
> > > TEST: lan2: Unicast IPv4 to primary MAC address                 [ OK ]
> >
> > For this to pass, the driver must properly respond to a port_fdb_add()
> > on the CPU port, with the MAC address of the $swp1 user port's net device,
> > offloaded in the DSA_DB_PORT corresponding to $swp1.
> >
> > In turn, for DSA to even consider passing you FDB entries in DSA_DB_PORT,
> > you must make dsa_switch_supports_uc_filtering() return true.
> >
> > (if you don't know what the words here mean, I've updated the documentation at
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/Documentation/networking/dsa/dsa.rst)
> Three out of four cases for the FDB isolation code are clear to me:
> - the DSA_DB_BRIDGE case is easy as this is basically what we had
> implemented before and I "just" need to look up the FID based on
> db.bridge.dev

Or db.bridge.num (this is currently set to 0 by DSA because you don't
declare ds->fdb_isolation = true), whichever is more convenient.

> - DSA_DB_PORT for a non-CPU/user port: we should use the same FID as
> standalone ("single port bridge") ports use (that's port number + 1;
> see gswip_add_single_port_br())

The db.dp from a DSA_DB_PORT entry will always be a user port, and this
is by construction, you don't even have to check.

> - GSWIP doesn't support DSA_DB_LAG currently, so I can handle this
> with -EOPNOTSUPP

Yes, furthermore, I think DSA_DB_LAG will get deleted at some point.

> One case took me a while to figure out but I think I finally
> understood it (and now it's clear why the FDB patch I sent earlier
> cannot be upstreamed):
> - DSA_DB_PORT for the CPU port: the port argument for port_fdb_add is
> the CPU port - but we can't map this to a FID (those are always tied
> to either a bridge or a user port). So instead I need to look at db.dp
> and for example use it's index for getting the FID (for standalone
> ports the FID is: port index + 1).

Looking at db.dp to determine the FID is not a workaround, but rather
exactly what you are expected to do.

> That results in: we're requested to install the CPU ports MAC address
> on the CPU port (6),

No. The CPU port doesn't have a MAC address (and in fact no port does;
it's a switch). But user ports have MAC addresses which are a purely
software construct to denote L2 termination. Every user port net device
can have its own MAC address, different from the other, and different
from the MAC address of the DSA master. Its interpretation is: "if a
user port receives a packet with a MAC DA that's equal to the net device's
MAC address, send the packet to the CPU, otherwise drop it".
It makes the standalone NIC illusion work.

The CPU port is just a dumb pipe, it just transports packets to/from our
actual user ports. We don't have a termination point for it (or as written
in other places: "we don't have a net_device"), so no MAC address, not
even as a software construct.

A pipe is exactly how you should see the CPU port. It doesn't have a FID
(a single port bridge) of its own because it is a part of all FIDs.

> but what we actually do is install the FDB entry with the CPU port's
> MAC address on a user port (let's say 4, which we get from db.dp).

No, quite the other way around.

Let's take an example based on what you've described: user port swp4 has
MAC address 00:01:02:03:04:05, and CPU port is 6. You'll get a call to

port_fdb_add(ds, port = 6, addr = 00:01:02:03:04:05, vid = 0,
	     db = {type = DSA_DB_PORT, dp = swp4}).

What you need to do is create an FDB entry on which only packets
received by swp4 in standalone mode will match (so it needs to have a
FID equal to the FID that swp4 classifies packets to, in standalone mode),
and delivers these packets to the CPU port 6, which is already in that FID,
as it is part of every FID. Remember, when swp4 receives a packet and is
standalone, it always assigns the FID of that packet to the value that
it's configured to (port index + 1, or 5, if you say so). This packet
in this FID can either find an entry in the FDB, case in which its
destination is certainly the CPU port (that's why port = 6), or the
address will be absent from the FDB, case in which the packet will be
flooded nowhere (the only other port in this FID, the CPU port, has
flooding turned off) => dropped.

As mentioned earlier, it's desirable that packets delivered by software,
over the CPU port and towards a standalone one, are sent in "god mode",
so that the FDB won't be searched at all in that direction.

You seem to have something reversed in your terminology, although I
can't exactly pinpoint what. When you say "install an FDB entry on port X",
what I understand is "make the packets with that FDB entry's MAC DA be
delivered towards port X". Or maybe I have something reversed?
I'm quite curious to know.

> Now if a packet/frame should target the CPU port we don't need
> flooding because the switch knows the destination port based on the
> FDB entry we installed.

Yes, so rather than the CPU port being a 'dumb' pipe which passes all
packets through it, you're making it a slightly 'smarter' pipe which
essentially uses the FDB as an RX filter for standalone user ports.

> Also I would like to point out that I am still doing all of this in my
> spare time.

I'm doing this in my spare time as well, and I'm having fun while at it.
Sorry for being handwavy and insisting only on explaining the general
idea rather than opening the GSWIP manual and checking that what I'm
saying is actually implementable. I'll do so if you have a specific
question about something apparently not mapping to the expectations.
