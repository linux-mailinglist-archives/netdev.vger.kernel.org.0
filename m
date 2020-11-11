Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2EB2AFB8A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgKKWnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgKKWlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:41:47 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86A7C061A49;
        Wed, 11 Nov 2020 14:33:22 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id 2so3380802ybc.12;
        Wed, 11 Nov 2020 14:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jb6xUdM/LpLTOZW3X6Y/EQoOSxyDYWTFF9RUv5ehhQc=;
        b=p34Op9HFcRQsnxzbh8yb2CoYD5PqYuC+xPR2mMEdiqtfycl3LNLgaDHlsGJBMPdi1i
         qedhV+M06rsAVltBjVvYhZa4n/G4RMppuniLEdn3fJ1Gn2wnQFsxnom00F/4HgS5QOo5
         4GXHczs28xP+UdPxcszmtwHNRfSN1mR739pU5jcRcHdEmxUVXYQ3IJBOoZ1Q8kJMD4WV
         SRJXqdCjUZt9hHu8jkm1tJOrdqO/2NLWWKRdbPojkoLy48lIU6zxCOYNdRiLkXMGtIAP
         6l0qY7jBzV4LGD0S7gajgv+lHi7vx7+dv9gsi3JmAx8927vz+QGDA+goMXTQxYXo+3aH
         Gcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jb6xUdM/LpLTOZW3X6Y/EQoOSxyDYWTFF9RUv5ehhQc=;
        b=hVT/aay0otzXWKTbOxAtIsXiE1/kNWsxV5tqMD5LdkbSgJ33GkfsfgfoNWWCIWPrFh
         KhsqlfukfFwh8TENqT4j+zMqYt4d0vz/3iq+mrVg3zJ6VU8e6BYNCG3R/2jm5+D9AEpE
         yc3pOIp05PIbQGow0/kUo9jVuK5OJyCMqfK4J87wKgVg4krr786vPrYyp3o6d8NKuaqw
         x3OBFGrLlXx1NUuoVNiKCM7akqYz3+sp9KQgzDCkIqhWV/w3WNnUCuxnYZpSwW6LQxn2
         Ce1/c2qo1UK82o66vK8le9A7BCHz5Q42Rd8cSDYd+bXzj4vCEB2eRKk3foZasUcorXAc
         WZjg==
X-Gm-Message-State: AOAM532ORtwEEypMUf6+XTSEcQw4k5ARCL/mCmli4/t2BBvntck75nxV
        RhtnaQjywTybC6dq0Frp6gmKUegNU3Xy7kHnOqQ=
X-Google-Smtp-Source: ABdhPJxO+/rL8mVU+Ph54MK8e/eD8ubsUrU9U5z7jQkl+OHsJ4insUUpxNUVgtexUMsxELTg9+3vvMyugNzOi55d+CI=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr10098441ybg.230.1605134002053;
 Wed, 11 Nov 2020 14:33:22 -0800 (PST)
MIME-Version: 1.0
References: <20201110210342.146242-1-me@ubique.spb.ru> <CAEf4BzZQSJZMRRvfzHUE+dhyMdP2BTkeXaVyrNymFbepymvj5Q@mail.gmail.com>
 <20201111103826.GA198626@dbanschikov-fedora-PC0VG1WZ.DHCP.thefacebook.com>
