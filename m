Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C2C48145D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 16:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbhL2PWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 10:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbhL2PW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 10:22:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BADC06173E
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:22:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id a83-20020a1c9856000000b00344731e044bso11903946wme.1
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 07:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=G8RAU0QBTXwsF1rWVGUxzy+tneH0f62DAaHmsiAcaOY=;
        b=FnhdFirGZqeDzNl0jFDhvJm5FDtO3OjUU3yZ6eFvDXcHBlHNME/sKv+YnfUQ4Q/rfP
         FXlzFErtWZKj1p8J4LdmOnva72a0jIkEb4+wVazFiNTU6SxnP8rfKNJDQgCGgS1E2zcV
         FfNIqa8Gy63Lasa2CcxrR0mv5prEzShJJ11KcI7IMgXi7pUbli2ge5FFVrCFNszl6JIE
         uRUvSaPapAw27fL8MpzQQBeJpyIWgA3hyaSofKZhXnMbmbpcnV6sEEPp5e67rd+H0wII
         02uYbrapbPYW41g+AM3aFsMpBt9QA8j2WElKXWDpjBWIRkoTqPUwSCtP5y6vxFbSHeI5
         Kvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=G8RAU0QBTXwsF1rWVGUxzy+tneH0f62DAaHmsiAcaOY=;
        b=t0IYQnA90pzM6biA5+e+4J2wkas3L58UTv8CeLITN8jryH1qnEW2EgtjY7/bW66m5T
         QUBiYJNpDgh8afpBI0BPup5+9+mmBzpKnNsTpHDmAadsz/c0UYf/xxfWQ0AhrmqudLSM
         qWcxGz8RixT4oBZX7QNtSEcHo5QIvDCAef+iOopHXmhmZoYyb9k/brV3sNUqpglwCYrL
         +5S7FI4IpTR3u/tcJDMGERSDXm2E3AsNwOtcsVd3MIiJT6hOXas0DDcXClbQbvso6bGf
         RO93zXjUr1Dj4wkh0liF4aVmUg2qwmQ/eCgWXx3wWQzxE51d01hviH7LNyJBjv6QlPhq
         UcvA==
X-Gm-Message-State: AOAM531LEx7gmXfwmRQS5KETcWz0s6ygYKXm8+2BMOpJ4zysBA2iNO/P
        qiXNFyWiaJGPwvKwaWb62lgDSQ==
X-Google-Smtp-Source: ABdhPJxon02w+CPoMtT0QpsPJ6LRSlWDA8AYky2WmjCNWsL0W+tN41PoeGf6I5davIsBEXDkRxebJw==
X-Received: by 2002:a05:600c:1f18:: with SMTP id bd24mr22258227wmb.174.1640791347179;
        Wed, 29 Dec 2021 07:22:27 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id r11sm24368170wrz.78.2021.12.29.07.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 07:22:26 -0800 (PST)
Date:   Wed, 29 Dec 2021 15:22:24 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>, broonie@kernel.org
Cc:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
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
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v5 net-next 01/13] mfd: ocelot: add support for external
 mfd control over SPI for the VSC7512
Message-ID: <Ycx9MMc+2ZhgXzvb@google.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
 <20211218214954.109755-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211218214954.109755-2-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Dec 2021, Colin Foster wrote:

> Create a single SPI MFD ocelot device that manages the SPI bus on the
> external chip and can handle requests for regmaps. This should allow any
> ocelot driver (pinctrl, miim, etc.) to be used externally, provided they
> utilize regmaps.

We're going to need Mark Brown to have a look at this Regmap implementation.

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/Kconfig       |  15 ++
>  drivers/mfd/Makefile      |   3 +
>  drivers/mfd/ocelot-core.c | 149 +++++++++++++++
>  drivers/mfd/ocelot-mfd.h  |  19 ++

Drop the '-mfd' part please.

>  drivers/mfd/ocelot-spi.c  | 374 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 560 insertions(+)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-mfd.h
>  create mode 100644 drivers/mfd/ocelot-spi.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3fb480818599..af76c9780a10 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -954,6 +954,21 @@ config MFD_MENF21BMC
>  	  This driver can also be built as a module. If so the module
>  	  will be called menf21bmc.
>  
> +config MFD_OCELOT_CORE

You can drop the "_CORE" part.

> +	tristate "Microsemi Ocelot External Control Support"
> +	select MFD_CORE
> +	help
> +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +	  VSC7513, VSC7514) controlled externally.

