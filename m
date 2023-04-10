Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A046DC7E4
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDJOb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDJOb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:31:57 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD5A5264;
        Mon, 10 Apr 2023 07:31:35 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1plsXl-0007Xe-2p;
        Mon, 10 Apr 2023 16:30:54 +0200
Date:   Mon, 10 Apr 2023 15:30:50 +0100
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
Subject: Re: [RFC PATCH v2 net-next 01/14] net: dsa: mt7530: fix comments
 regarding port 5 and 6 for both switches
Message-ID: <ZDQdmih4aHdrUvqr@makrotopia.org>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230407134626.47928-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:46:13PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There's no logic to numerically order the CPU ports. State the port number
> and its being a CPU port instead.

Port 5 is often used as a user port as well, eg. on the BPi-R3 where
it serves to provide SerDes for the 2nd SFP cage.
On other boards (e.g. Netgear WAX-206) it is used to connect a 2.5G
PHY used as WAN port.

Hence just stating that port 5 "a CPU port" could be a bit misleading
as it is not always used as a CPU port.

> 
> Remove the irrelevant PHY muxing information from
> mt7530_mac_port_get_caps(). Explain the supported MII modes instead.
> 
> Remove the out of place PHY muxing information from
> mt753x_phylink_mac_config(). The function is for both the MT7530 and MT7531
> switches but there's no phy muxing on MT7531.
> 
> These comments were gradually introduced with the commits below.
> ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK API")
> 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new
> hardware")
> c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e4bb5037d352..31ef70f0cd12 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2506,7 +2506,7 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> +	case 5: /* Port 5, a CPU port, supports rgmii, mii, and gmii. */
>  		phy_interface_set_rgmii(config->supported_interfaces);
>  		__set_bit(PHY_INTERFACE_MODE_MII,
>  			  config->supported_interfaces);
> @@ -2514,7 +2514,7 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 6: /* 1st cpu port */
> +	case 6: /* Port 6, a CPU port, supports rgmii and trgmii. */
>  		__set_bit(PHY_INTERFACE_MODE_RGMII,
>  			  config->supported_interfaces);
>  		__set_bit(PHY_INTERFACE_MODE_TRGMII,
> @@ -2539,14 +2539,14 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  			  config->supported_interfaces);
>  		break;
>  
> -	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
> +	case 5: /* Port 5, a CPU port, supports rgmii and sgmii/802.3z. */
>  		if (mt7531_is_rgmii_port(priv, port)) {
>  			phy_interface_set_rgmii(config->supported_interfaces);
>  			break;
>  		}
>  		fallthrough;
>  
> -	case 6: /* 1st cpu port supports sgmii/8023z only */
> +	case 6: /* Port 6, a CPU port, supports sgmii/802.3z only. */
>  		__set_bit(PHY_INTERFACE_MODE_SGMII,
>  			  config->supported_interfaces);
>  		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
> @@ -2738,7 +2738,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
>  			goto unsupported;
>  		break;
> -	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
> +	case 5: /* Port 5, a CPU port. */
>  		if (priv->p5_interface == state->interface)
>  			break;
>  
> @@ -2748,7 +2748,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		if (priv->p5_intf_sel != P5_DISABLED)
>  			priv->p5_interface = state->interface;
>  		break;
> -	case 6: /* 1st cpu port */
> +	case 6: /* Port 6, a CPU port. */
>  		if (priv->p6_interface == state->interface)
>  			break;
>  
> -- 
> 2.37.2
> 
