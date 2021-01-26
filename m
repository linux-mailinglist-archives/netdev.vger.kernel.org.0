Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6AC3048FE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbhAZFey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbhAZBuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:50:07 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858DEC061351;
        Mon, 25 Jan 2021 16:32:32 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id x78so15090274ybe.11;
        Mon, 25 Jan 2021 16:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FL9eji8IEU4GjraOBf+9ed4vg2HJTGgpMF/wdNIdtuU=;
        b=TEw3S7qjGpwdYpgjgpRdTMZF7C7r4YVMZMyZFnbBCpNfoh3WmnCrepMGKdaOJa6xVz
         qSyDhJ8znP/2CQ/pDrihjmMQVhlzOuyQuzhw/iBjzTkazDia0w9bQYH5Q9sC5omwiUsQ
         ciJTVYv0qPkAouh90csi/29BkTyXfF0zmEmPFsyGv/YCjvolv0QoMQR6uoni4vuX2ZfB
         E8qkn6ZdlPOfqNYztDMgpbTzbg5VsMBJeT0uND3YGMaOsI95nU/drZWQlePr12+oDjnp
         2tJY8wsGmW8Ss/SVtZrGaz4YQQYc32ehOGKF0kl1qo+hF9hgQz4J7KnQz+M63f9iHhDw
         z9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FL9eji8IEU4GjraOBf+9ed4vg2HJTGgpMF/wdNIdtuU=;
        b=jsMSlBkJgXK1cVMEOVR46UbRanUJJG+OzX0NIckkWqxVZCn0V37CN+rNsngY+NHQVQ
         p4DLIyZa8uJACyE1j4rK89rY3pRjSQEuxrQ5llIeeC7VfN5TaKbNTzM7Gyynlhzk+nfj
         YXHRg57AK7OMGTxGh3Dk2dr1a+0yfR3QGmnWk4qfwNu58IcqgYGUZrwre8x7936dU+sb
         8DxL5q06CBndB4K2zHMXCNRwTQOCG+6G5S/uTEMxXeA3mzGdBlYoyPRPW2dWV8dRp7oI
         fuAE/RBOtlYB5RKGjiMfz3Gsplmxbq9RnTFiIxRMI8cFvcU+0Rp3SQ8qOmCXwrYUtz2v
         hLbg==
X-Gm-Message-State: AOAM530SAoy9aUvS71HWlk/fF/yhlNICbyvG4HjO7RksFUJ5Ae0cY1p0
        7MBf3sKZha6AQFoKhq3gCwysgPxszqwXK2fvXbU=
X-Google-Smtp-Source: ABdhPJxzxbb1IlWqyhxs9Q6vVoNuZJIX81co+Gh8/YTs8nSKoZF2AtTSunXSnwFyu/S0y9RexUnifVJe9PZsml5oP6E=
X-Received: by 2002:a25:b195:: with SMTP id h21mr4544979ybj.347.1611621151736;
 Mon, 25 Jan 2021 16:32:31 -0800 (PST)
MIME-Version: 1.0
References: <20210125154938.40504-1-quentin@isovalent.com>
In-Reply-To: <20210125154938.40504-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Jan 2021 16:32:21 -0800
Message-ID: <CAEf4BzYKrmMM_9SRKyGA0LNv-DvThpr9cQsNLVtn5h0jEUYtWg@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix build for BPF preload when $(O) points to a
 relative path
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 7:49 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Building the kernel with CONFIG_BPF_PRELOAD, and by providing a relative
> path for the output directory, may fail with the following error:
>
>   $ make O=build bindeb-pkg
>   ...
>   /.../linux/tools/scripts/Makefile.include:5: *** O=build does not exist.  Stop.
>   make[7]: *** [/.../linux/kernel/bpf/preload/Makefile:9: kernel/bpf/preload/libbpf.a] Error 2
>   make[6]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf/preload] Error 2
>   make[5]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf] Error 2
>   make[4]: *** [/.../linux/Makefile:1799: kernel] Error 2
>   make[4]: *** Waiting for unfinished jobs....
>
> In the case above, for the "bindeb-pkg" target, the error is produced by
> the "dummy" check in Makefile.include, called from libbpf's Makefile.
> This check changes directory to $(PWD) before checking for the existence
> of $(O). But at this step we have $(PWD) pointing to "/.../linux/build",
> and $(O) pointing to "build". So the Makefile.include tries in fact to
> assert the existence of a directory named "/.../linux/build/build",
> which does not exist.
>
> By contrast, other tools called from the main Linux Makefile get the
> variable set to $(abspath $(objtree)), where $(objtree) is ".". We can
> update the Makefile for kernel/bpf/preload to set $(O) to the same
> value, to permit compiling with a relative path for output. Note that
> apart from the Makefile.include, the variable $(O) is not used in
> libbpf's build system.
>
> Note that the error does not occur for all make targets and
> architectures combinations.
>
> - On x86, "make O=build vmlinux" appears to work fine.
>   $(PWD) points to "/.../linux/tools", but $(O) points to the absolute
>   path "/.../linux/build" and the test succeeds.
> - On UML, it has been reported to fail with a message similar to the
>   above (see [0]).
> - On x86, "make O=build bindeb-pkg" fails, as described above.
>
> It is unsure where the different values for $(O) and $(PWD) come from
> (likely some recursive make with different arguments at some point), and
> because several targets are broken, it feels safer to fix the $(O) value
> passed to libbpf rather than to hunt down all changes to the variable.
>
> David Gow previously posted a slightly different version of this patch
> as a RFC [0], two months ago or so.
>
> [0] https://lore.kernel.org/bpf/20201119085022.3606135-1-davidgow@google.com/t/#u
>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Reported-by: David Gow <davidgow@google.com>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

I still think it would benefit everyone to figure out where this is
breaking (given Linux Makefile explicitly tries to handle such
relative path situation for O=, I believe), but this is trivial
enough, so:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

BTW, you haven't specified which tree you intended it for.

>  kernel/bpf/preload/Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> index 23ee310b6eb4..11b9896424c0 100644
> --- a/kernel/bpf/preload/Makefile
> +++ b/kernel/bpf/preload/Makefile
> @@ -4,8 +4,11 @@ LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
>  LIBBPF_A = $(obj)/libbpf.a
>  LIBBPF_OUT = $(abspath $(obj))
>
> +# Set $(O) so that the "dummy" test in tools/scripts/Makefile.include, called
> +# by libbpf's Makefile, succeeds when building the kernel with $(O) pointing to
> +# a relative path, as in "make O=build bindeb-pkg".
>  $(LIBBPF_A):
> -       $(Q)$(MAKE) -C $(LIBBPF_SRCS) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
> +       $(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(abspath .) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a

why not O=$(LIBBPF_OUT), btw?

>
>  userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
>         -I $(srctree)/tools/lib/ -Wno-unused-result
> --
> 2.25.1
>
