Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDCC375E73
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhEGBhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEGBhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 21:37:50 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E41C061574;
        Thu,  6 May 2021 18:36:51 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id c3so10531454lfs.7;
        Thu, 06 May 2021 18:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yp92bb3c6SvtXsIjAOJgzWLF7h8li9Wnf1HLRPggKFg=;
        b=VbYVVX4p8gqRYI4xPWPKYkP4e7wOcnI/duVCy13AmT+drOv0RR9eehgffrbmMp8tUS
         viWQHf9f0ApvEKQhbJvHJ4240wkeUGWQWUr/Szxb+fXFNLaLulNQPmsIevMCEX8T6/jr
         DqDHh2Mg0GsRCN6p9gjp1k3E40YdBAKXYxcosoECRbAIhe5eGZx7LgTsgi+CWdLh6F01
         Vp/FMv57UWx4nRyvT628mlJGzUab8ukmLe31wA27a4tReKp7VjEn7iR7b4UeW7CjePsX
         BqlI22usYmDYqSqvJ8AWVe8ngIbK86OMHzvyF9Hvn2/oczGA0MxINu7qx0hJKyeomcBE
         XW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yp92bb3c6SvtXsIjAOJgzWLF7h8li9Wnf1HLRPggKFg=;
        b=SvPUJkDYUChHun1yjfQlztArCwA/04vIpzIB+43fan1NW8lKE6E9WbrmYipfCtRUdw
         kF7B4TNN3SyKkZC1pP/40orN14hcN4nPL/dLY98IPuRYCNaqju6w4ahhwPqNRS/XEDGa
         tztgydCk+vMnXEUeQqrXi62MREo80U2ZNJkNNfqFsRJ5k1uMRzsEhh5r9bg5q4hJMmTG
         a5kDBpwd2LL3bUq5H+6qNfrSRmz4OJGyQVZvbMwOyIyUhOjRYmmcBKxGJyUyIh5+QldN
         io4aSnaLuwmAirUtCfMfgifNNfkL29pif+f6XTwbyKVcgYiWtSe0FDapF0QK7Ni7MXJM
         usog==
X-Gm-Message-State: AOAM533tSWYQMq2aLoItMq7nBo0L/Wi7/e8NiSQU3dHwzqtwETWmKGtO
        dbsbRzJ8GNV2es+OBAprCT4B1RqRCCHZc5OFn6c=
X-Google-Smtp-Source: ABdhPJyUFJpvuSJsvsGGISKzUcW11B7p50GcV5lnAf1wGaOYxSigFhSpFAeTnUK/rz15TutmLQqFMmj8wTbJceUjKFU=
X-Received: by 2002:a05:6512:2036:: with SMTP id s22mr5161234lfs.540.1620351409650;
 Thu, 06 May 2021 18:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210429114712.43783-1-jolsa@kernel.org>
In-Reply-To: <20210429114712.43783-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 May 2021 18:36:38 -0700
Message-ID: <CAADnVQLDwjE8KFcqbzB5op5b=fC2941tnnWOtQ+X1DYi6Yw1xA@mail.gmail.com>
Subject: Re: [PATCHv2] bpf: Add deny list of btf ids check for tracing programs
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 4:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The recursion check in __bpf_prog_enter and __bpf_prog_exit
> leaves some (not inlined) functions unprotected:
>
> In __bpf_prog_enter:
>   - migrate_disable is called before prog->active is checked
>
> In __bpf_prog_exit:
>   - migrate_enable,rcu_read_unlock_strict are called after
>     prog->active is decreased
>
> When attaching trampoline to them we get panic like:
>
>   traps: PANIC: double fault, error_code: 0x0
>   double fault: 0000 [#1] SMP PTI
>   RIP: 0010:__bpf_prog_enter+0x4/0x50
>   ...
>   Call Trace:
>    <IRQ>
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    ...
>
> Fixing this by adding deny list of btf ids for tracing
> programs and checking btf id during program verification.
> Adding above functions to this list.
>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> v2 changes:
>   - drop check for EXT programs [Andrii]
>
>  kernel/bpf/verifier.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2579f6fbb5c3..42311e51ac71 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13112,6 +13112,17 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
>         return 0;
>  }
>
> +BTF_SET_START(btf_id_deny)
> +BTF_ID_UNUSED
> +#ifdef CONFIG_SMP
> +BTF_ID(func, migrate_disable)
> +BTF_ID(func, migrate_enable)
> +#endif
> +#if !defined CONFIG_PREEMPT_RCU && !defined CONFIG_TINY_RCU
> +BTF_ID(func, rcu_read_unlock_strict)
> +#endif
> +BTF_SET_END(btf_id_deny)

I was wondering whether it makes sense to do this on pahole side instead ?
It can do more flexible regex matching and excluding all such functions
from vmlinux btf without the kernel having to do a maze of #ifdef
depending on config.
On one side we will lose BTF info about such functions, but what do we
need it for?
On the other side it will be a tiny reduction in vmlinux btf :)
Thoughts?
