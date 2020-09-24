Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE3D277AC3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIXUxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXUxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:53:34 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10740C0613CE;
        Thu, 24 Sep 2020 13:53:34 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c17so449487ybe.0;
        Thu, 24 Sep 2020 13:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X26VXKRgJ7zz5yLrfSCPbvsxms5PpiX1aZI3xlblKCM=;
        b=pF4l5kOfZDgwoIu9tTiKpek9ESrndPb6mlOlkX7yy5XufY5YHgIB5x8u/O2zIiVnph
         zvpw1lgzqg2k4AXGBdqxI3KOwFxgAKCrmPzQp2jLU0OhYGxOP3nKOdnbN8DbOBBD4oVx
         O/RkX0KrAYNDvUz2GP5zLAjEMTf25HxZtQt8MT9M9CHLGd8tYiuwM77+8tYbrjU3GOws
         PFZ8fzNlnhEevoLhdjbpVz5wMVifILI3kxx5m5wY/+vcidA9bTU25caOFf8IWVc3gMsf
         i6W91RJSnYpg6HnJknnxlscMTRLPAWRzNDDqhvyhGVyHmvqDEhH4rXoZEiCeuP/ood4+
         /Prg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X26VXKRgJ7zz5yLrfSCPbvsxms5PpiX1aZI3xlblKCM=;
        b=nbAyTkUOvTbqoV/JpyKUVzKm0FVWl0fbOqrqtpOAsGOTRlUMXe41RV+X7rZjxrrjFC
         0mtMacJeQdM7VnixueUtRxCcQ2tpC9OJvLOsbceFJ8UQqZqaD+I92oRpFQFiVTNh1O6V
         uWE2lC9WW1hUZA8QLGDTT5t0pmwI3M9R24yS6wVcSCDKLa8bahWBlrsu0xBZOUFTKNxa
         kNNqUNTjZmtLvcyXtWhQx3x4JHQdzecpGp7X+GnPmnaFyGGqZF+CINsRgsmdFSGTGj1r
         0Lc+k9dS94RuTIFBN/Q4TyLQeX4PpK/1RlCW2oATejf7Dx8MVSf9K8pkFfHaRjXV1G/x
         pKLA==
X-Gm-Message-State: AOAM533Zm+YDoLqYbsScDkgxXBkgC96n/SqoZJ17zqN5hNsaCD7ZWkvW
        +tpxExK2ffTUC2zJrv1MDokckdso+WS0/yFc2B8=
X-Google-Smtp-Source: ABdhPJyypHnYyn1YRsUIR9LU7dvDH1WnI3MjfVYn6H+VyJZZPaSBD8RC0H0kccJvjIF/zjAS1ZtZC5sP378N7UpFpDQ=
X-Received: by 2002:a25:730a:: with SMTP id o10mr925796ybc.403.1600980813180;
 Thu, 24 Sep 2020 13:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600967205.git.daniel@iogearbox.net> <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
In-Reply-To: <ae48d5b3c4b6b7ee1285c3167c3aa38ae3fdc093.1600967205.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:53:22 -0700
Message-ID: <CAEf4BzZ4kFGeUgpJV9MgE1iJ6Db=E-TXoF73z3Rae5zgp5LLZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] bpf, libbpf: add bpf_tail_call_static helper
 for bpf programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:22 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
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
> We're also using __throw_build_bug() macro in different places as a neat
> trick to trigger compilation errors when compiler does not remove code at
> compilation time. This works for the BPF backend as it does not implement
> the __builtin_trap().
>
>   [0] https://github.com/cilium/cilium/commit/f5537c26020d5297b70936c6b7d03a1e412a1035
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/lib/bpf/bpf_helpers.h | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 1106777df00b..18b75a4c82e6 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -53,6 +53,38 @@
>         })
>  #endif
>
> +/*
> + * Misc useful helper macros
> + */
> +#ifndef __throw_build_bug
> +# define __throw_build_bug()   __builtin_trap()
> +#endif

this will become part of libbpf stable API, do we want/need to expose
it? If we want to expose it, then we should probably provide a better
description.

But also curious, how is it better than _Static_assert() (see
test_cls_redirect.c), which also allows to provide a better error
message?

> +
> +static __always_inline void
> +bpf_tail_call_static(void *ctx, const void *map, const __u32 slot)
> +{
> +       if (!__builtin_constant_p(slot))
> +               __throw_build_bug();
> +
> +       /*
> +        * Don't gamble, but _guarantee_ that LLVM won't optimize setting
> +        * r2 and r3 from different paths ending up at the same call insn as
> +        * otherwise we won't be able to use the jmpq/nopl retpoline-free
> +        * patching by the x86-64 JIT in the kernel.
> +        *

So the clobbering comment below is completely clear. But this one is
less clear without some sort of example situation in which bad things
happen. Do you mind providing some pseudo-C example in which the
compiler will optimize things in such a way that the tail call
patching won't happen?

> +        * Note on clobber list: we need to stay in-line with BPF calling
> +        * convention, so even if we don't end up using r0, r4, r5, we need
> +        * to mark them as clobber so that LLVM doesn't end up using them
> +        * before / after the call.
> +        */
> +       asm volatile("r1 = %[ctx]\n\t"
> +                    "r2 = %[map]\n\t"
> +                    "r3 = %[slot]\n\t"
> +                    "call 12\n\t"
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
