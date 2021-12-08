Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DA246CD77
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhLHGMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbhLHGMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:12:34 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281A2C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 22:09:03 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id j21so1251716ila.5
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 22:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=lIv4QVsdbvdCrazbsuQ0JkznpnxKe0kM4Mgzgv9g9Ng=;
        b=A9IbIZkRvor3oFJkrRafTA1saGK62vBeXMbzAPSWf3F9BlVPQnMt5Xqckamqfwc4Yo
         mbXmcNb566lv6P+7OY76DPcJtuTnqWPAOE+docKcYyDQJY9Uve16+4R2Dr/Cb0V5pZDf
         xVHHbMnuR9zZleAWB2yco/tnuQ5TASbcwLcsrLzUnaqqUolbvQnVu4wqywWXqxJqsiE6
         BN61CnoAngjPL/F4/UvMIY4e21LoXy1LlLEiC0XOnRVI9YYuwIHpkhgVrD2dSX7QYhW/
         LjIMVf7JFUoGNSjAR000TS4KqrEb8rKKr9NsKqlwssIVz2NOJaRzgle46IJi7HMf33n3
         oFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=lIv4QVsdbvdCrazbsuQ0JkznpnxKe0kM4Mgzgv9g9Ng=;
        b=t+Ivnomk3JKecpGwlLyV6wIFmCExPkhFB3RWRY6twgUIm1vhF4l3x1057GwK4YpvFY
         v8R3geNN3C+h6zQ+0nGMMXBTb3/vq2HVj6cuyT62y9cQG+UagcuCGG8cJsr13T/qOe9P
         ynHleIrHKOBtaytNmKwnnDMskpF6rEqyr5HBc28B1jlgo2z456wHwMRKFkjg5rwH3rlX
         ZWmlWwcbdVvb5u1YJzQ5HGzH0AzHQVinvlNu6P116L0vpcdq+BvhqcLkqQmn9Bj8xZLT
         PIE25PkyF3vTq9ivgl98KNiIeJf8QK/ZG9BWyncluhrHPuQm5qGw2Z8TIdNE2vxRMEcG
         rFZg==
X-Gm-Message-State: AOAM532eWPLBtUKGv3p7She+2ZaTt3VGWrQRDpi6KJ+DgI+JKC2k3xTO
        v0tPYBr/aESIBHf048ZVEw2W
X-Google-Smtp-Source: ABdhPJxCBv/N4/T7fKIXaN//OmmhFumF7iE4BkJJGan3y7HJR3+arWPwv15nrSbvEzwjnx+SaWDf8w==
X-Received: by 2002:a92:b112:: with SMTP id t18mr3691457ilh.301.1638943741099;
        Tue, 07 Dec 2021 22:09:01 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id i26sm1721104ila.12.2021.12.07.22.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 22:09:00 -0800 (PST)
Message-ID: <d1297aac11a0a3d98180ed100034ff9fc06ed98c.camel@egauge.net>
Subject: Re: [PATCH] wilc1000: Add reset/enable GPIO support to SPI driver
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Claudiu.Beznea@microchip.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        Ajay.Kathat@microchip.com, adham.abozaeid@microchip.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Dec 2021 23:08:59 -0700
In-Reply-To: <e2a7e005-e133-ec15-df78-2302aa538a26@microchip.com>
References: <20211202034348.2901092-1-davidm@egauge.net>
         <e2a7e005-e133-ec15-df78-2302aa538a26@microchip.com>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-07 at 10:11 +0000, Claudiu.Beznea@microchip.com wrote:
> On 02.12.2021 05:55, David Mosberger-Tang wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > This patch is based on similar code from the linux4sam/linux-at91 GIT
> > repository.
> > 
> > For the SDIO driver, the RESET/ENABLE pins of WILC1000 may be
> > controlled through the SDIO power sequence driver.  This commit adds
> > analogous support for the SPI driver.  Specifically, during bus
> > probing, the chip will be reset-cycled and during unloading, the chip
> > will be placed into reset and disabled (both to reduce power
> > consumption and to ensure the WiFi radio is off).
> > 
> > Both RESET and ENABLE GPIOs are optional.  However, if the ENABLE GPIO
> > is specified, then the RESET GPIO also must be specified as otherwise
> > there is no way to ensure proper timing of the ENABLE/RESET sequence.
> > 
> > Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> > ---
> >  .../net/wireless/microchip,wilc1000.yaml      | 11 +++
> >  .../net/wireless/microchip/wilc1000/Makefile  |  2 +-
> >  drivers/net/wireless/microchip/wilc1000/hif.h |  2 +
> >  .../net/wireless/microchip/wilc1000/netdev.h  | 10 +++
> >  .../net/wireless/microchip/wilc1000/power.c   | 73 +++++++++++++++++++
> >  drivers/net/wireless/microchip/wilc1000/spi.c | 15 +++-
> >  .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
> >  7 files changed, 110 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/net/wireless/microchip/wilc1000/power.c
> > 
> > diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> > index 6c35682377e6..2ce316f5e353 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> > +++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
> > @@ -32,6 +32,15 @@ properties:
> >    clock-names:
> >      const: rtc
> > 
> > +  enable-gpios:
> > +    maxItems: 1
> > +    description: A GPIO line connected to the ENABLE line.  If this
> > +      is specified, then reset-gpios also must be specified.
> > +
> > +  reset-gpios:
> > +    maxItems: 1
> > +    description: A GPIO line connected to the RESET line.
> > +
> 
> Bindings should go through a different patch.

