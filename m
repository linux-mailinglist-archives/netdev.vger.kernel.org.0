Return-Path: <netdev+bounces-2055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4902700209
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:00:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47E86281675
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214328F6E;
	Fri, 12 May 2023 08:00:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C9563D5
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:00:01 +0000 (UTC)
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820AC1BCA;
	Fri, 12 May 2023 00:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683878398; x=1715414398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umOcZNydYWMkIf5mbEUP8/J6HKiH1xlOF3VU6GTvq9Q=;
  b=GoCKd/Z5FyFXbnjWFdXIN8ATYMDTFwIZ+pQXY4LbVs3m5Pto25jAYVpS
   shQDooZeD+mGFUZDFNLQF9SumoJThXHMWhRSYZf2Ep9zsYEcrAE26WcKd
   S6PowUNULF9D6wvhRex4toxAxivzqGMANuo5InAOMug8jcnKt/SCxweko
   6xn2i3l7Y7Mgj3NB0KpQF1ZtnyOZ1TPi7KtSQ8BZMgIN2ltB0/ugYYr3f
   VmczkzUzUr1jRsNiKfeW/qnGcUzkSWzk4Hm/3l52I/9NEzmtAQ5KtgUwr
   AbXYM/P7Ko/lWbF1sdS5dM13qoprPBpJ2xf0CpA6oNhUQ3VNwJ5sBmBGF
   A==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677538800"; 
   d="scan'208";a="30870394"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 12 May 2023 09:59:56 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 12 May 2023 09:59:56 +0200
X-PGP-Universal: processed;
	by tq-pgp-pr1.tq-net.de on Fri, 12 May 2023 09:59:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1683878396; x=1715414396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umOcZNydYWMkIf5mbEUP8/J6HKiH1xlOF3VU6GTvq9Q=;
  b=dj6TTamwow7wlhhjaudDKc/UlUfbtW78wjIKMMDnIMZ4stG7qVfqmkH2
   zgwfHXbXxK5lLI2e92paY6xa+YzT69beReMdf9i/Wqmvoew5XrlTaLG0X
   aAuKXFBCDk7VkR1wpcdJzbJZ9B//Y9ZdrDF1L7+A/BpYW+XJF7Yt06wRZ
   EW8J6ehKESLKzDJaQI5NjfqQVNb03giy/IFUI/0gugBKANjeDkWIRnacD
   rcyf5c4iBI1MWOQNKI+SQPBg1JfPjBIOU6+5qIDydjFdgj//ZR5zODP5Y
   pFVYK8vIXQQRsy9FWA7vqhuQTFu+Pa+HTKSc1UJ8LVCKsHTKtwGbizYJ4
   w==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677538800"; 
   d="scan'208";a="30870393"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 12 May 2023 09:59:56 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id E0C33280056;
	Fri, 12 May 2023 09:59:55 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, Yan Wang <rk.code@outlook.com>
Cc: Yan Wang <rk.code@outlook.com>
Subject: Re: [PATCH v4] net: mdiobus: Add a function to deassert reset
Date: Fri, 12 May 2023 09:59:56 +0200
Message-ID: <1858925.CQOukoFCf9@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
References: <KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
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

Am Donnerstag, 11. Mai 2023, 08:59:09 CEST schrieb Yan Wang:
> It is possible to mount multiple sub-devices on the mido bus.
> The hardware power-on does not necessarily reset these devices.
> The device may be in an uncertain state, causing the device's ID
> to not be scanned.
>=20
> So,before adding a reset to the scan, make sure the device is in

'So, before'. One space after ,

> normal working mode.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Link:
> https://lore.kernel.org/oe-kbuild-all/202305101702.4xW6vT72-lkp@intel.com/
> Signed-off-by: Yan Wang <rk.code@outlook.com>
> ---
> v4:
>   - Get pulse width and settling time from the device tree
>   - Add logic for processing (PTR_ERR(reset) =3D=3D -EPROBE_DEFER)
>   - included <linux/goio/consumer.h>
>   - fixed commit message
> v3:
> https://lore.kernel.org/all/KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR0=
1M
> B5448.apcprd01.prod.exchangelabs.com/ - fixed commit message
> v2:
> https://lore.kernel.org/all/KL1PR01MB54482416A8BE0D80EA27223CE6779@KL1PR0=
1M
> B5448.apcprd01.prod.exchangelabs.com/ - fixed commit message
>   - Using gpiod_ replace gpio_
> v1:
> https://lore.kernel.org/all/KL1PR01MB5448631F2D6F71021602117FE6769@KL1PR0=
1M
> B5448.apcprd01.prod.exchangelabs.com/ - Incorrect description of commit
> message.
>   - The gpio-api too old
> ---
>  drivers/net/mdio/fwnode_mdio.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>=20
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdi=
o.c
> index 1183ef5e203e..9d7df6393059 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -11,6 +11,7 @@
>  #include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/pse-pd/pse.h>
> +#include <linux/gpio/consumer.h>

Please sort alphabetically.
>=20
>  MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
>  MODULE_LICENSE("GPL");
> @@ -57,6 +58,35 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwno=
de)
> return register_mii_timestamper(arg.np, arg.args[0]);
>  }
>=20
> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
> +{
> +	struct gpio_desc *reset;
> +	unsigned int reset_assert_delay;
> +	unsigned int reset_deassert_delay;
> +
> +	reset =3D fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_LOW,=20
NULL);
> +	if (IS_ERR(reset)) {
> +		if (PTR_ERR(reset) =3D=3D -EPROBE_DEFER)
> +			pr_debug("%pOFn: %s: GPIOs not yet available,=20
retry later\n",
> +				 to_of_node(fwnode), __func__);

You are not dealing with this error at all. pr_debug is (mostly) not even=20
printed in kernel log, despite the code registering the PHY ignoring the=20
deferral completely.

> +		else
> +			pr_err("%pOFn: %s: Can't get reset line=20
property\n",
> +			       to_of_node(fwnode), __func__);
> +

This error also gets ignored.

> +		return;
> +	}
> +	fwnode_property_read_u32(fwnode, "reset-assert-us",
> +				 &reset_assert_delay);
> +	fwnode_property_read_u32(fwnode, "reset-deassert-us",
> +				 &reset_deassert_delay);

These are currently read in fwnode_mdiobus_phy_device_register(). There is =
no=20
need to read them twice. It should be moved to a location where it just nee=
d=20
to be read once.

Regards,
Alexander

> +	gpiod_set_value_cansleep(reset, 1);
> +	fsleep(reset_assert_delay);
> +	gpiod_set_value_cansleep(reset, 0);
> +	fsleep(reset_deassert_delay);
> +	/*Release phy's reset line, mdiobus_register_gpiod() need to request=20
it*/
> +	gpiod_put(reset);
> +}
> +
>  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  				       struct phy_device *phy,
>  				       struct fwnode_handle *child,=20
u32 addr)
> @@ -119,6 +149,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
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



