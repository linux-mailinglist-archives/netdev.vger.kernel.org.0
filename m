Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923F31E3E63
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgE0KBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:01:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729754AbgE0KB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590573687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p+Npb1oaA/q+RvOPe4v/x6Ts2XAyuVZ94IYNronv0pU=;
        b=f/Eb/+onXWlZ7T75FZOBq8O5sV5pEIRz+rfENaRJLvY9yASkiKaBz4tTMZVxuJsn0ZONYx
        NXvqd1DU+up6zG7rsilHXlEB5k81A7M/tDYX5rP1+XwAXj73Iap4X1Gx+gPkFFZbLTDtqn
        Q/balH5H/zn4F9tSein1LcRZy5CftzQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-wGgKYjScPnmb2jsXPtDdwA-1; Wed, 27 May 2020 06:01:25 -0400
X-MC-Unique: wGgKYjScPnmb2jsXPtDdwA-1
Received: by mail-ed1-f72.google.com with SMTP id f18so9924497eds.6
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 03:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p+Npb1oaA/q+RvOPe4v/x6Ts2XAyuVZ94IYNronv0pU=;
        b=Q6yMX6+meLukVQzIXG4bF3wN4MxHLXL47cSh/0GQPgjF255+A4/XSm6z5Q1A260YHl
         U2qY13dIOaDfrLkUYSXJDX57vwvbOJgXrPECKCN26SWQZqUOEZIUBNZtRQQLxyNSZC0P
         96LfLWSxcMgi+TyWpMSzoKZlU8nJkmM+VY7VR/GL+U0df4gHXrhfVrIvGp2ftRpGIBPp
         djY1rVUAQSpuCy+uCgMS6eO2vZFr2Q6/gX3l0jrStU5K+vKqWUrpIQz2AHqGUCaZdjvl
         2ERajMWD3pBFcisbGdDZsW4OKg744LcygNNjEyeKS5v7gnlq6qKVfXXVi/josTorAxlK
         LNCQ==
X-Gm-Message-State: AOAM531jDVp17X2+vHCSiPfZ1dHfhrvth/cEZS7Te4yOF63xBNieSMBb
        x9Kl2tKfitkI55hzwlaVlvFbfVQH6gWld7cAu2C4D95Bg4HWtREFRbINyYUzG8/sbLe9ywHylWO
        j6y8HeevuYhuXpBxP
X-Received: by 2002:a17:906:7848:: with SMTP id p8mr5417793ejm.244.1590573683415;
        Wed, 27 May 2020 03:01:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5Xu/zdCY6KpNrSX/F4O4WzJirUlgGVX+ezeIKJeAMNHLVv3YFwK6xPvAH/J95xYbz8b91aQ==
X-Received: by 2002:a17:906:7848:: with SMTP id p8mr5417750ejm.244.1590573683048;
        Wed, 27 May 2020 03:01:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c23sm2255587ejm.116.2020.05.27.03.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:01:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B97471804EB; Wed, 27 May 2020 12:01:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH bpf-next 2/5] bpf: Add support to attach bpf program to a devmap entry
