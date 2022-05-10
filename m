Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284AA521EE4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243682AbiEJPiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346224AbiEJPg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:36:28 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14009FD0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:32:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so24315946wrg.12
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 08:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ibDKLmqXZAEEFTExzRdfpLVElcsKcx9KbemDnOPns+k=;
        b=figfC27hBQ7YIl202+8UV+l1HErOFJIF9/fpjPlCPer5g3I7PjAtzfad9fQkyRxLjr
         2Rn89ZkXFnj/ZtK9VRdPLP2LkZM3RIZHLXiPF7jTPH2sjLvKyJyyZhA8IU8nvYI6dAq8
         eWWDHyE0BiwMx0ztz4HjHBdxVDNMORyJ3lEV0cf+voR+rNEqAWWKymQdZiy6Bu0isRA0
         sx/2yAsnZP4Up/rDDDUE9k3t+Ayuee8qbQu+lddnI/2qPWWDITuddK7AaNrlWrBvSbHh
         +GKPURa/WCWQELR5zsHNR3B0osJYPBBuowvHljLEI/p32ixzYEuxagZ/9me25B5QZUhV
         zZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ibDKLmqXZAEEFTExzRdfpLVElcsKcx9KbemDnOPns+k=;
        b=R9PEo/hhpRGHkk2J0joMlJXrsFiMXbU0yKEbmKMkVgvsXr1Mw1T9CaahflRwf9XH0Z
         /Zcw4YZy4tHjSK+QpwEDQ6JazsZPSRMI9iCuh/xchRiKWd5EHRjfkd70UHKqdlwM+JGL
         500EzphfKON4LaQfrT28U95M9awctvSpSSggKxQ3X999pc1dCa5hm4w4BuNfHB2n6YR5
         1vUyza43b8O6nar0vFGBmNK8EuL1MDS7zSXPhcha8TP/jySLY9kbHDIPIIGFn0iyvxuq
         /YTTHrZzH46yFU23XF7RcUEswuAigXONRrqIoSsYCp1F5c1HXKvXMcPtsSRDB5zYjDzw
         eMBQ==
X-Gm-Message-State: AOAM5326pIYbtXqr07XMcKgF3odrZRP+AMJ2Zt9+OFGj4n5pUOXCPYPN
        wbQXO9UPnr9Bm8Hv8oW4P7H03w==
X-Google-Smtp-Source: ABdhPJxhbL0kXjtF40z+/oU1QTJ/WF63V5u/yXTZ1XONjVrTuv3E338FNMTKvYPqbqjTgY9CE4ly0A==
X-Received: by 2002:a5d:4205:0:b0:20a:e23c:a7f4 with SMTP id n5-20020a5d4205000000b0020ae23ca7f4mr19616144wrq.576.1652196749233;
        Tue, 10 May 2022 08:32:29 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id x18-20020adfdd92000000b0020c5253d915sm13895707wrl.97.2022.05.10.08.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:32:28 -0700 (PDT)
Date:   Tue, 10 May 2022 16:32:26 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 08/16] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YnqFijExn8Nn+xhs@google.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
 <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
 <20220509172028.qcxzexnabovrdatq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509172028.qcxzexnabovrdatq@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 May 2022, Vladimir Oltean wrote:

> On Mon, May 09, 2022 at 04:49:22PM -0700, Colin Foster wrote:
> > > > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > > > +						const struct resource *res)
> > > > +{
> > > > +	struct device *dev = child->parent;
> > > > +
> > > > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> > > 
> > > So much for being bus-agnostic :-/
> > > Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
> > > via a function pointer which is populated by ocelot-spi.c? If you do
> > > that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.
> > 
> > That was my initial design. "core" was calling into "spi" exclusively
> > via function pointers.
> > 
> > The request was "Please find a clearer way to do this without function
> > pointers"
> > 
> > https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/
> 
> Yeah, I'm not sure what Lee was looking for, either. In any case I agree
> with the comment that you aren't configuring a bus. In this context it
> seems more appropriate to call this function pointer "init_regmap", with
> different implementations per transport.

FWIW, I'm still against using function pointers for this.

What about making ocelot_init_regmap_from_resource() an inline
function and pushing it into one of the header files?

[As an aside, you don't need to pass both dev (parent) and child]

In there you could simply do:

inline struct regmap *ocelot_init_regmap_from_resource(struct device *dev,
						       const struct resource *res)
{
	if (dev_get_drvdata(dev->parent)->spi)
		return ocelot_spi_devm_init_regmap(dev, res);

	return NULL;
}

Also, do you really need devm in the title?

> Or alternatively you could leave the "core"/"spi" pseudo-separation up
> to the next person who needs to add support for some other register I/O
> method.

Or this.  Your call.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
