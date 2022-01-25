Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6EB49B1D4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355267AbiAYK36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345474AbiAYKVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:21:16 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D85C06176F
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:21:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ka4so29536614ejc.11
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 02:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v30D70OPLVtNvFxgkZp8dWGqr6GnI2jw20wYyawnuRI=;
        b=AUsbUFpvHTKDZX3ZukbLUoAGTJSi9S6T4AQCEsSPtBYGHVZflIPIZw/zkNiiN1exep
         MnpRX2vHE7sy5EBCo71VGSAagsa2XC38QHM3OTYb7cWIuNiWchdFa80d1CjtvJKI1FQa
         e7pw4XA5DaDfsIUnh6r+TV8keYnrvDYFVT33+Y9Mm4AK09mrWO0pLzu71g9sHsBYmM8N
         j+AG6Wdy/7M3tOhaR5rPZ7WOTopxQ2I8iC/VpYFYyhx1hGHiacj0YnrDgdAU3wLviJHF
         eXuveFyWkQcA/ZuKsfVscVx0/TVJe0+geQjASwzW+4ZYvqI5oAFNQPMU95KKFJClVLOg
         WfoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v30D70OPLVtNvFxgkZp8dWGqr6GnI2jw20wYyawnuRI=;
        b=Q+EizTOyjPr3GAhi+aioZhaG4kZple3lnpU7jLrpzHrc4x72clhoCgqDpLQrWyhgK2
         a2jyr6QN/+oqmIVoIlPwOkO8JsrgSNKV1B/hUwuLwKtrOFGEzYCLhx1Ds2+Ty5B1cO41
         YXLmkz/mfXSbm3Pr/IK9fGoeBKMCNqgLk4vkBMBIAIPgiwiDDkwCTbKmytOUJah/1hnm
         rqcVnTbWhaiyK6x4vAGbduvQu2AlwMldnAt0SiPTeJ7gCnCHzRtPYqfU1LXZxUI1B7/i
         0XAcZKg27b7L7X4MAjRLai/lbalKMzs0RzhAKrn/5/zyuzxm1E8/dLv7/0WEmjvxwgQ7
         GeDw==
X-Gm-Message-State: AOAM533+E0C/dlnI+LwyItyHY0lHSma97Fai6HuVy3srGhuPowr26Fj6
        iz6Q+QdMKQhtv/s2U0dOJYz7g4/UA0f+lqZIwNWtoQ==
X-Google-Smtp-Source: ABdhPJyZM143/v5BtbEzwl4CJ0VdaPnxdnt1JP9K52HtAqo20ZBqnWWeJc055EuQVBHION5NGjljDfxy9u2pvij2MMM=
X-Received: by 2002:a17:906:cc84:: with SMTP id oq4mr16696651ejb.736.1643106071794;
 Tue, 25 Jan 2022 02:21:11 -0800 (PST)
