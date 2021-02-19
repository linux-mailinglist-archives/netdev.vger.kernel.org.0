Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F0231FDB1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBSRMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:12:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhBSRMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613754646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SvXKceW4R9UV/dlGYlPCNRXpekPlXxrzZ6deL78WIL4=;
        b=VRCTZj/iR0uRQF96YWzipfIrBklB2IeuuaAKGmkSQhGHn2/mMTHzQiHaUsOm+ozEcfUFMb
        CMkdGcLN6Vx8+0kg8eIavBFqhX19Cc5q+de0NOkxVQ1YuPVYwqGJI++JicRO/sRgnIPQ2K
        dfLkoElZfs3Nvg3QwOz7aPRJpMn9Ypo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-at1i8y3sMgiFhYWze_-lGg-1; Fri, 19 Feb 2021 12:10:44 -0500
X-MC-Unique: at1i8y3sMgiFhYWze_-lGg-1
Received: by mail-ed1-f72.google.com with SMTP id w14so3014457edv.6
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 09:10:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SvXKceW4R9UV/dlGYlPCNRXpekPlXxrzZ6deL78WIL4=;
        b=mLkiq0ZSfSRjZKsaowTQd52LtryO7JeaMWYVns8Bdt3LsJ3gJ+MSan+xBtcrTkGV8U
         3pkTTVJseYignRRWZebKlwx2fo0ww8w0WAPJpw1GKOtvvuAqhKVqq/rbwzcxM28LU7/w
         SHj7WTPMZ408ZYXscA2ryCQKLnDUVD3ygC2yB05X7LAabtbUuQmoTC4/e1Gt1MK332jf
         J8qRUX8shy+q3PD/NPjFNuknDhp+Wlir6OAPJ+lh4ugSVqDSwIw8uKlh+fMuzQITdQPS
         +5CtbNcK5XCf4Iz75yfVH89ZUroNN7htqm+zTddP/rlxj63ye0yIm18/vH85QuIJCXYh
         51NA==
X-Gm-Message-State: AOAM530rnmRjAnl0qW2LgooZk9dUb6KgU3z/LqRy0++LtAgPb/YUGmSe
        84hZj/6xalB4rSyK9Z2AhcLEIb0fSpAr19QDjkWmCq1FoVLu11OteG86me6csammB5Nw0+Rqy8R
        lu8STTqz1X2iqprbs
X-Received: by 2002:a05:6402:22ce:: with SMTP id dm14mr10241182edb.256.1613754642780;
        Fri, 19 Feb 2021 09:10:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqfHA/Qui6iVgCx4aZZ1LnhCVzj/QjCaQmrOd7dM6Ds2bjS13xLohc8Dl2o4tHi0cvrOFV+w==
X-Received: by 2002:a05:6402:22ce:: with SMTP id dm14mr10241140edb.256.1613754642359;
        Fri, 19 Feb 2021 09:10:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b4sm6235511edh.40.2021.02.19.09.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F2E9E180676; Fri, 19 Feb 2021 18:10:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next 2/2] bpf, xdp: restructure redirect actions
In-Reply-To: <20210219145922.63655-3-bjorn.topel@gmail.com>
References: <20210219145922.63655-1-bjorn.topel@gmail.com>
 <20210219145922.63655-3-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 19 Feb 2021 18:10:40 +0100
Message-ID: <87r1lchtkf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The XDP_REDIRECT implementations for maps and non-maps are fairly
> similar, but obviously need to take different code paths depending on
> if the target is using a map or not. Today, the redirect targets for
> XDP either uses a map, or is based on ifindex.
>
> Here, an explicit redirect type is added to bpf_redirect_info, instead
> of the actual map. Redirect type, map item/ifindex, and the map_id (if
> any) is passed to xdp_do_redirect().
>
> In addition to making the code easier to follow, using an explicit
> type in bpf_redirect_info has a slight positive performance impact by
> avoiding a pointer indirection for the map type lookup, and instead
> use the cacheline for bpf_redirect_info.
>
> Since the actual map is not passed via bpf_redirect_info anymore, the
> map lookup is only done in the BPF helper. This means that the
> bpf_clear_redirect_map() function can be removed. The actual map item
> is RCU protected.
>
> The bpf_redirect_info flags member is not used by XDP, and not
> read/written any more. The map member is only written to when
> required/used, and not unconditionally.
>
> rfc->v1: Use map_id, and remove bpf_clear_redirect_map(). (Toke)
>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Very cool! Also a small nit below, but otherwise:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

