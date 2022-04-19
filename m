Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8A350720B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353984AbiDSPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244917AbiDSPpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:45:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316E219008
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:42:25 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f16f3a7c34so64491557b3.17
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MWhERi4DU4hY8hbRinL5pU8MGWdCiSqvzarGWodqTns=;
        b=Xa96Vb4Y1Q8TZ6IS/+WURX2vOyOEXq0qysiGlErbZR+wWj9FIRQO0lf2cLaN+Jhh3O
         cHOIQrQZY4+rFkcEQ6GEUebsnHFTTCRLHMyUkmiHn95Fg0ERfSXGcQBSRA00v03pnxzs
         Ytw+gZ+zCPr3WTRky8ytoGgq4mvX0aAi45cqa1JCIpKCPoysDDFT7NaS52UWU3f9eYuZ
         X7emeJZmm3zc2Bp4PkF1/9tay7ZqWO0SQDl/iJ0vassyFCFDjCLdVk/8zeFxjwyG0I+v
         8yC5dSNIK3hrRl8y/oAU4bbhr3U86KI7l1JVQ8bfcrDkhuNgEwzxBKnqxRBjql/Q4F4s
         /AEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MWhERi4DU4hY8hbRinL5pU8MGWdCiSqvzarGWodqTns=;
        b=cePKvwAFVN4fLtWF1qIfHSdmztw2fqhSK6UvBqEKBQmptF1A/NoZYqPoYGL4r8ouWj
         2ep0Sd4yA2R7rlM5MMmUYb/Wsq/zxdLcWb6/Liyvl41rV6s9ZMIH995ZwWOkw99DxId8
         gY3M4AkyLj8N/VseHQr4xIurGTChZzeOl6cbaLD4keSPz2nQ2nLoEykH3uP4lkJ9DgQf
         BA7kQoYwc21hfuUy2OZmj7na6uIFS8oiZO4SYoDk1pqx/gyPQx3iim/bZS+2/TX0h+o0
         T6GP/idSR9z3ylZp64N3Zn0DSBIFt1vohi8Yqc7BsgYOvGUufFybaIaJFI8xSDSSCGUq
         UW4g==
X-Gm-Message-State: AOAM531lifoL8T2HW1gpJL1/iqZlYrldiKHzpsCiFV2lMReee1Ow6RZX
        DVkBJoc3nocZSpYzvsoA86xWf3c=
X-Google-Smtp-Source: ABdhPJzQzBklYFPdivJ3Z8Gc+UNAXKFCXm1LGcfqQQMV0CEwQhuGOrZGcqeelvEOosukbybSFgjATOs=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:37f:6746:8e66:a291])
 (user=sdf job=sendgmr) by 2002:a81:ad47:0:b0:2ee:927d:ff39 with SMTP id
 l7-20020a81ad47000000b002ee927dff39mr16281999ywk.249.1650382944389; Tue, 19
 Apr 2022 08:42:24 -0700 (PDT)
Date:   Tue, 19 Apr 2022 08:42:21 -0700
In-Reply-To: <CAADnVQ+X5HPDsqXX6mHWV4sT9=2gQSag5cc9w6iJG_YE577ZEw@mail.gmail.com>
Message-Id: <Yl7YXXIG/EECZxd9@google.com>
Mime-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com> <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
 <Yl2W5ThWCFPIeLW8@google.com> <CAADnVQ+X5HPDsqXX6mHWV4sT9=2gQSag5cc9w6iJG_YE577ZEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/18, Alexei Starovoitov wrote:
