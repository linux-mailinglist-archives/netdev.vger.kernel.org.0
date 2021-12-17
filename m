Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639C747873A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhLQJcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhLQJcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 04:32:17 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984E5C061751;
        Fri, 17 Dec 2021 01:32:15 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r17so2505166wrc.3;
        Fri, 17 Dec 2021 01:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=5pSylweorhrc/az3zSaSAP1dIOTvJVZbjxQOd6u98sA=;
        b=ZlANqW2OJgRvyFfp4VHyLiBFShDpe8LtHWZlgqgNalVAZ7KY3/YhNEqxJTwthqw8Es
         MqUyOqRP9rE3goQU+akIHlQTHBm/Uj/J5hEpYrdVvpVAP3l1OUub3Sh95NowNcdNEIOU
         P6NpimxONbHflBFEpv1lXRFkcT7aPwz84iRY5Y8yuDY0QnwTxCmSdlH8AoqNEacP5ILr
         WVTdTOX+eWwQWfg9aYcuSy+2QaSrGtvqQCg76sKqHje0Vy6GZWwgl13z/aKiwmKZGsvp
         Xv7I+i3GjHBOILhkvZKQ4DzaVkFFIZ+hnJVez+FlYeq9sRpYPe1hrheCPZ6oFykWCQCk
         cY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=5pSylweorhrc/az3zSaSAP1dIOTvJVZbjxQOd6u98sA=;
        b=73aVQhZcmA6V6Ie9Ot8wgutqBXUbHv5ODkGl6K2ljb20IEKvG9ALlCMifQZilUA8Xl
         cHKMwtBxOqRjG3jWB33PnT5VxJYix/GfvL4OW/+FHEQc7LOl9wJa/HLfQTe3XOfDMGZD
         Be0fCGmG4Nvh2X8fytKSmwnI35UlMV4ImBAoDL86Yg4nG7TNIkm6UZyr52qHd8cFTWXn
         Jw4rP1hyUXwFjQngd/+1BX+ZoSALh5B2OGh3GbODJRo7gw29SioyQQAV+hDah+Pi/42r
         pXs7wpLRihT+YSZIxSSmxE2mcyhy7a3Eh3uYM6g9lKMTEge3lH2NkyeLy8kWPOdmt5PO
         A5cQ==
X-Gm-Message-State: AOAM5315yn42Ygdzw/M884wWfMuumS/jjMvP7nTlz6z5hnd6EVLSHCB4
        7SjDTSgEC7ndsyMbIFweHZW8g8b1z5A=
X-Google-Smtp-Source: ABdhPJyXNx1VuMIp2gn4beQlmZy47Mk121DGM8GLcVqnwS0obpaxfXizZlUf2wN580P3CYH1GfGMqw==
X-Received: by 2002:a5d:4143:: with SMTP id c3mr1721803wrq.254.1639733534118;
        Fri, 17 Dec 2021 01:32:14 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:5c04:3253:ca5d:176d? (p200300ea8f24fd005c043253ca5d176d.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:5c04:3253:ca5d:176d])
        by smtp.googlemail.com with ESMTPSA id t8sm8979876wmq.32.2021.12.17.01.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 01:32:13 -0800 (PST)
Message-ID: <04b4d955-3a67-79f3-e2d3-f1c1785bd554@gmail.com>
Date:   Fri, 17 Dec 2021 10:32:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        bhelgaas@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211217091430.588034-1-jiasheng@iscas.ac.cn>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] sfc: falcon: potential dereference null pointer of
 rx_queue->page_ring
