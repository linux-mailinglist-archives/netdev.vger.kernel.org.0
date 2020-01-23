Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5FA146369
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 09:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgAWIXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 03:23:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28914 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgAWIXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 03:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579767817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W1079Sc3YinweIQqvR7AOqDDXfHjE2GoBaavvSp8qNQ=;
        b=icgt5TpyItXwKP6lZzsf4BmuQ9sOuvqPGzMljJ2HkQ2Nmd2GV8G/nFsrWGLE7q6/laJUcK
        iNWlCI8kfd+LCq0s8JiSZTlPPpNVaLASwvBDtKAGekEM2Wq3umFHBPuQIIF1rqJxumdXin
        GcvLL5d1WR/qMQAKynzW+K/SbcSgc6o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-D4NeWquqOoyztnP9gtgHDw-1; Thu, 23 Jan 2020 03:23:28 -0500
X-MC-Unique: D4NeWquqOoyztnP9gtgHDw-1
Received: by mail-wr1-f70.google.com with SMTP id k18so1384178wrw.9
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 00:23:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W1079Sc3YinweIQqvR7AOqDDXfHjE2GoBaavvSp8qNQ=;
        b=ZxnNUUTv65NqUJJWrcXIpVgrnqZlcVv4GOpuURbp6A7aAtV4mAuXiXqocfTvBQuVif
         whwGa/SbE5+ku5NM63zc+cDDJyFk/mpWzUqhNpymrnlhUnar7ddhCTvLCrNZPlLtNiAT
         8q1MzRfkvl5pkkBMhot0RNaIodzgGMtgtkUkFUQBmD1ytiOFIuxtJmEz5vBQPfUmCXDY
         T/t1pH2KM/8knMRZcVoaYvrduvh8qvQ6+OitQL2EuEXsI/fQq7YKZn+u55lwJHHCSzQj
         WgeSqoQ5sMdoMmR94qMbRReYPZLXjZuORdFt/CYqDFzYyQCyGq6q9LlSI/DqMKi3HF2H
         JlGg==
X-Gm-Message-State: APjAAAVJ08ESmAdGTftgK+aA/E3/gv0uF/di0brizeren6PsZvkH35rG
        t7JWlQaLEcqBAB2Ug0rzjTnntGo4k1X5Q0yWwID2VdR2L4vYa0rS1Z+7vy1sO97EPkEXKUPXs3m
        /BnidOGhBuipkWJZa
X-Received: by 2002:a5d:5704:: with SMTP id a4mr17112565wrv.198.1579767807312;
        Thu, 23 Jan 2020 00:23:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwu6zDuvRBYXxvwfYFlcqEKG4azPjz3eSnrD3oDImQ9KpBW6g+OnZ5PtKDJSexJXegFFR2H/g==
X-Received: by 2002:a5d:5704:: with SMTP id a4mr17112537wrv.198.1579767807032;
        Thu, 23 Jan 2020 00:23:27 -0800 (PST)
Received: from redhat.com (bzq-79-176-0-156.red.bezeqint.net. [79.176.0.156])
        by smtp.gmail.com with ESMTPSA id n189sm1778796wme.33.2020.01.23.00.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 00:23:26 -0800 (PST)
