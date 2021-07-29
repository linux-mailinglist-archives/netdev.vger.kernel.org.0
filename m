Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493D93D9E2E
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhG2HQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbhG2HQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:16:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2CEC061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:16:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m90Hl-0007wL-18; Thu, 29 Jul 2021 09:16:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:f664:c769:c9a5:5ced])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B01CA65AB97;
        Thu, 29 Jul 2021 07:16:51 +0000 (UTC)
Date:   Thu, 29 Jul 2021 09:16:50 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Message-ID: <20210729071650.77e274e4zobv5uwo@pengutronix.de>
References: <20210728203647.15240-1-Stefan.Maetje@esd.eu>
 <20210728203647.15240-2-Stefan.Maetje@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2ylmwzleifore2fq"
Content-Disposition: inline
In-Reply-To: <20210728203647.15240-2-Stefan.Maetje@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2ylmwzleifore2fq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.07.2021 22:36:47, Stefan M=C3=A4tje wrote:
> This patch adds support for the PCI based PCIe/402 CAN interface family
> from esd GmbH that is available with various form factors
> (https://esd.eu/en/products/402-series-can-interfaces).
>=20
> All boards utilize a FPGA based CAN controller solution developed
> by esd (esdACC). For more information on the esdACC see
> https://esd.eu/en/products/esdacc.

Thanks for the patch!

> This driver detects all available CAN interface boards but atm.
> operates the CAN-FD capable devices in Classic-CAN mode only!

Are you planing to change this?

> Signed-off-by: Stefan M=C3=A4tje <Stefan.Maetje@esd.eu>

For now just some nitpicks:

Compilation throws this error message on 32 bit ARM:

| drivers/net/can/esd/esd402_pci.c: In function =E2=80=98pci402_init_dma=E2=
=80=99:                                                                    =
                                                                           =
              =20
| drivers/net/can/esd/esd402_pci.c:304:32: warning: right shift count >=3D =
width of type [-Wshift-count-overflow]                                     =
                                                                           =
=20
|   304 |  iowrite32((u32)(card->dma_hnd >> 32),                           =
                                                                           =
                                                                           =
                                =20
|       |                                ^~                                =
                                                                           =
                                                                           =
                                =20
|   CHECK   /srv/work/frogger/socketcan/linux/drivers/net/can/esd/esd402_pc=
i.c                                                                        =
                                                                           =
                                =20
| drivers/net/can/esd/esd402_pci.c:304:42: warning: shift too big (32) for =
type unsigned int                           =20

[...]

> diff --git a/drivers/net/can/esd/Makefile b/drivers/net/can/esd/Makefile
> new file mode 100644
> index 000000000000..a960e8b97c6f
> --- /dev/null
> +++ b/drivers/net/can/esd/Makefile
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +#  Makefile for esd gmbh ESDACC controller driver
> +#
> +esd_402_pci-y :=3D esdacc.o esd402_pci.o
> +
> +ifeq ($(CONFIG_CAN_ESD_402_PCI),)
> +obj-m +=3D esd_402_pci.o
> +else
> +obj-$(CONFIG_CAN_ESD_402_PCI) +=3D esd_402_pci.o
> +endif

Why do you build the driver, if it has not been enabled?

The straight forward way to build the driver would be:

| obj-$(CONFIG_CAN_ESD_402_PCI) +=3D esd_402_pci.o
|
| esd_402_pci-objs :=3D esdacc.o esd402_pci.o

You can rename the esd_402_pci.c to esd_402_pci-core.c to avoid
inconsistent naming, (C file is called esd402_pci.c, while the driver
module is esd_402_pci.ko)

Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2ylmwzleifore2fq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmECVeAACgkQqclaivrt
76kh8Af6AgwRrntMx4RiKY+Uc0u3wZD3/KJ5yU31cvFo/8ATetQ9u0I15xmmCY4u
7Vyiln0kvsdJ4tcEIu7ofC6iCApH1tC/XXWsqLUf26Hbb36TBCXeB+bQWX3Nrz2f
dMhbU/8G3oLHGCcU69h5Q0pFbG0Xp9PqkWktKsBjB4nNwP0HFrHEDI42Pd9hfYVP
+QWV2G/6aaHM8O3o2oXtJCD/+ysCY9Spt419n6ysg3iU7SA6o7Hv0HY39CtGQ/Ra
riMXwFaui/2hQ+7HWv5MK6REMnNMkkyNsH4Dzz6+sLgW2yQc9JCzk4eaPGxPxMdp
yiLAa2li7S6OzNPsYT27LHC/VHh1Sw==
=qGLC
-----END PGP SIGNATURE-----

--2ylmwzleifore2fq--
