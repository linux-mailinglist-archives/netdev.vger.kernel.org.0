Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69CB6BDCA9
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjCPXGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPXGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:06:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE4EE046;
        Thu, 16 Mar 2023 16:06:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id er8so2087416edb.0;
        Thu, 16 Mar 2023 16:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679007975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lbwgNVP8/EzUPzs9Cc5aFDmpJKB5seYqAjSB8co8rY=;
        b=K4Mfsjm5mY4M25QmVpgUu/4iqEfY8OLxOH1IhKrnEMtj2ZtLwb96A3S6TimmsUdzDD
         FpsxYj6orpg6peh43rC1o27EJBVV02n7jzbK2F8DYcm6k6VAtQFUNJ60Ou4+ntJ4P6Y1
         4NR3BiAOqVmwk4OB2rx+h7VRa56RawRDcM7ww6qblASERe0OR+Zl8wfwQg1FNI71wjga
         kOUqaygOO7MvGzysLmTKIQRPr3JvQIvyEAWCV0ykGkPXzc0RJpOXrJ2clVsIShd96bjP
         cET8U/2gcTQ6DIrUnv0/4/dS3w9wuMkrq41l3HGEqpxC2d50lJKk2tocLYkXg/74jOpa
         HiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679007975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lbwgNVP8/EzUPzs9Cc5aFDmpJKB5seYqAjSB8co8rY=;
        b=X3D01TpgH8PXKrASUAgugS6a05shJuFUOL52mS/8KUdHDhecmNOHbjWNk8UApmmKGP
         jhegZ512LkLylhcrORFA3KWrd3njUqlGGFv8DFf+Qn34p76TmirvsPbsVfG7ojUKMNXW
         sxGdEKxl72R+2EeiriU5gBrS0zeC+PYwplMnIkrgvS8GT/N5clyRibYROHWRW/pQ5Umi
         TyDMX46cAxM1ZngtLtgZ+ushdiNo6jbDOr7URvaD2CcMcpUjx2+O6N/q5T40vyZxSmkr
         S8uFj+nVASGpOMLMDTYBub7Fi/+ygk/szyRWoBXc09DBcDi7HMXVAVcZ9odXhxJ4MbBf
         F0gw==
X-Gm-Message-State: AO0yUKXOdtQQ9MKHwJ2wKmuNsuGYSDYvuzYDiKaHPXsfwn3B4yYOGSd4
        YtgwqtRv28V/KsmI6jte5LMjYYs6U5TB9Fk5dRI=
X-Google-Smtp-Source: AK7set/yGJWDqEW2XnZrMDjr8U0e8Bl8EjO1HkIe5BTDGkV28fIVFrMnZj5BF/mpOQpNXCnuapOYB10QITC2RYSarAQ=
X-Received: by 2002:a17:906:8552:b0:8ab:b606:9728 with SMTP id
 h18-20020a170906855200b008abb6069728mr6233918ejy.5.1679007975250; Thu, 16 Mar
 2023 16:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-2-alexei.starovoitov@gmail.com> <CAEf4BzaSMB6oKBO2VXvz4cVE9wXqYq+vyD=EOe3YJ3a-L==WCg@mail.gmail.com>
 <CAADnVQLud8-+pexQo8rscVM2d8K2dsYU1rJbFGK2ZZygdAgkQA@mail.gmail.com>
