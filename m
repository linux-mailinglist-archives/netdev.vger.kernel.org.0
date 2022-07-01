Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3B8563AFC
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiGAUZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGAUZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:25:25 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4293B3EF34;
        Fri,  1 Jul 2022 13:25:24 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-317710edb9dso34698497b3.0;
        Fri, 01 Jul 2022 13:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o5304g2izTzqhKjKH1tS5hpqamPb38vJX8yLFjCUovQ=;
        b=CATAofdzdvUzvhqTeiJWkzmBpqmNrwmSL4nYcPyxFefXxpzx09+VO7ss4+kIAuTkAb
         9sKJnvMckJ8AgnSMLgdf9Mhu5TLmImyDAdUoPWKTxSCzw4CD7UiQFvpo+N8pYgFxMV2s
         jro1jezVFj+YU4PmrxI+yakjQhtXJmyCQJ6112X0JZ1in9TYnbYWI8g/nG4Vsa6bOkfP
         BPvafnWu9lFDqgZuy7nzjtCJW1xz+gf6yucFFZPomG4zridooPGJnjkTowtj4KG6ly/+
         QBQ7iLgeRncsAHlyxcjEypS8lFv/7BVV7AGo/Tt/WfhSOxKp3oSZalqoe5ZLWRehL1n6
         iPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o5304g2izTzqhKjKH1tS5hpqamPb38vJX8yLFjCUovQ=;
        b=3JhYDyVpaltXE/gmLnXPkIS3BSzomdqhIOyO+lSvm8uGR2ua8LwtDEfU+N/NN3KnZF
         5Ol6RCHBA2xuWk32KbEHX+SiKWaYd/pbXnIh08RjmXiomV0N6fI1GHJDmrBqiaGFQqCZ
         42I+dRSscbboWNIJ0tEN3fzM71h6boSk9fzHtrielP/u03J1DAbHr0H6WvjxYp3oMMJ1
         Bs32qBgrmP778aaspYly8LC03B5/ZiJu/5+TFIl9HM4uP/fommWad81AmqlnNY7/qhna
         DhLJj4TeJU88QcVOWOoQqk+A8Frb+gnKDRFRabckVK7V83766Z5c0e/McpvazkZ8507u
         ljuQ==
X-Gm-Message-State: AJIora93a/R1JQc73fCHg1VrcipbDzc5EkOe0daH/5Pydf/xw4SJQwrh
        0Jftm48qp4JTr0Oo9sPFxR1wkw1j27Y2MCQNvj8=
X-Google-Smtp-Source: AGRyM1suYeUPgbv2hVqDE2Uh4l62jY1sXjr1x1+zFPpsFPqYwpNlYRQdJSiP8c8T5G+XS65OZTpRY+Dpnvkgt3pjV08=
X-Received: by 2002:a81:1889:0:b0:317:987b:8e82 with SMTP id
 131-20020a811889000000b00317987b8e82mr18458638ywy.185.1656707123449; Fri, 01
 Jul 2022 13:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220701192609.3970317-1-colin.foster@in-advantage.com> <20220701192609.3970317-3-colin.foster@in-advantage.com>
In-Reply-To: <20220701192609.3970317-3-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 22:24:46 +0200
Message-ID: <CAHp75VdZwUj7dGQsiWR=M_UgxFz0q669bsdsKq3xAD3Wqv+2dw@mail.gmail.com>
Subject: Re: [PATCH v12 net-next 2/9] net: mdio: mscc-miim: add ability to be
 used in a non-mmio configuration
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
> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
>
> Add support for these non-memory-mapped configurations.

...

> +       phy_regmap = ocelot_regmap_from_resource_optional(pdev, 1,
> +                                                &mscc_miim_phy_regmap_config);
> +       if (IS_ERR(phy_regmap)) {
> +               dev_err(dev, "Unable to create phy register regmap\n");
> +               return PTR_ERR(phy_regmap);

return dev_err_probe(...); ?

>         }

-- 
With Best Regards,
Andy Shevchenko
