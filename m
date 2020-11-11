Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4472AEEDC
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgKKKih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKKih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 05:38:37 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5E6C0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 02:38:34 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id dk16so2051913ejb.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 02:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BPxM4C3vxk/6yaa7IQ2YhdzlAHJjSZgmGVjwT8UK8zY=;
        b=j3abW3VZz2uX17u3JS4WhWOdiYZdArdkw94l2xJC/dO1rb33YD+mDe7duuJAW6H8tk
         kc8LI1lPFEfchl0F1Iv9TSjN93wJKeIbSWOH2xfE2mdukb0ffIjAsZPC4WiQwyl1WefG
         3rhgntuw6OXjxKmhWdJB+HcOQGi6tCJ2bPRQ4u4SoSVHkG546vymcxe5imQt1W3HHnH+
         nPxlvUA3Jpnl/S90Wq6LrjcEXfiwsGdHdQzRfC67Hd7YhZxb5DOJVMm0lDJUA+GjJNPb
         2thd2eM69Wbje/WmnfGeTfxeCHHF8lEmRwnpF60005Rxo+lRKpR4E+RYSQtYo7PDYUjY
         57Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BPxM4C3vxk/6yaa7IQ2YhdzlAHJjSZgmGVjwT8UK8zY=;
        b=BGYAz3R/XiCewqHhkhKX4P0BJhVWe6Emn29YHoFdoGXgtEsJM47dVyWHSyh2JkrCud
         uyoX8p0vQh1cf0HOkxZsFPg8I0AISJzJG8DNiNTesSsEiC4k8SxqrpptkuHcrgX9DP5j
         IMYFHXrB74orfsK3Kj7vsJfffL6A4XddvwipULEAHu701GGigNKzGg/ycilgRuT/qq1/
         iFOD08wHIq1SLVWH6wOCBnHz5TuR99vNfacHXr7TYwOJTtHFOgRVVgCoNdBHOPqT4cie
         3B32DrDvAqrQxP7zqNdM/v1u3ZuJmQslOldKLktQNlcOR92hL7KDo791r2QB1h0sb4n4
         ucIA==
X-Gm-Message-State: AOAM533set75aZXzXKhLl/JS5cTIKWU84wiu3mBT0C8qJzYQmbGJu8l0
        5NMF2TlcQC9O0ec462mZmrUkdQ==
X-Google-Smtp-Source: ABdhPJwtT4pM/cg2P5nqlP5790OT0OkmFxc/d/oKPWWZYwSvNRBCC8xWa/X61L2xBYq6Z310sdLFqQ==
X-Received: by 2002:a17:906:8401:: with SMTP id n1mr24048505ejx.215.1605091113381;
        Wed, 11 Nov 2020 02:38:33 -0800 (PST)
Received: from localhost ([2620:10d:c093:400::5:ed76])
        by smtp.gmail.com with ESMTPSA id h2sm689743ejx.55.2020.11.11.02.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 02:38:32 -0800 (PST)
Date:   Wed, 11 Nov 2020 10:38:26 +0000
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH] bpf: relax return code check for subprograms
Message-ID: <20201111103826.GA198626@dbanschikov-fedora-PC0VG1WZ.DHCP.thefacebook.com>
References: <20201110210342.146242-1-me@ubique.spb.ru>
 <CAEf4BzZQSJZMRRvfzHUE+dhyMdP2BTkeXaVyrNymFbepymvj5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZQSJZMRRvfzHUE+dhyMdP2BTkeXaVyrNymFbepymvj5Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 08:47:13PM -0800, Andrii Nakryiko wrote:
