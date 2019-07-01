Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795B55B6AE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfGAITG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:19:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37820 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfGAITF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 04:19:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id g15so3760649pgi.4;
        Mon, 01 Jul 2019 01:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ENqNJlovAzbtIMDMyEuT6YxQGdhBBs3Nh+LrxQq4GI0=;
        b=dd364buBd+ouEhxHpqNpPkomOOMHJ+9u0FMaw5me+OPu3CSiY0QuGa5VmUQdZLk+Z4
         IB0Svr4Mc6vcovCTBLVAfL6Qr4KBywUL9p3DWssGoc4UjB9mVpKCdIYUFvPMunx21fvm
         Qr06rmuD+1IGJ2j5i2LAqds1F5V9kqxeKsinCdFzpmH9EhHPfDA+Ndug3Qzv2jiYvZuv
         dn0iw1qqwQUxqMIa6B2Uar0Td9ar9Rr0NkNTAOMla8XwX5ryC6AVDIaeOnYCSjR5J7zA
         AihSwjl96Qazoc0DJh4MJtEQOTuUlFH15SC1nmsDYfuu84secHKIsgBE1ljt10uaSj4X
         tGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ENqNJlovAzbtIMDMyEuT6YxQGdhBBs3Nh+LrxQq4GI0=;
        b=YPnQvt46YVFAqLqE1bI4f3wwge56ixBFJdlEHm8qggJbfSXzoeTHv1t5j8Gj/EkP86
         aGFe3o3ool/gFJN7tTU5weff9UhpgqW0HguYjkX3DQ817uaqw4t+ywsfHaPfYQsagWKm
         zqzUBp3cMfi9riQLW8sGD03c7Gd1c3AcmvqOzEkvRuTiOEIsxlcMLB9MR+UV0NTkOOVG
         XrF1A5qn5K0eiwH+U9w+fQqplh1q2ap3aN9K1b3mc30z9Qy4w/gyADpGllV8LRyiutio
         RXahbYG+7K4MHSO6JVxN0indD6eBujb3qcksQ3dVLD94o/CdPSLn/i2fDaqk1a4uqgja
         ZKmA==
X-Gm-Message-State: APjAAAX7BPHu+bxmJELuqtBQUWkrjLa2rSsoWtNq5Qt8POUKdpvcBdaf
        bTAylra2krNvarY6Y1esjbw=
X-Google-Smtp-Source: APXvYqwAiKcJFocYrpTbgg3ZSDAgSgjwkR5cm1zwQU0lsdiTbx4wO0ymCAizzUs48BCIsgtyNwsN0Q==
X-Received: by 2002:a17:90a:c596:: with SMTP id l22mr30069932pjt.46.1561969144292;
        Mon, 01 Jul 2019 01:19:04 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id r188sm12219235pfr.16.2019.07.01.01.19.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 01:19:03 -0700 (PDT)
Date:   Mon, 1 Jul 2019 01:19:01 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 7/7] Input: add IOC3 serio driver
Message-ID: <20190701081901.GE172968@dtor-ws>
References: <20190613170636.6647-1-tbogendoerfer@suse.de>
 <20190613170636.6647-8-tbogendoerfer@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613170636.6647-8-tbogendoerfer@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Thu, Jun 13, 2019 at 07:06:33PM +0200, Thomas Bogendoerfer wrote:
