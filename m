Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B3D94F99
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfHSVKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:10:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43560 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfHSVKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:10:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id h13so3385376edq.10
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+bXxXFP35wncyk0fRCNDB5x+wP1WxbPhpHmefViO08M=;
        b=BThLqx4zBMnNRbmoZtvskkC8FHb1O9qkRR0CUJYxk/2WD0cHmL1r/7eTxZSo3oeN7L
         wI5vi2jRay9/OsBmETmequcQ5aL0hO3xCwWmU0wnUnpbZNdcmfWH0cKLz1s5txPJmP6o
         xxP8X4niQhsyFUgogvI8qq5aLk72Yvogo4j+n9g0F0SHJFen8IR6fDLecvTjDfqk1ITa
         FwJsHmjU5wclcPrPlBLYdQ/YANsVvumSKs0QvWhUNXGxMRUB5Mi87PzvZhsWvRyjoekE
         X/EPHqxWkDs0nkN8TqSM7zo618oyO+zLuvxP3JQAwHbJPRaHe5lzFzhwRKioGBidOpAV
         twrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+bXxXFP35wncyk0fRCNDB5x+wP1WxbPhpHmefViO08M=;
        b=fyEOZ5lsIpt1HXFanCHSBQFykabVjVAiPrZUA/ojuIc1mDnCkrX6MgNKTq7SE5JCOG
         7niRjPx13FNW+jRyXO9pHqPs6B2Vkp9lnJiNK/kghoNmh6igs9L/A5QZ5CojcFkYX+ai
         aNbbXfL+PawDRW3nQ5oNXFfK0+GYZwQ51ZpgtWdCLywHa+T+THD4suljiCF1gd6G2bEz
         joiwoPuNRMn8ch0vc90enCbHsj8Zhk+sKRLvipkb/1nzuCN4OLo49xCOszEZrKcm21MZ
         ypBUCC+zrhz9V6d7/p29XwScbKgstljuD/FdaRdHay5EF91CaHJ49jmnTHC0pCBl2vfJ
         GePQ==
X-Gm-Message-State: APjAAAXMedPQVA27GCKNVTbSORyohhuOiE86lyP+YSMpw2x5N9Nv9AnF
        txIohpaIo2Ka9StKF393WuKRKpa+tyQA4QKxaAc=
X-Google-Smtp-Source: APXvYqxZ5V63yRvi0uvdYpTxMZ67/EFhsvC/prm/2XKMxzTMIlsvp3tzsSOAZ3ZyyCsX9DtlgUDu6hbNoTLLH2ct0iY=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr22802914ejb.90.1566249045116;
 Mon, 19 Aug 2019 14:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
 <20190628123009.GA10385@splinter> <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
 <bb99eabb-1410-e7c2-4226-ee6c5fef6880@gmail.com> <4756358f-6717-0fbc-3fe8-9f6359583367@gmail.com>
 <20190819201502.GA25207@splinter>
