Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768231B782F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgDXOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:19:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726667AbgDXOTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:19:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587737961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zZTOKD6Ncqd3+51m0Ix41rGnRkm6vJ5R+T6RG0yQOLY=;
        b=g8s+5vFLkOLuKOonfJlUFRGUfFxsy1cBh+ww2h/IUs1e5frPxb4btcICvHwAt8SPfUSPAV
        dQuHgkcjypW3qUqv1p+nsH8hLyx6jioGelRAtgA+Wyi5niXlc8FRCjfoyWNvj+YhBTzfSZ
        IXcnx29JjpSVkTBqKyT3oDIni2NJ+OU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-pJBilwIPMvC3G42DQs8c9Q-1; Fri, 24 Apr 2020 10:19:19 -0400
X-MC-Unique: pJBilwIPMvC3G42DQs8c9Q-1
Received: by mail-wr1-f71.google.com with SMTP id e5so4802823wrs.23
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zZTOKD6Ncqd3+51m0Ix41rGnRkm6vJ5R+T6RG0yQOLY=;
        b=ll0tUTWhrKZSSElJzA0Ufz5CGaNIpyzbdFT3oFssnB7HvFEk3iOxTZ6Zk3fOj3mQhy
         lg7tfOTQ3whTLi4siWVKCCI+kWAl6cwEEa/zsIC0N/tJ81bQA1dM6n/wdtVa+5N7Me3z
         vxURh6hENfAy5ibxQH2cRGng2dIxm6EBRQabNDfNcJSg0hggBHWOCN9/r/Rzqw/1DV2p
         V9p7zTZzD+MKHSFWAVuuTJcm22W4FsZymphVnaVVF8kN8wV/YPQhGX4NhACLnYKbFr+f
         qriVPqnDt2S3pVQ4D5/hgp6VveW5WfNv51SLYJtLyuVdkEtxcg26LmORyjONb42WX5GT
         zbaQ==
X-Gm-Message-State: AGi0PuZSgT5taqZKgSnRPQcfEhGktETwBVJN3Cskuk+vlM3IRQv6bStX
        4btsiL1ckU0CQTnqPFV/1cpI0WUPvUDj+dJ799990hY7ln+8LUfkbav4uvKphnTGG7jUpz0IKNO
        8zNzE+5ggSMp646m3
X-Received: by 2002:a1c:a9c3:: with SMTP id s186mr10325043wme.89.1587737957970;
        Fri, 24 Apr 2020 07:19:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypLPAz185vPHxwSHEssI5e+6+0lgz+rUnZYKswgCdPlT/BaEwaGiZd/s+va2Hr3busH1px46Qw==
X-Received: by 2002:a1c:a9c3:: with SMTP id s186mr10325009wme.89.1587737957642;
        Fri, 24 Apr 2020 07:19:17 -0700 (PDT)
Received: from localhost.localdomain ([151.66.196.206])
        by smtp.gmail.com with ESMTPSA id k6sm3257159wma.19.2020.04.24.07.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:19:16 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:19:08 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200424141908.GA6295@localhost.localdomain>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20200424085610.10047-2-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This is a prototype for xdp multicast support. In this implemention we
> add a new helper to accept two maps, forward map and exclude map.
> We will redirect the packet to all the interfaces in *forward map*, but
> exclude the interfaces that in *exclude map*.
>=20
> To achive this I add a new ex_map for struct bpf_redirect_info.
> in the helper I set tgt_value to NULL to make a difference with
> bpf_xdp_redirect_map()
>=20
> We also add a flag *BPF_F_EXCLUDE_INGRESS* incase you don't want to
> create a exclude map for each interface and just want to exclude the
> ingress interface.
>=20
> The general data path is kept in net/core/filter.c. The native data
> path is in kernel/bpf/devmap.c so we can use direct calls to
> get better performace.
>=20
> v2: add new syscall bpf_xdp_redirect_map_multi() which could accept
> include/exclude maps directly.
>=20
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/linux/bpf.h            |  20 ++++++
>  include/linux/filter.h         |   1 +
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  23 ++++++-
>  kernel/bpf/devmap.c            | 114 +++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          |   6 ++
>  net/core/filter.c              |  98 ++++++++++++++++++++++++++--
>  net/core/xdp.c                 |  26 ++++++++
>  tools/include/uapi/linux/bpf.h |  23 ++++++-
>  9 files changed, 305 insertions(+), 7 deletions(-)
>=20

[...]

