Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA46B2CAF0B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgLAVoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:44:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgLAVoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:44:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606858967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bd+bOWxKLT1X2KXSuMWdz16oD4oa+3W04I/i/WY8Ks=;
        b=GLITdFyXU9z/V2VZTOkoJd+jBggtTqKNWKbo+iPceX4qIxnYFrRSpZASLOkZsLC4At0ufE
        OKal4saTBeT66ibywOhU+wNCVqjisfurzTExleeVKvr+wA2PhXXw0KiLppt7ONGDpPAXS0
        6Z2Dgr/fpJTkYeIFrPNgZTN3rAMsjec=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-60S9bKCdPFy0U_5TlDKleg-1; Tue, 01 Dec 2020 16:42:46 -0500
X-MC-Unique: 60S9bKCdPFy0U_5TlDKleg-1
Received: by mail-ed1-f69.google.com with SMTP id g1so2110428edk.0
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:42:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/bd+bOWxKLT1X2KXSuMWdz16oD4oa+3W04I/i/WY8Ks=;
        b=oMteqmtYxyq5P/kzvfKe1ZhacHH0lb61Dl8yKLLn7CuRlzqj3wCpIbnut0UP7qF+Zm
         jofHYnDV3ghti4nZ4kiMHG0s8LbatN54SpJs9epMXG9/rRqZdyb6i+MwpGZ4clE80Ec8
         DDeyrOx63xmLCL1FYailQa/f+ttT3cEWFecsFI19siXi+TfVYBHOT/vIrQ5Xt+PFXArn
         GQY4ARBasnAnZwC+vyFMwve9cPnXoNkKlw0asAqUXo7ZNnJKMMaNPp6b02e4yyt1Fu7v
         h0IyW3Ff1UDjDpYZwrdVWswgK9bj+1JH7Uro+3U5nlh6RMZI9YiggOEwlGqyF1mcWEG4
         ydhg==
X-Gm-Message-State: AOAM5304+co6KRwKCy/bfV5ICuRw5k2ly4ItLSVBrO6GnqI8cZF7YOsa
        Bg1KS5FO1wzCEuV/UCNcvSQvm6sPhAFa/aNVWg2wMYmeTgZheK3NtnR51ynDxQMwaI6PUwJ2f/m
        ES0YpWCLTbA+hjj2+
X-Received: by 2002:aa7:d297:: with SMTP id w23mr5287559edq.374.1606858964613;
        Tue, 01 Dec 2020 13:42:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj6/BYeys7O5UzeBcnIT1rKdIQGhojHmXbRd0855Aw1KRUG7bLCZNaQ/sXejbUgdm9ikmDeg==
X-Received: by 2002:aa7:d297:: with SMTP id w23mr5287530edq.374.1606858964076;
        Tue, 01 Dec 2020 13:42:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o11sm313968ejh.55.2020.12.01.13.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 13:42:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D197A1843EC; Tue,  1 Dec 2020 22:42:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, hawk@kernel.org, kuba@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Subject: Re: [PATCH bpf-next] bpf, xdp: add bpf_redirect{,_map}() leaf node
 detection and optimization
In-Reply-To: <20201201172345.264053-1-bjorn.topel@gmail.com>
References: <20201201172345.264053-1-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Dec 2020 22:42:42 +0100
Message-ID: <87y2ihyzhp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Teach the verifier to detect if all calls to bpf_redirect{,_map}() are
> leaf nodes, i.e.:
>
>   return bpf_redirect_map(...);
> or
>   ret =3D bpf_redirect_map(...);
>   if (ret !=3D 0)
>      return ret;
>
> If so, we can apply an optimization to the XDP path. Instead of
> calling bpf_redirect_map() followed by xdp_do_redirect(), we simply
> perform the work of xdp_do_redirect() from bpf_redirect_map(). By
> doing so we can do fewer loads/stores/checks and save some cycles.
>
> The XDP core will introspect the XDP program to check whether the
> optimization can be performed, by checking the "redirect_opt" bit in
> the bpf_prog structure.
>
> The bpf_redirect_info structure is extended with some new members:
> xdp_prog_redirect_opt and xdp. The xdp_prog_redirect_opt member is the
> current program executing the helper. This is also used as a flag in
> the XDP core to determine if the optimization is turned on. The xdp
> member is the current xdp_buff/context executing.
>
> The verifier detection is currently very simplistic, and aimed for
> very simple XDP programs such as the libbpf AF_XDP XDP program. If BPF
> tail calls or bpf2bpf calls are used, the optimization will be
> disabled.
>
> Performance up ~5% Mpps for the xdp_redirect_map and xdpsock samples,
> and ~3% for bpf_redirect() programs.

