Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF63B71B0
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 14:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhF2MDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 08:03:43 -0400
Received: from phobos.denx.de ([85.214.62.61]:35362 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232788AbhF2MDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 08:03:40 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D5C4982859;
        Tue, 29 Jun 2021 14:01:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624968071;
        bh=NwGgCXJE1oeL3k+EimvcQDc0fBhsm5rumG+mnsU1V2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jAI7ToYgELz5x8rmLQ2660ifkdJVg0GTeVNrQgHEjRtaG4E5KvqVOD6mFp/9Ik8P8
         uw2/kruCg3QJrfX13p4vy5k1/GJ21zyrRhtTXMZIeux9FzMX3s6V2mBVEmVBgZVWBc
         Jw2Bc5nL2dooh9EQPfY5wAaLrWyo+PEr3+HBEKUEODZrz8rsz7ZoQ70Jy3UbghySwK
         EPNeLKZsbIC/+Xt1HYvFPOL2xw7MQeenw55GshU+CV/ESPHPUVs5lZ7eI4GiAjibRf
         YFY+VEX1LBqaJIBB2rJ+cAjw46vnScbO+r+aJ7/piCkG5BKJjKo93+PCAvZB9gLBSb
         R3LWaUah5NXOQ==
Date:   Tue, 29 Jun 2021 14:01:04 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210629140104.70a3da1a@ktm>
In-Reply-To: <20210629093055.x5pvcebk4y4f6nem@skbuf>
References: <YNSJyf5vN4YuTUGb@lunn.ch>
        <20210624163542.5b6d87ee@ktm>
        <YNSuvJsD0HSSshOJ@lunn.ch>
        <20210625115935.132922ff@ktm>
        <YNXq1bp7XH8jRyx0@lunn.ch>
        <20210628140526.7417fbf2@ktm>
        <20210628124835.zbuija3hwsnh2zmd@skbuf>
        <20210628161314.37223141@ktm>
        <20210628142329.2y7gmykoy7uh44gd@skbuf>
        <20210629100937.10ce871d@ktm>
        <20210629093055.x5pvcebk4y4f6nem@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/kfEcMgA6CAnN6.ZB_n3QJia"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/kfEcMgA6CAnN6.ZB_n3QJia
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Tue, Jun 29, 2021 at 10:09:37AM +0200, Lukasz Majewski wrote:
> > Hi Vladimir,
> > =20
> > > On Mon, Jun 28, 2021 at 04:13:14PM +0200, Lukasz Majewski wrote: =20
> > > > > > > So before considering merging your changes, i would like
> > > > > > > to see a usable binding.
> > > > > > >
> > > > > > > I also don't remember seeing support for STP. Without
> > > > > > > that, your network has broadcast storm problems when
> > > > > > > there are loops. So i would like to see the code needed
> > > > > > > to put ports into blocking, listening, learning, and
> > > > > > > forwarding states.
> > > > > > >
> > > > > > > 	  Andrew =20
> > > > >
> > > > > I cannot stress enough how important it is for us to see STP
> > > > > support and consequently the ndo_start_xmit procedure for
> > > > > switch ports. =20
> > > >
> > > > Ok.
> > > > =20
> > > > > Let me see if I understand correctly. When the switch is
> > > > > enabled, eth0 sends packets towards both physical switch
> > > > > ports, and eth1 sends packets towards none, but eth0 handles
> > > > > the link state of switch port 0, and eth1 handles the link
> > > > > state of switch port 1? =20
> > > >
> > > > Exactly, this is how FEC driver is utilized for this switch. =20
> > >
> > > This is a much bigger problem than anything which has to do with
> > > code organization. Linux does not have any sort of support for
> > > unmanaged switches. =20
> >
> > My impression is similar. This switch cannot easily fit into DSA
> > (lack of appending tags) =20
>=20
> No, this is not why the switch does not fit the DSA model.
> DSA assumes that the master interface and the switch are two
> completely separate devices which manage themselves independently.
> Their boundary is typically at the level of a MAC-to-MAC connection,
> although vendors have sometimes blurred this line a bit in the case
> of integrated switches. But the key point is that if there are 2
> external ports going to the switch, these should be managed by the
> switch driver. But when the switch is sandwiched between the Ethernet
> controller of the "DSA master" (the DMA engine of fec0) and the DSA
> master's MAC (still owned by fec), the separation isn't quite what
> DSA expects, is it? Remember that in the case of the MTIP switch, the
> fec driver needs to put the MACs going to the switch in promiscuous
> mode such that the switch behaves as a switch and actually forwards
> packets by MAC DA instead of dropping them. So the system is much
> more tightly coupled.
>=20
>  +-----------------------------------------------------------------------=
----+
>  |
>        | | +--------------+        +--------------------+--------+
>   +------------+ | |              |        | MTIP switch        |
>    |      |            | | |   fec 1 DMA  |---x    |
>   | Port 2 |------| fec 1 MAC  | | |              |        |
>   \  /    |        |      |            | | +--------------+        |
>            \/     +--------+      +------------+ |
>      |             /\              |                   | |
> +--------------+        +--------+   /  \    +--------+
> +------------+ | |              |        |        |           |
>  |      |            | | |   fec 0 DMA  |--------| Port 0 |
> | Port 1 |------| fec 0 MAC  | | |              |        |        |
>         |        |      |            | | +--------------+
> +--------+-----------+--------+      +------------+ |
>                                                           |
> +------------------------------------------------------------------------=
---+
>=20
> Is this DSA? I don't really think so, but you could still try to argue
> otherwise.
>=20
> The opposite is also true. DSA supports switches that don't append
> tags to packets (see sja1105). This doesn't make them "less DSA",
> just more of a pain to work with.
>=20
> > nor to switchdev.
> >
> > The latter is caused by two modes of operation:
> >
> > - Bypass mode (no switch) -> DMA1 and DMA0 are used
> > - Switch mode -> only DMA0 is used
> >
> >
> > Moreover, from my understanding of the CPSW - looks like it uses
> > always just a single DMA, and the switching seems to be the default
> > operation for two ethernet ports.
> >
> > The "bypass mode" from NXP's L2 switch seems to be achieved inside
> > the CPSW switch, by configuring it to not pass packets between
> > those ports. =20
>=20
> I don't exactly see the point you're trying to make here. At the end
> of the day, the only thing that matters is what you expose to the
> user. With no way (when the switch is enabled) for a socket opened on
> eth0 to send/receive packets coming only from the first port, and a
> socket opened on eth1 to send/receive packets coming only from the
> second port, I think this driver attempt is a pretty far cry from
> what a switch driver in Linux is expected to offer, be it modeled as
> switchdev or DSA.
>=20
> > > Please try to find out if your switch is supposed to be able
> > > to be managed (run control protocols on the CPU). =20
> >
> > It can support all the "normal" set of L2 switch features:
> >
> > - VLANs, lookup table (with learning), filtering and forwarding
> >   (Multicast, Broadcast, Unicast), priority queues, IP snooping,
> > etc.
> >
> > Frames for BPDU are recognized by the switch and can be used to
> > implement support for RSTP. However, this switch has a separate
> > address space (not covered and accessed by FEC address).
> > =20
> > > If not, well, I
> > > don't know what to suggest. =20
> >
> > For me it looks like the NXP's L2 switch shall be treated _just_ as
> > offloading IP block to accelerate switching (NXP already support
> > dpaa[2] for example).
> >
> > The idea with having it configured on demand, when:
> > ip link add name br0 type bridge; ip link set br0 up;
> > ip link set eth0 master br0;
> > ip link set eth1 master br0;
> >
> > Seems to be a reasonable one. In the above scenario it would work
> > hand by hand with FEC drivers (as those would handle PHY
> > communication setup and link up/down events). =20
>=20
> You seem to imply that we are suggesting something different.
>=20
> > It would be welcome if the community could come up with some rough
> > idea how to proceed with this IP block support =20
>=20
> Ok, so what I would do if I really cared that much about mainline
> support is I would refactor the FEC driver to offer its core
> functionality to a new multi-port driver that is able to handle the
> FEC DMA interfaces, the MACs and the switch. EXPORT_SYMBOL_GPL is your
> friend.
>=20
> This driver would probe on a device tree binding with 3 "reg" values:
> 1 for the fec@800f0000, 1 for the fec@800f4000 and 1 for the
> switch@800f8000. No puppet master driver which coordinates other
> drivers, just a single driver that, depending on the operating state,
> manages all the SoC resources in a way that will offer a sane and
> consistent view of the Ethernet ports.
>=20
> So it will have a different .ndo_start_xmit implementation depending
> on whether the switch is bypassed or not (if you need to send a
> packet on eth1 and the switch is bypassed, you send it through the
> DMA interface of eth1, otherwise you send it through the DMA
> interface of eth0 in a way in which the switch will actually route it
> to the eth1 physical port).
>=20
> Then I would implement support for BPDU RX/TX (I haven't looked at the
> documentation, but I expect that what this switch offers for control
> traffic doesn't scale at high speeds (if it does, great, then send and
> receive all your packets as control packets, to have precise port
> identification). If it doesn't, you'll need a way to treat your data
> plane packets differently from the control plane packets. For the data
> plane, you can perhaps borrow some ideas from net/dsa/tag_8021q.c, or
> even from Tobias Waldekranz's proposal to just let data plane packets
> coming from the bridge slide into the switch with no precise control
> of the destination port at all, just let the switch perform FDB
> lookups for those packets because the switch hardware FDB is supposed
> to be more or less in sync with the bridge software FDB:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.17891=
86-1-tobias@waldekranz.com/
>=20

Thanks for sketching and sharing such detailed plan.=20

> > (especially that for example imx287 is used in many embedded devices
> > and is going to be in active production for next 10+ years). =20
>=20
> Well, I guess you have a plan then. There are still 10+ years left to
> enjoy the benefits of a proper driver design...

:-)


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/kfEcMgA6CAnN6.ZB_n3QJia
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDbC4AACgkQAR8vZIA0
zr1wGwgAqaycwPhYj9dU716qF/vndzUI6j4akH9VpCHuI/HD8ADXc3VLblvJpV91
+lE0arn/1iGxzsnsy8wxLStlM0vFLAXiBqJWGPgQom9ELdKNUjeHx41BrSqVLkVW
RwaK+ZeDFAvekB51fwELw25KcHjixtMpWwZoARgkFahS5Kc4F4qCbXLfg4Pol9Pa
qP1W6gjsecPORCmTpteKITpYACeV5eCcepXpuuvKsa4Y3fJAEogSmfqysd9z2pG3
A/dvUSKh6LwIRnJGFq/xkW/2VGI+Itm42dIFPX8RCnSQYbR8qPfI2HBmlQZeRU4I
pvrOkhXujbfUKB48UXp88gi5CLU5/A==
=uxrj
-----END PGP SIGNATURE-----

--Sig_/kfEcMgA6CAnN6.ZB_n3QJia--
