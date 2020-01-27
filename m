Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3214AC4C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 23:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgA0Wyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 17:54:55 -0500
Received: from ozlabs.org ([203.11.71.1]:57355 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgA0Wyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 17:54:55 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4864nk5Qq1z9sPJ;
        Tue, 28 Jan 2020 09:54:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1580165691;
        bh=TC+Bk4yssTtaHBpAR5BNdU7WqavBtwsSepN+Yaa2TNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ja2LQoTS1GPIrXybj09hloSxAozUdZUyu5utTaxRp8c/IlzDbx5FpRliTMGjC1bgN
         tGIHEAlSSn73qVvhf6SJvBAIbwBg7WFczQEDck4DHEnNnZp6yrq2XcaVR/eIjj4MhG
         jQqUgB91oS7n2idrsAAq4XJJCDmF/tVvH69ta2xEqrXG7gL68Vn6JT7464eo6nXnRS
         o44+PmaxfGMiBPycvr66o6QfYJkCKfEKgM+gQ+MT9EbkBh2hMQehmynyrASxvKRFJC
         dUnafDwzfw1rWy5Q++FJCBSh58cT1+UpnZ7Q5j3ojeZIp5Ib6Nj2YK9KZLm/uw9uzL
         r/ZUZxe7OFbYQ==
Date:   Tue, 28 Jan 2020 09:54:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandru-Mihai Maftei <amaftei@solarflare.com>
Subject: Re: linux-next: manual merge of the generic-ioremap tree with the
 net-next tree
Message-ID: <20200128095449.5688fddc@canb.auug.org.au>
In-Reply-To: <20200109161202.1b0909d9@canb.auug.org.au>
References: <20200109161202.1b0909d9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/u.qhGEasX3Q0i80LbwjupLO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/u.qhGEasX3Q0i80LbwjupLO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 9 Jan 2020 16:12:02 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> Today's linux-next merge of the generic-ioremap tree got a conflict in:
>=20
>   drivers/net/ethernet/sfc/efx.c
>=20
> between commit:
>=20
>   f1826756b499 ("sfc: move struct init and fini code")
>=20
> from the net-next tree and commit:
>=20
>   4bdc0d676a64 ("remove ioremap_nocache and devm_ioremap_nocache")
>=20
> from the generic-ioremap tree.
>=20
> I fixed it up (the latter moved the code, so I applied the following
> merge fix patch) and can carry the fix as necessary. This is now fixed
> as far as linux-next is concerned, but any non trivial conflicts should
> be mentioned to your upstream maintainer when your tree is submitted
> for merging.  You may also want to consider cooperating with the
> maintainer of the conflicting tree to minimise any particularly complex
> conflicts.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 9 Jan 2020 16:08:52 +1100
> Subject: [PATCH] fix up for "sfc: move struct init and fini code"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/sfc/efx_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet=
/sfc/efx_common.c
> index fe74c66c8ec6..bf0126633c25 100644
> --- a/drivers/net/ethernet/sfc/efx_common.c
> +++ b/drivers/net/ethernet/sfc/efx_common.c
> @@ -954,7 +954,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_add=
r_t dma_mask,
>  		goto fail3;
>  	}
> =20
> -	efx->membase =3D ioremap_nocache(efx->membase_phys, mem_map_size);
> +	efx->membase =3D ioremap(efx->membase_phys, mem_map_size);
>  	if (!efx->membase) {
>  		netif_err(efx, probe, efx->net_dev,
>  			  "could not map memory BAR at %llx+%x\n",
> --=20
> 2.24.0

This is now a conflict between the net-next tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/u.qhGEasX3Q0i80LbwjupLO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4vajkACgkQAVBC80lX
0GzPpQf/a9xWOi9dDL04qfsIfYg7TednXbl7p81Oy/NQz7EYO4Ug8YuXuzASb8B3
71X56Ie0xqEakAqndG5XS1+sBTLe1go/5le13+AxXvVIVp5lC3kTX9XYZ8RTdEEj
b0GEjRozCvNMyV+MOqsS09TJVbKor4ZRATBLdtnpiGNx3m/+YCuMWOA+7Joz0TaD
6pcJQmlWXZ+c7iYFD6PWR7IfoPtytWV4Gxa+EkucMwFJqIL5BiWhRSlBwjnXoPwL
VDu4D+MHE+D4kvCw3oJt3yT2dutxkf+ShVxQbXR1EZL0u+hJvJ13sYpYeSVwkTPl
WAXm1yi79Gldyu4CHeLug8vzhMwLhQ==
=+npg
-----END PGP SIGNATURE-----

--Sig_/u.qhGEasX3Q0i80LbwjupLO--