Please describe the device in more detail here.

I'm not sure what an "External Control Support" is.

> +config MFD_OCELOT_SPI
> +	tristate "Microsemi Ocelot SPI interface"
> +	depends on MFD_OCELOT_CORE
> +	depends on SPI_MASTER
> +	select REGMAP_SPI
> +	help
> +	  Say yes here to add control to the MFD_OCELOT chips via SPI.
> +
>  config EZX_PCAP
>  	bool "Motorola EZXPCAP Support"
>  	depends on SPI_MASTER
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 0b1b629aef3e..dff83f474fb5 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
>  
>  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
>  
> +obj-$(CONFIG_MFD_OCELOT_CORE)	+= ocelot-core.o
> +obj-$(CONFIG_MFD_OCELOT_SPI)	+= ocelot-spi.o
> +
>  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
>  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
>  
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> new file mode 100644
> index 000000000000..a65619a8190b
> --- /dev/null
> +++ b/drivers/mfd/ocelot-core.c
> @@ -0,0 +1,149 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Copyright 2021 Innovative Advantage Inc.

Author?

Short device description?

> + */
> +
> +#include <asm/byteorder.h>

These, if required, usually go at the bottom.

> +#include <linux/spi/spi.h>
> +#include <linux/kconfig.h>

What's this for?

> +#include <linux/module.h>
> +#include <linux/regmap.h>

These should be alphabetical.

> +#include "ocelot-mfd.h"
> +
> +#define REG(reg, offset)	[reg] = offset

What does this save, really?

> +enum ocelot_mfd_gcb_regs {

Please remove the term 'mfd\|MFD' from everywhere.

> +	GCB_SOFT_RST,
> +	GCB_REG_MAX,
> +};
> +
> +enum ocelot_mfd_gcb_regfields {
> +	GCB_SOFT_RST_CHIP_RST,
> +	GCB_REGFIELD_MAX,
> +};
> +
> +static const u32 vsc7512_gcb_regmap[] = {
> +	REG(GCB_SOFT_RST,	0x0008),
> +};
> +
> +static const struct reg_field vsc7512_mfd_gcb_regfields[GCB_REGFIELD_MAX] = {
> +	[GCB_SOFT_RST_CHIP_RST] = REG_FIELD(vsc7512_gcb_regmap[GCB_SOFT_RST], 0, 0),
> +};
> +
> +struct ocelot_mfd_core {
> +	struct ocelot_mfd_config *config;
> +	struct regmap *gcb_regmap;
> +	struct regmap_field *gcb_regfields[GCB_REGFIELD_MAX];
> +};

Not sure about this at all.

Which driver did you take your inspiration from?

> +static const struct resource vsc7512_gcb_resource = {
> +	.start	= 0x71070000,
> +	.end	= 0x7107022b,

No magic numbers please.

> +	.name	= "devcpu_gcb",

What is a 'devcpu_gcb'?

> +};
> +
> +static int ocelot_mfd_reset(struct ocelot_mfd_core *core)
> +{
> +	int ret;
> +
> +	dev_info(core->config->dev, "resetting ocelot chip\n");

These types of calls are not useful in production code.

> +	ret = regmap_field_write(core->gcb_regfields[GCB_SOFT_RST_CHIP_RST], 1);

No magic numbers please.  I have no idea what this is doing.

> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Note: This is adapted from the PCIe reset strategy. The manual doesn't
> +	 * suggest how to do a reset over SPI, and the register strategy isn't
> +	 * possible.
> +	 */
> +	msleep(100);
> +
> +	ret = core->config->init_bus(core->config);

You're not writing a bus.  I doubt you need ops call-backs.

> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
> +				  int size)
> +{
> +	if (res->name)
> +		snprintf(name, size - 1, "ocelot_mfd-%s", res->name);
> +	else
> +		snprintf(name, size - 1, "ocelot_mfd@0x%08x", res->start);
> +}
> +EXPORT_SYMBOL(ocelot_mfd_get_resource_name);

What is this used for?

You should not be hand rolling device resource names like this.

This sort of code belongs in the bus/class API.

Please use those instead.