> On Mon, Apr 18, 2022 at 9:50 AM <sdf@google.com> wrote:
> >
> > On 04/16, Alexei Starovoitov wrote:
> > > On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com>  
> wrote:
> > > > +static int
> > > > +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > > +                           enum cgroup_bpf_attach_type atype,
> > > > +                           const void *ctx, bpf_prog_run_fn  
> run_prog,
> > > > +                           int retval, u32 *ret_flags)
> > > > +{
> > > > +       const struct bpf_prog_array_item *item;
> > > > +       const struct bpf_prog *prog;
> > > > +       const struct bpf_prog_array *array;
> > > > +       struct bpf_run_ctx *old_run_ctx;
> > > > +       struct bpf_cg_run_ctx run_ctx;
> > > > +       u32 func_ret;
> > > > +
> > > > +       run_ctx.retval = retval;
> > > > +       migrate_disable();
> > > > +       rcu_read_lock();
> > > > +       array = rcu_dereference(cgrp->effective[atype]);
> > > > +       item = &array->items[0];
> > > > +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > > +       while ((prog = READ_ONCE(item->prog))) {
> > > > +               run_ctx.prog_item = item;
> > > > +               func_ret = run_prog(prog, ctx);
> > > ...
> > > > +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
> > > >                                     &ctx, bpf_prog_run, retval);
> >
> > > Did you check the asm that bpf_prog_run gets inlined
> > > after being passed as a pointer to a function?
> > > Crossing fingers... I suspect not every compiler can do that :(
> > > De-virtualization optimization used to be tricky.
> >
> > No, I didn't, but looking at it right now, both gcc and clang
> > seem to be doing inlining all way up to bpf_dispatcher_nop_func.
> >
> > clang:
> >
> >    0000000000001750 <__cgroup_bpf_run_filter_sock_addr>:
> >    __cgroup_bpf_run_filter_sock_addr():
> >    ./kernel/bpf/cgroup.c:1226
> >    int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
> >                                       struct sockaddr *uaddr,
> >                                       enum cgroup_bpf_attach_type atype,
> >                                       void *t_ctx,
> >                                       u32 *flags)
> >    {
> >
> >    ...
> >
> >    ./include/linux/filter.h:628
> >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> >        1980:    49 8d 75 48             lea    0x48(%r13),%rsi
> >    bpf_dispatcher_nop_func():
> >    ./include/linux/bpf.h:804
> >         return bpf_func(ctx, insnsi);
> >        1984:    4c 89 f7                mov    %r14,%rdi
> >        1987:    41 ff 55 30             call   *0x30(%r13)
> >        198b:    89 c3                   mov    %eax,%ebx
> >
> > gcc (w/retpoline):
> >
> >    0000000000001110 <__cgroup_bpf_run_filter_sock_addr>:
> >    __cgroup_bpf_run_filter_sock_addr():
> >    kernel/bpf/cgroup.c:1226
> >    {
> >
> >    ...
> >
> >    ./include/linux/filter.h:628
> >                 ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
> >        11c5:    49 8d 75 48             lea    0x48(%r13),%rsi
> >    bpf_dispatcher_nop_func():
> >    ./include/linux/bpf.h:804
> >        11c9:    48 8d 7c 24 10          lea    0x10(%rsp),%rdi
> >        11ce:    e8 00 00 00 00          call   11d3
> > <__cgroup_bpf_run_filter_sock_addr+0xc3>
> >                         11cf: R_X86_64_PLT32     
> __x86_indirect_thunk_rax-0x4
> >        11d3:    89 c3                   mov    %eax,%ebx

> Hmm. I'm not sure how you've got this asm.
> Here is what I see with gcc 8 and gcc 10:
> bpf_prog_run_array_cg:
> ...
>          movq    %rcx, %r12      # run_prog, run_prog
> ...
> # ../kernel/bpf/cgroup.c:77:            run_ctx.prog_item = item;
>          movq    %rbx, (%rsp)    # item, run_ctx.prog_item
> # ../kernel/bpf/cgroup.c:78:            if (!run_prog(prog, ctx) &&
> !IS_ERR_VALUE((long)run_ctx.retval))
>          movq    %rbp, %rsi      # ctx,
>          call    *%r12   # run_prog

> __cgroup_bpf_run_filter_sk:
>          movq    $bpf_prog_run, %rcx     #,
> # ../kernel/bpf/cgroup.c:1202:  return
> bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
>          leaq    1520(%rax), %rdi        #, tmp92
> # ../kernel/bpf/cgroup.c:1202:  return
> bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
>          jmp     bpf_prog_run_array_cg   #

> This is without kasan, lockdep and all debug configs are off.

> So the generated code is pretty bad as I predicted :(

> So I'm afraid this approach is no go.

I've retested again and it still unrolls it for me on gcc 11 :-/
Anyway, I guess we have two options:

1. Go back to defines.
2. Don't pass a ptr to func, but pass an enum which indicates whether
    to use bpf_prog_run or __bpf_prog_run_save_cb. Seems like in this
    case the compiler shouldn't have any trouble unwrapping it?

I'll prototype and send (2). If it won't work out we can always get back
to (1).
