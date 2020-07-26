Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9785522E170
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 18:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGZQtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 12:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgGZQtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 12:49:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4AC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 09:49:34 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k71so7871631pje.0
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 09:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ptAXm213M6O9WpuIoeZ/qe/eZ+MZhkv9NR00W2Q54JM=;
        b=Pr6vhbU7UrCIHA7juhxgjLjWNRCxrKMcvT9ZiOxYPMVonsLOXSNAuLZHzcw5Oxb+Jg
         2vcTDh6kSaw6WWB4xydK9K5XdD7DCeZuqGzOlQtV0ehK59WwF9SAgHJWD2Sog9WBtrJI
         sO+BDauqVn4N8hXuIPcJJwHdW1UPvPJPsEHTmxS854i1LPXze1tDPFUaxFEFtFunIf3m
         jEK/ZvpsiZymjGeIHGACJH05MNxbebyV8s3fDLAMX5Qx4PASJEslL48qDd+WtIwYFqVl
         npti/DrkTJNH9CaVYb0h0Kl22QUfFI1yTAYsZXnHuu+eI9f02kxTtEbEyumy8tx7sS0O
         cyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ptAXm213M6O9WpuIoeZ/qe/eZ+MZhkv9NR00W2Q54JM=;
        b=mr8ydNqlqN6zdfIwRQbUQ2Olm5UQSgbuRoelaiyUk/gVB5/OBmIY8ZAgAG+BQJqZwn
         sCy+HX56sCy5gSYH+D7RXvuhJTKcn9dBKtQuW41h+lds2BLkz6n2xVlw/I2N4G3uhA95
         CXGzzKT6C4WRezbCpDIVpRXKye7GfPd0076eXHRUnWPMqiO6OM55OVtXAtaD0id9LQ7f
         S37gSSu1CAUP73CVwUnvvwExJxw+0Bmc+9390J3i5QVCXo2PZWkUG9PEsXTo9NI73pTX
         YJK43UA+REtpIVdVEVUoA0uK+S0G6lnScRtL+I/3T/DhbYZ8ksaHqPhsYL+SlJ7M1BpN
         9GtA==
X-Gm-Message-State: AOAM531ErT8HDJgLGjgMr7ikryE3smPIUnXZnC40C0bFffPyDkbYRM/K
        F2Yt41FMad+SlfBIssMlDzw=
X-Google-Smtp-Source: ABdhPJyIqCVZrRcsKInwDawtp2OIgRDtQbnI+gmRbvaNjPo32qIvES+FmoySKtwrDfr9S2qzHMb13w==
X-Received: by 2002:a17:902:9009:: with SMTP id a9mr14783491plp.252.1595782173753;
        Sun, 26 Jul 2020 09:49:33 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x13sm12003672pfj.122.2020.07.26.09.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2020 09:49:32 -0700 (PDT)
Subject: Re: [RFC] net: add support for threaded NAPI polling
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200726163119.86162-1-nbd@nbd.name>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <546c2923-ca6e-00e7-8bcb-3a3eb034a58e@gmail.com>
Date:   Sun, 26 Jul 2020 09:49:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200726163119.86162-1-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/26/20 9:31 AM, Felix Fietkau wrote:
> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
> poll function does not perform well. Since NAPI poll is bound to the CPU it
> was scheduled from, we can easily end up with a few very busy CPUs spending
> most of their time in softirq/ksoftirqd and some idle ones.
> 
> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
> same except for using netif_threaded_napi_add instead of netif_napi_add.
> 
> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
> thread.
> 
> With threaded NAPI, throughput seems stable and consistent (and higher than
> the best results I got without it).

Note that even with a threaded NAPI, you will not be able to use more than one cpu
to process the traffic.

Also I wonder how this will scale to more than one device using this ?

Say we need 4 NAPI, how the different work queues will mix together ?

We invented years ago RPS and RFS, to be able to spread incoming traffic
to more cpus, for devices having one hardware queue.


