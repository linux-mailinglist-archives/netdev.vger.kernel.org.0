Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A82563B31
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiGAUj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiGAUjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:39:25 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694935A2D9;
        Fri,  1 Jul 2022 13:39:24 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id o19so5977830ybg.2;
        Fri, 01 Jul 2022 13:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vmpdhz2MZms21RljAHKQJe5ukt7DpuDeSaFEOMnP2tg=;
        b=OHthEuiGA0aw0q3wK0vCa25L6+8RrWXc+L3SxWr/oP5eTN+QlIlRI4dCxxuWyn7cWi
         BXjq76rdjYJdx/oOOWcAnPikEXvJrSqeOB31Me2F0asjXUGMTrrxbmJlb8caVC1Up9m8
         vpyOEY/h+2nphaFjowQnRxgO2BPNfsBJ5mMxRH8cwygRLznaSbhvRW9mf4MnHVvyNm+2
         o34c0T3JpNjpFgQlFId/4mZaa89u7cRCdtNDX06Cw6IwEuOvWYipi9itXyfn6rfB2D58
         JnIpLj01BuGh8F/bPRfj/Cdc+ntjq7mwMya/W0DoUVLEZ/imHP2C+TcPpvuw9vIMxqnk
         XGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vmpdhz2MZms21RljAHKQJe5ukt7DpuDeSaFEOMnP2tg=;
        b=xIxpfmLHFFKkZ7s5Vw5WCkGrlzjfMZSOcmVCPn5FfqpJCp3INMqLaMYaTCvSdiYO0W
         kXvD9alcnjRkdNNjOb7QJwdI3QP8Y6cz2RB0ztlNgLeUqz1+PMBAVze7tvOmt+LMwlGX
         H3gjI8hbSYgjfVUusMOPG/yTO2LDrUt+y2NTWpAndhMvZAdgAdpNZamak9p/ZP5Om96l
         zowwagS0lM4qOpqtBXBv2kNqGyJ7xB55QNjCfo9wrMuCWVtNP3WdPFfxdlP4jgUEo3t3
         XmT7WYP5j+MufnBIcr5Qt3w/PxyBIMxda0mq/LcUC9tgzN8NqDIr5rRbWd0jcoyZnKCa
         lT0w==
X-Gm-Message-State: AJIora8Z/bv+qU8IqRXIybKipKir8GcbIfzfm/nRh80shrIEO554PtDo
        pS5h4fOsuCtduE5Sa891P0sPWkNZGn2rJCk+N50=
X-Google-Smtp-Source: AGRyM1s9GkQeoOpM7XRM53cmXQcpT2TUqqfoQ84USYGIHTmRiZZvIGJtxxuk/hTDOlq7xtWIbORPd5VLYeOoPYsmbE0=
X-Received: by 2002:a05:6902:10c9:b0:668:e27c:8f7 with SMTP id
 w9-20020a05690210c900b00668e27c08f7mr17229851ybu.128.1656707963560; Fri, 01
 Jul 2022 13:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220701192609.3970317-1-colin.foster@in-advantage.com> <20220701192609.3970317-10-colin.foster@in-advantage.com>
In-Reply-To: <20220701192609.3970317-10-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 22:38:46 +0200
Message-ID: <CAHp75VcfKS9Y+T5LPRk0SFHJCGarJ2wS2gwii=a+1it03S+_Og@mail.gmail.com>
Subject: Re: [PATCH v12 net-next 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
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

On Fri, Jul 1, 2022 at 9:26 PM Colin Foster
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

> +config MFD_OCELOT
> +       tristate "Microsemi Ocelot External Control Support"
> +       depends on SPI_MASTER
> +       select MFD_CORE
> +       select REGMAP_SPI
> +       help
> +         Ocelot is a family of networking chips that support multiple ethernet
> +         and fibre interfaces. In addition to networking, they contain several
> +         other functions, including pinctrl, MDIO, and communication with
> +         external chips. While some chips have an internal processor capable of
> +         running an OS, others don't. All chips can be controlled externally
> +         through different interfaces, including SPI, I2C, and PCIe.
> +
> +         Say yes here to add support for Ocelot chips (VSC7511, VSC7512,
> +         VSC7513, VSC7514) controlled externally.
> +
> +         If unsure, say N.

What will be the module name?

...

It misses a few inclusions, like kernel.h for ARRAY_SIZE() and types.h
for booleans.

> +#include <linux/mfd/core.h>
> +#include <linux/mfd/ocelot.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>

+ blank line?

> +#include <soc/mscc/ocelot.h>

...

> +#define GCB_SOFT_RST                   0x0008
> +
> +#define SOFT_CHIP_RST                  0x1

It's not clear what these values are: register offsets? Bit fields of
the hardware registers? Commands to some IPC?

> +#define VSC7512_GCB_RST_SLEEP          100
> +#define VSC7512_GCB_RST_TIMEOUT                100000

Missed units in both cases.

...


> +static int ocelot_gcb_chip_rst_status(struct ocelot_ddata *ddata)
> +{
> +       int val, err;
> +
> +       err = regmap_read(ddata->gcb_regmap, GCB_SOFT_RST, &val);
> +       if (err)

> +               val = -1;

Can be returned directly. Why not a proper error code, btw?

> +       return val;
> +}

...

> +#include <linux/iopoll.h>

What for? Maybe it should be ioport.h ?


...

> +       static const u8 dummy_buf[16] = {0};

On stack for DMA?! Hmm...
...

> +       err = spi_setup(spi);
> +       if (err < 0) {
> +               return dev_err_probe(&spi->dev, err,
> +                                    "Error performing SPI setup\n");
> +       }

{} are not needed.

...

> +       err = ocelot_spi_initialize(dev);
> +       if (err) {
> +               return dev_err_probe(dev, err,
> +                                    "Error initializing SPI bus after reset\n");
> +       }

{} are not needed.

> +       err = ocelot_core_init(dev);
> +       if (err < 0) {

Ditto.

> +               return dev_err_probe(dev, err,
> +                                    "Error initializing Ocelot core\n");

> +               return err;

Dead code.

> +       }

...

> +#include <asm/byteorder.h>

You missed a lot of forward declarations that are used in this file.

Like

struct spi_device;

-- 
With Best Regards,
Andy Shevchenko
