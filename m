Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDB20373F
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgFVMum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728203AbgFVMul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:50:41 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A5C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 05:50:41 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id y10so3487946eje.1
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 05:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=PoDmfrvK7J0OSuL9Jzbk3t6WaDsUs7TZNo7pWlGIKRo=;
        b=MmaLPnLO+jkC9KkSUAXNzvlhQeueBYlLEggDjJR6shNL8ZQlgiUdPsfMEgrw/IcsrL
         FmmXRcxTji8fLJ/eZpOq0SmGSZoIu2BA3my36/qa+rZTSw0xjrI0ru8rguSpKGOm7QbR
         JdSmk3ZrEMkCKnoHq+PYci5e2ByIwoiyPjYeOb2kCWGWoXuEDgRo9W5BXaT1BZhQAesH
         BxWmAiQzU2IOXSaJ/Bewi63g6YPBrM2KaICYJ9WhI3DJL+la1TBq3IVGYZnutCnIdT3a
         3c17AsLC/FjpcI4k9akokf+5lHELD1M9YI39ARgW9jMRxJZxaI5kRoRV4IUyhkhajILh
         CYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=PoDmfrvK7J0OSuL9Jzbk3t6WaDsUs7TZNo7pWlGIKRo=;
        b=aswM6bGtvBbPEOr/0cHTOe2pDKllpvVUMUVrRht+euERAkveOikmlhVvNW9wOqpbfE
         9NfeSkMAmiil67PYxlj0Qj5IvUcUb4fYbOStvl78uR1QXY+TKybkiOTepdaLuC5v1sCB
         fL9iuVqvoOyAiOhvD/9j8F+KrP3bvL1cml8C9+t4wLJS1ntH6yl4haiLs+RcaYArcvYB
         KxK9fikiYhDlh6jt+LLDK7MUdK7ehtxctRrc5Ak76yaX+HcO123+fy/TAFq+OisYBrXN
         8s2bMQY0f5r3hlRKCSXvZVJWF12CGmzmu12tw60yzKX25CYU7p0upZB40SZ33Vlz+QRk
         wv/w==
X-Gm-Message-State: AOAM531HXRrXGaKq1udye+PvmLR4UrhAqmRCMsqxssLs+752Aq5fxKD7
        kAUnifk2R7DUIjQuxziyzl7sbCwF0cEx7pV0lfo78A==
X-Google-Smtp-Source: ABdhPJwGJ6kM/ECfSqtpyxwzSk2r1mtncDn+GOOOjo4qp7JXefRaD296mdORnFG0fuL04DW92hdNWmHoz7gKbxdhJ6w=
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr1574462ejx.77.1592830240114;
 Mon, 22 Jun 2020 05:50:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Mon, 22 Jun 2020 05:50:39
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <001f01d6487d$50ae9960$f20bcc20$@xen.org>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
 <1592817672-2053-4-git-send-email-kda@linux-powerpc.org> <001f01d6487d$50ae9960$f20bcc20$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 22 Jun 2020 15:50:39 +0300
Message-ID: <CAOJe8K3+V9G24YHppo6HcEP5B5vtei2F_MSiSEjekayXGqEwBg@mail.gmail.com>
Subject: Re: [PATCH net-next v10 3/3] xen networking: add XDP offset
 adjustment to xen-netback
