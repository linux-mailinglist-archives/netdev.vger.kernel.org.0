Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAC03551C7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 13:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbhDFLSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 07:18:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233034AbhDFLSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 07:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617707882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=57wxye06S84zpzareNm6C2u5PlOjQNiWAJNmCFRqiS0=;
        b=EfCtHj87/daRju5Zbvwd645oClToaxRCzE7S3oqsr94MOad1LQojr7HAtJ4m+OGIG7UaCE
        wh6g4IB/Ezxj0DpcaaJ3wUvRepgWTY1WW9wR1c4t0zztLG1Y6AWHzOw4VhY6XUo1dkFoaA
        lRBgEByVneVV8OjYw+tRxoIVtoWzK6Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-AjlXNoIDP_OPN52lL-DsXA-1; Tue, 06 Apr 2021 07:18:00 -0400
X-MC-Unique: AjlXNoIDP_OPN52lL-DsXA-1
Received: by mail-ed1-f72.google.com with SMTP id o25so4848066edv.20
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 04:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=57wxye06S84zpzareNm6C2u5PlOjQNiWAJNmCFRqiS0=;
        b=d0v3qaovo4oeTi/DrW5aS40bi3mVAZxxTxl0mwcau3azYBfGljLQrZaIEg/JEsx83o
         fXiwVp5drgocgjwn7aX2cwrpxqwXVejej6NKYdg7Wbk1QjsCtSfmI2mLuw/Gr6yIFTD8
         rFOE9fEQ8aV0rdd5Raw7s0VpSx9OXi7O979/5j9D3jwUUuR6HPdBFxN+zEdQijNaJWMT
         MSoz6aHZr0ls1bm1nbYItQ3LxU0d3Pj8luzbKN9KTqexUqLJTrjpmwreZv0KJKXMzqY5
         6VGOta2ZCeHbxBMd/1GOz6hHro2q5/2MXyce3DrFHWi67xz2RLqwfn3ijrKrbHarFhde
         YvcA==
X-Gm-Message-State: AOAM531fwG+IuwTO9QodLHSyEdlKdEipOrw3rmW0kGPCHTzZIcFey6/w
        /W+bvT+sXsvm65tfNxZJ0qfvZZUJvsJTGGQUpTrLIIgLxc65A+B/w1esBAhukHaN+QI9KpM9uz8
        61IXEx5Km29CU5tR/
X-Received: by 2002:a17:907:75d9:: with SMTP id jl25mr32823149ejc.452.1617707879276;
        Tue, 06 Apr 2021 04:17:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWsj8v2YD5bOVHxp/6+/bu1bTjT+EhIGpNRqwtsfx0DqeJzUazrTMmBe5S+wzgf21xKH2RfQ==
