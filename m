Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06E35B9195
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiIOAU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 20:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiIOAUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 20:20:24 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425A54D804;
        Wed, 14 Sep 2022 17:20:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MSdBr0XmXz4x1T;
        Thu, 15 Sep 2022 10:20:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1663201220;
        bh=gnGui/z0Z0qQeqJQvLvMOfV3VcFbb7V/C7qu0wIP4MM=;
        h=Date:From:To:Cc:Subject:From;
        b=rwbZQ35L0uePD3q0IILydINIZ+iiRaKsoRQIP74lVf/criwGXZlMPyVrjiG82g0g8
         15V/qlSowydMDMrT7d/DcUmKPBUtBAq747H1b4enIhdHDQ2dy/iXtlNFX2XQ5WCimz
         yOnsEMbEUWUCoawvB19xKgZieHyVO8Sz4ytCO1J6R4YWzOPxbFlpYvOFoN09gUuikp
         UvYuyc917doia43At0RMJIsSyPAlNz0taYTxJGk4SXto35+4rRNmuuGwg+YIcmIDiK
         UHQh/OQs/V/lw7b1MhA9lVMZ53gpG1YuafekpmpT/lJTy8a14e5Rym9WdrxrxevoM+
         h2svVmXG7LYHw==
Date:   Thu, 15 Sep 2022 10:20:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Aurelien Aptel <aaptel@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: linux-next: manual merge of the mlx5-next tree with the net-next
 tree
Message-ID: <20220915102018.795c4a55@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/D5qb6bUYOjLrNQ6THHsn8k2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/D5qb6bUYOjLrNQ6THHsn8k2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mlx5-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/fw.c

between commit:

  8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")

from the net-next tree and commits:

  939838632b91 ("net/mlx5: Query ADV_VIRTUALIZATION capabilities")
  6182534c2678 ("net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumera=
tions")

from the mlx5-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/fw.c
index c63ce03e79e0,2140bf161c90..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@@ -273,13 -273,18 +273,25 @@@ int mlx5_query_hca_caps(struct mlx5_cor
  			return err;
  	}
 =20
 +	if (MLX5_CAP_GEN_64(dev, general_obj_types) &
 +	    MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD) {
 +		err =3D mlx5_core_get_caps(dev, MLX5_CAP_MACSEC);
 +		if (err)
 +			return err;
 +	}
 +
+ 	if (MLX5_CAP_GEN(dev, adv_virtualization)) {
+ 		err =3D mlx5_core_get_caps(dev, MLX5_CAP_ADV_VIRTUALIZATION);
+ 		if (err)
+ 			return err;
+ 	}
+=20
+ 	if (MLX5_CAP_GEN(dev, nvmeotcp)) {
+ 		err =3D mlx5_core_get_caps(dev, MLX5_CAP_DEV_NVMEOTCP);
+ 		if (err)
+ 			return err;
+ 	}
+=20
  	return 0;
  }
 =20

--Sig_/D5qb6bUYOjLrNQ6THHsn8k2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMib8IACgkQAVBC80lX
0GyFywgAkZdlOT75c5isIubKOOQPttiFJdr3TYp2S5rktSZrAu8ZZX0A7Pey5coO
N41MQxKV22jD0UybU5zlLsTIrdvKihXY8VkDUutB31q512+KDdFEYuXs+1rLGCAj
B2L4ChcZlkMt31dISE6PL6tlmZuZA1L4fc0O3xRG9YZOFle6tdiMS+NcrRkNZd4C
5ADQp7LL4AR36uHYaYktYEGKhueQDtCUN6XCF5LxGzPDH72s9VyNusC4b7Rjoi0W
AVxi1iuTW1Shr6cCQaoHueZcYuCIzhoKWeQbgLA8FWauBOlnI4TPE8r/PnT2XSW3
iBCZxn093OH/TRGRKqRZ59XTl+hNXw==
=cxZN
-----END PGP SIGNATURE-----

--Sig_/D5qb6bUYOjLrNQ6THHsn8k2--
