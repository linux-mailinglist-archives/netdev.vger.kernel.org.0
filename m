Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F116651F810
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 11:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiEIJ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236381AbiEIJH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 05:07:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3891D4A01;
        Mon,  9 May 2022 02:03:34 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id d6so15456964ede.8;
        Mon, 09 May 2022 02:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CUCKrYgDcQ1ovRNlaPi0ouGBWPagl7uuIjCRC+fjjgU=;
        b=iwyNx79zCyjneqByG4hWPdFpAWnpNfBTGCCL8MHC2ie7qSqt0rFxosc5hNbfqe5uA9
         EANnHF2Tr2gQGK0dWUjifLqkTCt191jsteGrJTEOxf/pTxUYOpkP9tQryU7nGN2dOVal
         eBFEP+T0hwqWsM8RbfbrlmURZKwbyGDv0FtCaRCMBEo+loAZll0tM/A1vStsGtPlforY
         nNshSRxaYeU4ky3Sl9ktxki2AsEXcvuRHfNx7YKenN4if8yGKp4W2TQJqoe9jdRarQ/3
         XtyWfmbEor0oM/9ma3wZGY9b7cFGO7RSoesgUuVXHz08/1l+lIg7F01kwD72Q3s5e/JO
         e64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CUCKrYgDcQ1ovRNlaPi0ouGBWPagl7uuIjCRC+fjjgU=;
        b=Dkx8+3HsHFR3p6x1l1B/nNq0NWhDyUEeQNLDbzp7WALpPI3jEnltYPd5mbUCtLk2ty
         JYhZ9cCrXa2QASQiRfOqPTi+vnHeguSZxidA/91oy43PG5fK2oK2TecC+pyMJs1Tj8Ye
         Y2lbJOmUxA6wq3jC/fGcP4ckxwhm0kRjY0Pv09fqDXLICYQegurkE1orBNQ83NRg30RW
         pINCEvTJZoU4wXw91VVxzNtLChx81iOS5aw8hGzfpWc/UtqKdPhlHK7dFj0E/3IGJ6tB
         UTBzamsEqZEjI8xAutSeNPSBdz5Ye/3oqT3tUkfds17x8wZUjPJ8dRifxXgUfVwrJPcx
         qENg==
X-Gm-Message-State: AOAM533vLUiU1x/t3iyv05ArtEVadsRzaA/gz6MRc2TBMEnfbBwsdJnV
        n8Mhyjbh1ucjivdqwLOxlTGAa7FrDNYK+7j8Xmk=
X-Google-Smtp-Source: ABdhPJzvQXgP0aZCwYzhKA0UAEobSdjZ/pC+3IXCRCcSEQQekkq6YODgbL/1UTXpty2C+UM1Z+oBKG0W+vULZTtwrdI=
X-Received: by 2002:aa7:d916:0:b0:425:d75f:ae68 with SMTP id
 a22-20020aa7d916000000b00425d75fae68mr16090053edr.270.1652086998298; Mon, 09
 May 2022 02:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220508185313.2222956-1-colin.foster@in-advantage.com> <20220508185313.2222956-9-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-9-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 9 May 2022 11:02:42 +0200
Message-ID: <CAHp75VdnFSP9-D=O3h5L80O19xK7ct6ax6kXGfHEiKe9niktYA@mail.gmail.com>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 8, 2022 at 8:53 PM Colin Foster
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

> +         If unsure, say N

Seems like an abrupt sentence.

...

> +EXPORT_SYMBOL(ocelot_chip_reset);

Please, switch to the namespace (_NS) variant of the exported-imported
symbols for these drivers.

...

> +int ocelot_core_init(struct device *dev)
> +{
> +       int ret;
> +
> +       ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs,
> +                                  ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
> +       if (ret) {
> +               dev_err(dev, "Failed to add sub-devices: %d\n", ret);
> +               return ret;
> +       }
> +
> +       return 0;

Isn't it simple

  return devm_mfd_add_devices(...);

?

> +}

