Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847E83752E9
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhEFLRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhEFLRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:17:22 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DBCC061574;
        Thu,  6 May 2021 04:16:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t18so5184019wry.1;
        Thu, 06 May 2021 04:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ERhyj95+NOCNMd8Kepbci4Mf8xE+AkD2ybfN97GxMe0=;
        b=fzFC8kJtD+pqznq8Qhi7k52XMSfVehiDyWrPSUyTmpkYNWIcMF+a0iGaSfgZZ3qwkk
         T6zp2bey6Yl0hbK48qDN0HXEPsjPo8/AwaROnfCiwZzAFxB2peTp06aN6Yb/JGW0k5oN
         28gF46kwDQ/slhJhKvLjD3QdS72Gnp2dDD66QPpaPSAzi2pc0GAtA6/cSNuUL9g6osM/
         mK37ec5yng9sFFaYn4409RnxpoxRDXpl18FQq7DM29Cqz2bbN20g4tERNuTl/4GHzUad
         V9YdWtSdJ/BGnmkxI/QYCk4pBKleOeEpF7f/qQvYeRM1OKGCPpwjTU2Anw6P2uVOQSPd
         8URg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ERhyj95+NOCNMd8Kepbci4Mf8xE+AkD2ybfN97GxMe0=;
        b=iGMh/lehAOC9+Fxj24U6/uJvjLktsaDqzXGOMB73DzLu8AgtHq6ecjP6MN+tRZ3CY6
         iW6qkXpgcgbPSbx6MwXVW4m6WBYQwB2Z8WLBbifE/cG4w8jTDdzt/pMkbmS5wtG+PuMP
         Wrf6gVLzZdPK3f55CU5tMTp+BFFLZSw2r9ugHUmEb5Y5S0Ra4Q9RScOmShMKp40EK9Yo
         YdnlBwlc5AOB52TSPiAamqYduzxg5reuCknmxSuWlgN1GN8DCWprBFsdHd259VgcyoPf
         6XNmiApaaBiF4E+jBZ6+8ptrBpQYyOrrGZTpdpizZyXrLMnYjuUYC7WXF1ZcRyi1FyYA
         Lp7w==
X-Gm-Message-State: AOAM5339pGQtu4CaYhM7Kr9ynDvwlbODN3vN5ksjvB/i/Nv/whyUGC/R
        6bLmkHBLsBj2QrZTyjsVfk4=
X-Google-Smtp-Source: ABdhPJxF3GT693uMSqRescLpsII83+/XfFM8g9d9zZPERlwj4zFZzM1CU3JH7o2i8n4nHLkOVRvPQA==
X-Received: by 2002:a5d:408f:: with SMTP id o15mr4264885wrp.89.1620299782453;
        Thu, 06 May 2021 04:16:22 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id y21sm9476897wmc.46.2021.05.06.04.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:16:22 -0700 (PDT)
Date:   Thu, 6 May 2021 14:16:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 10/20] net: dsa: qca8k: add priority
 tweak to qca8337 switch
Message-ID: <20210506111620.vqvlvvd57c6yliua@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-10-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-10-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:04AM +0200, Ansuel Smith wrote:
> The port 5 of the ar8337 have some problem in flood condition. The
> original legacy driver had some specific buffer and priority settings
> for the different port suggested by the QCA switch team. Add this
> missing settings to improve switch stability under load condition.
> The packet priority tweak and the rx delay is specific to qca8337.
> Limit this changes to qca8337 as now we also support 8327 switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 54 +++++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/qca8k.h | 24 ++++++++++++++++++
>  2 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 17c6fd4afa7d..9e034c445085 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -783,7 +783,12 @@ static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> +	const struct qca8k_match_data *data;
>  	int ret, i;
> +	u32 mask;
> +
> +	/* get the switches ID from the compatible */
> +	data = of_device_get_match_data(priv->dev);
>  
>  	/* Make sure that port 0 is the cpu port */
>  	if (!dsa_is_cpu_port(ds, 0)) {
> @@ -889,6 +894,45 @@ qca8k_setup(struct dsa_switch *ds)
>  		}
>  	}
>  
> +	if (data->id == QCA8K_ID_QCA8337) {
> +		for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> +			switch (i) {
> +			/* The 2 CPU port and port 5 requires some different
> +			 * priority than any other ports.
> +			 */
> +			case 0:
> +			case 5:
> +			case 6:
> +				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
> +				break;
> +			default:
> +				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
> +					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
> +			}
> +			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
> +
> +			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
> +			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
> +			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
> +			QCA8K_PORT_HOL_CTRL1_WRED_EN;
> +			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
> +				  QCA8K_PORT_HOL_CTRL1_ING_BUF |
> +				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
> +				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
> +				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
> +				  mask);
> +		}

What is this actually doing and why is it needed?

> +	}
> +
>  	/* Setup our port MTUs to match power on defaults */
>  	for (i = 0; i < QCA8K_NUM_PORTS; i++)
>  		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
> @@ -909,9 +953,13 @@ static void
>  qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			 const struct phylink_link_state *state)
>  {
> +	const struct qca8k_match_data *data;
>  	struct qca8k_priv *priv = ds->priv;
>  	u32 reg, val;
>  
> +	/* get the switches ID from the compatible */
> +	data = of_device_get_match_data(priv->dev);
> +
>  	switch (port) {
>  	case 0: /* 1st CPU port */
>  		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> @@ -962,8 +1010,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			    QCA8K_PORT_PAD_RGMII_EN |
>  			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
>  			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> -		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
> -			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
> +		/* QCA8337 requires to set rgmii rx delay */
> +		if (data->id == QCA8K_ID_QCA8337)
> +			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
> +				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);

Why are we looking at an RGMII delay change in a patch about "priority
tweaks"? This patch is very confusing.

>  		break;
>  	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_1000BASEX:
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 86e8d479c9f9..34c5522e7202 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -166,6 +166,30 @@
>  #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
>  #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
>  
> +#define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF		GENMASK(7, 4)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1(x)		((x) << 4)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF		GENMASK(11, 8)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2(x)		((x) << 8)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF		GENMASK(15, 12)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3(x)		((x) << 12)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF		GENMASK(19, 16)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4(x)		((x) << 16)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF		GENMASK(23, 20)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5(x)		((x) << 20)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF		GENMASK(29, 24)
> +#define   QCA8K_PORT_HOL_CTRL0_EG_PORT(x)		((x) << 24)
> +
> +#define QCA8K_REG_PORT_HOL_CTRL1(_i)			(0x974 + (_i) * 0x8)
> +#define   QCA8K_PORT_HOL_CTRL1_ING_BUF			GENMASK(3, 0)
> +#define   QCA8K_PORT_HOL_CTRL1_ING(x)			((x) << 0)
> +#define   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN		BIT(6)
> +#define   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN		BIT(7)
> +#define   QCA8K_PORT_HOL_CTRL1_WRED_EN			BIT(8)
> +#define   QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN		BIT(16)
> +
>  /* Pkt edit registers */
>  #define QCA8K_EGRESS_VLAN(x)				(0x0c70 + (4 * (x / 2)))
>  
> -- 
> 2.30.2
> 
