Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9556EE492
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjDYPPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbjDYPPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:15:48 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0A87ED9;
        Tue, 25 Apr 2023 08:15:46 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1prKO6-0004ZF-0X;
        Tue, 25 Apr 2023 17:15:26 +0200
Date:   Tue, 25 Apr 2023 16:13:36 +0100
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
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 10/24] net: dsa: mt7530: empty default case on
 mt7530_setup_port5()
Message-ID: <ZEfuIHET4Nva0hj4@makrotopia.org>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
 <20230425082933.84654-11-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230425082933.84654-11-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:29:19AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> There're two code paths for setting up port 5:
> 
> mt7530_setup()
> -> mt7530_setup_port5()
> 
> mt753x_phylink_mac_config()
> -> mt753x_mac_config()
>    -> mt7530_mac_config()
>       -> mt7530_setup_port5()
> 
> On the first code path, priv->p5_intf_sel is either set to
> P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4 when mt7530_setup_port5() is run.
> 
> On the second code path, priv->p5_intf_sel is set to P5_INTF_SEL_GMAC5 when
> mt7530_setup_port5() is run.
> 
> Empty the default case which will never run but is needed nonetheless to
> handle all the remaining enumeration values.

If the default: case is really just unreachable code because of the
sound reasoning you presented above, then you should just remove it.

> 
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index aab9ebb54d7d..b3db68d6939a 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -933,9 +933,7 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
>  		val &= ~MHWTRAP_P5_DIS;
>  		break;
>  	default:
> -		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
> -			priv->p5_intf_sel);
> -		goto unlock_exit;
> +		break;

I suppose you can also rather just remove the default: case alltogether
instead of keeping it and making it a no-op.

>  	}
>  
>  	/* Setup RGMII settings */
> @@ -965,7 +963,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
>  	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
>  		val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
>  
> -unlock_exit:
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> -- 
> 2.37.2
> 