> 
> Based on a patch by Hillf Danton
> 
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  include/linux/netdevice.h | 23 ++++++++++++++++++++++
>  net/core/dev.c            | 40 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ac2cd3f49aba..3a39211c7598 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -347,6 +347,7 @@ struct napi_struct {
>  	struct list_head	dev_list;
>  	struct hlist_node	napi_hash_node;
>  	unsigned int		napi_id;
> +	struct work_struct	work;
>  };
>  
>  enum {
> @@ -357,6 +358,7 @@ enum {
>  	NAPI_STATE_HASHED,	/* In NAPI hash (busy polling possible) */
>  	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>  	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
> +	NAPI_STATE_THREADED,	/* Use threaded NAPI */
>  };
>  
>  enum {
> @@ -367,6 +369,7 @@ enum {
>  	NAPIF_STATE_HASHED	 = BIT(NAPI_STATE_HASHED),
>  	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>  	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
> +	NAPIF_STATE_THREADED	 = BIT(NAPI_STATE_THREADED),
>  };
>  
>  enum gro_result {
> @@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  		    int (*poll)(struct napi_struct *, int), int weight);
>  
> +/**
> + *	netif_threaded_napi_add - initialize a NAPI context
> + *	@dev:  network device
> + *	@napi: NAPI context
> + *	@poll: polling function
> + *	@weight: default weight
> + *
> + * This variant of netif_napi_add() should be used from drivers using NAPI
> + * with CPU intensive poll functions.
> + * This will schedule polling from a high priority workqueue that
> + */
> +static inline void netif_threaded_napi_add(struct net_device *dev,
> +					   struct napi_struct *napi,
> +					   int (*poll)(struct napi_struct *, int),
> +					   int weight)
> +{
> +	set_bit(NAPI_STATE_THREADED, &napi->state);
> +	netif_napi_add(dev, napi, poll, weight);
> +}
> +
>  /**
>   *	netif_tx_napi_add - initialize a NAPI context
>   *	@dev:  network device
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 19f1abc26fcd..e140b6a9d5eb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
>  struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>  struct list_head ptype_all __read_mostly;	/* Taps */
>  static struct list_head offload_base __read_mostly;
> +static struct workqueue_struct *napi_workq __read_mostly;
>  
>  static int netif_rx_internal(struct sk_buff *skb);
>  static int call_netdevice_notifiers_info(unsigned long val,
> @@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
>  {
>  	unsigned long flags;
>  
> +	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
> +		queue_work(napi_workq, &n->work);
> +		return;
> +	}
> +
>  	local_irq_save(flags);
>  	____napi_schedule(this_cpu_ptr(&softnet_data), n);
>  	local_irq_restore(flags);
> @@ -6333,6 +6339,11 @@ EXPORT_SYMBOL(napi_schedule_prep);
>   */
>  void __napi_schedule_irqoff(struct napi_struct *n)
>  {
> +	if (test_bit(NAPI_STATE_THREADED, &n->state)) {
> +		queue_work(napi_workq, &n->work);
> +		return;
> +	}

I do not believe we want to add yet another test in this fast path.

Presumably drivers willing to use thread NAPI can use different interface
and directly call queue_work(), without testing NAPI_STATE_THREADED.

> +
>  	____napi_schedule(this_cpu_ptr(&softnet_data), n);
>  }
>  EXPORT_SYMBOL(__napi_schedule_irqoff);
> @@ -6601,6 +6612,30 @@ static void init_gro_hash(struct napi_struct *napi)
>  	napi->gro_bitmask = 0;
>  }
>  
> +static void napi_workfn(struct work_struct *work)
> +{
> +	struct napi_struct *n = container_of(work, struct napi_struct, work);
> +
> +	for (;;) {
> +		if (!test_bit(NAPI_STATE_SCHED, &n->state))

This all looks wrong, some important GRO logic is implemented in napi_poll()

You can not bypass napi_poll()

> +			return;
> +
> +		if (n->poll(n, n->weight) < n->weight)
> +			return;
> +
> +		if (!need_resched())
> +			continue;
> +


Why not simply using cond_resched() ?

> +		/*
> +		 * have to pay for the latency of task switch even if
> +		 * napi is scheduled
> +		 */
> +		if (test_bit(NAPI_STATE_SCHED, &n->state))
> +			queue_work(napi_workq, work);
> +		return;
> +	}
> +}
> +
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  		    int (*poll)(struct napi_struct *, int), int weight)
>  {
> @@ -6621,6 +6656,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  #ifdef CONFIG_NETPOLL
>  	napi->poll_owner = -1;
>  #endif
> +	INIT_WORK(&napi->work, napi_workfn);
>  	set_bit(NAPI_STATE_SCHED, &napi->state);
>  	napi_hash_add(napi);
>  }
> @@ -10676,6 +10712,10 @@ static int __init net_dev_init(void)
>  		sd->backlog.weight = weight_p;
>  	}
>  
> +	napi_workq = alloc_workqueue("napi_workq", WQ_UNBOUND | WQ_HIGHPRI,
> +				     WQ_UNBOUND_MAX_ACTIVE);
> +	BUG_ON(!napi_workq);
> +
>  	dev_boot_phase = 0;
>  
>  	/* The loopback device is special if any other network devices
> 
