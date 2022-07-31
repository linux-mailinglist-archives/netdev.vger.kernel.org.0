Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB61586173
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 22:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbiGaUtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 16:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGaUtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 16:49:50 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27AD65E8
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 13:49:46 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c131so16111886ybf.9
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 13:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5k8/vKWOGndrS22ucw5r3eSuLfLM8BdfZbfSPywv6jg=;
        b=NIBE3Pyw+9XoP22WYkPJ0QZut5qMHRnk4F5pcjkj6o+kOccH6SDzX5EahmfYtoEgtr
         Kv1VZIBpxHl4Y8A6gPYMQ2yqxNMlGlHOIqL0tGtORKfG49wtFu3hzlqy7YYTMAozPeM/
         m4fpwc0eKePeeDsHbXgTiwlKCLu1iiGitD/UR4nbJhZqgd7FLfwcRj9wOptEUnefRFen
         fQHnhKHZXFpEIPEHVy9KZMVW7XxKrR2eHxEcoVEk0vj6XQro2rn6sD2oJJYBd8gk0SjV
         ZQbnFi416hd3OEcu6sXpclLjwwTVIxgr2clTr95+b4LJ5xlC4ahGtM3ReebmPuEMO6eF
         hLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5k8/vKWOGndrS22ucw5r3eSuLfLM8BdfZbfSPywv6jg=;
        b=F3DilWTVnmG3Sl5uOFT8OZ5kc0l2TPDFxpLNJXqauQQTYEk7L5mm8mILWyVc/idnJQ
         nXBTvjwFqEuAsxhl51ThIMQlUT4K3xkvWX3xfu6/bfoyKSg8n28eRCM6mG9ncAU/zl06
         pdrzbw/6IaB2rwLV71NNRsVcXmUBMYeO131k9S/X0fx0JcUDK2PsxEOqOxQs3BCfjGKM
         PBr/Hl/RNMEXTTyUsDqIgz28Rqrgt9LnxWqGp7Ya821KbNBQT20wFPDflVpz+1wVcAt1
         jJrUeYyCESFXshIhjFIXAsur6HY2ysFOHCIKELymB/PT3G8FvoV35QSJMMWxfGoYMBpS
         /mgw==
X-Gm-Message-State: ACgBeo3eO5ohoXIvLfXIfUn8Ygg29Chr53lkOMvCSfSPi08C6Gf0crkb
        qJM5inpCKGe/wMftGxlKHTloUWxTkjAoQZrVsESmjuw7uhM=
X-Google-Smtp-Source: AA6agR7LpA9/y/38YIVUwDmWeQ1UQTG5FiplKx8DBSLkYah6yxfIl2nYiduyGdmhl8Glj+bKtNTRuj3IxxeaJdTfeTA=
X-Received: by 2002:a25:e682:0:b0:671:79d9:66c7 with SMTP id
 d124-20020a25e682000000b0067179d966c7mr9207300ybh.5.1659300585875; Sun, 31
 Jul 2022 13:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <20220727224409.jhdw3hqfta4eg4pi@skbuf> <CAFBinCD5yQodsv0PoqnqVA6F7uMkoD-_mUxi54uAHc9Am7V-VQ@mail.gmail.com>
 <20220729000536.hetgdvufplearurq@skbuf>
In-Reply-To: <20220729000536.hetgdvufplearurq@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 31 Jul 2022 22:49:35 +0200
Message-ID: <CAFBinCBXNnpz0FUCs1PnxAoPk2nTKoj=r2wjSFx_rT=vV+JPtA@mail.gmail.com>
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

On Fri, Jul 29, 2022 at 2:05 AM Vladimir Oltean <olteanv@gmail.com> wrote:
[...]
> > - disable learning on all ports
>
> Yes, here's just one other example of what can go wrong if it's enabled
> on standalone ports, if you need to see it:
> https://lore.kernel.org/netdev/20220727233249.fpn7gyivnkdg5uhe@skbuf/T/#m2e27a5385f70ee3440ee7f6250aaafdbfdc7446b
>
> Essentially every time when there's a chance that the switch will
> receive on one port what another port has sent, learning will be a
> problem. This is why it's also problematic for the selftests - because
> we intentionally put 2 pairs of ports in loopback.
Makes sense, thanks!

