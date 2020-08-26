Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B481E253274
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgHZO4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgHZO4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:56:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7337DC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 07:56:18 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q14so2098404wrn.9
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 07:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g50Mvxau++0Z/x758kbBweP91Vq2ziQSaXSGj8uR10U=;
        b=by/f2qrNImTOjMROOBrQmTdA8EAMnXUJBTAUFwFQi5AS3FzN6MDp30PLX64Prp6WbB
         RiAj67JYCNLmEMuSZ0ZNsRgAXo8bqBTiO+P5iWbH3Djq7UnFZ+3wVW/PAK1x+YtV451Y
         4jQTJ1nF5i8JLAzrdWcFxbABFdiLFcgE1hC31n2tGN+IyOU4ZgxKtNuABcHwt5yZq9R9
         3DVRzwSHDYQ47ZIao7c5JKc0uN6zmM5iHBkf33sQ18Ol00LQB/68+U8ehA3ZCnmdz41K
         ezIn9tjOe/CwL3C9naUUKicMCkcOuvuqoiqsePIBqgSp/XuRB+bO0gT01xadgz/8rNCr
         VtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g50Mvxau++0Z/x758kbBweP91Vq2ziQSaXSGj8uR10U=;
        b=byNb9wGXypfJh33CCkbw4qIKfZOPKQ4KyCQlpdjJFm1kXlooVVPa2GhqEe7SlszE6V
         3CECPJL6NPEvXFlsdqh32lsNteii5o+hf+WvygGd65vMXEA3D0y3+lQXGN1G1JIuwrgv
         JYrozOGz5FEJExTCxRS1MdZ4wuDEUOW0dDi5DbM8206YCXoLr0K/XNPzgevYaxMiOJI/
         i+AyAWEVgfJMdzOHjg5VVI8Df7STUwdl4OTddgD/mO//xGxRVyEMWeaMGf3NpGh05rRz
         enMfA6tl0vOVXxUYFbHmC8ZVdn2sXy4yG3UqtivfjDifFBE6NARKi+cRjphLlMVwl6CG
         MjPQ==
X-Gm-Message-State: AOAM533jceAx1afuFDXpTHw8nhHactk3T9WaOh373iC4P5rD0i4SwQjl
        B95v/2SaJuwrIpfOi5rQrG0=
X-Google-Smtp-Source: ABdhPJw5HycaNNytTUt+XIsQr4qQ2icF2GIgfiwVEBHi5xXuyC/vicHqEjDnq4xPFUp+NtowuIIo6A==
X-Received: by 2002:adf:9ed1:: with SMTP id b17mr15358258wrf.140.1598453777179;
        Wed, 26 Aug 2020 07:56:17 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.17.76])
        by smtp.gmail.com with ESMTPSA id j11sm6013521wrq.69.2020.08.26.07.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 07:56:16 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net/mlx4_en: RX, Add a prefetch command for
 small L1_CACHE_BYTES
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200826125418.11379-1-tariqt@mellanox.com>
 <20200826125418.11379-4-tariqt@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7a5e4514-5c5c-cd7d-6300-ff491f41aefa@gmail.com>
Date:   Wed, 26 Aug 2020 07:55:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826125418.11379-4-tariqt@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/20 5:54 AM, Tariq Toukan wrote:
> A single cacheline might not contain the packet header for
> small L1_CACHE_BYTES values.
> Use net_prefetch() as it issues an additional prefetch
> in this case.
> 
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index b50c567ef508..99d7737e8ad6 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -705,7 +705,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>  
>  		frags = ring->rx_info + (index << priv->log_rx_info);
>  		va = page_address(frags[0].page) + frags[0].page_offset;
> -		prefetchw(va);
> +		net_prefetchw(va);
>  		/*
>  		 * make sure we read the CQE after we read the ownership bit
>  		 */
> 

Why these cache lines would be written next ? Presumably we read the headers (pulled into skb->head)

Really using prefetch() for the about to be read packet is too late anyway for current cpus.

