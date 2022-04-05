Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3E14F30F8
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbiDEIjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiDEIYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:24:43 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59719FD1;
        Tue,  5 Apr 2022 01:20:13 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso1082110wma.0;
        Tue, 05 Apr 2022 01:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IkFQfkILQILc0jtuFNwSXWZAcJp9B6qZC4/E7e4YQGw=;
        b=ECSiUL8yl3G5wydmrRZSGrWdrfaMxOoijJK1JN7M0wI2MhM+j2zujXCFFttZOM6+mt
         KPX/mqiYRSgYJmNj8GRb/XDtndg5j+G4ui3d90JO3ADwDZOb53G2sZc8MQNUZjmW+0yb
         1Ri33ZcO/tpT0sxrTqo5TN3Qgz/x6mThFWi+uUwsyLJfBkfPcvmRTsO9749RicO7qmxx
         C2Ym3rk93k04wqLPu+HDaLIlXVEpZG/VjDxg0l8SWRxnVfvn/ay+TF6a5wv1lFasr71V
         pmWAHRGEDGuno0A9xpAupcO83a1nCRSvclNcEqIr1c9J3HQVQBoubpSAXSaMRcBHDzAp
         kqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=IkFQfkILQILc0jtuFNwSXWZAcJp9B6qZC4/E7e4YQGw=;
        b=UTIIee9k5NrwIiBL+yqAJe0ZbGOCvJDcJ8rHYoyzvV8XbhkUzwlNSbpxoA8j44YaBC
         r05ybxxi4isuLVPOmhevwagYqW7VATm0CFt89Yiz/9wQ4Cd8c0Xmzmt7+by3gLHMPNOF
         1voXY5Cs/5+DKxr5BBIIdgbOYW7mMzwLFsEq0xovQRfweuOYwfbSgWUBAE0wrNIHagx7
         zgP+TbTR+RovhkAAxH4zosOkwW3ChYDAOWoMjiH7evqHnm5HQIpjW2klwQ/P1fSpxqBp
         8hjvT614XeSOuME151MUli5dH8kNT4OFe6Ay2gGPuq1CsWUEfIov9J5I8M2Yh8+N6KQW
         Msvg==
X-Gm-Message-State: AOAM533Ilu0vx4fZYEZ1/yT15EZkhkUzMuXRWvxS3AFqK6TFASt6JLov
        aL4S8xIPWl3m1OF46fZ3rFQ=
X-Google-Smtp-Source: ABdhPJwPK1pVic5P2+m205Ryh5gl+ihBTiXPfMQUeEoNYcZhHrcx+RVWqj0rp2kG1yHPT8alF/TjkA==
X-Received: by 2002:a05:600c:35cc:b0:38c:6d25:f4ad with SMTP id r12-20020a05600c35cc00b0038c6d25f4admr1919669wmq.127.1649146812272;
        Tue, 05 Apr 2022 01:20:12 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id e1-20020a5d5001000000b0020611591990sm5132727wrt.71.2022.04.05.01.20.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Apr 2022 01:20:11 -0700 (PDT)
Date:   Tue, 5 Apr 2022 09:20:09 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com, bpf@vger.kernel.org
Subject: Re: [PATCH net] net: sfc: fix using uninitialized xdp tx_queue
Message-ID: <20220405082009.sgxozrdssoypaw7h@gmail.com>
Mail-Followup-To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com, bpf@vger.kernel.org
References: <20220405050019.12260-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405050019.12260-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taehee,

On Tue, Apr 05, 2022 at 05:00:19AM +0000, Taehee Yoo wrote:
> In some cases, xdp tx_queue can get used before initialization.
> 1. interface up/down
> 2. ring buffer size change
> 
> When CPU cores are lower than maximum number of channels of sfc driver,
> it creates new channels only for XDP.
> 
> When an interface is up or ring buffer size is changed, all channels
> are initialized.
> But xdp channels are always initialized later.
> So, the below scenario is possible.
> Packets are received to rx queue of normal channels and it is acted
> XDP_TX and tx_queue of xdp channels get used.
> But these tx_queues are not initialized yet.
> If so, TX DMA or queue error occurs.
> 
> In order to avoid this problem
> 1. initializes xdp tx_queues earlier than other rx_queue in
> efx_start_channels().
> 2. checks whether tx_queue is initialized or not in efx_xdp_tx_buffers().
> 
> Splat looks like:
>    sfc 0000:08:00.1 enp8s0f1np1: TX queue 10 spurious TX completion id 250
>    sfc 0000:08:00.1 enp8s0f1np1: resetting (RECOVER_OR_ALL)
>    sfc 0000:08:00.1 enp8s0f1np1: MC command 0x80 inlen 100 failed rc=-22
>    (raw=22) arg=789
>    sfc 0000:08:00.1 enp8s0f1np1: has been disabled
> 
> Fixes: dfe44c1f52ee ("sfc: handle XDP_TX outcomes of XDP eBPF programs")

A better fixes tag for this might be
f28100cb9c96 ("sfc: fix lack of XDP TX queues - error XDP TX failed (-22)")
as it enabled XDP in more situations.

> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 2 +-
>  drivers/net/ethernet/sfc/tx.c           | 3 +++
>  drivers/net/ethernet/sfc/tx_common.c    | 2 ++
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index 83e27231fbe6..377df8b7f015 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -1140,7 +1140,7 @@ void efx_start_channels(struct efx_nic *efx)
>  	struct efx_rx_queue *rx_queue;
>  	struct efx_channel *channel;
>  
> -	efx_for_each_channel(channel, efx) {
> +	efx_for_each_channel_rev(channel, efx) {
>  		efx_for_each_channel_tx_queue(tx_queue, channel) {
>  			efx_init_tx_queue(tx_queue);
>  			atomic_inc(&efx->active_queues);
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index d16e031e95f4..6983799e1c05 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
>  	if (unlikely(!tx_queue))
>  		return -EINVAL;
>  
> +	if (!tx_queue->initialised)
> +		return -EINVAL;
> +
>  	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
>  		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
>  
> diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
> index d530cde2b864..9bc8281b7f5b 100644
> --- a/drivers/net/ethernet/sfc/tx_common.c
> +++ b/drivers/net/ethernet/sfc/tx_common.c
> @@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
>  	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
>  		  "shutting down TX queue %d\n", tx_queue->queue);
>  
> +	tx_queue->initialised = false;
> +
>  	if (!tx_queue->buffer)
>  		return;
>  
> -- 
> 2.17.1
