Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C1760FC96
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiJ0QAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiJ0QAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:00:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4681557BC4;
        Thu, 27 Oct 2022 09:00:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id n12so5885026eja.11;
        Thu, 27 Oct 2022 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SW4XxAEZl3IlDzbqHTqK+eThF9vGXQHhRs6UmQcYWB4=;
        b=f6HNIVgObL1o/0Y/lX6C4Gc1jWvL/1pTReopPeHpIKaapHz5+K031UNPkgyvOik34H
         wZzN6xA7CJY6M2NIo4YKW5twfjiJXioHv4dhvz79PstfVeB2lxUdPOmFymCwRKro4z2u
         eDplHZXhtCxZNgj1Ce4N69skQstvSYscz9PbE7BMm6cPDY5ZBLW34KFNOy+BAI51BTuk
         WXGZbDnvY9o3LqOMpWLQjXGO4S1V7xy4HRTZcIChNee1osUemUz0ThessvEzhkBoaGn5
         KXPGHejyW4fAyxf/hoAoxI9eTX5WqygiTIkqJOuhIoz7nZ4b3ZCsQH892qbMvPRvjPzQ
         ttYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SW4XxAEZl3IlDzbqHTqK+eThF9vGXQHhRs6UmQcYWB4=;
        b=uiU0qro1RXTuS5dextsiDMk1V5Gx0GGAjaCyWko64zaEP7lU8isJW/K0SawsKBHdoG
         7Usjkc6y9hc+gob6Iztw87yPVCuTe7V4y0FOnrq4bS9ihv0ZHzDcCuYWxM4o1Vm98hQO
         GXM4oYym25ElJkLBZP1tmVsnaZuHCW98peI68nQhgEiAWW0bLbnDIXorkf6aQAhwlgHP
         qxcPMi44nUMrgoeEZrmPkgn4k+6/PIugoAocW7v7VTqfDzB4yMwljcZdSJKVJfR9oJIl
         4y9U8R+LaRmKofXGk97Y/h3icLy+ILca1VYMD2BuVlfqXykHTEDMwga+IuLD+FWrCJ0o
         MaWQ==
X-Gm-Message-State: ACrzQf1Y57uFWS+RniEmZRMWvF4kIQoYbbRbq68f/2zqU8DxTqYKq/4h
        XsQkQehvVIr4RZYDZBbbdGU=
X-Google-Smtp-Source: AMsMyM4DolQOWaHLB7SyNkyZXcXRfDcv/EyomnmMbE5214MgCYDEMxXWWv/9eiQPJWowjHpIGnmy5w==
X-Received: by 2002:a17:907:c10:b0:7ad:8218:c2a2 with SMTP id ga16-20020a1709070c1000b007ad8218c2a2mr7502889ejc.183.1666886428568;
        Thu, 27 Oct 2022 09:00:28 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id e2-20020a170906314200b0077e6be40e4asm988748eje.175.2022.10.27.09.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 09:00:28 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:00:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Camel Guo <camel.guo@axis.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
Message-ID: <20221027160025.hjymnt3tzhoyv6ep@skbuf>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025135243.4038706-3-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Camel,

I took a very superficial look. I'm only interested in the API
perspective for now. Some comments.

