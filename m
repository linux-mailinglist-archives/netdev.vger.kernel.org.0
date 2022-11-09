Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183FF622BBA
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKIMjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiKIMjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:39:10 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF4D1DA46
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:39:09 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e129so16114206pgc.9
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 04:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JbeI3A0Vt6enTtuFXcI9CQHp5arPu0B2KdkJZJ6hYho=;
        b=TYLegCo3QkgS/lNGtjh5JSXfYlyIiHx5kLI5I7sLgZUfeS9XEeUna8PUJjeBo8S3wq
         bV+ONX9Ggeu63IH6vx6AwexfEweTySjz7AHwMCRpfnyco7Pq9p8nQzG9/lzmaC78xgmc
         HghkDCK/YPUlwMgwahMzj61FYtD8kmKrLFfF5gVPXgm5e3H02X68Q1b1HIjb9mlBZdZC
         xAoZiT1l29DOxVnE+NLFvSj8/oOY9n9XGDMne+ykYBTbdtc1CHmhJ8Of/KGzgWvm5ibG
         ej0B8m68lhUGFzmpktuu3XjqkURy9zvxa1t1dTC5jQdeLEoMq+1iY0t7BdXR9BHqrPWm
         yQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JbeI3A0Vt6enTtuFXcI9CQHp5arPu0B2KdkJZJ6hYho=;
        b=0q8NIbnUdLztnF2nsge30z5paRQYofP9bT2h0NjijEDOoMvBAHDilFUcv0T+oN+QSg
         jkyVXFXVoHvl2/ofKKfAc0F7crW92WoP+JxqEN4qLf6MWmk4zcw9bL4uUmGg80jTg2Yz
         af9zPzEpnCw5sDjEh2Y4JM4PdX9Kz4FhrwgiH7eaKZihTDjVA6TkEdyx0pliAeaYsQ8J
         LLvkR/ZNny0+OCCcyOp1UEUmU7jahhZ0AsgcntqBYzRTQSdnEDZvoQRjNfqrziqs6ZvP
         D6X3OePIa78Ur/av5jDZ0vcUFmyLGZ/y3t0li6hr2wreACg/E0jUxnC+yrl5kJClrnTr
         j+sA==
X-Gm-Message-State: ACrzQf2qfM7orczba5k39GkRA8n1WeAKCfdVCVgQRB3qlHrhrPkwIqvx
        k499/cuSYA7qHA+s+BiDWOPtB1jlKPUXk4h70VqUdg==
X-Google-Smtp-Source: AMsMyM6UyIRss8vbFTKZjYYAqIFAYkG7jrBpMim1fLdx9aWNF17I3eISGGbimjJbrByhxboTKPRD9qEql+EhFwCeIKs=
X-Received: by 2002:a63:464d:0:b0:441:5968:cd0e with SMTP id
 v13-20020a63464d000000b004415968cd0emr53539683pgk.595.1667997548655; Wed, 09
 Nov 2022 04:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
In-Reply-To: <20221109043845.16617-1-balamanikandan.gunasundar@microchip.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 9 Nov 2022 13:38:32 +0100
Message-ID: <CAPDyKFo+FUAZ=1Vu4+503ch5_Wrw47BanTjdB=7J8XhRwczyqg@mail.gmail.com>
Subject: Re: [PATCH] mmc: atmel-mci: Convert to gpio descriptors
To:     Balamanikandan Gunasundar 
        <balamanikandan.gunasundar@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     ludovic.desroches@microchip.com, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, 3chas3@gmail.com,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Linus W

On Wed, 9 Nov 2022 at 05:39, Balamanikandan Gunasundar
<balamanikandan.gunasundar@microchip.com> wrote:
>
> Replace the legacy GPIO APIs with gpio descriptor consumer interface.
>
> To maintain backward compatibility, we rely on the "cd-inverted"
> property to manage the invertion flag instead of GPIO property.
>
> Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>

I added Linus W, to get some feedback from the expert in this area.

