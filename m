Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B1F5A6649
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiH3O3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 10:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiH3O3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:29:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857F861D96
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661869777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmXShkPGu5qohlisPijwUoqxiVIKAZ+9/TfZzFh7608=;
        b=eAZwpzBRq66v6mdO4T8oG9UPPoc/kb9yp97P6UazL9CpW8F5dQPmFTyKof7svpybYwCxjO
        m2b79YQUVHj7uFoxT+IilbO5glGjw3scJH5NJOb17zjbqbOZH5lekyMIBKZ34fvnH1Sgoo
        qBe3ZNJx8MgFKh7chIOYczlZDBoy+Zo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-274-9M5JOG0_OPSMGCsuVxa0rQ-1; Tue, 30 Aug 2022 10:29:36 -0400
X-MC-Unique: 9M5JOG0_OPSMGCsuVxa0rQ-1
Received: by mail-pj1-f71.google.com with SMTP id g9-20020a17090a290900b001fd59cc2c14so4921400pjd.7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lmXShkPGu5qohlisPijwUoqxiVIKAZ+9/TfZzFh7608=;
        b=ljslbkBb7Agawonij26NlyLWBIPTZoX4qmumReAEqn7aH39o07tL1zaXGbTRR7kdS2
         PKCcWxSj1zirBh0t/iOGqQN6z9ltN/tmiYtGg8odAcGL80x7F8y0C8A0dPPPX7TqsBt6
         AUWnXcv5yBskG+s34mG1Ocp3uFcnSYohf9eTQisONW17HwrpqmmiOcpOs98BMmJxyW2S
         DdGE4V640FyN/Vx6KuDDb1lRJZ2QaEmfhhqmaQmlS7whHflmhjV0l6enrfStqrPUukgM
         8YgFto92I+OVxu2X7DuCQGp22tY9WNhWqFbkaXQ+gKoPFHFpwCppLsJDCIe02qSUmXMR
         5Mtw==
X-Gm-Message-State: ACgBeo3EAu2YNLRlHwpRcRAjcCf60jimzYIskr6HakpLvYAdwsplr/IJ
        Pg89XeagoBMUmqZs3yqRpFe3cRs1crX9aC9HrdgiTjpOodeeQqAX+/R11MgSoCFBOLVxyc6RmX0
        DB4kFr4E2fGCG1RGXdesEdsTDhIX1+Tst
X-Received: by 2002:a63:d10b:0:b0:41d:bd7d:7759 with SMTP id k11-20020a63d10b000000b0041dbd7d7759mr18107751pgg.196.1661869775388;
        Tue, 30 Aug 2022 07:29:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ZkHiVpznHXYfoQbkr7dm3Zi5mkVALp/HWJ4F89gPVcA8KOGuI5YxXe4p2AipIfQA48i4dFJ6SAqik3HjUw/A=
X-Received: by 2002:a63:d10b:0:b0:41d:bd7d:7759 with SMTP id
 k11-20020a63d10b000000b0041dbd7d7759mr18107710pgg.196.1661869775042; Tue, 30
 Aug 2022 07:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
