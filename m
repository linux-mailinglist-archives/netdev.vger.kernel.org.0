Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDE0430CEF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 01:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbhJQXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 19:55:00 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:33697 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhJQXzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 19:55:00 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HXcJH71nHz4xbb;
        Mon, 18 Oct 2021 10:52:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634514768;
        bh=Z12/LzqRnTuMa2K3hnOVJnRq+Am1J+wCD4czDVuOD7M=;
        h=Date:From:To:Cc:Subject:From;
        b=IxxTqJTLVQ27rAafX7YDlfpCawNB5LnJTAjMPtZ4+Lj1iKayXEdjpqyBnfVygHvuq
         Mm0Koh9FFadD02wk6lFitDVo1u//tczX2qoBgMRR2HJ/ZFAaTVnO8SrkbPWpWJ07Eb
         AZInpBHuvcoemvN7JiFSBiFqrHq/v9+Pawellh8rDut+YtyPVVq80NppBWSVAH8o9n
         80MfgJCbZgdvK96fg+0lRluyyhDLDsN5GIi+znQollXavN+T7oxINYybHML4keDYka
         RK2/u37XZXIEfYzO3TsyrS1N8+D5CCfY+IVTVexkmb4r5qIjomSsHisVc7gQxmYpSS
         Eyt5ZtfKsrESA==
Date:   Mon, 18 Oct 2021 10:52:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Brett Creeley <brett.creeley@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20211018105246.13d388b0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6xYK3BNhZmGD.oCN5M5mGEU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6xYK3BNhZmGD.oCN5M5mGEU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_devlink.c

between commit:

  b726ddf984a5 ("ice: Print the api_patch as part of the fw.mgmt.api")

from the net tree and commit:

  0128cc6e928d ("ice: refactor devlink getter/fallback functions to void")

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

diff --cc drivers/net/ethernet/intel/ice/ice_devlink.c
index da7288bdc9a3,55353bf4cbef..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@@ -63,13 -60,11 +60,11 @@@ static void ice_info_fw_api(struct ice_
  {
  	struct ice_hw *hw =3D &pf->hw;
 =20
 -	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u",
 -		 hw->api_maj_ver, hw->api_min_ver);
 +	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", hw->api_maj_ver,
 +		 hw->api_min_ver, hw->api_patch);
-=20
- 	return 0;
  }
 =20
- static int ice_info_fw_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
+ static void ice_info_fw_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
  {
  	struct ice_hw *hw =3D &pf->hw;
 =20

--Sig_/6xYK3BNhZmGD.oCN5M5mGEU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFst04ACgkQAVBC80lX
0GwT4gf7BzGVWydcvGaTk61MyxsEm9UWLSPifNCqaFa3+vfRDrUuYE7AiZt+k4wa
7VBcN91/3A7VlBbe0LlYU5+kBnKhiT56bna+678Uw6HGn6E3Ob0g6xEzlJQRzxXj
kP0DSWaqQFp/A/4YEdHf7r8pJ2BC6AuIVS3+TMukPJ0ei9eYExPn2ucRTeCMILOy
CJo/4a/BC+q/fIPafmFJrGIAky3S3jIQzsg99bWx0sQI8InDI5SqvF7VJXA8i2iZ
MuhphCURvEFB69aqmEWFILxXp8GAGlMfHD1tzG6xY7nAlM0DLWcHL+GOi1i6ipKM
B7W9N6xNNHRPGnUcZqLHp+LiwBn9sQ==
=nquE
-----END PGP SIGNATURE-----

--Sig_/6xYK3BNhZmGD.oCN5M5mGEU--
