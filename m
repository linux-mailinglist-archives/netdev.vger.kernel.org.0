Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C196BDBA2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 23:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCPW1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 18:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjCPW1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 18:27:32 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED1B3E04;
        Thu, 16 Mar 2023 15:27:02 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id o12so13473961edb.9;
        Thu, 16 Mar 2023 15:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679005568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfe6c65rjSWNleSBjbCg2jg/1AapZLiVjBrjoEhs8II=;
        b=iVFnuORu3KmOaCQOelF5aESan2YJqApjdJNoIX5BOeYl3KWLtSpBxycewd/nzpgXEf
         rwWZ6itk5AL8+GGG1e3YXLaWZnKqB8z2d7yC7QcmalFFbcCyalGxB1XYV1ziU4tq3csy
         rESxsd7Y11nFwCYCyrtMkc9GvORfu1fRtqheKwvCzj0lZNbIeLZ6jiu3h0X9w7TixKJ5
         8t0CUzH04o9/zYbW5cEYnenartX/SVmGKqjDp7oEggJLLiaGqmJp+G1/djPx3gODCK71
         VonWrVlXxKlcvd1bdzlhO1O53EHGmmT2Mw2I/GigU6d3oIqk/UxmutoBmc47gaM3f6w7
         Gg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qfe6c65rjSWNleSBjbCg2jg/1AapZLiVjBrjoEhs8II=;
        b=o36rEJygOy8r6Zz0VH5pmBMn2sArvzhCIY3rUEEHavyIViEaMm2YhgjY8R3P1QRObW
         J9FKWN3WWs83cHhVO7Z4Ere7QwAQ+bGt6g4f6xxlXZdnBC3s4rQyGX9mzij53oBPFZCv
         RU7HO9AgILVMjd281qzUpxpDj+G9P9OO6klxOMxsRqJOvSgkxUeLOniZCHPFH8CSG+Ft
         vlWB8Qgtxx1JCmykd9qCLzCdYq6bC9dXx18Bw5MlA7hB1mHEWrGle99IkRa5t14GAAfg
         i+7MspKalG+g3AFhhXLwnC8pdAc79Tzvg5A5WHdM7nTEKmB4sCF7gqiQeb9E3no8VFsY
         /1vw==
X-Gm-Message-State: AO0yUKXSnR99AMza1GWpsSl1QwtLkfSp7Oh8uAUtx1S4VxxJ6OO24y8r
        JOx/NADiD3nUuayePxEjIGLFzKljUoo/wR2IY/IAi6gGg0o=
X-Google-Smtp-Source: AK7set8RD3PHZWbvptP/gcOWGyAqq3ZG25cS4W+l11pEt79Bo5vXTHa+yMK7Zsz/DVs0WiwcIM4SaNNSoBCvog0+xaI=
X-Received: by 2002:a17:906:fb9a:b0:92a:581:ac49 with SMTP id
 lr26-20020a170906fb9a00b0092a0581ac49mr6123071ejb.3.1679005567998; Thu, 16
 Mar 2023 15:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
 <20230315223607.50803-2-alexei.starovoitov@gmail.com> <CAEf4BzaSMB6oKBO2VXvz4cVE9wXqYq+vyD=EOe3YJ3a-L==WCg@mail.gmail.com>
