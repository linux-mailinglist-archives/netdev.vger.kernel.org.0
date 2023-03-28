Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2AB6CB9A9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjC1IoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjC1IoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:44:01 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0848B4699;
        Tue, 28 Mar 2023 01:43:57 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E7EB9240006;
        Tue, 28 Mar 2023 08:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1679993036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Stn5bBio8UE0UiwH0VU1eqH2PnrSrakBk4jMUQ6LNnk=;
        b=CyrHakV1lihwtAFspGj4zHOIkyObdwKaJd54VW+yLyEM0hI+0gWCPUXJKAxIaGRSsDYu3c
        8dcsxdqes5FCIQski7mvtEfKc9p7EJYw+nFpoZcKhx47ekbXnAwGr9O8aduJSJMh7npCwT
        NUZvOdmvDzp68lSjBNjEpF9Z22/ePyG1RvAwS+lWXYJXN2MNjHPLChQ1F519ynL2Vr2cx/
        SlPjTgL0ZNVZjxsHNY4uZg888hC13f/8DqQkzIxm/goR7JQiJsdZJMOFI5WF5mnoZM5aVx
        shbQfL6q3mBEYAK9xwA/NO2KuIaNhOP59CvhhYNPrvfuCh55OM+dbCovGnhSJg==
Date:   Tue, 28 Mar 2023 10:44:29 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230328104429.5d2e475a@fixe.home>
In-Reply-To: <20230324220042.rquucjt7dctn7xno@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-1-clement.leger@bootlin.com>
        <20230314163651.242259-4-clement.leger@bootlin.com>
        <20230314163651.242259-4-clement.leger@bootlin.com>
        <20230314233454.3zcpzhobif475hl2@skbuf>
        <20230315155430.5873cdb6@fixe.home>
        <20230324220042.rquucjt7dctn7xno@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sat, 25 Mar 2023 00:00:42 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> Hi Cl=C3=A9ment,
>=20
> I'm very sorry for the delay.

No worries !

>=20
> On Wed, Mar 15, 2023 at 03:54:30PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > The documentation is public and available at [1]. Section 4.5.3 is of
> > interest for your understanding of the VLAN filtering support. Let's
> > hope I answered most of your questions.
> >=20
> > [1]
> > https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1=
l-group-users-manual-r-engine-and-ethernet-peripherals?r=3D1054561 =20
>=20
> Yes, indeed, it appears that you gave me this link before and I already
> had the PDF downloaded, but forgot about it... I've reorganized my
> documentation PDFs since then.

That's ok, I understand this not the only IP you need to review ;)

>=20
> > > - can it drop a VLAN which isn't present in the port membership list?
> > >   I guess this is what A5PSW_VLAN_DISC_SHIFT does. =20
> >=20
> > Yes, A5PSW_VLAN_DISC_SHIFT stands for "discard" which means the packet
> > is discarded if the port is not a member of the VLAN.
> > A5PSW_VLAN_VERI_SHIFT is meant to enable VLAN lookup for packet
> > flooding (instead of the default lookup). =20
>=20
> OK. IMO, this driver should always enable VLANDISC and VLANVERI for all
> ports, no matter whether under a VLAN-aware bridge or not. But more on
> that at the end.
>=20
> > > - can it use VLAN information from the packet (with a fallback on the
> > >   port PVID) to determine where to send, and where *not* to send the
> > >   packet? How does this relate to the flooding registers? Is the flood
> > >   mask restricted by the VLAN mask? Is there a default VLAN installed=
 in
> > >   the hardware tables, which is also the PVID of all ports, and all
> > >   ports are members of it? Could you implement standalone/bridged port
> > >   forwarding isolation based on VLANs, rather than the flimsy and most
> > >   likely buggy implementation done based on flooding domains, from th=
is
> > >   patch set? =20
> >=20
> > Yes, the VLAN membership is used for packet flooding. The flooding
> > registers are used when the packets come has a src MAC that is not in =
=20
>=20
> s/src/destination/
>=20
> > the FDB. For more infiormation, see section 4.5.3.9, paragraph 3.c
> > which describe the whole lookup process. =20
>=20
> Ok, got it. So UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
> are only used for flooding, if the packet doesn't see any hit in the
> VLAN resolution table.

