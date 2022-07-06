Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968C25693DE
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiGFVG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiGFVG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:06:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AB728719;
        Wed,  6 Jul 2022 14:06:55 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id m16so5296505edb.11;
        Wed, 06 Jul 2022 14:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f02gYQxUh6yCZ0bPt81I8jPJuxpJnwE8J3b3EZ/J0O4=;
        b=g/VsZ/7ZZ/naVmisTG12FwDdkN/RhnNi3TACZLB9bE89axmiVBxzCl2N5isdZdbxYD
         m+2O1xrBw7llb/XlsnvZ5ml1iTuHiY+fkR4XMiR/hUgXz2+wQ1y4ViOpiTYhkoP+nkF3
         9L8mm7+Msjg6U/oVbh9JMkSRrjrI7t67a0ecYZBc8QOp2tIffzAq4wwalarndEBcZay6
         NRcigbhUjTZJZkLwd19T4x9jR2ks9NFlvALj86hGA2oLe1tvF43gFnTUPY2+hoRbr88I
         s8waBWcXH/wL88sUp/maEVcc1mUqmcnKeV5XejT6Qx+IhBpViosqAaKk/jD4T6E4zz2c
         MQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f02gYQxUh6yCZ0bPt81I8jPJuxpJnwE8J3b3EZ/J0O4=;
        b=5FLv8oggyJatTjwPfPL/m68YkjElBgTiCPAQvzQpDQB0cwoVnrUZnmCeurEVVA7Qay
         n2GZ6gnq0gF5HB1I17utNCOX3ufrOqMOYQL/NRe/yBol23YN+c+LEMkCu3dpqP7Yfy88
         KTJvQmlcIDYM5xSGqnACNa/TQm18HsbSjKp1eeWYKNaLeSaGKltEmXEkACjTOUeQAOW8
         HaK5Rm8Seu2/8gVe3LNKT1xmz5Sa1xJSOckcrioXCr5sWWy/j9+wGMTQ2KAHG0i/zZZh
         aR/a4qiFEODbZwFFM94veos/ozpCb0QZ40M59F3RtvXzF6xxPVFCib+j6vfyKJlxrzpb
         +dPg==
X-Gm-Message-State: AJIora8U5JO4SVNSOeWpgG39P9Kk9kC9HQ8R4csOSzNzdBfb6vdiQcuv
        aJCbrVYRvUfINWAW2ZFmBkY=
X-Google-Smtp-Source: AGRyM1tkCn6BramZeIOENVgpAhmcp68WU8Dt0BdLGts/vFG9Fx+apVP1KNnQGmnXNbSfl0WIlujOsA==
X-Received: by 2002:aa7:cdc9:0:b0:43a:7b6f:e569 with SMTP id h9-20020aa7cdc9000000b0043a7b6fe569mr13103973edw.401.1657141613866;
        Wed, 06 Jul 2022 14:06:53 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id bl24-20020a170906c25800b00704757b1debsm17683333ejb.9.2022.07.06.14.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:06:53 -0700 (PDT)
Date:   Thu, 7 Jul 2022 00:06:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: lantiq_gswip: Fix FDB add/remove on the
 CPU port
Message-ID: <20220706210651.ozvjcwwp2hquzmhn@skbuf>
References: <20220630212703.3280485-1-martin.blumenstingl@googlemail.com>
 <20220701130157.bwepfw2oeco6teyv@skbuf>
 <CAFBinCDqgQ1WWWPmfXykeZPsiwLNu+fPg6nCN7TMNNR_JL3gxQ@mail.gmail.com>
 <20220702185652.dpzrxuitacqp6m3t@skbuf>
 <CAFBinCC7s7adM38JUkroCV3q7t7fJBu6r9zULfpOqR9L5NeWyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCC7s7adM38JUkroCV3q7t7fJBu6r9zULfpOqR9L5NeWyg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 03, 2022 at 12:53:45AM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
