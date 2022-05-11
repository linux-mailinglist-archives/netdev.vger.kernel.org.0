Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BE4522DAA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243160AbiEKHwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbiEKHwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:52:25 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CE43EBA2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:52:23 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 1-20020a05600c248100b00393fbf11a05so2660726wms.3
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=U4txhdK9Owvg5yVMcfh3t17Ov6EFFrSL43IhxGLvGwk=;
        b=PqPyI3po6gH7Zna6q/JzTXgKqt+WtWBJ0F7a8UCGwS/DkmSIDX2QBx9TymvBxEA+7J
         YeCszyNCjl8mNXzH71McEZ8twN278xzi+Zf7h8runAJF0VA8a+XUqZBS3O8ZD30/UYq7
         y3UONocPhMW7o/2zAFK9cH2g4YbLN34uOe2LQtnX2u0emTJaR9LjEZqfUM0Bu8ZiK5p0
         ayDAYXb1b0u2zXm57y/8Qb+c2qjIexzRX2KT+jVuOHGpcZAnA7l/lQR5thEY1sbFUj4l
         UYVIxZFnWbIKecNJxHQP46z+h9rt/hWSh9Ns9ATiu3Hw3jXTOlLQCJsRhnahaFewKV/w
         sVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=U4txhdK9Owvg5yVMcfh3t17Ov6EFFrSL43IhxGLvGwk=;
        b=dTzx40ShQlMY3KZQMxERDFWSnvzExw2lXAadgTVUKOfKSMQCQIMe7NWYAC+YGUkda0
         uDHkIkKJDj/BuZsWbFc/Q64gaJV8o90ovy+Pprq0oeKpavBwlw9/O2NRXkfhEDortgXJ
         kcupU3d+VeguXTePj7q+i84QZkcZKKI4rJqOI6An+9UsUxVqY1lUwMButJilfJb7nXKf
         9h06aNRbyLkUdpnzOh0TZBHkoCg+UdWkhYei/DdBuQkdNDjGh90fERk2LD7Z7glGLBi1
         GNSl+NhXXI9x1qPGFnKkRPd43P+Nhq6V+2V2ZeI7/YCZMHjpndHXYH4Jhk/3QiemiKnT
         fRSA==
X-Gm-Message-State: AOAM531lSWfvfCbSLxKKj2I0/jO5xcE4SIxU6K+gQGHHEhiYCJIUiHSP
        JBfYEi5DraeC4wSxJ2QB0yw=
X-Google-Smtp-Source: ABdhPJzTv2YxyNjl5C42Bqq2jS+k1AeU5KrerhOI3kO9POrFvVeTZ5kN25+lU4AZffb3T5cFYm8xVQ==
X-Received: by 2002:a05:600c:a53:b0:394:7a51:cb71 with SMTP id c19-20020a05600c0a5300b003947a51cb71mr3627395wmq.148.1652255542339;
        Wed, 11 May 2022 00:52:22 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id k9-20020adff289000000b0020c5253d8c0sm1000605wro.12.2022.05.11.00.52.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 May 2022 00:52:21 -0700 (PDT)
Date:   Wed, 11 May 2022 08:52:20 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, ap420073@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] sfc: separate channel->tx_queue and
 efx->xdp_tx_queue mappings
Message-ID: <20220511075220.3eut4vp33o4w4qtt@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, ap420073@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20220510084443.14473-1-ihuguet@redhat.com>
 <20220510084443.14473-3-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510084443.14473-3-ihuguet@redhat.com>
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

On Tue, May 10, 2022 at 10:44:40AM +0200, Íñigo Huguet wrote:
> Channels that contains tx queues need to determine the mapping of this
> queue structures to hw queue numbers. This applies both to all tx
> queues, no matter if they are normal tx queues, xdp_tx queues or both at
> the same time.

In my thinking XDP-only channels are a different channel type, so it
would be cleaner to define a separate struct efx_channel_type for those.

> 
> Also, a lookup table to map each cpu to a xdp_tx queue is created,
> containing pointers to the xdp_tx queues, that should already be
> allocated in one or more channels. This lookup table is global to all
> efx_nic structure.

I'm not keen on a direct CPU to queue mapping, but rather map the
specific XDP-only channels to CPUs. Also for such a mapping there is
XPS already. Ideally that configuration will be used.

