Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44AC6B91D1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCNLjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCNLi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:38:59 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76341B44;
        Tue, 14 Mar 2023 04:38:57 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id s22so19584343lfi.9;
        Tue, 14 Mar 2023 04:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678793935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd+/D1mauSkZb0YeUtA3Fwrhf1kTYNf5H6shW8c9DGk=;
        b=i8DtvnAWLdcjjx1EkeFhNg73kVk+GcIZalysrZVQeglMsALIGdeMgvbmf1v/kDo9jQ
         dVbK9VpavPgWuMWgXddXV598kHjt4MpWsNup2RBWqIpl4KsnSuAdwAkblvQBkEolhbMO
         7ffuoB6nbQvurBptf5CrsoqmUwgF36u+vCFyIY5vXHrkexKvGRyKziX9e5xQGOuNMGn7
         wJVYYkieXzNri2Ly5r1EwLiOpKuxQQtS3F8I7ojAh0gIbg5x+/1d2Bn52PYpT482G1/F
         qnT9JbG/iGb4FzVWRHh5ukOo4rWPXVTU2oYhOMgL/Gd7aXj9/BBrcNoK34pHqGd/93Gn
         wvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678793935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gd+/D1mauSkZb0YeUtA3Fwrhf1kTYNf5H6shW8c9DGk=;
        b=UyWrtU6FaX2vL6+gP0Z0z66xmjeko6UmGj143aNJoX6fOPpA1KizQAyxz2AjBzMqMp
         WWeNXxje+bAlTz1KaNF3mlpZ8FJnMFdFcZ5RNNNF8ZqUUzqImIOTAFx9UtDykzIZgQcG
         Vjr7gkxLw0e55QX/YO1RMUnJRxb6k/sKHrpNJAoa53rBoEnSz4MrHvMZuwRwJn4ay3xA
         w8D8xG/hMdcRaKunCUKXBQ7JVwU77BWEyO9rKZbI9J/PFza0E4lUt4sdD729z3ILv5vJ
         g3ZP6ytL3y3f8I9rddiZ3ClW2kXeA+dzZSCMHfUlDkUiPIuI40ZP1Rlup5af98UXJGR4
         mrbQ==
X-Gm-Message-State: AO0yUKXqouonBV76AG4+RoSAy3u5hQZpBbgnkkDPyULVQvHkXObXlLLj
        uBhWQm+VoL5fQa95O9OhQrk=
X-Google-Smtp-Source: AK7set/aEFZcvx3G3XImbxduxLVpd98MXCjNyOgm0Y7UZEaptGxI7Jhg4YmVr9xlvV7X7mVwoHdbYA==
X-Received: by 2002:ac2:485c:0:b0:4d1:7923:3b90 with SMTP id 28-20020ac2485c000000b004d179233b90mr635370lfy.32.1678793935375;
        Tue, 14 Mar 2023 04:38:55 -0700 (PDT)
Received: from mobilestation ([95.79.133.202])
        by smtp.gmail.com with ESMTPSA id i16-20020a056512007000b004db26660d86sm369785lfo.95.2023.03.14.04.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 04:38:54 -0700 (PDT)
Date:   Tue, 14 Mar 2023 14:38:51 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Qing Zhang <zhangqing@loongson.cn>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 13/13] net: dwmac-loongson: Perceive zero IRQ as
 invalid
Message-ID: <20230314113851.g5qp5ee5eyzslac5@mobilestation>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-14-Sergey.Semin@baikalelectronics.ru>
 <ZBAuWk9lnGjeuvKC@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBAuWk9lnGjeuvKC@nimitz>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:20:42AM +0100, Piotr Raczynski wrote:
> On Tue, Mar 14, 2023 at 01:42:37AM +0300, Serge Semin wrote:
> > Linux kernel defines zero IRQ number as invalid in case if IRQ couldn't be
> > mapped. Fix that for Loongson PCI MAC specific IRQs request procedure.
> > 
> 

> Looks a little odd but as I also checked and kernel does seem to treat
> zero as mapping failure instead of -WHATEVER.

See what Linus originally told about that:
https://lore.kernel.org/lkml/Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org/

> 
> Fix looks fine.
> 
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

Thanks.

-Serge(y)

> 
> > Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> > index a25c187d3185..907bdfcc07e9 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> > @@ -127,20 +127,20 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
> >  	res.addr = pcim_iomap_table(pdev)[0];
> >  
> >  	res.irq = of_irq_get_byname(np, "macirq");
> > -	if (res.irq < 0) {
> > +	if (res.irq <= 0) {
> >  		dev_err(&pdev->dev, "IRQ macirq not found\n");
> >  		ret = -ENODEV;
> >  		goto err_disable_msi;
> >  	}
> >  
> >  	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
> > -	if (res.wol_irq < 0) {
> > +	if (res.wol_irq <= 0) {
> >  		dev_info(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");
> >  		res.wol_irq = res.irq;
> >  	}
> >  
> >  	res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
> > -	if (res.lpi_irq < 0) {
> > +	if (res.lpi_irq <= 0) {
> >  		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
> >  		ret = -ENODEV;
> >  		goto err_disable_msi;
> > -- 
> > 2.39.2
> > 
> > 
