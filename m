Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57D06AC5D2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjCFPqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCFPqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:46:22 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85FE2D14F;
        Mon,  6 Mar 2023 07:45:59 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id i34so40428581eda.7;
        Mon, 06 Mar 2023 07:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678117556;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+agbrQBr9UIR6u+yd/9aPdKOrcjr4SJiOd6RvbJ917E=;
        b=Y77j9wNfCqhsQgS5VtBqGxkr8fNqSRIiwr7uASxDqh41IHEK6k6P0iDCMIQ010xLN8
         8gGCpcmgTFWfiJ61RPep8tFG0/ivQG1G0DByq8/8QDtpvocC4GkMyu04ddS/cWmT/7s5
         06n64qwzdpI34bvi8Pj6WzfCuLgjEmFW1lL5RTSoRz4fVk65VA4E67Cyo7tqAufgQz2U
         E9UvW3OpZaef7UqqVnqAcvGJ1yeVay1LIstSzDk8cIS73hReozWfns/A3W4VRwZEniRh
         zvQqrnG7Bl4V/uGRce4XXabZsWlm40LofmGGxVRT6yVCi9SArylPJDlUqdOH6XchBb28
         zl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678117556;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+agbrQBr9UIR6u+yd/9aPdKOrcjr4SJiOd6RvbJ917E=;
        b=78bRD269mz/8LGKcV1+dZdzg7bzjpfx6NYkY7uJB/hp6z7zVlQw2d4terV44mkajbn
         pbI4R9SGeznrQsQiC1enUToD6Kdxzt9YhBQg+m9t8db3rCITZWGPmmFtEws/pvmwKGi0
         GStyB4f3ftnqXaIo9cmFW5IRBdy202QricYn+zMxtUd0myWmvtktyh0WiNcImnCeaODj
         yyNoAMG723FCuyzwo6eaKA5jR/N2w3MgFDCp6K5C8Xgy+K4HuWHOCe0oYTJy8u4RpSWV
         +EdpCTbPTV2sHx30SO5CJvWysJ38ZmypcWGkAV2bpMcTNjumMVHU7GbOS1471l0KDTNY
         ksaQ==
X-Gm-Message-State: AO0yUKU6hp7PcI3qvs/2ZzyLjlfunqjFPAhnVPghu5O2WfBevPHj14h+
        wL1dC7gSPAUZQpf8I91oeH4=
X-Google-Smtp-Source: AK7set9BlqZGG5uxTwNphRDgJIRMh0nQJIjcZc4FuO0fw/8jOfMKvBhYTdg7oIcUFcf1w1KT+Ji3hw==
X-Received: by 2002:aa7:d513:0:b0:4af:7f6e:297b with SMTP id y19-20020aa7d513000000b004af7f6e297bmr11260638edq.35.1678117555732;
        Mon, 06 Mar 2023 07:45:55 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090643c700b008caaae1f1e1sm4686362ejn.110.2023.03.06.07.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 07:45:55 -0800 (PST)
Date:   Mon, 6 Mar 2023 17:45:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
Message-ID: <20230306154552.26o6sbwf3rfekcyz@skbuf>
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230304125453.53476-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230304125453.53476-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arınç,

On Sat, Mar 04, 2023 at 03:54:54PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Move the PLL setup of the MT7530 switch out of the pad configuration of
> port 6 to mt7530_setup, after reset.

it would have been good if this patch had done that and only that, no?

> This fixes the improper initialisation of the switch when only port 5 is
> used as a CPU port.
> 
> Add supported phy modes of port 5 on the PLL setup.
> 
> Remove now incorrect comment regarding P5 as GMAC5.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
> 
> I'm trying to mimic this change by Alexander [0] for the MT7530 switch.
> This is already the case for MT7530 and MT7531 on the MediaTek ethernet
> driver on U-Boot [1] [2].
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=42bc4fafe359ed6b73602b7a2dba0dd99588f8ce
> [1] https://github.com/u-boot/u-boot/blob/a94ab561e2f49a80d8579930e840b810ab1a1330/drivers/net/mtk_eth.c#L729
> [2] https://github.com/u-boot/u-boot/blob/a94ab561e2f49a80d8579930e840b810ab1a1330/drivers/net/mtk_eth.c#L903
> 
> There are some parts I couldn't figure out myself with my limited C
> knowledge. I've pointed them out on the code. Vladimir, could you help?
> 
> There is a lot of code which is only needed for port 6 or trgmii on port 6,
> but runs whether port 6 or trgmii is used or not. For now, the best I can
> do is to fix port 5 so it works without port 6 being used.
> 
> The U-Boot driver seems to be much more organised so it could be taken as
> a reference to sort out this DSA driver further.
> 
> Also, now that the pad setup for mt7530 is also moved somewhere else, can
> we completely get rid of @pad_setup?
> 
> Arınç

