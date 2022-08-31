Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFD45A8355
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiHaQhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiHaQhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:37:42 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEEFD632E;
        Wed, 31 Aug 2022 09:37:41 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id cu2so29605759ejb.0;
        Wed, 31 Aug 2022 09:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=LUc1UqoukDgf6zuzjdMnbiLk3tEUFc0BeZCBbwrHGVc=;
        b=Zmj3KU1so1VHDTsl7gOv5XB32FOEUvLV0NdxF0FQHBcWQEz7mhskRXMgiVSpbkMfxZ
         uJmfbu6vXn4c/c3rN3STlhTI/VsVCSz9I4ApkwdCfLzk9JOW4O2C39upN/3Hwa5npnGI
         ObpO8rCrqQS+JK0zyS7TSCoTx9Aqpt7WgJpesbXZtXTYVprMNAJO7mFqrIWq4LbakLtG
         tULp9dPKdduZvLAIRWqzH8xMyyDByKGRPCELu6VcTgmkJzsfyqijeTBdBUI2j6zfxovm
         iZALh1KYlM1I9CdYW7fZUkq3d1dnIcdyP83w9RiGI3qd89Mt2HUMYXJ9QbrGsfJe3NA9
         P20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=LUc1UqoukDgf6zuzjdMnbiLk3tEUFc0BeZCBbwrHGVc=;
        b=7bzBqsGv4bs3fiv9eBHjcZo5ElfDTID1Nn7TRML8CZWiMQxYNS7FoPaOw0XbFcVBkR
         q0bdCI++tk31yrltQHmBwy3O8qxzt0DlwGD3EVDF50+YXYyPRYnSLKo7NFiQCrEJPnGo
         rdmWfQmt4ESbT6ty2WhRTTUeYrgkBK2R33E2BFaRetCvUw/p/jGWyC9hLU88gJ5hY1Y+
         14uf0s0VJBp5wqjjme0vj2PBF5bVrv+z/4SXQsLPMnNEbWcxf2mWch6naPi2R9CbqboZ
         hEnK3B9/HMowB5v4WN1IWMefz1u8QdTGnU27nnAnVoIROVEVXxqs41khRsja1mtLDpLL
         a+fA==
X-Gm-Message-State: ACgBeo3s3Vb7YhlqvOwnAkNcXJ+m5IUnXu2yeJOpDDIEQlhaqiAWi00l
        FGZ2A8WGRdTTDZtBTe4s2RZW0H4am1+zXgJ3jkA=
X-Google-Smtp-Source: AA6agR58ACwmMSMkgLoOJCljtCvL1UxcY/VL++Iod5fhTfkYrsI40fI5tAfv7Wj9izVwK9oq9oZYnCtX4LvOE3mdlTo=
X-Received: by 2002:a17:906:ef90:b0:730:9cd8:56d7 with SMTP id
 ze16-20020a170906ef9000b007309cd856d7mr19836106ejb.94.1661963859777; Wed, 31
 Aug 2022 09:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com> <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
In-Reply-To: <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Aug 2022 09:37:28 -0700
Message-ID: <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
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

