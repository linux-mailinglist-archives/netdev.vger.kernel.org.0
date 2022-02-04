Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C534A98EF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 13:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358428AbiBDMHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 07:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiBDMHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 07:07:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D3AC061714;
        Fri,  4 Feb 2022 04:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/R6k+zfCQLtzC5fphtSolIP5mV88jokWbtj5V/Bndfo=; b=vV7FwD6+1HFcDi0WBK1n+WSa7j
        6nwzQzVzi5+eBGfJjLkVBTDdciJmM/ODHbnAIn87wlDZaVGFppfZ+kIcVCeEP48y2KiwVKc1CXNfQ
        HwbFgydFmju4PHbiyUdIr78S1W5mmqAZMOHdMJ60inw6Pv5vWMco470p1tf3mR8GjcuActvmp9Gnr
        Z9+xF0g185xIO5+pwflcRJvACgdLLsPqZdl98F1xB1/Oqr2qR03hqug7ilKFZdiBMIRSQqoHVRy6N
        J+0BDyiJuXcdfPlkRiuNVwP3B59jQ/pap32T5wWhmLteCCuu+rRjcExlmQpfogonB4SlWXln36qcV
        sZ5TRa+A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57036)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFxLl-0004VH-H0; Fri, 04 Feb 2022 12:06:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFxLX-0004xK-P8; Fri, 04 Feb 2022 12:05:47 +0000
Date:   Fri, 4 Feb 2022 12:05:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     nick.hawkins@hpe.com
Cc:     verdun@hpe.com, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Corey Minyard <minyard@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Stanislav Jakubek <stano.jakubek@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Hao Fang <fanghao11@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Wang Kefeng <wangkefeng.wang@huawei.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] HPE BMC GXP SUPPORT
Message-ID: <Yf0Wm1kOV1Pss9HJ@shell.armlinux.org.uk>
References: <nick.hawkins@hpe.com>
 <20220202165315.18282-1-nick.hawkins@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202165315.18282-1-nick.hawkins@hpe.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Feb 02, 2022 at 10:52:50AM -0600, nick.hawkins@hpe.com wrote:
> diff --git a/arch/arm/mach-hpe/Makefile b/arch/arm/mach-hpe/Makefile
> new file mode 100644
> index 000000000000..8b0a91234df4
> --- /dev/null
> +++ b/arch/arm/mach-hpe/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_ARCH_HPE_GXP) += gxp.o
> diff --git a/arch/arm/mach-hpe/gxp.c b/arch/arm/mach-hpe/gxp.c
> new file mode 100644
> index 000000000000..a37838247948
> --- /dev/null
> +++ b/arch/arm/mach-hpe/gxp.c
> @@ -0,0 +1,62 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2022 Hewlett-Packard Enterprise Development Company, L.P.
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +
> +#include <linux/init.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clocksource.h>

It's normal to list all linux/ includes before asm/ includes. Please
rearrange.

