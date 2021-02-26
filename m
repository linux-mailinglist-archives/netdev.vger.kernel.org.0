Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE52325F5C
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 09:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhBZIpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 03:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBZIpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 03:45:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C2EC061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 00:44:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lFYjD-0000l9-5J; Fri, 26 Feb 2021 09:44:03 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:adc1:3ee1:6274:c5d0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B0C4A5E9945;
        Fri, 26 Feb 2021 08:43:59 +0000 (UTC)
Date:   Fri, 26 Feb 2021 09:43:59 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/6] can: c_can: add support to 64 message objects
Message-ID: <20210226084359.jnlq6ccbeuib6zis@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-7-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z4je5v2dzmisaw5k"
Content-Disposition: inline
In-Reply-To: <20210225215155.30509-7-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--z4je5v2dzmisaw5k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.02.2021 22:51:55, Dario Binacchi wrote:
> --- a/drivers/net/can/c_can/c_can.h
> +++ b/drivers/net/can/c_can/c_can.h
> @@ -22,8 +22,6 @@
>  #ifndef C_CAN_H
>  #define C_CAN_H
> =20
> -#define C_CAN_NO_OF_OBJECTS	32
> -
>  enum reg {
>  	C_CAN_CTRL_REG =3D 0,
>  	C_CAN_CTRL_EX_REG,
> @@ -61,6 +59,7 @@ enum reg {
>  	C_CAN_NEWDAT2_REG,
>  	C_CAN_INTPND1_REG,
>  	C_CAN_INTPND2_REG,
> +	C_CAN_INTPND3_REG,
>  	C_CAN_MSGVAL1_REG,
>  	C_CAN_MSGVAL2_REG,
>  	C_CAN_FUNCTION_REG,
> @@ -122,6 +121,7 @@ static const u16 __maybe_unused reg_map_d_can[] =3D {
>  	[C_CAN_NEWDAT2_REG]	=3D 0x9E,
>  	[C_CAN_INTPND1_REG]	=3D 0xB0,
>  	[C_CAN_INTPND2_REG]	=3D 0xB2,
> +	[C_CAN_INTPND3_REG]	=3D 0xB4,
>  	[C_CAN_MSGVAL1_REG]	=3D 0xC4,
>  	[C_CAN_MSGVAL2_REG]	=3D 0xC6,
>  	[C_CAN_IF1_COMREQ_REG]	=3D 0x100,
> @@ -161,6 +161,7 @@ struct raminit_bits {
> =20
>  struct c_can_driver_data {
>  	enum c_can_dev_id id;
> +	int msg_obj_num;

unsigned int

> =20
>  	/* RAMINIT register description. Optional. */
>  	const struct raminit_bits *raminit_bits; /* Array of START/DONE bit pos=
itions */
> diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_=
can_pci.c
> index 3752f68d095e..2cb98ccd04d7 100644
> --- a/drivers/net/can/c_can/c_can_pci.c
> +++ b/drivers/net/can/c_can/c_can_pci.c
> @@ -31,6 +31,8 @@ enum c_can_pci_reg_align {
>  struct c_can_pci_data {
>  	/* Specify if is C_CAN or D_CAN */
>  	enum c_can_dev_id type;
> +	/* Number of message objects */
> +	int msg_obj_num;

unsigned int


Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--z4je5v2dzmisaw5k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA4tMwACgkQqclaivrt
76nrpQf/ZUDVh6uLkvCAhuPWsFDZMmKecK6Gf1z2SxqXpfV0K/F4mdh8jO9eEUhP
1nbmdvwKwoDSOLJu19hfc20DVpcC1+o5mh+NwtLLCkWma0WKaeXe2K9/errZe3Vb
9CXgaETQrRZSHTRi8gPcLfQMehRCYWiMLJ2yurv9zBBIfmOaKi81b+R6ciECWs1I
MNwDhqXX+n18GmqgLKYLRuc1qDsUdGNCGmPzCA2kLtjSXb0EJDxe12DfpDJ+jWiO
L4kSaRP6NkCWYPagCfuBl9nnokuJr3d+yK2qqTTO9b7KIiRqUbyhCx480E4fNcyp
nkXZ2RhOsWQMafwc3ruxrDF2r92ETg==
=6yrX
-----END PGP SIGNATURE-----

--z4je5v2dzmisaw5k--
