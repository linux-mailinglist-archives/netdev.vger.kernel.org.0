Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA34F564177
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiGBQ0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiGBQ0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:26:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6C5FD02
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:26:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7fwp-0004Qj-Iv; Sat, 02 Jul 2022 18:26:19 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 11271A598A;
        Sat,  2 Jul 2022 16:26:16 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:26:16 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Message-ID: <20220702162616.zjlul4wpcgucauts@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="52p4kktnn5v2xh5r"
Content-Disposition: inline
In-Reply-To: <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--52p4kktnn5v2xh5r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.07.2022 15:01:30, Biju Das wrote:
> The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> to others like it has no clock divider register (CDR) support and it has
> no HW loopback(HW doesn't see tx messages on rx).
>=20
> This patch adds support for RZ/N1 SJA1000 CAN Controller.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/can/sja1000/sja1000_platform.c | 34 ++++++++++++++++++----
>  1 file changed, 29 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/can/sja1000/sja1000_platform.c b/drivers/net/can=
/sja1000/sja1000_platform.c
> index 5f3d362e0da5..8e63af76a013 100644
> --- a/drivers/net/can/sja1000/sja1000_platform.c
> +++ b/drivers/net/can/sja1000/sja1000_platform.c
> @@ -14,6 +14,7 @@
>  #include <linux/irq.h>
>  #include <linux/can/dev.h>
>  #include <linux/can/platform/sja1000.h>
> +#include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> @@ -103,6 +104,11 @@ static void sp_technologic_init(struct sja1000_priv =
*priv, struct device_node *o
>  	spin_lock_init(&tp->io_lock);
>  }
> =20
> +static void sp_rzn1_init(struct sja1000_priv *priv, struct device_node *=
of)
> +{
> +	priv->flags =3D SJA1000_NO_CDR_REG_QUIRK | SJA1000_NO_HW_LOOPBACK_QUIRK;
> +}
> +
>  static void sp_populate(struct sja1000_priv *priv,
>  			struct sja1000_platform_data *pdata,
>  			unsigned long resource_mem_flags)
> @@ -153,11 +159,13 @@ static void sp_populate_of(struct sja1000_priv *pri=
v, struct device_node *of)
>  		priv->write_reg =3D sp_write_reg8;
>  	}
> =20
> -	err =3D of_property_read_u32(of, "nxp,external-clock-frequency", &prop);
> -	if (!err)
> -		priv->can.clock.freq =3D prop / 2;
> -	else
> -		priv->can.clock.freq =3D SP_CAN_CLOCK; /* default */
> +	if (!priv->can.clock.freq) {
> +		err =3D of_property_read_u32(of, "nxp,external-clock-frequency", &prop=
);
> +		if (!err)
> +			priv->can.clock.freq =3D prop / 2;
> +		else
> +			priv->can.clock.freq =3D SP_CAN_CLOCK; /* default */
> +	}
> =20
>  	err =3D of_property_read_u32(of, "nxp,tx-output-mode", &prop);
>  	if (!err)
> @@ -192,8 +200,13 @@ static struct sja1000_of_data technologic_data =3D {
>  	.init =3D sp_technologic_init,
>  };
> =20
> +static struct sja1000_of_data renesas_data =3D {
> +	.init =3D sp_rzn1_init,
> +};
> +
>  static const struct of_device_id sp_of_table[] =3D {
>  	{ .compatible =3D "nxp,sja1000", .data =3D NULL, },
> +	{ .compatible =3D "renesas,rzn1-sja1000", .data =3D &renesas_data, },
>  	{ .compatible =3D "technologic,sja1000", .data =3D &technologic_data, },
>  	{ /* sentinel */ },
>  };
> @@ -210,6 +223,7 @@ static int sp_probe(struct platform_device *pdev)
>  	struct device_node *of =3D pdev->dev.of_node;
>  	const struct sja1000_of_data *of_data =3D NULL;
>  	size_t priv_sz =3D 0;
> +	struct clk *clk;
> =20
>  	pdata =3D dev_get_platdata(&pdev->dev);
>  	if (!pdata && !of) {
> @@ -262,6 +276,16 @@ static int sp_probe(struct platform_device *pdev)
>  	priv->reg_base =3D addr;
> =20
>  	if (of) {
> +		clk =3D devm_clk_get_optional(&pdev->dev, "can_clk");
> +		if (IS_ERR(clk))
> +			return dev_err_probe(&pdev->dev, PTR_ERR(clk), "no CAN clk");

Please take care of releasing all acquired resources.

> +
> +		if (clk) {
> +			priv->can.clock.freq  =3D clk_get_rate(clk) / 2;
> +			if (!priv->can.clock.freq)
> +				return dev_err_probe(&pdev->dev, -EINVAL, "Zero CAN clk rate");

same here.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--52p4kktnn5v2xh5r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAcaUACgkQrX5LkNig
0133pwf8CAyFKei1tMIffEcDvMZnO4lyxCwikis4LruwcdTDcAnKIwqAScbppD/C
DEECgwtkPlLToNTI0Dr3/jmUA0yxgTHuFEv9jbqyOTPpBGnDewL1MnyPT2tcwZkk
nr7TTyOyFzR7hbF/0UojlnHvqxsg13BsqzkH2rEemP3zSO16g97VbQVInafE+9LN
PI3o9rnl6v44NkUstYBftEs/NEOez/SeTQ+qoPoDvFLmFUOzGcDucD7qpOGMhr9N
ACG7ltHez6gASORvPVLJededWFqNdhOvOAIS25aYiHSVHlTTcgIQtgZzn7yd4G0q
Bm5FN+VFAHJzDgd5oMKu7oZj/6QZdg==
=BhcI
-----END PGP SIGNATURE-----

--52p4kktnn5v2xh5r--
