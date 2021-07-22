Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C1C3D2DDF
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhGVUBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 16:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhGVUBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 16:01:51 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A64C061575;
        Thu, 22 Jul 2021 13:42:24 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y42so10481946lfa.3;
        Thu, 22 Jul 2021 13:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ARK0i0Bp9fQeNW3MXicGQaonPg0dq6jRH3wg0BWwTn4=;
        b=WZgW4ag53VAMrGXAMpwI9NQ6N4Tip5aqiFghCld6Oy5L3xYIoDAL9uKS3yJTd/k2CQ
         BljcGXsaEqzdb+QRgdDUoonr7naezV07fMpRm0gAX6rRiB/gTNlLsmaZ9/SkiN6Abcmm
         b457Hu4KHBTsytE3WE3iuXhtL6eVEp3oWFboTTPyqgjRWWagEzL5mg2DAqTgPnSvm3eH
         pm3QRtr868U+Pfn3RCmOwQwHu1bMM3HCsojsyXRlxot5uSKUwBWyl9zsUKtv/C0T9Lxm
         RtIOLaaMRLG1W6dqxpK+1no8OeX317K/Vic/7kRkv4c20R562IKjG4Vgh4oLcMwCmYGn
         +F+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARK0i0Bp9fQeNW3MXicGQaonPg0dq6jRH3wg0BWwTn4=;
        b=XAJCusZxQ4k7P/WNQfc2HwYLWhnpNf35hPgGwk3nM03BW1tT9kBnRsaLpHgOanlpco
         dydM+KoK+lwYLz+CwxCnPPKVC7X+V1MP/6kspwSLrBeC1Pg6u+EmQIy8jQ5fJtY2g4GS
         yRWxmroV/meCwQYwabkIjL2gGp4BIEWOZxBZBREK44NjTtl2qpiTcHAcO0DHYXPE8adB
         3Z2BvRVmXkFdG1UvzeuIg89ZgzgChqBiGU/EuvQ/YVaQGQiOK7xVSpl9SVZLlhP0p275
         q3IVRPVurMMnEvmJHkB6ieKeweiy1fOw6obYl28ymZreI36MGsg/vGux6xsC7QMdIlpP
         GhyQ==
X-Gm-Message-State: AOAM530zKUQk2LEwmK1JZRdt511G5ZPfzJLdx8kbLpzJpu61NFTG+Wfw
        TrYwUCSbBJkoa3oEixw3wb4=
X-Google-Smtp-Source: ABdhPJybMvMZkieirq+YPEKqxwh9ShrXQ+Su1cIiIAaLIGKvJ2TT2pLL0bdeaMuM0VCGPWjFAHFpgg==
X-Received: by 2002:a05:6512:30f:: with SMTP id t15mr775906lfp.399.1626986542561;
        Thu, 22 Jul 2021 13:42:22 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.84.209])
        by smtp.gmail.com with ESMTPSA id r15sm3202488ljk.92.2021.07.22.13.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 13:42:22 -0700 (PDT)
Subject: Re: [PATCH net-next 05/18] ravb: Replace chip type with a structure
 for driver data
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
 <20210722141351.13668-6-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <09e06a00-6b9e-c8b8-e5c3-67d82d900a74@gmail.com>
