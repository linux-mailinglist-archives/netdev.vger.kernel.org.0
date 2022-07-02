Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D256417D
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiGBQdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiGBQdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:33:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B91E024
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:33:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7g3i-00053Q-RI; Sat, 02 Jul 2022 18:33:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BE2EEA5994;
        Sat,  2 Jul 2022 16:33:23 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:33:22 +0200
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
Message-ID: <20220702163322.pmw46uucdciilvcf@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-4-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rrmq4hmepqv7ibgb"
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


--rrmq4hmepqv7ibgb
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

This is something different than....

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

=2E.. the IFF_ECHO.

IFF_ECHO set means the driver cals can_put_echo_skb() before TX and
can_get_echo_skb() after TX complete interrupt.

| irqreturn_t sja1000_interrupt(int irq, void *dev_id)
[...]
| 	while ((isrc =3D priv->read_reg(priv, SJA1000_IR)) &&
| 	       (n < SJA1000_MAX_IRQ)) {
|=20
| 		status =3D priv->read_reg(priv, SJA1000_SR);
| 		/* check for absent controller due to hw unplug */
| 		if (status =3D=3D 0xFF && sja1000_is_absent(priv))
| 			goto out;
|=20
| 		if (isrc & IRQ_WUI)
| 			netdev_warn(dev, "wakeup interrupt\n");
|=20
| 		if (isrc & IRQ_TI) {
| 			/* transmission buffer released */
| 			if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
| 			    !(status & SR_TCS)) {
| 				stats->tx_errors++;
| 				can_free_echo_skb(dev, 0, NULL);
| 			} else {

Please add a netdev_info() for debugging and verify that you get a TX
complete IRQ.

| 				/* transmission complete */
| 				stats->tx_bytes +=3D can_get_echo_skb(dev, 0, NULL);
| 				stats->tx_packets++;
| 			}
| 			netif_wake_queue(dev);
| 		}


If your hardware doesn't support hardware loopback (configured via
CMD_SRR):

| 	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
| 		cmd_reg_val |=3D CMD_SRR;
| 	else
| 		cmd_reg_val |=3D CMD_TR;

then don't set CAN_CTRLMODE_LOOPBACK in priv->can.ctrlmode_supported.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rrmq4hmepqv7ibgb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAc1AACgkQrX5LkNig
010LvggAiS4t/1rvYNu/g/NhSFbptDWfXl0RjwuUTEsPfzlzjiBjAePWKCzjwZN9
/Z7hApJgnihQ1dQ/TjqJHAj3WxxLch9UbbVsHKWvPTaaPvetpBQm1KirS1YSLJS4
J0Vf5vLGKi1QHY4hckHCmj9ikT68+y1t5xkLvcS75aSH3pUFvwFLlNF7TJ2vRf1+
8pXyrG4Eg6Io6/gIIkTdBdJNBop9G0es8cwkZ4Oqmzx+3TeE12/cM/GhDZObLd9+
EKA1sIP6TeCFMU19SxqGW7wSO4JrrHX9ez+/vcg5YWQJln/YMxKBi4riUSjsnUGU
NSZSxxhqKBdCztBxfI3JmF0OixZYrw==
=Zqsr
-----END PGP SIGNATURE-----

--rrmq4hmepqv7ibgb--
