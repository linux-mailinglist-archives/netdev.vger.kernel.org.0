Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE835E30B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbhDMPjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:39:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237575AbhDMPjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:39:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618328336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tsZNPPwQEwQsXCj8Y4wzus7mksq3VK2t+TU1GNor3ko=;
        b=cRL7f99VIyGejplh8HEFNMPwfg37hqPMLwrp5NP+DmOSGLq4hFUW70xuZEV+n7p1Y/Jh16
        tzlMM3FBjdlfRE88kmN3ev5DBWmYw0jREGQs/LJXAJASyC+caGzN6rrZF8URaA6K5zlnOq
        h0r4rzcQrcMN5DC5wrgpQZs1BwYcqN0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-QjeRURaPN3iLKV8Cq1vxKw-1; Tue, 13 Apr 2021 11:38:55 -0400
X-MC-Unique: QjeRURaPN3iLKV8Cq1vxKw-1
Received: by mail-ed1-f70.google.com with SMTP id y13-20020aa7cccd0000b02903781fa66252so1492305edt.18
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 08:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tsZNPPwQEwQsXCj8Y4wzus7mksq3VK2t+TU1GNor3ko=;
        b=fRMyO3iEnNZK+sYI0KNqY1qdiqv8AKVyMxJc4clcnpdXBNqMC97/qb2Iv2WlldSnGH
         LMN3ZC56U5d+WtFMrEquPjsEoPvd1yXk97JIlnpyJejqJS9kRzH0pnAlhRLKMiHEd4MU
         rTIGmjbIyR2KC6NLXjdi9ecP3NSs8esvmN1X1EE0OhL8xsqkCcy3ZXa09TlfLl22aPFW
         vKnEJ5/MvzZ23S+GoR6MlbGJiRmuejA4ad3olj07LQkTSj5Ar7+IhsJDoXcCqgiyNJZs
         jVXpuPzCh1p5obKzJREKkvsrCgNM/KdK2gNORSqjpp4FsBAs7SGFwSZVOHLfax1vJ5Vz
         2N2g==
X-Gm-Message-State: AOAM531bJu3Nhi6iICmLKjYsWeNsI6q2M2ZIK1PQ32WX7Nltn3QuzaV4
        hUd/lErawtkJv8ps30IktUUJROPowG8aoAtf3pC289AOK0pvFBhiuU5KHS2hlow88xMJ262bKcV
        zFaezmem6JeDoFHov
X-Received: by 2002:a50:fb8c:: with SMTP id e12mr36495160edq.295.1618328333539;
        Tue, 13 Apr 2021 08:38:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoZoR7tJsGGC5ktcn7/4InCfrE93Aa/j07i53Tqh4Xv1zk7pQOFY9KC8BmGYT2YHKFeFDVxw==
X-Received: by 2002:a50:fb8c:: with SMTP id e12mr36495111edq.295.1618328332928;
        Tue, 13 Apr 2021 08:38:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id yr16sm7210222ejb.63.2021.04.13.08.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 08:38:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2BB6C1804E8; Tue, 13 Apr 2021 17:38:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv5 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210413094133.3966678-3-liuhangbin@gmail.com>
References: <20210413094133.3966678-1-liuhangbin@gmail.com>
 <20210413094133.3966678-3-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 13 Apr 2021 17:38:51 +0200
