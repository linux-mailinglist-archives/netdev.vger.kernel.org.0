Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB401F06D8
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 15:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgFFNsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 09:48:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:48086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgFFNsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jun 2020 09:48:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 725FAAAC3;
        Sat,  6 Jun 2020 13:48:42 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6D552604AD; Sat,  6 Jun 2020 15:48:38 +0200 (CEST)
Date:   Sat, 6 Jun 2020 15:48:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] ethtool: remove extra checks
Message-ID: <20200606134838.buk2ior2oqdnboqz@lion.mk-sys.cz>
References: <6d90f9b2-9bdd-d813-ef4e-ed0a7d1acaf2@virtuozzo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vndb34irvom74w52"
Content-Disposition: inline
In-Reply-To: <6d90f9b2-9bdd-d813-ef4e-ed0a7d1acaf2@virtuozzo.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vndb34irvom74w52
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 06, 2020 at 03:49:05PM +0300, Vasily Averin wrote:
> Found by smatch:
> net/ethtool/linkmodes.c:356 ethnl_set_linkmodes() warn:
>  variable dereferenced before check 'info' (see line 332)
> net/ethtool/linkinfo.c:143 ethnl_set_linkinfo() warn:
>  variable dereferenced before check 'info' (see line 119
>=20
> In both cases non-zero 'info' is always provided by caller.
>=20
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  net/ethtool/linkinfo.c  | 3 +--
>  net/ethtool/linkmodes.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
> index 677068d..5eaf173 100644
> --- a/net/ethtool/linkinfo.c
> +++ b/net/ethtool/linkinfo.c
> @@ -140,8 +140,7 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct ge=
nl_info *info)
> =20
>  	ret =3D __ethtool_get_link_ksettings(dev, &ksettings);
>  	if (ret < 0) {
> -		if (info)
> -			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
> +		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>  		goto out_ops;
>  	}
>  	lsettings =3D &ksettings.base;

This change is already in net tree as commit 178f67b1288b ("ethtool:
linkinfo: remove an unnecessary NULL check").

> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> index 452608c..b759133 100644
> --- a/net/ethtool/linkmodes.c
> +++ b/net/ethtool/linkmodes.c
> @@ -353,8 +353,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct g=
enl_info *info)
> =20
>  	ret =3D __ethtool_get_link_ksettings(dev, &ksettings);
>  	if (ret < 0) {
> -		if (info)
> -			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
> +		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>  		goto out_ops;
>  	}
> =20

For this part,=20

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Michal

--vndb34irvom74w52
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7bnq4ACgkQ538sG/LR
dpWtqQgAnRXsX6rMwN09s8h5wKb4I7K7sPGDGv9vD8nVWVtfnpY4tABo6+p4PGpl
m6Pk2COSSry3YBAOh+agpwdGuJJJnNy2SjEW4UJ9ucfW3457/qadBiVXl2Qmokys
fE+0vjuJIu59nS3DQuAZcpiMUU0Phjx7+1iiWTALpBEJq5RXP4EQljYTdATbsZtG
AVlRrBetRDgO6KHpNJraHeTLVo0n64nM2+yH1LZ6F65FfP5n2LhB4QbRhrOf3ZaF
iA/qpp0paWP5eraMiWKzVloYiF+T7e7FVBcERXvZDRc6PpIrdQ/2/D42/TY2G7ov
xTDJimPLjOH2m2jFZK5u6DKsw40I/w==
=NVyr
-----END PGP SIGNATURE-----

--vndb34irvom74w52--
