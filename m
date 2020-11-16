Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B292B4094
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgKPKNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbgKPKNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:13:50 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4915EC0613D1
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 02:13:48 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id s25so23585798ejy.6
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 02:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=eUexxalWWW3sAgPdtJ+hwphCF2dSR9rNJsVsIvPlNVI=;
        b=fxwkArX/oc4z9qAMJ9gSO7AYFOBvA3NpMKLIORKO3O3UCRnF+tkXMLoF8Tm59fuXZy
         qUOTeGe75cH7xbQzG+gR/kcLnp6IhsD9iDs7fetgPMeD8va8+nVKILw2MBugKrqr3XI/
         o3dLtIUA28vNWH80ic3GKB1S2lZyCKRN2XzjS5UkAjO6sjdZu+PSsyT2JRWDA8QsWj7I
         Csff5+M5JCRThMF2jhQPvXWxuT2qhTQb07ucEDkvGYPzgG873dKb3/VWQ2kCKD1EAav+
         6FZoizAUFl7PY4OipPZ34WfJX0yvhgz9bNzCoVvQKRl3S/7uf8TreaW93aPP0jfH98P3
         pePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=eUexxalWWW3sAgPdtJ+hwphCF2dSR9rNJsVsIvPlNVI=;
        b=sK6qLEevRhJ3JlQigX4WU0a5L10fJYI/qC3XFBPK9UZ7VsOCk4ddpQdfSXsAah98y/
         +WIVCHUG84tCin6fexhzMad3/6DTh4T/aaoyLJ08nPpTWQ6itgxTOr/vNs41yJ6TBhSZ
         j/iRBGzDW/w8nHXgiRDxk4x9AhYPuf375bCNHyOKvMQVvyY/iJ5s2igjFmQGiJxcp/bI
         +ajMXJ6IQUN1oNO3ytLOrkMS5H5p+CE1ZN2VZ/P6CyLAxv7/8ZyLUg4FSe/ulaO/kmVI
         c5D12a6SsgckWqptNZul8scSjZBNfYi2dkVG/AUfK9ox+d4H7yI9zHyqwWsHCylEqDjb
         vcYw==
X-Gm-Message-State: AOAM532wxXnphTKvxQBBT6CMco1QYdrOoY+yrYR5xkWVt5Qo6vqWBpFY
        fpUkSTYtqXTnvbiaLG4rs7nJwL0P/z9PpBNKZZib2g==
X-Google-Smtp-Source: ABdhPJwYW4UN9olfKOirCbEp5W4OGDak+tLBs5uembWUdFg5O+XjgR/lXxi2UDmh240Z1CqCGE9N1fEH5xkjAwYiTsE=
X-Received: by 2002:a17:906:1b09:: with SMTP id o9mr14429592ejg.79.1605521626845;
 Mon, 16 Nov 2020 02:13:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:380d:0:0:0:0:0 with HTTP; Mon, 16 Nov 2020 02:13:45
 -0800 (PST)
X-Originating-IP: [5.35.10.61]
In-Reply-To: <5fb245b1.1c69fb81.e2685.976dSMTPIN_ADDED_MISSING@mx.google.com>
References: <CAOJe8K3wz=-LC++N-Hvrturt46+AAK1cW8VYXK+VMT9y1OSzmQ@mail.gmail.com>
 <5fb245b1.1c69fb81.e2685.976dSMTPIN_ADDED_MISSING@mx.google.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 16 Nov 2020 13:13:45 +0300
