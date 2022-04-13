Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83DB4FF1FC
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiDMIet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiDMIes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:34:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B360C4A902
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:32:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e21so1499355wrc.8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=43L4Fo1VTg4iHrSwnBG558ytJYsFKrb6ExWD6ZDsMak=;
        b=KG6a9NYqPhTPLeRQWj7HFdFz0SVMQgvtCq9jhHPw0ijLyeLHMPpL6P66acaHSk1da1
         WQ7MbIycSEDhN0RdU8Lc/7jCq0LD5g76SIPX49y48OYMupEz5UgFBI2RcrxXLUuhetCs
         cjAxq3OQ+trQSFj4zI5AHi2Eh+nIfLqDP6jgzHrXG15oObfPNn9KdO9ITMmLFflV5UnR
         V7s0OqBlRhRfO47q0OVKdLqStMhNFAD0vO99+DVNSLtyG1uFXkaRzah1KU7PC6Rdlami
         AbzEyOTjmPlkO/ewRJWE8qACRDqzJuhZEDR70Z1dbiYPmIZ9z5kVltilHNvmu8nK4cr9
         Ehug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=43L4Fo1VTg4iHrSwnBG558ytJYsFKrb6ExWD6ZDsMak=;
        b=ASu+bi/kHUi1RINYtqMpNP+btC27sksvrY08Mr2EAOSPmW0qmuG7Vhzlojo16KcBBX
         xpUtGZ5hV+W09VMDHvlq/hysTme37lbffUnky02Qn3TGIWkTUljoyl031yugDBPE3U1w
         JUQx06PIjiLCC8DHei2BZIcG0xv9A4gTBrwewoAduj7w7gxEcrMDRWocx+PkEIwn7RWF
         uDkzuxXnC607XmMzZw6mTkdyaaZWngYoVUx4Zf/2wtlwapnpk83O+N5OgPtnaT7xQaAU
         w2RYuzUkeFMpuwAdSstcpUJcfl3jg7EE4+2ZaoyQ1N7y4g+nKu5JlAcoNtEMQ9graaOk
         YVtg==
X-Gm-Message-State: AOAM530tzQ0cU2jG1s3B/7xxzJBVEH4WvEd0GD/P3I5+PtXR4F8VbbEx
        tohlve2YiFoiMIVtRxl/Us53pFxXjrXnxg==
X-Google-Smtp-Source: ABdhPJyb4o/u7q7PWqlOyrGHkM8DDEqRl9AmtylLWkEJrmLmDjLt1mvEGrxMMUOQ6KZKokIhuDpJ5w==
X-Received: by 2002:a5d:44d0:0:b0:207:9ac8:2c3b with SMTP id z16-20020a5d44d0000000b002079ac82c3bmr18170538wrr.688.1649838745047;
        Wed, 13 Apr 2022 01:32:25 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c154900b0038cb98076d6sm1955228wmg.10.2022.04.13.01.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:32:24 -0700 (PDT)
Date:   Wed, 13 Apr 2022 09:32:22 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
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
Subject: Re: [RFC v7 net-next 10/13] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YlaKlhiQEWMxJxhU@google.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
 <20220307021208.2406741-11-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220307021208.2406741-11-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 06 Mar 2022, Colin Foster wrote:

> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
> 
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, serial GPIO, and HSIO.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/Kconfig       |  24 +++
>  drivers/mfd/Makefile      |   3 +
>  drivers/mfd/ocelot-core.c | 189 +++++++++++++++++++++++
>  drivers/mfd/ocelot-spi.c  | 313 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/ocelot.h      |  42 +++++
>  include/soc/mscc/ocelot.h |   5 +
>  6 files changed, 576 insertions(+)
>  create mode 100644 drivers/mfd/ocelot-core.c
>  create mode 100644 drivers/mfd/ocelot-spi.c
>  create mode 100644 drivers/mfd/ocelot.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ba0b3eb131f1..d4312a5252d0 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -948,6 +948,30 @@ config MFD_MENF21BMC
>  	  This driver can also be built as a module. If so the module
>  	  will be called menf21bmc.
>  
> +config MFD_OCELOT
> +	tristate "Microsemi Ocelot External Control Support"
> +	select MFD_CORE
> +	help
> +	  Ocelot is a family of networking chips that support multiple ethernet
> +	  and fibre interfaces. In addition to networking, they contain several
> +	  other functions, including pictrl, MDIO, and communication with
> +	  external chips. While some chips have an internal processor capable of
> +	  running an OS, others don't. All chips can be controlled externally
> +	  through different interfaces, including SPI, I2C, and PCIe.
> +
> +	  Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +	  VSC7513, VSC7514) controlled externally.
> +
> +	  If unsure, say N
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
>  obj-$(CONFIG_EZX_PCAP)		+= ezx-pcap.o
>  obj-$(CONFIG_MFD_CPCAP)		+= motorola-cpcap.o
>  
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> new file mode 100644
> index 000000000000..36e4326a853a
> --- /dev/null
> +++ b/drivers/mfd/ocelot-core.c
> @@ -0,0 +1,189 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * MFD core driver for the Ocelot chip family.

Please drop all references to 'MFD'.

'Core' is fine, as is 'Parent'.

> + * The VSC7511, 7512, 7513, and 7514 can be controlled internally via an
> + * on-chip MIPS processor, or externally via SPI, I2C, PCIe. This core driver is
> + * intended to be the bus-agnostic glue between, for example, the SPI bus and
> + * the MFD children.
> + *
> + * Copyright 2021 Innovative Advantage Inc.

Out of date?

> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + */
> +
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <soc/mscc/ocelot.h>
> +
> +#include <asm/byteorder.h>
> +
> +#include "ocelot.h"
> +
> +#define GCB_SOFT_RST 0x0008

Tab these out to match the others?

> +#define SOFT_CHIP_RST 0x1
> +
> +#define VSC7512_GCB_RES_START	0x71070000
> +#define VSC7512_GCB_RES_SIZE	0x14
> +
> +#define VSC7512_MIIM0_RES_START	0x7107009c
> +#define VSC7512_MIIM0_RES_SIZE	0x24
> +
> +#define VSC7512_MIIM1_RES_START	0x710700c0
> +#define VSC7512_MIIM1_RES_SIZE	0x24
> +
> +#define VSC7512_PHY_RES_START	0x710700f0
> +#define VSC7512_PHY_RES_SIZE	0x4
> +
> +#define VSC7512_HSIO_RES_START	0x710d0000
> +#define VSC7512_HSIO_RES_SIZE	0x10000
> +
> +#define VSC7512_GPIO_RES_START	0x71070034
> +#define VSC7512_GPIO_RES_SIZE	0x6c
> +
> +#define VSC7512_SIO_RES_START	0x710700f8
> +#define VSC7512_SIO_RES_SIZE	0x100
> +
> +static const struct resource vsc7512_gcb_resource =
> +	DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE,
> +			     "devcpu_gcb_chip_regs");
> +
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
> +	return ret;
> +}
> +
> +static struct regmap *ocelot_devm_regmap_init(struct ocelot_core *core,
> +					      struct device *child,
> +					      const struct resource *res)
> +{
> +	/*
> +	 * Call directly into ocelot_spi to get a new regmap. This will need to
> +	 * be expanded if additional bus types are to be supported in the
> +	 * future.
> +	 */
> +	return ocelot_spi_devm_get_regmap(core, child, res);
> +}
> +
> +struct regmap *ocelot_get_regmap_from_resource(struct device *child,
> +					       const struct resource *res)
> +{
> +	struct ocelot_core *core = dev_get_drvdata(child->parent);
> +
> +	return ocelot_devm_regmap_init(core, child, res);
> +}
> +EXPORT_SYMBOL(ocelot_get_regmap_from_resource);

What's the reason for having an additional function when one would do?

