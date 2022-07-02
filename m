Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C4556415F
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbiGBQQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiGBQQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:16:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD2DF5B6
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:16:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7fmv-0003QY-5e; Sat, 02 Jul 2022 18:16:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9B17EA5975;
        Sat,  2 Jul 2022 16:16:02 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:16:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/6] can: sja1000: Add Quirks for RZ/N1 SJA1000 CAN
 controller
Message-ID: <20220702161601.5bodwpgn4taoeprq@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-4-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7vkzvfkvsowegrl4"
Content-Disposition: inline
In-Reply-To: <20220702140130.218409-4-biju.das.jz@bp.renesas.com>
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


--7vkzvfkvsowegrl4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.07.2022 15:01:27, Biju Das wrote:
> Chapter 6.5.16 of the RZ/N1 Peripheral Manual mentions the below
> differences compared to the reference Philips SJA1000 device.
>=20
> Handling of Transmitted Messages:
>  * The CAN controller does not copy transmitted messages to the receive
>    buffer, unlike the reference device.
>=20
> Clock Divider Register:
>  * This register is not supported
>=20
> This patch adds device quirks to handle these differences.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/can/sja1000/sja1000.c | 17 +++++++++++------
>  drivers/net/can/sja1000/sja1000.h |  4 +++-
>  2 files changed, 14 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/=
sja1000.c
> index 2e7638f98cf1..49cf4fc4d896 100644
> --- a/drivers/net/can/sja1000/sja1000.c
> +++ b/drivers/net/can/sja1000/sja1000.c
> @@ -183,8 +183,9 @@ static void chipset_init(struct net_device *dev)
>  {
>  	struct sja1000_priv *priv =3D netdev_priv(dev);
> =20
> -	/* set clock divider and output control register */
> -	priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
> +	if (!(priv->flags & SJA1000_NO_CDR_REG_QUIRK))
> +		/* set clock divider and output control register */
> +		priv->write_reg(priv, SJA1000_CDR, priv->cdr | CDR_PELICAN);
> =20
>  	/* set acceptance filter (accept all) */
>  	priv->write_reg(priv, SJA1000_ACCC0, 0x00);
> @@ -208,9 +209,11 @@ static void sja1000_start(struct net_device *dev)
>  	if (priv->can.state !=3D CAN_STATE_STOPPED)
>  		set_reset_mode(dev);
> =20
> -	/* Initialize chip if uninitialized at this stage */
> -	if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
> -		chipset_init(dev);
> +	if (!(priv->flags & SJA1000_NO_CDR_REG_QUIRK)) {
> +		/* Initialize chip if uninitialized at this stage */
> +		if (!(priv->read_reg(priv, SJA1000_CDR) & CDR_PELICAN))
> +			chipset_init(dev);
> +	}
> =20
>  	/* Clear error counters and error code capture */
>  	priv->write_reg(priv, SJA1000_TXERR, 0x0);
> @@ -652,12 +655,14 @@ static const struct net_device_ops sja1000_netdev_o=
ps =3D {
> =20
>  int register_sja1000dev(struct net_device *dev)
>  {
> +	struct sja1000_priv *priv =3D netdev_priv(dev);
>  	int ret;
> =20
>  	if (!sja1000_probe_chip(dev))
>  		return -ENODEV;
> =20
> -	dev->flags |=3D IFF_ECHO;	/* we support local echo */
> +	if (!(priv->flags & SJA1000_NO_HW_LOOPBACK_QUIRK))
> +		dev->flags |=3D IFF_ECHO;	/* we support local echo */
>  	dev->netdev_ops =3D &sja1000_netdev_ops;
> =20
>  	set_reset_mode(dev);
> diff --git a/drivers/net/can/sja1000/sja1000.h b/drivers/net/can/sja1000/=
sja1000.h
> index 9d46398f8154..d0b8ce3f70ec 100644
> --- a/drivers/net/can/sja1000/sja1000.h
> +++ b/drivers/net/can/sja1000/sja1000.h
> @@ -145,7 +145,9 @@
>  /*
>   * Flags for sja1000priv.flags
>   */
> -#define SJA1000_CUSTOM_IRQ_HANDLER 0x1
> +#define SJA1000_CUSTOM_IRQ_HANDLER	BIT(0)
> +#define SJA1000_NO_CDR_REG_QUIRK	BIT(1)
> +#define SJA1000_NO_HW_LOOPBACK_QUIRK	BIT(2)

Please name these defines SJA1000_QUIRK_*

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7vkzvfkvsowegrl4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAbz8ACgkQrX5LkNig
012hjAf9GhfcXvs9wRFl+sZS1vgLfNO7ziu0Dcgv7YypEOpSb66vXxiAssHfGIAC
seqK4EIvnF4xTlljgYE71o1UVV+T18XGECCrJi659pQx1gEv2mhGF8BADW6+4LCm
kZJjvNmxEmpgvAxZrZUaIdEnc16G4EzPbSJv8rvg4W4iw8cysXbYAFxIqCIQ3VkV
3Hcm27giZLTDkkxNUgCMkZx4lM7D/8TJa1yovgP/qifmZ6uVQ8k25lAFZuSlLJER
1+2AzKipzceaXsHw4Pon36QGYNxgaOW2d5YorMQqbrbHvSZjhI1z7k+ooF21HiYF
DtIl+dbkB8zRzlKDuPmUiFozP7W4dg==
=M+H8
-----END PGP SIGNATURE-----

--7vkzvfkvsowegrl4--
