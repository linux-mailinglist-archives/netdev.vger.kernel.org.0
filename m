Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B522F64942E
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 13:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiLKMYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 07:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiLKMYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 07:24:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A1510568;
        Sun, 11 Dec 2022 04:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6i6N09X3DCcqlDINO1vV/DEzMCBg+KMZPnNEzHal4ZY=; b=GINXTrh2vDLUlYv2ye/+pYmWaD
        hXmMFNwOOJ3ZRzJd7HTxAIGobz7MBqhcvq9kCOf2WHYSdSMgUMEeZCZgwRCIXyNBzh0AEE6/XlY3Z
        jdYJmK4TPWKbRZOprsxntzdj/etZcZLXI+QWW8rcPYYry59PzfseTgRLzJo4sc4EjhXDkJ6We280u
        zTdyAO0m3Nch/llk/OJjaYeW6CzfoGfCBKJMRKag9/W49uqvLDJsB3qQkMix5sr7C92ltZsdHNivl
        SKyH8wdBWa/LSZB68YqNFe0dWQMpooMzcTlJBHUUbTvz7imdShDImOt5ry4m36HfLFzBKfgD6yrUj
        oFhLN+BA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35660)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p4LN7-0004hT-1R; Sun, 11 Dec 2022 12:23:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p4LN3-0004YX-Be; Sun, 11 Dec 2022 12:23:53 +0000
Date:   Sun, 11 Dec 2022 12:23:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v6 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
 <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 11:46:39PM +0100, Piergiorgio Beruto wrote:
> This patch adds the required connection between netlink ethtool and
> phylib to resolve PLCA get/set config and get status messages.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  drivers/net/phy/phy.c        | 175 +++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c |   3 +
>  include/linux/phy.h          |   7 ++
>  3 files changed, 185 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e5b6cb1a77f9..40d90ed2f0fb 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -543,6 +543,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
>  }
>  EXPORT_SYMBOL(phy_ethtool_get_stats);
>  
> +/**
> + * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
> + *

You shouldn't have an empty line in the comment here

> + * @phydev: the phy_device struct
> + * @plca_cfg: where to store the retrieved configuration

Maybe have an empty line, followed by a bit of text describing what this
function does and the return codes it generates?

> + */
> +int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
> +			     struct phy_plca_cfg *plca_cfg)
> +{
> +	int ret;
> +
> +	if (!phydev->drv) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	if (!phydev->drv->get_plca_cfg) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	memset(plca_cfg, 0xFF, sizeof(*plca_cfg));
> +
> +	mutex_lock(&phydev->lock);

Maybe move the memset() and mutex_lock() before the first if() statement
above? Maybe the memset() should be done by plca_get_cfg_prepare_data()?
Wouldn't all implementations need to memset this to 0xff?

Also, lower-case 0xff please.

> +	ret = phydev->drv->get_plca_cfg(phydev, plca_cfg);
> +
> +	if (ret)
> +		goto out_drv;
> +
> +out_drv:

This if() and out_drv label seems unused (although with the above
suggested change, you will need to move the "out" label here.)

> +	mutex_unlock(&phydev->lock);
> +out:
> +	return ret;
> +}
> +
> +/**
> + * phy_ethtool_set_plca_cfg - Set PLCA RS configuration
> + *
> + * @phydev: the phy_device struct
> + * @extack: extack for reporting useful error messages
> + * @plca_cfg: new PLCA configuration to apply
> + */
> +int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
> +			     const struct phy_plca_cfg *plca_cfg,
> +			     struct netlink_ext_ack *extack)
> +{
> +	int ret;
> +	struct phy_plca_cfg *curr_plca_cfg = 0;

Unnecessary initialiser. Also, reverse Christmas-tree please.

> +
> +	if (!phydev->drv) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	if (!phydev->drv->set_plca_cfg ||
> +	    !phydev->drv->get_plca_cfg) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	curr_plca_cfg = kmalloc(sizeof(*curr_plca_cfg), GFP_KERNEL);

What if kmalloc() returns NULL?

> +	memset(curr_plca_cfg, 0xFF, sizeof(*curr_plca_cfg));
> +
> +	mutex_lock(&phydev->lock);

Consider moving the above three to the beginning of the function so
phydev->drv is checked under the mutex.

> +
> +	ret = phydev->drv->get_plca_cfg(phydev, curr_plca_cfg);
> +	if (ret)
> +		goto out_drv;
> +
> +	if (curr_plca_cfg->enabled < 0 && plca_cfg->enabled >= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY does not support changing the PLCA 'enable' attribute");
> +		ret = -EINVAL;
> +		goto out_drv;
> +	}
> +
> +	if (curr_plca_cfg->node_id < 0 && plca_cfg->node_id >= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY does not support changing the PLCA 'local node ID' attribute");
> +		ret = -EINVAL;
> +		goto out_drv;
> +	}
> +
> +	if (curr_plca_cfg->node_cnt < 0 && plca_cfg->node_cnt >= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY does not support changing the PLCA 'node count' attribute");
> +		ret = -EINVAL;
> +		goto out_drv;
> +	}
> +
> +	if (curr_plca_cfg->to_tmr < 0 && plca_cfg->to_tmr >= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY does not support changing the PLCA 'TO timer' attribute");
> +		ret = -EINVAL;
> +		goto out_drv;
> +	}
> +
> +	if (curr_plca_cfg->burst_cnt < 0 && plca_cfg->burst_cnt >= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY does not support changing the PLCA 'burst count' attribute");
> +		ret = -EINVAL;
> +		goto out_drv;
> +	}
> +
> +	if (curr_plca_cfg->burst_tmr < 0 && plca_cfg->burst_tmr >= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY does not support changing the PLCA 'burst timer' attribute");
> +		ret = -EINVAL;
> +		goto out_drv;
> +	}
> +
> +	// if enabling PLCA, perform additional sanity checks
> +	if (plca_cfg->enabled > 0) {
> +		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> +				       phydev->advertising)) {
> +			ret = -EOPNOTSUPP;
> +			NL_SET_ERR_MSG(extack,
> +				       "Point to Multi-Point mode is not enabled");
> +		}
> +
> +		// allow setting node_id concurrently with enabled
> +		if (plca_cfg->node_id >= 0)
> +			curr_plca_cfg->node_id = plca_cfg->node_id;
> +
> +		if (curr_plca_cfg->node_id >= 255) {
> +			NL_SET_ERR_MSG(extack, "PLCA node ID is not set");
> +			ret = -EINVAL;
> +			goto out_drv;
> +		}
> +	}
> +
> +	ret = phydev->drv->set_plca_cfg(phydev, plca_cfg);
> +	if (ret)
> +		goto out_drv;

