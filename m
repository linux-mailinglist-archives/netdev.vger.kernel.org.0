Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE5429116F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 12:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437241AbgJQKd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 06:33:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57704 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410981AbgJQKd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 06:33:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 597A21C0B76; Sat, 17 Oct 2020 12:33:55 +0200 (CEST)
Date:   Sat, 17 Oct 2020 12:33:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/4] ptp: ptp_idt82p33: update to support adjphase
Message-ID: <20201017103354.GA4607@amd>
References: <1596815755-10994-1-git-send-email-min.li.xe@renesas.com>
 <OSAPR01MB178028345EC84C1564DD104ABA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <OSAPR01MB178028345EC84C1564DD104ABA020@OSAPR01MB1780.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32=20
> +offsetNs) {

adj_write_phase?

> +	struct idt82p33_channel *channel =3D
> +		container_of(ptp, struct idt82p33_channel, caps);
> +	struct idt82p33 *idt82p33 =3D channel->idt82p33;
> +	s64 offsetInFs;
> +	s64 offsetRegVal;
> +	u8 val[4] =3D {0};
> +	int err;
> +
> +	offsetInFs =3D (s64)(-offsetNs) * 1000000;
> +
> +	if (offsetInFs > WRITE_PHASE_OFFSET_LIMIT)
> +		offsetInFs =3D WRITE_PHASE_OFFSET_LIMIT;
> +	else if (offsetInFs < -WRITE_PHASE_OFFSET_LIMIT)
> +		offsetInFs =3D -WRITE_PHASE_OFFSET_LIMIT;

I'm sure we have macro for this.

> +	/* Convert from phaseOffsetInFs to register value */
> +	offsetRegVal =3D ((offsetInFs * 1000) / IDT_T0DPLL_PHASE_RESOL);
> +
> +	val[0] =3D offsetRegVal & 0xFF;
> +	val[1] =3D (offsetRegVal >> 8) & 0xFF;
> +	val[2] =3D (offsetRegVal >> 16) & 0xFF;
> +	val[3] =3D (offsetRegVal >> 24) & 0x1F;
> +	val[3] |=3D PH_OFFSET_EN;

ThisIsReally far away from usual coding style.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+KyJIACgkQMOfwapXb+vItegCgjkLFpg997O4+vZn7lY5OGlbw
OPIAniV9ymdVsUZIgo8euo0SOxRXVWr8
=wXVU
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
