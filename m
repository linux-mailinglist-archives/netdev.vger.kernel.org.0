Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5634A3F40
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiAaJ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiAaJ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:29:39 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A419AC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 01:29:38 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id d138-20020a1c1d90000000b0034e043aaac7so10579202wmd.5
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 01:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+K6CVITrnsRUky+BLWhSxF5egzLJ88cWLKIMCc6XEbQ=;
        b=loqmf1qlcbSW+eis/GTE7x15gBHA728qXoxkIgL8gUHEnvZSJ9td6+gyLUdgEXlAbb
         Dq1OPDsv78flVFaRHc6xEORePa+qtlfom/UPARjImwMHnnku2qwK31AaFZ42BrRe2VOW
         BmgqOhNd+hpoqeRH7I0OEToNl5H3HDsjMePYwvCU6SB3RNFAEFrWL6UlnouS70Ikd9zu
         V+5W4wkck2O0VZqUNVLDmswtoYLO12vOkO/KsAPYWgdg8w+V8fDrjeaROS781CXg9K1E
         yxHt0GOJVeVBGaFKHQe2B9+YLV21veluJdNG283Or2kb1JDlvmJ+zQ/SK8LA3SSZZ1MU
         KUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+K6CVITrnsRUky+BLWhSxF5egzLJ88cWLKIMCc6XEbQ=;
        b=kIhHsHeFY2ot6hG8QYJl0siMsD3/Y4tP7a+E/Jk2YJOJx2VK4LiA3eywQTv5rd2+4k
         hA+lFetzTWGoKNGdlcuiWgHSCbwsnklvMn1YKbdSgReKphOiZhlQKryJYe28Wt0N1LAm
         3dwy+GK9VWDjyc5onj44fxvjZMtO420FLnNT55aJY5k9NYKDucLw/CASvk3DgD8VnsGq
         iM8+ymUwlebJahnqqn26YuQ/1z9krRuhDWnqvfjUL+p4zDRHuwJ6/17dFO9xIuPs3oJG
         4Vw0QYd59vzz4qZO3Yv0tFRvwgFawVP15ywaIAyBTz2W4eqNIkDHSBfid2KSb6sbz1KB
         w9OQ==
X-Gm-Message-State: AOAM530/ZsTXNRuOFVONES+fVLA6Y6CnjC+mhj8LMjFlsLnkQFnfgkiB
        zR6PJCKp7ZjW2jq5BSh/oAc3qQ==
X-Google-Smtp-Source: ABdhPJyEsZVSsVBdRUL6qYAq3IIxILI7cX6VjnOLwoIO4iTz4HDgV0oyZ60c2oxQoYjiDUEXhLLgcA==
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr17274997wmq.53.1643621376995;
        Mon, 31 Jan 2022 01:29:36 -0800 (PST)
Received: from google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id s17sm11188184wrm.62.2022.01.31.01.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 01:29:36 -0800 (PST)
Date:   Mon, 31 Jan 2022 09:29:34 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        katie.morris@in-advantage.com
Subject: Re: [RFC v6 net-next 6/9] mfd: ocelot: add support for external mfd
 control over SPI for the VSC7512
Message-ID: <Yfer/qJmwRdShv4y@google.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220129220221.2823127-7-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Jan 2022, Colin Foster wrote:

> Create a single SPI MFD ocelot device that manages the SPI bus on the
> external chip and can handle requests for regmaps. This should allow any
> ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
> utilize regmaps.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/Kconfig                       |  19 ++
>  drivers/mfd/Makefile                      |   3 +
>  drivers/mfd/ocelot-core.c                 | 165 +++++++++++
>  drivers/mfd/ocelot-spi.c                  | 325 ++++++++++++++++++++++
>  drivers/mfd/ocelot.h                      |  36 +++

>  drivers/net/mdio/mdio-mscc-miim.c         |  21 +-
>  drivers/pinctrl/pinctrl-microchip-sgpio.c |  22 +-
>  drivers/pinctrl/pinctrl-ocelot.c          |  29 +-
>  include/soc/mscc/ocelot.h                 |  11 +

Please avoid mixing subsystems in patches if at all avoidable.