In-Reply-To: <CAADnVQLud8-+pexQo8rscVM2d8K2dsYU1rJbFGK2ZZygdAgkQA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Mar 2023 16:06:02 -0700
Message-ID: <CAEf4Bzat4dFCP40cMbDwPK-LyPKJtO1d0M44m9EbNajU9UgxFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to kfunc.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        David Vernet <void@manifault.com>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 3:26=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 16, 2023 at 1:34=E2=80=AFPM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Mar 15, 2023 at 3:36=E2=80=AFPM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfu=
nc.
> > > PTR_MEM is already recognized for NULL-ness by is_branch_taken(),
> > > so unresolved kfuncs will be seen as zero.
> > > This allows BPF programs to detect at load time whether kfunc is pres=
ent
> > > in the kernel with bpf_kfunc_exists() macro.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  kernel/bpf/verifier.c       | 7 +++++--
> > >  tools/lib/bpf/bpf_helpers.h | 3 +++
> > >  2 files changed, 8 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 60793f793ca6..4e49d34d8cd6 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -15955,8 +15955,8 @@ static int check_pseudo_btf_id(struct bpf_ver=
ifier_env *env,
> > >                 goto err_put;
> > >         }
> > >
> > > -       if (!btf_type_is_var(t)) {
> > > -               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_=
VAR.\n", id);
> > > +       if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
> > > +               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_=
VAR or KIND_FUNC\n", id);
> > >                 err =3D -EINVAL;
> > >                 goto err_put;
> > >         }
> > > @@ -15990,6 +15990,9 @@ static int check_pseudo_btf_id(struct bpf_ver=
ifier_env *env,
> > >                 aux->btf_var.reg_type =3D PTR_TO_BTF_ID | MEM_PERCPU;
> > >                 aux->btf_var.btf =3D btf;
> > >                 aux->btf_var.btf_id =3D type;
> > > +       } else if (!btf_type_is_func(t)) {
> > > +               aux->btf_var.reg_type =3D PTR_TO_MEM | MEM_RDONLY;
> > > +               aux->btf_var.mem_size =3D 0;
> > >         } else if (!btf_type_is_struct(t)) {
> > >                 const struct btf_type *ret;
> > >                 const char *tname;
> > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.=
h
> > > index 7d12d3e620cc..43abe4c29409 100644
> > > --- a/tools/lib/bpf/bpf_helpers.h
> > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > @@ -177,6 +177,9 @@ enum libbpf_tristate {
> > >  #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted=
")))
> > >  #define __kptr __attribute__((btf_type_tag("kptr")))
> > >
> > > +/* pass function pointer through asm otherwise compiler assumes that=
 any function !=3D 0 */
> > > +#define bpf_kfunc_exists(fn) ({ void *__p =3D fn; asm ("" : "+r"(__p=
)); __p; })
> > > +
> >
> > I think we shouldn't add this helper macro. It just obfuscates a
> > misuse of libbpf features and will be more confusing in practice.
>
> I don't think it obfuscates anything.
> If __weak is missing in extern declaration of kfunc the libbpf will
> error anyway, so there is no danger to miss it.
>
> > If I understand the comment, that asm is there to avoid compiler
> > optimization of *knowing* that kfunc exists (it's extern is resolved
> > to something other than 0), even if kfunc's ksym is not declared with
> > __weak.
>
> That's the current behavior of the combination of llvm and libbpf.
> Resolution of weak is a linker job. libbpf loading process is
> equivalent to linking. It's "linking" bpf elf .o into kernel and
> resolving weak symbols.
> We can document and guarantee that libbpf will evaluate
> unresolved into zero, but we might have a hard time doing the same with
> compilers. It's currently the case for LLVM and I hope GCC will follow.
> Here is nice writeup about weak:
> https://maskray.me/blog/2021-04-25-weak-symbol
>
> Two things to notice in that writeup:
> 1. "Unresolved weak symbols have a zero value."
> This is part of ELF spec for linkers.
> In our case it applies to libbpf.
> But it doesn't apply to compilers.
>
> 2. "GCC<5 (at least x86_64 and arm) may emit PC-relative relocations
> for hidden undefined weak symbols. GCC<5 i386 may optimize if (&foo)
> foo(); to unconditional foo();"

Ok, so

/* pass function pointer through asm otherwise compiler assumes that
any function !=3D 0 */

comment was referring to compiler assuming that function !=3D 0 for
__weak symbol? I definitely didn't read it this way. And "compiler
assumes that function !=3D 0" seems a bit too strong of a statement,
because at least Clang doesn't.

>
> In other words if compiler implements weak as PC-relative
> the optimizer part of the compiler may consider it as always not-null
> and optimize the check out.
>
> We can try to prevent that in LLVM and GCC compilers.

I'd definitely do that, yes. Seems like GCC also realized that this is
not good, so GCC>5 don't do this "optimization" (or whatever it was).

It seems like we are good right now.

We have tests for validating this for .kconfig and .ksym, so
regardless of the macro let's have tests for .ksym functions as well.
I think it's reasonable behavior that Clang has today and having a
test we can detect regression and work with compilers to fix this.
Just like we did previously with .rodata where GCC and Clang diverged.

> Another approach is to have a macro that passes weak addr through asm
> which prevents such optimization.
> So we still rely on libbpf resolving to zero while "linking" and
> macro prevents compilers from messing up the check.
> I feel it's safer to do it with macro.
>
> I guess I'm fine leaving it out for now and just do
> if (bpf_rcu_read_lock)
>    bpf_rcu_read_lock();
>
> though such code looks ugly and begs for a comment or macro like:
>
> if (bpf_kfunc_exists(bpf_rcu_read_lock))
>    bpf_rcu_read_lock();
>
> or
>
> if (bpf_rcu_read_lock) // unknown weak kfunc resolve to zero by libbpf
>    // and compiler won't optimize it out
>    bpf_rcu_read_lock();
>
> but adding such comment everywhere feels odd.
> macro is a cleaner way to document the code.

