Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688F11E5B3C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgE1IyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:54:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28396 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727814AbgE1IyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 04:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590656061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1lxwyCGxtxN9osgtnb8nkliEMVBjDWU5uxjafeU9/jk=;
        b=NYGSbp9Tg8W6uZxQntFwqm9yHOYpYC6O49ZVIAx8Q9DyXPhS6mLW6+mh1J+B0iE4ebXp3i
        PGAhxgEe1t+wxKj1WfN5zrkL+91Ax2MJxyQjyAZ/SsLQbSyFYBVZ+U9SlQIpFZYqicuU4r
        7BpV09VD8tEcm85ZQZAjR+/N0groNpQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-sz0S-S1NOie8Q7tTfAQa9A-1; Thu, 28 May 2020 04:54:20 -0400
X-MC-Unique: sz0S-S1NOie8Q7tTfAQa9A-1
Received: by mail-ej1-f71.google.com with SMTP id t24so722582ejr.18
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 01:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1lxwyCGxtxN9osgtnb8nkliEMVBjDWU5uxjafeU9/jk=;
        b=JU2SGVRJM3dVEB9DuJ126MmvQW4oZ7XmQxX9hV8Fq7YVWsVnNxqmDHZy3vSgGcsHQg
         hhImaWrzLB6R7KZTSI4U0Px06kw71jKrsByV4aBo3hQmDD44BEud2/OPMSROJ7XDGv9B
         yZ7mlgMmHc67zTBARN5mtxR5F+dK0aLt0k4PuVjMqUTZ6MdevuUIp7W62WiwDzesFMA2
         azgRkUOGAWQIXnXYSGtSsfMgjbc9IhC6sYw9tnXZHepDW8WCJtKmyqVIM2TVNY6x0pL9
         /VmTb7+spjPN+eZd8Qz29PiKnFHSTLn+5DRm9Ws1B9+/ZRvX4okonq8/xdTDrTqO2Uuc
         iHiA==
X-Gm-Message-State: AOAM531o4/Jh50IAqJlrQ083zT8+9uxVwFJfKzSAJzAysIdnOeRZX8AJ
        t0lqNQVw2D+y3ygDNrk1AQ+OSR79oFsgKTt6AdJBcZjAKnHhJcH/EaBc4kaeD/iIX9J7YwiulcV
        HdSXN+3Y3VZlKXgxQ
X-Received: by 2002:a17:906:3604:: with SMTP id q4mr2061468ejb.69.1590656058837;
        Thu, 28 May 2020 01:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgrBGbo91q3XVOx83h18peGBrxYXFDyk5kdyTbbwMeDxGoJ04YNFCZFJkjHDM2PqgqQy8Mlg==
X-Received: by 2002:a17:906:3604:: with SMTP id q4mr2061452ejb.69.1590656058545;
        Thu, 28 May 2020 01:54:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id af15sm4891973ejc.89.2020.05.28.01.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 01:54:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 656671804EB; Thu, 28 May 2020 10:54:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 bpf-next 2/5] bpf: Add support to attach bpf program to a devmap entry
In-Reply-To: <20200528001423.58575-3-dsahern@kernel.org>
References: <20200528001423.58575-1-dsahern@kernel.org> <20200528001423.58575-3-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 28 May 2020 10:54:17 +0200
Message-ID: <87imgg1lty.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dsahern@gmail.com>
>
> Add BPF_XDP_DEVMAP attach type for use with programs associated with a
> DEVMAP entry.
>
> Allow DEVMAPs to associate a program with a device entry by adding
> a bpf_prog_fd to 'struct devmap_val'. Values read show the program
> id, so the fd and id are a union.
>
> The program associated with the fd must have type XDP with expected
> attach type BPF_XDP_DEVMAP. When a program is associated with a device
> index, the program is run on an XDP_REDIRECT and before the buffer is
> added to the per-cpu queue. At this point rxq data is still valid; the
> next patch adds tx device information allowing the prorgam to see both
> ingress and egress device indices.
>
> XDP generic is skb based and XDP programs do not work with skb's. Block
> the use case by walking maps used by a program that is to be attached
> via xdpgeneric and fail if any of them are DEVMAP / DEVMAP_HASH with
>  > 4-byte values.
>
> Block attach of BPF_XDP_DEVMAP programs to devices.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/linux/bpf.h            |  5 +++
>  include/uapi/linux/bpf.h       |  5 +++
>  kernel/bpf/devmap.c            | 79 +++++++++++++++++++++++++++++++++-
>  net/core/dev.c                 | 18 ++++++++
>  tools/include/uapi/linux/bpf.h |  5 +++
>  5 files changed, 110 insertions(+), 2 deletions(-)
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
> index d27302ecaa9c..2d9927b7a922 100644
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
> @@ -3628,6 +3629,10 @@ struct xdp_md {
>  /* DEVMAP values */
>  struct devmap_val {
>  	__u32 ifindex;   /* device index */
> +	union {
> +		int   bpf_prog_fd;  /* prog fd on map write */
> +		__u32 bpf_prog_id;  /* prog id on map read */
> +	};
>  };
>  
>  enum sk_action {
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 069a50113e26..a628585a31e1 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -64,6 +64,7 @@ struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct hlist_node index_hlist;
>  	struct bpf_dtab *dtab;
> +	struct bpf_prog *xdp_prog;
>  	struct rcu_head rcu;
>  	unsigned int idx;
>  	struct devmap_val val;
> @@ -219,6 +220,8 @@ static void dev_map_free(struct bpf_map *map)
>  
>  			hlist_for_each_entry_safe(dev, next, head, index_hlist) {
>  				hlist_del_rcu(&dev->index_hlist);
> +				if (dev->xdp_prog)
> +					bpf_prog_put(dev->xdp_prog);
>  				dev_put(dev->dev);
>  				kfree(dev);
>  			}
> @@ -233,6 +236,8 @@ static void dev_map_free(struct bpf_map *map)
>  			if (!dev)
>  				continue;
>  
> +			if (dev->xdp_prog)
> +				bpf_prog_put(dev->xdp_prog);
>  			dev_put(dev->dev);
>  			kfree(dev);
>  		}
> @@ -319,6 +324,16 @@ static int dev_map_hash_get_next_key(struct bpf_map *map, void *key,
>  	return -ENOENT;
>  }
>  
> +bool dev_map_can_have_prog(struct bpf_map *map)
> +{
> +	if ((map->map_type == BPF_MAP_TYPE_DEVMAP ||
> +	     map->map_type == BPF_MAP_TYPE_DEVMAP_HASH) &&
> +	    map->value_size != 4)

nit (since you've gotten rid of the magic sizes everywhere else) how about:

map->value_size != sizeof_field(struct devmap_val, ifindex)

