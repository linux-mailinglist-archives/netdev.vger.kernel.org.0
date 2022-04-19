Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8233250730D
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354679AbiDSQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 12:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354668AbiDSQif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 12:38:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4233B13E27
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:35:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n40-20020a05600c3ba800b0038ff1939b16so1879188wms.2
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 09:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1iz2LuZBbh6iNPZGLMmhJtFze0j8ZOzB6NCaN/Mr1g=;
        b=XFRu6nLSpPZeUzxnmh/4jtM/SKAzcOQWJ42hog9VWVNmWcDaAZcvqcYoaSzbl7sRVy
         bpubwoHDV90MqnDV3u4TXEObfEAFabRDcBLkYr9/URXu4wEKho0V4CqzD40yM1/xTmgL
         VQkdJjjDhP+/cBL62noKAnDE7FJZFTTHA/igrfmXssEatnfL0NcdRhQI2BfPLyi8mQHw
         zZUKHCsZa35BI/wHkwADRDOva1uDLqNLseuumWM+BkCv1i3/pn5DKO9NA5t+GRBDa91Z
         iwZGqn3rb1nDGNmZGXObfn3dRcCKNMTPMomyoB34zKssvgjv8WxfuCwn+kZvKqAGpYkj
         9TOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1iz2LuZBbh6iNPZGLMmhJtFze0j8ZOzB6NCaN/Mr1g=;
        b=1JMs4j7z1M+p4INI0TX1BNOiv7k4JgefM7OLp5/5uhgj/xoyrp9HcTG9WNY6JAIR0l
         aV76GyfGR/7cQTuVaFjM7mrdNQCWikV+SXNXjBLpRcG8DUznxSfDcPitag9+0fez9ua2
         EDeKAUqo/tRavvLhW4SXbgodA6w4REOAJqWEtZjUPtAglXdeYWSNZWjvkfbafyUjJ51S
         57/7zjptgQPabDVU1Web95VeKc+0n5HFqGoDZvRINXnhfdqtHFmEbGRx5ycPOhKYOryS
         pc8IN9+vvir5iNiP/r1oXQWuUAENn31WGqLvLtQkIcbcLqWNWW7hAr59VNp4ExSE/LOx
         5DTg==
X-Gm-Message-State: AOAM530qFussZkHgVX5OEfvhOS17p9rMFcIebAxDsrp+TDD1ZqmJb0Rw
        2TA73Pzvd+krnwMU3yKz9MGGw7RaewjsL5eY5E0pzg==
X-Google-Smtp-Source: ABdhPJzx3Oyxfc7vyLwHOmxVNMpO/fjNMD4juCfvvA+TEjsnN8OmRXZVbgdiMjrtWnmzI9OvsclbwWyFM7iAQ137eFw=
X-Received: by 2002:a7b:cd04:0:b0:38e:d7a4:1548 with SMTP id
 f4-20020a7bcd04000000b0038ed7a41548mr16520844wmj.73.1650386149475; Tue, 19
 Apr 2022 09:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com> <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
 <Yl2W5ThWCFPIeLW8@google.com> <CAADnVQ+X5HPDsqXX6mHWV4sT9=2gQSag5cc9w6iJG_YE577ZEw@mail.gmail.com>
 <Yl7YXXIG/EECZxd9@google.com> <CAADnVQK8ARjeY2Vro0B0-6vxhgrWg-jhJqkbHh0s1xinSq2-+Q@mail.gmail.com>
 <CAADnVQLvULRaAyO2E89c_FMNW9HGXr=nkFc9B5V-5WmXKbaRuw@mail.gmail.com>
