Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB833E828E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 08:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfJ2Hed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 03:34:33 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34799 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2Hec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 03:34:32 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iPM1G-0001xy-Aa; Tue, 29 Oct 2019 08:34:22 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iPM1D-00040d-Ib; Tue, 29 Oct 2019 08:34:19 +0100
Date:   Tue, 29 Oct 2019 08:34:19 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jay Cliburn <jcliburn@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Burton <paul.burton@mips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        James Hogan <jhogan@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v4 2/5] dt-bindings: net: dsa: qca,ar9331 switch
 documentation
Message-ID: <20191029073419.gjr4y7qsxx2javuf@pengutronix.de>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-3-o.rempel@pengutronix.de>
 <20191023003543.GE5707@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u2f62fix5h57o5vr"
Content-Disposition: inline
In-Reply-To: <20191023003543.GE5707@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:14:36 up 164 days, 13:32, 99 users,  load average: 0.00, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u2f62fix5h57o5vr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2019 at 02:35:43AM +0200, Andrew Lunn wrote:
> On Tue, Oct 22, 2019 at 07:57:40AM +0200, Oleksij Rempel wrote:
> > Atheros AR9331 has built-in 5 port switch. The switch can be configured
> > to use all 5 or 4 ports. One of built-in PHYs can be used by first buil=
t-in
> > ethernet controller or to be used directly by the switch over second et=
hernet
> > controller.
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>=20
> Hi Oleksij
>=20
> What we never really discussed is how this MUXing of the PHY works.
>=20
> What i'm worried about is that when we do understand how it works, we
> cannot properly support it using this binding.

good point. i would prefer to make it properly.

> Please could you try to find information about this.

Documentation says:
The PHY interfaces (PHY0, PHY1, PHY2, PHY3 and PHY4) can connect to the swi=
tch
in bridge mode. In this case GE0 must be under reset. All five LAN ports are
switched together and connect to the CPU through the GMII interface (MAC0),
which is controlled by the ETH_CFG register bit SW_ONLY_MODE. If GE0 connec=
ts
separately to PHY, then MAC5 should be under reset.

There is no SW_ONLY_MODE bit in the documentation.
I found:
CFG_SW_PHY_SWAP - Used to switch the wires connection of PHY port 0 with th=
at of
port 4 in the Ethernet switch. MAC1 and PHY4 are paired while MAC5 and PHY0=
 are
paired.

CFG_SW_PHY_ADDR_SWAP - Exchanges the address of PHY port 0 with that of
PHY port 4 in the Ethernet switch.

It feels like this are the right bits. I'll try to test it after ELC-E
conference (If you are here, please ping me).
If this are the right bits, should it be registered as separate driver? This
register is on MMIO and not part of the switches MDIO.

Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--u2f62fix5h57o5vr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl2363oACgkQ4omh9DUa
UbMsrhAAyX9oqX95zGk5geXaRVZUQDgHyGWtzPV48YtCkqD1boETt+0rQAgMoNLg
wVYewuMycs6BANMrjYq8wQJW0CrFkaOPW91yxMiUqITqEdYI8v+NS89Vd6/HDaZv
GhNB7LNU7GPCZWsLG1Cu1TvLCiQncFIFadj+oLGm+SzmsfsRKcR2awp4P7O3YfU1
qheNR9bNxD64YVQZB3n4+fXyZFjXST+w5cve5T4C4pttuVKQKVkW+ICgdv0AWj/3
KMA9CF5vSpgDPYeDw3JoAGl7yEMYVlkEG1fP03X1fCdcc1ZQvmI8RL3GaYfuuy1c
JNCQfARZu1BdKd2VYiVJx+qYW18fuKt5ywQo9HRITOS1l+8WBgDaN0dd/e1DK99H
47SNlevcspoo2aj1ibt9Q0ZdO+rW+Oqtx9JjHpQC+zaqAMdHFtsB5GXgHaZx0iXr
lqZs4Tc9PvwfuVDGRDUTNF1y8g+5PrgjdBPOHJ8J/0drrrt4gEPLyUvEZeHMm3K/
x99GEN5gxAYKQmYyNydjmTqZmv0NwjniZoPIswAUrETZIMEoAh088eDQ3zLXUGgx
GxGzl9Px7Omc7cJC5hQAimCIhjITGZMR+wF40rsoRrWcre1ZyPnDd1MGB0qik1Mz
HyFe2nVfXrnSKD2UZc7y3nne0UCGJGmxl+jfELNAbJ7PBdtNOH0=
=BzWE
-----END PGP SIGNATURE-----

--u2f62fix5h57o5vr--
