Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97692398AFC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFBNtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFBNtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:49:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E01C061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 06:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+DuXi1xoQj+kmVEf1kB4n8hjZ2nkOU8ZA/PKN0fHsS4=; b=jLFTT2iuwV9ZiyH/vk3i3AFSi
        1IQls1Pz7ZXNTnkit+z4kzTFT1c/kpeQBCLc10jhKlYAbHL9z4BFOllqMHDI/OCoL78NCpOv5gN7o
        uUhLOQ8Sta6GMLldKlsO/QQe1+gsXvXG+37oaKk+D7F9BxfbVavbgjHij6S+bNYpUhv12nKo80Ydd
        y73TUeJzJ5j9sGE0m6g/HNugU4aQEgOBcagiXgQXe2m+Bvq5zKsPp+MVg8I+qm3frj7F/t4Nc5MHT
        E3if2PrKYwyFJhFrbUD4C8zZ3YtMvb3LzDVyYrX0TygzirnYoiFZ4xVTOYhh+0Z2PYH3o1L3FfMhr
        O6WO9yo0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44630)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1loRDu-0001Ig-A9; Wed, 02 Jun 2021 14:47:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1loRDp-0001B0-Vn; Wed, 02 Jun 2021 14:47:49 +0100
Date:   Wed, 2 Jun 2021 14:47:49 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 9/9] net: pcs: xpcs: convert to
 phylink_pcs_ops
Message-ID: <20210602134749.GL30436@shell.armlinux.org.uk>
References: <20210601003325.1631980-1-olteanv@gmail.com>
 <20210601003325.1631980-10-olteanv@gmail.com>
 <20210601121032.GV30436@shell.armlinux.org.uk>
 <20210602134321.ppvusilvmmybodtx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602134321.ppvusilvmmybodtx@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 04:43:21PM +0300, Vladimir Oltean wrote:
> On Tue, Jun 01, 2021 at 01:10:33PM +0100, Russell King (Oracle) wrote:
> > On Tue, Jun 01, 2021 at 03:33:25AM +0300, Vladimir Oltean wrote:
> > >  static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
> > >  	.validate = stmmac_validate,
> > > -	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
> > > -	.mac_config = stmmac_mac_config,
> > 
> > mac_config is still a required function.
> 
> This is correct, thanks.
> 
> VK, would you mind testing again with this extra patch added to the mix?
> If it works, I will add it to the series in v3, ordered properly.
> 
> -----------------------------[ cut here]-----------------------------
> From a79863027998451c73d5bbfaf1b77cf6097a110c Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Wed, 2 Jun 2021 16:35:55 +0300
> Subject: [PATCH] net: phylink: allow the mac_config method to be missing if
>  pcs_ops are provided
> 
> The pcs_config method from struct phylink_pcs_ops does everything that
> the mac_config method from struct phylink_mac_ops used to do in the
> legacy approach of driving a MAC PCS. So allow drivers to not implement
> the mac_config method if there is nothing to do. Keep the method
> required for setups that do not provide pcs_ops.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 96d8e88b4e46..a8842c6ce3a2 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -415,6 +415,9 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
>  static void phylink_mac_config(struct phylink *pl,
>  			       const struct phylink_link_state *state)
>  {
> +	if (!pl->mac_ops->mac_config)
> +		return;
> +
>  	phylink_dbg(pl,
>  		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
>  		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
> @@ -1192,6 +1195,12 @@ void phylink_start(struct phylink *pl)
>  
>  	ASSERT_RTNL();
>  
> +	/* The mac_ops::mac_config method may be absent only if the
> +	 * pcs_ops are present.
> +	 */
> +	if (WARN_ON_ONCE(!pl->mac_ops->mac_config && !pl->pcs_ops))
> +		return;
> +
>  	phylink_info(pl, "configuring for %s/%s link mode\n",
>  		     phylink_an_mode_str(pl->cur_link_an_mode),
>  		     phy_modes(pl->link_config.interface));

I would rather we didn't do that - I suspect your case is not the
common scenario, so please add a dummy function to stmmac instead.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