In-Reply-To: <CAADnVQLvULRaAyO2E89c_FMNW9HGXr=nkFc9B5V-5WmXKbaRuw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 19 Apr 2022 09:35:37 -0700
Message-ID: <CAKH8qBvApjJ5G4bNMtHxT+Fcw6uKOTZh1opkaC96OT6Gq55aJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 9:32 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Apr 19, 2022 at 9:20 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Apr 19, 2022 at 8:42 AM <sdf@google.com> wrote:
> > >
> > > On 04/18, Alexei Starovoitov wrote:
> > > > On Mon, Apr 18, 2022 at 9:50 AM <sdf@google.com> wrote:
> > > > >
> > > > > On 04/16, Alexei Starovoitov wrote:
> > > > > > On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com>
> > > > wrote:
> > > > > > > +static int
> > > > > > > +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > > > > > +                           enum cgroup_bpf_attach_type atype,
> > > > > > > +                           const void *ctx, bpf_prog_run_fn
> > > > run_prog,
> > > > > > > +                           int retval, u32 *ret_flags)
> > > > > > > +{
> > > > > > > +       const struct bpf_prog_array_item *item;
> > > > > > > +       const struct bpf_prog *prog;
> > > > > > > +       const struct bpf_prog_array *array;
> > > > > > > +       struct bpf_run_ctx *old_run_ctx;
> > > > > > > +       struct bpf_cg_run_ctx run_ctx;
> > > > > > > +       u32 func_ret;
> > > > > > > +
> > > > > > > +       run_ctx.retval = retval;
> > > > > > > +       migrate_disable();
> > > > > > > +       rcu_read_lock();
> > > > > > > +       array = rcu_dereference(cgrp->effective[atype]);
> > > > > > > +       item = &array->items[0];
> > > > > > > +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > > > > > +       while ((prog = READ_ONCE(item->prog))) {
> > > > > > > +               run_ctx.prog_item = item;
> > > > > > > +               func_ret = run_prog(prog, ctx);
> > > > > > ...
> > > > > > > +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
> > > > > > >                                     &ctx, bpf_prog_run, retval);
> > > > >
> > > > > > Did you check the asm that bpf_prog_run gets inlined
> > > > > > after being passed as a pointer to a function?
> > > > > > Crossing fingers... I suspect not every compiler can do that :(
> > > > > > De-virtualization optimization used to be tricky.
> > > > >
> > > > > No, I didn't, but looking at it right now, both gcc and clang
> > > > > seem to be doing inlining all way up to bpf_dispatcher_nop_func.
> > > > >
> > > > > clang:
> > > > >
> > > > >    0000000000001750 <__cgroup_bpf_run_filter_sock_addr>:
> > > > >    __cgroup_bpf_run_filter_sock_addr():
> > > > >    ./kernel/bpf/cgroup.c:1226
> > > > >    int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
> > > > >                                       struct sockaddr *uaddr,
> > > > >                                       enum cgroup_bpf_attach_type atype,
> > > > >                                       void *t_ctx,
> > > > >                                       u32 *flags)
> > > > >    {
> > > > >
> > > > >    ...
> > > > >
> > > > >    ./include/linux/filter.h:628
> > > > >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> > > > >        1980:    49 8d 75 48             lea    0x48(%r13),%rsi
> > > > >    bpf_dispatcher_nop_func():
> > > > >    ./include/linux/bpf.h:804
> > > > >         return bpf_func(ctx, insnsi);
> > > > >        1984:    4c 89 f7                mov    %r14,%rdi
> > > > >        1987:    41 ff 55 30             call   *0x30(%r13)
> > > > >        198b:    89 c3                   mov    %eax,%ebx
> > > > >
> > > > > gcc (w/retpoline):
> > > > >
> > > > >    0000000000001110 <__cgroup_bpf_run_filter_sock_addr>:
> > > > >    __cgroup_bpf_run_filter_sock_addr():
> > > > >    kernel/bpf/cgroup.c:1226
> > > > >    {
> > > > >
> > > > >    ...
> > > > >
> > > > >    ./include/linux/filter.h:628
> > > > >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> > > > >        11c5:    49 8d 75 48             lea    0x48(%r13),%rsi
> > > > >    bpf_dispatcher_nop_func():
> > > > >    ./include/linux/bpf.h:804
> > > > >        11c9:    48 8d 7c 24 10          lea    0x10(%rsp),%rdi
> > > > >        11ce:    e8 00 00 00 00          call   11d3
> > > > > <__cgroup_bpf_run_filter_sock_addr+0xc3>
> > > > >                         11cf: R_X86_64_PLT32
> > > > __x86_indirect_thunk_rax-0x4
> > > > >        11d3:    89 c3                   mov    %eax,%ebx
> > >
> > > > Hmm. I'm not sure how you've got this asm.
> > > > Here is what I see with gcc 8 and gcc 10:
> > > > bpf_prog_run_array_cg:
> > > > ...
> > > >          movq    %rcx, %r12      # run_prog, run_prog
> > > > ...
> > > > # ../kernel/bpf/cgroup.c:77:            run_ctx.prog_item = item;
> > > >          movq    %rbx, (%rsp)    # item, run_ctx.prog_item
> > > > # ../kernel/bpf/cgroup.c:78:            if (!run_prog(prog, ctx) &&
> > > > !IS_ERR_VALUE((long)run_ctx.retval))
> > > >          movq    %rbp, %rsi      # ctx,
> > > >          call    *%r12   # run_prog
> > >
> > > > __cgroup_bpf_run_filter_sk:
> > > >          movq    $bpf_prog_run, %rcx     #,
> > > > # ../kernel/bpf/cgroup.c:1202:  return
> > > > bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
> > > >          leaq    1520(%rax), %rdi        #, tmp92
> > > > # ../kernel/bpf/cgroup.c:1202:  return
> > > > bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
> > > >          jmp     bpf_prog_run_array_cg   #
> > >
> > > > This is without kasan, lockdep and all debug configs are off.
> > >
> > > > So the generated code is pretty bad as I predicted :(
> > >
> > > > So I'm afraid this approach is no go.
> > >
> > > I've retested again and it still unrolls it for me on gcc 11 :-/
> > > Anyway, I guess we have two options:
> > >
> > > 1. Go back to defines.
> > > 2. Don't pass a ptr to func, but pass an enum which indicates whether
> > >     to use bpf_prog_run or __bpf_prog_run_save_cb. Seems like in this
> > >     case the compiler shouldn't have any trouble unwrapping it?
> > >
> > > I'll prototype and send (2). If it won't work out we can always get back
> > > to (1).
> >
> > Going back to defines is probably not necessary.
> > Could you try moving bpf_prog_run_array_cg*() back to .h
> > and use static __always_inline ?
>
> Actually below was enough for gcc 8 and 10:
> -static int
> +static __always_inline int
>  bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
>                             enum cgroup_bpf_attach_type atype,
>                             const void *ctx, bpf_prog_run_fn run_prog,
> @@ -55,7 +55,7 @@ bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
>         return run_ctx.retval;
>  }
>
> -static int
> +static __always_inline int
>  bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
>
> we can keep them in .c and generated code looks good.
>
> I can apply it with the above change.
> wdyt?

Sure, let's go with that if it works! On my side, I managed to get the
same bad results on gcc-8; moving them to bpf-cgroup.h with
__always_inline seems to fix it. But if we can keep them in .c, that
looks even better.
