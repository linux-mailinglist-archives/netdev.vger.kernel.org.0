Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F19282A59
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 13:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbgJDLGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 07:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgJDLGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 07:06:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F06C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 04:06:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kP1qN-0000UL-NQ; Sun, 04 Oct 2020 13:06:19 +0200
Received: from [IPv6:2a03:f580:87bc:d400:fc36:ae63:3b35:518b] (unknown [IPv6:2a03:f580:87bc:d400:fc36:ae63:3b35:518b])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B1FB6571D48;
        Sun,  4 Oct 2020 11:06:14 +0000 (UTC)
Subject: Re: [PATCH v3 5/7] can: dev: add a helper function to calculate the
 duration of one bit
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>
References: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
 <20201002154219.4887-6-mailhol.vincent@wanadoo.fr>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <49660a42-9465-a519-6dd4-0f80795b0aca@pengutronix.de>
Date:   Sun, 4 Oct 2020 13:06:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002154219.4887-6-mailhol.vincent@wanadoo.fr>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="P1bLlkMoGDRCGjbltFWf9Kxwgcrtronrj"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P1bLlkMoGDRCGjbltFWf9Kxwgcrtronrj
Content-Type: multipart/mixed; boundary="kuD8BCZsIJtNW8FfoNg0Blx3C0CIPhP7q";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
 "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>
Message-ID: <49660a42-9465-a519-6dd4-0f80795b0aca@pengutronix.de>
Subject: Re: [PATCH v3 5/7] can: dev: add a helper function to calculate the
 duration of one bit
References: <20201002154219.4887-1-mailhol.vincent@wanadoo.fr>
 <20201002154219.4887-6-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20201002154219.4887-6-mailhol.vincent@wanadoo.fr>