Date:   Thu, 23 Jan 2020 03:23:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, jbrouer@redhat.com, toke@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH bpf-next 10/12] tun: run XDP program in tx path
Message-ID: <20200123032154-mutt-send-email-mst@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-11-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123014210.38412-11-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 06:42:08PM -0700, David Ahern wrote:
> From: Prashant Bhole <prashantbhole.linux@gmail.com>
> 
> Run the XDP program as soon as packet is removed from the ptr
> ring. Since this is XDP in tx path, the traditional handling of
> XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
> do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
> just runs the program and leaves the action handling to us.
> 
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  drivers/net/tun.c | 153 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 150 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index b6bac773f2a0..71bcd4ec2571 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -130,6 +130,7 @@ struct tap_filter {
>  /* MAX_TAP_QUEUES 256 is chosen to allow rx/tx queues to be equal
>   * to max number of VCPUs in guest. */
>  #define MAX_TAP_QUEUES 256
> +#define MAX_TAP_BATCH 64
>  #define MAX_TAP_FLOWS  4096
>  
>  #define TUN_FLOW_EXPIRE (3 * HZ)
> @@ -175,6 +176,7 @@ struct tun_file {
>  	struct tun_struct *detached;
>  	struct ptr_ring tx_ring;
>  	struct xdp_rxq_info xdp_rxq;
> +	void *pkt_ptrs[MAX_TAP_BATCH];
>  };
>  
>  struct tun_page {
> @@ -2140,6 +2142,107 @@ static ssize_t tun_put_user(struct tun_struct *tun,
>  	return total;
>  }
>  
> +static struct sk_buff *tun_prepare_xdp_skb(struct sk_buff *skb)
> +{
> +	struct sk_buff *nskb;
> +
> +	if (skb_shared(skb) || skb_cloned(skb)) {
> +		nskb = skb_copy(skb, GFP_ATOMIC);
> +		consume_skb(skb);
> +		return nskb;
> +	}
> +
> +	return skb;
> +}
> +
> +static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
> +				 struct sk_buff *skb)
> +{
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 act = XDP_PASS;
> +
> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
> +	if (xdp_prog) {
> +		skb = tun_prepare_xdp_skb(skb);
> +		if (!skb) {
> +			act = XDP_DROP;
> +			kfree_skb(skb);
> +			goto drop;
> +		}
> +
> +		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
> +		switch (act) {
> +		case XDP_TX:
> +			/* Rx path generic XDP will be called in this path
> +			 */
> +			local_bh_disable();
> +			netif_receive_skb(skb);
> +			local_bh_enable();
> +			break;
> +		case XDP_PASS:
> +			break;
> +		case XDP_REDIRECT:
> +			/* Since we are not handling this case yet, let's free
> +			 * skb here. In case of XDP_DROP/XDP_ABORTED, the skb
> +			 * was already freed in do_xdp_generic_core()
> +			 */
> +			kfree_skb(skb);
> +			/* fall through */
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fall through */
> +		case XDP_ABORTED:
> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> +			/* fall through */
> +		case XDP_DROP:
> +			goto drop;
> +		}
> +	}
> +
> +	return act;
> +drop:
> +	this_cpu_inc(tun->pcpu_stats->tx_dropped);
> +	return act;
> +}
> +
> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
> +			 struct xdp_frame *frame)
> +{
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 act = XDP_PASS;
> +
> +	xdp_prog = rcu_dereference(tun->xdp_egress_prog);
> +	if (xdp_prog) {
> +		xdp.data_hard_start = frame->data - frame->headroom;
> +		xdp.data = frame->data;
> +		xdp.data_end = xdp.data + frame->len;
> +		xdp.data_meta = xdp.data - frame->metasize;
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			break;
> +		case XDP_TX:
> +			/* fall through */
> +		case XDP_REDIRECT:
> +			/* fall through */
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			/* fall through */
> +		case XDP_ABORTED:
> +			trace_xdp_exception(tun->dev, xdp_prog, act);
> +			/* fall through */
> +		case XDP_DROP:
> +			xdp_return_frame_rx_napi(frame);
> +			break;
> +		}
> +	}
> +
> +	return act;
> +}
> +
>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
>  {
>  	DECLARE_WAITQUEUE(wait, current);
> @@ -2557,6 +2660,52 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  	return ret;
>  }
>  
> +static int tun_consume_packets(struct tun_file *tfile, void **ptr_array, int n)
> +{
> +	void **pkts = tfile->pkt_ptrs;
> +	struct xdp_frame *frame;
> +	struct tun_struct *tun;
> +	int i, num_ptrs;
> +	int pkt_cnt = 0;
> +	void *ptr;
> +	u32 act;
> +	int batchsz;
> +
> +	if (unlikely(!tfile))
> +		return 0;
> +
> +	rcu_read_lock();
> +	tun = rcu_dereference(tfile->tun);
> +	if (unlikely(!tun)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +
> +	while (n) {
> +		batchsz = (n > MAX_TAP_BATCH) ? MAX_TAP_BATCH : n;
> +		n -= batchsz;
> +		num_ptrs = ptr_ring_consume_batched(&tfile->tx_ring, pkts,
> +						    batchsz);
> +		if (!num_ptrs)
> +			break;

Can't we avoid looping over the packets in the current case
where there are no xdp programs at all?


> +		for (i = 0; i < num_ptrs; i++) {
> +			ptr = pkts[i];
> +			if (tun_is_xdp_frame(ptr)) {
> +				frame = tun_ptr_to_xdp(ptr);
> +				act = tun_do_xdp_tx(tun, tfile, frame);
> +			} else {
> +				act = tun_do_xdp_tx_generic(tun, ptr);
> +			}
> +
> +			if (act == XDP_PASS)
> +				ptr_array[pkt_cnt++] = ptr;
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +	return pkt_cnt;
> +}
> +
>  static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>  		       int flags)
>  {
> @@ -2577,9 +2726,7 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
>  			ptr = ctl->ptr;
>  			break;
>  		case TUN_MSG_CONSUME_PKTS:
> -			ret = ptr_ring_consume_batched(&tfile->tx_ring,
> -						       ctl->ptr,
> -						       ctl->num);
> +			ret = tun_consume_packets(tfile, ctl->ptr, ctl->num);
>  			goto out;
>  		case TUN_MSG_UNCONSUME_PKTS:
>  			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr,
> -- 
> 2.21.1 (Apple Git-122.3)