> 
> On Sat, Jul 2, 2022 at 8:56 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Sat, Jul 02, 2022 at 07:43:11PM +0200, Martin Blumenstingl wrote:
> > > Hi Vladimir,
> > >
> > > On Fri, Jul 1, 2022 at 3:02 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > [...]
> > > > > Use FID 0 (which is also the "default" FID) when adding/removing an FDB
> > > > > entry for the CPU port.
> > > >
> > > > What does "default" FID even mean, and why is the default FID relevant?
> > > The GSW140 datasheet [0] (which is for a newer IP than the one we are
> > > targeting currently with the GSWIP driver - but I am not aware of any
> > > older datasheets)
> >
> > Thanks for the document! Really useful.
> Great that this helps. Whenever you hear me contradicting statements
> from that datasheet then please let me know. There have been subtle
> changes between the different versions of the IP, so I may have to
> double check with the vendor driver to see if things still apply to
> older versions.
> 
> > > page 78 mentions: "By default the FID is zero and all entries belong
> > > to shared VLAN learning."
> >
> > Not talking about the hardware defaults when it's obvious the driver
> > changes those, in an attempt to comply to Linux networking expectations...
> >
> > > > In any case, I recommend you to first set up a test bench where you
> > > > actually see a difference between packets being flooded to the CPU vs
> > > > matching an FDB entry targeting it. Then read up a bit what the provided
> > > > dsa_db argument wants from port_fdb_add(). This conversation with Alvin
> > > > should explain a few things.
> > > > https://patchwork.kernel.org/project/netdevbpf/cover/20220302191417.1288145-1-vladimir.oltean@nxp.com/#24763870
> > > I previously asked Hauke whether the RX tag (net/dsa/tag_gswip.c) has
> > > some bit to indicate whether traffic is flooded - but to his knowledge
> > > the switch doesn't provide this information.
> >
> > Yeah, you generally won't find quite that level of detail even in more
> > advanced switches. Not that you need it...
> >
> > > So I am not sure what I can do in this case - do you have any pointers for me?
> >
> > Yes, I do.
> >
> > gswip_setup has:
> >
> >         /* Default unknown Broadcast/Multicast/Unicast port maps */
> >         gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP1);
> >         gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP2);
> >         gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP3); <- replace BIT(cpu_port) with 0
> >
> > If you can no longer ping, it means that flooding was how packets
> > reached the system.
> I tried this but I can still ping OpenWrt's br-lan IP.

Yes, so I looked at the GSW140 documentation again and found:

Table 38 Special Tag Ingress Format
Bit 4 Force no learning (1 B = address is not learned, 0 B = ignore)

This header format is quite different compared to what is supported by
gswip_tag_xmit() - 8 bytes vs 4 - but if they're at all similar, the
GSWIP may have a similar "learn disable" bit per packet, which the
tag proto driver isn't setting => address learning takes place.

Please note that there is a reason why a "learn disable" bit exists.
To work properly from all angles, only traffic injected into the switch
from br-lan should be learned by the hardware. Traffic injected from
standalone ports shouldn't.

