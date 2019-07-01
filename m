Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EBA5B3C5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 07:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfGAFB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 01:01:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45689 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfGAFBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 01:01:55 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45cZwb6BCHz9s4V;
        Mon,  1 Jul 2019 15:01:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561957311;
        bh=WjOo7BdhBFl450vHjjIDoQzFNDy8ygcgGkM8SW8EWVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tbRsO5uNSrqKYqJDlbMgeZtW7tmw8M8xN8Qa6+XAtvFbiDPRkqynZBVHcybKUUdvZ
         5IiRyP0CwPdFwPvIbPJ6g+JiQ+YC+dp3w7HkzRqIQz5MgZ9oZADfNLCnWyWX/iw88/
         1Sjl1KvSyJ+NZ9wEu+2k93vfaFTNlf/3ryjJYaZwwPWb+BIeT8Qxbrxn/BM/JlTQXv
         e1h8rqpTPMgmv/1UDlZGnt4S3jtWCCOPB42XNixT/ZNYKRmMZUmqaywUoQYFmdsLP2
         /D6i5mXewzh84tkeC/eX247wrGI93EXxu4pkXQCH4jBC7tDM8cwxypwm06XIaj0I2g
         4hQDDVstV7H8g==
Date:   Mon, 1 Jul 2019 15:01:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20190701150151.6bdb7749@canb.auug.org.au>
In-Reply-To: <20190701145722.5809cb2c@canb.auug.org.au>
References: <20190701145722.5809cb2c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8q26T++EcfQYJm_DWTzAXFa"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8q26T++EcfQYJm_DWTzAXFa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 1 Jul 2019 14:57:22 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>=20
> After merging the bpf-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:1605:5: error: conflict=
ing types for 'mlx5e_open_cq'
>  int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
>      ^~~~~~~~~~~~~
> In file included from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:4=
3:
> drivers/net/ethernet/mellanox/mlx5/core/en.h:977:5: note: previous declar=
ation of 'mlx5e_open_cq' was here
>  int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
>      ^~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   8960b38932be ("linux/dim: Rename externally used net_dim members")
>=20
> from the net-next tree interacting with commit
>=20
>   db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
>=20
> I have applied the following merge fix patch.
>=20
> From 8e92dbee0daa6bac412daebd08073ba9ca31c7a6 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 1 Jul 2019 14:55:02 +1000
> Subject: [PATCH] net/mlx5e: fix up for "linux/dim: Rename externally used
>  net_dim members"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/e=
thernet/mellanox/mlx5/core/en.h
> index 9cebaa642727..f0d77eb66acf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -974,7 +974,7 @@ int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct =
mlx5e_params *params,
>  void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
> =20
>  struct mlx5e_cq_param;
> -int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
> +int mlx5e_open_cq(struct mlx5e_channel *c, struct dim_cq_moder moder,
>  		  struct mlx5e_cq_param *param, struct mlx5e_cq *cq);
>  void mlx5e_close_cq(struct mlx5e_cq *cq);
> =20

Also, this:

drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c: In function 'mlx5e_=
open_xsk':
drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:64:9: error: variabl=
e 'icocq_moder' has initializer but incomplete type
  struct net_dim_cq_moder icocq_moder =3D {};
         ^~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:64:26: error: storag=
e size of 'icocq_moder' isn't known
  struct net_dim_cq_moder icocq_moder =3D {};
                          ^~~~~~~~~~~

For which I applied this:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Jul 2019 15:00:08 +1000
Subject: [PATCH] another fix for "linux/dim: Rename externally used net_dim
 members"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 9b4d47c47c92..aaffa6f68dc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -61,7 +61,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_=
params *params,
 		   struct mlx5e_channel *c)
 {
 	struct mlx5e_channel_param cparam =3D {};
-	struct net_dim_cq_moder icocq_moder =3D {};
+	struct dim_cq_moder icocq_moder =3D {};
 	int err;
=20
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/8q26T++EcfQYJm_DWTzAXFa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0Zk78ACgkQAVBC80lX
0GynlAf/TAXj6eOTQEJHc9LUGD2vYwpRK5PjDE8ICklrLrCwyRXizERRYW22cI3n
Ki9asTlcFFUc9GM+UWbbU59iVfJW/pP0jyvjNeNt5biLowwYZ9htM64lr5nzunpl
fOGg0z8YSQJhn3dx43GS/pz7W6NjcFC1FNcRogYrd51AeYQPDz0XtfIAX7i6K+Et
iYN5uLWYnNrVTpENuQdgOPn61jvz6zU8syuU2+AkrF9UWVwQhlw7fbhPGQu0mZZ2
R9hs/RjHu6Rj8N718qeEFqMUxUn7TLdLgvCAwXcxY6nm1x2z6/N2ROR5xc5YdrYF
f2cuiBySDt55jF3Md2r+/8mbrPM4qg==
=wmto
-----END PGP SIGNATURE-----

--Sig_/8q26T++EcfQYJm_DWTzAXFa--