On Tue, Oct 25, 2022 at 03:52:41PM +0200, Camel Guo wrote:
> +static int gsw1xx_port_enable(struct dsa_switch *ds, int port,
> +			      struct phy_device *phydev)
> +{
> +	struct gsw1xx_priv *priv = ds->priv;
> +
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
> +	/* RMON Counter Enable for port */
> +	gsw1xx_switch_w(priv, GSW1XX_IP_BM_PCFG_CNTEN,
> +			GSW1XX_IP_BM_PCFGp(port));
> +
> +	/* enable port fetch/store dma */
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_FDMA_PCTRL_EN,
> +			   GSW1XX_IP_FDMA_PCTRLp(port));
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_SDMA_PCTRL_EN,
> +			   GSW1XX_IP_SDMA_PCTRLp(port));
> +
> +	if (!dsa_is_cpu_port(ds, port)) {
> +		u32 mdio_phy = 0;
> +
> +		if (phydev)
> +			mdio_phy =
> +				phydev->mdio.addr & GSW1XX_MDIO_PHY_ADDR_MASK;
> +
> +		gsw1xx_mdio_mask(priv, GSW1XX_MDIO_PHY_ADDR_MASK, mdio_phy,
> +				 GSW1XX_MDIO_PHYp(port));
> +	}
> +
> +	return 0;
> +}
> +
> +static void gsw1xx_port_disable(struct dsa_switch *ds, int port)
> +{
> +	struct gsw1xx_priv *priv = ds->priv;
> +
> +	if (!dsa_is_user_port(ds, port))
> +		return;
> +
> +	gsw1xx_switch_mask(priv, GSW1XX_IP_FDMA_PCTRL_EN, 0,
> +			   GSW1XX_IP_FDMA_PCTRLp(port));
> +	gsw1xx_switch_mask(priv, GSW1XX_IP_SDMA_PCTRL_EN, 0,
> +			   GSW1XX_IP_SDMA_PCTRLp(port));
> +}
> +
> +static int gsw1xx_setup(struct dsa_switch *ds)
> +{
> +	struct gsw1xx_priv *priv = ds->priv;
> +	unsigned int cpu_port = priv->hw_info->cpu_port;
> +	int i;
> +	int err;
> +
> +	gsw1xx_switch_w(priv, GSW1XX_IP_SWRES_R0, GSW1XX_IP_SWRES);
> +	usleep_range(5000, 10000);
> +	gsw1xx_switch_w(priv, 0, GSW1XX_IP_SWRES);
> +
> +	/* disable port fetch/store dma on all ports */
> +	for (i = 0; i < priv->hw_info->max_ports; i++)
> +		gsw1xx_port_disable(ds, i);
> +
> +	/* enable Switch */
> +	gsw1xx_mdio_mask(priv, 0, GSW1XX_MDIO_GLOB_ENABLE, GSW1XX_MDIO_GLOB);
> +
> +	gsw1xx_switch_w(priv, 0x7F, GSW1XX_IP_PCE_PMAP2);
> +	gsw1xx_switch_w(priv, 0x7F, GSW1XX_IP_PCE_PMAP3);
> +
> +	/* Deactivate MDIO PHY auto polling since it affects mmd read/write.
> +	 */
> +	gsw1xx_mdio_w(priv, 0x0, GSW1XX_MDIO_MDC_CFG0);
> +
> +	gsw1xx_switch_mask(priv, 1, GSW1XX_IP_MAC_CTRL_2_MLEN,
> +			   GSW1XX_IP_MAC_CTRL_2p(cpu_port));
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_BM_QUEUE_GCTRL_GL_MOD,
> +			   GSW1XX_IP_BM_QUEUE_GCTRL);
> +
> +	/* Flush MAC Table */
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_PCE_GCTRL_0_MTFL,
> +			   GSW1XX_IP_PCE_GCTRL_0);
> +	err = gsw1xx_switch_r_timeout(priv, GSW1XX_IP_PCE_GCTRL_0,
> +				      GSW1XX_IP_PCE_GCTRL_0_MTFL);
> +	if (err) {
> +		dev_err(priv->dev, "MAC flushing didn't finish\n");
> +		return err;
> +	}
> +
> +	gsw1xx_port_enable(ds, cpu_port, NULL);

DSA automatically calls this on the CPU port. You have this code which
ignores the call:

	if (!dsa_is_user_port(ds, port)) // which the CPU port isn't
		return 0;

so why do it?!

