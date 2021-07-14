Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8133C8AB3
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 20:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240029AbhGNSXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 14:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhGNSXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 14:23:23 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A34C06175F;
        Wed, 14 Jul 2021 11:20:31 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t17so5251438lfq.0;
        Wed, 14 Jul 2021 11:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cMGaVysAlMXbtIN347TMOwnpIGxRKHH+sBocFgrr8xE=;
        b=DYmn7DRKhP3ON6h6T+GLVRA5DqBoCKVtAfjfuwlgzniy9ZskjrULaMn83krZLILdOl
         r1GeiPhNavrhwnFJ1dHmlwLLZAok0NuIXrc+MQ1TkuGv6ixuQAsZ5hvVCxSbEjyH5zEe
         hEwphHZmVAKIX50/eOwjBoIzwIMbk4swz2qP8lVgCOlSTeIGBX0QfElXzZHdnusoyO1O
         FH5uWTCnyhV1I8pmBe1Aq/ammIfUKc+Ft2BLb3qVQwVIvwTd2akPzztN9IBv1FZ7MpZm
         2SAB1bkGrXu93LKUj3CUV7xiSVv9qnLRRpPZ/AXSCgHNmlJV7PqCmQ1lnoFU3b1oMqC1
         rjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cMGaVysAlMXbtIN347TMOwnpIGxRKHH+sBocFgrr8xE=;
        b=jzLnjy3bIsodX4qM4ZaRkB+NLJ/mWTZyx7//XmE3VqDDwoI5XxEiSzSXVzoYDlRAjQ
         DKgHKUKf3GcnTyilhf2oY2bWa5+6pW4sCpDPa0/IIOqvkliumkKUkrszZxa3bO0QCTgS
         Nb2edg5jZlq/79LD80vr83S+SoT2BhL4sC/3Shik6/mjQxPqGMXmhs2yQuyYJaWGfGPz
         DEV5RYY3Jn465BJGc1EKIWdA1U8R5KbtbzVMF73XvVF9+x+KriGlhxcX9eKfUcBQt9/q
         57w9zELyHZUeHxClgRL0nh0RVz2BDWBPOrsDZyAyohmJgLYskCzkaH2AgEdztV3c4im5
         7CIQ==
X-Gm-Message-State: AOAM5300uMpDU6taJFZgYS5oD61SajFRzhwDRD2dA33zDIOVd0eR9Cfe
        0Zo1UD3SCaiKOGPB0sDXmUQ=
X-Google-Smtp-Source: ABdhPJzvhe3m5pmOp4I8ON7+5rYe3KjcrjkZAYsDkZb20f+pZZvK3auBae9mHaPasxz8ifh7NqrttQ==
X-Received: by 2002:a05:6512:92d:: with SMTP id f13mr8896651lft.186.1626286829374;
        Wed, 14 Jul 2021 11:20:29 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.80.53])
        by smtp.gmail.com with ESMTPSA id l6sm215585lfe.303.2021.07.14.11.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 11:20:29 -0700 (PDT)
Subject: Re: [PATCH/RFC 1/2] ravb: Preparation for supporting Gigabit Ethernet
 driver
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-2-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <b728e294-b1aa-1275-2b73-d80e6726c083@gmail.com>
Date:   Wed, 14 Jul 2021 21:20:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210714145408.4382-2-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/14/21 5:54 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP is almost
> similar to Ethernet AVB. With few canges in driver we can
> support both the IP. This patch is in preparation for
> supporting the same.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 86a1eb0634e8..80e62ca2e3d3 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -864,7 +864,7 @@ enum GECMR_BIT {
>  
>  /* The Ethernet AVB descriptor definitions. */
>  struct ravb_desc {
> -	__le16 ds;		/* Descriptor size */
> +	__le16 ds;	/* Descriptor size */

    Oops! But this should be a matter of the seperate patch if you want to fix whitespace...

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 4afff320dfd0..7e6feda59f4a 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -217,6 +217,29 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  }
>  
>  /* Free skb's and DMA buffers for Ethernet AVB */
> +static void ravb_ring_free_ex(struct net_device *ndev, int q)

   What does _ex() suffix mean (seems rather poor chice)? Perhaps rx would be better?

> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	int ring_size;
> +	int i;
> +
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
> +
> +		if (!dma_mapping_error(ndev->dev.parent,
> +				       le32_to_cpu(desc->dptr)))
> +			dma_unmap_single(ndev->dev.parent,
> +					 le32_to_cpu(desc->dptr),
> +					 RX_BUF_SZ,
> +					 DMA_FROM_DEVICE);
> +	}
> +	ring_size = sizeof(struct ravb_ex_rx_desc) *
> +		    (priv->num_rx_ring[q] + 1);
> +	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
> +			  priv->rx_desc_dma[q]);
> +	priv->rx_ring[q] = NULL;
> +}
> +
>  static void ravb_ring_free(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
[...]
> @@ -272,26 +281,15 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  }
>  
>  /* Format skb and descriptor buffer for Ethernet AVB */
> -static void ravb_ring_format(struct net_device *ndev, int q)
> +static void ravb_ring_format_ex(struct net_device *ndev, int q)

   Again, what the _ex suffix mean?