> > - disable unicast flooding on all ports
>
> I am having trouble saying 'yes' or 'no' to this because I don't know
> exactly what you mean. By flooding a packet, I understand "if its MAC DA
> is unknown to the FDB, deliver it to this set of ports". But flooding,
> like learning, is essentially a bridging service concept, so it applies
> only to packets coming from a particular bridging domain. In the case of
> a standalone port, packets come only from the CPU, via the control
> plane. Depending how the hardware is constructed, when you inject a
> packet to a port, maybe there won't be any ifs or buts and the switch
> will just deliver it there (I call this behavior: "control packets
> bypass FDB lookup", or "CPU is in god mode"). So maybe it doesn't matter
> whether unicast flooding is enabled on all standalone ports or not, as
> long as the macroscopically expected behavior can be observed: if
> software xmits a packet to a port, the packet gets delivered regardless
> of MAC DA.
I think I do understand it now.
We want the defaults to apply to standalone ports. Since flooding does
not exist there we should disable it (for both, unicast and
broadcast/multicast traffic). When flooding is wanted on a specific
port it'll be enabled through port_bridge_flags.

[...]
> > - (GSWIP can only enable broadcast and multicast at the same time, so
> > that's enabled too)
>
> I think the GSWIP would not be the only one in that category. The
> mv88e6xxx driver puts the ff:ff:ff:ff:ff:ff address in the FDB and that
> controls broadcast flooding, while the single knob that you mention
> controls what's left - i.e. multicast.

> > I think skb->offload_fwd_mark needs to be set unless we know that the
> > hardware wasn't able to forward the frame/packet.
> > In the vendor sources I was able to find the whole RX tag structure: [0]
> > I am not sure about the "mirror" bit (I assume this is: packet was
> > received on this port because this port is configured as a mirroring
> > target). All other bits seem irrelevant for skb->offload_fwd_mark -
> > meaning we always have to set skb->offload_fwd_mark.
> >
> > I have lots of failures in bridge_vlan_aware.sh and
> > bridge_vlan_unaware.sh - even before any of my changes - which I'll
> > need to investigate.
>
> I don't remember the problems I faced while making these tests pass on
> my hardware, and I also don't think they'll be the same as the ones
> you'll face.
I'll postpone bridge_vlan_unaware.sh investigations until I have the
standalone tests (which are relevant for GSWIP, meaning: excluding the
multicast ones) from local_termination.sh passing.

[...]
> > - the DSA_DB_BRIDGE case is easy as this is basically what we had
> > implemented before and I "just" need to look up the FID based on
> > db.bridge.dev
>
> Or db.bridge.num (this is currently set to 0 by DSA because you don't
> declare ds->fdb_isolation = true), whichever is more convenient.
Using db.bridge.num will probably allow us to get rid of the
priv->vlans array in the GSWIP driver. For now I'm using the bridge
dev since "it works" until tests are passing.

[...]
> > - DSA_DB_PORT for the CPU port: the port argument for port_fdb_add is
> > the CPU port - but we can't map this to a FID (those are always tied
> > to either a bridge or a user port). So instead I need to look at db.dp
> > and for example use it's index for getting the FID (for standalone
> > ports the FID is: port index + 1).
>
> Looking at db.dp to determine the FID is not a workaround, but rather
> exactly what you are expected to do.
Thanks for confirming!