> +static const struct resource vsc7512_miim0_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM0_RES_START, VSC7512_MIIM0_RES_SIZE,
> +			     "gcb_miim0"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PHY_RES_START, VSC7512_PHY_RES_SIZE,
> +			     "gcb_phy"),
> +};
> +
> +static const struct resource vsc7512_miim1_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_MIIM1_RES_START, VSC7512_MIIM1_RES_SIZE,
> +			     "gcb_miim1"),
> +};
> +
> +static const struct resource vsc7512_hsio_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE,
> +			     "hsio"),
> +};
> +
> +static const struct resource vsc7512_pinctrl_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_GPIO_RES_START, VSC7512_GPIO_RES_SIZE,
> +			     "gcb_gpio"),
> +};
> +
> +static const struct resource vsc7512_sgpio_resources[] = {
> +	DEFINE_RES_REG_NAMED(VSC7512_SIO_RES_START, VSC7512_SIO_RES_SIZE,
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
> +		.num_resources = ARRAY_SIZE(vsc7512_miim0_resources),
> +		.resources = vsc7512_miim0_resources,
> +	}, {
> +		.name = "ocelot-miim1",
> +		.of_compatible = "mscc,ocelot-miim",
> +		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
> +		.resources = vsc7512_miim1_resources,
> +	}, {
> +		.name = "ocelot-serdes",
> +		.of_compatible = "mscc,vsc7514-serdes",
> +		.num_resources = ARRAY_SIZE(vsc7512_hsio_resources),
> +		.resources = vsc7512_hsio_resources,
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

This just ends up calling ocelot_spi_devm_get_regmap() right?

Why not call that from inside ocelot-spi.c where 'core' was allocated?

> +	if (IS_ERR(core->gcb_regmap))
> +		return -ENOMEM;
> +
> +	ret = ocelot_reset(core);
> +	if (ret) {
> +		dev_err(dev, "Failed to reset device: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/*
> +	 * A chip reset will clear the SPI configuration, so it needs to be done
> +	 * again before we can access any registers
> +	 */
> +	ret = ocelot_spi_initialize(core);

Not a fan of calling back into the file which called us.

And what happens if SPI isn't controlling us?

Doesn't the documentation above say this device can also be
communicated with via I2C and PCIe?

> +	if (ret) {
> +		dev_err(dev, "Failed to initialize SPI interface: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_core_init);
> +
> +MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> new file mode 100644
> index 000000000000..c788e239c9a7
> --- /dev/null
> +++ b/drivers/mfd/ocelot-spi.c
> @@ -0,0 +1,313 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * SPI core driver for the Ocelot chip family.
> + *
> + * This driver will handle everything necessary to allow for communication over
> + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> + * processor's endianness. This will create and distribute regmaps for any MFD

As above, please drop references to MFD.

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
> +#define DEV_CPUORG_IF_CTRL	0x0000
> +#define DEV_CPUORG_IF_CFGSTAT	0x0004
> +
> +#define CFGSTAT_IF_NUM_VCORE	(0 << 24)
> +#define CFGSTAT_IF_NUM_VRAP	(1 << 24)
> +#define CFGSTAT_IF_NUM_SI	(2 << 24)
> +#define CFGSTAT_IF_NUM_MIIM	(3 << 24)
> +
> +
> +static const struct resource vsc7512_dev_cpuorg_resource = {
> +	.start	= 0x71000000,
> +	.end	= 0x710002ff,

No magic numbers.  Please define these addresses.

> +	.name	= "devcpu_org",
> +};
> +
> +#define VSC7512_BYTE_ORDER_LE 0x00000000
> +#define VSC7512_BYTE_ORDER_BE 0x81818181
> +#define VSC7512_BIT_ORDER_MSB 0x00000000
> +#define VSC7512_BIT_ORDER_LSB 0x42424242
> +
> +int ocelot_spi_initialize(struct ocelot_core *core)
> +{
> +	u32 val, check;
> +	int err;
> +
> +#ifdef __LITTLE_ENDIAN
> +	val = VSC7512_BYTE_ORDER_LE;
> +#else
> +	val = VSC7512_BYTE_ORDER_BE;
> +#endif

Not a fan of ifdefery in the middle of C files.

Please create a macro or define somewhere.

> +	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> +	if (err)
> +		return err;

Comment.

> +	val = core->spi_padding_bytes;
> +	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
> +	if (err)
> +		return err;

Comment.

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
> +	err = regmap_read(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
> +	if (err)
> +		return err;
> +
> +	if (check != val)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ocelot_spi_initialize);
> +
> +/*
> + * The SPI protocol for interfacing with the ocelot chips uses 24 bits, while
> + * the register locations are defined as 32-bit. The least significant two bits
> + * get shifted out, as register accesses must always be word-aligned, leaving
> + * bits 21:0 as the 22-bit address. It must always be big-endian, whereas the
> + * payload can be optimized for bit / byte order to match whatever architecture
> + * the controlling CPU has.
> + */
> +static unsigned int ocelot_spi_translate_address(unsigned int reg)
> +{
> +	return cpu_to_be32((reg & 0xffffff) >> 2);
> +}
> +
> +struct ocelot_spi_regmap_context {
> +	u32 base;
> +	struct ocelot_core *core;
> +};
> +
> +static int ocelot_spi_reg_read(void *context, unsigned int reg,
> +			       unsigned int *val)
> +{
> +	struct ocelot_spi_regmap_context *regmap_context = context;
> +	struct ocelot_core *core = regmap_context->core;
> +	struct spi_transfer tx, padding, rx;
> +	struct spi_message msg;

How big are all of these?

We will receive warnings if they occupy too much stack space.

> +	struct spi_device *spi;
> +	unsigned int addr;
> +	u8 *tx_buf;
> +
> +	spi = core->spi;
> +
> +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> +	tx_buf = (u8 *)&addr;
> +
> +	spi_message_init(&msg);
> +
> +	memset(&tx, 0, sizeof(tx));
> +
> +	/* Ignore the first byte for the 24-bit address */
> +	tx.tx_buf = &tx_buf[1];
> +	tx.len = 3;
> +
> +	spi_message_add_tail(&tx, &msg);
> +
> +	if (core->spi_padding_bytes > 0) {
> +		u8 dummy_buf[16] = {0};
> +
> +		memset(&padding, 0, sizeof(padding));
> +
> +		/* Just toggle the clock for padding bytes */
> +		padding.len = core->spi_padding_bytes;
> +		padding.tx_buf = dummy_buf;
> +		padding.dummy_data = 1;
> +
> +		spi_message_add_tail(&padding, &msg);
> +	}
> +
> +	memset(&rx, 0, sizeof(rx));
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
> +	struct ocelot_core *core = regmap_context->core;
> +	struct spi_transfer tx[2] = {0};
> +	struct spi_message msg;
> +	struct spi_device *spi;
> +	unsigned int addr;
> +	u8 *tx_buf;
> +
> +	spi = core->spi;
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
> +ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *child,
> +			   const struct resource *res)

This seems to always initialise a new Regmap.

To me 'get' implies that it could fetch an already existing one.

... and *perhaps* init a new one if none exists..

> +{
> +	struct ocelot_spi_regmap_context *context;
> +	struct regmap_config regmap_config;
> +
> +	context = devm_kzalloc(child, sizeof(*context), GFP_KERNEL);
> +	if (IS_ERR(context))
> +		return ERR_CAST(context);
> +
> +	context->base = res->start;
> +	context->core = core;
> +
> +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> +	       sizeof(ocelot_spi_regmap_config));
> +
> +	regmap_config.name = res->name;
> +	regmap_config.max_register = res->end - res->start;
> +
> +	return devm_regmap_init(child, NULL, context, &regmap_config);
> +}
> +
> +static int ocelot_spi_probe(struct spi_device *spi)
> +{
> +	struct device *dev = &spi->dev;
> +	struct ocelot_core *core;

This would be more in keeping with current drivers if you dropped the
'_core' part of the struct name and called the variable ddata.

> +	int err;
> +
> +	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
> +	if (!core)
> +		return -ENOMEM;

If you save 'core' (or preferably ddata) here and place it in the
device's driver_data slot via dev_set_drvdata(), you can just pass
around the 'struct device' which is more in keeping with current
implementations.

> +	if (spi->max_speed_hz <= 500000) {
> +		core->spi_padding_bytes = 0;
> +	} else {
> +		/*
> +		 * Calculation taken from the manual for IF_CFGSTAT:IF_CFG.
> +		 * Register access time is 1us, so we need to configure and send
> +		 * out enough padding bytes between the read request and data
> +		 * transmission that lasts at least 1 microsecond.
> +		 */
> +		core->spi_padding_bytes = 1 +
> +			(spi->max_speed_hz / 1000000 + 2) / 8;
> +	}
> +
> +	core->spi = spi;
> +
> +	spi->bits_per_word = 8;
> +
> +	err = spi_setup(spi);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> +		return err;
> +	}
> +
> +	core->cpuorg_regmap =
> +		ocelot_spi_devm_get_regmap(core, dev,
> +					   &vsc7512_dev_cpuorg_resource);
> +	if (IS_ERR(core->cpuorg_regmap))
> +		return -ENOMEM;
> +
> +	core->dev = dev;
> +
> +	/*
> +	 * The chip must be set up for SPI before it gets initialized and reset.
> +	 * This must be done before calling init, and after a chip reset is
> +	 * performed.
> +	 */
> +	err = ocelot_spi_initialize(core);
> +	if (err) {
> +		dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> +		return err;
> +	}
> +
> +	err = ocelot_core_init(core);
> +	if (err < 0) {
> +		dev_err(dev, "Error %d initializing Ocelot MFD\n", err);
> +		return err;
> +	}
> +
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
> +};
> +module_spi_driver(ocelot_spi_driver);
> +
> +MODULE_DESCRIPTION("SPI Controlled Ocelot Chip Driver");
> +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> +MODULE_LICENSE("Dual MIT/GPL");
> diff --git a/drivers/mfd/ocelot.h b/drivers/mfd/ocelot.h
> new file mode 100644
> index 000000000000..20d3853dd6d2
> --- /dev/null
> +++ b/drivers/mfd/ocelot.h
> @@ -0,0 +1,42 @@
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
> +	struct regmap *cpuorg_regmap;
> +
> +#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)

I'd drop this personally.

> +	int spi_padding_bytes;
> +	struct spi_device *spi;
> +#endif
> +};
> +
> +void ocelot_get_resource_name(char *name, const struct resource *res,
> +			      int size);
> +int ocelot_core_init(struct ocelot_core *core);
> +int ocelot_remove(struct ocelot_core *core);

This doesn't appear to be relevant.

> +#if IS_ENABLED(CONFIG_MFD_OCELOT_SPI)
> +struct regmap *ocelot_spi_devm_get_regmap(struct ocelot_core *core,
> +					  struct device *child,
> +					  const struct resource *res);
> +int ocelot_spi_initialize(struct ocelot_core *core);
> +#else
> +static inline struct regmap *ocelot_spi_devm_get_regmap(
> +		struct ocelot_core *core, struct device *child,
> +		const struct resource *res)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int ocelot_spi_initialize(struct ocelot_core *core)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 998616511ffb..d9e2710d5646 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -1018,11 +1018,16 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
>  }
>  #endif
>  
> +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> +struct regmap *ocelot_get_regmap_from_resource(struct device *child,
> +					       const struct resource *res);
> +#else
>  static inline struct regmap *
>  ocelot_get_regmap_from_resource(struct device *child,
>  				const struct resource *res)
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
> +#endif
>  
>  #endif

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
