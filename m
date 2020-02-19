Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669D916461D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgBSNzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:55:44 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37900 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbgBSNzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 08:55:43 -0500
Received: by mail-ed1-f67.google.com with SMTP id p23so29198269edr.5
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 05:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amR0+qn+QgeF/HrrtZDF1P8oWv0Plojl/SytffRZuR8=;
        b=Jzzjg1mgI6Usq6tC0hXnBLP58XfGFz+44hhembb8k6sDeqDXwux6xip3XI/boHVAJc
         eI8nH/UYHCEooS1RDsLhk9ItM73qqtQTqGivnEuD8OfKq6YAG5cde1vokbbm7TD5UaB6
         uREiMAjcaDXzOuuSvaIpJ8PYKn0WdEsioC83fXhet0lmwoVvTdQw+yZ0aAJWs8gBGDsx
         vP0sBTjDEFLmIgj5Oab76cqAD21hlSL0rrl655Qw9hhgYFFl8Fu2GslxnRfI1YrhftJ5
         lWZ7gP1LpuAo2ZZot+fgXLB7wYXRl3CSVDSyirxylyxh98EFKrsYL2XIjHLByZpFnfgC
         IBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amR0+qn+QgeF/HrrtZDF1P8oWv0Plojl/SytffRZuR8=;
        b=JJMpH0amsE+WypZzt9cb82b2i3DVVOTAB9HhFx8eyoWRX7jnAWMVYIvR34OtPxt5jU
         ZMW06ZFIFgDGgzPMp39Jr09qRV6SfN7KPO/nN3TEfmY0/yp6KA6qWcg457mhrz4gYt6v
         QsiUAZ4ij2swyd2/huoWGZheQvQxinghPJpUYqxFjAMCawnmdYarKkoQx7Ya1Bcxx9k7
         f8fWlMBxcpI/GC+cs+3hh81sMlmkPTwUy8c8iE3immMdVc5d0F6tt5m1MSkAvujsC3ds
         0pv0Me6O3oY5hKbxAyFf5wH68iKuqJ+qMaHINMUBIs5ZZXxUFLa2tnzybPSjrv7bhP1e
         ogQg==
X-Gm-Message-State: APjAAAUVPajf7DzDRXrR2XGwR9XoxfbYs7ZgX3yg8WrytOl4ldJg3CZm
        S5AoWkszh6fpL81/M2mOoA/6TeuGe47ZE+QjQEc=
X-Google-Smtp-Source: APXvYqxf+Yvl4L+E2ZnMQ04hNYfR5Y7Vg0thPpYGyiK141Stktyv9+hWb1Vz5wJVFuG6ZnKnFvVMQImSNSNItt6FFPg=
X-Received: by 2002:a05:6402:128c:: with SMTP id w12mr2955553edv.368.1582120540085;
 Wed, 19 Feb 2020 05:55:40 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218134850.yor4rs72b6cjfddz@lx-anielsen.microsemi.net>
 <CA+h21hpj+ARUZN5kkiponTCN_W1xaNDTpNB4u4xdiAGP5QqmfA@mail.gmail.com> <20200219101149.dq7jwhs6aypv43kf@lx-anielsen.microsemi.net>
In-Reply-To: <20200219101149.dq7jwhs6aypv43kf@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 19 Feb 2020 15:55:28 +0200
Message-ID: <CA+h21hqMPb3qV_Rusa8yADPxKhubXPjX7hHLhxuuS6g96btVHw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Wed, 19 Feb 2020 at 12:11, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> On 18.02.2020 16:02, Vladimir Oltean wrote:
> >The problem is on RX.
> >
> >> Is it with the broadcast ARP, or is it the following unicast packet?
> >For the unicast packet.

My bad, it is not just the unicast packet that is dropped, the
broadcast ARP packet is dropped too. All get dropped with the
"drop_local" counter on the front-panel port, the "no valid
destinations" counter.

> When you have it working (in your setup, with your patch applied). Does
> the ping reply packet have an IFH (DSA-tag)?
>

FYI any packet sent through a swpN net device (an Ocelot/Felix net
device, that is) will have an Injection Frame Header.

> Or is it a frame on the NPI port without an IFH.
>

No, I'm not trying to ping over an IP set on the DSA master interface,
if that's what you're asking.

> This is important as this will tell us of the frame was copied to CPU
> and then redirected to the NPI port, or if it was plain forwarded.
>

IFH is "injection" (host -> switch).
I suppose you meant Extraction Frame Header?
Nothing is seen by tcpdumping on the DSA master interface either.
Moreover, the "drop_local" counter on the front-panel swp0 increments
proportionally with the number of packets that the CPU should be
seeing.

By the way, could you please clarify the mechanisms by which the
switch will add an EFH on some but not all packets sent towards the
NPI port? The fact that this is possible is news to me.