[..]
> @@ -396,7 +414,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  }
>  
>  /* E-MAC init function */
> -static void ravb_emac_init(struct net_device *ndev)
> +static void ravb_emac_init_ex(struct net_device *ndev)

   Same question for the 3rd time... :-)

[...]
> @@ -422,29 +440,15 @@ static void ravb_emac_init(struct net_device *ndev)
>  	ravb_write(ndev, ECSIPR_ICDIP | ECSIPR_MPDIP | ECSIPR_LCHNGIP, ECSIPR);
>  }
>  
> +static void ravb_emac_init(struct net_device *ndev)
> +{
> +	ravb_emac_init_ex(ndev);

   Hm, looks pretty useless...

> +}
> +
>  /* Device init function for Ethernet AVB */
> -static int ravb_dmac_init(struct net_device *ndev)
> +static void ravb_dmac_init_ex(struct net_device *ndev)

   4th _ex...

[...]
> @@ -532,7 +561,7 @@ static void ravb_rx_csum(struct sk_buff *skb)
>  }
>  
>  /* Packet receive function for Ethernet AVB */
> -static bool ravb_rx(struct net_device *ndev, int *quota, int q)
> +static bool ravb_rx_ex(struct net_device *ndev, int *quota, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
> @@ -647,6 +676,11 @@ static bool ravb_rx(struct net_device *ndev, int *quota, int q)
>  	return boguscnt <= 0;
>  }
>  
> +static bool ravb_rx(struct net_device *ndev, int *quota, int q)
> +{
> +	return ravb_rx_ex(ndev, quota, q);
> +}
> +

   Looks pretty useless...

[...]
> @@ -920,7 +954,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
>  	if (ravb_rx(ndev, &quota, q))
>  		goto out;
>  
> -	/* Processing RX Descriptor Ring */
> +	/* Processing TX Descriptor Ring */

    Hm, looka like a missing comment fix from the patch refactoring ravb_poll()...

[...]
> @@ -2059,17 +2094,22 @@ static int ravb_probe(struct platform_device *pdev)
>  	if (!ndev)
>  		return -ENOMEM;
>  
> +	/* The Ether-specific entries in the device structure. */
> +	ndev->base_addr = res->start;
> +
> +	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
> +
> +	SET_NETDEV_DEV(ndev, &pdev->dev);
> +
> +	priv = netdev_priv(ndev);
> +	priv->chip_id = chip_id;
> +
>  	ndev->features = NETIF_F_RXCSUM;
>  	ndev->hw_features = NETIF_F_RXCSUM;
>  
>  	pm_runtime_enable(&pdev->dev);
>  	pm_runtime_get_sync(&pdev->dev);
>  
> -	/* The Ether-specific entries in the device structure. */
> -	ndev->base_addr = res->start;
> -
> -	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
> -

   What does that hunk achieve? 

>  	if (chip_id == RCAR_GEN3)
>  		irq = platform_get_irq_byname(pdev, "ch22");
>  	else
[...]
> @@ -2257,7 +2292,7 @@ static int ravb_remove(struct platform_device *pdev)
>  	struct ravb_private *priv = netdev_priv(ndev);
>  
>  	/* Stop PTP Clock driver */
> -	if (priv->chip_id != RCAR_GEN2)
> +	if (priv->chip_id == RCAR_GEN3)
>  		ravb_ptp_stop(ndev);
>  
>  	clk_disable_unprepare(priv->refclk);
> @@ -2362,7 +2397,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
>  	/* Request GTI loading */
>  	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
>  
> -	if (priv->chip_id != RCAR_GEN2)
> +	if (priv->chip_id == RCAR_GEN3)
>  		ravb_set_delay_mode(ndev);

   Probably, all those chip_id check fixes deserve a patch of their own...

MBR, Sergei