In-Reply-To: <20201111103826.GA198626@dbanschikov-fedora-PC0VG1WZ.DHCP.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Nov 2020 14:33:11 -0800
Message-ID: <CAEf4Bzasys6pG5uKHTUJCi1Tw0+N2_8mvx=ia9uFD90ECrNq4w@mail.gmail.com>
Subject: Re: [PATCH] bpf: relax return code check for subprograms
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 2:38 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> On Tue, Nov 10, 2020 at 08:47:13PM -0800, Andrii Nakryiko wrote:
> > On Tue, Nov 10, 2020 at 1:03 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> > >
> > > Currently verifier enforces return code checks for subprograms in the
> > > same manner as it does for program entry points. This prevents returning
> > > arbitrary scalar values from subprograms. Scalar type of returned values
> > > is checked by btf_prepare_func_args() and hence it should be safe to
> > > allow only scalars for now. Relax return code checks for subprograms and
> > > allow any correct scalar values.
> > >
> > > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > > Fixes: 51c39bb1d5d10 (bpf: Introduce function-by-function verification)
> > > ---
> >
> > Please make sure that your subject has [PATCH bpf-next], if it's
> > targeted against bpf-next tree.
> >
> > >  kernel/bpf/verifier.c                         | 26 ++++++++++++++-----
> > >  .../bpf/prog_tests/test_global_funcs.c        |  1 +
> > >  .../selftests/bpf/progs/test_global_func8.c   | 25 ++++++++++++++++++
> > >  3 files changed, 45 insertions(+), 7 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 10da26e55130..c108b19e1fad 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -7791,7 +7791,7 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
> > >         return 0;
> > >  }
> > >
> > > -static int check_return_code(struct bpf_verifier_env *env)
> > > +static int check_return_code(struct bpf_verifier_env *env, bool is_subprog)
> > >  {
> > >         struct tnum enforce_attach_type_range = tnum_unknown;
> > >         const struct bpf_prog *prog = env->prog;
> > > @@ -7801,10 +7801,12 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >         int err;
> > >
> > >         /* LSM and struct_ops func-ptr's return type could be "void" */
> > > -       if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
> > > -            prog_type == BPF_PROG_TYPE_LSM) &&
> > > -           !prog->aux->attach_func_proto->type)
> > > -               return 0;
> > > +       if (!is_subprog) {
> >
> > I think just adding `!is_subprog` && to existing if is cleaner and
> > more succinct.
> >
> > > +               if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
> > > +                    prog_type == BPF_PROG_TYPE_LSM) &&
> > > +                   !prog->aux->attach_func_proto->type)
> > > +                       return 0;
> > > +       }
> > >
> > >         /* eBPF calling convetion is such that R0 is used
> > >          * to return the value from eBPF program.
> > > @@ -7821,6 +7823,16 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >                 return -EACCES;
> > >         }
> > >
> > > +       reg = cur_regs(env) + BPF_REG_0;
> > > +       if (is_subprog) {
> > > +               if (reg->type != SCALAR_VALUE) {
> > > +                       verbose(env, "At subprogram exit the register R0 is not a scalar value (%s)\n",
> > > +                               reg_type_str[reg->type]);
> > > +                       return -EINVAL;
> > > +               }
> > > +               return 0;
> > > +       }
> > > +
> >
> > It's not clear why reg->type != SCALAR_VALUE check is done after
> > prog_type-specific check. Is there any valid case where we'd allow
> > non-scalar return? Maybe Alexei can chime in here.
> >
> > If not, then I'd just move the existing SCALAR_VALUE check below up
> > here, unconditionally for subprog and non-subprog. And then just exit
> > after that, if we are processing a subprog.
>
> As comment says BPF_PROG_TYPE_STRUCT_OPS and BPF_PROG_TYPE_LSM
> progs may return void. Hence we want allow this only for
> entry points and not for subprograms as btf_prepare_func_args()
> guarantees that subprogram return value has SCALAR type.
>
> Beside that there are other cases when SCALAR type is not
> enforced for return value: e.g. BPF_PROG_TYPE_TRACING with
> BPF_MODIFY_RETURN expected attach type.

I'm surprised we allow returning FP or map_value pointers or something
like that, regardless of program type. Which is why I raised this
question. But that's a separate topic, let's punt it.

>
> >
> > >         switch (prog_type) {
> > >         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> > >                 if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
> > > @@ -7874,7 +7886,6 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >                 return 0;
> > >         }
> > >
> > > -       reg = cur_regs(env) + BPF_REG_0;
> > >         if (reg->type != SCALAR_VALUE) {
> > >                 verbose(env, "At program exit the register R0 is not a known value (%s)\n",
> > >                         reg_type_str[reg->type]);
> > > @@ -9266,6 +9277,7 @@ static int do_check(struct bpf_verifier_env *env)
> > >         int insn_cnt = env->prog->len;
> > >         bool do_print_state = false;
> > >         int prev_insn_idx = -1;
> > > +       const bool is_subprog = env->cur_state->frame[0]->subprogno;
> >
> > this can probably be done inside check_return_code(), no?
>
> No.
> Frame stack may be empty when check_return_code() is called.

How can that happen? check_reg_arg() in check_return_code() relies on
having a frame available. So does cur_regs() function, also used
there. What am I missing?

>
>
> >
> > >
> > >         for (;;) {
> > >                 struct bpf_insn *insn;
> > > @@ -9530,7 +9542,7 @@ static int do_check(struct bpf_verifier_env *env)
> > >                                 if (err)
> > >                                         return err;
> > >
> > > -                               err = check_return_code(env);
> > > +                               err = check_return_code(env, is_subprog);
> > >                                 if (err)
> > >                                         return err;
> > >  process_bpf_exit:
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > > index 193002b14d7f..32e4348b714b 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > > @@ -60,6 +60,7 @@ void test_test_global_funcs(void)
> > >                 { "test_global_func5.o" , "expected pointer to ctx, but got PTR" },
> > >                 { "test_global_func6.o" , "modified ctx ptr R2" },
> > >                 { "test_global_func7.o" , "foo() doesn't return scalar" },
> > > +               { "test_global_func8.o" },
> > >         };
> > >         libbpf_print_fn_t old_print_fn = NULL;
> > >         int err, i, duration = 0;
> > > diff --git a/tools/testing/selftests/bpf/progs/test_global_func8.c b/tools/testing/selftests/bpf/progs/test_global_func8.c
> > > new file mode 100644
> > > index 000000000000..1e9a87f30b7c
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/test_global_func8.c
> > > @@ -0,0 +1,25 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright (c) 2020 Facebook */
> > > +#include <stddef.h>
> > > +#include <linux/bpf.h>
> > > +#include <bpf/bpf_helpers.h>
> > > +
> > > +__attribute__ ((noinline))
> >
> > nit: use __noinline, it's defined in bpf_helpers.h
> >
> > > +int bar(struct __sk_buff *skb)
> > > +{
> > > +       return bpf_get_prandom_u32();
> > > +}
> > > +
> > > +static __always_inline int foo(struct __sk_buff *skb)
> >
> > foo is not essential, just inline it in test_cls below
> >
> > > +{
> > > +       if (!bar(skb))
> > > +               return 0;
> > > +
> > > +       return 1;
> > > +}
> > > +
> > > +SEC("cgroup_skb/ingress")
> > > +int test_cls(struct __sk_buff *skb)
> > > +{
> > > +       return foo(skb);
> > > +}
> >
> > I also wonder what happens if __noinline function has return type
> > void? Do you mind adding another BPF program that uses non-inline
> > global void function? We might need to handle that case in the
> > verifier explicitly.
>
> btf_prepare_func_args() guarantees that a subprogram may have only
> SCALAR return type.

Right, I didn't know about this, thanks. We might want to lift that
restriction eventually.

>
> >
> >
> > > --
> > > 2.24.1
> > >