Yes exactly (at least that is why the documentation describes).

>=20
> And, I guess, if BIT(port) is unset in VLAN_IN_MODE_ENA, then untagged
> packets will not see any hit in the VLAN resolution table.
> But, if VLAN_IN_MODE_ENA contains BIT(port) and VLAN_IN_MODE is set to,
> say, TAG_ALWAYS for BIT(port), then all frames (including untagged
> frames) will get encapsulated in the VLAN from SYSTEM_TAGINFO[port].
> In that case, the packets will always hit the VLAN resolution table
> (assuming that the VID from $SYSTEM_TAGINFO[port] was installed there),

Yes, indeed and when adding a PVID, the documentation states that the
port must also be a member of the VLAN ID when vlan verification is
enabled:

In addition, if VLAN verification is enabled for a port (see Section
4.4.5, VLAN_VERIFY =E2=80=94 Verify VLAN Domain), the VLAN id used for
insertion (SYSTEM_TAGINFO[n]) must also be configured in the global
VLAN resolution table (see Section 4.4.51, VLAN_RES_TABLE[n] =E2=80=94 32 V=
LAN
Domain Entries (n =3D 0..31)), to ensure the switch accepts frames, which
contain the inserted tag.

> and the UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
> flooding masks are never used for traffic coming from this port; but
> rather, only the VLAN resolution table decides the destination ports.
>=20
> Did I get this right?

Yes I think so.