In-Reply-To: <20211217091430.588034-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.12.2021 10:14, Jiasheng Jiang wrote:
> The return value of kcalloc() needs to be checked.
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
>  drivers/net/ethernet/sfc/falcon/efx.c | 46 ++++++++++++++++++++-------
>  drivers/net/ethernet/sfc/falcon/efx.h |  2 +-
>  drivers/net/ethernet/sfc/falcon/rx.c  | 18 ++++++++---
>  3 files changed, 50 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
> index 5e7a57b680ca..fbd55029988e 100644
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
> +	int ret;
>  
>  	/* Calculate the rx buffer allocation parameters required to
>  	 * support the current MTU, including padding for header
> @@ -668,7 +669,10 @@ static void ef4_start_datapath(struct ef4_nic *efx)
>  		}
>  
>  		ef4_for_each_channel_rx_queue(rx_queue, channel) {
> -			ef4_init_rx_queue(rx_queue);
> +			ret = ef4_init_rx_queue(rx_queue);
> +			if (ret)

I think you can't simply return here, you have to clean up properly.
Check ef4_stop_datapath() for cleanup activities.

> +				return ret;
> +
>  			atomic_inc(&efx->active_queues);
>  			ef4_stop_eventq(channel);
>  			ef4_fast_push_rx_descriptors(rx_queue, false);
> @@ -680,6 +684,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
>  
>  	if (netif_device_present(efx->net_dev))
>  		netif_tx_wake_all_queues(efx->net_dev);
> +	return 0;
>  }
>  
>  static void ef4_stop_datapath(struct ef4_nic *efx)
> @@ -853,7 +858,10 @@ ef4_realloc_channels(struct ef4_nic *efx, u32 rxq_entries, u32 txq_entries)
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
> @@ -1814,8 +1822,10 @@ static int ef4_probe_all(struct ef4_nic *efx)
>   * is safe to call multiple times, so long as the NIC is not disabled.
>   * Requires the RTNL lock.
>   */
> -static void ef4_start_all(struct ef4_nic *efx)
> +static int ef4_start_all(struct ef4_nic *efx)
>  {
> +	int ret;
> +
>  	EF4_ASSERT_RESET_SERIALISED(efx);
>  	BUG_ON(efx->state == STATE_DISABLED);
>  
> @@ -1823,10 +1833,12 @@ static void ef4_start_all(struct ef4_nic *efx)
>  	 * of these flags are safe to read under just the rtnl lock */
>  	if (efx->port_enabled || !netif_running(efx->net_dev) ||
>  	    efx->reset_pending)
> -		return;
> +		return 0;
>  
>  	ef4_start_port(efx);
> -	ef4_start_datapath(efx);
> +	ret = ef4_start_datapath(efx);
> +	if (ret)
> +		return ret;
>  
>  	/* Start the hardware monitor if there is one */
>  	if (efx->type->monitor != NULL)
> @@ -1838,6 +1850,8 @@ static void ef4_start_all(struct ef4_nic *efx)
>  	spin_lock_bh(&efx->stats_lock);
>  	efx->type->update_stats(efx, NULL, NULL);
>  	spin_unlock_bh(&efx->stats_lock);
> +
> +	return 0;
>  }
>  
>  /* Quiesce the hardware and software data path, and regular activity
> @@ -2074,7 +2088,10 @@ int ef4_net_open(struct net_device *net_dev)
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
> @@ -2140,7 +2157,10 @@ static int ef4_change_mtu(struct net_device *net_dev, int new_mtu)
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
> @@ -2409,7 +2429,9 @@ int ef4_reset_up(struct ef4_nic *efx, enum reset_type method, bool ok)
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
> @@ -3033,7 +3055,9 @@ static int ef4_pm_thaw(struct device *dev)
>  		efx->phy_op->reconfigure(efx);
>  		mutex_unlock(&efx->mac_lock);
>  
> -		ef4_start_all(efx);
> +		rc = ef4_start_all(efx);
> +		if (rc)
> +			return rc;
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
> index 966f13e7475d..cf9a4c387dd5 100644
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
> +	int ret;
>  
>  	netif_dbg(rx_queue->efx, drv, rx_queue->efx->net_dev,
>  		  "initialising RX queue %d\n", ef4_rx_queue_index(rx_queue));
> @@ -744,7 +750,9 @@ void ef4_init_rx_queue(struct ef4_rx_queue *rx_queue)
>  	rx_queue->notified_count = 0;
>  	rx_queue->removed_count = 0;
>  	rx_queue->min_fill = -1U;
> -	ef4_init_rx_recycle_ring(efx, rx_queue);
> +	ret = ef4_init_rx_recycle_ring(efx, rx_queue);
> +	if (ret)
> +		return ret;
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

