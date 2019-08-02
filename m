Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 951427ED2D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389377AbfHBHKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:10:37 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40901 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389361AbfHBHKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:10:35 -0400
Received: by mail-ot1-f66.google.com with SMTP id l15so19879425oth.7
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 00:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aNOLjBPNnUmcQmvMToyFYssE9sARnDQ/c4luMj7emy0=;
        b=ZByTvhWD45O5rbMJPm0e9wEVpnT9SZtPM8zMbVnlxfFzaGij7Mj9bLuhtDht6DumSV
         X5+C/GbAojg2ZBuUa5sh+8yA7FU1/KNRmsztInjo9N3dLnWybMcoWDKeEPiB/ebLeZpq
         91Vk7RjNwrJr3eX6fiW47RfyqivZcb8JLML4cHZmY3c+1BeBv+eXMAQCcWw/gg9bjuBU
         vrss9yRxsUc1EFDB7ltk7uXcIFO5XrA7a28dWbscRQ7BYTq4viqVO6KIP4MaiEk1LZv+
         c2Zjlzg2tQB2PTRRKAU228AWlqLZlrisj3ViQ0NKdyQApwjMNgsi0fcbZSR27jzLqADe
         W3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aNOLjBPNnUmcQmvMToyFYssE9sARnDQ/c4luMj7emy0=;
        b=Q3Oj2o/kLsC0lPIgP+UL4wOHoUrn6oxrDx8PtLqxFcQ/aoYSLVoWoueKZNuVPQbqvS
         uTqXIx8t6vvqqgaL4bpLv/Tz+WCmJbGmyZlXaGSxZkxq6hjkfd3DlKITF4SCliy77OCw
         7RkXtRVkWIUFlYQcgG6je1PZ3OxCzCyapA5B6vL5HJ7Of8AI8MnZvcuRDbTSqWyeIBKF
         duN7031wgYFHaV22zIRAk5NYGxlOCiIiyI7M7s9f/isvNtafqJqCXsr91CIpgZ7gq+1P
         PCDDV4HukNrtDPTCA9g3D1KsanxcMAouxBLU9RSqNDKqi1msIHokoOFsigRhaEr9gDBY
         KiZQ==
X-Gm-Message-State: APjAAAW03Vu4XSCYtDZhxoNyPWPCLP5DjWTE1ZZjkWYIJ7Cz1Zb5r/6z
        67E2ssIc3igVqrw1Un8q8zJ88mulWQMGwuur2yrphg==
X-Google-Smtp-Source: APXvYqy4/Lk5jHB+v/1ocPg4upl5VRCkigymsxVJ4zA98u/jV3IYeAA2bS1N1TLTswamOCy90HSvHyGFfqUcSTl0o9w=
X-Received: by 2002:a9d:7352:: with SMTP id l18mr37662907otk.292.1564729833627;
 Fri, 02 Aug 2019 00:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-6-arnd@arndb.de>
In-Reply-To: <20190731195713.3150463-6-arnd@arndb.de>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Fri, 2 Aug 2019 09:10:22 +0200
Message-ID: <CAMpxmJWFfT_vrDas2fzW5tnxskk9kmgHQpGnGQ-_C20UaS_jhA@mail.gmail.com>
Subject: Re: [PATCH 05/14] gpio: lpc32xx: allow building on non-lpc32xx targets
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org, arm-soc <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
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
        linux-gpio <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 31 lip 2019 o 22:06 Arnd Bergmann <arnd@arndb.de> napisa=C5=82(a)=
:
>
> The driver uses hardwire MMIO addresses instead of the data
> that is passed in device tree. Change it over to only
> hardcode the register offset values and allow compile-testing.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd,

thanks for working on this.

