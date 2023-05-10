Return-Path: <netdev+bounces-1462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 741B76FDD3C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 481B72813DD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A659EF9F0;
	Wed, 10 May 2023 11:55:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ADD20B4C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:55:29 +0000 (UTC)
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05146A24A;
	Wed, 10 May 2023 04:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683719718; x=1715255718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kX2SUuVDggIqJv7fR5xblEE13YsFSLn3Q9/AkV/oBQ8=;
  b=DGUol04I49ZKQ4cgXIRLGD9nOVlPqZWVqljDBn4+ogd5sRu26wvSlYIM
   xhEl2MTc+3/HEu5bPvs8CYECZW0T2uekVlwWmLcT+8E+oNOOyiFvaXG4O
   AU5gG3vtPcrl6DAq3tuaq/AzwBrqY2+Fk6cUf8joTk4lsfqh/qOp96ZlT
   R/Quf4eT9nEhIeVCu0U0Lh++VbB2xGWzinU17Jz1rTrQqE68dwiU7e7AJ
   JYkfMD4fOEaxCJ3z+XKzpVB0cyStHrJj76ShP/zXyJ+lQplqR3Cf9Z+Vc
   VYTvNKIPXq0/a3ZNnhPlZC+TwgoCMIQfSAGZwLTZRFwiRGEElYWoJM9zi
   w==;
X-IronPort-AV: E=Sophos;i="5.99,264,1677538800"; 
   d="scan'208";a="30828875"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 10 May 2023 13:55:16 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 10 May 2023 13:55:16 +0200
X-PGP-Universal: processed;
	by tq-pgp-pr1.tq-net.de on Wed, 10 May 2023 13:55:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683719716; x=1715255716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kX2SUuVDggIqJv7fR5xblEE13YsFSLn3Q9/AkV/oBQ8=;
  b=FK7V/ckRDREAd05F+kCKES93Hi+kTRv6RLuP5XV8JHC90U8kcUePl7z+
   fTeu38dbHtu67oS5U2ogrqGzsU6oHqBHxIHCSsyjSt2gUxhtT3zZZ2DrP
   ZcTYLVVQR4+EOkN2+C3NXZwceIQgimG41ms4la/MxqEnRtnTVcEXZFKOn
   b9l38XwLYIThPD9Z8CckKh8/qZnz0Xv6e9rdI6ssQE447yD19Ae3gqPrN
   lIt3L8cHwkuUlzPHhV9l4n1m+q8ypAqc51/sWIFoVFX6ls3hI3Svm/9Sp
   ODh2o2RWU750cVJJig2WJIwmbDZ5sWEfBXKvuD2m7Qu+FC4Z4PLhI71+x
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,264,1677538800"; 
   d="scan'208";a="30828874"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 10 May 2023 13:55:15 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id A2EE7280056;
	Wed, 10 May 2023 13:55:15 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: andrew@lunn.ch, Yan Wang <rk.code@outlook.com>
Cc: Yan Wang <rk.code@outlook.com>, Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: mdiobus: Add a function to deassert reset
Date: Wed, 10 May 2023 13:55:15 +0200
Message-ID: <9107661.CDJkKcVGEf@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <96a1b95e-d05e-40f0-ada9-1956f43010e0@lunn.ch> <KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am Mittwoch, 10. Mai 2023, 10:02:52 CEST schrieb Yan Wang:
> It is possible to mount multiple sub-devices on the mido bus.

mdio bus

> The hardware power-on does not necessarily reset these devices.
> The device may be in an uncertain state, causing the device's ID
> to be scanned.
>=20
> So, before adding a reset to the scan, make sure the device is in
> normal working mode.
>=20
> I found that the subsequent drive registers the reset pin into the
> structure of the sub-device to prevent conflicts, so release the
> reset pin.
>=20
> Signed-off-by: Yan Wang <rk.code@outlook.com>

We had similar cases where the (single) PHY was in reset during Linux boot.
Should you be able to make this work by using a "ethernet-phy-id%4x.%4x"=20
compatible? See also [1]

[1] https://lkml.org/lkml/2020/10/28/1139

> ---
> v2:
>   - fixed commit message
>   - Using gpiod_ replace gpio_
> v1:
> https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR0=
1M
> B5448.apcprd01.prod.exchangelabs.com/ - Incorrect description of commit
> message.
>   - The gpio-api too old
> ---
>  drivers/net/mdio/fwnode_mdio.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdi=
o.c
> index 1183ef5e203e..6695848b8ef2 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -57,6 +57,20 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwno=
de)
> return register_mii_timestamper(arg.np, arg.args[0]);
>  }
>=20
> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
> +{
> +	struct gpio_desc *reset;
> +
> +	reset =3D fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH,=20
NULL);
> +	if (IS_ERR(reset) && PTR_ERR(reset) !=3D -EPROBE_DEFER)

How are you dealing with EPROBE_DEFER if the reset line is e.g. attached to=
 an=20
i2c expander, which is to be probed later on?

> +		return;
> +
> +	usleep_range(100, 200);

How do you know a PHY's reset pulse width?

> +	gpiod_set_value_cansleep(reset, 0);

What about post-reset stabilization times before MDIO access is allowed?

> +	/*Release the reset pin,it needs to be registered with the PHY.*/

/* Release [...] PHY. */

Best regards,
Alexander

> +	gpiod_put(reset);
> +}
> +
>  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  				       struct phy_device *phy,
>  				       struct fwnode_handle *child,=20
u32 addr)
> @@ -119,6 +133,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  	u32 phy_id;
>  	int rc;
>=20
> +	fwnode_mdiobus_pre_enable_phy(child);
> +
>  	psec =3D fwnode_find_pse_control(child);
>  	if (IS_ERR(psec))
>  		return PTR_ERR(psec);


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/



