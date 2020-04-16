Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D7D1AC4AA
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503921AbgDPOCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:02:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35341 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2441898AbgDPOCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 10:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gSJyZLga7ER7EnbVkueeWn7ZBeTH6pAV8OAFKoF98DY=;
        b=h0ZepTp4P+DQ7Wajyn1OYCZX0nw/0afMdsrZj9FfdBKdSyFArkaK39xzk1fr42qcU8hunx
        xhGRotiinYVuvSR3cGNsNiAEps2h6UiDsvANL8Snl2WtBUHOBTmoXpGaIBGThK7YnTS05K
        hMpb94LFJriWyPO+MbFFGD7atG5Db2w=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-CMwoOOZMN82TCHzZCumVPw-1; Thu, 16 Apr 2020 10:02:31 -0400
X-MC-Unique: CMwoOOZMN82TCHzZCumVPw-1
Received: by mail-lf1-f72.google.com with SMTP id l28so2322412lfp.8
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 07:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gSJyZLga7ER7EnbVkueeWn7ZBeTH6pAV8OAFKoF98DY=;
        b=s1BG41U36xlBtrZuq7TqH/HN/xg+zGgv+FteEa+yEd44lu7POjb1vXLoBPL9gtqVLE
         wD8k7XX70UVgaPAwIlZFgua55hk+Czv1azO6ysXB0RAMhz2v8clWszwnekQKlmOE2x7Z
         f2ZgeeviDdvZHpIY1L5UhnAcJIPDqQvJ8kBgF3KJkillv54QnlPO5SowSxFSh18kdLdQ
         3EF1ywbc4xnFmmtBfZahOjfmzjRFIwa/6LvZ7EDByRHa+VIFwnIZv6JShB7O3PEwd2Qw
         JIfo5QQh1yEHXDvutiy3MxNiaj3Ox3eW3XKPKC0giFgYdfycFcmYWKo3k1ae/pBNXopL
         NNkg==
X-Gm-Message-State: AGi0PuY1DJQ4nxIJSvG/2+9WnCdrYQnTfnfiRqzRn9jC7uaVDrV7n+7s
        gH25YTBceiNfXI99Alzj2qvsXPD6iwnfS6wh1Lccd+WwMcqKkhcAIjqfJRxbLPV4cgW2x4SwU+R
        4O+AqFC9DpDe9hSBv
X-Received: by 2002:a2e:a548:: with SMTP id e8mr6538071ljn.151.1587045750070;
        Thu, 16 Apr 2020 07:02:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypKCAs43V6pYsaF/TONUaSErzyvspDJpH+tLyhhYYu+8FdHmVylujRQrD23iAsSUMv/lGGT95w==
X-Received: by 2002:a2e:a548:: with SMTP id e8mr6538048ljn.151.1587045749770;
        Thu, 16 Apr 2020 07:02:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t19sm15158531lfl.53.2020.04.16.07.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 07:02:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6EAA6181587; Thu, 16 Apr 2020 16:02:28 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH RFC-v5 bpf-next 09/12] dev: Support xdp in the Tx path for xdp_frames
