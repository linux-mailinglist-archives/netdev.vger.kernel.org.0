Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B3F83A16
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfHFUNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:13:07 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35765 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFUNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:13:07 -0400
Received: by mail-ot1-f65.google.com with SMTP id j19so19047399otq.2;
        Tue, 06 Aug 2019 13:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lMxZ0x37GnyZR6snyKLwN4Z+9SDuCLa+7zGM3bgCPsE=;
        b=uNhHnqHWxcUMjj/DObO9qobJZuWy3455TBAFqXuRBPRMYC5UOcehqvZgzujVQQ4tO7
         iDYaYUxpX3n0Mk6A0VuEi2MFvBpyGPkiicuFcaiBnkyAPwdFiIPP6T38CwGYN0rNYukJ
         fBODZFn5Oz2nqDIu++qJzEiRM6bpn5EyKgEsSS5lD09B271GHk3KNUYGKOyjtqAOWD1E
         p5Z/YfvgTNzyKHA7stW8/f5WGpf4d8iMSt4BlUyR9C5ezdn55uVRgKPYsPQdPzFgM4VT
         cRlCvxxZWCluzM8Embbcxk15JKo7CMf3oSK45KhhnTFQqDEsfnNjRAwlkx136AVhMz2g
         oGvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lMxZ0x37GnyZR6snyKLwN4Z+9SDuCLa+7zGM3bgCPsE=;
        b=MT0XTplbvRDBM9TS8MYZluUQ1U2a3vjNA165zqKog8vfky65QRKAAZ9koWfxxGMghj
         WMK+dkZ3R/PRLd7zQkp6Bh4jBgKwMX80ih4FuXabsJ6vEkuLp3807dIqj4JQCkGC1e2j
         G5SgSwxgrz0TwO5VNrOp3oI4PKiryDXpWTZOFG5ERq50OFmLBaX/6wGHWEljO4jdK7bk
         CuTZdB8Z4dwMLR4uF8rygpQSyzkBBjd0xTWMTAYK2FgTDKxrT6xS5CY6DKbNo5dtLczD
         dXiIi+4n1pq4/xfoFvnDj5TbEqnyeFuYMVjpJjYamtWCBMvw44PSeSTD5UFmdLaybUlJ
         dppw==
X-Gm-Message-State: APjAAAWedk7jm86Zlqf1rK1vIkshoeQB7XQio/KGuKNa4V8Tb8k2Nr35
        DziRdPwA8yUvr62khxRP0tKCPvqRlHZ9cttYSo0=
X-Google-Smtp-Source: APXvYqxE7llsKhmMY5eBOo9Bp8SGwlO4IBzoSrd0PaMEtEgmygcJVEfPo61PKt0g7SmEEd0kK6W2y78Ewt3nTwN8ZyI=
X-Received: by 2002:a05:6602:144:: with SMTP id v4mr5426163iot.202.1565122385732;
 Tue, 06 Aug 2019 13:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-8-arnd@arndb.de>
In-Reply-To: <20190731195713.3150463-8-arnd@arndb.de>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Tue, 6 Aug 2019 16:12:54 -0400
Message-ID: <CA+rxa6pZ7RLAOR1AQqdcNWxvk8dyoMR586n0d2e_b8SHU-jyWA@mail.gmail.com>
Subject: Re: [PATCH 07/14] net: lpc-enet: move phy setup into platform code
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>

