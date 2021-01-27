Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B8F3054DC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhA0Hle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbhA0HiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:38:22 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24662C06174A;
        Tue, 26 Jan 2021 23:37:42 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d81so951547iof.3;
        Tue, 26 Jan 2021 23:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=J/luXJA5XBMYYxnRalHU96ygNZ23KxEs6NNDNp/ohpI=;
        b=K6rKXwHBNNbeoYDUU0yt2JM0LrLZB/+zCDxsa/FF502vTemO3Isk+sI/HloYlA2AEg
         mvOPy1Y/rSutQXKpCH0tjDJ2X41ljAUmtvdSqGzC5FkRlOfpm4J59ZRZgYtCMgAT7lNv
         zWSwZeKrqc5hnONcBsVDs0HXh4lX/eB8xA1XrEeJ0Q1Y3U+Dfx+3oq40hdB62NnQx0zD
         YIKeeR1CymsrJva6tuhYVoRfF7UNovYrDgpEsc9S5FZNW/Izq6EZGYoS3OarJOLXeg30
         ryyB7UnLz9CiwwQk6JxLoinyNQP4gu6vq/Y36SofIh5L85/NvurOjpztI+xJrv+AhZ9d
         yBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=J/luXJA5XBMYYxnRalHU96ygNZ23KxEs6NNDNp/ohpI=;
        b=dyp8ehOXRG0AG4cbk3CW9VKBL6Wkhy5LUzrleP5qAjmkFvdia9IW6qhCdKck5M3fOy
         vPdGKn+0kcEOOVLEAa2xKHk9Cnf9vhqQDlmRZad1nVTAMHwhf7uH3JkbT+G8Llc3HZ3x
         tInANSmfZcEy/rXFVJbUWZfvGAOv7FEarnuceqH8evBhyaWgXVmqauiSrUyoAOs3hk2C
         rGaxKO0sz2fRxWMyGZlUFEbZiaA5h6LOMo/N5h8atZhjp9mS6I4vudXnL2lg7HXobmrc
         F5p1gRieiNBy3ofy164fF7yNIkQdFRiDaYJnbsLn6yifxoJR71f1U/LUDXoAXPn4Vv5d
         xiHQ==
X-Gm-Message-State: AOAM531iLj3KoR8jH/zzqEi8wsNtBQZTUPfTUQ+lTdJ1Tc3GACAcCxVG
        9/zvgL9oX38F1+TTMQuSYlg=
X-Google-Smtp-Source: ABdhPJyj84DHvkm2hMN4dUiaySgRdyWlSIBKr9AwxQA+YCSX1QWuhDtfKhq+Bdyn0pMfDOW1FpxM+w==
X-Received: by 2002:a6b:fb09:: with SMTP id h9mr6722212iog.32.1611733061513;
        Tue, 26 Jan 2021 23:37:41 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id l14sm654842ilc.33.2021.01.26.23.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 23:37:40 -0800 (PST)
Date:   Tue, 26 Jan 2021 23:37:33 -0800
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
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <6011183d4628_86d69208ba@john-XPS-13-9370.notmuch>
In-Reply-To: <20210125124516.3098129-2-liuhangbin@gmail.com>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210125124516.3098129-2-liuhangbin@gmail.com>
Subject: RE: [PATCHv17 bpf-next 1/6] bpf: run devmap xdp_prog on flush instead
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
> The bq_xmit_all's logic is also refactored and error label is removed.
> When bq_xmit_all() is called from bq_enqueue(), another packet will
> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
> flush_node in bq_xmit_all() is redundant. Let's move the clear to
> __dev_flush(), and only check them once in bq_enqueue() since they are
> all modified together.
> 
> By using xdp_redirect_map in sample/bpf and send pkts via pktgen cmd:
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

[...]

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
> +		xdp.txq = &txq;
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
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
> +	return nframes; /* sent frames count */
> +}
> +
>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
> -	int sent = 0, drops = 0, err = 0;
> +	unsigned int cnt = bq->count;
> +	int drops = 0, err = 0;
> +	int to_send = cnt;
> +	int sent = cnt;
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
> +	if (bq->xdp_prog) {
> +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> +		if (!to_send) {
> +			sent = 0;
> +			goto out;
> +		}
> +		drops = cnt - to_send;
> +	}

I might be missing something about how *bq works here. What happens when
dev_map_bpf_prog_run returns to_send < cnt?

So I read this as it will send [0, to_send] and [to_send, cnt] will be
dropped? How do we know the bpf prog would have dropped the set,
[to_send+1, cnt]?

> +
> +	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);
>  	if (sent < 0) {
>  		err = sent;
>  		sent = 0;
> -		goto error;
> +
> +		/* If ndo_xdp_xmit fails with an errno, no frames have been
> +		 * xmit'ed and it's our responsibility to them free all.
> +		 */
> +		for (i = 0; i < cnt - drops; i++) {
> +			struct xdp_frame *xdpf = bq->q[i];
> +
> +			xdp_return_frame_rx_napi(xdpf);
> +		}
>  	}
> -	drops = bq->count - sent;
>  out:
> +	drops = cnt - sent;
>  	bq->count = 0;
>  
>  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);

I gather the remaining [to_send+1, cnt] packets are in fact dropped
because we set bq->count=0 and trace_xdp_devmap_xmit seems to think
they are dropped.

Also update the comment in trace_xdp_devmap_xmit,

   /* Catch API error of drv ndo_xdp_xmit sent more than count */

so that it reads to account for devmap progs as well?

> -	bq->dev_rx = NULL;
> -	__list_del_clearprev(&bq->flush_node);
>  	return;
> -error:
> -	/* If ndo_xdp_xmit fails with an errno, no frames have been
> -	 * xmit'ed and it's our responsibility to them free all.
> -	 */
> -	for (i = 0; i < bq->count; i++) {
> -		struct xdp_frame *xdpf = bq->q[i];
> -
> -		xdp_return_frame_rx_napi(xdpf);
> -		drops++;
> -	}
> -	goto out;
>  }

[...]
  
> -static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
> -					 struct xdp_buff *xdp,
> -					 struct bpf_prog *xdp_prog)
> -{
> -	struct xdp_txq_info txq = { .dev = dev };
> -	u32 act;
> -
> -	xdp_set_data_meta_invalid(xdp);
> -	xdp->txq = &txq;
> -
> -	act = bpf_prog_run_xdp(xdp_prog, xdp);
> -	switch (act) {
> -	case XDP_PASS:
> -		return xdp;
> -	case XDP_DROP:
> -		break;
> -	default:
> -		bpf_warn_invalid_xdp_action(act);
> -		fallthrough;
> -	case XDP_ABORTED:
> -		trace_xdp_exception(dev, xdp_prog, act);
> -		break;
> -	}
> -
> -	xdp_return_buff(xdp);
> -	return NULL;
> -}
> -
>  int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx)
>  {
> -	return __xdp_enqueue(dev, xdp, dev_rx);
> +	return __xdp_enqueue(dev, xdp, dev_rx, NULL);
>  }
>  
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> @@ -489,12 +516,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  {
>  	struct net_device *dev = dst->dev;
>  
> -	if (dst->xdp_prog) {
> -		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
> -		if (!xdp)
> -			return 0;

So here it looks like dev_map_run_prog will not drop extra
packets, but will see every single packet.

Are we changing the semantics subtle here? This looks like
a problem to me. We should not drop packets in the new case
unless bpf program tells us to.

> -	}
> -	return __xdp_enqueue(dev, xdp, dev_rx);
> +	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
>  }

Did I miss something? If not maybe a comment in the commit
message would help or in the code itself.

Thanks,
John
