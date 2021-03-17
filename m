Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FCB33FA69
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhCQVVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhCQVVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 17:21:01 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72128C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 14:21:01 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so3925631pjc.2
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 14:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jcVaxTJq1KTmi0Itq7olQYlCs6IdVefPv3fswiyaRUg=;
        b=PRbfRZNDjpPyFtbwzSCOqAFKTyPJAu+E1nsHyC/c0u51PYWw86DAVPO4pI55fCCZcz
         GEmGj54Bm+Z+QVRtbmiYI2He7jlE5IY1DZc4e6kU44GLtgaXq2b+WkFmvv35ktriqIho
         kO1CFaEinWiY8QlCx9tSGeOc+DU138GSemD69ewW3nsQDv7JGo6KkV/Qh0D9Rf6mfrJu
         xGx8q+xsR7T9KOmaC2bWNKRwPksHFrdyDOvSP9Jt1fOvD9KHodM4ZigqZ/8RehrtdaQc
         oCDpXQ5jl92PuMsTYba90f1Qah8zOZ1qZS8t9YdPSpEr9p15JhE+886qe8z8SH7rKIW2
         8fQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jcVaxTJq1KTmi0Itq7olQYlCs6IdVefPv3fswiyaRUg=;
        b=alOLfr5+onVI/oO5b0EEQb0kLKLpItcIq4B46ayBcuyOk8afeSF6+/mw4Uq/3vC0Bq
         hFbLri5abfolrAf8z5odMO4eunZNia3W0zxQ0s0Rk9J/FkRYGAI1mIEr5xq1ZuJcj9Js
         PeR0hIEddhMgKDPw2yncW4DgRxVkgcupFIzVY/daRznHY6+bn/eMU/CsPzlQ3ko0BJBu
         WC2ayS7e2Br+1E3FOfq/XKqOZvAhWuZRY1QYPnHaKg8PW/u0yXdiRFkM9t8hdlINyvYJ
         IJQaLhSxlYxNgU54Tg9H9nc8SAZbSLsE0FNwZKZwV8IYpY8ZvLN8uxwjikJHjlzmb+XJ
         a1JQ==
X-Gm-Message-State: AOAM532lnjU0tvgN1msOez56Gyu1/7A6SaV7FbK4lITUuP3trWEGkz4z
        Jc7kejasazuRGurxhEv4e2o=
X-Google-Smtp-Source: ABdhPJwyiYo8Zu1Ok3i4iIRkkfP3z4+zaoVAMtwodBroufyJODZsBfF/ZlmB7I02RDk7n4WCbw9MaA==
X-Received: by 2002:a17:902:9b92:b029:e6:b640:ad46 with SMTP id y18-20020a1709029b92b02900e6b640ad46mr6410488plp.56.1616016060800;
        Wed, 17 Mar 2021 14:21:00 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mp21sm71664pjb.16.2021.03.17.14.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 14:21:00 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: bcm_sf2: add function finding RGMII
 register
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210317143706.30809-1-zajec5@gmail.com>
 <20210317143706.30809-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <49f01c3d-7149-299e-d191-7ffdfb975039@gmail.com>
Date:   Wed, 17 Mar 2021 14:20:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317143706.30809-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/2021 7:37 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
> 1. It doesn't validate port argument
> 2. It doesn't support chipsets with non-lineral RGMII regs layout
> 
> Missing port validation could result in getting register offset from out
> of array. Random memory -> random offset -> random reads/writes. It
> affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).

That is entirely fair, however as a bug fix this is not necessarily the
simplest way to approach this.

> 
> Fixes: a78e86ed586d ("net: dsa: bcm_sf2: Prepare for different register layouts")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/dsa/bcm_sf2.c      | 51 ++++++++++++++++++++++++++++++----
>  drivers/net/dsa/bcm_sf2_regs.h |  2 --
>  2 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index ba5d546d06aa..942773bcb7e0 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -32,6 +32,30 @@
>  #include "b53/b53_priv.h"
>  #include "b53/b53_regs.h"
>  
> +static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)

This is not meant to be used outside the file, so I would be keen on
removing the bcm_sf2_ prefix to make the name shorter and closer to the
original macro name.