> This patch adds a platform driver for supporting keyboard and mouse
> interface of SGI IOC3 chips.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  drivers/input/serio/Kconfig   |  10 +++
>  drivers/input/serio/Makefile  |   1 +
>  drivers/input/serio/ioc3kbd.c | 158 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 169 insertions(+)
>  create mode 100644 drivers/input/serio/ioc3kbd.c
> 
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index f3e18f8ef9ca..373a1646019e 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -165,6 +165,16 @@ config SERIO_MACEPS2
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called maceps2.
>  
> +config SERIO_SGI_IOC3
> +	tristate "SGI IOC3 PS/2 controller"
> +	depends on SGI_MFD_IOC3
> +	help
> +	  Say Y here if you have an SGI Onyx2, SGI Octane or IOC3 PCI card
> +	  and you want to attach and use a keyboard, mouse, or both.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ioc3kbd.
> +
>  config SERIO_LIBPS2
>  	tristate "PS/2 driver library"
>  	depends on SERIO_I8042 || SERIO_I8042=n
> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
> index 67950a5ccb3f..6d97bad7b844 100644
> --- a/drivers/input/serio/Makefile
> +++ b/drivers/input/serio/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_HIL_MLC)		+= hp_sdc_mlc.o hil_mlc.o
>  obj-$(CONFIG_SERIO_PCIPS2)	+= pcips2.o
>  obj-$(CONFIG_SERIO_PS2MULT)	+= ps2mult.o
>  obj-$(CONFIG_SERIO_MACEPS2)	+= maceps2.o
> +obj-$(CONFIG_SERIO_SGI_IOC3)	+= ioc3kbd.o
>  obj-$(CONFIG_SERIO_LIBPS2)	+= libps2.o
>  obj-$(CONFIG_SERIO_RAW)		+= serio_raw.o
>  obj-$(CONFIG_SERIO_AMS_DELTA)	+= ams_delta_serio.o
> diff --git a/drivers/input/serio/ioc3kbd.c b/drivers/input/serio/ioc3kbd.c
> new file mode 100644
> index 000000000000..26fcf57465d6
> --- /dev/null
> +++ b/drivers/input/serio/ioc3kbd.c
> @@ -0,0 +1,158 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * SGI IOC3 PS/2 controller driver for linux
> + *
> + * Copyright (C) 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
> + *
> + * Based on code Copyright (C) 2005 Stanislaw Skowronek <skylark@unaligned.org>
> + *               Copyright (C) 2009 Johannes Dickgreber <tanzy@gmx.de>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/serio.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/sn/ioc3.h>
> +
> +struct ioc3kbd_data {
> +	struct ioc3_serioregs __iomem *regs;
> +	struct serio *kbd, *aux;
> +};
> +
> +static int ioc3kbd_write(struct serio *dev, u8 val)
> +{
> +	struct ioc3kbd_data *d = dev->port_data;
> +	unsigned long timeout = 0;
> +	u32 mask;
> +
> +	mask = (dev == d->aux) ? KM_CSR_M_WRT_PEND : KM_CSR_K_WRT_PEND;
> +	while ((readl(&d->regs->km_csr) & mask) && (timeout < 1000)) {
> +		udelay(100);
> +		timeout++;
> +	}
> +
> +	if (timeout >= 1000)
> +		return -1;

-ETIMEDOUT?

> +
> +	writel(val, dev == d->aux ?  &d->regs->m_wd : &d->regs->k_wd);

Nit: there are 2 spaces after ?, only one is needed.

> +
> +	return 0;
> +}
> +
> +static irqreturn_t ioc3kbd_intr(int itq, void *dev_id)
> +{
> +	struct ioc3kbd_data *d = dev_id;
> +	u32 data_k, data_m;
> +
> +	data_k = readl(&d->regs->k_rd);
> +	data_m = readl(&d->regs->m_rd);
> +
> +	if (data_k & KM_RD_VALID_0)
> +		serio_interrupt(d->kbd,
> +		(data_k >> KM_RD_DATA_0_SHIFT) & 0xff, 0);

This is weird formatting, you need one more tab here.

> +	if (data_k & KM_RD_VALID_1)
> +		serio_interrupt(d->kbd,
> +		(data_k >> KM_RD_DATA_1_SHIFT) & 0xff, 0);
> +	if (data_k & KM_RD_VALID_2)
> +		serio_interrupt(d->kbd,
> +		(data_k >> KM_RD_DATA_2_SHIFT) & 0xff, 0);
> +	if (data_m & KM_RD_VALID_0)
> +		serio_interrupt(d->aux,
> +		(data_m >> KM_RD_DATA_0_SHIFT) & 0xff, 0);
> +	if (data_m & KM_RD_VALID_1)
> +		serio_interrupt(d->aux,
> +		(data_m >> KM_RD_DATA_1_SHIFT) & 0xff, 0);
> +	if (data_m & KM_RD_VALID_2)
> +		serio_interrupt(d->aux,
> +		(data_m >> KM_RD_DATA_2_SHIFT) & 0xff, 0);
> +
> +	return 0;
> +}
> +
> +static int ioc3kbd_probe(struct platform_device *pdev)
> +{
> +	struct ioc3_serioregs __iomem *regs;
> +	struct device *dev = &pdev->dev;
> +	struct ioc3kbd_data *d;
> +	struct serio *sk, *sa;
> +	struct resource *mem;
> +	int irq, ret;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	regs = devm_ioremap_resource(&pdev->dev, mem);

We have a brand new helper: devm_platform_ioremap_resource()

> +	if (IS_ERR(regs))
> +		return PTR_ERR(regs);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return -ENXIO;
> +
> +	d = devm_kzalloc(&pdev->dev, sizeof(struct ioc3kbd_data), GFP_KERNEL);

I think we nor prefer deriving type from the pointer:

	d = evm_kzalloc(&pdev->dev, sizeof(*d), GFP_KERNEL);

> +	if (!d)
> +		return -ENOMEM;
> +
> +	ret = devm_request_irq(&pdev->dev, irq, ioc3kbd_intr, IRQF_SHARED,
> +			       "ioc3-kbd", d);
> +	if (ret) {
> +		dev_err(&pdev->dev, "could not request IRQ %d\n", irq);
> +		return ret;
> +	}

You need to make sure that interrupt will not fire while serio ports are
not yet allocated/registered. Is there a way to inhibit interrupt
generation on controller side?

> +
> +	sk = kzalloc(sizeof(struct serio), GFP_KERNEL);

	sk = kzalloc(sizeof(*sk), GFP_KERNEL);

> +	if (!sk)
> +		return -ENOMEM;
> +
> +	sa = kzalloc(sizeof(struct serio), GFP_KERNEL);

	sa = kzalloc(sizeof(*sa), GFP_KERNEL);

> +	if (!sa) {
> +		kfree(sk);
> +		return -ENOMEM;
> +	}
> +
> +	sk->id.type = SERIO_8042;
> +	sk->write = ioc3kbd_write;
> +	snprintf(sk->name, sizeof(sk->name), "IOC3 keyboard %d", pdev->id);
> +	snprintf(sk->phys, sizeof(sk->phys), "ioc3/serio%dkbd", pdev->id);
> +	sk->port_data = d;
> +	sk->dev.parent = &pdev->dev;
> +
> +	sa->id.type = SERIO_8042;
> +	sa->write = ioc3kbd_write;
> +	snprintf(sa->name, sizeof(sa->name), "IOC3 auxiliary %d", pdev->id);
> +	snprintf(sa->phys, sizeof(sa->phys), "ioc3/serio%daux", pdev->id);
> +	sa->port_data = d;
> +	sa->dev.parent = dev;
> +
> +	d->regs = regs;
> +	d->kbd = sk;
> +	d->aux = sa;
> +
> +	platform_set_drvdata(pdev, d);
> +	serio_register_port(d->kbd);
> +	serio_register_port(d->aux);
> +	return 0;
> +}
> +
> +static int ioc3kbd_remove(struct platform_device *pdev)
> +{
> +	struct ioc3kbd_data *d = platform_get_drvdata(pdev);
> +
> +	serio_unregister_port(d->kbd);
> +	serio_unregister_port(d->aux);

If you unregister ports while interrupt is registered/enabled you may
get a crash.

> +	return 0;
> +}
> +
> +static struct platform_driver ioc3kbd_driver = {
> +	.probe          = ioc3kbd_probe,
> +	.remove         = ioc3kbd_remove,
> +	.driver = {
> +		.name = "ioc3-kbd",
> +	},
> +};
> +module_platform_driver(ioc3kbd_driver);
> +
> +MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfer@suse.de>");
> +MODULE_DESCRIPTION("SGI IOC3 serio driver");
> +MODULE_LICENSE("GPL");
> -- 
> 2.13.7
> 

-- 
Dmitry
