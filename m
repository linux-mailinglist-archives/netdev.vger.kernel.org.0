Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A382F28DC33
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgJNI7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727731AbgJNI7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:59:37 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975F8C045858;
        Tue, 13 Oct 2020 22:24:05 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b69so1792944qkg.8;
        Tue, 13 Oct 2020 22:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTyZGQt5KuUq5z9rLb8JACAK351D3dXLreYGG/tKXVU=;
        b=diIpUdpOtSV4sSvCBvKNWhs7ZVOX7jK4RnfEdeWAsCYaUrVPDszwPH83pDq7dic93M
         yZTvemAoQO0OeJ4cCOCzW9b9XnJWVTXMTzXR6syLi296zlxl5d5ISSHGiOH3LAq/e0wE
         A6tRFAlghW5ORpDgkkLGe73lZF3OEvkz6+OzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTyZGQt5KuUq5z9rLb8JACAK351D3dXLreYGG/tKXVU=;
        b=QYF4aOXAq68706/NfF6eke7i7P9HUAUIv00n3GAg6I7saXu+yBX3Ij9bf2bFs5D4qo
         SZtf5UOX9GBcM6OV6x6CnLiCWLt7VQmJ7FAeIY8rBZ1xKsOMT1f6TnbnNlI8NNeFoPNH
         ZwmDNpi/2zyw2G/CsrJ0CEVcv18l77bGP6lGlFE+DPcX0oOXKXFHB3asgyY0F8kb24GE
         EyrqxpAWSgf9M/G8jMtsa+b4bcEhhCXInpwfAEuBs5PHsxLT4Osd+8hM4VIZRT0+llRm
         8v50zLWF8pIRmgTmkVHlHXebxV3PUYsuUAoFHH1gfECzuoo5CH+O+0j3buo94KvWbJWe
         TQKQ==
X-Gm-Message-State: AOAM532CV+oIsVsKlJ2u6FVrPWnQbMeKwY0dFf18Gc4wiaKLhMw8l7a7
        w0GkMl3HM8opdIgztd57l18Gw4vSgtvAXdFOIYM=
X-Google-Smtp-Source: ABdhPJysj5Reu8MnR7DVpnqtn6pSEkgSjtKEx/emy7+JdxFCEd4IAp6Iy3iA6zABlbBgCs7XqY/4pg0ZdaFQnK8vO7M=
X-Received: by 2002:a37:4a4d:: with SMTP id x74mr3469230qka.55.1602653044494;
 Tue, 13 Oct 2020 22:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201013124014.2989-1-i.mikhaylov@yadro.com> <20201013124014.2989-2-i.mikhaylov@yadro.com>
In-Reply-To: <20201013124014.2989-2-i.mikhaylov@yadro.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 14 Oct 2020 05:23:52 +0000
Message-ID: <CACPK8Xd_gCVjVm13O85+mnZ4VbhQorG4qiy+mVevrvyCbPg9XQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: ftgmac100: add handling of mdio/phy nodes for ast2400/2500
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        netdev@vger.kernel.org,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan,

On Tue, 13 Oct 2020 at 12:38, Ivan Mikhaylov <i.mikhaylov@yadro.com> wrote:
>
> phy-handle can't be handled well for ast2400/2500 which has an embedded
> MDIO controller. Add ftgmac100_mdio_setup for ast2400/2500 and initialize
> PHYs from mdio child node with of_mdiobus_register.

Good idea. The driver has become a mess of different ways to connect
the phy and it needs to be cleaned up. I have a patch that fixes
rmmod, which is currently broken.



