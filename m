Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591555A9D71
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiIAQsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiIAQsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:48:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8DF98351
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 09:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662050880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JmSTZNuoR5/0BLeN7G1KPisKeeRorhWXxUEtlv0SKGg=;
        b=EInNRLD/ShoVHoC+qC8nvhLqeBqMrK2mYZ1Xunag6uDPzVo42+gGrR5TJvtt9BwikvXr78
        iZPl6y9FmoqWWwVhCdVccdJIVc1194+DzCz5nJqJH0f1wEmgJqU3Cd7TaWzWRgGToTFPyb
        MWC04EYwHPfmXY97h+C5GmfL29+l96I=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-6-s7fpAQOteSRMI5vDAnhw-1; Thu, 01 Sep 2022 12:47:58 -0400
X-MC-Unique: 6-s7fpAQOteSRMI5vDAnhw-1
Received: by mail-pl1-f197.google.com with SMTP id c8-20020a170902d48800b0017545868987so3325148plg.15
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 09:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=JmSTZNuoR5/0BLeN7G1KPisKeeRorhWXxUEtlv0SKGg=;
        b=BiTwMLotXIHa/Yz1M6aTAqQnVjCmfzcRemwPflCyYmsxbKxmlq/kiK4NqxOG1JLf9K
         iCc8HB222gbdOVpe7sS+bG009PPuyVPEqbg/PJyJmJAe+2Ahk7uTTThzul6CUntySKme
         RAFBpC5HH+k4ki+m92n9Dj337b/L1cyLAUMZeDDP51yX7bH/VmtXHThn8Re54MJjV7FT
         XnPgDw2uPIl9J0jrUy/C2aGotZnGYTYChZscPOJtoL3IlMDOxJEloDuFDrvGWlEBGsmU
         HHMMxTlIg+h71xGWkIKeWI+O0szfnB9m+vu4LJuEotzIzggYwmoaGxYQJgYu5yJA3ntE
         ykTA==
X-Gm-Message-State: ACgBeo3pZ86r/1Rajo089VYOMojQvfHPGYJzLixjck5lvzzaANvnc9h9
        PTWhoRBCyWd8JymyqWQiufrb6LKMRqt+oEIAm5WL+JisTV2R547ZHkZevT1Lsyh28DtHBXPEbwJ
        CWHPN6cFQ7FBakoiDivhwqH+sLkgfyOfx
X-Received: by 2002:a17:903:120c:b0:172:728a:3b24 with SMTP id l12-20020a170903120c00b00172728a3b24mr31230805plh.61.1662050877612;
        Thu, 01 Sep 2022 09:47:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5V9baM7wbECIOLU2cc4dJ4lH8MVOMc1IGV9dE9JUZaUiy83PnHLzx+/7PJ3+AQ4GLfQUWhZJDTtOuHTUEUFkY=
X-Received: by 2002:a17:903:120c:b0:172:728a:3b24 with SMTP id
 l12-20020a170903120c00b00172728a3b24mr31230768plh.61.1662050877195; Thu, 01
 Sep 2022 09:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
 <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
 <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com>
 <CAO-hwJK9uHTWCg3_6jrPF6UKiamkNfj=cuH5mHauoLX+0udV9w@mail.gmail.com> <CAADnVQLuL045Sxdvh8kfcNkmD55+Wz8fHU3RtH+oQyOgePU5Pw@mail.gmail.com>
In-Reply-To: <CAADnVQLuL045Sxdvh8kfcNkmD55+Wz8fHU3RtH+oQyOgePU5Pw@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Thu, 1 Sep 2022 18:47:45 +0200
Message-ID: <CAO-hwJJJJRtoq2uTXRKCck6QSH8SFDSTpHmvTyOieczY7bdm8g@mail.gmail.com>
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

