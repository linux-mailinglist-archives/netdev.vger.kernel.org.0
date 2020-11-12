Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D426B2B05E4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgKLNDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgKLNDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:03:24 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30829C061A48
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:03:21 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id o20so6074236eds.3
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yyb1E/sd7Cc/pPe6bTxgtFSJRAKklmXaLvj/I78vaIM=;
        b=CbnNXQqapLCPRAMke5kzyf7Bl569kHtAYC/21aR5gNgbIQ3St0MyWx9Xvauwvs9/6K
         HovsL0Qv1Iyz6llc6Y4X2R6/ggX2UFIKeahg6/f6zg1cpDhuraPb/xfg/NhDNB0JwIov
         taxJTmFy3GGQhzOO71p9DubmpUqY5gu5ngED0g17fWLEXFyDnivPqw6RBn8YVTQt+yqg
         IJ9biFg/UDIKD/N7cvg3uVaQAd7h+2sElIZ7y6OxSC2L0F33kmevvJCLU6NxJTXFZSXV
         NmPDWye+2DMld+uqiHOz9NX0nVZRBiwsoPPvEyUofMzhrjnVHHwBog/rUV7Bo5ay5/yX
         /IEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yyb1E/sd7Cc/pPe6bTxgtFSJRAKklmXaLvj/I78vaIM=;
        b=kQkAh7tA0l8FGTI05hk2S5UKsgyawBux+tjAprteVS/sczc9L1+lIIFnsW8oZKGlPy
         T7NRYLmjAbaUDidoM7W960sqarZGIH7ZBCIHZ7kAXG9rMh8VYDBVspR8eyR8iKq8hnSv
         BwfKSIhvF6BuIi/p3bOASR9rOiG0Zbxh+5fXIk+3Cl2F05DUn+5iLwMed/KA8SnE0lrr
         Vgz08RFDl/xyKmtAGfv5iUREY7jGCpkBdTm4acvSBFTe3j6MrXhC30YdHtTUCqRatQZY
         ycQhxLBKz5OrYzDscBsVrw8h3oFGgZqdHALjUmtrfDvpf+17qcuKdRvT8hvtkSdkNXVZ
         /dqw==
X-Gm-Message-State: AOAM5336kNIaJFnKKhFwsIh2ZDu0AuOnQBvR3YTcGNhDXwN6HskCvurt
        KAeq0dIhZ6/9lKdoOWyGEvZzVg==
X-Google-Smtp-Source: ABdhPJzQfcUmhm3JVhjqAPFUvyMacLy1D+dMscaAuM24AJobRT4fvcels2OnwvTjWmBEEwF7rPypUA==
X-Received: by 2002:a05:6402:31a5:: with SMTP id dj5mr5093365edb.325.1605186199794;
        Thu, 12 Nov 2020 05:03:19 -0800 (PST)
Received: from localhost ([2620:10d:c093:400::5:3b5c])
        by smtp.gmail.com with ESMTPSA id s6sm2132156ejb.122.2020.11.12.05.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:03:19 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:03:12 +0000
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
Message-ID: <20201112130312.GA286385@dbanschikov-fedora-PC0VG1WZ.dhcp.thefacebook.com>
References: <20201110210342.146242-1-me@ubique.spb.ru>
 <CAEf4BzZQSJZMRRvfzHUE+dhyMdP2BTkeXaVyrNymFbepymvj5Q@mail.gmail.com>
 <20201111103826.GA198626@dbanschikov-fedora-PC0VG1WZ.DHCP.thefacebook.com>
 <CAEf4Bzasys6pG5uKHTUJCi1Tw0+N2_8mvx=ia9uFD90ECrNq4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzasys6pG5uKHTUJCi1Tw0+N2_8mvx=ia9uFD90ECrNq4w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 02:33:11PM -0800, Andrii Nakryiko wrote:

