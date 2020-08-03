Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9645F23AC2A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgHCSMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:12:35 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C143DC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:12:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p20so170009wrf.0
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 11:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xywtJYSs/n/8TbVUtJERlB/zTNl0yXoLdQXWkQ1bUFE=;
        b=n0YDMjXtJpztKEHr1Yi7ciqe+GZHb6aYmpAVJbgTWl67e8CX2wJ80Pc1tSsCIwp8/A
         0GeqRfpRuA4Xw48bXsB6+HmOOLQKup4bScVPQmqsb3TYleYJHzkBwHmtG4cEbFiXSsfv
         xi/B5EqpqFz8hVc0oo1N4kbHvW/QbvCAA+C67GRWY/YckGc4jkIRKUiKvQ6gT1HcWAao
         wrl6ZZG7TcL7l7ufXKiYLjhzkh/n35CFZjbPHCXNHr4q0UB6r0gHxCqp3WpDgDsSYnyp
         U8OfOUKc/4I4+rp8iTTDV21ZNqjFqQ1I3o/Cn8SExJ2+wlyENij4EjuuNezpfum55ndf
         QYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xywtJYSs/n/8TbVUtJERlB/zTNl0yXoLdQXWkQ1bUFE=;
        b=aDkFyYLs7I9qFStHuzGuHXpnEZARR97qjroDkbnwdqmc0EPgSeVA8ioWcmPekCfGF4
         NSPvEMfnb/hhRBjtbeM5T57rYWD0aCplj8qP5JgvvXD7VWJw7yp3O2HkBcZEYHjG1byq
         0n7eLuWo5KKeZM0AC+naCBVOhTYQiCmb5mHSYHlj0QzfJ4CxRCUCWnodTGsHhHzsTxPm
         a8KbL2fzL+I0Qxit5XfkdXRVqYA4uTRsoVsGa/0fgWUiltgwN20Hp555vm0s28XpSZiy
         4yXLF5ARxcgxIQ9dkKIybqrWX2J2L7nIqcmUfWJWFlbnJCMjMCIi7UMU3gdGuGW8qH33
         QhnA==
X-Gm-Message-State: AOAM530HyJ2KzMoTQB7DrPwsxrrGBbDZ9fP43aPNIHQegBIjOQCNSyRL
        FYPMwut4uW3OA5rB+iChVBrx0cXF
X-Google-Smtp-Source: ABdhPJx4bdzs3+IYdHSmExPsS6blIt3Ty4g5Si9L19WCCTpwLN+oCf2yZI6CmIwwY5eS8js4vD81QA==
X-Received: by 2002:adf:9e90:: with SMTP id a16mr17170360wrf.40.1596478353465;
        Mon, 03 Aug 2020 11:12:33 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f12sm560451wmc.46.2020.08.03.11.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 11:12:32 -0700 (PDT)
Subject: Re: [PATCH v4 09/11] net: dsa: microchip: Add Microchip KSZ8863 SMI
 based driver support
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-10-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1841afd-d5b8-b7f7-a2f1-af94292140fa@gmail.com>
Date:   Mon, 3 Aug 2020 11:12:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-10-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
> switches using the Microchip SMI Interface. They are supported using the
> MDIO-Bitbang Interface.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 

[snip

> +
> +config NET_DSA_MICROCHIP_KSZ8863_SMI
> +	tristate "KSZ series SMI connected switch driver"
> +	depends on NET_DSA_MICROCHIP_KSZ8795
> +	select MDIO_BITBANG
> +	default y

As Randy already identified please remove this.

> +	help
> +	  Select to enable support for registering switches configured through
> +	  Microchip SMI. It Supports the KSZ8863 and KSZ8873 Switch.
> diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
> index 929caa81e782ed2..2a03b21a3386f5d 100644
> --- a/drivers/net/dsa/microchip/Makefile
> +++ b/drivers/net/dsa/microchip/Makefile
> @@ -5,3 +5,4 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+= ksz9477_i2c.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
> +obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
> diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
> new file mode 100644
> index 000000000000000..fd493441d725284
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz8863_smi.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Microchip KSZ8863 series register access through SMI
> + *
> + * Copyright (C) 2019 Pengutronix, Michael Grzeschik <kernel@pengutronix.de>
> + */
> +
> +#include "ksz8.h"
> +#include "ksz_common.h"
> +
> +/* Serial Management Interface (SMI) uses the following frame format:
> + *
> + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data bits      | Idle
> + *               |frame| OP code  |address |address|  |                  |
> + * read | 32x1´s | 01  |    00    | 1xRRR  | RRRRR |Z0| 00000000DDDDDDDD |  Z
> + * write| 32x1´s | 01  |    00    | 0xRRR  | RRRRR |10| xxxxxxxxDDDDDDDD |  Z
> + *
> + */
> +
> +static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
> +			     void *val_buf, size_t val_len)
> +{
> +	struct ksz_device *dev = (struct ksz_device *)ctx;

There is no need to cast a void pointer, can you also make it a const
void *ctx?

> +	struct ksz8 *ksz8 = dev->priv;
> +	struct mdio_device *mdev = ksz8->priv;
> +	u8 reg = *(u8 *)reg_buf;
> +	u8 *val = val_buf;
> +	int ret = 0;
> +	int i;
> +
> +	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	for (i = 0; i < val_len; i++) {
> +		int tmp = reg + i;

Humm, how does this work for reg_len >1 with reg being a scalar? Why not
just use reg[i]?

> +
> +		ret = __mdiobus_read(mdev->bus, ((tmp & 0xE0) >> 5) |
> +				     BIT(4), tmp);

Can we provide defines instead of these numbers?

> +		if (ret < 0)
> +			goto out;
> +
> +		val[i] = ret;
> +	}
> +	ret = 0;
> +
> + out:
> +	mutex_unlock(&mdev->bus->mdio_lock);
> +
> +	return ret;
> +}
> +
> +static int ksz8863_mdio_write(void *ctx, const void *data, size_t count)
> +{
> +	struct ksz_device *dev = (struct ksz_device *)ctx;

Likewise, no need to cast here.

> +	struct ksz8 *ksz8 = dev->priv;
> +	struct mdio_device *mdev = ksz8->priv;
> +	u8 *val = (u8 *)(data + 4);
> +	u32 reg = *(u32 *)data;

Humm, are you positive this works for all endian configurations?
-- 
Florian
