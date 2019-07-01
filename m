Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F261F5B3AE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 06:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfGAEr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 00:47:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40203 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfGAEr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 00:47:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45cZcT4vxfz9s4V;
        Mon,  1 Jul 2019 14:47:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561956474;
        bh=NfR2zA85E3BqlOmSYIkyE2Hsp9EpOLv9gwews667qBI=;
        h=Date:From:To:Cc:Subject:From;
        b=Rza8+7Q0mjafQKfBF3Zjm/jt/IAyXTzLCawyQovXgXBvcfgCci6QZqfkwXzPGSDk/
         MknW8FJbUaXwQRLG3wHBXcPF1aX6f7xIHBxWewjjJR3xhrPAm1cCo1uhZN8gJ0bDS1
         qTluX4pNMb8tt1O7WUrSWpdNtYr0yAMP1T2LY7P20OjuyAoxTj1TeFx4ewSvjH3c6g
         CiD8d+GHNaEUS7CnbwaIXJJ7Y932rEChUO+DQyY42WEdAndqoFoTQrl6UodiTO14ad
         2CJd20Tim9wAgymDa22R3/3i2bc+xUQc/+TRUu4ZsUO09KdTEdSX0NzMWEW4K+KBu/
         OmiZCwalmehXw==
Date:   Mon, 1 Jul 2019 14:47:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20190701144752.1f954385@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/dy72frjPYLGHPzpsoZqgEE3"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/dy72frjPYLGHPzpsoZqgEE3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/en_main.c

between commit:

  8960b38932be ("linux/dim: Rename externally used net_dim members")

from the net-next tree and commits:

  db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
  0a06382fa406 ("net/mlx5e: Encapsulate open/close queues into a function")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1085040675ae,67b562c7f8a1..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@@ -1567,10 -1602,8 +1602,8 @@@ static void mlx5e_destroy_cq(struct mlx
  	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
  }
 =20
- static int mlx5e_open_cq(struct mlx5e_channel *c,
- 			 struct dim_cq_moder moder,
- 			 struct mlx5e_cq_param *param,
- 			 struct mlx5e_cq *cq)
 -int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
++int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
+ 		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq)
  {
  	struct mlx5_core_dev *mdev =3D c->mdev;
  	int err;
@@@ -1767,45 -1800,12 +1800,12 @@@ static void mlx5e_free_xps_cpumask(stru
  	free_cpumask_var(c->xps_cpumask);
  }
 =20
- static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
- 			      struct mlx5e_params *params,
- 			      struct mlx5e_channel_param *cparam,
- 			      struct mlx5e_channel **cp)
+ static int mlx5e_open_queues(struct mlx5e_channel *c,
+ 			     struct mlx5e_params *params,
+ 			     struct mlx5e_channel_param *cparam)
  {
- 	int cpu =3D cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix=
));
 -	struct net_dim_cq_moder icocq_moder =3D {0, 0};
 +	struct dim_cq_moder icocq_moder =3D {0, 0};
- 	struct net_device *netdev =3D priv->netdev;
- 	struct mlx5e_channel *c;
- 	unsigned int irq;
  	int err;
- 	int eqn;
-=20
- 	err =3D mlx5_vector2eqn(priv->mdev, ix, &eqn, &irq);
- 	if (err)
- 		return err;
-=20
- 	c =3D kvzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
- 	if (!c)
- 		return -ENOMEM;
-=20
- 	c->priv     =3D priv;
- 	c->mdev     =3D priv->mdev;
- 	c->tstamp   =3D &priv->tstamp;
- 	c->ix       =3D ix;
- 	c->cpu      =3D cpu;
- 	c->pdev     =3D priv->mdev->device;
- 	c->netdev   =3D priv->netdev;
- 	c->mkey_be  =3D cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
- 	c->num_tc   =3D params->num_tc;
- 	c->xdp      =3D !!params->xdp_prog;
- 	c->stats    =3D &priv->channel_stats[ix].ch;
- 	c->irq_desc =3D irq_to_desc(irq);
-=20
- 	err =3D mlx5e_alloc_xps_cpumask(c, params);
- 	if (err)
- 		goto err_free_channel;
-=20
- 	netif_napi_add(netdev, &c->napi, mlx5e_napi_poll, 64);
 =20
  	err =3D mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->icosq.cq);
  	if (err)
@@@ -2150,12 -2230,12 +2230,12 @@@ void mlx5e_build_ico_cq_param(struct ml
 =20
  	mlx5e_build_common_cq_param(priv, param);
 =20
 -	param->cq_period_mode =3D NET_DIM_CQ_PERIOD_MODE_START_FROM_EQE;
 +	param->cq_period_mode =3D DIM_CQ_PERIOD_MODE_START_FROM_EQE;
  }
 =20
- static void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
- 				    u8 log_wq_size,
- 				    struct mlx5e_sq_param *param)
+ void mlx5e_build_icosq_param(struct mlx5e_priv *priv,
+ 			     u8 log_wq_size,
+ 			     struct mlx5e_sq_param *param)
  {
  	void *sqc =3D param->sqc;
  	void *wq =3D MLX5_ADDR_OF(sqc, sqc, wq);

--Sig_/dy72frjPYLGHPzpsoZqgEE3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ZkHgACgkQAVBC80lX
0GwJ4wf/fetCtKbtMU1ik1P9kSLTty0RLn58NNZG8VZpjqA0UHYweKdzigPNbC5i
Pp+EyUNfVJM0Rc7VHoJsflS6BUMNy3lfItUcTReDhwybttWb5XorZrbxoqaOlBn+
7cOMa9RPghjlDCHG41sC4yiysLO6OskRP+kRf8DK/O5RxB6OS5ViM0NsHhpyBFeY
cGqEv04vBraqMhAdw8ifysE7QO5+q23XuVALsgz0UArAuKf9A6/MPopkhbADGZ2r
RQAM26hXE5j5xkssrkgKNjCyglhTOxFerrFyDQytPrzrJVIoSidPGuCUUtbWPxTC
TMPTrN5NIf4wQlApgYyIxHdPmuBLqg==
=Y+bT
-----END PGP SIGNATURE-----

--Sig_/dy72frjPYLGHPzpsoZqgEE3--
