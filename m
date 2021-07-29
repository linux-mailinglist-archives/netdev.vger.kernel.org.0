Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299743DAB69
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 20:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhG2Sx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 14:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhG2Sx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 14:53:58 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C71DC061765;
        Thu, 29 Jul 2021 11:53:55 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e5so8856714ljp.6;
        Thu, 29 Jul 2021 11:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=saPWFdbQhDgcoKDfNPSitnrQukVgKxBCeC27LbPCX40=;
        b=rikGAln/erLCNIf0VrFi9D1gQ3+0DZQoRl6bHSH6aE2oOHnWm9ztIi/xzbNYx2j50n
         Myar2lUGIaGrnoBUos9uvVDcWKx6RAXQ8GJ/YUpE0Ts1cJj+GWx6R7YFOZ+6U8xLMjzJ
         D04hM8Za0Ae37NRgYV+EsJ12ZqpgNrT1lj+qLdCfOui0wQn0SVLUwpVjE2+LMOfTfCTw
         YbscEKg0FiEggIXXjuCqpWScfDXs8TLMQVYl0HKhTYAPFi6HWkOPnCO9extiEG3IZ9it
         3qre3Aegf9uJtwlTHtMNJCdrqDgYVT9MoKCRh1cnivAiqVi2Xtq+XSzQjCzZ17xob689
         3t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=saPWFdbQhDgcoKDfNPSitnrQukVgKxBCeC27LbPCX40=;
        b=SwOHL8/aKkYMjmE4ee8RqHGr2Loo5T+yNhvr7polEdV/utsObD22ciAo+BgRaoJYbk
         lSENWjKHQrDiBVkLHqZzTOxXQwsr27D+txgjvktI2GgaTgEcg9uJ7VFYmPOwev6044vA
         BKoUt+iV3kEi4H/d+FGb2fPO8s3qtIQbe9WHUdeI6WzS/cBLHoH5ruZwB94HUpt8Hr81
         fi43vUUwG1DigPbiYf0pwVLShSFn82IRecsF4OL0sPK6fKJ0i5wr16Zzniy06p29uekt
         Rrm/h8vWECkWiPsnesJQ1W2FIPVAZX2EFS/mdEIKjnBDeT6qqNnUkzd/FcOcF1lwe8X7
         mGnw==
X-Gm-Message-State: AOAM531unNZX+xCiXmAs2QCFgFeAv6lYN3UPOAkh8XxLFmcbkqor/amL
        ikwFEpY0DzSmRpseGVq/Mds=
X-Google-Smtp-Source: ABdhPJyd8N/qrEd2jMGDm8GbYBYGSHEfTtZTNljjeeolZdAaXVmcrm8Rzyy3T9tbBQpCP8wEbcfISA==
X-Received: by 2002:a2e:760d:: with SMTP id r13mr3885395ljc.437.1627584833589;
        Thu, 29 Jul 2021 11:53:53 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.80.187])
        by smtp.gmail.com with ESMTPSA id o5sm309131lfu.18.2021.07.29.11.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 11:53:53 -0700 (PDT)
Subject: Re: [PATCH net-next 11/18] ravb: Factorise ravb_ring_init function
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
 <20210722141351.13668-12-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <a6728580-11d9-64f5-4c95-32a5a01379ac@gmail.com>
Date:   Thu, 29 Jul 2021 21:53:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-12-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 5:13 PM, Biju Das wrote:

> The ravb_ring_init function uses extended descriptor in rx for
> R-Car and normal descriptor for RZ/G2L. Factorise rx ring buffer
> allocation so that it can support later SoC.

   In this case I think you factored out the function in question... but my ENglish is possibly
too weak. :-)

> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 20 +++++++++++++++-----
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index a3258c5d0c3d..d82bfa6e57c1 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -991,6 +991,7 @@ enum ravb_chip_id {
>  struct ravb_ops {
>  	void (*ring_free)(struct net_device *ndev, int q);
>  	void (*ring_format)(struct net_device *ndev, int q);
> +	bool (*alloc_rx_desc)(struct net_device *ndev, int q);

  Aha, rx_ appears at last! :-)


> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index c23f0d420c70..3d0f6598b936 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -384,6 +384,19 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  }
>  
>  /* Init skb and descriptor buffer for Ethernet AVB */
> +static bool ravb_alloc_rx_desc(struct net_device *ndev, int q)

    Why *bool*? I think we shold just return a pointer allocated.

> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	int ring_size;
> +
> +	ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
> +
> +	priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
> +					      &priv->rx_desc_dma[q],
> +					      GFP_KERNEL);
> +	return priv->rx_ring[q];
> +}
> +
>  static int ravb_ring_init(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -418,11 +431,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  	}
>  
>  	/* Allocate all RX descriptors. */
> -	ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
> -	priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
> -					      &priv->rx_desc_dma[q],
> -					      GFP_KERNEL);
> -	if (!priv->rx_ring[q])
> +	if (!info->ravb_ops->alloc_rx_desc(ndev, q))
>  		goto error;
>  
>  	priv->dirty_rx[q] = 0;
> @@ -2008,6 +2017,7 @@ static int ravb_mdio_release(struct ravb_private *priv)
>  static const struct ravb_ops ravb_gen3_ops = {
>  	.ring_free = ravb_ring_free_rx,
>  	.ring_format = ravb_ring_format_rx,
> +	.alloc_rx_desc = ravb_alloc_rx_desc,
>  };
>  
>  static const struct ravb_drv_data ravb_gen3_data = {
> 

