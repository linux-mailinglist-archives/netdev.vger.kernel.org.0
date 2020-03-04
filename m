Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C961790FC
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbgCDNLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:11:02 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:37270 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbgCDNLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:11:01 -0500
Received: by mail-ua1-f68.google.com with SMTP id h32so637295uah.4
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 05:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4o06Nky5IXuXetMAo9uV9+wImSlDf00z+cA2PQsHm6g=;
        b=BdrJOljlj7qmd5f3CS6+fWksjB3gMPV8uhDNgMaIE6jAhLieWwv0Y3WtYGqJ/2Ncql
         ujLM4I+aIztSQkROAm33IlVPAWwhJXuxT1p/yfq6V4GonDb2og3rorB+kUxjb612D9ts
         /XMkjOUYm6YPxYEGbrhtA0Ia93GIjJfML5gLprdUNTEtrMXI8NFBI7vXZi4KU01Qi+ij
         Cehl1YqhDYqcVCgV8DaV4NQFTZvHgOg8MbYjKziw75f3VWzxzs1r85dDCvlRVqle0950
         9y5apAbxbCZHuxViFR5WoFLChrsJQuvzaSll3nn3E/pQT7as73UqiA1zlXrTU6QEEBYw
         u1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4o06Nky5IXuXetMAo9uV9+wImSlDf00z+cA2PQsHm6g=;
        b=iI1bKmQMJeb4c4LCG1GjTpB2+3qOBMp6gSt7Stb22/a9JtflejdcKd1t6UQmYaEfuU
         /kP2Frbwg7DbC8j8shPg7E8YQLpqjgOs46ufPMhOZv+ggdY/CqThCbjROkHSh61WM0Kn
         k4QQTR4rDlQKm5x/Ndoca8i3zdSVLY+32Uz0A5UVbmpW0H1wHIgR5VnUf2c1TrLp9PSw
         nXzyLiZ0jbaAIwcCPrk2loT73ljHsLYvZbNKsmuOUeXVboV1H/totM8DHcvhhhUSOgNj
         3jSgAFxiyHG+E515zFEtBF6EFXwJOokeChZN52lIJ3WhakybyIZB911ePVwt+KX4wD0q
         Q3xA==
X-Gm-Message-State: ANhLgQ1KwENsxplzIvYwZBCATuH0krzvX3oB5upvvsmEbh70RfYXpSIO
        c+v5FRuOsXhE3J0Ig8W1mQj5+UpwsiKpi2Xy7Q3qLg==
X-Google-Smtp-Source: ADFU+vvFR03V/JgEf4kLxZgXUZMXi7RWn6++Ih+wP8Z2Ve/ECPd8dS0Yzmzp9kTK/TggvVr9x81o5uXQZjdrvioHQLA=
X-Received: by 2002:a9f:2596:: with SMTP id 22mr1324597uaf.135.1583327459050;
 Wed, 04 Mar 2020 05:10:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Wed, 4 Mar 2020 05:10:58 -0800 (PST)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org> <f8aa7d34-582e-84de-bf33-9551b31b7470@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 4 Mar 2020 16:10:58 +0300
Message-ID: <CAOJe8K28BZCW7JDejKgDELR2WPfBgvj-0aJJXX9uCRnryGY+xg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     netdev@vger.kernel.org,
        "ilias.apalodimas" <ilias.apalodimas@linaro.org>,
        wei.liu@kernel.org, paul@xen.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/20, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