On Thu, Sep 1, 2022 at 6:15 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 31, 2022 at 10:56 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > On Wed, Aug 31, 2022 at 6:37 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Aug 30, 2022 at 7:29 AM Benjamin Tissoires
> > > <benjamin.tissoires@redhat.com> wrote:
> > > >
> > > > On Fri, Aug 26, 2022 at 3:51 AM Kumar Kartikeya Dwivedi
> > > > <memxor@gmail.com> wrote:
> > > > >
> > > > > On Fri, 26 Aug 2022 at 03:42, Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, Aug 24, 2022 at 6:41 AM Benjamin Tissoires
> > > > > > <benjamin.tissoires@redhat.com> wrote:
> > > > > > >
> > > > > > > When a function was trying to access data from context in a syscall eBPF
> > > > > > > program, the verifier was rejecting the call unless it was accessing the
> > > > > > > first element.
> > > > > > > This is because the syscall context is not known at compile time, and
> > > > > > > so we need to check this when actually accessing it.
> > > > > > >
> > > > > > > Check for the valid memory access if there is no convert_ctx callback,
> > > > > > > and allow such situation to happen.
> > > > > > >
> > > > > > > There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
> > > > > > > will check that the types are matching, which is a good thing, but to
> > > > > > > have an accurate result, it hides the fact that the context register may
> > > > > > > be null. This makes env->prog->aux->max_ctx_offset being set to the size
> > > > > > > of the context, which is incompatible with a NULL context.
> > > > > > >
> > > > > > > Solve that last problem by storing max_ctx_offset before the type check
> > > > > > > and restoring it after.
> > > > > > >
> > > > > > > Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > > >
> > > > > > > ---
> > > > > > >
> > > > > > > changes in v9:
> > > > > > > - rewrote the commit title and description
> > > > > > > - made it so all functions can make use of context even if there is
> > > > > > >   no convert_ctx
> > > > > > > - remove the is_kfunc field in bpf_call_arg_meta
> > > > > > >
> > > > > > > changes in v8:
> > > > > > > - fixup comment
> > > > > > > - return -EACCESS instead of -EINVAL for consistency
> > > > > > >
> > > > > > > changes in v7:
> > > > > > > - renamed access_t into atype
> > > > > > > - allow zero-byte read
> > > > > > > - check_mem_access() to the correct offset/size
> > > > > > >
> > > > > > > new in v6
> > > > > > > ---
> > > > > > >  kernel/bpf/btf.c      | 11 ++++++++++-
> > > > > > >  kernel/bpf/verifier.c | 19 +++++++++++++++++++
> > > > > > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > > > > index 903719b89238..386300f52b23 100644
> > > > > > > --- a/kernel/bpf/btf.c
> > > > > > > +++ b/kernel/bpf/btf.c
> > > > > > > @@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > > > > >  {
> > > > > > >         struct bpf_prog *prog = env->prog;
> > > > > > >         struct btf *btf = prog->aux->btf;
> > > > > > > +       u32 btf_id, max_ctx_offset;
> > > > > > >         bool is_global;
> > > > > > > -       u32 btf_id;
> > > > > > >         int err;
> > > > > > >
> > > > > > >         if (!prog->aux->func_info)
> > > > > > > @@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
> > > > > > >         if (prog->aux->func_info_aux[subprog].unreliable)
> > > > > > >                 return -EINVAL;
> > > > > > >
> > > > > > > +       /* subprogs arguments are not actually accessing the data, we need
> > > > > > > +        * to check for the types if they match.
> > > > > > > +        * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
> > > > > > > +        * given that this function will have a side effect of changing it.
> > > > > > > +        */
> > > > > > > +       max_ctx_offset = env->prog->aux->max_ctx_offset;
> > > > > > > +
> > > > > > >         is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> > > > > > >         err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
> > > > > > >
> > > > > > > +       env->prog->aux->max_ctx_offset = max_ctx_offset;
> > > > > >
> > > > > > I don't understand this.
> > > > > > If we pass a ctx into a helper and it's going to
> > > > > > access [0..N] bytes from it why do we need to hide it?
> > > > > > max_ctx_offset will be used later raw_tp, tp, syscall progs
> > > > > > to determine whether it's ok to load them.
> > > > > > By hiding the actual size of access somebody can construct
> > > > > > a prog that reads out of bounds.
> > > > > > How is this related to NULL-ness property?
> > > > >
> > > > > Same question, was just typing exactly the same thing.
> > > >
> > > > The test I have that is failing in patch 2/23 is the following, with
> > > > args being set to NULL by userspace:
> > > >
> > > > SEC("syscall")
> > > > int kfunc_syscall_test_null(struct syscall_test_args *args)
> > > > {
> > > >        bpf_kfunc_call_test_mem_len_pass1(args, 0);
> > > >
> > > >        return 0;
> > > > }
> > > >
> > > > Basically:
> > > > if userspace declares the following:
> > > >  DECLARE_LIBBPF_OPTS(bpf_test_run_opts, syscall_topts,
> > > >                .ctx_in = NULL,
> > > >                .ctx_size_in = 0,
> > > >        );
> > > >
> > > > The verifier is happy with the current released kernel:
> > > > kfunc_syscall_test_fail() never dereferences the ctx pointer, it just
> > > > passes it around to bpf_kfunc_call_test_mem_len_pass1(), which in turn
> > > > is also happy because it says it is not accessing the data at all (0
> > > > size memory parameter).
> > > >
> > > > In the current code, check_helper_mem_access() actually returns
> > > > -EINVAL, but doesn't change max_ctx_offset (it's still at the value of
> > > > 0 here). The program is now marked as unreliable, but the verifier
> > > > goes on.
> > > >
> > > > When adding this patch, if we declare a syscall eBPF (or any other
> > > > function that doesn't have env->ops->convert_ctx_access), the previous
> > > > "test" is failing because this ensures the syscall program has to have
> > > > a valid ctx pointer.
> > > > btf_check_func_arg_match() now calls check_mem_access() which
> > > > basically validates the fact that the program can dereference the ctx.
> > > >
> > > > So now, without the max_ctx_offset store/restore, the verifier
> > > > enforces that the provided ctx is not null.
> > > >
> > > > What I thought that would happen was that if we were to pass a NULL
> > > > context from userspace, but the eBPF program dereferences it (or in
> > > > that case have a subprog or a function call that dereferences it),
> > > > then max_ctx_offset would still be set to the proper value because of
> > > > that internal dereference, and so the verifier would reject with
> > > > -EINVAL the call to the eBPF program.
> > > >
> > > > If I add another test that has the following ebpf prog (with ctx_in
> > > > being set to NULL by the userspace):
> > > >
> > > > SEC("syscall")
> > > > int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> > > > {
> > > >        bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> > > >
> > > >        return 0;
> > > > }
> > > >
> > > > Then the call of the program is actually failing with -EINVAL, even
> > > > with this patch.
> > > >
> > > > But again, if setting from userspace a ctx of NULL with a 0 size is
> > > > not considered as valid, then we can just drop that hunk and add a
> > > > test to enforce it.
> > >
> > > PTR_TO_CTX in the verifier always means valid pointer.
> > > All code paths in the verifier assumes that it's not NULL.
> > > Pointer to skb, to xdp, to pt_regs, etc.
> > > The syscall prog type is little bit special, since it
> > > makes sense not to pass any argument to such prog.
> > > So ctx_size_in == 0 is enforced after the verification:
> > > if (ctx_size_in < prog->aux->max_ctx_offset ||
> > >     ctx_size_in > U16_MAX)
> > >           return -EINVAL;
> > > The verifier should be able to proceed assuming ctx != NULL
> > > and remember max max_ctx_offset.
> > > If max_ctx_offset == 4 and ctx_size_in == 0 then
> > > it doesn't matter whether the actual 'ctx' pointer is NULL
> > > or points to a valid memory.
> > > So it's ok for the verifier to assume ctx != NULL everywhere.
> >
> > Ok, thanks for the detailed explanation.
> >
> > >
> > > Back to the issue at hand.
> > > With this patch the line:
> > >     bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> > > will be seen as access_size == sizeof(*args), right?
> > > So this part:
> > > +                       if (access_size == 0)
> > > +                               return zero_size_allowed ? 0 : -EACCES;
> > >
> > > will be skipped and
> > > the newly added check_mem_access() will call check_ctx_access()
> > > which will call syscall_prog_is_valid_access() and it will say
> > > that any off < U16_MAX is fine and will simply
> > > record max max_ctx_offset.
> > > The ctx_size_in < prog->aux->max_ctx_offset check is done later.
> >
> > Yep, this is correct and this is working now, with a proper error (and
> > no, this is not the error I am trying to fix, see below):
> >
> > eBPF prog:
> > ```
> >   SEC("?syscall")
> >   int kfunc_syscall_test_null_fail(struct syscall_test_args *args)
> >   {
> >           bpf_kfunc_call_test_mem_len_pass1(args, sizeof(*args));
> >           return 0;
> >   }
> > ```
> >
> > before this patch (1/23):
> > * with ctx not NULL:
> > libbpf: prog 'kfunc_syscall_test_null_fail': BPF program load failed:
> > Invalid argument
> > R1 type=ctx expected=fp
> > arg#0 arg#1 memory, len pair leads to invalid memory access
> >
> >  => this is not correct, we expect the program to be loaded (and it is
> > expected, this is the bug that is fixed)
> >
> > * Same result with ctx being NULL from the caller
> >
> > With just the hunk in kernel/bpf/verifier.c (so without touching max_ctx_offset:
> > * with ctx not NULL:
> > program is loaded, and executed correctly
> >
> > * with ctx being NULL:
> > program is now loaded, but execution returns -EINVAL, as expected
> >
> > So this case is fully solved by just the hunk in verifier.c
> >
> > With the full patch:
> > same results, with or without ctx being set to NULL, so no side effects.
> >
> > >
> > > So when you're saying:
> > > "call of the program is actually failing with -EINVAL"
> > > that's the check you're referring to?
> >
> > No. I am referring to the following eBPF program:
> > ```
> >   SEC("syscall")
> >   int kfunc_syscall_test_null(struct syscall_test_args *args)
> >   {
> >            return 0;
> >   }
> > ```
> >
> > (no calls, just the declaration of a program)
> >
> > This one is supposed to be loaded and properly run whatever the
> > context is, right?
>
> Got it. Yes. Indeed.
> The if (!env->ops->convert_ctx_access)
> hunk alone would break existing progs because of
> side effect of max_ctx_offset.
> We have this unfortunate bit of code:
>                 ret = btf_check_subprog_arg_match(env, subprog, regs);
>                 if (ret == -EFAULT)
>                         /* unlikely verifier bug. abort.
>                          * ret == 0 and ret < 0 are sadly acceptable for
>                          * main() function due to backward compatibility.
>                          * Like socket filter program may be written as:
>                          * int bpf_prog(struct pt_regs *ctx)
>                          * and never dereference that ctx in the program.
>                          * 'struct pt_regs' is a type mismatch for socket
>                          * filter that should be using 'struct __sk_buff'.
>                          */
>                         goto out;
>
> because btf_check_subprog_arg_match() is used to match arguments
> for calling into a function and when the verifier just starts
> to analyze a function.
> Before this patch the btf_check_subprog_arg_match() would just
> EINVAL on your above example and will proceed,
> but with the patch the non zero max_ctx_offset will
> disallow execution later and break things.
> I think we need to clean up this bit of code.
> Just save/restore of max_ctx_offset isn't going to work.
> How about adding a flag to btf_check_subprog_arg_match
> to indicate whether the verifier is processing 'call' insn
> or just starting processing a function body and
> then do
> if (ptr_to_mem_ok && processing_call) ?
> Still feels like a hack.
> Maybe btf_check_func_arg_match() needs to be split to
> disambiguate calling vs processing the body ?

Just to be sure I understand the problem correctly:
btf_check_subprog_arg_match() is called twice only in verifier.c
  - first time (in do_check_common()):
               /* 1st arg to a function */
               regs[BPF_REG_1].type = PTR_TO_CTX;
               mark_reg_known_zero(env, regs, BPF_REG_1);
               ret = btf_check_subprog_arg_match(env, subprog, regs);

AFAICT this call is the "starting processing a function body", and
thus we should only match whether the function definition is correct
compared to the BTF (whether the program is correctly defined or not),
and thus should not have side effects like changing max_ctx_offset

  - second time (in __check_func_call()):
          func_info_aux = env->prog->aux->func_info_aux;
          if (func_info_aux)
                  is_global = func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
          err = btf_check_subprog_arg_match(env, subprog, caller->regs);

This time we are in the "processing 'call' insn" part and this is
where we need to also ensure that the register we access is correctly
set, so max_ctx_offset needs to be updated.

If the above is correct, then yes, it would make sense to me to have 2
distinct functions: one to check for the args types only (does the
function definition in the problem matches BTF), and one to check for
its use.
Behind the scenes, btf_check_subprog_arg_match() calls
btf_check_func_arg_match() which is the one function with entangled
arguments type checking and actually assessing that the values
provided are correct.

I can try to split that  btf_check_func_arg_match() into 2 distinct
functions, though I am not sure I'll get it right.
Maybe the hack about having "processing_call" for
btf_check_func_arg_match() only will be good enough as a first step
towards a better solution?

> And may cleanup the rest of that function ?
> Like all of if (is_kfunc) applies only to 'calling' case.
> Other ideas?
>

I was trying to understand the problem most of today, and the only
other thing I could think of was "why is the assumption that
PTR_TO_CTX is not NULL actually required?". But again, this question
is "valid" in the function declaration part, but not in the caller
insn part. So I think splitting btf_check_subprog_arg_match() in 2 is
probably the best.

Cheers,
Benjamin

