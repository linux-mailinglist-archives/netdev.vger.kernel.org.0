Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2BE6B9CDF
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjCNRRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCNRRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:17:48 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881379227F;
        Tue, 14 Mar 2023 10:17:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678814206; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Ae7IJ2NJt5XEf6R9b1ZGFMqghp42QiptfRPVqYO48JZPhWyeK8jWW8wQT+su50xYNFJxmMH6qDQZU/OYkpfw+o1lxGe+DLNyASJZfYUV0LlKRtxoDK9ekhVCixJThoS0uda/JDYnTSqLfv/WDsNKBegoC0pKS9HvnGFyBU6L0K0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678814206; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=7FYPsVXMUYBzapQ/og3FA2YuA7WefDgtC1bT+NuRoUY=; 
        b=LuzOzkXeuo5x24mnnU0vqnAGyXrygLtm+4Aa8IR0PNOV0hjcqy29aO1i0u9LZCgFBpWZXpP2ih90mVtR4XHDYXEfZnaEuITQrAUMBeCa5rfEAvR3h8cTpvuRSAtEn2+qzBGD50OYX03pJmLXMJeyBkPrzJMgNxeiI8I8OIuZWy0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678814206;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=7FYPsVXMUYBzapQ/og3FA2YuA7WefDgtC1bT+NuRoUY=;
        b=dD6ZQlTBE7HhHft70RI3QLm5XfENbw9P/mx1gOMNAPmk3KCempzs7WTYEkKiYVHu
        +2Ojaj03TFBT/ZQlXc5aQ9rJAOlqBTlxk02o8U0DS0H7JlAS2wT1cfsCp5fTTymeZX+
        raxaY3WhEVb7Os1KvBXVbTYnhzubm2uDrfVdYitY=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 16788142036435.019579454126301; Tue, 14 Mar 2023 10:16:43 -0700 (PDT)