>=20
> > Regarding your other question, by default, there is no default VLAN
> > installed but indeed, I see what you mean, a default VLAN could be used
> > to isolate each ports rather than setting the rule to forward only to
> > root CPU port + disabling of flooding. I guess a unique VLAN ID per port
> > should be used to isolate each of them and added to the root port to
> > untag the input frames tagged with the PVID ? =20
>=20
> For example, hellcreek_setup_vlan_membership() does something like this
> already. But your switch only has 32 VLANs.
>=20
> > > - is the FDB looked up per {MAC DA, VLAN ID} or just MAC DA? Looking =
at
> > >   a5psw_port_fdb_add(), there's absolutely no sign of "vid" being use=
d,
> > >   so I guess it's Shared VLAN Learning. In that case, there's absolut=
ely
> > >   no hope to implement ds->fdb_isolation for this hardware. But at the
> > >   *very* least, please disable address learning on standalone ports,
> > >   *and* implement ds->ops->port_fast_age() so that ports quickly forg=
et
> > >   their learned MAC adddresses after leaving a bridge and become
> > >   standalone again. =20
> >=20
> > Indeed, the lookup table does not contain the VLAN ID and thus it is
> > unused. We talked about it in a previous review and you already
> > mentionned that there is no hope to implement fdb_isolation. =20
>=20
> Yes, I vaguely remember. In any case, absolutely horrible, and let me
> explain why.
>=20
> AFAIU from the documentation, the (VLAN-unaware) MAC Address Lookup table
> always decides where the packet should go, if there is a MAC DA hit.
> Whereas the VLAN Resolution table decides if the packet can go there.
>=20
> The problem is that setups like this will not work for the a5psw:
>=20
>                 ___ br0__
>                /     |   \
>               /      |    \
> (software) bond0     |     \
>           /    \     |      |
>         swp0  swp1  swp2  swp3
>          |                  |
>          |                  |
>          |                  |
>      station A          station B
>=20
> DSA has logic to support bond0 as an unoffloaded bridge port (swp0 and
> swp1 are standalone and pass all traffic just to/from the CPU port), in
> the same bridging domain with swp2 and swp3, which do offload the
> bridging process.
>=20
> Assume station B wants to ping station A.
>=20
> swp3 learns the MAC SA (station B's MAC address) from the ICMP request
> as a FDB entry towards swp3. The MAC DA for the packet is unknown, so it
> is flooded to swp2 and to the CPU port. From there, the software bridge
> delivers the packet to bond0, which delivers it to swp0, and it reaches
> station A.
>=20
> Station A sends an ICMP reply to station B's MAC DA.
>=20
> When swp0 receives this packet, the MAC Address Lookup table finds an
> FDB entry saying that the packet should go to swp3. But the VLAN
> Resolution table says that swp3 is unreachable from swp0. So, the packet
> is dropped.
>=20
> There is simply no way this can work if the MAC Address Lookup table is
> VLAN-unaware. What should have happened is that swp0 should have not
> been able to find the FDB entry towards swp3, because swp0 is standalone,
> and swp3 is under a bridge.

Ok got it !

>=20
> Hmm, this makes me want to go to dsa_slave_changeupper() and to disable
> all the "Offloading not supported" fallback code paths, unless
> ds->fdb_isolation is set to true, so that people don't run into this
> pitfall. However, only the drivers that I maintain have FDB isolation,
> so that would disable the fallback for a lot of people :(

Hum indeed, that would be nice to have a way to forbid that on switches
that have a vlan-unaware fdb (probably not so common though).

>=20
> > Ok for disabling learning on standalone ports, and indeed, by default,
> > it's enabled. =20
>=20
> Okay. Disabling address learning on standalone ports should help with
> some use cases, like when all ports are standalone and there is no
> bridging offload.

Based on my previous comment, if I remove standalone ports from the
flooding mask, disable learning on them and if the port is fast aged
when leaving a bridge, it seems correct to assume this port will never
receive nor forward packets from other port and also thanks to the
matching rule we set for standalone ports, it will only send packets to
CPU port. Based on that I think I can say that the port will be truly
standalone. This also allows to keep the full 32 VLANs available for
stadnard operations.

>=20
> > Regarding ds->ops->port_fast_age(), it is already implemented. =20
>=20
> Sorry, I didn't notice that.
>=20
> > The port PVID itself is not used to filter the flooding mask. But each
> > time a PVID is set, the port must also be programmed as a membership of
> > the PVID VLAN ID in the VLAN resolution table. So actually, the PVID is
> > just here to tag (or not) the input packet, it does not take a role in
> > packet forwading. This is entirely done by the VLAN resolution table
> > content (VLAN_RES_TABLE register). =20
>=20
> I think I've understood that now, finally.
>=20
> > Does this means I don't have to be extra careful when programming it ? =
=20
>=20
> Actually, no :) you still do.
>=20
> What I don't think will work in your current setup of the hardware is thi=
s:
>=20
>  br0  (standalone)
>   |      |
>  swp0   swp1
>=20
> ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> ip link set swp0 master br0 && ip link set swp0 up
> bridge vlan add dev swp0 vid 100
> bridge fdb add 00:01:02:03:04:05 dev swp0 master static
>=20
> and then connect a station to swp1 and send a packet with
> { MAC DA 00:01:02:03:04:05, VID 100 }. It should only reach the CPU port
> of the switch, but it also leaks to swp0, am I right?

Actually, it won't leak to swp0 since, since we enable a specific
matching rule (MGMTFWD) for the standalone ports which ensure all the
lookup is bypassed and that the trafic coming from these ports is only
forwarded to the CPU port (see my comment at the end of this mail).

>=20
> I'm saying this because the standalone swp1 has vlan_filtering 0, so in
> the VLAN_VERIFY register, VLANVERI is 0 for swp1 (packets with VID 100 are
> accepted even if in the VLAN table, swp1 isn't a member of VID 100).
>=20
> [ hmm, if I'm correct about this, then I see that this situation isn't
>   covered in tools/testing/selftests/drivers/net/dsa/no_forwarding.sh.
>   Maybe we should add another entry to the selftest, for the "leak via
>   FDB entry" case ]
>=20
>=20
> This creates the very awkward situation where you have do the hard work
> and do everything exactly right (to avoid forwarding domain leaks), as
> if you were shooting for ds->fdb_isolation =3D true, but still do not get
> ds->fdb_isolation =3D true in the end (because the MAC table is VLAN
> unaware and there's nothing you can do about that). So, the software
> bonding scenario won't work, but at least it will result in packet drops
> (or, ideally, would be denied), and not in packet leaks. That's about
> the best scenario we're aiming for. So frustrating.
>=20
> I think the UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
> flooding destination masks are useless, because they are not keyed per
> source port, but global. This means that you need to be extraordinarily
> careful when you enable any port in these masks, because packets from
> literally any other port, which were untagged and didn't hit an entry in
> the MAC table, can reach there.
>=20
> To avoid forwarding leaks, I guess that:
>=20
> - each standalone port should be in a single VLAN with just the CPU
>   port. This would be achieved by setting A5PSW_VLAN_IN_MODE_ENA=3Dtrue to
>   enable VLAN input manipulation, and to set SYSTEM_TAGINFO[port] to
>   unique values per standalone port, together with VLAN_IN_MODE =3D
>   "always" and VLAN_OUT_MODE =3D "tag through" (to encapsulate all traffic
>   in the private port PVID, SYSTEM_TAGINFO, on ingress, and to
>   decapsulate it on egress). Then, care must be taken that the values
>   chosen for SYSTEM_TAGINFO[port] are reserved, and packets coming from
>   other ports are never able to be classified to the same VLANs.

Yep that is what I envisionned first when writing the driver but thanks
to the CPOU forward only rule, it was easier.=20

>=20
> - each port under a bridge which is currently VLAN-unaware should use
>   the same technique as for standalone ports, which is to set
>   SYSTEM_TAGINFO[port] to a reserved value, common for all ports under
>   the same bridge. That value can even be the standalone PVID of the
>   first port that joined the VLAN-unaware bridge. This way, you would
>   need to reserve no more than 4 VLANs, and you would keep reusing them
>   also for VLAN-unaware bridging.

However I did not thought about this part :) Indeed makes sense and
allows to use only 4 VLAN at most out of the 32s. By the way, this
bridge supports only a single bridge due to some registers being common
to all ports and not per bridge (flooding for instance...).

>=20
> - each port under a VLAN-aware bridge should set its SYSTEM_TAGINFO[port]
>   to the switchdev VLAN which has the BRIDGE_VLAN_INFO_PVID flag.
>=20
> If you reserve VLAN IDs of 4095, 4094, 4093, 4092 as special values to
> configure to SYSTEM_TAGINFO[port] when VLAN-unaware, then you must also
> reject port_vlan_add() of these VLANs, and you must ensure, using the
> VLAN Domain Verification function, that an "attacker" cannot sneak
> crafted packets through VLAN-aware bridge ports so that they are
> processed by the switch as if they were received on another ports.
>=20
> However, I do appreciate that 32 VLANs is not a lot, and that cropping 4
> of them is already 12.5%. The hardware designers probably didn't intend
> the switch to be used like that.
>=20
> Would it be possible to hack the 802.1X functionality of this switch
> such as to configure all standalone ports to "require authentication"?
> IIUC, that would mean that all traffic received on these ports is
> delivered by the switch straight to the management port, and it would
> bypass even the MAC table lookup, which would be good considering the
> software bonding use case, for example. It would also mean that you
> don't need to allocate one private SYSTEM_TAGINFO value per port.

After thinking about the current mechasnim, let me summarize why I
think it almost matches what you described in this last paragraph:

- Port is set to match a specific matching rule which will enforce port
  to CPU forwarding only based on the MGMTFWD bit of PATTERN_CTRL which
  states the following: "When set, the frame is forwarded to the
  management port only (suppressing destination address lookup)"

This means that for the "port to CPU" path when in standalone mode, we
are fine. Regarding the other "CPU to port" path only:

- Learning will be disabled when leaving the bridge. This will allow
  not to have any new forwarding entries in the MAC lookup table.

- Port is fast aged which means it won't be targeted for packet
  forwarding.

- We remove the port from the flooding mask which means it won't be
  flooded after being removed from the port.

Based on that, the port should not be the target of any forward packet
from the other ports. Note that anyway, even if using per-port VLAN for
standalone mode, we would also end up needing to disable learning,
fast-age the port and disable flooding (at least from my understanding
if we want the port to be truly isolated).

Tell me if it makes sense.

Thanks for your time reviewing and explaining all of that,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