Date:   Thu, 22 Jul 2021 23:42:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-6-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/22/21 5:13 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP is almost similar to
> Ethernet AVB. With few changes in driver we can support both the IP.
> 
> This patch is in preparation for supporting the same by replacing chip
> type by a structure with values, feature bits and function pointers.
> 
> Currently only values is added to structure and later patches will add
> features and function pointers.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 14 +++++
>  drivers/net/ethernet/renesas/ravb_main.c | 76 +++++++++++++++++-------
>  2 files changed, 67 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 80e62ca2e3d3..0ed21262f26b 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -988,6 +988,18 @@ enum ravb_chip_id {
>  	RCAR_GEN3,
>  };
>  
> +struct ravb_drv_data {

   I'd rather suggest *struct* ravb_hw_info... This is hardly a driver data, more like
hwrdware's one. :-)

> +	netdev_features_t net_features;
> +	netdev_features_t net_hw_features;
> +	const char (*gstrings_stats)[ETH_GSTRING_LEN];
> +	size_t gstrings_size;
> +	size_t stats_len;
> +	u32 num_gstat_queue;
> +	size_t skb_sz;
> +	u8 num_tx_desc;
> +	enum ravb_chip_id chip_id;

   Mhm, I'd expect that chip_id is no longer needed with the feature structs... 

[...]
> @@ -1040,6 +1052,8 @@ struct ravb_private {
>  	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
>  	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
>  	int num_tx_desc;		/* TX descriptors per packet */
> +
> +	const struct ravb_drv_data *info;

   So data or info? :-)

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 805397088850..84ebd6fef711 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -1176,9 +1179,12 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
>  
>  static void ravb_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
>  {
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
> +
>  	switch (stringset) {
>  	case ETH_SS_STATS:
> -		memcpy(data, ravb_gstrings_stats, sizeof(ravb_gstrings_stats));
> +		memcpy(data, info->gstrings_stats, info->gstrings_size);
>  		break;
>  	}
>  }
> @@ -1924,12 +1930,36 @@ static int ravb_mdio_release(struct ravb_private *priv)
>  	return 0;
>  }
>  
> +static const struct ravb_drv_data ravb_gen3_data = {
> +	.net_features = NETIF_F_RXCSUM,
> +	.net_hw_features = NETIF_F_RXCSUM,
> +	.gstrings_stats = ravb_gstrings_stats,
> +	.gstrings_size = sizeof(ravb_gstrings_stats),
> +	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),
> +	.num_gstat_queue = NUM_RX_QUEUE,
> +	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,
> +	.num_tx_desc = NUM_TX_DESC_GEN3,
> +	.chip_id = RCAR_GEN3,
> +};
> +
> +static const struct ravb_drv_data ravb_gen2_data = {
> +	.net_features = NETIF_F_RXCSUM,
> +	.net_hw_features = NETIF_F_RXCSUM,

   Mhm, why have the fields that don't change from SoC to SoC anyway?
I do think they should be added when a new SoC support is added...

> +	.gstrings_stats = ravb_gstrings_stats,
> +	.gstrings_size = sizeof(ravb_gstrings_stats),
> +	.stats_len = ARRAY_SIZE(ravb_gstrings_stats),

   Same question...

> +	.num_gstat_queue = NUM_RX_QUEUE,
> +	.skb_sz = RX_BUF_SZ + RAVB_ALIGN - 1,

   Again why?

> +	.num_tx_desc = NUM_TX_DESC_GEN2,
> +	.chip_id = RCAR_GEN2,
> +};
> +
[...]
> @@ -2052,15 +2082,15 @@ static int ravb_probe(struct platform_device *pdev)
>  	if (!ndev)
>  		return -ENOMEM;
>  
> -	ndev->features = NETIF_F_RXCSUM;
> -	ndev->hw_features = NETIF_F_RXCSUM;
> +	info = of_device_get_match_data(&pdev->dev);
> +
> +	ndev->features = info->net_features;
> +	ndev->hw_features = info->net_hw_features;
>  
>  	pm_runtime_enable(&pdev->dev);
>  	pm_runtime_get_sync(&pdev->dev);
>  
> -	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
> -
> -	if (chip_id == RCAR_GEN3)
> +	if (info->chip_id == RCAR_GEN3)

   Ugh...

>  		irq = platform_get_irq_byname(pdev, "ch22");
>  	else
>  		irq = platform_get_irq(pdev, 0);
[...]
> @@ -2099,7 +2130,7 @@ static int ravb_probe(struct platform_device *pdev)
>  	priv->avb_link_active_low =
>  		of_property_read_bool(np, "renesas,ether-link-active-low");
>  
> -	if (chip_id == RCAR_GEN3) {
> +	if (info->chip_id == RCAR_GEN3) {

   Ugh...

>  		irq = platform_get_irq_byname(pdev, "ch24");
>  		if (irq < 0) {
>  			error = irq;
[...]
> @@ -2184,7 +2214,7 @@ static int ravb_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&priv->ts_skb_list);
>  
>  	/* Initialise PTP Clock driver */
> -	if (chip_id != RCAR_GEN2)
> +	if (info->chip_id != RCAR_GEN2)
>  		ravb_ptp_init(ndev, pdev);

   Ugh...

>  
>  	/* Debug message level */
> @@ -2232,7 +2262,7 @@ static int ravb_probe(struct platform_device *pdev)
>  			  priv->desc_bat_dma);
>  
>  	/* Stop PTP Clock driver */
> -	if (chip_id != RCAR_GEN2)
> +	if (info->chip_id != RCAR_GEN2)
>  		ravb_ptp_stop(ndev);

  Ugh...


>  out_disable_refclk:
>  	clk_disable_unprepare(priv->refclk);

MBR, Sergei
