Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829CC27DEF6
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 05:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgI3DZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 23:25:26 -0400
Received: from ozlabs.org ([203.11.71.1]:46211 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgI3DZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 23:25:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1M8L55npz9sSG;
        Wed, 30 Sep 2020 13:25:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601436323;
        bh=u54S/ygKxoHQd93zauf7Zl/YQ7Ohsz0njaj6JvK12BQ=;
        h=Date:From:To:Cc:Subject:From;
        b=tZPbyFL/Un9ZbEW9flDKINmJehyEtp+G2Qmues8kfT/lzPpEznkgj9Gk6LDiJi7xS
         d5eUt/COklLHEZ47jK5pmYNL53WNf1x36pwCqFolaRdOKet5H0Wvdr41mLrM83sH16
         C97Q3gZGTjXhb8EyVgakNdbE0iyBOOa7p22ccPuxKUlWBqA1F8m1Gj9m9PlzNFUn1g
         UU4csg2PLc98N/e/YEU4Y3qcumMTnCs5IgOSqHmEcIWA8vW3LbONvUFaai4CylDdFa
         SbNqWFWBNPRnkD7asb8WX7hLzgvtizmuApGNlLM+NPzRYsRac4PvRcbl8SKuILYudo
         Y9nW+SDGyIVtA==
Date:   Wed, 30 Sep 2020 13:25:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Willy Liu <willy.liu@realtek.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200930132521.41e5b00d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FdD.lH2B3/sg9QFvd1eebk_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/FdD.lH2B3/sg9QFvd1eebk_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/phy/realtek.c

between commit:

  bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config")

from the net tree and commit:

  66e22932eb79 ("net: phy: realtek: enable ALDPS to save power for RTL8211F=
")

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

diff --cc drivers/net/phy/realtek.c
index 0f0960971800,4bf54cded48a..000000000000
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@@ -31,9 -33,13 +32,13 @@@
  #define RTL8211F_TX_DELAY			BIT(8)
  #define RTL8211F_RX_DELAY			BIT(3)
 =20
+ #define RTL8211F_ALDPS_PLL_OFF			BIT(1)
+ #define RTL8211F_ALDPS_ENABLE			BIT(2)
+ #define RTL8211F_ALDPS_XTAL_OFF			BIT(12)
+=20
 -#define RTL8211E_TX_DELAY			BIT(1)
 -#define RTL8211E_RX_DELAY			BIT(2)
 -#define RTL8211E_MODE_MII_GMII			BIT(3)
 +#define RTL8211E_CTRL_DELAY			BIT(13)
 +#define RTL8211E_TX_DELAY			BIT(12)
 +#define RTL8211E_RX_DELAY			BIT(11)
 =20
  #define RTL8201F_ISR				0x1e
  #define RTL8201F_IER				0x13

--Sig_/FdD.lH2B3/sg9QFvd1eebk_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9z+qEACgkQAVBC80lX
0GyY9Qf/cXBMXSwNE2gVWs91tBnwk1S3Z8hmsbC/Kfg+lhU8x4NlvFIRLmw7hq14
/4IueTPX1EuPDna9IlWyEKM3LtJlSIxvrLD1+rirH8v6L4pzvqWO5VNtjXONljvK
w769jrD47MzrIOo8DrC0P8EpSJukr3KWqdHG1t0p0B8wwSvAXRQwBzSOVXwY1YkL
GKrbytiDr8zePgcIS4FsnwieflJBuJ/0dqnfSAarVRseuhTdQecV1TtibNuCwuql
5OO/d7jsPNoKSMaNvA0iMsdP2Nx2q1xRLlMqPCEDt0g9DHqVuQYzWvPV6nOcRcSQ
uNgYkRLtUBgKyRiupZwLMyJhcaxc5Q==
=8cSi
-----END PGP SIGNATURE-----

--Sig_/FdD.lH2B3/sg9QFvd1eebk_--
