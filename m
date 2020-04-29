Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFDC1BE177
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgD2Opf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgD2Opf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:45:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0151C03C1AD;
        Wed, 29 Apr 2020 07:45:33 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so836030pjb.3;
        Wed, 29 Apr 2020 07:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=69Tp1mSQ7NPHm94uWqS6FIaA0fFYFrKBdlLv7IBtpLY=;
        b=s/4fWTDbicXxmAN5YG2saVluSNShiBVuWUNJZd/3hsWObcVKMy+Hz1LFaNj9nXro2G
         sznVBIlTCrRZ2I2uKdyZzr+P2XcANNgcItCmiaxu0YWuSr1y9FKO8TbvuyP+qUpethOF
         zbzpuZaYO4dkHWOA8nkNxHFcrinDdw0rWYJ4RG5vVgoJKDqkV380c3YuOnRlT2u1Mmym
         IXHzJuMfVlUjkacfX6IY4wo+Y0h2ClS5Eikv3yaC6iD9auzQsb09FnXbjmGkKjYcI0VR
         ZCmrp4Q6wqzpFkNL6npESO9vfRxDrR12GQo2s+sS3JGuy4DsPuJ9MvJuJpEDveqVxsrY
         zeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=69Tp1mSQ7NPHm94uWqS6FIaA0fFYFrKBdlLv7IBtpLY=;
        b=bQOtuuuOIW8UsTZlt4QmJHta9gVajTZNSfSh1J8VAZ0ovJOcc4xAWqJWOBqzz+STfo
         7uPjuhTVwehJBJtX5BwxQP839jWEiCSGfSILHohRprnURBeFfR1ihlyNpIiEa+Gdfi3v
         A0Ha/HXJQNzngV2tbLvunvMQJ087dNLMV5vXb4Mdf34fMyPDMWIKxMtK8Cq6rgYCwCG4
         uQ4ZX/YrtR0AXfQ1qhxjnpyJrXqntlxNoufJRgQOQQc1Qhri5wtx0twBxP5vwcADgT6Z
         Lnhq+TK/Is10ML/HqxuPrHD7V1jSGN7Ns3hsozY2izlnQrKLIkV0dKR3ejZWZugA2UNH
         Rj1Q==
X-Gm-Message-State: AGi0PuZWJACPLiHGYYiii50RejdrYGOmdAzc4Gm15UWlMUz0e5Ynq74z
        Y+y3aC09HcIa+hDZI26FYjE=
X-Google-Smtp-Source: APiQypJEz4yCvNnsCq7cYbXWfMJygr572PjmwVxS4xfP0wVxMeKtNpYx9V6g+vd9g1uvMfnwFHt1Xg==
X-Received: by 2002:a17:90a:6403:: with SMTP id g3mr3243981pjj.99.1588171533315;
        Wed, 29 Apr 2020 07:45:33 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id i190sm1283383pfe.114.2020.04.29.07.45.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 07:45:32 -0700 (PDT)
Date:   Wed, 29 Apr 2020 22:45:27 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     davem@davemloft.net, paul.walmsley@sifive.com, palmer@dabbelt.com,
        yash.shah@sifive.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH net v2] net: macb: fix an issue about leak related system
 resources
Message-ID: <20200429144527.GA639@nuc8i5>
References: <20200429135651.32635-1-zhengdejin5@gmail.com>
 <3ed83017-f3de-b6b0-91d0-d9075ad9eed5@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ed83017-f3de-b6b0-91d0-d9075ad9eed5@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 04:15:56PM +0200, Nicolas Ferre wrote:
> On 29/04/2020 at 15:56, Dejin Zheng wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > A call of the function macb_init() can fail in the function
> > fu540_c000_init. The related system resources were not released
> > then. use devm_platform_ioremap_resource() to replace ioremap()
> > to fix it.
> > 
> > Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
> > Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Reviewed-by: Yash Shah <yash.shah@sifive.com>
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> > v1 -> v2:
> >          - Nicolas and Andy suggest use devm_platform_ioremap_resource()
> >            to repalce devm_ioremap() to fix this issue. Thanks Nicolas
> >            and Andy.
> >          - Yash help me to review this patch, Thanks Yash!
> > 
> >   drivers/net/ethernet/cadence/macb_main.c | 8 +-------
> >   1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index a0e8c5bbabc0..99354e327d1f 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -4172,13 +4172,7 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
> > 
> >   static int fu540_c000_init(struct platform_device *pdev)
> >   {
> > -       struct resource *res;
> > -
> > -       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > -       if (!res)
> > -               return -ENODEV;
> > -
> > -       mgmt->reg = ioremap(res->start, resource_size(res));
> > +       mgmt->reg = devm_platform_ioremap_resource(pdev, 1);
> >          if (!mgmt->reg)
> 
> Is your test valid then?
>
Hi Nicolas:

I just compiled it successfully and I didn't have the hardware of this
driver, so I did not tested it. and this patch only affects the driver
of "sifive,fu540-macb", if these IO addresses can be monopolized by
this driver, this change should be ok.


Hi Yash:

Do you know that these IO addresses can be occupied by this driver
alone? Thank you very much!

BR,
Dejin

> Please use:
> if (IS_ERR(base))
>    return PTR_ERR(base);
> As advised by:
> lib/devres.c:156
>
Thanks!, I will sent it in patch v3.

> Regards,
>   Nicolas
> 
> >                  return -ENOMEM;
> > 
> > --
> > 2.25.0
> > 
> 
> 
> -- 
> Nicolas Ferre
