Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3904739BD0B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFDQ03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhFDQ03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 12:26:29 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB401C061766
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 09:24:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso6206015pji.0
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 09:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QclaApjKO3H5i5y16zFgcLjS/Mqx0stk/Q9/E1ZJjKY=;
        b=G/wbCyRBLCPaOkq6Lrx5YY+5IWExffp8AZkFy0JaGTJpI+ityo4WjM8dw06VhskFuN
         gid+uPRbyKIEwbnbLPit5sp6l+4s1bJIOf63Vj65wTAMFr9ly9niagug0+Y742TTi6kh
         vEpqcsd21l2Qv2KdAZBee67DQB2ASQPtwUgeu5Ev+/w3Uf6sVWnnAbDiCyCOHHW5OeqG
         g7AeXUb3m/I/J6KRuTIjf5j5o7UmqzJ/lWs+/1t41MGMtwZJQ5m4E+m57InZKBgP0iOI
         xIe6kRepjDZLclxD1+mXcptWa1tFCqSN++hU2Lhv2k8sUu/4YjFB2+aTcFZyaw295VlP
         f/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QclaApjKO3H5i5y16zFgcLjS/Mqx0stk/Q9/E1ZJjKY=;
        b=GTAZdQRNk6dF/BhUI5pffdHfyWDUr+f5PyqGjCjoJdETqiq5yppAy0ihMHdQTt2wkA
         ea7NGbWxSLLyS4vrdt0ZwJtyzEVyyv3HJBmp75ZFlSUqqeRJT86eIIUUnvK3ybH6+hyu
         NYADwV/nlshbBywbcPnaX9BqHp/QbZUmO4LNt8yQxp/j4fLA5bEVnzygEtVzMlOitlul
         +Vu9lFyzPgROHlk8Jy3SKB5O5+NRpyAAVf9oLLB7OnP6MpI7ZNwj1vf4e/CB/SvuIckw
         JzI85m0LbvFTb4711rCRiSmhRocmshi8OPgtTsx75gDVaBQyhxcyew2z/dJpacv0ItlO
         NfVQ==
X-Gm-Message-State: AOAM532AQUYKhzq+qrIcw9cGab3EjKlSHxndWu3zg1cZpJywchXmCDIs
        YdVOO4+Wh//wy+ZnUglhSOLuniH8vQSj8g==
X-Google-Smtp-Source: ABdhPJyeIIICfLIDW+NPPWEETJ0kTX8Ciafh26GuvC19XwSyCQrTlIMsd/UzVv21Df9pPZryRQuo7Q==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr5030563plk.62.1622823868084;
        Fri, 04 Jun 2021 09:24:28 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p11sm5281069pjo.19.2021.06.04.09.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:24:27 -0700 (PDT)
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
To:     Xu Liang <lxu@maxlinear.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        vee.khee.wong@linux.intel.com
Cc:     linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com
References: <20210604161250.49749-1-lxu@maxlinear.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
Date:   Fri, 4 Jun 2021 09:24:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604161250.49749-1-lxu@maxlinear.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2021 9:12 AM, Xu Liang wrote:
> Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> GPY241, GPY245 PHYs.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>
> ---
> v2 changes:
>  Fix format warning from checkpath and some comments.
>  Use smaller PHY ID mask.
>  Split FWV register mask.
>  Call phy_trigger_machine if necessary when clear interrupt.
> v3 changes:
>  Replace unnecessary phy_modify_mmd_changed with phy_modify_mmd
>  Move firmware version print to probe.
> 
>  MAINTAINERS               |   6 +
>  drivers/net/phy/Kconfig   |   6 +
>  drivers/net/phy/Makefile  |   1 +
>  drivers/net/phy/mxl-gpy.c | 552 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 565 insertions(+)
>  create mode 100644 drivers/net/phy/mxl-gpy.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 948706174fae..140b19d038fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11168,6 +11168,12 @@ W:	https://linuxtv.org
>  T:	git git://linuxtv.org/media_tree.git
>  F:	drivers/media/radio/radio-maxiradio*
>  
> +MAXLINEAR ETHERNET PHY DRIVER
> +M:	Xu Liang <lxu@maxlinear.com>
> +L:	netdev@vger.kernel.org
> +S:	Supported
> +F:	drivers/net/phy/mxl-gpy.c
> +
>  MCAN MMIO DEVICE DRIVER
>  M:	Chandrasekar Ramakrishnan <rcsekar@samsung.com>
>  L:	linux-can@vger.kernel.org
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 288bf405ebdb..d02098774d80 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -207,6 +207,12 @@ config MARVELL_88X2222_PHY
>  	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
>  	  Transceiver.
>  
> +config MXL_GPHY
> +	tristate "Maxlinear PHYs"
> +	help
> +	  Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
> +	  GPY241, GPY245 PHYs.
> +
>  config MICREL_PHY
>  	tristate "Micrel PHYs"
>  	help
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index bcda7ed2455d..1055fb73ac17 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY)	+= micrel.o
>  obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
>  obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
>  obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
> +obj-$(CONFIG_MXL_GPHY)		+= mxl-gpy.o

Could you spell it out completely: CONFIG_MAXLINEAR_GPHY for consistency
with the other vendor's and also to have some proper namespacing in case
we see a non-Ethernet PHY being submitted for a Maxlinear product in the
future?

>  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
>  obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
>  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
> new file mode 100644
> index 000000000000..3e3d3096e858
> --- /dev/null
> +++ b/drivers/net/phy/mxl-gpy.c
> @@ -0,0 +1,552 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Copyright (C) 2021 Maxlinear Corporation
> + * Copyright (C) 2020 Intel Corporation
> + *
> + * Drivers for Maxlinear Ethernet GPY
> + *
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/bitfield.h>
> +#include <linux/phy.h>
> +#include <linux/netdevice.h>
> +
> +/* PHY ID */
> +#define PHY_ID_GPY		0x67C9DC00
> +#define PHY_ID_MASK		GENMASK(31, 4)

Consider initializing your phy_driver with PHY_ID_MATCH_MODEL() which
would take care of populating the mask accordingly.

[snip]

> +
> +static int gpy_read_abilities(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_read_abilities(phydev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Detect 2.5G/5G support. */
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT2);
> +	if (ret < 0)
> +		return ret;
> +	if (!(ret & MDIO_PMA_STAT2_EXTABLE))
> +		return 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> +	if (ret < 0)
> +		return ret;
> +	if (!(ret & MDIO_PMA_EXTABLE_NBT))
> +		return 0;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> +	if (ret < 0)
> +		return ret;
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
> +			 phydev->supported,
> +			 ret & MDIO_PMA_NG_EXTABLE_2_5GBT);
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
> +			 phydev->supported,
> +			 ret & MDIO_PMA_NG_EXTABLE_5GBT);

This does not access vendor specific registers, should not this be part
of the standard genphy_read_abilities() or moved to a helper?

> +
> +	return 0;
> +}
> +
> +static int gpy_config_init(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Mask all interrupts */
> +	ret = phy_write(phydev, PHY_IMASK, 0);
> +	if (ret)
> +		return ret;
> +
> +	/* Clear all pending interrupts */
> +	ret = phy_read(phydev, PHY_ISTAT);
> +	return ret < 0 ? ret : 0;

You can certainly simplify this to:

	return phy_read(phydev, PHY_ISTAT);

[snip]

> +
> +MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
> +MODULE_AUTHOR("Maxlinear Corporation");

The author is not usually a company but an individual working on behalf
of that company.
-- 
Florian
