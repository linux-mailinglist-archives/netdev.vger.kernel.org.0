Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89DC506771
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 11:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350316AbiDSJJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 05:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350306AbiDSJJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 05:09:53 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C73926562
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 02:07:09 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u17-20020a05600c211100b0038eaf4cdaaeso1093492wml.1
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 02:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Jr5LYCuMTHuyWW7oXOYwjilKqaTnYeuD/6HBySF0F0U=;
        b=Pin0EB9RaTqccFoimDF5PAlGqr085qaRnpu8sNDfYAO6bBHAiLkxTeJZf0dr6P9RLE
         nAezPq9gxcigkH3ZbHjU8WrCDPGKR0mv/sjYIDVMFxjVIzdkureBjwNGhEnZR2gsKKpQ
         3hhJqASxLyoLbxlttOLOmwfF/1aASTvjMqEnULnSQXqI6ssCrVA7ZiVmNWpdQZVerv7s
         Gv1KSPn0rAe7Fj2TsB7KvzmmV3E9Deu2fO6dQwDB7j5Ii+ICOYz7w/FYWPsK9FnFU6Rz
         3/q5Jy5WTY7Ul+262QLXE0Fjwe6wzAiH3pF/uiPwm6+9+wB3jfQF1zzHMov1j7S8Ti5Z
         6KnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Jr5LYCuMTHuyWW7oXOYwjilKqaTnYeuD/6HBySF0F0U=;
        b=j4foz/2O1GTzJ1sz5roBhb9SmwFcxG9fe/eChrka9jdOKG9USwGkK053a19LN8NGdG
         6z5dpaAqLyrXKEtK91sAbdRw4+gaq75HXARTSJ/5mNsgISiOMUTOGE5HejVDMqeooTbD
         P3oELAyrVj6FX5rdQBjImO/2ATWtOoyXy2Jzjb29XwtzyvZ2qOsbDy6c5beuwIdhCszl
         UQqFwSxDoEZ7md5gCqlRqfnEo2I3f5Fv+MIB63ZCRTZLuL81Ncg5PR0/alPAOJUAxYDm
         F6ySTbFEc+obCrdx3mSiZbM7dR+11VL6p7vNJcypCC9cQCM97Fpgf9PHrVe5OH1mCFub
         IQyw==
X-Gm-Message-State: AOAM531DiVkxrl3W8ttSbyLlHFvCV8gm+fKI2SNOmQLxEiJqh3OSpVCY
        rQhR76S3saYOVKHQe52pgtafMQ==
X-Google-Smtp-Source: ABdhPJwBeAsqVSn0EbEcuelkqnVFkuLfCjPXedQC6/2nIBnoFdzLk3DCvxIZ/UD1Y3LYrMhEBPB6pQ==
X-Received: by 2002:a1c:218b:0:b0:38e:aa07:62a8 with SMTP id h133-20020a1c218b000000b0038eaa0762a8mr14938277wmh.172.1650359227815;
        Tue, 19 Apr 2022 02:07:07 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id 9-20020a056000154900b0020a849e1c41sm8803463wry.13.2022.04.19.02.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 02:07:07 -0700 (PDT)
Date:   Tue, 19 Apr 2022 10:07:04 +0100
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
Message-ID: <Yl57uP+rsl/bsI4i@google.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
 <20220307021208.2406741-11-colin.foster@in-advantage.com>
 <YlaKlhiQEWMxJxhU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YlaKlhiQEWMxJxhU@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,WEIRD_QUOTING
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Adding everyone/lists back on Cc]

On Thu, 14 Apr 2022, Colin Foster wrote:

> Hi Lee,
> 
> Thanks for the feedback. I agree with (and have made) your suggestions.
> Additional comments below.

I'm swamped right now, so I cannot do a full re-review, but please see
in-line for a couple of (most likely flippant i.e. not fully
thought out comments).

Please submit the changes you end up making off the back of this
review and I'll conduct another on the next version you send.