Message-ID: <87wnt6mbxw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> extend xdp_redirect_map for broadcast support.
>
> With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
> in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
> excluded when do broadcasting.
>
> When getting the devices in dev hash map via dev_map_hash_get_next_key(),
> there is a possibility that we fall back to the first key when a device
> was removed. This will duplicate packets on some interfaces. So just walk
> the whole buckets to avoid this issue. For dev array map, we also walk the
> whole map to find valid interfaces.
>
> Function bpf_clear_redirect_map() was removed in
> commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
> Add it back as we need to use ri->map again.
>
> Here is the performance result by using 10Gb i40e NIC, do XDP_DROP on
> veth peer, run xdp_redirect_{map, map_multi} in sample/bpf and send pkts
> via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t =
10 -s 64
>
> There are some drop back as we need to loop the map and get each interfac=
e.
>
> Version          | Test                                | Generic | Native
> 5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
> 5.12 rc4         | redirect_map        i40e->veth      |    1.7M | 11.7M
> 5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M
> 5.12 rc4 + patch | redirect_map        i40e->veth      |    1.7M | 11.4M
> 5.12 rc4 + patch | redirect_map multi  i40e->i40e      |    1.9M |  8.9M
> 5.12 rc4 + patch | redirect_map multi  i40e->veth      |    1.7M | 10.9M
> 5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |    1.2M |  3.8M
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Mostly looking good, but found a memory leak in the error path for generic =
XDP :(

See below...

> ---
> v5:
> a) use xchg() instead of READ/WRITE_ONCE and no need to clear ri->flags
>    in xdp_do_redirect()
> b) Do not use get_next_key() as we may restart looping from the first key
>    when remove/update a dev in hash map. Just walk the map directly to
>    get all the devices and ignore the new added/deleted objects.
> c) Loop all the array map instead stop at the first hole.
>
> v4:
> a) add a new argument flag_mask to __bpf_xdp_redirect_map() filter out
> invalid map.
> b) __bpf_xdp_redirect_map() sets the map pointer if the broadcast flag
> is set and clears it if the flag isn't set
> c) xdp_do_redirect() does the READ_ONCE/WRITE_ONCE on ri->map to check
> if we should enqueue multi
>
> v3:
> a) Rebase the code on Bj=C3=B6rn's "bpf, xdp: Restructure redirect action=
s".
>    - Add struct bpf_map *map back to struct bpf_redirect_info as we need
>      it for multicast.
>    - Add bpf_clear_redirect_map() back for devmap.c
>    - Add devmap_lookup_elem() as we need it in general path.
> b) remove tmp_key in devmap_get_next_obj()
>
> v2: Fix flag renaming issue in v1
> ---
>  include/linux/bpf.h            |  20 ++++
>  include/linux/filter.h         |  18 +++-
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  17 +++-
>  kernel/bpf/cpumap.c            |   3 +-
>  kernel/bpf/devmap.c            | 172 ++++++++++++++++++++++++++++++++-
>  net/core/filter.c              |  33 ++++++-
>  net/core/xdp.c                 |  29 ++++++
>  net/xdp/xskmap.c               |   3 +-
>  tools/include/uapi/linux/bpf.h |  17 +++-
>  10 files changed, 299 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ff8cd68c01b3..ab6bde1f3b91 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1496,8 +1496,13 @@ int dev_xdp_enqueue(struct net_device *dev, struct=
 xdp_buff *xdp,
>  		    struct net_device *dev_rx);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_r=
x,
> +			  struct bpf_map *map, bool exclude_ingress);
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
>  			     struct bpf_prog *xdp_prog);
> +int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
> +			   struct bpf_prog *xdp_prog, struct bpf_map *map,
> +			   bool exclude_ingress);
>  bool dev_map_can_have_prog(struct bpf_map *map);
>=20=20
>  void __cpu_map_flush(void);
> @@ -1665,6 +1670,13 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, s=
truct xdp_buff *xdp,
>  	return 0;
>  }
>=20=20
> +static inline
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_r=
x,
> +			  struct bpf_map *map, bool exclude_ingress)
> +{
> +	return 0;
> +}
> +
>  struct sk_buff;
>=20=20
>  static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
> @@ -1674,6 +1686,14 @@ static inline int dev_map_generic_redirect(struct =
bpf_dtab_netdev *dst,
>  	return 0;
>  }
>=20=20
> +static inline
> +int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
> +			   struct bpf_prog *xdp_prog, struct bpf_map *map,
> +			   bool exclude_ingress)
> +{
> +	return 0;
> +}
> +
>  static inline void __cpu_map_flush(void)
>  {
>  }
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 9a09547bc7ba..e4885b42d754 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -646,6 +646,7 @@ struct bpf_redirect_info {
>  	u32 flags;
>  	u32 tgt_index;
>  	void *tgt_value;
> +	struct bpf_map *map;
>  	u32 map_id;
>  	enum bpf_map_type map_type;
>  	u32 kern_flags;
> @@ -1464,17 +1465,18 @@ static inline bool bpf_sk_lookup_run_v6(struct ne=
t *net, int protocol,
>  }
>  #endif /* IS_ENABLED(CONFIG_IPV6) */
>=20=20
> -static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u=
32 ifindex, u64 flags,
> +static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u=
32 ifindex,
> +						  u64 flags, u64 flag_mask,
>  						  void *lookup_elem(struct bpf_map *map, u32 key))
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>=20=20
>  	/* Lower bits of the flags are used as return code on lookup failure */
> -	if (unlikely(flags > XDP_TX))
> +	if (unlikely(flags & ~(BPF_F_ACTION_MASK | flag_mask)))
>  		return XDP_ABORTED;
>=20=20
>  	ri->tgt_value =3D lookup_elem(map, ifindex);
> -	if (unlikely(!ri->tgt_value)) {
> +	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
>  		/* If the lookup fails we want to clear out the state in the
>  		 * redirect_info struct completely, so that if an eBPF program
>  		 * performs multiple lookups, the last one always takes
> @@ -1482,13 +1484,21 @@ static __always_inline int __bpf_xdp_redirect_map=
(struct bpf_map *map, u32 ifind
>  		 */
>  		ri->map_id =3D INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
>  		ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
> -		return flags;
> +		return flags & BPF_F_ACTION_MASK;
>  	}
>=20=20
>  	ri->tgt_index =3D ifindex;
>  	ri->map_id =3D map->id;
>  	ri->map_type =3D map->map_type;
>=20=20
> +	if (flags & BPF_F_BROADCAST) {
> +		WRITE_ONCE(ri->map, map);
> +		ri->flags =3D flags;
> +	} else {
> +		WRITE_ONCE(ri->map, NULL);
> +		ri->flags =3D 0;
> +	}
> +
>  	return XDP_REDIRECT;
>  }
>=20=20
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index a5bc214a49d9..5533f0ab2afc 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -170,6 +170,7 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp=
_frame *xdpf,
>  struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>  					 struct net_device *dev);
>  int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp);
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
>=20=20
>  static inline
>  void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff =
*xdp)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 85c924bc21b1..b178f5b0d3f4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2534,8 +2534,12 @@ union bpf_attr {
>   * 		The lower two bits of *flags* are used as the return code if
>   * 		the map lookup fails. This is so that the return value can be
>   * 		one of the XDP program return codes up to **XDP_TX**, as chosen
> - * 		by the caller. Any higher bits in the *flags* argument must be
> - * 		unset.
> + * 		by the caller. The higher bits of *flags* can be set to
> + * 		BPF_F_BROADCAST or BPF_F_EXCLUDE_INGRESS as defined below.
> + *
> + * 		With BPF_F_BROADCAST the packet will be broadcasted to all the
> + * 		interfaces in the map. with BPF_F_EXCLUDE_INGRESS the ingress
> + * 		interface will be excluded when do broadcasting.
>   *
>   * 		See also **bpf_redirect**\ (), which only supports redirecting
>   * 		to an ifindex, but doesn't require a map to do so.
> @@ -5052,6 +5056,15 @@ enum {
>  	BPF_F_BPRM_SECUREEXEC	=3D (1ULL << 0),
>  };
>=20=20
> +/* Flags for bpf_redirect_map helper */
> +enum {
> +	BPF_F_BROADCAST		=3D (1ULL << 3),
> +	BPF_F_EXCLUDE_INGRESS	=3D (1ULL << 4),
> +};
> +
> +#define BPF_F_ACTION_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
> +#define BPF_F_REDIR_MASK (BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS)
> +
>  #define __bpf_md_ptr(type, name)	\
>  union {					\
>  	type name;			\
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 0cf2791d5099..2c33a7a09783 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -601,7 +601,8 @@ static int cpu_map_get_next_key(struct bpf_map *map, =
void *key, void *next_key)
>=20=20
>  static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_ele=
m);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
> +				      __cpu_map_lookup_elem);
>  }
>=20=20
>  static int cpu_map_btf_id;
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 3980fb3bfb09..599a96c9d2c0 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -198,6 +198,7 @@ static void dev_map_free(struct bpf_map *map)
>  	list_del_rcu(&dtab->list);
>  	spin_unlock(&dev_map_lock);
>=20=20
> +	bpf_clear_redirect_map(map);
>  	synchronize_rcu();
>=20=20
>  	/* Make sure prior __dev_map_entry_free() have completed. */
> @@ -515,6 +516,101 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, st=
ruct xdp_buff *xdp,
>  	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
>  }
>=20=20
> +static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *x=
dp,
> +			 int exclude_ifindex)
> +{
> +	if (!obj || obj->dev->ifindex =3D=3D exclude_ifindex ||
> +	    !obj->dev->netdev_ops->ndo_xdp_xmit)
> +		return false;
> +
> +	if (xdp_ok_fwd_dev(obj->dev, xdp->data_end - xdp->data))
> +		return false;
> +
> +	return true;
> +}
> +
> +static int dev_map_enqueue_clone(struct bpf_dtab_netdev *obj,
> +				 struct net_device *dev_rx,
> +				 struct xdp_frame *xdpf)
> +{
> +	struct xdp_frame *nxdpf;
> +
> +	nxdpf =3D xdpf_clone(xdpf);
> +	if (unlikely(!nxdpf)) {
> +		xdp_return_frame_rx_napi(xdpf);
> +		return -ENOMEM;
> +	}
> +
> +	bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
> +
> +	return 0;
> +}
> +
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_r=
x,
> +			  struct bpf_map *map, bool exclude_ingress)
> +{
> +	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
> +	int exclude_ifindex =3D exclude_ingress ? dev_rx->ifindex : 0;
> +	struct bpf_dtab_netdev *dst, *last_dst =3D NULL;
> +	struct hlist_head *head;
> +	struct hlist_node *next;
> +	struct xdp_frame *xdpf;
> +	unsigned int i;
> +	int err;
> +
> +	xdpf =3D xdp_convert_buff_to_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -ENOSPC;
> +
> +	if (map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP) {
> +		for (i =3D 0; i < map->max_entries; i++) {
> +			dst =3D READ_ONCE(dtab->netdev_map[i]);
> +			if (!is_valid_dst(dst, xdp, exclude_ifindex))
> +				continue;
> +
> +			/* we only need n-1 clones; last_dst enqueued below */
> +			if (!last_dst) {
> +				last_dst =3D dst;
> +				continue;
> +			}
> +
> +			err =3D dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
> +			if (err)
> +				return err;
> +
> +			last_dst =3D dst;
> +		}
> +	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
> +		for (i =3D 0; i < dtab->n_buckets; i++) {
> +			head =3D dev_map_index_hash(dtab, i);
> +			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
> +				if (!is_valid_dst(dst, xdp, exclude_ifindex))
> +					continue;
> +
> +				/* we only need n-1 clones; last_dst enqueued below */
> +				if (!last_dst) {
> +					last_dst =3D dst;
> +					continue;
> +				}
> +
> +				err =3D dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
> +				if (err)
> +					return err;
> +
> +				last_dst =3D dst;
> +			}
> +		}
> +	}
> +
> +	/* consume the last copy of the frame */
> +	if (last_dst)
> +		bq_enqueue(last_dst->dev, xdpf, dev_rx, last_dst->xdp_prog);
> +	else
> +		xdp_return_frame_rx_napi(xdpf); /* dtab is empty */
> +
> +	return 0;
> +}
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
>  			     struct bpf_prog *xdp_prog)
>  {
> @@ -529,6 +625,76 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev =
*dst, struct sk_buff *skb,
>  	return 0;
>  }
>=20=20
> +int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
> +			   struct bpf_prog *xdp_prog, struct bpf_map *map,
> +			   bool exclude_ingress)
> +{
> +	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
> +	int exclude_ifindex =3D exclude_ingress ? dev->ifindex : 0;
> +	struct bpf_dtab_netdev *dst, *last_dst =3D NULL;
> +	struct hlist_head *head;
> +	struct hlist_node *next;
> +	struct sk_buff *nskb;
> +	unsigned int i;
> +	int err;
> +
> +	if (map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP) {
> +		for (i =3D 0; i < map->max_entries; i++) {
> +			dst =3D READ_ONCE(dtab->netdev_map[i]);
> +			if (!dst || dst->dev->ifindex =3D=3D exclude_ifindex)
> +				continue;
> +
> +			/* we only need n-1 clones; last_dst enqueued below */
> +			if (!last_dst) {
> +				last_dst =3D dst;
> +				continue;
> +			}
> +
> +			nskb =3D skb_clone(skb, GFP_ATOMIC);
> +			if (!nskb)
> +				return -ENOMEM;
> +
> +			err =3D dev_map_generic_redirect(last_dst, nskb, xdp_prog);
> +			if (err)
> +				return err;

In dev_map_enqueue_multi() you're using a helper that makes sure to free
the original frame before returning an error, but here you're
open-coding it, which means that these two error returns will leak the
original skb.

Maybe introduce a similar dev_map_redirect_clone() helper that also
frees the skb on error? That would make the two functions more similar
as well (and hopefully make any future consolidation easier).

> +			last_dst =3D dst;
> +		}
> +	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
> +		for (i =3D 0; i < dtab->n_buckets; i++) {
> +			head =3D dev_map_index_hash(dtab, i);
> +			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
> +				if (!dst || dst->dev->ifindex =3D=3D exclude_ifindex)
> +					continue;
> +
> +				/* we only need n-1 clones; last_dst enqueued below */
> +				if (!last_dst) {
> +					last_dst =3D dst;
> +					continue;
> +				}
> +
> +				nskb =3D skb_clone(skb, GFP_ATOMIC);
> +				if (!nskb)
> +					return -ENOMEM;
> +
> +				err =3D dev_map_generic_redirect(last_dst, nskb, xdp_prog);
> +				if (err)
> +					return err;

Same here, of course...

-Toke