> +{
> +
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
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> +			int exclude_ifindex)
> +{
> +	struct bpf_dtab_netdev *in_obj =3D NULL;
> +	u32 key, next_key;
> +	int err;
> +
> +	if (!map)
> +		return false;

doing so it seems mandatory to define an exclude_map even if we want just t=
o do
not forward the packet to the "ingress" interface.
Moreover I was thinking that we can assume to never forward to in the incom=
ing
interface. Doing so the code would be simpler I guess. Is there a use case =
for
it? (forward even to the ingress interface)

> +
> +	if (obj->dev->ifindex =3D=3D exclude_ifindex)
> +		return true;
> +
> +	devmap_get_next_key(map, NULL, &key);
> +
> +	for (;;) {
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			in_obj =3D __dev_map_lookup_elem(map, key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			in_obj =3D __dev_map_hash_lookup_elem(map, key);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (in_obj && in_obj->dev->ifindex =3D=3D obj->dev->ifindex)
> +			return true;
> +
> +		err =3D devmap_get_next_key(map, &key, &next_key);
> +
> +		if (err)
> +			break;
> +
> +		key =3D next_key;
> +	}
> +
> +	return false;
> +}
> +
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_r=
x,
> +			  struct bpf_map *map, struct bpf_map *ex_map,
> +			  bool exclude_ingress)
> +{
> +	struct bpf_dtab_netdev *obj =3D NULL;
> +	struct xdp_frame *xdpf, *nxdpf;
> +	struct net_device *dev;
> +	u32 key, next_key;
> +	int err;
> +
> +	devmap_get_next_key(map, NULL, &key);
> +
> +	xdpf =3D convert_to_xdp_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	for (;;) {
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			obj =3D __dev_map_lookup_elem(map, key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			obj =3D __dev_map_hash_lookup_elem(map, key);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (!obj || dev_in_exclude_map(obj, ex_map,
> +					       exclude_ingress ? dev_rx->ifindex : 0))
> +			goto find_next;
> +
> +		dev =3D obj->dev;
> +
> +		if (!dev->netdev_ops->ndo_xdp_xmit)
> +			return -EOPNOTSUPP;
> +
> +		err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> +		if (unlikely(err))
> +			return err;
> +
> +		nxdpf =3D xdpf_clone(xdpf);
> +		if (unlikely(!nxdpf))
> +			return -ENOMEM;
> +
> +		bq_enqueue(dev, nxdpf, dev_rx);
> +
> +find_next:
> +		err =3D devmap_get_next_key(map, &key, &next_key);
> +		if (err)
> +			break;
> +		key =3D next_key;
> +	}

Do we need to free 'incoming' xdp buffer here? I think most of the drivers =
assume
the packet is owned by the stack if xdp_do_redirect returns 0

> +
> +	return 0;
> +}
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
>  			     struct bpf_prog *xdp_prog)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 38cfcf701eeb..f77213a0e354 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3880,6 +3880,7 @@ static int check_map_func_compatibility(struct bpf_=
verifier_env *env,
>  	case BPF_MAP_TYPE_DEVMAP:
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
>  		if (func_id !=3D BPF_FUNC_redirect_map &&
> +		    func_id !=3D BPF_FUNC_redirect_map_multi &&
>  		    func_id !=3D BPF_FUNC_map_lookup_elem)
>  			goto error;
>  		break;
> @@ -3970,6 +3971,11 @@ static int check_map_func_compatibility(struct bpf=
_verifier_env *env,
>  		    map->map_type !=3D BPF_MAP_TYPE_XSKMAP)
>  			goto error;
>  		break;
> +	case BPF_FUNC_redirect_map_multi:
> +		if (map->map_type !=3D BPF_MAP_TYPE_DEVMAP &&
> +		    map->map_type !=3D BPF_MAP_TYPE_DEVMAP_HASH)
> +			goto error;
> +		break;
>  	case BPF_FUNC_sk_redirect_map:
>  	case BPF_FUNC_msg_redirect_map:
>  	case BPF_FUNC_sock_map_update:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7d6ceaa54d21..94d1530e5ac6 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3473,12 +3473,17 @@ static const struct bpf_func_proto bpf_xdp_adjust=
_meta_proto =3D {
>  };
> =20
>  static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
> -			    struct bpf_map *map, struct xdp_buff *xdp)
> +			    struct bpf_map *map, struct xdp_buff *xdp,
> +			    struct bpf_map *ex_map, bool exclude_ingress)
>  {
>  	switch (map->map_type) {
>  	case BPF_MAP_TYPE_DEVMAP:
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		return dev_map_enqueue(fwd, xdp, dev_rx);
> +		if (fwd)
> +			return dev_map_enqueue(fwd, xdp, dev_rx);
> +		else
> +			return dev_map_enqueue_multi(xdp, dev_rx, map, ex_map,
> +						     exclude_ingress);

I guess it would be better to do not make it the default case. Maybe you can
add a bit in flags to mark it for "multicast"

>  	case BPF_MAP_TYPE_CPUMAP:
>  		return cpu_map_enqueue(fwd, xdp, dev_rx);
>  	case BPF_MAP_TYPE_XSKMAP:
> @@ -3534,6 +3539,8 @@ int xdp_do_redirect(struct net_device *dev, struct =
xdp_buff *xdp,
>  		    struct bpf_prog *xdp_prog)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> +	bool exclude_ingress =3D !!(ri->flags & BPF_F_EXCLUDE_INGRESS);
> +	struct bpf_map *ex_map =3D READ_ONCE(ri->ex_map);
>  	struct bpf_map *map =3D READ_ONCE(ri->map);
>  	u32 index =3D ri->tgt_index;
>  	void *fwd =3D ri->tgt_value;
> @@ -3552,7 +3559,7 @@ int xdp_do_redirect(struct net_device *dev, struct =
xdp_buff *xdp,
> =20
>  		err =3D dev_xdp_enqueue(fwd, xdp, dev);
>  	} else {
> -		err =3D __bpf_tx_xdp_map(dev, fwd, map, xdp);
> +		err =3D __bpf_tx_xdp_map(dev, fwd, map, xdp, ex_map, exclude_ingress);
>  	}
> =20
>  	if (unlikely(err))
> @@ -3566,6 +3573,49 @@ int xdp_do_redirect(struct net_device *dev, struct=
 xdp_buff *xdp,
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_redirect);
> =20
> +static int dev_map_redirect_multi(struct net_device *dev, struct sk_buff=
 *skb,
> +				  struct bpf_prog *xdp_prog,
> +				  struct bpf_map *map, struct bpf_map *ex_map,
> +				  bool exclude_ingress)
> +
> +{
> +	struct bpf_dtab_netdev *dst;
> +	struct sk_buff *nskb;
> +	u32 key, next_key;
> +	int err;
> +	void *fwd;
> +
> +	/* Get first key from forward map */
> +	map->ops->map_get_next_key(map, NULL, &key);
> +
> +	for (;;) {
> +		fwd =3D __xdp_map_lookup_elem(map, key);
> +		if (fwd) {
> +			dst =3D (struct bpf_dtab_netdev *)fwd;
> +			if (dev_in_exclude_map(dst, ex_map,
> +					       exclude_ingress ? dev->ifindex : 0))
> +				goto find_next;
> +
> +			nskb =3D skb_clone(skb, GFP_ATOMIC);
> +			if (!nskb)
> +				return -EOVERFLOW;
> +
> +			err =3D dev_map_generic_redirect(dst, nskb, xdp_prog);
> +			if (unlikely(err))
> +				return err;
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
> +	return 0;
> +}
> +
>  static int xdp_do_generic_redirect_map(struct net_device *dev,
>  				       struct sk_buff *skb,
>  				       struct xdp_buff *xdp,
> @@ -3573,6 +3623,8 @@ static int xdp_do_generic_redirect_map(struct net_d=
evice *dev,
>  				       struct bpf_map *map)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> +	bool exclude_ingress =3D !!(ri->flags & BPF_F_EXCLUDE_INGRESS);
> +	struct bpf_map *ex_map =3D READ_ONCE(ri->ex_map);
>  	u32 index =3D ri->tgt_index;
>  	void *fwd =3D ri->tgt_value;
>  	int err =3D 0;
> @@ -3583,9 +3635,16 @@ static int xdp_do_generic_redirect_map(struct net_=
device *dev,
> =20
>  	if (map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||
>  	    map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
> -		struct bpf_dtab_netdev *dst =3D fwd;
> +		if (fwd) {
> +			struct bpf_dtab_netdev *dst =3D fwd;
> +
> +			err =3D dev_map_generic_redirect(dst, skb, xdp_prog);
> +		} else {
> +			/* Deal with multicast maps */
> +			err =3D dev_map_redirect_multi(dev, skb, xdp_prog, map,
> +						     ex_map, exclude_ingress);
> +		}
> =20
> -		err =3D dev_map_generic_redirect(dst, skb, xdp_prog);
>  		if (unlikely(err))
>  			goto err;
>  	} else if (map->map_type =3D=3D BPF_MAP_TYPE_XSKMAP) {
> @@ -3699,6 +3758,33 @@ static const struct bpf_func_proto bpf_xdp_redirec=
t_map_proto =3D {
>  	.arg3_type      =3D ARG_ANYTHING,
>  };
> =20
> +BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
> +	   struct bpf_map *, ex_map, u64, flags)
> +{
> +	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> +
> +	if (unlikely(!map || flags > BPF_F_EXCLUDE_INGRESS))
> +		return XDP_ABORTED;
> +
> +	ri->tgt_index =3D 0;
> +	ri->tgt_value =3D NULL;
> +	ri->flags =3D flags;
> +
> +	WRITE_ONCE(ri->map, map);
> +	WRITE_ONCE(ri->ex_map, ex_map);
> +
> +	return XDP_REDIRECT;
> +}
> +
> +static const struct bpf_func_proto bpf_xdp_redirect_map_multi_proto =3D {
> +	.func           =3D bpf_xdp_redirect_map_multi,
> +	.gpl_only       =3D false,
> +	.ret_type       =3D RET_INTEGER,
> +	.arg1_type      =3D ARG_CONST_MAP_PTR,
> +	.arg1_type      =3D ARG_CONST_MAP_PTR,
> +	.arg3_type      =3D ARG_ANYTHING,
> +};
> +
>  static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
>  				  unsigned long off, unsigned long len)
>  {
> @@ -6304,6 +6390,8 @@ xdp_func_proto(enum bpf_func_id func_id, const stru=
ct bpf_prog *prog)
>  		return &bpf_xdp_redirect_proto;
>  	case BPF_FUNC_redirect_map:
>  		return &bpf_xdp_redirect_map_proto;
> +	case BPF_FUNC_redirect_map_multi:
> +		return &bpf_xdp_redirect_map_multi_proto;
>  	case BPF_FUNC_xdp_adjust_tail:
>  		return &bpf_xdp_adjust_tail_proto;
>  	case BPF_FUNC_fib_lookup:
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 4c7ea85486af..70dfb4910f84 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -496,3 +496,29 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct=
 xdp_buff *xdp)
>  	return xdpf;
>  }
>  EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
> +
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> +{
> +	unsigned int headroom, totalsize;
> +	struct xdp_frame *nxdpf;
> +	struct page *page;
> +	void *addr;
> +
> +	headroom =3D xdpf->headroom + sizeof(*xdpf);
> +	totalsize =3D headroom + xdpf->len;
> +
> +	if (unlikely(totalsize > PAGE_SIZE))
> +		return NULL;
> +	page =3D dev_alloc_page();
> +	if (!page)
> +		return NULL;
> +	addr =3D page_to_virt(page);
> +
> +	memcpy(addr, xdpf, totalsize);
> +
> +	nxdpf =3D addr;
> +	nxdpf->data =3D addr + headroom;
> +
> +	return nxdpf;
> +}
> +EXPORT_SYMBOL_GPL(xdpf_clone);
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index 2e29a671d67e..1dbe42290223 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3025,6 +3025,21 @@ union bpf_attr {
>   *		* **-EOPNOTSUPP**	Unsupported operation, for example a
>   *					call from outside of TC ingress.
>   *		* **-ESOCKTNOSUPPORT**	Socket type not supported (reuseport).
> + *
> + * int bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_ma=
p, u64 flags)
> + * 	Description
> + * 		Redirect the packet to all the interfaces in *map*, and
> + * 		exclude the interfaces that in *ex_map*. The *ex_map* could
> + * 		be NULL.
> + *
> + * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
> + * 		which could exlcude redirect to the ingress device.
> + *
> + * 		See also bpf_redirect_map(), which supports redirecting
> + * 		packet to a specific ifindex in the map.
> + * 	Return
> + * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3151,7 +3166,8 @@ union bpf_attr {
>  	FN(xdp_output),			\
>  	FN(get_netns_cookie),		\
>  	FN(get_current_ancestor_cgroup_id),	\
> -	FN(sk_assign),
> +	FN(sk_assign),			\
> +	FN(redirect_map_multi),
> =20
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>   * function eBPF program intends to call
> @@ -3280,6 +3296,11 @@ enum bpf_lwt_encap_mode {
>  	BPF_LWT_ENCAP_IP,
>  };
> =20
> +/* BPF_FUNC_redirect_map_multi flags. */
> +enum {
> +	BPF_F_EXCLUDE_INGRESS		=3D (1ULL << 0),
> +};
> +
>  #define __bpf_md_ptr(type, name)	\
>  union {					\
>  	type name;			\
> --=20
> 2.19.2
>=20

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXqL1WQAKCRA6cBh0uS2t
rCZ5AQDacSa3ParxtUNl9NPvSz9aDXYHmg4sDjd675eA/TKnzwEAyfuKUKTW9Vdx
DAvmL+aXxK0VJht2QI78BJ5YiIBibwI=
=q1Rz
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

