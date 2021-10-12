Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E677429E6A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhJLHRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhJLHRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:17:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2461BC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:15:36 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maC0Y-0002cS-52; Tue, 12 Oct 2021 09:15:30 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maC0X-0007vL-Hy; Tue, 12 Oct 2021 09:15:29 +0200
Date:   Tue, 12 Oct 2021 09:15:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v3 1/8] ethtool: Add 10base-T1L link mode entry
Message-ID: <20211012071529.GC938@pengutronix.de>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011142215.9013-2-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:15:08 up 236 days, 10:39, 125 users,  load average: 0.10, 0.17,
 0.24
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:22:08PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add entry for the 10base-T1L full duplex mode.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  drivers/net/phy/phy-core.c   | 3 ++-
>  include/uapi/linux/ethtool.h | 1 +
>  net/ethtool/common.c         | 3 +++
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 2870c33b8975..ed137c295a3d 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -13,7 +13,7 @@
>   */
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 93,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");
> @@ -176,6 +176,7 @@ static const struct phy_setting settings[] = {
>  	/* 10M */
>  	PHY_SETTING(     10, FULL,     10baseT_Full		),
>  	PHY_SETTING(     10, HALF,     10baseT_Half		),
> +	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
>  };
>  #undef PHY_SETTING
>  
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index b6db6590baf0..2cdbd55566d6 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1661,6 +1661,7 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
>  	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
>  	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
> +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 92,
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
>  };
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index c63e0739dc6a..cbc2393a121b 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -200,6 +200,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
>  	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
>  	__DEFINE_LINK_MODE_NAME(100, FX, Half),
>  	__DEFINE_LINK_MODE_NAME(100, FX, Full),
> +	__DEFINE_LINK_MODE_NAME(10, T1L, Full),
>  };
>  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> @@ -235,6 +236,7 @@ static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  #define __LINK_MODE_LANES_T1		1
>  #define __LINK_MODE_LANES_X		1
>  #define __LINK_MODE_LANES_FX		1
> +#define __LINK_MODE_LANES_T1L		1
>  
>  #define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex)	\
>  	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] = {		\
> @@ -348,6 +350,7 @@ const struct link_mode_info link_mode_params[] = {
>  	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
>  	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
>  	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10, T1L, Full),
>  };
>  static_assert(ARRAY_SIZE(link_mode_params) == __ETHTOOL_LINK_MODE_MASK_NBITS);
>  
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