OK, will be fixed in v2.

> >  required:
> >    - compatible
> >    - interrupts
> > @@ -51,6 +60,8 @@ examples:
> >          interrupts = <27 0>;
> >          clocks = <&pck1>;
> >          clock-names = "rtc";
> > +        enable-gpios = <&pioA 5 0>;
> > +        reset-gpios = <&pioA 6 0>;
> >        };
> >      };
> > 
> > diff --git a/drivers/net/wireless/microchip/wilc1000/Makefile b/drivers/net/wireless/microchip/wilc1000/Makefile
> > index c3c9e34c1eaa..baf9f021a1d6 100644
> > --- a/drivers/net/wireless/microchip/wilc1000/Makefile
> > +++ b/drivers/net/wireless/microchip/wilc1000/Makefile
> > @@ -2,7 +2,7 @@
> >  obj-$(CONFIG_WILC1000) += wilc1000.o
> > 
> >  wilc1000-objs := cfg80211.o netdev.o mon.o \
> > -                       hif.o wlan_cfg.o wlan.o
> > +                       hif.o wlan_cfg.o wlan.o power.o
> > 
> >  obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
> >  wilc1000-sdio-objs += sdio.o
> > diff --git a/drivers/net/wireless/microchip/wilc1000/hif.h b/drivers/net/wireless/microchip/wilc1000/hif.h
> > index cccd54ed0518..a57095d8088e 100644
> > --- a/drivers/net/wireless/microchip/wilc1000/hif.h
> > +++ b/drivers/net/wireless/microchip/wilc1000/hif.h
> > @@ -213,4 +213,6 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length);
> >  void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length);
> >  void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
> >                                 struct cfg80211_crypto_settings *crypto);
> > +int wilc_of_parse_power_pins(struct wilc *wilc);
> > +void wilc_wlan_power(struct wilc *wilc, bool on);
> >  #endif
> > diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
> > index b9a88b3e322f..b95a247322a6 100644
> > --- a/drivers/net/wireless/microchip/wilc1000/netdev.h
> > +++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
> > @@ -197,6 +197,15 @@ struct wilc_vif {
> >         struct cfg80211_bss *bss;
> >  };
> > 
> > +struct wilc_power_gpios {
> > +       int reset;
> > +       int chip_en;
> > +};
> > +
> > +struct wilc_power {
> > +       struct wilc_power_gpios gpios;
> > +};
> > +
> >  struct wilc_tx_queue_status {
> >         u8 buffer[AC_BUFFER_SIZE];
> >         u16 end_index;
> > @@ -265,6 +274,7 @@ struct wilc {
> >         bool suspend_event;
> > 
> >         struct workqueue_struct *hif_workqueue;
> > +       struct wilc_power power;
> 
> For SDIO power should be controlled though MMC pwrseq driver. Thus I would
> keep this code for SPI only and move this member to struct wilc_spi.

OK, I was left with the impression that some SDIO implementations may
want to use GPIO control as well.  Since that doesn't seem to be the
case, I'll make v2 for SPI only.

> >         struct wilc_cfg cfg;
> >         void *bus_data;
> >         struct net_device *monitor_dev;
> > diff --git a/drivers/net/wireless/microchip/wilc1000/power.c b/drivers/net/wireless/microchip/wilc1000/power.c
> > new file mode 100644
> > index 000000000000..d26a39b7698d
> > --- /dev/null
> > +++ b/drivers/net/wireless/microchip/wilc1000/power.c
> > @@ -0,0 +1,73 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
> > + * All rights reserved.
> 
> This is not in the GIT repo. It should have been:
> "Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries"
> 		^
> 		current year

v2 has no new files so this issue goes away.

> > + */
> > +#include <linux/delay.h>
> > +#include <linux/gpio.h>
> > +#include <linux/of.h>
> > +#include <linux/of_gpio.h>
> > +#include <linux/version.h>
> > +
> > +#include "netdev.h"
> > +
> > +/**
> > + * wilc_of_parse_power_pins() - parse power sequence pins
> > + *
> > + * @wilc:      wilc data structure
> > + *
> > + * Returns:     0 on success, negative error number on failures.
> > + */
> > +int wilc_of_parse_power_pins(struct wilc *wilc)
> > +{
> > +       struct device_node *of = wilc->dev->of_node;
> > +       struct wilc_power *power = &wilc->power;
> > +       int ret;
> > +
> > +       power->gpios.reset = of_get_named_gpio_flags(of, "reset-gpios", 0,
> > +                                                    NULL);
> > +       power->gpios.chip_en = of_get_named_gpio_flags(of, "chip_en-gpios", 0,
> > +                                                      NULL);
> 
> Consider using gpio descriptors and devm_gpiod_get().

v2 uses of_get_named_gpio().

> > +       if (!gpio_is_valid(power->gpios.reset))
> > +               return 0;       /* assume SDIO power sequence driver is used */
> 
> In case of SDIO we should rely on mmc pwrseq all the time. It keeps things
> cleaner. I would keep the code in this file only for SPI.

Sure.

> > +
> > +       if (gpio_is_valid(power->gpios.chip_en)) {
> > +               ret = devm_gpio_request(wilc->dev, power->gpios.chip_en,
> > +                                       "CHIP_EN");
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +       return devm_gpio_request(wilc->dev, power->gpios.reset, "RESET");
> > +}
> > +EXPORT_SYMBOL_GPL(wilc_of_parse_power_pins);
> > +
> > +/**
> > + * wilc_wlan_power() - handle power on/off commands
> > + *
> > + * @wilc:      wilc data structure
> > + * @on:                requested power status
> > + *
> > + * Returns:    none
> > + */
> > +void wilc_wlan_power(struct wilc *wilc, bool on)
> > +{
> > +       if (!gpio_is_valid(wilc->power.gpios.reset)) {
> > +               /* In case SDIO power sequence driver is used to power this
> > +                * device then the powering sequence is handled by the bus
> > +                * via pm_runtime_* functions. */
> 
> I see this function is called anyway only in SPI context, so, don't think
> this handling for SDIO is necessary. Maybe these is something I miss with
> regards to it. Ajay, please correct me if I'm wrong.
> 
> > +               return;
> > +       }
> > +
> > +       if (on) {
> > +               if (gpio_is_valid(wilc->power.gpios.chip_en)) {
> > +                       gpio_direction_output(wilc->power.gpios.chip_en, 1);
> > +                       mdelay(5);
> > +               }
> > +               gpio_direction_output(wilc->power.gpios.reset, 1);
> > +       } else {
> > +               gpio_direction_output(wilc->power.gpios.reset, 0);
> > +               if (gpio_is_valid(wilc->power.gpios.chip_en))
> > +                       gpio_direction_output(wilc->power.gpios.chip_en, 0);
> > +       }
> > +}
> > +EXPORT_SYMBOL_GPL(wilc_wlan_power);
> > diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
> > index 640850f989dd..884ad7f954d4 100644
> > --- a/drivers/net/wireless/microchip/wilc1000/spi.c
> > +++ b/drivers/net/wireless/microchip/wilc1000/spi.c
> > @@ -171,6 +171,10 @@ static int wilc_bus_probe(struct spi_device *spi)
> >         wilc->bus_data = spi_priv;
> >         wilc->dev_irq_num = spi->irq;
> > 
> > +       ret = wilc_of_parse_power_pins(wilc);
> > +       if (ret)
> > +               goto netdev_cleanup;
> > +
> >         wilc->rtc_clk = devm_clk_get_optional(&spi->dev, "rtc");
> >         if (IS_ERR(wilc->rtc_clk)) {
> >                 ret = PTR_ERR(wilc->rtc_clk);
> > @@ -178,6 +182,10 @@ static int wilc_bus_probe(struct spi_device *spi)
> >         }
> >         clk_prepare_enable(wilc->rtc_clk);
> > 
> > +       /* ensure WILC1000 is reset and enabled: */
> > +       wilc_wlan_power(wilc, false);
> > +       wilc_wlan_power(wilc, true);
> > +
> >         return 0;
> > 
> >  netdev_cleanup:
> > @@ -977,9 +985,10 @@ static int wilc_spi_reset(struct wilc *wilc)
> > 
> >  static int wilc_spi_deinit(struct wilc *wilc)
> >  {
> > -       /*
> > -        * TODO:
> > -        */
> > +       struct wilc_spi *spi_priv = wilc->bus_data;
> > +
> > +       spi_priv->isinit = false;
> > +       wilc_wlan_power(wilc, false);
> >         return 0;
> >  }
> > 
> > diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
> > index 82566544419a..f1e4ac3a2ad5 100644
> > --- a/drivers/net/wireless/microchip/wilc1000/wlan.c
> > +++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
> > @@ -1253,7 +1253,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
> >         wilc->rx_buffer = NULL;
> >         kfree(wilc->tx_buffer);
> >         wilc->tx_buffer = NULL;
> > -       wilc->hif_func->hif_deinit(NULL);
> > +       wilc->hif_func->hif_deinit(wilc);
> >  }
> > 
> >  static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
> > --
> > 2.25.1
> > 