> On Tue, Nov 10, 2020 at 1:03 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> >
> > Currently verifier enforces return code checks for subprograms in the
> > same manner as it does for program entry points. This prevents returning
> > arbitrary scalar values from subprograms. Scalar type of returned values
> > is checked by btf_prepare_func_args() and hence it should be safe to
> > allow only scalars for now. Relax return code checks for subprograms and
> > allow any correct scalar values.
> >
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > Fixes: 51c39bb1d5d10 (bpf: Introduce function-by-function verification)
> > ---
> 
> Please make sure that your subject has [PATCH bpf-next], if it's
> targeted against bpf-next tree.
> 
> >  kernel/bpf/verifier.c                         | 26 ++++++++++++++-----
> >  .../bpf/prog_tests/test_global_funcs.c        |  1 +
> >  .../selftests/bpf/progs/test_global_func8.c   | 25 ++++++++++++++++++
> >  3 files changed, 45 insertions(+), 7 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func8.c
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 10da26e55130..c108b19e1fad 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -7791,7 +7791,7 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
> >         return 0;
> >  }
> >
> > -static int check_return_code(struct bpf_verifier_env *env)
> > +static int check_return_code(struct bpf_verifier_env *env, bool is_subprog)
> >  {
> >         struct tnum enforce_attach_type_range = tnum_unknown;
> >         const struct bpf_prog *prog = env->prog;
> > @@ -7801,10 +7801,12 @@ static int check_return_code(struct bpf_verifier_env *env)
> >         int err;
> >
> >         /* LSM and struct_ops func-ptr's return type could be "void" */
> > -       if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
> > -            prog_type == BPF_PROG_TYPE_LSM) &&
> > -           !prog->aux->attach_func_proto->type)
> > -               return 0;
> > +       if (!is_subprog) {
> 
> I think just adding `!is_subprog` && to existing if is cleaner and
> more succinct.
> 
> > +               if ((prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
> > +                    prog_type == BPF_PROG_TYPE_LSM) &&
> > +                   !prog->aux->attach_func_proto->type)
> > +                       return 0;
> > +       }
> >
> >         /* eBPF calling convetion is such that R0 is used
> >          * to return the value from eBPF program.
> > @@ -7821,6 +7823,16 @@ static int check_return_code(struct bpf_verifier_env *env)
> >                 return -EACCES;
> >         }
> >
> > +       reg = cur_regs(env) + BPF_REG_0;
> > +       if (is_subprog) {
> > +               if (reg->type != SCALAR_VALUE) {
> > +                       verbose(env, "At subprogram exit the register R0 is not a scalar value (%s)\n",
> > +                               reg_type_str[reg->type]);
> > +                       return -EINVAL;
> > +               }
> > +               return 0;
> > +       }
> > +
> 
> It's not clear why reg->type != SCALAR_VALUE check is done after
> prog_type-specific check. Is there any valid case where we'd allow
> non-scalar return? Maybe Alexei can chime in here.
> 
> If not, then I'd just move the existing SCALAR_VALUE check below up
> here, unconditionally for subprog and non-subprog. And then just exit
> after that, if we are processing a subprog.

As comment says BPF_PROG_TYPE_STRUCT_OPS and BPF_PROG_TYPE_LSM
progs may return void. Hence we want allow this only for
entry points and not for subprograms as btf_prepare_func_args()
guarantees that subprogram return value has SCALAR type.

Beside that there are other cases when SCALAR type is not
enforced for return value: e.g. BPF_PROG_TYPE_TRACING with
BPF_MODIFY_RETURN expected attach type.

> 
> >         switch (prog_type) {
> >         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> >                 if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
> > @@ -7874,7 +7886,6 @@ static int check_return_code(struct bpf_verifier_env *env)
> >                 return 0;
> >         }
> >
> > -       reg = cur_regs(env) + BPF_REG_0;
> >         if (reg->type != SCALAR_VALUE) {
> >                 verbose(env, "At program exit the register R0 is not a known value (%s)\n",
> >                         reg_type_str[reg->type]);
> > @@ -9266,6 +9277,7 @@ static int do_check(struct bpf_verifier_env *env)
> >         int insn_cnt = env->prog->len;
> >         bool do_print_state = false;
> >         int prev_insn_idx = -1;
> > +       const bool is_subprog = env->cur_state->frame[0]->subprogno;
> 
> this can probably be done inside check_return_code(), no?

No.
Frame stack may be empty when check_return_code() is called.


> 
> >
> >         for (;;) {
> >                 struct bpf_insn *insn;
> > @@ -9530,7 +9542,7 @@ static int do_check(struct bpf_verifier_env *env)
> >                                 if (err)
> >                                         return err;
> >
> > -                               err = check_return_code(env);
> > +                               err = check_return_code(env, is_subprog);
> >                                 if (err)
> >                                         return err;
> >  process_bpf_exit:
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > index 193002b14d7f..32e4348b714b 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > @@ -60,6 +60,7 @@ void test_test_global_funcs(void)
> >                 { "test_global_func5.o" , "expected pointer to ctx, but got PTR" },
> >                 { "test_global_func6.o" , "modified ctx ptr R2" },
> >                 { "test_global_func7.o" , "foo() doesn't return scalar" },
> > +               { "test_global_func8.o" },
> >         };
> >         libbpf_print_fn_t old_print_fn = NULL;
> >         int err, i, duration = 0;
> > diff --git a/tools/testing/selftests/bpf/progs/test_global_func8.c b/tools/testing/selftests/bpf/progs/test_global_func8.c
> > new file mode 100644
> > index 000000000000..1e9a87f30b7c
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_global_func8.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2020 Facebook */
> > +#include <stddef.h>
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +__attribute__ ((noinline))
> 
> nit: use __noinline, it's defined in bpf_helpers.h
> 
> > +int bar(struct __sk_buff *skb)
> > +{
> > +       return bpf_get_prandom_u32();
> > +}
> > +
> > +static __always_inline int foo(struct __sk_buff *skb)
> 
> foo is not essential, just inline it in test_cls below
> 
> > +{
> > +       if (!bar(skb))
> > +               return 0;
> > +
> > +       return 1;
> > +}
> > +
> > +SEC("cgroup_skb/ingress")
> > +int test_cls(struct __sk_buff *skb)
> > +{
> > +       return foo(skb);
> > +}
> 
> I also wonder what happens if __noinline function has return type
> void? Do you mind adding another BPF program that uses non-inline
> global void function? We might need to handle that case in the
> verifier explicitly.

btf_prepare_func_args() guarantees that a subprogram may have only
SCALAR return type.

> 
> 
> > --
> > 2.24.1
> >