To:     paul@xen.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Sent: 22 June 2020 10:21
>> To: netdev@vger.kernel.org
>> Cc: brouer@redhat.com; jgross@suse.com; wei.liu@kernel.org; paul@xen.org;
>> ilias.apalodimas@linaro.org
>> Subject: [PATCH net-next v10 3/3] xen networking: add XDP offset
>> adjustment to xen-netback
>>
>> the patch basically adds the offset adjustment and netfront
>> state reading to make XDP work on netfront side.
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
>>  drivers/net/xen-netback/common.h    |  4 ++++
>>  drivers/net/xen-netback/interface.c |  2 ++
>>  drivers/net/xen-netback/netback.c   |  7 +++++++
>>  drivers/net/xen-netback/rx.c        | 15 ++++++++++++++-
>>  drivers/net/xen-netback/xenbus.c    | 32
>> ++++++++++++++++++++++++++++++++
>>  5 files changed, 59 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/xen-netback/common.h
>> b/drivers/net/xen-netback/common.h
>> index 05847eb..f14dc10 100644
>> --- a/drivers/net/xen-netback/common.h
>> +++ b/drivers/net/xen-netback/common.h
>> @@ -281,6 +281,9 @@ struct xenvif {
>>  	u8 ipv6_csum:1;
>>  	u8 multicast_control:1;
>>
>> +	/* headroom requested by xen-netfront */
>> +	u16 netfront_xdp_headroom;
>> +
>>  	/* Is this interface disabled? True when backend discovers
>>  	 * frontend is rogue.
>>  	 */
>> @@ -395,6 +398,7 @@ static inline pending_ring_idx_t
>> nr_pending_reqs(struct xenvif_queue *queue)
>>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
>>
>>  extern bool separate_tx_rx_irq;
>> +extern bool provides_xdp_headroom;
>>
>>  extern unsigned int rx_drain_timeout_msecs;
>>  extern unsigned int rx_stall_timeout_msecs;
>> diff --git a/drivers/net/xen-netback/interface.c
>> b/drivers/net/xen-netback/interface.c
>> index 0c8a02a..fc16edd 100644
>> --- a/drivers/net/xen-netback/interface.c
>> +++ b/drivers/net/xen-netback/interface.c
>> @@ -483,6 +483,8 @@ struct xenvif *xenvif_alloc(struct device *parent,
>> domid_t domid,
>>  	vif->queues = NULL;
>>  	vif->num_queues = 0;
>>
>> +	vif->netfront_xdp_headroom = 0;
>> +
>
Hi Paul,

> How about just 'xdp_headroom'? It's shorter to type :-)

makes sense.

>
>>  	spin_lock_init(&vif->lock);
>>  	INIT_LIST_HEAD(&vif->fe_mcast_addr);
>>
>> diff --git a/drivers/net/xen-netback/netback.c
>> b/drivers/net/xen-netback/netback.c
>> index 315dfc6..6dfca72 100644
>> --- a/drivers/net/xen-netback/netback.c
>> +++ b/drivers/net/xen-netback/netback.c
>> @@ -96,6 +96,13 @@
>>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
>>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
>>
>> +/* The module parameter tells that we have to put data
>> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
>> + * needed for XDP processing
>> + */
>> +bool provides_xdp_headroom = true;
>> +module_param(provides_xdp_headroom, bool, 0644);
>> +
>>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
>> pending_idx,
>>  			       u8 status);
>>
>> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
>> index ef58870..c5e9e14 100644
>> --- a/drivers/net/xen-netback/rx.c
>> +++ b/drivers/net/xen-netback/rx.c
>> @@ -258,6 +258,19 @@ static void xenvif_rx_next_skb(struct xenvif_queue
>> *queue,
>>  		pkt->extra_count++;
>>  	}
>>
>> +	if (queue->vif->netfront_xdp_headroom) {
>> +		struct xen_netif_extra_info *extra;
>> +
>> +		extra = &pkt->extras[XEN_NETIF_EXTRA_TYPE_XDP - 1];
>> +
>> +		memset(extra, 0, sizeof(struct xen_netif_extra_info));
>> +		extra->u.xdp.headroom = queue->vif->netfront_xdp_headroom;
>> +		extra->type = XEN_NETIF_EXTRA_TYPE_XDP;
>> +		extra->flags = 0;
>> +
>> +		pkt->extra_count++;
>> +	}
>> +
>>  	if (skb->sw_hash) {
>>  		struct xen_netif_extra_info *extra;
>>
>> @@ -356,7 +369,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
>> *queue,
>>  				struct xen_netif_rx_request *req,
>>  				struct xen_netif_rx_response *rsp)
>>  {
>> -	unsigned int offset = 0;
>> +	unsigned int offset = queue->vif->netfront_xdp_headroom;
>>  	unsigned int flags;
>>
>>  	do {
>> diff --git a/drivers/net/xen-netback/xenbus.c
>> b/drivers/net/xen-netback/xenbus.c
>> index 286054b..c67abc5 100644
>> --- a/drivers/net/xen-netback/xenbus.c
>> +++ b/drivers/net/xen-netback/xenbus.c
>> @@ -393,6 +393,22 @@ static void set_backend_state(struct backend_info
>> *be,
>>  	}
>>  }
>>
>> +static void read_xenbus_frontend_xdp(struct backend_info *be,
>> +				      struct xenbus_device *dev)
>> +{
>> +	struct xenvif *vif = be->vif;
>> +	u16 headroom;
>> +	int err;
>> +
>> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
>> +			   "netfront-xdp-headroom", "%hu", &headroom);
>
> Isn't it just "xdp-headroom"? That's what the comments in netif.h state.
>
>> +	if (err < 0) {
>> +		vif->netfront_xdp_headroom = 0;
>> +		return;
>> +	}
>
> What is a reasonable value for maximum headroom? Do we really want to allow
> values all the way up to 65535?

Since the headroom is used for encapsulation I think we definitely
don't need more than 65535
but more that 255


>
>   Paul
>
>> +	vif->netfront_xdp_headroom = headroom;
>> +}
>> +
>>  /**
>>   * Callback received when the frontend's state changes.
>>   */
>> @@ -417,6 +433,11 @@ static void frontend_changed(struct xenbus_device
>> *dev,
>>  		set_backend_state(be, XenbusStateConnected);
>>  		break;
>>
>> +	case XenbusStateReconfiguring:
>> +		read_xenbus_frontend_xdp(be, dev);
>> +		xenbus_switch_state(dev, XenbusStateReconfigured);
>> +		break;
>> +
>>  	case XenbusStateClosing:
>>  		set_backend_state(be, XenbusStateClosing);
>>  		break;
>> @@ -947,6 +968,8 @@ static int read_xenbus_vif_flags(struct backend_info
>> *be)
>>  	vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
>>  						"feature-ipv6-csum-offload", 0);
>>
>> +	read_xenbus_frontend_xdp(be, dev);
>> +
>>  	return 0;
>>  }
>>
>> @@ -1036,6 +1059,15 @@ static int netback_probe(struct xenbus_device
>> *dev,
>>  			goto abort_transaction;
>>  		}
>>
>> +		/* we can adjust a headroom for netfront XDP processing */
>> +		err = xenbus_printf(xbt, dev->nodename,
>> +				    "feature-xdp-headroom", "%d",
>> +				    provides_xdp_headroom);
>> +		if (err) {
>> +			message = "writing feature-xdp-headroom";
>> +			goto abort_transaction;
>> +		}
>> +
>>  		/* We don't support rx-flip path (except old guests who
>>  		 * don't grok this feature flag).
>>  		 */
>> --
>> 1.8.3.1
>
>
>
