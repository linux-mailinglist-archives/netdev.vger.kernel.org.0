Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8588588
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfHIWEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44533 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729639AbfHIWEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:04:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so46703487pfe.11;
        Fri, 09 Aug 2019 15:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o2KGjmwUbr1cs5TsIsFMJ/0FkhUZd/ApycxTUddQoE0=;
        b=WYG6lBTDqSGni5FHKqhELWRvOsilGlKRAjXJkOYt7wTryC+WDqUuGDpAG+fxZjuAkQ
         sGZt2j1XgC9bgLHSFs4Uw/887666782zqbAkRrKk/oPYdQVyJirBkGr537Ch4IEYD7et
         ihz0lrN5yTLhqPiGKN1aibVcIr7SRprlFVj5bffYm8k5pNfCtfYSs2Y9Q0mtuHmj5TJN
         oWeQKlSx7KOJ+O0ZI+6Z56EFOAVRPnumAMnrAqZoRRTiQmbGyGUjRZmF7qoyJiNpiO0N
         iOMWliORS88/uV9sYQ8b/ab3SXyJXP1rSJGfiS+kxUwyAtiy3xOAwGlI1BOhBwbPuF30
         G52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o2KGjmwUbr1cs5TsIsFMJ/0FkhUZd/ApycxTUddQoE0=;
        b=OwpHel9CnsZKrzuDl+MmFeKr4GI1jlR4aZyBMXKUimzHh4kFfzsXcCZTY8J13Wgw7z
         rGKpkK0ygiU2fxt1gK3g+sh3HydQxJWmI35T6rscjED6GkjDtztSjJxj2tqycG2cUP9W
         5+pGquEtSsuk4dgUZat0PHzH52ivEcQ4zmBLUwxtp91Mg4Mf1Vb04Nv/xyDptYYkBNns
         kn7u/LwHE+HKCAvgUR2hEtnekFpXLihvnvdDa02+zdva37Mj3MfSv9d1LGtbpbjjwAPe
         BU0pBDd+qBFae8Qlmiz2WWIEH8l3cO+9XTIF6pqzHPoO0DFhIPpbtf1a5LNCsrs/9H1p
         C7vA==
X-Gm-Message-State: APjAAAUzmWzO4i38UhhXIMU3uBmpLIo/0Wk9hDIrbMQ8ClR4sn7YWl+Q
        F7fdypwTjiKegZDM7PeTYJY=
X-Google-Smtp-Source: APXvYqyiRrp//J7RveYsA93qftn7Bn/hCBFIPoJL5S/+gF+H3TOULotl9wQ2o5O0LdJ9UpMkLBi2TA==
X-Received: by 2002:a63:590f:: with SMTP id n15mr19481072pgb.190.1565388293082;
        Fri, 09 Aug 2019 15:04:53 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id q22sm96124715pgh.49.2019.08.09.15.04.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:04:52 -0700 (PDT)
Date:   Fri, 9 Aug 2019 15:04:50 -0700
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
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 9/9] Input: add IOC3 serio driver
Message-ID: <20190809220450.GP178933@dtor-ws>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
 <20190809103235.16338-10-tbogendoerfer@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809103235.16338-10-tbogendoerfer@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 12:32:31PM +0200, Thomas Bogendoerfer wrote:
> This patch adds a platform driver for supporting keyboard and mouse
> interface of SGI IOC3 chips.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  drivers/input/serio/Kconfig   |  10 +++
>  drivers/input/serio/Makefile  |   1 +
>  drivers/input/serio/ioc3kbd.c | 163 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+)
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
> index 000000000000..6840e3c23fed
> --- /dev/null
> +++ b/drivers/input/serio/ioc3kbd.c
> @@ -0,0 +1,163 @@
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
> +	int irq;
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
> +		return -ETIMEDOUT;
> +
> +	writel(val, dev == d->aux ? &d->regs->m_wd : &d->regs->k_wd);
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
> +		serio_interrupt(d->kbd, (data_k >> KM_RD_DATA_0_SHIFT) & 0xff,
> +				0);
> +	if (data_k & KM_RD_VALID_1)
> +		serio_interrupt(d->kbd, (data_k >> KM_RD_DATA_1_SHIFT) & 0xff,
> +				0);
> +	if (data_k & KM_RD_VALID_2)
> +		serio_interrupt(d->kbd, (data_k >> KM_RD_DATA_2_SHIFT) & 0xff,
> +				0);
> +	if (data_m & KM_RD_VALID_0)
> +		serio_interrupt(d->aux, (data_m >> KM_RD_DATA_0_SHIFT) & 0xff,
> +				0);
> +	if (data_m & KM_RD_VALID_1)
> +		serio_interrupt(d->aux, (data_m >> KM_RD_DATA_1_SHIFT) & 0xff,
> +				0);
> +	if (data_m & KM_RD_VALID_2)
> +		serio_interrupt(d->aux, (data_m >> KM_RD_DATA_2_SHIFT) & 0xff,
> +				0);
> +
> +	return 0;

IRQ_NONE? Or IRQ_HANDLED?

> +}
> +
> +static int ioc3kbd_probe(struct platform_device *pdev)
> +{
> +	struct ioc3_serioregs __iomem *regs;
> +	struct device *dev = &pdev->dev;
> +	struct ioc3kbd_data *d;
> +	struct serio *sk, *sa;
> +	int irq, ret;
> +
> +	regs = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(regs))
> +		return PTR_ERR(regs);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return -ENXIO;
> +
> +	d = devm_kzalloc(&pdev->dev, sizeof(*d), GFP_KERNEL);
> +	if (!d)
> +		return -ENOMEM;
> +
> +	sk = kzalloc(sizeof(*sk), GFP_KERNEL);
> +	if (!sk)
> +		return -ENOMEM;
> +
> +	sa = kzalloc(sizeof(*sa), GFP_KERNEL);
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
> +	d->irq = irq;
> +
> +	platform_set_drvdata(pdev, d);
> +	serio_register_port(d->kbd);
> +	serio_register_port(d->aux);
> +
> +	ret = devm_request_irq(&pdev->dev, irq, ioc3kbd_intr, IRQF_SHARED,
> +			       "ioc3-kbd", d);

Just request_irq(); there is not really any benefit from devm since you
free it manually.

What else is sharing this interrupt?

> +	if (ret) {
> +		dev_err(&pdev->dev, "could not request IRQ %d\n", irq);
> +		serio_unregister_port(d->kbd);
> +		serio_unregister_port(d->aux);
> +		kfree(sk);
> +		kfree(sa);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int ioc3kbd_remove(struct platform_device *pdev)
> +{
> +	struct ioc3kbd_data *d = platform_get_drvdata(pdev);
> +
> +	devm_free_irq(&pdev->dev, d->irq, d);
> +	serio_unregister_port(d->kbd);
> +	serio_unregister_port(d->aux);
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

Thanks.

-- 
Dmitry
