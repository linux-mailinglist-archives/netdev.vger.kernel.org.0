Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6086E709B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 03:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjDSBF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 21:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjDSBF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 21:05:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D1046BB;
        Tue, 18 Apr 2023 18:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Q8o0qgq8+xO90jhfN2O1+TkcR9RHUp7q+rece25IGKQ=; b=vzFjDspCtyNwSp7WO7eWEWRXzm
        clxr4eASwMedDPBHy56+ZhGtab9hLd5EHBqsJo8MpEgTMA6ZJK04ITfC/408psYHNM3QU7dbEHoAU
        XtIsAasnSEBRcnyJJ8vhRdz0sPC0s0lPQ8BrgSUE4QNM3dZ6FqUFu/xgbMPE9KxofPHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1powGA-00AeZi-LD; Wed, 19 Apr 2023 03:05:22 +0200
Date:   Wed, 19 Apr 2023 03:05:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: Re: [PATCH net-next 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <66b0064e-48ec-429e-91bf-77e4c0009291@lunn.ch>
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-4-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1681863018-28006-4-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 05:10:15PM -0700, Justin Chen wrote:
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165. This controller features two distinct Ethernet
> ports that can be independently operated.
> 
> This patch supports:
> 
> - Wake-on-LAN using magic packets
> - basic ethtool operations (link, counters, message level)
> - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Hi Justin

Since you are submitting this, your Signed-off-by: needs to be last
here.


> ---
>  drivers/net/ethernet/broadcom/Kconfig              |   11 +
>  drivers/net/ethernet/broadcom/Makefile             |    1 +
>  drivers/net/ethernet/broadcom/asp2/Makefile        |    2 +
>  drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 1527 ++++++++++++++++++++
>  drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  636 ++++++++
>  .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  620 ++++++++
>  drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   | 1425 ++++++++++++++++++
>  .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |  238 +++
>  8 files changed, 4460 insertions(+)
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/Makefile
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.c
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.h
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
>  create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h
> 
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index 948586bf1b5b..d4166141145d 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -255,4 +255,15 @@ config BNXT_HWMON
>  	  Say Y if you want to expose the thermal sensor data on NetXtreme-C/E
>  	  devices, via the hwmon sysfs interface.
>  
> +config BCMASP
> +	tristate "Broadcom ASP 2.0 Ethernet support"
> +	default ARCH_BRCMSTB
> +	depends on OF
> +	select MII
> +	select PHYLIB
> +	select MDIO_BCM_UNIMAC
> +	help
> +	  This configuration enables the Broadcom ASP 2.0 Ethernet controller
> +	  driver which is present in Broadcom STB SoCs such as 72165.
> +
>  endif # NET_VENDOR_BROADCOM
> diff --git a/drivers/net/ethernet/broadcom/Makefile b/drivers/net/ethernet/broadcom/Makefile
> index 0ddfb5b5d53c..bac5cb6ad0cd 100644
> --- a/drivers/net/ethernet/broadcom/Makefile
> +++ b/drivers/net/ethernet/broadcom/Makefile
> @@ -17,3 +17,4 @@ obj-$(CONFIG_BGMAC_BCMA) += bgmac-bcma.o bgmac-bcma-mdio.o
>  obj-$(CONFIG_BGMAC_PLATFORM) += bgmac-platform.o
>  obj-$(CONFIG_SYSTEMPORT) += bcmsysport.o
>  obj-$(CONFIG_BNXT) += bnxt/
> +obj-$(CONFIG_BCMASP) += asp2/
> diff --git a/drivers/net/ethernet/broadcom/asp2/Makefile b/drivers/net/ethernet/broadcom/asp2/Makefile
> new file mode 100644
> index 000000000000..e07550315f83
> --- /dev/null
> +++ b/drivers/net/ethernet/broadcom/asp2/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_BCMASP) += bcm-asp.o
> +bcm-asp-objs := bcmasp.o bcmasp_intf.o bcmasp_ethtool.o
> diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
> new file mode 100644
> index 000000000000..9cf5f4d6dd0d
> --- /dev/null
> +++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
> @@ -0,0 +1,1527 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Broadcom STB ASP 2.0 Driver
> + *
> + * Copyright (c) 2020 Broadcom
> + */
> +#include <linux/etherdevice.h>
> +#include <linux/if_vlan.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk.h>
> +
> +#include "bcmasp.h"
> +#include "bcmasp_intf_defs.h"
> +
> +static inline void _intr2_mask_clear(struct bcmasp_priv *priv, u32 mask)
> +{
> +	intr2_core_wl(priv, mask, ASP_INTR2_MASK_CLEAR);
> +	priv->irq_mask &= ~mask;
> +}

