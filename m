Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC000184384
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgCMJPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:15:39 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:35624 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCMJPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:15:39 -0400
Received: by mail-vk1-f193.google.com with SMTP id g25so999415vkl.2
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 02:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=EmQjHVRo0cV4no30jvoqI8GWFq3sAmSHJ5i2PJxIlN0=;
        b=cRHMckFWY0gyKuRqXeksyyI5R0Fc4yvIYb8uqpucBCGGDMH64kxsoNlrlvjMFb+d0i
         Btsmwo13qObL1pB2Jc4TExfFDKy+PgtKa3EFc/sOMKp9Ntp79UPf901wqWZR3uZb1yaJ
         flkfBgHYfYjdYVEZaJ3yvLJaT/6TLBY4OCtsIkgIy30M9xFKq5lBcr+WtpEQp2SLXL8J
         QWI54NsLnIJ2y90eWvbmKw52wN3pouLdr5HKv/882rBvnRocJYcrvGuyJGkTBRKOoJji
         peOoXgfA92gnuXCr+C3He7iDo0t4sG08EGWyULC1kHM0ZDtB26As3In1ZssZokX3BuaW
         6ukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=EmQjHVRo0cV4no30jvoqI8GWFq3sAmSHJ5i2PJxIlN0=;
        b=YLZiI9qvEnaMAVDqd09RMG59e5xfXuE/xUzl5ukKA44VTN7IIsyqrsT3jVTVFuZZxP
         Szw08l4DlMvr/iVjb1EjbmkFmy1w9EWShhDqwDSjyoFp7GiF5gOP5tbkMLiBh6JtkMOI
         WuZbK6A3NTZz9+AGrRy8eKivMEeFRCwC1OKwJ/4mI+GBhgDTrsbFjsYmACcb+eD5EJz2
         vNK+FUuyRrk6DxdfqnmwgV5D+NTvdRMkz2YFpfJEzfSZ8mpndn8h9UWEul3+JNZhi3MF
         YUv7Pa9f0Q8X2OMgcsuUCgm6kt2Dq/nHKxu63Q9lVjb4o7lC+PGCVLM0xt7sWfSi05q0
         EAlg==
X-Gm-Message-State: ANhLgQ36oz+ud3tWlOQvYP/p+EbF1QWFQ0XKbDIAceukC4R2RQnF0mbC
        w++uJbYGlOH3KcBd2Jv7SMcB/n/wKdhYQImj91nDj4zB
X-Google-Smtp-Source: ADFU+vtAJyahAbbwU0TEFy+nMUBo22Wa9B/Xo0cbdL71Os1riqr8BP2z1ME0UowZ7VAWyC6bgt8rdvYfzxRwmBhInvs=
X-Received: by 2002:a1f:b695:: with SMTP id g143mr8220653vkf.59.1584090937920;
 Fri, 13 Mar 2020 02:15:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Fri, 13 Mar 2020 02:15:37
 -0700 (PDT)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <005001d5f866$fbeca400$f3c5ec00$@xen.org>
References: <1584011425-4589-1-git-send-email-kda@linux-powerpc.org> <005001d5f866$fbeca400$f3c5ec00$@xen.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 13 Mar 2020 12:15:37 +0300
Message-ID: <CAOJe8K2=qejcj=3gDWXHYZTf65-BNZHFOj22ELQ6OOkSYkWegg@mail.gmail.com>
Subject: Re: [PATCH net-next v3] xen-netfront: add basic XDP support
To:     paul@xen.org
Cc:     netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org, wei.liu@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20, Paul Durrant <xadimgnik@gmail.com> wrote:
>> -----Original Message-----
>> From: Denis Kirjanov <kda@linux-powerpc.org>
>> Sent: 12 March 2020 11:10
>> To: netdev@vger.kernel.org
>> Cc: jgross@suse.com; ilias.apalodimas@linaro.org; wei.liu@kernel.org;
>> paul@xen.org; Denis Kirjanov
>> <kda@linux-powerpc.org>
>> Subject: [PATCH net-next v3] xen-netfront: add basic XDP support
>>
>> the patch adds a basic xdo logic to the netfront driver
>
> This commit comment is by no means adequate. For a start xen-netback is also
> changed. Please also give some detail about what the
> patch is doing and why.

Hi Paul,

