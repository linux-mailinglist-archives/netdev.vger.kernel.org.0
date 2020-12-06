Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF612D0685
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 19:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgLFSlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 13:41:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:60704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgLFSlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 13:41:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 188E8AC90;
        Sun,  6 Dec 2020 18:40:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CAAA660344; Sun,  6 Dec 2020 19:40:28 +0100 (CET)
Date:   Sun, 6 Dec 2020 19:40:28 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH ethtool v2] Improve error message when SFP module is
 missing
Message-ID: <20201206184028.fi7ttyyqkmjwnrnj@lion.mk-sys.cz>
References: <19fb6da036b04a465398f5b053b029ea04179aba.1606929734.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iq5i3mpj2wjfa3oa"
Content-Disposition: inline
In-Reply-To: <19fb6da036b04a465398f5b053b029ea04179aba.1606929734.git.baruch@tkos.co.il>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iq5i3mpj2wjfa3oa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02, 2020 at 07:22:14PM +0200, Baruch Siach wrote:
> ETHTOOL_GMODULEINFO request success indicates that SFP cage is present.
> Failure of ETHTOOL_GMODULEEEPROM is most likely because SFP module is
> not plugged in. Add an indication to the user as to what might be the
> reason for the failure.
>=20
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied (with minor whitespace formatting cleanup), thank you.

Michal

> ---
> v2: Limit message to likely errno values (Andrew Lunn)
> ---
>  ethtool.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index 1d9067e774af..63b3a095eded 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -4855,7 +4855,11 @@ static int do_getmodule(struct cmd_context *ctx)
>  	eeprom->offset =3D geeprom_offset;
>  	err =3D send_ioctl(ctx, eeprom);
>  	if (err < 0) {
> +		int saved_errno =3D errno;
>  		perror("Cannot get Module EEPROM data");
> +		if (saved_errno =3D=3D ENODEV || saved_errno =3D=3D EIO ||
> +				saved_errno =3D=3D ENXIO)
> +			fprintf(stderr, "SFP module not in cage?\n");
>  		free(eeprom);
>  		return 1;
>  	}
> --=20
> 2.29.2
>=20

--iq5i3mpj2wjfa3oa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl/NJZcACgkQ538sG/LR
dpVtLQgAjplGryjbE4zOPwOvT0pSHmpFBfvcXGe39NthCH8qmPwkszB3NXApZR55
z2OUMbSASWmHW4KIdGKLyGlH2r8Ugr7mHEizFkyjxFeAQG56SoG/ar0MaSvPT71o
3ZyVybroeHxbK7T96YykalkgsDR7NRfsgjo/ySwHXalOjO8/cSlwrgRUYI0jyXtq
WILNe+Hez03zIgeofdnv3fQPKETOYTRWNosXGviE3YyeD6EKjBo8me+WefpuV9Fv
/DY875j9xYrMmF+NNT0Ew4f2LD8lYO3/PWfu0w6WiJGqMxCB80mK8jsLC8h+2FEB
VX7yiSSb8LZTadSFDdjaSA1o2p/sGw==
=6a/t
-----END PGP SIGNATURE-----

--iq5i3mpj2wjfa3oa--