Neat! Got actual numbers? :)

> An interesting extension would be to support an indirect jump
> instruction/proper tail calls (only for helpers) in BPF, so the call
> could be elided in favor for a jump.
>
> Thanks to Maciej for the internal code review.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/linux/bpf_verifier.h |   3 ++
>  include/linux/filter.h       |  30 +++++++++--
>  kernel/bpf/verifier.c        |  68 ++++++++++++++++++++++++
>  net/core/dev.c               |   2 +-
>  net/core/filter.c            | 100 +++++++++++++++++++++++++++++++++--
>  5 files changed, 195 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 306869d4743b..74e7e2f89251 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -423,6 +423,9 @@ struct bpf_verifier_env {
>  	u32 peak_states;
>  	/* longest register parentage chain walked for liveness marking */
>  	u32 longest_mark_read_walk;
> +	/* Are all leaf nodes redirect_map? */
> +	bool all_leaves_redirect;
> +	u32 redirect_call_cnt;
>  };
>=20=20
>  __printf(2, 0) void bpf_verifier_vlog(struct bpf_verifier_log *log,
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 1b62397bd124..6509ced898a2 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -534,7 +534,8 @@ struct bpf_prog {
>  				kprobe_override:1, /* Do we override a kprobe? */
>  				has_callchain_buf:1, /* callchain buffer allocated? */
>  				enforce_expected_attach_type:1, /* Enforce expected_attach_type chec=
king at attach time */
> -				call_get_stack:1; /* Do we call bpf_get_stack() or bpf_get_stackid()=
 */
> +				call_get_stack:1, /* Do we call bpf_get_stack() or bpf_get_stackid()=
 */
> +				redirect_opt:1; /* All bpf_redirect{,_map}() are leaf calls */
>  	enum bpf_prog_type	type;		/* Type of BPF program */
>  	enum bpf_attach_type	expected_attach_type; /* For some prog types */
>  	u32			len;		/* Number of filter blocks */
> @@ -622,6 +623,8 @@ struct bpf_redirect_info {
>  	struct bpf_map *map;
>  	u32 kern_flags;
>  	struct bpf_nh_params nh;
> +	const struct bpf_prog *xdp_prog_redirect_opt;
> +	struct xdp_buff *xdp;
>  };
>=20=20
>  DECLARE_PER_CPU(struct bpf_redirect_info, bpf_redirect_info);
> @@ -734,6 +737,13 @@ DECLARE_BPF_DISPATCHER(xdp)
>  static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>  					    struct xdp_buff *xdp)
>  {
> +	if (prog->redirect_opt) {
> +		struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> +
> +		ri->xdp_prog_redirect_opt =3D prog;
> +		ri->xdp =3D xdp;
> +	}
> +
>  	/* Caller needs to hold rcu_read_lock() (!), otherwise program
>  	 * can be released while still running, or map elements could be
>  	 * freed early while still having concurrent users. XDP fastpath
> @@ -743,6 +753,11 @@ static __always_inline u32 bpf_prog_run_xdp(const st=
ruct bpf_prog *prog,
>  	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
>  }
>=20=20
> +static __always_inline u32 bpf_prog_run_xdp_skb(const struct bpf_prog *p=
rog, struct xdp_buff *xdp)
> +{
> +	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
> +}
> +
>  void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *pr=
og);
>=20=20
>  static inline u32 bpf_prog_insn_size(const struct bpf_prog *prog)
> @@ -951,9 +966,16 @@ static inline int xdp_ok_fwd_dev(const struct net_de=
vice *fwd,
>   */
>  int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
>  			    struct xdp_buff *xdp, struct bpf_prog *prog);
> -int xdp_do_redirect(struct net_device *dev,
> -		    struct xdp_buff *xdp,
> -		    struct bpf_prog *prog);
> +int __xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp, stru=
ct bpf_prog *prog);
> +static inline int xdp_do_redirect(struct net_device *dev, struct xdp_buf=
f *xdp,
> +				  struct bpf_prog *prog)
> +{
> +	if (prog->redirect_opt)
> +		return 0;
> +
> +	return __xdp_do_redirect(dev, xdp, prog);
> +}
> +
>  void xdp_do_flush(void);
>=20=20
>  /* The xdp_do_flush_map() helper has been renamed to drop the _map suffi=
x, as
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index e333ce43f281..9ede6f1bca37 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5032,6 +5032,58 @@ static int check_reference_leak(struct bpf_verifie=
r_env *env)
>  	return state->acquired_refs ? -EINVAL : 0;
>  }
>=20=20
> +static void check_redirect_opt(struct bpf_verifier_env *env, int func_id=
, int insn_idx)
> +{

I like the simplicity of this check - sure it can be made more
elaborate, but this is a good place to start.

> +	struct bpf_insn *insns =3D env->prog->insnsi;
> +	int insn_cnt =3D env->prog->len;
> +	struct bpf_insn *insn;
> +	bool is_leaf =3D false;
> +
> +	if (!(func_id =3D=3D BPF_FUNC_redirect || func_id =3D=3D BPF_FUNC_redir=
ect_map))
> +		return;
> +
> +	/* Naive peephole leaf node checking */
> +	insn_idx++;
> +	if (insn_idx >=3D insn_cnt)
> +		return;
> +
> +	insn =3D &insns[insn_idx];
> +	switch (insn->code) {
> +	/* Is the instruction following the call, an exit? */
> +	case BPF_JMP | BPF_EXIT:
> +		is_leaf =3D true;
> +		break;
> +	/* Follow the true branch of "if return value (r/w0) is not
> +	 * zero", and look for exit.
> +	 */
> +	case BPF_JMP | BPF_JSGT | BPF_K:
> +	case BPF_JMP32 | BPF_JSGT | BPF_K:
> +	case BPF_JMP | BPF_JGT | BPF_K:
> +	case BPF_JMP32 | BPF_JGT | BPF_K:
> +	case BPF_JMP | BPF_JNE | BPF_K:
> +	case BPF_JMP32 | BPF_JNE | BPF_K:
> +		if (insn->dst_reg =3D=3D BPF_REG_0 && insn->imm =3D=3D 0) {
> +			insn_idx +=3D insn->off + 1;
> +			if (insn_idx >=3D insn_cnt)
> +				break;
> +
> +			insn =3D &insns[insn_idx];
> +			is_leaf =3D insn->code =3D=3D (BPF_JMP | BPF_EXIT);
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (!env->redirect_call_cnt++) {
> +		env->all_leaves_redirect =3D is_leaf;
> +		return;
> +	}
> +
> +	if (!is_leaf)
> +		env->all_leaves_redirect =3D false;
> +}
> +
>  static int check_helper_call(struct bpf_verifier_env *env, int func_id, =
int insn_idx)
>  {
>  	const struct bpf_func_proto *fn =3D NULL;
> @@ -5125,6 +5177,8 @@ static int check_helper_call(struct bpf_verifier_en=
v *env, int func_id, int insn
>  		}
>  	}
>=20=20
> +	check_redirect_opt(env, func_id, insn_idx);
> +
>  	regs =3D cur_regs(env);
>=20=20
>  	/* check that flags argument in get_local_storage(map, flags) is 0,
> @@ -11894,6 +11948,17 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
>  	return 0;
>  }
>=20=20
> +static void validate_redirect_opt(struct bpf_verifier_env *env)
> +{
> +	if (env->subprog_cnt !=3D 1)
> +		return;
> +
> +	if (env->subprog_info[0].has_tail_call)
> +		return;
> +
> +	env->prog->redirect_opt =3D env->all_leaves_redirect;
> +}
> +
>  struct btf *bpf_get_btf_vmlinux(void)
>  {
>  	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
> @@ -12092,6 +12157,9 @@ int bpf_check(struct bpf_prog **prog, union bpf_a=
ttr *attr,
>  	if (ret =3D=3D 0)
>  		adjust_btf_func(env);
>=20=20
> +	if (ret =3D=3D 0)
> +		validate_redirect_opt(env);
> +
>  err_release_maps:
>  	if (!env->prog->aux->used_maps)
>  		/* if we didn't copy map pointers into bpf_prog_info, release
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3b6b0e175fe7..d31f97ea955b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4654,7 +4654,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff=
 *skb,
>  	rxqueue =3D netif_get_rxqueue(skb);
>  	xdp->rxq =3D &rxqueue->xdp_rxq;
>=20=20
> -	act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> +	act =3D bpf_prog_run_xdp_skb(xdp_prog, xdp);
>=20=20
>  	/* check if bpf_xdp_adjust_head was used */
>  	off =3D xdp->data - orig_data;
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..f5a0d29aa272 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3981,8 +3981,8 @@ void bpf_clear_redirect_map(struct bpf_map *map)
>  	}
>  }
>=20=20
> -int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> -		    struct bpf_prog *xdp_prog)
> +int __xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> +		      struct bpf_prog *xdp_prog)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
>  	struct bpf_map *map =3D READ_ONCE(ri->map);
> @@ -4015,7 +4015,7 @@ int xdp_do_redirect(struct net_device *dev, struct =
xdp_buff *xdp,
>  	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, map, index, err);
>  	return err;
>  }
> -EXPORT_SYMBOL_GPL(xdp_do_redirect);
> +EXPORT_SYMBOL_GPL(__xdp_do_redirect);
>=20=20
>  static int xdp_do_generic_redirect_map(struct net_device *dev,
>  				       struct sk_buff *skb,
> @@ -4091,6 +4091,36 @@ int xdp_do_generic_redirect(struct net_device *dev=
, struct sk_buff *skb,
>  	return err;
>  }
>=20=20
> +static u64 __bpf_xdp_redirect_opt(u32 index, struct bpf_redirect_info *r=
i)
> +{
> +	const struct bpf_prog *xdp_prog;
> +	struct net_device *fwd, *dev;
> +	struct xdp_buff *xdp;
> +	int err;
> +
> +	xdp_prog =3D ri->xdp_prog_redirect_opt;
> +	xdp =3D ri->xdp;
> +	dev =3D xdp->rxq->dev;
> +
> +	ri->xdp_prog_redirect_opt =3D NULL;
> +
> +	fwd =3D dev_get_by_index_rcu(dev_net(dev), index);
> +	if (unlikely(!fwd)) {
> +		err =3D -EINVAL;
> +		goto err;
> +	}
> +
> +	err =3D dev_xdp_enqueue(fwd, xdp, dev);
> +	if (unlikely(err))
> +		goto err;
> +
> +	_trace_xdp_redirect_map(dev, xdp_prog, fwd, NULL, index);
> +	return XDP_REDIRECT;
> +err:
> +	_trace_xdp_redirect_map_err(dev, xdp_prog, fwd, NULL, index, err);
> +	return XDP_ABORTED;
> +}
> +
>  BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
>  {
>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> @@ -4098,6 +4128,9 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, fla=
gs)
>  	if (unlikely(flags))
>  		return XDP_ABORTED;
>=20=20
> +	if (ri->xdp_prog_redirect_opt)
> +		return __bpf_xdp_redirect_opt(ifindex, ri);
> +
>  	ri->flags =3D flags;
>  	ri->tgt_index =3D ifindex;
>  	ri->tgt_value =3D NULL;
> @@ -4114,6 +4147,64 @@ static const struct bpf_func_proto bpf_xdp_redirec=
t_proto =3D {
>  	.arg2_type      =3D ARG_ANYTHING,
>  };
>=20=20
> +static u64 __bpf_xdp_redirect_map_opt(struct bpf_map *map, u32 index, u6=
4 flags,
> +				      struct bpf_redirect_info *ri)
> +{
> +	const struct bpf_prog *xdp_prog;
> +	struct net_device *dev;
> +	struct xdp_buff *xdp;
> +	void *val;
> +	int err;
> +
> +	xdp_prog =3D ri->xdp_prog_redirect_opt;
> +	xdp =3D ri->xdp;
> +	dev =3D xdp->rxq->dev;
> +
> +	ri->xdp_prog_redirect_opt =3D NULL;
> +
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP: {
> +		val =3D __dev_map_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err =3D dev_map_enqueue(val, xdp, dev);
> +		break;
> +	}
> +	case BPF_MAP_TYPE_DEVMAP_HASH: {
> +		val =3D __dev_map_hash_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err =3D dev_map_enqueue(val, xdp, dev);
> +		break;
> +	}
> +	case BPF_MAP_TYPE_CPUMAP: {
> +		val =3D __cpu_map_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err =3D cpu_map_enqueue(val, xdp, dev);
> +		break;
> +	}
> +	case BPF_MAP_TYPE_XSKMAP: {
> +		val =3D __xsk_map_lookup_elem(map, index);
> +		if (unlikely(!val))
> +			return flags;
> +		err =3D __xsk_map_redirect(val, xdp);
> +		break;
> +	}

This seems like an awful lot of copy-paste code reuse. Why not keep the
__xdp_map_lookup_elem() (and flags handling) in bpf_xdp_redirect_map()
and call this function after that lookup (using ri->tgt_value since
you're passing in ri anyway)? Similarly, __bpf_tx_xdp_map() already does
the disambiguation on map type for enqueue that you are duplicating here.

I realise there may be some performance benefit to the way this is
structured (assuming the compiler is not smart enough to optimise the
code into basically the same thing as this), but at the very least I'd
like to see the benefit quantified before accepting this level of code
duplication :)

-Toke

