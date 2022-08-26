Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B85A1E61
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiHZBvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244630AbiHZBvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:51:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9138210F4;
        Thu, 25 Aug 2022 18:51:00 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id f3so133465ilq.5;
        Thu, 25 Aug 2022 18:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TCqawMB1BroOCCY1cc8Q17JbFwztT5yJfejMYO+xyio=;
        b=A8fs/dlzuT6PUty0lbVyz0q0+xTQqIHFn15K6fRclJhp9s2LfmcuUI1X0RkTD8cJkl
         JXE+z/4FETSi2C7j2KWcDp0fGPO5GPHUYz3vuJX3TQWvg/WVTZRLbDVyZJwYp/cTFWhu
         UY3tK01OANEecnfD93Xz1SpRzkCoJ6a8U4N9a1iSg0611WuHVi1I/XB4WQNlk2kYMwMk
         qSfUSTN/7e/pyxn2/2J7dE+h4MlRptsC+gAtOX9cslMaygc5RSPV63CZOnbWtJ/gYhs9
         loHwDCFrFXY1SN+EGuWfF7SaLaqRXLeUcyrdctrvKpe5uLjp71c4uKhzfaeKUhc27xlW
         9THQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TCqawMB1BroOCCY1cc8Q17JbFwztT5yJfejMYO+xyio=;
        b=dFWW+AMkO4cECtwNiHUInsJqkEYKW1Vt0et2TOUDgIJiwtuKwuD3B3RurzrIjB9Pj6
         T3h6WVDbbRaI1tPMvOIp4iWYkyQum73PGim2DgfWJdwJBZ3cxdu2ZbmcmAkiOB4geNl9
         F+Kt6QyWdfkCCeixOV+QWJUA9GjfYpqZjpJ/FBS199zCVPlyOm4Kmq0/HvMDjeV+6hNN
         MR2/CXCy6KzdfRt3id8fhUi00Z/sjKLMbPnzfE38bd5Xw3H/RixHh4bE4IErHxaXy3V0
         VLOAzWNk9OkF+iwMIv6erPNkpAxYGAnT+sC2/FBVwsfjoXiyHykM/WshexccXGn9cK+I
         xIJw==
X-Gm-Message-State: ACgBeo2RW2ACiWi23ydnBfSLpAZIH+gsyezFsxlsiSDBa/zWCml392Ai
        PKhtiTQsXclySh9bIEjiTTPoWimkAF3ty2YGsgw=
X-Google-Smtp-Source: AA6agR7mPpEE04KxGm5s+rx+HDYxbojQyCxdvOMGim2Cjswq1vX3nSCs02H46wmyRz6//iZCZ3W+P59NEF3AZIyCb+M=
X-Received: by 2002:a05:6e02:1c04:b0:2df:6b58:5fe8 with SMTP id
 l4-20020a056e021c0400b002df6b585fe8mr3180072ilh.68.1661478659768; Thu, 25 Aug
 2022 18:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
In-Reply-To: <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 03:50:23 +0200
Message-ID: <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
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

On Fri, 26 Aug 2022 at 03:42, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > When a function was trying to access data from context in a syscall eBPF
> > program, the verifier was rejecting the call unless it was accessing the
> > first element.
> > This is because the syscall context is not known at compile time, and
> > so we need to check this when actually accessing it.
> >
> > Check for the valid memory access if there is no convert_ctx callback,
> > and allow such situation to happen.
> >
> > There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> > will check that the types are matching, which is a good thing, but to
> > have an accurate result, it hides the fact that the context register may
> > be null. This makes env->prog->aux->max_ctx_offset being set to the size
> > of the context, which is incompatible with a NULL context.
> >
> > Solve that last problem by storing max_ctx_offset before the type check
> > and restoring it after.
> >
> > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >
> > changes in v9:
> > - rewrote the commit title and description
> > - made it so all functions can make use of context even if there is
> >   no convert_ctx
> > - remove the is_kfunc field in bpf_call_arg_meta
> >
> > changes in v8:
> > - fixup comment
> > - return -EACCESS instead of -EINVAL for consistency
> >
> > changes in v7:
> > - renamed access_t into atype
> > - allow zero-byte read
> > - check_mem_access() to the correct offset/size
> >
> > new in v6
> > ---
> >  kernel/bpf/btf.c      | 11 ++++++++++-
> >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> >  2 files changed, 29 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 903719b89238..386300f52b23 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >  {
> >         struct bpf_prog *prog = env->prog;
> >         struct btf *btf = prog->aux->btf;
> > +       u32 btf_id, max_ctx_offset;
> >         bool is_global;
> > -       u32 btf_id;
> >         int err;
> >
> >         if (!prog->aux->func_info)
> > @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> >         if (prog->aux->func_info_aux[subprog].unreliable)
> >                 return -EINVAL;
> >
> > +       /* subprogs arguments are not actually accessing the data, we need
> > +        * to check for the types if they match.
> > +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> > +        * given that this function will have a side effect of changing it.
> > +        */
> > +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> > +
> >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> >         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> >
> > +       env->prog->aux->max_ctx_offset = max_ctx_offset;
>
> I don't understand this.
> If we pass a ctx into a helper and it's going to
> access [0..N] bytes from it why do we need to hide it?
> max_ctx_offset will be used later raw_tp, tp, syscall progs
> to determine whether it's ok to load them.
> By hiding the actual size of access somebody can construct
> a prog that reads out of bounds.
> How is this related to NULL-ness property?

Same question, was just typing exactly the same thing.

>
> > +
> >         /* Compiler optimizations can remove arguments from static functions
> >          * or mismatched type can be passed into a global function.
> >          * In such cases mark the function as unreliable from BTF point of view.
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 2c1f8069f7b7..d694f43ab911 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5229,6 +5229,25 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
> >                                 env,
> >                                 regno, reg->off, access_size,
> >                                 zero_size_allowed, ACCESS_HELPER, meta);
> > +       case PTR_TO_CTX:
> > +               /* in case the function doesn't know how to access the context,
> > +                * (because we are in a program of type SYSCALL for example), we
> > +                * can not statically check its size.
> > +                * Dynamically check it now.
> > +                */
> > +               if (!env->ops->convert_ctx_access) {
> > +                       enum bpf_access_type atype = meta && meta->raw_mode ? BPF_WRITE : BPF_READ;
> > +                       int offset = access_size - 1;
> > +
> > +                       /* Allow zero-byte read from PTR_TO_CTX */
> > +                       if (access_size == 0)
> > +                               return zero_size_allowed ? 0 : -EACCES;
> > +
> > +                       return check_mem_access(env, env->insn_idx, regno, offset, BPF_B,
> > +                                               atype, -1, false);
> > +               }
>
> This part looks good alone. Without max_ctx_offset save/restore.

+1, save/restore would be incorrect.
