Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB4C7141712
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 11:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgARKxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 05:53:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58400 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgARKxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 05:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wujg23cjYKyDE5T6UWUVUS6smEWl/Ay0DL9sfcBki6o=; b=x2B5BcbzOmhXBoMqLrkG5IBIe
        N5Yr/28nsMPnLvmgZRGBiOKYKR2oSn5uEDm55QM7fkofvj+qi340YNtYKV1fuAWneXbiZ798tjhyq
        4cpO1dAGEuv77yFkPybnZ9ikEWf3nSN6Aic3X80zr2DeMevag1vYIqzAAes9i+rnLeld09/CW6Ek3
        3oncrxRjAVUamokiFI6C1h5MSgpAVVPSLWgAqSMmWuKPC9v0caoiNXXvgz0Ytqk9Zq8cgtKeHn2Pu
        L4HA8ME5x8hXqXQcjAxT3ohRuTDAb0TXtQY6qKJZE3oOQ6XK5g6eMOCAnKfR1mSmAe6lfVHtSDI1d
        Ky0dc0Cog==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39948)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1isljO-000290-6W; Sat, 18 Jan 2020 10:53:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1isljJ-0000oj-RT; Sat, 18 Jan 2020 10:53:25 +0000
Date:   Sat, 18 Jan 2020 10:53:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: phylink: allow in-band AN for USXGMII
Message-ID: <20200118105325.GS25745@shell.armlinux.org.uk>
References: <20200116173930.14775-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116173930.14775-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 07:39:30PM +0200, Vladimir Oltean wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> USXGMII supports passing link information in-band between PHY and MAC PCS,
> add it to the list of protocols that support in-band AN mode.
> 
> Being a MAC-PHY protocol that can auto-negotiate link speeds up to 10
> Gbps, we populate the initial supported mask with the entire spectrum of
> link modes up to 10G that PHYLINK supports, and we let the driver reduce
> that mask in its .phylink_validate method.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Please copy your patches to the netdev mailing list.

> ---
>  drivers/net/phy/phylink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index efabbfa4a6d3..f40d92ec32f8 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -299,6 +299,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>  			break;
>  
>  		case PHY_INTERFACE_MODE_10GKR:
> +		case PHY_INTERFACE_MODE_USXGMII:
>  		case PHY_INTERFACE_MODE_10GBASER:

Please also move USXGMII before 10GKR.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
