Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34C862A9D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405086AbfGHUxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:53:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36810 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405061AbfGHUxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:53:02 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so4272956pgm.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gpXg8J/JtC4cRYJvAosMWH7XbOa1N2kZzO0TUiwFFOw=;
        b=DZ530myboJ9E/AHjpRZVKMvtrPXJ1J3IPx0xMCz1Ah6wlSdsPZeXoEMbfyxDjALs/H
         ZngU9dULLXlZVcVj079C92k6jQRGXC8+uibnKCGLJgEqX9KQNR6jramGQsA+K44kgBIc
         AASrFRW31YjKcWC0CVkbGP54evrgK+bvnvoWNCLjZSPv12aDd2aPGLol2nKnaydpYDwI
         oNLbSgRZeoMJg2zRuz1YoQKhDWb1Ngl6I84t+ZSpdM0zQ7Xo7cwimu9F4/p0GSgpPyeG
         EHwL+B6KjQS6vw6NMfJ/WCziQhyh0/i4udYjBqAqmVccvOHwYXq+IUWbWIHi2mAIUkEv
         nuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gpXg8J/JtC4cRYJvAosMWH7XbOa1N2kZzO0TUiwFFOw=;
        b=BbLDAwkP9cISxnI1sfO6FTfB9kr+N+dYccwPgTBMwY6tixRpotb8YtWxekgQmXgMGP
         jOBXUCcFZtV9pz7TnzczRl3PAYGmGxzWisAA4ZYCu2m0YEgR5CkJkurbNFMnQKyVpMgk
         nplrkJQdOglN7nZ7If4YRPW4JELsNA847QMgHLS6KNsSBndTadrIk5T6dlEGpY5xAnNR
         BegrhxcldXj+PD3XQuElVI54foiCHjfoliMahYizEOwi9N16LU3BKKHjKozQh8/CpTTu
         jjdAEPlLyUig7W3GXAxmzO9jRHBv0gg4ni7qx5qKRzwYplesG0uVcZ8QB7gl7PzwR+Or
         xcMA==
X-Gm-Message-State: APjAAAVVjFJ4MjKIwiFleYSLajkB+61tVY5oe7JK30W5jPxhFcAKqAyd
        uEHJN5e8VyMzQy9BaAMMWuNx8fgbrhc=
X-Google-Smtp-Source: APXvYqz8xP66Ihb0QkWB2MrMceu1DMcgUkvCkUdBUkkFXBsJkIusqeZvd4iivLqdfGAUnSkIgIhy9g==
X-Received: by 2002:a65:47c1:: with SMTP id f1mr25636150pgs.169.1562619181724;
        Mon, 08 Jul 2019 13:53:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 14sm18218709pfy.40.2019.07.08.13.53.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 13:53:01 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:52:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/2] forcedeth: add recv cache make nic work steadily
Message-ID: <20190708135257.18200316@cakuba.netronome.com>
In-Reply-To: <1562307568-21549-2-git-send-email-yanjun.zhu@oracle.com>
References: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
        <1562307568-21549-2-git-send-email-yanjun.zhu@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 02:19:27 -0400, Zhu Yanjun wrote:
> A recv cache is added. The size of recv cache is 1000Mb / skb_length.
> When the system memory is not enough, this recv cache can make nic work
> steadily.
> When nic is up, this recv cache and work queue are created. When nic
> is down, this recv cache will be destroyed and delayed workqueue is
> canceled.
> When nic is polled or rx interrupt is triggerred, rx handler will
> get a skb from recv cache. Then the state of recv cache is checked.
> If recv cache is not in filling up state, a work is queued to fill
> up recv cache.
> When skb size is changed, the old recv cache is destroyed and new recv
> cache is created.
> When the system memory is not enough, the allocation of skb failed.
> recv cache will continue allocate skb until the recv cache is filled up.
> When the system memory is not enough, this can make nic work steadily.
> Becase of recv cache, the performance of nic is enhanced.
> 
> CC: Joe Jin <joe.jin@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Could you tell us a little more about the use case and the system
condition?

> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index b327b29..a673005 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -674,6 +674,11 @@ struct nv_ethtool_stats {
>  	u64 tx_broadcast;
>  };
>  
> +/* 1000Mb is 125M bytes, 125 * 1024 * 1024 bytes
> + * The length of recv cache is 125M / skb_length
> + */
> +#define RECV_CACHE_LIST_LENGTH		(125 * 1024 * 1024 / np->rx_buf_sz)
> +
>  #define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
>  #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
>  #define NV_DEV_STATISTICS_V1_COUNT (NV_DEV_STATISTICS_V2_COUNT - 6)
> @@ -844,8 +849,18 @@ struct fe_priv {
>  	char name_rx[IFNAMSIZ + 3];       /* -rx    */
>  	char name_tx[IFNAMSIZ + 3];       /* -tx    */
>  	char name_other[IFNAMSIZ + 6];    /* -other */
> +
> +	/* This is to schedule work */
> +	struct delayed_work     recv_cache_work;
> +	/* This list is to store skb queue for recv */
> +	struct sk_buff_head recv_list;
> +	unsigned long nv_recv_list_state;
>  };
>  
> +/* This is recv list state to fill up recv cache */
> +enum recv_list_state {
> +	RECV_LIST_ALLOCATE
> +};
>  /*
>   * Maximum number of loops until we assume that a bit in the irq mask
>   * is stuck. Overridable with module param.
> @@ -1804,7 +1819,11 @@ static int nv_alloc_rx(struct net_device *dev)
>  		less_rx = np->last_rx.orig;
>  
>  	while (np->put_rx.orig != less_rx) {
> -		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		struct sk_buff *skb = skb_dequeue(&np->recv_list);
> +
> +		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
> +			schedule_delayed_work(&np->recv_cache_work, 0);

Interesting, this seems to be coming up in multiple places recently..

Could you explain why you have your own RECV_LIST_ALLOCATE bit here?
Workqueue implementation itself uses an atomic bit to avoid scheduling
work mutliple times:

bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
			   struct delayed_work *dwork, unsigned long delay)
{
	struct work_struct *work = &dwork->work;
	bool ret = false;
	unsigned long flags;

	/* read the comment in __queue_work() */
	local_irq_save(flags);

	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
		__queue_delayed_work(cpu, wq, dwork, delay);
		ret = true;
	}

	local_irq_restore(flags);
	return ret;
}
EXPORT_SYMBOL(queue_delayed_work_on);

