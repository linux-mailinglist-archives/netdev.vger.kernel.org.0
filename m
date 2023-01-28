Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9091167F953
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjA1P6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjA1P6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E081298DA;
        Sat, 28 Jan 2023 07:58:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 816D460C23;
        Sat, 28 Jan 2023 15:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC8FC433D2;
        Sat, 28 Jan 2023 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674921508;
        bh=7R+Y0pFZ9qQaQE2Of8Zyt01fF+w51NH/3ezIsAynqvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d4enHA5MJ371GrPucjk++EVvYqWfJUb0Rmdj7ygsHD6FdJSuKLpmLKZObRmyoduRb
         F7/rgXbXthLnxMVJdAyroI/3tQf7IL+wc3TYMiY9DLLWZ9lgFPGplKFOxflb3tFuNt
         UtYcUlsjz0il95gmiB3mk4Bvk/TbRiYPJ9FjEivIPmpDedLPGd1WcinaLHdellNT7Y
         g/L7fp8K98T+nO5sT29tqenfN8c3UVjvN0Ncbjl4SfTpSGVwHHakRtS6Y7/70MN4yc
         AsRCXMaJ9yLeFgwHKcot/dcC5xFelUPaBwh2MZkhTt1C1Gr3icbGZaQVBWurLjEUVb
         0mCC0mntbHQgQ==
Date:   Sat, 28 Jan 2023 16:12:17 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     <Oleksii_Moisieiev@epam.com>, <gregkh@linuxfoundation.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <alexandre.torgue@foss.st.com>, <vkoul@kernel.org>,
        <olivier.moysan@foss.st.com>, <arnaud.pouliquen@foss.st.com>,
        <mchehab@kernel.org>, <fabrice.gasnier@foss.st.com>,
        <ulf.hansson@linaro.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Loic PALLARDY <loic.pallardy@st.com>
Subject: Re: [PATCH v3 4/6] bus: stm32_sys_bus: add support for STM32MP15
 and STM32MP13 system bus
Message-ID: <20230128161217.0e79436e@jic23-huawei>
In-Reply-To: <20230127164040.1047583-5-gatien.chevallier@foss.st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
        <20230127164040.1047583-5-gatien.chevallier@foss.st.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 17:40:38 +0100
Gatien Chevallier <gatien.chevallier@foss.st.com> wrote:

> This driver is checking the access rights of the different
> peripherals connected to the system bus. If access is denied,
> the associated device tree node is skipped so the platform bus
> does not probe it.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Signed-off-by: Loic PALLARDY <loic.pallardy@st.com>

Hi Gatien,

A few comments inline,

Thanks,

Jonathan

> diff --git a/drivers/bus/stm32_sys_bus.c b/drivers/bus/stm32_sys_bus.c
> new file mode 100644
> index 000000000000..c12926466bae
> --- /dev/null
> +++ b/drivers/bus/stm32_sys_bus.c
> @@ -0,0 +1,168 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023, STMicroelectronics - All Rights Reserved
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +
> +/* ETZPC peripheral as firewall bus */
> +/* ETZPC registers */
> +#define ETZPC_DECPROT			0x10
> +
> +/* ETZPC miscellaneous */
> +#define ETZPC_PROT_MASK			GENMASK(1, 0)
> +#define ETZPC_PROT_A7NS			0x3
> +#define ETZPC_DECPROT_SHIFT		1

This define makes the code harder to read.  What we care about is
the number of bits in the register divided by number of entries.
(which is 2) hence the shift by 1. See below for more on this.


> +
> +#define IDS_PER_DECPROT_REGS		16

> +#define STM32MP15_ETZPC_ENTRIES		96
> +#define STM32MP13_ETZPC_ENTRIES		64

These defines just make the code harder to check.
They aren't magic numbers, but rather just telling us how many
entries there are, so I would just put them in the structures directly.
Their use make it clear what they are without needing to give them a name.


> +struct stm32_sys_bus_match_data {

Comment on naming of this below.

> +	unsigned int max_entries;
> +};
> +

