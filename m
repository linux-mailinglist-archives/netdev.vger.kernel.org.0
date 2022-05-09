Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B2E51F737
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiEIIuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiEIIm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:42:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4627E140872;
        Mon,  9 May 2022 01:38:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y21so15399968edo.2;
        Mon, 09 May 2022 01:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMazJG1oZcfw9sE9cXd6CynJ8lCT3EbZsgzh9ET7llc=;
        b=HxqlKqKeHdAkLav9aMokH/SXokLXWb9BhNm//vtgIXmDIn86Z6/3SvvYKcCc5UKy0o
         Zx9XAOXMeKRjxCF9EYDzTufoCUeyolmULuo7/rU3Rjao2omT9G6xcupLbqZkoc44JXaa
         50QOzGSfVxIZOa5tS148cITb5MjXIvLU1WyZwjWyAmCjtcijUHdIit6PrwBazqB519xv
         QQCiUC9H1P8buGeOl11NuLxB8ZuvER3UIcofc0gdQUMa+FcsLOpiDHKXdtoraBybJ5hz
         Zmo2FNHjYFut1ijhesoR56LYM+be4ufdPHGqO8KvL+TrImV9R/Yc7IU2qZ0jy0/STcCp
         kkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMazJG1oZcfw9sE9cXd6CynJ8lCT3EbZsgzh9ET7llc=;
        b=5cs9VK+7DLxGmbKqBl2ruo7k0uU/RHwov1lvLZDoDnWwQso+iU6Wq0nU4H3/f1kbuf
         1ymVphJuzNnKcCxEYv+wVeDLTIF4zHo3aATInxxrEaMsUiFhYtSRxhdzxi3TGh9hlqpg
         +sF4pwRl10QuBNyXHziSFIhROxPDfM1Z8QwwvuKrwwFansgFOOCsxHP8VC8Qo2IkPVMG
         h4HOTh7fJUgfB+Pptym+YI4wzgGoF5AEOwFaD4Be/J7nzvNJELLKcDKtfckwEBI/9lSC
         n7So+tvkjlerUGwCgmxhpEVWsuf03XEphObPx1MM4e9DyDyS8J0SYzoBD/gtQ3u8Pbs+
         lS9A==
X-Gm-Message-State: AOAM531QYu7ANJDtBZQ6YNNc1nYGNy5N+awPCxk3/6v1jZcTTDZdOI65
        4m9MVjR3mIbJvD+BQAGDd9ZzWjq3ZI3t+vPYQL0=
X-Google-Smtp-Source: ABdhPJxPNHvB6kOHwLXMMY8KJ0zo5PF4zplUttHJE5Now4O5zEi0RU/QKdR1DnT0barRkwwdDupynTd9JkWHag3pmTM=
X-Received: by 2002:a50:e696:0:b0:419:998d:5feb with SMTP id
 z22-20020a50e696000000b00419998d5febmr16524780edm.122.1652085506199; Mon, 09
 May 2022 01:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220508185313.2222956-1-colin.foster@in-advantage.com> <20220508185313.2222956-6-colin.foster@in-advantage.com>
In-Reply-To: <20220508185313.2222956-6-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 9 May 2022 10:37:49 +0200
Message-ID: <CAHp75VcFpY6-ed5RYWg+N=U1F5o+GyJZB-8kThJ-nZvg9gwBVA@mail.gmail.com>
Subject: Re: [RFC v8 net-next 05/16] pinctrl: ocelot: add ability to be used
 in a non-mmio configuration
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
> There are a few Ocelot chips that contain pinctrl logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

...

> +#if defined(REG)

Redundant.

> +#undef REG
> +#endif

...

> +               res = platform_get_resource(pdev, IORESOURCE_REG, 0);
> +               if (!res) {
> +                       dev_err(dev, "Failed to get resource\n");
> +                       return -ENODEV;

return dev_err_probe(...); ?

> +               }

...

>         if (IS_ERR(info->map)) {
>                 dev_err(dev, "Failed to create regmap\n");
>                 return PTR_ERR(info->map);

Ditto.

-- 
With Best Regards,
Andy Shevchenko
