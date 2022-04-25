Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D750EBB8
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiDYWYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343631AbiDYVwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:52:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6623AA54
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:48:54 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso350414wme.5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3g7+LN6g47+LAildy/dOa6umRojr4CwCIm2qQex3m4=;
        b=QkgFm5ud5f8TG4VRDKm54eW869BVn0aXDMQNiIZrXcX8hxpC/GbSSF1+mo1AJfQeBB
         ruq79rNUJoiHZ++7Z/KhayHCk8Lf6J2naHQVvLEwoZUixMcOE8jaxTm+SBXT3qtwOZ5A
         fDj5GWQQE/ukjvo7DTiYbZnB8dc6URBT4D4wCqjEVJ1B2PJWMmhk3st7OHXxPlbHHVG3
         2Gj+FqsG40nOINNN8G3s5xKKjlhuRTReqMlqslcGA0NOKCz134/DLcfaLtEZrmxPfuAL
         AIC53P9oFEopCr9kPhGotPK1U7rDWhCUcuwsbQchPY0+RMa1Ha/MbtANDIbCD/GyjTVi
         UDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3g7+LN6g47+LAildy/dOa6umRojr4CwCIm2qQex3m4=;
        b=fd6oOQ0fFY80NYcEiEDPsP4Pe/XUCuyDuNWsYeXTvIcyyCvO2N4SqFpAxFK/nKGxzk
         tAayfnj3bYKFYU6rWNVKlikPcHefnttUOPHt/mwT0cpZKq5LjjiO9QWZUMhr/JEOQWwH
         580A0Xihq8QT6qRW5D8i+pfqU0lOJoqsZf/2ZRHDagbVO+J2omC4+VYdikGKvyNfKW1x
         hpgbbrPOsvXf1rydxcPbpAUTrETtSYwiOTku9g5TMOvir7800/4PIQ82HS8SPhV1NQRl
         ko4HltmnBaf2k9JCloH2e7SqjlIfBEszcan8wpVRZUK8oi3m5OGJsOJkihoWaUcbK4qD
         53xQ==
X-Gm-Message-State: AOAM533G7U+6PcwOq3MyPG1ryZgEBJ466vStv9cdQoOshb4eO8xFsiHv
        o+ZjKOLj0ldyUTy2WUj7NOyhnFgc2Or+5wMJZu8b3w==
X-Google-Smtp-Source: ABdhPJwZ/Me+/UZWIQaqf3MI5v8Kn/V3HnlN/Fp53TROB4hb7rFdoVgPg33rwI6iJ8Qgs4OxNU5pQsdQ/dCG6NPofho=
X-Received: by 2002:a1c:2904:0:b0:37b:ea53:4cbf with SMTP id
 p4-20020a1c2904000000b0037bea534cbfmr18326125wmp.46.1650923333338; Mon, 25
 Apr 2022 14:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220419222259.287515-1-sdf@google.com> <CAEf4BzYoA4xvqv7SaM2TvcbKef=m4n6TSGVNA34T2we05fRwpw@mail.gmail.com>
 <CAKH8qBsTiQA5knxoBSqxCYav89QdSN0j6t1EWX1MEVbAqLj6kg@mail.gmail.com> <20220425203759.yxyyvdarx4woegfg@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220425203759.yxyyvdarx4woegfg@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 25 Apr 2022 14:48:41 -0700
