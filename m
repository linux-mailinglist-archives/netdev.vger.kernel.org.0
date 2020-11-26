Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B542C4FDF
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 08:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731417AbgKZH4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 02:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730005AbgKZH4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 02:56:31 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E17C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 23:56:31 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id i2so1081104wrs.4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 23:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ObvQaROjXAIsMQ2DF40vb80HUDvE/Lu/C5WxF/JBk6I=;
        b=WuJHxLq+6iiIAUF3ay7XjK8zfHcMYYV1GRLLu8rp/wgSU7wAki+8z3/IsqIxQe6mLr
         DuZiRjN3qNtVsACu0fiL/tN2gXCY2FQ/7RaDlExw5x53/zHYmM1f97JwyLQ0f6vxFZWL
         E+iJ7/00uQbQ6YEAmh0BJDA8lgmm0OdaLbj3Sqk6SoK0+bfGqDmCL0hyWdQ60zHUSk6C
         bVcvGxMiBL6TZyQtirPn0s/PdyTG3hg5oWm/nuVZl7haQPKYSuGXhDFualyjN1dHZqdW
         iHDDIwETqFflGyztIM5l0jgaOGTijoa33rAVmfeeZdxgEqM8CfOEYuCG8LtsXbFTZnmK
         8pJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ObvQaROjXAIsMQ2DF40vb80HUDvE/Lu/C5WxF/JBk6I=;
        b=Tl8f2Ll3hoK1EyQLAdi3QNzghBbVcEqap987lGDx58qBNctp7M6YeYLB/uYTYJrli0
         4lGHdOl6ENqzNgeQGVatmXn54Uo5T6rGn9dUlNpvflXWxzDeMI3iR3VPvMRcKGQso+rp
         lcz+G4DTuHAt2lJgkOj2bne5HwDilznmm1Lm6gcTe/xqz1Ti1nkYeVTRLWqkWXxnvPqK
         E6Higt5bflIoptKG/pYwfSwOnb7A9/8tv3SQm81CJ7FfUqTTEUnG9FF145XrJMp/0Qgb
         /p9uIzNEAyG3J8J6g6a4GM+fexz0vy3ZdMFQ9D3IFpkzSPopsNOxAOtZhtoAtd7Cq/o/
         lINA==
X-Gm-Message-State: AOAM533t2zdb7kDTtrui/HlHT/jFLj1YAoBl9R9PWjQj7BzqL8JV2YYH
        d+RLTOpIxFk+z29CO3EFlx0=
X-Google-Smtp-Source: ABdhPJwWUrFGjfPEKoljc0lNuq1XiQhgpjf5JEseADxdLwf1oM53V/JHJbOCTJpp/pLnGavybc1NrA==
X-Received: by 2002:a5d:4e09:: with SMTP id p9mr2267173wrt.345.1606377389973;
        Wed, 25 Nov 2020 23:56:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:3123:671a:df8f:7fd9? (p200300ea8f2328003123671adf8f7fd9.dip0.t-ipconnect.de. [2003:ea:8f23:2800:3123:671a:df8f:7fd9])
        by smtp.googlemail.com with ESMTPSA id z188sm1349632wmg.36.2020.11.25.23.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 23:56:29 -0800 (PST)
Subject: Re: [PATCH V1 net-next 5/9] net: ena: aggregate stats increase into a
 function
To:     akiyano@amazon.com, kuba@kernel.org, netdev@vger.kernel.org
Cc:     dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, ndagan@amazon.com,
        shayagr@amazon.com, sameehj@amazon.com
References: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
 <1606344708-11100-6-git-send-email-akiyano@amazon.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4bfce37b-674e-b738-46a6-d4d8af6ac8cb@gmail.com>
Date:   Thu, 26 Nov 2020 08:56:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606344708-11100-6-git-send-email-akiyano@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 25.11.2020 um 23:51 schrieb akiyano@amazon.com:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Introduce ena_increase_stat_atomic() function to increase statistics by
> certain number.
> The function includes the
>     - lock aquire
>     - stat increase
>     - lock release
> 

