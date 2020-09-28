Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867C827B100
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgI1PhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:37:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:34188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgI1PhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 11:37:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D051AD5F;
        Mon, 28 Sep 2020 15:37:05 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 64D8C603A9; Mon, 28 Sep 2020 17:37:05 +0200 (CEST)
Date:   Mon, 28 Sep 2020 17:37:05 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 2/2] netlink: fix memory leak
Message-ID: <20200928153705.etztslrdglekpadj@lion.mk-sys.cz>
References: <20200924192758.577595-1-ivecera@redhat.com>
 <20200924192758.577595-2-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6u4pxccd5i32viv4"
Content-Disposition: inline
In-Reply-To: <20200924192758.577595-2-ivecera@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6u4pxccd5i32viv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2020 at 09:27:58PM +0200, Ivan Vecera wrote:
> Potentially allocated memory allocated for mask is not freed when
> the allocation for value fails.
>=20
> Fixes: 81a30f416ec7 ("netlink: add bitset command line parser handlers")
>=20
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---

Applied, thank you.

Michal

>  netlink/parser.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/netlink/parser.c b/netlink/parser.c
> index c5a368a65a7a..3b25f5d5a88e 100644
> --- a/netlink/parser.c
> +++ b/netlink/parser.c
> @@ -630,8 +630,10 @@ static int parse_numeric_bitset(struct nl_context *n=
lctx, uint16_t type,
>  	}
> =20
>  	value =3D calloc(nwords, sizeof(uint32_t));
> -	if (!value)
> +	if (!value) {
> +		free(mask);
>  		return -ENOMEM;
> +	}
>  	ret =3D __parse_num_string(arg, len1, value, force_hex1);
>  	if (ret < 0) {
>  		parser_err_invalid_value(nlctx, arg);
> --=20
> 2.26.2
>=20

--6u4pxccd5i32viv4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9yAxsACgkQ538sG/LR
dpV9iQf/Q2JjGebvw5RbIVLpzX/Of9SGspi7FDJpxNjaDvLoweQ1mF1lGV0Zyy9C
b1TVFXQR4FVyZRBz3a1PQe6zGUWwZvLu+Ai8nKjLtxr/gwhQY3/Xl9BRVjMHFtl2
LpMyTpKkuRhhK0s2llrPuELRVdZoaMG0XOU5HIHXBD8WP+L724e+Q5Hhi56ZbI8K
efrC/qwFjJVIqoMXdE4FpC2ZhxesOzzLaQs0+gqJU1EKwjab3mOako3aNAgD0zV6
prQvooruSV9a5Chd6mpL+pYUdgSYhHmPzFtk1xILX9EwNOF2tTGTVAu3wy7NbmPy
cFRZJoTVmnGGkoxh43LsnhEErK9BIg==
=uRlS
-----END PGP SIGNATURE-----

--6u4pxccd5i32viv4--