On Tue, Aug 30, 2022 at 7:29 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Fri, Aug 26, 2022 at 3:51 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Fri, 26 Aug 2022 at 03:42, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
> > > <benjamin.tissoires@redhat.com> wrote:
> > > >
> > > > When a function was trying to access data from context in a syscall eBPF
> > > > program, the verifier was rejecting the call unless it was accessing the
> > > > first element.
> > > > This is because the syscall context is not known at compile time, and
> > > > so we need to check this when actually accessing it.
> > > >
> > > > Check for the valid memory access if there is no convert_ctx callback,
> > > > and allow such situation to happen.
> > > >
> > > > There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> > > > will check that the types are matching, which is a good thing, but to
> > > > have an accurate result, it hides the fact that the context register may
> > > > be null. This makes env->prog->aux->max_ctx_offset being set to the size
> > > > of the context, which is incompatible with a NULL context.
> > > >
> > > > Solve that last problem by storing max_ctx_offset before the type check
> > > > and restoring it after.
> > > >
> > > > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > >
> > > > ---
> > > >
> > > > changes in v9:
> > > > - rewrote the commit title and description
> > > > - made it so all functions can make use of context even if there is
> > > >   no convert_ctx
> > > > - remove the is_kfunc field in bpf_call_arg_meta
> > > >
> > > > changes in v8:
> > > > - fixup comment
> > > > - return -EACCESS instead of -EINVAL for consistency
> > > >
> > > > changes in v7:
> > > > - renamed access_t into atype
> > > > - allow zero-byte read
> > > > - check_mem_access() to the correct offset/size
> > > >
> > > > new in v6
> > > > ---
> > > >  kernel/bpf/btf.c      | 11 ++++++++++-
> > > >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> > > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > index 903719b89238..386300f52b23 100644
> > > > --- a/kernel/bpf/btf.c
> > > > +++ b/kernel/bpf/btf.c
> > > > @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > >  {
> > > >         struct bpf_prog *prog = env->prog;
> > > >         struct btf *btf = prog->aux->btf;
> > > > +       u32 btf_id, max_ctx_offset;
> > > >         bool is_global;
> > > > -       u32 btf_id;
> > > >         int err;
> > > >
> > > >         if (!prog->aux->func_info)
> > > > @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > >         if (prog->aux->func_info_aux[subprog].unreliable)
> > > >                 return -EINVAL;
> > > >
> > > > +       /* subprogs arguments are not actually accessing the data, we need
> > > > +        * to check for the types if they match.
> > > > +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> > > > +        * given that this function will have a side effect of changing it.
> > > > +        */
> > > > +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> > > > +
> > > >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > > >         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> > > >
> > > > +       env->prog->aux->max_ctx_offset = max_ctx_offset;
> > >
> > > I don't understand this.
> > > If we pass a ctx into a helper and it's going to
> > > access [0..N] bytes from it why do we need to hide it?
> > > max_ctx_offset will be used later raw_tp, tp, syscall progs
> > > to determine whether it's ok to load them.
> > > By hiding the actual size of access somebody can construct
> > > a prog that reads out of bounds.
> > > How is this related to NULL-ness property?
> >
> > Same question, was just typing exactly the same thing.
>
> The test I have that is failing in patch 2/23 is the following, with
> args being set to NULL by userspace:
>
> SEC("syscall")
> int kfunc_syscall_test_null(struct syscall_test_args *args)
> {
>        bpf_kfunc_call_test_mem_len_pass1(args, 0);
>
>        return 0;
> }
>
> Basically:
> if userspace declares the following:
>  DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
>                .ctx_in = NULL,
>                .ctx_size_in = 0,
>        );
>
> The verifier is happy with the current released kernel:
> kfunc_syscall_test_fail() never dereferences the ctx pointer, it just
> passes it around to bpf_kfunc_call_test_mem_len_pass1(), which in turn
> is also happy because it says it is not accessing the data at all (0
> size memory parameter).
>
> In the current code, check_helper_mem_access() actually returns
> -EINVAL, but doesn't change max_ctx_offset (it's still at the value of
> 0 here). The program is now marked as unreliable, but the verifier
> goes on.
>
> When adding this patch, if we declare a syscall eBPF (or any other
> function that doesn't have env->ops->convert_ctx_access), the previous
> "test" is failing because this ensures the syscall program has to have
> a valid ctx pointer.
> btf_check_func_arg_match() now calls check_mem_access() which
> basically validates the fact that the program can dereference the ctx.
>
> So now, without the max_ctx_offset store/restore, the verifier
> enforces that the provided ctx is not null.
>
> What I thought that would happen was that if we were to pass a NULL
> context from userspace, but the eBPF program dereferences it (or in
> that case have a subprog or a function call that dereferences it),
> then max_ctx_offset would still be set to the proper value because of
> that internal dereference, and so the verifier would reject with
> -EINVAL the call to the eBPF program.
>
> If I add another test that has the following ebpf prog (with ctx_in
> being set to NULL by the userspace):
>
> SEC("syscall")
> int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> {
>        bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
>
>        return 0;
> }
>
> Then the call of the program is actually failing with -EINVAL, even
> with this patch.
>
> But again, if setting from userspace a ctx of NULL with a 0 size is
> not considered as valid, then we can just drop that hunk and add a
> test to enforce it.

PTR_TO_CTX in the verifier always means valid pointer.
All code paths in the verifier assumes that it's not NULL.
Pointer to skb, to xdp, to pt_regs, etc.
The syscall prog type is little bit special, since it
makes sense not to pass any argument to such prog.
So ctx_size_in == 0 is enforced after the verification:
if (ctx_size_in < prog->aux->max_ctx_offset ||
    ctx_size_in > U16_MAX)
          return -EINVAL;
The verifier should be able to proceed assuming ctx != NULL
and remember max max_ctx_offset.
If max_ctx_offset == 4 and ctx_size_in == 0 then
it doesn't matter whether the actual 'ctx' pointer is NULL
or points to a valid memory.
So it's ok for the verifier to assume ctx != NULL everywhere.

Back to the issue at hand.
With this patch the line:
    bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
will be seen as access_size == sizeof(*args), right?
So this part:
+                       if (access_size == 0)
+                               return zero_size_allowed ? 0 : -EACCES;

will be skipped and
the newly added check_mem_access() will call check_ctx_access()
which will call syscall_prog_is_valid_access() and it will say
that any off < U16_MAX is fine and will simply
record max max_ctx_offset.
The ctx_size_in < prog->aux->max_ctx_offset check is done later.

So when you're saying:
"call of the program is actually failing with -EINVAL"
that's the check you're referring to?

If so, everything works as expected.
The verifier thinks that bpf_kfunc_call_test_mem_len_pass1()
can read that many bytes from args,
so it has to reject running the loaded prog in bpf_prog_test_run_syscall().

So what are you trying to achieve ?
Make the verifier understand that ctx can be NULL ?
If so that is a probably huge undertaking.
Something else?
