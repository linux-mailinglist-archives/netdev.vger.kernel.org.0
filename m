Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FB357852B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiGROSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiGROSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:18:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFFEDEBE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:18:33 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a5so17242309wrx.12
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gLq0d/jV4o9aB9pU8p7hMA+66qSzv4eqlhhhHzAYRmw=;
        b=vEyDTieprd8sNYmuqnTOrargXydmC0ROgW8hxZ+TmQo8DTdxtWB2rU9xtKbwV8Io7Y
         NeSu3Z0Fcrwed5eQrOt7TevAPh4s6pboEcyIDANa0saXRTCSTib0SHWpA8W/+A9yP+6k
         d8WQULhyBS8JPUeIxdXsplv/iMA6q4QcNZSKR1aX5hD02/JFl9efIgZwo04d6A/V+T4H
         C3gR3a3z8Tz6+BFPHDiVvfGysxJCF+Fngd888vVyTgD1sGrqn+E6w2ivqve99Tz0+lDa
         vOkfc6CuS6TIoIfb+YsotGZtPNO/Cj/yF/vzTcCbWaPODbXXsPaIFLhp9d1UgkJhsYiJ
         Qc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gLq0d/jV4o9aB9pU8p7hMA+66qSzv4eqlhhhHzAYRmw=;
        b=2Cf1MQc/RYK6hke1g8FDBbIyFikr6DeEb2kCuKuZ69kN/UyssfVXDzYHMFg5gFjNRI
         FgEg8wbL/AJYc+80Begp6BriM7hYa4yXanpCMQhsuZg4unZnx879iPBYX9r+FTDQ9A6k
         9OC0FQ9ZnwqaHoXreCZ6WtHYbMkM3v/9JddOxdmJowlLNVJOnzGA9lfBZ2MOMpnkD7Gz
         Q6XFCxD/PvFhTHnkEE108DZaXiJMmdrzqJghEFTTzxvBQTlteNoLZ6r7jtpMJC2zzHmY
         /TS447JRHhULlXSIxT0X1N3A2WxgWTJ3GVnyo1tpdwwjfH33c+PS/i6wKtCs7UR4rNZc
         jjbA==
X-Gm-Message-State: AJIora9E3+r6lciQoDfBgYimqJIAOstHCNA0PAFwlETjh4evtm7z+EKK
        5NgPnbJMuYD5W48koekspOvKeQ==
X-Google-Smtp-Source: AGRyM1sAwosNw1DqpvsNcl7J11odJWZRQhS7HKRREBfavJFYLY9GKFX6JmjDGvjCkVb1BdRf62c3WQ==
X-Received: by 2002:a5d:64a4:0:b0:21d:be80:de06 with SMTP id m4-20020a5d64a4000000b0021dbe80de06mr20460241wrp.107.1658153911461;
        Mon, 18 Jul 2022 07:18:31 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id c6-20020a7bc006000000b003a02f957245sm18759407wmb.26.2022.07.18.07.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 07:18:31 -0700 (PDT)
Date:   Mon, 18 Jul 2022 15:18:28 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <YtVrtOHy3lAeKCRH@google.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-10-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220705204743.3224692-10-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Jul 2022, Colin Foster wrote:

> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
> 
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  MAINTAINERS               |   1 +
>  drivers/mfd/Kconfig       |  21 +++
>  drivers/mfd/Makefile      |   3 +
>  drivers/mfd/ocelot-core.c | 169 ++++++++++++++++++++
>  drivers/mfd/ocelot-spi.c  | 317 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/ocelot.h      |  34 ++++
>  6 files changed, 545 insertions(+)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-spi.c
>  create mode 100644 drivers/mfd/ocelot.h

Generally this is looking much better.

