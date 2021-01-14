Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A112F5FB2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbhANLT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:19:27 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:53478 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbhANLT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:19:26 -0500
Received: from relay7-d.mail.gandi.net (unknown [217.70.183.200])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id B372B3BB556;
        Thu, 14 Jan 2021 11:03:58 +0000 (UTC)
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 07984200D9;
        Thu, 14 Jan 2021 11:02:33 +0000 (UTC)
Date:   Thu, 14 Jan 2021 12:02:33 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
Message-ID: <20210114110233.GZ3654@piout.net>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
 <20210107091924.1569575-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107091924.1569575-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01/2021 10:19:22+0100, Steen Hegelund wrote:
> Provide a new ethernet phy configuration structure, that
> allow PHYs used for ethernet to be configured with
> speed, media type and clock information.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  include/linux/phy/phy-ethernet-serdes.h | 30 +++++++++++++++++++++++++
>  include/linux/phy/phy.h                 |  4 ++++
>  2 files changed, 34 insertions(+)
>  create mode 100644 include/linux/phy/phy-ethernet-serdes.h
> 
> diff --git a/include/linux/phy/phy-ethernet-serdes.h b/include/linux/phy/phy-ethernet-serdes.h
> new file mode 100644
> index 000000000000..d2462fadf179
> --- /dev/null
> +++ b/include/linux/phy/phy-ethernet-serdes.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * Microchip Sparx5 Ethernet SerDes driver
> + *
> + * Copyright (c) 2020 Microschip Inc
> + */
> +#ifndef __PHY_ETHERNET_SERDES_H_
> +#define __PHY_ETHERNET_SERDES_H_
> +
> +#include <linux/types.h>
> +
> +enum ethernet_media_type {
> +	ETH_MEDIA_DEFAULT,
> +	ETH_MEDIA_SR,
> +	ETH_MEDIA_DAC,
> +};
> +
> +/**
> + * struct phy_configure_opts_eth_serdes - Ethernet SerDes This structure is used
> + * to represent the configuration state of a Ethernet Serdes PHY.
> + * @speed: Speed of the serdes interface in Mbps
> + * @media_type: Specifies which media the serdes will be using
> + */
> +struct phy_configure_opts_eth_serdes {
> +	u32                        speed;
> +	enum ethernet_media_type   media_type;
> +};
> +
> +#endif
> +
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index e435bdb0bab3..78ecb375cede 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -18,6 +18,7 @@
>  
>  #include <linux/phy/phy-dp.h>
>  #include <linux/phy/phy-mipi-dphy.h>
> +#include <linux/phy/phy-ethernet-serdes.h>
>  
>  struct phy;
>  
> @@ -49,11 +50,14 @@ enum phy_mode {
>   *
>   * @mipi_dphy:	Configuration set applicable for phys supporting
>   *		the MIPI_DPHY phy mode.
> + * @eth_serdes: Configuration set applicable for phys supporting
> + *		the ethernet serdes.
>   * @dp:		Configuration set applicable for phys supporting
>   *		the DisplayPort protocol.
>   */
>  union phy_configure_opts {
>  	struct phy_configure_opts_mipi_dphy	mipi_dphy;
> +	struct phy_configure_opts_eth_serdes	eth_serdes;
>  	struct phy_configure_opts_dp		dp;
>  };
>  
> -- 
> 2.29.2
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
