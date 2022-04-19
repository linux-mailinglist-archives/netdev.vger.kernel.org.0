Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7055075F8
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiDSRIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355658AbiDSRIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:08:19 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE77C27;
        Tue, 19 Apr 2022 10:05:36 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t12so16365822pll.7;
        Tue, 19 Apr 2022 10:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZTpwwjWiUlON22xzLgKdHd8VWcQjI2RH3VYw9E+BRA=;
        b=XwqJYP8HTHULUm6FC3qt+UFGgILNMC6y5SOK7h+dQS1PMGzHLz7c22I9Hq2KiyNGrY
         NUPZ8ALUQGZG1aEvAff3zRMkQx6YsgJSvPE/IKpvDl6Jjn+Dr9eHHhzf/XcizlJwOV1Y
         cq7DdIVQdxSw9w8hVZv49SgJha1ujFm2TaI4FwNIs59mxS2wgcxnjHC4ZupavGNFzkNb
         gEF99CdT4mVj73naw/RD4qCTKExI4BusPZtRGUkzT/tzZCMQb6yxYCEVDdTxSTJb9KVy
         kl8ezYtXWuNT7SKwZC45EFFftkOUIbNpvjRW/0V2scbNdpa/kMCRXLfgOAqOkOpoNYR3
         Styw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZTpwwjWiUlON22xzLgKdHd8VWcQjI2RH3VYw9E+BRA=;
        b=C03LKY5UwbmocaR1zTHxbJs+9X0iKawHOup7FPinlb8HkN5PCb4lPP+VflUBfQ1vyd
         blPZSi9Q5a59kkCRh5oBCquohCYG88Ma/GgRJNvEEgvKLZMtA/vte3DEPYU3aiwS7eGq
         8JSKoFU/t7Lo23mddM39u4rLJPf5U0LYAUiL67ZPnWhGwSeyBpIQEMeH/IcYjjJ14vX3
         IqIdb/RfCzsCcujO6/PoSqJ2AzsT76SNqzb8vHV6VSFIRo7fK8TJ2GavKi+tvSIrv3zg
         OnFLtJlj1WzYOu1P5Tx99OfUHlo/xieaphm/RNo0SfblbuScQQ7QlaQJFlD/NftfRgqD
         zIlA==
X-Gm-Message-State: AOAM533jJhcfo1YHqdgov3Tlhbc9FUWC9pPvn6IgT+WpdTzcvfxq/EBU
        ObEpayg9I7eRnAlgKfcBRJLE3RoeXGX9xV4/NVU=
X-Google-Smtp-Source: ABdhPJyoNIpPkCBjZ09bvzfLUXUuLAwyF3S/416zx2JwCio6OO1NY0ChYGhIvL5goF4GFFN9KmqsRVvcwieAWx6KAqg=
X-Received: by 2002:a17:903:2310:b0:15a:19ea:a2be with SMTP id
 d16-20020a170903231000b0015a19eaa2bemr2590258plh.67.1650387935809; Tue, 19
 Apr 2022 10:05:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com> <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
 <Yl2W5ThWCFPIeLW8@google.com> <CAADnVQ+X5HPDsqXX6mHWV4sT9=2gQSag5cc9w6iJG_YE577ZEw@mail.gmail.com>
 <Yl7YXXIG/EECZxd9@google.com> <CAADnVQK8ARjeY2Vro0B0-6vxhgrWg-jhJqkbHh0s1xinSq2-+Q@mail.gmail.com>
 <CAADnVQLvULRaAyO2E89c_FMNW9HGXr=nkFc9B5V-5WmXKbaRuw@mail.gmail.com>
 <CAKH8qBvApjJ5G4bNMtHxT+Fcw6uKOTZh1opkaC96OT6Gq55aJg@mail.gmail.com>
 <CAADnVQJ5qV54=7QMJfUzdAj1T31xD4aRMSin4npyNmudwP2m+g@mail.gmail.com> <CAKH8qBugYgnqj3wfOi4+974XCTH2hoGbzq43hve1_NjDwNO_eQ@mail.gmail.com>
