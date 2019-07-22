Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB236FFF5
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 14:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbfGVMmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 08:42:43 -0400
Received: from vps.xff.cz ([195.181.215.36]:32938 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727510AbfGVMmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 08:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xff.cz; s=mail;
        t=1563799360; bh=Ckr9Ubp2dXbBZzwxo/Cv6y0gaoBWR3DUFXRixg2I/UE=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=EgaBM0ZrhDBaZ2QwDxirDrRyfisC+FwF2ehEjDEh1JYvJmJUXf1VBSTkCKXiPs+yL
         SaheZsDDOWK+YhDarhmZrzuWBrE5oco19z5D5r7kf4mt6FNh1KRj9A1pu9WqUj6FDx
         1/cAb3F849ttB4IigOmheYm3zh/rnXErbTJALFa4=
Date:   Mon, 22 Jul 2019 14:42:40 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megi@xff.cz>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Message-ID: <20190722124240.464e73losonwb356@core.my.home>
Mail-Followup-To: Jose Abreu <Jose.Abreu@synopsys.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3kbao36czv4w7rlp"
Content-Disposition: inline
In-Reply-To: <cover.1560266175.git.joabreu@synopsys.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3kbao36czv4w7rlp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jose,

On Tue, Jun 11, 2019 at 05:18:44PM +0200, Jose Abreu wrote:
> [ Hope this diff looks better (generated with --minimal) ]
>=20
> This converts stmmac to use phylink. Besides the code redution this will
> allow to gain more flexibility.

I'm testing 5.3-rc1 and on Orange Pi 3 (uses stmmac-sun8i.c glue) compared =
to
5.2 it fails to detect 1000Mbps link and the driver negotiates just a 10Mbp=
s speed.

After going through stmmac patches since 5.2, I think it may be realted to =
this
series, but I'm not completely sure. You'll probably have a better understa=
nding
of the changes. Do you have an idea what might be wrong? Please, see some l=
ogs
below.

thank you and regards,
	Ondrej

On 5.3-rc1 I see:

[    6.116512] dwmac-sun8i 5020000.ethernet eth0: PHY [stmmac-0:01] driver =
[RTL8211E Gigabit Ethernet]
[    6.116522] dwmac-sun8i 5020000.ethernet eth0: phy: setting supported 00=
,00000000,000062cf advertising 00,00000000,000062cf
[    6.118714] dwmac-sun8i 5020000.ethernet eth0: No Safety Features suppor=
t found
[    6.118725] dwmac-sun8i 5020000.ethernet eth0: No MAC Management Counter=
s available
[    6.118730] dwmac-sun8i 5020000.ethernet eth0: PTP not supported by HW
[    6.118738] dwmac-sun8i 5020000.ethernet eth0: configuring for phy/rgmii=
 link mode
[    6.118747] dwmac-sun8i 5020000.ethernet eth0: phylink_mac_config: mode=
=3Dphy/rgmii/Unknown/Unknown adv=3D00,00000000,000062cf pause=3D10 link=3D0=
 an=3D1
[    6.126099] dwmac-sun8i 5020000.ethernet eth0: phy link down rgmii/Unkno=
wn/Unknown
[    6.276325] random: crng init done
[    6.276338] random: 7 urandom warning(s) missed due to ratelimiting
[    7.543987] zram0: detected capacity change from 0 to 402653184
[    7.667702] Adding 393212k swap on /dev/zram0.  Priority:10 extents:1 ac=
ross:393212k SS

=2E.. delay due to other causes ...

[   28.640234] dwmac-sun8i 5020000.ethernet eth0: phy link up rgmii/10Mbps/=
Full
[   28.640295] dwmac-sun8i 5020000.ethernet eth0: phylink_mac_config: mode=
=3Dphy/rgmii/10Mbps/Full adv=3D00,00000000,00000000 pause=3D0f link=3D1 an=
=3D0
[   28.640324] dwmac-sun8i 5020000.ethernet eth0: Link is Up - 10Mbps/Full =
- flow control rx/tx

Settings for eth0:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full=20
	                        100baseT/Half 100baseT/Full=20
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full=20
	                        100baseT/Half 100baseT/Full=20
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full=20
	Link partner advertised pause frame use: Symmetric Receive-only
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 10Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: yes

On 5.2 it looks like this:

[    1.153596] dwmac-sun8i 5020000.ethernet: PTP uses main clock
[    1.416221] dwmac-sun8i 5020000.ethernet: PTP uses main clock
[    1.522735] dwmac-sun8i 5020000.ethernet: Current syscon value is not th=
e default 58000 (expect 50000)
[    1.522750] dwmac-sun8i 5020000.ethernet: No HW DMA feature register sup=
ported
[    1.522753] dwmac-sun8i 5020000.ethernet: RX Checksum Offload Engine sup=
ported
[    1.522755] dwmac-sun8i 5020000.ethernet: COE Type 2
[    1.522758] dwmac-sun8i 5020000.ethernet: TX Checksum insertion supported
[    1.522761] dwmac-sun8i 5020000.ethernet: Normal descriptors
[    1.522763] dwmac-sun8i 5020000.ethernet: Chain mode enabled
[    5.352833] dwmac-sun8i 5020000.ethernet eth0: No Safety Features suppor=
t found
[    5.352842] dwmac-sun8i 5020000.ethernet eth0: No MAC Management Counter=
s available
[    5.352846] dwmac-sun8i 5020000.ethernet eth0: PTP not supported by HW
[   10.463072] dwmac-sun8i 5020000.ethernet eth0: Link is Up - 1Gbps/Full -=
 flow control off

Settings for eth0:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Half 1000baseT/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Half 1000baseT/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full
	                                     100baseT/Half 100baseT/Full
	                                     1000baseT/Full
	Link partner advertised pause frame use: Symmetric Receive-only
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: yes


> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>=20
> Jose Abreu (3):
>   net: stmmac: Prepare to convert to phylink
>   net: stmmac: Start adding phylink support
>   net: stmmac: Convert to phylink and remove phylib logic
>=20
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   3 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 +-
>  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  81 +---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 391 ++++++++----------
>  .../ethernet/stmicro/stmmac/stmmac_platform.c |  21 +-
>  5 files changed, 190 insertions(+), 313 deletions(-)
>=20
> --=20
> 2.21.0
>=20

--3kbao36czv4w7rlp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTr+93hH7kY1E0fVsH58Khzvpd37QUCXTWvMgAKCRD58Khzvpd3
7dkTAQCOB6DH3l6Wua607gFTc2dShYKitfh7zsm41XMP5V+nbwEAhMZSzgaxdkqC
Qjy6pW350aW360Zhjkfjfs6YJ2DMUwQ=
=Rdw6
-----END PGP SIGNATURE-----

--3kbao36czv4w7rlp--
