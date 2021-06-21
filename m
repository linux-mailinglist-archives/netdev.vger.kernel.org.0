Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB8F3AECB2
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUPqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:46:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhFUPqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:46:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624290232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ddag9uFvLGQiOvNiE/6XQmyTWnhsAzvk8Bmfl6tM6/I=;
        b=ElOnKuybHggfe5K8zPnPcrFCrkBdT3Ge7912ygoVeIxQNygfeyyRHmLwJLhLvu52PYn0ni
        yffU5nwgwlHgU4AgL3Q0K6hOYB1JCrwciePQ+HW/RfU/sLH2Kak/WYiQz4qjV7k/XvY5xB
        JdlA8sefgdlpg93ZDKJnfknnUN+GsfY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-VLfqYMZvP0-NXOtcclqn_g-1; Mon, 21 Jun 2021 11:43:50 -0400
X-MC-Unique: VLfqYMZvP0-NXOtcclqn_g-1
Received: by mail-ed1-f70.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so1044471edv.8
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 08:43:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ddag9uFvLGQiOvNiE/6XQmyTWnhsAzvk8Bmfl6tM6/I=;
        b=kUSSfoIqhSJrtlJ+tdS52VTcdX+IoonVYad6OlJ2Ohp2QL2HuFRL5qSqRPUz0h/15m
         3nL6+srNipDNjVlxk+W9SkgEhiDnsOL4F9seMGs2YEcVmr6e3zjpaEhqtX9qVWA9POWO
         VqccchaLkeyzx4w0XUhJXaCgzM4dTSGiueH2KhXNWHn0QFvFZRqp1st7TyPUPFZLXysT
         Z25b8S6A22uAaEXLxFy3irW8X4thaOtP9Cu+d0EEOwrsiiEo7LEdaUpUVMJgF5RRtDqQ
         qaVYShrg8xzHl7gb4DWR6kKoYhrvkKBXaAgn+YkakDUNEZzJehFosMCixQ/Cc7GOJsbJ
         UBwA==
X-Gm-Message-State: AOAM532qeM2h6N0Yje3xgXYIZroj9xY43GJUEyk7iSuUCKNtI7pHD3Wo
        Qgd/oOQeOFZM3rai9LjgUpVnjEfk1Da74zfknA3F7JHrMtmtmo0I1Jg3B0RFvkScBydSS10mV//
        yo9Yf0tfGs3ZSCbbc
X-Received: by 2002:a17:906:63d2:: with SMTP id u18mr25555884ejk.186.1624290229294;
        Mon, 21 Jun 2021 08:43:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8cHxtxBPwMgmdfZ2KcHNobLmHzbnxJKUnCcyMT+GI82du9KFARfxreKWs3ANB48YHuc9Mjg==
X-Received: by 2002:a17:906:63d2:: with SMTP id u18mr25555853ejk.186.1624290228991;
        Mon, 21 Jun 2021 08:43:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p23sm10619296edt.71.2021.06.21.08.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 08:43:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B61C18071D; Mon, 21 Jun 2021 17:43:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: implement generic cpumap
In-Reply-To: <20210620233200.855534-3-memxor@gmail.com>
References: <20210620233200.855534-1-memxor@gmail.com>
 <20210620233200.855534-3-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 21 Jun 2021 17:43:47 +0200