Almost ready for inclusion with just a few nits.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5e798c42fa08..e3299677cd4a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14471,6 +14471,7 @@ OCELOT EXTERNAL SWITCH CONTROL
>  M:	Colin Foster <colin.foster@in-advantage.com>
>  S:	Supported
>  F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
> +F:	drivers/mfd/ocelot*
>  F:	include/linux/mfd/ocelot.h
>  
>  OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3b59456f5545..0ef433d170dc 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -962,6 +962,27 @@ config MFD_MENF21BMC
>  	  This driver can also be built as a module. If so the module
>  	  will be called menf21bmc.
>  
> +config MFD_OCELOT
> +	tristate "Microsemi Ocelot External Control Support"
> +	depends on SPI_MASTER
> +	select MFD_CORE
> +	select REGMAP_SPI
> +	help
> +	  Ocelot is a family of networking chips that support multiple ethernet
> +	  and fibre interfaces. In addition to networking, they contain several
> +	  other functions, including pinctrl, MDIO, and communication with
> +	  external chips. While some chips have an internal processor capable of
> +	  running an OS, others don't. All chips can be controlled externally
> +	  through different interfaces, including SPI, I2C, and PCIe.
> +
> +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +	  VSC7513, VSC7514) controlled externally.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called ocelot-soc.
> +
> +	  If unsure, say N.
> +
>  config EZX_PCAP
>  	bool "Motorola EZXPCAP Support"
>  	depends on SPI_MASTER
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 858cacf659d6..0004b7e86220 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -120,6 +120,9 @@ obj-$(CONFIG_MFD_MC13XXX_I2C)	+= mc13xxx-i2c.o
>  
>  obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
>  
> +ocelot-soc-objs			:= ocelot-core.o ocelot-spi.o
> +obj-$(CONFIG_MFD_OCELOT)	+= ocelot-soc.o
> +
>  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
>  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
>  
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> new file mode 100644
> index 000000000000..e07cd901e1b3
> --- /dev/null
> +++ b/drivers/mfd/ocelot-core.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Core driver for the Ocelot chip family.
> + *
> + * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
> + * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
> + * intended to be the bus-agnostic glue between, for example, the SPI bus and
> + * the child devices.
> + *
> + * Copyright 2021, 2022 Innovative Advantage Inc.

Range?

> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/ocelot.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>
> +
> +#include <soc/mscc/ocelot.h>
> +
> +#include "ocelot.h"
> +
> +#define REG_GCB_SOFT_RST		0x0008
> +
> +#define BIT_SOFT_CHIP_RST		BIT(0)
> +
> +#define VSC7512_MIIM0_RES_START		0x7107009c
> +#define VSC7512_MIIM0_RES_SIZE		0x24
> +
> +#define VSC7512_MIIM1_RES_START		0x710700c0
> +#define VSC7512_MIIM1_RES_SIZE		0x24

Maybe:

#define VSC7512_MIIM0_RES_START		0x7107009c
#define VSC7512_MIIM1_RES_START		0x710700c0
#define VSC7512_MIIM_RES_SIZE		0x24

No strong feelings about this though, just saves a line or two.

> +#define VSC7512_PHY_RES_START		0x710700f0
> +#define VSC7512_PHY_RES_SIZE		0x4
> +
> +#define VSC7512_GPIO_RES_START		0x71070034
> +#define VSC7512_GPIO_RES_SIZE		0x6c
> +
> +#define VSC7512_SIO_CTRL_RES_START	0x710700f8
> +#define VSC7512_SIO_CTRL_RES_SIZE	0x100
> +
> +#define VSC7512_GCB_RST_SLEEP_US	100
> +#define VSC7512_GCB_RST_TIMEOUT_US	100000
> +
> +static int ocelot_gcb_chip_rst_status(struct ocelot_ddata *ddata)
> +{
> +	int val, err;
> +
> +	err = regmap_read(ddata->gcb_regmap, REG_GCB_SOFT_RST, &val);
> +	if (err)
> +		val = err;

I think just returning err is clearer.

> +	return val;
> +}
> +
> +int ocelot_chip_reset(struct device *dev)
> +{
> +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> +	int ret, val;
> +
> +	/*
> +	 * Reset the entire chip here to put it into a completely known state.
> +	 * Other drivers may want to reset their own subsystems. The register
> +	 * self-clears, so one write is all that is needed and wait for it to
> +	 * clear.
> +	 */
> +	ret = regmap_write(ddata->gcb_regmap, REG_GCB_SOFT_RST,
> +			   BIT_SOFT_CHIP_RST);

Lots of these line-breaks can be removed which will tidy-up the file
quite a bit.  The new max is 100 chars.  So long as checkpatch.pl
doesn't complain, I'm happy.

> +	if (ret)
> +		return ret;
> +
> +	ret = readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
> +				 VSC7512_GCB_RST_SLEEP_US,
> +				 VSC7512_GCB_RST_TIMEOUT_US);
> +	if (ret)
> +		return dev_err_probe(ddata->dev, ret, "timeout: chip reset\n");

