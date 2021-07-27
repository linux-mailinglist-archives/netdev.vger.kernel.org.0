Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED083D7F78
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhG0UtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhG0Us5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:48:57 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CBAC061757;
        Tue, 27 Jul 2021 13:48:56 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id f12so387753ljn.1;
        Tue, 27 Jul 2021 13:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lF7mD1BVxioHFdomMrb2MRtMYijGt5v/snpw5amiNlQ=;
        b=ZjD43cgTjfivt4bHDpq5HvYzL/dIuanOURUGI4JeLB+d4gylPbEUWsFpBEhCEs0a/d
         7+/SQ1owF01STh+s4HjdoX/McTv6W3Vy+iiuYtkvcMWm+H/fSkGvYyEBGCaoWfwfOdLD
         T2Bwa3yQ4uDXjqtR4wtzGl/XVL3dC3bZVhcaa7zPpJ3LUOjiaDdbVoGgb6Pf/4Lp5Jtj
         rc8ybs8imjP291LpOm7Pp7ma+co5ILMANo9DzeUt/Hln+f28tY9dEqO4PEMlPabC4t4J
         L4ZG61DnbQOxBexw94E+KcMX5mG0qufES7JYTy8o6clN9WBmjrJt/iCkFTjA9MOebxnJ
         d0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lF7mD1BVxioHFdomMrb2MRtMYijGt5v/snpw5amiNlQ=;
        b=Ocd3K4PXeUqEiSurVvZhDypBNqjK4FLExXnCI9uv5XfPXmmeTsXd3KFRlQGR0TBPPZ
         1Lrbl2qM1LMYA66/Puo8mPng0QFbqTrXb3uXpgaSRSXAMes0e4cEA+fxihVrLXkShwwl
         Gceg9qKhiBKlh0y/2VDtWjh3FIHXahlje3CD3YbXwSZBSJcqL2kqEVMlXVdA3JmEN4x5
         iB7HnTXqbIuXHMUi/mSXh5pE/0oqkKun4+RY21eG1ZT8wBDt0lX2Mp18LGRgf0RW917F
         yvrnaCer9Uz+oZ/ftZNYdLD2Id1c0II6UeLwa8tmRchtv3DQg/jPsKHY6GrVdxwhHlkR
         R7jg==
X-Gm-Message-State: AOAM531CRWJQfP2zvuIdrKHB7vy8onrziCwZwpHqOsev4bvO3EM7BuqG
        1VGVcAoKU3NSng+8GQggkpY=
X-Google-Smtp-Source: ABdhPJyRlF492gkc3EkRMK9s+uMn4Su0BIzXqPdAzVIB3P41wFNOasqcqcMVHGrrX44f2krVi8To5Q==
X-Received: by 2002:a2e:7e06:: with SMTP id z6mr17020364ljc.394.1627418934371;
        Tue, 27 Jul 2021 13:48:54 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.79.110])
        by smtp.gmail.com with ESMTPSA id i25sm360933ljg.20.2021.07.27.13.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 13:48:54 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH net-next 08/18] ravb: Add R-Car common features
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-9-biju.das.jz@bp.renesas.com>
Message-ID: <d493b1d2-6d05-9eb3-c5f5-f3828938fe56@gmail.com>
Date:   Tue, 27 Jul 2021 23:48:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-9-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/22/21 5:13 PM, Biju Das wrote:

> The below features are supported by both R-Car Gen2 and Gen3.
> 
> 1) magic packet detection
> 2) multiple TSRQ support
> 3) extended descriptor in rx

   I think this one should better be called timestamping...

> 4) No half duplex support

   Couldn't we avoid the "negative" features?

> 5) override mtu change

   Hm, I'd vote for the individual patches covering only single feature...

> Add features bits to support the same.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 110 +++++++++++++++--------
>  1 file changed, 71 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index b3c99f974632..4ef2565534d2 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -680,11 +694,14 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
>  /* function for waiting dma process finished */
>  static int ravb_stop_dma(struct net_device *ndev)
>  {
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
>  	int error;
>  
>  	/* Wait for stopping the hardware TX process */
> -	error = ravb_wait(ndev, TCCR,
> -			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
> +	if (info->features & RAVB_MULTI_TSRQ)
> +		error = ravb_wait(ndev, TCCR,
> +				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
>  	if (error)

   What if the above *if* skips the ravb_wait() call -- didn't you get a complaint from gcc
about the unnintialized variable?

[...]
> @@ -808,11 +826,14 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
>  
>  static bool ravb_timestamp_interrupt(struct net_device *ndev)
>  {
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
>  	u32 tis = ravb_read(ndev, TIS);
>  
>  	if (tis & TIS_TFUF) {
>  		ravb_write(ndev, ~(TIS_TFUF | TIS_RESERVED), TIS);
> -		ravb_get_tx_tstamp(ndev);
> +		if (info->features & RAVB_EX_RX_DESC)

   Yeah, definitely a bad feature name...

> +			ravb_get_tx_tstamp(ndev);
>  		return true;
>  	}
>  	return false;
[...]
> @@ -1069,15 +1091,17 @@ static int ravb_phy_init(struct net_device *ndev)
>  		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
>  	}
>  
> -	/* 10BASE, Pause and Asym Pause is not supported */
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
> +	if (info->features & RAVB_NO_HALF_DUPLEX) {
> +		/* 10BASE, Pause and Asym Pause is not supported */
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
>  
> -	/* Half Duplex is not supported */
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +		/* Half Duplex is not supported */
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);

    Mhm? Some of the half-duplex modes sre unsupported still?

[...]
> @@ -1314,8 +1338,9 @@ static void ravb_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
>  static int ravb_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
>  
> -	if (wol->wolopts & ~WAKE_MAGIC)
> +	if ((wol->wolopts & ~WAKE_MAGIC) || (!(info->features & RAVB_MAGIC)))

   Parens about !x not needed. And I think the second operand should come first instead...

>  		return -EOPNOTSUPP;
>  
>  	priv->wol_enabled = !!(wol->wolopts & WAKE_MAGIC);
[...]
> @@ -1595,28 +1621,30 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  	desc->dptr = cpu_to_le32(dma_addr);
>  
>  	/* TX timestamp required */
> -	if (q == RAVB_NC) {
> -		ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
> -		if (!ts_skb) {
> -			if (num_tx_desc > 1) {
> -				desc--;
> -				dma_unmap_single(ndev->dev.parent, dma_addr,
> -						 len, DMA_TO_DEVICE);
> +	if (info->features & RAVB_EX_RX_DESC) {

   Definitely a bad name...

[...]
> @@ -2205,8 +2235,10 @@ static int ravb_probe(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(priv->refclk);
>  
> -	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> -	ndev->min_mtu = ETH_MIN_MTU;
> +	if (info->features & RAVB_OVERRIDE_MTU_CHANGE) {

   Why? :-/ Could you tell me more details?

> +		ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> +		ndev->min_mtu = ETH_MIN_MTU;
> +	}
>  
>  	priv->num_tx_desc = info->num_tx_desc;
>  

MBR, Sergei
