Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B84E2E9381
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhADKm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 05:42:28 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:43825 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhADKm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 05:42:28 -0500
Received: by mail-ot1-f46.google.com with SMTP id q25so25563716otn.10;
        Mon, 04 Jan 2021 02:42:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S4IVbE7LzJfQ0v8UqgW0RPFmuPLfdoUzAgSWkg+Ttc8=;
        b=Udy122TOZsFa9aMxoS0cL6qJe/LofBB9z9trxJNRsd5TjlXzQQtwwL1n+BQFb1+Riy
         k4Y4Plb2YZ4THD7u/0wP9WSIBiwU+M60hjAAvC8+Lsi7f1000LzG1w+CBshtxjqOgaVe
         rCdgzWSDE55yycLQ+nfnF68Qs5r6Lsvv7DOBgfxCHsLJDwzwqCEk5ZCWFAgwMvGv2K97
         ZSBkiuHag9ftj1BSmB0lEhbbDD0LPw/p7sqW+NOyN8zealQ7y84e5CM384lHeOsCg5qn
         hv9+C53OO8QKEjKS5ViFJuXm9bdB/XxPubtxljmJf3ckhNeXpCGUkRJHCDh3zYnfUCHt
         kSyw==
X-Gm-Message-State: AOAM5322hQv4PeabErA6jNdGRCcw6jiUH/YJBlk5LI2ibMsngkn0kY7U
        PP49m8ge+oCLjWrQw6kEKd5Eco+dr5gqCT9nmg4=
X-Google-Smtp-Source: ABdhPJzpTyOsYqkffItlUkWN/wndvtYGxzzu7wXZ1SHmN7oyEIsTQAbA7mSKZymIYePJf+62beQfMfvBDnjDxkPFQjM=
X-Received: by 2002:a05:6830:210a:: with SMTP id i10mr52172686otc.145.1609756907197;
 Mon, 04 Jan 2021 02:41:47 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com> <20201228213121.2331449-4-aford173@gmail.com>
In-Reply-To: <20201228213121.2331449-4-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Jan 2021 11:41:36 +0100
Message-ID: <CAMuHMdUCsAGYGS8oygT2xySRSm3Op4cJJmcnEK9BC732ZvN6JA@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: ethernet: ravb: Name the AVB functional clock fck
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Mon, Dec 28, 2020 at 10:32 PM Adam Ford <aford173@gmail.com> wrote:
> The bindings have been updated to support two clocks, but the
> original clock now requires the name fck to distinguish it
> from the other.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Thanks for your patch!

> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2142,7 +2142,7 @@ static int ravb_probe(struct platform_device *pdev)
>
>         priv->chip_id = chip_id;
>
> -       priv->clk = devm_clk_get(&pdev->dev, NULL);
> +       priv->clk = devm_clk_get(&pdev->dev, "fck");

This change is not backwards compatible, as existing DTB files do not
have the "fck" clock.  So the driver has to keep on assuming the first
clock is the functional clock, and this patch is thus not needed nor
desired.

>         if (IS_ERR(priv->clk)) {
>                 error = PTR_ERR(priv->clk);
>                 goto out_release;

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
