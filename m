Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026EC637C00
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKXOyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKXOyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:54:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43F22EF29
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:54:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyDcB-00049Y-5E; Thu, 24 Nov 2022 15:54:11 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9A1041286A3;
        Thu, 24 Nov 2022 14:54:07 +0000 (UTC)
Date:   Thu, 24 Nov 2022 15:54:05 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
Subject: Re: RE: [PATCH v3 1/2] can: m_can: Move mram init to mcan device
 setup
Message-ID: <20221124145405.d67cb6xmoiqfdsq3@pengutronix.de>
References: <20221122105455.39294-1-vivek.2311@samsung.com>
 <CGME20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b@epcas5p3.samsung.com>
 <20221122105455.39294-2-vivek.2311@samsung.com>
 <20221123224146.iic52cuhhnwqk2te@pengutronix.de>
 <01a101d8ffe4$1797f290$46c7d7b0$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7molxfrf5k54fpwk"
Content-Disposition: inline
In-Reply-To: <01a101d8ffe4$1797f290$46c7d7b0$@samsung.com>
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


--7molxfrf5k54fpwk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.11.2022 14:36:48, Vivek Yadav wrote:
> > Why not call the RAM init directly from m_can_chip_config()?
> >=20
> m_can_chip_config function is called from m_can open.
>=20
> Configuring RAM init every time we open the CAN instance is not
> needed, I think only once during the probe is enough.

That probably depends on you power management. If I add a regulator to
power the external tcan4x5x chip and power it up during open(), I need
to initialize the RAM.

> If message RAM init failed then fifo Transmit and receive will fail
> and there will be no communication. So there is no point to "open and
> Configure CAN chip".

For mmio devices the RAM init will probably not fail. There are return
values and error checking for the SPI attached devices. Where the SPI
communication will fail. However if this is problem, I assume the chip
will not be detected in the first place.

> From my understanding it's better to keep RAM init inside the probe
> and if there is a failure happened goes to CAN probe failure.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7molxfrf5k54fpwk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/hYsACgkQrX5LkNig
01087Qf9Gx/Nk41SCCj7+rrggRE7qKHXE5G+Qk02d7IXfzxLbUmsgUk5dsi29H/Z
P7czNTvipDDshilhlAfYDGZKD01XfogCP2DAwVIBE0kCxRAfpBpC1xmEhGSG7mtV
SHlKTj8cHNQ7J+IFmzCUq9R3ywgRyrX+PYgwg9danzR1dv049+kP/ptoTSUBOjqk
OWbU4BsTtl/iIs/3pOxfoq9NMEXnS44zAHgJlkA10LGESj7wCfTMX2oG2V/10C+J
/odw2rODOYOdcE30Lk5xEKvbbiHwIpMwQ2+8LSBckoqYhklPuC8H9oGrE0sIkCz8
T4zcFCce6yQGR1tpOZ2JxMXb0qDsTQ==
=rGjh
-----END PGP SIGNATURE-----

--7molxfrf5k54fpwk--