> +static struct regmap *ocelot_mfd_regmap_init(struct ocelot_mfd_core *core,
> +					     const struct resource *res)
> +{
> +	struct device *dev = core->config->dev;
> +	struct regmap *regmap;
> +	char name[32];
> +
> +	ocelot_mfd_get_resource_name(name, res, sizeof(name) - 1);
> +
> +	regmap = dev_get_regmap(dev, name);
> +
> +	if (!regmap)
> +		regmap = core->config->get_regmap(core->config, res, name);
> +
> +	return regmap;
> +}
> +
> +int ocelot_mfd_init(struct ocelot_mfd_config *config)
> +{
> +	struct device *dev = config->dev;
> +	const struct reg_field *regfield;
> +	struct ocelot_mfd_core *core;
> +	int i, ret;
> +
> +	core = devm_kzalloc(dev, sizeof(struct ocelot_mfd_config), GFP_KERNEL);
> +	if (!core)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, core);
> +
> +	core->config = config;
> +
> +	/* Create regmaps and regfields here */
> +	core->gcb_regmap = ocelot_mfd_regmap_init(core, &vsc7512_gcb_resource);
> +	if (!core->gcb_regmap)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < GCB_REGFIELD_MAX; i++) {
> +		regfield = &vsc7512_mfd_gcb_regfields[i];
> +		core->gcb_regfields[i] =
> +			devm_regmap_field_alloc(dev, core->gcb_regmap,
> +						*regfield);
> +		if (!core->gcb_regfields[i])
> +			return -ENOMEM;
> +	}
> +
> +	/* Prepare the chip */
> +	ret = ocelot_mfd_reset(core);
> +	if (ret) {
> +		dev_err(dev, "ocelot mfd reset failed with code %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Create and loop over all child devices here */

These need to all go in now please.

> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_mfd_init);
> +
> +int ocelot_mfd_remove(struct ocelot_mfd_config *config)
> +{
> +	/* Loop over all children and remove them */

Use devm_* then you won't have to.

> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_mfd_remove);
> +
> +MODULE_DESCRIPTION("Ocelot Chip MFD driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/mfd/ocelot-mfd.h b/drivers/mfd/ocelot-mfd.h
> new file mode 100644
> index 000000000000..6af8b8c5a316
> --- /dev/null
> +++ b/drivers/mfd/ocelot-mfd.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright 2021 Innovative Advantage Inc.
> + */
> +
> +#include <linux/regmap.h>
> +
> +struct ocelot_mfd_config {
> +	struct device *dev;
> +	struct regmap *(*get_regmap)(struct ocelot_mfd_config *config,
> +				     const struct resource *res,
> +				     const char *name);
> +	int (*init_bus)(struct ocelot_mfd_config *config);

Please re-work and delete this 'config' concept.

See other drivers in this sub-directory for reference.

> +};
> +
> +void ocelot_mfd_get_resource_name(char *name, const struct resource *res,
> +				  int size);
> +int ocelot_mfd_init(struct ocelot_mfd_config *config);
> +int ocelot_mfd_remove(struct ocelot_mfd_config *config);
> diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> new file mode 100644
> index 000000000000..65ceb68f27af
> --- /dev/null
> +++ b/drivers/mfd/ocelot-spi.c
> @@ -0,0 +1,374 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Copyright 2021 Innovative Advantage Inc.

As above.

> + */
> +
> +#include <asm/byteorder.h>
> +#include <linux/spi/spi.h>
> +#include <linux/iopoll.h>
> +#include <linux/kconfig.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/regmap.h>

As above.

> +#include "ocelot-mfd.h"
> +
> +#define REG(reg, offset)	[reg] = offset
> +
> +struct ocelot_spi {
> +	int spi_padding_bytes;
> +	struct spi_device *spi;
> +	struct ocelot_mfd_config config;
> +	struct regmap *cpuorg_regmap;
> +	const u32 *map;
> +};
> +
> +enum ocelot_dev_cpuorg_regs {
> +	DEV_CPUORG_IF_CTRL,
> +	DEV_CPUORG_IF_CFGSTAT,
> +	DEV_CPUORG_REG_MAX,
> +};
> +
> +static const u32 vsc7512_dev_cpuorg_regmap[] = {
> +	REG(DEV_CPUORG_IF_CTRL,		0x0000),
> +	REG(DEV_CPUORG_IF_CFGSTAT,	0x0004),
> +};
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
> +static struct ocelot_spi *
> +config_to_ocelot_spi(struct ocelot_mfd_config *config)
> +{
> +	return container_of(config, struct ocelot_spi, config);
> +}
> +
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
> +	dev_info(dev, "initializing SPI interface for chip\n");
> +
> +	val = 0;
> +
> +#ifdef __LITTLE_ENDIAN
> +	val |= VSC7512_BYTE_ORDER_LE;
> +#else
> +	val |= VSC7512_BYTE_ORDER_BE;
> +#endif
> +
> +	err = regmap_write(ocelot_spi->cpuorg_regmap,
> +			   ocelot_spi->map[DEV_CPUORG_IF_CTRL], val);
> +	if (err)
> +		return err;
> +
> +	val = ocelot_spi->spi_padding_bytes;
> +	err = regmap_write(ocelot_spi->cpuorg_regmap,
> +			   ocelot_spi->map[DEV_CPUORG_IF_CFGSTAT], val);
> +	if (err)
> +		return err;
> +
> +	check = val | 0x02000000;
> +
> +	err = regmap_read(ocelot_spi->cpuorg_regmap,
> +			  ocelot_spi->map[DEV_CPUORG_IF_CFGSTAT], &val);
> +	if (err)
> +		return err;
> +
> +	if (check != val) {
> +		dev_err(dev, "Error configuring SPI bus. V: 0x%08x != 0x%08x\n",
> +			val, check);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ocelot_spi_init_bus_from_config(struct ocelot_mfd_config *config)
> +{
> +	struct ocelot_spi *ocelot_spi = config_to_ocelot_spi(config);
> +
> +	return ocelot_spi_init_bus(ocelot_spi);
> +}
> +
> +static unsigned int ocelot_spi_translate_address(unsigned int reg)
> +{
> +	return cpu_to_be32((reg & 0xffffff) >> 2);
> +}
> +
> +struct ocelot_spi_regmap_context {
> +	struct spi_device *spi;
> +	u32 base;
> +	int padding_bytes;
> +};
> +
> +static int ocelot_spi_reg_read(void *context, unsigned int reg,
> +			       unsigned int *val)
> +{
> +	struct ocelot_spi_regmap_context *regmap_context = context;
> +	struct spi_transfer tx, padding, rx;
> +	struct ocelot_spi *ocelot_spi;
> +	struct spi_message msg;
> +	struct spi_device *spi;
> +	unsigned int addr;
> +	u8 *tx_buf;
> +
> +	WARN_ON(!val);
> +
> +	spi = regmap_context->spi;
> +
> +	ocelot_spi = spi_get_drvdata(spi);
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
> +	if (regmap_context->padding_bytes > 0) {
> +		u8 dummy_buf[16] = {0};
> +
> +		memset(&padding, 0, sizeof(struct spi_transfer));
> +
> +		/* Just toggle the clock for padding bytes */
> +		padding.len = regmap_context->padding_bytes;
> +		padding.tx_buf = dummy_buf;
> +		padding.dummy_data = 1;
> +
> +		spi_message_add_tail(&padding, &msg);
> +	}
> +
> +	memset(&rx, 0, sizeof(struct spi_transfer));
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
> +	struct spi_transfer tx[2] = {0};
> +	struct spi_message msg;
> +	struct spi_device *spi;
> +	unsigned int addr;
> +	u8 *tx_buf;
> +
> +	spi = regmap_context->spi;
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
> +static struct regmap *
> +ocelot_spi_get_regmap(struct ocelot_mfd_config *config,
> +		      const struct resource *res, const char *name)
> +{
> +	struct ocelot_spi *ocelot_spi = config_to_ocelot_spi(config);
> +	struct ocelot_spi_regmap_context *context;
> +	struct regmap_config regmap_config;
> +	struct regmap *regmap;
> +	struct device *dev;
> +
> +
> +	dev = &ocelot_spi->spi->dev;
> +
> +	/* Don't re-allocate another regmap if we have one */
> +	regmap = dev_get_regmap(dev, name);
> +	if (regmap)
> +		return regmap;
> +
> +	context = devm_kzalloc(dev, sizeof(struct ocelot_spi_regmap_context),
> +			       GFP_KERNEL);
> +
> +	if (IS_ERR(context))
> +		return ERR_CAST(context);
> +
> +	context->base = res->start;
> +	context->spi = ocelot_spi->spi;
> +	context->padding_bytes = ocelot_spi->spi_padding_bytes;
> +
> +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> +	       sizeof(ocelot_spi_regmap_config));
> +
> +	regmap_config.name = name;
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
> +	struct ocelot_spi *ocelot_spi;
> +	struct device *dev;
> +	char name[32];
> +	int err;
> +
> +	dev = &spi->dev;

Put this on the declaration line.

> +	ocelot_spi = devm_kzalloc(dev, sizeof(struct ocelot_spi),

sizeof(*ocelot_spi)

> +				      GFP_KERNEL);
> +

No '\n'.

> +	if (!ocelot_spi)
> +		return -ENOMEM;
> +
> +	if (spi->max_speed_hz <= 500000) {
> +		ocelot_spi->spi_padding_bytes = 0;
> +	} else {
> +		/*
> +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG. Err
> +		 * on the side of more padding bytes, as having too few can be
> +		 * difficult to detect at runtime.
> +		 */
> +		ocelot_spi->spi_padding_bytes = 1 +
> +			(spi->max_speed_hz / 1000000 + 2) / 8;

Please explain what this means or define the values (or both).

> +	}
> +
> +	ocelot_spi->spi = spi;

Why are you saving this?

> +	ocelot_spi->map = vsc7512_dev_cpuorg_regmap;

Why not just set up the regmap here?

> +	spi->bits_per_word = 8;
> +
> +	err = spi_setup(spi);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);

The error code usually comes at the end.

> +		return err;
> +	}
> +
> +	dev_info(dev, "configured SPI bus for speed %d, rx padding bytes %d\n",
> +			spi->max_speed_hz, ocelot_spi->spi_padding_bytes);

When would this be useful?

Don't we already have debug interfaces to find this out?

> +	/* Ensure we have devcpu_org regmap before we call ocelot_mfd_init */

because ...

> +	ocelot_mfd_get_resource_name(name, &vsc7512_dev_cpuorg_resource,
> +				     sizeof(name) - 1);

This is an ugly interface.  I think it needs to go.

> +	/*
> +	 * Since we created dev, we know there isn't a regmap, so create one
> +	 * here directly.
> +	 */

Sorry, what 'dev'?  When did we create that?

> +	ocelot_spi->cpuorg_regmap =
> +		ocelot_spi_get_regmap(&ocelot_spi->config,
> +				      &vsc7512_dev_cpuorg_resource, name);
> +	if (!ocelot_spi->cpuorg_regmap)
> +		return -ENOMEM;
> +
> +	ocelot_spi->config.init_bus = ocelot_spi_init_bus_from_config;
> +	ocelot_spi->config.get_regmap = ocelot_spi_get_regmap;
> +	ocelot_spi->config.dev = dev;

Please remove this API.

> +	spi_set_drvdata(spi, ocelot_spi);
> +
> +	/*
> +	 * The chip must be set up for SPI before it gets initialized and reset.
> +	 * Do this once here before calling mfd_init
> +	 */
> +	err = ocelot_spi_init_bus(ocelot_spi);
> +	if (err) {
> +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);

Doesn't this already print out an error message?

> +		return err;
> +	}
> +
> +	err = ocelot_mfd_init(&ocelot_spi->config);
> +	if (err < 0) {
> +		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
> +		return err;
> +	}
> +
> +	dev_info(&spi->dev, "ocelot spi mfd probed\n");

Please, remove all of these.

> +	return 0;
> +}
> +
> +static int ocelot_spi_remove(struct spi_device *spi)
> +{
> +	struct ocelot_spi *ocelot_spi;
> +
> +	ocelot_spi = spi_get_drvdata(spi);
> +	devm_kfree(&spi->dev, ocelot_spi);

Why use devm_* if you're going to free anyway?

> +	return 0;
> +}
> +
> +const struct of_device_id ocelot_mfd_of_match[] = {
> +	{ .compatible = "mscc,vsc7514_mfd_spi" },
> +	{ .compatible = "mscc,vsc7513_mfd_spi" },
> +	{ .compatible = "mscc,vsc7512_mfd_spi" },
> +	{ .compatible = "mscc,vsc7511_mfd_spi" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_mfd_of_match);
> +
> +static struct spi_driver ocelot_mfd_spi_driver = {
> +	.driver = {
> +		.name = "ocelot_mfd_spi",
> +		.of_match_table = of_match_ptr(ocelot_mfd_of_match),
> +	},
> +	.probe = ocelot_spi_probe,
> +	.remove = ocelot_spi_remove,
> +};
> +module_spi_driver(ocelot_mfd_spi_driver);
> +
> +MODULE_DESCRIPTION("Ocelot Chip MFD SPI driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("Dual MIT/GPL");

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