> +{
> +	switch (priv->type) {
> +	case BCM4908_DEVICE_ID:
> +		/* TODO */
> +		break;
> +	default:
> +		switch (port) {
> +		case 0:
> +			return REG_RGMII_0_CNTRL;
> +		case 1:
> +			return REG_RGMII_1_CNTRL;
> +		case 2:
> +			return REG_RGMII_2_CNTRL;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	WARN_ONCE(1, "Unsupported port %d\n", port);
> +
> +	return 0;

maybe return -1 or -EINVAL just in case 0 happens to be a valid offset
in the future. Checking the return value is not necessarily going to be
helpful as it needs immediate fixing, so what we could do is keep the
WARN_ON, and return the offset of REG_SWITCH_STATUS which is a read-only
register. This will trigger the bus arbiter logic to return an error
because a write was attempted from a read-only register.

What do you think?

> +}
> +
>  /* Return the number of active ports, not counting the IMP (CPU) port */
>  static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
>  {
> @@ -647,6 +671,7 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
>  {
>  	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
>  	u32 id_mode_dis = 0, port_mode;
> +	u32 reg_rgmii_ctrl;
>  	u32 reg;
>  
>  	if (port == core_readl(priv, CORE_IMP0_PRT_ID))
> @@ -670,10 +695,14 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
>  		return;
>  	}
>  
> +	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
> +	if (!reg_rgmii_ctrl)
> +		return;
> +
>  	/* Clear id_mode_dis bit, and the existing port mode, let
>  	 * RGMII_MODE_EN bet set by mac_link_{up,down}
>  	 */
> -	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
> +	reg = reg_readl(priv, reg_rgmii_ctrl);
>  	reg &= ~ID_MODE_DIS;
>  	reg &= ~(PORT_MODE_MASK << PORT_MODE_SHIFT);
>  
> @@ -681,13 +710,14 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
>  	if (id_mode_dis)
>  		reg |= ID_MODE_DIS;
>  
> -	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
> +	reg_writel(priv, reg, reg_rgmii_ctrl);
>  }
>  
>  static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
>  				    phy_interface_t interface, bool link)
>  {
>  	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
> +	u32 reg_rgmii_ctrl;
>  	u32 reg;
>  
>  	if (!phy_interface_mode_is_rgmii(interface) &&
> @@ -695,13 +725,17 @@ static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
>  	    interface != PHY_INTERFACE_MODE_REVMII)
>  		return;
>  
> +	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
> +	if (!reg_rgmii_ctrl)
> +		return;
> +
>  	/* If the link is down, just disable the interface to conserve power */
> -	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
> +	reg = reg_readl(priv, reg_rgmii_ctrl);
>  	if (link)
>  		reg |= RGMII_MODE_EN;
>  	else
>  		reg &= ~RGMII_MODE_EN;
> -	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
> +	reg_writel(priv, reg, reg_rgmii_ctrl);
>  }
>  
>  static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
> @@ -735,8 +769,13 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
>  {
>  	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
>  	struct ethtool_eee *p = &priv->dev->ports[port].eee;
> +	u32 reg_rgmii_ctrl;
>  	u32 reg, offset;
>  
> +	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
> +	if (!reg_rgmii_ctrl)
> +		return;
> +
>  	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
>  
>  	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
> @@ -750,7 +789,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
>  		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
>  		    interface == PHY_INTERFACE_MODE_MII ||
>  		    interface == PHY_INTERFACE_MODE_REVMII) {
> -			reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
> +			reg = reg_readl(priv, reg_rgmii_ctrl);
>  			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
>  
>  			if (tx_pause)
> @@ -758,7 +797,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
>  			if (rx_pause)
>  				reg |= RX_PAUSE_EN;
>  
> -			reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
> +			reg_writel(priv, reg, reg_rgmii_ctrl);
>  		}
>  
>  		reg = SW_OVERRIDE | LINK_STS;
> diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
> index 1d2d55c9f8aa..c7783cb45845 100644
> --- a/drivers/net/dsa/bcm_sf2_regs.h
> +++ b/drivers/net/dsa/bcm_sf2_regs.h
> @@ -48,8 +48,6 @@ enum bcm_sf2_reg_offs {
>  #define  PHY_PHYAD_SHIFT		8
>  #define  PHY_PHYAD_MASK			0x1F
>  
> -#define REG_RGMII_CNTRL_P(x)		(REG_RGMII_0_CNTRL + (x))
> -
>  /* Relative to REG_RGMII_CNTRL */
>  #define  RGMII_MODE_EN			(1 << 0)
>  #define  ID_MODE_DIS			(1 << 1)
> 

-- 
Florian