--kuD8BCZsIJtNW8FfoNg0Blx3C0CIPhP7q
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 10/2/20 5:41 PM, Vincent Mailhol wrote:
> Rename macro CAN_CALC_SYNC_SEG to CAN_SYNC_SEG and make it available
> through include/linux/can/dev.h
>=20
> Add an helper function can_bit_time() which returns the duration (in
> time quanta) of one CAN bit.
>=20
> Rationale for this patch: the sync segment and the bit time are two
> concepts which are defined in the CAN ISO standard. Device drivers for
> CAN might need those.
>=20
> Please refer to ISO 11898-1:2015, section 11.3.1.1 "Bit time" for
> additional information.
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>=20
> Changes in v3: None
>=20
> Changes in v2: None
> ---
>  drivers/net/can/dev.c   | 13 ++++++-------
>  include/linux/can/dev.h | 15 +++++++++++++++
>  2 files changed, 21 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 8c3e11820e03..6070b4ab3bd8 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -60,7 +60,6 @@ EXPORT_SYMBOL_GPL(can_len2dlc);
> =20
>  #ifdef CONFIG_CAN_CALC_BITTIMING
>  #define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
> -#define CAN_CALC_SYNC_SEG 1
> =20
>  /* Bit-timing calculation derived from:
>   *
> @@ -86,8 +85,8 @@ can_update_sample_point(const struct can_bittiming_co=
nst *btc,
>  	int i;
> =20
>  	for (i =3D 0; i <=3D 1; i++) {
> -		tseg2 =3D tseg + CAN_CALC_SYNC_SEG -
> -			(sample_point_nominal * (tseg + CAN_CALC_SYNC_SEG)) /
> +		tseg2 =3D tseg + CAN_SYNC_SEG -
> +			(sample_point_nominal * (tseg + CAN_SYNC_SEG)) /
>  			1000 - i;
>  		tseg2 =3D clamp(tseg2, btc->tseg2_min, btc->tseg2_max);
>  		tseg1 =3D tseg - tseg2;
> @@ -96,8 +95,8 @@ can_update_sample_point(const struct can_bittiming_co=
nst *btc,
>  			tseg2 =3D tseg - tseg1;
>  		}
> =20
> -		sample_point =3D 1000 * (tseg + CAN_CALC_SYNC_SEG - tseg2) /
> -			(tseg + CAN_CALC_SYNC_SEG);
> +		sample_point =3D 1000 * (tseg + CAN_SYNC_SEG - tseg2) /
> +			(tseg + CAN_SYNC_SEG);
>  		sample_point_error =3D abs(sample_point_nominal - sample_point);
> =20
>  		if (sample_point <=3D sample_point_nominal &&
> @@ -145,7 +144,7 @@ static int can_calc_bittiming(struct net_device *de=
v, struct can_bittiming *bt,
>  	/* tseg even =3D round down, odd =3D round up */
>  	for (tseg =3D (btc->tseg1_max + btc->tseg2_max) * 2 + 1;
>  	     tseg >=3D (btc->tseg1_min + btc->tseg2_min) * 2; tseg--) {
> -		tsegall =3D CAN_CALC_SYNC_SEG + tseg / 2;
> +		tsegall =3D CAN_SYNC_SEG + tseg / 2;
> =20
>  		/* Compute all possible tseg choices (tseg=3Dtseg1+tseg2) */
>  		brp =3D priv->clock.freq / (tsegall * bt->bitrate) + tseg % 2;
> @@ -223,7 +222,7 @@ static int can_calc_bittiming(struct net_device *de=
v, struct can_bittiming *bt,
> =20
>  	/* real bitrate */
>  	bt->bitrate =3D priv->clock.freq /
> -		(bt->brp * (CAN_CALC_SYNC_SEG + tseg1 + tseg2));
> +		(bt->brp * (CAN_SYNC_SEG + tseg1 + tseg2));
> =20
>  	return 0;
>  }
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index 791c452d98e1..77c3ea49b8fb 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -82,6 +82,21 @@ struct can_priv {
>  #endif
>  };
> =20
> +#define CAN_SYNC_SEG 1
> +
> +/*
> + * can_bit_time() - Duration of one bit
> + *
> + * Please refer to ISO 11898-1:2015, section 11.3.1.1 "Bit time" for
> + * additional information.
> + *
> + * Return: the number of time quanta in one bit.
> + */
> +static inline int can_bit_time(struct can_bittiming *bt)

make it return an unsigned int
make the bt pointer const

> +{
> +	return CAN_SYNC_SEG + bt->prop_seg + bt->phase_seg1 + bt->phase_seg2;=

> +}
> +
>  /*
>   * get_can_dlc(value) - helper macro to cast a given data length code =
(dlc)
>   * to u8 and ensure the dlc value to be max. 8 bytes.
>=20

tnx,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--kuD8BCZsIJtNW8FfoNg0Blx3C0CIPhP7q--

--P1bLlkMoGDRCGjbltFWf9Kxwgcrtronrj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl95rKEACgkQqclaivrt
76nNqAf/Yqv5BenuwGeUEUfjqLdv3j5eEAstISItQt3Gv2lMpI7V3l7/w9Uqjuku
tgRSb2hTfSde19RVNX1C0n+mIl6wJ1nKUYqOEgCqZTA0OYQVgafWhVP+sWf6H6+z
wyFkx9KCPVwlA+SE8FzQm0kzgIqNKKRoSEuaBOBpNgMFR4E3ym5G4d2RaPGCb3oo
bhqNjW9lfcMat+43C+e8To2xRvuiAhf4LPR0mepT9d3oF+CC86aFSwroTl2zSQYy
BmlcqCJd5MpZguZ8N6Uuxz9Dso78U3VhQB+NdxDzPqU/mvYDCUSIMAq4R9Dfn4mo
HADgnntCEraELzWTOWXPykfmzSYfSw==
=Te1n
-----END PGP SIGNATURE-----

--P1bLlkMoGDRCGjbltFWf9Kxwgcrtronrj--
