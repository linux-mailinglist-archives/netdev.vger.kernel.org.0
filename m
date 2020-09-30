Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFA27F4DD
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgI3WJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730090AbgI3WJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:09:20 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BB8C061755;
        Wed, 30 Sep 2020 15:09:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1r590qK1z9ryj;
        Thu,  1 Oct 2020 08:09:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601503757;
        bh=4wHl+HRtsaGHQY7qxtfNCZSpnvjVxb1tiN090/PdAiw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IgIuuEyQ0y/mtsJoh6BoMsdz1dNUhp/v8Ae5LaAoliKDlWDAc4h0EJhPVE9ELDpTL
         84feUErO8RIKxs9dMT5Ws9SwHCWsvWE4sNuYg1ZYN2yQvh6Lf5GQGF2KQKhLIDa9CJ
         718rHDW2XrbIMHjKLkuFl+3LpMnHxfJdw5tDEoeOzZSQoriqergintkYuOUQlJCaUJ
         mBc+m1DhjWGj+UV/b+FYZmPQg/AirMo/SxFw9MAC3rtvkbXtWOp2px+ud5y4mJBAZM
         aOeCcphfCshdIP50X0YditYnIe/8oCCARZRuO+tgXsNMn5OJA0OxYOnsW9L3dJZULN
         QTQC0LqFsUDfA==
Date:   Thu, 1 Oct 2020 08:09:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20201001080916.1f006d72@canb.auug.org.au>
In-Reply-To: <20200929130446.0c2630d2@canb.auug.org.au>
References: <20200929130446.0c2630d2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bQTd.i_qyImABQN4ENG/kfN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/bQTd.i_qyImABQN4ENG/kfN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 29 Sep 2020 13:04:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/net/ethernet/marvell/prestera/prestera_main.c: In function 'prest=
era_port_dev_lower_find':
> drivers/net/ethernet/marvell/prestera/prestera_main.c:504:33: error: pass=
ing argument 2 of 'netdev_walk_all_lower_dev' from incompatible pointer typ=
e [-Werror=3Dincompatible-pointer-types]
>   504 |  netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
>       |                                 ^~~~~~~~~~~~~~~~~~~~~~~
>       |                                 |
>       |                                 int (*)(struct net_device *, void=
 *)
> In file included from include/linux/etherdevice.h:21,
>                  from drivers/net/ethernet/marvell/prestera/prestera_main=
.c:4:
> include/linux/netdevice.h:4571:16: note: expected 'int (*)(struct net_dev=
ice *, struct netdev_nested_priv *)' but argument is of type 'int (*)(struc=
t net_device *, void *)'
>  4571 |          int (*fn)(struct net_device *lower_dev,
>       |          ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  4572 |      struct netdev_nested_priv *priv),
>       |      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/prestera/prestera_main.c:504:58: error: pass=
ing argument 3 of 'netdev_walk_all_lower_dev' from incompatible pointer typ=
e [-Werror=3Dincompatible-pointer-types]
>   504 |  netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
>       |                                                          ^~~~~
>       |                                                          |
>       |                                                          struct p=
restera_port **
> In file included from include/linux/etherdevice.h:21,
>                  from drivers/net/ethernet/marvell/prestera/prestera_main=
.c:4:
> include/linux/netdevice.h:4573:37: note: expected 'struct netdev_nested_p=
riv *' but argument is of type 'struct prestera_port **'
>  4573 |          struct netdev_nested_priv *priv);
>       |          ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
> cc1: some warnings being treated as errors
>=20
> Caused by commit
>=20
>   eff7423365a6 ("net: core: introduce struct netdev_nested_priv for neste=
d interface infrastructure")
>=20
> interacting with commit
>=20
>   e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementat=
ion")
>=20
> also in the net-next tree.
>=20
> I applied the following fix patch.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Sep 2020 12:57:59 +1000
> Subject: [PATCH] fix up for "net: core: introduce struct netdev_nested_pr=
iv for nested interface infrastructure"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/driv=
ers/net/ethernet/marvell/prestera/prestera_main.c
> index 9bd57b89d1d0..633d8770be35 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -482,9 +482,10 @@ bool prestera_netdev_check(const struct net_device *=
dev)
>  	return dev->netdev_ops =3D=3D &prestera_netdev_ops;
>  }
> =20
> -static int prestera_lower_dev_walk(struct net_device *dev, void *data)
> +static int prestera_lower_dev_walk(struct net_device *dev,
> +				   struct netdev_nested_priv *priv)
>  {
> -	struct prestera_port **pport =3D data;
> +	struct prestera_port **pport =3D (struct prestera_port **)priv->data;
> =20
>  	if (prestera_netdev_check(dev)) {
>  		*pport =3D netdev_priv(dev);
> @@ -497,11 +498,13 @@ static int prestera_lower_dev_walk(struct net_devic=
e *dev, void *data)
>  struct prestera_port *prestera_port_dev_lower_find(struct net_device *de=
v)
>  {
>  	struct prestera_port *port =3D NULL;
> +	struct netdev_nested_priv priv;
> =20
>  	if (prestera_netdev_check(dev))
>  		return netdev_priv(dev);
> =20
> -	netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &port);
> +	priv.data =3D (void *)&port;
> +	netdev_walk_all_lower_dev(dev, prestera_lower_dev_walk, &priv);
> =20
>  	return port;
>  }

I am still getting this build failure ...

--=20
Cheers,
Stephen Rothwell

--Sig_/bQTd.i_qyImABQN4ENG/kfN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl91AgwACgkQAVBC80lX
0GwSQggAlH8/PPJBNYNPQpiSBKOy/Q8a0V9HvLyJ5RF9lfU0tgY2ZGh/CsDA3b8P
McuKMc4K15VCIEtsk0bgp5MCMayfqPnE7/CCFEM0fSWhvrkuNOpv5cY74N2GtujH
ftCaXn+IJkxm9aTvr+JGz0WIL/+Yoogu5dRIzwgk/g31FAdHH1+BUqKvSw8nrB7S
uVB619QfDY7az0jOB+gOQ04v1BoyFU7YO4uWXMUtP0FMOx2o70/lwDGXUhnUlfEi
P8c9jJJxfe0xgDw6KxgEANabTq0WZ8Obrgs3ZQcqHZyB+tKRzpledhHqdvzvYCaE
pPV7KOnW9RIWodwxyUWjqoPDTT6kww==
=SnKV
-----END PGP SIGNATURE-----

--Sig_/bQTd.i_qyImABQN4ENG/kfN--