+static int stm32_etzpc_get_access(struct sys_bus_data *pdata, struct device_node *np)
+{
+	int err;
+	u32 offset, reg_offset, sec_val, id;
+
+	err = stm32_sys_bus_get_periph_id(pdata, np, &id);
+	if (err)
+		return err;
+
+	/* Check access configuration, 16 peripherals per register */
+	reg_offset = ETZPC_DECPROT + 0x4 * (id / IDS_PER_DECPROT_REGS);
+	offset = (id % IDS_PER_DECPROT_REGS) << ETZPC_DECPROT_SHIFT;

Use of defines in here is actively unhelpful when it comes to review. I would suggest letting
the maths be self explanatory (even if it's more code).

	offset = (id % IDS_PER_DECPROT_REGS) * (sizeof(u32) * BITS_PER_BYTE / IDS_PER_DECPROT_REGS);

Or if you prefer have a define of

#define DECPROT_BITS_PER_ID (sizeof(u32) * BITS_PER_BYTE / IDS_PER_DECPROT_REGS)

and
	offset = (id % IDS_PER_DECPROT_REGS) * DECPROT_BITS_PER_ID;

+
+	/* Verify peripheral is non-secure and attributed to cortex A7 */
+	sec_val = (readl(pdata->sys_bus_base + reg_offset) >> offset) & ETZPC_PROT_MASK;
+	if (sec_val != ETZPC_PROT_A7NS) {
+		dev_dbg(pdata->dev, "Invalid bus configuration: reg_offset %#x, value %d\n",
+			reg_offset, sec_val);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
...

> +static int stm32_sys_bus_probe(struct platform_device *pdev)
> +{
> +	struct sys_bus_data *pdata;
> +	void __iomem *mmio;
> +	struct device_node *np = pdev->dev.of_node;

I'd be consistent. You use dev_of_node() accessor elsewhere, so should
use it here as well.

> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	mmio = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(mmio))
> +		return PTR_ERR(mmio);
> +
> +	pdata->sys_bus_base = mmio;
> +	pdata->pconf = of_device_get_match_data(&pdev->dev);
> +	pdata->dev = &pdev->dev;
> +
> +	platform_set_drvdata(pdev, pdata);

Does this get used? I can't immediately spot where but maybe I just
missed it.

> +
> +	stm32_sys_bus_populate(pdata);
> +
> +	/* Populate all available nodes */
> +	return of_platform_populate(np, NULL, NULL, &pdev->dev);

As np only used here, I'd not bother with the local variable in this function.

> +}
> +
> +static const struct stm32_sys_bus_match_data stm32mp15_sys_bus_data = {

Naming a structure after where it comes from is a little unusual and
confusion when a given call gets it from somewhere else.

I'd expect it to be named after what sort of thing it contains.
stm32_sys_bus_info or something like that.

> +	.max_entries = STM32MP15_ETZPC_ENTRIES,
> +};
> +
> +static const struct stm32_sys_bus_match_data stm32mp13_sys_bus_data = {
> +	.max_entries = STM32MP13_ETZPC_ENTRIES,
> +};
> +
> +static const struct of_device_id stm32_sys_bus_of_match[] = {
> +	{ .compatible = "st,stm32mp15-sys-bus", .data = &stm32mp15_sys_bus_data },
> +	{ .compatible = "st,stm32mp13-sys-bus", .data = &stm32mp13_sys_bus_data },

Alphabetical order usually preferred when there isn't a strong reason for
another choice.

> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, stm32_sys_bus_of_match);
> +
> +static struct platform_driver stm32_sys_bus_driver = {
> +	.probe  = stm32_sys_bus_probe,
> +	.driver = {
> +		.name = "stm32-sys-bus",
> +		.of_match_table = stm32_sys_bus_of_match,
> +	},
> +};
> +
> +static int __init stm32_sys_bus_init(void)
> +{
> +	return platform_driver_register(&stm32_sys_bus_driver);
> +}
> +arch_initcall(stm32_sys_bus_init);
> +

Unwanted trailing blank line.


