Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0341A2265
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgDHM5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 08:57:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52540 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgDHM5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 08:57:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id t203so5024167wmt.2;
        Wed, 08 Apr 2020 05:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nweWKGt/Y9aqJqDt7m12iuogEEox3Lo6I1VJwmOK5kg=;
        b=UsegllFbhzQcnMBC84ewwm2sruK4rBm3iMCQaNFZjVv4kjU51yqOLeNics6byPIW2y
         uo0a63WeW78SFjzh6DEcEiMSlFSdwZ8UpzIrDoOBvc0UAXZ5iQnWTWK6FN6vx+D4AEMt
         YEIJzeyzcjCiZ77Jl4D2hze1NwOE/pdrqF2GykAaukokZ8kbNfvkk5F3NFFLFwGDs6V3
         2YLwK+sqc9iSBnTxbOYMi+bAzPULc/drBUmzriVH424aEssHXXDJqpnkUYWi34FrsJY+
         /wflUkwrjvVI9X/MZRAgtB7DDBl3rMYqYG6KO6gbu0VqnZGV/sqWsEikPg2cPBCsGk78
         feMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nweWKGt/Y9aqJqDt7m12iuogEEox3Lo6I1VJwmOK5kg=;
        b=q69uhU0ijknhEskMg4SpWM/uQKqX6rOr7BkqOl6fMX23oA3PuMDlC/5M3XwnqeIdyU
         kcmvmKir76CiEZhsufCzodk/AW9WG4MO56Bl52tlrh4yM2KdD4eFpLnH9vOJwTk/cmhS
         4Lht6pSlWSOYIovv36U5KNct+6CQM+u+AmYTJPkV3Ku/VCUEDaUzNoCnO+XSFwNJhbcA
         xVPXTp0ZbNLmzmhdR5R9ro1Eem33KYKn9/SLNHGF3rEG3M53Cw+3/6LCdcvlYuvHzE04
         Tv1cpd5qcMReUysX5vtHGwoeQKpt3hZq9+zBGuTfpG/VcwRyKFZ1+sS2fxeDnIQR2rWy
         Zzkw==
X-Gm-Message-State: AGi0PubD65zv7/AE1kDWUdiHR6x7xu+jDcE3RxqfvGlf0t54PBtyg/Lr
        Q5SEl3ACsOmXYBnkkZZRjIY=
X-Google-Smtp-Source: APiQypIYPuaBQH2Sypl8dG7VY0eyZ8SGAC0ddIS+37n/2zVl8Y1kCcGA4oFMliNfgqrqx0cFNutx7Q==
X-Received: by 2002:a1c:3281:: with SMTP id y123mr4562289wmy.30.1586350624725;
        Wed, 08 Apr 2020 05:57:04 -0700 (PDT)
Received: from [192.168.1.110] ([77.125.109.57])
        by smtp.gmail.com with ESMTPSA id k3sm6538329wmf.16.2020.04.08.05.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 05:57:04 -0700 (PDT)
Subject: Re: [PATCH RFC v2 16/33] mlx4: add XDP frame size and adjust max XDP
 MTU
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634671560.707275.13938272212851553455.stgit@firesoul>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <6ccf0d63-809e-bd50-c0af-06580ca75745@gmail.com>
Date:   Wed, 8 Apr 2020 15:57:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <158634671560.707275.13938272212851553455.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/8/2020 2:51 PM, Jesper Dangaard Brouer wrote:
> The mlx4 drivers size of memory backing the RX packet is stored in
> frag_stride. For XDP mode this will be PAGE_SIZE (normally 4096).
> For normal mode frag_stride is 2048.
> 
> Also adjust MLX4_EN_MAX_XDP_MTU to take tailroom into account.
> 
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    3 ++-
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c     |    1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> index 43dcbd8214c6..5bd3cd37d50f 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> @@ -51,7 +51,8 @@
>   #include "en_port.h"
>   
>   #define MLX4_EN_MAX_XDP_MTU ((int)(PAGE_SIZE - ETH_HLEN - (2 * VLAN_HLEN) - \
> -				   XDP_PACKET_HEADROOM))
> +				XDP_PACKET_HEADROOM -			    \
> +				SKB_DATA_ALIGN(sizeof(struct skb_shared_info))))
>   
>   int mlx4_en_setup_tc(struct net_device *dev, u8 up)
>   {
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index db3552f2d087..231f08c0276c 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -683,6 +683,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	rcu_read_lock();
>   	xdp_prog = rcu_dereference(ring->xdp_prog);
>   	xdp.rxq = &ring->xdp_rxq;
> +	xdp.frame_sz = priv->frag_info[0].frag_stride;
>   	doorbell_pending = 0;
>   
>   	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
> 
> 

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Thanks.
