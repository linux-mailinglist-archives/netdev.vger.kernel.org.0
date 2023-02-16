Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CA66992CB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjBPLK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjBPLK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:10:27 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5C82413C
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:10:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x4-20020a17090a388400b002349a303ca5so1184899pjb.4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2GMpHHfGRg7/TnbDsGNUndyh27UCOxxExN1x1g/Vmrg=;
        b=hTkcONNFXhyyY6b+D1ngopuY82WAhB/NaOhpHMDWLIlwvdvRg0/psMnu1kQEEQ0B1z
         oUHVVSgEiR25dQvFxBiA2SucfwrTpHiXJ5/Ghf8ii4DkuTdiQ8oMMDZcnifjHY8dNYwi
         GaAzLQjP/ceDYPNM5KQ9UY98gt98gWbbg8z92hoVcCex4tgqVMFh7abkPK/xYrleOdp7
         PYkAwUbON4UkmveexyELeeNTGKo2hhg5PKqzTC+XDwoDHgO6NjL2JxJDpzIJccHuxm8Q
         DXd7FfiIssXFM/MZs08PWx2atXvhcH5Mvtyz/19jldfY2ISmEhBkURCEKTfDUN8VNSTl
         PC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2GMpHHfGRg7/TnbDsGNUndyh27UCOxxExN1x1g/Vmrg=;
        b=26ojSGPW9aVvFMYLsCY2KLEVbnJG3JajVqfTBnxWAr5r3VG44AcU1D103I1EEhzK+W
         ZDwYtyiSmlfzM/i24lf8zYWhl9/TEPEwxvyoFKexutyEyrGQgl5UuTOFux8XmY/wZMF2
         P3CLAPfJ84bz1UGMDznCSJcY2dmFXHNKLR5y9WhqxpQhxGya+u+zUqJhrJv3u0kyB/BB
         jYbYWCrLQ7nUgQ914PoZDL9C3Ugskdz2DKq9Ffo+xJIQM6QeW3/XqzUXEpJLuW55Le9h
         /lzmpS5gam1pmcKlYwLr70ot2S985trd8sSgVYcSv83wKP6ghqRT+bm/jrI5h9B5TBdl
         tG0A==
X-Gm-Message-State: AO0yUKUJbuVpfRgMCIqqj6Q/NVWkiz/SyZXuhyRU5Gb0knOCHgzzuC0W
        0BKyCtuxZP7MYMvgyzxjTCKrldLz82uO6wMZI+5pAg==
X-Google-Smtp-Source: AK7set8sFgvSikw6hx/6n458aH1ciSDwVvfUnHw2qVF4We+bIcN9aEfWrb7Lc6P7xngKucLCMsUke8NhifxhmQYvZtA=
X-Received: by 2002:a17:90b:2d86:b0:233:d176:4e5d with SMTP id
 sj6-20020a17090b2d8600b00233d1764e5dmr468611pjb.121.1676545822458; Thu, 16
 Feb 2023 03:10:22 -0800 (PST)
MIME-Version: 1.0
References: <20230215155410.80944-1-andriy.shevchenko@linux.intel.com> <20230215155410.80944-2-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230215155410.80944-2-andriy.shevchenko@linux.intel.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 16 Feb 2023 12:09:46 +0100
Message-ID: <CAPDyKFoghVAiyG4bko6AXrKeV5pqiXP48Sh8Mk8evwK2oayw7Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: atmel-mci: Convert to agnostic GPIO API
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Chas Williams <3chas3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Arnd, Balamanikandan

On Wed, 15 Feb 2023 at 16:53, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> The of_gpio.h is going to be removed. In preparation of that convert
> the driver to the agnostic API.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This is the third attempt to get this done, within this release cycle. :-)

Arnd's:
https://lore.kernel.org/netdev/20230126135034.3320638-1-arnd@kernel.org/

Balamanikandan's:
https://lore.kernel.org/all/20221226073908.17317-1-balamanikandan.gunasundar@microchip.com/