Message-ID: <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
Date:   Tue, 14 Mar 2023 20:16:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9.03.2023 13:57, Daniel Golle wrote:
> Implement regmap access wrappers, for now only to be used by the
> pcs-mtk driver.
> Make use of external PCS driver and drop the reduntant implementation
> in mt7530.c.
> As a nice side effect the SGMII registers can now also more easily be
> inspected for debugging via /sys/kernel/debug/regmap.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>   drivers/net/dsa/Kconfig  |   1 +
>   drivers/net/dsa/mt7530.c | 277 ++++++++++-----------------------------
>   drivers/net/dsa/mt7530.h |  47 +------
>   3 files changed, 71 insertions(+), 254 deletions(-)
> 
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index f6f3b43dfb06..6b45fa8b6907 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -38,6 +38,7 @@ config NET_DSA_MT7530
>   	tristate "MediaTek MT7530 and MT7531 Ethernet switch support"
>   	select NET_DSA_TAG_MTK
>   	select MEDIATEK_GE_PHY
> +	select PCS_MTK_LYNXI
>   	help
>   	  This enables support for the MediaTek MT7530 and MT7531 Ethernet
>   	  switch chips. Multi-chip module MT7530 in MT7621AT, MT7621DAT,
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 3a15015bc409..582ba30374c8 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -14,6 +14,7 @@
>   #include <linux/of_mdio.h>
>   #include <linux/of_net.h>
>   #include <linux/of_platform.h>
> +#include <linux/pcs/pcs-mtk-lynxi.h>
>   #include <linux/phylink.h>
>   #include <linux/regmap.h>
>   #include <linux/regulator/consumer.h>
> @@ -2567,128 +2568,11 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
>   	return 0;
>   }
>   
> -static void mt7531_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
> -			       phy_interface_t interface, int speed, int duplex)
> -{
> -	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
> -	int port = pcs_to_mt753x_pcs(pcs)->port;
> -	unsigned int val;
> -
> -	/* For adjusting speed and duplex of SGMII force mode. */
> -	if (interface != PHY_INTERFACE_MODE_SGMII ||
> -	    phylink_autoneg_inband(mode))
> -		return;
> -
> -	/* SGMII force mode setting */
> -	val = mt7530_read(priv, MT7531_SGMII_MODE(port));
> -	val &= ~MT7531_SGMII_IF_MODE_MASK;
> -
> -	switch (speed) {
> -	case SPEED_10:
> -		val |= MT7531_SGMII_FORCE_SPEED_10;
> -		break;
> -	case SPEED_100:
> -		val |= MT7531_SGMII_FORCE_SPEED_100;
> -		break;
> -	case SPEED_1000:
> -		val |= MT7531_SGMII_FORCE_SPEED_1000;
> -		break;
> -	}
> -
> -	/* MT7531 SGMII 1G force mode can only work in full duplex mode,
> -	 * no matter MT7531_SGMII_FORCE_HALF_DUPLEX is set or not.
> -	 *
> -	 * The speed check is unnecessary as the MAC capabilities apply
> -	 * this restriction. --rmk
> -	 */
> -	if ((speed == SPEED_10 || speed == SPEED_100) &&
> -	    duplex != DUPLEX_FULL)
> -		val |= MT7531_SGMII_FORCE_HALF_DUPLEX;
> -
> -	mt7530_write(priv, MT7531_SGMII_MODE(port), val);
> -}
> -
>   static bool mt753x_is_mac_port(u32 port)
>   {
>   	return (port == 5 || port == 6);
>   }
>   
> -static int mt7531_sgmii_setup_mode_force(struct mt7530_priv *priv, u32 port,
> -					 phy_interface_t interface)
> -{
> -	u32 val;
> -
> -	if (!mt753x_is_mac_port(port))
> -		return -EINVAL;
> -
> -	mt7530_set(priv, MT7531_QPHY_PWR_STATE_CTRL(port),
> -		   MT7531_SGMII_PHYA_PWD);
> -
> -	val = mt7530_read(priv, MT7531_PHYA_CTRL_SIGNAL3(port));
> -	val &= ~MT7531_RG_TPHY_SPEED_MASK;
> -	/* Setup 2.5 times faster clock for 2.5Gbps data speeds with 10B/8B
> -	 * encoding.
> -	 */
> -	val |= (interface == PHY_INTERFACE_MODE_2500BASEX) ?
> -		MT7531_RG_TPHY_SPEED_3_125G : MT7531_RG_TPHY_SPEED_1_25G;
> -	mt7530_write(priv, MT7531_PHYA_CTRL_SIGNAL3(port), val);
> -
> -	mt7530_clear(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_ENABLE);
> -
> -	/* MT7531 SGMII 1G and 2.5G force mode can only work in full duplex
> -	 * mode, no matter MT7531_SGMII_FORCE_HALF_DUPLEX is set or not.
> -	 */
> -	mt7530_rmw(priv, MT7531_SGMII_MODE(port),
> -		   MT7531_SGMII_IF_MODE_MASK | MT7531_SGMII_REMOTE_FAULT_DIS,
> -		   MT7531_SGMII_FORCE_SPEED_1000);
> -
> -	mt7530_write(priv, MT7531_QPHY_PWR_STATE_CTRL(port), 0);
> -
> -	return 0;
> -}
> -
> -static int mt7531_sgmii_setup_mode_an(struct mt7530_priv *priv, int port,
> -				      phy_interface_t interface)
> -{
> -	if (!mt753x_is_mac_port(port))
> -		return -EINVAL;
> -
> -	mt7530_set(priv, MT7531_QPHY_PWR_STATE_CTRL(port),
> -		   MT7531_SGMII_PHYA_PWD);
> -
> -	mt7530_rmw(priv, MT7531_PHYA_CTRL_SIGNAL3(port),
> -		   MT7531_RG_TPHY_SPEED_MASK, MT7531_RG_TPHY_SPEED_1_25G);
> -
> -	mt7530_set(priv, MT7531_SGMII_MODE(port),
> -		   MT7531_SGMII_REMOTE_FAULT_DIS |
> -		   MT7531_SGMII_SPEED_DUPLEX_AN);
> -
> -	mt7530_rmw(priv, MT7531_PCS_SPEED_ABILITY(port),
> -		   MT7531_SGMII_TX_CONFIG_MASK, 1);
> -
> -	mt7530_set(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_ENABLE);
> -
> -	mt7530_set(priv, MT7531_PCS_CONTROL_1(port), MT7531_SGMII_AN_RESTART);
> -
> -	mt7530_write(priv, MT7531_QPHY_PWR_STATE_CTRL(port), 0);
> -
> -	return 0;
> -}
> -
> -static void mt7531_pcs_an_restart(struct phylink_pcs *pcs)
> -{
> -	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
> -	int port = pcs_to_mt753x_pcs(pcs)->port;
> -	u32 val;
> -
> -	/* Only restart AN when AN is enabled */
> -	val = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
> -	if (val & MT7531_SGMII_AN_ENABLE) {
> -		val |= MT7531_SGMII_AN_RESTART;
> -		mt7530_write(priv, MT7531_PCS_CONTROL_1(port), val);
> -	}
> -}
> -
>   static int
>   mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>   		  phy_interface_t interface)
> @@ -2711,11 +2595,11 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>   		phydev = dp->slave->phydev;
>   		return mt7531_rgmii_setup(priv, port, interface, phydev);
>   	case PHY_INTERFACE_MODE_SGMII:
> -		return mt7531_sgmii_setup_mode_an(priv, port, interface);
>   	case PHY_INTERFACE_MODE_NA:
>   	case PHY_INTERFACE_MODE_1000BASEX:
>   	case PHY_INTERFACE_MODE_2500BASEX:
> -		return mt7531_sgmii_setup_mode_force(priv, port, interface);
> +		/* handled in SGMII PCS driver */
> +		return 0;
>   	default:
>   		return -EINVAL;
>   	}
> @@ -2740,11 +2624,11 @@ mt753x_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
>   
>   	switch (interface) {
>   	case PHY_INTERFACE_MODE_TRGMII:
> +		return &priv->pcs[port].pcs;
>   	case PHY_INTERFACE_MODE_SGMII:
>   	case PHY_INTERFACE_MODE_1000BASEX:
>   	case PHY_INTERFACE_MODE_2500BASEX:
> -		return &priv->pcs[port].pcs;
> -
> +		return priv->ports[port].sgmii_pcs;
>   	default:
>   		return NULL;
>   	}
> @@ -2982,86 +2866,6 @@ static void mt7530_pcs_get_state(struct phylink_pcs *pcs,
>   		state->pause |= MLO_PAUSE_TX;
>   }
>   
> -static int
> -mt7531_sgmii_pcs_get_state_an(struct mt7530_priv *priv, int port,
> -			      struct phylink_link_state *state)
> -{
> -	u32 status, val;
> -	u16 config_reg;
> -
> -	status = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
> -	state->link = !!(status & MT7531_SGMII_LINK_STATUS);
> -	state->an_complete = !!(status & MT7531_SGMII_AN_COMPLETE);
> -	if (state->interface == PHY_INTERFACE_MODE_SGMII &&
> -	    (status & MT7531_SGMII_AN_ENABLE)) {
> -		val = mt7530_read(priv, MT7531_PCS_SPEED_ABILITY(port));
> -		config_reg = val >> 16;
> -
> -		switch (config_reg & LPA_SGMII_SPD_MASK) {
> -		case LPA_SGMII_1000:
> -			state->speed = SPEED_1000;
> -			break;
> -		case LPA_SGMII_100:
> -			state->speed = SPEED_100;
> -			break;
> -		case LPA_SGMII_10:
> -			state->speed = SPEED_10;
> -			break;
> -		default:
> -			dev_err(priv->dev, "invalid sgmii PHY speed\n");
> -			state->link = false;
> -			return -EINVAL;
> -		}
> -
> -		if (config_reg & LPA_SGMII_FULL_DUPLEX)
> -			state->duplex = DUPLEX_FULL;
> -		else
> -			state->duplex = DUPLEX_HALF;
> -	}
> -
> -	return 0;
> -}
> -
> -static void
> -mt7531_sgmii_pcs_get_state_inband(struct mt7530_priv *priv, int port,
> -				  struct phylink_link_state *state)
> -{
> -	unsigned int val;
> -
> -	val = mt7530_read(priv, MT7531_PCS_CONTROL_1(port));
> -	state->link = !!(val & MT7531_SGMII_LINK_STATUS);
> -	if (!state->link)
> -		return;
> -
> -	state->an_complete = state->link;
> -
> -	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
> -		state->speed = SPEED_2500;
> -	else
> -		state->speed = SPEED_1000;
> -
> -	state->duplex = DUPLEX_FULL;
> -	state->pause = MLO_PAUSE_NONE;
> -}
> -
> -static void mt7531_pcs_get_state(struct phylink_pcs *pcs,
> -				 struct phylink_link_state *state)
> -{
> -	struct mt7530_priv *priv = pcs_to_mt753x_pcs(pcs)->priv;
> -	int port = pcs_to_mt753x_pcs(pcs)->port;
> -
> -	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> -		mt7531_sgmii_pcs_get_state_an(priv, port, state);
> -		return;
> -	} else if ((state->interface == PHY_INTERFACE_MODE_1000BASEX) ||
> -		   (state->interface == PHY_INTERFACE_MODE_2500BASEX)) {
> -		mt7531_sgmii_pcs_get_state_inband(priv, port, state);
> -		return;
> -	}
> -
> -	state->link = false;
> -}
> -
>   static int mt753x_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
>   			     phy_interface_t interface,
>   			     const unsigned long *advertising,
> @@ -3081,18 +2885,57 @@ static const struct phylink_pcs_ops mt7530_pcs_ops = {
>   	.pcs_an_restart = mt7530_pcs_an_restart,
>   };
>   
> -static const struct phylink_pcs_ops mt7531_pcs_ops = {
> -	.pcs_validate = mt753x_pcs_validate,
> -	.pcs_get_state = mt7531_pcs_get_state,
> -	.pcs_config = mt753x_pcs_config,
> -	.pcs_an_restart = mt7531_pcs_an_restart,
> -	.pcs_link_up = mt7531_pcs_link_up,
> +static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
> +{
> +	struct mt7530_priv *priv = context;
> +
> +	*val = mt7530_read(priv, reg);
> +	return 0;
> +};
> +
> +static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val)
> +{
> +	struct mt7530_priv *priv = context;
> +
> +	mt7530_write(priv, reg, val);
> +	return 0;
> +};
> +
> +static int mt7530_regmap_update_bits(void *context, unsigned int reg,
> +				     unsigned int mask, unsigned int val)
> +{
> +	struct mt7530_priv *priv = context;
> +
> +	mt7530_rmw(priv, reg, mask, val);
> +	return 0;
> +};
> +
> +static const struct regmap_bus mt7531_regmap_bus = {
> +	.reg_write = mt7530_regmap_write,
> +	.reg_read = mt7530_regmap_read,
> +	.reg_update_bits = mt7530_regmap_update_bits,

These new functions can be used for both switches, mt7530 and mt7531, 
correct? If so, I believe they are supposed to be called mt753x since 
88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a 
new hardware").

mt753x: functions that can be used for mt7530 and mt7531 switches.
mt7530: functions specific to mt7530 switch.
mt7531: functions specific to mt7531 switch.

Arınç