>
>>
>> v3:
>> - added XDP_TX support (tested with xdping echoserver)
>> - added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
>> - moved xdp negotiation to xen-netback
>>
>> v2:
>> - avoid data copying while passing to XDP
>> - tell xen-natback that we need the headroom space
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
>>  drivers/net/xen-netback/common.h |   1 +
>>  drivers/net/xen-netback/rx.c     |   9 +-
>>  drivers/net/xen-netback/xenbus.c |  27 +++++
>>  drivers/net/xen-netfront.c       | 240
>> ++++++++++++++++++++++++++++++++++++++-
>>  4 files changed, 274 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/xen-netback/common.h
>> b/drivers/net/xen-netback/common.h
>> index 05847eb..0750c6f 100644
>> --- a/drivers/net/xen-netback/common.h
>> +++ b/drivers/net/xen-netback/common.h
>> @@ -280,6 +280,7 @@ struct xenvif {
>>  	u8 ip_csum:1;
>>  	u8 ipv6_csum:1;
>>  	u8 multicast_control:1;
>> +	u8 xdp_enabled:1;
>>
>>  	/* Is this interface disabled? True when backend discovers
>>  	 * frontend is rogue.
>> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
>> index ef58870..a110a59 100644
>> --- a/drivers/net/xen-netback/rx.c
>> +++ b/drivers/net/xen-netback/rx.c
>> @@ -33,6 +33,11 @@
>>  #include <xen/xen.h>
>>  #include <xen/events.h>
>>
>> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
>> +{
>> +	return (vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0);
>> +}
>> +
>>  static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
>>  {
>>  	RING_IDX prod, cons;
>> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
>> *queue,
>>  				struct xen_netif_rx_request *req,
>>  				struct xen_netif_rx_response *rsp)
>>  {
>> -	unsigned int offset = 0;
>> +	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
>>  	unsigned int flags;
>>
>>  	do {
>> @@ -389,7 +394,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
>> *queue,
>>  			flags |= XEN_NETRXF_extra_info;
>>  	}
>>
>> -	rsp->offset = 0;
>> +	rsp->offset = xenvif_rx_xdp_offset(queue->vif);
>>  	rsp->flags = flags;
>>  	rsp->id = req->id;
>>  	rsp->status = (s16)offset;
>
> I'm confused... largely due to the total lack of explanation of what this
> patch is doing... Why are you messing with the guest RX
> side here? If you want to squash the extra header then it can be stripped in
> the copy (which it looks like you do) with no need to
> expose a non-zero offset to the guest.

the idea is to reserve a headroom for XDP. Looks like it's a right place
where an RX response is made.
Ok, I see your point regarding exposing an offset. I'll send a new version.


>
>> diff --git a/drivers/net/xen-netback/xenbus.c
>> b/drivers/net/xen-netback/xenbus.c
>> index 286054b..0949c6b 100644
>> --- a/drivers/net/xen-netback/xenbus.c
>> +++ b/drivers/net/xen-netback/xenbus.c
>> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
>> *be,
>>  	}
>>  }
>>
>> +static void read_xenbus_frontend_xdp(struct backend_info *be,
>> +				      struct xenbus_device *dev)
>> +{
>> +	struct xenvif *vif = be->vif;
>> +	unsigned int val;
>> +	int err;
>> +
>> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
>> +			   "feature-xdp", "%u", &val);
>> +	if (err < 0)
>> +		return;
>> +	vif->xdp_enabled = val;
>> +}
>> +
>>  /**
>>   * Callback received when the frontend's state changes.
>>   */
>> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
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
>> @@ -1036,6 +1055,14 @@ static int netback_probe(struct xenbus_device
>> *dev,
>>  			goto abort_transaction;
>>  		}
>>
>> +		/* we can adjust a headroom for netfront XDP processing */
>> +		err = xenbus_printf(xbt, dev->nodename,
>> +				    "feature-xdp-headroom", "%d", 1);
>> +		if (err) {
>> +			message = "writing feature-xdp-headroom";
>> +			goto abort_transaction;
>> +		}
>> +
>
> Unconditionally enabling? I'd like a modparam for this.

Well, XDP is a useful feature so I don't think it's a totally bad
decision to make it enabled
by default. On another hand I can add a modparam, sure.

>
>>  		/* We don't support rx-flip path (except old guests who
>>  		 * don't grok this feature flag).
>>  		 */
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 482c6c8..d298b36 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
>> @@ -44,6 +44,8 @@
>>  #include <linux/mm.h>
>>  #include <linux/slab.h>
>>  #include <net/ip.h>
>> +#include <linux/bpf.h>
>> +#include <linux/bpf_trace.h>
>>
>>  #include <xen/xen.h>
>>  #include <xen/xenbus.h>
>> @@ -102,6 +104,8 @@ struct netfront_queue {
>>  	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
>>  	struct netfront_info *info;
>>
>> +	struct bpf_prog __rcu *xdp_prog;
>> +
>>  	struct napi_struct napi;
>>
>>  	/* Split event channels support, tx_* == rx_* when using
>> @@ -144,6 +148,8 @@ struct netfront_queue {
>>  	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
>>  	grant_ref_t gref_rx_head;
>>  	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
>> +
>> +	struct xdp_rxq_info xdp_rxq;
>>  };
>>
>>  struct netfront_info {
>> @@ -159,6 +165,8 @@ struct netfront_info {
>>  	struct netfront_stats __percpu *rx_stats;
>>  	struct netfront_stats __percpu *tx_stats;
>>
>> +	bool netback_has_xdp_headroom;
>> +
>>  	atomic_t rx_gso_checksum_fixup;
>>  };
>>
>> @@ -167,6 +175,9 @@ struct netfront_rx_info {
>>  	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
>>  };
>>
>> +static int xennet_xdp_xmit(struct net_device *dev, int n,
>> +			   struct xdp_frame **frames, u32 flags);
>> +
>>  static void skb_entry_set_link(union skb_entry *list, unsigned short id)
>>  {
>>  	list->link = id;
>> @@ -406,7 +417,8 @@ static void xennet_tx_buf_gc(struct netfront_queue
>> *queue)
>>  			queue->grant_tx_ref[id] = GRANT_INVALID_REF;
>>  			queue->grant_tx_page[id] = NULL;
>>  			add_id_to_freelist(&queue->tx_skb_freelist, queue->tx_skbs, id);
>> -			dev_kfree_skb_irq(skb);
>> +			if (skb)
>> +				dev_kfree_skb_irq(skb);
>
> Why? dev_kfree_skb_irq() will happily deal with a NULL value.
>
>>  		}
>>
>>  		queue->tx.rsp_cons = prod;
>> @@ -778,6 +790,52 @@ static int xennet_get_extras(struct netfront_queue
>> *queue,
>>  	return err;
>>  }
>>
>> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
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
>> +
>> +	act = bpf_prog_run_xdp(prog, xdp);
>> +	switch (act) {
>> +	case XDP_TX:
>> +		xdpf = convert_to_xdp_frame(xdp);
>> +		err = xennet_xdp_xmit(queue->info->netdev, 1,
>> +				&xdpf, 0);
>> +		if (unlikely(err < 0))
>> +			trace_xdp_exception(queue->info->netdev, prog, act);
>> +		break;
>> +	case XDP_REDIRECT:
>> +		err = xdp_do_redirect(queue->info->netdev, xdp, prog);
>> +		if (unlikely(err))
>> +			trace_xdp_exception(queue->info->netdev, prog, act);
>> +		xdp_do_flush();
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
>> @@ -792,6 +850,9 @@ static int xennet_get_responses(struct netfront_queue
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
>> @@ -827,6 +888,21 @@ static int xennet_get_responses(struct netfront_queue
>> *queue,
>>
>>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>>
>> +		rcu_read_lock();
>> +		xdp_prog = rcu_dereference(queue->xdp_prog);
>> +		if (xdp_prog) {
>> +			/* currently only a single page contains data */
>> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
>
> How's this going to work for jumbo frames?

XEN_NETRXF_more_data. Ok, I'll check that.

Thanks!

>
>   Paul
>
>> +			verdict = xennet_run_xdp(queue,
>> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
>> +				       rx, xdp_prog, &xdp);
>> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
>> +				err = -EINVAL;
>> +				goto next;
>> +			}
>> +
>> +		}
>> +		rcu_read_unlock();
>>  		__skb_queue_tail(list, skb);
>>
>>  next:
>> @@ -1261,6 +1337,144 @@ static void xennet_poll_controller(struct
>> net_device *dev)
>>  }
>>  #endif
>
>
