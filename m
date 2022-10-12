Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E575FC164
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 09:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJLHrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 03:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJLHri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 03:47:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF6CAD992
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 00:47:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oiWSZ-0006ES-5h; Wed, 12 Oct 2022 09:47:23 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B0BFDFB363;
        Wed, 12 Oct 2022 07:47:20 +0000 (UTC)
Date:   Wed, 12 Oct 2022 09:47:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcan: Add support for handling dlec error on CAN FD
 format frame
Message-ID: <20221012074719.mzk44xjuvbyws37d@pengutronix.de>
References: <CGME20221011120147epcas5p45049f7c0428a799c005b6ab77b428128@epcas5p4.samsung.com>
 <20221011113512.13756-1-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aty6nrt5skca5o6c"
Content-Disposition: inline
In-Reply-To: <20221011113512.13756-1-vivek.2311@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aty6nrt5skca5o6c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.10.2022 17:05:12, Vivek Yadav wrote:
> When a frame in CAN FD format has reached the data phase, the next
> CAN event (error or valid frame) will be shown in DLEC.
>=20
> Utilizes the dedicated flag (Data Phase Last Error Code: DLEC flag) to
> determine the type of last error that occurred in the data phase
> of a CAN FD frame and handle the bus errors.
>=20
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

I've just sent patch

| https://lore.kernel.org/all/20221012074205.691384-1-mkl@pengutronix.de

to clean up the LEC error handling a bit. This makes it easier to add
DLEC support.

> ---
>  drivers/net/can/m_can/m_can.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 4709c012b1dc..c070580d35fb 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -156,6 +156,7 @@ enum m_can_reg {
>  #define PSR_EW		BIT(6)
>  #define PSR_EP		BIT(5)
>  #define PSR_LEC_MASK	GENMASK(2, 0)
> +#define PSR_DLEC_SHIFT  8

Please define a PSR_DLEC_MASK and follow the lec handling in my patch.

regards,
Marc

> =20
>  /* Interrupt Register (IR) */
>  #define IR_ALL_INT	0xffffffff
> @@ -870,6 +871,7 @@ static int m_can_handle_bus_errors(struct net_device =
*dev, u32 irqstatus,
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
>  	int work_done =3D 0;
> +	int dpsr =3D 0;
> =20
>  	if (irqstatus & IR_RF0L)
>  		work_done +=3D m_can_handle_lost_msg(dev);
> @@ -884,6 +886,15 @@ static int m_can_handle_bus_errors(struct net_device=
 *dev, u32 irqstatus,
>  	    m_can_is_protocol_err(irqstatus))
>  		work_done +=3D m_can_handle_protocol_error(dev, irqstatus);
> =20
> +	if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {

I think we can skip the check for CAN-FD here.

> +		dpsr  =3D psr >> PSR_DLEC_SHIFT;
> +		if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
> +		    is_lec_err(dpsr)) {
> +			netdev_dbg(dev, "Data phase error detected\n");
> +			work_done +=3D m_can_handle_lec_err(dev, dpsr & LEC_UNUSED);
> +		}
> +	}
> +
>  	/* other unproccessed error interrupts */
>  	m_can_handle_other_err(dev, irqstatus);

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--aty6nrt5skca5o6c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNGcQQACgkQrX5LkNig
0136cAgAjdT9d+ZApUi7zO4Q56htRxIlnSUmxMEoMwyPekiQbJr9PH5YyCbozB+y
41vLHN0qxPgdIjmaLuONm6MHOF+xQeZRP+KI2QPENt+k/Yk6WEnl7AMvfQADeeYl
L9QE2AN8BwxBROR05vEPBGeUDLW4Jx5dYxlIiv1CmddJjfiY6OkwTSJ6acfz8pCR
nzSZGBIgpON/ZUZ2ZR5FwYMV7dFJekfSsCQl+a45v5WyjfKD9MGQ4fwaqPEvgkcW
lGb0JzwAFa44segRjdHZAR1eBgq+/Cc0+2Uzt9lsaEI2MhPV4E9znnWQgXhTiST3
sVu0qPQshPdFrn46CIYS4Gy1TQQacQ==
=iMwA
-----END PGP SIGNATURE-----

--aty6nrt5skca5o6c--