Message-ID: <87v967rznw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> This change implements CPUMAP redirect support for generic XDP programs.
> The idea is to reuse the cpu map entry's queue that is used to push
> native xdp frames for redirecting skb to a different CPU. This will
> match native XDP behavior (in that RPS is invoked again for packet
> reinjected into networking stack).
>
> To be able to determine whether the incoming skb is from the driver or
> cpumap, we reuse skb->redirected bit that skips generic XDP processing
> when it is set. To always make use of this, CONFIG_NET_REDIRECT guard on
> it has been lifted and it is always available.
>
> From the redirect side, we add the skb to ptr_ring with its lowest bit
> set to 1.  This should be safe as skb is not 1-byte aligned. This allows
> kthread to discern between xdp_frames and sk_buff. On consumption of the
> ptr_ring item, the lowest bit is unset.
>
> In the end, the skb is simply added to the list that kthread is anyway
> going to maintain for xdp_frames converted to skb, and then received
> again by using netif_receive_skb_list.
>
> Bulking optimization for generic cpumap is left as an exercise for a
> future patch for now.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf.h    |   8 +++
>  include/linux/skbuff.h |  10 +--
>  kernel/bpf/cpumap.c    | 151 +++++++++++++++++++++++++++++++++++++----
>  net/core/filter.c      |   6 +-
>  4 files changed, 154 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f309fc1509f2..46e6587d3ee6 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1513,6 +1513,8 @@ bool dev_map_can_have_prog(struct bpf_map *map);
>  void __cpu_map_flush(void);
>  int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> +int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
> +			     struct sk_buff *skb);
>  bool cpu_map_prog_allowed(struct bpf_map *map);
>  
>  /* Return map's numa specified by userspace */
> @@ -1710,6 +1712,12 @@ static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
>  	return 0;
>  }
>  
> +static inline int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
> +					   struct sk_buff *skb)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline bool cpu_map_prog_allowed(struct bpf_map *map)
>  {
>  	return false;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index b2db9cd9a73f..f19190820e63 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -863,8 +863,8 @@ struct sk_buff {
>  	__u8			tc_skip_classify:1;
>  	__u8			tc_at_ingress:1;
>  #endif
> -#ifdef CONFIG_NET_REDIRECT
>  	__u8			redirected:1;
> +#ifdef CONFIG_NET_REDIRECT
>  	__u8			from_ingress:1;
>  #endif
>  #ifdef CONFIG_TLS_DEVICE
> @@ -4664,17 +4664,13 @@ static inline __wsum lco_csum(struct sk_buff *skb)
>  
>  static inline bool skb_is_redirected(const struct sk_buff *skb)
>  {
> -#ifdef CONFIG_NET_REDIRECT
>  	return skb->redirected;
> -#else
> -	return false;
> -#endif
>  }
>  
>  static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
>  {
> -#ifdef CONFIG_NET_REDIRECT
>  	skb->redirected = 1;
> +#ifdef CONFIG_NET_REDIRECT
>  	skb->from_ingress = from_ingress;
>  	if (skb->from_ingress)
>  		skb->tstamp = 0;
> @@ -4683,9 +4679,7 @@ static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
>  
>  static inline void skb_reset_redirect(struct sk_buff *skb)
>  {
> -#ifdef CONFIG_NET_REDIRECT
>  	skb->redirected = 0;
> -#endif
>  }
>  
>  static inline bool skb_csum_is_sctp(struct sk_buff *skb)
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index a1a0c4e791c6..f016daf8fdcc 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -16,6 +16,7 @@
>   * netstack, and assigning dedicated CPUs for this stage.  This
>   * basically allows for 10G wirespeed pre-filtering via bpf.
>   */
> +#include <linux/bitops.h>
>  #include <linux/bpf.h>
>  #include <linux/filter.h>
>  #include <linux/ptr_ring.h>
> @@ -79,6 +80,29 @@ struct bpf_cpu_map {
>  
>  static DEFINE_PER_CPU(struct list_head, cpu_map_flush_list);
>  
> +static void *__ptr_set_bit(void *ptr, int bit)
> +{
> +	unsigned long __ptr = (unsigned long)ptr;
> +
> +	__ptr |= BIT(bit);
> +	return (void *)__ptr;
> +}
> +
> +static void *__ptr_clear_bit(void *ptr, int bit)
> +{
> +	unsigned long __ptr = (unsigned long)ptr;
> +
> +	__ptr &= ~BIT(bit);
> +	return (void *)__ptr;
> +}
> +
> +static int __ptr_test_bit(void *ptr, int bit)
> +{
> +	unsigned long __ptr = (unsigned long)ptr;
> +
> +	return __ptr & BIT(bit);
> +}

Why not put these into bitops.h instead?

>  static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>  {
>  	u32 value_size = attr->value_size;
> @@ -168,6 +192,64 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
>  	}
>  }
>  
> +static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
> +				    void **frames, int skb_n,
> +				    struct xdp_cpumap_stats *stats,
> +				    struct list_head *listp)
> +{
> +	struct xdp_rxq_info rxq = {};
> +	struct xdp_buff xdp;
> +	int err, i;
> +	u32 act;
> +
> +	xdp.rxq = &rxq;
> +
> +	if (!rcpu->prog)
> +		goto insert;
> +
> +	for (i = 0; i < skb_n; i++) {
> +		struct sk_buff *skb = frames[i];
> +
> +		rxq.dev = skb->dev;
> +
> +		act = bpf_prog_run_generic_xdp(skb, &xdp, rcpu->prog);
> +		switch (act) {
> +		case XDP_PASS:
> +			list_add_tail(&skb->list, listp);
> +			break;
> +		case XDP_REDIRECT:
> +			err = xdp_do_generic_redirect(skb->dev, skb, &xdp,
> +						      rcpu->prog);
> +			if (unlikely(err)) {
> +				kfree_skb(skb);
> +				stats->drop++;
> +			} else {
> +				stats->redirect++;
> +			}
> +			return;
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			fallthrough;
> +		case XDP_ABORTED:
> +			trace_xdp_exception(skb->dev, rcpu->prog, act);
> +			fallthrough;
> +		case XDP_DROP:
> +			kfree_skb(skb);
> +			stats->drop++;
> +			return;
> +		}
> +	}
> +
> +	return;
> +
> +insert:
> +	for (i = 0; i < skb_n; i++) {
> +		struct sk_buff *skb = frames[i];
> +
> +		list_add_tail(&skb->list, listp);
> +	}
> +}
> +
>  static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>  				    void **frames, int n,
>  				    struct xdp_cpumap_stats *stats)
> @@ -179,8 +261,6 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>  	if (!rcpu->prog)
>  		return n;
>  
> -	rcu_read_lock_bh();
> -
>  	xdp_set_return_frame_no_direct();
>  	xdp.rxq = &rxq;
>  
> @@ -227,17 +307,36 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
>  		}
>  	}
>  
> +	xdp_clear_return_frame_no_direct();
> +
> +	return nframes;
> +}
> +
> +#define CPUMAP_BATCH 8
> +
> +static int cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu,
> +				void **frames, int xdp_n, int skb_n,
> +				struct xdp_cpumap_stats *stats,
> +				struct list_head *list)
> +{
> +	int nframes;
> +
> +	rcu_read_lock_bh();
> +
> +	nframes = cpu_map_bpf_prog_run_xdp(rcpu, frames, xdp_n, stats);
> +
>  	if (stats->redirect)
> -		xdp_do_flush_map();
> +		xdp_do_flush();
>  
> -	xdp_clear_return_frame_no_direct();
> +	if (unlikely(skb_n))
> +		cpu_map_bpf_prog_run_skb(rcpu, frames + CPUMAP_BATCH, skb_n,
> +					 stats, list);
>  
> -	rcu_read_unlock_bh(); /* resched point, may call do_softirq() */
> +	rcu_read_unlock_bh();
>  
>  	return nframes;
>  }
>  
> -#define CPUMAP_BATCH 8
>  
>  static int cpu_map_kthread_run(void *data)
>  {
> @@ -254,9 +353,9 @@ static int cpu_map_kthread_run(void *data)
>  		struct xdp_cpumap_stats stats = {}; /* zero stats */
>  		unsigned int kmem_alloc_drops = 0, sched = 0;
>  		gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
> -		void *frames[CPUMAP_BATCH];
> +		int i, n, m, nframes, xdp_n, skb_n;
> +		void *frames[CPUMAP_BATCH * 2];

This double-sized array thing is clever, but it hurts readability. You'd
get basically the same code by having them as two separate arrays and
passing in two separate pointers to cpu_map_bpf_prog_run().

Or you could even just use 'list' - you're passing in that anyway, just
to have cpu_map_bpf_prog_run_skb() add the skbs to it; so why not just
add them right here in the caller, and have cpu_map_bpf_prog_run_skb()
remove them again if the rcpu prog doesn't return XDP_PASS?

-Toke

