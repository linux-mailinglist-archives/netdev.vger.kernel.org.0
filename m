Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B5C1BB47A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 05:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD1DZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 23:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgD1DZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 23:25:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D19AC03C1A9;
        Mon, 27 Apr 2020 20:25:00 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so7786515plo.7;
        Mon, 27 Apr 2020 20:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pdrvzD+DuU91+ygk7eb413XuXlCm15QQGsmxIoU0CRg=;
        b=fg/4BznnQOB3wPtojWBAwoEZ+UaAWf3aAGVQGM7viXJ2Ke7uVbsoIZO0kIxJypVDv5
         UHzFcCU5y6XQpmfaQa8x8qJzY2Z2CS5aF55ZPYtjDQYubHol+2B+QV4NP6l78BVP+5Vr
         DY/uJ2BdGA+RE1oiK/LZTJMlfTluihtFJtGFvfz1QvhbImtdVwWW7476eHC0QROeVW4m
         gi73+OOo7sYuy+XQKLFGORd7tmvB1/fVTBZZylEyuF2EtFooYvBAHQ/+wA0V5aAOYmVC
         L76Z+UZrRLgsWX+VbH5sltYYcPj4I+asv/fxIItuV0tBZeb1V/8dCkLwiatm8MpxQDbJ
         y1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pdrvzD+DuU91+ygk7eb413XuXlCm15QQGsmxIoU0CRg=;
        b=qmqkiYUFjnW/oWDoNolS5pINW58v40zPGB2OGJH8LbAn+s1I9LbILkc2UQ/ul2BByA
         PwGoGnzFNfREFfYjUBi///AFAkeFHc/x0u8gRveTb0ltnapfXlCV0vXab15Xl+OrBg4l
         LLXxQ9hirSVfOl5a/9FiFh5VCX/cctzOO6R45jwvH+J6OTrveqFtX78Nuylbz8PhM323
         1ewUmEM81IjU4Knrl8RnVyuF/XSqhcrMdKdCtKPpMmG0aw14w0LqdnANlNF0ZyHEVVZw
         GQvF2fMol0Nky7lhoSd1/AGBr9Y/OHBx+8p1MoYLVvD+w0mQNpKclJ5Wb7Q8LgM2Z/Ud
         YdhQ==
X-Gm-Message-State: AGi0PuaHV+ZIc3hWu6cwxx1zvKquZK48Jxi/Prkz2hbVANjAJ0KpatX9
        gsvdOu583RVMQDkEReoQZJtDyiaX
X-Google-Smtp-Source: APiQypIC9LjO0hlNaH6042Opu83OU/BOZTnUNUgBOQYF2xQYkRw/EwJgy9qpkGjwuKpKCkS7w7Jbgw==
X-Received: by 2002:a17:902:d34a:: with SMTP id l10mr26700867plk.234.1588044299733;
        Mon, 27 Apr 2020 20:24:59 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id r63sm13769546pfr.42.2020.04.27.20.24.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Apr 2020 20:24:59 -0700 (PDT)
Date:   Tue, 28 Apr 2020 11:24:53 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        yash.shah@sifive.com, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
Message-ID: <20200428032453.GA32072@nuc8i5>
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
 <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 01:33:41PM +0300, Andy Shevchenko wrote:
> On Sat, Apr 25, 2020 at 3:57 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> >
> > A call of the function macb_init() can fail in the function
> > fu540_c000_init. The related system resources were not released
> > then. use devm_ioremap() to replace ioremap() for fix it.
> >
> 
> Why not to go further and convert to use devm_platform_ioremap_resource()?
>
devm_platform_ioremap_resource() will call devm_request_mem_region(),
and here did not do it.

> > Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> >  drivers/net/ethernet/cadence/macb_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index a0e8c5bbabc0..edba2eb56231 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device *pdev)
> >         if (!res)
> >                 return -ENODEV;
> >
> > -       mgmt->reg = ioremap(res->start, resource_size(res));
> > +       mgmt->reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> >         if (!mgmt->reg)
> >                 return -ENOMEM;
> >
> > --
> > 2.25.0
> >
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
