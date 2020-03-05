Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE41417A5F1
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgCENEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:04:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55043 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgCENEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:04:09 -0500
Received: by mail-wm1-f67.google.com with SMTP id i9so6211524wml.4
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 05:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ehlrr/1/hyrLWqL/B+s18qZN1kX34f05qJQzRkuogHk=;
        b=i8PZm2HI0Gq51KFWQxTajSAhMv+9Pkedn/G5Oqlj1f9Q5neL9IwVaLO2U+cfGYeLJi
         2/f14Cdxlp/TotqlAWqc0yVPEXXBO15UeF03Kb5+MBVHzH1jkHuS/0e5tX9iDaBDxUxL
         XfnhZL1qou/FDrDLQiP0WFl9CqZeMoREwGTrpgbUrXyeyYwt01rZ62b2KCn8Bh+rlkqA
         86g2ZEbAK9Cb6RFfLw3MPWpzOAOJ7uOejsEQSgP6Glc7Zg4nba7ADHU9TH5FfFB81Mxk
         YW25Sald6eXLrYlfbGTEUBph8CKddIeVj8TNw0zVuVcv8t9PQETnTtb8lTxSHH0FD3KV
         Grdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ehlrr/1/hyrLWqL/B+s18qZN1kX34f05qJQzRkuogHk=;
        b=rmgUyFHmPqsdN/HKaSY1BG0CFUCDNTG9HGPsffjKOU3DYuDqZm4ra1EkUxRm2eqRqH
         H8YhEPGRN9PhUjEoFziNMhgZ8nnhtSX3Wj1NY0rdK4tADrxCh7jzXHXceP4iDcCvxrOd
         whmxO33GObEHOjGWh+ZG/5w9Ne7WoAIv/xR0VUGf25K4x2r2ajgaVzgmdOaaPdrlg4Z/
         reHRNIaMbRC2SwQR1at4tVHIahNUpVvcmFW5n8hoWSK1LoviG02yFhxLjuawi25BzKyk
         lWF0TpIxPUm7w8cTDCjQOSuvuGH6xSRNwK4BZa1jUBfViYcfUk0Q4xuQxQNm8aMDgtk9
         ZzlA==
X-Gm-Message-State: ANhLgQ3Tu4xaMwjqCTCtHVWTKGBvnFbXpt8yH/W9I+cFUMBFhPXIHGAq
        pgNK23PcmGxHjrQnr+IEZQoEqg==
X-Google-Smtp-Source: ADFU+vtULcP7aTeLQCSCvyEJUNurNUVyF6tHlM40QFM6w9wLPrPCCYlBWJ2L0GatGVL4w3cNM6dJig==
X-Received: by 2002:a1c:9a88:: with SMTP id c130mr9919635wme.73.1583413447258;
        Thu, 05 Mar 2020 05:04:07 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id r3sm6707985wmg.19.2020.03.05.05.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 05:04:06 -0800 (PST)
Date:   Thu, 5 Mar 2020 15:04:04 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, jgross@suse.com
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
Message-ID: <20200305130404.GA574021@apalos.home>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Denis,

There's a bunch of things still missing from my remarks on V1.
XDP is not supposed to allocate and free pages constantly as that's one of the
things that's making it fast.

You are also missing proper support for XDP_REDIRECT, ndo_xdp_xmit. We usually
require the whole functionality to merge the driver.


