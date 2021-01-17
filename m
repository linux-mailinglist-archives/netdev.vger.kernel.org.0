Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9692F9606
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbhAQW54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730137AbhAQW5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:57:53 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F31C061573;
        Sun, 17 Jan 2021 14:57:12 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id e22so29418689iom.5;
        Sun, 17 Jan 2021 14:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Aa6qAYFv2el2ckvXqOD5dPY1/AdwtTMVOCOq6+R6Ml4=;
        b=LGcjuHAU0BWJOjAriz4lXDghbF6yEAeTpUNBKzDjmVshwf5hNH9Minl3TgMjbuT0k2
         Wxw4tkqgDvuMa+A/LqdagOxlbpOzAvu20NqDpvxTp6FRxAdIrynpOdDHyx2PPCRYsWVs
         Bvs+0ve8rHi+xX4L8DXapCvb3C7RtzEL4Kze8MHk+CPz4U+r6nCKl052+zldhhMIqNT6
         5tWaBd9BNoPjm49nKfTX2To2g2GryM/TpXgGXL1o5s/k+NNbZlIRR8m9UH4Q9RatqJDF
         62n1mRZ9HMOo5caRcU8Ot54Wke9g6k8+jta+zRI8dI/R0uePw6XNlJAP4/pK/5Ptu6vo
         PPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Aa6qAYFv2el2ckvXqOD5dPY1/AdwtTMVOCOq6+R6Ml4=;
        b=dGHQxpIp2JPOSiBmmDiPgrdoHYjqGqRAtpg2lrYVL0qMzYvzzXTEF2pXN/HxfP5FF/
         EXYeNNjFprFX2FVdWmPs7H7Zjb4VYGUtj+FfUivtgni2Mh2gdlivevXaaMuv1fx/UM3X
         xntGnnSe2hSGiyMMEBfJRzilq43YhkqDnyIidEGqLbxvUZnzV78wYRoo0WCZVGvumfA8
         I6zq7UWPsZOR8j5/+t9H1gaMJ0rI/tV0lREr0la3V2JuVHq+6t/JdB6pOXSLFdK5ngYA
         BsyNokLQk8J5Is5RXF6eR5KJP2yd6KgKhdwIHhKrZ8As1J7Oh0Ec7RGG+UG/+YlILgUu
         tN6Q==
X-Gm-Message-State: AOAM531bi5L1ViHCAl3hMEHm4pqr3ivjXwaGUZfUQJtKTALqyktdYlYd
        94/Ofm0THRjf6hlUye0yqFw=
X-Google-Smtp-Source: ABdhPJyWdxBF1gG7N3jEpP2TmQwZsrAcbMm6wHvytoHJyU69cqYNl1ufmfzLpiMnCeEtHzTEnoZgcw==
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr19289501ilj.155.1610924231653;
        Sun, 17 Jan 2021 14:57:11 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id n11sm7048266ioh.37.2021.01.17.14.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 14:57:10 -0800 (PST)
Date:   Sun, 17 Jan 2021 14:57:02 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <6004c0be660fd_2664208e8@john-XPS-13-9370.notmuch>
In-Reply-To: <20210114142321.2594697-2-liuhangbin@gmail.com>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210114142321.2594697-2-liuhangbin@gmail.com>
Subject: RE: [PATCHv14 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> This changes the devmap XDP program support to run the program when the
> bulk queue is flushed instead of before the frame is enqueued. This has
> a couple of benefits:
> 
> - It "sorts" the packets by destination devmap entry, and then runs the
>   same BPF program on all the packets in sequence. This ensures that we
>   keep the XDP program and destination device properties hot in I-cache.
> 
> - It makes the multicast implementation simpler because it can just
>   enqueue packets using bq_enqueue() without having to deal with the
>   devmap program at all.
> 
> The drawback is that if the devmap program drops the packet, the enqueue
> step is redundant. However, arguably this is mostly visible in a
> micro-benchmark, and with more mixed traffic the I-cache benefit should
> win out. The performance impact of just this patch is as follows:
> 
> Using xdp_redirect_map(with a 2nd xdp_prog patch[1]) in sample/bpf and send
> pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> 
> There are about +/- 0.1M deviation for native testing, the performance
> improved for the base-case, but some drop back with xdp devmap prog attached.
> 
> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
> 5.10 rc6         | xdp_redirect_map   i40e->i40e  |    2.0M |   9.1M |  8.0M
> 5.10 rc6         | xdp_redirect_map   i40e->veth  |    1.7M |  11.0M |  9.7M
> 5.10 rc6 + patch | xdp_redirect_map   i40e->i40e  |    2.0M |   9.5M |  7.5M
> 5.10 rc6 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  11.6M |  9.1M
> 
> [1] https://patchwork.ozlabs.org/project/netdev/patch/20201208120159.2278277-1-liuhangbin@gmail.com/
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> --
> v14: no update, only rebase the code
> v13: pass in xdp_prog through __xdp_enqueue()
> v2-v12: no this patch
> ---
>  kernel/bpf/devmap.c | 115 +++++++++++++++++++++++++++-----------------
>  1 file changed, 72 insertions(+), 43 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f6e9c68afdd4..84fe15950e44 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -57,6 +57,7 @@ struct xdp_dev_bulk_queue {
>  	struct list_head flush_node;
>  	struct net_device *dev;
>  	struct net_device *dev_rx;
> +	struct bpf_prog *xdp_prog;
>  	unsigned int count;
>  };
>  
> @@ -327,40 +328,92 @@ bool dev_map_can_have_prog(struct bpf_map *map)
>  	return false;
>  }
>  
> +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> +				struct xdp_frame **frames, int n,
> +				struct net_device *dev)
> +{
> +	struct xdp_txq_info txq = { .dev = dev };
> +	struct xdp_buff xdp;
> +	int i, nframes = 0;
> +
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +		u32 act;
> +		int err;
> +
> +		xdp_convert_frame_to_buff(xdpf, &xdp);

Hi, slightly higher level question about the desgin. How come we have
to bounce the xdp_frame back and forth between an xdp_buff<->xdp-frame?
Seems a bit wasteful.

> +		xdp.txq = &txq;
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);