> +
> +#define IOP_REGS_PHYS_BASE 0xc0000000
> +#define IOP_REGS_VIRT_BASE 0xf0000000
> +#define IOP_REGS_SIZE (240*SZ_1M)
> +
> +#define IOP_EHCI_USBCMD 0x0efe0010
> +
> +static struct map_desc gxp_io_desc[] __initdata = {
> +	{
> +	.virtual	= (unsigned long)IOP_REGS_VIRT_BASE,
> +	.pfn		= __phys_to_pfn(IOP_REGS_PHYS_BASE),
> +	.length		= IOP_REGS_SIZE,
> +	.type		= MT_DEVICE,

If you keep this, please indent the above four lines by one more tab.

> +	},
> +};
> +
> +void __init gxp_map_io(void)
> +{
> +	iotable_init(gxp_io_desc, ARRAY_SIZE(gxp_io_desc));
> +}
> +
> +static void __init gxp_dt_init(void)
> +{
> +	/*reset EHCI host controller for clear start*/
> +	__raw_writel(0x00080002,
> +		(void __iomem *)(IOP_REGS_VIRT_BASE + IOP_EHCI_USBCMD));

Please consider making IOP_REGS_VIRT_BASE a 'void __iomem' pointer, it
being a _virtual_ iomem address. This should save you needing repeated
casts except for the initialiser above.

> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}
> +
> +static void gxp_restart(enum reboot_mode mode, const char *cmd)
> +{
> +	__raw_writel(1, (void __iomem *) IOP_REGS_VIRT_BASE);
> +}
> +
> +static const char * const gxp_board_dt_compat[] = {
> +	"HPE,GXP",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(GXP_DT, "HPE GXP")
> +	.init_machine	= gxp_dt_init,
> +	.map_io		= gxp_map_io,
> +	.restart	= gxp_restart,
> +	.dt_compat	= gxp_board_dt_compat,
> +MACHINE_END
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index cfb8ea0df3b1..5916dade7608 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -617,6 +617,14 @@ config CLKSRC_ST_LPC
>  	  Enable this option to use the Low Power controller timer
>  	  as clocksource.
>  
> +config GXP_TIMER
> +	bool "GXP timer driver"
> +	depends on ARCH_HPE
> +	default y
> +	help
> +	  Provides a driver for the timer control found on HPE
> +	  GXP SOCs. This is required for all GXP SOCs.
> +
>  config ATCPIT100_TIMER
>  	bool "ATCPIT100 timer driver"
>  	depends on NDS32 || COMPILE_TEST
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> index fa5f624eadb6..ffca09ec34de 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -89,3 +89,4 @@ obj-$(CONFIG_GX6605S_TIMER)		+= timer-gx6605s.o
>  obj-$(CONFIG_HYPERV_TIMER)		+= hyperv_timer.o
>  obj-$(CONFIG_MICROCHIP_PIT64B)		+= timer-microchip-pit64b.o
>  obj-$(CONFIG_MSC313E_TIMER)		+= timer-msc313e.o
> +obj-$(CONFIG_GXP_TIMER)			+= gxp_timer.o
> diff --git a/drivers/clocksource/gxp_timer.c b/drivers/clocksource/gxp_timer.c
> new file mode 100644
> index 000000000000..e3c617036e0d
> --- /dev/null
> +++ b/drivers/clocksource/gxp_timer.c
> @@ -0,0 +1,158 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2022 Hewlett-Packard Enterprise Development Company, L.P.
> + *
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/bitops.h>
> +#include <linux/clockchips.h>
> +#include <linux/clocksource.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqreturn.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/sched_clock.h>
> +
> +#include <asm/irq.h>

Why do you need asm/irq.h ?

> +
> +#define TIMER0_FREQ 1000000
> +#define TIMER1_FREQ 1000000
> +
> +#define MASK_TCS_ENABLE		0x01
> +#define MASK_TCS_PERIOD		0x02
> +#define MASK_TCS_RELOAD		0x04
> +#define MASK_TCS_TC		0x80
> +
> +struct gxp_timer {
> +	void __iomem *counter;
> +	void __iomem *control;
> +	struct clock_event_device evt;
> +};
> +
> +static void __iomem *system_clock __read_mostly;
> +
> +static u64 notrace gxp_sched_read(void)
> +{
> +	return readl_relaxed(system_clock);
> +}
> +
> +static int gxp_time_set_next_event(unsigned long event,
> +					struct clock_event_device *evt_dev)
> +{
> +	struct gxp_timer *timer = container_of(evt_dev, struct gxp_timer, evt);
> +	/*clear TC by write 1 and disable timer int and counting*/
> +	writeb_relaxed(MASK_TCS_TC, timer->control);
> +	/*update counter value*/
> +	writel_relaxed(event, timer->counter);
> +	/*enable timer counting and int*/
> +	writeb_relaxed(MASK_TCS_TC|MASK_TCS_ENABLE, timer->control);

Spaces around the | please. checkpatch probably should've noticed that.

> +
> +	return 0;
> +}
> +
> +static irqreturn_t gxp_time_interrupt(int irq, void *dev_id)
> +{
> +	struct gxp_timer *timer = dev_id;
> +	void (*event_handler)(struct clock_event_device *timer);
> +
> +

One too many blank lines.

> +	if (readb_relaxed(timer->control) & MASK_TCS_TC) {
> +		writeb_relaxed(MASK_TCS_TC, timer->control);
> +
> +		event_handler = READ_ONCE(timer->evt.event_handler);
> +		if (event_handler)
> +			event_handler(&timer->evt);
> +		return IRQ_HANDLED;
> +	} else {
> +		return IRQ_NONE;
> +	}
> +}
> +
> +static int __init gxp_timer_init(struct device_node *node)
> +{
> +	void __iomem *base_counter;
> +	void __iomem *base_control;
> +	u32 freq;
> +	int ret, irq;
> +	struct gxp_timer *gxp_timer;
> +
> +	base_counter = of_iomap(node, 0);
> +	if (!base_counter) {
> +		pr_err("Can't remap counter registers");
> +		return -ENXIO;
> +	}
> +
> +	base_control = of_iomap(node, 1);
> +	if (!base_control) {
> +		pr_err("Can't remap control registers");

iounmap base_counter?

> +		return -ENXIO;
> +	}
> +
> +	system_clock = of_iomap(node, 2);
> +	if (!system_clock) {
> +		pr_err("Can't remap control registers");

iounmap base_counter and base_control?

> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(node, "clock-frequency", &freq)) {
> +		pr_err("Can't read clock-frequency\n");
> +		goto err_iounmap;
> +	}
> +
> +	sched_clock_register(gxp_sched_read, 32, freq);
> +	clocksource_mmio_init(system_clock, node->name, freq,
> +				300, 32, clocksource_mmio_readl_up);

We normally align continutation lines in function arguments to the
opening ( thusly:

	clocksource_mmio_init(system_clock, node->name, freq,
			      300, 32, clocksource_mmio_readl_up);

> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (irq <= 0) {
> +		ret = -EINVAL;
> +		pr_err("GXP Timer Can't parse IRQ %d", irq);
> +		goto err_iounmap;
> +	}
> +
> +	gxp_timer = kzalloc(sizeof(*gxp_timer), GFP_KERNEL);
> +	if (!gxp_timer) {
> +		ret = -ENOMEM;
> +		goto err_iounmap;
> +	}
> +
> +	gxp_timer->counter = base_counter;
> +	gxp_timer->control = base_control;
> +	gxp_timer->evt.name = node->name;
> +	gxp_timer->evt.rating = 300;
> +	gxp_timer->evt.features = CLOCK_EVT_FEAT_ONESHOT;
> +	gxp_timer->evt.set_next_event = gxp_time_set_next_event;
> +	gxp_timer->evt.cpumask = cpumask_of(0);
> +
> +	if (request_irq(irq, gxp_time_interrupt, IRQF_TIMER | IRQF_SHARED,
> +		node->name, gxp_timer)) {

Again:

	if (request_irq(irq, gxp_time_interrupt, IRQF_TIMER | IRQF_SHARED,
			node->name, gxp_timer)) {

> +		pr_err("%s: request_irq() failed\n", "GXP Timer Tick");

Consider storing the error code from request_irq() and printing it here.
So:

	err = request_irq(...);
	if (err) {
		pr_err("%s: request_irq() failed: %pe\n", "GXP Timer Tick",
		       ERR_PTR(err));

> +		goto err_timer_free;
> +	}
> +
> +	clockevents_config_and_register(&gxp_timer->evt, TIMER0_FREQ,
> +					0xf, 0xffffffff);
> +
> +	pr_info("gxp: system timer (irq = %d)\n", irq);
> +	return 0;
> +
> +
> +err_timer_free:
> +	kfree(gxp_timer);
> +
> +err_iounmap:
> +	iounmap(system_clock);
> +	iounmap(base_control);
> +	iounmap(base_counter);
> +	return ret;
> +}
> +
> +TIMER_OF_DECLARE(gxp, "hpe,gxp-timer", gxp_timer_init);

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
