Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458A753D681
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 13:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiFDLWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 07:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiFDLWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 07:22:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05797248E5
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 04:22:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxRrS-0000ia-PZ; Sat, 04 Jun 2022 13:22:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A90578C2DA;
        Sat,  4 Jun 2022 11:22:28 +0000 (UTC)
Date:   Sat, 4 Jun 2022 13:22:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220604112227.nlyxulkxelgofruz@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pvg7tyzpzddgwkey"
Content-Disposition: inline
In-Reply-To: <20220603102848.17907-5-mailhol.vincent@wanadoo.fr>
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


--pvg7tyzpzddgwkey
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.06.2022 19:28:45, Vincent Mailhol wrote:
> Only a few drivers rely on the CAN rx offload framework (as of the
> writing of this patch, only three: flexcan, ti_hecc and
> mcp251xfd). Give the option to the user to deselect this features
> during compilation.
>=20
> The drivers relying on CAN rx offload are in different sub
> folders. All of these drivers get tagged with "select CAN_RX_OFFLOAD"
> so that the option is automatically enabled whenever one of those
> driver is chosen.
>=20
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/can/Kconfig               | 16 ++++++++++++++++
>  drivers/net/can/dev/Makefile          |  2 ++
>  drivers/net/can/spi/mcp251xfd/Kconfig |  1 +
>  3 files changed, 19 insertions(+)
>=20
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index 8f3b97aea638..1f1d81da1c8c 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -102,6 +102,20 @@ config CAN_CALC_BITTIMING
> =20
>  	  If unsure, say Y.
> =20
> +config CAN_RX_OFFLOAD
> +	bool "CAN RX offload"
> +	default y
> +	help
> +	  Framework to offload the controller's RX FIFO during one
> +	  interrupt. The CAN frames of the FIFO are read and put into a skb
> +	  queue during that interrupt and transmitted afterwards in a NAPI
> +	  context.
> +
> +	  The additional features selected by this option will be added to the
> +	  can-dev module.
> +
> +	  If unsure, say Y.
> +
>  config CAN_AT91
>  	tristate "Atmel AT91 onchip CAN controller"
>  	depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
> @@ -113,6 +127,7 @@ config CAN_FLEXCAN
>  	tristate "Support for Freescale FLEXCAN based chips"
>  	depends on OF || COLDFIRE || COMPILE_TEST
>  	depends on HAS_IOMEM
> +	select CAN_RX_OFFLOAD
>  	help
>  	  Say Y here if you want to support for Freescale FlexCAN.
> =20
> @@ -162,6 +177,7 @@ config CAN_SUN4I
>  config CAN_TI_HECC
>  	depends on ARM
>  	tristate "TI High End CAN Controller"
> +	select CAN_RX_OFFLOAD
>  	help
>  	  Driver for TI HECC (High End CAN Controller) module found on many
>  	  TI devices. The device specifications are available from www.ti.com
> diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
> index b8a55b1d90cd..5081d8a3be57 100644
> --- a/drivers/net/can/dev/Makefile
> +++ b/drivers/net/can/dev/Makefile
> @@ -11,3 +11,5 @@ can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
>  can-dev-$(CONFIG_CAN_NETLINK) +=3D rx-offload.o
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Do you want to remove this?

> =20
>  can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
> +
> +can-dev-$(CONFIG_CAN_RX_OFFLOAD) +=3D rx-offload.o
> diff --git a/drivers/net/can/spi/mcp251xfd/Kconfig b/drivers/net/can/spi/=
mcp251xfd/Kconfig
> index dd0fc0a54be1..877e4356010d 100644
> --- a/drivers/net/can/spi/mcp251xfd/Kconfig
> +++ b/drivers/net/can/spi/mcp251xfd/Kconfig
> @@ -2,6 +2,7 @@
> =20
>  config CAN_MCP251XFD
>  	tristate "Microchip MCP251xFD SPI CAN controllers"
> +	select CAN_RX_OFFLOAD
>  	select REGMAP
>  	select WANT_DEV_COREDUMP
>  	help

I remember I've given you a list of drivers needing RX offload, I
probably missed the m_can driver. Feel free to squash this patch:

--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -8,7 +8,6 @@ can-dev-$(CONFIG_CAN_NETLINK) +=3D bittiming.o
 can-dev-$(CONFIG_CAN_NETLINK) +=3D dev.o
 can-dev-$(CONFIG_CAN_NETLINK) +=3D length.o
 can-dev-$(CONFIG_CAN_NETLINK) +=3D netlink.o
-can-dev-$(CONFIG_CAN_NETLINK) +=3D rx-offload.o
=20
 can-dev-$(CONFIG_CAN_CALC_BITTIMING) +=3D calc_bittiming.o
=20
diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index 45ad1b3f0cd0..fc2afab36279 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig CAN_M_CAN
        tristate "Bosch M_CAN support"
+       select CAN_RX_OFFLOAD
        help
          Say Y here if you want support for Bosch M_CAN controller framewo=
rk.
          This is common support for devices that embed the Bosch M_CAN IP.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pvg7tyzpzddgwkey
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbQHEACgkQrX5LkNig
012c2gf8C/gNJNvEuZbs7n7LevMALo31wcnilUdo6W7cXTyfc0/pOg+WACXex3at
y+CDvjWkkMGbNL1sHsKdOrXN9iFY97yCvlFCNBuiHXkmsz9RXDY+G+d/FRuZ2ZUA
gpM2u6S6Z0PjGt78k/hVqoiAgCX/HqTbqCN9A9/kn+vrIh8KDps26Bl+U8Q4FeXH
OfRMPGgCtAJZo/9o1Lt502XuYcVXytdI1uFvhfXvH1BCFAVR+eUY0lXDrjULfw96
0Kxj2M+PUveANkVw0WaZa+xSbi4vbfd21bxbvvfZk13cyX9WeuVAMUf9XmeCMqMA
VR47UVj1A+pGip+ZZO/6eQ0CxrkqIQ==
=en9U
-----END PGP SIGNATURE-----

--pvg7tyzpzddgwkey--
