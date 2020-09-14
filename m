Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4562683F0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgINFE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgINFE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 01:04:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39CCC061788
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 22:04:55 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id k14so299405edo.1
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 22:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qw29AdXtCYZRa8G3I3RQgCCnOcHR3ivBh4i+1lH4G8A=;
        b=KmOcYLCNEj8MDt2SlHWzXxvKI5SNE6/iVdmXJePY2lFlJcMbJFQ5uAqQF5dppIdFN6
         6MoWXQGDSpynqFq837oenEx5Wk2hEzAuDwMgHfcPbEBFDV9K7S3pBx1liT33N2SCYM4H
         agoYwSqNxOM3ekeAtL76nES5g5I45mZKPQ9dnFvhbYbyuqxO2Nxm41DRbQ0HhHF1spwP
         t0mpCRAajJwTWjR1FaJ6EQzwdUrVmfXHU40IZ7TMTG4d3nqMRrlwA7YFhYuKepa0f0eh
         sKbAzW23vIfeIFGefD5Blgv/wsF+u+3AMizvwZWwPaDOxQDB2Ni6xTL5X4QjFt2J0SCT
         Yy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qw29AdXtCYZRa8G3I3RQgCCnOcHR3ivBh4i+1lH4G8A=;
        b=MfTVDLYGSRERbghOrW8T7yzwxWvrJYvxAcy2G8xQrTkBaZxQ0rWTACwVTLCoXh/bYY
         WfJ2RXIC5zsRvY7JtMTrio+fGD5uLq7porDW/2Oa5ZHCL+r9u3SfUqgVnoNkvh6U8v5t
         /MJREs8hhFtp6iSE73pzB/DKdx1LwA3oXyO3WEj+BoniQ9pZ15frHTiMfeCmP93D33lv
         m0KCgQhKy4J6GZ7b6Y1uQ2PSvwyTwvJDvN8XElg7UuIp/1IOwnRxB2W3X5WYx311N2tM
         KjFioWZenkRWqEPvQwQJujkAxDDevghl6vw+bt3WEJMfxg4uxjOvxlYYR6QiVLTkHiFU
         hjJA==
X-Gm-Message-State: AOAM533SjaLw6JXGlmsoRgsIqJhX1WfBQNaZnf1pughjpw3JhtXx9mOc
        WER8iRzL3rqjWeIKLp8OdokdCeJruXVqZiLAubHGUA==
X-Google-Smtp-Source: ABdhPJylxkCeLNpusq7Kv7ORjJaYhNOus9fuu//uDY4QHsj0OCxPfeDDfiLhoChbm0j82d3PuxI5tlh4lc49+YOVygQ=
X-Received: by 2002:aa7:dc18:: with SMTP id b24mr14613834edu.285.1600059893857;
 Sun, 13 Sep 2020 22:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-6-haoluo@google.com>
 <CAEf4Bza2W9jO3FRCf_y44SwhUHr=WoCLigqLh3pUMMOaUBF64w@mail.gmail.com>
In-Reply-To: <CAEf4Bza2W9jO3FRCf_y44SwhUHr=WoCLigqLh3pUMMOaUBF64w@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Sun, 13 Sep 2020 22:04:42 -0700
Message-ID: <CA+khW7hJV5iwmwnTNL5Uw07szfjtMoqumGO9BVhAyddevH3hMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/6] bpf: Introduce bpf_this_cpu_ptr()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for taking a look!

On Fri, Sep 4, 2020 at 1:09 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Add bpf_this_cpu_ptr() to help access percpu var on this cpu. This
> > helper always returns a valid pointer, therefore no need to check
> > returned value for NULL. Also note that all programs run with
> > preemption disabled, which means that the returned pointer is stable
> > during all the execution of the program.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> looks good, few small things, but otherwise:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
[...]
> >
> >  /* eBPF function prototype used by verifier to allow BPF_CALLs from eBPF programs
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index d0ec94d5bdbf..e7ca91c697ed 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3612,6 +3612,19 @@ union bpf_attr {
> >   *             bpf_per_cpu_ptr() must check the returned value.
> >   *     Return
> >   *             A generic pointer pointing to the kernel percpu variable on *cpu*.
> > + *
> > + * void *bpf_this_cpu_ptr(const void *percpu_ptr)
> > + *     Description
> > + *             Take a pointer to a percpu ksym, *percpu_ptr*, and return a
> > + *             pointer to the percpu kernel variable on this cpu. See the
> > + *             description of 'ksym' in **bpf_per_cpu_ptr**\ ().
> > + *
> > + *             bpf_this_cpu_ptr() has the same semantic as this_cpu_ptr() in
> > + *             the kernel. Different from **bpf_per_cpu_ptr**\ (), it would
> > + *             never return NULL.
> > + *     Return
> > + *             A generic pointer pointing to the kernel percpu variable on
>
> what's "a generic pointer"? is it as opposed to sk_buff pointer or something?
>

Ack. "A pointer" should be good enough. I wrote "generic pointer"
because the per_cpu_ptr() in kernel code is a macro, whose returned
value is a typed pointer, IIUC. But here we are missing the type. This
is another difference between this helper and per_cpu_ptr(). But this
may not matter.

> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index a702600ff581..e070d2abc405 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5016,8 +5016,10 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> >                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> >                 regs[BPF_REG_0].id = ++env->id_gen;
> >                 regs[BPF_REG_0].mem_size = meta.mem_size;
> > -       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
> > +       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL ||
> > +                  fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID) {
> >                 const struct btf_type *t;
> > +               bool not_null = fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID;
>
> nit: this is fine, but I'd inline it below
>

Ack.

> >
> >                 mark_reg_known_zero(env, regs, BPF_REG_0);
> >                 t = btf_type_skip_modifiers(btf_vmlinux, meta.ret_btf_id, NULL);
> > @@ -5034,10 +5036,12 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> >                                         tname, PTR_ERR(ret));
> >                                 return -EINVAL;
> >                         }
> > -                       regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> > +                       regs[BPF_REG_0].type = not_null ?
> > +                               PTR_TO_MEM : PTR_TO_MEM_OR_NULL;
> >                         regs[BPF_REG_0].mem_size = tsize;
> >                 } else {
> > -                       regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
> > +                       regs[BPF_REG_0].type = not_null ?
> > +                               PTR_TO_BTF_ID : PTR_TO_BTF_ID_OR_NULL;
> >                         regs[BPF_REG_0].btf_id = meta.ret_btf_id;
> >                 }
> >         } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index d474c1530f87..466acf82a9c7 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1160,6 +1160,18 @@ static const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
> >         .arg2_type      = ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_1(bpf_this_cpu_ptr, const void *, percpu_ptr)
> > +{
> > +       return (u64)this_cpu_ptr(percpu_ptr);
>
> see previous comment, this might trigger unnecessary compilation
> warnings on 32-bit arches
>

Ack. Will cast to "unsigned long". Thanks for catching this!


> > +}
> > +
> > +static const struct bpf_func_proto bpf_this_cpu_ptr_proto = {
> > +       .func           = bpf_this_cpu_ptr,
> > +       .gpl_only       = false,
> > +       .ret_type       = RET_PTR_TO_MEM_OR_BTF_ID,
> > +       .arg1_type      = ARG_PTR_TO_PERCPU_BTF_ID,
> > +};
> > +
>
> [...]