xdp_update_frame_from_buff will then convert it back from the xdp_buff?

struct xdp_buff {
	void *data;
	void *data_end;
	void *data_meta;
	void *data_hard_start;
	struct xdp_rxq_info *rxq;
	struct xdp_txq_info *txq;
	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
};

struct xdp_frame {
	void *data;
	u16 len;
	u16 headroom;
	u32 metasize:8;
	u32 frame_sz:24;
	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
	 * while mem info is valid on remote CPU.
	 */
	struct xdp_mem_info mem;
	struct net_device *dev_rx; /* used by cpumap */
};


It looks like we could embed xdp_buff in xdp_frame and then keep the metadata
at the end.

Because you are working performance here wdyt? <- @Jesper as well.


> +			if (unlikely(err < 0))
> +				xdp_return_frame_rx_napi(xdpf);
> +			else
> +				frames[nframes++] = xdpf;
> +			break;
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			fallthrough;
> +		case XDP_ABORTED:
> +			trace_xdp_exception(dev, xdp_prog, act);
> +			fallthrough;
> +		case XDP_DROP:
> +			xdp_return_frame_rx_napi(xdpf);
> +			break;
> +		}
> +	}
> +	return n - nframes; /* dropped frames count */
> +}
> +
>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
>  	int sent = 0, drops = 0, err = 0;
> +	unsigned int cnt = bq->count;
> +	unsigned int xdp_drop;
>  	int i;
>  
> -	if (unlikely(!bq->count))
> +	if (unlikely(!cnt))
>  		return;
>  
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < cnt; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];
>  
>  		prefetch(xdpf);
>  	}
>  
> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> +	if (unlikely(bq->xdp_prog)) {

Whats the rational for making above unlikely()? Seems for users its not
unlikely. Can you measure a performance increase/decrease here? I think
its probably fine to just let compiler/prefetcher do its thing here. Or
I'm not reading this right, but seems users of bq->xdp_prog would disagree
on unlikely case?

Either way a comment might be nice to give us some insight in 6 months
why we decided this is unlikely.

> +		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> +		cnt -= xdp_drop;
> +		if (!cnt) {


if dev_map_bpf_prog_run() returned sent packets this would read better
imo.

  sent = dev_map_bpf_prog_run(...)
  if (!sent)
        goto out;

> +			sent = 0;
> +			drops = xdp_drop;
> +			goto out;
> +		}
> +	}
> +
> +	sent = dev->netdev_ops->ndo_xdp_xmit(dev, cnt, bq->q, flags);

And,    sent = dev->netdev_ops->ndo_xdp_xmit(dev, sent, bq->q, flags);

>  	if (sent < 0) {
>  		err = sent;
>  		sent = 0;
>  		goto error;
>  	}
> -	drops = bq->count - sent;
> +	drops = (cnt - sent) + xdp_drop;

With about 'sent' logic then drops will still be just, drops = bq->count - sent
and move the calculation below the out label and I think you clean up above
as well. Did I miss something...

>  out:
>  	bq->count = 0;
>  
>  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
>  	bq->dev_rx = NULL;
> +	bq->xdp_prog = NULL;
>  	__list_del_clearprev(&bq->flush_node);
>  	return;
>  error:
>  	/* If ndo_xdp_xmit fails with an errno, no frames have been
>  	 * xmit'ed and it's our responsibility to them free all.
>  	 */
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < cnt; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];

Patch looks overall good to me, but cleaning up the logic a bit seems like
a plus.

Thanks,
John
