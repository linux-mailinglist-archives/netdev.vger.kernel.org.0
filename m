Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A3536CC68
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbhD0UhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbhD0UhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:37:08 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5B3C061574;
        Tue, 27 Apr 2021 13:36:24 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 82so71037340yby.7;
        Tue, 27 Apr 2021 13:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TX+ocx5m+B3mBT8f6FXxNCukxTMN/uZAeQddLGbGz4U=;
        b=kQubP+kelKlfLKP/IJh4xrm3h745FkzDr5Jp6I4Attv+LqBhWrI902uaZo34+bESb0
         aV3E6fOrs6qeGydQ04/VmGJ/fI80zAgBQyjcPFKt391kwsqc5dUBK0YwrFY5jQsvmBuJ
         GsIOZ4MmEe4BmVdjBHZSypLsU97oUW38XXtDjqIIm7RGXQAk/VJDqJln+vBfTQbGVJ5F
         ZrhhyxI1jpd93D+Kpt0P2CE80Bn+M+VCwc5nYr9x83fnFknjuFKM+WgOUMXlApy4F2of
         nDW7/kx1F/P+DEzfI/GiCUhK1AFXLWRJPUAUq6AacSqTfDYzVUo2DZu9dFwyD8Esc+M7
         ho5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TX+ocx5m+B3mBT8f6FXxNCukxTMN/uZAeQddLGbGz4U=;
        b=eaQyKWLt2DwQ3RGKsYMqrA4xaCceMyWwku/uwjI78wgonC3dNkcm8UKEFhdt3/HuPt
         UEhoCnXYKTcjYtIUOoNCPtzYUNbro7E9F2mfcB1WXNuLaDx1LYsBhRSPGNvRKFxDJrnf
         REAfX/RcHMZMdTUn5iowfHbYUhgesDB2nnJPsp7YziXcGiEQ/Z2Dp2epUxvJAOYmRaHY
         xwFCQvoy2BExXWfMWZNxfN0iVzfU/nrZaGgnRoQ/hfposH4f5C/B97zKI8pzcxQB0/dM
         wfktTjiY5AtZhhrr5PE+tVzDRxbk/DF8BgLvwidDV6roeX+sUXIfILc16FaBqdVHUsF/
         BAEQ==
X-Gm-Message-State: AOAM5321GIqUiyEh2a0/O7uE8WdrSzVB/EPgWmMNQZUoQJMJMpUhnWsB
        ONQnq7s4p5fEWJmaHDSF9kmexSXxjCzgj4Ad10s=
X-Google-Smtp-Source: ABdhPJxFVuH+Pyd502vLIn81FK30BXHWqjOpRldxj2C5cKILBPk/UHwAlTstxqZRz4HESSxe2LAoiIcJ2qzohrut5Ow=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr35348801ybf.425.1619555783301;
 Tue, 27 Apr 2021 13:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210423150600.498490-1-memxor@gmail.com> <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
