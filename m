Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2170431673
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhJRKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhJRKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 06:50:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69721C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 03:48:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcQBV-0003Jz-Qd; Mon, 18 Oct 2021 12:48:01 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c2ef-28ab-e0cd-e8fd.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c2ef:28ab:e0cd:e8fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id ED5856965B1;
        Mon, 18 Oct 2021 10:47:59 +0000 (UTC)
Date:   Mon, 18 Oct 2021 12:47:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: xilinx_can: remove redundent netif_napi_del from
 xcan_remove
Message-ID: <20211018104759.t5ib62kqjenjepkv@pengutronix.de>
References: <20211017125022.3100329-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="laxzct2z5txsqxzw"
Content-Disposition: inline
In-Reply-To: <20211017125022.3100329-1-mudongliangabcd@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--laxzct2z5txsqxzw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.10.2021 20:50:21, Dongliang Mu wrote:
> Since netif_napi_del is already done in the free_candev, so we remove
> this redundent netif_napi_del invocation. In addition, this patch can
> match the operations in the xcan_probe and xcan_remove functions.
>=20
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/can/xilinx_can.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 3b883e607d8b..60a3fb369058 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -1848,7 +1848,6 @@ static int xcan_remove(struct platform_device *pdev)
> =20
>  	unregister_candev(ndev);
>  	pm_runtime_disable(&pdev->dev);
> -	netif_napi_del(&priv->napi);
>  	free_candev(ndev);
> =20
>  	return 0;

Fixed the following error:

| drivers/net/can/xilinx_can.c: In function =E2=80=98xcan_remove=E2=80=99:
| drivers/net/can/xilinx_can.c:1847:20: error: unused variable =E2=80=98pri=
v=E2=80=99 [-Werror=3Dunused-variable]
|  1847 |  struct xcan_priv *priv =3D netdev_priv(ndev);
|       |                    ^~~~

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--laxzct2z5txsqxzw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFtUNwACgkQqclaivrt
76lG4Af/egULUDAzVZK2yX285A7T6hDs6mdkip8Z7JDRg+Jdhjix258HzSYS7Qdd
Sxp1DUGn16KE+9HlJn4BQ/5LosSc3RixQxegHKLDa09BmlKD7qSKakSySMinQk6c
M9GoO1wRFH7VcXfou4p3TtdcOkocsk/AxRac12J5cufxzi4yDskRj0+NzW+tP1RJ
8pL7Q8eXZezsD04FEX2PyJHOyn8VDnkfxILcwdtpTIzhwDakYzI0PmSWRekya5jK
gk6lkVWPVdo2ZH6JwsGfNNAx+yi8A/4h1o1KeK7C5D416PLcU+HPWCTNMEoee7bK
uSHXM95bWxiWLJDpB1AqDx8FHrGkLQ==
=sQuT
-----END PGP SIGNATURE-----

--laxzct2z5txsqxzw--
