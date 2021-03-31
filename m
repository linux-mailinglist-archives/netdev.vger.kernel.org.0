Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E287350194
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhCaNlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235981AbhCaNlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617198083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rccxDYfw9vp+Dvmt0DxJeFcvrSyYfaiVQ1bHIt9jCKE=;
        b=YbDrGh3oU5xAsdCxrRUfx3yrBhRWjDBG+OgfXUJOseLnxP6glTcauVZkDoeWICHcpceZIj
        dgFYSboAO3o9QCos2+gQQzp73Ajlq0A4yuSLFdruoD2zhNY6x5Y6ishe9qJyiLkme4dqtA
        iek1Xipve3WCvcypkQCZTSq5EZ0ndTU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-u_oZSFAMMmeUpnX0f_5U3A-1; Wed, 31 Mar 2021 09:41:21 -0400
X-MC-Unique: u_oZSFAMMmeUpnX0f_5U3A-1
Received: by mail-ed1-f69.google.com with SMTP id r6so1136018edh.7
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 06:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=rccxDYfw9vp+Dvmt0DxJeFcvrSyYfaiVQ1bHIt9jCKE=;
        b=hcjyiay4B1wToHoFX4AHqS1TjgCWxcOD5xBp2k/s0GA2MovLKbfDkr3637Kkc3Bhl3
         7Q+F12oFHe3j1BleeEPD2J8khTfOR3cJHLzSsv/Vbn58dAadc+j5pLMpRd06oJCkE+xe
         rAfZ/UZ+LnEdazKynyRXkSxcYWD1PRfyXkSIMKbl7H+5mXvHQ4sc+3IfmF0wpz7nQv77
         N9jdEhIsM0/M1E6q5iqsbDXwsa5+J1eOB835m+/BMTQ42NnJXU5RT+uecWG+oZNjrLi7
         TVd+9iLDa4d8x1nIDKmNnx3btT7Irbou012H9Yjeyeho3HHNllmH8lo3o+CJKMtC7HBZ
         6+nA==
X-Gm-Message-State: AOAM530Pwr7/aYaa3YOVbzvEqmXS+zi9XcHGCCJnSLM/R8ckT9Lg4oFt
        kTlYy7gv4C3jBXWE+fMTg5lNGQmoz2vIAO4i/VU/XaOSMFyWT41NpmKNjMyA2SYB1XWANw/hXA6
        NjjFze/nqAmOoq3Ur
X-Received: by 2002:a05:6402:698:: with SMTP id f24mr3760710edy.262.1617198079900;
        Wed, 31 Mar 2021 06:41:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/G4qPf7pSBWQy5oWo4qT5+kdwNdUvpaLfzYu8uKFPgPLv0KmHtt90UHmVIrMx9vBw2mYgqw==
X-Received: by 2002:a05:6402:698:: with SMTP id f24mr3760676edy.262.1617198079511;
        Wed, 31 Mar 2021 06:41:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id jx22sm1187681ejc.105.2021.03.31.06.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 06:41:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1E86B1801A8; Wed, 31 Mar 2021 15:41:17 +0200 (CEST)
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
Subject: Re: [PATCHv3 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
In-Reply-To: <20210325092733.3058653-3-liuhangbin@gmail.com>
References: <20210325092733.3058653-1-liuhangbin@gmail.com>
 <20210325092733.3058653-3-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 31 Mar 2021 15:41:17 +0200
Message-ID: <87lfa3phj6.fsf@toke.dk>
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
> ---
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
>  include/linux/filter.h         |  14 +++-
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  17 ++++-
>  kernel/bpf/devmap.c            | 127 +++++++++++++++++++++++++++++++++
>  net/core/filter.c              |  92 +++++++++++++++++++++++-
>  net/core/xdp.c                 |  29 ++++++++
>  tools/include/uapi/linux/bpf.h |  17 ++++-
>  8 files changed, 310 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a25730eaa148..5dacb1a45a03 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1456,11 +1456,15 @@ struct sk_buff;
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
> @@ -1595,6 +1599,11 @@ static inline int bpf_obj_get_user(const char __us=
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
> @@ -1622,6 +1631,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, s=
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
> index b2b85b2cad8e..434170aafd0d 100644
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
> @@ -1479,11 +1480,11 @@ static __always_inline int __bpf_xdp_redirect_map=
(struct bpf_map *map, u32 ifind
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>=20=20
>  	/* Lower bits of the flags are used as return code on lookup failure */
> -	if (unlikely(flags > XDP_TX))
> +	if (unlikely(flags & ~(BPF_F_ACTION_MASK | BPF_F_REDIR_MASK)))
>  		return XDP_ABORTED;
>=20=20
>  	ri->tgt_value =3D lookup_elem(map, ifindex);
> -	if (unlikely(!ri->tgt_value)) {
> +	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
>  		/* If the lookup fails we want to clear out the state in the
>  		 * redirect_info struct completely, so that if an eBPF program
>  		 * performs multiple lookups, the last one always takes
> @@ -1491,13 +1492,20 @@ static __always_inline int __bpf_xdp_redirect_map=
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
> +	if ((map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP ||
> +	     map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) &&
> +	    (flags & BPF_F_BROADCAST)) {
> +		ri->flags =3D flags;

This, combined with this:

[...]

> +	if (ri->flags & BPF_F_BROADCAST) {
> +		map =3D READ_ONCE(ri->map);
> +		WRITE_ONCE(ri->map, NULL);
> +	}
> +
>  	switch (map_type) {
>  	case BPF_MAP_TYPE_DEVMAP:
>  		fallthrough;
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		err =3D dev_map_enqueue(fwd, xdp, dev);
> +		if (ri->flags & BPF_F_BROADCAST)
> +			err =3D dev_map_enqueue_multi(xdp, dev, map,
> +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> +		else
> +			err =3D dev_map_enqueue(fwd, xdp, dev);

Means that (since the flags value is never cleared again) once someone
has done a broadcast redirect, that's all they'll ever get until the
next reboot ;)

Also, the bpf_clear_redirect_map() call has no effect since the call to
dev_map_enqueue_multi() only checks the flags and not the value of the
map pointer before deciding which enqueue function to call.

To fix both of these, how about changing the logic so that:

- __bpf_xdp_redirect_map() sets the map pointer if the broadcast flag is
  set (and clears it if the flag isn't set!)

- xdp_do_redirect() does the READ_ONCE/WRITE_ONCE on ri->map
  unconditionally and then dispatches to dev_map_enqueue_multi() if the
  read resulted in a non-NULL pointer

Also, it should be invalid to set the broadcast flag with a map type
other than a devmap; __bpf_xdp_redirect_map() should check that.

And finally, with the changes above, you no longer need the broadcast
flag in do_redirect() at all, so you could just have a bool
ri->exclude_ingress that is set in the helper and pass that directly to
dev_map_enqueue_multi().

A selftest that validates that the above works as it's supposed to might
be nice as well (i.e., one that broadcasts and does a regular redirect
after one another)

-Toke