X-Received: by 2002:a17:907:75d9:: with SMTP id jl25mr32823116ejc.452.1617707878703;
        Tue, 06 Apr 2021 04:17:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id nb29sm620084ejc.118.2021.04.06.04.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 04:17:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5C67F180300; Tue,  6 Apr 2021 13:17:56 +0200 (CEST)
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
Subject: Re: [PATCHv4 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210402121954.3568992-3-liuhangbin@gmail.com>
References: <20210402121954.3568992-1-liuhangbin@gmail.com>
 <20210402121954.3568992-3-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Apr 2021 13:17:56 +0200
Message-ID: <875z0z4q6z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> This patch add two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to ext=
end
> xdp_redirect_map for broadcast support.
>
> Keep the general data path in net/core/filter.c and the native data
> path in kernel/bpf/devmap.c so we can use direct calls to get better
> performace.
>
> Here is the performance result by using xdp_redirect_{map, map_multi} in
> sample/bpf and send pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t =
10 -s 64
>
> There are some drop back as we need to loop the map and get each interfac=
e.
>
> Version          | Test                                | Generic | Native
> 5.12 rc2         | redirect_map        i40e->i40e      |    2.0M |  9.8M
> 5.12 rc2         | redirect_map        i40e->veth      |    1.8M | 12.0M
> 5.12 rc2 + patch | redirect_map        i40e->i40e      |    2.0M |  9.6M
> 5.12 rc2 + patch | redirect_map        i40e->veth      |    1.7M | 12.0M
> 5.12 rc2 + patch | redirect_map multi  i40e->i40e      |    1.6M |  7.8M
> 5.12 rc2 + patch | redirect_map multi  i40e->veth      |    1.4M |  9.3M
> 5.12 rc2 + patch | redirect_map multi  i40e->mlx4+veth |    1.0M |  3.4M
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>
> ---
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
>  include/linux/bpf.h            |  22 ++++++
>  include/linux/filter.h         |  18 ++++-
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  17 ++++-
>  kernel/bpf/cpumap.c            |   3 +-
>  kernel/bpf/devmap.c            | 133 ++++++++++++++++++++++++++++++++-
>  net/core/filter.c              |  97 +++++++++++++++++++++++-
>  net/core/xdp.c                 |  29 +++++++
>  net/xdp/xskmap.c               |   3 +-
>  tools/include/uapi/linux/bpf.h |  17 ++++-
>  10 files changed, 326 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9fdd839b418c..d5745c6000bc 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1492,11 +1492,15 @@ struct sk_buff;
>  struct bpf_dtab_netdev;
>  struct bpf_cpu_map_entry;
>=20=20
> +struct bpf_dtab_netdev *devmap_lookup_elem(struct bpf_map *map, u32 key);
>  void __dev_flush(void);
>  int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> +bool dst_dev_is_ingress(struct bpf_dtab_netdev *obj, int ifindex);
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_r=
x,
> +			  struct bpf_map *map, bool exclude_ingress);
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
>  			     struct bpf_prog *xdp_prog);
>  bool dev_map_can_have_prog(struct bpf_map *map);
> @@ -1639,6 +1643,11 @@ static inline int bpf_obj_get_user(const char __us=
er *pathname, int flags)
>  	return -EOPNOTSUPP;
>  }
>=20=20
> +static inline struct net_device *devmap_lookup_elem(struct bpf_map *map,=
 u32 key)
> +{
> +	return NULL;
> +}
> +
>  static inline bool dev_map_can_have_prog(struct bpf_map *map)
>  {
>  	return false;
> @@ -1666,6 +1675,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, s=
truct xdp_buff *xdp,
>  	return 0;
>  }
>=20=20
> +static inline
> +bool dst_dev_is_ingress(struct bpf_dtab_netdev *obj, int ifindex)
> +{
> +	return false;
> +}
> +
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