I don't like the strategy you used in this patch here, and I don't want
to answer these questions just yet, because I'm not certain that my
answers will be useful in the end.

> 
> ---
>  drivers/net/dsa/mt7530.c | 46 +++++++++++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 0e99de26d159..fb20ce4f443e 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -395,9 +395,8 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
>  
>  /* Setup TX circuit including relevant PAD and driving */
>  static int
> -mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
> +mt7530_pad_clk_setup(struct mt7530_priv *priv, phy_interface_t interface)
>  {
> -	struct mt7530_priv *priv = ds->priv;
>  	u32 ncpo1, ssc_delta, trgint, i, xtal;
>  
>  	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
> @@ -409,9 +408,32 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>  		return -EINVAL;
>  	}
>  
> +	/* Is setting trgint to 0 really needed for the !trgint check? */
> +	trgint = 0;
> +
> +	/* FIXME: run this switch if p5 is defined on the devicetree */
> +	/* and change interface to the phy-mode of port 5 */
> +	switch (interface) {

so this should be something like priv->p5_interface (assuming this is
initialized by the time mt7530_pad_clk_setup() is called, which it isn't).

> +	case PHY_INTERFACE_MODE_GMII:
> +		/* PLL frequency: 125MHz */
> +		ncpo1 = 0x0c80;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		break;

so with priv->p5_interface == "mii", ncpo1 is uninitialized (will be
potentially still initialized by the port 6 "switch" statement below).

> +	case PHY_INTERFACE_MODE_RGMII:
> +		/* PLL frequency: 125MHz */
> +		ncpo1 = 0x0c80;
> +		break;
> +	default:
> +		dev_err(priv->dev, "xMII interface %d not supported\n",
> +			interface);
> +		return -EINVAL;
> +	}

What method did you use to determine the ncpo1 values here? Are they
coordinated with what p6 wants? I would expect to see a table with

  priv->p5_interface        priv->p6_interface       ncpo1 value
      gmii                     rgmii                     ???
      mii                      rgmii                     ???
      rgmii                    rgmii                     ???
      gmii                     trgmii                    ???
      mii                      trgmii                    ???
      rgmii                    trgmii                    ???

right now, you let the p6_interface logic overwrite the ncpo1 selected
by the p5_interface logic like crazy, and it's not clear to me that this
is what you want.

This problem is way deeper than knowledge of the C language, your pseudo
code simply does not describe what should happen in all combinations.

From our private conversation dated Feb 08, I guess that what you're
doing is also a useless complication and not what you truly want. What
you truly want is for the CORE_GSWPLL_GRP2 register to be programmed
regardless of whether port 6 is used or not.

> +
> +	/* FIXME: run this switch if p6 is defined on the devicetree */
> +	/* and change interface to the phy-mode of port 6 */
>  	switch (interface) {

same comment as above, this should approximate priv->p6_interface.

>  	case PHY_INTERFACE_MODE_RGMII:
> -		trgint = 0;
>  		/* PLL frequency: 125MHz */
>  		ncpo1 = 0x0c80;
>  		break;
> @@ -2172,7 +2194,11 @@ mt7530_setup(struct dsa_switch *ds)
>  		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
>  		     SYS_CTRL_REG_RST);
>  
> -	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
> +	/* Setup switch core pll */
> +	/* FIXME: feed the phy-mode of port 5 and 6, if the ports are defined on the devicetree */
> +	mt7530_pad_clk_setup(priv, interface);

"interface" is completely uninitialized here.

Sorry, I'm not reviewing this any further, because it obviously doesn't work.

> +
> +	/* Enable Port 6 */
>  	val = mt7530_read(priv, MT7530_MHWTRAP);
>  	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
>  	val |= MHWTRAP_MANUAL;
> @@ -2491,11 +2517,9 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  }
>  
>  static int
> -mt753x_pad_setup(struct dsa_switch *ds, const struct phylink_link_state *state)
> +mt7530_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
>  {
> -	struct mt7530_priv *priv = ds->priv;
> -
> -	return priv->info->pad_setup(ds, state->interface);
> +	return 0;
>  }
>  
>  static int
> @@ -2769,8 +2793,6 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		if (priv->p6_interface == state->interface)
>  			break;
>  
> -		mt753x_pad_setup(ds, state);
> -
>  		if (mt753x_mac_config(ds, port, mode, state) < 0)
>  			goto unsupported;
>  
> @@ -3187,7 +3209,7 @@ static const struct mt753x_info mt753x_table[] = {
>  		.phy_write_c22 = mt7530_phy_write_c22,
>  		.phy_read_c45 = mt7530_phy_read_c45,
>  		.phy_write_c45 = mt7530_phy_write_c45,
> -		.pad_setup = mt7530_pad_clk_setup,
> +		.pad_setup = mt7530_pad_setup,
>  		.mac_port_get_caps = mt7530_mac_port_get_caps,
>  		.mac_port_config = mt7530_mac_config,
>  	},
> @@ -3199,7 +3221,7 @@ static const struct mt753x_info mt753x_table[] = {
>  		.phy_write_c22 = mt7530_phy_write_c22,
>  		.phy_read_c45 = mt7530_phy_read_c45,
>  		.phy_write_c45 = mt7530_phy_write_c45,
> -		.pad_setup = mt7530_pad_clk_setup,
> +		.pad_setup = mt7530_pad_setup,

as a general rule, for bug fixes don't touch stuff that you don't need to touch

>  		.mac_port_get_caps = mt7530_mac_port_get_caps,
>  		.mac_port_config = mt7530_mac_config,
>  	},
> -- 
> 2.37.2
> 