In-Reply-To: <CAEf4BzaSMB6oKBO2VXvz4cVE9wXqYq+vyD=EOe3YJ3a-L==WCg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 Mar 2023 15:25:56 -0700
Message-ID: <CAADnVQLud8-+pexQo8rscVM2d8K2dsYU1rJbFGK2ZZygdAgkQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Allow ld_imm64 instruction to point to kfunc.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, Mar 16, 2023 at 1:34=E2=80=AFPM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Mar 15, 2023 at 3:36=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Allow ld_imm64 insn with BPF_PSEUDO_BTF_ID to hold the address of kfunc=
.
> > PTR_MEM is already recognized for NULL-ness by is_branch_taken(),
> > so unresolved kfuncs will be seen as zero.
> > This allows BPF programs to detect at load time whether kfunc is presen=
t
> > in the kernel with bpf_kfunc_exists() macro.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  kernel/bpf/verifier.c       | 7 +++++--
> >  tools/lib/bpf/bpf_helpers.h | 3 +++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 60793f793ca6..4e49d34d8cd6 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15955,8 +15955,8 @@ static int check_pseudo_btf_id(struct bpf_verif=
ier_env *env,
> >                 goto err_put;
> >         }
> >
> > -       if (!btf_type_is_var(t)) {
> > -               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VA=
R.\n", id);
> > +       if (!btf_type_is_var(t) && !btf_type_is_func(t)) {
> > +               verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VA=
R or KIND_FUNC\n", id);
> >                 err =3D -EINVAL;
> >                 goto err_put;
> >         }
> > @@ -15990,6 +15990,9 @@ static int check_pseudo_btf_id(struct bpf_verif=
ier_env *env,
> >                 aux->btf_var.reg_type =3D PTR_TO_BTF_ID | MEM_PERCPU;
> >                 aux->btf_var.btf =3D btf;
> >                 aux->btf_var.btf_id =3D type;
> > +       } else if (!btf_type_is_func(t)) {
> > +               aux->btf_var.reg_type =3D PTR_TO_MEM | MEM_RDONLY;
> > +               aux->btf_var.mem_size =3D 0;
> >         } else if (!btf_type_is_struct(t)) {
> >                 const struct btf_type *ret;
> >                 const char *tname;
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 7d12d3e620cc..43abe4c29409 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -177,6 +177,9 @@ enum libbpf_tristate {
> >  #define __kptr_untrusted __attribute__((btf_type_tag("kptr_untrusted")=
))
> >  #define __kptr __attribute__((btf_type_tag("kptr")))
> >
> > +/* pass function pointer through asm otherwise compiler assumes that a=
ny function !=3D 0 */
> > +#define bpf_kfunc_exists(fn) ({ void *__p =3D fn; asm ("" : "+r"(__p))=
; __p; })
> > +
>
> I think we shouldn't add this helper macro. It just obfuscates a
> misuse of libbpf features and will be more confusing in practice.

I don't think it obfuscates anything.
If __weak is missing in extern declaration of kfunc the libbpf will
error anyway, so there is no danger to miss it.

> If I understand the comment, that asm is there to avoid compiler
> optimization of *knowing* that kfunc exists (it's extern is resolved
> to something other than 0), even if kfunc's ksym is not declared with
> __weak.

That's the current behavior of the combination of llvm and libbpf.
Resolution of weak is a linker job. libbpf loading process is
equivalent to linking. It's "linking" bpf elf .o into kernel and
resolving weak symbols.
We can document and guarantee that libbpf will evaluate
unresolved into zero, but we might have a hard time doing the same with
compilers. It's currently the case for LLVM and I hope GCC will follow.
Here is nice writeup about weak:
https://maskray.me/blog/2021-04-25-weak-symbol

Two things to notice in that writeup:
1. "Unresolved weak symbols have a zero value."
This is part of ELF spec for linkers.
In our case it applies to libbpf.
But it doesn't apply to compilers.

2. "GCC<5 (at least x86_64 and arm) may emit PC-relative relocations
for hidden undefined weak symbols. GCC<5 i386 may optimize if (&foo)
foo(); to unconditional foo();"

In other words if compiler implements weak as PC-relative
the optimizer part of the compiler may consider it as always not-null
and optimize the check out.

We can try to prevent that in LLVM and GCC compilers.
Another approach is to have a macro that passes weak addr through asm
which prevents such optimization.
So we still rely on libbpf resolving to zero while "linking" and
macro prevents compilers from messing up the check.
I feel it's safer to do it with macro.

I guess I'm fine leaving it out for now and just do
if (bpf_rcu_read_lock)
   bpf_rcu_read_lock();

though such code looks ugly and begs for a comment or macro like:

if (bpf_kfunc_exists(bpf_rcu_read_lock))
   bpf_rcu_read_lock();

or

if (bpf_rcu_read_lock) // unknown weak kfunc resolve to zero by libbpf
   // and compiler won't optimize it out
   bpf_rcu_read_lock();

but adding such comment everywhere feels odd.
macro is a cleaner way to document the code.

> __weak has a consistent semantics to indicate something that's
> optional. This is documented (e.g., [0] for kconfig variables) We do
> have tests making sure this works for weak __kconfig and variable
> __ksyms. Let's add similar ones for kfunc ksyms.

Right. We should definitely document that libbpf resolves
unknown __ksym __weak into zero.

> +       if (bpf_iter_num_new2) { // works
> +               struct bpf_iter_num it;
> +               bpf_iter_num_new2(&it, 0, 100);
> +               bpf_iter_num_destroy(&it);
> +       }

It works, but how many people know that unknown weak resolves to zero ?
I didn't know until yesterday.
