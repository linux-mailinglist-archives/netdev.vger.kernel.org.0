Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74203429AC
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 02:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhCTBlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 21:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCTBky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 21:40:54 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA9EC061760
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 18:40:54 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i9so4922698qka.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 18:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j70/tM1l2gVFoj1Vlwmu23HMZ+Naj9/vNEgAl0EBlR8=;
        b=ig3LH0bVLzrhwGSQ9xftM57zVglOx3bWlooIL6mAuw8/UaGnuLa5BK9B4HWknUw4b+
         Jd6/y4aZQPqEHrNZViRXArXM0X89f7RLcgVRYNdhXphA379oORewECw8kffmUO0c2fsj
         /tBE5x2Ca3TiiutNiSH8X89fBEBstrus7ywIDFZHpMV40ikx3GhcdTPQS1sF5Zk2QuRh
         Nv9yEqlcZ67dU4HP3XhQyAP30ghLhH5hjJfFeY6+2hevBtRU1cbizXHwFPJVFYdeAQxL
         6ijPkGzITIYdDH1wXbSk/AD6UddbZ+RDV0Xoh52pGIZZdXZtzjdw4ElD0pbRSpinU3tt
         aQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j70/tM1l2gVFoj1Vlwmu23HMZ+Naj9/vNEgAl0EBlR8=;
        b=O30BtJqDqYc/CnSZ3ptBmTqeOfCgrRhz/EQocCLFM9UA/eV4zSsfzncPwYG4XHGxSI
         tdFQt6w48WcQOZND5HUupIp/IOmLn1u5eIAC6IDS5hAdkxc1TRnb+pk9vano0TJD8PP3
         2l4Ccua/O9qay+W7cig6mw0qaLH976cNitAxkxeIp5VdNsG5kADfndO7aTJfhMAtaHF+
         KqJoafV5tCAXapl5aoG10aQ5Vq7oRA8/BZr6aCeVfB7tNYsMuNyaMPMsAF4La+zriO+w
         jWb0lg1YrgE9rT9rk5vsBMiRycDJXDUYsXIqYHv9dqa4xF2tVvhU/VUx72gii0ByJNpS
         q4/w==
X-Gm-Message-State: AOAM531USBczvlpGeACkA9g/KdGwfjhPAo4VXW1XsjvfYGk5/Kxjlsqr
        paCo7eGmOgrHvF7dAfu6+Am2eAtNmuU3ahCK7fYVTg==
X-Google-Smtp-Source: ABdhPJwxfsoYOA1pKbYhaAnz7sx1ZvOUCjOA+qWYBrmIelPcsW/iwOYx+f3NqTh+NwBXaKQrZRGQ3ApUDgMiVGWfyq8=
X-Received: by 2002:a37:6108:: with SMTP id v8mr1408297qkb.448.1616204453261;
 Fri, 19 Mar 2021 18:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210320000001.915366-1-sdf@google.com> <CAADnVQLCdMWgB9tB4UiSFHp36vswfQO_R_1ifdPqyrD6UT6vqA@mail.gmail.com>
 <CAKH8qBvXwzOqJ_4ETF1LrBQKxhKWLWv28beFHHK+=Zd0hULGFQ@mail.gmail.com> <CAADnVQ+fg-HMM=TtsrZx1kJQpy7-fckcgkN00L-Gp5Aa-CzmQQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+fg-HMM=TtsrZx1kJQpy7-fckcgkN00L-Gp5Aa-CzmQQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 19 Mar 2021 18:40:42 -0700
Message-ID: <CAKH8qBsdJak0eO_zsuzAyNmSkVtR99ZAgGgP=j8mtAn9CvZ58g@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: use NOP_ATOMIC5 instead of emit_nops(&prog, 5)
 for BPF_TRAMP_F_CALL_ORIG
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 5:33 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Mar 19, 2021 at 5:25 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Fri, Mar 19, 2021 at 5:14 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Mar 19, 2021 at 5:00 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > __bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
> > > > emits non-atomic one which breaks fentry/fexit with k8 atomics:
> > > >
> > > > P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
> > > > K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)
> > > >
> > > > Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
> > > > and running fexit_bpf2bpf selftest.
> > > >
> > > > Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  arch/x86/net/bpf_jit_comp.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > > > index 72b5a57e9e31..b35fc8023884 100644
> > > > --- a/arch/x86/net/bpf_jit_comp.c
> > > > +++ b/arch/x86/net/bpf_jit_comp.c
> > > > @@ -2012,7 +2012,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> > > >                 /* remember return value in a stack for bpf prog to access */
> > > >                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> > > >                 im->ip_after_call = prog;
> > > > -               emit_nops(&prog, 5);
> > > > +               memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> > > > +               prog += X86_PATCH_SIZE;
> > >
> > > I'm well aware, but ideal_nops are pretty much gone already.
> > > The changes are already in the -tip tree.
> > > So I decided to reduce the conflicts for the merge window.
> > >
> > > Do you actually see the breakage or it's purely theoretical?
> > We do see it, but it's on our tree that pulls from bpf.
> > And it obviously doesn't have that "x86: Remove dynamic NOP selection" yet.
> > Thanks for the pointer, I guess I can just wait for the real merge then.
>
> If it breaks the real users we have to land the fix, but let me ask how
> come that you run with k8 cpu? k8 does other nasty things.
> Do you run with all of amd errata?
It's not amd, it's intel:

cpu family      : 6
model           : 45
model name      : Intel(R) Xeon(R) CPU E5-2689 0 @ 2.60GHz

I think I'm hitting the following from the arch/x86/kernel/alternative.c:

/*
* Due to a decoder implementation quirk, some
* specific Intel CPUs actually perform better with
* the "k8_nops" than with the SDM-recommended NOPs.
*/
if (boot_cpu_data.x86 == 6 &&
   boot_cpu_data.x86_model >= 0x0f &&
   boot_cpu_data.x86_model != 0x1c &&
   boot_cpu_data.x86_model != 0x26 &&
   boot_cpu_data.x86_model != 0x27 &&
   boot_cpu_data.x86_model < 0x30) {
ideal_nops = k8_nops;
