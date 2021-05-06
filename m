Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9D375312
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhEFLeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbhEFLe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:34:29 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BAAC061574;
        Thu,  6 May 2021 04:33:29 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z6so5238143wrm.4;
        Thu, 06 May 2021 04:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u+7qdlluiqhLlsnV3gq9b/KX/0q/cP8G/iZNlQREXZE=;
        b=rUSjyB7C+t0snsq+9mLu7cnZ3YSX+XpYSLlPoTYk9tqUjMRIBGuz0zGz2bD2HsiEy8
         NhQpfeuhVg9QiTijfHfihy6SUZRhlnW0D5jHun3TK1RRi78W0xkpiGbyVUBkZQreZdX4
         OZ967E7r//pw2Yl4ZwPzgateP5SeijEyHTAQdlTntCxjdyupgqDVUMlGbaCSfVqnB1V/
         bcAE3G5Brz/ZS8yPjw1bfo7bOekK8wD6DFEl2pfrxGYRAyIyaTqyBl5zSryQheTu2xHc
         CHeCl7SvrLVUzqhDp5Oksu46M0otP8mGg2UcI9taw3RzV5iuBd4Mn0hzEI2dk7YaVx3t
         cHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u+7qdlluiqhLlsnV3gq9b/KX/0q/cP8G/iZNlQREXZE=;
        b=bNqScEVjl40+nYnmFCRtOPIPU6yoo/9AFRQeXgYoRf8pY7zdYkjgQmnd6b94CfRPAx
         I9ntBFt97p0CcYDCXUl+jacooNe1zxyfpyjTusPXmO6ItXHQq18PSieabvnTkTOztZl2
         vu56E/yIeQJ+FBNGoz/v38nKl9Iu3HFiczZSLRRQNxbSwUyYw3lSQJs40KHlZyYDCCvJ
         wmhbN1CGJpXaPhkv3txzR1FJkYKjTYvGmpq6RF2/9VZPzT6vlXveJKrgC+7vbCso43Hw
         a3O+4ZtO8hnuPlbGwy2ByJf8ZAHDlNTIMiooMxbwQ4E6uPaKZL+UulyvSxIGIQZnBkDk
         nWBg==
X-Gm-Message-State: AOAM532rjN0ei9r/GBx+Q+V81VG/D+G32+cwP50Shx0TgUVPzIMV+Z+F
        NAzeampXIVDp0ztbvhSfuWY=
X-Google-Smtp-Source: ABdhPJwpbeHUdYneO0nNVFCeAH3zv1T+v19f4HhDDmSVCIyFhho0+q+jLy0AD7oP/7H7BxWpo8hksQ==
X-Received: by 2002:adf:fa4c:: with SMTP id y12mr4506051wrr.393.1620300808495;
        Thu, 06 May 2021 04:33:28 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id f8sm3078987wmc.8.2021.05.06.04.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:33:28 -0700 (PDT)
Date:   Thu, 6 May 2021 14:33:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH net-next 1/4] net: phy: add MediaTek PHY driver
Message-ID: <20210506113325.b7kwybdgxkoj7rqp@skbuf>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429062130.29403-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429062130.29403-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 02:21:27PM +0800, DENG Qingfang wrote:
> Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
> The initialization procedure is from the vendor driver, but due to lack
> of documentation, the function of some register values remains unknown.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC v4 -> PATCH v1:
> - No changes.
> 
>  drivers/net/phy/Kconfig    |   5 ++
>  drivers/net/phy/Makefile   |   1 +
>  drivers/net/phy/mediatek.c | 112 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 118 insertions(+)
>  create mode 100644 drivers/net/phy/mediatek.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 288bf405ebdb..9db39fb443e6 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
>  	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
>  	  Transceiver.
>  
> +config MEDIATEK_PHY
> +	tristate "MediaTek PHYs"
> +	help
> +	  Supports the MediaTek switch integrated PHYs.
> +
>  config MICREL_PHY
>  	tristate "Micrel PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index bcda7ed2455d..ab512cb3592b 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -64,6 +64,7 @@ obj-$(CONFIG_LXT_PHY)		+= lxt.o
>  obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
>  obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
>  obj-$(CONFIG_MARVELL_88X2222_PHY)	+= marvell-88x2222.o
> +obj-$(CONFIG_MEDIATEK_PHY)	+= mediatek.o
>  obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
>  obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
>  obj-$(CONFIG_MICREL_PHY)	+= micrel.o
> diff --git a/drivers/net/phy/mediatek.c b/drivers/net/phy/mediatek.c
> new file mode 100644
> index 000000000000..86e6c466b0e9
> --- /dev/null
> +++ b/drivers/net/phy/mediatek.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +#include <linux/bitfield.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +
> +#define MTK_EXT_PAGE_ACCESS		0x1f
> +#define MTK_PHY_PAGE_STANDARD		0x0000
> +#define MTK_PHY_PAGE_EXTENDED		0x0001
> +#define MTK_PHY_PAGE_EXTENDED_2		0x0002
> +#define MTK_PHY_PAGE_EXTENDED_3		0x0003
> +#define MTK_PHY_PAGE_EXTENDED_2A30	0x2a30
> +#define MTK_PHY_PAGE_EXTENDED_52B5	0x52b5
> +
> +static int mtk_phy_read_page(struct phy_device *phydev)
> +{
> +	return __phy_read(phydev, MTK_EXT_PAGE_ACCESS);
> +}
> +
> +static int mtk_phy_write_page(struct phy_device *phydev, int page)
> +{
> +	return __phy_write(phydev, MTK_EXT_PAGE_ACCESS, page);
> +}
> +
> +static void mtk_phy_config_init(struct phy_device *phydev)
> +{
> +	/* Disable EEE */
> +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);

Is there any ERR around this (i.e. is the feature universally broken or
just on your setup)? There is a function called of_set_phy_eee_broken,
you can let the PHY core disable EEE advertisement based on device tree.

> +
> +	/* Enable HW auto downshift */
> +	phy_modify_paged(phydev, MTK_PHY_PAGE_EXTENDED, 0x14, 0, BIT(4));
> +
> +	/* Increase SlvDPSready time */
> +	phy_select_page(phydev, MTK_PHY_PAGE_EXTENDED_52B5);
> +	__phy_write(phydev, 0x10, 0xafae);
> +	__phy_write(phydev, 0x12, 0x2f);
> +	__phy_write(phydev, 0x10, 0x8fae);
> +	phy_restore_page(phydev, MTK_PHY_PAGE_STANDARD, 0);
> +
> +	/* Adjust 100_mse_threshold */
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x123, 0xffff);
> +
> +	/* Disable mcc */
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0xa6, 0x300);
> +}
