Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5743342962
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 01:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhCTAO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 20:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhCTAOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 20:14:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C8C061760;
        Fri, 19 Mar 2021 17:14:15 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id q13so12582859lfu.8;
        Fri, 19 Mar 2021 17:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kyZRY0KU4xDNE+96ywWaGNkTYhFcY1ukMn6saa2e/Ds=;
        b=BBzMchccShu3YT2oPuKWY97nM0lep3Y1dIFcE4oh4RYmcZyLKXmvcG3+kJD4prI3VY
         xjNTisRypbZB4sRkT88NxQPktp0hfyxVqvbOH037c5TKFexLaS8ExgZbYpUlO6WfyCsU
         kAACMQpYnFKmcF8pseualRCGVvBspxfvkVaOcgMcGQlWy8cTQn/WScMZlE0xhDDIohs5
         84GPGCfUKuh7aoMG+X9dDAig0ui0ymDWu+kUDfLGzvo00mAtxU2X8Fozr77JkmRZLRJP
         D+eHMHihN6zYArHFpXgipBrySKL6B6GtndOvCXFr65i/YNYJ4uye6rsbWRFRGiFNBatC
         Av2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyZRY0KU4xDNE+96ywWaGNkTYhFcY1ukMn6saa2e/Ds=;
        b=QPoPKVcu1LFrdam/IuX1KsN8VuookFwo4bu1A00ERD6CtpGDtBaZNgEvYirJK/jF95
         wLOC9dgissfv2dajvzVzL2eHN/JsfH+TtV32rWTua9zQ0tVp00HczrGKMMQ1X0b/4PVf
         buxetIWOAIpEaDu1L23C/FzrJFu6NTYebhWck9zDJL5opsOUAvb+3UG+K12ay9CazhBv
         9n8/wCU5m0FGeRICuoyuDCuhHVgXNnpqSTmoZoCXzrvFHz5pXCkjhmAqe5e0dsA9kbK7
         pb1NZ0G9iXSsqjJZBiHSVO1fpQSdB2MdvPcdfnbWJ7Xe4LBA/qpynZAhX0hDEsCUBx6N
         gYLg==
X-Gm-Message-State: AOAM533LLisEEg6LEpGuM9l/m9zrFA1wD8ckli9TWW3O1QwppDl+5DM7
        CD9Mq3exAD631dpAaFE65rkgF1F5qU7NrrGYnqM=
X-Google-Smtp-Source: ABdhPJz5XQeMVbRBvhO5PDNHsZCJPGkDqQgbsxp7Hc7A/kRSyJAGF6Zmu3+RP2f9tj7MpUYcbu0RxpK4feQmlDL7TTw=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr2365733lfq.214.1616199253512;
 Fri, 19 Mar 2021 17:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210320000001.915366-1-sdf@google.com>
In-Reply-To: <20210320000001.915366-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 19 Mar 2021 17:14:02 -0700
Message-ID: <CAADnVQLCdMWgB9tB4UiSFHp36vswfQO_R_1ifdPqyrD6UT6vqA@mail.gmail.com>
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

On Fri, Mar 19, 2021 at 5:00 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> __bpf_arch_text_poke does rewrite only for atomic nop5, emit_nops(xxx, 5)
> emits non-atomic one which breaks fentry/fexit with k8 atomics:
>
> P6_NOP5 == P6_NOP5_ATOMIC (0f1f440000 == 0f1f440000)
> K8_NOP5 != K8_NOP5_ATOMIC (6666906690 != 6666666690)
>
> Can be reproduced by doing "ideal_nops = k8_nops" in "arch_init_ideal_nops()
> and running fexit_bpf2bpf selftest.
>
> Fixes: e21aa341785c ("bpf: Fix fexit trampoline.")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 72b5a57e9e31..b35fc8023884 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2012,7 +2012,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>                 /* remember return value in a stack for bpf prog to access */
>                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
>                 im->ip_after_call = prog;
> -               emit_nops(&prog, 5);
> +               memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> +               prog += X86_PATCH_SIZE;

I'm well aware, but ideal_nops are pretty much gone already.
The changes are already in the -tip tree.
So I decided to reduce the conflicts for the merge window.

Do you actually see the breakage or it's purely theoretical?
