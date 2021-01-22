Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700532FFD67
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 08:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbhAVH3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 02:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbhAVH3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 02:29:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBC9C0613ED
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 23:29:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2qsF-0006h6-Rm; Fri, 22 Jan 2021 08:28:51 +0100
Received: from [IPv6:2a03:f580:87bc:d400:aed1:e241:8b32:9cc0] (unknown [IPv6:2a03:f580:87bc:d400:aed1:e241:8b32:9cc0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 782CE5CA4FA;
        Fri, 22 Jan 2021 07:28:50 +0000 (UTC)
Subject: Re: [PATCH v3] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
To:     Su Yanjun <suyanjun218@gmail.com>,
        manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210122030130.166242-1-suyanjun218@gmail.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e0de6ea1-c52f-0256-4e1b-8d86dc2bb386@pengutronix.de>
Date:   Fri, 22 Jan 2021 08:28:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210122030130.166242-1-suyanjun218@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="QuG6NMp9amXrJUAOs9RboeETeWh1cslRa"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QuG6NMp9amXrJUAOs9RboeETeWh1cslRa
Content-Type: multipart/mixed; boundary="oKRZK4dgGyHtCcrujiJGEYp4Tb5MbGhnJ";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Su Yanjun <suyanjun218@gmail.com>, manivannan.sadhasivam@linaro.org,
 thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
 kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <e0de6ea1-c52f-0256-4e1b-8d86dc2bb386@pengutronix.de>
Subject: Re: [PATCH v3] can: mcp251xfd: replace sizeof(u32) with val_bytes in
 regmap
References: <20210122030130.166242-1-suyanjun218@gmail.com>
In-Reply-To: <20210122030130.166242-1-suyanjun218@gmail.com>

--oKRZK4dgGyHtCcrujiJGEYp4Tb5MbGhnJ
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 1/22/21 4:01 AM, Su Yanjun wrote:
> The sizeof(u32) is hardcoded. It's better to use the config value in
> regmap.
>=20
> It increases the size of target object, but it's flexible when new mcp =
chip
> need other val_bytes.
>=20
> Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
> ---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/n=
et/can/spi/mcp251xfd/mcp251xfd-core.c
> index f07e8b737d31..3dde52669343 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -1308,6 +1308,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_pri=
v *priv,
>  		       const u8 offset, const u8 len)
>  {
>  	const struct mcp251xfd_tx_ring *tx_ring =3D priv->tx;
> +	int val_bytes =3D regmap_get_val_bytes(priv->map_reg);

You're using the wrong regmap here.

> =20
>  	if (IS_ENABLED(CONFIG_CAN_MCP251XFD_SANITY) &&
>  	    (offset > tx_ring->obj_num ||
> @@ -1322,7 +1323,7 @@ mcp251xfd_tef_obj_read(const struct mcp251xfd_pri=
v *priv,
>  	return regmap_bulk_read(priv->map_rx,
>  				mcp251xfd_get_tef_obj_addr(offset),
>  				hw_tef_obj,
> -				sizeof(*hw_tef_obj) / sizeof(u32) * len);
> +				sizeof(*hw_tef_obj) / val_bytes * len);
>  }
> =20
>  static int mcp251xfd_handle_tefif(struct mcp251xfd_priv *priv)
> @@ -1511,11 +1512,12 @@ mcp251xfd_rx_obj_read(const struct mcp251xfd_pr=
iv *priv,
>  		      const u8 offset, const u8 len)
>  {
>  	int err;
> +	int val_bytes =3D regmap_get_val_bytes(priv->map_reg);

You're using the wrong regmap here.

> =20
>  	err =3D regmap_bulk_read(priv->map_rx,
>  			       mcp251xfd_get_rx_obj_addr(ring, offset),
>  			       hw_rx_obj,
> -			       len * ring->obj_size / sizeof(u32));
> +			       len * ring->obj_size / val_bytes);
> =20
>  	return err;
>  }
> @@ -2139,6 +2141,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *d=
ev_id)
>  	struct mcp251xfd_priv *priv =3D dev_id;
>  	irqreturn_t handled =3D IRQ_NONE;
>  	int err;
> +	int val_bytes =3D regmap_get_val_bytes(priv->map_reg);
> =20
>  	if (priv->rx_int)
>  		do {
> @@ -2162,7 +2165,7 @@ static irqreturn_t mcp251xfd_irq(int irq, void *d=
ev_id)
>  		err =3D regmap_bulk_read(priv->map_reg, MCP251XFD_REG_INT,
>  				       &priv->regs_status,
>  				       sizeof(priv->regs_status) /
> -				       sizeof(u32));
> +				       val_bytes);
>  		if (err)
>  			goto out_fail;
> =20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--oKRZK4dgGyHtCcrujiJGEYp4Tb5MbGhnJ--

--QuG6NMp9amXrJUAOs9RboeETeWh1cslRa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAKfq8ACgkQqclaivrt
76nMsAgAsKXTtjOiJ0d27xqngjBuS1f8bXe30dJ87xn64nkQGzMUJSJu3kPaQd+l
5X7Jb8ae7kH9+gdcJtp9M+Nc+HB0faS4gWeW2gJXB4e8BG+/GhcAnpork2LRxWel
Y828G2PVglRFxH13P5L36fg4GE6WyM4r4AcK9R9EWJ/iiNHV6k3BhwdIap2Ocage
v/wID8WbxA0vXBMdDwZ3npgEhAkZ4mDe7g6EidskGXjdUGmb1+AHg/qHbk83XhNe
nuR/KZEx95ZfRDCd5QpYCs7WPQCkN8bElYftRpWuX8/q5XboD+HoPMLur/Ji7LY1
mg5RDXJq+2bR2a1oZb1BJfAgN+gT7g==
=NEwd
-----END PGP SIGNATURE-----

--QuG6NMp9amXrJUAOs9RboeETeWh1cslRa--