>
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 114 ++++++++++++++---------
>  1 file changed, 69 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 87236206366f..e32066519ec1 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1044,11 +1044,47 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
>         schedule_work(&priv->reset_task);
>  }
>
> -static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
> +static int ftgmac100_mii_probe(struct net_device *netdev)
>  {
> -       struct net_device *netdev = priv->netdev;
> +       struct ftgmac100 *priv = netdev_priv(netdev);
> +       struct platform_device *pdev = to_platform_device(priv->dev);
> +       struct device_node *np = pdev->dev.of_node;
> +       phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
>         struct phy_device *phydev;
>
> +       /* Get PHY mode from device-tree */
> +       if (np) {
> +               /* Default to RGMII. It's a gigabit part after all */
> +               phy_intf = of_get_phy_mode(np, &phy_intf);
> +               if (phy_intf < 0)
> +                       phy_intf = PHY_INTERFACE_MODE_RGMII;
> +
> +               /* Aspeed only supports these. I don't know about other IP
> +                * block vendors so I'm going to just let them through for
> +                * now. Note that this is only a warning if for some obscure
> +                * reason the DT really means to lie about it or it's a newer
> +                * part we don't know about.
> +                *
> +                * On the Aspeed SoC there are additionally straps and SCU
> +                * control bits that could tell us what the interface is
> +                * (or allow us to configure it while the IP block is held
> +                * in reset). For now I chose to keep this driver away from
> +                * those SoC specific bits and assume the device-tree is
> +                * right and the SCU has been configured properly by pinmux
> +                * or the firmware.
> +                */
> +               if (priv->is_aspeed &&
> +                   phy_intf != PHY_INTERFACE_MODE_RMII &&
> +                   phy_intf != PHY_INTERFACE_MODE_RGMII &&
> +                   phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> +                   phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> +                   phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
> +                       netdev_warn(netdev,
> +                                   "Unsupported PHY mode %s !\n",
> +                                   phy_modes(phy_intf));
> +               }

Why do we move this?

> +       }
> +
>         phydev = phy_find_first(priv->mii_bus);
>         if (!phydev) {
>                 netdev_info(netdev, "%s: no PHY found\n", netdev->name);
> @@ -1056,7 +1092,7 @@ static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
>         }
>
>         phydev = phy_connect(netdev, phydev_name(phydev),
> -                            &ftgmac100_adjust_link, intf);
> +                            &ftgmac100_adjust_link, phy_intf);
>
>         if (IS_ERR(phydev)) {
>                 netdev_err(netdev, "%s: Could not attach to PHY\n", netdev->name);
> @@ -1601,8 +1637,8 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
>  {
>         struct ftgmac100 *priv = netdev_priv(netdev);
>         struct platform_device *pdev = to_platform_device(priv->dev);
> -       phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
>         struct device_node *np = pdev->dev.of_node;
> +       struct device_node *mdio_np;
>         int i, err = 0;
>         u32 reg;
>
> @@ -1623,39 +1659,6 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
>                 iowrite32(reg, priv->base + FTGMAC100_OFFSET_REVR);
>         }
>
> -       /* Get PHY mode from device-tree */
> -       if (np) {
> -               /* Default to RGMII. It's a gigabit part after all */
> -               err = of_get_phy_mode(np, &phy_intf);
> -               if (err)
> -                       phy_intf = PHY_INTERFACE_MODE_RGMII;
> -
> -               /* Aspeed only supports these. I don't know about other IP
> -                * block vendors so I'm going to just let them through for
> -                * now. Note that this is only a warning if for some obscure
> -                * reason the DT really means to lie about it or it's a newer
> -                * part we don't know about.
> -                *
> -                * On the Aspeed SoC there are additionally straps and SCU
> -                * control bits that could tell us what the interface is
> -                * (or allow us to configure it while the IP block is held
> -                * in reset). For now I chose to keep this driver away from
> -                * those SoC specific bits and assume the device-tree is
> -                * right and the SCU has been configured properly by pinmux
> -                * or the firmware.
> -                */
> -               if (priv->is_aspeed &&
> -                   phy_intf != PHY_INTERFACE_MODE_RMII &&
> -                   phy_intf != PHY_INTERFACE_MODE_RGMII &&
> -                   phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> -                   phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> -                   phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
> -                       netdev_warn(netdev,
> -                                  "Unsupported PHY mode %s !\n",
> -                                  phy_modes(phy_intf));
> -               }
> -       }
> -
>         priv->mii_bus->name = "ftgmac100_mdio";
>         snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%d",
>                  pdev->name, pdev->id);
> @@ -1667,22 +1670,22 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
>         for (i = 0; i < PHY_MAX_ADDR; i++)
>                 priv->mii_bus->irq[i] = PHY_POLL;
>
> -       err = mdiobus_register(priv->mii_bus);
> +       mdio_np = of_get_child_by_name(np, "mdio");
> +       if (mdio_np)
> +               err = of_mdiobus_register(priv->mii_bus, mdio_np);
> +       else
> +               err = mdiobus_register(priv->mii_bus);
> +
>         if (err) {
>                 dev_err(priv->dev, "Cannot register MDIO bus!\n");
>                 goto err_register_mdiobus;
>         }
>
> -       err = ftgmac100_mii_probe(priv, phy_intf);
> -       if (err) {
> -               dev_err(priv->dev, "MII Probe failed!\n");
> -               goto err_mii_probe;
> -       }
> +       if (mdio_np)
> +               of_node_put(mdio_np);

By the time I get down here I'm lost. Do you think you could split the
change up into a few smaller patches?

If not, try to explain what the various hunks of your change are trying to do.

Cheers,

Joel

>
>         return 0;
>
> -err_mii_probe:
> -       mdiobus_unregister(priv->mii_bus);
>  err_register_mdiobus:
>         mdiobus_free(priv->mii_bus);
>         return err;
> @@ -1836,10 +1839,23 @@ static int ftgmac100_probe(struct platform_device *pdev)
>         } else if (np && of_get_property(np, "phy-handle", NULL)) {
>                 struct phy_device *phy;
>
> +               /* Support "mdio"/"phy" child nodes for ast2400/2500 with
> +                * an embedded MDIO controller. Automatically scan the DTS for
> +                * available PHYs and register them.
> +                */
> +               if (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
> +                   of_device_is_compatible(np, "aspeed,ast2500-mac")) {
> +                       err = ftgmac100_setup_mdio(netdev);
> +                       if (err)
> +                               goto err_setup_mdio;
> +               }
> +
>                 phy = of_phy_get_and_connect(priv->netdev, np,
>                                              &ftgmac100_adjust_link);
>                 if (!phy) {
>                         dev_err(&pdev->dev, "Failed to connect to phy\n");
> +                       if (priv->mii_bus)
> +                               mdiobus_unregister(priv->mii_bus);
>                         goto err_setup_mdio;
>                 }
>
> @@ -1860,6 +1876,14 @@ static int ftgmac100_probe(struct platform_device *pdev)
>                 err = ftgmac100_setup_mdio(netdev);
>                 if (err)
>                         goto err_setup_mdio;
> +
> +               err = ftgmac100_mii_probe(netdev);
> +               if (err) {
> +                       dev_err(priv->dev, "MII probe failed!\n");
> +                       mdiobus_unregister(priv->mii_bus);
> +                       goto err_setup_mdio;
> +               }
> +
>         }
>
>         if (priv->is_aspeed) {
> --
> 2.21.1
>