*This* function is not probe.

Also the last failure will produce 2 prints due to the dev_err_probe()
in actual .probe() below.  Please fix that.

> +	return 0;
> +}
> +EXPORT_SYMBOL_NS(ocelot_chip_reset, MFD_OCELOT);
> +
> +static const struct resource vsc7512_miim0_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM0_RES_SIZE,
> +			     "gcb_miim0"),

Lots of early breaks coming up - I won't comment on them all.

> +	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE,
> +			     "gcb_phy"),
> +};
> +
> +static const struct resource vsc7512_miim1_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM1_RES_SIZE,
> +			     "gcb_miim1"),
> +};
> +
> +static const struct resource vsc7512_pinctrl_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
> +			     "gcb_gpio"),
> +};
> +
> +static const struct resource vsc7512_sgpio_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START,
> +			     VSC7512_SIO_CTRL_RES_SIZE,
> +			     "gcb_sio"),
> +};
> +
> +static const struct mfd_cell vsc7512_devs[] = {
> +	{
> +		.name = "ocelot-pinctrl",
> +		.of_compatible = "mscc,ocelot-pinctrl",
> +		.num_resources = ARRAY_SIZE(vsc7512_pinctrl_resources),
> +		.resources = vsc7512_pinctrl_resources,
> +	}, {
> +		.name = "ocelot-sgpio",
> +		.of_compatible = "mscc,ocelot-sgpio",
> +		.num_resources = ARRAY_SIZE(vsc7512_sgpio_resources),
> +		.resources = vsc7512_sgpio_resources,
> +	}, {
> +		.name = "ocelot-miim0",
> +		.of_compatible = "mscc,ocelot-miim",
> +		.of_reg = VSC7512_MIIM0_RES_START,
> +		.use_of_reg = true,
> +		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
> +		.resources = vsc7512_miim0_resources,
> +	}, {
> +		.name = "ocelot-miim1",
> +		.of_compatible = "mscc,ocelot-miim",
> +		.of_reg = VSC7512_MIIM1_RES_START,
> +		.use_of_reg = true,
> +		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> +		.resources = vsc7512_miim1_resources,
> +	},
> +};
> +
> +static void ocelot_core_try_add_regmap(struct device *dev,
> +				       const struct resource *res)
> +{
> +	if (!dev_get_regmap(dev, res->name))
> +		ocelot_spi_init_regmap(dev, res);

This is probably clearer at first-glance for readers:

	if (dev_get_regmap(dev, res->name))
	        return;
	
	ocelot_spi_init_regmap(dev, res);

> +}
> +
> +static void ocelot_core_try_add_regmaps(struct device *dev,
> +					const struct mfd_cell *cell)
> +{
> +	int i;
> +
> +	for (i = 0; i < cell->num_resources; i++)
> +		ocelot_core_try_add_regmap(dev, &cell->resources[i]);
> +}
> +
> +int ocelot_core_init(struct device *dev)
> +{
> +	int i, ndevs;
> +
> +	ndevs = ARRAY_SIZE(vsc7512_devs);
> +
> +	for (i = 0; i < ndevs; i++)
> +		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> +
> +	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> +				    ndevs, NULL, 0, NULL);
> +}
> +EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
> +
> +MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_IMPORT_NS(MFD_OCELOT_SPI);
> diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> new file mode 100644
> index 000000000000..0c1c5215c706
> --- /dev/null
> +++ b/drivers/mfd/ocelot-spi.c
> @@ -0,0 +1,317 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * SPI core driver for the Ocelot chip family.
> + *
> + * This driver will handle everything necessary to allow for communication over
> + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> + * processor's endianness. This will create and distribute regmaps for any
> + * children.
> + *
> + * Copyright 2021, 2022 Innovative Advantage Inc.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/ioport.h>
> +#include <linux/kconfig.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/spi/spi.h>
> +
> +#include <asm/byteorder.h>
> +
> +#include "ocelot.h"
> +
> +#define REG_DEV_CPUORG_IF_CTRL		0x0000
> +#define REG_DEV_CPUORG_IF_CFGSTAT	0x0004
> +
> +#define CFGSTAT_IF_NUM_VCORE		(0 << 24)
> +#define CFGSTAT_IF_NUM_VRAP		(1 << 24)
> +#define CFGSTAT_IF_NUM_SI		(2 << 24)
> +#define CFGSTAT_IF_NUM_MIIM		(3 << 24)
> +
> +#define VSC7512_DEVCPU_ORG_RES_START	0x71000000
> +#define VSC7512_DEVCPU_ORG_RES_SIZE	0x38
> +
> +#define VSC7512_CHIP_REGS_RES_START	0x71070000
> +#define VSC7512_CHIP_REGS_RES_SIZE	0x14
> +
> +struct spi_device;

