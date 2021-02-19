Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF1231FD90
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhBSRGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:06:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229587AbhBSRGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:06:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613754319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G9YmUjSdB0aEqx5Q3NW+k6kL+oQpdgPeOrPsN461J+c=;
        b=fWNN7F9NfA2bFhKSJQn6E4SWSXHgDZYd/ddgXUmWK+91WY0WOm1qffCw/KH4lhu9GyDSgP
        hV+RpNssBW7v79bqBH4XN9WST4/ToW0EJHDe6mx+mnjuEK8vU9SxlV85a3prq8uD+WLcN/
        jh91P94FTvPUD264ybAfgluQfnWLyRg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-iw7_a9diP-2noHkGE3iWxQ-1; Fri, 19 Feb 2021 12:05:18 -0500
X-MC-Unique: iw7_a9diP-2noHkGE3iWxQ-1
Received: by mail-ej1-f69.google.com with SMTP id gx1so2257893ejc.21
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 09:05:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=G9YmUjSdB0aEqx5Q3NW+k6kL+oQpdgPeOrPsN461J+c=;
        b=qZsL8iItkFKlAvORk8CnDIMEXQzMiBNjTEsVhCtDcdiMMn7HPnsUNX8MTQiovNPKa9
         4ZPgJyoarcFkr/RTwcjuxa/GqHAMnT72dOPXZYkG6xlT5rVcNTxDUPA89sQh1TqR9DKF
         SU5YA9E/gkJShnA8KP8uPHVv1Vngnoxms4FxfxdK5jLuvpZe+SoD9KR2XP0hijtobOL2
         eqOl4DB152gvdR41zkcM8pnPmqIGcNMqJT3ApI5Caw6AGd1fRJiiV71/FHOuO4VynTHg
         USrTB4eRGHf2G24yFON/MNlWfn9313eYhaObw2C18a95w77FeLzjof2f/ie0+2aWkflJ
         jHAw==
X-Gm-Message-State: AOAM530rIda5W1LxKQ3Fr9btjWIxGUu32DH//E33O58SkZZpteQoy4uf
        ySpiFkOC80yCGZYONd+7R/y3FnSscGgQ3pdL/0JKsI34AVYpLygMhcAJt66cmufWP8gn0QMWdEa
        iq8/4fQpk63xMWQ+X
X-Received: by 2002:a05:6402:1398:: with SMTP id b24mr9750009edv.108.1613754316641;
        Fri, 19 Feb 2021 09:05:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIHu3B8wM1v/cjRw3TPaBUyADr4lzU23ih6RDVLwhWbfe1BLysUjjlnsQN71PV6UBEGEE8VQ==
X-Received: by 2002:a05:6402:1398:: with SMTP id b24mr9749954edv.108.1613754316244;
        Fri, 19 Feb 2021 09:05:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x17sm4906093eju.36.2021.02.19.09.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:05:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 48D36180676; Fri, 19 Feb 2021 18:05:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org,
        magnus.karlsson@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next 1/2] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
In-Reply-To: <20210219145922.63655-2-bjorn.topel@gmail.com>
References: <20210219145922.63655-1-bjorn.topel@gmail.com>
 <20210219145922.63655-2-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 19 Feb 2021 18:05:15 +0100
Message-ID: <87tuq8httg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Currently the bpf_redirect_map() implementation dispatches to the
> correct map-lookup function via a switch-statement. To avoid the
> dispatching, this change adds one bpf_redirect_map() implementation per
> map. Correct function is automatically selected by the BPF verifier.
>
> rfc->v1: Get rid of the macro and use __always_inline. (Jesper)
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Nice! Way better with the __always_inline. One small nit below, but
otherwise:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

> ---
>  include/linux/bpf.h    | 20 +++++++------
>  include/linux/filter.h |  2 ++
>  include/net/xdp_sock.h |  6 ++--
>  kernel/bpf/cpumap.c    |  2 +-
>  kernel/bpf/devmap.c    |  4 +--
>  kernel/bpf/verifier.c  | 28 +++++++++++-------
>  net/core/filter.c      | 67 ++++++++++++++++++++++++++----------------
>  7 files changed, 76 insertions(+), 53 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index cccaef1088ea..3dd186eeaf98 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -314,12 +314,14 @@ enum bpf_return_type {
>  	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
>  };
>=20=20
> +typedef u64 (*bpf_func_proto_func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r=
5);
> +
>  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF=
 programs
