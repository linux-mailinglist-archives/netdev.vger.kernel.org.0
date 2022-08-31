Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86965A84D6
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiHaR5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 13:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiHaR5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 13:57:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFCBD7CFE
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lKRE16b9MM8u6Z8O6Bdi3U8ibkp6UbNP1fi8My+b5A8=;
        b=VYG3BHLtpT+3HSAtiCg2HvePBO+xqAACMKFW91pU+WYQMKdCy2/guomaQ0jNd+wIE6Jabn
        eqb//43YD6bqgQFZPR+8o1XOelDwEI3vNWFPedhg6T2tKoaI+WMZZAjhxVDc3eZgDfV2nN
        s9pF5aBI+ccvpFjz/0TrlWXz3O9yptE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-512-zcpBr-p7PjOOXqLPnyviAQ-1; Wed, 31 Aug 2022 13:56:58 -0400
X-MC-Unique: zcpBr-p7PjOOXqLPnyviAQ-1
Received: by mail-pj1-f69.google.com with SMTP id a17-20020a17090abe1100b001fda49516e2so14082pjs.2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 10:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lKRE16b9MM8u6Z8O6Bdi3U8ibkp6UbNP1fi8My+b5A8=;
        b=U/m/E/SokiJDV3t/zPK68zbQ+sSVu0Xe5z7W6OxF5NBhWEbjPSQ4uorI+ZOvYoR5p+
         YPWFCj3gpnv1e6rUDSFGY1zf/rsP7VrihTwNaIzHbfbA/dW94+AdOcXFuYoqPY9KXKcE
         9qjC9hgpLqwQ1dF8ZMLP2BD4pusKc9xgxdfham9DZvCLL/LavPrxYXz9iXEDHgO/r5TS
         Lbi2+BuMyCvEY8Gnp/58gm8WoJbTpIGVOGDE3zI7i7IKS/suxLMN7Z+0rh50DdwV1rsH
         ngvVZKL4k2UkyuQ6TaWD7xPnNWl1ApqYSG04YNNaZHXgOJdGhBpESrk5OBo1DyZR8g/7
         5VsA==
X-Gm-Message-State: ACgBeo33MV+nYF+x4pcwqbhHjtyG+w+2pqDVDbQ4gXdJ+SaM4YRsx5R6
        UIzqGJIaQD8R50FpQJkliiK5PusM01iY0jAvBVx5D5JeGYy7lCfPvIm0wxcgninu7qSaQOMPbH1
        voKEH71pjJB6eemJ8cAP8b0KFrbEYtPi/
X-Received: by 2002:a65:6255:0:b0:42c:87b1:485b with SMTP id q21-20020a656255000000b0042c87b1485bmr8853670pgv.491.1661968617020;
        Wed, 31 Aug 2022 10:56:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7yF6XgnbUA7X7pkH/iSvWC9vC651aFLswA1iXydDYqeAQponIFLXm+j24vx9ittOajohLxG7OhhxuSOM34jyE=
X-Received: by 2002:a65:6255:0:b0:42c:87b1:485b with SMTP id
 q21-20020a656255000000b0042c87b1485bmr8853631pgv.491.1661968616657; Wed, 31
 Aug 2022 10:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
 <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com> <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com>