> ---
>  include/linux/filter.h     |  11 ++-
>  include/trace/events/xdp.h |  66 +++++++++------
>  kernel/bpf/cpumap.c        |   1 -
>  kernel/bpf/devmap.c        |   1 -
>  net/core/filter.c          | 162 ++++++++++++++++---------------------
>  net/xdp/xskmap.c           |   1 -
>  6 files changed, 121 insertions(+), 121 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 1dedcf66b694..1f3cf2a1e116 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -646,11 +646,20 @@ struct bpf_redirect_info {
>  	u32 flags;
>  	u32 tgt_index;
>  	void *tgt_value;
> -	struct bpf_map *map;
> +	u32 map_id;
> +	u32 tgt_type;
>  	u32 kern_flags;
>  	struct bpf_nh_params nh;
>  };
>=20=20
> +enum xdp_redirect_type {
> +	XDP_REDIR_UNSET,
> +	XDP_REDIR_DEV_IFINDEX,
> +	XDP_REDIR_DEV_MAP,
> +	XDP_REDIR_CPU_MAP,
> +	XDP_REDIR_XSK_MAP,
> +};
> +
>  DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
>=20=20
>  /* flags for bpf_redirect_info kern_flags */
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index 76a97176ab81..538321735447 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -86,19 +86,15 @@ struct _bpf_dtab_netdev {
>  };
>  #endif /* __DEVMAP_OBJ_TYPE */
>=20=20
> -#define devmap_ifindex(tgt, map)				\
> -	(((map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||	\
> -		  map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH)) ? \
> -	  ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex : 0)
> -
>  DECLARE_EVENT_CLASS(xdp_redirect_template,
>=20=20
>  	TP_PROTO(const struct net_device *dev,
>  		 const struct bpf_prog *xdp,
>  		 const void *tgt, int err,
> -		 const struct bpf_map *map, u32 index),
> +		 enum xdp_redirect_type type,
> +		 const struct bpf_redirect_info *ri),
>=20=20
> -	TP_ARGS(dev, xdp, tgt, err, map, index),
> +	TP_ARGS(dev, xdp, tgt, err, type, ri),
>=20=20
>  	TP_STRUCT__entry(
>  		__field(int, prog_id)
> @@ -111,14 +107,30 @@ DECLARE_EVENT_CLASS(xdp_redirect_template,
>  	),
>=20=20
>  	TP_fast_assign(
> +		u32 ifindex =3D 0, map_id =3D 0, index =3D ri->tgt_index;
> +
> +		switch (type) {
> +		case XDP_REDIR_DEV_MAP:
> +			ifindex =3D ((struct _bpf_dtab_netdev *)tgt)->dev->ifindex;
> +			fallthrough;
> +		case XDP_REDIR_CPU_MAP:
> +		case XDP_REDIR_XSK_MAP:
> +			map_id =3D ri->map_id;
> +			break;
> +		case XDP_REDIR_DEV_IFINDEX:
> +			ifindex =3D (u32)(long)tgt;
> +			break;
> +		default:
> +			break;
> +		}
> +
>  		__entry->prog_id	=3D xdp->aux->id;
>  		__entry->act		=3D XDP_REDIRECT;
>  		__entry->ifindex	=3D dev->ifindex;
>  		__entry->err		=3D err;
> -		__entry->to_ifindex	=3D map ? devmap_ifindex(tgt, map) :
> -						index;
> -		__entry->map_id		=3D map ? map->id : 0;
> -		__entry->map_index	=3D map ? index : 0;
> +		__entry->to_ifindex	=3D ifindex;
> +		__entry->map_id		=3D map_id;
> +		__entry->map_index	=3D index;
>  	),
>=20=20
>  	TP_printk("prog_id=3D%d action=3D%s ifindex=3D%d to_ifindex=3D%d err=3D=
%d"
> @@ -133,45 +145,49 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect,
>  	TP_PROTO(const struct net_device *dev,
>  		 const struct bpf_prog *xdp,
>  		 const void *tgt, int err,
> -		 const struct bpf_map *map, u32 index),
> -	TP_ARGS(dev, xdp, tgt, err, map, index)
> +		 enum xdp_redirect_type type,
> +		 const struct bpf_redirect_info *ri),
> +	TP_ARGS(dev, xdp, tgt, err, type, ri)
>  );
>=20=20
>  DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
>  	TP_PROTO(const struct net_device *dev,
>  		 const struct bpf_prog *xdp,
>  		 const void *tgt, int err,
> -		 const struct bpf_map *map, u32 index),
> -	TP_ARGS(dev, xdp, tgt, err, map, index)
> +		 enum xdp_redirect_type type,
> +		 const struct bpf_redirect_info *ri),
> +	TP_ARGS(dev, xdp, tgt, err, type, ri)
>  );
>=20=20
>  #define _trace_xdp_redirect(dev, xdp, to)				\
> -	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to)
> +	trace_xdp_redirect(dev, xdp, NULL, 0, XDP_REDIR_DEV_IFINDEX, NULL)
>=20=20
>  #define _trace_xdp_redirect_err(dev, xdp, to, err)			\
> -	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to)
> +	trace_xdp_redirect_err(dev, xdp, NULL, err, XDP_REDIR_DEV_IFINDEX, NULL)
>=20=20
> -#define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
> -	 trace_xdp_redirect(dev, xdp, to, 0, map, index)
> +#define _trace_xdp_redirect_map(dev, xdp, to, type, ri)		\
> +	trace_xdp_redirect(dev, xdp, to, 0, type, ri)
>=20=20
> -#define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
> -	 trace_xdp_redirect_err(dev, xdp, to, err, map, index)
> +#define _trace_xdp_redirect_map_err(dev, xdp, to, type, ri, err)	\
> +	trace_xdp_redirect_err(dev, xdp, to, err, type, ri)
>=20=20
>  /* not used anymore, but kept around so as not to break old programs */
>  DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map,
>  	TP_PROTO(const struct net_device *dev,
>  		 const struct bpf_prog *xdp,
>  		 const void *tgt, int err,
> -		 const struct bpf_map *map, u32 index),
> -	TP_ARGS(dev, xdp, tgt, err, map, index)
> +		 enum xdp_redirect_type type,
> +		 const struct bpf_redirect_info *ri),
> +	TP_ARGS(dev, xdp, tgt, err, type, ri)
>  );
>=20=20
>  DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
>  	TP_PROTO(const struct net_device *dev,
>  		 const struct bpf_prog *xdp,
>  		 const void *tgt, int err,
> -		 const struct bpf_map *map, u32 index),
> -	TP_ARGS(dev, xdp, tgt, err, map, index)
> +		 enum xdp_redirect_type type,
> +		 const struct bpf_redirect_info *ri),
> +	TP_ARGS(dev, xdp, tgt, err, type, ri)
>  );
>=20=20
>  TRACE_EVENT(xdp_cpumap_kthread,
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index a4d2cb93cd69..b7f4d22f5c8d 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -543,7 +543,6 @@ static void cpu_map_free(struct bpf_map *map)
>  	 * complete.
>  	 */
>=20=20
> -	bpf_clear_redirect_map(map);
>  	synchronize_rcu();
>=20=20
>  	/* For cpu_map the remote CPUs can still be using the entries
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 37ac4cde9713..b5681a98020d 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -197,7 +197,6 @@ static void dev_map_free(struct bpf_map *map)
>  	list_del_rcu(&dtab->list);
>  	spin_unlock(&dev_map_lock);
>=20=20
> -	bpf_clear_redirect_map(map);
>  	synchronize_rcu();
>=20=20
>  	/* Make sure prior __dev_map_entry_free() have completed. */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index fd64d768e16a..56074b88d7e2 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3919,23 +3919,6 @@ static const struct bpf_func_proto bpf_xdp_adjust_=
meta_proto =3D {
>  	.arg2_type	=3D ARG_ANYTHING,
>  };
>=20=20
> -static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
> -			    struct bpf_map *map, struct xdp_buff *xdp)
> -{
> -	switch (map->map_type) {
> -	case BPF_MAP_TYPE_DEVMAP:
> -	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		return dev_map_enqueue(fwd, xdp, dev_rx);
> -	case BPF_MAP_TYPE_CPUMAP:
> -		return cpu_map_enqueue(fwd, xdp, dev_rx);
> -	case BPF_MAP_TYPE_XSKMAP:
> -		return __xsk_map_redirect(fwd, xdp);
> -	default:
> -		return -EBADRQC;
> -	}
> -	return 0;
> -}
> -
>  void xdp_do_flush(void)
>  {
>  	__dev_flush();
> @@ -3944,55 +3927,45 @@ void xdp_do_flush(void)
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_flush);
>=20=20
> -void bpf_clear_redirect_map(struct bpf_map *map)
> -{
> -	struct bpf_redirect_info *ri;
> -	int cpu;
> -
> -	for_each_possible_cpu(cpu) {
> -		ri =3D per_cpu_ptr(&bpf_redirect_info, cpu);
> -		/* Avoid polluting remote cacheline due to writes if
> -		 * not needed. Once we pass this test, we need the
> -		 * cmpxchg() to make sure it hasn't been changed in
> -		 * the meantime by remote CPU.
> -		 */
> -		if (unlikely(READ_ONCE(ri->map) =3D=3D map))
> -			cmpxchg(&ri->map, map, NULL);
> -	}
> -}
> -
>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct bpf_prog *xdp_prog)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> -	struct bpf_map *map =3D READ_ONCE(ri->map);
> -	u32 index =3D ri->tgt_index;
> +	enum xdp_redirect_type type =3D ri->tgt_type;
>  	void *fwd =3D ri->tgt_value;
>  	int err;
>=20=20
> -	ri->tgt_index =3D 0;
> -	ri->tgt_value =3D NULL;
> -	WRITE_ONCE(ri->map, NULL);
> +	ri->tgt_type =3D XDP_REDIR_UNSET;
>=20=20
> -	if (unlikely(!map)) {
> -		fwd =3D dev_get_by_index_rcu(dev_net(dev), index);
> +	switch (type) {
> +	case XDP_REDIR_DEV_IFINDEX:
> +		fwd =3D dev_get_by_index_rcu(dev_net(dev), (u32)(long)fwd);
>  		if (unlikely(!fwd)) {
>  			err =3D -EINVAL;
> -			goto err;
> +			break;
>  		}
> -
>  		err =3D dev_xdp_enqueue(fwd, xdp, dev);
> -	} else {
> -		err =3D __bpf_tx_xdp_map(dev, fwd, map, xdp);
> +		break;
> +	case XDP_REDIR_DEV_MAP:
> +		err =3D dev_map_enqueue(fwd, xdp, dev);
> +		break;
> +	case XDP_REDIR_CPU_MAP:
> +		err =3D cpu_map_enqueue(fwd, xdp, dev);
> +		break;
> +	case XDP_REDIR_XSK_MAP:
> +		err =3D __xsk_map_redirect(fwd, xdp);
> +		break;
> +	default:
> +		err =3D -EBADRQC;
>  	}
>=20=20
>  	if (unlikely(err))
>  		goto err;
>=20=20
> -	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
> +	_trace_xdp_redirect_map(dev, xdp_prog, fwd, type, ri);
>  	return 0;
>  err:
> -	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
> +	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, type, ri, err);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_redirect);
> @@ -4001,41 +3974,40 @@ static int xdp_do_generic_redirect_map(struct net=
_device *dev,
>  				       struct sk_buff *skb,
>  				       struct xdp_buff *xdp,
>  				       struct bpf_prog *xdp_prog,
> -				       struct bpf_map *map)
> +				       void *fwd,
> +				       enum xdp_redirect_type type)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> -	u32 index =3D ri->tgt_index;
> -	void *fwd =3D ri->tgt_value;
> -	int err =3D 0;
> -
> -	ri->tgt_index =3D 0;
> -	ri->tgt_value =3D NULL;
> -	WRITE_ONCE(ri->map, NULL);
> +	int err;
>=20=20
> -	if (map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||
> -	    map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
> +	switch (type) {
> +	case XDP_REDIR_DEV_MAP: {
>  		struct bpf_dtab_netdev *dst =3D fwd;

I thought the braces around the case body looked a bit odd. I guess
that's to get a local scope for the dst var (and xs var below), right?
This is basically a cast, though, so I wonder if you couldn't just as
well use the fwd pointer directly (with a cast) in the function call
below? WDYT?

(Strictly speaking I don't think the compiler will even complain if you
omit the cast as well, but having it in there is nice fore readability I
think, and guards against someone forgetting to update the call if the
function prototype changes).

>  		err =3D dev_map_generic_redirect(dst, skb, xdp_prog);
>  		if (unlikely(err))
>  			goto err;
> -	} else if (map->map_type =3D=3D BPF_MAP_TYPE_XSKMAP) {
> +		break;
> +	}
> +	case XDP_REDIR_XSK_MAP: {
>  		struct xdp_sock *xs =3D fwd;
>=20=20
>  		err =3D xsk_generic_rcv(xs, xdp);
>  		if (err)
>  			goto err;
>  		consume_skb(skb);
> -	} else {
> +		break;
> +	}
> +	default:
>  		/* TODO: Handle BPF_MAP_TYPE_CPUMAP */
>  		err =3D -EBADRQC;
>  		goto err;
>  	}
>=20=20
> -	_trace_xdp_redirect_map(dev, xdp_prog, fwd, map, index);
> +	_trace_xdp_redirect_map(dev, xdp_prog, fwd, type, ri);
>  	return 0;
>  err:
> -	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
> +	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, type, ri, err);
>  	return err;
>  }
>=20=20
> @@ -4043,29 +4015,31 @@ int xdp_do_generic_redirect(struct net_device *de=
v, struct sk_buff *skb,
>  			    struct xdp_buff *xdp, struct bpf_prog *xdp_prog)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> -	struct bpf_map *map =3D READ_ONCE(ri->map);
> -	u32 index =3D ri->tgt_index;
> -	struct net_device *fwd;
> +	enum xdp_redirect_type type =3D ri->tgt_type;
> +	void *fwd =3D ri->tgt_value;
>  	int err =3D 0;
>=20=20
> -	if (map)
> -		return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog,
> -						   map);
> -	ri->tgt_index =3D 0;
> -	fwd =3D dev_get_by_index_rcu(dev_net(dev), index);
> -	if (unlikely(!fwd)) {
> -		err =3D -EINVAL;
> -		goto err;
> -	}
> +	ri->tgt_type =3D XDP_REDIR_UNSET;
> +	ri->tgt_value =3D NULL;
>=20=20
> -	err =3D xdp_ok_fwd_dev(fwd, skb->len);
> -	if (unlikely(err))
> -		goto err;
> +	if (type =3D=3D XDP_REDIR_DEV_IFINDEX) {
> +		fwd =3D dev_get_by_index_rcu(dev_net(dev), (u32)(long)fwd);
> +		if (unlikely(!fwd)) {
> +			err =3D -EINVAL;
> +			goto err;
> +		}
>=20=20
> -	skb->dev =3D fwd;
> -	_trace_xdp_redirect(dev, xdp_prog, index);
> -	generic_xdp_tx(skb, xdp_prog);
> -	return 0;
> +		err =3D xdp_ok_fwd_dev(fwd, skb->len);
> +		if (unlikely(err))
> +			goto err;
> +
> +		skb->dev =3D fwd;
> +		_trace_xdp_redirect(dev, xdp_prog, index);
> +		generic_xdp_tx(skb, xdp_prog);
> +		return 0;
> +	}
> +
> +	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, type);
>  err:
>  	_trace_xdp_redirect_err(dev, xdp_prog, index, err);
>  	return err;
> @@ -4078,10 +4052,9 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, fl=
ags)
>  	if (unlikely(flags))
>  		return XDP_ABORTED;
>=20=20
> -	ri->flags =3D flags;
> -	ri->tgt_index =3D ifindex;
> -	ri->tgt_value =3D NULL;
> -	WRITE_ONCE(ri->map, NULL);
> +	ri->tgt_type =3D XDP_REDIR_DEV_IFINDEX;
> +	ri->tgt_index =3D 0;
> +	ri->tgt_value =3D (void *)(long)ifindex;
>=20=20
>  	return XDP_REDIRECT;
>  }
> @@ -4096,7 +4069,8 @@ static const struct bpf_func_proto bpf_xdp_redirect=
_proto =3D {
>=20=20
>  static __always_inline s64 __bpf_xdp_redirect_map(struct bpf_map *map, u=
32 ifindex, u64 flags,
>  						  void *lookup_elem(struct bpf_map *map,
> -								    u32 key))
> +								    u32 key),
> +						  enum xdp_redirect_type type)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>=20=20
> @@ -4105,35 +4079,39 @@ static __always_inline s64 __bpf_xdp_redirect_map=
(struct bpf_map *map, u32 ifind
>=20=20
>  	ri->tgt_value =3D lookup_elem(map, ifindex);
>  	if (unlikely(!ri->tgt_value)) {
> -		WRITE_ONCE(ri->map, NULL);
> +		ri->tgt_type =3D XDP_REDIR_UNSET;
>  		return flags;
>  	}
>=20=20
> -	ri->flags =3D flags;
>  	ri->tgt_index =3D ifindex;
> -	WRITE_ONCE(ri->map, map);
> +	ri->tgt_type =3D type;
> +	ri->map_id =3D map->id;
>=20=20
>  	return XDP_REDIRECT;
>  }
>=20=20
>  BPF_CALL_3(bpf_xdp_redirect_devmap, struct bpf_map *, map, u32, ifindex,=
 u64, flags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_ele=
m);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_ele=
m,
> +				      XDP_REDIR_DEV_MAP);
>  }
>=20=20
>  BPF_CALL_3(bpf_xdp_redirect_devmap_hash, struct bpf_map *, map, u32, ifi=
ndex, u64, flags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_looku=
p_elem);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_looku=
p_elem,
> +				      XDP_REDIR_DEV_MAP);
>  }
>=20=20
>  BPF_CALL_3(bpf_xdp_redirect_cpumap, struct bpf_map *, map, u32, ifindex,=
 u64, flags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_ele=
m);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_ele=
m,
> +				      XDP_REDIR_CPU_MAP);
>  }
>=20=20
>  BPF_CALL_3(bpf_xdp_redirect_xskmap, struct bpf_map *, map, u32, ifindex,=
 u64, flags)
>  {
> -	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_ele=
m);
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_ele=
m,
> +				      XDP_REDIR_XSK_MAP);
>  }
>=20=20
>  bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type)
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 113fd9017203..c285d3dd04ad 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -87,7 +87,6 @@ static void xsk_map_free(struct bpf_map *map)
>  {
>  	struct xsk_map *m =3D container_of(map, struct xsk_map, map);
>=20=20
> -	bpf_clear_redirect_map(map);
>  	synchronize_net();
>  	bpf_map_area_free(m);
>  }
> --=20
> 2.27.0

