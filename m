Return-Path: <netdev+bounces-3829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F5B709047
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FDEC1C2121F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDB87F9;
	Fri, 19 May 2023 07:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496A57F3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:17:15 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4A8E58
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 00:17:13 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzuM3-0007xp-KD; Fri, 19 May 2023 09:16:47 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 942241C837F;
	Fri, 19 May 2023 07:16:43 +0000 (UTC)
Date: Fri, 19 May 2023 09:16:43 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, Tero Kristo <kristo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Conor Dooley <conor+dt@kernel.org>
Subject: Re: [PATCH v6 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230519-morbidity-directory-dbe704584aa3-mkl@pengutronix.de>
References: <20230518193613.15185-1-jm@ti.com>
 <20230518193613.15185-3-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iuo7eibl3agbzuu3"
Content-Disposition: inline
In-Reply-To: <20230518193613.15185-3-jm@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--iuo7eibl3agbzuu3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.05.2023 14:36:13, Judith Mendez wrote:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found and
> poll-interval property is defined in device tree M_CAN node.
>=20
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>

[...]

> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_c=
an/m_can_platform.c
> index 94dc82644113..3e60cebd9d12 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -5,6 +5,7 @@
>  //
>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.=
com/
> =20
> +#include <linux/hrtimer.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> =20
> @@ -96,12 +97,40 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
>  		goto probe_fail;
> =20
>  	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
> -	irq =3D platform_get_irq_byname(pdev, "int0");
> -	if (IS_ERR(addr) || irq < 0) {
> -		ret =3D -EINVAL;
> +	if (IS_ERR(addr)) {
> +		ret =3D PTR_ERR(addr);
>  		goto probe_fail;
>  	}
> =20

As we don't use an explicit "poll-interval" anymore, this needs some
cleanup. The flow should be (pseudo code, error handling omitted):

if (device_property_present("interrupts") {
        platform_get_irq_byname();
        polling =3D false;
} else {
        hrtimer_init();
        polling =3D true;
}

> +	irq =3D platform_get_irq_byname_optional(pdev, "int0");

Remove the "_optional" and....

> +	if (irq =3D=3D -EPROBE_DEFER) {
> +		ret =3D -EPROBE_DEFER;
> +		goto probe_fail;
> +	}
> +
> +	if (device_property_present(mcan_class->dev, "interrupts") ||
> +	    device_property_present(mcan_class->dev, "interrupt-names"))
> +		mcan_class->polling =3D false;

=2E..move the platform_get_irq_byname() here

> +	else
> +		mcan_class->polling =3D true;
> +
> +	if (!mcan_class->polling && irq < 0) {
> +		ret =3D -ENXIO;
> +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found, polling not a=
ctivated\n");
> +		goto probe_fail;
> +	}

Remove this check.

> +
> +	if (mcan_class->polling) {
> +		if (irq > 0) {
> +			mcan_class->polling =3D false;
> +			dev_info(mcan_class->dev, "Polling enabled, using hardware IRQ\n");

Remove this.

> +		} else {
> +			dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
> +			hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
> +				     HRTIMER_MODE_REL_PINNED);

move this backwards, where you set "polling =3D true"

> +		}
> +	}
> +
>  	/* message ram could be shared */
>  	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram=
");
>  	if (!res) {
> --=20
> 2.17.1

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--iuo7eibl3agbzuu3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRnIlgACgkQvlAcSiqK
BOgXywf/RpAXV/U1zHDPBijDrYbooi5qG+9apga4pa83AeVAmCSFEvc4HdppRD9a
44eyG2UYRZER6Yotk3qLMev4Pawss2VbjbxAgxUvb7cTqkxEw7EppC8updsbneww
4NsVsG0IJ+6J68R73+FZ0ero9kcKXbHWvqTz/xEWFfEGll+S89W5lRpybDzDUoa4
f0ggPvpHbvKMSQWRwTh3EtTY59Ym9QYaQ/ZdEGKG1W/yPN4McVLFUwrcoi3xI/oV
V9Qf5kf36sZ3z32MqMCtQaqKLaCiuL3LVsx98rkDH/k0Wb8JjSCt/3Y7KtU1tg5g
NyKk4mhSR+pxCNUwBVWiGGhc4Asgsw==
=W8BC
-----END PGP SIGNATURE-----

--iuo7eibl3agbzuu3--

