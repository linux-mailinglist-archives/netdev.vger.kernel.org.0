Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AEF1CC083
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 12:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEIKrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 06:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbgEIKrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 06:47:53 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D90C061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 03:47:53 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id b20so3502525ejg.11
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 03:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=5aFe1rFE5PSFkL85oCeV3du0AZioksJej0skqLEftIs=;
        b=aQgUcuwo20Cl6wPPTtuBGawajhtb9+dQy5/fU6gWpbTcIcAyRuYfzphBps8XsaNj3N
         EVDdpabXVDVYsM+ru51rnBoY+7sp6wW4YmO7qQscZRbmr1cuv/T1pwh9ee+aNMLhgVTA
         XAiTv/2P+g516Q7ySz6Y0ZaLNLoV6AzcGKKmi7qkrzWt8HpYaYZTp1SvQ5iGTy/iTzXw
         Fb1fGIs4gHchXUm4ArqHSCZJ/f3WQj3uyHl5HkwwL+SgMepS4L/j2JWMx+FqVD8vbPD+
         hNEfuXyTvdiKjK6O69P7NDdkcMeziRFiWtRIfxTBtxoR9MkPPBtualmTk8Aa53tIOzkY
         LF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=5aFe1rFE5PSFkL85oCeV3du0AZioksJej0skqLEftIs=;
        b=BxY0AcmMk0T1ooxFG6MdCbAphn38N/ncPxOZsTiV2ZEblet6750FXMmXPRC3qTT7Lg
         HorjIU10PDqalk03oGO3Fq4u6oBRlTUuiGlOfRlEiChgHlmnJAhiRG1Nxij/h4DCjfJ5
         8Xxjhu2vlyvTxAEBJKfwiqMjRH7tS2GAg2tDS74DQujH1dQlOcS4mG6mOgyTye0t0yET
         cKjAnzANq+GPR1u6+au5ggIhsqQGbz2QPct55OkS/e45O6vhVLbD1sTB9aSXKvu7vJWU
         8AWpGl4r4GoT3Z3T5lkPkJ1VHOXYhrsuA2rvLBaysZq0Dkz2IdsnqPDrwEIOADcY/y4g
         yusg==
X-Gm-Message-State: AGi0PuYkb6CddsJgnkYcRzoWwTvTWwXZbEd2+viFWXze6id7/J9bdGUC
        3988FFd9hidcp01L9dqWyNQIZ9RLEDCnoP9MX2zTHg==
X-Google-Smtp-Source: APiQypLg6QOZ6zo/DKvdE+fntBsvWOZixVVsnn85rfJlg/Jt6qiGZIBXs3aLdTwTPKL69aXgchUzyjqg8DJip9hS0uo=
X-Received: by 2002:a17:906:4c8e:: with SMTP id q14mr5799316eju.208.1589021271704;
 Sat, 09 May 2020 03:47:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:7497:0:0:0:0:0 with HTTP; Sat, 9 May 2020 03:47:51 -0700 (PDT)
X-Originating-IP: [5.35.46.227]
In-Reply-To: <20200508140704.41eb0722@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org> <20200508140704.41eb0722@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sat, 9 May 2020 13:47:51 +0300
Message-ID: <CAOJe8K35ZxWzgiXd+eB_VULQPMv2+aRME9otgd8=2fLXs9K8zA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 1/3] xen networking: add basic XDP support for xen-netfront
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  7 May 2020 15:40:39 +0300 Denis Kirjanov wrote:
>> The patch adds a basic XDP processing to xen-netfront driver.
>>
>> We ran an XDP program for an RX response received from netback
>> driver. Also we request xen-netback to adjust data offset for
>> bpf_xdp_adjust_head() header space for custom headers.
>>
>> synchronization between frontend and backend parts is done
>> by using xenbus state switching:
>> Reconfiguring -> Reconfigured- > Connected
>>
>> UDP packets drop rate using xdp program is around 310 kpps
>> using ./pktgen_sample04_many_flows.sh and 160 kpps without the patch.
>
> Please provide a cover letter for the submission.
>
>> @@ -167,6 +179,9 @@ struct netfront_rx_info {
>>  	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
>>  };
>>
>> +static int xennet_xdp_xmit(struct net_device *dev, int n,
>> +			   struct xdp_frame **frames, u32 flags);
>
> Is it possible to put the function here and avoid the forward
> declaration?

Sure

