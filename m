Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5132B6EAEF9
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbjDUQYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbjDUQYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:24:23 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5F99030;
        Fri, 21 Apr 2023 09:24:20 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pptYN-0001o5-0y;
        Fri, 21 Apr 2023 18:24:07 +0200
Date:   Fri, 21 Apr 2023 17:24:04 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next 04/22] net: dsa: mt7530: improve comments
 regarding port 5 and 6
Message-ID: <ZEK4pIrlA_u69isg@makrotopia.org>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-5-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230421143648.87889-5-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 05:36:30PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There's no logic to numerically order the CPU ports. State the port number
> and its capability of being used as a CPU port instead.
> 
> Remove the irrelevant PHY muxing information from
> mt7530_mac_port_get_caps(). Explain the supported MII modes instead.
> 
> Remove the out of place PHY muxing information from
> mt753x_phylink_mac_config(). The function is for both the MT7530 and MT7531
> switches but there's no PHY muxing on MT7531.
> 
> These comments were gradually introduced with the commits below.
> ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK API")
> 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new
> hardware")
> c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
>  drivers/net/dsa/mt7530.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index edc34be745b2..e956ffa1eea8 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2504,7 +2504,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> +	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
> +		 * delays, mii, and gmii.
> +		 */
>  		phy_interface_set_rgmii(config->supported_interfaces);
>  		__set_bit(PHY_INTERFACE_MODE_MII,
>  			  config->supported_interfaces);
> @@ -2512,7 +2514,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 6: /* 1st cpu port */
> +	case 6: /* Port 6 which can be used as a CPU port supports rgmii and
> +		 * trgmii.
> +		 */
>  		__set_bit(PHY_INTERFACE_MODE_RGMII,
>  			  config->supported_interfaces);
>  		__set_bit(PHY_INTERFACE_MODE_TRGMII,
> @@ -2532,14 +2536,17 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
> +	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
> +		 * delays on MT7531BE, sgmii/802.3z on MT7531AE.
> +		 */
>  		if (!priv->p5_sgmii) {
>  			phy_interface_set_rgmii(config->supported_interfaces);
>  			break;
>  		}
>  		fallthrough;
>  
> -	case 6: /* 1st cpu port supports sgmii/8023z only */
> +	case 6: /* Port 6 which can be used as a CPU port supports sgmii/802.3z.
> +		 */
>  		__set_bit(PHY_INTERFACE_MODE_SGMII,
>  			  config->supported_interfaces);
>  		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
> @@ -2731,7 +2738,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
>  			goto unsupported;
>  		break;
> -	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> +	case 5: /* Port 5, can be used as a CPU port. */
>  		if (priv->p5_interface == state->interface)
>  			break;
>  
> @@ -2741,7 +2748,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		if (priv->p5_intf_sel != P5_DISABLED)
>  			priv->p5_interface = state->interface;
>  		break;
> -	case 6: /* 1st cpu port */
> +	case 6: /* Port 6, can be used as a CPU port. */
>  		if (priv->p6_interface == state->interface)
>  			break;
>  
> -- 
> 2.37.2
> 
