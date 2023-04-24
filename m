Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11326ED603
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 22:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjDXUPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 16:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDXUP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 16:15:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5BC5FDC
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 13:15:28 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pr2aS-00019X-Ix; Mon, 24 Apr 2023 22:15:00 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AF43F1B662C;
        Mon, 24 Apr 2023 20:14:54 +0000 (UTC)
Date:   Mon, 24 Apr 2023 22:14:53 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 1/4] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230424-canon-primal-ece722b184d4-mkl@pengutronix.de>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-2-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gzyhhear7eocopqn"
Content-Disposition: inline
In-Reply-To: <20230424195402.516-2-jm@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--gzyhhear7eocopqn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.04.2023 14:53:59, Judith Mendez wrote:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found and
> poll-interval property is defined in device tree M_CAN node.
>=20
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
>=20
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
> Changelog:
> v2:
> 	1. Add poll-interval to MCAN class device to check if poll-interval prop=
ery is
> 	present in MCAN node, this enables timer polling method.
> 	2. Add 'polling' flag to MCAN class device to check if a device is using=
 timer
> 	polling method
> 	3. Check if both timer polling and hardware interrupt are enabled for a =
MCAN
> 	device, default to hardware interrupt mode if both are enabled.
> 	4. Changed ms_to_ktime() to ns_to_ktime()
> 	5. Removed newlines, tabs, and restructure if/else section.
>=20
>  drivers/net/can/m_can/m_can.c          | 30 ++++++++++++++++++++-----
>  drivers/net/can/m_can/m_can.h          |  5 +++++
>  drivers/net/can/m_can/m_can_platform.c | 31 ++++++++++++++++++++++++--
>  3 files changed, 59 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index a5003435802b..33e094f88da1 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -23,6 +23,7 @@
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/hrtimer.h>

keep the list of includes sorted

> =20
>  #include "m_can.h"
> =20
> @@ -1587,6 +1588,11 @@ static int m_can_close(struct net_device *dev)
>  	if (!cdev->is_peripheral)
>  		napi_disable(&cdev->napi);
> =20
> +	if (cdev->polling) {
> +		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
> +		hrtimer_cancel(&cdev->hrtimer);
> +	}
> +
>  	m_can_stop(dev);
>  	m_can_clk_stop(cdev);
>  	free_irq(dev->irq, dev);
> @@ -1793,6 +1799,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff=
 *skb,
>  	return NETDEV_TX_OK;
>  }
> =20
> +enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
> +{
> +	struct m_can_classdev *cdev =3D
> +		container_of(timer, struct m_can_classdev, hrtimer);
> +
> +	m_can_isr(0, cdev->net);
> +
> +	hrtimer_forward_now(timer, ms_to_ktime(1));

Please create a define for this

> +
> +	return HRTIMER_RESTART;
> +}
> +
>  static int m_can_open(struct net_device *dev)
>  {
>  	struct m_can_classdev *cdev =3D netdev_priv(dev);
> @@ -1827,13 +1845,15 @@ static int m_can_open(struct net_device *dev)
>  		}
> =20
>  		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
> -
>  		err =3D request_threaded_irq(dev->irq, NULL, m_can_isr,
> -					   IRQF_ONESHOT,
> -					   dev->name, dev);
> -	} else {
> -		err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
> +					   IRQF_ONESHOT, dev->name, dev);
> +	} else if (!cdev->polling) {
> +			err =3D request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
>  				  dev);

No need to change the indention

> +	} else {
> +		dev_dbg(cdev->dev, "Start hrtimer\n");
> +		cdev->hrtimer.function =3D &hrtimer_callback;
> +		hrtimer_start(&cdev->hrtimer, ms_to_ktime(cdev->poll_interval), HRTIME=
R_MODE_REL_PINNED);
>  	}
> =20
>  	if (err < 0) {
> diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> index a839dc71dc9b..1ba87eb23f8e 100644
> --- a/drivers/net/can/m_can/m_can.h
> +++ b/drivers/net/can/m_can/m_can.h
> @@ -28,6 +28,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/hrtimer.h>

keep the list of includes sorted

> =20
>  /* m_can lec values */
>  enum m_can_lec_type {
> @@ -93,6 +94,10 @@ struct m_can_classdev {
>  	int is_peripheral;
> =20
>  	struct mram_cfg mcfg[MRAM_CFG_NUM];
> +
> +	struct hrtimer hrtimer;
> +	u32 poll_interval;
> +	u8 polling;

bool

>  };
> =20
>  struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int =
sizeof_priv);
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_c=
an/m_can_platform.c
> index 9c1dcf838006..e899c04edc01 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -7,6 +7,7 @@
> =20
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
> +#include <linux/hrtimer.h>
> =20
>  #include "m_can.h"
> =20
> @@ -97,11 +98,37 @@ static int m_can_plat_probe(struct platform_device *p=
dev)
> =20
>  	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
>  	irq =3D platform_get_irq_byname(pdev, "int0");

use platform_get_irq_byname_optional(), it doesn't print an error
message.

> -	if (IS_ERR(addr) || irq < 0) {
> -		ret =3D -EINVAL;
> +	if (irq =3D=3D -EPROBE_DEFER) {
> +		ret =3D -EPROBE_DEFER;
>  		goto probe_fail;
>  	}
> =20
> +	if (IS_ERR(addr)) {
> +		ret =3D PTR_ERR(addr);
> +		goto probe_fail;
> +	}

please move the error check for "addr" directly after the "addr =3D "
assignment.

> +
> +	mcan_class->polling =3D 0;

No need to init as "0"

> +	if (device_property_present(mcan_class->dev, "poll-interval")) {
> +		mcan_class->polling =3D 1;
> +	}

No need for the { } here.

> +
> +	if (!mcan_class->polling && irq < 0) {
> +		ret =3D -ENODATA;
-ENXIO
> +		dev_dbg(mcan_class->dev, "Polling not enabled\n");

print a proper error message using dev_err_probe("IRQ %s not found and
polling not activated\n")

> +		goto probe_fail;
> +	}
> +
> +	if (mcan_class->polling && irq > 0) {
> +		mcan_class->polling =3D 0;
> +		dev_dbg(mcan_class->dev, "Polling not enabled, hardware interrupt exis=
ts\n");
> +	}
> +
> +	if (mcan_class->polling && irq < 0) {
> +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_P=
INNED);
> +	}

combine both if (mcan_class->polling) into one.

> +
>  	/* message ram could be shared */
>  	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram=
");
>  	if (!res) {
> --=20
> 2.17.1
>=20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--gzyhhear7eocopqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRG4zoACgkQvlAcSiqK
BOilJQf/VuO4TbAJn3uvF6rlMhtngv3OcHQd3ea4G/HmeGBpR74du9qfRRvQDofD
Q9cmIgxMCC8Iw4UsRbWWgF4044zOOKhO2J9EsCnAEA2qce1n4FwyrBFxVKG6AFCE
9mbdbLDgxaevO6oMZlfj2ztGLPcg7MjAJFxkV6GBxZ250S+fy7felidJ7VbYVD/3
QOTb2lS2oTL++qNgTrN5jasRjwAR3b1W6Pm58CyRcviAZv0sfZ6qqOdm0sFhkuzr
Oya9y76BTSORjyzRVDzsyKk4cD0Mrw58TppNVEH43vY+x/qKUyf6bQRjm1Dsxvkz
ygLUMeJNMrXajkr9F/LLchFYWA2Ryw==
=wS/Z
-----END PGP SIGNATURE-----

--gzyhhear7eocopqn--
