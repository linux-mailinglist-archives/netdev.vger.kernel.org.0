Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AE7B6079
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 11:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfIRJgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 05:36:13 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44815 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfIRJgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 05:36:13 -0400
Received: by mail-oi1-f193.google.com with SMTP id w6so5370668oie.11;
        Wed, 18 Sep 2019 02:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=647EZl6hgInflOJEBtnbSt2bfFi2MO4rtXW6zyd4Yx4=;
        b=DwmAzO+BtZSiTJNJ+oK/jqQb7ZlCkFCwR/NQYoDLYJVTNRV6dd8g4MKiulY/Qtfhe5
         +igIgp9JoOzVuRY7Ko124F+0fns5rL8JXbdrh3jBAMe+KwlZIpV8ObrETfqyo88yULyj
         scHfr02h2kWjta2ZGR6m34tNFkUtv6Lq2MiTcEJFE8ZzZJ15S6sbufw1Qxj+cFkRp9R4
         +j96KMA3tfqKnLOjaCJaK8VkMaIARHz99On+gRy9UdV9tWbmbMgfgE4iVtFkHmCksjPQ
         PetOSoBu1uEP+CLPHFpBIWxMX6cPHUTWdlaiK9OztjOHIdt8cbJgcRYQSAExWyinOZEJ
         euIQ==
X-Gm-Message-State: APjAAAWwCf5eBsj3xuzs/6me+nRdLFvT6e3gV9zKDqKXiuxJaha7fFuH
        dkjH9T9Z/NBS2UpGArFavesZF6UhEdXn4dQxxhA=
X-Google-Smtp-Source: APXvYqwVy+ggT271kz8K67E78u+yWVnRd+tPQmMl9bAs0J4PyqnskwqPDXeOxfcqTF0LYMnIctvgq+NoJw6VlSf2Oek=
X-Received: by 2002:aca:3908:: with SMTP id g8mr1598684oia.54.1568799372300;
 Wed, 18 Sep 2019 02:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190821124850.9592-1-yuehaibing@huawei.com> <CAMuHMdXdd4oiHqTpFTYBTSeCB6A78_gSGmwPy5EgPRZXibOqZw@mail.gmail.com>
 <12c00786-980f-5761-3117-3e741e63d7b3@ti.com>
In-Reply-To: <12c00786-980f-5761-3117-3e741e63d7b3@ti.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 Sep 2019 11:35:59 +0200
Message-ID: <CAMuHMdW4Yzd6tMP=mTWvcVdeCbKiDE+Nm2V=73Wsbc5rG6uYNQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: ti: use devm_platform_ioremap_resource()
 to simplify code
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        ivan.khoronzhuk@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grygorii,

On Wed, Sep 18, 2019 at 11:29 AM Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 17/09/2019 21:35, Geert Uytterhoeven wrote:
> > On Wed, Aug 21, 2019 at 2:51 PM YueHaibing <yuehaibing@huawei.com> wrote:
> >> Use devm_platform_ioremap_resource() to simplify the code a bit.
> >> This is detected by coccinelle.
> >>
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> >> ---
> >>   drivers/net/ethernet/ti/cpsw.c | 5 ++---
> >>   1 file changed, 2 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> >> index 32a8974..5401095 100644
> >> --- a/drivers/net/ethernet/ti/cpsw.c
> >> +++ b/drivers/net/ethernet/ti/cpsw.c
> >> @@ -2764,7 +2764,7 @@ static int cpsw_probe(struct platform_device *pdev)
> >>          struct net_device               *ndev;
> >>          struct cpsw_priv                *priv;
> >>          void __iomem                    *ss_regs;
> >> -       struct resource                 *res, *ss_res;
> >> +       struct resource                 *ss_res;
> >>          struct gpio_descs               *mode;
> >>          const struct soc_device_attribute *soc;
> >>          struct cpsw_common              *cpsw;
> >> @@ -2798,8 +2798,7 @@ static int cpsw_probe(struct platform_device *pdev)
> >
> > And just out-of-context, we also have:
> >
> >          ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >          ss_regs = devm_ioremap_resource(dev, ss_res);
> >          if (IS_ERR(ss_regs))
> >
> > which was not detected as being the same pattern?
> >
> > Interesting...
>
> ss_res is used below to determine phys address of CPPI RAM.

Right, thanks, I missed that.

> >
> >>                  return PTR_ERR(ss_regs);
> >>          cpsw->regs = ss_regs;
> >>
> >> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> >> -       cpsw->wr_regs = devm_ioremap_resource(dev, res);
> >> +       cpsw->wr_regs = devm_platform_ioremap_resource(pdev, 1);
> >>          if (IS_ERR(cpsw->wr_regs))
> >>                  return PTR_ERR(cpsw->wr_regs);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
