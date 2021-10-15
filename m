Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E584F42E99D
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhJOHDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhJOHDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:03:37 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340F3C061755
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 00:01:31 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a25so34168744edx.8
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 00:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FmKkfM/1eZ6CH+Nh6bYE9seKAU754cBloquUZK6mdqE=;
        b=tkVzioxgPLgsxZof6tus91cnxKZrzjdS3z8DEavY8Oi1OmMtqCq65N6JS1GsMCc4eA
         FgHR7JSmgPMtQpjkLN/lfLULjd48xbrDVeqlAkxp50zIr1GeKu9SxZzpcjOE8rsWpaLO
         EibptvGr56Ot3HqH2G3Zlrxle/LeVe8kMX97EkEC1Wlstn6q9cA2NbvwBE8994ePisfL
         /a75reki8xcXuHO6KF/rWatMH67cTf+Tk5yjSZXGfIe3NKPRRCROYb2B0R7ew21kwpZ6
         MANAKNTSFOG2qsLQVxsKcFpSh04JMzklntlFlllhVRkte4a7whRCrjoNwBvv2TRnuqe0
         MR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FmKkfM/1eZ6CH+Nh6bYE9seKAU754cBloquUZK6mdqE=;
        b=jb0Cvz4ypSjkbGVffcV9D+qa11ybNfeKGxdbdHtzzFXcTP9YiSpW5gPhz/bPDXKBAa
         eMaqLE2VpYUmf3PvuS2cJeCgWrYqv8i9G5e9I74g3Hz4zbxsREGm9MINAaqnJKl25u5w
         xyvn41vLusaZMCAhZqnTvn5xTkwLJfcrsGSa++lPTz/5SO60GWg/TR2SRnWLSKjacuC8
         S58tuwFoayuO3olqIi2FBKMGLnMKUdPBPdjRk2bSs/rpHeMKCyjPNNW7XIFd5Wil9Idc
         WnGp69X7k+tNlmWBzsDYo6Vr5LOFExF986K7Wnq1lFLZujIl2CPDoscmMEYprOdBpCy/
         nFKQ==
X-Gm-Message-State: AOAM532b6YGbKVzBnvU6+sm9/YWQZ62DLxPyxlILYxplgPR28aeyqxyj
        c0chy9Iw3xrknC3Xy2OdUV4DSU9gjfzOOLf+03UOCQ==
X-Google-Smtp-Source: ABdhPJwNoPIEp9DqsKcjRA/4bQg99WBVvXwoh/QRRh1FQrhwZnaIKoS9tr3rFItF7II3bnd8+H/p9XfpTYmuH2TO/1A=
X-Received: by 2002:a50:d50c:: with SMTP id u12mr15591860edi.118.1634281287150;
 Fri, 15 Oct 2021 00:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211008144920.10975-1-asmaa@nvidia.com> <20211008144920.10975-2-asmaa@nvidia.com>
