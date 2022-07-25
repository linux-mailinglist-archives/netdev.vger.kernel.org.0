Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAF45804EF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbiGYUBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGYUBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:01:22 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215FFBC06;
        Mon, 25 Jul 2022 13:01:21 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w5so2939723edd.13;
        Mon, 25 Jul 2022 13:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wNN4mVH/SyRJ4COePe/9hQsezCFR8p9Jr07EoPN/p4A=;
        b=nfnsmf/qvqvc5ltskEbdtr6EvX8N2U/ovpyM+8utCHHbKQ7vEG8XXGxwwn8GOGZjIT
         Qd1DlaQ1Maq+BHEd9wwsJKt2d5noQCpHMcOewHJPs4saWqV5dH8YzHXzd2kKAtfq2rh7
         l4XGznfiy5VAfzymRVT3prJMShafPZKZNcTm2HRYt7L9ARq8hFX7V5gSguxVlU1b26Jm
         ok8DTkQJrNKtINpqn62pnHNgjV1XNcH/pGUwfIN935p1uD6gcVA628+ZK+gJa/8957Pg
         memaWLIe+wgYMPkHJJCVD+3J7nMKzEY3MVvDr9ET6P39Xp8qXvNiu94UuPtw7JTzEZXD
         ZeuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wNN4mVH/SyRJ4COePe/9hQsezCFR8p9Jr07EoPN/p4A=;
        b=cQh1ushUbYINen4pKH2EpXP9rOxG/cMAtuyTnE0HZdyL8dSaVTs8ilX0ZH3xM0dEJQ
         MZ09OFN/E28A9G9wU70xvSRGq6JS+OGvFXHnertwiJV5qiUXd7ri3Q88rFtTIE63he4s
         sRQ0Gwb1ez4BmrT/t6kbWqteKqU9LvVcT1TMApciIZhPsjEKNP4klMZPV84p2XrFBNSx
         U29USmhux9qc4BH2jvHxVNj8fmThLMaPPulXpRri6+FAtxhevFfOS4Ig9JslT+JvjLi2
         ePzzWUudScj9CuDre6SBWaZQtMIRKboJfAASLcvi/HkbB7bHt91yFic8TMbTz+bv/aEN
         CGKQ==
X-Gm-Message-State: AJIora+OseXzFO1fpC4dXhNHsmeynmjt139UcyoXKepI34zB7eEFbBMs
        olles2YFTDSVOsX3IHZYIOuqKLVfffWxRrW752I=
X-Google-Smtp-Source: AGRyM1uZYoYheybNUnbJ68eFBR+LM7u2yM88gm1gyLYXLPjJ7d6vPulcanpsEcwWbMnl8jaGTgIWuvQFYghYKGQ162M=
X-Received: by 2002:a05:6402:d53:b0:43b:a0cf:d970 with SMTP id
 ec19-20020a0564020d5300b0043ba0cfd970mr14532718edb.277.1658779279416; Mon, 25
 Jul 2022 13:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220722040609.91703-1-colin.foster@in-advantage.com> <20220722040609.91703-10-colin.foster@in-advantage.com>
In-Reply-To: <20220722040609.91703-10-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 25 Jul 2022 22:00:42 +0200
Message-ID: <CAHp75Ve-pqgb56punEL=p=PnEtjRnqTBSqgs+vVn1Zv8F94g9Q@mail.gmail.com>
Subject: Re: [PATCH v14 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 6:06 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
>
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.

...

+bits.h

> +#include <linux/kernel.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/ocelot.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>

...

> +#define VSC7512_MIIM_RES_SIZE          0x24
> +#define VSC7512_PHY_RES_SIZE           0x4

Can you make _SIZEs to be fixed width? Like 0x004 here.

> +#define VSC7512_GPIO_RES_SIZE          0x6c

> +#define VSC7512_SIO_CTRL_RES_SIZE      0x100

...

> +       ret = readx_poll_timeout(ocelot_gcb_chip_rst_status, ddata, val, !val,
> +                                VSC7512_GCB_RST_SLEEP_US, VSC7512_GCB_RST_TIMEOUT_US);
> +       return ret;

return readx_poll_timeou(...);

...

> +static int ocelot_spi_regmap_bus_read(void *context, const void *reg, size_t reg_size,
> +                                     void *val, size_t val_size)
> +{
> +       struct spi_transfer tx, padding, rx;
> +       struct device *dev = context;
> +       struct ocelot_ddata *ddata;
> +       struct spi_device *spi;
> +       struct spi_message msg;
> +
> +       ddata = dev_get_drvdata(dev);
> +       spi = to_spi_device(dev);
> +
> +       spi_message_init(&msg);
> +
> +       memset(&tx, 0, sizeof(tx));
> +
> +       tx.tx_buf = reg;
> +       tx.len = reg_size;
> +
> +       spi_message_add_tail(&tx, &msg);
> +
> +       if (ddata->spi_padding_bytes) {
> +               memset(&padding, 0, sizeof(padding));
> +
> +               padding.len = ddata->spi_padding_bytes;
> +               padding.tx_buf = ddata->dummy_buf;
> +               padding.dummy_data = 1;
> +
> +               spi_message_add_tail(&padding, &msg);
> +       }
> +
> +       memset(&rx, 0, sizeof(rx));
> +       rx.rx_buf = val;
> +       rx.len = val_size;
> +
> +       spi_message_add_tail(&rx, &msg);

I'm wondering if you can use in both cases
spi_message_init_with_transfers(). (Note you may explicitly as SPI
core to toggle CS if needed)

> +       return spi_sync(spi, &msg);
> +}

...

> +static int ocelot_spi_regmap_bus_write(void *context, const void *data, size_t count)
> +{
> +       struct device *dev = context;
> +       struct spi_device *spi;
> +
> +       spi = to_spi_device(dev);

Can be unified with definition block above to save 2 LoCs.

> +       return spi_write(spi, data, count);
> +}

...

> +               ddata->spi_padding_bytes = 1 + (spi->max_speed_hz / 1000000 + 2) / 8;

HZ_PER_MHZ ?

...

> +       /*
> +        * A chip reset will clear the SPI configuration, so it needs to be done
> +        * again before we can access any registers

Missed period.

> +        */

...

> +       err = ocelot_core_init(dev);
> +       if (err < 0)

Does ' < 0' part here and everywhere else bring any value?

> +               return dev_err_probe(dev, err, "Error initializing Ocelot core\n");

...

> + * struct ocelot_ddata - Private data for an external Ocelot chip
> + *

No need for this and blank lines between field descriptions..

> + * @gcb_regmap:                General Configuration Block regmap. Used for
> + *                     operations like chip reset.
> + *
> + * @cpuorg_regmap:     CPU Device Origin Block regmap. Used for operations
> + *                     like SPI bus configuration.
> + *
> + * @spi_padding_bytes: Number of padding bytes that must be thrown out before
> + *                     read data gets returned. This is calculated during
> + *                     initialization based on bus speed.
> + *
> + * @dummy_buf:         Zero-filled buffer of spi_padding_bytes size. The dummy
> + *                     bytes that will be sent out between the address and
> + *                     data of a SPI read operation.

--
With Best Regards,
Andy Shevchenko
