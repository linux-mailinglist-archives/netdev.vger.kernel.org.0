Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9912444283
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhKCNil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhKCNil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:38:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D39AC061714;
        Wed,  3 Nov 2021 06:36:04 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso1864683wme.3;
        Wed, 03 Nov 2021 06:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9Uvh5caEZPaBGsYkz+RB5PR1cX52FmrRW0kzG11c76w=;
        b=qI/UsZ2Mq1UosSHGW96E1Ln6Ohj4iHO3r5lBIvPiiNnSxIBIgcvQTvfRZyeI4uu4O/
         HYbGeRhksts0ElYrEG0INKEe7aXhGIbNRoa+5SfNLfBRpFlXkAKGayX0LZ63aqDWcpJu
         dosgFRYQhPioiFxg3dKiHepeHKdbG2JsP/JMlRyX4UEPlfgB3nyfKFkz67tWL42Oz4Lq
         haeTteOxmjvqdt2T96vQoPKq68khNWceoi3kbQKOgXwGPz4h2E6HMJQpKmhk4bbm2avI
         AoSD57sN9RO2aPG2Vw102MrdVN2OMUIaMVVTVHFMc1zAox6M/EelPvrtB3rZV8jRItpA
         XAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9Uvh5caEZPaBGsYkz+RB5PR1cX52FmrRW0kzG11c76w=;
        b=X4e65o8V2tH7oqGNHwlB5oSAQ3w28WKc6w75n35cYKxoj6huTDF1QSHoG5D4Qo9VKc
         pJvGcRh7o4GqXSfhQorQPhObNGrmoITKMOQs6zaTqxaRs1ZWe96IOtvYkiYeugHRIrtp
         I2tByDP9cWGQHm12v+XttRw4dGGIVC/PsehTCDua/WEnV6ni6tVOHPETLTKuQpSRFCws
         TuRkDr3hZiqcfftyC2aKP8N9MmTQ7vEnCGmTVDqi/lPtPiAkxm36u6x/mONQ6mC2bFnE
         DjXOrbUxxtc3qKaMicg1Ysqhph/g+ZtHvmPzfeu4sJUWdYqDBPkqQk4FNLQ6uwaNwiyD
         /mPw==
X-Gm-Message-State: AOAM530x/MKUsSp2biNvnKvyNPOV3wXRFefQPuOn1qEgnBC7dSXw8M6b
        x0yHhEExRwgQPJvPzq/esXBLlXlfwWwdd4sV72A=
X-Google-Smtp-Source: ABdhPJyk9Vedichm0HF4wrXK3I6wCZMF2YAnKWK9qhd5b6mRw8h4ORBTyVOJ9T9BtxHsr3rVBwd+WcJuTZ2OQtcKxVM=
X-Received: by 2002:a1c:740e:: with SMTP id p14mr15144147wmc.109.1635946563010;
 Wed, 03 Nov 2021 06:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211103115453.397209-1-bjorn@kernel.org> <f98b15c9-bd06-267e-e404-ae4f607d8740@iogearbox.net>
In-Reply-To: <f98b15c9-bd06-267e-e404-ae4f607d8740@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 3 Nov 2021 14:35:50 +0100
Message-ID: <CAJ+HfNg9Ko93D1M5En8wv4f-7j_by=OwnewRDiM+xQ0EZLw06w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] riscv, bpf: Fix RV32 broken build, and silence
 RV64 warning
To:     Daniel Borkmann <daniel@iogearbox.net>, jszhang@kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 at 14:15, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/3/21 12:54 PM, Bj=C3=B6rn T=C3=B6pel wrote:
> > Commit 252c765bd764 ("riscv, bpf: Add BPF exception tables") only
> > addressed RV64, and broke the RV32 build [1]. Fix by gating the excepti=
on
> > tables code with CONFIG_ARCH_RV64I.
> >
> > Further, silence a "-Wmissing-prototypes" warning [2] in the RV64 BPF
> > JIT.
> >
> > [1] https://lore.kernel.org/llvm/202111020610.9oy9Rr0G-lkp@intel.com/
> > [2] https://lore.kernel.org/llvm/202110290334.2zdMyRq4-lkp@intel.com/
> >
> > Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> > ---
> > Tong/Daniel: The RV32 build has been broken since Thursday. I'll try
> > to fast-track a bit, and commit a quick-fix for it. Hope that's OK
> > with you, Tong!
> >
> > I've verified the build on my machine using riscv32 GCC 9.3.0 and
> > riscv64 GCC 11.2.0.
>
> Thanks for the fix Bjorn!
>
> > arch/riscv/mm/extable.c         | 4 ++--
> >   arch/riscv/net/bpf_jit_comp64.c | 2 ++
> >   2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
> > index 18bf338303b6..ddb7d3b99e89 100644
> > --- a/arch/riscv/mm/extable.c
> > +++ b/arch/riscv/mm/extable.c
> > @@ -11,7 +11,7 @@
> >   #include <linux/module.h>
> >   #include <linux/uaccess.h>
> >
> > -#ifdef CONFIG_BPF_JIT
> > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
> >   int rv_bpf_fixup_exception(const struct exception_table_entry *ex, st=
ruct pt_regs *regs);
> >   #endif
> >
> > @@ -23,7 +23,7 @@ int fixup_exception(struct pt_regs *regs)
> >       if (!fixup)
> >               return 0;
> >
> > -#ifdef CONFIG_BPF_JIT
> > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
> >       if (regs->epc >=3D BPF_JIT_REGION_START && regs->epc < BPF_JIT_RE=
GION_END)
> >               return rv_bpf_fixup_exception(fixup, regs);
> >   #endif
> > diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_c=
omp64.c
> > index 2ca345c7b0bf..f2a779c7e225 100644
> > --- a/arch/riscv/net/bpf_jit_comp64.c
> > +++ b/arch/riscv/net/bpf_jit_comp64.c
> > @@ -459,6 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct r=
v_jit_context *ctx)
> >   #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
> >   #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
> >
> > +int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
> > +                             struct pt_regs *regs);
>
> I'm okay to take this as a quick fix, but if its not too much hassle, cou=
ld we add a
> arch/riscv/include/asm/extable.h in similar fashion like arm64 or x86 whe=
re we move
> the ex_handler_bpf() signature there, did you have a chance to check?
>

OK! I've not looked into it yet!

There's a patch out from Jisheng on the RV list, which is starting
some consolidation work [1].

@Jisheng What do you think about adding type/handlers [2,3] as
arm64/x86 recently did, to your series?


Bj=C3=B6rn

[1] https://lore.kernel.org/linux-riscv/20211022001957.1eba8f04@xhacker/
[2] https://lore.kernel.org/linux-arm-kernel/20211019160219.5202-11-mark.ru=
tland@arm.com/
[3] https://lore.kernel.org/lkml/20210908132525.211958725@linutronix.de/
