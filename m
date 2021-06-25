Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D896E3B4107
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhFYKCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:02:06 -0400
Received: from phobos.denx.de ([85.214.62.61]:53410 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhFYKCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 06:02:05 -0400
Received: from ktm (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 30403829BE;
        Fri, 25 Jun 2021 11:59:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624615183;
        bh=gdYanvGSzDRlcAUO0Yh0FR9zxuzSoEjpPYMgRTCkuzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rROYKipvUS77ZhVzTbUUNl4HhKLxOEBEXuptOhgUBstC7UG4iZ8Kn+c/w2QSbhAHN
         XoVOln/4jK5nbYOOUxsja/OUW2x6iXosolkm9k8QnsYh9z3vO+NLiFavz17DOhwqNZ
         oNrS+YiO0FxFGRB96/OCgimwGYCSk9Oa4WljFILBAPZCdHVLo/MTfbg7L4mH+kVswx
         R40OiLGz7+9FuvfqaN7XtoKDn5ay3ECFcmFErZQifKk2kqWi1F65KApHJhedteEnFl
         LE4k+tV0C/OMSjAHMNFoYUwC4jduP+AKk+0kTO9RawYgWu/6m5r/1/63ZrCOBLuanq
         x2nksAQ/LT/jw==
Date:   Fri, 25 Jun 2021 11:59:35 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210625115935.132922ff@ktm>
In-Reply-To: <YNSuvJsD0HSSshOJ@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
        <20210622144111.19647-3-lukma@denx.de>
        <YNH7vS9FgvEhz2fZ@lunn.ch>
        <20210623133704.334a84df@ktm>
        <YNOTKl7ZKk8vhcMR@lunn.ch>
        <20210624125304.36636a44@ktm>
        <YNSJyf5vN4YuTUGb@lunn.ch>
        <20210624163542.5b6d87ee@ktm>
        <YNSuvJsD0HSSshOJ@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/HH17enIFFxd8w1TzOqPbMaA"; protocol="application/pgp-signature"
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/HH17enIFFxd8w1TzOqPbMaA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Thu, Jun 24, 2021 at 04:35:42PM +0200, Lukasz Majewski wrote:
> > Hi Andrew,
> >  =20
> > > > I'm not sure if the imx28 switch is similar to one from TI
> > > > (cpsw-3g)
> > > > - it looks to me that the bypass mode for both seems to be very
> > > > different. For example, on NXP when switch is disabled we need
> > > > to handle two DMA[01]. When it is enabled, only one is used. The
> > > > approach with two DMAs is best handled with FEC driver
> > > > instantiation.   =20
> > >=20
> > > I don't know if it applies to the FEC, but switches often have
> > > registers which control which egress port an ingress port can send
> > > packets to. So by default, you allow CPU to port0, CPU to port1,
> > > but block between port0 to port1. This would give you two
> > > independent interface, the switch enabled, and using one DMA.
> > > When the bridge is configured, you simply allow port0 and
> > > send/receive packets to/from port1. No change to the DMA setup,
> > > etc. =20
> >=20
> > Please correct me if I misunderstood this concept - but it seems
> > like you refer to the use case where the switch is enabled, and by
> > changing it's "allowed internal port's" mapping it decides if
> > frames are passed between engress ports (port1 and port2). =20
>=20
> Correct.
>=20
>=20
> > 	----------
> > DMA0 ->	|P0    P1| -> ENET-MAC (PHY control) -> eth0 (lan1)
> > 	|L2 SW	 |
> > 	|      P2| -> ENET-MAC (PHY control) -> eth1 (lan2)
> > 	----------
> >=20
> > DMA1 (not used)
> >=20
> > We can use this approach when we keep always enabled L2 switch.
> >=20
> > However now in FEC we use the "bypass" mode, where:
> > DMA0 -> ENET-MAC (FEC instance driver 1) -> eth0
> > DMA1 -> ENET-MAC (FEC instance driver 2) -> eth1
> >=20
> > And the "bypass" mode is the default one. =20
>=20
> Which is not a problem, when you refactor the FEC into a library and a
> driver, plus add a new switch driver. When the FEC loads, it uses
> bypass mode, the switch disabled. When the new switch driver loads, it
> always enables the switch, but disables communication between the two
> ports until they both join the same bridge.

Ok, the proposed idea would be to use FEC (refactored) on devices which
are not equipped with the switch.

On devices, which have this IP block (like vf610, imx287) we would use
the driver with switch enabled and then in switch either bridge or
separate the traffic?

>=20
> But i doubt we are actually getting anywhere. You say you don't have
> time to write a new driver.

Yes, I believe that this would be a very time consuming task. Joakim
also pointed out that the rewrite from NXP will not happen anytime soon.

> I'm not convinced you can hack the FEC
> like you are suggesting=20

I do believe that I can just extend the L2 switch driver (fec_mtip.c
file to be precise) to provide full blown L2 switch functionality
without touching the legacy FEC more than in this patch set.

Would you consider applying this patch series then?

> and not end up in the mess the cpsw had,
> before they wrote a new driver.

I do see some conceptual differences between those two drivers.

>=20
>        Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/HH17enIFFxd8w1TzOqPbMaA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmDVqQcACgkQAR8vZIA0
zr0u0Qf9HhUfM14c/5OoAaQ5tMLlAthPnr4oaFv+IzjgvQSUSzmsPeme/gZsj8Hq
anDl1KWQ+leqH3iA7dmgWZz8uu5mYC3nNQ4GZYrK/5sV6kWBPlL/67chlf+WD/dv
aj1hmrivLCAAt20WFB0GYQgUH/IKPLdpIMnwO+ztyj1bBx26CqMC+12B68Rgh51l
fiZrL09UYiGlnvJG3Nt+1RzbHLumXClphxhQH8oRCBcVMWaTPJQqetyrnszDlCDK
SnuBoEuc80ym8s0Nw19ruuZhitWPjz/tzdPoK2Ue0s39kOhV5OK4leaIMwvcqcDN
gnb/ErF82xM6pij+8VHG/xuA1UNBCA==
=4WKs
-----END PGP SIGNATURE-----

--Sig_/HH17enIFFxd8w1TzOqPbMaA--
