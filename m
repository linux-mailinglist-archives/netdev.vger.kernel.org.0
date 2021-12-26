Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8547F71E
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 15:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhLZOZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 09:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhLZOZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 09:25:02 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1A5C06173E;
        Sun, 26 Dec 2021 06:25:02 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id f9so40034092ybq.10;
        Sun, 26 Dec 2021 06:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPSmQVRpFDURHTDiqGlWaD8bs9iVditRvVfyM/+fmAk=;
        b=ko/kj6SKx8/ub4muM+ohTg9hzGiYRLrMac4C5881b65C/7h3fmbOFiFPiaa25pyVYs
         iXeBLm8ODHoXJp+Eusd+NeIvbwNoMlb5Z+KNBVfiviUjxazWcs4GyfSr4ef17vux7fPg
         GRb+Xs9y54Ma3ZfdnivvFc7nyKjyfUnWJmdzQwy/I+maVK3NyV2vBjWD8xEHiYghb9sz
         6CK1VOv5Elk5heNaCEZmoHWtmrm3kdQyhUAo/At4H+Ahl09MVulDYVBIN9TyssioQUN8
         scbPg/HqgpA7xVcaPC9EMK4h4RYBW2pMZGIyCkq7UvC50k0wdnzvk4s+NoIB1MqfCpw5
         ENcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPSmQVRpFDURHTDiqGlWaD8bs9iVditRvVfyM/+fmAk=;
        b=djjFrqlsW+Jm3CEQtud+ZjWEOZ8xtL44LeNrXwFS4Gbt1bAOCLc2GjPE/N6P3Pjips
         DjuWjG4/xE0xAmPHcRarqEw4JETWdJC2ILGYKg3hhvxgVnF/E0AGrv7HO+Nh/b1kmrHq
         1u8Lw3nOG5wvywqgZUjHl+rps55+jJD4sI6MYf/H1mv6yYqrEqU8xteaQp9n9Qe1ICjf
         oQexkIOBxZ06vlQQSikOWffLaWztZku7APza5xudmE0VTPcyyda/sJInMKCp3WdKqrPr
         osHvU0LubPlRmJU7UQQDI2Lbr9fLRenMPH78O7RxuFBh6Gdd7XJxmObmWEjhN5KWrmg+
         qu6A==
X-Gm-Message-State: AOAM532PIhzfZySZvLtWJio794VkAabQ3WUmLRAbtudpPiaQukEU57Jc
        d+BIwvlUKQYf2oE+uz91J+/5kqkWDOc/nsziQ3A7h96BYIr+lQ==
X-Google-Smtp-Source: ABdhPJw2qDMJ6Lbh+HWo+YWy2haCM0TYULR8bI35MneN8iItwqMXump8I3gIkF6ip3rZJfrWWi2UuKweAAt7f6dZZRc=
X-Received: by 2002:a25:1004:: with SMTP id 4mr17511876ybq.669.1640528701775;
 Sun, 26 Dec 2021 06:25:01 -0800 (PST)
MIME-Version: 1.0
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211224192626.15843-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAHp75VcurBNEcMFnAHTg8PTbJOhO7QA4iv1t4W=siC=D-AkHAw@mail.gmail.com>
 <CA+V-a8tuD-WKyRL_kwitqOyxJDMu1J14AtZ12LbSF9+8mj+=FQ@mail.gmail.com> <bb5a43e5-6036-3788-71ca-c411611e0ad9@gmail.com>
In-Reply-To: <bb5a43e5-6036-3788-71ca-c411611e0ad9@gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sun, 26 Dec 2021 14:24:36 +0000
Message-ID: <CA+V-a8uykb1=LVgi7NPsBxkGwh2Dwzy0JggbLnsWk05oHQ4NOQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] net: pxa168_eth: Use platform_get_irq() to get the interrupt
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

Thank you for the review.

On Sun, Dec 26, 2021 at 11:15 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 25.12.2021 13:19, Lad, Prabhakar wrote:
> > Hi Andy,
> >
> > Thank you for the review.
> >
> > On Sat, Dec 25, 2021 at 11:24 AM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> >>
> >>
> >>
> >> On Friday, December 24, 2021, Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >>>
> >>> platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
> >>> allocation of IRQ resources in DT core code, this causes an issue
> >>> when using hierarchical interrupt domains using "interrupts" property
> >>> in the node as this bypasses the hierarchical setup and messes up the
> >>> irq chaining.
> >>>
> >>> In preparation for removal of static setup of IRQ resource from DT core
> >>> code use platform_get_irq().
> >>>
> >>> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >>> ---
> >>>  drivers/net/ethernet/marvell/pxa168_eth.c | 9 +++++----
> >>>  1 file changed, 5 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
> >>> index 1d607bc6b59e..52bef50f5a0d 100644
> >>> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
> >>> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> >>> @@ -1388,7 +1388,6 @@ static int pxa168_eth_probe(struct platform_device *pdev)
> >>>  {
> >>>         struct pxa168_eth_private *pep = NULL;
> >>>         struct net_device *dev = NULL;
> >>> -       struct resource *res;
> >>>         struct clk *clk;
> >>>         struct device_node *np;
> >>>         int err;
> >>> @@ -1419,9 +1418,11 @@ static int pxa168_eth_probe(struct platform_device *pdev)
> >>>                 goto err_netdev;
> >>>         }
> >>>
> >>> -       res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >>> -       BUG_ON(!res);
> >>> -       dev->irq = res->start;
> >>> +       err = platform_get_irq(pdev, 0);
> >>> +       if (err == -EPROBE_DEFER)
> >>
> >>
> >>  What about other errors?
> >>
> > Ouch I missed it...
> >>
> >>>
> >>> +               goto err_netdev;
> >>> +       BUG_ON(dev->irq < 0);
> >>
> >>
> >> ??? What is this and how it supposed to work?
> >>
> >
> .. should have been BUG_ON(dev->irq < 0);
>
> Usage of BUG_ON() is discouraged. Better handle the error w/o stopping
> the whole system.
>
Agreed, if everyone is OK i'll create a separate patch for removal of
BUG_ON() and the later patch for using platform_get_irq().

Cheers,
Prabhakar
