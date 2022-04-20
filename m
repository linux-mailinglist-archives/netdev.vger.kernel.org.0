Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA9C5092D7
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 00:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351694AbiDTWdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 18:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiDTWdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 18:33:43 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC8C3614E
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 15:30:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id t6so713212wra.4
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 15:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JNdJoRr5tGng4b0lE14ckizzv6cvGcq4TrCt6gSM2M8=;
        b=jI9YpA622nmVtBPlLCZoi6OSOaN9erRKXqwRsU1FpST1tlaT5vrIhPmihdK8uSWhXw
         s9GsSqewlsDC9hDCAPj3ChLm1LZapE4ANp1eueaJ8bFWtP4tzWA7W27HgWwnMrKIunY8
         5Ob/FNWCCUHkY1JsvuFpEVhfZh1SQu4T+agf5C0ipR1yHEDV7T4SWPP2xHTqesMYhPrL
         jqL1YXkpbjnT1sq3LyI9XAQKow5Qxow84K6tngZ+vY+NVg3o1wuzLLHE/k1pvpDWR0Rv
         pkyy/CNxDNoFRRds8f9qKGbr3fh1g6Kl41TW6h7qJZnAHWSL5V9XZGGhRLVx8g6h4khX
         3Xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JNdJoRr5tGng4b0lE14ckizzv6cvGcq4TrCt6gSM2M8=;
        b=4V2TnH7cq2uST5VYrAhHz3SWtAziLe1aZSqavhH+HH/NvCVjOj8gij+ulRT8XFY42Y
         Gy97P4KmweK3DPTjEyIWTmLtKQS7pyM6lUpXKe+DoCc5I/8P4crgHUWNIWIcYvye0yRQ
         dogCHlVDU6DCmSCJN0YdsYss31CcjpgZcI3rt00a4wF28DUtg3FwHyf0//4g69nEpOyY
         68v09qfMnM1oAM6ITrutjaVSxTysTyCa1edMuxOHLZ6nyxsxN5VzKaoIv5cVIEOs6AaF
         lCBfTPUZn08xWPLGINz6UrUVXihTUhWmoaO3WW3M+wUg827TbY6AGQGLgbNMKA3RHrWD
         +K0Q==
X-Gm-Message-State: AOAM533FMsS2r0sIgkH42sZ3QIGaAtI/iDgXayGFLhKv1W4YmkfWckil
        OJrg08dvFqlXY8TR5ArXYVzc7prKiFZLW1J+LOW6h6dyqFbWwg==
X-Google-Smtp-Source: ABdhPJzd/mXFOlyeeIoEiC8aXTwfqYUR7SVagQGpPiHwr3WJpd+ItNkBduHlPnpXbo5R28XY7a7iqwvsJ/kunrPGinw=
X-Received: by 2002:a5d:610d:0:b0:207:b141:a5fe with SMTP id
 v13-20020a5d610d000000b00207b141a5femr17387532wrt.463.1650493854529; Wed, 20
 Apr 2022 15:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220419222259.287515-1-sdf@google.com> <CAEf4BzYoA4xvqv7SaM2TvcbKef=m4n6TSGVNA34T2we05fRwpw@mail.gmail.com>
