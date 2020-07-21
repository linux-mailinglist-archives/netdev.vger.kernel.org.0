Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15C8227507
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgGUBzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:55:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39919 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbgGUBzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 21:55:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9hWl2mDPz9sRN;
        Tue, 21 Jul 2020 11:55:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595296547;
        bh=TI85x241LSmUe5XSIcekXqnHuC4GGWRab8yFSyRxlcA=;
        h=Date:From:To:Cc:Subject:From;
        b=rzD/T6BpJhz2r+IQFX9QKORBhyA5HAbA7+b4IQmdYhQ9008KKKBjb1hlf1NWGLkMJ
         JOXwGUSHbXajBkfZu1PlocMtvP/ZdZ9p8VppMstdnbtzj6cMtuWyKCL1zqGmzs5OM7
         pTWHcYD6Au+3oPPLDI+M4ql1NY1p6uNwPK6kOPr3Nfa13vTu9QSqslAawD6C+2p8gZ
         yX8bDrdU2qwZuTtlPHLIkruDRW8r4UA7qdARBJhRH4SYMfk5VRSIg/e7hc0s2gqCL/
         LXbxafwNdv6upHrRwRRjQ6kQVs98Gs0lbpwAjA2TjLHplbxH0IDByLWaMQv/BQUUI5
         kvu9garkZNOOQ==
Date:   Tue, 21 Jul 2020 11:55:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nikita Danilov <ndanilov@marvell.com>,
        Pavel Belous <pbelous@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200721115544.338fa4c1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aERApVzZM/gwHEPnOdxV1B7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aERApVzZM/gwHEPnOdxV1B7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/aquantia/atlantic/aq_hw.h

between commit:

  23e500e88723 ("net: atlantic: disable PTP on AQC111, AQC112")

from the net tree and commit:

  1e41b3fee795 ("net: atlantic: add support for 64-bit reads/writes")

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

diff --cc drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index 992fedbe4ce3,95ee1336ac79..000000000000
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@@ -64,7 -67,7 +67,8 @@@ struct aq_hw_caps_s=20
  	u8 rx_rings;
  	bool flow_control;
  	bool is_64_dma;
+ 	bool op64bit;
 +	u32 quirks;
  	u32 priv_data_len;
  };
 =20

--Sig_/aERApVzZM/gwHEPnOdxV1B7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8WSyAACgkQAVBC80lX
0GywIgf/YcPIa/ZunWj5EEScYBGTVxb1CE/vfw994++hj5Wo3PSTsMIispL4JcOJ
A8jXjeI7N6GXKNol03QtPy1yK0DNEydvgjrx6f8w12D5N9Zhqx2MNVTU1X/cW+Am
a7JYcbi4w7mQ0WkgMxDXitulJ0n9azNynIycaofQ3FX8+KZ6ci9Y0XX47VPxo71j
SP7xf0I6mdHRUWzRLtgLPfunUFyhp3kBHLN4SVLXzEirrBQAm3IzA0jGlEkYEX2j
3ao8/bAvwyz//Cjz45FpsgAM1Fd+aOL0yEmcm62gD6jibSNhk+Dv2yP9oIznK/ha
gZ4imhw0EeGWm9u1gLoyacuOftO+ww==
=6NSN
-----END PGP SIGNATURE-----

--Sig_/aERApVzZM/gwHEPnOdxV1B7--
