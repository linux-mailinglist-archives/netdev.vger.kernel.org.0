Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E257B2B8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbiGTITs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiGTITr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:19:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8FF6A9DC
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:19:45 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b26so25031969wrc.2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=H3cfWCLBlBYx1Erw4k3ViEzQD+OSmuEO+WWt3HWcPoA=;
        b=rR6JZ+S7IixgYfovd+L1INMwl+54Px8Y0e+3XmVtikQZpCf5s9gkH9XepDR74CWKOZ
         9JLTcSPGceYWc1eOO1jx2oXTj8YqOvqS+wG9p4hW9xU9asnbOrl0muhhwwYVM34sKjyS
         rGNKO6m3k8yyWwgDgA44/wk7ypQ69ZOBiVbJOXplDd3cyZ4R2JYioguX7H/tVjlI2fGM
         q7p8VdQq0WofPlTG8vZcUCZqagSXzBP8TgIbaBoy52M3B4BtUM57AKJhWQroXQr2u/Ik
         Q2rYGF/IHqCPOuX/qRNGSq9ICsXBurc2g1nYPIlCV4spj2cX1em/XfRo3bW2bZ0s+rWq
         tK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=H3cfWCLBlBYx1Erw4k3ViEzQD+OSmuEO+WWt3HWcPoA=;
        b=nx4PSqLMaJKPo/BGVm+9oVyB2F8HlpfZeH8/2agKgkZwkvTsqxOx2Zbs9AAu0AYCUf
         x0xb/t34JN6eKotlJNLyayps2xweNiWzLs0KTivSjJfaY7f6bBWpefJp/gWILt5AYQ3s
         urgErCyJTg8lVO2EqjyPhq5kRV/xvfwuB0mys054sWzNyhNT+pBspKFSqNH5uEL2HsPi
         PZBCaibSZR3BKooqMmYU9bz5sqXCszS+m9LyA9Qc2TrTyM1OrJyo8t5sriqjBwZ9YCHZ
         OrMNOuBv3+cjPyAeKseu732kTssNRhpOMhDW8L4bS0Ac9l/G2pwYYQLCpg4eBLYhkcS/
         8VzA==
X-Gm-Message-State: AJIora+ZOrdvYkutT5KOysW+kx2xLmsXpqw1XcpL46Xgd+zdqhKdDWRc
        zveLgxuwdD3e0DSD8xg0vWcPkQ==
X-Google-Smtp-Source: AGRyM1tKM9yWRqu/6hb5ToXfPCjx8kO+ohEW+UULtwcZ7Bj7hyGH5XdN95owydZj/Z9UEhfe392XnQ==
X-Received: by 2002:a5d:64c8:0:b0:21d:9873:bbf0 with SMTP id f8-20020a5d64c8000000b0021d9873bbf0mr29529081wri.150.1658305184429;
        Wed, 20 Jul 2022 01:19:44 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05600c3caa00b003a31b79dc0esm8936892wmb.1.2022.07.20.01.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 01:19:43 -0700 (PDT)
Date:   Wed, 20 Jul 2022 09:19:41 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Message-ID: <Yte6nTJ3IMJhdLAp@google.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-10-colin.foster@in-advantage.com>
 <YtVrtOHy3lAeKCRH@google.com>
 <Ytbuj6qfUj1NOitS@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ytbuj6qfUj1NOitS@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022, Colin Foster wrote:

> On Mon, Jul 18, 2022 at 03:18:28PM +0100, Lee Jones wrote:
> > On Tue, 05 Jul 2022, Colin Foster wrote:
> > 
> > > +MODULE_IMPORT_NS(MFD_OCELOT_SPI);
> > > diff --git a/drivers/mfd/ocelot-spi.c b/drivers/mfd/ocelot-spi.c
> > > new file mode 100644
> > > index 000000000000..0c1c5215c706
> > > --- /dev/null
> > > +++ b/drivers/mfd/ocelot-spi.c
> > > @@ -0,0 +1,317 @@
> > > +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > > +/*
> > > + * SPI core driver for the Ocelot chip family.
> > > + *
> > > + * This driver will handle everything necessary to allow for communication over
> > > + * SPI to the VSC7511, VSC7512, VSC7513 and VSC7514 chips. The main functions
> > > + * are to prepare the chip's SPI interface for a specific bus speed, and a host
> > > + * processor's endianness. This will create and distribute regmaps for any
> > > + * children.
> > > + *
> > > + * Copyright 2021, 2022 Innovative Advantage Inc.
> > > + *
> > > + * Author: Colin Foster <colin.foster@in-advantage.com>
> > > + */
> > > +
> > > +#include <linux/ioport.h>
> > > +#include <linux/kconfig.h>
> > > +#include <linux/module.h>
> > > +#include <linux/regmap.h>
> > > +#include <linux/spi/spi.h>
> > > +
> > > +#include <asm/byteorder.h>
> > > +
> > > +#include "ocelot.h"
> > > +
> > > +#define REG_DEV_CPUORG_IF_CTRL		0x0000
> > > +#define REG_DEV_CPUORG_IF_CFGSTAT	0x0004
> > > +
> > > +#define CFGSTAT_IF_NUM_VCORE		(0 << 24)
> > > +#define CFGSTAT_IF_NUM_VRAP		(1 << 24)
> > > +#define CFGSTAT_IF_NUM_SI		(2 << 24)
> > > +#define CFGSTAT_IF_NUM_MIIM		(3 << 24)
> > > +
> > > +#define VSC7512_DEVCPU_ORG_RES_START	0x71000000
> > > +#define VSC7512_DEVCPU_ORG_RES_SIZE	0x38
> > > +
> > > +#define VSC7512_CHIP_REGS_RES_START	0x71070000
> > > +#define VSC7512_CHIP_REGS_RES_SIZE	0x14
> > > +
> > > +struct spi_device;
> > 
> > Why not just #include?
> 
> I mis-understood this to mean drivers/mfd/ocelot-spi.c when it meant
> drivers/mfd/ocelot.h. Thanks.
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220701192609.3970317-10-colin.foster@in-advantage.com/#24921057
> 
> """
> You missed a lot of forward declarations that are used in this file.
> 
> Like
> 
> struct spi_device;
> """

spi_device is used in *this* file.

You should explicitly add the include file.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
