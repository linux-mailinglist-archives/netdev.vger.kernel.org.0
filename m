Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099D236CACA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbhD0SCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhD0SCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 14:02:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C96C061574;
        Tue, 27 Apr 2021 11:02:06 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c17so7289702pfn.6;
        Tue, 27 Apr 2021 11:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NF7e3+UHeX1iyIfc/ldSHIG5+xZ/G8gxf7RUQdAM2aY=;
        b=R+EhvPd8RK4mArkNKTuRmK3/+pjpJ1Z0EsuldxndlAJV7rqPbqL6MEDb5+mkgNcjpo
         Ezekf+4scsOz97HJ1L/BR713ycfKy1UtTkSte1lKL5vTH8OxYWen3neJgh5fstOaE8HN
         pBMgoyWj/m60hwW5o47zQKZimy+pnMHLxAbCFeYiaTorGznwqlg9fU6uLO1fATOHG/Wv
         fMl9TJjbhGuLk9B7kaphCvEVbGYbOQltqjp1gsr419oI2JwQGIJDkZ0ClvwCpEVj5ls9
         yA4wndEl6VeKfCundYvwwt+h3ni9dpO8zMjARvae+uSf6i88ldhD+lsWDwu/NEey2b+W
         QHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NF7e3+UHeX1iyIfc/ldSHIG5+xZ/G8gxf7RUQdAM2aY=;
        b=UX+j0atIpxNMbMnRta4UI0ZCDI63c7DYkdF0lbvg0gJg6m+UJo48SdgVf01i8Yqtcu
         erFHLNtDog3sOckBbvcSLf3nTeS3kzoAAMEHc5+zU1535nVFXBqBO4xwPht2sB5I9fEa
         9MnoFiO+aCZTbrcAzOckmdjCO6rNYiGUyxK0/6I2QIIMYVva5gpFLWTnL7anNNIW3rSJ
         cwa3h1EiHaMoxZdNcA+TfJmwXPll6HV0TQ2WQI+Lby9rACyvfcc5XUJrEmtd/Mlrquh+
         V1/z/L1R3WclgaRyKe4Fi6OeSxta0OGmlhd9pHEx/H2TwS75moEAjDhJRuyMDFdayyg0
         hhEw==
X-Gm-Message-State: AOAM5307Ea3iFqBqpyXnwYBf4rgjgGbgH6q45niNhoDKtZCT5RqkkhMT
        ozRRZN9f6eqdMo8KtVyp3hE=
X-Google-Smtp-Source: ABdhPJzLMCcg9PYjIKGVO70A48bQiyKI00LDfuQ25YYQMs+bK0G3coPSFeQdKQVFeUEMVguyzwgmdg==
X-Received: by 2002:aa7:908c:0:b029:250:b584:a406 with SMTP id i12-20020aa7908c0000b0290250b584a406mr24096327pfa.44.1619546525759;
        Tue, 27 Apr 2021 11:02:05 -0700 (PDT)
Received: from localhost ([47.15.118.129])
        by smtp.gmail.com with ESMTPSA id g24sm371139pgn.18.2021.04.27.11.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 11:02:05 -0700 (PDT)
Date:   Tue, 27 Apr 2021 23:32:02 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210427180202.pepa2wdbhhap3vyg@apollo>
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 08:34:30PM IST, Daniel Borkmann wrote:
> On 4/23/21 5:05 PM, Kumar Kartikeya Dwivedi wrote:
> [...]
> >   tools/lib/bpf/libbpf.h   |  92 ++++++++
> >   tools/lib/bpf/libbpf.map |   5 +
> >   tools/lib/bpf/netlink.c  | 478 ++++++++++++++++++++++++++++++++++++++-
> >   3 files changed, 574 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index bec4e6a6e31d..1c717c07b66e 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -775,6 +775,98 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
> >   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> >   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> >
> > +enum bpf_tc_attach_point {
> > +	BPF_TC_INGRESS,
> > +	BPF_TC_EGRESS,
> > +	BPF_TC_CUSTOM_PARENT,
> > +	_BPF_TC_PARENT_MAX,
>
> I don't think we need to expose _BPF_TC_PARENT_MAX as part of the API, I would drop
> the latter.
>

Ok, will drop.

> > +};
> > +
> > +/* The opts structure is also used to return the created filters attributes
> > + * (e.g. in case the user left them unset). Some of the options that were left
> > + * out default to a reasonable value, documented below.
> > + *
> > + *	protocol - ETH_P_ALL
> > + *	chain index - 0
> > + *	class_id - 0 (can be set by bpf program using skb->tc_classid)
> > + *	bpf_flags - TCA_BPF_FLAG_ACT_DIRECT (direct action mode)
> > + *	bpf_flags_gen - 0
> > + *
> > + *	The user must fulfill documented requirements for each function.
>
> Not sure if this is overly relevant as part of the bpf_tc_opts in here. For the
> 2nd part, I would probably just mention that libbpf internally attaches the bpf
> programs with direct action mode. The hw offload may be future todo, and the other
> bits are little used anyway; mentioning them here, what value does it have to
> libbpf users? I'd rather just drop the 2nd part and/or simplify this paragraph
> just stating that the progs are attached in direct action mode.
>

The goal was to just document whatever attributes were set to by default, but I can see
your point. I'll trim it.

> > + */
> > +struct bpf_tc_opts {
> > +	size_t sz;
> > +	__u32 handle;
> > +	__u32 parent;
> > +	__u16 priority;
> > +	__u32 prog_id;
> > +	bool replace;
> > +	size_t :0;
> > +};
> > +
> > +#define bpf_tc_opts__last_field replace
> > +
> > +struct bpf_tc_ctx;
> > +
> > +struct bpf_tc_ctx_opts {
> > +	size_t sz;
> > +};
> > +
> > +#define bpf_tc_ctx_opts__last_field sz
> > +
> > +/* Requirements */
> > +/*
> > + * @ifindex: Must be > 0.
> > + * @parent: Must be one of the enum constants < _BPF_TC_PARENT_MAX
> > + * @opts: Can be NULL, currently no options are supported.
> > + */
>
> Up to Andrii, but we don't have such API doc in general inside libbpf.h, I
> would drop it for the time being to be consistent with the rest (same for
> others below).
>

