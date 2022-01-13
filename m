Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD25B48E046
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 23:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiAMWcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 17:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiAMWcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 17:32:14 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F3CC061574;
        Thu, 13 Jan 2022 14:32:14 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i129so1131859pfe.13;
        Thu, 13 Jan 2022 14:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZSn3rKTmi6wW6+xPj+4/2r0fgxQebadQhpxJC1+1Tvo=;
        b=hBY5YddTm0P7IsZZ1oeU6w2QoYP4L4C3MhEoN3zmhmU/mDKQqsn1qcCqqWTMPa/f7+
         xNXO33vOI8qlFlTvZzAjzPkzQkV2cwMl7Ejg8rFis4CwseC9abg2KbuoXFUL6Qhv4npI
         1cSO/EQNMgRZ6FbeiKj9woM/v97gy3nu0+1IcpobFokr6R0sDoJjnpfmhkMyGgmx1A8a
         I6S6xiN9RsuHIiH+eGiJB9qRvFQnW/OoCR6mrwR4FZZdbKdkfQKs56rfASlJocY07a/O
         g+nr+LZ1L364aUa2L+smB+zYnp7LXqnkoKxI0v4ztSNkmQ9VScmzAMC7JmJkG1xrQ8OB
         TleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZSn3rKTmi6wW6+xPj+4/2r0fgxQebadQhpxJC1+1Tvo=;
        b=YPmqBJLQEp6kaVBXtb5bRuIt2ZL8h9/k8N1hOSiqtsmpl7jxE6wGhHJ0f7vwqqbbuw
         tSfho5+W/xasQAtje6mBFgymRMoA+9vu8Y+houCPGqn+bPoffvMpiWuQ/V5nqdstRYZG
         ruH/C4NYWX9QNJHACfwh1s9Q6Qc+sbLcC86yLe0wnwwUY2jbi9pMLnoCViECyp7FU2p8
         ZlaHw3Es9TCxbcQeOJ4Lh5BuryylOxVGVi+IIuupZBENCmMjTzhjdAZethnVkD1PuqRa
         IA28QmhAaaiF6YZJKMvh1Tm38tQfW2F1F6PfffB7AmmOBXtj96c0yNpdiGnIiPpA/TWf
         bGkA==
X-Gm-Message-State: AOAM531r9ATeFEYFHjOEWyuuv0Igd/G3H70A/KZVw1OuY44r1a0RB37v
        3Bc9DPFJrMnqiyMtJZhCGMc=
X-Google-Smtp-Source: ABdhPJwlNGP5tM/qXX+x/J44PN7W+Hy+V3oFobqX3JZMmgbs2z+wA5SPblUvDPiSHZW3BMiwbYV+6w==
X-Received: by 2002:a63:7d43:: with SMTP id m3mr3215871pgn.301.1642113134257;
        Thu, 13 Jan 2022 14:32:14 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5547])
        by smtp.gmail.com with ESMTPSA id g7sm3666264pfu.61.2022.01.13.14.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 14:32:13 -0800 (PST)
Date:   Thu, 13 Jan 2022 14:32:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v7 02/10] bpf: Populate kfunc BTF ID sets in
 struct btf
Message-ID: <20220113223211.s2m5fkvafd6fk4tv@ast-mbp.dhcp.thefacebook.com>
References: <20220111180428.931466-1-memxor@gmail.com>
 <20220111180428.931466-3-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111180428.931466-3-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 11:34:20PM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h     |  46 ++++++++
>  include/linux/btf_ids.h |  13 ++-
>  kernel/bpf/btf.c        | 253 +++++++++++++++++++++++++++++++++++++++-
>  kernel/bpf/verifier.c   |   1 +
>  4 files changed, 305 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 0c74348cbc9d..95a8238272af 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -12,11 +12,40 @@
>  #define BTF_TYPE_EMIT(type) ((void)(type *)0)
>  #define BTF_TYPE_EMIT_ENUM(enum_val) ((void)enum_val)
>  
> +enum btf_kfunc_hook {
> +	BTF_KFUNC_HOOK_XDP,
> +	BTF_KFUNC_HOOK_TC,
> +	BTF_KFUNC_HOOK_STRUCT_OPS,
> +	BTF_KFUNC_HOOK_MAX,
> +};

The enum doesn't have to be in .h, right?
Would be cleaner to reduce its scope to btf.c

>  		 */
> -		if ((btf_mod->flags & BTF_MODULE_F_LIVE) && try_module_get(btf_mod->module))
> +		if ((btf_mod->flags & BTF_MODULE_F_LIVE) && try_module_get(btf_mod->module)) {
> +			/* pairs with smp_wmb in register_btf_kfunc_id_set */
> +			smp_rmb();

Doesn't look necessary. More below.

> +/* This function must be invoked only from initcalls/module init functions */
> +int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
> +			      const struct btf_kfunc_id_set *kset)
> +{
> +	enum btf_kfunc_hook hook;
> +	struct btf *btf;
> +	int ret;
> +
> +	btf = btf_get_module_btf(kset->owner);
> +	if (IS_ERR_OR_NULL(btf))
> +		return btf ? PTR_ERR(btf) : -ENOENT;
> +
> +	hook = bpf_prog_type_to_kfunc_hook(prog_type);
> +	ret = btf_populate_kfunc_set(btf, hook, kset);
> +	/* Make sure all updates are visible before we go to MODULE_STATE_LIVE,
> +	 * pairs with smp_rmb in btf_try_get_module (for success case).
> +	 *
> +	 * btf_populate_kfunc_set(...)
> +	 * smp_wmb()	<-----------.
> +	 * mod->state = LIVE	    |		if (mod->state == LIVE)
> +	 *			    |		  atomic_inc_nz(mod)
> +	 *			    `--------->	  smp_rmb()
> +	 *					  btf_kfunc_id_set_contains(...)
> +	 */
> +	smp_wmb();

This comment somehow implies that mod->state = LIVE
and if (mod->state == LIVE && try_mod_get) can race.
That's not the case.
The patch 1 closed the race.
btf_kfunc_id_set_contains() will be called only on LIVE modules.
At that point all __init funcs of the module including register_btf_kfunc_id_set()
have completed.
This smp_wmb/rmb pair serves no purpose.
Unless I'm missing something?

> +	/* reference is only taken for module BTF */
> +	if (btf_is_module(btf))
> +		btf_put(btf);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
>  
>  #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
>  
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index bfb45381fb3f..b5ea73560a4d 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1783,6 +1783,7 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
>  
>  		mod = btf_try_get_module(btf);
>  		if (!mod) {
> +			verbose(env, "failed to get reference for BTF's module\n");

This one is highly unlikely, right?
One can see it only with a specially crafted test like patch 10.
Normal users will never see it. Why add it then?
Also there are two places in verifier.c that calls btf_try_get_module().
If it's a real concern, both places should have verbose().
But I would not add it in either.