Message-ID: <CAKH8qBvq54azM0TTpPNWdQJxEVLwQ0PPY1860njYbUqJpH319Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: use bpf_prog_run_array_cg_flags everywhere
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 1:38 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Apr 20, 2022 at 03:30:43PM -0700, Stanislav Fomichev wrote:
> > On Wed, Apr 20, 2022 at 3:04 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Apr 19, 2022 at 3:23 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Rename bpf_prog_run_array_cg_flags to bpf_prog_run_array_cg and
> > > > use it everywhere. check_return_code already enforces sane
> > > > return ranges for all cgroup types. (only egress and bind hooks have
> > > > uncanonical return ranges, the rest is using [0, 1])
> > > >
> > > > No functional changes.
> > > >
> > > > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  include/linux/bpf-cgroup.h |  8 ++---
> > > >  kernel/bpf/cgroup.c        | 70 ++++++++++++--------------------------
> > > >  2 files changed, 24 insertions(+), 54 deletions(-)
> > > >
> > > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > > > index 88a51b242adc..669d96d074ad 100644
> > > > --- a/include/linux/bpf-cgroup.h
> > > > +++ b/include/linux/bpf-cgroup.h
> > > > @@ -225,24 +225,20 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
> > > >
> > > >  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)                                      \
> > > >  ({                                                                            \
> > > > -       u32 __unused_flags;                                                    \
> > > >         int __ret = 0;                                                         \
> > > >         if (cgroup_bpf_enabled(atype))                                         \
> > > >                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> > > > -                                                         NULL,                \
> > > > -                                                         &__unused_flags);    \
> > > > +                                                         NULL, NULL);         \
> > > >         __ret;                                                                 \
> > > >  })
> > > >
> > > >  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx)                  \
> > > >  ({                                                                            \
> > > > -       u32 __unused_flags;                                                    \
> > > >         int __ret = 0;                                                         \
> > > >         if (cgroup_bpf_enabled(atype))  {                                      \
> > > >                 lock_sock(sk);                                                 \
> > > >                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> > > > -                                                         t_ctx,               \
> > > > -                                                         &__unused_flags);    \
> > > > +                                                         t_ctx, NULL);        \
> > > >                 release_sock(sk);                                              \
> > > >         }                                                                      \
> > > >         __ret;                                                                 \
> > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > index 0cb6211fcb58..f61eca32c747 100644
> > > > --- a/kernel/bpf/cgroup.c
> > > > +++ b/kernel/bpf/cgroup.c
> > > > @@ -25,50 +25,18 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> > > >  /* __always_inline is necessary to prevent indirect call through run_prog
> > > >   * function pointer.
> > > >   */
> > > > -static __always_inline int
> > > > -bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > > -                           enum cgroup_bpf_attach_type atype,
> > > > -                           const void *ctx, bpf_prog_run_fn run_prog,
> > > > -                           int retval, u32 *ret_flags)
> > > > -{
> > > > -       const struct bpf_prog_array_item *item;
> > > > -       const struct bpf_prog *prog;
> > > > -       const struct bpf_prog_array *array;
> > > > -       struct bpf_run_ctx *old_run_ctx;
> > > > -       struct bpf_cg_run_ctx run_ctx;
> > > > -       u32 func_ret;
> > > > -
> > > > -       run_ctx.retval = retval;
> > > > -       migrate_disable();
> > > > -       rcu_read_lock();
> > > > -       array = rcu_dereference(cgrp->effective[atype]);
> > > > -       item = &array->items[0];
> > > > -       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > > -       while ((prog = READ_ONCE(item->prog))) {
> > > > -               run_ctx.prog_item = item;
> > > > -               func_ret = run_prog(prog, ctx);
> > > > -               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
> > > > -                       run_ctx.retval = -EPERM;
> > > > -               *(ret_flags) |= (func_ret >> 1);
> > > > -               item++;
> > > > -       }
> > > > -       bpf_reset_run_ctx(old_run_ctx);
> > > > -       rcu_read_unlock();
> > > > -       migrate_enable();
> > > > -       return run_ctx.retval;
> > > > -}
> > > > -
> > > >  static __always_inline int
> > > >  bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> > > >                       enum cgroup_bpf_attach_type atype,
> > > >                       const void *ctx, bpf_prog_run_fn run_prog,
> > > > -                     int retval)
> > > > +                     int retval, u32 *ret_flags)
> > > >  {
> > > >         const struct bpf_prog_array_item *item;
> > > >         const struct bpf_prog *prog;
> > > >         const struct bpf_prog_array *array;
> > > >         struct bpf_run_ctx *old_run_ctx;
> > > >         struct bpf_cg_run_ctx run_ctx;
> > > > +       u32 func_ret;
> > > >
> > > >         run_ctx.retval = retval;
> > > >         migrate_disable();
> > > > @@ -78,8 +46,11 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> > > >         old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > >         while ((prog = READ_ONCE(item->prog))) {
> > > >                 run_ctx.prog_item = item;
> > > > -               if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
> > > > +               func_ret = run_prog(prog, ctx);
> > > > +               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
> > >
> > > to be completely true to previous behavior, shouldn't there be
> > >
> > > if (ret_flags)
> > >     func_ret &= 1;
> > > if (!func_ret && !IS_ERR_VALUE(...))
> > >
> > > here?
> > >
> > > This might have been discussed previously and I missed it. If that's
> > > so, please ignore.
> >
> > We are converting the cases where run_prog(prog, ctx) returns 0 or 1,
> > so it seems like we don't have to reproduce the existing behavior
> > 1-to-1?
> > So I'm not sure it matters, or am I missing something?
> A nit, how about testing 'if (ret_flags)' first such that
> it is obvious which case will use higher bits in the return value.
> The compiler may be able to optimize the ret_flags == NULL case also ?
>
> Something like:
>
>         func_ret = run_prog(prog, ctx);
>         /* The cg bpf prog uses the higher bits of the return value */
>         if (ret_flags) {
>                 *(ret_flags) |= (func_ret >> 1);
>                 func_ret &= 1;
>         }
>         if (!func_ret && !IS_ERR_VALUE((long)run_ctx.retval))
>                 run_ctx.retval = -EPERM;

Sure, this should also address Andrii's point I think. Will resend a v2.
