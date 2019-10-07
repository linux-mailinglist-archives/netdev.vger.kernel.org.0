Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830CECEDD3
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfJGUoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:44:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:26406 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbfJGUoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 16:44:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 13:44:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="asc'?scan'208";a="394457126"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 07 Oct 2019 13:44:12 -0700
Message-ID: <a00c9af7d24ac0dd6af8698c9e545591392720fe.camel@intel.com>
Subject: Re: i40e_pto.c: Odd use of strlcpy converted from strncpy
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Joe Perches <joe@perches.com>, intel-wired-lan@lists.osuosl.org,
        netdev <netdev@vger.kernel.org>
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        Patryk =?UTF-8?Q?Ma=C5=82ek?= <patryk.malek@intel.com>
Date:   Mon, 07 Oct 2019 13:44:11 -0700
In-Reply-To: <edf91d8284a2a19d956eb8b7e8b6c4984ceaa1ab.camel@perches.com>
References: <edf91d8284a2a19d956eb8b7e8b6c4984ceaa1ab.camel@perches.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7z2uVr0ArLU7yfEvLYqf"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-7z2uVr0ArLU7yfEvLYqf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-10-06 at 10:19 -0700, Joe Perches wrote:
> This got converted from strncpy to strlcpy but it's
> now not necessary to use one character less than the
> actual size.
>=20
> Perhaps the sizeof() - 1 is now not correct and it
> should use strscpy and a normal sizeof.
>=20
> from:
>=20
> commit 7eb74ff891b4e94b8bac48f648a21e4b94ddee64
> Author: Mitch Williams <mitch.a.williams@intel.com>
> Date:   Mon Aug 20 08:12:30 2018 -0700
>=20
>     i40e: use correct length for strncpy
>=20
> and
>=20
> commit 4ff2d8540321324e04c1306f85d4fe68a0c2d0ae
> Author: Patryk Ma=C5=82ek <patryk.malek@intel.com>
> Date:   Tue Oct 30 10:50:44 2018 -0700
>=20
>     i40e: Replace strncpy with strlcpy to ensure null termination

Looks like you have a typo in the subject, s/i40e_pto.c/i40e_ptp.c/.

You are also missing you signed-off-by: and Fixes:, I can get your
change under test in the meantime to confirm your fix.

> ---
>  drivers/net/ethernet/intel/i40e/i40e_ptp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
> b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
> index 9bf1ad4319f5..627b1c02bb4b 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
> @@ -700,8 +700,8 @@ static long i40e_ptp_create_clock(struct i40e_pf
> *pf)
>  	if (!IS_ERR_OR_NULL(pf->ptp_clock))
>  		return 0;
> =20
> -	strlcpy(pf->ptp_caps.name, i40e_driver_name,
> -		sizeof(pf->ptp_caps.name) - 1);
> +	strscpy(pf->ptp_caps.name, i40e_driver_name, sizeof(pf-
> >ptp_caps.name));
> +
>  	pf->ptp_caps.owner =3D THIS_MODULE;
>  	pf->ptp_caps.max_adj =3D 999999999;
>  	pf->ptp_caps.n_ext_ts =3D 0;
>=20
>=20


--=-7z2uVr0ArLU7yfEvLYqf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl2bo5sACgkQ5W/vlVpL
7c7A/A//TFv2ges65eXffdGEeIeVqNUr6O2L2LlRXuHfmzJXqiVnV2i8U3bV+SMf
P3yskWbSyiL7BS2fi34rFsyZhImT6MzGwdIC4fRmn+pRgPLTouM4AL6p4A0JeLXn
KPNt8POTXg8ETlwovOfpY67xDEmgn9C9+GN3/7lYHOCROpY25AEYPk1Bo9u5Iw5Q
31drnh6M+sSdxWrcT5o3EHzfHPbhxJ4mP0lu+Gd3mKe2boIN0Du3BDkVQtK5ryQn
gqtp6ns8PA+4Eq15R30/IYF6mMKIz6X/06NWjmK18mFNUs5Z9I0vo613BaOQ3iX5
Pk7VZ6nlKsUyP2btwjlSFfJjeX2NBlPDyrjsBvWmAeRrD0y08mcN3slv8seEEMeX
2eyDfZ2l4PY7PmVM2CddLJrpkoNzbHp5eEPlfiy0V3SE9F5XJQtQZ0citWul+p0C
gaij35pW/B7JK9btdFry93Q22zfsV797J1XLkRkLni0+KGzIJMVbRiwBsNWPxIP4
K11Pv+fi0SBkeDiChQ/3ED5QJRbV2dPLb7HAIlzPYoB6fsZdTTJJpKAP/cTawEJA
qAwiO2DVBipJwqP1nHBdQcUJCLo0QgkdfrGONRgSQURxY4Al/9Ra4IJFcoiphq4P
SH+vQcaQcfYNSwyE7Tdxaa5YGnZPdw7naFJuSy3PpUq1CB9K8Oo=
=XpGh
-----END PGP SIGNATURE-----

--=-7z2uVr0ArLU7yfEvLYqf--