> >
> > >
> > > >         switch (prog_type) {
> > > >         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> > > >                 if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
> > > > @@ -7874,7 +7886,6 @@ static int check_return_code(struct bpf_verifier_env *env)
> > > >                 return 0;
> > > >         }
> > > >
> > > > -       reg = cur_regs(env) + BPF_REG_0;
> > > >         if (reg->type != SCALAR_VALUE) {
> > > >                 verbose(env, "At program exit the register R0 is not a known value (%s)\n",
> > > >                         reg_type_str[reg->type]);
> > > > @@ -9266,6 +9277,7 @@ static int do_check(struct bpf_verifier_env *env)
> > > >         int insn_cnt = env->prog->len;
> > > >         bool do_print_state = false;
> > > >         int prev_insn_idx = -1;
> > > > +       const bool is_subprog = env->cur_state->frame[0]->subprogno;
> > >
> > > this can probably be done inside check_return_code(), no?
> >
> > No.
> > Frame stack may be empty when check_return_code() is called.
> 
> How can that happen? check_reg_arg() in check_return_code() relies on
> having a frame available. So does cur_regs() function, also used
> there. What am I missing?

Yes, sorry, you are right.

Verifier doesn't create a new frame for call to a global function
and frames are freed only for nested function calls. The frame[0]
with subprogno is prepared and freed in do_check_common() hence
it should be safe for access it from check_return_code().

Yes, it is simplier to move this check in check_return_code().



> 
> >
> >
> > >
> > > >
> > > >         for (;;) {
> > > >                 struct bpf_insn *insn;
> > > > @@ -9530,7 +9542,7 @@ static int do_check(struct bpf_verifier_env *env)
> > > >                                 if (err)
> > > >                                         return err;
> > > >
> > > > -                               err = check_return_code(env);
> > > > +                               err = check_return_code(env, is_subprog);
> > > >                                 if (err)
> > > >                                         return err;
> > > >  process_bpf_exit:
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > > > index 193002b14d7f..32e4348b714b 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > > > @@ -60,6 +60,7 @@ void test_test_global_funcs(void)
> > > >                 { "test_global_func5.o" , "expected pointer to ctx, but got PTR" },
> > > >                 { "test_global_func6.o" , "modified ctx ptr R2" },
> > > >                 { "test_global_func7.o" , "foo() doesn't return scalar" },
> > > > +               { "test_global_func8.o" },
> > > >         };
> > > >         libbpf_print_fn_t old_print_fn = NULL;
> > > >         int err, i, duration = 0;
> > > > diff --git a/tools/testing/selftests/bpf/progs/test_global_func8.c b/tools/testing/selftests/bpf/progs/test_global_func8.c
> > > > new file mode 100644
> > > > index 000000000000..1e9a87f30b7c
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/progs/test_global_func8.c
> > > > @@ -0,0 +1,25 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/* Copyright (c) 2020 Facebook */
> > > > +#include <stddef.h>
> > > > +#include <linux/bpf.h>
> > > > +#include <bpf/bpf_helpers.h>
> > > > +
> > > > +__attribute__ ((noinline))
> > >
> > > nit: use __noinline, it's defined in bpf_helpers.h
> > >
> > > > +int bar(struct __sk_buff *skb)
> > > > +{
> > > > +       return bpf_get_prandom_u32();
> > > > +}
> > > > +
> > > > +static __always_inline int foo(struct __sk_buff *skb)
> > >
> > > foo is not essential, just inline it in test_cls below
> > >
> > > > +{
> > > > +       if (!bar(skb))
> > > > +               return 0;
> > > > +
> > > > +       return 1;
> > > > +}
> > > > +
> > > > +SEC("cgroup_skb/ingress")
> > > > +int test_cls(struct __sk_buff *skb)
> > > > +{
> > > > +       return foo(skb);
> > > > +}
> > >
> > > I also wonder what happens if __noinline function has return type
> > > void? Do you mind adding another BPF program that uses non-inline
> > > global void function? We might need to handle that case in the
> > > verifier explicitly.
> >
> > btf_prepare_func_args() guarantees that a subprogram may have only
> > SCALAR return type.
> 
> Right, I didn't know about this, thanks. We might want to lift that
> restriction eventually.
> 
> >
> > >
> > >
> > > > --
> > > > 2.24.1
> > > >