It's subjective. To me, checking whether __weak extern is non-NULL
seems pretty clean and explicit. From blog that you referred:

  > The ELF specification says "Unresolved weak symbols have a zero
value." This property can be used to check whether a definition is
provided.

So this is quite intended use cases even outside of BPF world.


But for macro, it's not kfunc-specific (and macro itself has no way to
check that you are actually passing kfunc ksym), so even if it was a
macro, it would be better to call it something more generic like
bpf_ksym_exists() (though that will work for .kconfig, yet will be
inappropriately named).

The asm bit, though, seems to be a premature thing that can hide real
compiler issues, so I'm still hesitant to add it. It should work today
with modern compilers, so I'd test and validate this.

>
> > __weak has a consistent semantics to indicate something that's
> > optional. This is documented (e.g., [0] for kconfig variables) We do
> > have tests making sure this works for weak __kconfig and variable
> > __ksyms. Let's add similar ones for kfunc ksyms.
>
> Right. We should definitely document that libbpf resolves
> unknown __ksym __weak into zero.

Yep.

>
> > +       if (bpf_iter_num_new2) { // works
> > +               struct bpf_iter_num it;
> > +               bpf_iter_num_new2(&it, 0, 100);
> > +               bpf_iter_num_destroy(&it);
> > +       }
>
> It works, but how many people know that unknown weak resolves to zero ?
> I didn't know until yesterday.

I was explicit about this from the very beginning of BPF CO-RE work.
ksyms were added later, but semantics was consistent between .kconfig
and .ksym. Documentation can't be ever good enough and discoverable
enough (like [0]), of course, but let's do our best to make it as
obvious as possible. This __weak behavior is tested and used in
multiple selftests as well:

$ git grep -E '(__kconfig|__ksym) __weak'
progs/bpf_iter_ipv6_route.c:extern bool CONFIG_IPV6_SUBTREES __kconfig __we=
ak;
progs/get_func_ip_test.c:extern bool CONFIG_X86_KERNEL_IBT __kconfig __weak=
;
progs/linked_vars1.c:extern bool CONFIG_BPF_SYSCALL __kconfig __weak;
progs/linked_vars1.c:extern const void bpf_link_fops __ksym __weak;
progs/lsm_cgroup.c:extern bool CONFIG_SECURITY_SELINUX __kconfig __weak;
progs/lsm_cgroup.c:extern bool CONFIG_SECURITY_SMACK __kconfig __weak;
progs/lsm_cgroup.c:extern bool CONFIG_SECURITY_APPARMOR __kconfig __weak;
progs/profiler.inc.h:extern bool CONFIG_CGROUP_PIDS __kconfig __weak;
progs/read_bpf_task_storage_busy.c:extern bool CONFIG_PREEMPT __kconfig __w=
eak;
progs/task_kfunc_success.c:void invalid_kfunc(void) __ksym __weak;
progs/task_storage_nodeadlock.c:extern bool CONFIG_PREEMPT __kconfig __weak=
;
progs/test_core_extern.c:extern int LINUX_UNKNOWN_VIRTUAL_EXTERN
__kconfig __weak;
progs/test_core_extern.c:extern enum libbpf_tristate CONFIG_TRISTATE
__kconfig __weak;
progs/test_core_extern.c:extern bool CONFIG_BOOL __kconfig __weak;
progs/test_core_extern.c:extern char CONFIG_CHAR __kconfig __weak;
progs/test_core_extern.c:extern uint16_t CONFIG_USHORT __kconfig __weak;
progs/test_core_extern.c:extern int CONFIG_INT __kconfig __weak;
progs/test_core_extern.c:extern uint64_t CONFIG_ULONG __kconfig __weak;
progs/test_core_extern.c:extern const char CONFIG_STR[8] __kconfig __weak;
progs/test_core_extern.c:extern uint64_t CONFIG_MISSING __kconfig __weak;
progs/test_ksyms.c:extern const void bpf_link_fops1 __ksym __weak;
progs/test_ksyms_module.c:extern void
bpf_testmod_invalid_mod_kfunc(void) __ksym __weak;
progs/test_ksyms_weak.c:extern const struct rq runqueues __ksym
__weak; /* typed */
progs/test_ksyms_weak.c:extern const void bpf_prog_active __ksym
__weak; /* typeless */
progs/test_ksyms_weak.c:extern const void bpf_link_fops1 __ksym __weak;
progs/test_ksyms_weak.c:extern const int bpf_link_fops2 __ksym __weak;


  [0] https://nakryiko.com/posts/bpf-core-reference-guide/#kconfig-extern-v=
ariables
