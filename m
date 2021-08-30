Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D57A3FBD40
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 22:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhH3UCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbhH3UCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 16:02:23 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A667AC061575;
        Mon, 30 Aug 2021 13:01:29 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id k24so14481125pgh.8;
        Mon, 30 Aug 2021 13:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5pL2hO5916vdEq3jqoZPUnBxJADCo06t1E/K7umqVws=;
        b=UPOEJXDdY3EpsVIBNLIhj1apE0Ae85EdOHJTaQ56uLSkATAsnzGbemHnsHsOYiulhK
         m4NpGYF0eah5+MXoaJmfWIYAs1dENJCP2SOTcqXzZuH2fL/mKNWgkcqb4YVzCvzJxb60
         hSoEDgDNZtN8CWu03sacZdNjQM4gI7PnMxgUlEGJ9/5pvhMcmUQAjN1aAVQ25Tg0Ocue
         Zn4PBUIm+ZpqTrdo/28iQ7+C96Cwer2k+YMhMrsuW7MOpKkAaZee1TiBs3e9qLG7nyA0
         AVPLSEynvExiURXDv3hhaBGUNhjeyvR8F9ajVVWRigr3B69kQkkWDh0zA0Z6ddEmXy3w
         zhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5pL2hO5916vdEq3jqoZPUnBxJADCo06t1E/K7umqVws=;
        b=jIJU1L2yme0QRpVuDZQrlPZENAi4J8eKrj05qoJu92tLu+heo9QDddiXviswypPdQI
         eNlpSJ+XmQWVah0kzD9GUoCGxW4uOCwki3ZIBlfHzSV+ebZxXyYKjva0xjw5Gq4s28j1
         J7lYlZdJYhShf3qxN59kcPtR/L3T+o7dMDXhYKoVFnv88YPbsK6BgnA9xjJephjcGgkM
         1nzdB3O5SQ4kDIJxNH4ah0AFF3C32kNBgeIK55e2uV4fEf1u5o0EQozKk01NxB3LqlzV
         8GB1mzEfQVLXuf8scAW/oQpVTZaoBH5VWnYG51Q32ctJgpKuAQdp06CS+sNUWPkpWprX
         5y1w==
X-Gm-Message-State: AOAM532UaqqFLxwMgAIqZedMokqBfU7wBSTja/ZudPtN67VqIVA7fAKS
        d9KBBW9iuf7O8My6A1C3PtI=
X-Google-Smtp-Source: ABdhPJzhMp0b9OASVIDSdBcdPIONqOMkTXCEaphpcVA6geoeHNCofTJTl9d3ckawTEsr8YfJUFb9wA==
X-Received: by 2002:aa7:8c17:0:b0:3fe:bb5c:4556 with SMTP id c23-20020aa78c17000000b003febb5c4556mr7864219pfd.48.1630353689088;
        Mon, 30 Aug 2021 13:01:29 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4106])
        by smtp.gmail.com with ESMTPSA id f18sm5331195pfc.161.2021.08.30.13.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 13:01:28 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:01:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next RFC v1 1/8] bpf: Introduce BPF support for
 kernel module function calls
Message-ID: <20210830200123.lsdkoa5rfmfj3xts@ast-mbp.dhcp.thefacebook.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
 <20210830173424.1385796-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830173424.1385796-2-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:04:17PM +0530, Kumar Kartikeya Dwivedi wrote:
> This change adds support on the kernel side to allow for BPF programs to
> call kernel module functions. Userspace will prepare an array of module
> BTF fds that is passed in during BPF_PROG_LOAD. In the kernel, the
> module BTF array is placed in the auxilliary struct for bpf_prog.
> 
> The verifier then uses insn->off to index into this table. insn->off is
> used by subtracting one from it, as userspace has to set the index of
> array in insn->off incremented by 1. This lets us denote vmlinux btf by
> insn->off == 0, and the prog->aux->kfunc_btf_tab[insn->off - 1] for
> module BTFs.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/linux/filter.h         |  9 ++++
>  include/uapi/linux/bpf.h       |  3 +-
>  kernel/bpf/core.c              | 14 ++++++
>  kernel/bpf/syscall.c           | 55 +++++++++++++++++++++-
>  kernel/bpf/verifier.c          | 85 ++++++++++++++++++++++++++--------
>  tools/include/uapi/linux/bpf.h |  3 +-
>  7 files changed, 147 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f4c16f19f83e..39f59e5f3a26 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -874,6 +874,7 @@ struct bpf_prog_aux {
>  	void *jit_data; /* JIT specific data. arch dependent */
>  	struct bpf_jit_poke_descriptor *poke_tab;
>  	struct bpf_kfunc_desc_tab *kfunc_tab;
> +	struct bpf_kfunc_btf_tab *kfunc_btf_tab;
>  	u32 size_poke_tab;
>  	struct bpf_ksym ksym;
>  	const struct bpf_prog_ops *ops;
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 7d248941ecea..46451891633d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -592,6 +592,15 @@ struct bpf_prog {
>  	struct bpf_insn		insnsi[];
>  };
>  
> +#define MAX_KFUNC_DESCS 256
> +/* There can only be at most MAX_KFUNC_DESCS module BTFs for kernel module
> + * function calls.
> + */
> +struct bpf_kfunc_btf_tab {
> +	u32 nr_btfs;
> +	struct btf_mod_pair btfs[];
> +};
> +
>  struct sk_filter {
>  	refcount_t	refcnt;
>  	struct rcu_head	rcu;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 791f31dd0abe..4cbb2082a553 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1334,8 +1334,9 @@ union bpf_attr {
>  			/* or valid module BTF object fd or 0 to attach to vmlinux */
>  			__u32		attach_btf_obj_fd;
>  		};
> -		__u32		:32;		/* pad */
> +		__u32		kfunc_btf_fds_cnt; /* reuse hole for count of BTF fds below */

No need for size.

>  		__aligned_u64	fd_array;	/* array of FDs */
> +		__aligned_u64   kfunc_btf_fds;  /* array of BTF FDs for module kfunc support */

Just reuse fd_array. No need for another array of FDs.

> +		tab = prog->aux->kfunc_btf_tab;
> +		for (i = 0; i < n; i++) {
> +			struct btf_mod_pair *p;
> +			struct btf *mod_btf;
> +
> +			mod_btf = btf_get_by_fd(fds[i]);
> +			if (IS_ERR(mod_btf)) {
> +				err = PTR_ERR(mod_btf);
> +				goto free_prog;
> +			}
> +			if (!btf_is_module(mod_btf)) {
> +				err = -EINVAL;
> +				btf_put(mod_btf);
> +				goto free_prog;
> +			}

just do that dynamically like access to fd_array is handled in other places.
no need to preload.