Kind regards
Uffe

> ---
>  drivers/mmc/host/atmel-mci.c | 79 ++++++++++++++++++------------------
>  include/linux/atmel-mci.h    |  4 +-
>  2 files changed, 41 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 67b2cd166e56..1df90966e104 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -19,7 +19,8 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> -#include <linux/of_gpio.h>
> +#include <linux/irq.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/platform_device.h>
>  #include <linux/scatterlist.h>
>  #include <linux/seq_file.h>
> @@ -389,8 +390,8 @@ struct atmel_mci_slot {
>  #define ATMCI_CARD_NEED_INIT   1
>  #define ATMCI_SHUTDOWN         2
>
> -       int                     detect_pin;
> -       int                     wp_pin;
> +       struct gpio_desc        *detect_pin;
> +       struct gpio_desc        *wp_pin;
>         bool                    detect_is_active_high;
>
>         struct timer_list       detect_timer;
> @@ -638,7 +639,11 @@ atmci_of_init(struct platform_device *pdev)
>                         pdata->slot[slot_id].bus_width = 1;
>
>                 pdata->slot[slot_id].detect_pin =
> -                       of_get_named_gpio(cnp, "cd-gpios", 0);
> +                       devm_gpiod_get_from_of_node(&pdev->dev, cnp,
> +                                                   "cd-gpios",
> +                                                   0, GPIOD_IN, "cd-gpios");
> +               if (IS_ERR(pdata->slot[slot_id].detect_pin))
> +                       pdata->slot[slot_id].detect_pin = NULL;
>
>                 pdata->slot[slot_id].detect_is_active_high =
>                         of_property_read_bool(cnp, "cd-inverted");
> @@ -647,7 +652,11 @@ atmci_of_init(struct platform_device *pdev)
>                         of_property_read_bool(cnp, "non-removable");
>
>                 pdata->slot[slot_id].wp_pin =
> -                       of_get_named_gpio(cnp, "wp-gpios", 0);
> +                       devm_gpiod_get_from_of_node(&pdev->dev, cnp,
> +                                                   "wp-gpios",
> +                                                   0, GPIOD_IN, "wp-gpios");
> +               if (IS_ERR(pdata->slot[slot_id].wp_pin))
> +                       pdata->slot[slot_id].wp_pin = NULL;
>         }
>
>         return pdata;
> @@ -1511,8 +1520,8 @@ static int atmci_get_ro(struct mmc_host *mmc)
>         int                     read_only = -ENOSYS;
>         struct atmel_mci_slot   *slot = mmc_priv(mmc);
>
> -       if (gpio_is_valid(slot->wp_pin)) {
> -               read_only = gpio_get_value(slot->wp_pin);
> +       if (slot->wp_pin) {
> +               read_only = gpiod_get_value(slot->wp_pin);
>                 dev_dbg(&mmc->class_dev, "card is %s\n",
>                                 read_only ? "read-only" : "read-write");
>         }
> @@ -1525,8 +1534,8 @@ static int atmci_get_cd(struct mmc_host *mmc)
>         int                     present = -ENOSYS;
>         struct atmel_mci_slot   *slot = mmc_priv(mmc);
>
> -       if (gpio_is_valid(slot->detect_pin)) {
> -               present = !(gpio_get_value(slot->detect_pin) ^
> +       if (slot->detect_pin) {
> +               present = !(gpiod_get_raw_value(slot->detect_pin) ^
>                             slot->detect_is_active_high);
>                 dev_dbg(&mmc->class_dev, "card is %spresent\n",
>                                 present ? "" : "not ");
> @@ -1639,8 +1648,8 @@ static void atmci_detect_change(struct timer_list *t)
>         if (test_bit(ATMCI_SHUTDOWN, &slot->flags))
>                 return;
>
> -       enable_irq(gpio_to_irq(slot->detect_pin));
> -       present = !(gpio_get_value(slot->detect_pin) ^
> +       enable_irq(gpiod_to_irq(slot->detect_pin));
> +       present = !(gpiod_get_raw_value(slot->detect_pin) ^
>                     slot->detect_is_active_high);
>         present_old = test_bit(ATMCI_CARD_PRESENT, &slot->flags);
>
> @@ -2241,9 +2250,9 @@ static int atmci_init_slot(struct atmel_mci *host,
>         dev_dbg(&mmc->class_dev,
>                 "slot[%u]: bus_width=%u, detect_pin=%d, "
>                 "detect_is_active_high=%s, wp_pin=%d\n",
> -               id, slot_data->bus_width, slot_data->detect_pin,
> +               id, slot_data->bus_width, desc_to_gpio(slot_data->detect_pin),
>                 slot_data->detect_is_active_high ? "true" : "false",
> -               slot_data->wp_pin);
> +               desc_to_gpio(slot_data->wp_pin));
>
>         mmc->ops = &atmci_ops;
>         mmc->f_min = DIV_ROUND_UP(host->bus_hz, 512);
> @@ -2279,51 +2288,43 @@ static int atmci_init_slot(struct atmel_mci *host,
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
> +       if (slot->detect_pin) {
> +               if (gpiod_get_raw_value(slot->detect_pin) ^
> +                   slot->detect_is_active_high) {
>                         clear_bit(ATMCI_CARD_PRESENT, &slot->flags);
>                 }
> +       } else {
> +               dev_dbg(&mmc->class_dev, "no detect pin available\n");
>         }
>
> -       if (!gpio_is_valid(slot->detect_pin)) {
> +       if (!slot->detect_pin) {
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
> +       if (!slot->wp_pin)
> +               dev_dbg(&mmc->class_dev, "no WP pin available\n");
>
>         host->slot[id] = slot;
>         mmc_regulator_get_supply(mmc);
> -       mmc_pwrseq_alloc(slot->mmc);
>         mmc_add_host(mmc);
>
> -       if (gpio_is_valid(slot->detect_pin)) {
> +       if (slot->detect_pin) {
>                 int ret;
>
>                 timer_setup(&slot->detect_timer, atmci_detect_change, 0);
>
> -               ret = request_irq(gpio_to_irq(slot->detect_pin),
> -                               atmci_detect_interrupt,
> -                               IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> -                               "mmc-detect", slot);
> +               ret = request_irq(gpiod_to_irq(slot->detect_pin),
> +                                 atmci_detect_interrupt,
> +                                 IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +                                 "mmc-detect", slot);
>                 if (ret) {
>                         dev_dbg(&mmc->class_dev,
>                                 "could not request IRQ %d for detect pin\n",
> -                               gpio_to_irq(slot->detect_pin));
> -                       slot->detect_pin = -EBUSY;
> +                               gpiod_to_irq(slot->detect_pin));
> +                       slot->detect_pin = NULL;
>                 }
>         }
>
> @@ -2342,10 +2343,8 @@ static void atmci_cleanup_slot(struct atmel_mci_slot *slot,
>
>         mmc_remove_host(slot->mmc);
>
> -       if (gpio_is_valid(slot->detect_pin)) {
> -               int pin = slot->detect_pin;
> -
> -               free_irq(gpio_to_irq(pin), slot);
> +       if (slot->detect_pin) {
> +               free_irq(gpiod_to_irq(slot->detect_pin), slot);
>                 del_timer_sync(&slot->detect_timer);
>         }
>
> diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
> index 1491af38cc6e..017e7d8f6126 100644
> --- a/include/linux/atmel-mci.h
> +++ b/include/linux/atmel-mci.h
> @@ -26,8 +26,8 @@
>   */
>  struct mci_slot_pdata {
>         unsigned int            bus_width;
> -       int                     detect_pin;
> -       int                     wp_pin;
> +       struct gpio_desc        *detect_pin;
> +       struct gpio_desc        *wp_pin;
>         bool                    detect_is_active_high;
>         bool                    non_removable;
>  };
> --
> 2.25.1
>
