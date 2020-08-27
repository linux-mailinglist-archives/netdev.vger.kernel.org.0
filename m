Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1862543D4
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgH0KhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:37:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:38276 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgH0Kg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 06:36:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D39DEB817;
        Thu, 27 Aug 2020 10:37:27 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 84498603FB; Thu, 27 Aug 2020 12:36:55 +0200 (CEST)
Date:   Thu, 27 Aug 2020 12:36:55 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [v2] ioctl: only memset non-NULL link settings
Message-ID: <20200827103655.vyjtik4p23tzop4n@lion.mk-sys.cz>
References: <20200827095033.3265848-1-hegtvedt@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4xpnzbfts5mx4ci6"
Content-Disposition: inline
In-Reply-To: <20200827095033.3265848-1-hegtvedt@cisco.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4xpnzbfts5mx4ci6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2020 at 11:50:33AM +0200, Hans-Christian Noren Egtvedt wrot=
e:
> In commit bef780467fa ('ioctl: do not pass transceiver value back to
> kernel') a regression slipped in. If we have a kernel that does not
> support the ETHTOOL_xLINKSETTINGS API, then the do_ioctl_glinksettings()
> function will return a NULL pointer.
>=20
> Hence before memset'ing the pointer to zero we must first check it is
> valid, as NULL return is perfectly fine when running on old kernels.
>=20
> Fixes: bef780467fa7 ("ioctl: do not pass transceiver value back to kernel=
")
> Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>

Applied, thank you.

Michal

> ---
>  ethtool.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/ethtool.c b/ethtool.c
> index e32a93b..606af3e 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -3048,10 +3048,11 @@ static int do_sset(struct cmd_context *ctx)
>  		struct ethtool_link_usettings *link_usettings;
> =20
>  		link_usettings =3D do_ioctl_glinksettings(ctx);
> -		memset(&link_usettings->deprecated, 0,
> -		       sizeof(link_usettings->deprecated));
>  		if (link_usettings =3D=3D NULL)
>  			link_usettings =3D do_ioctl_gset(ctx);
> +		else
> +			memset(&link_usettings->deprecated, 0,
> +			       sizeof(link_usettings->deprecated));
>  		if (link_usettings =3D=3D NULL) {
>  			perror("Cannot get current device settings");
>  			err =3D -1;
> --=20
> 2.25.1
>=20

--4xpnzbfts5mx4ci6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9HjMIACgkQ538sG/LR
dpW4qQf9FjoE73reT6BPISFOhDaajwR/tVkOW4TiPuvtuOw+CyNb/OWkVLPAX8xp
IMJ+CIH8e2veaMq5OSEUETOhVB+GKaPUkW3gMeZjNcu5WxtC/SCZ1fz6VtMk+KQ3
9LugQyNbcFwaHFXNDmgyYGSVoqlPDEN/jeKXQ9TVQf7cbO0yYIPZiQgQjkJ7Z3zL
xoM/IgATlV1TlD0jy/gOPiir8xAnb15+MAxDgXFo4kGWb2D68LKUVFI2YZx6V9Ny
vEAdXML9o4+S0ksFBmodPPwGr5GiCPxc/Vo8tHku7cilNU64Lm9JpmMh+i7gY24c
kAe7s1MosKkyaZsbGOYm9WuSqfks9w==
=0LTI
-----END PGP SIGNATURE-----

--4xpnzbfts5mx4ci6--