In-Reply-To: <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Wed, 31 Aug 2022 19:56:45 +0200
Message-ID: <CAO-hwJK9uHTWCg3_6jrPF6UKiamkNfj=cuH5mHauoLX+0udV9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 6:37 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 30, 2022 at 7:29 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > On Fri, Aug 26, 2022 at 3:51 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Fri, 26 Aug 2022 at 03:42, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
> > > > <benjamin.tissoires@redhat.com> wrote:
> > > > >
> > > > > When a function was trying to access data from context in a syscall eBPF
> > > > > program, the verifier was rejecting the call unless it was accessing the
> > > > > first element.
> > > > > This is because the syscall context is not known at compile time, and
> > > > > so we need to check this when actually accessing it.
> > > > >
> > > > > Check for the valid memory access if there is no convert_ctx callback,
> > > > > and allow such situation to happen.
> > > > >
> > > > > There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> > > > > will check that the types are matching, which is a good thing, but to
> > > > > have an accurate result, it hides the fact that the context register may
> > > > > be null. This makes env->prog->aux->max_ctx_offset being set to the size
> > > > > of the context, which is incompatible with a NULL context.
> > > > >
> > > > > Solve that last problem by storing max_ctx_offset before the type check
> > > > > and restoring it after.
> > > > >
> > > > > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > >
> > > > > ---
> > > > >
> > > > > changes in v9:
> > > > > - rewrote the commit title and description
> > > > > - made it so all functions can make use of context even if there is
> > > > >   no convert_ctx
> > > > > - remove the is_kfunc field in bpf_call_arg_meta
> > > > >
> > > > > changes in v8:
> > > > > - fixup comment
> > > > > - return -EACCESS instead of -EINVAL for consistency
> > > > >
> > > > > changes in v7:
> > > > > - renamed access_t into atype
> > > > > - allow zero-byte read
> > > > > - check_mem_access() to the correct offset/size
> > > > >
> > > > > new in v6
> > > > > ---
> > > > >  kernel/bpf/btf.c      | 11 ++++++++++-
> > > > >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> > > > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > > index 903719b89238..386300f52b23 100644
> > > > > --- a/kernel/bpf/btf.c
> > > > > +++ b/kernel/bpf/btf.c
> > > > > @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > > >  {
> > > > >         struct bpf_prog *prog = env->prog;
> > > > >         struct btf *btf = prog->aux->btf;
> > > > > +       u32 btf_id, max_ctx_offset;
> > > > >         bool is_global;
> > > > > -       u32 btf_id;
> > > > >         int err;
> > > > >
> > > > >         if (!prog->aux->func_info)
> > > > > @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > > >         if (prog->aux->func_info_aux[subprog].unreliable)
> > > > >                 return -EINVAL;
> > > > >
> > > > > +       /* subprogs arguments are not actually accessing the data, we need
> > > > > +        * to check for the types if they match.
> > > > > +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> > > > > +        * given that this function will have a side effect of changing it.
> > > > > +        */
> > > > > +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> > > > > +
> > > > >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > > > >         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> > > > >
> > > > > +       env->prog->aux->max_ctx_offset = max_ctx_offset;
> > > >
> > > > I don't understand this.
> > > > If we pass a ctx into a helper and it's going to
> > > > access [0..N] bytes from it why do we need to hide it?
> > > > max_ctx_offset will be used later raw_tp, tp, syscall progs
> > > > to determine whether it's ok to load them.
> > > > By hiding the actual size of access somebody can construct
> > > > a prog that reads out of bounds.
> > > > How is this related to NULL-ness property?
> > >
> > > Same question, was just typing exactly the same thing.
> >
> > The test I have that is failing in patch 2/23 is the following, with
> > args being set to NULL by userspace:
> >
> > SEC("syscall")
> > int kfunc_syscall_test_null(struct syscall_test_args *args)
> > {
> >        bpf_kfunc_call_test_mem_len_pass1(args, 0);
> >
> >        return 0;
> > }
> >
> > Basically:
> > if userspace declares the following:
> >  DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
> >                .ctx_in = NULL,
> >                .ctx_size_in = 0,
> >        );
> >
> > The verifier is happy with the current released kernel:
> > kfunc_syscall_test_fail() never dereferences the ctx pointer, it just
> > passes it around to bpf_kfunc_call_test_mem_len_pass1(), which in turn
> > is also happy because it says it is not accessing the data at all (0
> > size memory parameter).
> >
> > In the current code, check_helper_mem_access() actually returns
> > -EINVAL, but doesn't change max_ctx_offset (it's still at the value of
> > 0 here). The program is now marked as unreliable, but the verifier
> > goes on.
> >
> > When adding this patch, if we declare a syscall eBPF (or any other
> > function that doesn't have env->ops->convert_ctx_access), the previous
> > "test" is failing because this ensures the syscall program has to have
> > a valid ctx pointer.
> > btf_check_func_arg_match() now calls check_mem_access() which
> > basically validates the fact that the program can dereference the ctx.
> >
> > So now, without the max_ctx_offset store/restore, the verifier
> > enforces that the provided ctx is not null.
> >
> > What I thought that would happen was that if we were to pass a NULL
> > context from userspace, but the eBPF program dereferences it (or in
> > that case have a subprog or a function call that dereferences it),
> > then max_ctx_offset would still be set to the proper value because of
> > that internal dereference, and so the verifier would reject with
> > -EINVAL the call to the eBPF program.
> >
> > If I add another test that has the following ebpf prog (with ctx_in
> > being set to NULL by the userspace):
> >
> > SEC("syscall")
> > int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> > {
> >        bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> >
> >        return 0;
> > }
> >
> > Then the call of the program is actually failing with -EINVAL, even
> > with this patch.
> >
> > But again, if setting from userspace a ctx of NULL with a 0 size is
> > not considered as valid, then we can just drop that hunk and add a
> > test to enforce it.
>
> PTR_TO_CTX in the verifier always means valid pointer.
> All code paths in the verifier assumes that it's not NULL.
> Pointer to skb, to xdp, to pt_regs, etc.
> The syscall prog type is little bit special, since it
> makes sense not to pass any argument to such prog.
> So ctx_size_in == 0 is enforced after the verification:
> if (ctx_size_in < prog->aux->max_ctx_offset ||
>     ctx_size_in > U16_MAX)
>           return -EINVAL;
> The verifier should be able to proceed assuming ctx != NULL
> and remember max max_ctx_offset.
> If max_ctx_offset == 4 and ctx_size_in == 0 then
> it doesn't matter whether the actual 'ctx' pointer is NULL
> or points to a valid memory.
> So it's ok for the verifier to assume ctx != NULL everywhere.

Ok, thanks for the detailed explanation.

>
> Back to the issue at hand.
> With this patch the line:
>     bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> will be seen as access_size == sizeof(*args), right?
> So this part:
> +                       if (access_size == 0)
> +                               return zero_size_allowed ? 0 : -EACCES;
>
> will be skipped and
> the newly added check_mem_access() will call check_ctx_access()
> which will call syscall_prog_is_valid_access() and it will say
> that any off < U16_MAX is fine and will simply
> record max max_ctx_offset.
> The ctx_size_in < prog->aux->max_ctx_offset check is done later.

Yep, this is correct and this is working now, with a proper error (and
no, this is not the error I am trying to fix, see below):

eBPF prog:
```
  SEC("?syscall")
  int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
  {
          bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
          return 0;
  }
```

before this patch (1/23):
* with ctx not NULL:
libbpf: prog 'kfunc_syscall_test_null_fail': BPF program load failed:
Invalid argument
R1 type=ctx expected=fp
arg#0 arg#1 memory, len pair leads to invalid memory access

 => this is not correct, we expect the program to be loaded (and it is
expected, this is the bug that is fixed)

* Same result with ctx being NULL from the caller

With just the hunk in kernel/bpf/verifier.c (so without touching max_ctx_offset:
* with ctx not NULL:
program is loaded, and executed correctly

* with ctx being NULL:
program is now loaded, but execution returns -EINVAL, as expected

So this case is fully solved by just the hunk in verifier.c

With the full patch:
same results, with or without ctx being set to NULL, so no side effects.

>
> So when you're saying:
> "call of the program is actually failing with -EINVAL"
> that's the check you're referring to?

No. I am referring to the following eBPF program:
```
  SEC("syscall")
  int kfunc_syscall_test_null(struct syscall_test_args *args)
  {
           return 0;
  }
```

(no calls, just the declaration of a program)

This one is supposed to be loaded and properly run whatever the
context is, right?

However, without the hunk in the btf.c file (max_ctx_offset), we have
the following (ctx is set to NULL by the userspace):
verify_success:FAIL:kfunc_syscall_test_null unexpected error: -22 (errno 22)

The reason is that the verifier is calling
btf_check_subprog_arg_match() on programs too, and considers that ctx
is not NULL, and bumps the max_ctx_offset value.

>
> If so, everything works as expected.

Not exactly, we can not call a syscall program with a null context
without this hunk.

> The verifier thinks that bpf_kfunc_call_test_mem_len_pass1()
> can read that many bytes from args,
> so it has to reject running the loaded prog in bpf_prog_test_run_syscall().

Yes, that part works. I am focusing on the program declaration.

>
> So what are you trying to achieve ?

See above :)

> Make the verifier understand that ctx can be NULL ?

Nope. I am fine with the way it is. But any eBPF (sub)prog is checked
against btf_check_subprog_arg_match(), which in turns marks all of
these calls accessing the entire ctx, even if the ctx is null when
that case is valid.

> If so that is a probably huge undertaking.
> Something else?
>

Hopefully this is clearer now.

Cheers,
Benjamin