In-Reply-To: <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 30 Aug 2022 16:29:23 +0200
Message-ID: <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 3:51 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, 26 Aug 2022 at 03:42, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > When a function was trying to access data from context in a syscall eBPF
> > > program, the verifier was rejecting the call unless it was accessing the
> > > first element.
> > > This is because the syscall context is not known at compile time, and
> > > so we need to check this when actually accessing it.
> > >
> > > Check for the valid memory access if there is no convert_ctx callback,
> > > and allow such situation to happen.
> > >
> > > There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> > > will check that the types are matching, which is a good thing, but to
> > > have an accurate result, it hides the fact that the context register may
> > > be null. This makes env->prog->aux->max_ctx_offset being set to the size
> > > of the context, which is incompatible with a NULL context.
> > >
> > > Solve that last problem by storing max_ctx_offset before the type check
> > > and restoring it after.
> > >
> > > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > >
> > > ---
> > >
> > > changes in v9:
> > > - rewrote the commit title and description
> > > - made it so all functions can make use of context even if there is
> > >   no convert_ctx
> > > - remove the is_kfunc field in bpf_call_arg_meta
> > >
> > > changes in v8:
> > > - fixup comment
> > > - return -EACCESS instead of -EINVAL for consistency
> > >
> > > changes in v7:
> > > - renamed access_t into atype
> > > - allow zero-byte read
> > > - check_mem_access() to the correct offset/size
> > >
> > > new in v6
> > > ---
> > >  kernel/bpf/btf.c      | 11 ++++++++++-
> > >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 903719b89238..386300f52b23 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > >  {
> > >         struct bpf_prog *prog = env->prog;
> > >         struct btf *btf = prog->aux->btf;
> > > +       u32 btf_id, max_ctx_offset;
> > >         bool is_global;
> > > -       u32 btf_id;
> > >         int err;
> > >
> > >         if (!prog->aux->func_info)
> > > @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > >         if (prog->aux->func_info_aux[subprog].unreliable)
> > >                 return -EINVAL;
> > >
> > > +       /* subprogs arguments are not actually accessing the data, we need
> > > +        * to check for the types if they match.
> > > +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> > > +        * given that this function will have a side effect of changing it.
> > > +        */
> > > +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> > > +
> > >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > >         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> > >
> > > +       env->prog->aux->max_ctx_offset = max_ctx_offset;
> >
> > I don't understand this.
> > If we pass a ctx into a helper and it's going to
> > access [0..N] bytes from it why do we need to hide it?
> > max_ctx_offset will be used later raw_tp, tp, syscall progs
> > to determine whether it's ok to load them.
> > By hiding the actual size of access somebody can construct
> > a prog that reads out of bounds.
> > How is this related to NULL-ness property?
>
> Same question, was just typing exactly the same thing.

The test I have that is failing in patch 2/23 is the following, with
args being set to NULL by userspace:

SEC("syscall")
int kfunc_syscall_test_null(struct syscall_test_args *args)
{
       bpf_kfunc_call_test_mem_len_pass1(args, 0);

       return 0;
}

Basically:
if userspace declares the following:
 DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
               .ctx_in = NULL,
               .ctx_size_in = 0,
       );

The verifier is happy with the current released kernel:
kfunc_syscall_test_fail() never dereferences the ctx pointer, it just
passes it around to bpf_kfunc_call_test_mem_len_pass1(), which in turn
is also happy because it says it is not accessing the data at all (0
size memory parameter).

In the current code, check_helper_mem_access() actually returns
-EINVAL, but doesn't change max_ctx_offset (it's still at the value of
0 here). The program is now marked as unreliable, but the verifier
goes on.

When adding this patch, if we declare a syscall eBPF (or any other
function that doesn't have env->ops->convert_ctx_access), the previous
"test" is failing because this ensures the syscall program has to have
a valid ctx pointer.
btf_check_func_arg_match() now calls check_mem_access() which
basically validates the fact that the program can dereference the ctx.

So now, without the max_ctx_offset store/restore, the verifier
enforces that the provided ctx is not null.

What I thought that would happen was that if we were to pass a NULL
context from userspace, but the eBPF program dereferences it (or in
that case have a subprog or a function call that dereferences it),
then max_ctx_offset would still be set to the proper value because of
that internal dereference, and so the verifier would reject with
-EINVAL the call to the eBPF program.

If I add another test that has the following ebpf prog (with ctx_in
being set to NULL by the userspace):

SEC("syscall")
int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
{
       bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));

       return 0;
}

Then the call of the program is actually failing with -EINVAL, even
with this patch.

But again, if setting from userspace a ctx of NULL with a 0 size is
not considered as valid, then we can just drop that hunk and add a
test to enforce it.

Cheers,
Benjamin

>
> >
> > > +
> > >         /* Compiler optimizations can remove arguments from static functions
> > >          * or mismatched type can be passed into a global function.
> > >          * In such cases mark the function as unreliable from BTF point of view.
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 2c1f8069f7b7..d694f43ab911 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -5229,6 +5229,25 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
> > >                                 env,
> > >                                 regno, reg->off, access_size,
> > >                                 zero_size_allowed, ACCESS_HELPER, meta);
> > > +       case PTR_TO_CTX:
> > > +               /* in case the function doesn't know how to access the context,
> > > +                * (because we are in a program of type SYSCALL for example), we
> > > +                * can not statically check its size.
> > > +                * Dynamically check it now.
> > > +                */
> > > +               if (!env->ops->convert_ctx_access) {
> > > +                       enum bpf_access_type atype = meta && meta->raw_mode ? BPF_WRITE : BPF_READ;
> > > +                       int offset = access_size - 1;
> > > +
> > > +                       /* Allow zero-byte read from PTR_TO_CTX */
> > > +                       if (access_size == 0)
> > > +                               return zero_size_allowed ? 0 : -EACCES;
> > > +
> > > +                       return check_mem_access(env, env->insn_idx, regno, offset, BPF_B,
> > > +                                               atype, -1, false);
> > > +               }
> >
> > This part looks good alone. Without max_ctx_offset save/restore.
>
> +1, save/restore would be incorrect.
>

