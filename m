Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1DD3FDD0C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbhIANIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 09:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344834AbhIANII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 09:08:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EB8C03D7C9
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 05:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lEn5wbi62oX+338fxsLHsWKq/jI6VPGeHeIRdvjDqRg=; b=QCKiHlEnwJFMaPDVvWVQ7MvcV
        xoVLWHYDd0FkmsX0xLZ7rfpcmYDRN9lNOOhUs8tgJUH93hA+XVriwdrczAVVIv7qbzfz0/3HKlN7u
        nSi80rr+VEURIUj/SvTCypgDTap7WFWFmeEAUji6Yr36ne268r2o7Hnkf0xKsPhOPeA2e8bZPIZYl
        3gZ7F0XNV+TTWkc7TnvtSDTHKa4S/njNFXgBFOslH64n9YUCBZD/YPv37Ot/6fmsvYtmQpb+e9k2B
        a5YsBokvo1rHAxPBFfScbcpLLjqSoZDNxiJ43IcbVv5sN4D2Eo0mEWnA4tG3aFbN7REB3lMiVT9Z2
        reOtzMgvA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47982)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLPnE-0008Fp-4J; Wed, 01 Sep 2021 13:56:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLPnA-0006rV-MJ; Wed, 01 Sep 2021 13:56:36 +0100
Date:   Wed, 1 Sep 2021 13:56:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210901125636.GA22278@shell.armlinux.org.uk>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901091332.GZ22278@shell.armlinux.org.uk>
 <DB8PR04MB67959C4B1D1AFEC5AEEB73F3E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB67959C4B1D1AFEC5AEEB73F3E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 10:21:59AM +0000, Joakim Zhang wrote:
> 
> Hi Russell,
> 
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: 2021年9月1日 17:14
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
> > joabreu@synopsys.com; davem@davemloft.net; kuba@kernel.org;
> > mcoquelin.stm32@gmail.com; netdev@vger.kernel.org; andrew@lunn.ch;
> > f.fainelli@gmail.com; hkallweit1@gmail.com; dl-linux-imx <linux-imx@nxp.com>
> > Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume
> > back with WoL enabled
> > 
> > NAK. Please read the phylink documentation. speed/duplex/pause is undefined
> > in .mac_config.
> 
> Speed/duplex/pause also the field of " struct phylink_link_state", so these can be refered in .mac_config, please
> see the link which stmmac did before:
> https://elixir.bootlin.com/linux/v5.4.143/source/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c#L852

The phylink documentation says:

/**
 * mac_config() - configure the MAC for the selected mode and state
 * @config: a pointer to a &struct phylink_config.
 * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
 * @state: a pointer to a &struct phylink_link_state.
 *
 * Note - not all members of @state are valid.  In particular,
 * @state->lp_advertising, @state->link, @state->an_complete are never
 * guaranteed to be correct, and so any mac_config() implementation must
 * never reference these fields.
...
 * %MLO_AN_FIXED, %MLO_AN_PHY:
...
 *   Older drivers (prior to the mac_link_up() change) may use @state->speed,
 *   @state->duplex and @state->pause to configure the MAC, but this is
 *   deprecated; such drivers should be converted to use mac_link_up().
 *   Valid state members: interface, advertising.
 *   Deprecated state members: speed, duplex, pause.
...
 * %MLO_AN_INBAND:
...
 *   Valid state members: interface, an_enabled, pause, advertising.

The reason for this is there have _always_ been code paths through
phylink where particularly speed and duplex are _not_ _set_ according
to the current link settings. For example, a call to ksettings_set.
This is why I revised the interface so that mac_link_up() receives
the link settings and depreciated these members in mac_config().

In any case, as can be seen from the documentation, speed and duplex
have _never_ been valid when operating in inband mode in mac_config.

> > I think the problem here is that you're not calling phylink_stop() when WoL is
> > enabled, which means phylink will continue to maintain the state as per the
> > hardware state, and phylib will continue to run its state machine reporting the
> > link state to phylink.
> 
> Yes, I also tried do below code change, but the host would not be wakeup, phylink_stop() would
> call phy_stop(), phylib would call phy_suspend() finally, it will not suspend phy if it detect WoL enabled,
> so now I don't know why system can't be wakeup with this code change.
> 
> @@ -5374,7 +5374,6 @@ int stmmac_suspend(struct device *dev)
>                 rtnl_lock();
>                 if (device_may_wakeup(priv->device))
>                         phylink_speed_down(priv->phylink, false);
> -               phylink_stop(priv->phylink);
>                 rtnl_unlock();
>                 mutex_lock(&priv->lock);
> 
> @@ -5385,6 +5384,10 @@ int stmmac_suspend(struct device *dev)
>         }
>         mutex_unlock(&priv->lock);
> 
> +       rtnl_lock();
> +       phylink_stop(priv->phylink);
> +       rtnl_unlock();
> +
>         priv->speed = SPEED_UNKNOWN;
>         return 0;
>  }
> @@ -5448,6 +5451,12 @@ int stmmac_resume(struct device *dev)
>                 pinctrl_pm_select_default_state(priv->device);
>                 if (priv->plat->clk_ptp_ref)
>                         clk_prepare_enable(priv->plat->clk_ptp_ref);
> +
> +               rtnl_lock();
> +               /* We may have called phylink_speed_down before */
> +               phylink_speed_up(priv->phylink);
> +               rtnl_unlock();
> +
>                 /* reset the phy so that it's ready */
>                 if (priv->mii && priv->mdio_rst_after_resume)
>                         stmmac_mdio_reset(priv->mii);
> @@ -5461,13 +5470,9 @@ int stmmac_resume(struct device *dev)
>                         return ret;
>         }
> 
> -       if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> -               rtnl_lock();
> -               phylink_start(priv->phylink);
> -               /* We may have called phylink_speed_down before */
> -               phylink_speed_up(priv->phylink);
> -               rtnl_unlock();
> -       }
> +       rtnl_lock();
> +       phylink_start(priv->phylink);
> +       rtnl_unlock();
> 
>         rtnl_lock();
>         mutex_lock(&priv->lock);

You also need to remove the calls to phylink_mac_change() from the
suspend/resume functions. Without knowing how WoL is configured to
work in your setup, I couldn't comment why it isn't working. Can you
give some hints please?

Also, what configuration of WoL are you using? I see stmmac supports
several different configurations, but I assume priv->plat->pmt is
NULL here?

> > phylink_stop() (and therefore phy_stop()) should be called even if WoL is active
> > to shut down this state reporting, as other network drivers do.
> 
> Ok, you mean that phylink_stop() also should be called even if WoL is active, I would look in this direction since
> you are a professional.

Yes. If the system is suspending for whatever reason, you want to
bring the MAC down so that when it resumes, the MAC will see a link
up event afterwards.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
