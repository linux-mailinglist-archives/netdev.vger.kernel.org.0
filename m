Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB420211DC3
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgGBIIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgGBIIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:08:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AE4C08C5DC
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 01:08:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l17so25716590wmj.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 01:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OnB2PeH80Z2yTNUSHboJU/armphySHhXMqSE2LUNLHA=;
        b=vnWKlCcL1j/OYMqmERoRdKYikWnXg0lnbhjUam52wCuHnryjiNUbfNLtt10RYWCmbw
         1fus56nmE1E4s5A/7sHU/Yy0uDgcQiY/SIhVXp15pna0arv/25hGYasIk1W5sDhz8p0Z
         g51/ATVLhGwY8BWFSczLmCLxsG9LgVjlyBboKYN3ph3i5V9pGUGMlBVdXCXCR9uCe8fg
         Qh92gvuHueQ/z7fEWvce1Ob4T4gkC3GAZXvL4mE8vS91zcTPXv1ybZbe88awEy1Q8LQG
         1on8eyYCwzBQ5pFKVeNRyCo+IxPJn+OebSCklL6Mof0XYtE02e77z23f36LzJnLTLmBF
         zQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OnB2PeH80Z2yTNUSHboJU/armphySHhXMqSE2LUNLHA=;
        b=SKm+RN+AODHwQF+VDcfOXj1J0hX+lC58DKv3/nSvyuCDacb/ZG+z6ved5urH7sXYWn
         vmk3ytVSHqAtXZI0y/M+qOLd2n6nmDQuQfPTzSV3uGf7xBid2pcV/Klxfgi5XzrOgefq
         HQlex5PkC5yE71FBkzkRVbs43R9xRIe90viaPkr9ArJAvAJnfChfHwsk0xDFwjXoAMGx
         DBi1sqYxpJQ7TlBCax4BHmPfORt9N8OrvvbUKU305RhKlb0TyLkZiI6DVTfcqs9zY4Wu
         0oDSb3YffiyC5rqhe+yCw+2n2q8rUhH8QoldaZFz4tpPVf+ksoxzJoeVGj9NX4FduDjI
         yY4w==
X-Gm-Message-State: AOAM531Sxy+I6sIjXPr4ANGvH1HvJxxeWgCwVTJ2GuvLBISOpYG/hm98
        d5M1Qgp/jEdutjYYEiExC6/6qw==
X-Google-Smtp-Source: ABdhPJwuzmUrgiIjv9uMlmPmZ4Rp94Nn/qUKBzKzeyRkmYIV+7VmAe2yV9dkOXRGmsk4DrKxybhU7Q==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr30201567wmg.74.1593677302615;
        Thu, 02 Jul 2020 01:08:22 -0700 (PDT)
Received: from apalos.home (athedsl-4423884.home.otenet.gr. [79.130.240.188])
        by smtp.gmail.com with ESMTPSA id 59sm10445190wrj.37.2020.07.02.01.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 01:08:21 -0700 (PDT)
Date:   Thu, 2 Jul 2020 11:08:19 +0300
From:   ilias.apalodimas@linaro.org
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next 3/4] mvpp2: add basic XDP support
Message-ID: <20200702080819.GA499364@apalos.home>
References: <20200630180930.87506-1-mcroce@linux.microsoft.com>
 <20200630180930.87506-4-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630180930.87506-4-mcroce@linux.microsoft.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 08:09:29PM +0200, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Add XDP native support.
> By now only XDP_DROP, XDP_PASS and XDP_REDIRECT
> verdicts are supported.
> 
> Co-developed-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---

[...]

