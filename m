Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D6C47A00B
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 10:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhLSJ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 04:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhLSJ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 04:29:53 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9230C061574;
        Sun, 19 Dec 2021 01:29:52 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so7341121wmj.5;
        Sun, 19 Dec 2021 01:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yw/oy985DZTS5RPQsnNUYd8xhhnbG9oDSgQT2uDbFng=;
        b=FgAlyOEvI9GyY4/1XB1BcIDn6CrYqjnUrqISUECnHu2yFaGt2kdIJP9n6YSk0B2Bpf
         xyjUZmjN0CYlfAXht9ZyEg9Rf+Ama6MxlB+wd1vA273PQSCYIlbGRPxw4/9DvjNWoYuL
         hqHsquB3u13MfVrK/ZXupcNcrIr/EUszzBS3o4yqCZijAB/epc05iC0ePl5hGEH4O3zs
         NEdLW7U4aPq5G+JacZ8wtwblkde7LWazjZFY4U7H0g4Q5z5gZ3IoBL2M6veJOBKa0dNN
         8oPRq2hhTaYFO7RSJRllBmxtRs59OvKObCQFtjCZ+WUoiHbsHyEPlO0b/HypJCBrNVsw
         GJiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=Yw/oy985DZTS5RPQsnNUYd8xhhnbG9oDSgQT2uDbFng=;
        b=gt1twSoOSJhZNaLWcefbZuGZhAZyvjKd6UucIe5/9aOv7nzOXtHPCe8I3E8n6OqUDr
         SeMpVbSoyI0FFygf4/vaZlxBgxewL837uXh+sqRtx0YQXK/qgWpKoRSqkiBuVeSQ3NPa
         +GsDIu9UpmFInc5YS9SzkWnLbynqKNO6OLDXy2ynqmzIRZx+iHq8OgkCTAwq+PZM+7D9
         KzBPerjGT/soOwodwrXOxoBepo2zZisfv7K92j1e5pvcxqiiR+exmSoteVLLCWZjYkgQ
         3ffNdvB6ixN2b6/2HC0v+ZscSTYzq1EnqKRThEMQpafz4N+m5WFU7Iwu+d662I88X8+P
         cD+A==
X-Gm-Message-State: AOAM530mne0ivS6gYGKpks/DC8blpDlhhu3/GW8QfzE12+rkvRGa8QA3
        7bT09KcieR4jDhAtXXEWK9Y=
X-Google-Smtp-Source: ABdhPJxaN5swRB9TXkMi7UnUc3SVp1tm+dfcPKlYQBW8lm75L9tJus/7oe4jOzcigXh4SslQ054PPw==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr9949385wmh.104.1639906191228;
        Sun, 19 Dec 2021 01:29:51 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id 138sm15474132wma.17.2021.12.19.01.29.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Dec 2021 01:29:50 -0800 (PST)
Date:   Sun, 19 Dec 2021 09:29:48 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        bhelgaas@google.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sfc: falcon: potential dereference null pointer of
 rx_queue->page_ring
Message-ID: <20211219092948.t2iprptmyfrzgthb@gmail.com>
Mail-Followup-To: Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        bhelgaas@google.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211217143308.675315-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217143308.675315-1-jiasheng@iscas.ac.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 10:33:08PM +0800, Jiasheng Jiang wrote:
> The return value of kcalloc() needs to be checked.

Your predicate is wrong. The code that uses rx_queue->page_ring
can deal with it being NULL.
The only thing you might want to do is set rx_queue->page_ptr_mask
to 0.

Martin

