Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C076C33EFF6
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhCQMDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:03:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231319AbhCQMDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 08:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615982587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loTLL5bPRcgdVQ4WlyJhjazx0VzTXi8HDfcDLUMb2Kg=;
        b=QcwduuNKmXYmsJa+9DtgSi6cgvk1wcMm9oUa1cF7GSn4Vtyx4DgRPZGTpivPRgzUM/57Fa
        eB3whC3o0IQFF792xmvVpI3ZiVo0DMCLfn4KUtnm9Bg5IOU/NOc6F63SVHeJ5r8RRkDNfA
        OzJLwIYeAv2hvgzSfCiAlKxZGdzXaOs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-6Z7BVk8BMUu8_hRtNYMyBA-1; Wed, 17 Mar 2021 08:03:05 -0400
X-MC-Unique: 6Z7BVk8BMUu8_hRtNYMyBA-1
Received: by mail-ej1-f70.google.com with SMTP id gn30so14999996ejc.3
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 05:03:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=loTLL5bPRcgdVQ4WlyJhjazx0VzTXi8HDfcDLUMb2Kg=;
        b=SLrVQlcQpFNC8NJv+qTaWc2zf0MYONSO1fPzDxPACcQcrpxOg9kPAj0QBje3iSy0fr
         ncLN5jlnFRhLmFptPAUwSGJxtWSB0rSzdv7kzm6BkSLFBYXAm2IOZ1Kdq+IKh4fDwWTb
         64cP1420uIStgAEKUB3xa5coca/9RjGRTrP+Rm/SftMLqBm7JawVHqKtv4mgYbfCAays
         Wt6e4VFqxCOvnmuEl1EhXmGm1X2ZGxJq7NBWFY7IM7fjSDuAnvheFWmL01sqh90C/qRe
         +0qaBjPX67Czn7LjGTBjNgZuG+ieice4IK4LXIpK/WBxUYYuj1HBUdv7r3PvG7NVCcSI
         7m2w==
X-Gm-Message-State: AOAM532e0owSEgHbIHnViBWgzkmzqDGlEO2YyHzP/LcoDeVxvA5Yn9TT
        iVZtcpF14JoxZXZuItx677DtRBZPScN5fZsw1WxjV79S2Ni9di2/gpa3rGlJ+J6PWjMhXogf5Ql
        GguJlLIsGoo6AgXsQ
X-Received: by 2002:a05:6402:c0f:: with SMTP id co15mr41126280edb.373.1615982584357;
        Wed, 17 Mar 2021 05:03:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAkY9coblSmGNsVnkcMF4ALQaXyWQZN4WBEF7ZwBdkGDyRnGBuWC2hl2THkHtOn4jT/iqoEA==
X-Received: by 2002:a05:6402:c0f:: with SMTP id co15mr41126247edb.373.1615982584086;
        Wed, 17 Mar 2021 05:03:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u15sm12659921eds.6.2021.03.17.05.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 05:03:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 00E8B181F55; Wed, 17 Mar 2021 13:03:02 +0100 (CET)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv2 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210309101321.2138655-3-liuhangbin@gmail.com>
References: <20210309101321.2138655-1-liuhangbin@gmail.com>
 <20210309101321.2138655-3-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Mar 2021 13:03:02 +0100
Message-ID: <87r1kec7ih.fsf@toke.dk>
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
> There are some drop back as we need to loop the map and get each
> interface.
>
> Version      | Test                                | Generic | Native
> 5.11         | redirect_map        i40e->i40e      |    1.9M |  9.3M
> 5.11         | redirect_map        i40e->veth      |    1.5M | 11.2M
> 5.11 + patch | redirect_map        i40e->i40e      |    1.9M |  9.6M
> 5.11 + patch | redirect_map        i40e->veth      |    1.5M | 11.9M
> 5.11 + patch | redirect_map_multi  i40e->i40e      |    1.5M |  7.7M
> 5.11 + patch | redirect_map_multi  i40e->veth      |    1.2M |  9.1M
> 5.11 + patch | redirect_map_multi  i40e->mlx4+veth |    0.9M |  3.2M
>
> v2: fix flag renaming issue in v1
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

FYI, this no longer applies to bpf-next due to Bj=C3=B6rn's refactor in
commit: ee75aef23afe ("bpf, xdp: Restructure redirect actions")

Also, two small nits below:


> ---
>  include/linux/bpf.h            |  16 +++++
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  17 ++++-
>  kernel/bpf/devmap.c            | 119 +++++++++++++++++++++++++++++++++
>  net/core/filter.c              |  74 ++++++++++++++++++--
>  net/core/xdp.c                 |  29 ++++++++
>  tools/include/uapi/linux/bpf.h |  17 ++++-
>  7 files changed, 262 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index c931bc97019d..bb07ccd170f2 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1458,6 +1458,9 @@ int dev_xdp_enqueue(struct net_device *dev, struct =
xdp_buff *xdp,
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
> @@ -1630,6 +1633,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, s=
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
> index 2d3036e292a9..5982ceb217dc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2508,8 +2508,12 @@ union bpf_attr {
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
> @@ -5004,6 +5008,15 @@ enum {
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
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f80cf5036d39..ad616a043d2a 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -519,6 +519,125 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, st=
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
> +	u32 *tmp_key =3D key;

why is tmp_key needed? you're not using key for anything else, so you
could just substitute that for all of the uses of tmp_key below?

> +	u32 index;
> +	int err;
> +
> +	err =3D devmap_get_next_key(map, tmp_key, next_key);
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
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			obj =3D __dev_map_lookup_elem(map, *next_key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			obj =3D __dev_map_hash_lookup_elem(map, *next_key);
> +			break;
> +		default:
> +			break;
> +		}
> +
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
> +		tmp_key =3D next_key;
> +		err =3D devmap_get_next_key(map, tmp_key, next_key);
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
> +	int ex_ifindex;
> +	u32 key, next_key;

Out of reverse-xmas-tree order...


-Toke