Unnecessary if() statement.

> +
> +out_drv:
> +	kfree(curr_plca_cfg);
> +	mutex_unlock(&phydev->lock);
> +out:
> +	return ret;
> +}
> +
> +/**
> + * phy_ethtool_get_plca_status - Get PLCA RS status information
> + *
> + * @phydev: the phy_device struct
> + * @plca_st: where to store the retrieved status information
> + */
> +int phy_ethtool_get_plca_status(struct phy_device *phydev,
> +				struct phy_plca_status *plca_st)
> +{
> +	int ret;
> +
> +	if (!phydev->drv) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	if (!phydev->drv->get_plca_status) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	mutex_lock(&phydev->lock);

Same comment here.

> +	ret = phydev->drv->get_plca_status(phydev, plca_st);
> +
> +	if (ret)
> +		goto out_drv;

And here.

> +
> +out_drv:
> +	mutex_unlock(&phydev->lock);
> +out:
> +	return ret;
> +}
> +
>  /**
>   * phy_start_cable_test - Start a cable test
>   *
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 8e48b3cec5e7..44bd06be9691 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3276,6 +3276,9 @@ static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
>  	.get_sset_count		= phy_ethtool_get_sset_count,
>  	.get_strings		= phy_ethtool_get_strings,
>  	.get_stats		= phy_ethtool_get_stats,
> +	.get_plca_cfg		= phy_ethtool_get_plca_cfg,
> +	.set_plca_cfg		= phy_ethtool_set_plca_cfg,
> +	.get_plca_status	= phy_ethtool_get_plca_status,
>  	.start_cable_test	= phy_start_cable_test,
>  	.start_cable_test_tdr	= phy_start_cable_test_tdr,
>  };
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 2a5c2d3a5da5..e0dcd534fe6f 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1845,6 +1845,13 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
>  int phy_ethtool_get_sset_count(struct phy_device *phydev);
>  int phy_ethtool_get_stats(struct phy_device *phydev,
>  			  struct ethtool_stats *stats, u64 *data);
> +int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
> +			     struct phy_plca_cfg *plca_cfg);
> +int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
> +			     const struct phy_plca_cfg *plca_cfg,
> +			     struct netlink_ext_ack *extack);
> +int phy_ethtool_get_plca_status(struct phy_device *phydev,
> +				struct phy_plca_status *plca_st);
>  
>  static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
>  {
> -- 
> 2.37.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
