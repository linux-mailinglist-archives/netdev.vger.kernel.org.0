Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF6949B0F8
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237114AbiAYJy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiAYJvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:51:07 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1ACC06175D
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:51:06 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id n10so46021957edv.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HlPvap3s7pdO0i3AvOfOgwK8HydV4tcDe28Yz+r5dr0=;
        b=czSb6VFvgku1bVsTdGbcRTR0h8h7GNK9U7KQbStWcKMBxUQIn8d5yU5gfXgnxAmfvr
         2OsmpbsMIKQIJzgXfb/MHunf7rUu/HGy0aTFyNATY4s5oSHnUwkn+ccspaA7B4xMMS1x
         ODBXUhk+iS4skIxEjJktEEBsCu1Mqmf1LYWH64SqZdlpNzh3svpwMTEynwMu1BHsJCQh
         s/nSaUKZT5NM+M527n8NWD/Z6I5Nc9AKrr4oIkAPNW16pRI9PW4+GrJAo9N+219PjRZh
         p3qKj2+9BdnsGQKJ/+Afhue35T2O3LgrmT+bzwkIXvYESr2x0PxpiBd3hO+zmXQ08DjV
         O1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HlPvap3s7pdO0i3AvOfOgwK8HydV4tcDe28Yz+r5dr0=;
        b=5DoyOrr3Bo+PvOvoXvY2V106WKnbXGiZrG6qKghkZ0FTZWNPDYCuks2caQjCdCAAoh
         +bb6O/p09FSsmnTojNS6kJAP1wmFfgATDejwo/uMIdQlW+7bq5dq+yBGU5UoKjey7TGG
         x96ZNgAUr6NAycuqmPgylFxEJQ5UqtIP2LrqUu+XdrtGtpITG3gOL2tldHu3C7YlyK0G
         oGxa/RgNe5sZKKnoR8RiC8+9LyBj4ysiZWWzHYYY+sQiPo+fULsHBe5sNM7vKJD3QRVC
         SHT9Uh3n50DwUJGQe1MEHa7YJZzHfZN+8xUHg/5CdKJy2A8bSuOAfRw8HNJpUy+lu3bY
         kjNQ==
X-Gm-Message-State: AOAM531cG3EAKpvJND1k6gqtZW6dJUeAKcmVW/iP/ZQ34gKAJ3m2kYen
        z7GKupaYp0jUqCmmfBDRJOV1Y7uA343ocTaIf5bIbw==
X-Google-Smtp-Source: ABdhPJwQzlX3EMzz8K17JeuAaI2l2wrQ2t9jeb+BkBrkVLHJV+P7nqMNLX4xKtjzYu9msSkcu7xBJKtfWdWFjHaLCAI=
X-Received: by 2002:a05:6402:1604:: with SMTP id f4mr19666005edv.352.1643104264783;
 Tue, 25 Jan 2022 01:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20220120070226.1492-1-biao.huang@mediatek.com> <20220120070226.1492-2-biao.huang@mediatek.com>
In-Reply-To: <20220120070226.1492-2-biao.huang@mediatek.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 25 Jan 2022 10:50:54 +0100
Message-ID: <CAMRc=Mc+DqcQFGqxoYXYG-VCuaKkJusoVGSHb0G-MtYsiVCxVw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/9] net: ethernet: mtk-star-emac: store
 bit_clk_div in compat structure
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        srv_heupstream@mediatek.com, Macpaul Lin <macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 8:02 AM Biao Huang <biao.huang@mediatek.com> wrote:
>
> From: Fabien Parent <fparent@baylibre.com>
>
> Not all the SoC are using the same clock divider. Move the divider into
> a compat structure specific to the SoCs.
>
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 23 +++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> index 1d5dd2015453..26f5020f2e9c 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/platform_device.h>
> @@ -232,6 +233,10 @@ struct mtk_star_ring {
>         unsigned int tail;
>  };
>
> +struct mtk_star_compat {
> +       unsigned char bit_clk_div;
> +};
> +
>  struct mtk_star_priv {
>         struct net_device *ndev;
>
> @@ -257,6 +262,8 @@ struct mtk_star_priv {
>         int duplex;
>         int pause;
>
> +       const struct mtk_star_compat *compat_data;
> +
>         /* Protects against concurrent descriptor access. */
>         spinlock_t lock;
>
> @@ -899,7 +906,7 @@ static void mtk_star_init_config(struct mtk_star_priv *priv)
>         regmap_write(priv->regs, MTK_STAR_REG_SYS_CONF, val);
>         regmap_update_bits(priv->regs, MTK_STAR_REG_MAC_CLK_CONF,
>                            MTK_STAR_MSK_MAC_CLK_CONF,
> -                          MTK_STAR_BIT_CLK_DIV_10);
> +                          priv->compat_data->bit_clk_div);
>  }
>
>  static void mtk_star_set_mode_rmii(struct mtk_star_priv *priv)
> @@ -1461,6 +1468,7 @@ static int mtk_star_probe(struct platform_device *pdev)
>
>         priv = netdev_priv(ndev);
>         priv->ndev = ndev;
> +       priv->compat_data = of_device_get_match_data(&pdev->dev);
>         SET_NETDEV_DEV(ndev, dev);
>         platform_set_drvdata(pdev, ndev);
>
> @@ -1556,10 +1564,17 @@ static int mtk_star_probe(struct platform_device *pdev)
>         return devm_register_netdev(dev, ndev);
>  }
>
> +static struct mtk_star_compat mtk_star_mt8516_compat = {

static const ... ?

> +       .bit_clk_div = MTK_STAR_BIT_CLK_DIV_10,
> +};
> +
>  static const struct of_device_id mtk_star_of_match[] = {
> -       { .compatible = "mediatek,mt8516-eth", },
> -       { .compatible = "mediatek,mt8518-eth", },
> -       { .compatible = "mediatek,mt8175-eth", },
> +       { .compatible = "mediatek,mt8516-eth",
> +         .data = &mtk_star_mt8516_compat },
> +       { .compatible = "mediatek,mt8518-eth",
> +         .data = &mtk_star_mt8516_compat },
> +       { .compatible = "mediatek,mt8175-eth",
> +         .data = &mtk_star_mt8516_compat },
>         { }
>  };
>  MODULE_DEVICE_TABLE(of, mtk_star_of_match);
> --
> 2.25.1
>