>   * to in-kernel helper functions and for adjusting imm32 field in BPF_CA=
LL
>   * instructions after verifying
>   */
>  struct bpf_func_proto {
> -	u64 (*func)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
> +	bpf_func_proto_func func;
>  	bool gpl_only;
>  	bool pkt_access;
>  	enum bpf_return_type ret_type;
> @@ -1429,9 +1431,11 @@ struct btf *bpf_get_btf_vmlinux(void);
>  /* Map specifics */
>  struct xdp_buff;
>  struct sk_buff;
> +struct bpf_dtab_netdev;
> +struct bpf_cpu_map_entry;
>=20=20
> -struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 k=
ey);
> -struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, =
u32 key);
> +void *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
> +void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
>  void __dev_flush(void);
>  int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> @@ -1441,7 +1445,7 @@ int dev_map_generic_redirect(struct bpf_dtab_netdev=
 *dst, struct sk_buff *skb,
>  			     struct bpf_prog *xdp_prog);
>  bool dev_map_can_have_prog(struct bpf_map *map);
>=20=20
> -struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32=
 key);
> +void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key);
>  void __cpu_map_flush(void);
>  int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> @@ -1568,14 +1572,12 @@ static inline int bpf_obj_get_user(const char __u=
ser *pathname, int flags)
>  	return -EOPNOTSUPP;
>  }
>=20=20
> -static inline struct net_device  *__dev_map_lookup_elem(struct bpf_map *=
map,
> -						       u32 key)
> +static inline void  *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	return NULL;
>  }
>=20=20
> -static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_=
map *map,
> -							     u32 key)
> +static inline void  *__dev_map_hash_lookup_elem(struct bpf_map *map, u32=
 key)
>  {
>  	return NULL;
>  }
> @@ -1615,7 +1617,7 @@ static inline int dev_map_generic_redirect(struct b=
pf_dtab_netdev *dst,
>  }
>=20=20
>  static inline
> -struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32=
 key)
> +void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	return NULL;
>  }
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 3b00fc906ccd..1dedcf66b694 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1472,4 +1472,6 @@ static inline bool bpf_sk_lookup_run_v6(struct net =
*net, int protocol,
>  }
>  #endif /* IS_ENABLED(CONFIG_IPV6) */
>=20=20
> +bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type);
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index cc17bc957548..da4139a58630 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -80,8 +80,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buf=
f *xdp);
>  int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp);
>  void __xsk_map_flush(void);
>=20=20
> -static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
> -						     u32 key)
> +static inline void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	struct xsk_map *m =3D container_of(map, struct xsk_map, map);
>  	struct xdp_sock *xs;
> @@ -109,8 +108,7 @@ static inline void __xsk_map_flush(void)
>  {
>  }
>=20=20
> -static inline struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map,
> -						     u32 key)
> +static inline void *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	return NULL;
>  }
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 5d1469de6921..a4d2cb93cd69 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -563,7 +563,7 @@ static void cpu_map_free(struct bpf_map *map)
>  	kfree(cmap);
>  }
>=20=20
> -struct bpf_cpu_map_entry *__cpu_map_lookup_elem(struct bpf_map *map, u32=
 key)