No inline functions in .c files. Let the compiler decide.

> +static inline void bcmasp_intr2_handling(struct bcmasp_intf *intf, u32 status)
> +{
> +	if (unlikely(!intf))
> +		return;

Can it even happen? An interrupt from an interface which does not
exist?

> +static void bcmasp_set_mda_filter(struct bcmasp_intf *intf,
> +				  const unsigned char *addr,
> +				  unsigned char *mask,
> +				  unsigned int i)
> +{
> +	struct bcmasp_priv *priv = intf->parent;
> +	u32 addr_h, addr_l, mask_h, mask_l;
> +
> +	/* Set local copy */
> +	memcpy(priv->mda_filters[i].mask, mask, ETH_ALEN);
> +	memcpy(priv->mda_filters[i].addr, addr, ETH_ALEN);

eth_addr_copy() ?

> +static inline void u64_to_mac(unsigned char *addr, u64 val)
> +{
> +	addr[0] = (u8)(val >> 40);
> +	addr[1] = (u8)(val >> 32);
> +	addr[2] = (u8)(val >> 24);
> +	addr[3] = (u8)(val >> 16);
> +	addr[4] = (u8)(val >> 8);
> +	addr[5] = (u8)val;
> +}

u64_to_ether_addr() ?

> +
> +#define mac_to_u64(a)		((((u64)a[0]) << 40) | \
> +				(((u64)a[1]) << 32) | \
> +				(((u64)a[2]) << 24) | \
> +				(((u64)a[3]) << 16) | \
> +				(((u64)a[4]) << 8) | \
> +				((u64)a[5]))
> +

ether_addr_to_u64()

You might want to read that include file and see if there is anything
else you can replace.

> +static int bcmasp_probe(struct platform_device *pdev)
> +{
> +	struct bcmasp_priv *priv;
> +	struct device_node *ports_node, *intf_node;
> +	struct device *dev = &pdev->dev;
> +	const struct bcmasp_plat_data *pdata;
> +	int ret, i, count = 0, port;
> +	struct bcmasp_intf *intf;

Reverse christmass tree.

> +	priv->clk = devm_clk_get(dev, "sw_asp");
> +	if (IS_ERR(priv->clk)) {
> +		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +		dev_warn(dev, "failed to request clock\n");
> +		priv->clk = NULL;
> +	}

Maybe devm_clk_get_optional() ??

> +
> +	/* Base from parent node */
> +	priv->base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(priv->base)) {
> +		dev_err(dev, "failed to iomap\n");
> +		return PTR_ERR(priv->base);
> +	}
> +
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
> +	if (ret)
> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to set DMA mask: %d\n", ret);
> +		return ret;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, priv);
> +	priv->pdev = pdev;
> +	spin_lock_init(&priv->mda_lock);
> +	spin_lock_init(&priv->clk_lock);
> +	mutex_init(&priv->net_lock);
> +	mutex_init(&priv->wol_lock);
> +
> +	pdata = device_get_match_data(&pdev->dev);
> +	if (pdata) {
> +		priv->init_wol = pdata->init_wol;
> +		priv->enable_wol = pdata->enable_wol;
> +		priv->destroy_wol = pdata->destroy_wol;
> +		priv->hw_info = pdata->hw_info;
> +	} else {
> +		dev_err(&pdev->dev, "unable to find platform data\n");
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(priv->clk);
> +	if (ret)
> +		return ret;

I think there is also a devm_clk_get_enable_optional().

> +static void bcmasp_get_drvinfo(struct net_device *dev,
> +			       struct ethtool_drvinfo *info)
> +{
> +	strscpy(info->driver, "bcmasp", sizeof(info->driver));
> +	strscpy(info->version, "v2.0", sizeof(info->version));

Don't fill in the version, it is useless. The core will insert the git
hash which has more value.

> +	strscpy(info->bus_info, dev_name(dev->dev.parent),
> +		sizeof(info->bus_info));
> +}
> +
> +static int bcmasp_get_link_ksettings(struct net_device *dev,
> +				     struct ethtool_link_ksettings *cmd)
> +{
> +	if (!netif_running(dev))
> +		return -EINVAL;
> +
> +	if (!dev->phydev)
> +		return -ENODEV;

I skipped the PHY handling section. Is it possible to not have a PHY?
Normally you have a fixed-link if their is not a real PHY.

There is also phy_ethtool_set_link_ksettings()

> +static int bcmasp_nway_reset(struct net_device *dev)
> +{
> +	if (!dev->phydev)
> +		return -ENODEV;
> +
> +	return genphy_restart_aneg(dev->phydev);

phy_ethtool_nway_reset().

I get the feeling this code was written against an old kernel version,
and has not been updated to use all the new helpers.

	Andrew