Message-ID: <CAOJe8K2dBdoviSi7j_6XXpntp8GCBWuMWeAbmHbeZqs_bvG5LQ@mail.gmail.com>
Subject: Re: [PATCH] xsk: add cq event
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> On Mon, 16 Nov 2020 12:13:21 +0300, Denis Kirjanov <kda@linux-powerpc.org>
> wrote:
>> On 11/16/20, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>> > When we write all cq items to tx, we have to wait for a new event based
>> > on poll to indicate that it is writable. But the current writability is
>> > triggered based on whether tx is full or not, and In fact, when tx is
>> > dissatisfied, the user of cq's item may not necessarily get it, because
>> > it
>> > may still be occupied by the network card. In this case, we need to
>> > know
>> > when cq is available, so this patch adds a socket option, When the user
>> > configures this option using setsockopt, when cq is available, a
>> > readable event is generated for all xsk bound to this umem.
>> >
>> > I can't find a better description of this event,
>> > I think it can also be 'readable', although it is indeed different from
>> > the 'readable' of the new data. But the overhead of xsk checking
>> > whether
>> > cq or rx is readable is small.
>> >
>> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> > ---
>> >  include/net/xdp_sock.h      |  1 +
>> >  include/uapi/linux/if_xdp.h |  1 +
>> >  net/xdp/xsk.c               | 28 ++++++++++++++++++++++++++++
>> >  3 files changed, 30 insertions(+)
>> >
>> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> > index 1a9559c..faf5b1a 100644
>> > --- a/include/net/xdp_sock.h
>> > +++ b/include/net/xdp_sock.h
>> > @@ -49,6 +49,7 @@ struct xdp_sock {
>> >  	struct xsk_buff_pool *pool;
>> >  	u16 queue_id;
>> >  	bool zc;
>> > +	bool cq_event;
>> >  	enum {
>> >  		XSK_READY = 0,
>> >  		XSK_BOUND,
>> > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
>> > index a78a809..2dba3cb 100644
>> > --- a/include/uapi/linux/if_xdp.h
>> > +++ b/include/uapi/linux/if_xdp.h
>> > @@ -63,6 +63,7 @@ struct xdp_mmap_offsets {
>> >  #define XDP_UMEM_COMPLETION_RING	6
>> >  #define XDP_STATISTICS			7
>> >  #define XDP_OPTIONS			8
>> > +#define XDP_CQ_EVENT			9
>> >
>> >  struct xdp_umem_reg {
>> >  	__u64 addr; /* Start of packet data area */
>> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> > index cfbec39..0c53403 100644
>> > --- a/net/xdp/xsk.c
>> > +++ b/net/xdp/xsk.c
>> > @@ -285,7 +285,16 @@ void __xsk_map_flush(void)
>> >
>> >  void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
>> >  {
>> > +	struct xdp_sock *xs;
>> > +
>> >  	xskq_prod_submit_n(pool->cq, nb_entries);
>> > +
>> > +	rcu_read_lock();
>> > +	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
>> > +		if (xs->cq_event)
>> > +			sock_def_readable(&xs->sk);
>> > +	}
>> > +	rcu_read_unlock();
>> >  }
>> >  EXPORT_SYMBOL(xsk_tx_completed);
>> >
>> > @@ -495,6 +504,9 @@ static __poll_t xsk_poll(struct file *file, struct
>> > socket *sock,
>> >  			__xsk_sendmsg(sk);
>> >  	}
>> >
>> > +	if (xs->cq_event && pool->cq && !xskq_prod_is_empty(pool->cq))
>> > +		mask |= EPOLLIN | EPOLLRDNORM;
>> > +
>> >  	if (xs->rx && !xskq_prod_is_empty(xs->rx))
>> >  		mask |= EPOLLIN | EPOLLRDNORM;
>> >  	if (xs->tx && !xskq_cons_is_full(xs->tx))
>> > @@ -882,6 +894,22 @@ static int xsk_setsockopt(struct socket *sock, int
>> > level, int optname,
>> >  		mutex_unlock(&xs->mutex);
>> >  		return err;
>> >  	}
>> > +	case XDP_CQ_EVENT:
>> > +	{
>> > +		int cq_event;
>> > +
>> > +		if (optlen < sizeof(cq_event))
>> > +			return -EINVAL;
>> > +		if (copy_from_sockptr(&cq_event, optval, sizeof(cq_event)))
>> > +			return -EFAULT;
>> > +
>> > +		if (cq_event)
>> > +			xs->cq_event = true;
>> > +		else
>> > +			xs->cq_event = false;
>>
>> It's false by default, isn't it?
>
> I add cq_event inside "xdp_sock", that is got by sk_alloc, this call
> sk_prot_alloc by __GFP_ZERO. So I think it is false.

Right, I meant that what's the point to set it explicitly to 'false'?

>
> Thanks.
>
>>
>> > +
>> > +		return 0;
>> > +	}
>> >  	default:
>> >  		break;
>> >  	}
>> > --
>> > 1.8.3.1
>> >
>> >
>
