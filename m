Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48019315736
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhBITvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:51:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:38498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233634AbhBITnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:43:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E31EEAE07;
        Tue,  9 Feb 2021 19:42:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A6F9860573; Tue,  9 Feb 2021 20:42:29 +0100 (CET)
Date:   Tue, 9 Feb 2021 20:42:29 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH ethtool v2 2/5] netlink: settings: Add netlink support
 for lanes parameter
Message-ID: <20210209194229.7czrlyx6znjsy77v@lion.mk-sys.cz>
References: <20210202182513.325864-1-danieller@nvidia.com>
 <20210202182513.325864-3-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3ssdmg5hcnfiq7bj"
Content-Disposition: inline
In-Reply-To: <20210202182513.325864-3-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3ssdmg5hcnfiq7bj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 08:25:10PM +0200, Danielle Ratson wrote:
> Add support for "ethtool -s <dev> lanes N ..." for setting a specific
> number of lanes.
>=20
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  ethtool.c          | 1 +
>  netlink/settings.c | 8 ++++++++
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 585aafa..fcb09f7 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5620,6 +5620,7 @@ static const struct option args[] =3D {
>  		.nlfunc	=3D nl_sset,
>  		.help	=3D "Change generic options",
>  		.xhelp	=3D "		[ speed %d ]\n"
> +			  "		[ lanes %d ]\n"
>  			  "		[ duplex half|full ]\n"
>  			  "		[ port tp|aui|bnc|mii|fibre|da ]\n"
>  			  "		[ mdix auto|on|off ]\n"
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 90c28b1..6cb5d5b 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -20,6 +20,7 @@
>  struct link_mode_info {
>  	enum link_mode_class	class;
>  	u32			speed;
> +	u32			lanes;
>  	u8			duplex;
>  };
> =20

This structure member is not used anywhere in this patch and, AFAICS,
not even in the rest of your series. Perhaps a leftover from an older
version?

Michal

> @@ -1067,6 +1068,13 @@ static const struct param_parser sset_params[] =3D=
 {
>  		.handler	=3D nl_parse_direct_u32,
>  		.min_argc	=3D 1,
>  	},
> +	{
> +		.arg		=3D "lanes",
> +		.group		=3D ETHTOOL_MSG_LINKMODES_SET,
> +		.type		=3D ETHTOOL_A_LINKMODES_LANES,
> +		.handler	=3D nl_parse_direct_u32,
> +		.min_argc	=3D 1,
> +	},
>  	{
>  		.arg		=3D "duplex",
>  		.group		=3D ETHTOOL_MSG_LINKMODES_SET,
> --=20
> 2.26.2
>=20

--3ssdmg5hcnfiq7bj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmAi5aAACgkQ538sG/LR
dpU4HwgAi0BLn9OlCfVp/Sfng4ajY40lg1IOdGeziFTbI3Q6jL1KhA+FGwJIomUc
qb2YVzCo0tXrKZH2X90kNTC2cPm75bqe9+2d9UGi5PosFU+Zb9uokhzD0d5ZqTKy
sXwRKp4tEcG6SNDpBAhRG3luLi48khPgiBOUT68Y9oAScflROK09WdySu3z6cC8C
IcVQylBKNBrrQCXhBX59Q9GHNQRDeGRPvzqGMXO8kVPcbM/o4/L5KxEYIAg+aQHR
v+XrOypw5LhJq6Y8UTkFP4ZN0/LJAnAN21AVSLmm8TQzoaRGeyJeT/2K4p3ozqaX
gHOKAZDEgK38PYJKa6vaRtfUzNCuHA==
=Debj
-----END PGP SIGNATURE-----

--3ssdmg5hcnfiq7bj--
