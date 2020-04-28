Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515AC1BBEA2
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 15:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgD1NMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 09:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgD1NMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 09:12:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA362C03C1A9;
        Tue, 28 Apr 2020 06:12:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so6950157pfx.7;
        Tue, 28 Apr 2020 06:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QY6myh2Pbs2C9PZFWtJrxYe9xeu5bPk92DtEEgzJ9PU=;
        b=p1CIaXBa6jbtnD4pxqBpOM+KmW3HNVZ8XxHooyFDVvpLCPHQctJB43RB0PfDugQFSM
         fuiuSZxh2h8/B9giQEmv0u6wW4X1vARujgvHj3ipUagNBeSbKSzKIeG2SvYLoc5A1rEL
         9EWQ7Xpd6ZAKrJIDiKp2hI6RvjP1pO35nvkMaKuWJtN+slLeIZLnuEFw8PECWABykSx4
         mKLIRifGuMwQWkEHPemS6TQNbU0ipm/2VgOpHlaYKI3zoBNi3SW2zSTPW3xiBezZwbHk
         wJroKSNyyMRPDQTKmVCAj7k4/KPI05h8h84RDIScjlPc6SiBb4OCFc2mGk7zmakbGZEK
         rNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QY6myh2Pbs2C9PZFWtJrxYe9xeu5bPk92DtEEgzJ9PU=;
        b=Tt+uPjMCKd0WN7tvy13UpiE9kG1VIWhwYS2VNTUDJzvlG4ieUqdN4BdEI57dh+knZ3
         uaVI3vl4MY/Xazvhh94OyB4V5xHzqlpfsSLbv0rHNHh7IQouu9tovrR0G2YiKHsn0Rcc
         6fBqRVwmvSjJ/fJmjbBN7Aoci7jdp6dby8bNNFxAAWkp7NtFWxkdqe2wSZJ26jXXX0Y2
         U0Fz42kiuSaWq54MyFUta6rsluf5OsRxFYUkQCo5zyBh1Y3DgayPc7dNU9IvyyCbOrR0
         dM/YrydyoFgrb/0pqCHR3zyqtMNsbAmjgak77sIKH7f7nZwPWUl4vBsXMBouaTQ5IyhE
         2VRA==
X-Gm-Message-State: AGi0PubI3yzbc1B1iGcSlAF1cCo98Y952aNaOvkLEWnfBfb9F738PhRe
        q9mSS04icEZ9a1/C2+0o8vQ=
X-Google-Smtp-Source: APiQypIeTHTeMX+TBQ6Cq0KUxAlhefQNCkaRhSHaB4ffN8vwrX2Hm82JksCtGAZ0NIO7OcLpPSejgQ==
X-Received: by 2002:a63:585c:: with SMTP id i28mr27952797pgm.363.1588079525423;
        Tue, 28 Apr 2020 06:12:05 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id x10sm13152720pgq.79.2020.04.28.06.12.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2020 06:12:05 -0700 (PDT)
Date:   Tue, 28 Apr 2020 21:11:59 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, yash.shah@sifive.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
Message-ID: <20200428131159.GA2128@nuc8i5>
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
 <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
 <20200428032453.GA32072@nuc8i5>
 <acdfcb8d-9079-1340-09d5-2c10383f9c26@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdfcb8d-9079-1340-09d5-2c10383f9c26@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:42:56AM +0200, Nicolas Ferre wrote:
> On 28/04/2020 at 05:24, Dejin Zheng wrote:
> > On Mon, Apr 27, 2020 at 01:33:41PM +0300, Andy Shevchenko wrote:
> > > On Sat, Apr 25, 2020 at 3:57 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> > > > 
> > > > A call of the function macb_init() can fail in the function
> > > > fu540_c000_init. The related system resources were not released
> > > > then. use devm_ioremap() to replace ioremap() for fix it.
> > > > 
> > > 
> > > Why not to go further and convert to use devm_platform_ioremap_resource()?
> > > 
> > devm_platform_ioremap_resource() will call devm_request_mem_region(),
> > and here did not do it.
> 
> And what about devm_platform_get_and_ioremap_resource()? This would
> streamline this whole fu540_c000_init() function.
>
Nicolas, the function devm_platform_get_and_ioremap_resource() will also
call devm_request_mem_region(), after call it, These IO addresses will
be monopolized by this driver. the devm_ioremap() and ioremap() are not
do this. if this IO addresses will be shared with the other driver, call
devm_platform_get_and_ioremap_resource() may be fail.

BR,
Dejin

> Regards,
>   Nicolas
> 
> > > > Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> > > > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > > > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > > > ---
> > > >   drivers/net/ethernet/cadence/macb_main.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > > > index a0e8c5bbabc0..edba2eb56231 100644
> > > > --- a/drivers/net/ethernet/cadence/macb_main.c
> > > > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > > > @@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device *pdev)
> > > >          if (!res)
> > > >                  return -ENODEV;
> > > > 
> > > > -       mgmt->reg = ioremap(res->start, resource_size(res));
> > > > +       mgmt->reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> > > >          if (!mgmt->reg)
> > > >                  return -ENOMEM;
> > > > 
> 
> 
> -- 
> Nicolas Ferre
