Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB652C93F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbiESBfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiESBfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:35:36 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E63D9548D;
        Wed, 18 May 2022 18:35:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L3XVW1Qk1z4xY2;
        Thu, 19 May 2022 11:35:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652924132;
        bh=0uz7tlkkzoYhRZiRjCTzND3ILnAf9SvcH6TOA+ncRAQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Gd02Rq+LukHlnljt6PwsWZfmdx+0ZRyoveatyPmENNcn+nLMeCQ5ClpGUg1ptbClM
         GVbQ5aNCsdW7BKgQRdHw5amZzBenp3Ok+Lswqs570NIFZebgtc/rETUEfslrZzRv1z
         0fE4ThXy6QjYXc5gwFKopJlMg53XpPoflyTugsXuI1aFyjnzDZQXAaXV9lPxUpblkt
         33dVRKumCfKdoyD1yHIAqHP25lcZ+/1UdVM5/iTPQ5et52AOBffueGddEru+A3O8r3
         MZf/KjxG4xOQ2rRsSmSPpZNguZp9eF3PoOpEdZYF96Zg7wstnM1ILOlKRWwhUiIbsT
         UURD12DqORQpA==
Date:   Thu, 19 May 2022 11:35:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: linux-next: manual merge of the rdma tree with the net tree
Message-ID: <20220519113529.226bc3e2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8A7u_k62YMCgoamBoiu3ovB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8A7u_k62YMCgoamBoiu3ovB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the rdma tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/main.c

between commit:

  b33886971dbc ("net/mlx5: Initialize flow steering during driver probe")

from the net tree and commits:

  40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support")
  f2b41b32cde8 ("net/mlx5: Remove ipsec_ops function table")

from the rdma tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/main.c
index ef196cb764e2,d504c8cb8f96..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@@ -1192,15 -1181,7 +1190,7 @@@ static int mlx5_load(struct mlx5_core_d
  		goto err_fpga_start;
  	}
 =20
- 	mlx5_accel_ipsec_init(dev);
-=20
- 	err =3D mlx5_accel_tls_init(dev);
- 	if (err) {
- 		mlx5_core_err(dev, "TLS device start failed %d\n", err);
- 		goto err_tls_start;
- 	}
-=20
 -	err =3D mlx5_init_fs(dev);
 +	err =3D mlx5_fs_core_init(dev);
  	if (err) {
  		mlx5_core_err(dev, "Failed to init flow steering\n");
  		goto err_fs;
@@@ -1245,11 -1226,8 +1235,8 @@@ err_ec
  err_vhca:
  	mlx5_vhca_event_stop(dev);
  err_set_hca:
 -	mlx5_cleanup_fs(dev);
 +	mlx5_fs_core_cleanup(dev);
  err_fs:
- 	mlx5_accel_tls_cleanup(dev);
- err_tls_start:
- 	mlx5_accel_ipsec_cleanup(dev);
  	mlx5_fpga_device_stop(dev);
  err_fpga_start:
  	mlx5_rsc_dump_cleanup(dev);
@@@ -1274,9 -1252,7 +1261,7 @@@ static void mlx5_unload(struct mlx5_cor
  	mlx5_ec_cleanup(dev);
  	mlx5_sf_hw_table_destroy(dev);
  	mlx5_vhca_event_stop(dev);
 -	mlx5_cleanup_fs(dev);
 +	mlx5_fs_core_cleanup(dev);
- 	mlx5_accel_ipsec_cleanup(dev);
- 	mlx5_accel_tls_cleanup(dev);
  	mlx5_fpga_device_stop(dev);
  	mlx5_rsc_dump_cleanup(dev);
  	mlx5_hv_vhca_cleanup(dev->hv_vhca);

--Sig_/8A7u_k62YMCgoamBoiu3ovB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKFnuEACgkQAVBC80lX
0Gx+awf/aSAXYuCrUQSP++SGx0XBNFOpmTg4BH7WiLzk+0Dd/M4uXfg0mfAceBOF
ohj8aUVP37Wp4ksPmpU3wVg0YcTRmVVwGFayhkrIa9gQEEuTWW0eCq275Dnw1pZs
PDH2LrSl9a8LlU2/qQaDvR2RSCUbyIKX8YZSg8M/fGpULlXYAVo5E9O0RjEHJZxm
v6BxNnmi3nmhZKTdqLXNaQGjI6OrjjgK6Pqam7y8GuqzZNidMULIectm04W2LPrn
r0+H3zQt2ccJchP1/Qx5QzFf6JWG2PYy9t4SEYKmvQUsKZNgzpWo6o04Flz/Fhft
MiqvreMPsMpCUv2yzOsXQFqGuEn0fA==
=WEPE
-----END PGP SIGNATURE-----

--Sig_/8A7u_k62YMCgoamBoiu3ovB--