If there are not build time dependencies/breakages, I'd suggest
firstly applying support for this into MFD *then* utilising that
support in subsequent patches.

>  9 files changed, 614 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-spi.c
>  create mode 100644 drivers/mfd/ocelot.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ba0b3eb131f1..57bbf2d11324 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -948,6 +948,25 @@ config MFD_MENF21BMC
>  	  This driver can also be built as a module. If so the module
>  	  will be called menf21bmc.
>  
> +config MFD_OCELOT
> +	tristate "Microsemi Ocelot External Control Support"

Please explain exactly what an ECS is in the help below.

> +	select MFD_CORE
> +	help
> +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +	  VSC7513, VSC7514) controlled externally.
> +
> +	  All four of these chips can be controlled internally (MMIO) or
> +	  externally via SPI, I2C, PCIe. This enables control of these chips
> +	  over one or more of these buses.
> +
> +config MFD_OCELOT_SPI
> +	tristate "Microsemi Ocelot SPI interface"
> +	depends on MFD_OCELOT
> +	depends on SPI_MASTER
> +	select REGMAP_SPI
> +	help
> +	  Say yes here to add control to the MFD_OCELOT chips via SPI.
> +
>  config EZX_PCAP
>  	bool "Motorola EZXPCAP Support"
>  	depends on SPI_MASTER
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index df1ecc4a4c95..12513843067a 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
>  
>  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
>  
> +obj-$(CONFIG_MFD_OCELOT)	+= ocelot-core.o
> +obj-$(CONFIG_MFD_OCELOT_SPI)	+= ocelot-spi.o
> +

These do not look lined-up with the remainder of the file.

>  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
>  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
>  
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> new file mode 100644
> index 000000000000..590489481b8c
> --- /dev/null
> +++ b/drivers/mfd/ocelot-core.c
> @@ -0,0 +1,165 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * MFD core driver for the Ocelot chip family.
> + *
> + * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
> + * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
> + * intended to be the bus-agnostic glue between, for example, the SPI bus and
> + * the MFD children.
> + *
> + * Copyright 2021 Innovative Advantage Inc.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +
> +#include <asm/byteorder.h>
> +
> +#include "ocelot.h"
> +
> +#define GCB_SOFT_RST (0x0008)

Why the brackets?

> +#define SOFT_CHIP_RST (0x1)

As above.

> +static const struct resource vsc7512_gcb_resource = {
> +	.start	= 0x71070000,
> +	.end	= 0x7107022b,

Please define these somewhere.

> +	.name	= "devcpu_gcb",
> +};

There is a macro you can use for these.

Grep for "DEFINE_RES_"

> +static int ocelot_reset(struct ocelot_core *core)
> +{
> +	int ret;
> +
> +	/*
> +	 * Reset the entire chip here to put it into a completely known state.
> +	 * Other drivers may want to reset their own subsystems. The register
> +	 * self-clears, so one write is all that is needed
> +	 */
> +	ret = regmap_write(core->gcb_regmap, GCB_SOFT_RST, SOFT_CHIP_RST);
> +	if (ret)
> +		return ret;
> +
> +	msleep(100);
> +
> +	/*
> +	 * A chip reset will clear the SPI configuration, so it needs to be done
> +	 * again before we can access any more registers
> +	 */
> +	ret = ocelot_spi_initialize(core);
> +
> +	return ret;
> +}
> +
> +static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
> +					      struct device *dev,
> +					      const struct resource *res)
> +{
> +	struct regmap *regmap;
> +
> +	regmap = dev_get_regmap(dev, res->name);
> +	if (!regmap)
> +		regmap = ocelot_spi_devm_get_regmap(core, dev, res);

Why are you making SPI specific calls from the Core driver?

> +	return regmap;
> +}
> +
> +struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
> +					       const struct resource *res)
> +{
> +	struct ocelot_core *core = dev_get_drvdata(dev);
> +
> +	return ocelot_devm_regmap_init(core, dev, res);
> +}
> +EXPORT_SYMBOL(ocelot_get_regmap_from_resource);

Why don't you always call ocelot_devm_regmap_init() with the 'core'
parameter dropped and just do dev_get_drvdata() inside of there?

You're passing 'dev' anyway.

