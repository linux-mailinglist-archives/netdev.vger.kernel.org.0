Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4831D342A05
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 03:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhCTCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 22:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCTCbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 22:31:36 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECD6C061760;
        Fri, 19 Mar 2021 19:31:35 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g8so5768581lfv.12;
        Fri, 19 Mar 2021 19:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ik/fdWl54By5s9X5Z1SyPQ/XceBKzmTy7oaDJAYK7+0=;
        b=DiyJZOxVYuYyie1B1+TMy9H+r29ppqRzoygUrRq6AI0sIJ/bd7Pzkzq958OO1eyX4y
         DyGs66yO79PME1AsclFLKoD1qvcXKUEChTlgx+4W7DW3QlmzKXfM+u3RVPYHqToxPz00
         PcCO5BFz3Mhqj/MHSZqByLHSGaZC95pz/+3uFtt7yKq8hIrfC9MxLkx4pKgzqiF2DB6e
         /2QxZLt0+XiNUC6vXMgYfaQCRvSzqrjkr0E4oP/J6/e+9t6EznqyiYkISewbzCQi+Mjy
         yAB/PU9t53laaVzR0CEskQZ76eJ5pS29/Kb6tgMOTKHv++VFaUyCutxGkf0AYXsO/rPl
         gt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ik/fdWl54By5s9X5Z1SyPQ/XceBKzmTy7oaDJAYK7+0=;
        b=LqhDNi5f0dHIXPPRM+54ryz0Lz3DjBqvB1mEcHm7Vln5QS+xmyy2QZlW+UUzlo4Vo6
         ah+ADZt6KP3uEN4mmZBMFJ3mx0ZMraE05KwVE4uCDWsp0vUztqLlsw1iUQtGhaYb6XgA
         0JCBPzHLfm+pu9T79pcnyC4bG2T7YjtwtdDE+lheQ+tIRxDo/vmXQn8s0A7ROUqEP46I
         C6eFK8+K6rFwkAuzPlDsi0sJGVYztNMF6XS+46JfB8jBqMOSpNfVE2fYnSvCCahqS/kQ
         GY2AMBjcYNkHTEMvJoWjeYKQXV3D7B29yzZOjQpXGl3iSxlkY6+omc404XTRi1eBWSbR
         U67g==
X-Gm-Message-State: AOAM533NunAjiJil/yElhY6J28agKWLgoEzqLlEi49XcpsrOWJ9/tA0+
        3xHbCG5dK6NtDfobGm7HhFlsjXTStkluBVybTTo7ryrh
X-Google-Smtp-Source: ABdhPJxuW9cxZgvxszH1Qh2lgx1PEkjBm25WsHyrClS9G068yjDMSO4fMyNvLH1092MNDzVS0E8+Qb1K4fAkXA0mlb8=
X-Received: by 2002:ac2:5b5a:: with SMTP id i26mr2569043lfp.182.1616207493814;
 Fri, 19 Mar 2021 19:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210320000001.915366-1-sdf@google.com> <CAADnVQLCdMWgB9tB4UiSFHp36vswfQO_R_1ifdPqyrD6UT6vqA@mail.gmail.com>
 <CAKH8qBvXwzOqJ_4ETF1LrBQKxhKWLWv28beFHHK+=Zd0hULGFQ@mail.gmail.com>
 <CAADnVQ+fg-HMM=TtsrZx1kJQpy7-fckcgkN00L-Gp5Aa-CzmQQ@mail.gmail.com> <CAKH8qBsdJak0eO_zsuzAyNmSkVtR99ZAgGgP=j8mtAn9CvZ58g@mail.gmail.com>
In-Reply-To: <CAKH8qBsdJak0eO_zsuzAyNmSkVtR99ZAgGgP=j8mtAn9CvZ58g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Mar 2021 19:31:22 -0700
Message-ID: <CAADnVQLyUk+J_GLQc4RTMDZCvMFcb4M_fLsSQYYWCz_f9nWiPw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog, 5)
 for BPF_TRAMP_F_CALL_ORIG
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 6:40 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Mar 19, 2021 at 5:33 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 5:25 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Fri, Mar 19, 2021 at 5:14 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Mar 19, 2021 at 5:00 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > __bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
> > > > > emits non-atomic one which breaks fentry/fexit with k8 atomics:
> > > > >
> > > > > P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
> > > > > K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)
> > > > >
> > > > > Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
> > > > > and running fexit_bpf2bpf selftest.
> > > > >
> > > > > Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  arch/x86/net/bpf_jit_comp.c | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > > > index 72b5a57e9e31..b35fc8023884 100644
> > > > > --- a/arch/x86/net/bpf_jit_comp.c
> > > > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > > > @@ -2012,7 +2012,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > > > >                 /* remember return value in a stack for bpf prog to access */
> > > > >                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> > > > >                 im->ip_after_call = prog;
> > > > > -               emit_nops(&prog, 5);
> > > > > +               memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> > > > > +               prog += X86_PATCH_SIZE;
> > > >
> > > > I'm well aware, but ideal_nops are pretty much gone already.
> > > > The changes are already in the -tip tree.
> > > > So I decided to reduce the conflicts for the merge window.
> > > >
> > > > Do you actually see the breakage or it's purely theoretical?
> > > We do see it, but it's on our tree that pulls from bpf.
> > > And it obviously doesn't have that "x86: Remove dynamic NOP selection" yet.
> > > Thanks for the pointer, I guess I can just wait for the real merge then.
> >
> > If it breaks the real users we have to land the fix, but let me ask how
> > come that you run with k8 cpu? k8 does other nasty things.
> > Do you run with all of amd errata?
> It's not amd, it's intel:
>
> cpu family      : 6
> model           : 45
> model name      : Intel(R) Xeon(R) CPU E5-2689 0 @ 2.60GHz
>
> I think I'm hitting the following from the arch/x86/kernel/alternative.c:
>
> /*
> * Due to a decoder implementation quirk, some
> * specific Intel CPUs actually perform better with
> * the "k8_nops" than with the SDM-recommended NOPs.
> */
> if (boot_cpu_data.x86 == 6 &&
>    boot_cpu_data.x86_model >= 0x0f &&
>    boot_cpu_data.x86_model != 0x1c &&
>    boot_cpu_data.x86_model != 0x26 &&
>    boot_cpu_data.x86_model != 0x27 &&
>    boot_cpu_data.x86_model < 0x30) {
> ideal_nops = k8_nops;

Ohh. Thanks for explaining. Applied.
