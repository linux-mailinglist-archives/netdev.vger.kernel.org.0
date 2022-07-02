Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EE2564181
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiGBQki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiGBQkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:40:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30708642D
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:40:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7gAQ-0005V2-It; Sat, 02 Jul 2022 18:40:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 13A6BA599C;
        Sat,  2 Jul 2022 16:40:19 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:40:18 +0200
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
        linux-renesas-soc@vger.kernel.org, ukl@pengutronix.de
Subject: Re: [PATCH 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Message-ID: <20220702164018.ztizq3ftto4lsabr@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-7-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f3wdjqabzkv2g5gp"
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


--f3wdjqabzkv2g5gp
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
[...]
> @@ -262,6 +276,16 @@ static int sp_probe(struct platform_device *pdev)
>  	priv->reg_base =3D addr;
> =20
>  	if (of) {
> +		clk =3D devm_clk_get_optional(&pdev->dev, "can_clk");
> +		if (IS_ERR(clk))
> +			return dev_err_probe(&pdev->dev, PTR_ERR(clk), "no CAN clk");
> +
> +		if (clk) {
> +			priv->can.clock.freq  =3D clk_get_rate(clk) / 2;
> +			if (!priv->can.clock.freq)
> +				return dev_err_probe(&pdev->dev, -EINVAL, "Zero CAN clk rate");
> +		}

There's no clk_prepare_enable in the driver. You might go the quick and
dirty way an enable the clock right here. IIRC there's a new convenience
function to get and enable a clock, managed bei devm. Uwe (Cc'ed) can
point you in the right direction.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--f3wdjqabzkv2g5gp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAdOwACgkQrX5LkNig
012S4wgAnHRTDIcK00UJstKOyPHiPAq+rg4NkUTRoItwb2OXxLMRN17BIBwDnVeR
VMPmhJCa6m5USotTb5XkCaSwzbJid6flyV5o7C1U55fm00Yu9QOf+hbHa5gK6rJ6
m9Fi0SQ9yAYhtA4CvmvJCHC4lWazQlRRldThx/nJaW1jhTALXEgmsF4D7NXKu91t
9gwPeyzSPzEUXhOT5zw1P48CCs3xUZFR6fhB2N7b6m5i/QXFtnAfg8AHuFE4+uJg
qrJ2dqOuGsBtInwDA6TNjAh4uXnSZoxC+yAApmhxK8PfxipPzjzIsUnlYQcqMiWi
0tjMpZjGRkxoEO92AJwNCybn1PnkvA==
=Gqtl
-----END PGP SIGNATURE-----

--f3wdjqabzkv2g5gp--