Are we sure that the compiler is smart enough to combine the OR flags
here at compile-time? I guess it should be since it's an always_inline,
but it would be good to check that we don't end up with multiple bit
operations at runtime...

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
> index 49371eba98ba..fe2c35bcc880 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2513,8 +2513,12 @@ union bpf_attr {
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
> @@ -5015,6 +5019,15 @@ enum {
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
> index 3980fb3bfb09..c8452c5f40f8 100644
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
> @@ -451,6 +452,24 @@ static void *__dev_map_lookup_elem(struct bpf_map *m=
ap, u32 key)
>  	return obj;
>  }
>=20=20
> +struct bpf_dtab_netdev *devmap_lookup_elem(struct bpf_map *map, u32 key)
> +{
> +	struct bpf_dtab_netdev *obj =3D NULL;
> +
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		obj =3D __dev_map_lookup_elem(map, key);
> +		break;
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		obj =3D __dev_map_hash_lookup_elem(map, key);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return obj;
> +}
> +
>  /* Runs under RCU-read-side, plus in softirq under NAPI protection.
>   * Thus, safe percpu variable access.
>   */
> @@ -515,6 +534,114 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, st=
ruct xdp_buff *xdp,
>  	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
>  }
>=20=20
> +/* Use direct call in fast path instead of map->ops->map_get_next_key() =
*/
> +static int devmap_get_next_key(struct bpf_map *map, void *key, void *nex=
t_key)
> +{
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		return dev_map_get_next_key(map, key, next_key);
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		return dev_map_hash_get_next_key(map, key, next_key);
> +	default:
> +		break;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +bool dst_dev_is_ingress(struct bpf_dtab_netdev *dst, int ifindex)
> +{
> +	return dst->dev->ifindex =3D=3D ifindex;
> +}
> +
> +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buff *xdp,
> +						   struct bpf_map *map,
> +						   u32 *key, u32 *next_key,
> +						   int ex_ifindex)
> +{
> +	struct bpf_dtab_netdev *obj;
> +	struct net_device *dev;
> +	u32 index;
> +	int err;
> +
> +	err =3D devmap_get_next_key(map, key, next_key);
> +	if (err)
> +		return NULL;
> +
> +	/* When using dev map hash, we could restart the hashtab traversal
> +	 * in case the key has been updated/removed in the mean time.
> +	 * So we may end up potentially looping due to traversal restarts
> +	 * from first elem.
> +	 *
> +	 * Let's use map's max_entries to limit the loop number.
> +	 */
> +	for (index =3D 0; index < map->max_entries; index++) {
> +		obj =3D devmap_lookup_elem(map, *next_key);
> +		if (!obj || dst_dev_is_ingress(obj, ex_ifindex))
> +			goto find_next;
> +
> +		dev =3D obj->dev;
> +
> +		if (!dev->netdev_ops->ndo_xdp_xmit)
> +			goto find_next;
> +
> +		err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> +		if (unlikely(err))
> +			goto find_next;
> +
> +		return obj;
> +
> +find_next:
> +		key =3D next_key;
> +		err =3D devmap_get_next_key(map, key, next_key);
> +		if (err)
> +			break;
> +	}
> +
> +	return NULL;
> +}
> +
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_r=
x,
> +			  struct bpf_map *map, bool exclude_ingress)
> +{
> +	struct bpf_dtab_netdev *obj =3D NULL, *next_obj =3D NULL;
> +	struct xdp_frame *xdpf, *nxdpf;
> +	u32 key, next_key;
> +	int ex_ifindex;
> +
> +	ex_ifindex =3D exclude_ingress ? dev_rx->ifindex : 0;
> +
> +	/* Find first available obj */
> +	obj =3D devmap_get_next_obj(xdp, map, NULL, &key, ex_ifindex);
> +	if (!obj)
> +		return -ENOENT;
> +
> +	xdpf =3D xdp_convert_buff_to_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	for (;;) {
> +		/* Check if we still have one more available obj */
> +		next_obj =3D devmap_get_next_obj(xdp, map, &key, &next_key, ex_ifindex=
);
> +		if (!next_obj) {
> +			bq_enqueue(obj->dev, xdpf, dev_rx, obj->xdp_prog);
> +			return 0;
> +		}
> +
> +		nxdpf =3D xdpf_clone(xdpf);
> +		if (unlikely(!nxdpf)) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			return -ENOMEM;
> +		}
> +
> +		bq_enqueue(obj->dev, nxdpf, dev_rx, obj->xdp_prog);
> +
> +		/* Deal with next obj */
> +		obj =3D next_obj;
> +		key =3D next_key;
> +	}
> +}
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
>  			     struct bpf_prog *xdp_prog)
>  {
> @@ -755,12 +882,14 @@ static int dev_map_hash_update_elem(struct bpf_map =
*map, void *key, void *value,
>=20=20
>  static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_ele=
m);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, BPF_F_REDIR_MASK,
> +				      __dev_map_lookup_elem);
>  }
>=20=20
>  static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 f=
lags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_looku=
p_elem);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, BPF_F_REDIR_MASK,
> +				      __dev_map_hash_lookup_elem);
>  }
>=20=20
>  static int dev_map_btf_id;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cae56d08a670..08a4d3869056 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3926,6 +3926,23 @@ void xdp_do_flush(void)
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_flush);
>=20=20
> +void bpf_clear_redirect_map(struct bpf_map *map)
> +{
> +	struct bpf_redirect_info *ri;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		ri =3D per_cpu_ptr(&bpf_redirect_info, cpu);
> +		/* Avoid polluting remote cacheline due to writes if
> +		 * not needed. Once we pass this test, we need the
> +		 * cmpxchg() to make sure it hasn't been changed in
> +		 * the meantime by remote CPU.
> +		 */
> +		if (unlikely(READ_ONCE(ri->map) =3D=3D map))
> +			cmpxchg(&ri->map, map, NULL);
> +	}
> +}
> +
>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct bpf_prog *xdp_prog)
>  {
> @@ -3933,16 +3950,28 @@ int xdp_do_redirect(struct net_device *dev, struc=
t xdp_buff *xdp,
>  	enum bpf_map_type map_type =3D ri->map_type;
>  	void *fwd =3D ri->tgt_value;
>  	u32 map_id =3D ri->map_id;
> +	bool exclude_ingress;
> +	struct bpf_map *map;
>  	int err;
>=20=20
>  	ri->map_id =3D 0; /* Valid map id idr range: [1,INT_MAX[ */
>  	ri->map_type =3D BPF_MAP_TYPE_UNSPEC;
>=20=20
> +	map =3D READ_ONCE(ri->map);
> +	if (map) {
> +		WRITE_ONCE(ri->map, NULL);
> +		exclude_ingress =3D ri->flags & BPF_F_EXCLUDE_INGRESS;
> +		ri->flags =3D 0;
> +	}

I would just drop this block entirely...

> +
>  	switch (map_type) {
>  	case BPF_MAP_TYPE_DEVMAP:
>  		fallthrough;
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		err =3D dev_map_enqueue(fwd, xdp, dev);

...and instead just add a line here like:

map =3D xchg(&ri->map, NULL);

This will make it much clearer that the read of map belongs with the
devmap types. And you don't actually need to clear the flags (since now
they will always be set in the helper), so you can just use ri->flags &
BPF_F_EXCLUDE_INGRESS directly in the function call below like you did
before.

> +		if (map)
> +			err =3D dev_map_enqueue_multi(xdp, dev, map, exclude_ingress);
> +		else
> +			err =3D dev_map_enqueue(fwd, xdp, dev);
>  		break;
>  	case BPF_MAP_TYPE_CPUMAP:
>  		err =3D cpu_map_enqueue(fwd, xdp, dev);
> @@ -3976,6 +4005,57 @@ int xdp_do_redirect(struct net_device *dev, struct=
 xdp_buff *xdp,
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_redirect);
>=20=20
> +static int dev_map_redirect_multi(struct net_device *dev, struct sk_buff=
 *skb,
> +				  struct bpf_prog *xdp_prog, struct bpf_map *map,
> +				  bool exclude_ingress)
> +{
> +	struct bpf_dtab_netdev *dst;
> +	u32 key, next_key, index;
> +	struct sk_buff *nskb;
> +	void *fwd;
> +	int err;
> +
> +	err =3D map->ops->map_get_next_key(map, NULL, &key);
> +	if (err)
> +		return err;
> +
> +	/* When using dev map hash, we could restart the hashtab traversal
> +	 * in case the key has been updated/removed in the mean time.
> +	 * So we may end up potentially looping due to traversal restarts
> +	 * from first elem.
> +	 *
> +	 * Let's use map's max_entries to limit the loop number.
> +	 */
> +
> +	for (index =3D 0; index < map->max_entries; index++) {
> +		fwd =3D devmap_lookup_elem(map, key);
> +		if (fwd) {
> +			dst =3D (struct bpf_dtab_netdev *)fwd;
> +			if (dst_dev_is_ingress(dst, exclude_ingress ? dev->ifindex : 0))
> +				goto find_next;
> +
> +			nskb =3D skb_clone(skb, GFP_ATOMIC);
> +			if (!nskb)
> +				return -ENOMEM;
> +
> +			/* Try forword next one no mater the current forward
> +			 * succeed or not.
> +			 */
> +			dev_map_generic_redirect(dst, nskb, xdp_prog);
> +		}
> +
> +find_next:
> +		err =3D map->ops->map_get_next_key(map, &key, &next_key);
> +		if (err)
> +			break;
> +
> +		key =3D next_key;
> +	}
> +
> +	consume_skb(skb);
> +	return 0;
> +}
> +
>  static int xdp_do_generic_redirect_map(struct net_device *dev,
>  				       struct sk_buff *skb,
>  				       struct xdp_buff *xdp,
> @@ -3984,13 +4064,26 @@ static int xdp_do_generic_redirect_map(struct net=
_device *dev,
>  				       enum bpf_map_type map_type, u32 map_id)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> +	bool exclude_ingress;
> +	struct bpf_map *map;
>  	int err;
>=20=20
> +	map =3D READ_ONCE(ri->map);
> +	if (map) {
> +		WRITE_ONCE(ri->map, NULL);
> +		exclude_ingress =3D ri->flags & BPF_F_EXCLUDE_INGRESS;
> +		ri->flags =3D 0;
> +	}

(same as above)


-Toke

