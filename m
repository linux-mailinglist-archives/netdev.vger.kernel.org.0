Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E318069A48F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBQDsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBQDsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:48:40 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7455A3A9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:48:39 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id a27so34773qto.4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9dsPTjCeHzF/D2dbkeBTlIFIo1jUDk52TuQA8VIQp+w=;
        b=HL8ua4jGFD9uvNpXTf0hziGj8Zx6APX57zJFFJDzZVLLTt7zCgN8RlEY1gSrWTE5jo
         VW/Md7LDgSKWmHo9/qbOYoT+sC+tm/okDk/3Tqk25QX3MjsWM4Qwnb3ii4HNykBTtOQy
         0x/BA7TxEPenk5yxfnjhirCVPqD+PKrPjA7Hw/Dl3uxObMk+T2uDeQVvvOf7d2YVBB+f
         5rYGeBC934BuqPnUr4nj9zSQJoPbbQRW3ICfVxvnLzywTjXfheQa5q3kfumXFBTBxSw8
         o7jtmutjfubZOKt02AoGIzmRRr+b4bxv6YKBXrJVK1iLVSSQEHM80Lc86W+we9W4EArt
         JfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9dsPTjCeHzF/D2dbkeBTlIFIo1jUDk52TuQA8VIQp+w=;
        b=FkNcwGED/n6XAtq5yq2Z/r14SdsFafo2SElwYlwcwY5++G7Cvn1vdpQrgWEJ6S2Nkw
         QMXMKZSfY1RftjosJvZHdt6HTCT3dkjfIU/xedXwkto8KMXTUqek3oUtwRFLUstIWsFQ
         knwgBCcrH5WQm1/1GmtSvVeNmBuEaHQO/S43pWqVvluPUgYbqhUVoKRFw9h7vPbAVu71
         qZZK8YTNbpwvOwEWs6gOHPkTMZ4sBwVXSkgNDg8m8Sq/APU0bnhZSn27MXTmuAeeFoS7
         LUnw7i6jHrdtR0T9mOwOX4A1ulK+1n/spaKdNVBgQmMrribXy3U8gmqjc/cL5XM5WwgI
         5kgQ==
X-Gm-Message-State: AO0yUKXedR9DDz5sWMkKXBIODlzeFHCQAGG4t8pxxmUFo4F3eKRvyYH9
        pbDna31eFQTKzCqE3S1V2JE=
X-Google-Smtp-Source: AK7set+qg8d1p34LeB20AHypDEiWajHeNmixHQm2W88a+OFnl8lfJJzktEPXn1VXuFQR0sxyofbMng==
X-Received: by 2002:ac8:7f8f:0:b0:3b8:6db0:7564 with SMTP id z15-20020ac87f8f000000b003b86db07564mr11383038qtj.44.1676605718124;
        Thu, 16 Feb 2023 19:48:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x78-20020a376351000000b006bb82221013sm2130350qkb.0.2023.02.16.19.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 19:48:33 -0800 (PST)
Message-ID: <30ec2581-ab5d-2cf8-e5cb-dc7c99f43d3c@gmail.com>
Date:   Thu, 16 Feb 2023 19:48:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC 09/18] net: genet: Fixup EEE
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
References: <20230217034230.1249661-1-andrew@lunn.ch>
 <20230217034230.1249661-10-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230217034230.1249661-10-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2023 7:42 PM, Andrew Lunn wrote:
> The enabling/disabling of EEE in the MAC should happen as a result of
> auto negotiation. So move the enable/disable into bcmgenet_mii_setup()
> which gets called by phylib when there is a change in link status.
> 
> bcmgenet_set_eee() now just writes the LTI timer value to the hardware
> and stores if TX LPI should be enabled. Everything else is passed to
> phylib, so it can correctly setup the PHY.
> 
> bcmgenet_get_eee() relies on phylib doing most of the work, the MAC
> driver just adds the LTI timer value from hardware and the stored
> tx_lpi_enabled.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

This looks similar to a number of patches for GENET that I need to 
resurrect against net-next, or even submit to net. LGTM at first glance, 
I will give you series a test.

