Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7A573D8C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiGMUF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiGMUF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:05:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C6722289;
        Wed, 13 Jul 2022 13:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EVrD+Zxoj2adqCGwdunLuG7a8ZSPZ0ojB0Z9EuSlbIM=; b=fKS5eDuj0bAXqk3uPCI0dKJyo6
        3++Tg1JeX9/GR56QsYmJrdyHh39X3mXEjTHfKuJoh8PkvWnJjtVNHAwEv9O0/dA+IjMbmyFMMdAxC
        LGCHiJT13smg15z9N3tu35ccifDeEcl3+FdClwjF6VK3WYCJp47+pjGmb1QnRML+V62F/0JJBbvIE
        QaP/r5XwySCmxu8sJNR7YqgDA0uUZTZMSYNUgJUq+2uqAj1/875+PTi5jTUA8jYkiSRZBJj8lIMZU
        UwJWk5aPogbRXKFa2JoT9+cSOOTstbu5wCtnq7NP7sCfxJUgFV/TxqwBCr1sY5mQ0589iTKm0jceq
        E6We+ASg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33322)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oBibq-0004zd-Pp; Wed, 13 Jul 2022 21:05:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oBibp-0005vg-1F; Wed, 13 Jul 2022 21:05:21 +0100
Date:   Wed, 13 Jul 2022 21:05:21 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Message-ID: <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 08:20:13PM +0300, Oleksandr Mazur wrote:
> For SFP port prestera driver will use kernel
> phylink infrastucture to configure port mode based on
> the module that has beed inserted
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> PATCH V2:
>   - fix mistreat of bitfield values as if they were bools.
>   - remove phylink_config ifdefs.
>   - remove obsolete phylink pcs / mac callbacks;
>   - rework mac (/pcs) config to not look for speed / duplex
>     parameters while link is not yet set up.
>   - remove unused functions.
>   - add phylink select cfg to prestera Kconfig.

I would appreciate answers to my questions, rather than just another
patch submission. So I'll repeat my question in the hope of an answer:

First question which applies to everything in this patch is - why make
phylink conditional for this driver?

The reason that this needs to be answered is that I would like an
explanation why it's conditional, because it shouldn't be. By making it
conditional, you will have multiple separate paths through the driver
code trying to do the same thing, but differently, which means more time
an effort maintaining the driver.

> +static int prestera_pcs_config(struct phylink_pcs *pcs,
> +			       unsigned int mode,
> +			       phy_interface_t interface,
> +			       const unsigned long *advertising,
> +			       bool permit_pause_to_mac)
> +{
> +	struct prestera_port *port = port = prestera_pcs_to_port(pcs);
> +	struct prestera_port_mac_config cfg_mac;
> +	int err;
> +
> +	err = prestera_port_cfg_mac_read(port, &cfg_mac);
> +	if (err)
> +		return err;
> +
> +	cfg_mac.admin = true;
> +	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		cfg_mac.speed = SPEED_10000;
> +		cfg_mac.inband = 0;
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		cfg_mac.speed = SPEED_2500;
> +		cfg_mac.duplex = DUPLEX_FULL;
> +		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +					  advertising);
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
> +		break;
> +	case PHY_INTERFACE_MODE_SGMII:
> +		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +					  advertising);

This looks wrong to me. In SGMII mode, it is normal for the advertising
mask to indicate the media modes on the PHY to advertise, and whether to
enable advertisements on the _media_. Whether media advertisements are
enabled or not doesn't have any bearing on the PCS<->PHY link. If the
interface is in in-band mode, then the SGMII control word exchange
should always happen.

> +		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	default:
> +		cfg_mac.speed = SPEED_1000;
> +		cfg_mac.duplex = DUPLEX_FULL;
> +		cfg_mac.inband = test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +					  advertising);
> +		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
> +		break;
>  	}
>  
> +	err = prestera_port_cfg_mac_write(port, &cfg_mac);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static void prestera_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +}

No way to restart 1000base-X autoneg?

> @@ -530,25 +777,48 @@ static int prestera_create_ports(struct prestera_switch *sw)
>  static void prestera_port_handle_event(struct prestera_switch *sw,
>  				       struct prestera_event *evt, void *arg)
>  {
> +	struct prestera_port_mac_state smac;
> +	struct prestera_port_event *pevt;
>  	struct delayed_work *caching_dw;
>  	struct prestera_port *port;
>  
> -	port = prestera_find_port(sw, evt->port_evt.port_id);
> -	if (!port || !port->dev)
> -		return;
> -
> -	caching_dw = &port->cached_hw_stats.caching_dw;
> -
> -	prestera_ethtool_port_state_changed(port, &evt->port_evt);
> -
>  	if (evt->id == PRESTERA_PORT_EVENT_MAC_STATE_CHANGED) {
> +		pevt = &evt->port_evt;
> +		port = prestera_find_port(sw, pevt->port_id);
> +		if (!port || !port->dev)
> +			return;
> +
> +		caching_dw = &port->cached_hw_stats.caching_dw;
> +
> +		if (port->phy_link) {
> +			memset(&smac, 0, sizeof(smac));
> +			smac.valid = true;
> +			smac.oper = pevt->data.mac.oper;
> +			if (smac.oper) {
> +				smac.mode = pevt->data.mac.mode;
> +				smac.speed = pevt->data.mac.speed;
> +				smac.duplex = pevt->data.mac.duplex;
> +				smac.fc = pevt->data.mac.fc;
> +				smac.fec = pevt->data.mac.fec;
> +			}
> +			prestera_port_mac_state_cache_write(port, &smac);

I think you should be calling phylink_mac_change() here, rather than
below.

> +		}
> +
>  		if (port->state_mac.oper) {
> -			netif_carrier_on(port->dev);
> +			if (port->phy_link)
> +				phylink_mac_change(port->phy_link, true);
> +			else
> +				netif_carrier_on(port->dev);
> +
>  			if (!delayed_work_pending(caching_dw))
>  				queue_delayed_work(prestera_wq, caching_dw, 0);
>  		} else if (netif_running(port->dev) &&
>  			   netif_carrier_ok(port->dev)) {
> -			netif_carrier_off(port->dev);
> +			if (port->phy_link)
> +				phylink_mac_change(port->phy_link, false);
> +			else
> +				netif_carrier_off(port->dev);
> +
>  			if (delayed_work_pending(caching_dw))
>  				cancel_delayed_work(caching_dw);
>  		}
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
