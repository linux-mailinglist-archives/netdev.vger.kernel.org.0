Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640163D6E7C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 07:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhG0F6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 01:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbhG0F57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 01:57:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A5DC0617B0
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 22:56:47 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m8G57-00061A-NF; Tue, 27 Jul 2021 07:56:45 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m8G56-00069i-OQ; Tue, 27 Jul 2021 07:56:44 +0200
Date:   Tue, 27 Jul 2021 07:56:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH v2 1/7] ethtool: Add 10base-T1L link mode entries
Message-ID: <20210727055644.yqwskkr4htcmwzem@pengutronix.de>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210712130631.38153-2-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:54:45 up 236 days, 20:01, 12 users,  load average: 0.17, 0.07,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 04:06:25PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add entries for the 10base-T1L full and half duplex supported modes.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/phy/phy-core.c   | 4 +++-
>  include/uapi/linux/ethtool.h | 2 ++
>  net/ethtool/common.c         | 2 ++
>  3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 2870c33b8975..fd9c83ce10fc 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -13,7 +13,7 @@
>   */
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 92,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 94,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");
> @@ -176,6 +176,8 @@ static const struct phy_setting settings[] = {
>  	/* 10M */
>  	PHY_SETTING(     10, FULL,     10baseT_Full		),
>  	PHY_SETTING(     10, HALF,     10baseT_Half		),
> +	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
> +	PHY_SETTING(     10, HALF,     10baseT1L_Half		),
>  };
>  #undef PHY_SETTING

IEEE 802.3cg-2019 do not define half duplex support for T1L, only for
T1S. IMO, 10baseT1L_Half can be dropped.


> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 67aa7134b301..8a905466d7dc 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1659,6 +1659,8 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
>  	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
>  	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
> +	ETHTOOL_LINK_MODE_10baseT1L_Half_BIT		 = 92,
> +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 93,
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
>  };
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index f9dcbad84788..5b93d888fd83 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -199,6 +199,8 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
>  	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
>  	__DEFINE_LINK_MODE_NAME(100, FX, Half),
>  	__DEFINE_LINK_MODE_NAME(100, FX, Full),
> +	__DEFINE_LINK_MODE_NAME(10, T1L, Half),
> +	__DEFINE_LINK_MODE_NAME(10, T1L, Full),
>  };
>  static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
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
