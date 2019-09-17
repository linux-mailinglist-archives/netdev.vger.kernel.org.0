Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB250B5568
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 20:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfIQSgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 14:36:03 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38186 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfIQSgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 14:36:03 -0400
Received: by mail-ot1-f68.google.com with SMTP id e11so2826371otl.5;
        Tue, 17 Sep 2019 11:36:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=89MnuguQ9bvZxHwMu/z5v0jmYgMuK+bvkbMFTX2cRFk=;
        b=Yp20852S1cn2UCaZ5C3XkUEYzKgRZOyto7t4kPfBmyw2k7+UgS5WN9V90j4pCxcrc7
         Ap4fSyA4m8xzZOXimAX01lQXHbSkXQwuKmEGyE6vMCiHX7ZRFOfV0FStQ99KBOjIrEDw
         FH4WW58iPffBhmBmKB1wM1QgDc/BaTO9KI0/5HeEKy/wULTmUIw5yDt60rmYTcMSgI/m
         EM9WGJ5lubduzkREJeoayaBKwuei1tePqah5ty+gx73fMPta//VVzHS3CdvZyCpUgLUb
         agVdSQrPsPmkX3zzdcja6E76z8peSbieKahIVAtM07wIalHuQBClcuKh5saWPLY10UhL
         NzaA==
X-Gm-Message-State: APjAAAXrjKr6pFu8yZ3miTDtoxw/DdbgI6sVHq8l/cbmfk2tbSyxm5lb
        aPR6ypctYsCYetu0ZhdA4JxaLvA0emufy0QXao4=
X-Google-Smtp-Source: APXvYqyn9SE7wRWHYVeLcbDaLC/fA8y5pA7lkSh6vNLDdZy2V2ds67R6P3uJv32ZyOi3p+RMtTl90k1tqw+mRyZxi4Q=
X-Received: by 2002:a9d:5784:: with SMTP id q4mr191546oth.107.1568745362364;
 Tue, 17 Sep 2019 11:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190821124850.9592-1-yuehaibing@huawei.com>
In-Reply-To: <20190821124850.9592-1-yuehaibing@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 17 Sep 2019 20:35:51 +0200
Message-ID: <CAMuHMdXdd4oiHqTpFTYBTSeCB6A78_gSGmwPy5EgPRZXibOqZw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: ti: use devm_platform_ioremap_resource()
 to simplify code
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
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

Hi YueHaibing,

On Wed, Aug 21, 2019 at 2:51 PM YueHaibing <yuehaibing@huawei.com> wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/ti/cpsw.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 32a8974..5401095 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -2764,7 +2764,7 @@ static int cpsw_probe(struct platform_device *pdev)
>         struct net_device               *ndev;
>         struct cpsw_priv                *priv;
>         void __iomem                    *ss_regs;
> -       struct resource                 *res, *ss_res;
> +       struct resource                 *ss_res;
>         struct gpio_descs               *mode;
>         const struct soc_device_attribute *soc;
>         struct cpsw_common              *cpsw;
> @@ -2798,8 +2798,7 @@ static int cpsw_probe(struct platform_device *pdev)

And just out-of-context, we also have:

        ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
        ss_regs = devm_ioremap_resource(dev, ss_res);
        if (IS_ERR(ss_regs))

which was not detected as being the same pattern?

Interesting...

>                 return PTR_ERR(ss_regs);
>         cpsw->regs = ss_regs;
>
> -       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -       cpsw->wr_regs = devm_ioremap_resource(dev, res);
> +       cpsw->wr_regs = devm_platform_ioremap_resource(pdev, 1);
>         if (IS_ERR(cpsw->wr_regs))
>                 return PTR_ERR(cpsw->wr_regs);

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
