Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4E588B45
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiHCLb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbiHCLb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:31:57 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD092C673;
        Wed,  3 Aug 2022 04:31:55 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id uj29so17776169ejc.0;
        Wed, 03 Aug 2022 04:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3wQQVAw0AEj2rKso/cKnl1tlt539pW1XXl86QQyFILQ=;
        b=YLfbOS2enJ+s26RtfesBJ8zGnIqOz8N1zVQYbOjbnUMzFumntwAsg2wEbx4BZDcy8K
         DjhgEL4q7F389yVMDemajrC+7YZy05+V2vUwkeiTyrnkiZdOqeDtl2Jp3uxYzxtf2EzZ
         cbfZwx6yWgzRf9i2YER4UAIisghjpJ48M7A7JLUi5ILL35agh9k0wP2wyoMevrC0WaQX
         uYdvczGJBIeGDOBCyn5x+kjPEa2y9OG1E6AJ+PC4VANYvn3cKZS3aTw0ESO5Z6qyewfH
         mPMzpXxxw7hVyEX5t4ZkLv12mRPc8ANE3dnFmm57K24jzCcHjdur0NH5WjwLfihg5fnQ
         0hqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3wQQVAw0AEj2rKso/cKnl1tlt539pW1XXl86QQyFILQ=;
        b=7SRusJ7KLVEHCGekWUmnwNeqHlRyS9RlP1+ZYAjpJVCDqBqylu2qztymdqMIklK38E
         hr3rWyhOmsUOrn1gBBr0CGcyiCr95vbQF2eZu4zuz2p0yxDUkNodSYS/2JFuLkm2LIEy
         oeSqIi6HYg+ZFPnTjmyMNGEh+aMDKXg9gwn4FgEhok0r89vZPXvUxSPReHGETFk+TJrA
         Dz0TbmUWdBDM/rtQJkE6cYS8te8Vm557WIfjnSQnFywUjAEP+j8kWyefYftvTrLaFhpH
         WGeWAF11wDI6sRU7C5/2MeCSYru5RuNqJH80nQSmffQr4ODHxIlkf9e4YKhBg66MuIL8
         oubg==
X-Gm-Message-State: AJIora8zII7VSyGsGNey8qrj5VUV/pIT2vDLQC9d/0usM9yOc/7yVdZE
        Hc/t5jTWniTRkgjZUP5IcnhwndWGgdO3GygLvjw=
X-Google-Smtp-Source: AGRyM1v2LZTHvoyZ0Ial20+txMxihjbbvZ9Nq7L4lWElqvegdOZdXoAtyo3ytFLkzF8T6Nu8BE5sJxhj9WJ8A5G3ets=
X-Received: by 2002:a17:907:c06:b0:701:eb60:ded with SMTP id
 ga6-20020a1709070c0600b00701eb600dedmr20395317ejc.178.1659526313516; Wed, 03
 Aug 2022 04:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-2-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-2-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:31:16 +0200
Message-ID: <CAHp75VcoY+Gr-T9DEvQooPmnwDjPdeZudRwq7L0Bo8vOGdbzOQ@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 1/9] mfd: ocelot: add helper to get regmap from a resource
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

On Wed, Aug 3, 2022 at 7:47 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource()
> and devm_regmap_init_mmio().
>
> Operating in an MFD might be different, in that it could be memory mapped,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> instead of IORESOURCE_MEM becomes necessary.
>
> When this happens, there's redundant logic that needs to be implemented in
> every driver. In order to avoid this redundancy, utilize a single function
> that, if the MFD scenario is enabled, will perform this fallback logic.

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>
> v15
>     * Add missed errno.h and ioport.h includes
>     * Add () to function references in both the commit log and comments
>
> v14
>     * Add header guard
>     * Change regs type from u32* to void*
>     * Add Reviewed-by tag
>
> ---
>  MAINTAINERS                |  5 +++
>  include/linux/mfd/ocelot.h | 62 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
>  create mode 100644 include/linux/mfd/ocelot.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 28108e4fdb8f..f781caceeb38 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14467,6 +14467,11 @@ F:     net/dsa/tag_ocelot.c
>  F:     net/dsa/tag_ocelot_8021q.c
>  F:     tools/testing/selftests/drivers/net/ocelot/*
>
> +OCELOT EXTERNAL SWITCH CONTROL
> +M:     Colin Foster <colin.foster@in-advantage.com>
> +S:     Supported
> +F:     include/linux/mfd/ocelot.h
> +
>  OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
>  M:     Frederic Barrat <fbarrat@linux.ibm.com>
>  M:     Andrew Donnellan <ajd@linux.ibm.com>
> diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> new file mode 100644
> index 000000000000..dd72073d2d4f
> --- /dev/null
> +++ b/include/linux/mfd/ocelot.h
> @@ -0,0 +1,62 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/* Copyright 2022 Innovative Advantage Inc. */
> +
> +#ifndef _LINUX_MFD_OCELOT_H
> +#define _LINUX_MFD_OCELOT_H
> +
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/ioport.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/types.h>
> +
> +struct resource;
> +
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
> +        * Don't use _get_and_ioremap_resource() here, since that will invoke
> +        * prints of "invalid resource" which will simply add confusion.
> +        */
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, index);
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
> +
> +static inline struct regmap *
> +ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int index,
> +                           const struct regmap_config *config)
> +{
> +       struct regmap *map;
> +
> +       map = ocelot_regmap_from_resource_optional(pdev, index, config);
> +       return map ?: ERR_PTR(-ENOENT);
> +}
> +
> +#endif
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