I think we need to keep this somewhere. We dropped bpf_tc_info since it wasn't
really serving any purpose, but that meant we would put the only extra thing it
returned (prog_id) into bpf_tc_opts. That means we also need to take care that
it is unset (along with replace) in functions where it isn't used, to allow for
reuse for some future purpose. If we don't document that the user needs to unset
them whenever working with bpf_tc_query and bpf_tc_detach, how are they supposed
to know?

Maybe a man page and/or a blog post would be better? Just putting it above the
function seemed best for now.

> > +LIBBPF_API struct bpf_tc_ctx *bpf_tc_ctx_init(__u32 ifindex,
>
> nit: in user space s/__u32 ifindex/int ifindex/
>

Ok.

> > +					      enum bpf_tc_attach_point parent,
> > +					      struct bpf_tc_ctx_opts *opts);
>
> Should we enforce opts being NULL or non-NULL here, or drop the arg from here
> for now altogether? (And if later versions of the functions show up this could
> be mapped to the right one?)
>

I can enforce it to be NULL for now, but I'd rather keep it this way than add
another with opts later. The way this works, you could extend it to attach
other kinds of qdiscs (by taking a simple config in opts), which I think can be
very useful.

> > +/*
> > + * @ctx: Can be NULL, if not, must point to a valid object.
> > + *	 If the qdisc was attached during ctx_init, it will be deleted if no
> > + *	 filters are attached to it.
> > + *	 When ctx == NULL, this is a no-op.
> > + */
> > +LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
> > +/*
> > + * @ctx: Cannot be NULL.
> > + * @fd: Must be >= 0.
> > + * @opts: Cannot be NULL, prog_id must be unset, all other fields can be
> > + *	  optionally set. All fields except replace  will be set as per created
> > + *        filter's attributes. parent must only be set when attach_point of ctx is
> > + *        BPF_TC_CUSTOM_PARENT, otherwise parent must be unset.
> > + *
> > + * Fills the following fields in opts:
> > + *	handle
> > + *	parent
> > + *	priority
> > + *	prog_id
> > + */
> > +LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
> > +			     struct bpf_tc_opts *opts);
> > +/*
> > + * @ctx: Cannot be NULL.
> > + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
> > + *	  must be set.
> > + */
> > +LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
> > +			     const struct bpf_tc_opts *opts);
>
> One thing that I find a bit odd from this API is that BPF_TC_INGRESS / BPF_TC_EGRESS
> needs to be set each time via bpf_tc_ctx_init(). So whenever a specific program would
> be attached to both we need to 're-init' in between just to change from hook a to b,
> whereas when you have BPF_TC_CUSTOM_PARENT, you could just use a different opts->parent
> without going this detour (unless the clsact wasn't loaded there in the first place).
>

Currently I check that opts->parent is unset when BPF_TC_INGRESS or BPF_TC_EGRESS
is set as attach point. But since both map to clsact, we could allow the user to
specify opts->parent as BPF_TC_INGRESS or BPF_TC_EGRESS (no need to use
TC_H_MAKE, we can detect it from ctx->parent that it won't be a parent id). This
would mean that by default attach point is what you set for ctx, but for
bpf_tc_attach you can temporarily override to be some other attach point (for
the same qdisc). You still won't be able to set anything other than the two
though.

> Could we add a BPF_TC_UNSPEC to enum bpf_tc_attach_point, which the user would pass to
> bpf_tc_ctx_init(), so that opts.direction = BPF_TC_INGRESS with subsequent bpf_tc_attach()
> can be called, and same opts.direction = BPF_TC_EGRESS with bpf_tc_attach() for different
> fd. The only thing we cared about in bpf_tc_ctx_init() resp. the ctx was that qdisc was
> ready.
>
> > +/*
> > + * @ctx: Cannot be NULL.
> > + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
> > + *	  must be set.
> > + *
> > + * Fills the following fields in opts:
> > + *	handle
> > + *	parent
> > + *	priority
> > + *	prog_id
> > + */
> > +LIBBPF_API int bpf_tc_query(struct bpf_tc_ctx *ctx,
> > +			    struct bpf_tc_opts *opts);
> > +
> >   #ifdef __cplusplus
> >   } /* extern "C" */
> >   #endif

--
Kartikeya
