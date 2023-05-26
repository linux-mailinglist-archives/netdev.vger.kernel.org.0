Return-Path: <netdev+bounces-5770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE299712B46
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:59:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 987F3281933
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CC228C02;
	Fri, 26 May 2023 16:59:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0A271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:59:46 +0000 (UTC)
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895FFA3;
	Fri, 26 May 2023 09:59:43 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685120381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZ4try5mxxCJlBunlZdGkrN9b4onog+w6GD5OBfPZ7k=;
	b=P9YxnulzHQAoElHA1eGhvpXma1e61ONUekwqIi37lQ4rGilzyW0Ixv3nmGR3cuA1955htB
	CleYfzQ+DVF8Kzp33TFBmiQPmPRAd0WCU4SNRsR/xrGoNDQiTWJMI9OTzutuUy7lhENix2
	aUxmIn/Qz0p0VtcWwS6rkG7k7gyZWyaeQUVmgKjrZ5UDwXUgqvxKfznXhWSFgFdZ61ipL7
	7zQAf83MjminoiClr/xlj7CsqqbZKVtrsfqvXvbBzWWzScxdBTE/yQ9S+yEChojsQEYV/Y
	P8zx/MXsfmbcMHX76y4VdfW15Z5d02mV7fvffMh4/HREhwzr8w1SEpOZpmFU7w==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 840FC1BF208;
	Fri, 26 May 2023 16:59:37 +0000 (UTC)
Date: Fri, 26 May 2023 18:59:36 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com, Andrew Lunn
 <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Florian Fainelli
 <f.fainelli@gmail.com>, Heiner Kallweit <hkallweit1@gmail.com>, Russell
 King <linux@armlinux.org.uk>, Ioana Ciornei <ioana.ciornei@nxp.com>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, Alexandre
 Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 1/4] net: mdio: Introduce a regmap-based
 mdio driver
Message-ID: <20230526185936.0a95b9e9@pc-7.home>
In-Reply-To: <20230526102139.dwttilkquihvp7bs@skbuf>
References: <20230526074252.480200-1-maxime.chevallier@bootlin.com>
	<20230526074252.480200-2-maxime.chevallier@bootlin.com>
	<20230526102139.dwttilkquihvp7bs@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Vlad,

On Fri, 26 May 2023 13:21:39 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> >  M:	William Breathitt Gray <william.gray@linaro.org>
> >  L:	linux-iio@vger.kernel.org
> > diff --git a/drivers/net/ethernet/altera/Kconfig
> > b/drivers/net/ethernet/altera/Kconfig index
> > dd7fd41ccde5..0a7c0a217536 100644 ---
> > a/drivers/net/ethernet/altera/Kconfig +++
> > b/drivers/net/ethernet/altera/Kconfig @@ -5,6 +5,8 @@ config
> > ALTERA_TSE select PHYLIB
> >  	select PHYLINK
> >  	select PCS_ALTERA_TSE
> > +	select MDIO_REGMAP
> > +	depends on REGMAP  
> 
> I don't think this bit belongs in this patch.
> Also: depends on REGMAP or select REGMAP?

Ugh sorry about that... I'll address both the dependency and the wrong
patch splitting in next revision.

> >  	help
> >  	  This driver supports the Altera Triple-Speed (TSE)
> > Ethernet MAC. 
> > diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> > index 9ff2e6f22f3f..aef39c89cf44 100644
> > --- a/drivers/net/mdio/Kconfig
> > +++ b/drivers/net/mdio/Kconfig
> > @@ -185,6 +185,16 @@ config MDIO_IPQ8064
> >  	  This driver supports the MDIO interface found in the
> > network interface units of the IPQ8064 SoC
> >  
> > +config MDIO_REGMAP
> > +	tristate
> > +	help
> > +	  This driver allows using MDIO devices that are not
> > sitting on a
> > +	  regular MDIO bus, but still exposes the standard 802.3
> > register
> > +	  layout. It's regmap-based so that it can be used on
> > integrated,
> > +	  memory-mapped PHYs, SPI PHYs and so on. A new virtual
> > MDIO bus is
> > +	  created, and its read/write operations are mapped to the
> > underlying
> > +	  regmap.  
> 
> It would probably be helpful to state that those who select this
> option should also explicitly select REGMAP.

You're right, I'll update this

> > +
> >  config MDIO_THUNDER
> >  	tristate "ThunderX SOCs MDIO buses"
> >  	depends on 64BIT
> > diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> > index 7d4cb4c11e4e..1015f0db4531 100644
> > --- a/drivers/net/mdio/Makefile
> > +++ b/drivers/net/mdio/Makefile
> > @@ -19,6 +19,7 @@ obj-$(CONFIG_MDIO_MOXART)		+=
> > mdio-moxart.o obj-$(CONFIG_MDIO_MSCC_MIIM)		+=
> > mdio-mscc-miim.o obj-$(CONFIG_MDIO_MVUSB)		+=
> > mdio-mvusb.o obj-$(CONFIG_MDIO_OCTEON)		+=
> > mdio-octeon.o +obj-$(CONFIG_MDIO_REGMAP)		+=
> > mdio-regmap.o obj-$(CONFIG_MDIO_SUN4I)		+=
> > mdio-sun4i.o obj-$(CONFIG_MDIO_THUNDER)		+=
> > mdio-thunder.o obj-$(CONFIG_MDIO_XGENE)		+=
> > mdio-xgene.o diff --git a/include/linux/mdio/mdio-regmap.h
> > b/include/linux/mdio/mdio-regmap.h new file mode 100644
> > index 000000000000..b8508f152552
> > --- /dev/null
> > +++ b/include/linux/mdio/mdio-regmap.h
> > @@ -0,0 +1,24 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal
> > PHYs or PCS
> > + * within the MMIO-mapped area
> > + *
> > + * Copyright (C) 2023 Maxime Chevallier
> > <maxime.chevallier@bootlin.com>
> > + */
> > +#ifndef MDIO_REGMAP_H
> > +#define MDIO_REGMAP_H
> > +
> > +struct device;
> > +struct regmap;
> > +
> > +struct mdio_regmap_config {
> > +	struct device *parent;
> > +	struct regmap *regmap;
> > +	char name[MII_BUS_ID_SIZE];  
> 
> don't we need a header included for the MII_BUS_ID_SIZE macro?
> An empty C file which includes just <linux/mdio/mdio-regmap.h> must
> build without errors.

You're correct, I'll include the proper header.

Thanks,

Maxime