In-Reply-To: <CAKH8qBugYgnqj3wfOi4+974XCTH2hoGbzq43hve1_NjDwNO_eQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 Apr 2022 10:05:24 -0700
Message-ID: <CAADnVQ+xVE2Fk5BNvSmc8H7BxQojzYACDhatRog+kqCQNG7-8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:01 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Tue, Apr 19, 2022 at 9:49 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 19, 2022 at 9:35 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Tue, Apr 19, 2022 at 9:32 AM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Apr 19, 2022 at 9:20 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Apr 19, 2022 at 8:42 AM <sdf@google.com> wrote:
> > > > > >
> > > > > > On 04/18, Alexei Starovoitov wrote:
> > > > > > > On Mon, Apr 18, 2022 at 9:50 AM <sdf@google.com> wrote:
> > > > > > > >
> > > > > > > > On 04/16, Alexei Starovoitov wrote:
> > > > > > > > > On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com>
> > > > > > > wrote:
> > > > > > > > > > +static int
> > > > > > > > > > +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > > > > > > > > +                           enum cgroup_bpf_attach_type atype,
> > > > > > > > > > +                           const void *ctx, bpf_prog_run_fn
> > > > > > > run_prog,
> > > > > > > > > > +                           int retval, u32 *ret_flags)
> > > > > > > > > > +{
> > > > > > > > > > +       const struct bpf_prog_array_item *item;
> > > > > > > > > > +       const struct bpf_prog *prog;
> > > > > > > > > > +       const struct bpf_prog_array *array;
> > > > > > > > > > +       struct bpf_run_ctx *old_run_ctx;
> > > > > > > > > > +       struct bpf_cg_run_ctx run_ctx;
> > > > > > > > > > +       u32 func_ret;
> > > > > > > > > > +
> > > > > > > > > > +       run_ctx.retval = retval;
> > > > > > > > > > +       migrate_disable();
> > > > > > > > > > +       rcu_read_lock();
> > > > > > > > > > +       array = rcu_dereference(cgrp->effective[atype]);
> > > > > > > > > > +       item = &array->items[0];
> > > > > > > > > > +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > > > > > > > > +       while ((prog = READ_ONCE(item->prog))) {
> > > > > > > > > > +               run_ctx.prog_item = item;
> > > > > > > > > > +               func_ret = run_prog(prog, ctx);
> > > > > > > > > ...
> > > > > > > > > > +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
> > > > > > > > > >                                     &ctx, bpf_prog_run, retval);
> > > > > > > >
> > > > > > > > > Did you check the asm that bpf_prog_run gets inlined
> > > > > > > > > after being passed as a pointer to a function?
> > > > > > > > > Crossing fingers... I suspect not every compiler can do that :(
> > > > > > > > > De-virtualization optimization used to be tricky.
> > > > > > > >
> > > > > > > > No, I didn't, but looking at it right now, both gcc and clang
> > > > > > > > seem to be doing inlining all way up to bpf_dispatcher_nop_func.
> > > > > > > >
> > > > > > > > clang:
> > > > > > > >
> > > > > > > >    0000000000001750 <__cgroup_bpf_run_filter_sock_addr>:
> > > > > > > >    __cgroup_bpf_run_filter_sock_addr():
> > > > > > > >    ./kernel/bpf/cgroup.c:1226
> > > > > > > >    int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
> > > > > > > >                                       struct sockaddr *uaddr,
> > > > > > > >                                       enum cgroup_bpf_attach_type atype,
> > > > > > > >                                       void *t_ctx,
> > > > > > > >                                       u32 *flags)
> > > > > > > >    {
> > > > > > > >
> > > > > > > >    ...
> > > > > > > >
> > > > > > > >    ./include/linux/filter.h:628
> > > > > > > >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> > > > > > > >        1980:    49 8d 75 48             lea    0x48(%r13),%rsi
> > > > > > > >    bpf_dispatcher_nop_func():
> > > > > > > >    ./include/linux/bpf.h:804
> > > > > > > >         return bpf_func(ctx, insnsi);
> > > > > > > >        1984:    4c 89 f7                mov    %r14,%rdi
> > > > > > > >        1987:    41 ff 55 30             call   *0x30(%r13)
> > > > > > > >        198b:    89 c3                   mov    %eax,%ebx
> > > > > > > >
> > > > > > > > gcc (w/retpoline):
> > > > > > > >
> > > > > > > >    0000000000001110 <__cgroup_bpf_run_filter_sock_addr>:
> > > > > > > >    __cgroup_bpf_run_filter_sock_addr():
> > > > > > > >    kernel/bpf/cgroup.c:1226
> > > > > > > >    {
> > > > > > > >
> > > > > > > >    ...
> > > > > > > >
> > > > > > > >    ./include/linux/filter.h:628
> > > > > > > >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> > > > > > > >        11c5:    49 8d 75 48             lea    0x48(%r13),%rsi
> > > > > > > >    bpf_dispatcher_nop_func():
> > > > > > > >    ./include/linux/bpf.h:804
> > > > > > > >        11c9:    48 8d 7c 24 10          lea    0x10(%rsp),%rdi
> > > > > > > >        11ce:    e8 00 00 00 00          call   11d3
> > > > > > > > <__cgroup_bpf_run_filter_sock_addr+0xc3>
> > > > > > > >                         11cf: R_X86_64_PLT32
> > > > > > > __x86_indirect_thunk_rax-0x4
> > > > > > > >        11d3:    89 c3                   mov    %eax,%ebx
> > > > > >
> > > > > > > Hmm. I'm not sure how you've got this asm.
> > > > > > > Here is what I see with gcc 8 and gcc 10:
> > > > > > > bpf_prog_run_array_cg:
> > > > > > > ...
> > > > > > >          movq    %rcx, %r12      # run_prog, run_prog
> > > > > > > ...
> > > > > > > # ../kernel/bpf/cgroup.c:77:            run_ctx.prog_item = item;
> > > > > > >          movq    %rbx, (%rsp)    # item, run_ctx.prog_item
> > > > > > > # ../kernel/bpf/cgroup.c:78:            if (!run_prog(prog, ctx) &&
> > > > > > > !IS_ERR_VALUE((long)run_ctx.retval))
> > > > > > >          movq    %rbp, %rsi      # ctx,
> > > > > > >          call    *%r12   # run_prog
> > > > > >
> > > > > > > __cgroup_bpf_run_filter_sk:
> > > > > > >          movq    $bpf_prog_run, %rcx     #,
> > > > > > > # ../kernel/bpf/cgroup.c:1202:  return
> > > > > > > bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
> > > > > > >          leaq    1520(%rax), %rdi        #, tmp92
> > > > > > > # ../kernel/bpf/cgroup.c:1202:  return
> > > > > > > bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
> > > > > > >          jmp     bpf_prog_run_array_cg   #
> > > > > >
> > > > > > > This is without kasan, lockdep and all debug configs are off.
> > > > > >
> > > > > > > So the generated code is pretty bad as I predicted :(
> > > > > >
> > > > > > > So I'm afraid this approach is no go.
> > > > > >
> > > > > > I've retested again and it still unrolls it for me on gcc 11 :-/
> > > > > > Anyway, I guess we have two options:
> > > > > >
> > > > > > 1. Go back to defines.
> > > > > > 2. Don't pass a ptr to func, but pass an enum which indicates whether
> > > > > >     to use bpf_prog_run or __bpf_prog_run_save_cb. Seems like in this
> > > > > >     case the compiler shouldn't have any trouble unwrapping it?
> > > > > >
> > > > > > I'll prototype and send (2). If it won't work out we can always get back
> > > > > > to (1).
> > > > >
> > > > > Going back to defines is probably not necessary.
> > > > > Could you try moving bpf_prog_run_array_cg*() back to .h
> > > > > and use static __always_inline ?
> > > >
> > > > Actually below was enough for gcc 8 and 10:
> > > > -static int
> > > > +static __always_inline int
> > > >  bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > >                             enum cgroup_bpf_attach_type atype,
> > > >                             const void *ctx, bpf_prog_run_fn run_prog,
> > > > @@ -55,7 +55,7 @@ bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > >         return run_ctx.retval;
> > > >  }
> > > >
> > > > -static int
> > > > +static __always_inline int
> > > >  bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> > > >
> > > > we can keep them in .c and generated code looks good.
> > > >
> > > > I can apply it with the above change.
> > > > wdyt?
> > >
> > > Sure, let's go with that if it works! On my side, I managed to get the
> > > same bad results on gcc-8; moving them to bpf-cgroup.h with
> > > __always_inline seems to fix it. But if we can keep them in .c, that
> > > looks even better.
> >
> > Ok. Applied.
> >
> > As the next step... can we combine bpf_prog_run_array_cg*()
> > into one function?
> > The only difference is:
> > func_ret = run_prog(prog, ctx);
> > if (!(func_ret & 1)
> >   vs
> > if (!run_prog(prog, ctx)
> >
> > afaik we don't have a check on the verifier side for possible
> > return values of cgroup progs,
> > so it might break some progs if we just do the former
> > in both cases?
>
> Seems like we do have return ranges checking for cgroup progs (I'm
> looking at check_return_code). Using bpf_prog_run_array_cg_flags
> everywhere seems possible, I can try and post some patches if it
> works.

Thanks!
Since it's always_inline extra 'if (ret_flags) *ret_flags = ...'
in the critical path is fine, since it will be optimized out
by the compiler when ret_flags are NULL.
Hopefully the compiler can hoist the check out of the while loop too
in case it's not NULL. But no big deal.
That array has typically only one prog in it.
