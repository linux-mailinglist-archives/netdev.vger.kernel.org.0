Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8692483A10
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfHFULw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:11:52 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35751 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfHFULw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:11:52 -0400
Received: by mail-oi1-f196.google.com with SMTP id a127so68428730oii.2;
        Tue, 06 Aug 2019 13:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L9+cVJ1tHnXHLgWnIFc8trRPYs0ZvKQBrpOrQ/JACNw=;
        b=sIXKlKnGMf3/x5UdpiL2krma7wQpwGLW+fNiBVYGuAg+enmNapJrdHJOK3Oz6VrG4S
         uyrECxK7aeBd7o3/uEp8bWKsib3jCFom0hef5aSfRgnTGDHYO+nZABn6EpZoOfS//Di8
         K3J2QiIPIqO43WOsFkM/9MS+hFVl0vY7nLlRLOOOT38bOre68X6M4+VE7+iryhYTkoWH
         +iIcdRhzuCzCJXfZ2RI2EC7lMHdMYNFg0AFO6lRZgQWTJRQOF+px3mavO28/a1fqiwMl
         zIzP3jFzckC9iAiQ+eeHYXmFqjmRtbWUw99s2dPsWL3ujUbHxrOx7r/gJGbY7a2vzl0c
         vmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L9+cVJ1tHnXHLgWnIFc8trRPYs0ZvKQBrpOrQ/JACNw=;
        b=csWeasVMoCS7SXc4EKv854JGcrPKsKac/IlS3oSQQa87YP3HCdVRG1SPJwlUbXInuo
         zhVHI4l65PLNKF4UrDJHdpgotD/ixnRf5J1PW1GN4AJhcKwq3/ntYeIVGJd3DK5tOSfG
         2XlNEyskSEzLABHCqJ4i88oJV0T+Lv7Y5FjP1bm/2Mv/P80Jl69tv7g46fv3uTBEz7ry
         3WYUzw1MnvCzWYHYqWEqLN2t8+Nkly86kXGjCKnXFOl/TAQiWEShYNgAQCaoBQK6tOev
         Z5HBGE9R8yl94BHII6ZL67PDQ+PipWTuJGvimADPbJ+3QOFIFXvoNeljJXOWnfRq0hWW
         PRAw==
X-Gm-Message-State: APjAAAWhV8d3ZVSZDozyfK2n5PHUgeM7DFK0J/jbB5ohQDsZ3NANhb1i
        3cJZnBO2FXb569Vxa1LkOkicqPQxmR2EdaCScMQ=
X-Google-Smtp-Source: APXvYqzgWKoM+BMJTliT2FhYuhnnw0Sff1jkVm8UFW2f3OncWRNYvDy3QFieh0lskdwjWmdDcfZrqUQTJBiO+gLmuHM=
X-Received: by 2002:a05:6638:c8:: with SMTP id w8mr6365741jao.52.1565122310484;
 Tue, 06 Aug 2019 13:11:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-8-arnd@arndb.de>
In-Reply-To: <20190731195713.3150463-8-arnd@arndb.de>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Tue, 6 Aug 2019 16:11:38 -0400
Message-ID: <CA+rxa6pcw7une0YUyMd1ZxUpcAqRRqZHcEUXxTYuscmpDUsCuQ@mail.gmail.com>
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
