Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF77931E599
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhBRFaw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Feb 2021 00:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhBRF3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:29:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C237BC061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 21:28:26 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lCbrM-0005v3-RY; Thu, 18 Feb 2021 06:28:16 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lCbrL-0005YM-5z; Thu, 18 Feb 2021 06:28:15 +0100
Date:   Thu, 18 Feb 2021 06:28:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH net] net: ag71xx: remove unnecessary MTU reservation
Message-ID: <20210218052815.buawrjs4tti5e6m5@pengutronix.de>
References: <20210218034514.3421-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210218034514.3421-1-dqfext@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:27:28 up 77 days, 19:33, 30 users,  load average: 0.02, 0.03,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 11:45:14AM +0800, DENG Qingfang wrote:
> 2 bytes of the MTU are reserved for Atheros DSA tag, but DSA core
> has already handled that since commit dc0fe7d47f9f.
> Remove the unnecessary reservation.
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  drivers/net/ethernet/atheros/ag71xx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index dd5c8a9038bb..a60ce9030581 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -223,8 +223,6 @@
>  #define AG71XX_REG_RX_SM	0x01b0
>  #define AG71XX_REG_TX_SM	0x01b4
>  
> -#define ETH_SWITCH_HEADER_LEN	2
> -
>  #define AG71XX_DEFAULT_MSG_ENABLE	\
>  	(NETIF_MSG_DRV			\
>  	| NETIF_MSG_PROBE		\
> @@ -933,7 +931,7 @@ static void ag71xx_hw_setup(struct ag71xx *ag)
>  
>  static unsigned int ag71xx_max_frame_len(unsigned int mtu)
>  {
> -	return ETH_SWITCH_HEADER_LEN + ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
> +	return ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
>  }
>  
>  static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
