Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D631EF806
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgFEMb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:31:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:40140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbgFEMb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:31:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4E8B5ABCF;
        Fri,  5 Jun 2020 12:31:58 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6AF5C60302; Fri,  5 Jun 2020 14:31:54 +0200 (CEST)
Date:   Fri, 5 Jun 2020 14:31:54 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] ethtool: linkinfo: remove an unnecessary NULL check
Message-ID: <20200605123154.vwhlbnqthvtciauj@lion.mk-sys.cz>
References: <20200605110413.GF978434@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uhia6p2wxxyz4zql"
Content-Disposition: inline
In-Reply-To: <20200605110413.GF978434@mwanda>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uhia6p2wxxyz4zql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 05, 2020 at 02:04:13PM +0300, Dan Carpenter wrote:
> This code generates a Smatch warning:
>=20
>     net/ethtool/linkinfo.c:143 ethnl_set_linkinfo()
>     warn: variable dereferenced before check 'info' (see line 119)
>=20
> Fortunately, the "info" pointer is never NULL so the check can be
> removed.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

The same useless check is also in ethnl_set_linkmodes(), I'll send
a patch for that one.

Michal

> ---
>  net/ethtool/linkinfo.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
> index 677068deb68c0..5eaf173eaaca5 100644
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
> --=20
> 2.26.2
>=20

--uhia6p2wxxyz4zql
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7aOzMACgkQ538sG/LR
dpWtJAgAg7nxLCgCxy8aVU/plaBV1h4dISFI4ZZPMCIrk57iyqIOcw+uqYarz3+6
ngBikC4JL4Z2hBKEjTegiKs9KpfQlvJdAR5sqRjgp1oboPcT61tz0wPM9xEKy1EN
cT8MOWzwkickK7wOE8wxGbI+uHuG0rIjL6vS6cUk2gxdH13Wa1K4oVtlOUcZOSj/
qMCr2FK0l4ESQGr/JI1lzCGYv1KH9cklysr7tvXftATpuXglL/4I4Hb8o85iPYCM
XGMxZ4UnqdcaYEo0aj4xBK3GYKX1kAU2KpUKjR/Xtu8xPB0Ztdtvz99tBM1+KLfR
1FB22+DQ/Vrcp6aQ3el6MaRaxHAiJA==
=oOVc
-----END PGP SIGNATURE-----

--uhia6p2wxxyz4zql--
