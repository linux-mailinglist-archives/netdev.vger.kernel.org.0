Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2D47F33A
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 13:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhLYMTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 07:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhLYMTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 07:19:36 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA96EC061401;
        Sat, 25 Dec 2021 04:19:36 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id k69so14582040ybf.1;
        Sat, 25 Dec 2021 04:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kx+36xsr0Ny2N7LS8kpmmApX5XKoC8oiXANGbtnyyDA=;
        b=PRjiA6HCvaAn0PACGcBU9DJT7nVBbcPAuVOxVtsPUXIFcTnE4axx4aTEULvrFHDoyT
         MFX3sTHuFkEsKdOI2OnKKZSngVkub+MkLGUYrQzbZ1IqCWDM/SD18rsHpOzk+iG/+2aM
         6slt7lu+tbTEE+TNRrySq+HRx0kMlCoGG/wqAXwM8uPxaw+P+ZqbJel2uCJgqkglZUEH
         xBW58pN9Mn/c7TofZoPQcuNnarwJTrNGmanZzCNTu/CojP4z9ewN/vwZTkeJat/B1G5H
         XOTb0a+2yMjQiWtgeJBX6Jku8YDvZ8uGlLNde4W1eI0lzDoqTPrXgTPH/AwCqb84nrwc
         /2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kx+36xsr0Ny2N7LS8kpmmApX5XKoC8oiXANGbtnyyDA=;
        b=5qcrb/dfFhght7CN+uSTNSf2uSXrN5Oq9Sxh+XaS/fF0k7t/pZc6KYD99S/HdIU853
         wtqMhZhekm++QL61iE4rIyppJ/vd7uZWZVDxz+emp5dBmvXhq8SAu8RYg9DHw3fiKBpq
         WFnuMthyuKg4XlqsBoLdqmIda2hQAY5kgeZwGXCZ5PVjBspKFuSEzb6XmmypUbEiKmfD
         TkaiASubLjzzJDoVQ79ACoJODKfVnY4GO+UsNdrP2gSqn4Dd9IpCIWA9gkyuNAyRXKBV
         K2RJRSfhtajbxv0Y/K7rSqmRepilK7/iql7tnNFatXTOGPD9Tfc1DdDdlKQwsB1zps7T
         z5vA==
X-Gm-Message-State: AOAM533Y4vk9bP1sbkue65RlTyVnUaSpaU3IDwyfTC2+OM8d7mz7nh2O
        sZ67ym8AbxSX24MGJCsC3RfByFyT3+q+70lCVRgxMHObXOouAQ==
X-Google-Smtp-Source: ABdhPJzWPnf1J0cQdExxgB+EfJZiasfQNGIO8fpp8WmWtWW54AXDzPVelHTOckdMZ8zFeBDgPuqpLhHnsDdWnqdk2JU=
X-Received: by 2002:a25:dc4d:: with SMTP id y74mr13112043ybe.422.1640434775870;
 Sat, 25 Dec 2021 04:19:35 -0800 (PST)
MIME-Version: 1.0
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211224192626.15843-3-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAHp75VcurBNEcMFnAHTg8PTbJOhO7QA4iv1t4W=siC=D-AkHAw@mail.gmail.com>
In-Reply-To: <CAHp75VcurBNEcMFnAHTg8PTbJOhO7QA4iv1t4W=siC=D-AkHAw@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 25 Dec 2021 12:19:09 +0000
Message-ID: <CA+V-a8tuD-WKyRL_kwitqOyxJDMu1J14AtZ12LbSF9+8mj+=FQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] net: pxa168_eth: Use platform_get_irq() to get the interrupt
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thank you for the review.

On Sat, Dec 25, 2021 at 11:24 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
>
>
> On Friday, December 24, 2021, Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>>
>> platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
>> allocation of IRQ resources in DT core code, this causes an issue
>> when using hierarchical interrupt domains using "interrupts" property
>> in the node as this bypasses the hierarchical setup and messes up the
>> irq chaining.
>>
>> In preparation for removal of static setup of IRQ resource from DT core
>> code use platform_get_irq().
>>
>> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>> ---
>>  drivers/net/ethernet/marvell/pxa168_eth.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
>> index 1d607bc6b59e..52bef50f5a0d 100644
>> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
>> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
>> @@ -1388,7 +1388,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
>>  {
>>         struct pxa168_eth_private *pep = NULL;
>>         struct net_device *dev = NULL;
>> -       struct resource *res;
>>         struct clk *clk;
>>         struct device_node *np;
>>         int err;
>> @@ -1419,9 +1418,11 @@ static int pxa168_eth_probe(struct platform_device *pdev)
>>                 goto err_netdev;
>>         }
>>
>> -       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> -       BUG_ON(!res);
>> -       dev->irq = res->start;
>> +       err = platform_get_irq(pdev, 0);
>> +       if (err == -EPROBE_DEFER)
>
>
>  What about other errors?
>
Ouch I missed it...
>
>>
>> +               goto err_netdev;
>> +       BUG_ON(dev->irq < 0);
>
>
> ??? What is this and how it supposed to work?
>
.. should have been BUG_ON(dev->irq < 0);

Cheers,
Prabhakar
>>
>> +       dev->irq = err;
>>         dev->netdev_ops = &pxa168_eth_netdev_ops;
>>         dev->watchdog_timeo = 2 * HZ;
>>         dev->base_addr = 0;
>> --
>> 2.17.1
>>
>
>
> --
> With Best Regards,
> Andy Shevchenko
>
>
