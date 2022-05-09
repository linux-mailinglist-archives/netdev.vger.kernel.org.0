Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644C451F73A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiEIIuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236510AbiEIItU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:49:20 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85871F0DC5;
        Mon,  9 May 2022 01:45:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g20so15409680edw.6;
        Mon, 09 May 2022 01:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pACjuUWFJ5GZIbniWMSNPk/IN6wOmnS55W0CKNtZNbk=;
        b=Ifmf8JI3lGr7NqR25+3ysog33HBpALcK432GUQBzkzQ0BDuRT6oUV6cIXRXot5s1nn
         D/nobqvlRNRbiCCE7wwNyV+2kAxj1RLdPffHBT4QbVbukqt+Uj9zxt3EG4zEXvFO3PtV
         4GW75c5lRqwc4bqouS+jO4egMbalASyYHgqEuBuqJYoHnenTe6VRtfneSo/9RYOQRuBz
         7V+/rspE/7RbYF4N0iVwQRGgJzNo3e9V2jFXgFQyuEA8WVsJ4u+olbEiwy0HHFJUf+ez
         v83Qcq9QC1UIRd3F++wYpm9zy9+VxV9sjBu0yXQXh7B7KeiWRbh5UBXAY7NIVTo/KcOP
         cjkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pACjuUWFJ5GZIbniWMSNPk/IN6wOmnS55W0CKNtZNbk=;
        b=mr61ygtuW0q8moYahNlYr2qQkdZZVZ6k0PlGLkqNIUseG6uQq4/sBmcKdhr9+XURCJ
         5xCwvA0Cnpseljj/rp3e1BuHYYMtNTX2rUE0p3W/V/N8qPt31zReqOkGkgVbvNy7eJvu
         Ijj7ReJiDuqx0FavDaxro7mk/qydYX4cCpjp8wASIXxyvl0o2rsOew9SwOl1WH32wBju
         cQiGSzyxtX6etk4kF/xJX369Xoe/m0mtU20AxDYX67dd0OAvwid9yb8BOcZ8RY2MNhi7
         9tNwf5MVHyNb9eFIvOm68npoPtfssslhBGdyMvK2rJanZr8jOw5PzBqXOKYp6+BBvkWe
         AtMw==
X-Gm-Message-State: AOAM531ucla1wRCeFXCMx4fvFqpYCTcUWA3bnJDu5ua2H6Lb3NpCZFoX
        9mqlDpfZ2UcnGxhKRNM8UoF2+uXoautFLUJPtk0=
X-Google-Smtp-Source: ABdhPJxAyMOf+0tdFqa4L6QCJYoi99Yp4xMOthZru/m//p1OZVJgjJvBaoTjUcXNoTY2kPSYCsp+IKPQuEpnlaAOK1Y=
X-Received: by 2002:a50:e696:0:b0:419:998d:5feb with SMTP id
 z22-20020a50e696000000b00419998d5febmr16548918edm.122.1652085917945; Mon, 09
 May 2022 01:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220508185313.2222956-1-colin.foster@in-advantage.com> <20220508185313.2222956-7-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-7-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 9 May 2022 10:44:42 +0200
Message-ID: <CAHp75VcWWDvakG_OLkTgZYbNeoDH5Bw5U0t-NqmzcYyd44uU_g@mail.gmail.com>
Subject: Re: [RFC v8 net-next 06/16] pinctrl: microchip-sgpio: add ability to
 be used in a non-mmio configuration
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
> There are a few Ocelot chips that can contain SGPIO logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

...

> -       regs = devm_platform_ioremap_resource(pdev, 0);
> -       if (IS_ERR(regs))
> -               return PTR_ERR(regs);
> +       regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> +       if (IS_ERR(regs)) {
> +               /*
> +                * Fall back to using IORESOURCE_REG, which is possible in an
> +                * MFD configuration
> +                */
> +               res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> +               if (!res) {
> +                       dev_err(dev, "Failed to get resource\n");
> +                       return -ENODEV;
> +               }
> +
> +               priv->regs = ocelot_init_regmap_from_resource(dev, res);
> +       } else {
> +               priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
> +       }
>
> -       priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
>         if (IS_ERR(priv->regs))
>                 return PTR_ERR(priv->regs);

This looks like repetition of something you have done in a few
previous patches. Can you avoid code duplication by introducing a
corresponding helper function?

-- 
With Best Regards,
Andy Shevchenko
