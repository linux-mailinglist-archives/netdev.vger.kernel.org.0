Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2106197E
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 05:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfGHD2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 23:28:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37129 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfGHD2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 23:28:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45hrWp4BFnz9sNF;
        Mon,  8 Jul 2019 13:28:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562556518;
        bh=CHCn/D8eAiBLkRYmzJoUB3/S5s/rbxlG1ArTgtS9wLo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hHB5nBuHHIwWKBhncKQi1dONJAcF4zmpOXd9iZ2om6K+JJQZWU9uuTzr3iNGn6Ssk
         uyRYsWFl7uIAZM+RtX3LnrHhedshBzzdxGvpHcAXRaVC1EHs3olADK6Ixs1mjwQEoZ
         wK3VatSF73ypVR+sfye5/tk1v9st4o/drsDRZmy/VIDDJac38EI0fSdBsUegdXEq/4
         ewX88pML+O2Z1ZxgR0rFAiafXujNwh/sTFM9usBE07FTPDOMarylgQQ9qXy++ZD3TG
         i85AB8b/ud+7J/LEch5R5y1dL4WdKqnNMWMddF4BW5ZkRrhuWrIymcQFmXctDkYCut
         ldN5mVUjhueqg==
Date:   Mon, 8 Jul 2019 13:28:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the rdma
 tree
Message-ID: <20190708132837.5ccb36ed@canb.auug.org.au>
In-Reply-To: <20190704124738.1e88cb69@canb.auug.org.au>
References: <20190704124738.1e88cb69@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WFz+iZTScEnSIiQwpXVHD5l"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WFz+iZTScEnSIiQwpXVHD5l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 4 Jul 2019 12:47:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> Today's linux-next merge of the mlx5-next tree got a conflict in:
>=20
>   drivers/infiniband/hw/mlx5/cq.c
>=20
> between commit:
>=20
>   e39afe3d6dbd ("RDMA: Convert CQ allocations to be under core responsibi=
lity")
>=20
> from the rdma tree and commit:
>=20
>   38164b771947 ("net/mlx5: mlx5_core_create_cq() enhancements")
>=20
> from the mlx5-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc drivers/infiniband/hw/mlx5/cq.c
> index bfe3efdd77d7,4efbbd2fce0c..000000000000
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@@ -891,7 -891,8 +891,8 @@@ int mlx5_ib_create_cq(struct ib_cq *ibc
>   	int entries =3D attr->cqe;
>   	int vector =3D attr->comp_vector;
>   	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
> + 	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
>  -	struct mlx5_ib_cq *cq;
>  +	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
>   	int uninitialized_var(index);
>   	int uninitialized_var(inlen);
>   	u32 *cqb =3D NULL;

This is now a conflict between the net-next tree and the rdma tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/WFz+iZTScEnSIiQwpXVHD5l
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0iuGUACgkQAVBC80lX
0GxbEwf+PlZ2tLyCFf5KdyUPf1/Nk5a8cYCobK1n7AAHZu+hd5HOvOiUI6cx3szE
9M4TuGve/KZwD3JF4VUtqjyRHfea5C44E7CuCefSlUftak60gusKATGaB+efwbOb
JOnDG6qHoeom2JhjoUgWilljISukGwP5ARrnleWosnu9BldCuM0EzcRgxd27eTrB
cigGuxlyPaIfEXQWONOyENjg5wQ3ZRyKe69h7y+4zKfi/lgUgEhXMemdRg7Kjknp
JyJ21FWMhHvDGpBfU2m1Kr6z9AqeUR9JcUXzg1DDMHosMaJU0XZMlcCJB+ektGqe
RjpI5MzMURZ2yUCXDMAVPIZXa2lrTA==
=GGMU
-----END PGP SIGNATURE-----

--Sig_/WFz+iZTScEnSIiQwpXVHD5l--
