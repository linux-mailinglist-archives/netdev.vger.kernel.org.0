Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2604105DAC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKVA1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:27:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36182 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKVA1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QIJZTLKonnK0A0lxCHwgs5Dx3L4fEmo9nQtqXEl/IYQ=; b=z7UmRhEUyufGxXPwPUozRUy1l
        c7YYsmCtZYh74sxsFUGvhcDftxSFYMPQ4xrNkEF1tpjBEHUHWfyOZExWh9ncrHUYj3DF8a2GNd4ih
        jiFF6e7J8x73yVBygZxC2ndX/8jwA71CTp5ZfSbeHcVuaA7uF5h4xu9iNl6JwM/hl8pYoEafiVA4X
        Mf8jXBoPUA4EoYE6c6GksU8AylU4eumyZ56uCLTfSimdVJ5qbhrw02DByts2XzL1OAxv9NmrD0oE6
        tShTU2H/Rp8eli1rCFnGD3oo+Q5op9aKUZ+vW8Irj4HA6FgJKyylpMPLr+tUFVBp4Sq76AYJ2djrp
        Y38MQyddg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38744)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXwnG-0001cU-0w; Fri, 22 Nov 2019 00:27:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXwnD-0003CA-5M; Fri, 22 Nov 2019 00:27:23 +0000
Date:   Fri, 22 Nov 2019 00:27:23 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next 2/3] dpaa2-eth: add phylink_mac_ops stub
 callbacks
Message-ID: <20191122002723.GE25745@shell.armlinux.org.uk>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
 <1574363727-5437-3-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574363727-5437-3-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:15:26PM +0200, Ioana Ciornei wrote:
> For the moment, we do not have a way to query the PCS link state
> or to restart aneg on it. Add stub functions for both of the callbacks
> since phylink can provoke an oops when an SFP module has been inserted.
> 
> Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
> Reported-by: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

This is independent of patch 1.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 0200308d1bc7..efc587515661 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -183,11 +183,24 @@ static void dpaa2_mac_link_down(struct phylink_config *config,
>  		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
>  }
>  
> +static void dpaa2_mac_an_restart(struct phylink_config *config)
> +{
> +	/* Not supported */
> +}
> +
> +static void dpaa2_mac_pcs_get_state(struct phylink_config *config,
> +				    struct phylink_link_state *state)
> +{
> +	/* Not supported */
> +}
> +
>  static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
>  	.validate = dpaa2_mac_validate,
>  	.mac_config = dpaa2_mac_config,
>  	.mac_link_up = dpaa2_mac_link_up,
>  	.mac_link_down = dpaa2_mac_link_down,
> +	.mac_an_restart = dpaa2_mac_an_restart,
> +	.mac_pcs_get_state = dpaa2_mac_pcs_get_state,
>  };
>  
>  bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