Actually, Balamanikandan's version was acked already in December by
Linus Walleij and Ludovic, but I failed to apply it so I was
requesting a rebase.

That said, I think we should give BalaBalamanikandan some more time
for a re-spin (unless someone is willing to help him out in this
regard), as it's getting late for v6.3 anyway.

Kind regards
Uffe

> ---
>  drivers/mmc/host/atmel-mci.c | 106 ++++++++++++++++-------------------
>  1 file changed, 48 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index fad5e6b4c654..79876e3152e6 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -11,7 +11,7 @@
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/err.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -19,7 +19,6 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> -#include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
>  #include <linux/scatterlist.h>
>  #include <linux/seq_file.h>
> @@ -44,8 +43,8 @@
>  /**
>   * struct mci_slot_pdata - board-specific per-slot configuration
>   * @bus_width: Number of data lines wired up the slot
> - * @detect_pin: GPIO pin wired to the card detect switch
> - * @wp_pin: GPIO pin wired to the write protect sensor
> + * @wp_gpio: GPIO pin wired to the write protect sensor
> + * @detect_gpio: GPIO pin wired to the card detect switch
>   * @detect_is_active_high: The state of the detect pin when it is active
>   * @non_removable: The slot is not removable, only detect once
>   *
> @@ -60,8 +59,8 @@
>   */
>  struct mci_slot_pdata {
>         unsigned int            bus_width;
> -       int                     detect_pin;
> -       int                     wp_pin;
> +       struct gpio_desc        *wp_gpio;
> +       struct gpio_desc        *detect_gpio;
>         bool                    detect_is_active_high;
>         bool                    non_removable;
>  };
> @@ -399,12 +398,12 @@ struct atmel_mci {
>   *     &struct atmel_mci.
>   * @clock: Clock rate configured by set_ios(). Protected by host->lock.
>   * @flags: Random state bits associated with the slot.
> - * @detect_pin: GPIO pin used for card detection, or negative if not
> - *     available.
> - * @wp_pin: GPIO pin used for card write protect sending, or negative
> + * @wp_gpio: GPIO pin used for card write protect sending, or NULL
>   *     if not available.
> + * @detect_gpio: GPIO pin used for card detection, or negative if not
> + *     available.
>   * @detect_is_active_high: The state of the detect pin when it is active.
> - * @detect_timer: Timer used for debouncing @detect_pin interrupts.
> + * @detect_timer: Timer used for debouncing @detect_gpio interrupts.
>   */
>  struct atmel_mci_slot {
>         struct mmc_host         *mmc;
> @@ -422,8 +421,9 @@ struct atmel_mci_slot {
>  #define ATMCI_CARD_NEED_INIT   1
>  #define ATMCI_SHUTDOWN         2
>
> -       int                     detect_pin;
> -       int                     wp_pin;
> +       struct gpio_desc        *wp_gpio;
> +
> +       struct gpio_desc        *detect_gpio;
>         bool                    detect_is_active_high;
>
>         struct timer_list       detect_timer;
> @@ -637,7 +637,8 @@ MODULE_DEVICE_TABLE(of, atmci_dt_ids);
>  static struct mci_platform_data*
>  atmci_of_init(struct platform_device *pdev)
>  {
> -       struct device_node *np = pdev->dev.of_node;
> +       struct device *dev = &pdev->dev;
> +       struct device_node *np = dev->of_node;
>         struct device_node *cnp;
>         struct mci_platform_data *pdata;
>         u32 slot_id;
> @@ -669,8 +670,10 @@ atmci_of_init(struct platform_device *pdev)
>                                          &pdata->slot[slot_id].bus_width))
>                         pdata->slot[slot_id].bus_width = 1;
>
> -               pdata->slot[slot_id].detect_pin =
> -                       of_get_named_gpio(cnp, "cd-gpios", 0);
> +               pdata->slot[slot_id].detect_gpio = devm_gpiod_get_optional(dev, "cd", GPIOD_IN);
> +               if (!pdata->slot[slot_id].detect_gpio)
> +                       dev_dbg(dev, "no detect pin available\n");
> +               gpiod_set_consumer_name(pdata->slot[slot_id].detect_gpio, "mmc_detect");
>
>                 pdata->slot[slot_id].detect_is_active_high =
>                         of_property_read_bool(cnp, "cd-inverted");
> @@ -678,8 +681,10 @@ atmci_of_init(struct platform_device *pdev)
>                 pdata->slot[slot_id].non_removable =
>                         of_property_read_bool(cnp, "non-removable");
>
> -               pdata->slot[slot_id].wp_pin =
> -                       of_get_named_gpio(cnp, "wp-gpios", 0);
> +               pdata->slot[slot_id].wp_gpio = devm_gpiod_get_optional(dev, "wp", GPIOD_IN);
> +               if (!pdata->slot[slot_id].wp_gpio)
> +                       dev_dbg(dev, "no WP pin available\n");
> +               gpiod_set_consumer_name(pdata->slot[slot_id].wp_gpio, "mmc_wp");
>         }
>
>         return pdata;
> @@ -1535,8 +1540,8 @@ static int atmci_get_ro(struct mmc_host *mmc)
>         int                     read_only = -ENOSYS;
>         struct atmel_mci_slot   *slot = mmc_priv(mmc);
>
> -       if (gpio_is_valid(slot->wp_pin)) {
> -               read_only = gpio_get_value(slot->wp_pin);
> +       if (slot->wp_gpio) {
> +               read_only = gpiod_get_value(slot->wp_gpio);
>                 dev_dbg(&mmc->class_dev, "card is %s\n",
>                                 read_only ? "read-only" : "read-write");
>         }
> @@ -1544,14 +1549,18 @@ static int atmci_get_ro(struct mmc_host *mmc)
>         return read_only;
>  }
>
> +static bool is_card_present(struct atmel_mci_slot *slot)
> +{
> +       return !(gpiod_get_raw_value(slot->detect_gpio) ^ slot->detect_is_active_high);
> +}
> +
>  static int atmci_get_cd(struct mmc_host *mmc)
>  {
>         int                     present = -ENOSYS;
>         struct atmel_mci_slot   *slot = mmc_priv(mmc);
>
> -       if (gpio_is_valid(slot->detect_pin)) {
> -               present = !(gpio_get_value(slot->detect_pin) ^
> -                           slot->detect_is_active_high);
> +       if (slot->detect_gpio) {
> +               present = is_card_present(slot);
>                 dev_dbg(&mmc->class_dev, "card is %spresent\n",
>                                 present ? "" : "not ");
>         }
> @@ -1663,9 +1672,8 @@ static void atmci_detect_change(struct timer_list *t)
>         if (test_bit(ATMCI_SHUTDOWN, &slot->flags))
>                 return;
>
> -       enable_irq(gpio_to_irq(slot->detect_pin));
> -       present = !(gpio_get_value(slot->detect_pin) ^
> -                   slot->detect_is_active_high);
> +       enable_irq(gpiod_to_irq(slot->detect_gpio));
> +       present = is_card_present(slot);
>         present_old = test_bit(ATMCI_CARD_PRESENT, &slot->flags);
>
>         dev_vdbg(&slot->mmc->class_dev, "detect change: %d (was %d)\n",
> @@ -2254,18 +2262,18 @@ static int atmci_init_slot(struct atmel_mci *host,
>         slot = mmc_priv(mmc);
>         slot->mmc = mmc;
>         slot->host = host;
> -       slot->detect_pin = slot_data->detect_pin;
> -       slot->wp_pin = slot_data->wp_pin;
> +       slot->wp_gpio = slot_data->wp_gpio;
> +       slot->detect_gpio = slot_data->detect_gpio;
>         slot->detect_is_active_high = slot_data->detect_is_active_high;
>         slot->sdc_reg = sdc_reg;
>         slot->sdio_irq = sdio_irq;
>
>         dev_dbg(&mmc->class_dev,
> -               "slot[%u]: bus_width=%u, detect_pin=%d, "
> -               "detect_is_active_high=%s, wp_pin=%d\n",
> -               id, slot_data->bus_width, slot_data->detect_pin,
> +               "slot[%u]: bus_width=%u, detect_gpio=%d, "
> +               "detect_is_active_high=%s, wp_gpio=%d\n",
> +               id, slot_data->bus_width, desc_to_gpio(slot_data->detect_gpio),
>                 slot_data->detect_is_active_high ? "true" : "false",
> -               slot_data->wp_pin);
> +               desc_to_gpio(slot_data->wp_gpio));
>
>         mmc->ops = &atmci_ops;
>         mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
> @@ -2301,32 +2309,16 @@ static int atmci_init_slot(struct atmel_mci *host,
>
>         /* Assume card is present initially */
>         set_bit(ATMCI_CARD_PRESENT, &slot->flags);
> -       if (gpio_is_valid(slot->detect_pin)) {
> -               if (devm_gpio_request(&host->pdev->dev, slot->detect_pin,
> -                                     "mmc_detect")) {
> -                       dev_dbg(&mmc->class_dev, "no detect pin available\n");
> -                       slot->detect_pin = -EBUSY;
> -               } else if (gpio_get_value(slot->detect_pin) ^
> -                               slot->detect_is_active_high) {
> +       if (slot->detect_gpio) {
> +               if (!is_card_present(slot))
>                         clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
> -               }
> -       }
> -
> -       if (!gpio_is_valid(slot->detect_pin)) {
> +       } else {
>                 if (slot_data->non_removable)
>                         mmc->caps |= MMC_CAP_NONREMOVABLE;
>                 else
>                         mmc->caps |= MMC_CAP_NEEDS_POLL;
>         }
>
> -       if (gpio_is_valid(slot->wp_pin)) {
> -               if (devm_gpio_request(&host->pdev->dev, slot->wp_pin,
> -                                     "mmc_wp")) {
> -                       dev_dbg(&mmc->class_dev, "no WP pin available\n");
> -                       slot->wp_pin = -EBUSY;
> -               }
> -       }
> -
>         host->slot[id] = slot;
>         mmc_regulator_get_supply(mmc);
>         ret = mmc_add_host(mmc);
> @@ -2335,18 +2327,18 @@ static int atmci_init_slot(struct atmel_mci *host,
>                 return ret;
>         }
>
> -       if (gpio_is_valid(slot->detect_pin)) {
> +       if (slot->detect_gpio) {
>                 timer_setup(&slot->detect_timer, atmci_detect_change, 0);
>
> -               ret = request_irq(gpio_to_irq(slot->detect_pin),
> +               ret = request_irq(gpiod_to_irq(slot->detect_gpio),
>                                 atmci_detect_interrupt,
>                                 IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>                                 "mmc-detect", slot);
>                 if (ret) {
>                         dev_dbg(&mmc->class_dev,
>                                 "could not request IRQ %d for detect pin\n",
> -                               gpio_to_irq(slot->detect_pin));
> -                       slot->detect_pin = -EBUSY;
> +                               gpiod_to_irq(slot->detect_gpio));
> +                       slot->detect_gpio = NULL;
>                 }
>         }
>
> @@ -2365,10 +2357,8 @@ static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
>
>         mmc_remove_host(slot->mmc);
>
> -       if (gpio_is_valid(slot->detect_pin)) {
> -               int pin = slot->detect_pin;
> -
> -               free_irq(gpio_to_irq(pin), slot);
> +       if (slot->detect_gpio) {
> +               free_irq(gpiod_to_irq(slot->detect_gpio), slot);
>                 del_timer_sync(&slot->detect_timer);
>         }
>
> --
> 2.39.1
>
