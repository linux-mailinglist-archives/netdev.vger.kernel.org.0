Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E79C57FCA0
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 11:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiGYJkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 05:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiGYJk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 05:40:28 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD414E7B;
        Mon, 25 Jul 2022 02:40:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id c12so5762459ede.3;
        Mon, 25 Jul 2022 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wk5AdTHZkK3y/y86s2c6z+V6gZGrMEpCv6krR/2aEhw=;
        b=WyCpx2vunPvzLmeyFWBQxitXLhUa99to7s/rJpVE8ru7UYq8XMRsSPtcU6LC//Uiup
         Uj5cM7BdEu6VHp1DfMXcnKz8XFRoKnnxjvsHrVS9ov8b6Cowtcp7DBteWxnug3FPyrwd
         t++iCranU4Pg1it/saglRtJjPEZumxxD4QqC8TsJvV8GWfrcbDkEN9C6mZUlc3Q3eDPX
         kJIamuZUKv93P9h8gOGuTp1WNFPjdcs5Mg+qGXKE/eoC5eBHzWqYelnOYvl1vB3fV0tS
         /PQlJlmAHtG+BA1QxFkTTJdMiwum3FnlTGoufX2F+DXLGauusXHKLcATIU0f6cyujV6u
         Aqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wk5AdTHZkK3y/y86s2c6z+V6gZGrMEpCv6krR/2aEhw=;
        b=7qKl05PIW2U0Nm0A4pHlXynwCJ/4SvIVuaSxuFkewMuNeUCE9FY8xY5o9FPK/4B08C
         FeyVy96V15fl6MuY8F0ePDKzvFXee1htt0OqFqpa5IzaeR3V7CyX4E5CTGs9z3lYmCQ+
         ZDT4cSwU0QpERFH+HBkVsK5lpUY9JxNKRU7nvE4rvJxzOroP57Jx62dxFUDFjx58Xcb0
         yeJSDDCFzHhhwi89bgM5lnfccZ2o9fhP3sTWb7d6aqKE0GOwzgxf2tUBm+b+XG0/23aq
         tT5ZbxXky9CI/i4FzAfjPb/XkfNNjDJsELeSQD+SGgcdKuQamegbVHTgCGzWd1WNz6fr
         lZ1A==
X-Gm-Message-State: AJIora/p0FPbRdAvua781MzC0dBE666pwvm/sRZJpuw4ZuTP6siUQtbM
        b7bkzWJrYgBkY5DeF26lKcTz+YIe4ebTzkcdALo=
X-Google-Smtp-Source: AGRyM1sXm4n75Ytiaw9TN/6jOw92F3faw/dxPtaeJZ4pGJu4n51v3+jvF691H0/dfKds1kfN7JPgw2k0M8AwmOUQI2E=
X-Received: by 2002:a05:6402:d53:b0:43b:a0cf:d970 with SMTP id
 ec19-20020a0564020d5300b0043ba0cfd970mr11829902edb.277.1658742026168; Mon, 25
 Jul 2022 02:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220722040609.91703-1-colin.foster@in-advantage.com> <20220722040609.91703-2-colin.foster@in-advantage.com>
In-Reply-To: <20220722040609.91703-2-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 25 Jul 2022 11:39:48 +0200
Message-ID: <CAHp75VdoBO8nKvGicsMhtY226AmL6nzt_52W+fLjeTkndwV7Aw@mail.gmail.com>
Subject: Re: [PATCH v14 mfd 1/9] mfd: ocelot: add helper to get regmap from a resource
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
> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource and
> devm_regmap_init_mmio.

When we refer to functions we put it like func().

> Operating in an MFD might be different, in that it could be memory mapped,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> instead of IORESOURCE_MEM becomes necessary.
>
> When this happens, there's redundant logic that needs to be implemented in
> every driver. In order to avoid this redundancy, utilize a single function
> that, if the MFD scenario is enabled, will perform this fallback logic.

...

> +#include <linux/err.h>

You also missed errno.h

> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>

...

> +static inline struct regmap *
> +ocelot_regmap_from_resource_optional(struct platform_device *pdev,
> +                                    unsigned int index,
> +                                    const struct regmap_config *config)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct resource *res;
> +       void __iomem *regs;
> +
> +       /*
> +        * Don't use get_and_ioremap_resource here, since that will invoke

_get_and_ioremap_resource()

> +        * prints of "invalid resource" which simply add confusion
> +        */

will simply add

Missed period.

> +       res = platform_get_resource(pdev, IORESOURCE_MEM, index);

Where are the IORESOURCE_*  defined? Haven't you missed a header?

> +       if (res) {
> +               regs = devm_ioremap_resource(dev, res);
> +               if (IS_ERR(regs))
> +                       return ERR_CAST(regs);
> +               return devm_regmap_init_mmio(dev, regs, config);
> +       }
> +
> +       /*
> +        * Fall back to using REG and getting the resource from the parent
> +        * device, which is possible in an MFD configuration
> +        */
> +       if (dev->parent) {
> +               res = platform_get_resource(pdev, IORESOURCE_REG, index);
> +               if (!res)
> +                       return NULL;
> +
> +               return dev_get_regmap(dev->parent, res->name);
> +       }
> +
> +       return NULL;
> +}

-- 
With Best Regards,
Andy Shevchenko