> 
> I zero'ed the GSWIP_PCE_PMAP2 register (which according to the
> documentation is used for L2 multicast/broadcast flooding) as well,
> which changes the behavior:
> - once the br-lan (IP address: 192.168.1.14) interface is brought up
> it cannot be ping'ed from a device connected to one of the switch
> ports ("Destination Host Unreachable")
> - I can ping a device connected to the switch from within OpenWrt
> (meaning: ping from the CPU port to a device with IP 192.168.1.100 on
> one of the switch port works)
> - once I start the ping from within OpenWrt I immediately get replies
> from OpenWrt to the other device
> 
> ping log:
>     [similar messages omitted, only the icmp_seq is different]
>     From 192.168.1.100 icmp_seq=87 Destination Host Unreachable
>     [this is when I start "ping 192.168.1.100" from within OpenWrt)
>     64 bytes from 192.168.1.14: icmp_seq=88 ttl=64 time=3016 ms
>     64 bytes from 192.168.1.14: icmp_seq=89 ttl=64 time=2002 ms
>     64 bytes from 192.168.1.14: icmp_seq=90 ttl=64 time=989 ms
>     64 bytes from 192.168.1.14: icmp_seq=91 ttl=64 time=0.379 ms
> 
> I made sure that the changes from my patch are not applied:
> # dmesg | grep " to fdb: -22" | wc -l
> 9
> 
> Also in case it's relevant: I added some printk's to
> gswip_port_fdb_dump() (because I don't know how to differentiate
> "hardware FDB" from "software FDB" entries in "bridge fdb show brport
> lan1"):
> The switch seems to learn the CPU port's MAC address automatically -
> even before I issue "ping 192.168.1.100" (most likely due to something
> in OpenWrt accessing the network).
> The "static" flag is not set though (which is expected I think).

Ok, so this wasn't too complicated it seems. Thanks for doing the tests.

There isn't a better way than to printk the FDB entries on the CPU port,
given that there isn't a netdev for that port through which we could
report .ndo_fdb_dump.

What exists is the concept of "devlink regions" and "devlink port regions".
These are named binary bits exposed by certain DSA drivers that are
dumped by user space over netlink, and interpreted by a vendor specific
tool.

Andrew Lunn wrote mv88e6xxx_dump for... mv88e6xxx
https://github.com/lunn/mv88e6xxx_dump

and that can be used to dump information for CPU ports. It includes
entire Address Translation Unit (ATU) entries, so the format is a quite
a bit more detailed than bridge FDB entries since it is hardware specific.

There are various forks of that tool for other pieces of hardware, like
sja1105_dump:
https://github.com/vladimiroltean/mv88e6xxx_dump

To my knowledge there hasn't been any successful attempt in unifying all
forks into a larger dsa_dump, although I've wanted to do that.

Mentioning this just in case you have some spare time to work on a small
little debugging tool. If you're fine with printk that's cool too.

> As a side-note: I think the comment is partially incorrect. At least
> for the GSWIP IP revision which the driver is targeting,
> GSWIP_PCE_PMAP1 is for the "monitoring" port. My understanding is that
> this "monitoring port" is used with port mirroring (which the hardware
> supports but we don't implement in the driver yet).
> 
> > It appears that what goes on is interesting.
> > The switch is configured to flood traffic that's unknown to the FDB only
> > to the CPU (notably not to other bridged ports).
> > In software, the packet reaches tag_gswip.c, where unlike the majority
> > of other DSA tagging protocols, we do not call dsa_default_offload_fwd_mark(skb).
> > Then, the packet reaches the software bridge, and the switch has
> > informed the bridge (via skb->offload_fwd_mark == 0) that the packet
> > hasn't been already flooded in hardware, so the software bridge needs to
> > do it (only if necessary, of course).
> >
> > The software bridge floods the packet according to its own FDB. In your
> > case, the software bridge recognizes the MAC DA of the packet as being
> > equal to the MAC address of br0 itself, and so, it doesn't flood it,
> > just terminates it locally. This is true whether or not the switch
> > learned that address in its FDB on the CPU port.
> >
> > > Also apologies if all of this is very obvious. So far I have only been
> > > working on the xMII part of Ethernet drivers, meaning: I am totally
> > > new to the FDB part.
> > >
> > > > Then have a patch (set) lifting the "return -EINVAL" from gswip *properly*.
> > > > And only then do we get to ask the questions "how bad are things for
> > > > linux-5.18.y? how bad are they for linux-5.15.y? what do we need to do?".
> > > agreed
> > >
> > >
> > > Thanks again for your time and all these valuable hints Vladimir!
> > > Martin
> > >
> > >
> > > [0] https://assets.maxlinear.com/web/documents/617930_gsw140_ds_rev1.11.pdf
> >
> > So if I'm right, the state of facts is quite "not broken" (quite the
> > other way around, I'm really impressed), although there are still
> > improvements to be made. Flooding could be offloaded to hardware, then
> > flooding to CPU could be turned off and controlled via port promiscuity.
> > This would save quite a few CPU cycles.
> 
> Hearing that things are not horribly broken is great!
> Also saving a few CPU cycles would be awesome since this SoCs has a
> 500MHz MIPS 34Kc core with two VPEs (meaning: one core which supports
> SMT - or "HT" as known in the Intel world). So any CPU cycle that can
> be saved helps

The first thing will be to get the driver to pass the existing
selftests. If you look at tools/testing/selftests/drivers/net/dsa/local_termination.sh,
that is what should ultimately pass, since it checks that the packets
that should be received are received, and the ones that shouldn't aren't.

But to get there we'll need to make smaller steps, like disable address
learning on standalone ports, isolate FDBs, maybe offload the bridge TX
forwarding process (in order to populate the "Force no learning" bit in
tag_gswip.c properly), and only then will the local_termination test
also pass. There's also some more work to do in the bridge driver, but
we're getting there slowly.

I'll give some more details about these things in the thread with the
selftest for the configure_vlan_while_not_filtering feature, there are
quite a few things to be said.
