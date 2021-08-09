Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB63E3E39
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 05:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhHIDVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 23:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhHIDVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 23:21:31 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2441C061757;
        Sun,  8 Aug 2021 20:21:10 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id y130so4294963qkb.6;
        Sun, 08 Aug 2021 20:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QAh+pRTFBMAr0+T9wtQVR3MusEWk4kYhdCUk1mCd9nw=;
        b=atyxxfBd1TD6a0f9xFNLmjNeJLyGzB1GGvFmE9PI2YqifBZr9ccFNl9mIpeLjtR8Dc
         u6yZiPJHQAF0SCQLBYtp3SKuDEqClNnsII2RbWxd5TlVk1ZDm1M/hvOy01axv4etNLcT
         ME5d7UxocnwooPI3ReE5bPdEP+cMxDpvcjAiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QAh+pRTFBMAr0+T9wtQVR3MusEWk4kYhdCUk1mCd9nw=;
        b=kwus3PQb2YVyle6chlp5JenOLN6iWW7Q7ja8gh3uISWvvjRqFwTOerpKWtw/Qf6hoO
         JcW83BE40DzdPAj33X2SGsLeDh5CJ3fIYxTL2JR+r/tuAkp4CjbUtdYzniJn4SzpC2tx
         +OLpQrSJ0CvtP+vVviFk50XDp4HqyWXbatelWQFYl3oLd/abt4NoLWKEMfXSA0gw2SQU
         DbVLlduSk3BUWnTRMnpPQlgBuoJi4SbrIsv7OBy8WBuhlB39UZ+5qETczJKA5qV6QjC/
         uMptiYqP8TFFma6IqwAcyHGfJAO1aMpXBwfNR/5XSRdyOSBRbl7YwU2PV8e6XInZ9aga
         11Ig==
X-Gm-Message-State: AOAM532gg5X7iOk6toVyD4RCx6gkWWqQdq88mxroDPfw2asV/F7g1MyB
        yRuxG9CK/TF/gzsDYaIn7THTTAMePL1AlnImsrY=
X-Google-Smtp-Source: ABdhPJxVTlKiAdXt0XMifFnR8/gPBBXfovIot4eZ4giZMm0DbLu6mhlQdSB4UldYT1OJ33vn+O603JvRkwxa247KBg0=
X-Received: by 2002:a05:620a:19a8:: with SMTP id bm40mr7386566qkb.66.1628479269896;
 Sun, 08 Aug 2021 20:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210806054904.534315-1-joel@jms.id.au> <20210806054904.534315-3-joel@jms.id.au>
 <YQ7czmvIm6FTZAol@lunn.ch>
In-Reply-To: <YQ7czmvIm6FTZAol@lunn.ch>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 9 Aug 2021 03:20:57 +0000
Message-ID: <CACPK8XdOUhz8U0NqOcLRPC3=rjfVB1FFhwyJzMy2AE+7Omm_2g@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network interface
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Aug 2021 at 19:19, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static void liteeth_reset_hw(struct liteeth *priv)
> > +{
> > +     /* Reset, twice */
> > +     writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> > +     udelay(10);
> > +     writeb(1, priv->base + LITEETH_PHY_CRG_RESET);
> > +     udelay(10);
> > +     writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> > +     udelay(10);
>
> What is this actually resetting?

This comes from the reference firmware that many (but not all) litex
systems run before loading their operating system.

I'm not completely sure how necessary it still is; I will drop it for now.

>
> > +static int liteeth_probe(struct platform_device *pdev)
> > +{
> > +     struct net_device *netdev;
> > +     void __iomem *buf_base;
> > +     struct resource *res;
> > +     struct liteeth *priv;
> > +     int irq, err;
> > +
> > +     netdev = alloc_etherdev(sizeof(*priv));
> > +     if (!netdev)
> > +             return -ENOMEM;
> > +
> > +     priv = netdev_priv(netdev);
> > +     priv->netdev = netdev;
> > +     priv->dev = &pdev->dev;
> > +
> > +     irq = platform_get_irq(pdev, 0);
> > +     if (irq < 0) {
> > +             dev_err(&pdev->dev, "Failed to get IRQ\n");
> > +             goto err;
> > +     }
> > +
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +     priv->base = devm_ioremap_resource(&pdev->dev, res);
> > +     if (IS_ERR(priv->base)) {
> > +             err = PTR_ERR(priv->base);
> > +             goto err;
> > +     }
> > +
> > +     res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +     priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
> > +     if (IS_ERR(priv->mdio_base)) {
> > +             err = PTR_ERR(priv->mdio_base);
> > +             goto err;
> > +     }
>
> So you don't have any PHY handling, or any MDIO bus master code. So i
> would drop this, until the MDIO architecture question is answered. I
> also wonder how much use the MAC driver is without any PHY code?
> Unless you have a good reason, i don't think we should merge this
> until it makes the needed calls into phylib. It is not much code to
> add.

You mean I should skip out the parsing of the mdio base until I'm
using it? That's reasonable.