In-Reply-To: <20200527010905.48135-3-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org> <20200527010905.48135-3-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 12:01:21 +0200
Message-ID: <875zch3de6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> Add BPF_XDP_DEVMAP attach type for use with programs associated with a
> DEVMAP entry.
>
> DEVMAPs can associate a program with a device entry by setting the
> value to <index, fd> pair. The program associated with the fd must have
> type XDP with expected attach type BPF_XDP_DEVMAP. When a program is
> associated with a device index, the program is run on an XDP_REDIRECT
> and before the buffer is added to the per-cpu queue. At this point
> rxq data is still valid; the next patch adds tx device information
> allowing the prorgam to see both ingress and egress device indices.
>
> XDP generic is skb based and XDP programs do not work with skb's. Block
> the use case by walking maps used by a program that is to be attached
> via xdpgeneric and fail if any of them are DEVMAP / DEVMAP_HASH with
> 8-bytes values.
>
> Block attach of BPF_XDP_DEVMAP programs to devices.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  include/linux/bpf.h            |  5 ++
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/devmap.c            | 92 ++++++++++++++++++++++++++++++----
>  net/core/dev.c                 | 18 +++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  5 files changed, 108 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index efe8836b5c48..088751bc09aa 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1242,6 +1242,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
>  			     struct bpf_prog *xdp_prog);
> +bool dev_map_can_have_prog(struct bpf_map *map);
>  
>  struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
>  void __cpu_map_flush(void);
> @@ -1355,6 +1356,10 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
>  {
>  	return NULL;
>  }
> +static inline bool dev_map_can_have_prog(struct bpf_map *map)
> +{
> +	return false;
> +}
>  
>  static inline void __dev_flush(void)
>  {
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 97e1fd19ff58..8c2c0d0c9a0e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -224,6 +224,7 @@ enum bpf_attach_type {
>  	BPF_CGROUP_INET6_GETPEERNAME,
>  	BPF_CGROUP_INET4_GETSOCKNAME,
>  	BPF_CGROUP_INET6_GETSOCKNAME,
> +	BPF_XDP_DEVMAP,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 95db6d8beebc..7658b3e2e7fc 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -73,6 +73,7 @@ struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct hlist_node index_hlist;
>  	struct bpf_dtab *dtab;
> +	struct bpf_prog *xdp_prog;
>  	struct rcu_head rcu;
>  	unsigned int idx;
>  	struct dev_map_ext_val val;
> @@ -231,6 +232,8 @@ static void dev_map_free(struct bpf_map *map)
>  
>  			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
>  				hlist_del_rcu(&dev->index_hlist);
> +				if (dev->xdp_prog)
> +					bpf_prog_put(dev->xdp_prog);
>  				dev_put(dev->dev);
>  				kfree(dev);
>  			}
> @@ -245,6 +248,8 @@ static void dev_map_free(struct bpf_map *map)
>  			if (!dev)
>  				continue;
>  
> +			if (dev->xdp_prog)
> +				bpf_prog_put(dev->xdp_prog);
>  			dev_put(dev->dev);
>  			kfree(dev);
>  		}
> @@ -331,6 +336,16 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
>  	return -ENOENT;
>  }
>  
> +bool dev_map_can_have_prog(struct bpf_map *map)
> +{
> +	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
> +	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
> +	    map->value_size != 4)
> +		return true;
> +
> +	return false;
> +}
> +
>  static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
> @@ -455,6 +470,35 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  	return bq_enqueue(dev, xdpf, dev_rx);
>  }
>  
> +static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
> +					 struct xdp_buff *xdp,
> +					 struct bpf_prog *xdp_prog)
> +{
> +	u32 act;
> +
> +	act = bpf_prog_run_xdp(xdp_prog, xdp);
> +	switch (act) {
> +	case XDP_DROP:
> +		fallthrough;
> +	case XDP_PASS:
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(dev, xdp_prog, act);
> +		act = XDP_DROP;
> +		break;
> +	}
> +
> +	if (act == XDP_DROP) {
> +		xdp_return_buff(xdp);
> +		xdp = NULL;
> +	}
> +
> +	return xdp;
> +}
> +
>  int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx)
>  {
> @@ -466,6 +510,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  {
>  	struct net_device *dev = dst->dev;
>  
> +	if (dst->xdp_prog) {
> +		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
> +		if (!xdp)
> +			return 0;
> +	}
>  	return __xdp_enqueue(dev, xdp, dev_rx);
>  }

Did you give any special consideration to where the hook should be? I'm
asking because my immediate thought was that it should be on flush
(i.e., in bq_xmit_all()), but now that I see this I'm so sure anymore.
What were your thoughts around this?

-Toke

