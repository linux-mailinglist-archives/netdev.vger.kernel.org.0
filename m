Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA53924EE09
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 17:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgHWPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 11:55:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:32916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgHWPzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 11:55:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E757BAB3E;
        Sun, 23 Aug 2020 15:55:42 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 65D616030D; Sun, 23 Aug 2020 17:55:13 +0200 (CEST)
Date:   Sun, 23 Aug 2020 17:55:13 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 1/2] netlink: Fix the condition for displaying
 actual changes
Message-ID: <20200823155513.umnbppvbcpirnyrp@lion.mk-sys.cz>
References: <20200814131745.32215-1-maximmi@mellanox.com>
 <20200814131745.32215-2-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jokywthhdp25na45"
Content-Disposition: inline
In-Reply-To: <20200814131745.32215-2-maximmi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jokywthhdp25na45
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2020 at 04:17:44PM +0300, Maxim Mikityanskiy wrote:
> This comment in the code:
>=20
>     /* result is not exactly as requested, show differences */
>=20
> implies that the "Actual changes" output should be displayed only if the
> result is not as requested, which matches the legacy ethtool behavior.
> However, in fact, ethtool-netlink displays "actual changes" even when
> the changes are expected (e.g., one bit was requested, and it was
> changed as requested).
>=20
> This commit fixes the condition above to make the behavior match the
> description in the comment and the behavior of the legacy ethtool. The
> new condition excludes the req_mask bits from active_mask to avoid
> reacting on bit changes that we asked for. The new condition now
> matches the ifs in the loop above that print "[requested on/off]" and
> "[not requested]".
>=20
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Applied, thank you.

Michal

> ---
>  netlink/features.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/netlink/features.c b/netlink/features.c
> index 8b5b858..133529d 100644
> --- a/netlink/features.c
> +++ b/netlink/features.c
> @@ -413,7 +413,7 @@ static void show_feature_changes(struct nl_context *n=
lctx,
> =20
>  	diff =3D false;
>  	for (i =3D 0; i < words; i++)
> -		if (wanted_mask[i] || active_mask[i])
> +		if (wanted_mask[i] || (active_mask[i] & ~sfctx->req_mask[i]))
>  			diff =3D true;
>  	if (!diff)
>  		return;
> --=20
> 2.21.0
>=20

--jokywthhdp25na45
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9CkVwACgkQ538sG/LR
dpWxIgf/RJ4skFwdl510ZeSz6uNjEk2cWj7j5LiEq3GCtQpZbsyezYfk9vb/7A4E
j2cfUAe+heYNhZ1k6Pae7JLgu4XZcoefecKyMpIvaW725MnEvdDejTn6skJij/XU
XAU0D6ve9ualPERTCiRHvyoWUXGlNau2Av4FTqh2h2MyYU+O1IDLv1OWPfrkY5YA
AFQcbr2sS9p+yvXIPRX0R3w/CfkREXeGVHLqP8O6BnKLzXr+857zYUqIR2e4jUKK
rQUVG9yw6+m1HNCxmmWDrE6fdRW85WrEqIZfYqhkuzP29IRc33s7n0Q+jWQca2Ir
Qnc9ijmQFIGgFwluORcaHG0Zml0OaA==
=NmB+
-----END PGP SIGNATURE-----

--jokywthhdp25na45--