> On 02.03.20 15:21, Denis Kirjanov wrote:
>> the patch adds a basic xdo logic to the netfront driver
>>
>> XDP redirect is not supported yet
>>
>> v2:
>> - avoid data copying while passing to XDP
>> - tell xen-natback that we need the headroom space
>
> Please add the patch history below the "---" delimiter
>
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
>>   drivers/net/xen-netback/common.h |   1 +
>>   drivers/net/xen-netback/rx.c     |   9 ++-
>>   drivers/net/xen-netback/xenbus.c |  21 ++++++
>>   drivers/net/xen-netfront.c       | 157
>> +++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 186 insertions(+), 2 deletions(-)
>
> You are modifying xen-netback sources. Please Cc the maintainers.
>
>>
>> diff --git a/drivers/net/xen-netback/common.h
>> b/drivers/net/xen-netback/common.h
>> index 05847eb..0750c6f 100644
>> --- a/drivers/net/xen-netback/common.h
>> +++ b/drivers/net/xen-netback/common.h
>> @@ -280,6 +280,7 @@ struct xenvif {
>>   	u8 ip_csum:1;
>>   	u8 ipv6_csum:1;
>>   	u8 multicast_control:1;
>> +	u8 xdp_enabled:1;
>>
>>   	/* Is this interface disabled? True when backend discovers
>>   	 * frontend is rogue.
>> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
>> index ef58870..a110a59 100644
>> --- a/drivers/net/xen-netback/rx.c
>> +++ b/drivers/net/xen-netback/rx.c
>> @@ -33,6 +33,11 @@
>>   #include <xen/xen.h>
>>   #include <xen/events.h>
>>
>> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
>> +{
>> +	return (vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0);
>> +}
>> +
>>   static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
>>   {
>>   	RING_IDX prod, cons;
>> @@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
>> *queue,
>>   				struct xen_netif_rx_request *req,
>>   				struct xen_netif_rx_response *rsp)
>>   {
>> -	unsigned int offset =3D 0;
>> +	unsigned int offset =3D xenvif_rx_xdp_offset(queue->vif);
>>   	unsigned int flags;
>>
>>   	do {
>> @@ -389,7 +394,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
>> *queue,
>>   			flags |=3D XEN_NETRXF_extra_info;
>>   	}
>>
>> -	rsp->offset =3D 0;
>> +	rsp->offset =3D xenvif_rx_xdp_offset(queue->vif);
>>   	rsp->flags =3D flags;
>>   	rsp->id =3D req->id;
>>   	rsp->status =3D (s16)offset;
>> diff --git a/drivers/net/xen-netback/xenbus.c
>> b/drivers/net/xen-netback/xenbus.c
>> index 286054b..81a6023 100644
>> --- a/drivers/net/xen-netback/xenbus.c
>> +++ b/drivers/net/xen-netback/xenbus.c
>> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info
>> *be,
>>   	}
>>   }
>>
>> +static void read_xenbus_fronetend_xdp(struct backend_info *be,
>> +				      struct xenbus_device *dev)
>
> Typo: s/fronetend/frontend/
>
>> +{
>> +	struct xenvif *vif =3D be->vif;
>> +	unsigned int val;
>> +	int err;
>> +
>> +	err =3D xenbus_scanf(XBT_NIL, dev->otherend,
>> +			   "feature-xdp", "%u", &val);
>> +	if (err < 0)
>> +		return;
>> +	vif->xdp_enabled =3D val;
>> +}
>> +
>>   /**
>>    * Callback received when the frontend's state changes.
>>    */
>> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device
>> *dev,
>>   		set_backend_state(be, XenbusStateConnected);
>>   		break;
>>
>> +	case XenbusStateReconfiguring:
>> +		read_xenbus_fronetend_xdp(be, dev);
>> +		xenbus_switch_state(dev, XenbusStateReconfigured);
>> +		break;
>> +
> Where is the reaction to the backend being set to "Reconfigured"?
>
>>   	case XenbusStateClosing:
>>   		set_backend_state(be, XenbusStateClosing);
>>   		break;
>> @@ -935,6 +954,8 @@ static int read_xenbus_vif_flags(struct backend_info
>> *be)
>>
>>   	vif->gso_mask =3D 0;
>>
>> +	vif->xdp_enabled =3D 0;
>> +
>>   	if (xenbus_read_unsigned(dev->otherend, "feature-gso-tcpv4", 0))
>>   		vif->gso_mask |=3D GSO_BIT(TCPV4);
>>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 482c6c8..db8a280 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
>> @@ -44,6 +44,8 @@
>>   #include <linux/mm.h>
>>   #include <linux/slab.h>
>>   #include <net/ip.h>
>> +#include <linux/bpf.h>
>> +#include <linux/bpf_trace.h>
>>
>>   #include <xen/xen.h>
>>   #include <xen/xenbus.h>
>> @@ -102,6 +104,8 @@ struct netfront_queue {
>>   	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
>>   	struct netfront_info *info;
>>
>> +	struct bpf_prog __rcu *xdp_prog;
>> +
>>   	struct napi_struct napi;
>>
>>   	/* Split event channels support, tx_* =3D=3D rx_* when using
>> @@ -778,6 +782,40 @@ static int xennet_get_extras(struct netfront_queue
>> *queue,
>>   	return err;
>>   }
>>
>> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
>> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
>> +		   struct xdp_buff *xdp)
>> +{
>> +	u32 len =3D rx->status;
>> +	u32 act =3D XDP_PASS;
>> +
>> +	xdp->data_hard_start =3D page_address(pdata);
>> +	xdp->data =3D xdp->data_hard_start + XDP_PACKET_HEADROOM;
>> +	xdp_set_data_meta_invalid(xdp);
>> +	xdp->data_end =3D xdp->data + len;
>> +	xdp->handle =3D 0;
>> +
>> +	act =3D bpf_prog_run_xdp(prog, xdp);
>> +	switch (act) {
>> +	case XDP_PASS:
>> +	case XDP_TX:
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
>> +	if (act !=3D XDP_PASS && act !=3D XDP_TX)
>> +		xdp->data_hard_start =3D NULL;
>> +
>> +	return act;
>> +}
>> +
>>   static int xennet_get_responses(struct netfront_queue *queue,
>>   				struct netfront_rx_info *rinfo, RING_IDX rp,
>>   				struct sk_buff_head *list)
>> @@ -792,6 +830,9 @@ static int xennet_get_responses(struct netfront_queu=
e
>> *queue,
>>   	int slots =3D 1;
>>   	int err =3D 0;
>>   	unsigned long ret;
>> +	struct bpf_prog *xdp_prog;
>> +	struct xdp_buff xdp;
>> +	u32 verdict;
>>
>>   	if (rx->flags & XEN_NETRXF_extra_info) {
>>   		err =3D xennet_get_extras(queue, extras, rp);
>> @@ -827,6 +868,22 @@ static int xennet_get_responses(struct netfront_que=
ue
>> *queue,
>>
>>   		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>>
>> +		rcu_read_lock();
>> +		xdp_prog =3D rcu_dereference(queue->xdp_prog);
>> +		if (xdp_prog) {
>> +			/* currently only a single page contains data */
>> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags !=3D 1);
>> +			verdict =3D xennet_run_xdp(queue,
>> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
>> +				       rx, xdp_prog, &xdp);
>> +
>> +			if (verdict !=3D XDP_PASS && verdict !=3D XDP_TX) {
>> +				err =3D -EINVAL;
>> +				goto next;
>> +			}
>> +
>> +		}
>> +		rcu_read_unlock();
>>   		__skb_queue_tail(list, skb);
>>
>>   next:
>> @@ -1261,6 +1318,105 @@ static void xennet_poll_controller(struct
>> net_device *dev)
>>   }
>>   #endif
>>
>> +#define NETBACK_XDP_HEADROOM_DISABLE	0
>> +#define NETBACK_XDP_HEADROOM_ENABLE	1
>> +
>> +static int talk_to_netback_xdp(struct netfront_info *np, int xdp)
>> +{
>> +	struct xenbus_transaction xbt;
>> +	const char *message;
>> +	int err;
>> +
>> +again:
>> +	err =3D xenbus_transaction_start(&xbt);
>> +	if (err) {
>> +		xenbus_dev_fatal(np->xbdev, err, "starting transaction");
>> +		goto out;
>> +	}
>> +
>> +	err =3D xenbus_printf(xbt, np->xbdev->nodename, "feature-xdp", "%d",
>> xdp);
>> +	if (err) {
>> +		message =3D "writing feature-xdp";
>> +		goto abort_transaction;
>> +	}
>> +
>> +	err =3D xenbus_transaction_end(xbt, 0);
>> +	if (err) {
>> +		if (err =3D=3D -EAGAIN)
>> +			goto again;
>
> Writing a single node to Xenstore doesn't need a transaction.
>
>> +	}
>> +
>> +	return 0;
>> +
>> +abort_transaction:
>> +	xenbus_dev_fatal(np->xbdev, err, "%s", message);
>> +	xenbus_transaction_end(xbt, 1);
>> +out:
>> +	return err;
>> +}
>> +
>> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog=
,
>> +			struct netlink_ext_ack *extack)
>> +{
>> +	struct netfront_info *np =3D netdev_priv(dev);
>> +	struct bpf_prog *old_prog;
>> +	unsigned int i, err;
>> +
>> +	old_prog =3D rtnl_dereference(np->queues[0].xdp_prog);
>> +	if (!old_prog && !prog)
>> +		return 0;
>> +
>> +	if (prog)
>> +		bpf_prog_add(prog, dev->real_num_tx_queues);
>> +
>> +	for (i =3D 0; i < dev->real_num_tx_queues; ++i)
>> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
>> +
>> +	if (old_prog)
>> +		for (i =3D 0; i < dev->real_num_tx_queues; ++i)
>> +			bpf_prog_put(old_prog);
>> +
>> +	err =3D talk_to_netback_xdp(np, old_prog ? NETBACK_XDP_HEADROOM_DISABL=
E:
>> +				  NETBACK_XDP_HEADROOM_ENABLE);
>> +	if (err)
>> +		return err;
>> +
>> +	xenbus_switch_state(np->xbdev, XenbusStateReconfiguring);
>
> What is happening in case the backend doesn't support XDP?
Here we just ask xen-backend to make a headroom, that's it.
It's better to send xen-backend changes in a separate patch.

>
> Is it really a good idea to communicate xdp_set via a frontend state
> change? This will be rather slow. OTOH I have no idea how often this
> might happen.

I don't think that it's going to switch often and more likely it's a one sh=
ot
action.

>
>
> Juergen
>