> ---
>  drivers/gpio/Kconfig        |  8 +++++
>  drivers/gpio/Makefile       |  2 +-
>  drivers/gpio/gpio-lpc32xx.c | 63 ++++++++++++++++++++++++-------------
>  3 files changed, 50 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index bb13c266c329..ae86ee963eae 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -311,6 +311,14 @@ config GPIO_LPC18XX
>           Select this option to enable GPIO driver for
>           NXP LPC18XX/43XX devices.
>
> +config GPIO_LPC32XX
> +       tristate "NXP LPC32XX GPIO support"
> +       default ARCH_LPC32XX
> +       depends on OF_GPIO && (ARCH_LPC32XX || COMPILE_TEST)
> +       help
> +         Select this option to enable GPIO driver for
> +         NXP LPC32XX devices.
> +
>  config GPIO_LYNXPOINT
>         tristate "Intel Lynxpoint GPIO support"
>         depends on ACPI && X86
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index a4e91175c708..87d659ae95eb 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -74,7 +74,7 @@ obj-$(CONFIG_GPIO_LP3943)             +=3D gpio-lp3943.=
o
>  obj-$(CONFIG_GPIO_LP873X)              +=3D gpio-lp873x.o
>  obj-$(CONFIG_GPIO_LP87565)             +=3D gpio-lp87565.o
>  obj-$(CONFIG_GPIO_LPC18XX)             +=3D gpio-lpc18xx.o
> -obj-$(CONFIG_ARCH_LPC32XX)             +=3D gpio-lpc32xx.o
> +obj-$(CONFIG_GPIO_LPC32XX)             +=3D gpio-lpc32xx.o
>  obj-$(CONFIG_GPIO_LYNXPOINT)           +=3D gpio-lynxpoint.o
>  obj-$(CONFIG_GPIO_MADERA)              +=3D gpio-madera.o
>  obj-$(CONFIG_GPIO_MAX3191X)            +=3D gpio-max3191x.o
> diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
> index 24885b3db3d5..548f7cb69386 100644
> --- a/drivers/gpio/gpio-lpc32xx.c
> +++ b/drivers/gpio/gpio-lpc32xx.c
> @@ -16,8 +16,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/module.h>
>
> -#include <mach/hardware.h>
> -#include <mach/platform.h>
> +#define _GPREG(x)                              (x)

What purpose does this macro serve?