MIME-Version: 1.0
References: <20220120070226.1492-1-biao.huang@mediatek.com> <20220120070226.1492-4-biao.huang@mediatek.com>
In-Reply-To: <20220120070226.1492-4-biao.huang@mediatek.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Tue, 25 Jan 2022 11:21:01 +0100
Message-ID: <CAMRc=MefKOmdKbm5KT=zQLORwm7oYe1oUy_XW3heqAqFqbE5NQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 3/9] net: ethernet: mtk-star-emac: add support
 for MT8365 SoC
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
> Add Ethernet driver support for MT8365 SoC.
>
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
> Signed-off-by: Fabien Parent <fparent@baylibre.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 75 ++++++++++++++++---
>  1 file changed, 64 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> index 7c2af775d601..403439782db9 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -151,6 +151,7 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
>  #define MTK_STAR_REG_MAC_CLK_CONF              0x00ac
>  #define MTK_STAR_MSK_MAC_CLK_CONF              GENMASK(7, 0)
>  #define MTK_STAR_BIT_CLK_DIV_10                        0x0a
> +#define MTK_STAR_BIT_CLK_DIV_50                        0x32
>
>  /* Counter registers. */
>  #define MTK_STAR_REG_C_RXOKPKT                 0x0100
> @@ -183,9 +184,11 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
>  #define MTK_STAR_REG_C_RX_TWIST                        0x0218
>
>  /* Ethernet CFG Control */
> -#define MTK_PERICFG_REG_NIC_CFG_CON            0x03c4
> -#define MTK_PERICFG_MSK_NIC_CFG_CON_CFG_MII    GENMASK(3, 0)
> -#define MTK_PERICFG_BIT_NIC_CFG_CON_RMII       BIT(0)
> +#define MTK_PERICFG_REG_NIC_CFG0_CON           0x03c4
> +#define MTK_PERICFG_REG_NIC_CFG1_CON           0x03c8
> +#define MTK_PERICFG_REG_NIC_CFG_CON_V2         0x0c10
> +#define MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF   GENMASK(3, 0)
> +#define MTK_PERICFG_BIT_NIC_CFG_CON_RMII       1
>
>  /* Represents the actual structure of descriptors used by the MAC. We can
>   * reuse the same structure for both TX and RX - the layout is the same, only
> @@ -234,6 +237,7 @@ struct mtk_star_ring {
>  };
>
>  struct mtk_star_compat {
> +       int (*set_interface_mode)(struct net_device *ndev);
>         unsigned char bit_clk_div;
>  };
>
> @@ -909,13 +913,6 @@ static void mtk_star_init_config(struct mtk_star_priv *priv)
>                            priv->compat_data->bit_clk_div);
>  }
>
> -static void mtk_star_set_mode_rmii(struct mtk_star_priv *priv)
> -{
> -       regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG_CON,
> -                          MTK_PERICFG_MSK_NIC_CFG_CON_CFG_MII,
> -                          MTK_PERICFG_BIT_NIC_CFG_CON_RMII);
> -}
> -
>  static int mtk_star_enable(struct net_device *ndev)
>  {
>         struct mtk_star_priv *priv = netdev_priv(ndev);
> @@ -1531,7 +1528,13 @@ static int mtk_star_probe(struct platform_device *pdev)
>                 return -ENODEV;
>         }
>
> -       mtk_star_set_mode_rmii(priv);
> +       if (priv->compat_data->set_interface_mode) {
> +               ret = priv->compat_data->set_interface_mode(ndev);
> +               if (ret) {
> +                       dev_err(dev, "Failed to set phy interface, err = %d\n", ret);
> +                       return -EINVAL;
> +               }
> +       }

Shouldn't you still call mtk_star_set_mode_rmii(priv) if there's no callback?

>
>         ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>         if (ret) {
> @@ -1564,10 +1567,58 @@ static int mtk_star_probe(struct platform_device *pdev)
>         return devm_register_netdev(dev, ndev);
>  }
>
> +static int mt8516_set_interface_mode(struct net_device *ndev)
> +{
> +       struct mtk_star_priv *priv = netdev_priv(ndev);
> +       struct device *dev = mtk_star_get_dev(priv);
> +       unsigned int intf_val = 0;

No need to initialize.

> +
> +       switch (priv->phy_intf) {
> +       case PHY_INTERFACE_MODE_RMII:
> +               intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
> +               break;
> +       default:
> +               dev_err(dev, "This interface not supported\n");
> +               return -EINVAL;
> +       }
> +
> +       regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG0_CON,
> +                          MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
> +                          intf_val);
> +       return 0;

You can directly return regmap_update_bits().

> +}
> +
> +static int mt8365_set_interface_mode(struct net_device *ndev)
> +{
> +       struct mtk_star_priv *priv = netdev_priv(ndev);
> +       struct device *dev = mtk_star_get_dev(priv);
> +       unsigned int intf_val = 0;
> +
> +       switch (priv->phy_intf) {
> +       case PHY_INTERFACE_MODE_RMII:
> +               intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
> +               break;
> +       default:
> +               dev_err(dev, "This interface not supported\n");
> +               return -EINVAL;
> +       }
> +
> +       regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG_CON_V2,
> +                          MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
> +                          intf_val);
> +       return 0;
> +}

Same as above.

> +
>  static struct mtk_star_compat mtk_star_mt8516_compat = {
> +       .set_interface_mode = mt8516_set_interface_mode,
>         .bit_clk_div = MTK_STAR_BIT_CLK_DIV_10,
>  };
>
> +static struct mtk_star_compat mtk_star_mt8365_compat = {
> +       .set_interface_mode = mt8365_set_interface_mode,
> +       .bit_clk_div = MTK_STAR_BIT_CLK_DIV_50,
> +};
> +
>  static const struct of_device_id mtk_star_of_match[] = {
>         { .compatible = "mediatek,mt8516-eth",
>           .data = &mtk_star_mt8516_compat },
> @@ -1575,6 +1626,8 @@ static const struct of_device_id mtk_star_of_match[] = {
>           .data = &mtk_star_mt8516_compat },
>         { .compatible = "mediatek,mt8175-eth",
>           .data = &mtk_star_mt8516_compat },
> +       { .compatible = "mediatek,mt8365-eth",
> +         .data = &mtk_star_mt8365_compat },
>         { }
>  };
>  MODULE_DEVICE_TABLE(of, mtk_star_of_match);
> --
> 2.25.1
>

Bart