On Wed, Jul 31, 2019 at 4:01 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Setting the phy mode requires touching a platform specific
> register, which prevents us from building the driver without
> its header files.
>
> Move it into a separate function in arch/arm/mach/lpc32xx
> to hide the core registers from the network driver.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-lpc32xx/common.c       | 12 ++++++++++++
>  drivers/net/ethernet/nxp/lpc_eth.c   | 12 +-----------
>  include/linux/soc/nxp/lpc32xx-misc.h |  5 +++++
>  3 files changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
> index f648324d5fb4..a475339333c1 100644
> --- a/arch/arm/mach-lpc32xx/common.c
> +++ b/arch/arm/mach-lpc32xx/common.c
> @@ -63,6 +63,18 @@ u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaaddr)
>  }
>  EXPORT_SYMBOL_GPL(lpc32xx_return_iram);
>
> +void lpc32xx_set_phy_interface_mode(phy_interface_t mode)
> +{
> +       u32 tmp = __raw_readl(LPC32XX_CLKPWR_MACCLK_CTRL);
> +       tmp &= ~LPC32XX_CLKPWR_MACCTRL_PINS_MSK;
> +       if (mode == PHY_INTERFACE_MODE_MII)
> +               tmp |= LPC32XX_CLKPWR_MACCTRL_USE_MII_PINS;
> +       else
> +               tmp |= LPC32XX_CLKPWR_MACCTRL_USE_RMII_PINS;
> +       __raw_writel(tmp, LPC32XX_CLKPWR_MACCLK_CTRL);
> +}
> +EXPORT_SYMBOL_GPL(lpc32xx_set_phy_interface_mode);
> +
>  static struct map_desc lpc32xx_io_desc[] __initdata = {
>         {
>                 .virtual        = (unsigned long)IO_ADDRESS(LPC32XX_AHB0_START),
> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
> index bcdd0adcfb0c..0893b77c385d 100644
> --- a/drivers/net/ethernet/nxp/lpc_eth.c
> +++ b/drivers/net/ethernet/nxp/lpc_eth.c
> @@ -20,9 +20,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/soc/nxp/lpc32xx-misc.h>
>
> -#include <mach/hardware.h>
> -#include <mach/platform.h>
> -
>  #define MODNAME "lpc-eth"
>  #define DRV_VERSION "1.00"
>
> @@ -1237,16 +1234,9 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
>         dma_addr_t dma_handle;
>         struct resource *res;
>         int irq, ret;
> -       u32 tmp;
>
>         /* Setup network interface for RMII or MII mode */
> -       tmp = __raw_readl(LPC32XX_CLKPWR_MACCLK_CTRL);
> -       tmp &= ~LPC32XX_CLKPWR_MACCTRL_PINS_MSK;
> -       if (lpc_phy_interface_mode(dev) == PHY_INTERFACE_MODE_MII)
> -               tmp |= LPC32XX_CLKPWR_MACCTRL_USE_MII_PINS;
> -       else
> -               tmp |= LPC32XX_CLKPWR_MACCTRL_USE_RMII_PINS;
> -       __raw_writel(tmp, LPC32XX_CLKPWR_MACCLK_CTRL);
> +       lpc32xx_set_phy_interface_mode(lpc_phy_interface_mode(dev));
>
>         /* Get platform resources */
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> diff --git a/include/linux/soc/nxp/lpc32xx-misc.h b/include/linux/soc/nxp/lpc32xx-misc.h
> index f232e1a1bcdc..af4f82f6cf3b 100644
> --- a/include/linux/soc/nxp/lpc32xx-misc.h
> +++ b/include/linux/soc/nxp/lpc32xx-misc.h
> @@ -9,9 +9,11 @@
>  #define __SOC_LPC32XX_MISC_H
>
>  #include <linux/types.h>
> +#include <linux/phy.h>
>
>  #ifdef CONFIG_ARCH_LPC32XX
>  extern u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaaddr);
> +extern void lpc32xx_set_phy_interface_mode(phy_interface_t mode);
>  #else
>  static inline u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaaddr)
>  {
> @@ -19,6 +21,9 @@ static inline u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaadd
>         *dmaaddr = 0;
>         return 0;
>  }
> +static inline void lpc32xx_set_phy_interface_mode(phy_interface_t mode)
> +{
> +}
>  #endif
>
>  #endif  /* __SOC_LPC32XX_MISC_H */
> --
> 2.20.0
>
