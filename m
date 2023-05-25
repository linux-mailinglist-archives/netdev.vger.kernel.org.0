Return-Path: <netdev+bounces-5349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9A2D710E99
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EF66281180
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422E6156EB;
	Thu, 25 May 2023 14:51:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B26E576
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:51:24 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505EEE5B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:51:10 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30948709b3cso1480221f8f.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685026265; x=1687618265;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeijlDecbtktn6DXqwJPUuO+lbWfB3mfxW4GJePGozU=;
        b=leeLU24eKgDk9tDVaPvkhO3LvZqnDKhYs8alEciN0wXJlg9E2v42M9qATllt0Lg1UC
         yvlcy9n5Y6XydTvDdjGC5MW226IrCii+F1My0DZkGz10kUdvzCeOE952pxEJGwvYs8AA
         onQvVLL7S5kVje2321ayQcYYWZUZBAQF5wbWyMoNEBWGpvu0ROOUS9WuXD21TMGTb6+U
         s0zR+1pBJw1yJ28hhCi4pgCHXq9f057vHh3WhhrjHFkkjau/X+U57rQNRxPA7Hlprxy2
         Aspe8Bw3Um9NdSY33ZTMRikCqtLmH+wVSleQKRQapU3p6MAWI32ArIoPFoFVgXQMPCrs
         Dlug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685026265; x=1687618265;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KeijlDecbtktn6DXqwJPUuO+lbWfB3mfxW4GJePGozU=;
        b=MbCOkK8nOSFH+KailoBO1MXh97qpYo5FHFk1FiLV6h8pcMQ0fxH18GUFpfWl4rJ4V2
         JLvoWhMnXsqFr3DVbwjwKhglBVZXy5dANMq+p73rDkIxI/cmw9vsFgEcGDG36QsTQ1q4
         yvySfG8aXywr6OOx4hBrpEWs55diQL9U7iGDf9y3rBWm5gVabM8d2PFxJ8ME+WXaZREF
         kcpCrFpIQXKWB98PjFllAMuhqf1pA1LlvJaLyhNR1/LMg8SnmxpEkiJCzie2GxwM6mYJ
         +LvZhWwk8ReLdpJDlw7AlltEN6SBL/WjU8mApax/hI+ujE5SoPVnsMvze8WqEsfpd5KA
         Fn8Q==
X-Gm-Message-State: AC+VfDz4qXRxe1E2JNluB8iU+iRG8HHmaQCG7nvUHpu8hrPYng32KLvO
	iWlDHUNT/SfflIncMidNS6g=
X-Google-Smtp-Source: ACHHUZ6woI+EN7RDsZ3dAI3iDy5+w4lPBDxRufoIatNofpEIRocEDj6t3QgfXFKkM4azZ5tZTVrjYA==
X-Received: by 2002:adf:f049:0:b0:30a:aeb0:910d with SMTP id t9-20020adff049000000b0030aaeb0910dmr2781521wro.44.1685026265293;
        Thu, 25 May 2023 07:51:05 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id i13-20020a5d522d000000b00307c8d6b4a0sm2058393wra.26.2023.05.25.07.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 May 2023 07:51:04 -0700 (PDT)
Subject: Re: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting
 the channels
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, habetsm.xilinx@gmail.com
References: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <40d9d9b9-0500-2c68-c047-20b1a090c0bf@gmail.com>
Date: Thu, 25 May 2023 15:51:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24/05/2023 10:36, Pieter Jansen van Vuuren wrote:
> When fewer VIs are allocated than what is allowed we can readjust
> the channels by calling efx_mcdi_alloc_vis() again.
> 
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
though see below for one nit (fix in a follow-up?)

> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index d916877b5a9a..c201e001f3b8 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -40,19 +40,26 @@ static int ef100_alloc_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>  	unsigned int tx_vis = efx->n_tx_channels + efx->n_extra_tx_channels;
>  	unsigned int rx_vis = efx->n_rx_channels;
>  	unsigned int min_vis, max_vis;
> +	int rc;
>  
>  	EFX_WARN_ON_PARANOID(efx->tx_queues_per_channel != 1);
>  
>  	tx_vis += efx->n_xdp_channels * efx->xdp_tx_per_channel;
>  
>  	max_vis = max(rx_vis, tx_vis);
> -	/* Currently don't handle resource starvation and only accept
> -	 * our maximum needs and no less.
> +	/* We require at least a single complete TX channel worth of queues. */
> +	min_vis = efx->tx_queues_per_channel;
> +
> +	rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
> +				NULL, allocated_vis);

I'd like a check here like
    if (rc == -EAGAIN)
            rc = -ESOMETHINGELSE;
 just to avoid confusion if the MC or MCDI machinery returns EAGAIN
 for whatever reason.
Or perhaps better still, don't overload EAGAIN like this and instead
 have this function return 1 in the "we succeeded but didn't get
 max_vis" case (would need a comment above the function, documenting
 this), since that's not a value that can happen in-band.

-ed