In-Reply-To: <20190819201502.GA25207@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 00:10:33 +0300
Message-ID: <CA+h21hrt9SXPDZq8i1=dZsa4iPHzKwzHnTGUM+ysXascUoKOpQ@mail.gmail.com>
Subject: Re: What to do when a bridge port gets its pvid deleted?
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 at 23:15, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, Aug 19, 2019 at 08:15:03PM +0300, Vladimir Oltean wrote:
> > On 6/28/19 7:45 PM, Florian Fainelli wrote:
> > > On 6/28/19 5:37 AM, Vladimir Oltean wrote:
> > > > On Fri, 28 Jun 2019 at 15:30, Ido Schimmel <idosch@idosch.org> wrote:
> > > > >
> > > > > On Tue, Jun 25, 2019 at 11:49:29PM +0300, Vladimir Oltean wrote:
> > > > > > A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
> > > > > > at the very least), as well as Mellanox Spectrum (I didn't look at all
> > > > > > the pure switchdev drivers) try to restore the pvid to a default value
> > > > > > on .port_vlan_del.
> > > > >
> > > > > I don't know about DSA drivers, but that's not what mlxsw is doing. If
> > > > > the VLAN that is configured as PVID is deleted from the bridge port, the
> > > > > driver instructs the port to discard untagged and prio-tagged packets.
> > > > > This is consistent with the bridge driver's behavior.
> > > > >
> > > > > We do have a flow the "restores" the PVID, but that's when a port is
> > > > > unlinked from its bridge master. The PVID we set is 4095 which cannot be
> > > > > configured by the 8021q / bridge driver. This is due to the way the
> > > > > underlying hardware works. Even if a port is not bridged and used purely
> > > > > for routing, packets still do L2 lookup first which sends them directly
> > > > > to the router block. If PVID is not configured, untagged packets could
> > > > > not be routed. Obviously, at egress we strip this VLAN.
> > > > >
> > > > > > Sure, the port stops receiving traffic when its pvid is a VLAN ID that
> > > > > > is not installed in its hw filter, but as far as the bridge core is
> > > > > > concerned, this is to be expected:
> > > > > >
> > > > > > # bridge vlan add dev swp2 vid 100 pvid untagged
> > > > > > # bridge vlan
> > > > > > port    vlan ids
> > > > > > swp5     1 PVID Egress Untagged
> > > > > >
> > > > > > swp2     1 Egress Untagged
> > > > > >           100 PVID Egress Untagged
> > > > > >
> > > > > > swp3     1 PVID Egress Untagged
> > > > > >
> > > > > > swp4     1 PVID Egress Untagged
> > > > > >
> > > > > > br0      1 PVID Egress Untagged
> > > > > > # ping 10.0.0.1
> > > > > > PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> > > > > > 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
> > > > > > 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
> > > > > > 64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
> > > > > > 64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
> > > > > > 64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
> > > > > > ^C
> > > > > > --- 10.0.0.1 ping statistics ---
> > > > > > 5 packets transmitted, 5 received, 0% packet loss, time 4188ms
> > > > > > rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
> > > > > > # bridge vlan del dev swp2 vid 100
> > > > > > # bridge vlan
> > > > > > port    vlan ids
> > > > > > swp5     1 PVID Egress Untagged
> > > > > >
> > > > > > swp2     1 Egress Untagged
> > > > > >
> > > > > > swp3     1 PVID Egress Untagged
> > > > > >
> > > > > > swp4     1 PVID Egress Untagged
> > > > > >
> > > > > > br0      1 PVID Egress Untagged
> > > > > >
> > > > > > # ping 10.0.0.1
> > > > > > PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> > > > > > ^C
> > > > > > --- 10.0.0.1 ping statistics ---
> > > > > > 8 packets transmitted, 0 received, 100% packet loss, time 7267ms
> > > > > >
> > > > > > What is the consensus here? Is there a reason why the bridge driver
> > > > > > doesn't take care of this?
> > > > >
> > > > > Take care of what? :) Always maintaining a PVID on the bridge port? It's
> > > > > completely OK not to have a PVID.
> > > > >
> > > >
> > > > Yes, I didn't think it through during the first email. I came to the
> > > > same conclusion in the second one.
> > > >
> > > > > > Do switchdev drivers have to restore the pvid to always be
> > > > > > operational, even if their state becomes inconsistent with the upper
> > > > > > dev? Is it just 'nice to have'? What if VID 1 isn't in the hw filter
> > > > > > either (perfectly legal)?
> > > > >
> > > > > Are you saying that DSA drivers always maintain a PVID on the bridge
> > > > > port and allow untagged traffic to ingress regardless of the bridge
> > > > > driver's configuration? If so, I think this needs to be fixed.
> > > >
> > > > Well, not at the DSA core level.
> > > > But for Microchip:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/microchip/ksz9477.c#n576
> > > > For Broadcom:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/b53/b53_common.c#n1376
> > > > For Mediatek:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/mt7530.c#n1196
> > > >
> > > > There might be others as well.
> > >
> > > That sounds bogus indeed, and I bet that the two other drivers just
> > > followed the b53 driver there. I will have to test this again and come
> > > up with a patch eventually.
> > >
> > > When the port leaves the bridge we do bring it back into a default PVID
> > > (which is different than the bridge's default PVID) so that part should
> > > be okay.
> > >
> >
> > Adding a few more networking people.
> > So my flow is something like this:
> > - Boot a board with a DSA switch
> > - Bring all interfaces up
> > - Enslave all interfaces to br0
> > - Enable vlan_filtering on br0
> >
> > What VIDs should be installed into the ports' hw filters, and what should
> > the pvid be at this point?
> > Should the switch ports pass any traffic?
> > At this point, 'bridge vlan' shows a confusing:
> > port    vlan ids
> > eth0     1 PVID Egress Untagged
> >
> > swp5     1 PVID Egress Untagged
> >
> > swp2     1 PVID Egress Untagged
> >
> > swp3     1 PVID Egress Untagged
> >
> > swp4     1 PVID Egress Untagged
> >
> > br0      1 PVID Egress Untagged
> > for all ports, but the .port_vlan_add callback is nowhere to be found.
>
> The bridge adds a PVID on the port when it is enslaved to the bridge.
> The configuration only takes effect when VLAN filtering is enabled. I'm
> looking at dsa_port_vlan_add() and it seems that it does not propagate
> the VLAN call when VLAN filtering is disabled. This explains why you
> never see the callback.
>

Aha! The offending commit is this:

commit 2ea7a679ca2abd251c1ec03f20508619707e1749
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Tue Nov 7 00:04:24 2017 +0100

    net: dsa: Don't add vlans when vlan filtering is disabled

    The software bridge can be build with vlan filtering support
    included. However, by default it is turned off. In its turned off
    state, it still passes VLANs via switchev, even though they are not to
    be used. Don't pass these VLANs to the hardware. Only do so when vlan
    filtering is enabled.

    This fixes at least one corner case. There are still issues in other
    corners, such as when vlan_filtering is later enabled.

    Signed-off-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: David S. Miller <davem@davemloft.net>

It's good to know that it's there (like you said, it explains some
things) but I can't exactly say that removing it helps in any way.
In fact, removing it only overwrites the dsa_8021q VLANs with 1 during
bridge_join, while not actually doing anything upon a vlan_filtering
toggle.
So the sja1105 driver is in a way shielded by DSA from the bridge, for
the better.
It still appears to be true that the bridge doesn't think it's
necessary to notify through SWITCHDEV_OBJ_ID_PORT_VLAN again. So my
best bet is to restore the pvid on my own.
However I've already stumbled upon an apparent bug while trying to do
that. Does this look off? If it doesn't, I'll submit it as a patch:

commit 788f03991aa576fc0b4b26ca330af0f412c55582
Author: Vladimir Oltean <olteanv@gmail.com>
Date:   Mon Aug 19 22:57:00 2019 +0300

    net: bridge: Keep the BRIDGE_VLAN_INFO_PVID flag in net_bridge_vlan

    Currently this simplified code snippet fails:

            br_vlan_get_pvid(netdev, &pvid);
            br_vlan_get_info(netdev, pvid, &vinfo);
            ASSERT(!(vinfo.flags & BRIDGE_VLAN_INFO_PVID));

    It is intuitive that the pvid of a netdevice should have the
    BRIDGE_VLAN_INFO_PVID flag set.

    However I can't seem to pinpoint a commit where this behavior was
    introduced. It seems like it's been like that since forever.

    Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 021cc9f66804..f49b2758bcab 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -68,10 +68,13 @@ static bool __vlan_add_flags(struct
net_bridge_vlan *v, u16 flags)
     else
         vg = nbp_vlan_group(v->port);

-    if (flags & BRIDGE_VLAN_INFO_PVID)
+    if (flags & BRIDGE_VLAN_INFO_PVID) {
         ret = __vlan_add_pvid(vg, v->vid);
-    else
+        v->flags |= BRIDGE_VLAN_INFO_PVID;
+    } else {
         ret = __vlan_delete_pvid(vg, v->vid);
+        v->flags &= ~BRIDGE_VLAN_INFO_PVID;
+    }

     if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
         v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;


> I assume that if you configure the bridge with VLAN filtering enabled
> and then enslave a port, then everything works fine.
>
> mlxsw avoids the situation by forbidding the toggling of VLAN filtering
> on the bridge when its ports are enslaved.
>

I can certainly understand where this comes from. However a simpleton
might object that this:

ip link add name br0 type bridge vlan_filtering 1
ip link set dev swp2 master br0

should behave the same as this:

ip link add name br0 type bridge
ip link set dev swp2 master br0
echo 1 > /sys/class/net/br0/bridge/vlan_filtering

I can't disagree with said simpleton.

> >
> > Whose responsibility is it for the switch to pass traffic without any
> > further 'bridge vlan' command? What is the mechanism through which this
> > should work?
> >
> > What if I do:
> > sudo bridge vlan add vid 100 dev swp2 pvid untagged
> > echo 0 | sudo tee /sys/class/net/br0/bridge/vlan_filtering
> > echo 1 | sudo tee /sys/class/net/br0/bridge/vlan_filtering
> > What pvid should there be on swp2 now?
> > 'bridge vlan' shows:
> > port    vlan ids
> > eth0     1 PVID Egress Untagged
> >
> > swp5     1 PVID Egress Untagged
> >
> > swp2     1 Egress Untagged
> >          100 PVID Egress Untagged
> >
> > swp3     1 PVID Egress Untagged
> >
> > swp4     1 PVID Egress Untagged
> >
> > br0      1 PVID Egress Untagged
> > If the 'bridge vlan' output is correct, whose responsibility is it to
> > restore this pvid?
>
> I suggest to follow mlxsw and avoid this mess. You can support both VLAN
> filtering enable / disable without supporting dynamically toggling the
> option.
>
> >
> > More context: the sja1105 driver is somewhat similar to the mlxsw in that
> > VLAN awareness cannot be truly disabled. Arid details aside, in both cases,
> > achieving "VLAN-unaware"-like behavior involves manipulating the pvid in
> > both cases. But it appears that the bridge core does expect:
> > (1) that the driver performs a default VLAN initialization which matches its
> > own, without them ever communicating. But because switchdev/DSA drivers
> > start off in standalone mode, vlan_filtering=0 comes first, hence the
> > non-standard pvid. Through what mechanism is the bridge-expected pvid
> > supposed to get restored upon flipping vlan_filtering?
> > (2) that toggling VLAN filtering off and on has no other state upon the
> > underlying driver than enabling and disabling VLAN awareness. The VLAN hw
> > filter table is assumed to be unchanged. Is this a correct assumption?
> >
> > Thanks,
> > -Vladimir
