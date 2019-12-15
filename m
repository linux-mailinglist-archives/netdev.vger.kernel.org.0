Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19B311FBC4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 00:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfLOXMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 18:12:55 -0500
Received: from ozlabs.org ([203.11.71.1]:45365 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfLOXMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 18:12:54 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47bgDL6sJ8z9sP3;
        Mon, 16 Dec 2019 10:12:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576451571;
        bh=zMiqmzCvgcqHx+0yaRnTJO+6mueTexFJgMghjoYNm7A=;
        h=Date:From:To:Cc:Subject:From;
        b=vKnk1KARJQ3FRioXEfyRgoAX4RKCVCBFkKEhV58wugWQ9gE+olr9LO/XtvwV+q08t
         e4FCiWrKQo1y80EPVwEsUjdQ168Y3b+eXkR/vooAs47k3VL0jVuJbocYKJB0ylTS7D
         kPgeQLsxbZfL1X7A5f4Hpw+/hsLFo7nKKUcY1oA6bhtGnRpDwWeVYAovtKdvSZuwQh
         iwkaQa1AskI2G+fnXE2ogvRxUdVmLBplULyuj3qO72fRMa4IisTpUUCfXijgnTTocw
         ZIGQ9HafN5WnFtErab0/xHwV3VLqPuH8+hKO+0lluFbHJSx+eN4yqaJ7FA50WqE9CH
         rcC8ciCXPlcfA==
Date:   Mon, 16 Dec 2019 10:12:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191216101250.227b4bd6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7hR9Oyw+SWKUQlWvv/o.WDF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7hR9Oyw+SWKUQlWvv/o.WDF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/phy/phylink.c

between commit:

  9b2079c046a9 ("net: phylink: fix interface passed to mac_link_up")

from the net tree and commit:

  24cf0e693bb5 ("net: phylink: split link_an_mode configured and current se=
ttings")

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

diff --cc drivers/net/phy/phylink.c
index 1585eebb73fe,1e0e32c466ee..000000000000
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@@ -441,8 -445,9 +445,8 @@@ static void phylink_mac_link_up(struct=20
  	struct net_device *ndev =3D pl->netdev;
 =20
  	pl->cur_interface =3D link_state.interface;
- 	pl->ops->mac_link_up(pl->config, pl->link_an_mode,
+ 	pl->ops->mac_link_up(pl->config, pl->cur_link_an_mode,
 -			     pl->phy_state.interface,
 -			     pl->phydev);
 +			     pl->cur_interface, pl->phydev);
 =20
  	if (ndev)
  		netif_carrier_on(ndev);

--Sig_/7hR9Oyw+SWKUQlWvv/o.WDF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl32vfIACgkQAVBC80lX
0Gwe/Qf/QoChsQ8Jg9vaq/2tEj4B7hExBmJ6b5f1DHPjC5WYT3ddPcQHuzENJaJj
SQ5wyAmmKR+1LJdB6QK/QWv2y4+f3nLynO51OypRIFTJlvbUnqMf+gdG2zXblQEk
eStvuiV31hvKrDUQJ75oZWqnS2/iiMgstUuGNQhMzzVHP/N8UC88KVhNhNgOETTE
8q+tSCFsZuOPSfMECv16OcNXLrCtYpPSwDoVl2+DgPuXhOAPiTxbcJx+4+CuECPA
OfTlcfJcATFkS4TiKTR/63gB6Yt7AN4TzyoZgImRnNv+GCke37dIVCHJNa4aTytq
TYdkeAy2dLDIBqGyUerHfPF2VrxpZg==
=x3oB
-----END PGP SIGNATURE-----

--Sig_/7hR9Oyw+SWKUQlWvv/o.WDF--