> ---
>   .../net/ethernet/broadcom/genet/bcmgenet.c    | 31 ++++++-------------
>   .../net/ethernet/broadcom/genet/bcmgenet.h    |  1 +
>   drivers/net/ethernet/broadcom/genet/bcmmii.c  |  1 +
>   3 files changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index d937daa8ee88..2793d94ed32c 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -1272,12 +1272,17 @@ static void bcmgenet_get_ethtool_stats(struct net_device *dev,
>   	}
>   }
>   
> -static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
> +void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active)
>   {
>   	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	u32 off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;

Seems unnecessary, yes it does not quite abide by the RCT style, but no 
need to fix that yet.

> +	struct ethtool_eee *p = &priv->eee;
> +	bool enable;
> +	u32 off;
>   	u32 reg;
>   
> +	off = priv->hw_params->tbuf_offset + TBUF_ENERGY_CTRL;
> +	enable = eee_active && p->tx_lpi_enabled;
> +
>   	if (enable && !priv->clk_eee_enabled) {
>   		clk_prepare_enable(priv->clk_eee);
>   		priv->clk_eee_enabled = true;
> @@ -1310,9 +1315,6 @@ static void bcmgenet_eee_enable_set(struct net_device *dev, bool enable)
>   		clk_disable_unprepare(priv->clk_eee);
>   		priv->clk_eee_enabled = false;
>   	}
> -
> -	priv->eee.eee_enabled = enable;
> -	priv->eee.eee_active = enable;
>   }
>   
>   static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
> @@ -1326,8 +1328,7 @@ static int bcmgenet_get_eee(struct net_device *dev, struct ethtool_eee *e)
>   	if (!dev->phydev)
>   		return -ENODEV;
>   
> -	e->eee_enabled = p->eee_enabled;
> -	e->eee_active = p->eee_active;
> +	e->tx_lpi_enabled = p->tx_lpi_enabled;
>   	e->tx_lpi_timer = bcmgenet_umac_readl(priv, UMAC_EEE_LPI_TIMER);
>   
>   	return phy_ethtool_get_eee(dev->phydev, e);
> @@ -1337,7 +1338,6 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
>   {
>   	struct bcmgenet_priv *priv = netdev_priv(dev);
>   	struct ethtool_eee *p = &priv->eee;
> -	int ret = 0;
>   
>   	if (GENET_IS_V1(priv))
>   		return -EOPNOTSUPP;
> @@ -1345,20 +1345,9 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
>   	if (!dev->phydev)
>   		return -ENODEV;
>   
> -	p->eee_enabled = e->eee_enabled;
> +	p->tx_lpi_enabled = e->tx_lpi_enabled;
>   
> -	if (!p->eee_enabled) {
> -		bcmgenet_eee_enable_set(dev, false);
> -	} else {
> -		ret = phy_init_eee(dev->phydev, false);
> -		if (ret) {
> -			netif_err(priv, hw, dev, "EEE initialization failed\n");
> -			return ret;
> -		}
> -
> -		bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
> -		bcmgenet_eee_enable_set(dev, true);
> -	}
> +	bcmgenet_umac_writel(priv, e->tx_lpi_timer, UMAC_EEE_LPI_TIMER);
>   
>   	return phy_ethtool_set_eee(dev->phydev, e);
>   }
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> index 946f6e283c4e..7458a62afc2c 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
> @@ -703,4 +703,5 @@ int bcmgenet_wol_power_down_cfg(struct bcmgenet_priv *priv,
>   void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
>   			       enum bcmgenet_power_mode mode);
>   
> +void bcmgenet_eee_enable_set(struct net_device *dev, bool eee_active);
>   #endif /* __BCMGENET_H__ */
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index b615176338b2..eb1747503c2e 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -100,6 +100,7 @@ void bcmgenet_mii_setup(struct net_device *dev)
>   
>   	if (phydev->link) {
>   		bcmgenet_mac_config(dev);
> +		bcmgenet_eee_enable_set(dev, phydev->eee_active);
>   	} else {
>   		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
>   		reg &= ~RGMII_LINK;

-- 
Florian