>  }
>  
> +static int
> +mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
> +	      struct bpf_prog *prog, struct xdp_buff *xdp,
> +	      struct page_pool *pp)
> +{
> +	unsigned int len, sync, err;
> +	struct page *page;
> +	u32 ret, act;
> +
> +	len = xdp->data_end - xdp->data_hard_start - MVPP2_SKB_HEADROOM;
> +	act = bpf_prog_run_xdp(prog, xdp);
> +
> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> +	sync = xdp->data_end - xdp->data_hard_start - MVPP2_SKB_HEADROOM;
> +	sync = max(sync, len);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		ret = MVPP2_XDP_PASS;
> +		break;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(port->dev, xdp, prog);
> +		if (unlikely(err)) {
> +			ret = MVPP2_XDP_DROPPED;
> +			page = virt_to_head_page(xdp->data);
> +			page_pool_put_page(pp, page, sync, true);
> +		} else {
> +			ret = MVPP2_XDP_REDIR;
> +		}
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(port->dev, prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +		page = virt_to_head_page(xdp->data);
> +		page_pool_put_page(pp, page, sync, true);
> +		ret = MVPP2_XDP_DROPPED;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  /* Main rx processing */
>  static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		    int rx_todo, struct mvpp2_rx_queue *rxq)
>  {
>  	struct net_device *dev = port->dev;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
>  	int rx_received;
>  	int rx_done = 0;
> +	u32 xdp_ret = 0;
>  	u32 rcvd_pkts = 0;
>  	u32 rcvd_bytes = 0;
>  
> +	rcu_read_lock();
> +
> +	xdp_prog = READ_ONCE(port->xdp_prog);
> +
>  	/* Get number of received packets and clamp the to-do */
>  	rx_received = mvpp2_rxq_received(port, rxq->id);
>  	if (rx_todo > rx_received)
> @@ -3060,7 +3115,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		dma_addr_t dma_addr;
>  		phys_addr_t phys_addr;
>  		u32 rx_status;
> -		int pool, rx_bytes, err;
> +		int pool, rx_bytes, err, ret;
>  		void *data;
>  
>  		rx_done++;
> @@ -3096,6 +3151,33 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		else
>  			frag_size = bm_pool->frag_size;
>  
> +		if (xdp_prog) {
> +			xdp.data_hard_start = data;
> +			xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> +			xdp.data_end = xdp.data + rx_bytes;
> +			xdp.frame_sz = PAGE_SIZE;
> +
> +			if (bm_pool->pkt_size == MVPP2_BM_SHORT_PKT_SIZE)
> +				xdp.rxq = &rxq->xdp_rxq_short;
> +			else
> +				xdp.rxq = &rxq->xdp_rxq_long;
> +
> +			xdp_set_data_meta_invalid(&xdp);
> +
> +			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp);
> +
> +			if (ret) {
> +				xdp_ret |= ret;
> +				err = mvpp2_rx_refill(port, bm_pool, pp, pool);
> +				if (err) {
> +					netdev_err(port->dev, "failed to refill BM pools\n");
> +					goto err_drop_frame;
> +				}
> +
> +				continue;
> +			}
> +		}
> +
>  		skb = build_skb(data, frag_size);
>  		if (!skb) {
>  			netdev_warn(port->dev, "skb build failed\n");
> @@ -3118,7 +3200,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		rcvd_pkts++;
>  		rcvd_bytes += rx_bytes;
>  
> -		skb_reserve(skb, MVPP2_MH_SIZE + NET_SKB_PAD);
> +		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
>  		skb_put(skb, rx_bytes);
>  		skb->protocol = eth_type_trans(skb, dev);
>  		mvpp2_rx_csum(port, rx_status, skb);
> @@ -3133,6 +3215,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
>  	}
>  
> +	rcu_read_unlock();
> +
>  	if (rcvd_pkts) {
>  		struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
>  
> @@ -3608,6 +3692,8 @@ static void mvpp2_start_dev(struct mvpp2_port *port)
>  	}
>  
>  	netif_tx_start_all_queues(port->dev);
> +
> +	clear_bit(0, &port->state);
>  }
>  
>  /* Set hw internals when stopping port */
> @@ -3615,6 +3701,8 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
>  {
>  	int i;
>  
> +	set_bit(0, &port->state);
> +
>  	/* Disable interrupts on all threads */
>  	mvpp2_interrupts_disable(port);
>  
> @@ -4021,6 +4109,10 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
>  	}
>  
>  	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
> +		if (port->xdp_prog) {
> +			netdev_err(dev, "Jumbo frames are not supported with XDP\n");

Does it make sense to switch to NL_SET_ERR_MSG_MOD() here, so the user can get
an immediate feedback?

> +			return -EINVAL;
> +		}
>  		if (priv->percpu_pools) {
>  			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
>  			mvpp2_bm_switch_buffers(priv, false);
> @@ -4159,6 +4251,73 @@ static int mvpp2_set_features(struct net_device *dev,
>  	return 0;
>  }
>  
> +static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
> +{
> +	struct bpf_prog *prog = bpf->prog, *old_prog;
> +	bool running = netif_running(port->dev);
> +	bool reset = !prog != !port->xdp_prog;
> +
> +	if (port->dev->mtu > ETH_DATA_LEN) {
> +		netdev_err(port->dev, "Jumbo frames are not supported by XDP, current MTU %d.\n",
> +			   port->dev->mtu);

ditto

> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (!port->priv->percpu_pools) {
> +		netdev_err(port->dev, "Per CPU Pools required for XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* device is up and bpf is added/removed, must setup the RX queues */
> +	if (running && reset) {
> +		mvpp2_stop_dev(port);
> +		mvpp2_cleanup_rxqs(port);
> +		mvpp2_cleanup_txqs(port);
> +	}
> +
> +	old_prog = xchg(&port->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	/* bpf is just replaced, RXQ and MTU are already setup */
> +	if (!reset)
> +		return 0;
> +
> +	/* device was up, restore the link */
> +	if (running) {
> +		int ret = mvpp2_setup_rxqs(port);
> +
> +		if (ret) {
> +			netdev_err(port->dev, "mvpp2_setup_rxqs failed\n");
> +			return ret;
> +		}
> +		ret = mvpp2_setup_txqs(port);
> +		if (ret) {
> +			netdev_err(port->dev, "mvpp2_setup_txqs failed\n");
> +			return ret;
> +		}
> +
> +		mvpp2_start_dev(port);
> +	}
> +
> +	return 0;
> +}
> +
> +static int mvpp2_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	struct mvpp2_port *port = netdev_priv(dev);
> +
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return mvpp2_xdp_setup(port, xdp);
> +	case XDP_QUERY_PROG:
> +		xdp->prog_id = port->xdp_prog ? port->xdp_prog->aux->id : 0;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  /* Ethtool methods */
>  
>  static int mvpp2_ethtool_nway_reset(struct net_device *dev)
> @@ -4509,6 +4668,7 @@ static const struct net_device_ops mvpp2_netdev_ops = {
>  	.ndo_vlan_rx_add_vid	= mvpp2_vlan_rx_add_vid,
>  	.ndo_vlan_rx_kill_vid	= mvpp2_vlan_rx_kill_vid,
>  	.ndo_set_features	= mvpp2_set_features,
> +	.ndo_bpf		= mvpp2_xdp,
>  };
>  
>  static const struct ethtool_ops mvpp2_eth_tool_ops = {
> -- 
> 2.26.2
> 