> > That results in: we're requested to install the CPU ports MAC address
> > on the CPU port (6),
>
> No. The CPU port doesn't have a MAC address (and in fact no port does;
> it's a switch). But user ports have MAC addresses which are a purely
> software construct to denote L2 termination. Every user port net device
> can have its own MAC address, different from the other, and different
> from the MAC address of the DSA master. Its interpretation is: "if a
> user port receives a packet with a MAC DA that's equal to the net device's
> MAC address, send the packet to the CPU, otherwise drop it".
> It makes the standalone NIC illusion work.
>
> The CPU port is just a dumb pipe, it just transports packets to/from our
> actual user ports. We don't have a termination point for it (or as written
> in other places: "we don't have a net_device"), so no MAC address, not
> even as a software construct.
>
> A pipe is exactly how you should see the CPU port. It doesn't have a FID
> (a single port bridge) of its own because it is a part of all FIDs.
>
> > but what we actually do is install the FDB entry with the CPU port's
> > MAC address on a user port (let's say 4, which we get from db.dp).
>
> No, quite the other way around.
>
> Let's take an example based on what you've described: user port swp4 has
> MAC address 00:01:02:03:04:05, and CPU port is 6. You'll get a call to
>
> port_fdb_add(ds, port = 6, addr = 00:01:02:03:04:05, vid = 0,
>              db = {type = DSA_DB_PORT, dp = swp4}).
>
> What you need to do is create an FDB entry on which only packets
> received by swp4 in standalone mode will match (so it needs to have a
> FID equal to the FID that swp4 classifies packets to, in standalone mode),
> and delivers these packets to the CPU port 6, which is already in that FID,
> as it is part of every FID. Remember, when swp4 receives a packet and is
> standalone, it always assigns the FID of that packet to the value that
> it's configured to (port index + 1, or 5, if you say so). This packet
> in this FID can either find an entry in the FDB, case in which its
> destination is certainly the CPU port (that's why port = 6), or the
> address will be absent from the FDB, case in which the packet will be
> flooded nowhere (the only other port in this FID, the CPU port, has
> flooding turned off) => dropped.
>
> As mentioned earlier, it's desirable that packets delivered by software,
> over the CPU port and towards a standalone one, are sent in "god mode",
> so that the FDB won't be searched at all in that direction.
>
> You seem to have something reversed in your terminology, although I
> can't exactly pinpoint what. When you say "install an FDB entry on port X",
> what I understand is "make the packets with that FDB entry's MAC DA be
> delivered towards port X". Or maybe I have something reversed?
> I'm quite curious to know.
Thanks a lot for explaining this (yet again)!
There's three issues with my original sentence:
- I should have used the term "user port's MAC address" instead of
"CPU ports MAC"
- "on the CPU port (6)" needs to be more precise, it should be
"towards the CPU port (6)"
- I'm not mentioning the source port (user port) number and thus FID at all

Also I need to get the idea out of my head that the CPU port is equal to eth0.
It's not, eth0 is connected to the CPU port on the switch.

While working on my patches a more practical question came up while I
was breaking the driver and then trying to make local_termination.sh
pass again.
At the start of run_tests for the standalone port scenario I am
getting the following values:
  rcv_dmac = 00:01:02:03:04:02
  MACVLAN_ADDR = 00:00:de:ad:be:ef
My expectation is that port_fdb_add() is called with these MAC
addresses. I verified that dsa_switch_supports_uc_filtering() returns
true, but still I

> > Now if a packet/frame should target the CPU port we don't need
> > flooding because the switch knows the destination port based on the
> > FDB entry we installed.
>
> Yes, so rather than the CPU port being a 'dumb' pipe which passes all
> packets through it, you're making it a slightly 'smarter' pipe which
> essentially uses the FDB as an RX filter for standalone user ports.
>
> > Also I would like to point out that I am still doing all of this in my
> > spare time.
>
> I'm doing this in my spare time as well, and I'm having fun while at it.
> Sorry for being handwavy and insisting only on explaining the general
> idea rather than opening the GSWIP manual and checking that what I'm
> saying is actually implementable. [...]
I fully understand this and it makes sense as others can also benefit
from your explanation (since it's generic, not driver specific).

> I'll do so if you have a specific question about something apparently
> not mapping to the expectations.
I still have an issue which I believe is related to the FDB handling.

I *think* that I have implemented FDB isolation correctly in my
work-in-progress branch [0].

The GSWIP140 datasheet (page 82) has a "MAC Learning disable and MAC
Learning Limitation Description" (table 26).
In the xRX200 vendor kernel I cannot find the LNDIS bit in
PCE_PCTRL_3, so I suspect it has only been added in newer GSWIP
revisions (xRX200 is at least one major IP revision behind GSW140).
Maybe Hauke knows?
So what I'm doing to disable learning is setting the "learning limit"
(which limits the number of entries that can be learned) for that port
to zero.

 My problem is that whenever I disable learning a lot of tests from
local_termination.sh are failing, including:
- TEST: lan2: Unicast IPv4 to primary MAC address
- TEST: lan2: Unicast IPv4 to macvlan MAC address

Setting the PLIMMOD bit to 1 means that GSWIP won't drop the packet if
the learning limit is exceeded (the default value seems to be 0).
This at least works around the first failing test (Unicast IPv4 to
primary MAC address).

Based on your understanding of my issue: I am going in the right
direction when I'm saying that this is an FDB issue?


Thank you!
Martin


[0] https://github.com/xdarklight/linux/commits/lantiq-gswip-integration-20220730