> +static const struct resource vsc7512_miim1_resources[] = {
> +	{
> +		.start = 0x710700c0,
> +		.end = 0x710700e3,
> +		.name = "gcb_miim1",
> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +
> +static const struct resource vsc7512_pinctrl_resources[] = {
> +	{
> +		.start = 0x71070034,
> +		.end = 0x7107009f,
> +		.name = "gcb_gpio",
> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +
> +static const struct resource vsc7512_sgpio_resources[] = {
> +	{
> +		.start = 0x710700f8,
> +		.end = 0x710701f7,
> +		.name = "gcb_sio",
> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +
> +static const struct mfd_cell vsc7512_devs[] = {
> +	{
> +		.name = "pinctrl-ocelot",

<device>-<sub-device>

"ocelot-pinctrl"

> +		.of_compatible = "mscc,ocelot-pinctrl",
> +		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
> +		.resources = vsc7512_pinctrl_resources,
> +	},
> +	{

Same line please.

> +		.name = "pinctrl-sgpio",

"ocelot-sgpio"

> +		.of_compatible = "mscc,ocelot-sgpio",
> +		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
> +		.resources = vsc7512_sgpio_resources,
> +	},
> +	{
> +		.name = "ocelot-miim1",
> +		.of_compatible = "mscc,ocelot-miim",
> +		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> +		.resources = vsc7512_miim1_resources,
> +	},
> +};
> +
> +int ocelot_core_init(struct ocelot_core *core)
> +{
> +	struct device *dev = core->dev;
> +	int ret;
> +
> +	dev_set_drvdata(dev, core);
> +
> +	core->gcb_regmap = ocelot_devm_regmap_init(core, dev,
> +						   &vsc7512_gcb_resource);
> +	if (!core->gcb_regmap)

And if an error is returned?

> +		return -ENOMEM;
> +
> +	/* Prepare the chip */

Does it prepare or reset the chip?

If the former, then the following call is misnamed.

if the latter, then there is no need for this comment.

> +	ret = ocelot_reset(core);
> +	if (ret) {
> +		dev_err(dev, "ocelot mfd reset failed with code %d\n", ret);

Isn't the device called 'ocelot'?  If so, you just repeated yourself.

"Failed to reset device: %d\n"

> +		return ret;
> +	}
> +
> +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,

Why NONE?

> +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(dev, "error adding mfd devices\n");

"Failed to add sub-devices"

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_core_init);
> +
> +int ocelot_remove(struct ocelot_core *core)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_remove);

What's the propose of this?

> +MODULE_DESCRIPTION("Ocelot Chip MFD driver");

No such thing as an MFD driver.

> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> new file mode 100644
> index 000000000000..1e268a4dfa17
> --- /dev/null
> +++ b/drivers/mfd/ocelot-spi.c
> @@ -0,0 +1,325 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * SPI core driver for the Ocelot chip family.
> + *
> + * This driver will handle everything necessary to allow for communication over
> + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> + * processor's endianness. This will create and distribute regmaps for any MFD
> + * children.
> + *
> + * Copyright 2021 Innovative Advantage Inc.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/iopoll.h>
> +#include <linux/kconfig.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/regmap.h>
> +#include <linux/spi/spi.h>
> +
> +#include <asm/byteorder.h>
> +
> +#include "ocelot.h"
> +
> +struct ocelot_spi {
> +	int spi_padding_bytes;
> +	struct spi_device *spi;
> +	struct ocelot_core core;
> +	struct regmap *cpuorg_regmap;
> +};
> +
> +#define DEV_CPUORG_IF_CTRL	(0x0000)
> +#define DEV_CPUORG_IF_CFGSTAT	(0x0004)
> +
> +static const struct resource vsc7512_dev_cpuorg_resource = {
> +	.start	= 0x71000000,
> +	.end	= 0x710002ff,
> +	.name	= "devcpu_org",
> +};
> +
> +#define VSC7512_BYTE_ORDER_LE 0x00000000
> +#define VSC7512_BYTE_ORDER_BE 0x81818181
> +#define VSC7512_BIT_ORDER_MSB 0x00000000
> +#define VSC7512_BIT_ORDER_LSB 0x42424242
> +
> +static struct ocelot_spi *core_to_ocelot_spi(struct ocelot_core *core)
> +{
> +	return container_of(core, struct ocelot_spi, core);
> +}

See my comments in the header file.

> +static int ocelot_spi_init_bus(struct ocelot_spi *ocelot_spi)
> +{
> +	struct spi_device *spi;
> +	struct device *dev;
> +	u32 val, check;
> +	int err;
> +
> +	spi = ocelot_spi->spi;
> +	dev = &spi->dev;
> +
> +#ifdef __LITTLE_ENDIAN
> +	val = VSC7512_BYTE_ORDER_LE;
> +#else
> +	val = VSC7512_BYTE_ORDER_BE;
> +#endif
> +
> +	err = regmap_write(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> +	if (err)
> +		return err;
> +
> +	val = ocelot_spi->spi_padding_bytes;
> +	err = regmap_write(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT,
> +			   val);
> +	if (err)
> +		return err;
> +
> +	check = val | 0x02000000;

Either define or comment magic numbers (I prefer the former).

> +	err = regmap_read(ocelot_spi->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT,
> +			  &val);
> +	if (err)
> +		return err;

Comments needed for what you're actually doing here.

> +	if (check != val)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +int ocelot_spi_initialize(struct ocelot_core *core)
> +{
> +	struct ocelot_spi *ocelot_spi = core_to_ocelot_spi(core);
> +
> +	return ocelot_spi_init_bus(ocelot_spi);
> +}
> +EXPORT_SYMBOL(ocelot_spi_initialize);

See my comments in the header file.

> +static unsigned int ocelot_spi_translate_address(unsigned int reg)
> +{
> +	return cpu_to_be32((reg & 0xffffff) >> 2);
> +}

Comment.

> +struct ocelot_spi_regmap_context {
> +	u32 base;
> +	struct ocelot_spi *ocelot_spi;
> +};

See my comments in the header file.

> +static int ocelot_spi_reg_read(void *context, unsigned int reg,
> +			       unsigned int *val)
> +{
> +	struct ocelot_spi_regmap_context *regmap_context = context;
> +	struct ocelot_spi *ocelot_spi = regmap_context->ocelot_spi;
> +	struct spi_transfer tx, padding, rx;
> +	struct spi_message msg;
> +	struct spi_device *spi;
> +	unsigned int addr;
> +	u8 *tx_buf;
> +
> +	WARN_ON(!val);

Is this possible?

> +	spi = ocelot_spi->spi;
> +
> +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> +	tx_buf = (u8 *)&addr;
> +
> +	spi_message_init(&msg);
> +
> +	memset(&tx, 0, sizeof(struct spi_transfer));
> +
> +	/* Ignore the first byte for the 24-bit address */
> +	tx.tx_buf = &tx_buf[1];
> +	tx.len = 3;
> +
> +	spi_message_add_tail(&tx, &msg);
> +
> +	if (ocelot_spi->spi_padding_bytes > 0) {
> +		u8 dummy_buf[16] = {0};
> +
> +		memset(&padding, 0, sizeof(struct spi_transfer));
> +
> +		/* Just toggle the clock for padding bytes */
> +		padding.len = ocelot_spi->spi_padding_bytes;
> +		padding.tx_buf = dummy_buf;
> +		padding.dummy_data = 1;
> +
> +		spi_message_add_tail(&padding, &msg);
> +	}
> +
> +	memset(&rx, 0, sizeof(struct spi_transfer));

sizeof(*rx)

> +	rx.rx_buf = val;
> +	rx.len = 4;
> +
> +	spi_message_add_tail(&rx, &msg);
> +
> +	return spi_sync(spi, &msg);
> +}
> +
> +static int ocelot_spi_reg_write(void *context, unsigned int reg,
> +				unsigned int val)
> +{
> +	struct ocelot_spi_regmap_context *regmap_context = context;
> +	struct ocelot_spi *ocelot_spi = regmap_context->ocelot_spi;
> +	struct spi_transfer tx[2] = {0};
> +	struct spi_message msg;
> +	struct spi_device *spi;
> +	unsigned int addr;
> +	u8 *tx_buf;
> +
> +	spi = ocelot_spi->spi;
> +
> +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> +	tx_buf = (u8 *)&addr;
> +
> +	spi_message_init(&msg);
> +
> +	/* Ignore the first byte for the 24-bit address and set the write bit */
> +	tx_buf[1] |= BIT(7);
> +	tx[0].tx_buf = &tx_buf[1];
> +	tx[0].len = 3;
> +
> +	spi_message_add_tail(&tx[0], &msg);
> +
> +	memset(&tx[1], 0, sizeof(struct spi_transfer));
> +	tx[1].tx_buf = &val;
> +	tx[1].len = 4;
> +
> +	spi_message_add_tail(&tx[1], &msg);
> +
> +	return spi_sync(spi, &msg);
> +}
> +
> +static const struct regmap_config ocelot_spi_regmap_config = {
> +	.reg_bits = 24,
> +	.reg_stride = 4,
> +	.val_bits = 32,
> +
> +	.reg_read = ocelot_spi_reg_read,
> +	.reg_write = ocelot_spi_reg_write,
> +
> +	.max_register = 0xffffffff,
> +	.use_single_write = true,
> +	.use_single_read = true,
> +	.can_multi_write = false,
> +
> +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> +	.val_format_endian = REGMAP_ENDIAN_NATIVE,
> +};
> +
> +struct regmap *
> +ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *dev,
> +			   const struct resource *res)
> +{
> +	struct ocelot_spi *ocelot_spi = core_to_ocelot_spi(core);
> +	struct ocelot_spi_regmap_context *context;
> +	struct regmap_config regmap_config;
> +	struct regmap *regmap;
> +
> +	context = devm_kzalloc(dev, sizeof(*context), GFP_KERNEL);
> +	if (IS_ERR(context))
> +		return ERR_CAST(context);
> +
> +	context->base = res->start;
> +	context->ocelot_spi = ocelot_spi;
> +
> +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> +	       sizeof(ocelot_spi_regmap_config));
> +
> +	regmap_config.name = res->name;
> +	regmap_config.max_register = res->end - res->start;
> +
> +	regmap = devm_regmap_init(dev, NULL, context, &regmap_config);
> +	if (IS_ERR(regmap))
> +		return ERR_CAST(regmap);
> +
> +	return regmap;
> +}
> +
> +static int ocelot_spi_probe(struct spi_device *spi)
> +{
> +	struct device *dev = &spi->dev;
> +	struct ocelot_spi *ocelot_spi;
> +	int err;
> +
> +	ocelot_spi = devm_kzalloc(dev, sizeof(*ocelot_spi), GFP_KERNEL);
> +
> +	if (!ocelot_spi)
> +		return -ENOMEM;
> +
> +	if (spi->max_speed_hz <= 500000) {
> +		ocelot_spi->spi_padding_bytes = 0;
> +	} else {
> +		/*
> +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> +		 * Register access time is 1us, so we need to configure and send
> +		 * out enough padding bytes between the read request and data
> +		 * transmission that lasts at least 1 microsecond.
> +		 */
> +		ocelot_spi->spi_padding_bytes = 1 +
> +			(spi->max_speed_hz / 1000000 + 2) / 8;
> +	}
> +
> +	ocelot_spi->spi = spi;
> +
> +	spi->bits_per_word = 8;
> +
> +	err = spi_setup(spi);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> +		return err;
> +	}
> +
> +	ocelot_spi->cpuorg_regmap =
> +		ocelot_spi_devm_get_regmap(&ocelot_spi->core, dev,
> +					   &vsc7512_dev_cpuorg_resource);
> +	if (!ocelot_spi->cpuorg_regmap)

And if an error is returned?

> +		return -ENOMEM;
> +
> +	ocelot_spi->core.dev = dev;
> +
> +	/*
> +	 * The chip must be set up for SPI before it gets initialized and reset.
> +	 * This must be done before calling init, and after a chip reset is
> +	 * performed.
> +	 */
> +	err = ocelot_spi_init_bus(ocelot_spi);
> +	if (err) {
> +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> +		return err;
> +	}
> +
> +	err = ocelot_core_init(&ocelot_spi->core);
> +	if (err < 0) {
> +		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ocelot_spi_remove(struct spi_device *spi)
> +{
> +	return 0;
> +}
> +
> +const struct of_device_id ocelot_spi_of_match[] = {
> +	{ .compatible = "mscc,vsc7512_mfd_spi" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> +
> +static struct spi_driver ocelot_spi_driver = {
> +	.driver = {
> +		.name = "ocelot_mfd_spi",
> +		.of_match_table = of_match_ptr(ocelot_spi_of_match),
> +	},
> +	.probe = ocelot_spi_probe,
> +	.remove = ocelot_spi_remove,
> +};
> +module_spi_driver(ocelot_spi_driver);
> +
> +MODULE_DESCRIPTION("Ocelot Chip MFD SPI driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("Dual MIT/GPL");
> diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> new file mode 100644
> index 000000000000..8bb2b57002be
> --- /dev/null
> +++ b/drivers/mfd/ocelot.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright 2021 Innovative Advantage Inc.
> + */
> +
> +#include <linux/kconfig.h>
> +#include <linux/regmap.h>
> +
> +struct ocelot_core {
> +	struct device *dev;
> +	struct regmap *gcb_regmap;
> +};

Please drop this over-complicated 'core' and 'spi' stuff.

You spend too much effort converting between 'dev', 'core' and 'spi'.

I suggest you just pass 'dev' around as your key parameter.

Any additional attributes you *need" to carry around can do in:

  struct ocelot *ddata;

> +void ocelot_get_resource_name(char *name, const struct resource *res,
> +			      int size);
> +int ocelot_core_init(struct ocelot_core *core);
> +int ocelot_remove(struct ocelot_core *core);
> +
> +#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)
> +struct regmap *ocelot_spi_devm_get_regmap(struct ocelot_core *core,
> +					  struct device *dev,
> +					  const struct resource *res);
> +int ocelot_spi_initialize(struct ocelot_core *core);
> +#else
> +static inline struct regmap *ocelot_spi_devm_get_regmap(
> +		struct ocelot_core *core, struct device *dev,
> +		const struct resource *res)
> +{
> +	return NULL;
> +}
> +
> +static inline int ocelot_spi_initialize(struct ocelot_core *core)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
> index 07baf8390744..8e54bde06fd5 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -11,11 +11,13 @@
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
>  #include <linux/mdio/mdio-mscc-miim.h>
> +#include <linux/mfd/core.h>
>  #include <linux/module.h>
>  #include <linux/of_mdio.h>
>  #include <linux/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
> +#include <soc/mscc/ocelot.h>
>  
>  #define MSCC_MIIM_REG_STATUS		0x0
>  #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
> @@ -230,13 +232,20 @@ static int mscc_miim_probe(struct platform_device *pdev)
>  	struct mii_bus *bus;
>  	int ret;
>  
> -	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> -	if (IS_ERR(regs)) {
> -		dev_err(dev, "Unable to map MIIM registers\n");
> -		return PTR_ERR(regs);
> -	}
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	if (!device_is_mfd(pdev)) {
> +		regs = devm_ioremap_resource(dev, res);
> +		if (IS_ERR(regs)) {
> +			dev_err(dev, "Unable to map MIIM registers\n");
> +			return PTR_ERR(regs);
> +		}
>  
> -	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
> +		mii_regmap = devm_regmap_init_mmio(dev, regs,
> +						   &mscc_miim_regmap_config);

These tabs look wrong.

Doesn't checkpatch.pl warn about stuff like this?
> +	} else {
> +		mii_regmap = ocelot_get_regmap_from_resource(dev->parent, res);
> +	}

You need a comment to explain why you're calling both of these.

>  	if (IS_ERR(mii_regmap)) {
>  		dev_err(dev, "Unable to create MIIM regmap\n");
> diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> index 8db3caf15cf2..53df095b33e0 100644
> --- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
> +++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> @@ -12,6 +12,7 @@
>  #include <linux/clk.h>
>  #include <linux/gpio/driver.h>
>  #include <linux/io.h>
> +#include <linux/mfd/core.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/module.h>
>  #include <linux/pinctrl/pinmux.h>
> @@ -19,6 +20,7 @@
>  #include <linux/property.h>
>  #include <linux/regmap.h>
>  #include <linux/reset.h>
> +#include <soc/mscc/ocelot.h>
>  
>  #include "core.h"
>  #include "pinconf.h"
> @@ -137,7 +139,9 @@ static inline int sgpio_addr_to_pin(struct sgpio_priv *priv, int port, int bit)
>  
>  static inline u32 sgpio_get_addr(struct sgpio_priv *priv, u32 rno, u32 off)
>  {
> -	return priv->properties->regoff[rno] + off;
> +	int stride = regmap_get_reg_stride(priv->regs);
> +
> +	return (priv->properties->regoff[rno] + off) * stride;
>  }
>  
>  static u32 sgpio_readl(struct sgpio_priv *priv, u32 rno, u32 off)
> @@ -818,6 +822,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
>  	struct fwnode_handle *fwnode;
>  	struct reset_control *reset;
>  	struct sgpio_priv *priv;
> +	struct resource *res;
>  	struct clk *clk;
>  	u32 __iomem *regs;
>  	u32 val;
> @@ -850,11 +855,18 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	regs = devm_platform_ioremap_resource(pdev, 0);
> -	if (IS_ERR(regs))
> -		return PTR_ERR(regs);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	if (!device_is_mfd(pdev)) {
> +		regs = devm_ioremap_resource(dev, res);

What happens if you call this if the device was registered via MFD?

> +		if (IS_ERR(regs))
> +			return PTR_ERR(regs);
> +
> +		priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> +	} else {
> +		priv->regs = ocelot_get_regmap_from_resource(dev->parent, res);
> +	}
>  
> -	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
>  	if (IS_ERR(priv->regs))
>  		return PTR_ERR(priv->regs);
>  
> diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> index b6ad3ffb4596..d5485c6a0e20 100644
> --- a/drivers/pinctrl/pinctrl-ocelot.c
> +++ b/drivers/pinctrl/pinctrl-ocelot.c
> @@ -10,6 +10,7 @@
>  #include <linux/gpio/driver.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/mfd/core.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> @@ -20,6 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
> +#include <soc/mscc/ocelot.h>
>  
>  #include "core.h"
>  #include "pinconf.h"
> @@ -1123,6 +1125,9 @@ static int lan966x_pinmux_set_mux(struct pinctrl_dev *pctldev,
>  	return 0;
>  }
>  
> +#if defined(REG)
> +#undef REG
> +#endif
>  #define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
>  
>  static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
> @@ -1805,6 +1810,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct ocelot_pinctrl *info;
>  	struct regmap *pincfg;
> +	struct resource *res;
>  	void __iomem *base;
>  	int ret;
>  	struct regmap_config regmap_config = {
> @@ -1819,16 +1825,27 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
>  
>  	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
>  
> -	base = devm_ioremap_resource(dev,
> -			platform_get_resource(pdev, IORESOURCE_MEM, 0));
> -	if (IS_ERR(base))
> -		return PTR_ERR(base);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (IS_ERR(res)) {
> +		dev_err(dev, "Failed to get resource\n");
> +		return PTR_ERR(res);
> +	}
>  
>  	info->stride = 1 + (info->desc->npins - 1) / 32;
>  
> -	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> +	if (!device_is_mfd(pdev)) {
> +		base = devm_ioremap_resource(dev, res);
> +		if (IS_ERR(base))
> +			return PTR_ERR(base);
> +
> +		regmap_config.max_register =
> +			OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> +
> +		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> +	} else {
> +		info->map = ocelot_get_regmap_from_resource(dev->parent, res);
> +	}
>  
> -	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
>  	if (IS_ERR(info->map)) {
>  		dev_err(dev, "Failed to create regmap\n");
>  		return PTR_ERR(info->map);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 5c3a3597f1d2..70fae9c8b649 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -969,4 +969,15 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
>  }
>  #endif
>  
> +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> +struct regmap *ocelot_get_regmap_from_resource(struct device *dev,
> +					       const struct resource *res);
> +#else
> +static inline struct regmap *
> +ocelot_get_regmap_from_resource(struct device *dev, const struct resource *res)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  #endif

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