In-Reply-To: <20211008144920.10975-2-asmaa@nvidia.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Fri, 15 Oct 2021 09:01:16 +0200
Message-ID: <CAMRc=Mc4yJZ2qv7W+mk-jJhhxEwe+7VowJt51ZekpVrZ=4LsZA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] gpio: mlxbf2: Introduce IRQ support
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, davthompson@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 8, 2021 at 4:50 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:
>
> Introduce standard IRQ handling in the gpio-mlxbf2.c
> driver.
>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> ---
>  drivers/gpio/gpio-mlxbf2.c | 147 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 145 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
> index 177d03ef4529..3d89912a05b8 100644
> --- a/drivers/gpio/gpio-mlxbf2.c
> +++ b/drivers/gpio/gpio-mlxbf2.c
> @@ -1,9 +1,14 @@
>  // SPDX-License-Identifier: GPL-2.0
>
> +/*
> + * Copyright (C) 2020-2021 NVIDIA CORPORATION & AFFILIATES
> + */
> +
>  #include <linux/bitfield.h>
>  #include <linux/bitops.h>
>  #include <linux/device.h>
>  #include <linux/gpio/driver.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/ioport.h>
>  #include <linux/kernel.h>
> @@ -43,9 +48,14 @@
>  #define YU_GPIO_MODE0                  0x0c
>  #define YU_GPIO_DATASET                        0x14
>  #define YU_GPIO_DATACLEAR              0x18
> +#define YU_GPIO_CAUSE_RISE_EN          0x44
> +#define YU_GPIO_CAUSE_FALL_EN          0x48
>  #define YU_GPIO_MODE1_CLEAR            0x50
>  #define YU_GPIO_MODE0_SET              0x54
>  #define YU_GPIO_MODE0_CLEAR            0x58
> +#define YU_GPIO_CAUSE_OR_CAUSE_EVTEN0  0x80
> +#define YU_GPIO_CAUSE_OR_EVTEN0                0x94
> +#define YU_GPIO_CAUSE_OR_CLRCAUSE      0x98
>
>  struct mlxbf2_gpio_context_save_regs {
>         u32 gpio_mode0;
> @@ -55,6 +65,7 @@ struct mlxbf2_gpio_context_save_regs {
>  /* BlueField-2 gpio block context structure. */
>  struct mlxbf2_gpio_context {
>         struct gpio_chip gc;
> +       struct irq_chip irq_chip;
>
>         /* YU GPIO blocks address */
>         void __iomem *gpio_io;
> @@ -218,15 +229,114 @@ static int mlxbf2_gpio_direction_output(struct gpio_chip *chip,
>         return ret;
>  }
>
> +static void mlxbf2_gpio_irq_enable(struct irq_data *irqd)
> +{
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +       struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
> +       int offset = irqd_to_hwirq(irqd);
> +       unsigned long flags;
> +       u32 val;
> +
> +       spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
> +       val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
> +       val |= BIT(offset);
> +       writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
> +
> +       val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> +       val |= BIT(offset);
> +       writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> +       spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
> +}
> +
> +static void mlxbf2_gpio_irq_disable(struct irq_data *irqd)
> +{
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +       struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
> +       int offset = irqd_to_hwirq(irqd);
> +       unsigned long flags;
> +       u32 val;
> +
> +       spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
> +       val = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> +       val &= ~BIT(offset);
> +       writel(val, gs->gpio_io + YU_GPIO_CAUSE_OR_EVTEN0);
> +       spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
> +}
> +
> +static irqreturn_t mlxbf2_gpio_irq_handler(int irq, void *ptr)
> +{
> +       struct mlxbf2_gpio_context *gs = ptr;
> +       struct gpio_chip *gc = &gs->gc;
> +       unsigned long pending;
> +       u32 level;
> +
> +       pending = readl(gs->gpio_io + YU_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> +       writel(pending, gs->gpio_io + YU_GPIO_CAUSE_OR_CLRCAUSE);
> +
> +       for_each_set_bit(level, &pending, gc->ngpio) {
> +               int gpio_irq = irq_find_mapping(gc->irq.domain, level);
> +               generic_handle_irq(gpio_irq);
> +       }
> +
> +       return IRQ_RETVAL(pending);
> +}
> +
> +static int
> +mlxbf2_gpio_irq_set_type(struct irq_data *irqd, unsigned int type)
> +{
> +       struct gpio_chip *gc = irq_data_get_irq_chip_data(irqd);
> +       struct mlxbf2_gpio_context *gs = gpiochip_get_data(gc);
> +       int offset = irqd_to_hwirq(irqd);
> +       unsigned long flags;
> +       bool fall = false;
> +       bool rise = false;
> +       u32 val;
> +
> +       switch (type & IRQ_TYPE_SENSE_MASK) {
> +       case IRQ_TYPE_EDGE_BOTH:
> +               fall = true;
> +               rise = true;
> +               break;
> +       case IRQ_TYPE_EDGE_RISING:
> +               rise = true;
> +               break;
> +       case IRQ_TYPE_EDGE_FALLING:
> +               fall = true;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       spin_lock_irqsave(&gs->gc.bgpio_lock, flags);
> +       if (fall) {
> +               val = readl(gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
> +               val |= BIT(offset);
> +               writel(val, gs->gpio_io + YU_GPIO_CAUSE_FALL_EN);
> +       }
> +
> +       if (rise) {
> +               val = readl(gs->gpio_io + YU_GPIO_CAUSE_RISE_EN);
> +               val |= BIT(offset);
> +               writel(val, gs->gpio_io + YU_GPIO_CAUSE_RISE_EN);
> +       }
> +       spin_unlock_irqrestore(&gs->gc.bgpio_lock, flags);
> +
> +       return 0;
> +}
> +
>  /* BlueField-2 GPIO driver initialization routine. */
>  static int
>  mlxbf2_gpio_probe(struct platform_device *pdev)
>  {
>         struct mlxbf2_gpio_context *gs;
>         struct device *dev = &pdev->dev;
> +       struct gpio_irq_chip *girq;
>         struct gpio_chip *gc;
>         unsigned int npins;
> -       int ret;
> +       const char *name;
> +       int ret, irq;
> +
> +       name = dev_name(dev);
>
>         gs = devm_kzalloc(dev, sizeof(*gs), GFP_KERNEL);
>         if (!gs)
> @@ -256,11 +366,44 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
>                         NULL,
>                         0);
>
> +       if (ret) {
> +               dev_err(dev, "bgpio_init failed\n");
> +               return ret;
> +       }

This is a correct fix but it should be sent as a fix aimed for stable
in a separate branch, as we want that to be backported.

Other than that it looks good to me, which tree do you want it to go through?

Bart

> +
>         gc->direction_input = mlxbf2_gpio_direction_input;
>         gc->direction_output = mlxbf2_gpio_direction_output;
>         gc->ngpio = npins;
>         gc->owner = THIS_MODULE;
>
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq >= 0) {
> +               gs->irq_chip.name = name;
> +               gs->irq_chip.irq_set_type = mlxbf2_gpio_irq_set_type;
> +               gs->irq_chip.irq_enable = mlxbf2_gpio_irq_enable;
> +               gs->irq_chip.irq_disable = mlxbf2_gpio_irq_disable;
> +
> +               girq = &gs->gc.irq;
> +               girq->chip = &gs->irq_chip;
> +               girq->handler = handle_simple_irq;
> +               girq->default_type = IRQ_TYPE_NONE;
> +               /* This will let us handle the parent IRQ in the driver */
> +               girq->num_parents = 0;
> +               girq->parents = NULL;
> +               girq->parent_handler = NULL;
> +
> +               /*
> +                * Directly request the irq here instead of passing
> +                * a flow-handler because the irq is shared.
> +                */
> +               ret = devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler,
> +                                      IRQF_SHARED, name, gs);
> +               if (ret) {
> +                       dev_err(dev, "failed to request IRQ");
> +                       return ret;
> +               }
> +       }
> +
>         platform_set_drvdata(pdev, gs);
>
>         ret = devm_gpiochip_add_data(dev, &gs->gc, gs);
> @@ -315,5 +458,5 @@ static struct platform_driver mlxbf2_gpio_driver = {
>  module_platform_driver(mlxbf2_gpio_driver);
>
>  MODULE_DESCRIPTION("Mellanox BlueField-2 GPIO Driver");
> -MODULE_AUTHOR("Mellanox Technologies");
> +MODULE_AUTHOR("Asmaa Mnebhi <asmaa@nvidia.com>");
>  MODULE_LICENSE("GPL v2");
> --
> 2.30.1
>