...

> +#include <linux/of.h>

Do you really use this? (See also below).

...

> +#define VSC7512_CPUORG_RES_START       0x71000000
> +#define VSC7512_CPUORG_RES_SIZE                0x2ff

Doesn't look right.
I'm expecting to see 0x300 here and -1 where it's needed in the code.

...

> +static const struct regmap_config ocelot_spi_regmap_config = {
> +       .reg_bits = 24,
> +       .reg_stride = 4,
> +       .reg_downshift = 2,
> +       .val_bits = 32,
> +
> +       .write_flag_mask = 0x80,

> +       .max_register = 0xffffffff,

Is it for real?! Have you considered what happens if someone actually
tries to read all these registers (and for the record it's not a
theoretical case, since the user may do it via debugfs)?

> +       .use_single_write = true,
> +       .can_multi_write = false,
> +
> +       .reg_format_endian = REGMAP_ENDIAN_BIG,
> +       .val_format_endian = REGMAP_ENDIAN_NATIVE,
> +};

...

> +       if (ddata->spi_padding_bytes > 0) {

' > 0' part is redundant.

> +               memset(&padding, 0, sizeof(padding));
> +
> +               padding.len = ddata->spi_padding_bytes;
> +               padding.tx_buf = dummy_buf;
> +               padding.dummy_data = 1;
> +
> +               spi_message_add_tail(&padding, &msg);
> +       }

...

> +       memcpy(&regmap_config, &ocelot_spi_regmap_config,
> +              sizeof(ocelot_spi_regmap_config));

sizeof(regmap_config) is a bit safer (in case somebody changes the
types of the src and dst).

...

> +       err = spi_setup(spi);
> +       if (err < 0) {
> +               dev_err(&spi->dev, "Error %d initializing SPI\n", err);
> +               return err;

return dev_err_probe(...);

> +       }
...

> +       ddata->cpuorg_regmap =
> +               ocelot_spi_devm_init_regmap(dev, dev,
> +                                           &vsc7512_dev_cpuorg_resource);

It's easier to read when it's a longer line. At least the last two can
be on one line.

...

> +       ddata->gcb_regmap = ocelot_spi_devm_init_regmap(dev, dev,
> +                                                       &vsc7512_gcb_resource);

Do you have different cases for two first parameters? If not, drop duplication.

...

> +       if (err) {
> +               dev_err(dev, "Error %d initializing Ocelot SPI bus\n", err);
> +               return err;

return dev_err_probe(...);

And everywhere else where it's appropriate.

> +       }

...

> +const struct of_device_id ocelot_spi_of_match[] = {
> +       { .compatible = "mscc,vsc7512_mfd_spi" },
> +       { },

No comma for terminator entry.

> +};

...

> +               .of_match_table = of_match_ptr(ocelot_spi_of_match),

of_match_ptr() is rather harmful than useful. We have a lot of
compiler warnings due to misuse of this. Besides that it prevents to
use driver in non-OF environments (if it is / will be the case).

...

> +/*
> + * Copyright 2021 Innovative Advantage Inc.
> + */

One line.

...

> +#include <linux/regmap.h>

I don't see the users of this. Use forward declarations (many of them
are actually missed).

Also, seems kconfig.h, err.h and errno.h missed.

> +#include <asm/byteorder.h>

> +struct ocelot_ddata {
> +       struct device *dev;
> +       struct regmap *gcb_regmap;
> +       struct regmap *cpuorg_regmap;
> +       int spi_padding_bytes;
> +       struct spi_device *spi;
> +};

...

> +#if IS_ENABLED(CONFIG_MFD_OCELOT)
> +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> +                                               const struct resource *res);
> +#else
>  static inline struct regmap *
>  ocelot_init_regmap_from_resource(struct device *child,
>                                  const struct resource *res)
>  {
>         return ERR_PTR(-EOPNOTSUPP);
>  }

-- 
With Best Regards,
Andy Shevchenko