> On Wed, Apr 13, 2022 at 09:32:22AM +0100, Lee Jones wrote:
> > On Sun, 06 Mar 2022, Colin Foster wrote:
> > 
> [...]
> > > +
> > > +int ocelot_core_init(struct ocelot_core *core)
> > > +{
> > > +	struct device *dev = core->dev;
> > > +	int ret;
> > > +
> > > +	dev_set_drvdata(dev, core);
> > > +
> > > +	core->gcb_regmap = ocelot_devm_regmap_init(core, dev,
> > > +						   &vsc7512_gcb_resource);
> > 
> > This just ends up calling ocelot_spi_devm_get_regmap() right?
> > 
> > Why not call that from inside ocelot-spi.c where 'core' was allocated?
> 
> core->gcb_regmap doesn't handle anything more than chip reset. This will
> have to happen regardless of the interface.
> 
> The "spi" part uses the core->cpuorg_regmap, which is needed for
> configuring the SPI bus. In the case of I2C, this cpu_org regmap
> (likely?) wouldn't be necessary, but the gcb_regmap absolutely would.
> That's why gcb is allocated in core and cpuorg is allocated in SPI.
> 
> The previous RFC had cpuorg_regmap hidden inside a private struct to
> emphasize this separation. As you pointed out, there was a lot of
> bouncing between "core" structs and "spi" structs that got ugly.
> 
> (Looking at this more now... the value of cpuorg_regmap should have been
> in the CONFIG_MFD_OCELOT_SPI ifdef, which might have made this
> distinction more clear)

The TL;DR of my review point would be to make this as simple as
possible.  If you can call a single function, instead of needlessly
sending the thread of execution through three, please do.

> > > +	if (IS_ERR(core->gcb_regmap))
> > > +		return -ENOMEM;
> > > +
> > > +	ret = ocelot_reset(core);
> > > +	if (ret) {
> > > +		dev_err(dev, "Failed to reset device: %d\n", ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	/*
> > > +	 * A chip reset will clear the SPI configuration, so it needs to be done
> > > +	 * again before we can access any registers
> > > +	 */
> > > +	ret = ocelot_spi_initialize(core);
> > 
> > Not a fan of calling back into the file which called us.
> > 
> > And what happens if SPI isn't controlling us?
> > 
> > Doesn't the documentation above say this device can also be
> > communicated with via I2C and PCIe?
> 
> During the last RFC this was done through a callback. You had requested
> I not use callbacks.
> 
> From that exchange:
> """"
> > > > +	ret = core->config->init_bus(core->config);
> > >
> > > You're not writing a bus.  I doubt you need ops call-backs.
> >
> > In the case of SPI, the chip needs to be configured both before and
> > after reset. It sets up the bus for endianness, padding bytes, etc. This
> > is currently achieved by running "ocelot_spi_init_bus" once during SPI
> > probe, and once immediately after chip reset.
> >
> > For other control mediums I doubt this is necessary. Perhaps "init_bus"
> > is a misnomer in this scenario...
> 
> Please find a clearer way to do this without function pointers.
> """"

Yes, I remember.

This is an improvement on that, but it doesn't mean it's ideal.

> The idea is that we set up the SPI bus so we can read registers. The
> protocol changes based on bus speed, so this is necessary.
> 
> This initial setup is done in ocelot-spi.c, before ocelot_core_init is
> called.
> 
> We then reset the chip by writing some registers. This chip reset also
> clears the SPI configuration, so we need to reconfigure the SPI bus
> before we can read any additional registers.
> 
> Short of using function pointers, I imagine this will have to be
> something akin to:
> 
> if (core->is_spi) {
>     ocelot_spi_initalize();
> }

What about if, instead of calling from SPI into Core, which calls back
into SPI again, you do this from SPI instead:

[flippant - I haven't fully assessed the viability of this suggestion]

foo_type spi_probe(bar_type baz)
{
  setup_spi();

  core_init();

  more_spi_stuff();
}

> I feel if the additional buses are added, they'll have to implement this
> type of change. But as I don't (and don't plan to) have hardware to
> build those interfaces out, right now ocelot_core assumes the bus is
> SPI.

What are the chances of someone else coming along and implementing the
other interfaces?  You might very well be over-complicating this
implementation for support that may never be required.

> > > +	if (ret) {
> > > +		dev_err(dev, "Failed to initialize SPI interface: %d\n", ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> > > +				   ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> > > +	if (ret) {
> > > +		dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL(ocelot_core_init);
> > > +
> > > +MODULE_DESCRIPTION("Externally Controlled Ocelot Chip Driver");
> > > +MODULE_AUTHOR("Colin Foster <colin.foster@in-advantage.com>");
> > > +MODULE_LICENSE("GPL v2");
> > > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > > new file mode 100644
> > > index 000000000000..c788e239c9a7
> > > --- /dev/null
> > > +++ b/drivers/mfd/ocelot-spi.c
> > > @@ -0,0 +1,313 @@
> > > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > > +/*
> > > + * SPI core driver for the Ocelot chip family.
> > > + *
> > > + * This driver will handle everything necessary to allow for communication over
> > > + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> > > + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> > > + * processor's endianness. This will create and distribute regmaps for any MFD
> > 
> > As above, please drop references to MFD.
> > 
> > > + * children.
> > > + *
> > > + * Copyright 2021 Innovative Advantage Inc.
> > > + *
> > > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > > + */
> > > +
> > > +#include <linux/iopoll.h>
> > > +#include <linux/kconfig.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > > +#include <linux/regmap.h>
> > > +#include <linux/spi/spi.h>
> > > +
> > > +#include <asm/byteorder.h>
> > > +
> > > +#include "ocelot.h"
> > > +
> > > +#define DEV_CPUORG_IF_CTRL	0x0000
> > > +#define DEV_CPUORG_IF_CFGSTAT	0x0004
> > > +
> > > +#define CFGSTAT_IF_NUM_VCORE	(0 << 24)
> > > +#define CFGSTAT_IF_NUM_VRAP	(1 << 24)
> > > +#define CFGSTAT_IF_NUM_SI	(2 << 24)
> > > +#define CFGSTAT_IF_NUM_MIIM	(3 << 24)
> > > +
> > > +
> > > +static const struct resource vsc7512_dev_cpuorg_resource = {
> > > +	.start	= 0x71000000,
> > > +	.end	= 0x710002ff,
> > 
> > No magic numbers.  Please define these addresses.
> 
> I missed these. Thanks.
> 
> > 
> > > +	.name	= "devcpu_org",
> > > +};
> > > +
> > > +#define VSC7512_BYTE_ORDER_LE 0x00000000
> > > +#define VSC7512_BYTE_ORDER_BE 0x81818181
> > > +#define VSC7512_BIT_ORDER_MSB 0x00000000
> > > +#define VSC7512_BIT_ORDER_LSB 0x42424242
> > > +
> > > +int ocelot_spi_initialize(struct ocelot_core *core)
> > > +{
> > > +	u32 val, check;
> > > +	int err;
> > > +
> > > +#ifdef __LITTLE_ENDIAN
> > > +	val = VSC7512_BYTE_ORDER_LE;
> > > +#else
> > > +	val = VSC7512_BYTE_ORDER_BE;
> > > +#endif
> > 
> > Not a fan of ifdefery in the middle of C files.
> > 
> > Please create a macro or define somewhere.
> 
> I'll clear this up in comments and move things around. This macro
> specifically tends to lend itself to this type of ifdef dropping:
> 
> https://elixir.bootlin.com/linux/v5.18-rc2/C/ident/__LITTLE_ENDIAN

I see that the majority of implementations exist in header files as I
would expect.  With respect to the others, past acceptance and what is
acceptable in other subsystems has little bearing on what will be
accepted here and now.

> The comment I'm adding is:
>         /*
>          * The SPI address must be big-endian, but we want the payload to match
>          * our CPU. These are two bits (0 and 1) but they're repeated such that
>          * the write from any configuration will be valid. The four
>          * configurations are:
>          *
>          * 0b00: little-endian, MSB first
>          * |            111111   | 22221111 | 33222222 |
>          * | 76543210 | 54321098 | 32109876 | 10987654 |
>          *
>          * 0b01: big-endian, MSB first
>          * | 33222222 | 22221111 | 111111   |          |
>          * | 10987654 | 32109876 | 54321098 | 76543210 |
>          *
>          * 0b10: little-endian, LSB first
>          * |              111111 | 11112222 | 22222233 |
>          * | 01234567 | 89012345 | 67890123 | 45678901 |
>          *
>          * 0b11: big-endian, LSB first
>          * | 22222233 | 11112222 |   111111 |          |
>          * | 45678901 | 67890123 | 89012345 | 01234567 |
>          */
> 
> With this info, would you recommend:
> 1. A file-scope static const at the top of this file
> 2. A macro assigned to one of those sequences
> 3. A function to "detect" which architecture we're running

I do not have a strong opinion.

Just tuck the #iferry away somewhere in a header file.

> > > +	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CTRL, val);
> > > +	if (err)
> > > +		return err;
> > 
> > Comment.
> > 
> > > +	val = core->spi_padding_bytes;
> > > +	err = regmap_write(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, val);
> > > +	if (err)
> > > +		return err;
> > 
> > Comment.
> 
> Adding:
> 
> /*
>  * Apply the number of padding bytes between a read request and the data
>  * payload. Some registers have access times of up to 1us, so if the
>  * first payload bit is shifted out too quickly, the read will fail.
>  */
> 
> > 
> > > +	/*
> > > +	 * After we write the interface configuration, read it back here. This
> > > +	 * will verify several different things. The first is that the number of
> > > +	 * padding bytes actually got written correctly. These are found in bits
> > > +	 * 0:3.
> > > +	 *
> > > +	 * The second is that bit 16 is cleared. Bit 16 is IF_CFGSTAT:IF_STAT,
> > > +	 * and will be set if the register access is too fast. This would be in
> > > +	 * the condition that the number of padding bytes is insufficient for
> > > +	 * the SPI bus frequency.
> > > +	 *
> > > +	 * The last check is for bits 31:24, which define the interface by which
> > > +	 * the registers are being accessed. Since we're accessing them via the
> > > +	 * serial interface, it must return IF_NUM_SI.
> > > +	 */
> > > +	check = val | CFGSTAT_IF_NUM_SI;
> > > +
> > > +	err = regmap_read(core->cpuorg_regmap, DEV_CPUORG_IF_CFGSTAT, &val);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	if (check != val)
> > > +		return -ENODEV;
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL(ocelot_spi_initialize);
> > > +
> > > +/*
> > > + * The SPI protocol for interfacing with the ocelot chips uses 24 bits, while
> > > + * the register locations are defined as 32-bit. The least significant two bits
> > > + * get shifted out, as register accesses must always be word-aligned, leaving
> > > + * bits 21:0 as the 22-bit address. It must always be big-endian, whereas the
> > > + * payload can be optimized for bit / byte order to match whatever architecture
> > > + * the controlling CPU has.
> > > + */
> > > +static unsigned int ocelot_spi_translate_address(unsigned int reg)
> > > +{
> > > +	return cpu_to_be32((reg & 0xffffff) >> 2);
> > > +}
> > > +
> > > +struct ocelot_spi_regmap_context {
> > > +	u32 base;
> > > +	struct ocelot_core *core;
> > > +};
> > > +
> > > +static int ocelot_spi_reg_read(void *context, unsigned int reg,
> > > +			       unsigned int *val)
> > > +{
> > > +	struct ocelot_spi_regmap_context *regmap_context = context;
> > > +	struct ocelot_core *core = regmap_context->core;
> > > +	struct spi_transfer tx, padding, rx;
> > > +	struct spi_message msg;
> > 
> > How big are all of these?
> > 
> > We will receive warnings if they occupy too much stack space.
> 
> Looking at the structs they're on the order of 10s of bytes. Maybe 70
> bytes per instance (back of napkin calculation)
> 
> But it seems very common to stack-allocate spi_transfers:
> 
> https://elixir.bootlin.com/linux/v5.18-rc2/source/drivers/spi/spi.c#L4097
> https://elixir.bootlin.com/linux/v5.18-rc2/source/include/linux/spi/spi.h#L1244
> 
> Do you have a feel for at what point that becomes a concern?

That's fine.  I just want you to bear this in mind.

I wish to prevent adding yet more W=1 level warnings into the kernel.

> > > +	struct spi_device *spi;
> > > +	unsigned int addr;
> > > +	u8 *tx_buf;
> > > +
> > > +	spi = core->spi;
> > > +
> > > +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> > > +	tx_buf = (u8 *)&addr;
> > > +
> > > +	spi_message_init(&msg);
> > > +
> > > +	memset(&tx, 0, sizeof(tx));
> > > +
> > > +	/* Ignore the first byte for the 24-bit address */
> > > +	tx.tx_buf = &tx_buf[1];
> > > +	tx.len = 3;
> > > +
> > > +	spi_message_add_tail(&tx, &msg);
> > > +
> > > +	if (core->spi_padding_bytes > 0) {
> > > +		u8 dummy_buf[16] = {0};
> > > +
> > > +		memset(&padding, 0, sizeof(padding));
> > > +
> > > +		/* Just toggle the clock for padding bytes */
> > > +		padding.len = core->spi_padding_bytes;
> > > +		padding.tx_buf = dummy_buf;
> > > +		padding.dummy_data = 1;
> > > +
> > > +		spi_message_add_tail(&padding, &msg);
> > > +	}
> > > +
> > > +	memset(&rx, 0, sizeof(rx));
> > > +	rx.rx_buf = val;
> > > +	rx.len = 4;
> > > +
> > > +	spi_message_add_tail(&rx, &msg);
> > > +
> > > +	return spi_sync(spi, &msg);
> > > +}
> > > +
> > > +static int ocelot_spi_reg_write(void *context, unsigned int reg,
> > > +				unsigned int val)
> > > +{
> > > +	struct ocelot_spi_regmap_context *regmap_context = context;
> > > +	struct ocelot_core *core = regmap_context->core;
> > > +	struct spi_transfer tx[2] = {0};
> > > +	struct spi_message msg;
> > > +	struct spi_device *spi;
> > > +	unsigned int addr;
> > > +	u8 *tx_buf;
> > > +
> > > +	spi = core->spi;
> > > +
> > > +	addr = ocelot_spi_translate_address(reg + regmap_context->base);
> > > +	tx_buf = (u8 *)&addr;
> > > +
> > > +	spi_message_init(&msg);
> > > +
> > > +	/* Ignore the first byte for the 24-bit address and set the write bit */
> > > +	tx_buf[1] |= BIT(7);
> > > +	tx[0].tx_buf = &tx_buf[1];
> > > +	tx[0].len = 3;
> > > +
> > > +	spi_message_add_tail(&tx[0], &msg);
> > > +
> > > +	memset(&tx[1], 0, sizeof(struct spi_transfer));
> > > +	tx[1].tx_buf = &val;
> > > +	tx[1].len = 4;
> > > +
> > > +	spi_message_add_tail(&tx[1], &msg);
> > > +
> > > +	return spi_sync(spi, &msg);
> > > +}
> > > +
> > > +static const struct regmap_config ocelot_spi_regmap_config = {
> > > +	.reg_bits = 24,
> > > +	.reg_stride = 4,
> > > +	.val_bits = 32,
> > > +
> > > +	.reg_read = ocelot_spi_reg_read,
> > > +	.reg_write = ocelot_spi_reg_write,
> > > +
> > > +	.max_register = 0xffffffff,
> > > +	.use_single_write = true,
> > > +	.use_single_read = true,
> > > +	.can_multi_write = false,
> > > +
> > > +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> > > +	.val_format_endian = REGMAP_ENDIAN_NATIVE,
> > > +};
> > > +
> > > +struct regmap *
> > > +ocelot_spi_devm_get_regmap(struct ocelot_core *core, struct device *child,
> > > +			   const struct resource *res)
> > 
> > This seems to always initialise a new Regmap.
> > 
> > To me 'get' implies that it could fetch an already existing one.
> > 
> > ... and *perhaps* init a new one if none exists..
> 
> That's exactly what my intention was when I started.
> 
> But it seems like *if* that is something that is required, it should be
> done through a syscon / device tree implementation and not be snuck into
> this regmap getter. I was trying to do too much.
> 
> I'm renaming to "init"
> 
> > 
> > > +{
> > > +	struct ocelot_spi_regmap_context *context;
> > > +	struct regmap_config regmap_config;
> > > +
> > > +	context = devm_kzalloc(child, sizeof(*context), GFP_KERNEL);
> > > +	if (IS_ERR(context))
> > > +		return ERR_CAST(context);
> > > +
> > > +	context->base = res->start;
> > > +	context->core = core;
> > > +
> > > +	memcpy(&regmap_config, &ocelot_spi_regmap_config,
> > > +	       sizeof(ocelot_spi_regmap_config));
> > > +
> > > +	regmap_config.name = res->name;
> > > +	regmap_config.max_register = res->end - res->start;
> > > +
> > > +	return devm_regmap_init(child, NULL, context, &regmap_config);
> > > +}
> > > +
> > > +static int ocelot_spi_probe(struct spi_device *spi)
> > > +{
> > > +	struct device *dev = &spi->dev;
> > > +	struct ocelot_core *core;
> > 
> > This would be more in keeping with current drivers if you dropped the
> > '_core' part of the struct name and called the variable ddata.
> 
> There's already a "struct ocelot" defined in include/soc/mscc/ocelot.h.
> I suppose it could be renamed to align with what it actually is: the
> "switch" component of the ocelot chip.
> 
> Vladimir, Alexandre, Horaitu, others:
> Any opinions about this becoming "struct ocelot" and the current struct
> being "struct ocelot_switch"?
> 
> Or maybe a technical / philosophical question: is "ocelot" the switch
> core that can be implemented in other hardware? Or is it the chip family
> entirely, (pinctrl, sgpio, etc.) who's switch core was brought into
> other products?
> 
> The existing struct change would hit about 30 files.
> https://elixir.bootlin.com/linux/v5.18-rc2/C/ident/ocelot

That's not ideal.

Please consider using 'ocelot_ddata' for now and consider a larger
overhaul at a later date, if it makes sense to do so.

[...]

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
