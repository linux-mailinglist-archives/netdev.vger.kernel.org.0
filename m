Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC44524964
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351955AbiELJtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347600AbiELJtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:49:45 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F9923BC0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:49:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x18so6526828wrc.0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m+GHfrW6fEuHc5Bs8OGRGQGWigIu1swhxgOxVtKpNhk=;
        b=dwGIQ0BkCa1E3CJvLrusI8PupUWwR7p+1hFOBj/+L8AjeAwkXB0MDERMHgBJdhDGzT
         nJlqSVX2eesukTMTMDhXG13WsiALG4nTQnhPW0lqClxlD/Pt2CZ6HcwTVPpq8htGKkVs
         Wj8OonXKuY/XIQhNxBpqwTd+E1x4rH1AFARunTtpBT9n+FpJH3Lt1Ehz3smX9gJqC7iU
         D+peMsK+SCpRCnwRpCAeQwqNsJxnqzcIFKut5MhQOnRb34TDVV0O7ed/m9Ta5OYFcfkv
         XxQDekIaWAJRf7O5gp2Ps6WKd+0HggV9t3i6jnt5xZTJ+aYAVIta6srR6nN67Oay4tUn
         if2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m+GHfrW6fEuHc5Bs8OGRGQGWigIu1swhxgOxVtKpNhk=;
        b=tTo5raqPpsmDD67tdb1pvTl6vdTiu6VpWbTB789KDgaRBY0qj/RfJLqztyIt0CJ++9
         dGVmcfQ42OrzZdp9GtZsXL2p3dmZudeG6SSBMQ2tjv633Rft9f2ngJEpZSL4/sxU436s
         /83AKYnx6xUfkSLJOAz14pdRTO+6wopfOQSgzbiHGwhyIqygkEqHtL2Y6PxGdto3uokM
         k8VrVF0D7Qh2AMFPuCSJ0SOKafO5lMC9dvCIWUiH7IPysVhIaiozJGPhME61fRdBtcYA
         eq4zYQhKnuyIn4yTZ+TEvlqePHUQFYvvRBhpVviGtSd1tZyt2mnAY9v/tzwtIaL5j/R0
         BbCg==
X-Gm-Message-State: AOAM533h9NGTgBFBs45YGCHO4L3Nfq3shLWF0bWD2TlDu4cmjzHdWzeG
        PZLd8theQEXdNUMPArJ+8ImJiA==
X-Google-Smtp-Source: ABdhPJzJ8xq2tAa6Ub50g1TH/DdizJOEPl87cht3iCrjgVaclsdPRT2WWsCqIHuuIx0bKY2DJYFaBA==
X-Received: by 2002:a5d:64c8:0:b0:20c:6970:fb22 with SMTP id f8-20020a5d64c8000000b0020c6970fb22mr25695147wri.424.1652348982423;
        Thu, 12 May 2022 02:49:42 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id d2-20020a056000114200b0020c6a524fe0sm3635878wrx.98.2022.05.12.02.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 02:49:41 -0700 (PDT)
Date:   Thu, 12 May 2022 10:49:39 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Message-ID: <YnzYM1kOJ9hcaaQ6@google.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-9-colin.foster@in-advantage.com>
 <20220509105239.wriaryaclzsq5ia3@skbuf>
 <20220509234922.GC895@COLIN-DESKTOP1.localdomain>
 <20220509172028.qcxzexnabovrdatq@skbuf>
 <YnqFijExn8Nn+xhs@google.com>
 <20220510161319.GA872@COLIN-DESKTOP1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510161319.GA872@COLIN-DESKTOP1.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022, Colin Foster wrote:

> On Tue, May 10, 2022 at 04:32:26PM +0100, Lee Jones wrote:
> > On Mon, 09 May 2022, Vladimir Oltean wrote:
> > 
> > > On Mon, May 09, 2022 at 04:49:22PM -0700, Colin Foster wrote:
> > > > > > +struct regmap *ocelot_init_regmap_from_resource(struct device *child,
> > > > > > +						const struct resource *res)
> > > > > > +{
> > > > > > +	struct device *dev = child->parent;
> > > > > > +
> > > > > > +	return ocelot_spi_devm_init_regmap(dev, child, res);
> > > > > 
> > > > > So much for being bus-agnostic :-/
> > > > > Maybe get the struct ocelot_ddata and call ocelot_spi_devm_init_regmap()
> > > > > via a function pointer which is populated by ocelot-spi.c? If you do
> > > > > that don't forget to clean up drivers/mfd/ocelot.h of SPI specific stuff.
> > > > 
> > > > That was my initial design. "core" was calling into "spi" exclusively
> > > > via function pointers.
> > > > 
> > > > The request was "Please find a clearer way to do this without function
> > > > pointers"
> > > > 
> > > > https://lore.kernel.org/netdev/Ydwju35sN9QJqJ%2FP@google.com/
> > > 
> > > Yeah, I'm not sure what Lee was looking for, either. In any case I agree
> > > with the comment that you aren't configuring a bus. In this context it
> > > seems more appropriate to call this function pointer "init_regmap", with
> > > different implementations per transport.
> > 
> > FWIW, I'm still against using function pointers for this.
> > 
> > What about making ocelot_init_regmap_from_resource() an inline
> > function and pushing it into one of the header files?
> > 
> > [As an aside, you don't need to pass both dev (parent) and child]
> 
> I see your point. This wasn't always the case, since ocelot-core prior
> to v8 would call ocelot_spi_devm_init_regmap. Since this was changed,
> the "dev, dev" part can all be handled internally. That's nice.
> 
> > 
> > In there you could simply do:
> > 
> > inline struct regmap *ocelot_init_regmap_from_resource(struct device *dev,
> > 						       const struct resource *res)
> > {
> > 	if (dev_get_drvdata(dev->parent)->spi)
> > 		return ocelot_spi_devm_init_regmap(dev, res);
> > 
> > 	return NULL;
> > }
> 
> If I do this, won't I have to declare ocelot_spi_devm_init_regmap in a
> larger scope (include/soc/mscc/ocelot.h)? I like the idea of keeping it
> more hidden inside drivers/mfd/ocelot.h, assuming I can't keep it
> enclosed in drivers/mfd/ocelot-spi.c entirely.

Yes, it will have the same scope as ocelot_init_regmap_from_resource().

Have you considered include/linux/mfd?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