> +void *__cpu_map_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	struct bpf_cpu_map *cmap =3D container_of(map, struct bpf_cpu_map, map);
>  	struct bpf_cpu_map_entry *rcpu;
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 85d9d1b72a33..37ac4cde9713 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -258,7 +258,7 @@ static int dev_map_get_next_key(struct bpf_map *map, =
void *key, void *next_key)
>  	return 0;
>  }
>=20=20
> -struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, =
u32 key)
> +void *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
>  	struct hlist_head *head =3D dev_map_index_hash(dtab, key);
> @@ -392,7 +392,7 @@ void __dev_flush(void)
>   * update happens in parallel here a dev_put wont happen until after rea=
ding the
>   * ifindex.
>   */
> -struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 k=
ey)
> +void *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
>  {
>  	struct bpf_dtab *dtab =3D container_of(map, struct bpf_dtab, map);
>  	struct bpf_dtab_netdev *obj;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3d34ba492d46..b5fb0c4e911a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5409,7 +5409,8 @@ record_func_map(struct bpf_verifier_env *env, struc=
t bpf_call_arg_meta *meta,
>  	    func_id !=3D BPF_FUNC_map_delete_elem &&
>  	    func_id !=3D BPF_FUNC_map_push_elem &&
>  	    func_id !=3D BPF_FUNC_map_pop_elem &&
> -	    func_id !=3D BPF_FUNC_map_peek_elem)
> +	    func_id !=3D BPF_FUNC_map_peek_elem &&
> +	    func_id !=3D BPF_FUNC_redirect_map)
>  		return 0;
>=20=20
>  	if (map =3D=3D NULL) {
> @@ -11860,17 +11861,22 @@ static int fixup_bpf_calls(struct bpf_verifier_=
env *env)
>  		}
>=20=20
>  patch_call_imm:
> -		fn =3D env->ops->get_func_proto(insn->imm, env->prog);
> -		/* all functions that have prototype and verifier allowed
> -		 * programs to call them, must be real in-kernel functions
> -		 */
> -		if (!fn->func) {
> -			verbose(env,
> -				"kernel subsystem misconfigured func %s#%d\n",
> -				func_id_name(insn->imm), insn->imm);
> -			return -EFAULT;
> +		if (insn->imm =3D=3D BPF_FUNC_redirect_map) {
> +			aux =3D &env->insn_aux_data[i];
> +			map_ptr =3D BPF_MAP_PTR(aux->map_ptr_state);
> +			insn->imm =3D get_xdp_redirect_func(map_ptr->map_type) - __bpf_call_b=
ase;
> +		} else {
> +			fn =3D env->ops->get_func_proto(insn->imm, env->prog);
> +			/* all functions that have prototype and verifier allowed
> +			 * programs to call them, must be real in-kernel functions
> +			 */
> +			if (!fn->func) {
> +				verbose(env, "kernel subsystem misconfigured func %s#%d\n",
> +					func_id_name(insn->imm), insn->imm);
> +				return -EFAULT;
> +			}
> +			insn->imm =3D fn->func - __bpf_call_base;
>  		}
> -		insn->imm =3D fn->func - __bpf_call_base;
>  	}
>=20=20
>  	/* Since poke tab is now finalized, publish aux to tracker. */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index adfdad234674..fd64d768e16a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3944,22 +3944,6 @@ void xdp_do_flush(void)
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_flush);
>=20=20
> -static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
> -{
> -	switch (map->map_type) {
> -	case BPF_MAP_TYPE_DEVMAP:
> -		return __dev_map_lookup_elem(map, index);
> -	case BPF_MAP_TYPE_DEVMAP_HASH:
> -		return __dev_map_hash_lookup_elem(map, index);
> -	case BPF_MAP_TYPE_CPUMAP:
> -		return __cpu_map_lookup_elem(map, index);
> -	case BPF_MAP_TYPE_XSKMAP:
> -		return __xsk_map_lookup_elem(map, index);
> -	default:
> -		return NULL;
> -	}
> -}
> -
>  void bpf_clear_redirect_map(struct bpf_map *map)
>  {
>  	struct bpf_redirect_info *ri;
> @@ -4110,22 +4094,17 @@ static const struct bpf_func_proto bpf_xdp_redire=
ct_proto =3D {
>  	.arg2_type      =3D ARG_ANYTHING,
>  };
>=20=20
> -BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
> -	   u64, flags)
> +static __always_inline s64 __bpf_xdp_redirect_map(struct bpf_map *map, u=
32 ifindex, u64 flags,
> +						  void *lookup_elem(struct bpf_map *map,
> +								    u32 key))
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>=20=20
> -	/* Lower bits of the flags are used as return code on lookup failure */
>  	if (unlikely(flags > XDP_TX))
>  		return XDP_ABORTED;
>=20=20
> -	ri->tgt_value =3D __xdp_map_lookup_elem(map, ifindex);
> +	ri->tgt_value =3D lookup_elem(map, ifindex);
>  	if (unlikely(!ri->tgt_value)) {
> -		/* If the lookup fails we want to clear out the state in the
> -		 * redirect_info struct completely, so that if an eBPF program
> -		 * performs multiple lookups, the last one always takes
> -		 * precedence.
> -		 */

Why remove the comments?

>  		WRITE_ONCE(ri->map, NULL);
>  		return flags;
>  	}
> @@ -4137,8 +4116,44 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *,=
 map, u32, ifindex,
>  	return XDP_REDIRECT;
>  }
>=20=20
> +BPF_CALL_3(bpf_xdp_redirect_devmap, struct bpf_map *, map, u32, ifindex,=
 u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_lookup_ele=
m);
> +}
> +
> +BPF_CALL_3(bpf_xdp_redirect_devmap_hash, struct bpf_map *, map, u32, ifi=
ndex, u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __dev_map_hash_looku=
p_elem);
> +}
> +
> +BPF_CALL_3(bpf_xdp_redirect_cpumap, struct bpf_map *, map, u32, ifindex,=
 u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __cpu_map_lookup_ele=
m);
> +}
> +
> +BPF_CALL_3(bpf_xdp_redirect_xskmap, struct bpf_map *, map, u32, ifindex,=
 u64, flags)
> +{
> +	return __bpf_xdp_redirect_map(map, ifindex, flags, __xsk_map_lookup_ele=
m);
> +}
> +
> +bpf_func_proto_func get_xdp_redirect_func(enum bpf_map_type map_type)
> +{
> +	switch (map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		return bpf_xdp_redirect_devmap;
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		return bpf_xdp_redirect_devmap_hash;
> +	case BPF_MAP_TYPE_CPUMAP:
> +		return bpf_xdp_redirect_cpumap;
> +	case BPF_MAP_TYPE_XSKMAP:
> +		return bpf_xdp_redirect_xskmap;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/* NB! .func is NULL! get_xdp_redirect_func() is used instead! */
>  static const struct bpf_func_proto bpf_xdp_redirect_map_proto =3D {
> -	.func           =3D bpf_xdp_redirect_map,
>  	.gpl_only       =3D false,
>  	.ret_type       =3D RET_INTEGER,
>  	.arg1_type      =3D ARG_CONST_MAP_PTR,
> --=20
> 2.27.0

