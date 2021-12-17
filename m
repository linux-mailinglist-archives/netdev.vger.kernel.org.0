Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF10E4781C6
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhLQAsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhLQAsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:48:04 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83BCC061574;
        Thu, 16 Dec 2021 16:48:03 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id v64so1801999ybi.5;
        Thu, 16 Dec 2021 16:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XYNusbjwkkYtN/QqZDFJGNCvR7j+Lfic/Sj6wFR/rlA=;
        b=Fc74BzUP0DveI3XwHOmFP8RJsyGE+DkOpU1Xa86Kf5a7gRDpS6nD0yAF/z0/Yx376q
         IwvvRbozHe5AlsXNhKTEaRSVh//gckNd6G90XqQS62512vWryB2CIvJeBuyjKE9taC5s
         +z93K7jAvuvtC/DGNz0MOhArCdTVxT3bkPtzr61ztIcq5TKcMvC8BvxeHum+rLP9Cz6g
         G85M08wLApbDMWTI2oOsjzFfb7VAve9L/qiQKBc7pLN+/C6a962hruRac1AcyJsAxr0a
         RX93y5HVNB2HJ9EXWHELdOwC08mvScNMq0WuQnFYuzI1dwDM99XnhFdw4qaHyvS2xWrW
         lGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XYNusbjwkkYtN/QqZDFJGNCvR7j+Lfic/Sj6wFR/rlA=;
        b=P1cDT6PvZkZuWJborzJogz9Us0AeAOtUPfOioJYuMgq7u/8uneYNROtqjl6TMUTuS2
         lI4nrhwlaJpYCZoanw6fPM1QAPwEQH9EdQV78EdTOR3xIc1BY0qFGDNf5zw0MgAJFavH
         u/dIW81tzAHJeMeJQl8IS5NkKNkVjqT5k8Mz4TEIzHe7RKBjoYQt2zZfRSblPtKYfW/I
         Hb3B0wd7lhmcUt8byjxhFs2zGEBD9Evdg/Jlk1YiovbKwkOafjjs64w9uATrgUBAxpEz
         l3chAAd49yCa2rmy94ZPCTJxKypsXO0IAu4I/yJC1WAuDFjmbjIlbumEfKllCdvR8BRM
         HabA==
X-Gm-Message-State: AOAM5304+BtxNt54ErxoCgEN62ktqfJ/W+GAtrFSiLAF0EvT7s+6A5fd
        XT8EzKBp9MLcdSQufPYxIvt8YrZ2KulXfwgfUOs=
X-Google-Smtp-Source: ABdhPJwpeglE9sHoAX5UTcJS8a4yEjrP4mkljRYPnLSOtbz6fsUoQrmEVVKwqbma0QvbY31yg+dpgqzLhDJYqPiswns=
X-Received: by 2002:a25:1004:: with SMTP id 4mr934036ybq.669.1639702082961;
 Thu, 16 Dec 2021 16:48:02 -0800 (PST)
MIME-Version: 1.0
References: <20211217003540.21344-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20211217003540.21344-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 17 Dec 2021 00:47:37 +0000
Message-ID: <CA+V-a8uuSRP8H9_kfUoy7+e9MJuwA7nP2w3PRDAm_2K7-x9uqw@mail.gmail.com>
Subject: Re: [PATCH] net: mv643xx_eth: Propagate errors from of_irq_to_resource()
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On Fri, Dec 17, 2021 at 12:35 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
>
> The driver overrides the error code returned by of_irq_to_resource() to
> -EINVAL. Switch to propagating the error code upstream so that errors
> such as -EPROBE_DEFER are handled.
>
> While at it drop the memset() operation as of_irq_to_resource()
> does call memset() before filling in the IRQ resource.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
Please ignore this patch, as the plan is to drop all the users
of_irq_to_resource() (see [0]). I'll send a new patch which uses the
preferred way of platform_get_irq().

[0] https://patchwork.ozlabs.org/project/linux-ide/patch/20211217001238.16298-1-prabhakar.mahadev-lad.rj@bp.renesas.com/

Cheers,
Prabhakar

> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 105247582684..7a5ff629d158 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -2716,10 +2716,10 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
>         memset(&ppd, 0, sizeof(ppd));
>         ppd.shared = pdev;
>
> -       memset(&res, 0, sizeof(res));
> -       if (of_irq_to_resource(pnp, 0, &res) <= 0) {
> +       ret = of_irq_to_resource(pnp, 0, &res);
> +       if (ret <= 0) {
>                 dev_err(&pdev->dev, "missing interrupt on %pOFn\n", pnp);
> -               return -EINVAL;
> +               return ret ? ret : -ENXIO;
>         }
>
>         if (of_property_read_u32(pnp, "reg", &ppd.port_number)) {
> --
> 2.17.1
>
