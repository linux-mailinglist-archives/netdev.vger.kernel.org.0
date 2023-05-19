Return-Path: <netdev+bounces-3826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2172C709029
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9C871C2122F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257D97F9;
	Fri, 19 May 2023 07:11:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BC17F3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:11:57 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB09E7F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 00:11:54 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzuHI-0007Pp-Rh; Fri, 19 May 2023 09:11:52 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzuHH-00045a-1T; Fri, 19 May 2023 09:11:51 +0200
Date: Fri, 19 May 2023 09:11:51 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 09/24] net: stmmac: Simplify ethtool get eee
Message-ID: <20230519071151.GB8586@pengutronix.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-10-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331005518.2134652-10-andrew@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Mar 31, 2023 at 02:55:03AM +0200, Andrew Lunn wrote:
> phylink_ethtool_get_eee() fills in eee_enabled, eee_active and
> tx_lpi_enabled.  So there is no need for the MAC driver to do it as
> well.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Complete patch set is tested on stmmac interface of Polyhex Debix Model A
i.MX8MPlus board.

The only thing that's changed from before is that we're not advertising
EEE as a default anymore.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h         | 1 -
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 7 -------
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    | 2 --
>  3 files changed, 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index 3d15e1e92e18..a0f6e58fc622 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -253,7 +253,6 @@ struct stmmac_priv {
>  	int eee_enabled;
>  	int eee_active;
>  	int tx_lpi_timer;
> -	int tx_lpi_enabled;
>  	int eee_tw_timer;
>  	bool eee_sw_timer_en;
>  	unsigned int mode;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index 35c8dd92d369..fd97cdbb6797 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -782,10 +782,7 @@ static int stmmac_ethtool_op_get_eee(struct net_device *dev,
>  	if (!priv->dma_cap.eee)
>  		return -EOPNOTSUPP;
>  
> -	edata->eee_enabled = priv->eee_enabled;
> -	edata->eee_active = priv->eee_active;
>  	edata->tx_lpi_timer = priv->tx_lpi_timer;
> -	edata->tx_lpi_enabled = priv->tx_lpi_enabled;
>  
>  	return phylink_ethtool_get_eee(priv->phylink, edata);
>  }
> @@ -799,10 +796,6 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
>  	if (!priv->dma_cap.eee)
>  		return -EOPNOTSUPP;
>  
> -	if (priv->tx_lpi_enabled != edata->tx_lpi_enabled)
> -		netdev_warn(priv->dev,
> -			    "Setting EEE tx-lpi is not supported\n");
> -
>  	if (!edata->eee_enabled)
>  		stmmac_disable_eee_mode(priv);
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index dd2488998993..190b74d7f4e7 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -971,7 +971,6 @@ static void stmmac_mac_link_down(struct phylink_config *config,
>  
>  	stmmac_mac_set(priv, priv->ioaddr, false);
>  	priv->eee_active = false;
> -	priv->tx_lpi_enabled = false;
>  	priv->eee_enabled = stmmac_eee_init(priv);
>  	stmmac_set_eee_pls(priv, priv->hw, false);
>  
> @@ -1084,7 +1083,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>  		if (!priv->plat->rx_clk_runs_in_lpi)
>  			phy_eee_clk_stop_enable(phy);
>  		priv->eee_enabled = stmmac_eee_init(priv);
> -		priv->tx_lpi_enabled = priv->eee_enabled;
>  		stmmac_set_eee_pls(priv, priv->hw, true);
>  	}
>  
> -- 
> 2.40.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