> I need to understand the problem better before trying to solve it.
>
> >> >But if I do this:
> >> >ip link add dev br0 type bridge
> >> >ip link set dev swp0 master br0
> >> >ip link set dev swp0 nomaster
> >> >ping 192.168.1.2
> >> >Then it works, because the code path from ocelot_bridge_stp_state_set
> >> >that puts the CPU port in the forwarding mask of the other ports gets
> >> >executed on the "bridge leave" action.
> >> >The whole point is to have the same behavior at probe time as after
> >> >removing the ports from the bridge.
> >> This does sound like a bug, but I still do not agree in the solution.
> >>
> >> >The code with ocelot_mact_learn towards PGID_CPU for the MAC addresses
> >> >of the switch port netdevices is all bypassed in Felix DSA. Even if it
> >> >weren't, it isn't the best solution.
> >> >On your switch, this test would probably work exactly because of that
> >> >ocelot_mact_learn.
> >> So I guess it is the reception of the unicast packet which is causing
> >> problems.
> >>
> >> >But try to receive packets sent at any other unicast DMAC immediately
> >> >after probe time, and you should see them in tcpdump but won't.
> >> That is true - this is because we have no way of implementing promisc
> >> mode, which still allow us to HW offload of the switching. We discussed
> >> this before.
> >>
> >> Long story short, it sounds like you have an issue because the
> >> Felix/DSA driver behave differently than the Ocelot. Could you try to do
> >> your fix such that it only impact Felix and does not change the Ocelot
> >> behavioral.
> >
> >It looks like you disagree with having BIT(ocelot->cpu) in PGID_SRC +
> >p (the forwarding matrix) and just want to rely on whitelisting
> >towards PGID_CPU*?
> Yes.
>
> When the port is not member of the bridge, it should act as a normal NIC
> interface.
>
> With this change frames are being forwarded even when the port is not
> member of the bridge. This may be what you want in a DSA (or may not -
> not sure), but it is not ideal in the Ocelot/switchdev solution as we
> want to use the MAC-table to do the RX filtering.
>
> >But you already have that logic present in your driver, it's just not
> >called from a useful place for Felix.
> >So it logically follows that we should remove these lines from
> >ocelot_bridge_stp_state_set, no?
> >
> >            } else {
> >                    /* Only the CPU port, this is compatible with link
> >                     * aggregation.
> >                     */
> >                    ocelot_write_rix(ocelot,
> >                                     BIT(ocelot->cpu),
> >                                     ANA_PGID_PGID, PGID_SRC + p);
> This should not be removed. When the port is member of the bridge this
> bit must be set. When it is removed it must be cleared again.

Yes, but why keep BIT(ocelot->cpu) in the "valid destinations for this
source port p" mask (PGID_SRC + p) at all, if you just explained above
that you don't need it, because the MAC table takes care of getting
frames copied to the CPU, and there are dubious loopholes in the
hardware implementation that make this possible even if the third PGID
lookup (for source masks) denies it?

>
> >*I admit that I have no idea why it works for you, and why the frames
> >learned towards PGID_CPU are forwarded to the CPU _despite_
> >BIT(ocelot->cpu) not being present in PGID_SRC + p.
> I believe this is because we have the MAC address in the MAC table.
>

Could you please confirm this using stronger language than "I believe"?
Just for everybody to follow along here, in Ocelot/Felix, Port Group
IDs (PGIDs) are masks of destination ports. The switch performs 3
lookups in the PGID table for each frame, and forwards the frame to
the ports that are present in the logical AND of all 3 PGIDs (for the
most part, see below).

The first PGID lookup is for the destination masks and the PGID table
is indexed by the DEST_IDX field from the MAC table (FDB).
The PGID can be an unicast set: PGIDs 0-11 are the per-port PGIDs, and
by convention PGID i has only BIT(i) set, aka only this port is set in
the destination mask.
Or the PGID can be a multicast set: PGIDs 12-63 can (again, still by
convention) hold a richer destination mask comprised of multiple
ports.

I'll be ignoring the second PGID lookup, for aggregation, here, since
it doesn't interfere (it doesn't restrict the valid destinations mask
in any way).

The third PGID lookup is for source masks: PGID entries 80-91 answer
the question: is port i allowed to forward traffic to port j? If yes,
then BIT(j) of PGID 80+i will be found set. _These_ are what we're
talking about here (PGID_SRC + i).

What is interesting about the CPU port in this whole story is that, in
the way the driver sets up the PGIDs, its bit isn't set in any source
mask PGID of any other port (therefore, the third lookup would always
decide to exclude the CPU port from this list). So frames are never
_forwarded_ to the CPU.

There is a loophole in this PGID mechanism which is described in the
VSC7514 manual:

        If an entry is found in the MAC table entry of ENTRY_TYPE 0 or 1
        and the CPU port is set in the PGID pointed to by the MAC table
        entry, CPU extraction queue PGID.DST_PGID is added to the CPUQ.

In other words, the CPU port is special, and frames are "copied" to
the CPU, disregarding the source masks (third PGID lookup), if
BIT(cpu) is found to be set in the destination masks (first PGID
lookup).

So my question was: is the "copy to CPU" action special-cased in the
Ocelot hardware to bypass the L2 forwarding matrix? Because if it is,
that isn't how any of the other DSA switches works.

> It seems that you want to use learning to forward frames to the CPU,
> also in the case when the port is not a member of the bridge. I'm not
> too keen on this, mainly because I'm not sure how well it will work. If
> you are certain this is what you want for Felix then lets try find a way
> to make it happend for Felix without chancing the behaivural for Ocelot.
>
> An alternative solution would be to use the MAC-table for white listing
> of unicast packets. But as I understand the thread this is not so easy
> to do with DSA. Sorry, I do not know DSA very well, and was not able to
> fully understand why. But this is as far as I know the only way to get
> the proper RX filtering.

With VLAN filtering enabled, keeping the MAC of the interface
installed in the MAC table in all VLANs that the port is a member of
will be a nightmare. Also think about reference counting (in DSA all
ports have the same MAC address by default. When should you remove the
MAC table entry corresponding to a port?) Also consider that I'd have
to change a lot of core DSA stuff for one switch.

>
> An other solution, is to skip the RX filtering, and when a port is not
> member of a beidge set the 'ANA:PORT[0-11]:CPU_FWD_CFG.CPU_SRC_COPY_ENA'
> bit. This will cause all fraems to be copied to the CPU. Again, we need
> to find a way to do this which does not affect Ocelot.

But I don't want to do this, do I? I want a forwarding path towards
the CPU, not to spam the CPU.

>
> /Allan
>

Regards,
-Vladimir
