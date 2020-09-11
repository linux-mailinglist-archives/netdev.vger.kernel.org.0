Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC2265680
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgIKBRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:17:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44909 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgIKBRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:17:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BndCg1g9Cz9sV5;
        Fri, 11 Sep 2020 11:17:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1599787057;
        bh=LWyAdIS7WVTbxNr2SjDaV0cpjjjBFUm7NK4RyJZ+7Pc=;
        h=Date:From:To:Cc:Subject:From;
        b=t8LQWBMzi/l4dMpI8k8CyXYUqi5ON4wyS4mjbZLkSvLAI/7zW+nixIrMVVOJWTJfR
         IyggRjIP8tqba89IaB+0OnF0S6XjRxCIV72E1pLhccW6Y5Md+62V8RlLjxpBaMka/h
         WbvUCbG7hrUvo7rQV8rt2ww4YBrpI2UHvF4hDmSMA2I8KiIZSlSLFzae5f9KkD59YH
         MAfYpgELwGhiYIFRX921griXXMqdL9AYglrlcoOq44WDgDxm0BFyTtIhpHgPzshc7T
         y5Gulti2SlReie66DH0pPd4/yJd9hhE9tG3IFEu9Sl3QHmL50GUBMNwLLIwuQlIbCa
         hJyTaZYd4kIkA==
Date:   Fri, 11 Sep 2020 11:17:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200911111731.48a324d0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O1IAK=LqVcAtnf78bAe8pva";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/O1IAK=LqVcAtnf78bAe8pva
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/dsa/microchip/ksz9477.c

between commit:

  edecfa98f602 ("net: dsa: microchip: look for phy-mode in port nodes")

from the net tree and commit:

  805a7e6f5388 ("net: dsa: microchip: Improve phy mode message")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/dsa/microchip/ksz9477.c
index 2f5506ac7d19,b62dd64470a8..000000000000
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@@ -1229,12 -1229,15 +1229,15 @@@ static void ksz9477_port_setup(struct k
  			ksz9477_set_gbit(dev, true, &data8);
  			data8 &=3D ~PORT_RGMII_ID_IG_ENABLE;
  			data8 &=3D ~PORT_RGMII_ID_EG_ENABLE;
 -			if (dev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
 -			    dev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID)
 +			if (p->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
 +			    p->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID)
  				data8 |=3D PORT_RGMII_ID_IG_ENABLE;
 -			if (dev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
 -			    dev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)
 +			if (p->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
 +			    p->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)
  				data8 |=3D PORT_RGMII_ID_EG_ENABLE;
+ 			/* On KSZ9893, disable RGMII in-band status support */
+ 			if (dev->features & IS_9893)
+ 				data8 &=3D ~PORT_MII_MAC_MODE;
  			p->phydev.speed =3D SPEED_1000;
  			break;
  		}
@@@ -1276,22 -1280,21 +1281,30 @@@ static void ksz9477_config_cpu_port(str
  			 * note the difference to help debugging.
  			 */
  			interface =3D ksz9477_get_interface(dev, i);
 -			if (!dev->interface)
 -				dev->interface =3D interface;
 -			if (interface && interface !=3D dev->interface) {
 +			if (!p->interface) {
 +				if (dev->compat_interface) {
 +					dev_warn(dev->dev,
 +						 "Using legacy switch \"phy-mode\" property, because it is missing =
on port %d node. "
 +						 "Please update your device tree.\n",
 +						 i);
 +					p->interface =3D dev->compat_interface;
 +				} else {
 +					p->interface =3D interface;
 +				}
 +			}
- 			if (interface && interface !=3D p->interface)
- 				dev_info(dev->dev,
- 					 "use %s instead of %s\n",
- 					  phy_modes(p->interface),
- 					  phy_modes(interface));
++			if (interface && interface !=3D p->interface) {
+ 				prev_msg =3D " instead of ";
+ 				prev_mode =3D phy_modes(interface);
+ 			} else {
+ 				prev_msg =3D "";
+ 				prev_mode =3D "";
+ 			}
+ 			dev_info(dev->dev,
+ 				 "Port%d: using phy mode %s%s%s\n",
+ 				 i,
 -				 phy_modes(dev->interface),
++				 phy_modes(p->interface),
+ 				 prev_msg,
+ 				 prev_mode);
 =20
  			/* enable cpu port */
  			ksz9477_port_setup(dev, i, true);

--Sig_/O1IAK=LqVcAtnf78bAe8pva
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9a0CsACgkQAVBC80lX
0GwgVwgAjhDoosLD6E5rpvDHIOaa9kvp7nqC93q03BzCmkoeoKeEz0xqT+3kkV7z
+N9UzEsvUkDwo8Kfd6JbbTsVH+yp6fEDX/R/GTnqRHMoLIgvL2bnZbKAu/ixmNn5
rbLv1JnlaSo1OcNmk//FWm/Nx+Yj5zjyWZWdbvbymiuNeCH00huDJF2jQkPmaqyf
fKqTZFinAn0JlXyY6dddrEg4h2pcrJiHkXqnqah+ORhcwkVIQdx2eJmZCGDZPJtR
0MtblS+GEUd9vLMfGmch/r048VkohdKC+0Si3x2dNs46bke63IKzk3/iSga4PzAs
soAaSHL1GP+AAD+mtaFZ5ATPjvDnRA==
=cPgw
-----END PGP SIGNATURE-----

--Sig_/O1IAK=LqVcAtnf78bAe8pva--