In-Reply-To: <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 13:36:12 -0700
Message-ID: <CAEf4BzZzJQ+bewwYBtbacCv+x-hjstvQtEGO3jt+0Y4NK_7V=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 8:04 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
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
> > +     BPF_TC_INGRESS,
> > +     BPF_TC_EGRESS,
> > +     BPF_TC_CUSTOM_PARENT,
> > +     _BPF_TC_PARENT_MAX,
>
> I don't think we need to expose _BPF_TC_PARENT_MAX as part of the API, I would drop
> the latter.
>
> > +};
> > +
> > +/* The opts structure is also used to return the created filters attributes
> > + * (e.g. in case the user left them unset). Some of the options that were left
> > + * out default to a reasonable value, documented below.
> > + *
> > + *   protocol - ETH_P_ALL
> > + *   chain index - 0
> > + *   class_id - 0 (can be set by bpf program using skb->tc_classid)
> > + *   bpf_flags - TCA_BPF_FLAG_ACT_DIRECT (direct action mode)
> > + *   bpf_flags_gen - 0
> > + *
> > + *   The user must fulfill documented requirements for each function.
>
> Not sure if this is overly relevant as part of the bpf_tc_opts in here. For the
> 2nd part, I would probably just mention that libbpf internally attaches the bpf
> programs with direct action mode. The hw offload may be future todo, and the other
> bits are little used anyway; mentioning them here, what value does it have to
> libbpf users? I'd rather just drop the 2nd part and/or simplify this paragraph
> just stating that the progs are attached in direct action mode.
>
> > + */
> > +struct bpf_tc_opts {
> > +     size_t sz;
> > +     __u32 handle;
> > +     __u32 parent;
> > +     __u16 priority;
> > +     __u32 prog_id;
> > +     bool replace;
> > +     size_t :0;
> > +};
> > +
> > +#define bpf_tc_opts__last_field replace
> > +
> > +struct bpf_tc_ctx;
> > +
> > +struct bpf_tc_ctx_opts {
> > +     size_t sz;
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

+1

>
> > +LIBBPF_API struct bpf_tc_ctx *bpf_tc_ctx_init(__u32 ifindex,
>
> nit: in user space s/__u32 ifindex/int ifindex/
>
> > +                                           enum bpf_tc_attach_point parent,
> > +                                           struct bpf_tc_ctx_opts *opts);
>
> Should we enforce opts being NULL or non-NULL here, or drop the arg from here
> for now altogether? (And if later versions of the functions show up this could
> be mapped to the right one?)
>

OPTS_VALID check handles all the cases. Opts are always allowed to be
NULL. If it's not null, all the bytes beyond what current libbpf
version supports should be zero. All that is handled by OPTS_VALID, so
I don't think anything extra needs to be checked.

> > +/*
> > + * @ctx: Can be NULL, if not, must point to a valid object.
> > + *    If the qdisc was attached during ctx_init, it will be deleted if no
> > + *    filters are attached to it.
> > + *    When ctx == NULL, this is a no-op.
> > + */
> > +LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
> > +/*
> > + * @ctx: Cannot be NULL.
> > + * @fd: Must be >= 0.
> > + * @opts: Cannot be NULL, prog_id must be unset, all other fields can be
> > + *     optionally set. All fields except replace  will be set as per created
> > + *        filter's attributes. parent must only be set when attach_point of ctx is
> > + *        BPF_TC_CUSTOM_PARENT, otherwise parent must be unset.
> > + *
> > + * Fills the following fields in opts:
> > + *   handle
> > + *   parent
> > + *   priority
> > + *   prog_id
> > + */
> > +LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
> > +                          struct bpf_tc_opts *opts);
> > +/*
> > + * @ctx: Cannot be NULL.
> > + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
> > + *     must be set.
> > + */
> > +LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
> > +                          const struct bpf_tc_opts *opts);
>
> One thing that I find a bit odd from this API is that BPF_TC_INGRESS / BPF_TC_EGRESS
> needs to be set each time via bpf_tc_ctx_init(). So whenever a specific program would
> be attached to both we need to 're-init' in between just to change from hook a to b,
> whereas when you have BPF_TC_CUSTOM_PARENT, you could just use a different opts->parent
> without going this detour (unless the clsact wasn't loaded there in the first place).
>
> Could we add a BPF_TC_UNSPEC to enum bpf_tc_attach_point, which the user would pass to
> bpf_tc_ctx_init(), so that opts.direction = BPF_TC_INGRESS with subsequent bpf_tc_attach()
> can be called, and same opts.direction = BPF_TC_EGRESS with bpf_tc_attach() for different
> fd. The only thing we cared about in bpf_tc_ctx_init() resp. the ctx was that qdisc was
> ready.
>
> > +/*
> > + * @ctx: Cannot be NULL.
> > + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
> > + *     must be set.
> > + *
> > + * Fills the following fields in opts:
> > + *   handle
> > + *   parent
> > + *   priority
> > + *   prog_id
> > + */
> > +LIBBPF_API int bpf_tc_query(struct bpf_tc_ctx *ctx,
> > +                         struct bpf_tc_opts *opts);
> > +
> >   #ifdef __cplusplus
> >   } /* extern "C" */
> >   #endif