>
>>  static void skb_entry_set_link(union skb_entry *list, unsigned short id)
>>  {
>>  	list->link = id;
>> @@ -265,8 +280,8 @@ static struct sk_buff
>> *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
>>  	if (unlikely(!skb))
>>  		return NULL;
>>
>> -	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
>> -	if (!page) {
>> +	page = page_pool_dev_alloc_pages(queue->page_pool);
>> +	if (unlikely(!page)) {
>>  		kfree_skb(skb);
>>  		return NULL;
>>  	}
>> @@ -778,6 +793,53 @@ static int xennet_get_extras(struct netfront_queue
>> *queue,
>>  	return err;
>>  }
>>
>> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
>
> static
>
>> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
>> +		   struct xdp_buff *xdp)
>> +{
>> +	struct xdp_frame *xdpf;
>> +	u32 len = rx->status;
>> +	u32 act = XDP_PASS;
>> +	int err;
>> +
>> +	xdp->data_hard_start = page_address(pdata);
>> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
>> +	xdp_set_data_meta_invalid(xdp);
>> +	xdp->data_end = xdp->data + len;
>> +	xdp->rxq = &queue->xdp_rxq;
>> +	xdp->handle = 0;
>
> No need to clear this.
>
>> +	act = bpf_prog_run_xdp(prog, xdp);
>> +	switch (act) {
>> +	case XDP_TX:
>> +		get_page(pdata);
>> +		xdpf = convert_to_xdp_frame(xdp);
>> +		err = xennet_xdp_xmit(queue->info->netdev, 1, &xdpf, 0);
>> +		if (unlikely(err < 0))
>> +			trace_xdp_exception(queue->info->netdev, prog, act);
>> +		break;
>> +	case XDP_REDIRECT:
>> +		get_page(pdata);
>> +		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
>> +		if (unlikely(err))
>> +			trace_xdp_exception(queue->info->netdev, prog, act);
>> +		xdp_do_flush();
>
> Can you call flush after the RX loop? (xennet_poll()?) This is supposed
> to batch all redirections in the NAPI cycle.

Ok, will do

>
>> +		break;
>> +	case XDP_PASS:
>> +	case XDP_DROP:
>> +		break;
>> +
>> +	case XDP_ABORTED:
>> +		trace_xdp_exception(queue->info->netdev, prog, act);
>> +		break;
>> +
>> +	default:
>> +		bpf_warn_invalid_xdp_action(act);
>> +	}
>> +
>> +	return act;
>> +}
>> +
>>  static int xennet_get_responses(struct netfront_queue *queue,
>>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>>  				struct sk_buff_head *list)
>> @@ -792,6 +854,9 @@ static int xennet_get_responses(struct netfront_queue
>> *queue,
>>  	int slots = 1;
>>  	int err = 0;
>>  	unsigned long ret;
>> +	struct bpf_prog *xdp_prog;
>> +	struct xdp_buff xdp;
>> +	u32 verdict;
>>
>>  	if (rx->flags & XEN_NETRXF_extra_info) {
>>  		err = xennet_get_extras(queue, extras, rp);
>> @@ -827,9 +892,20 @@ static int xennet_get_responses(struct netfront_queue
>> *queue,
>>
>>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>>
>> -		__skb_queue_tail(list, skb);
>> -
>> +		rcu_read_lock();
>> +		xdp_prog = rcu_dereference(queue->xdp_prog);
>> +		if (xdp_prog && !(rx->flags & XEN_NETRXF_more_data)) {
>
> What is XEN_NETRXF_more_data?
>
> If you have a mis-formatted frame it has to be dropped, nothing can
> escape the XDP program and go to the stack.

I see, thanks.

>
>> +			/* currently only a single page contains data */
>> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
>> +			verdict = xennet_run_xdp(queue,
>> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
>> +				       rx, xdp_prog, &xdp);
>> +			if (verdict != XDP_PASS)
>> +				err = -EINVAL;
>> +		}
>> +		rcu_read_unlock();
>>  next:
>> +		__skb_queue_tail(list, skb);
>>  		if (!(rx->flags & XEN_NETRXF_more_data))
>>  			break;
>>
>
>> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>> +			struct netlink_ext_ack *extack)
>> +{
>> +	struct netfront_info *np = netdev_priv(dev);
>> +	struct bpf_prog *old_prog;
>> +	unsigned int i, err;
>> +	unsigned long int max_mtu = XEN_PAGE_SIZE - XDP_PACKET_HEADROOM;
>> +
>> +	if (dev->mtu > max_mtu) {
>> +		netdev_warn(dev, "XDP requires MTU less than %lu\n", max_mtu);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!np->netback_has_xdp_headroom)
>> +		return 0;
>> +
>> +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
>> +	if (!old_prog && !prog)
>
> You don't have to check this, the core will not call drivers any more
> if there is no program and request is to disable XDP.
>
>> +		return 0;
>> +
>> +	if (prog)
>> +		bpf_prog_add(prog, dev->real_num_tx_queues);
>> +
>> +	for (i = 0; i < dev->real_num_tx_queues; ++i)
>> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
>
> I'm I reading this right the moment you assign the program the RX
> function will start assuming there is a headroom, even if you haven't
> reconfigured the backend, yet..

That's a good catch. Thank you.

>
>> +	if (old_prog)
>> +		for (i = 0; i < dev->real_num_tx_queues; ++i)
>> +			bpf_prog_put(old_prog);
>> +
>> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
>> +
>> +	err = talk_to_netback_xdp(np, prog ? NETBACK_XDP_HEADROOM_ENABLE:
>> +				  NETBACK_XDP_HEADROOM_DISABLE);
>> +	if (err)
>> +		return err;
>> +
>> +	/* avoid race with XDP headroom adjustment */
>> +	wait_event(module_wq,
>> +		   xenbus_read_driver_state(np->xbdev->otherend) ==
>> +		   XenbusStateReconfigured);
>> +	np->netfront_xdp_enabled = true;
>> +	xenbus_switch_state(np->xbdev, XenbusStateConnected);
>> +
>> +	return 0;
>> +}
>> +
>
>> @@ -1754,6 +1993,51 @@ static void xennet_destroy_queues(struct
>> netfront_info *info)
>>  	info->queues = NULL;
>>  }
>>
>> +
>> +
>> +static int xennet_create_page_pool(struct netfront_queue *queue)
>
> Please run checkpatch --strict on your patches.
>
