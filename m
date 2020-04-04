Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA04919E4E0
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgDDMT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 08:19:56 -0400
Received: from mx.0dd.nl ([5.2.79.48]:48138 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDDMT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 08:19:56 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id A81075FC75;
        Sat,  4 Apr 2020 14:19:54 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="FnkcgQFR";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 4CD4627C8BA;
        Sat,  4 Apr 2020 14:19:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 4CD4627C8BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1586002794;
        bh=ctayAcaFI2hlA1UO9mKHsTkEOszfKFOnmNt31e4Np0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FnkcgQFRZELMzJe7wCKoQLLnSJGlZWKvPN6+dQ6pGu2p1AJE439FO+gj7O8yLm2FD
         51WSsVONmjWuhENP5JtBfGcBJstO848Mcr1Su1pN+ntJOfggcmGfly9QsN3BZKd1Wc
         9OsTxvzq6kYNQdnEAmxRJ5pdAEz2EfIYLRB1+Xc51kKwOYVeXgYYbGfOYPDTy5RmUH
         PjfibHRoWN2G1gcctcK8ax45ErcuaBVa/8o/8S04z1+sABIwbHS6UiWiF0+jvbdT+j
         AqRZtxuPtDVw09HjT+mv2mB5UT+9Px5SpXLKJ5cgKNGmQHfJqjp/WwAGPg0XKZ6Ay/
         i05ABzsRQxn9g==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 04 Apr 2020 12:19:54 +0000
Date:   Sat, 04 Apr 2020 12:19:54 +0000
Message-ID: <20200404121954.Horde.D4IT7LfXGUekf9m8q6GWcn4@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     sean.wang@mediatek.com
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, Landen.Chao@mediatek.com,
        steven.liu@mediatek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net 2/2] net: ethernet: mediatek: move mt7623 settings
 out off the mt7530
References: <1585960697-15547-1-git-send-email-sean.wang@mediatek.com>
 <1585960697-15547-2-git-send-email-sean.wang@mediatek.com>
In-Reply-To: <1585960697-15547-2-git-send-email-sean.wang@mediatek.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

See comments below.

Quoting sean.wang@mediatek.com:

