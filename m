Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2F827B36F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgI1RkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgI1RkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:40:08 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E2C061755;
        Mon, 28 Sep 2020 10:40:07 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id f70so1510613ybg.13;
        Mon, 28 Sep 2020 10:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bRUB/bwFEosynQ9K/iHMMiBU5kn7FkW/CO7KofKLlos=;
        b=VBtgkvhfPZXlkH9wbKCdmPcpJ8oNrc5LzViJQ3qoePtupLyCjiZ4OOjm10NdGvllI9
         j2iBN+oj8Z/ZBlPqmXgIJJCDiaUT9B3Rq/5dVhNefZZmk9udP0EPSvkwXBYf9yVDe8hM
         WF2tjNj/IGXXK2Wl3k0fy4e+5IXuiwTToHpK+72A0nqHiwxGEEkCOl9gffBP9/g78ufT
         TRYsVSlpHKLP5eJej2BQTyWRx4yqPJJ0ika6b5J28Nhl8Mjc24rasbTdt5SxJBE1onWx
         0M7wZj1OsV4DKm3CdoxBzGfsjVUxzf/jTm/yP476X30evHtWD9vIDWZOPQbmktlM4GNM
         V+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bRUB/bwFEosynQ9K/iHMMiBU5kn7FkW/CO7KofKLlos=;
        b=kLp/LHT1P6KQpgF4Khhv2h+2GSuWHDhuUavO7h+bP/of7gAWH/Q8h2Q9//2xrxX2hy
         sXr0pN28AWI/tMhnsX3kXONu+msVF3Z75WglHCxQiwUUrJ5wwSS4B4e29Aq5MAfKjr9G
         oVkAUINrStPDbLHJbYPuUSC7S7Gl1aEQDeVLpHGklrXRQ6Ur/wIkAe40e+eQAUq49iiw
         eqpAGuPE5o0gMynGktR+ItMnt+hX9cIxeAI0sE/WeptiIRqB0OmgC3UUECKFaTlizKHC
         NW70stvl7KMnIXAQm5t4tCwYyrMVuFkK8HKovzH5iRtgo8KT6G9T6SUlO6vQc9Mk5UpE
         ZajA==
X-Gm-Message-State: AOAM532U2Iw1mtkqwUKtTIRh2MQaGzbS55twd5vgV8k9y3VTrbX/Dj50
        HSjR/HgN/Z7La6duxHQIa5HPcmI5jaU+U7lw+ck=
X-Google-Smtp-Source: ABdhPJxQM1/V6NaKJCNgmuY84m1KTfRM5PpfbnvpUgsehTkepFHNfpLccl/qEDLPf6yIZNb4pxzYyclAl79UAG7EdRM=
X-Received: by 2002:a25:8541:: with SMTP id f1mr905314ybn.230.1601314806520;
 Mon, 28 Sep 2020 10:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1601303057.git.daniel@iogearbox.net> <9c4b6a19ced3e2ee6c6d28f5f3883cc7b2b02400.1601303057.git.daniel@iogearbox.net>
In-Reply-To: <9c4b6a19ced3e2ee6c6d28f5f3883cc7b2b02400.1601303057.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Sep 2020 10:39:55 -0700
Message-ID: <CAEf4BzYxSkjJzPVzOkOQkOVPUKri9aa69QGFrUdGjAf7f9Uf=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] bpf, libbpf: add bpf_tail_call_static
 helper for bpf programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 7:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Port of tail_call_static() helper function from Cilium's BPF code base [0]
> to libbpf, so others can easily consume it as well. We've been using this
> in production code for some time now. The main idea is that we guarantee
> that the kernel's BPF infrastructure and JIT (here: x86_64) can patch the
> JITed BPF insns with direct jumps instead of having to fall back to using
> expensive retpolines. By using inline asm, we guarantee that the compiler
> won't merge the call from different paths with potentially different
> content of r2/r3.
>
> We're also using Cilium's __throw_build_bug() macro (here as: __bpf_unreachable())
> in different places as a neat trick to trigger compilation errors when
> compiler does not remove code at compilation time. This works for the BPF
> back end as it does not implement the __builtin_trap().
>
>   [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andriin@fb.com>
> ---

few optional nits below, but looks good to me:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h | 46 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>

[...]

> +/*
> + * Helper function to perform a tail call with a constant/immediate map slot.
> + */
> +static __always_inline void
> +bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)

nit: const void *ctx would work here, right? would avoid users having
to do unnecessary casts in some cases

> +{
> +       if (!__builtin_constant_p(slot))
> +               __bpf_unreachable();
> +
> +       /*
> +        * Provide a hard guarantee that LLVM won't optimize setting r2 (map
> +        * pointer) and r3 (constant map index) from _different paths_ ending
> +        * up at the _same_ call insn as otherwise we won't be able to use the
> +        * jmpq/nopl retpoline-free patching by the x86-64 JIT in the kernel
> +        * given they mismatch. See also d2e4c1e6c294 ("bpf: Constant map key
> +        * tracking for prog array pokes") for details on verifier tracking.
> +        *
> +        * Note on clobber list: we need to stay in-line with BPF calling
> +        * convention, so even if we don't end up using r0, r4, r5, we need
> +        * to mark them as clobber so that LLVM doesn't end up using them
> +        * before / after the call.
> +        */
> +       asm volatile("r1 = %[ctx]\n\t"
> +                    "r2 = %[map]\n\t"
> +                    "r3 = %[slot]\n\t"
> +                    "call 12\n\t"

nit: it's weird to have tabs at the end of each string literal,
especially that r1 doesn't start with a tab...

> +                    :: [ctx]"r"(ctx), [map]"r"(map), [slot]"i"(slot)
> +                    : "r0", "r1", "r2", "r3", "r4", "r5");
> +}
> +
>  /*
>   * Helper structure used by eBPF C program
>   * to describe BPF map attributes to libbpf loader
> --
> 2.21.0
>
