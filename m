Return-Path: <netdev+bounces-1414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F306FDB5A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F87828136B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D22B6FD7;
	Wed, 10 May 2023 10:10:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC1220B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:10:43 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6262180
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:10:40 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-965e93f915aso1114722866b.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683713439; x=1686305439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A+6oHru7C70uRBlUD0hl5QSN+B+mjxZ6Dk4I39zF6EI=;
        b=sUmAeBWpzb3WDh9zH4niy04bUeH+g0ngakgbEfHiKmbsrs3voOBKmVGLtwaV1UDz/w
         5VxEi0oJeAMlc/NIRoGrEu413p9xtc6vGQsYphalKVAoLM1QOoTA64Rg/QiRbGOiI4Ue
         Sgu4lBsUrhuHXw+yKvVml3I+1X1M9mUyW3HXR5lmnCMDDEbzx2kFkIJQixHdsZUnkJUT
         xaan/KNxSPIIvyk/TSnXhE3qNGV2JHEOL20B/aKkgR7F95zX1VWnUSSV656DQdAfg2gd
         pdw1LSM9fWMYsqpgw/ZeUs/1hhb0NYoIIJ8/5YDZ/f1odxe0MB8FctM32Wii6UGGIuVk
         63Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683713439; x=1686305439;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+6oHru7C70uRBlUD0hl5QSN+B+mjxZ6Dk4I39zF6EI=;
        b=RYrFVp+pyDRP94VYmrv+l2wBKVMlVWwK4v70dO8TGjiAr+r52UYaj62oatvFsJfAmB
         XytWAycrYu9/KM5ou8RTZjace2ikR8Q8mEIHDiOATQ9lxAaL7KQC1OQ7Zq6ERMIuho42
         ZefkJ9lJ7GdqRS8gA0udwUOOuHqiwMYmetXeDyHSnkIzFPSiw6LbdYoFBvzKhbZDdEQa
         Kx02Q6P/WZgeWOBd27nsv76j1WkkEmXpc1FAxB79GhqWjKxg05vXnoN5Fk+jU/f3YU2w
         3U4D+KpMKAgrUsVaC/aAgw3JkEV4SXE5NK/2+U2LMA+jxVPw82YsSRWluurrZs98FkCt
         hJ0Q==
X-Gm-Message-State: AC+VfDzoqrMRhnPqTj40cFFreGHG5ePnnpfgKLcsm5q5Aft/IWmFaHHf
	7oLHUXKF6wmFZNjm3xToHhua8A==
X-Google-Smtp-Source: ACHHUZ59S3F8tS4Fb8+6T/WWQrM0r38Q4aXeTYbnbUuCE1kf9BaB9hkpLvkXrFNpewQE0GQOjz5xrg==
X-Received: by 2002:a17:907:1687:b0:958:cc8:bd55 with SMTP id hc7-20020a170907168700b009580cc8bd55mr16959522ejc.0.1683713439248;
        Wed, 10 May 2023 03:10:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c175:a0f9:6928:8c9d? ([2a02:810d:15c0:828:c175:a0f9:6928:8c9d])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906bc4300b0095fde299e83sm2438459ejv.214.2023.05.10.03.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 03:10:38 -0700 (PDT)
Message-ID: <a26c47fc-1915-bfde-2a3d-3902f153892e@linaro.org>
Date: Wed, 10 May 2023 12:10:37 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next V3 3/3] net: axienet: Introduce dmaengine support
Content-Language: en-US
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc: linux@armlinux.org.uk, michal.simek@amd.com, radhey.shyam.pandey@amd.com,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-4-sarath.babu.naidu.gaddam@amd.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230510085031.1116327-4-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10/05/2023 10:50, Sarath Babu Naidu Gaddam wrote:
> Add dmaengine framework to communicate with the xilinx DMAengine
> driver(AXIDMA).
> 
> Axi ethernet driver uses separate channels for transmit and receive.
> Add support for these channels to handle TX and RX with skb and
> appropriate callbacks. Also add axi ethernet core interrupt for



