Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1343B17A642
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgCENXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:23:34 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46093 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgCENXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:23:33 -0500
Received: by mail-qt1-f196.google.com with SMTP id x21so4010748qto.13
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 05:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3NJJt/LG9G3qWkaTTmCReYkem7bmTwqlT4W7ujRrLeM=;
        b=PylggPfeqf9MWc92vs3mizdc9N9nOO/RmxKcbAarDPYbsTAm/EhfvVYqY/4HPgH8ri
         O5bKpKZBYOAiBpK1+9cHi6LEeXFdyR7krBuuUoNkYCK89TJzCIgpMF0T21kQW095vubc
         c9DKObVuMXbXk503V5rYRMmLu8R+2pT4t5tEMJO7KRtkAkc2N+H84Osz5bZlzgCas14t
         T+2JOdFwCuoK4h/YZqgpE7gvhVVuotuAVcdD6YtYrYdgyGhCh4v0HWIiT83qUcyDSQxj
         XVGKjMJ9hznQLcjggUUdd3xBnuNQkejOGaic6qUafv7rN60GrCoJfNSTWw+4ySvGwIyP
         9U+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3NJJt/LG9G3qWkaTTmCReYkem7bmTwqlT4W7ujRrLeM=;
        b=S5pmMJZL69zSCEQ259ID2Z5aUnE/fnLqE63lOtOq7e6QPSxlMhQR7gSsKtBeTgmk4m
         pQ8nNcEJkp6rXk9rogra5ZjsJ8xzGD9gXzU4GfcqN5bQaJaIdSCRpwU7Yt0E8l5Gfvg0
         3tK7wsX2kRfszeDHcDKrGljHTq9YnyPUJiVkQ2GMi+S7aZylJZ/rjXRtwQIey2IareQv
         Fu2a83aUyL0vaY0fCUUHFK6tgmj0GWuUKIQbBmy25dhWATURTybdLLZPJiK5NmzdjT3r
         f95TrHzv6qp/s9j1XPu0M0NUZkfxv5ejDMXFsjyea3b6VSj8XmY7xSrpVs1Z6rMeb/nT
         5TWw==
X-Gm-Message-State: ANhLgQ0W1f30i/Li4cdIgdkUx/5Ef/ElYvmZrf5lNuCEY2sABQSU7QeG
        I4wrMxhNs62tTEdDnLUwnoIE0KkvyhK9jKFSzyc=
X-Google-Smtp-Source: ADFU+vvyO17v+yLO8VBgeQxU0YUBGulT8Sg484mpU+WO9P6FYSqdz/u4jdC9scdtQILZB0OvDWNWCQA85pTCfAeAb8I=
X-Received: by 2002:ac8:2b82:: with SMTP id m2mr7025140qtm.161.1583414612474;
 Thu, 05 Mar 2020 05:23:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac8:224b:0:0:0:0:0 with HTTP; Thu, 5 Mar 2020 05:23:31 -0800 (PST)
In-Reply-To: <20200305130404.GA574021@apalos.home>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org> <20200305130404.GA574021@apalos.home>
From:   Denis Kirjanov <kirjanov@gmail.com>
Date:   Thu, 5 Mar 2020 16:23:31 +0300
Message-ID: <CAHj3AVndOjLsOkjC1h5WOb+NaswHaggC3MTaRq-r7mA6rGcCZw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org,
        jgross@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20, Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> Hi Denis,
>
> There's a bunch of things still missing from my remarks on V1.
> XDP is not supposed to allocate and free pages constantly as that's one o=
f
> the
> things that's making it fast.

Hi Ilias,

I've removed the copying to an allocated page so there is no page
allocation/free logic added.


>
> You are also missing proper support for XDP_REDIRECT, ndo_xdp_xmit. We
> usually
> require the whole functionality to merge the driver.

I wanted to minimize changes and send follow-up patches

>
>
> On Mon, Mar 02, 2020 at 05:21:14PM +0300, Denis Kirjanov wrote:
>>
> [...]
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
>
> Maybe i am missing something on the usage, but XDP_TX and XDROP are handl=
ed
> similarly?
> XDP_TX is supposed to sent the packet out of the interface it arrived.

Yep, you're right. I'll add it to the next version.

Thanks!

>
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
>>  static int xennet_get_responses(struct netfront_queue *queue,
>>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>>  				struct sk_buff_head *list)
>> @@ -792,6 +830,9 @@ static int xennet_get_responses(struct netfront_queu=
e
>> *queue,
>>  	int slots =3D 1;
>>  	int err =3D 0;
>>  	unsigned long ret;
>> +	struct bpf_prog *xdp_prog;
>> +	struct xdp_buff xdp;
>> +	u32 verdict;
>>
>>  	if (rx->flags & XEN_NETRXF_extra_info) {
>>  		err =3D xennet_get_extras(queue, extras, rp);
>> @@ -827,6 +868,22 @@ static int xennet_get_responses(struct netfront_que=
ue
>> *queue,
>>
>>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
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
>>  		__skb_queue_tail(list, skb);
>>
>>  next:
>> @@ -1261,6 +1318,105 @@ static void xennet_poll_controller(struct
>> net_device *dev)
>>  }
>>  #endif
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
>> +
>> +	return 0;
>> +}
>> +
>> +static u32 xennet_xdp_query(struct net_device *dev)
>> +{
>> +	struct netfront_info *np =3D netdev_priv(dev);
>> +	unsigned int num_queues =3D dev->real_num_tx_queues;
>> +	unsigned int i;
>> +	struct netfront_queue *queue;
>> +	const struct bpf_prog *xdp_prog;
>> +
>> +	for (i =3D 0; i < num_queues; ++i) {
>> +		queue =3D &np->queues[i];
>> +		xdp_prog =3D rtnl_dereference(queue->xdp_prog);
>> +		if (xdp_prog)
>> +			return xdp_prog->aux->id;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>> +{
>> +	switch (xdp->command) {
>> +	case XDP_SETUP_PROG:
>> +		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
>> +	case XDP_QUERY_PROG:
>> +		xdp->prog_id =3D xennet_xdp_query(dev);
>> +		return 0;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>>  static const struct net_device_ops xennet_netdev_ops =3D {
>>  	.ndo_open            =3D xennet_open,
>>  	.ndo_stop            =3D xennet_close,
>> @@ -1272,6 +1428,7 @@ static void xennet_poll_controller(struct net_devi=
ce
>> *dev)
>>  	.ndo_fix_features    =3D xennet_fix_features,
>>  	.ndo_set_features    =3D xennet_set_features,
>>  	.ndo_select_queue    =3D xennet_select_queue,
>> +	.ndo_bpf            =3D xennet_xdp,
>>  #ifdef CONFIG_NET_POLL_CONTROLLER
>>  	.ndo_poll_controller =3D xennet_poll_controller,
>>  #endif
>> --
>> 1.8.3.1
>>
> Cheers
> /Ilias
>


--=20
Regards / Mit besten Gr=C3=BC=C3=9Fen,
Denis
