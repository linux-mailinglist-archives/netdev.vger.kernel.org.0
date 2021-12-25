Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C33747F3F0
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 17:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhLYQ7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 11:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhLYQ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 11:59:23 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3F6C061401;
        Sat, 25 Dec 2021 08:59:23 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m21so45732703edc.0;
        Sat, 25 Dec 2021 08:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+k69rh8SFucKX8UvshO5DlBjGVGk6P6s2e6v5dk7jDA=;
        b=CHuldeveHO3cBSB0YH2ZCDhXFLYfDo1mYQ/wgPs8EKLL6KNV0EbAdVZHj46IHUewsy
         2WzMu6lOXmkuXVfP24BY6VpSzII7VGcKQgGTk8lztrgEsO6hRyxayX0xvSDpEjMgjBE6
         FvNaqhyqeoE63oGPLaI2gHzHRCmNy7ueQWkKA2WNVZTmBBJ7rpUBNbT0X2/5fWon0EMC
         06tg3kWDc0hxz7UwlpeHI3FVc7XnNhIhUEMcPQoUsByVuMothnIOeL27O5SrL1HiQH3K
         m7CfeoxSL1IQcUstiNfP8tY0wF2mDJktIqVyFExh0osLKKm9r7X4cZUXJHmqZ9kwzT8h
         GU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+k69rh8SFucKX8UvshO5DlBjGVGk6P6s2e6v5dk7jDA=;
        b=E/wExDyNQ+1OKSPxLFZIzzHzExWjXkW2Vw5tfn9uSm1e4/wXmGDO38lCh1pmgJd2u1
         2jUBHZUVtkakJZzE1KKPfdPGvJE/7lz2FlDEyrH4Ttz9oRYmDU2+0XotdaH8mQGM1fYD
         rfPphGeV0Ufz1GiYhkS+c7vz9L1SfAO4KAlPuU5JNukKTpCobnOkcFi+coEuBRtWeeXy
         lr1UQEgWU0UZp9th6XH4xDH5nXZ4sL7/ikqVmHwA8OR959mcIBUiUVQJ2XWScKuqpCy5
         la6QGfmr99zPG2vwS4g82NO/Ox/2ogy+0HDzrp1OAub1HtcU2HKmfZ1DY56QL61P+XMd
         bOcw==
X-Gm-Message-State: AOAM531BWtuJ8Yj0IT9BmNgNeMk/KkfPhYmE43p0TCl43AtSDqCtw2tS
        ulfiOrUOZch3h0+JhKhphVj6UX8FmiiLF3lhhiI=
X-Google-Smtp-Source: ABdhPJwSdHYOQY3OO23NCjyzqTvku0bzifaBH7915iI/CgIg2/nAGx6Sx2YjqbAUTut9knwmBbRYwl9BsR3BMCXdrGQ=
X-Received: by 2002:a17:906:ced9:: with SMTP id si25mr9308621ejb.77.1640451561707;
 Sat, 25 Dec 2021 08:59:21 -0800 (PST)
MIME-Version: 1.0
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20211224192626.15843-9-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20211224192626.15843-9-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 25 Dec 2021 18:58:45 +0200
Message-ID: <CAHp75Vd60ftgzvWqz+r5YcptimDwURmwOucOBw-WqdHega6NqA@mail.gmail.com>
Subject: Re: [PATCH 8/8] net: ethernet: ti: davinci_emac: Use
 platform_get_irq() to get the interrupt
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 25, 2021 at 4:06 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
> allocation of IRQ resources in DT core code, this causes an issue
> when using hierarchical interrupt domains using "interrupts" property
> in the node as this bypasses the hierarchical setup and messes up the
> irq chaining.
>
> In preparation for removal of static setup of IRQ resource from DT core
> code use platform_get_irq() for DT users only.
>
> While at it propagate error code in case request_irq() fails instead of
> returning -EBUSY.


> +       if (dev_of_node(&priv->pdev->dev)) {

Why?! What's wrong with using the same approach in all cases?

> +               while ((ret = platform_get_irq_optional(priv->pdev, res_num)) != -ENXIO) {

This is wrong.

You need to check better as I pointed several times against your patches.

> +                       if (ret < 0)
> +                               goto rollback;
>
> +                       ret = request_irq(ret, emac_irq, 0, ndev->name, ndev);
> +                       if (ret) {
> +                               dev_err(emac_dev, "DaVinci EMAC: request_irq() failed\n");
>                                 goto rollback;
>                         }
> +                       res_num++;
>                 }
> -               res_num++;
> +       } else {
> +               while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, res_num))) {
> +                       for (irq_num = res->start; irq_num <= res->end; irq_num++) {
> +                               ret = request_irq(irq_num, emac_irq, 0, ndev->name, ndev);
> +                               if (ret) {
> +                                       dev_err(emac_dev, "DaVinci EMAC: request_irq() failed\n");
> +                                       goto rollback;
> +                               }
> +                       }
> +                       res_num++;
> +               }
> +               /* prepare counters for rollback in case of an error */
> +               res_num--;
> +               irq_num--;
>         }

-- 
With Best Regards,
Andy Shevchenko