In-Reply-To: <CAEf4BzYoA4xvqv7SaM2TvcbKef=m4n6TSGVNA34T2we05fRwpw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 20 Apr 2022 15:30:43 -0700
Message-ID: <CAKH8qBsTiQA5knxoBSqxCYav89QdSN0j6t1EWX1MEVbAqLj6kg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: use bpf_prog_run_array_cg_flags everywhere
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Wed, Apr 20, 2022 at 3:04 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Apr 19, 2022 at 3:23 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Rename bpf_prog_run_array_cg_flags to bpf_prog_run_array_cg and
> > use it everywhere. check_return_code already enforces sane
> > return ranges for all cgroup types. (only egress and bind hooks have
> > uncanonical return ranges, the rest is using [0, 1])
> >
> > No functional changes.
> >
> > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/bpf-cgroup.h |  8 ++---
> >  kernel/bpf/cgroup.c        | 70 ++++++++++++--------------------------
> >  2 files changed, 24 insertions(+), 54 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index 88a51b242adc..669d96d074ad 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -225,24 +225,20 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
> >
> >  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)                                      \
> >  ({                                                                            \
> > -       u32 __unused_flags;                                                    \
> >         int __ret = 0;                                                         \
> >         if (cgroup_bpf_enabled(atype))                                         \
> >                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> > -                                                         NULL,                \
> > -                                                         &__unused_flags);    \
> > +                                                         NULL, NULL);         \
> >         __ret;                                                                 \
> >  })
> >
> >  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx)                  \
> >  ({                                                                            \
> > -       u32 __unused_flags;                                                    \
> >         int __ret = 0;                                                         \
> >         if (cgroup_bpf_enabled(atype))  {                                      \
> >                 lock_sock(sk);                                                 \
> >                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> > -                                                         t_ctx,               \
> > -                                                         &__unused_flags);    \
> > +                                                         t_ctx, NULL);        \
> >                 release_sock(sk);                                              \
> >         }                                                                      \
> >         __ret;                                                                 \
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 0cb6211fcb58..f61eca32c747 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -25,50 +25,18 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> >  /* __always_inline is necessary to prevent indirect call through run_prog
> >   * function pointer.
> >   */
> > -static __always_inline int
> > -bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > -                           enum cgroup_bpf_attach_type atype,
> > -                           const void *ctx, bpf_prog_run_fn run_prog,
> > -                           int retval, u32 *ret_flags)
> > -{
> > -       const struct bpf_prog_array_item *item;
> > -       const struct bpf_prog *prog;
> > -       const struct bpf_prog_array *array;
> > -       struct bpf_run_ctx *old_run_ctx;
> > -       struct bpf_cg_run_ctx run_ctx;
> > -       u32 func_ret;
> > -
> > -       run_ctx.retval = retval;
> > -       migrate_disable();
> > -       rcu_read_lock();
> > -       array = rcu_dereference(cgrp->effective[atype]);
> > -       item = &array->items[0];
> > -       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > -       while ((prog = READ_ONCE(item->prog))) {
> > -               run_ctx.prog_item = item;
> > -               func_ret = run_prog(prog, ctx);
> > -               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
> > -                       run_ctx.retval = -EPERM;
> > -               *(ret_flags) |= (func_ret >> 1);
> > -               item++;
> > -       }
> > -       bpf_reset_run_ctx(old_run_ctx);
> > -       rcu_read_unlock();
> > -       migrate_enable();
> > -       return run_ctx.retval;
> > -}
> > -
> >  static __always_inline int
> >  bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> >                       enum cgroup_bpf_attach_type atype,
> >                       const void *ctx, bpf_prog_run_fn run_prog,
> > -                     int retval)
> > +                     int retval, u32 *ret_flags)
> >  {
> >         const struct bpf_prog_array_item *item;
> >         const struct bpf_prog *prog;
> >         const struct bpf_prog_array *array;
> >         struct bpf_run_ctx *old_run_ctx;
> >         struct bpf_cg_run_ctx run_ctx;
> > +       u32 func_ret;
> >
> >         run_ctx.retval = retval;
> >         migrate_disable();
> > @@ -78,8 +46,11 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> >         old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> >         while ((prog = READ_ONCE(item->prog))) {
> >                 run_ctx.prog_item = item;
> > -               if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
> > +               func_ret = run_prog(prog, ctx);
> > +               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
>
> to be completely true to previous behavior, shouldn't there be
>
> if (ret_flags)
>     func_ret &= 1;
> if (!func_ret && !IS_ERR_VALUE(...))
>
> here?
>
> This might have been discussed previously and I missed it. If that's
> so, please ignore.

We are converting the cases where run_prog(prog, ctx) returns 0 or 1,
so it seems like we don't have to reproduce the existing behavior
1-to-1?
So I'm not sure it matters, or am I missing something?