>  		if (likely(skb)) {
>  			np->put_rx_ctx->skb = skb;
>  			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
> @@ -1845,7 +1864,11 @@ static int nv_alloc_rx_optimized(struct net_device *dev)
>  		less_rx = np->last_rx.ex;
>  
>  	while (np->put_rx.ex != less_rx) {
> -		struct sk_buff *skb = netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		struct sk_buff *skb = skb_dequeue(&np->recv_list);
> +
> +		if (!test_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state))
> +			schedule_delayed_work(&np->recv_cache_work, 0);

It seems a little heavy to schedule this work on every packet, would it
make sense to add this in nv_napi_poll() instead?

>  		if (likely(skb)) {
>  			np->put_rx_ctx->skb = skb;
>  			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
> @@ -1957,6 +1980,40 @@ static void nv_init_tx(struct net_device *dev)
>  	}
>  }
>  
> +static void nv_init_recv_cache(struct net_device *dev)
> +{
> +	struct fe_priv *np = netdev_priv(dev);
> +
> +	skb_queue_head_init(&np->recv_list);
> +	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
> +		struct sk_buff *skb = netdev_alloc_skb(dev,
> +				 np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		/* skb is null. This indicates that memory is not
> +		 * enough.
> +		 */
> +		if (unlikely(!skb)) {
> +			ndelay(3);
> +			continue;

Does this path ever hit?  Seems like doing an ndelay() and retrying
allocation is not the best idea for non-preempt kernel.  

Also perhaps you should consider using __netdev_alloc_skb() and passing
GFP_KERNEL, that way the system has a chance to go into memory reclaim
(I presume this function can sleep).

> +		}
> +
> +		skb_queue_tail(&np->recv_list, skb);
> +	}
> +}
> +
> +static void nv_destroy_recv_cache(struct net_device *dev)
> +{
> +	struct sk_buff *skb;
> +	struct fe_priv *np = netdev_priv(dev);
> +
> +	cancel_delayed_work_sync(&np->recv_cache_work);
> +	WARN_ON(delayed_work_pending(&np->recv_cache_work));
> +
> +	while ((skb = skb_dequeue(&np->recv_list)))
> +		kfree_skb(skb);

skb_queue_purge()

> +	WARN_ON(skb_queue_len(&np->recv_list));
> +}
> +
>  static int nv_init_ring(struct net_device *dev)
>  {
>  	struct fe_priv *np = netdev_priv(dev);
> @@ -3047,6 +3104,8 @@ static int nv_change_mtu(struct net_device *dev, int new_mtu)
>  		nv_drain_rxtx(dev);
>  		/* reinit driver view of the rx queue */
>  		set_bufsize(dev);
> +		nv_destroy_recv_cache(dev);
> +		nv_init_recv_cache(dev);
>  		if (nv_init_ring(dev)) {
>  			if (!np->in_shutdown)
>  				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
> @@ -4074,6 +4133,32 @@ static void nv_free_irq(struct net_device *dev)
>  	}
>  }
>  
> +static void nv_recv_cache_worker(struct work_struct *work)
> +{
> +	struct fe_priv *np = container_of(work, struct fe_priv,
> +					  recv_cache_work.work);
> +
> +	set_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
> +	while (skb_queue_len(&np->recv_list) < RECV_CACHE_LIST_LENGTH) {
> +		struct sk_buff *skb = netdev_alloc_skb(np->dev,
> +				np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		/* skb is null. This indicates that memory is not
> +		 * enough.
> +		 * When the system memory is not enough, the kernel
> +		 * will compact memory or drop caches. At that time,
> +		 * if memory allocation fails, it had better wait some
> +		 * time for memory.
> +		 */
> +		if (unlikely(!skb)) {
> +			ndelay(3);
> +			continue;

Same comments as for the init function.

> +		}
> +
> +		skb_queue_tail(&np->recv_list, skb);
> +	}
> +	clear_bit(RECV_LIST_ALLOCATE, &np->nv_recv_list_state);
> +}
> +
>  static void nv_do_nic_poll(struct timer_list *t)
>  {
>  	struct fe_priv *np = from_timer(np, t, nic_poll);
> @@ -4129,6 +4214,8 @@ static void nv_do_nic_poll(struct timer_list *t)
>  			nv_drain_rxtx(dev);
>  			/* reinit driver view of the rx queue */
>  			set_bufsize(dev);
> +			nv_destroy_recv_cache(dev);
> +			nv_init_recv_cache(dev);
>  			if (nv_init_ring(dev)) {
>  				if (!np->in_shutdown)
>  					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);