Could you please let me know if this patch works, instead of what you've
posted above? It does what you *said* you tried to do, aka it performs
the initialization of CORE_GSWPLL_GRP2 independently of port 6 setup.
There is a slight reordering of register writes with MT7530_P6ECR, but
hopefully that doesn't bother anyone.

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3a15015bc409..a508402c4ecb 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -393,6 +393,24 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 		mt7530_write(priv, MT7530_ATA1 + (i * 4), reg[i]);
 }
 
+/* Set up switch core clock for MT7530 */
+static void mt7530_pll_setup(struct mt7530_priv *priv)
+{
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
+
+	/* Set core clock into 500Mhz */
+	core_write(priv, CORE_GSWPLL_GRP2,
+		   RG_GSWPLL_POSDIV_500M(1) |
+		   RG_GSWPLL_FBKDIV_500M(25));
+
+	/* Enable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1,
+		   RG_GSWPLL_EN_PRE |
+		   RG_GSWPLL_POSDIV_200M(2) |
+		   RG_GSWPLL_FBKDIV_200M(32));
+}
+
 /* Setup TX circuit including relevant PAD and driving */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -453,21 +471,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
 		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	/* Setup core clock for MT7530 */
-	/* Disable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1, 0);
-
-	/* Set core clock into 500Mhz */
-	core_write(priv, CORE_GSWPLL_GRP2,
-		   RG_GSWPLL_POSDIV_500M(1) |
-		   RG_GSWPLL_FBKDIV_500M(25));
-
-	/* Enable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1,
-		   RG_GSWPLL_EN_PRE |
-		   RG_GSWPLL_POSDIV_200M(2) |
-		   RG_GSWPLL_FBKDIV_200M(32));
-
 	/* Setup the MT7530 TRGMII Tx Clock */
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
@@ -2196,6 +2199,8 @@ mt7530_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7530_pll_setup(priv);
+
 	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
-- 
2.34.1