>
>  #define LPC32XX_GPIO_P3_INP_STATE              _GPREG(0x000)
>  #define LPC32XX_GPIO_P3_OUTP_SET               _GPREG(0x004)
> @@ -72,12 +71,12 @@
>  #define LPC32XX_GPO_P3_GRP     (LPC32XX_GPI_P3_GRP + LPC32XX_GPI_P3_MAX)
>
>  struct gpio_regs {
> -       void __iomem *inp_state;
> -       void __iomem *outp_state;
> -       void __iomem *outp_set;
> -       void __iomem *outp_clr;
> -       void __iomem *dir_set;
> -       void __iomem *dir_clr;
> +       unsigned long inp_state;
> +       unsigned long outp_state;
> +       unsigned long outp_set;
> +       unsigned long outp_clr;
> +       unsigned long dir_set;
> +       unsigned long dir_clr;
>  };
>
>  /*
> @@ -167,14 +166,26 @@ struct lpc32xx_gpio_chip {
>         struct gpio_regs        *gpio_grp;
>  };
>
> +void __iomem *gpio_reg_base;

Any reason why this can't be made part of struct lpc32xx_gpio_chip?

> +
> +static inline u32 gpreg_read(unsigned long offset)

Here and elsewhere: could you please keep the lpc32xx_gpio prefix for
all symbols?

> +{
> +       return __raw_readl(gpio_reg_base + offset);
> +}
> +
> +static inline void gpreg_write(u32 val, unsigned long offset)
> +{
> +       __raw_writel(val, gpio_reg_base + offset);
> +}
> +
>  static void __set_gpio_dir_p012(struct lpc32xx_gpio_chip *group,
>         unsigned pin, int input)
>  {
>         if (input)
> -               __raw_writel(GPIO012_PIN_TO_BIT(pin),
> +               gpreg_write(GPIO012_PIN_TO_BIT(pin),
>                         group->gpio_grp->dir_clr);
>         else
> -               __raw_writel(GPIO012_PIN_TO_BIT(pin),
> +               gpreg_write(GPIO012_PIN_TO_BIT(pin),
>                         group->gpio_grp->dir_set);
>  }
>
> @@ -184,19 +195,19 @@ static void __set_gpio_dir_p3(struct lpc32xx_gpio_c=
hip *group,
>         u32 u =3D GPIO3_PIN_TO_BIT(pin);
>
>         if (input)
> -               __raw_writel(u, group->gpio_grp->dir_clr);
> +               gpreg_write(u, group->gpio_grp->dir_clr);
>         else
> -               __raw_writel(u, group->gpio_grp->dir_set);
> +               gpreg_write(u, group->gpio_grp->dir_set);
>  }
>
>  static void __set_gpio_level_p012(struct lpc32xx_gpio_chip *group,
>         unsigned pin, int high)
>  {
>         if (high)
> -               __raw_writel(GPIO012_PIN_TO_BIT(pin),
> +               gpreg_write(GPIO012_PIN_TO_BIT(pin),
>                         group->gpio_grp->outp_set);
>         else
> -               __raw_writel(GPIO012_PIN_TO_BIT(pin),
> +               gpreg_write(GPIO012_PIN_TO_BIT(pin),
>                         group->gpio_grp->outp_clr);
>  }
>
> @@ -206,31 +217,31 @@ static void __set_gpio_level_p3(struct lpc32xx_gpio=
_chip *group,
>         u32 u =3D GPIO3_PIN_TO_BIT(pin);
>
>         if (high)
> -               __raw_writel(u, group->gpio_grp->outp_set);
> +               gpreg_write(u, group->gpio_grp->outp_set);
>         else
> -               __raw_writel(u, group->gpio_grp->outp_clr);
> +               gpreg_write(u, group->gpio_grp->outp_clr);
>  }
>
>  static void __set_gpo_level_p3(struct lpc32xx_gpio_chip *group,
>         unsigned pin, int high)
>  {
>         if (high)
> -               __raw_writel(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_=
set);
> +               gpreg_write(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_s=
et);
>         else
> -               __raw_writel(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_=
clr);
> +               gpreg_write(GPO3_PIN_TO_BIT(pin), group->gpio_grp->outp_c=
lr);
>  }
>
>  static int __get_gpio_state_p012(struct lpc32xx_gpio_chip *group,
>         unsigned pin)
>  {
> -       return GPIO012_PIN_IN_SEL(__raw_readl(group->gpio_grp->inp_state)=
,
> +       return GPIO012_PIN_IN_SEL(gpreg_read(group->gpio_grp->inp_state),
>                 pin);
>  }
>
>  static int __get_gpio_state_p3(struct lpc32xx_gpio_chip *group,
>         unsigned pin)
>  {
> -       int state =3D __raw_readl(group->gpio_grp->inp_state);
> +       int state =3D gpreg_read(group->gpio_grp->inp_state);
>
>         /*
>          * P3 GPIO pin input mapping is not contiguous, GPIOP3-0..4 is ma=
pped
> @@ -242,13 +253,13 @@ static int __get_gpio_state_p3(struct lpc32xx_gpio_=
chip *group,
>  static int __get_gpi_state_p3(struct lpc32xx_gpio_chip *group,
>         unsigned pin)
>  {
> -       return GPI3_PIN_IN_SEL(__raw_readl(group->gpio_grp->inp_state), p=
in);
> +       return GPI3_PIN_IN_SEL(gpreg_read(group->gpio_grp->inp_state), pi=
n);
>  }
>
>  static int __get_gpo_state_p3(struct lpc32xx_gpio_chip *group,
>         unsigned pin)
>  {
> -       return GPO3_PIN_IN_SEL(__raw_readl(group->gpio_grp->outp_state), =
pin);
> +       return GPO3_PIN_IN_SEL(gpreg_read(group->gpio_grp->outp_state), p=
in);
>  }
>
>  /*
> @@ -498,6 +509,10 @@ static int lpc32xx_gpio_probe(struct platform_device=
 *pdev)
>  {
>         int i;
>
> +       gpio_reg_base =3D devm_platform_ioremap_resource(pdev, 0);
> +       if (gpio_reg_base)
> +               return -ENXIO;
> +
>         for (i =3D 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++) {
>                 if (pdev->dev.of_node) {
>                         lpc32xx_gpiochip[i].chip.of_xlate =3D lpc32xx_of_=
xlate;
> @@ -527,3 +542,7 @@ static struct platform_driver lpc32xx_gpio_driver =3D=
 {
>  };
>
>  module_platform_driver(lpc32xx_gpio_driver);
> +
> +MODULE_AUTHOR("Kevin Wells <kevin.wells@nxp.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("GPIO driver for LPC32xx SoC");
> --
> 2.20.0
>

Bart
