Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4404D346E96
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhCXBVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:21:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42141 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCXBVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 21:21:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F4r6p1GBsz9sWV;
        Wed, 24 Mar 2021 12:21:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616548898;
        bh=CKifn0z86IKcRhsxJ3SNEoPSfhGODKU1yWl6/rCV2e0=;
        h=Date:From:To:Cc:Subject:From;
        b=st+1XGjJboPmiNh3ngNoDeqcOCvYvOLUuUM4X0CiczPhPJtw47FaOot9wfj0Aefvx
         f1vY4XJ4PcuxwLp+dHld+ThbAR+6+nd/SvTxY+D/ri/bQ734HwnxG/szva+OQ9206K
         ZS+x00jC3E1ZUifiJD+y5yrJmFM/ZQMWkKlfW2LC0tEVnq7znvpXRf8UWBAynpXGmi
         soTFoBQFe/BrQgAoE7JhPzzHX9UEWOSwbzFpRbfaZmxHv+nTLA9jk4CznMjbNhYg0g
         +SzwiBhypbMYGXRIR2SSUa8hI7eeSP2ISCrKagqshDMgXtCLp42B8/UZyA8IGKo9pT
         jRPmZG03Zv54g==
Date:   Wed, 24 Mar 2021 12:21:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Wan Jiabing <wanjiabing@vivo.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210324122137.5ff8f0b2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mQspNTZzRq=1d96KhQCGZS2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mQspNTZzRq=1d96KhQCGZS2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c

between commit:

  7c1ef1959b6f ("net/mlx5: SF, do not use ecpu bit for vhca state processin=
g")

from the net tree and commit:

  4c94fe88cde4 ("net: ethernet: Remove duplicate include of vhca_event.h")

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

diff --cc drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index a5a0f60bef66,3c8a00dd573a..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@@ -5,8 -5,7 +5,7 @@@
  #include "priv.h"
  #include "sf.h"
  #include "mlx5_ifc_vhca_event.h"
- #include "vhca_event.h"
 -#include "ecpf.h"
 +#include "mlx5_core.h"
 =20
  struct mlx5_sf_hw {
  	u32 usr_sfnum;

--Sig_/mQspNTZzRq=1d96KhQCGZS2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBalCEACgkQAVBC80lX
0GxGhggAkcnlhlxZJSg3roN3rb7jKPsaYdFSTrYakDIcpM2Z2i4HX901XrTfbTr2
ztOzYNfSQugxUnY6+yXxjUIdPUXaolVfXGApZF6yRPBZ7TksLR3QL2GUomcaWvOK
5krEJMmmmOwT3qMsfJgo40IQt4LjQzuPRZz7Jr7WEa2g5aSwC4TDcXMBj6BVj1b8
tzcTj1/7QOZbs+jXKtekirp6Aq0hPPHuyAu1wqvgTfPcullzziQ/IItqL0GuoUF7
uLKj7l1LqOw0Sgj0mEo31agRRYh3x5F1KykR5+c78R4wslyWfdkSxuAC4TW8Dp3x
kqbhPCfNcWgnHMzyad2MMql6Xv8SHw==
=NSQ5
-----END PGP SIGNATURE-----

--Sig_/mQspNTZzRq=1d96KhQCGZS2--