Why not just #include?

> +static const struct resource vsc7512_dev_cpuorg_resource =
> +	DEFINE_RES_REG_NAMED(VSC7512_DEVCPU_ORG_RES_START,
> +			     VSC7512_DEVCPU_ORG_RES_SIZE,
> +			     "devcpu_org");
> +
> +static const struct resource vsc7512_gcb_resource =
> +	DEFINE_RES_REG_NAMED(VSC7512_CHIP_REGS_RES_START,
> +			     VSC7512_CHIP_REGS_RES_SIZE,
> +			     "devcpu_gcb_chip_regs");
> +
> +static int ocelot_spi_initialize(struct device *dev)
> +{
> +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> +	u32 val, check;
> +	int err;
> +
> +	val = OCELOT_SPI_BYTE_ORDER;
> +
> +	/*
> +	 * The SPI address must be big-endian, but we want the payload to match
> +	 * our CPU. These are two bits (0 and 1) but they're repeated such that
> +	 * the write from any configuration will be valid. The four
> +	 * configurations are:
> +	 *
> +	 * 0b00: little-endian, MSB first
> +	 * |            111111   | 22221111 | 33222222 |
> +	 * | 76543210 | 54321098 | 32109876 | 10987654 |
> +	 *
> +	 * 0b01: big-endian, MSB first
> +	 * | 33222222 | 22221111 | 111111   |          |
> +	 * | 10987654 | 32109876 | 54321098 | 76543210 |
> +	 *
> +	 * 0b10: little-endian, LSB first
> +	 * |              111111 | 11112222 | 22222233 |
> +	 * | 01234567 | 89012345 | 67890123 | 45678901 |
> +	 *
> +	 * 0b11: big-endian, LSB first
> +	 * | 22222233 | 11112222 |   111111 |          |
> +	 * | 45678901 | 67890123 | 89012345 | 01234567 |
> +	 */
> +	err = regmap_write(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CTRL, val);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * Apply the number of padding bytes between a read request and the data
> +	 * payload. Some registers have access times of up to 1us, so if the
> +	 * first payload bit is shifted out too quickly, the read will fail.
> +	 */
> +	val = ddata->spi_padding_bytes;
> +	err = regmap_write(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CFGSTAT,
> +			   val);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * After we write the interface configuration, read it back here. This
> +	 * will verify several different things. The first is that the number of
> +	 * padding bytes actually got written correctly. These are found in bits
> +	 * 0:3.
> +	 *
> +	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
> +	 * and will be set if the register access is too fast. This would be in
> +	 * the condition that the number of padding bytes is insufficient for
> +	 * the SPI bus frequency.
> +	 *
> +	 * The last check is for bits 31:24, which define the interface by which
> +	 * the registers are being accessed. Since we're accessing them via the
> +	 * serial interface, it must return IF_NUM_SI.
> +	 */
> +	check = val | CFGSTAT_IF_NUM_SI;
> +
> +	err = regmap_read(ddata->cpuorg_regmap, REG_DEV_CPUORG_IF_CFGSTAT,
> +			  &val);
> +	if (err)
> +		return err;
> +
> +	if (check != val)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static const struct regmap_config ocelot_spi_regmap_config = {
> +	.reg_bits = 24,
> +	.reg_stride = 4,
> +	.reg_downshift = 2,
> +	.val_bits = 32,
> +
> +	.write_flag_mask = 0x80,
> +
> +	.use_single_write = true,
> +	.can_multi_write = false,
> +
> +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> +	.val_format_endian = REGMAP_ENDIAN_NATIVE,
> +};
> +
> +static int ocelot_spi_regmap_bus_read(void *context,
> +				      const void *reg, size_t reg_size,
> +				      void *val, size_t val_size)
> +{
> +	struct ocelot_ddata *ddata = context;
> +	struct spi_transfer tx, padding, rx;
> +	struct spi_device *spi = ddata->spi;
> +	struct spi_message msg;
> +
> +	spi = ddata->spi;

Drop this line.

> +	spi_message_init(&msg);
> +
> +	memset(&tx, 0, sizeof(tx));
> +
> +	tx.tx_buf = reg;
> +	tx.len = reg_size;
> +
> +	spi_message_add_tail(&tx, &msg);
> +
> +	if (ddata->spi_padding_bytes) {
> +		memset(&padding, 0, sizeof(padding));
> +
> +		padding.len = ddata->spi_padding_bytes;
> +		padding.tx_buf = ddata->dummy_buf;
> +		padding.dummy_data = 1;
> +
> +		spi_message_add_tail(&padding, &msg);
> +	}
> +
> +	memset(&rx, 0, sizeof(rx));
> +	rx.rx_buf = val;
> +	rx.len = val_size;
> +
> +	spi_message_add_tail(&rx, &msg);
> +
> +	return spi_sync(spi, &msg);
> +}
> +
> +static int ocelot_spi_regmap_bus_write(void *context, const void *data,
> +				       size_t count)
> +{
> +	struct ocelot_ddata *ddata = context;
> +	struct spi_device *spi = ddata->spi;
> +
> +	return spi_write(spi, data, count);
> +}
> +
> +static const struct regmap_bus ocelot_spi_regmap_bus = {
> +	.write = ocelot_spi_regmap_bus_write,
> +	.read = ocelot_spi_regmap_bus_read,
> +};
> +
> +struct regmap *
> +ocelot_spi_init_regmap(struct device *dev, const struct resource *res)

One line, along with all the others.

> +{
> +	struct ocelot_ddata *ddata = dev_get_drvdata(dev);
> +	struct regmap_config regmap_config;
> +
> +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> +	       sizeof(regmap_config));
> +
> +	regmap_config.name = res->name;
> +	regmap_config.max_register = res->end - res->start;
> +	regmap_config.reg_base = res->start;
> +
> +	return devm_regmap_init(dev, &ocelot_spi_regmap_bus, ddata,
> +				&regmap_config);
> +}
> +EXPORT_SYMBOL_NS(ocelot_spi_init_regmap, MFD_OCELOT_SPI);
> +
> +static int ocelot_spi_probe(struct spi_device *spi)
> +{
> +	struct device *dev = &spi->dev;
> +	struct ocelot_ddata *ddata;
> +	struct regmap *r;
> +	int err;
> +
> +	ddata = devm_kzalloc(dev, sizeof(*ddata), GFP_KERNEL);
> +	if (!ddata)
> +		return -ENOMEM;
> +
> +	ddata->dev = dev;

How are you fetching ddata if you don't already have 'dev'?

> +	dev_set_drvdata(dev, ddata);

This should use the spi_* variant.

> +	if (spi->max_speed_hz <= 500000) {
> +		ddata->spi_padding_bytes = 0;
> +	} else {
> +		/*
> +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> +		 * Register access time is 1us, so we need to configure and send
> +		 * out enough padding bytes between the read request and data
> +		 * transmission that lasts at least 1 microsecond.
> +		 */
> +		ddata->spi_padding_bytes = 1 +
> +			(spi->max_speed_hz / 1000000 + 2) / 8;
> +
> +		ddata->dummy_buf = devm_kzalloc(dev, ddata->spi_padding_bytes,
> +						GFP_KERNEL);
> +		if (!ddata->dummy_buf)
> +			return -ENOMEM;
> +	}
> +
> +	ddata->spi = spi;

If you have 'spi' you definitely do not need 'dev'.

You can derive one from the other.

> +	spi->bits_per_word = 8;
> +
> +	err = spi_setup(spi);
> +	if (err < 0)
> +		return dev_err_probe(&spi->dev, err,
> +				     "Error performing SPI setup\n");
> +
> +	r = ocelot_spi_init_regmap(dev, &vsc7512_dev_cpuorg_resource);
> +	if (IS_ERR(r))
> +		return PTR_ERR(r);
> +
> +	ddata->cpuorg_regmap = r;
> +
> +	r = ocelot_spi_init_regmap(dev, &vsc7512_gcb_resource);
> +	if (IS_ERR(r))
> +		return PTR_ERR(r);
> +
> +	ddata->gcb_regmap = r;
> +
> +	/*
> +	 * The chip must be set up for SPI before it gets initialized and reset.
> +	 * This must be done before calling init, and after a chip reset is
> +	 * performed.
> +	 */
> +	err = ocelot_spi_initialize(dev);
> +	if (err)
> +		return dev_err_probe(dev, err, "Error initializing SPI bus\n");
> +
> +	err = ocelot_chip_reset(dev);
> +	if (err)
> +		return dev_err_probe(dev, err, "Error resetting device\n");
> +
> +	/*
> +	 * A chip reset will clear the SPI configuration, so it needs to be done
> +	 * again before we can access any registers
> +	 */
> +	err = ocelot_spi_initialize(dev);
> +	if (err)
> +		return dev_err_probe(dev, err,
> +				     "Error initializing SPI bus after reset\n");
> +
> +	err = ocelot_core_init(dev);
> +	if (err < 0)
> +		return dev_err_probe(dev, err,
> +				     "Error initializing Ocelot core\n");
> +
> +	return 0;
> +}
> +
> +static const struct spi_device_id ocelot_spi_ids[] = {
> +	{ "vsc7512", 0 },
> +	{ }
> +};
> +
> +static const struct of_device_id ocelot_spi_of_match[] = {
> +	{ .compatible = "mscc,vsc7512" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ocelot_spi_of_match);
> +
> +static struct spi_driver ocelot_spi_driver = {
> +	.driver = {
> +		.name = "ocelot-soc",
> +		.of_match_table = ocelot_spi_of_match,
> +	},
> +	.id_table = ocelot_spi_ids,
> +	.probe = ocelot_spi_probe,
> +};
> +module_spi_driver(ocelot_spi_driver);
> +
> +MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("Dual MIT/GPL");
> +MODULE_IMPORT_NS(MFD_OCELOT);
> diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> new file mode 100644
> index 000000000000..c86bd6990a3c
> --- /dev/null
> +++ b/drivers/mfd/ocelot.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/* Copyright 2021, 2022 Innovative Advantage Inc. */
> +
> +#include <asm/byteorder.h>
> +
> +struct device;
> +struct spi_device;
> +struct regmap;
> +struct resource;
> +
> +struct ocelot_ddata {
> +	struct device *dev;
> +	struct regmap *gcb_regmap;
> +	struct regmap *cpuorg_regmap;
> +	int spi_padding_bytes;
> +	struct spi_device *spi;
> +	void *dummy_buf;
> +};

This looks like it deserves a doc header.

> +int ocelot_chip_reset(struct device *dev);
> +int ocelot_core_init(struct device *dev);
> +
> +/* SPI-specific routines that won't be necessary for other interfaces */
> +struct regmap *ocelot_spi_init_regmap(struct device *dev,
> +				      const struct resource *res);
> +
> +#define OCELOT_SPI_BYTE_ORDER_LE 0x00000000
> +#define OCELOT_SPI_BYTE_ORDER_BE 0x81818181
> +
> +#ifdef __LITTLE_ENDIAN
> +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_LE
> +#else
> +#define OCELOT_SPI_BYTE_ORDER OCELOT_SPI_BYTE_ORDER_BE
> +#endif

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