> +
> +	return 0;
> +}
> +
> +static enum dsa_tag_protocol gsw1xx_get_tag_protocol(struct dsa_switch *ds,
> +						     int port,
> +						     enum dsa_tag_protocol mp)
> +{
> +	return DSA_TAG_PROTO_NONE;

Nope, this won't fly for new drivers, please write a protocol driver for
your switch, or use something based on tag_8021q.c if the switch doesn't
support something natively.

> +}
> +
> +static void gsw1xx_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
> +{
> +	struct gsw1xx_priv *priv = ds->priv;
> +	u32 stp_state;
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		gsw1xx_switch_mask(priv, GSW1XX_IP_SDMA_PCTRL_EN, 0,
> +				   GSW1XX_IP_SDMA_PCTRLp(port));
> +		return;
> +	case BR_STATE_BLOCKING:
> +	case BR_STATE_LISTENING:
> +		stp_state = GSW1XX_IP_PCE_PCTRL_0_PSTATE_LISTEN;
> +		break;
> +	case BR_STATE_LEARNING:
> +		stp_state = GSW1XX_IP_PCE_PCTRL_0_PSTATE_LEARNING;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		stp_state = GSW1XX_IP_PCE_PCTRL_0_PSTATE_FORWARDING;
> +		break;
> +	default:
> +		dev_err(priv->dev, "invalid STP state: %d\n", state);
> +		return;
> +	}
> +
> +	gsw1xx_switch_mask(priv, 0, GSW1XX_IP_SDMA_PCTRL_EN,
> +			   GSW1XX_IP_SDMA_PCTRLp(port));
> +	gsw1xx_switch_mask(priv, GSW1XX_IP_PCE_PCTRL_0_PSTATE_MASK, stp_state,
> +			   GSW1XX_IP_PCE_PCTRL_0p(port));
> +}
> +
> +static const struct dsa_switch_ops gsw1xx_switch_ops = {
> +	.get_tag_protocol	= gsw1xx_get_tag_protocol,
> +	.setup			= gsw1xx_setup,
> +	.set_mac_eee		= gsw1xx_set_mac_eee,
> +	.get_mac_eee		= gsw1xx_get_mac_eee,
> +	.port_enable		= gsw1xx_port_enable,
> +	.port_disable		= gsw1xx_port_disable,
> +	.port_stp_state_set	= gsw1xx_port_stp_state_set,

No need to implement .port_stp_state_set() if .port_bridge_join() is
absent. First get the support for standalone port mode right (hint, need
to disable address learning and forwarding between ports for standalone mode).

Look inside tools/testing/selftests/drivers/net/dsa/, a bunch of tests
should pass even with software forwarding. First make sure that switch
ports can ping each other through a cable in loopback. Then there's
no_forwarding.sh, a must have. I think bridge_vlan_aware.sh and
bridge_vlan_unaware.sh should also pass.

As far as local_termination.sh, that also tests for some optional
optimizations. You can run it, and the goal should be to get "OK" for
all tests. "FAIL" is also ok, if the reason is "reception succeeded,
but should have failed". What is not ok is "FAIL" with the reason
"reception failed". Something like this would be ok:

    TEST: br0: Unicast IPv4 to primary MAC address                      [ OK ]
    TEST: br0: Unicast IPv4 to macvlan MAC address                      [ OK ]
    TEST: br0: Unicast IPv4 to unknown MAC address                      [FAIL]
            reception succeeded, but should have failed
    TEST: br0: Unicast IPv4 to unknown MAC address, promisc             [ OK ]
    TEST: br0: Unicast IPv4 to unknown MAC address, allmulti            [FAIL]
            reception succeeded, but should have failed
    TEST: br0: Multicast IPv4 to joined group                           [ OK ]
    TEST: br0: Multicast IPv4 to unknown group                          [FAIL]
            reception succeeded, but should have failed
    TEST: br0: Multicast IPv4 to unknown group, promisc                 [ OK ]
    TEST: br0: Multicast IPv4 to unknown group, allmulti                [ OK ]
    TEST: br0: Multicast IPv6 to joined group                           [ OK ]
    TEST: br0: Multicast IPv6 to unknown group                          [FAIL]
            reception succeeded, but should have failed
    TEST: br0: Multicast IPv6 to unknown group, promisc                 [ OK ]
    TEST: br0: Multicast IPv6 to unknown group, allmulti                [ OK ]

The selftest results for unoffloaded mode will stand as a future guide
for regression testing when you add later support for offloading various
features. So please try to spend some time running them now, ask
questions if needed.

> +	.phylink_mac_link_down	= gsw1xx_phylink_mac_link_down,
> +	.phylink_mac_link_up	= gsw1xx_phylink_mac_link_up,
> +	.get_strings		= gsw1xx_get_strings,
> +	.get_ethtool_stats	= gsw1xx_get_ethtool_stats,
> +	.get_sset_count		= gsw1xx_get_sset_count,

New DSA drivers should first add support for:

	.get_stats64
	.get_pause_stats
	.get_rmon_stats
	.get_eth_ctrl_stats
	.get_eth_mac_stats
	.get_eth_phy_stats

Only if there remains something uncovered do we start talking about
unstructured stats.

> +};
> +
> +void gsw1xx_remove(struct gsw1xx_priv *priv)
> +{
> +	if (!priv)
> +		return;
> +
> +	/* disable the switch */
> +	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
> +
> +	dsa_unregister_switch(priv->ds);
> +
> +	if (priv->ds->slave_mii_bus) {
> +		mdiobus_unregister(priv->ds->slave_mii_bus);
> +		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
> +		mdiobus_free(priv->ds->slave_mii_bus);
> +	}
> +
> +	dev_set_drvdata(priv->dev, NULL);

dev_set_drvdata() is no longer required from remove().
Please keep it in shutdown() though.

> +}
> +EXPORT_SYMBOL(gsw1xx_remove);
> +static const struct regmap_range gsw1xx_valid_regs[] = {
> +	/* GSWIP Core Registers */
> +	regmap_reg_range(GSW1XX_IP_BASE_ADDR,
> +			 GSW1XX_IP_BASE_ADDR + GSW1XX_IP_REG_LEN),
> +	/* Top Level PDI Registers, MDIO Master Reigsters */

s/Reigsters/Registers/

> +	regmap_reg_range(GSW1XX_MDIO_BASE_ADDR,
> +			 GSW1XX_MDIO_BASE_ADDR + GSW1XX_MDIO_REG_LEN),
> +};