In-Reply-To: <20200413171801.54406-10-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org> <20200413171801.54406-10-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Apr 2020 16:02:28 +0200
Message-ID: <87imhzlea3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Add support to run Tx path program on xdp_frames by adding a hook to
> bq_xmit_all before xdp_frames are passed to ndo_xdp_xmit for the device.
>
> If an xdp_frame is dropped by the program, it is removed from the
> xdp_frames array with subsequent entries moved up.
>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/linux/netdevice.h |  3 ++
>  kernel/bpf/devmap.c       | 19 ++++++++---
>  net/core/dev.c            | 70 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 87 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 39e1b42c042f..d75e31ac2751 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3715,6 +3715,9 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
>  void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
>  int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb);
>  u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb);
> +unsigned int do_xdp_egress_frame(struct net_device *dev,
> +				 struct xdp_frame **frames,
> +				 unsigned int *pcount);
>  int netif_rx(struct sk_buff *skb);
>  int netif_rx_ni(struct sk_buff *skb);
>  int netif_receive_skb(struct sk_buff *skb);
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 58bdca5d978a..bedecd07d898 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -322,24 +322,33 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
>  	int sent = 0, drops = 0, err = 0;
> +	unsigned int count = bq->count;
>  	int i;
>  
> -	if (unlikely(!bq->count))
> +	if (unlikely(!count))
>  		return 0;
>  
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < count; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];
>  
>  		prefetch(xdpf);
>  	}
>  
> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> +	if (static_branch_unlikely(&xdp_egress_needed_key)) {
> +		count = do_xdp_egress_frame(dev, bq->q, &count);

nit: seems a bit odd to pass the point to count, then reassign it with
the return value?

> +		drops += bq->count - count;
> +		/* all frames consumed by the xdp program? */
> +		if (!count)
> +			goto out;
> +	}
> +
> +	sent = dev->netdev_ops->ndo_xdp_xmit(dev, count, bq->q, flags);
>  	if (sent < 0) {
>  		err = sent;
>  		sent = 0;
>  		goto error;
>  	}
> -	drops = bq->count - sent;
> +	drops += count - sent;
>  out:
>  	bq->count = 0;
>  
> @@ -351,7 +360,7 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  	/* If ndo_xdp_xmit fails with an errno, no frames have been
>  	 * xmit'ed and it's our responsibility to them free all.
>  	 */
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < count; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];
>  
>  		xdp_return_frame_rx_napi(xdpf);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1bbaeb8842ed..f23dc6043329 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4720,6 +4720,76 @@ u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
>  
> +static u32 __xdp_egress_frame(struct net_device *dev,
> +			      struct bpf_prog *xdp_prog,
> +			      struct xdp_frame *xdp_frame,
> +			      struct xdp_txq_info *txq)
> +{
> +	struct xdp_buff xdp;
> +	u32 act;
> +
> +	xdp.data_hard_start = xdp_frame->data - xdp_frame->headroom;
> +	xdp.data = xdp_frame->data;
> +	xdp.data_end = xdp.data + xdp_frame->len;
> +	xdp_set_data_meta_invalid(&xdp);

Why invalidate the metadata? On the contrary we'd want metadata from the
RX side to survive, wouldn't we?

> +	xdp.txq = txq;
> +
> +	act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +	act = handle_xdp_egress_act(act, dev, xdp_prog);
> +
> +	/* if not dropping frame, readjust pointers in case
> +	 * program made changes to the buffer
> +	 */
> +	if (act != XDP_DROP) {
> +		int headroom = xdp.data - xdp.data_hard_start;
> +		int metasize = xdp.data - xdp.data_meta;
> +
> +		metasize = metasize > 0 ? metasize : 0;
> +		if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
> +			return XDP_DROP;
> +
> +		xdp_frame = xdp.data_hard_start;
> +		xdp_frame->data = xdp.data;
> +		xdp_frame->len  = xdp.data_end - xdp.data;
> +		xdp_frame->headroom = headroom - sizeof(*xdp_frame);
> +		xdp_frame->metasize = metasize;
> +		/* xdp_frame->mem is unchanged */
> +	}
> +
> +	return act;
> +}
> +
> +unsigned int do_xdp_egress_frame(struct net_device *dev,
> +				 struct xdp_frame **frames,
> +				 unsigned int *pcount)
> +{
> +	struct bpf_prog *xdp_prog;
> +	unsigned int count = *pcount;
> +
> +	xdp_prog = rcu_dereference(dev->xdp_egress_prog);
> +	if (xdp_prog) {
> +		struct xdp_txq_info txq = { .dev = dev };

Do you have any thoughts on how to populate this for the redirect case?
I guess using Magnus' HWQ abstraction when that lands? Or did you have
something different in mind?

> +		unsigned int i, j;
> +		u32 act;
> +
> +		for (i = 0, j = 0; i < count; i++) {
> +			struct xdp_frame *frame = frames[i];
> +
> +			act = __xdp_egress_frame(dev, xdp_prog, frame, &txq);
> +			if (act == XDP_DROP) {
> +				xdp_return_frame_rx_napi(frame);
> +				continue;
> +			}
> +
> +			frames[j] = frame;
> +			j++;
> +		}
> +		count = j;
> +	}
> +
> +	return count;
> +}
> +
>  static int netif_rx_internal(struct sk_buff *skb)
>  {
>  	int ret;
> -- 
> 2.21.1 (Apple Git-122.3)