> +/**
> + * axienet_setup_dma_chan - request the dma channels.
> + * @ndev:       Pointer to net_device structure
> + *
> + * Return: 0, on success.
> + *          non-zero error value on failure
> + *
> + * This function requests the TX and RX channels. It also submits the
> + * allocated skb buffers and call back APIs to dmaengine.
> + *
> + */
> +static int axienet_setup_dma_chan(struct net_device *ndev)
> +{
> +	struct axienet_local *lp = netdev_priv(ndev);
> +	int i, ret;
> +
> +	lp->tx_chan = dma_request_chan(lp->dev, "tx_chan0");
> +	if (IS_ERR(lp->tx_chan)) {
> +		ret = PTR_ERR(lp->tx_chan);
> +		if (ret != -EPROBE_DEFER)
> +			netdev_err(ndev, "No Ethernet DMA (TX) channel found\n");

dev_err_probe seems suitable here.


> +		return ret;
> +	}
> +
> +	lp->rx_chan = dma_request_chan(lp->dev, "rx_chan0");
> +	if (IS_ERR(lp->rx_chan)) {
> +		ret = PTR_ERR(lp->rx_chan);
> +		if (ret != -EPROBE_DEFER)
> +			netdev_err(ndev, "No Ethernet DMA (RX) channel found\n");

dev_err_probe

> +		goto err_dma_request_rx;
> +	}
> +	lp->skb_cache = kmem_cache_create("ethernet", sizeof(struct axi_skbuff),
> +					  0, 0, NULL);
> +	if (!lp->skb_cache) {
> +		ret =  -ENOMEM;
> +		goto err_kmem;
> +	}
> +	/* TODO: Instead of BD_NUM_DEFAULT use runtime support*/
> +	for (i = 0; i < RX_BUF_NUM_DEFAULT; i++)
> +		axienet_rx_submit_desc(ndev);
> +	dma_async_issue_pending(lp->rx_chan);
> +
> +	return 0;
> +err_kmem:
> +	dma_release_channel(lp->rx_chan);
> +err_dma_request_rx:
> +	dma_release_channel(lp->tx_chan);
> +	return ret;
> +}
> +
> +/**
> + * axienet_init_dmaengine - init the dmaengine code.
> + * @ndev:       Pointer to net_device structure
> + *
> + * Return: 0, on success.
> + *          non-zero error value on failure
> + *
> + * This is the dmaengine initialization code.
> + */
> +static inline int axienet_init_dmaengine(struct net_device *ndev)
> +{
> +	int ret;
> +
> +	ret = axienet_setup_dma_chan(ndev);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  /**
>   * axienet_init_legacy_dma - init the dma legacy code.
>   * @ndev:       Pointer to net_device structure
> @@ -1239,7 +1520,20 @@ static int axienet_open(struct net_device *ndev)
>  
>  	phylink_start(lp->phylink);
>  
> -	if (!AXIENET_USE_DMA(lp)) {
> +	if (AXIENET_USE_DMA(lp)) {
> +		ret = axienet_init_dmaengine(ndev);
> +		if (ret < 0)
> +			goto error_code;
> +
> +		/* Enable interrupts for Axi Ethernet core (if defined) */
> +		if (lp->eth_irq > 0) {
> +			ret = request_irq(lp->eth_irq, axienet_eth_irq, IRQF_SHARED,
> +					  ndev->name, ndev);
> +			if (ret)
> +				goto error_code;
> +		}
> +
> +	} else {
>  		ret = axienet_init_legacy_dma(ndev);
>  		if (ret)
>  			goto error_code;
> @@ -1287,6 +1581,12 @@ static int axienet_stop(struct net_device *ndev)
>  		free_irq(lp->tx_irq, ndev);
>  		free_irq(lp->rx_irq, ndev);
>  		axienet_dma_bd_release(ndev);
> +	} else {
> +		dmaengine_terminate_all(lp->tx_chan);
> +		dmaengine_terminate_all(lp->rx_chan);
> +
> +		dma_release_channel(lp->rx_chan);
> +		dma_release_channel(lp->tx_chan);
>  	}
>  
>  	axienet_iow(lp, XAE_IE_OFFSET, 0);
> @@ -2136,6 +2436,33 @@ static int axienet_probe(struct platform_device *pdev)
>  		}
>  		netif_napi_add(ndev, &lp->napi_rx, axienet_rx_poll);
>  		netif_napi_add(ndev, &lp->napi_tx, axienet_tx_poll);
> +	} else {
> +		struct xilinx_vdma_config cfg;
> +		struct dma_chan *tx_chan;
> +
> +		lp->eth_irq = platform_get_irq_optional(pdev, 0);
> +		tx_chan = dma_request_chan(lp->dev, "tx_chan0");
> +
> +		if (IS_ERR(tx_chan)) {
> +			ret = PTR_ERR(tx_chan);
> +			if (ret != -EPROBE_DEFER)
> +				dev_err(&pdev->dev, "No Ethernet DMA (TX) channel found\n");

dev_err_probe

Best regards,
Krzysztof