> To avoid dereference of null pointer in case of the failure of alloc.
> Therefore, it might be better to change the return type of
> ef4_init_rx_recycle_ring(), ef4_init_rx_queue(), ef4_start_datapath(),
> ef4_start_all(), and return -ENOMEM when alloc fails and return 0 the
> others.
> Also, ef4_realloc_channels(), ef4_net_open(), ef4_change_mtu(),
> ef4_reset_up() and ef4_pm_thaw() should deal with the return value of
> ef4_start_all().
> 
> Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog:
> 
> v1 -> v2
> 
> *Change 1. Alter the "ret" to 'rc' and cleanup the rx_queue and tx_queue
> when alloc fails.
> ---
>  drivers/net/ethernet/sfc/falcon/efx.c | 56 +++++++++++++++++++++------
>  drivers/net/ethernet/sfc/falcon/efx.h |  2 +-
>  drivers/net/ethernet/sfc/falcon/rx.c  | 18 +++++++--
>  3 files changed, 60 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
> index 5e7a57b680ca..89b93ed08251 100644
> --- a/drivers/net/ethernet/sfc/falcon/efx.c
> +++ b/drivers/net/ethernet/sfc/falcon/efx.c
> @@ -201,7 +201,7 @@ static void ef4_init_napi_channel(struct ef4_channel *channel);
>  static void ef4_fini_napi(struct ef4_nic *efx);
>  static void ef4_fini_napi_channel(struct ef4_channel *channel);
>  static void ef4_fini_struct(struct ef4_nic *efx);
> -static void ef4_start_all(struct ef4_nic *efx);
> +static int ef4_start_all(struct ef4_nic *efx);
>  static void ef4_stop_all(struct ef4_nic *efx);
>  
>  #define EF4_ASSERT_RESET_SERIALISED(efx)		\
> @@ -590,7 +590,7 @@ static int ef4_probe_channels(struct ef4_nic *efx)
>   * to propagate configuration changes (mtu, checksum offload), or
>   * to clear hardware error conditions
>   */
> -static void ef4_start_datapath(struct ef4_nic *efx)
> +static int ef4_start_datapath(struct ef4_nic *efx)
>  {
>  	netdev_features_t old_features = efx->net_dev->features;
>  	bool old_rx_scatter = efx->rx_scatter;
> @@ -598,6 +598,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
>  	struct ef4_rx_queue *rx_queue;
>  	struct ef4_channel *channel;
>  	size_t rx_buf_len;
> +	int rc;
>  
>  	/* Calculate the rx buffer allocation parameters required to
>  	 * support the current MTU, including padding for header
> @@ -668,7 +669,10 @@ static void ef4_start_datapath(struct ef4_nic *efx)
>  		}
>  
>  		ef4_for_each_channel_rx_queue(rx_queue, channel) {
> -			ef4_init_rx_queue(rx_queue);
> +			rc = ef4_init_rx_queue(rx_queue);
> +			if (rc)
> +				goto fail;
> +
>  			atomic_inc(&efx->active_queues);
>  			ef4_stop_eventq(channel);
>  			ef4_fast_push_rx_descriptors(rx_queue, false);
> @@ -680,6 +684,17 @@ static void ef4_start_datapath(struct ef4_nic *efx)
>  
>  	if (netif_device_present(efx->net_dev))
>  		netif_tx_wake_all_queues(efx->net_dev);
> +
> +	return 0;
> +
> +fail:
> +	ef4_for_each_channel(channel, efx) {
> +		ef4_for_each_channel_rx_queue(rx_queue, channel)
> +			ef4_fini_rx_queue(rx_queue);
> +		ef4_for_each_possible_channel_tx_queue(tx_queue, channel)
> +			ef4_fini_tx_queue(tx_queue);
> +	}
> +	return rc;
>  }
>  
>  static void ef4_stop_datapath(struct ef4_nic *efx)
> @@ -853,7 +868,10 @@ ef4_realloc_channels(struct ef4_nic *efx, u32 rxq_entries, u32 txq_entries)
>  			  "unable to restart interrupts on channel reallocation\n");
>  		ef4_schedule_reset(efx, RESET_TYPE_DISABLE);
>  	} else {
> -		ef4_start_all(efx);
> +		rc = ef4_start_all(efx);
> +		if (rc)
> +			return rc;
> +
>  		netif_device_attach(efx->net_dev);
>  	}
>  	return rc;
> @@ -1814,8 +1832,10 @@ static int ef4_probe_all(struct ef4_nic *efx)
>   * is safe to call multiple times, so long as the NIC is not disabled.
>   * Requires the RTNL lock.
>   */
> -static void ef4_start_all(struct ef4_nic *efx)
> +static int ef4_start_all(struct ef4_nic *efx)
>  {
> +	int rc;
> +
>  	EF4_ASSERT_RESET_SERIALISED(efx);
>  	BUG_ON(efx->state == STATE_DISABLED);
>  
> @@ -1823,10 +1843,12 @@ static void ef4_start_all(struct ef4_nic *efx)
>  	 * of these flags are safe to read under just the rtnl lock */
>  	if (efx->port_enabled || !netif_running(efx->net_dev) ||
>  	    efx->reset_pending)
> -		return;
> +		return 0;
>  
>  	ef4_start_port(efx);
> -	ef4_start_datapath(efx);
> +	rc = ef4_start_datapath(efx);
> +	if (rc)
> +		return rc;
>  
>  	/* Start the hardware monitor if there is one */
>  	if (efx->type->monitor != NULL)
> @@ -1838,6 +1860,8 @@ static void ef4_start_all(struct ef4_nic *efx)
>  	spin_lock_bh(&efx->stats_lock);
>  	efx->type->update_stats(efx, NULL, NULL);
>  	spin_unlock_bh(&efx->stats_lock);
> +
> +	return 0;
>  }
>  
>  /* Quiesce the hardware and software data path, and regular activity
> @@ -2074,7 +2098,10 @@ int ef4_net_open(struct net_device *net_dev)
>  	 * before the monitor starts running */
>  	ef4_link_status_changed(efx);
>  
> -	ef4_start_all(efx);
> +	rc = ef4_start_all(efx);
> +	if (rc)
> +		return rc;
> +
>  	ef4_selftest_async_start(efx);
>  	return 0;
>  }
> @@ -2140,7 +2167,10 @@ static int ef4_change_mtu(struct net_device *net_dev, int new_mtu)
>  	ef4_mac_reconfigure(efx);
>  	mutex_unlock(&efx->mac_lock);
>  
> -	ef4_start_all(efx);
> +	rc = ef4_start_all(efx);
> +	if (rc)
> +		return rc;
> +
>  	netif_device_attach(efx->net_dev);
>  	return 0;
>  }
> @@ -2409,7 +2439,9 @@ int ef4_reset_up(struct ef4_nic *efx, enum reset_type method, bool ok)
>  
>  	mutex_unlock(&efx->mac_lock);
>  
> -	ef4_start_all(efx);
> +	rc = ef4_start_all(efx);
> +	if (rc)
> +		return rc;
>  
>  	return 0;
>  
> @@ -3033,7 +3065,9 @@ static int ef4_pm_thaw(struct device *dev)
>  		efx->phy_op->reconfigure(efx);
>  		mutex_unlock(&efx->mac_lock);
>  
> -		ef4_start_all(efx);
> +		rc = ef4_start_all(efx);
> +		if (rc)
> +			goto fail;
>  
>  		netif_device_attach(efx->net_dev);
>  
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.h b/drivers/net/ethernet/sfc/falcon/efx.h
> index d3b4646545fa..483501b42667 100644
> --- a/drivers/net/ethernet/sfc/falcon/efx.h
> +++ b/drivers/net/ethernet/sfc/falcon/efx.h
> @@ -39,7 +39,7 @@ void ef4_set_default_rx_indir_table(struct ef4_nic *efx);
>  void ef4_rx_config_page_split(struct ef4_nic *efx);
>  int ef4_probe_rx_queue(struct ef4_rx_queue *rx_queue);
>  void ef4_remove_rx_queue(struct ef4_rx_queue *rx_queue);
> -void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue);
> +int ef4_init_rx_queue(struct ef4_rx_queue *rx_queue);
>  void ef4_fini_rx_queue(struct ef4_rx_queue *rx_queue);
>  void ef4_fast_push_rx_descriptors(struct ef4_rx_queue *rx_queue, bool atomic);
>  void ef4_rx_slow_fill(struct timer_list *t);
> diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
> index 966f13e7475d..6042219ddb2f 100644
> --- a/drivers/net/ethernet/sfc/falcon/rx.c
> +++ b/drivers/net/ethernet/sfc/falcon/rx.c
> @@ -709,8 +709,8 @@ int ef4_probe_rx_queue(struct ef4_rx_queue *rx_queue)
>  	return rc;
>  }
>  
> -static void ef4_init_rx_recycle_ring(struct ef4_nic *efx,
> -				     struct ef4_rx_queue *rx_queue)
> +static int ef4_init_rx_recycle_ring(struct ef4_nic *efx,
> +				    struct ef4_rx_queue *rx_queue)
>  {
>  	unsigned int bufs_in_recycle_ring, page_ring_size;
>  
> @@ -728,13 +728,19 @@ static void ef4_init_rx_recycle_ring(struct ef4_nic *efx,
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring = kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> +	if (!rx_queue->page_ring)
> +		return -ENOMEM;
> +
>  	rx_queue->page_ptr_mask = page_ring_size - 1;
> +
> +	return 0;
>  }
>  
> -void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
> +int ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
>  {
>  	struct ef4_nic *efx = rx_queue->efx;
>  	unsigned int max_fill, trigger, max_trigger;
> +	int rc;
>  
>  	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
>  		  "initialising RX queue %d\n", ef4_rx_queue_index(rx_queue));
> @@ -744,7 +750,9 @@ void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
>  	rx_queue->notified_count = 0;
>  	rx_queue->removed_count = 0;
>  	rx_queue->min_fill = -1U;
> -	ef4_init_rx_recycle_ring(efx, rx_queue);
> +	rc = ef4_init_rx_recycle_ring(efx, rx_queue);
> +	if (rc)
> +		return rc;
>  
>  	rx_queue->page_remove = 0;
>  	rx_queue->page_add = rx_queue->page_ptr_mask + 1;
> @@ -770,6 +778,8 @@ void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
>  
>  	/* Set up RX descriptor ring */
>  	ef4_nic_init_rx(rx_queue);
> +
> +	return 0;
>  }
>  
>  void ef4_fini_rx_queue(struct ef4_rx_queue *rx_queue)
> -- 
> 2.25.1
