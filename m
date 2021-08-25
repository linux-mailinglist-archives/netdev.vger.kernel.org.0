Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9910F3F74AE
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbhHYMA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240252AbhHYMA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:00:56 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BC6C061757;
        Wed, 25 Aug 2021 05:00:10 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id f22so17021277qkm.5;
        Wed, 25 Aug 2021 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mIKPjNSOg6AxDB4D3W6zqs6Hlakd7gYX5dh+dl4t6MY=;
        b=J1p19cUC7UX0hatinDkEWGutHdtc2d3/EZZHzaWcX+rNEz6buzewbl/ntnkzqwU5Hc
         K0S2sxRHIYDRs2RTjEO5qjK5tHax5nsBYyOiucLZwDElb3+NtNjfkoQl/tmTnbxQNPAh
         TR3nQZdYK2R5ikcXtc9lyygjCUgVqoekJRqU3iIYgCnv19CJxqlvKL66mT/CVbg7vRGW
         p2/tn9DKnmUXLUYr3/qsYh60HueBtSwO4JeIGQceyBhxDsEin7ql3SD731A5+sV20HP4
         D++T2Bck3Q3PtnsfCw0NF3pOuUJ5BTQQEYD0prLleKs/qU3lN6AF/6xfy4kLzhPYTwCH
         6cWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mIKPjNSOg6AxDB4D3W6zqs6Hlakd7gYX5dh+dl4t6MY=;
        b=m2f3KZE0lW0pR3u7bN9bQ60DCaew7irtZ4kHkJ1vXUyqlHEngqH18BCoGv5KtHjPLZ
         1QbsW4UfpN1oz1rP4paYyubHyaNpglfwpiW9ygg2qeMs/XaKG+YkT4bhc7EUlBbNUlvh
         82ENNJDs4yVgj/Q5Z7pb/QDsxevn4SrV5tlcid8oN+R5Fbs4uCgdIN2QrnY08kx5IYaM
         Lfn9xDGL7NGmKDaws/AhV7uhYOqiaiwwea20ze63GxB5ySqOGVBRcS8hVmTiEkidxmMN
         AvvY+r9eQWBaUU7QUqmpGOEwXGrQjMK6VATHeEEencvchfQ9LfPMZvLuuyaHFZS9HdmS
         McGw==
X-Gm-Message-State: AOAM530+aWd28F24x1QTszBcVDDsAgxUkdmQYkEDolpUW22ffbbz/NgV
        Y2OVuiCS2zC52J2t55YTC7pYWnFcSrbgjQoR
X-Google-Smtp-Source: ABdhPJw8bTC+MC+3CepTQhKomN1uZUG8Oz1LtP2pWSF7xdCIY0vMayYP7RibIAHE/9HDvEXdCOWx5g==
X-Received: by 2002:a37:a88a:: with SMTP id r132mr31852066qke.212.1629892809872;
        Wed, 25 Aug 2021 05:00:09 -0700 (PDT)
Received: from errol.ini.cmu.edu (pool-71-112-192-175.pitbpa.fios.verizon.net. [71.112.192.175])
        by smtp.gmail.com with ESMTPSA id y19sm7432978qtv.21.2021.08.25.05.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:00:09 -0700 (PDT)
Date:   Wed, 25 Aug 2021 08:00:06 -0400
From:   "Gabriel L. Somlo" <gsomlo@gmail.com>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Florent Kermarrec <florent@enjoy-digital.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Shah <dave@ds0.me>, Stafford Horne <shorne@gmail.com>
Subject: Re: [PATCH v2 2/2] net: Add driver for LiteX's LiteEth network
 interface
Message-ID: <YSYwxmCqDKL+qvY/@errol.ini.cmu.edu>
References: <20210820074726.2860425-3-joel@jms.id.au>
 <YSVLz0Se+hTVr0DA@errol.ini.cmu.edu>
 <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 06:35:17AM +0000, Joel Stanley wrote:
> > > +
> > > +     netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
> > > +     if (!netdev)
> > > +             return -ENOMEM;
> > > +
> > > +     SET_NETDEV_DEV(netdev, &pdev->dev);
> > > +     platform_set_drvdata(pdev, netdev);
> > > +
> > > +     priv = netdev_priv(netdev);
> > > +     priv->netdev = netdev;
> > > +     priv->dev = &pdev->dev;
> > > +
> > > +     irq = platform_get_irq(pdev, 0);
> > > +     if (irq < 0) {
> > > +             dev_err(&pdev->dev, "Failed to get IRQ %d\n", irq);
> > > +             return irq;
> >
> > At this point, netdev has been dynamically allocated, and should
> > probably be free'd before liteeth_probe() is allowed to fail,
> > to avoid any potential leaks...
> 
> We use the managed variant of alloc_etherdev, which means the
> structure is freed by the driver core when the driver is removed. This
> saves having to open code the cleanup/free code.
> 
> Have a read of Documentation/driver-api/driver-model/devres.rst for
> more information.

That makes sense, thanks for the link!

Cheers,
--Gabriel
