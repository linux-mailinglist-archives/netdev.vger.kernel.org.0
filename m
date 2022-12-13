Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42764B19B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiLMI4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbiLMI4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:56:17 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04239F4;
        Tue, 13 Dec 2022 00:56:16 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id a16so16714308edb.9;
        Tue, 13 Dec 2022 00:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e6Z3+Ru5Hns8lMMMOwhQFZXE5Nu44PgsT6yMgMnKR64=;
        b=WVsPe78yuf+qG8m3haEyg1F4WXQKZRDAGiSJqxo6oJKonl4VQF4eZt6YVRGyhs9UD8
         dWVWGAhiUYBj3y5laMajYeDIMfhQt0sFAR6oR7rmqgtBxL/hBeNJfNQNoSfK40Dj+/Vu
         lSrpKWgZozeVbOE8RFeB59Ce5QyNoa0JuzJyjHzp8/q2G04KYrGBhbiEghDI9OnzNG3C
         32eF0aQnBhJciq4XX76R/d2A5yVCmlbiT7oiBrx8NtbsnbVNR7WIcBlyQEcJFlURDPtu
         1EntrWN0zMagdW92QY1++GbBc4uE7BplxWPDKULFndWvL/U2+jqEMNn6WSVFXkiAfUFO
         Ozzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e6Z3+Ru5Hns8lMMMOwhQFZXE5Nu44PgsT6yMgMnKR64=;
        b=lpW+xbpz+T9XK7yUp1MoHuyD28TZlBd/8Vln8OtTlewbrS1hLb13E4fUxBz3R4rADX
         SxxsK6Jhw8LX7bpXVAP6vk8+HGfoUOTvzIv+0xSOWMtXncmQyLnwNh5YtqT7p1UqlibR
         1U+KzHh1JWACm8g/LGKqlS94/vy+SKwt+/j6DyVbbS15E0rReOJdC9U3kSEMA552Ifr/
         Mh6u7ogmUYHscD0VI8R9OY500PuuNbmqgeEOkvoynFRE9o54/eIvwpfC5uT82cH0y8rB
         3vrhjhk63folYAngeQZHwrGAMI0toXTLSEeKeAdS2IVoZSvQ1ILW13IZXgmAk1oveXLw
         wCzg==
X-Gm-Message-State: ANoB5plBeojoe4PD6SMYrRpg5kURD3wXdqGO6HMYEfbesUPOjeDWDLhs
        VyD55HgKN/UJw25lce2hkzQ=
X-Google-Smtp-Source: AA0mqf7TGl/+z/W0YQnqXsZeUZCW6dtBlZNFJdG55lPg/hpwBJYQFXoh6QmaMkGxGGO+CaCttAzipg==
X-Received: by 2002:a05:6402:4006:b0:46c:d5e8:30e4 with SMTP id d6-20020a056402400600b0046cd5e830e4mr19108311eda.23.1670921774440;
        Tue, 13 Dec 2022 00:56:14 -0800 (PST)
Received: from [192.168.1.115] ([77.124.106.18])
        by smtp.gmail.com with ESMTPSA id o10-20020aa7d3ca000000b004701c6a403asm891754edr.86.2022.12.13.00.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 00:56:13 -0800 (PST)
Message-ID: <ea04a91b-a6bc-ff5f-cbac-5d342a9b2d93@gmail.com>
Date:   Tue, 13 Dec 2022 10:56:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH bpf-next v4 10/15] net/mlx4_en: Introduce wrapper for
 xdp_buff
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-11-sdf@google.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221213023605.737383-11-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/2022 4:36 AM, Stanislav Fomichev wrote:
> No functional changes. Boilerplate to allow stuffing more data after xdp_buff.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 26 +++++++++++++---------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 8f762fc170b3..014a80af2813 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -661,9 +661,14 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>   #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
>   #endif
>   
> +struct mlx4_en_xdp_buff {
> +	struct xdp_buff xdp;
> +};
> +
>   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
> +	struct mlx4_en_xdp_buff mxbuf = {};
>   	int factor = priv->cqe_factor;
>   	struct mlx4_en_rx_ring *ring;
>   	struct bpf_prog *xdp_prog;
> @@ -671,7 +676,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	bool doorbell_pending;
>   	bool xdp_redir_flush;
>   	struct mlx4_cqe *cqe;
> -	struct xdp_buff xdp;
>   	int polled = 0;
>   	int index;
>   
> @@ -681,7 +685,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	ring = priv->rx_ring[cq_ring];
>   
>   	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
> -	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
> +	xdp_init_buff(&mxbuf.xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
>   	doorbell_pending = false;
>   	xdp_redir_flush = false;
>   
> @@ -776,24 +780,24 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   						priv->frag_info[0].frag_size,
>   						DMA_FROM_DEVICE);
>   
> -			xdp_prepare_buff(&xdp, va - frags[0].page_offset,
> +			xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
>   					 frags[0].page_offset, length, false);
> -			orig_data = xdp.data;
> +			orig_data = mxbuf.xdp.data;
>   
> -			act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
>   
> -			length = xdp.data_end - xdp.data;
> -			if (xdp.data != orig_data) {
> -				frags[0].page_offset = xdp.data -
> -					xdp.data_hard_start;
> -				va = xdp.data;
> +			length = mxbuf.xdp.data_end - mxbuf.xdp.data;
> +			if (mxbuf.xdp.data != orig_data) {
> +				frags[0].page_offset = mxbuf.xdp.data -
> +					mxbuf.xdp.data_hard_start;
> +				va = mxbuf.xdp.data;
>   			}
>   
>   			switch (act) {
>   			case XDP_PASS:
>   				break;
>   			case XDP_REDIRECT:
> -				if (likely(!xdp_do_redirect(dev, &xdp, xdp_prog))) {
> +				if (likely(!xdp_do_redirect(dev, &mxbuf.xdp, xdp_prog))) {
>   					ring->xdp_redirect++;
>   					xdp_redir_flush = true;
>   					frags[0].page = NULL;

Thanks for your patches.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
