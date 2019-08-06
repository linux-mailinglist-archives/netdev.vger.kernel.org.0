Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20294839FA
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfHFUCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:02:40 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40000 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfHFUCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:02:40 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so38386698oth.7;
        Tue, 06 Aug 2019 13:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gqjViCXObN2WgC0+IhrtTb7Ll35AmMVzauFcMWGTI3Y=;
        b=g6geZrRSw1Dk72HeV3MeqgqDiCymOKGzorDS9kcJv2KYasDx9IRJzWdUCQ5iz/Ck/a
         sMOqtrYcPYFkeOtOkh3EZ6BQOFZFtjfX4FeNaR7psKg3xzJZZT2HZI2UO45VHTO99KCa
         5DJfIPEVo7ChrD9UA9ksvW4WKmWAYqfMY6fVOBsARhj6ITM/Y954KCB64DT/86RovKv+
         v3izTjlAuvKv3KGD3bthq9dyPH36SX8i7m0+F89SRk5FQznew6pgkuE+/KIjfgWA0K30
         KRvE8YQ5YyG26Sgb8bPl/FmaHp9h4HQXgX6WZJSlRti8akUyiqMHCDslkE+F9DWvSgMq
         +SWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gqjViCXObN2WgC0+IhrtTb7Ll35AmMVzauFcMWGTI3Y=;
        b=DAVKmvYCat5Dj/ruLiTDzFFuhZq4kak1ETB6I0A26uw55TdS6uBJmEri64wRgyHQVs
         GN0Hy5n4PPvA4kEaPHcBmPMzYLhiipyLt5cVtdtxMbMaA5/o5SReiskWf1eMKNW0iPH1
         e4DwW70VB23KpGrgxdaSpWb29r9f194r6Ro7GM7esYhQ0u0xEquCc8jXCfeKeAqWU8rL
         QHTybgeHsj6D1htR0yXbCfmlDtKElfBibDqXLIv4CfekibAMhtjmTZ3r04tBCHWvTopq
         yXqopfEBABpB5N5VkeK5JNRcYTvhc2ynumq8hJR0CH5cmo0QtomaTzLcDwfnVnVl0N6f
         1IVw==
X-Gm-Message-State: APjAAAUv/enkbaZmdiOEMTkClH/qX+lO8nl3kZrRCiqzEPZP78AwDiNv
        C4f3UQG58s/Izj9E+KwZXS+RfZRthcf/rEJWTYc=
X-Google-Smtp-Source: APXvYqxUZRrA60vyMd0kzSQ4htAnblGQWHtpdj5jgj0q6G1y1gZxQTbe74lzuUCM09PKJHet7o8XCRwQJqJO6Q95G/0=
X-Received: by 2002:a5d:9942:: with SMTP id v2mr5555846ios.177.1565121759065;
 Tue, 06 Aug 2019 13:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-6-arnd@arndb.de>
In-Reply-To: <20190731195713.3150463-6-arnd@arndb.de>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Tue, 6 Aug 2019 16:02:27 -0400
Message-ID: <CA+rxa6p4gD7+6-aRyd4-V4TvkyMiUh9ueMLc6ggBaDC=LG7fQg@mail.gmail.com>
Subject: Re: [PATCH 05/14] gpio: lpc32xx: allow building on non-lpc32xx targets
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
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
        Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Wed, Jul 31, 2019 at 4:00 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> The driver uses hardwire MMIO addresses instead of the data
> that is passed in device tree. Change it over to only
> hardcode the register offset values and allow compile-testing.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpio/Kconfig        |  8 +++++
>  drivers/gpio/Makefile       |  2 +-
>  drivers/gpio/gpio-lpc32xx.c | 63 ++++++++++++++++++++++++-------------
>  3 files changed, 50 insertions(+), 23 deletions(-)
>
[...]

> diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
> index 24885b3db3d5..548f7cb69386 100644
> --- a/drivers/gpio/gpio-lpc32xx.c
> +++ b/drivers/gpio/gpio-lpc32xx.c

[...]

> @@ -498,6 +509,10 @@ static int lpc32xx_gpio_probe(struct platform_device *pdev)
>  {
>         int i;
>
> +       gpio_reg_base = devm_platform_ioremap_resource(pdev, 0);
> +       if (gpio_reg_base)
> +               return -ENXIO;

The probe function will always return an error.
Please replace the previous 2 lines with:
    if (IS_ERR(gpio_reg_base))
        return PTR_ERR(gpio_reg_base);

You can add my acked-by and tested-by in the v2 patch.
Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>
Tested-by: Sylvain Lemieux <slemieux.tyco@gmail.com>

> +
>         for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++) {
>                 if (pdev->dev.of_node) {
>                         lpc32xx_gpiochip[i].chip.of_xlate = lpc32xx_of_xlate;
> @@ -527,3 +542,7 @@ static struct platform_driver lpc32xx_gpio_driver = {
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
Sylvain