> From: René van Dorst <opensource@vdorst.com>
>
> Moving mt7623 logic out off mt7530, is required to make hardware setting
> consistent after we introduce phylink to mtk driver.
>
> Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
> Reviewed-by: Sean Wang <sean.wang@mediatek.com>
> Tested-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 43 ++++++++++++++++++---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  8 ++++
>  2 files changed, 45 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c  
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 8d28f90acfe7..14da599664e6 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -65,6 +65,17 @@ u32 mtk_r32(struct mtk_eth *eth, unsigned reg)
>  	return __raw_readl(eth->base + reg);
>  }
>
> +u32 mtk_m32(struct mtk_eth *eth, u32 mask, u32 set, unsigned reg)
> +{
> +	u32 val;
> +
> +	val = mtk_r32(eth, reg);
> +	val &= ~mask;
> +	val |= set;
> +	mtk_w32(eth, val, reg);
> +	return reg;
> +}
> +
>  static int mtk_mdio_busy_wait(struct mtk_eth *eth)
>  {
>  	unsigned long t_start = jiffies;
> @@ -160,11 +171,21 @@ static int mt7621_gmac0_rgmii_adjust(struct  
> mtk_eth *eth,
>  	return 0;
>  }
>
> -static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth, int speed)
> +static void mtk_gmac0_rgmii_adjust(struct mtk_eth *eth,
> +				   phy_interface_t interface, int speed)
>  {
>  	u32 val;
>  	int ret;
>
> +	if (interface == PHY_INTERFACE_MODE_TRGMII) {
> +		mtk_w32(eth, TRGMII_MODE, INTF_MODE);
> +		val = 500000000;
> +		ret = clk_set_rate(eth->clks[MTK_CLK_TRGPLL], val);
> +		if (ret)
> +			dev_err(eth->dev, "Failed to set trgmii pll: %d\n", ret);
> +		return;
> +	}
> +
>  	val = (speed == SPEED_1000) ?
>  		INTF_MODE_RGMII_1000 : INTF_MODE_RGMII_10_100;
>  	mtk_w32(eth, val, INTF_MODE);
> @@ -193,7 +214,7 @@ static void mtk_mac_config(struct phylink_config  
> *config, unsigned int mode,
>  	struct mtk_mac *mac = container_of(config, struct mtk_mac,
>  					   phylink_config);
>  	struct mtk_eth *eth = mac->hw;
> -	u32 mcr_cur, mcr_new, sid;
> +	u32 mcr_cur, mcr_new, sid, i;
>  	int val, ge_mode, err;
>
>  	/* MT76x8 has no hardware settings between for the MAC */
> @@ -251,10 +272,20 @@ static void mtk_mac_config(struct  
> phylink_config *config, unsigned int mode,
>  							      state->interface))
>  					goto err_phy;
>  			} else {
> -				if (state->interface !=
> -				    PHY_INTERFACE_MODE_TRGMII)
> -					mtk_gmac0_rgmii_adjust(mac->hw,
> -							       state->speed);
> +				mtk_gmac0_rgmii_adjust(mac->hw,
> +						       state->interface,
> +						       state->speed);
> +

As I tried to explain in my email of 27 March.

mtk_gmac0_rgmii_adjust() needs to be modified or split-up!
Russell King pointed out that mtk_gmac0_rgmii_adjust() is using state->speed
variable. This variable may has not the right value so it should not be used
here. Also mtk_gmac0_rgmii_adjust() is only called on a  
state->interface change
not state->speed change.

So can we make this function only dependend on the state->interface and how?

I think in both cases, remove mtk_gmac0_rgmii_adjust() changes in this  
patch and
create a separet patch to fix mtk_gmac0_rgmii_adjust() issue. Would be  
great if
that also complies to the latest PHYLINK api [1]. So that functions that using
state->speed and other related parameters move to mac_link_up(). Similair also
on the mt7530 switch driver [2].

Greats,

René

[1]:  
https://lore.kernel.org/linux-arm-kernel/20200217172242.GZ25745@shell.armlinux.org.uk/
[2]:  
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=1d01145fd659f9f96ede1c34e3bea0ccb558a293

> +				/* mt7623_pad_clk_setup */
> +				for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
> +					mtk_w32(mac->hw,
> +						TD_DM_DRVP(8) | TD_DM_DRVN(8),
> +						TRGMII_TD_ODT(i));
> +
> +				/* Assert/release MT7623 RXC reset */
> +				mtk_m32(mac->hw, 0, RXC_RST | RXC_DQSISEL,
> +					TRGMII_RCK_CTRL);
> +				mtk_m32(mac->hw, RXC_RST, 0, TRGMII_RCK_CTRL);
>  			}
>  		}
>
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h  
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index 85830fe14a1b..454cfcd465fd 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -352,10 +352,13 @@
>  #define DQSI0(x)		((x << 0) & GENMASK(6, 0))
>  #define DQSI1(x)		((x << 8) & GENMASK(14, 8))
>  #define RXCTL_DMWTLAT(x)	((x << 16) & GENMASK(18, 16))
> +#define RXC_RST			BIT(31)
>  #define RXC_DQSISEL		BIT(30)
>  #define RCK_CTRL_RGMII_1000	(RXC_DQSISEL | RXCTL_DMWTLAT(2) | DQSI1(16))
>  #define RCK_CTRL_RGMII_10_100	RXCTL_DMWTLAT(2)
>
> +#define NUM_TRGMII_CTRL		5
> +
>  /* TRGMII RXC control register */
>  #define TRGMII_TCK_CTRL		0x10340
>  #define TXCTL_DMWTLAT(x)	((x << 16) & GENMASK(18, 16))
> @@ -363,6 +366,11 @@
>  #define TCK_CTRL_RGMII_1000	TXCTL_DMWTLAT(2)
>  #define TCK_CTRL_RGMII_10_100	(TXC_INV | TXCTL_DMWTLAT(2))
>
> +/* TRGMII TX Drive Strength */
> +#define TRGMII_TD_ODT(i)	(0x10354 + 8 * (i))
> +#define  TD_DM_DRVP(x)		((x) & 0xf)
> +#define  TD_DM_DRVN(x)		(((x) & 0xf) << 4)
> +
>  /* TRGMII Interface mode register */
>  #define INTF_MODE		0x10390
>  #define TRGMII_INTF_DIS		BIT(0)
> --
> 2.25.1