Having "atomic" in the name may be misleading, because it's not atomic.
On 64bit the function is reduced to (*statp) += cnt what isn't
atomic. Therefore e.g. rx_dropped counter in struct net_device is
defined as atomic_long_t.

All the u64_stats_ functions do is ensure thet a parallel reader
never sees an invalid counter value. But you may still be in trouble
if there are two parallel writers.

> line sequence that is ubiquitous across the driver.
> 
> The function increases a single stat at a time. Therefore code that
> increases several stats for a single lock aquire/release wasn't
> transformed to use this function. This is to avoid calling the function
> several times for each stat which looks bad and might decrease
> performance (each stat would aquire the lock again).
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 172 ++++++++-----------
>  1 file changed, 73 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 371593ed0400..2b7ba2e24e3a 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -80,6 +80,15 @@ static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
>  static int ena_create_io_tx_queues_in_range(struct ena_adapter *adapter,
>  					    int first_index, int count);
>  
> +/* Increase a stat by cnt while holding syncp seqlock */
> +static void ena_increase_stat_atomic(u64 *statp, u64 cnt,
> +				     struct u64_stats_sync *syncp)
> +{
> +       u64_stats_update_begin(syncp);
> +       (*statp) += cnt;
> +       u64_stats_update_end(syncp);
> +}
> +
>  static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
>  	struct ena_adapter *adapter = netdev_priv(dev);
> @@ -92,9 +101,8 @@ static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  		return;
>  
>  	adapter->reset_reason = ENA_REGS_RESET_OS_NETDEV_WD;
> -	u64_stats_update_begin(&adapter->syncp);
> -	adapter->dev_stats.tx_timeout++;
> -	u64_stats_update_end(&adapter->syncp);
> +	ena_increase_stat_atomic(&adapter->dev_stats.tx_timeout, 1,
> +		&adapter->syncp);
>  
>  	netif_err(adapter, tx_err, dev, "Transmit time out\n");
>  }
> @@ -154,9 +162,8 @@ static int ena_xmit_common(struct net_device *dev,
>  	if (unlikely(rc)) {
>  		netif_err(adapter, tx_queued, dev,
>  			  "Failed to prepare tx bufs\n");
> -		u64_stats_update_begin(&ring->syncp);
> -		ring->tx_stats.prepare_ctx_err++;
> -		u64_stats_update_end(&ring->syncp);
> +		ena_increase_stat_atomic(&ring->tx_stats.prepare_ctx_err, 1,
> +			&ring->syncp);
>  		if (rc != -ENOMEM) {
>  			adapter->reset_reason =
>  				ENA_REGS_RESET_DRIVER_INVALID_STATE;
> @@ -264,9 +271,8 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
>  	return 0;
>  
>  error_report_dma_error:
> -	u64_stats_update_begin(&xdp_ring->syncp);
> -	xdp_ring->tx_stats.dma_mapping_err++;
> -	u64_stats_update_end(&xdp_ring->syncp);
> +	ena_increase_stat_atomic(&xdp_ring->tx_stats.dma_mapping_err, 1,
> +		&xdp_ring->syncp);
>  	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map xdp buff\n");
>  
>  	xdp_return_frame_rx_napi(tx_info->xdpf);
> @@ -320,9 +326,8 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
>  	 * has a mb
>  	 */
>  	ena_com_write_sq_doorbell(xdp_ring->ena_com_io_sq);
> -	u64_stats_update_begin(&xdp_ring->syncp);
> -	xdp_ring->tx_stats.doorbells++;
> -	u64_stats_update_end(&xdp_ring->syncp);
> +	ena_increase_stat_atomic(&xdp_ring->tx_stats.doorbells, 1,
> +		&xdp_ring->syncp);
>  
>  	return NETDEV_TX_OK;
>  
> @@ -369,9 +374,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring,
>  		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
>  	}
>  
> -	u64_stats_update_begin(&rx_ring->syncp);
> -	(*xdp_stat)++;
> -	u64_stats_update_end(&rx_ring->syncp);
> +	ena_increase_stat_atomic(xdp_stat, 1, &rx_ring->syncp);
>  out:
>  	rcu_read_unlock();
>  
> @@ -924,9 +927,8 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
>  
>  	page = alloc_page(gfp);
>  	if (unlikely(!page)) {
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.page_alloc_fail++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.page_alloc_fail, 1,
> +			&rx_ring->syncp);
>  		return -ENOMEM;
>  	}
>  
> @@ -936,9 +938,8 @@ static int ena_alloc_rx_page(struct ena_ring *rx_ring,
>  	dma = dma_map_page(rx_ring->dev, page, 0, ENA_PAGE_SIZE,
>  			   DMA_BIDIRECTIONAL);
>  	if (unlikely(dma_mapping_error(rx_ring->dev, dma))) {
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.dma_mapping_err++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.dma_mapping_err, 1,
> +			&rx_ring->syncp);
>  
>  		__free_page(page);
>  		return -EIO;
> @@ -1011,9 +1012,8 @@ static int ena_refill_rx_bufs(struct ena_ring *rx_ring, u32 num)
>  	}
>  
>  	if (unlikely(i < num)) {
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.refil_partial++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.refil_partial, 1,
> +			&rx_ring->syncp);
>  		netif_warn(rx_ring->adapter, rx_err, rx_ring->netdev,
>  			   "Refilled rx qid %d with only %d buffers (from %d)\n",
>  			   rx_ring->qid, i, num);
> @@ -1189,9 +1189,7 @@ static int handle_invalid_req_id(struct ena_ring *ring, u16 req_id,
>  			  "Invalid req_id: %hu\n",
>  			  req_id);
>  
> -	u64_stats_update_begin(&ring->syncp);
> -	ring->tx_stats.bad_req_id++;
> -	u64_stats_update_end(&ring->syncp);
> +	ena_increase_stat_atomic(&ring->tx_stats.bad_req_id, 1, &ring->syncp);
>  
>  	/* Trigger device reset */
>  	ring->adapter->reset_reason = ENA_REGS_RESET_INV_TX_REQ_ID;
> @@ -1302,9 +1300,8 @@ static int ena_clean_tx_irq(struct ena_ring *tx_ring, u32 budget)
>  		if (netif_tx_queue_stopped(txq) && above_thresh &&
>  		    test_bit(ENA_FLAG_DEV_UP, &tx_ring->adapter->flags)) {
>  			netif_tx_wake_queue(txq);
> -			u64_stats_update_begin(&tx_ring->syncp);
> -			tx_ring->tx_stats.queue_wakeup++;
> -			u64_stats_update_end(&tx_ring->syncp);
> +			ena_increase_stat_atomic(&tx_ring->tx_stats.queue_wakeup, 1,
> +				&tx_ring->syncp);
>  		}
>  		__netif_tx_unlock(txq);
>  	}
> @@ -1323,9 +1320,8 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, bool frags)
>  						rx_ring->rx_copybreak);
>  
>  	if (unlikely(!skb)) {
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.skb_alloc_fail++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.skb_alloc_fail, 1,
> +			&rx_ring->syncp);
>  		netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
>  			  "Failed to allocate skb. frags: %d\n", frags);
>  		return NULL;
> @@ -1453,9 +1449,8 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
>  		     (ena_rx_ctx->l3_csum_err))) {
>  		/* ipv4 checksum error */
>  		skb->ip_summed = CHECKSUM_NONE;
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.bad_csum++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.bad_csum, 1,
> +			&rx_ring->syncp);
>  		netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
>  			  "RX IPv4 header checksum error\n");
>  		return;
> @@ -1466,9 +1461,8 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
>  		   (ena_rx_ctx->l4_proto == ENA_ETH_IO_L4_PROTO_UDP))) {
>  		if (unlikely(ena_rx_ctx->l4_csum_err)) {
>  			/* TCP/UDP checksum error */
> -			u64_stats_update_begin(&rx_ring->syncp);
> -			rx_ring->rx_stats.bad_csum++;
> -			u64_stats_update_end(&rx_ring->syncp);
> +			ena_increase_stat_atomic(&rx_ring->rx_stats.bad_csum, 1,
> +				&rx_ring->syncp);
>  			netif_dbg(rx_ring->adapter, rx_err, rx_ring->netdev,
>  				  "RX L4 checksum error\n");
>  			skb->ip_summed = CHECKSUM_NONE;
> @@ -1477,13 +1471,11 @@ static void ena_rx_checksum(struct ena_ring *rx_ring,
>  
>  		if (likely(ena_rx_ctx->l4_csum_checked)) {
>  			skb->ip_summed = CHECKSUM_UNNECESSARY;
> -			u64_stats_update_begin(&rx_ring->syncp);
> -			rx_ring->rx_stats.csum_good++;
> -			u64_stats_update_end(&rx_ring->syncp);
> +			ena_increase_stat_atomic(&rx_ring->rx_stats.csum_good, 1,
> +				&rx_ring->syncp);
>  		} else {
> -			u64_stats_update_begin(&rx_ring->syncp);
> -			rx_ring->rx_stats.csum_unchecked++;
> -			u64_stats_update_end(&rx_ring->syncp);
> +			ena_increase_stat_atomic(&rx_ring->rx_stats.csum_unchecked, 1,
> +				&rx_ring->syncp);
>  			skb->ip_summed = CHECKSUM_NONE;
>  		}
>  	} else {
> @@ -1675,14 +1667,12 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
>  	adapter = netdev_priv(rx_ring->netdev);
>  
>  	if (rc == -ENOSPC) {
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.bad_desc_num++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.bad_desc_num, 1,
> +					 &rx_ring->syncp);
>  		adapter->reset_reason = ENA_REGS_RESET_TOO_MANY_RX_DESCS;
>  	} else {
> -		u64_stats_update_begin(&rx_ring->syncp);
> -		rx_ring->rx_stats.bad_req_id++;
> -		u64_stats_update_end(&rx_ring->syncp);
> +		ena_increase_stat_atomic(&rx_ring->rx_stats.bad_req_id, 1,
> +					 &rx_ring->syncp);
>  		adapter->reset_reason = ENA_REGS_RESET_INV_RX_REQ_ID;
>  	}
>  
> @@ -1743,9 +1733,8 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
>  				tx_ring->smoothed_interval,
>  				true);
>  
> -	u64_stats_update_begin(&tx_ring->syncp);
> -	tx_ring->tx_stats.unmask_interrupt++;
> -	u64_stats_update_end(&tx_ring->syncp);
> +	ena_increase_stat_atomic(&tx_ring->tx_stats.unmask_interrupt, 1,
> +		&tx_ring->syncp);
>  
>  	/* It is a shared MSI-X.
>  	 * Tx and Rx CQ have pointer to it.
> @@ -2552,9 +2541,8 @@ static int ena_up(struct ena_adapter *adapter)
>  	if (test_bit(ENA_FLAG_LINK_UP, &adapter->flags))
>  		netif_carrier_on(adapter->netdev);
>  
> -	u64_stats_update_begin(&adapter->syncp);
> -	adapter->dev_stats.interface_up++;
> -	u64_stats_update_end(&adapter->syncp);
> +	ena_increase_stat_atomic(&adapter->dev_stats.interface_up, 1,
> +		&adapter->syncp);
>  
>  	set_bit(ENA_FLAG_DEV_UP, &adapter->flags);
>  
> @@ -2592,9 +2580,8 @@ static void ena_down(struct ena_adapter *adapter)
>  
>  	clear_bit(ENA_FLAG_DEV_UP, &adapter->flags);
>  
> -	u64_stats_update_begin(&adapter->syncp);
> -	adapter->dev_stats.interface_down++;
> -	u64_stats_update_end(&adapter->syncp);
> +	ena_increase_stat_atomic(&adapter->dev_stats.interface_down, 1,
> +		&adapter->syncp);
>  
>  	netif_carrier_off(adapter->netdev);
>  	netif_tx_disable(adapter->netdev);
> @@ -2822,15 +2809,13 @@ static int ena_check_and_linearize_skb(struct ena_ring *tx_ring,
>  	    (header_len < tx_ring->tx_max_header_size))
>  		return 0;
>  
> -	u64_stats_update_begin(&tx_ring->syncp);
> -	tx_ring->tx_stats.linearize++;
> -	u64_stats_update_end(&tx_ring->syncp);
> +	ena_increase_stat_atomic(&tx_ring->tx_stats.linearize, 1,
> +		&tx_ring->syncp);
>  
>  	rc = skb_linearize(skb);
>  	if (unlikely(rc)) {
> -		u64_stats_update_begin(&tx_ring->syncp);
> -		tx_ring->tx_stats.linearize_failed++;
> -		u64_stats_update_end(&tx_ring->syncp);
> +		ena_increase_stat_atomic(&tx_ring->tx_stats.linearize_failed, 1,
> +			&tx_ring->syncp);
>  	}
>  
>  	return rc;
> @@ -2870,9 +2855,8 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
>  					       tx_ring->push_buf_intermediate_buf);
>  		*header_len = push_len;
>  		if (unlikely(skb->data != *push_hdr)) {
> -			u64_stats_update_begin(&tx_ring->syncp);
> -			tx_ring->tx_stats.llq_buffer_copy++;
> -			u64_stats_update_end(&tx_ring->syncp);
> +			ena_increase_stat_atomic(&tx_ring->tx_stats.llq_buffer_copy, 1,
> +				&tx_ring->syncp);
>  
>  			delta = push_len - skb_head_len;
>  		}
> @@ -2929,9 +2913,8 @@ static int ena_tx_map_skb(struct ena_ring *tx_ring,
>  	return 0;
>  
>  error_report_dma_error:
> -	u64_stats_update_begin(&tx_ring->syncp);
> -	tx_ring->tx_stats.dma_mapping_err++;
> -	u64_stats_update_end(&tx_ring->syncp);
> +	ena_increase_stat_atomic(&tx_ring->tx_stats.dma_mapping_err, 1,
> +		&tx_ring->syncp);
>  	netif_warn(adapter, tx_queued, adapter->netdev, "Failed to map skb\n");
>  
>  	tx_info->skb = NULL;
> @@ -3008,9 +2991,8 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  			  __func__, qid);
>  
>  		netif_tx_stop_queue(txq);
> -		u64_stats_update_begin(&tx_ring->syncp);
> -		tx_ring->tx_stats.queue_stop++;
> -		u64_stats_update_end(&tx_ring->syncp);
> +		ena_increase_stat_atomic(&tx_ring->tx_stats.queue_stop, 1,
> +			&tx_ring->syncp);
>  
>  		/* There is a rare condition where this function decide to
>  		 * stop the queue but meanwhile clean_tx_irq updates
> @@ -3025,9 +3007,8 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		if (ena_com_sq_have_enough_space(tx_ring->ena_com_io_sq,
>  						 ENA_TX_WAKEUP_THRESH)) {
>  			netif_tx_wake_queue(txq);
> -			u64_stats_update_begin(&tx_ring->syncp);
> -			tx_ring->tx_stats.queue_wakeup++;
> -			u64_stats_update_end(&tx_ring->syncp);
> +			ena_increase_stat_atomic(&tx_ring->tx_stats.queue_wakeup, 1,
> +				&tx_ring->syncp);
>  		}
>  	}
>  
> @@ -3036,9 +3017,8 @@ static netdev_tx_t ena_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		 * has a mb
>  		 */
>  		ena_com_write_sq_doorbell(tx_ring->ena_com_io_sq);
> -		u64_stats_update_begin(&tx_ring->syncp);
> -		tx_ring->tx_stats.doorbells++;
> -		u64_stats_update_end(&tx_ring->syncp);
> +		ena_increase_stat_atomic(&tx_ring->tx_stats.doorbells, 1,
> +			&tx_ring->syncp);
>  	}
>  
>  	return NETDEV_TX_OK;
> @@ -3673,9 +3653,8 @@ static int check_missing_comp_in_tx_queue(struct ena_adapter *adapter,
>  		rc = -EIO;
>  	}
>  
> -	u64_stats_update_begin(&tx_ring->syncp);
> -	tx_ring->tx_stats.missed_tx += missed_tx;
> -	u64_stats_update_end(&tx_ring->syncp);
> +	ena_increase_stat_atomic(&tx_ring->tx_stats.missed_tx , missed_tx,
> +		&tx_ring->syncp);
>  
>  	return rc;
>  }
> @@ -3758,9 +3737,8 @@ static void check_for_empty_rx_ring(struct ena_adapter *adapter)
>  			rx_ring->empty_rx_queue++;
>  
>  			if (rx_ring->empty_rx_queue >= EMPTY_RX_REFILL) {
> -				u64_stats_update_begin(&rx_ring->syncp);
> -				rx_ring->rx_stats.empty_rx_ring++;
> -				u64_stats_update_end(&rx_ring->syncp);
> +				ena_increase_stat_atomic(&rx_ring->rx_stats.empty_rx_ring, 1,
> +					&rx_ring->syncp);
>  
>  				netif_err(adapter, drv, adapter->netdev,
>  					  "Trigger refill for ring %d\n", i);
> @@ -3790,9 +3768,8 @@ static void check_for_missing_keep_alive(struct ena_adapter *adapter)
>  	if (unlikely(time_is_before_jiffies(keep_alive_expired))) {
>  		netif_err(adapter, drv, adapter->netdev,
>  			  "Keep alive watchdog timeout.\n");
> -		u64_stats_update_begin(&adapter->syncp);
> -		adapter->dev_stats.wd_expired++;
> -		u64_stats_update_end(&adapter->syncp);
> +		ena_increase_stat_atomic(&adapter->dev_stats.wd_expired, 1,
> +			&adapter->syncp);
>  		adapter->reset_reason = ENA_REGS_RESET_KEEP_ALIVE_TO;
>  		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
>  	}
> @@ -3803,9 +3780,8 @@ static void check_for_admin_com_state(struct ena_adapter *adapter)
>  	if (unlikely(!ena_com_get_admin_running_state(adapter->ena_dev))) {
>  		netif_err(adapter, drv, adapter->netdev,
>  			  "ENA admin queue is not in running state!\n");
> -		u64_stats_update_begin(&adapter->syncp);
> -		adapter->dev_stats.admin_q_pause++;
> -		u64_stats_update_end(&adapter->syncp);
> +		ena_increase_stat_atomic(&adapter->dev_stats.admin_q_pause, 1,
> +			&adapter->syncp);
>  		adapter->reset_reason = ENA_REGS_RESET_ADMIN_TO;
>  		set_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
>  	}
> @@ -4441,9 +4417,8 @@ static int __maybe_unused ena_suspend(struct device *dev_d)
>  	struct pci_dev *pdev = to_pci_dev(dev_d);
>  	struct ena_adapter *adapter = pci_get_drvdata(pdev);
>  
> -	u64_stats_update_begin(&adapter->syncp);
> -	adapter->dev_stats.suspend++;
> -	u64_stats_update_end(&adapter->syncp);
> +	ena_increase_stat_atomic(&adapter->dev_stats.suspend, 1,
> +		&adapter->syncp);
>  
>  	rtnl_lock();
>  	if (unlikely(test_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags))) {
> @@ -4464,9 +4439,8 @@ static int __maybe_unused ena_resume(struct device *dev_d)
>  	struct ena_adapter *adapter = dev_get_drvdata(dev_d);
>  	int rc;
>  
> -	u64_stats_update_begin(&adapter->syncp);
> -	adapter->dev_stats.resume++;
> -	u64_stats_update_end(&adapter->syncp);
> +	ena_increase_stat_atomic(&adapter->dev_stats.resume, 1,
> +		&adapter->syncp);
>  
>  	rtnl_lock();
>  	rc = ena_restore_device(adapter);
> 