> Mappings to hw queues and xdp lookup table creation were done at the
> same time in efx_set_channels, but it had a bit messy and not very clear
> code. Then, commit 059a47f1da93 ("net: sfc: add missing xdp queue
> reinitialization") moved part of that initialization to a separate
> function to fix a bug produced because the xdp_tx queues lookup table
> was not reinitialized after channels reallocation, leaving it pointing
> to deallocated queues. Not all of that initialization needs to be
> redone, but only the xdp_tx queues lookup table, and not the mappings to
> hw queues. So this resulted in even less clear code.
> 
> This patch moves back the part of that code that doesn't need to be
> reinitialized. That is, the mapping of tx queues with hw queues numbers.
> As a result, xdp queues lookup table creation and this are done in
> different places, conforming to single responsibility principle and
> resulting in more clear code.
> 
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 69 +++++++++++++------------
>  1 file changed, 37 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index 3f28f9861dfa..8feba80f0a34 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -767,6 +767,19 @@ void efx_remove_channels(struct efx_nic *efx)
>  	kfree(efx->xdp_tx_queues);
>  }
>  
> +static inline int efx_alloc_xdp_tx_queues(struct efx_nic *efx)
> +{
> +	if (efx->xdp_tx_queue_count) {
> +		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
> +		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
> +					     sizeof(*efx->xdp_tx_queues),
> +					     GFP_KERNEL);

efx_set_channels() can be called multiple times. In that case
the previous memory allocated is not freed and thus it is leaked.

Martin

> +		if (!efx->xdp_tx_queues)
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
>  static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
>  				struct efx_tx_queue *tx_queue)
>  {
> @@ -789,44 +802,29 @@ static void efx_set_xdp_channels(struct efx_nic *efx)
>  	int xdp_queue_number = 0;
>  	int rc;
>  
> -	/* We need to mark which channels really have RX and TX
> -	 * queues, and adjust the TX queue numbers if we have separate
> -	 * RX-only and TX-only channels.
> -	 */
>  	efx_for_each_channel(channel, efx) {
>  		if (channel->channel < efx->tx_channel_offset)
>  			continue;
>  
>  		if (efx_channel_is_xdp_tx(channel)) {
>  			efx_for_each_channel_tx_queue(tx_queue, channel) {
> -				tx_queue->queue = next_queue++;
>  				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
>  							  tx_queue);
>  				if (rc == 0)
>  					xdp_queue_number++;
>  			}
> -		} else {
> -			efx_for_each_channel_tx_queue(tx_queue, channel) {
> -				tx_queue->queue = next_queue++;
> -				netif_dbg(efx, drv, efx->net_dev,
> -					  "Channel %u TXQ %u is HW %u\n",
> -					  channel->channel, tx_queue->label,
> -					  tx_queue->queue);
> -			}
> +		} else if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
>  
>  			/* If XDP is borrowing queues from net stack, it must
>  			 * use the queue with no csum offload, which is the
>  			 * first one of the channel
>  			 * (note: tx_queue_by_type is not initialized yet)
>  			 */
> -			if (efx->xdp_txq_queues_mode ==
> -			    EFX_XDP_TX_QUEUES_BORROWED) {
> -				tx_queue = &channel->tx_queue[0];
> -				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
> -							  tx_queue);
> -				if (rc == 0)
> -					xdp_queue_number++;
> -			}
> +			tx_queue = &channel->tx_queue[0];
> +			rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
> +						  tx_queue);
> +			if (rc == 0)
> +				xdp_queue_number++;
>  		}
>  	}
>  	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
> @@ -952,31 +950,38 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
>  
>  int efx_set_channels(struct efx_nic *efx)
>  {
> +	struct efx_tx_queue *tx_queue;
>  	struct efx_channel *channel;
> +	unsigned int queue_num = 0;
>  	int rc;
>  
>  	efx->tx_channel_offset =
>  		efx_separate_tx_channels ?
>  		efx->n_channels - efx->n_tx_channels : 0;
>  
> -	if (efx->xdp_tx_queue_count) {
> -		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
> -
> -		/* Allocate array for XDP TX queue lookup. */
> -		efx->xdp_tx_queues = kcalloc(efx->xdp_tx_queue_count,
> -					     sizeof(*efx->xdp_tx_queues),
> -					     GFP_KERNEL);
> -		if (!efx->xdp_tx_queues)
> -			return -ENOMEM;
> -	}
> -
> +	/* We need to mark which channels really have RX and TX queues, and
> +	 * adjust the TX queue numbers if we have separate RX/TX only channels.
> +	 */
>  	efx_for_each_channel(channel, efx) {
>  		if (channel->channel < efx->n_rx_channels)
>  			channel->rx_queue.core_index = channel->channel;
>  		else
>  			channel->rx_queue.core_index = -1;
> +
> +		if (channel->channel >= efx->tx_channel_offset) {
> +			efx_for_each_channel_tx_queue(tx_queue, channel) {
> +				tx_queue->queue = queue_num++;
> +				netif_dbg(efx, drv, efx->net_dev,
> +					  "Channel %u TXQ %u is HW %u\n",
> +					  channel->channel, tx_queue->label,
> +					  tx_queue->queue);
> +			}
> +		}
>  	}
>  
> +	rc = efx_alloc_xdp_tx_queues(efx);
> +	if (rc)
> +		return rc;
>  	efx_set_xdp_channels(efx);
>  
>  	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
> -- 
> 2.34.1
