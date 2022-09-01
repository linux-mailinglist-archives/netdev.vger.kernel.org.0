Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF3C5A8C3A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 06:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiIAEPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 00:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiIAEP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 00:15:27 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649F52ED58;
        Wed, 31 Aug 2022 21:15:22 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s11so20884543edd.13;
        Wed, 31 Aug 2022 21:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5JSpU1QR2YVELHFzvSSyyf2pVK2J22SigUM2w1BDKSc=;
        b=HHTdkimlsO8d5i+9a9C62dYNhCVIDoasqJPBl+1Ci5DORlMl5s0ewUa1M2r76LeL9P
         57MCShbyOsPYCJC8qsLDv6gJEOPOFxdec7Y5kjfjUR38G61oO8WbbJyt9ILu9rsonr6P
         4f4/aoh3yPQXpzlrcp1jw38/FQ8lIJ9gmV3QzCKzlVWMR/nUOPcYfG44XW5rUGl1lwBT
         Fq+SjXsYQo5yV8fGJmIGB/fDcAlVZg9BUZ6MoqvdoTbIBriGCvS08R/hvGD7R0XdaL5C
         ZHiUQJYPOp+H1rfgwTCgiLadQWKjkZVwpN7MLf7fCfA8rKz6fPo4A5OyHofUejikBBxg
         HXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5JSpU1QR2YVELHFzvSSyyf2pVK2J22SigUM2w1BDKSc=;
        b=5Fk6ynNKZDXzn+c7Z+ZzSSy/R65hb2TaZA1C3IdqgMCCqkvNbrbRfLFfibTHpxIg3G
         Cq0lsgmRF/osfcC56pCULfvf6L62J2nZgSw6lXhS6QhAmYUjM6zmU9K9FiJJ44qnHz6j
         qoZaroBZ0spNnfqA9eGJyuXYMC5rICRMn4YmtE5BTLbv3pgg3zA7mQLmlo51ktnRkNFJ
         7JuCRt1BrCCN2E6EPtngd7hPiWYuUXBjzcgVNESbtPkl+ioFfa+esYDAYpllBHu7BPiO
         sVQ1ExEemb6b2aaUiMcFZHC8PKm/kK48t6ALQZ+lQ8gwawDOWMhCoE36AcUlbG4/5IT+
         D8yA==
X-Gm-Message-State: ACgBeo13xKFxfBoMb9S2x5lNgVCDMNm8mCFOEZ8dZsV4X90+GqLk1jRx
        6zuDuMO5c1Byu3PxOXvrcfeapinhehW6mJUtmQQ=
X-Google-Smtp-Source: AA6agR4qfIZbsIxB5vAtgKbtbizFNfSi9/4OOkflwc7Ld+WvJXNJpXsrW4Es6OlINw66dA2471PUDgLTa9cjvXB6L2s=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr27420244edb.333.1662005720762; Wed, 31
 Aug 2022 21:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
 <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
 <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com> <CAO-hwJK9uHTWCg3_6jrPF6UKiamkNfj=cuH5mHauoLX+0udV9w@mail.gmail.com>
In-Reply-To: <CAO-hwJK9uHTWCg3_6jrPF6UKiamkNfj=cuH5mHauoLX+0udV9w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Aug 2022 21:15:09 -0700
Message-ID: <CAADnVQLuL045Sxdvh8kfcNkmD55+Wz8fHU3RtH+oQyOgePU5Pw@mail.gmail.com>
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