On Mon, Mar 02, 2020 at 05:21:14PM +0300, Denis Kirjanov wrote:
>  
[...]
> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +		   struct xdp_buff *xdp)
> +{
> +	u32 len = rx->status;
> +	u32 act = XDP_PASS;
> +
> +	xdp->data_hard_start = page_address(pdata);
> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->handle = 0;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +	case XDP_TX:
> +	case XDP_DROP:

Maybe i am missing something on the usage, but XDP_TX and XDROP are handled
similarly?
XDP_TX is supposed to sent the packet out of the interface it arrived.

> +		break;
> +
> +	case XDP_ABORTED:
> +		trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +	if (act != XDP_PASS && act != XDP_TX)
> +		xdp->data_hard_start = NULL;
> +
> +	return act;
> +}
> +
>  static int xennet_get_responses(struct netfront_queue *queue,
>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>  				struct sk_buff_head *list)
> @@ -792,6 +830,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  	int slots = 1;
>  	int err = 0;
>  	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;
>  
>  	if (rx->flags & XEN_NETRXF_extra_info) {
>  		err = xennet_get_extras(queue, extras, rp);
> @@ -827,6 +868,22 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  
>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>  
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog) {
> +			/* currently only a single page contains data */
> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
> +			verdict = xennet_run_xdp(queue,
> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
> +				       rx, xdp_prog, &xdp);
> +
> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
> +				err = -EINVAL;
> +				goto next;
> +			}
> +
> +		}
> +		rcu_read_unlock();
>  		__skb_queue_tail(list, skb);
>  
>  next:
> @@ -1261,6 +1318,105 @@ static void xennet_poll_controller(struct net_device *dev)
>  }
>  #endif
>  
> +#define NETBACK_XDP_HEADROOM_DISABLE	0
> +#define NETBACK_XDP_HEADROOM_ENABLE	1
> +
> +static int talk_to_netback_xdp(struct netfront_info *np, int xdp)
> +{
> +	struct xenbus_transaction xbt;
> +	const char *message;
> +	int err;
> +
> +again:
> +	err = xenbus_transaction_start(&xbt);
> +	if (err) {
> +		xenbus_dev_fatal(np->xbdev, err, "starting transaction");
> +		goto out;
> +	}
> +
> +	err = xenbus_printf(xbt, np->xbdev->nodename, "feature-xdp", "%d", xdp);
> +	if (err) {
> +		message = "writing feature-xdp";
> +		goto abort_transaction;
> +	}
> +
> +	err = xenbus_transaction_end(xbt, 0);
> +	if (err) {
> +		if (err == -EAGAIN)
> +			goto again;
> +	}
> +
> +	return 0;
> +
> +abort_transaction:
> +	xenbus_dev_fatal(np->xbdev, err, "%s", message);
> +	xenbus_transaction_end(xbt, 1);
> +out:
> +	return err;
> +}
> +
> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +	unsigned int i, err;
> +
> +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
> +	if (!old_prog && !prog)
> +		return 0;
> +
> +	if (prog)
> +		bpf_prog_add(prog, dev->real_num_tx_queues);
> +
> +	for (i = 0; i < dev->real_num_tx_queues; ++i)
> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
> +
> +	if (old_prog)
> +		for (i = 0; i < dev->real_num_tx_queues; ++i)
> +			bpf_prog_put(old_prog);
> +
> +	err = talk_to_netback_xdp(np, old_prog ? NETBACK_XDP_HEADROOM_DISABLE:
> +				  NETBACK_XDP_HEADROOM_ENABLE);
> +	if (err)
> +		return err;
> +
> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
> +
> +	return 0;
> +}
> +
> +static u32 xennet_xdp_query(struct net_device *dev)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	unsigned int i;
> +	struct netfront_queue *queue;
> +	const struct bpf_prog *xdp_prog;
> +
> +	for (i = 0; i < num_queues; ++i) {
> +		queue = &np->queues[i];
> +		xdp_prog = rtnl_dereference(queue->xdp_prog);
> +		if (xdp_prog)
> +			return xdp_prog->aux->id;
> +	}
> +
> +	return 0;
> +}
> +
> +static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
> +	case XDP_QUERY_PROG:
> +		xdp->prog_id = xennet_xdp_query(dev);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static const struct net_device_ops xennet_netdev_ops = {
>  	.ndo_open            = xennet_open,
>  	.ndo_stop            = xennet_close,
> @@ -1272,6 +1428,7 @@ static void xennet_poll_controller(struct net_device *dev)
>  	.ndo_fix_features    = xennet_fix_features,
>  	.ndo_set_features    = xennet_set_features,
>  	.ndo_select_queue    = xennet_select_queue,
> +	.ndo_bpf            = xennet_xdp,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller = xennet_poll_controller,
>  #endif
> -- 
> 1.8.3.1
> 
Cheers
/Ilias
