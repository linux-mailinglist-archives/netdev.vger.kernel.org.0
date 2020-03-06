Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B3517B98F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 10:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCFJsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 04:48:30 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:41846 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgCFJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 04:48:30 -0500
Received: by mail-vs1-f66.google.com with SMTP id k188so1115706vsc.8
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 01:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=G+R/Kw9MBvZAA4ZmBt+CPV0i9rR1O2+WxGJV4yGKEec=;
        b=br3wfjaBnaxQ598o09JZc7Y4ttUGbhcpOpjKOLTzwNDrPovc5wMCIJBBLuyGeE7Ryl
         PsKR929Lqa8Xe3ujHpmhOE2nuoRr1H0taoWu3SEWRD39J0iBD98dF1qUB9Pn+v3L8Gl4
         OvbiZ/iwhmnhkXDVYH7m0vDKbZBwzmX1aY/bGG7eCkDQ0Y6f/4iozpTCdUjDKtcbPBfv
         RaZyD0ydjBjkMewBIDcxLMfdpLJ2SayrOfta4iKbTkhDlbY6P002Lj0i6kqs2YikUaQl
         bnOaALvZV/aIMOqMs3v68n2Z0koM6nxVYQNWl06ziCK71IaSL+nQt1fDabHCaQ0+5Uhw
         lTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=G+R/Kw9MBvZAA4ZmBt+CPV0i9rR1O2+WxGJV4yGKEec=;
        b=VNBcT18rQ9yrrYShCzTBtVolNvWfAHVHOiUfVgCtap+fco3p1sP0fodi/idzNL8bWy
         4yntXKFXRrwCCWa4l0tM6vyERduH24rfg0t9PnXC2sA1WIVErIfceK0cA4SNbxi/bsLs
         VfGSpliUr3IfkcwWhX4RqIQUA5ESH33JsISM3coyXKkrJGzAjqO0zqVxHa3TEeqRdS9O
         NYez3RBR7slmHZx7YeDCGwn8G70RH78+u1auzVjtAcyRX8lKLfPEGVGaJ+CzDb9QQkKd
         96w4emQqUaOrS8QeiXy/PDhAumB35ReClwGNYbZYonu7nprppYtrKTWzaQV5vaURnsqB
         4Kvw==
X-Gm-Message-State: ANhLgQ179ij546MgJJ4ud6PqYUnvlV3m3CatNvM2I/dV1EArbA+e12OR
        mhRfl5zJnPVC04e4BFjaQeZBMpX62eBgcwOEKpu9hg==
X-Google-Smtp-Source: ADFU+vvHrTk8lyzdHIdoVAwHYeH0utOZrJ1gX8ilWx8/JxhEOkQXWobtrHTEXU1WDDROSonhrwvx/as9tRI4zM+pXdM=
X-Received: by 2002:a67:df97:: with SMTP id x23mr1620541vsk.160.1583488107088;
 Fri, 06 Mar 2020 01:48:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Fri, 6 Mar 2020 01:48:26 -0800 (PST)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <20200305153515.4ce0ecf4@carbon>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org> <20200305153515.4ce0ecf4@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 6 Mar 2020 12:48:26 +0300
Message-ID: <CAOJe8K3AaGFAPYymu4FW4OhXnhnxQUhA18m4OLp_66EVj6LxEA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Mon,  2 Mar 2020 17:21:14 +0300
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 482c6c8..db8a280 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
> [...]
>> @@ -778,6 +782,40 @@ static int xennet_get_extras(struct netfront_queue
>> *queue,
>>  	return err;
>>  }
>>
>> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
>> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
>> +		   struct xdp_buff *xdp)
>> +{
>> +	u32 len = rx->status;
>> +	u32 act = XDP_PASS;
>> +
>> +	xdp->data_hard_start = page_address(pdata);
>> +	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
>> +	xdp_set_data_meta_invalid(xdp);
>> +	xdp->data_end = xdp->data + len;
>> +	xdp->handle = 0;
>> +
>> +	act = bpf_prog_run_xdp(prog, xdp);
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
>> +	if (act != XDP_PASS && act != XDP_TX)
>> +		xdp->data_hard_start = NULL;
>> +
>> +	return act;
>> +}
>> +
>>  static int xennet_get_responses(struct netfront_queue *queue,
>>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>>  				struct sk_buff_head *list)
>> @@ -792,6 +830,9 @@ static int xennet_get_responses(struct netfront_queue
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
>> @@ -827,6 +868,22 @@ static int xennet_get_responses(struct netfront_queue
>> *queue,
>>
>>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>>
>> +		rcu_read_lock();
>> +		xdp_prog = rcu_dereference(queue->xdp_prog);
>> +		if (xdp_prog) {
>> +			/* currently only a single page contains data */
>> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
>> +			verdict = xennet_run_xdp(queue,
>> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
>
> This looks really weird, skb_shinfo(skb)->frags[0], you already have an
> SKB and you are sending fragment-0 to the xennet_run_xdp() function.
>
> XDP meant to run before an SKB is allocated...

Agreed. But the xen networking works that data communicated using
shared pages between backend and frontend parts.
So xen-netfront just allocates skbs with attached pages to them and
shares those pages with xen-netback

>
>> +				       rx, xdp_prog, &xdp);
>> +
>> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
>> +				err = -EINVAL;
>> +				goto next;
>> +			}
>> +
>> +		}
>> +		rcu_read_unlock();
>>  		__skb_queue_tail(list, skb);
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