On Wed, Aug 31, 2022 at 10:56 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Wed, Aug 31, 2022 at 6:37 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 30, 2022 at 7:29 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > On Fri, Aug 26, 2022 at 3:51 AM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > On Fri, 26 Aug 2022 at 03:42, Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
> > > > > <benjamin.tissoires@redhat.com> wrote:
> > > > > >
> > > > > > When a function was trying to access data from context in a syscall eBPF
> > > > > > program, the verifier was rejecting the call unless it was accessing the
> > > > > > first element.
> > > > > > This is because the syscall context is not known at compile time, and
> > > > > > so we need to check this when actually accessing it.
> > > > > >
> > > > > > Check for the valid memory access if there is no convert_ctx callback,
> > > > > > and allow such situation to happen.
> > > > > >
> > > > > > There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> > > > > > will check that the types are matching, which is a good thing, but to
> > > > > > have an accurate result, it hides the fact that the context register may
> > > > > > be null. This makes env->prog->aux->max_ctx_offset being set to the size
> > > > > > of the context, which is incompatible with a NULL context.
> > > > > >
> > > > > > Solve that last problem by storing max_ctx_offset before the type check
> > > > > > and restoring it after.
> > > > > >
> > > > > > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > >
> > > > > > ---
> > > > > >
> > > > > > changes in v9:
> > > > > > - rewrote the commit title and description
> > > > > > - made it so all functions can make use of context even if there is
> > > > > >   no convert_ctx
> > > > > > - remove the is_kfunc field in bpf_call_arg_meta
> > > > > >
> > > > > > changes in v8:
> > > > > > - fixup comment
> > > > > > - return -EACCESS instead of -EINVAL for consistency
> > > > > >
> > > > > > changes in v7:
> > > > > > - renamed access_t into atype
> > > > > > - allow zero-byte read
> > > > > > - check_mem_access() to the correct offset/size
> > > > > >
> > > > > > new in v6
> > > > > > ---
> > > > > >  kernel/bpf/btf.c      | 11 ++++++++++-
> > > > > >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> > > > > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > > > index 903719b89238..386300f52b23 100644
> > > > > > --- a/kernel/bpf/btf.c
> > > > > > +++ b/kernel/bpf/btf.c
> > > > > > @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > > > >  {
> > > > > >         struct bpf_prog *prog = env->prog;
> > > > > >         struct btf *btf = prog->aux->btf;
> > > > > > +       u32 btf_id, max_ctx_offset;
> > > > > >         bool is_global;
> > > > > > -       u32 btf_id;
> > > > > >         int err;
> > > > > >
> > > > > >         if (!prog->aux->func_info)
> > > > > > @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > > > >         if (prog->aux->func_info_aux[subprog].unreliable)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > +       /* subprogs arguments are not actually accessing the data, we need
> > > > > > +        * to check for the types if they match.
> > > > > > +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> > > > > > +        * given that this function will have a side effect of changing it.
> > > > > > +        */
> > > > > > +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> > > > > > +
> > > > > >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > > > > >         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> > > > > >
> > > > > > +       env->prog->aux->max_ctx_offset = max_ctx_offset;
> > > > >
> > > > > I don't understand this.
> > > > > If we pass a ctx into a helper and it's going to
> > > > > access [0..N] bytes from it why do we need to hide it?
> > > > > max_ctx_offset will be used later raw_tp, tp, syscall progs
> > > > > to determine whether it's ok to load them.
> > > > > By hiding the actual size of access somebody can construct
> > > > > a prog that reads out of bounds.
> > > > > How is this related to NULL-ness property?
> > > >
> > > > Same question, was just typing exactly the same thing.
> > >
> > > The test I have that is failing in patch 2/23 is the following, with
> > > args being set to NULL by userspace:
> > >
> > > SEC("syscall")
> > > int kfunc_syscall_test_null(struct syscall_test_args *args)
> > > {
> > >        bpf_kfunc_call_test_mem_len_pass1(args, 0);
> > >
> > >        return 0;
> > > }
> > >
> > > Basically:
> > > if userspace declares the following:
> > >  DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
> > >                .ctx_in = NULL,
> > >                .ctx_size_in = 0,
> > >        );
> > >
> > > The verifier is happy with the current released kernel:
> > > kfunc_syscall_test_fail() never dereferences the ctx pointer, it just
> > > passes it around to bpf_kfunc_call_test_mem_len_pass1(), which in turn
> > > is also happy because it says it is not accessing the data at all (0
> > > size memory parameter).
> > >
> > > In the current code, check_helper_mem_access() actually returns
> > > -EINVAL, but doesn't change max_ctx_offset (it's still at the value of
> > > 0 here). The program is now marked as unreliable, but the verifier
> > > goes on.
> > >
> > > When adding this patch, if we declare a syscall eBPF (or any other
> > > function that doesn't have env->ops->convert_ctx_access), the previous
> > > "test" is failing because this ensures the syscall program has to have
> > > a valid ctx pointer.
> > > btf_check_func_arg_match() now calls check_mem_access() which
> > > basically validates the fact that the program can dereference the ctx.
> > >
> > > So now, without the max_ctx_offset store/restore, the verifier
> > > enforces that the provided ctx is not null.
> > >
> > > What I thought that would happen was that if we were to pass a NULL
> > > context from userspace, but the eBPF program dereferences it (or in
> > > that case have a subprog or a function call that dereferences it),
> > > then max_ctx_offset would still be set to the proper value because of
> > > that internal dereference, and so the verifier would reject with
> > > -EINVAL the call to the eBPF program.
> > >
> > > If I add another test that has the following ebpf prog (with ctx_in
> > > being set to NULL by the userspace):
> > >
> > > SEC("syscall")
> > > int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> > > {
> > >        bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> > >
> > >        return 0;
> > > }
> > >
> > > Then the call of the program is actually failing with -EINVAL, even
> > > with this patch.
> > >
> > > But again, if setting from userspace a ctx of NULL with a 0 size is
> > > not considered as valid, then we can just drop that hunk and add a
> > > test to enforce it.
> >
> > PTR_TO_CTX in the verifier always means valid pointer.
> > All code paths in the verifier assumes that it's not NULL.
> > Pointer to skb, to xdp, to pt_regs, etc.
> > The syscall prog type is little bit special, since it
> > makes sense not to pass any argument to such prog.
> > So ctx_size_in == 0 is enforced after the verification:
> > if (ctx_size_in < prog->aux->max_ctx_offset ||
> >     ctx_size_in > U16_MAX)
> >           return -EINVAL;
> > The verifier should be able to proceed assuming ctx != NULL
> > and remember max max_ctx_offset.
> > If max_ctx_offset == 4 and ctx_size_in == 0 then
> > it doesn't matter whether the actual 'ctx' pointer is NULL
> > or points to a valid memory.
> > So it's ok for the verifier to assume ctx != NULL everywhere.
>
> Ok, thanks for the detailed explanation.
>
> >
> > Back to the issue at hand.
> > With this patch the line:
> >     bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> > will be seen as access_size == sizeof(*args), right?
> > So this part:
> > +                       if (access_size == 0)
> > +                               return zero_size_allowed ? 0 : -EACCES;
> >
> > will be skipped and
> > the newly added check_mem_access() will call check_ctx_access()
> > which will call syscall_prog_is_valid_access() and it will say
> > that any off < U16_MAX is fine and will simply
> > record max max_ctx_offset.
> > The ctx_size_in < prog->aux->max_ctx_offset check is done later.
>
> Yep, this is correct and this is working now, with a proper error (and
> no, this is not the error I am trying to fix, see below):
>
> eBPF prog:
> ```
>   SEC("?syscall")
>   int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
>   {
>           bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
>           return 0;
>   }
> ```
>
> before this patch (1/23):
> * with ctx not NULL:
> libbpf: prog 'kfunc_syscall_test_null_fail': BPF program load failed:
> Invalid argument
> R1 type=ctx expected=fp
> arg#0 arg#1 memory, len pair leads to invalid memory access
>
>  => this is not correct, we expect the program to be loaded (and it is
> expected, this is the bug that is fixed)
>
> * Same result with ctx being NULL from the caller
>
> With just the hunk in kernel/bpf/verifier.c (so without touching max_ctx_offset:
> * with ctx not NULL:
> program is loaded, and executed correctly
>
> * with ctx being NULL:
> program is now loaded, but execution returns -EINVAL, as expected
>
> So this case is fully solved by just the hunk in verifier.c
>
> With the full patch:
> same results, with or without ctx being set to NULL, so no side effects.
>
> >
> > So when you're saying:
> > "call of the program is actually failing with -EINVAL"
> > that's the check you're referring to?
>
> No. I am referring to the following eBPF program:
> ```
>   SEC("syscall")
>   int kfunc_syscall_test_null(struct syscall_test_args *args)
>   {
>            return 0;
>   }
> ```
>
> (no calls, just the declaration of a program)
>
> This one is supposed to be loaded and properly run whatever the
> context is, right?

Got it. Yes. Indeed.
The if (!env->ops->convert_ctx_access)
hunk alone would break existing progs because of
side effect of max_ctx_offset.
We have this unfortunate bit of code:
                ret = btf_check_subprog_arg_match(env, subprog, regs);
                if (ret == -EFAULT)
                        /* unlikely verifier bug. abort.
                         * ret == 0 and ret < 0 are sadly acceptable for
                         * main() function due to backward compatibility.
                         * Like socket filter program may be written as:
                         * int bpf_prog(struct pt_regs *ctx)
                         * and never dereference that ctx in the program.
                         * 'struct pt_regs' is a type mismatch for socket
                         * filter that should be using 'struct __sk_buff'.
                         */
                        goto out;

because btf_check_subprog_arg_match() is used to match arguments
for calling into a function and when the verifier just starts
to analyze a function.
Before this patch the btf_check_subprog_arg_match() would just
EINVAL on your above example and will proceed,
but with the patch the non zero max_ctx_offset will
disallow execution later and break things.
I think we need to clean up this bit of code.
Just save/restore of max_ctx_offset isn't going to work.
How about adding a flag to btf_check_subprog_arg_match
to indicate whether the verifier is processing 'call' insn
or just starting processing a function body and
then do
if (ptr_to_mem_ok && processing_call) ?
Still feels like a hack.
Maybe btf_check_func_arg_match() needs to be split to
disambiguate calling vs processing the body ?
And may cleanup the rest of that function ?
Like all of if (is_kfunc) applies only to 'calling' case.
Other ideas?
