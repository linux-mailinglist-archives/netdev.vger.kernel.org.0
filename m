Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958BA372329
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhECWqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhECWqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 18:46:35 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7243CC061574;
        Mon,  3 May 2021 15:45:40 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id h202so671159ybg.11;
        Mon, 03 May 2021 15:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dd8PPqagotgsii7UGnjmNKQl6bRsvX0ze6s7JjbKli0=;
        b=oyy0BG6+W6Wi3N6AcIPX5xbAs56cy5LMsWEOoBCXovAX88vgneteKVCw1+UzC1DbN1
         bpvrzWrXpGfqSjKZfk7hqdoI24gHICsZEzLp0ebJwoQ6eRp17acloCD5RlJvkIp93+FX
         /2TOFJ6dEAnFgnspL65Do0LXGVm+xqc2I3fwHK/+BBu7vm6XzT3JgWUQCFs0UvWLbAZI
         lsjNle3aKfspJtEE9gTLnOX8Sy/lL9SCbjcWUHuM/hhhgh0JUDs5WEcmo9++Z5TE52/p
         6t1FhYrcoctAAfYplW1BngIegI3I9v6sxgknmskG/U8mrGTYpYOLirG8Akcq6p3VKNug
         YlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dd8PPqagotgsii7UGnjmNKQl6bRsvX0ze6s7JjbKli0=;
        b=VfC7ni70/r0NhH0J18rIr5FtY3erji8MjvVrFUEzUol+nDMaR+gFwHLdeuJcDTmCLA
         t+XeFl6S245hnVevlsOB/3CLQ+knwpfuLiohkLk+aw2pLmJXGKrLu5k0e3ai0ZnwXZAm
         vpk7BTQFy6c+xrYE7LBw72ebpPTnfnZFsFGsQDbrS04l8r3BwlXq71Ib8rMJeNL8fU0r
         b7Vb0ch9rvLlHrD0SN3BC7WVxjbVJ+MB7CleGkCcjY3X5GKemNEy+5LHlyneVPn1morl
         zeRw5NWkWQpGHY22CqetjxpAedhkvNhjm91pVf6tdj3Yu6hQeKw2gHrInYuAYBTKq7Vk
         liZw==
X-Gm-Message-State: AOAM530HH4E1mD2zWDIX5imAwazyYk1Bxwv0RsdV1KtD2X4hw2je22Dw
        0udYcCcWPr6ao/CeurKT2vjOi55WNUK/5kZkTrE=
X-Google-Smtp-Source: ABdhPJzgnoRkbWzA4Pc9UbEpW/9etOdJ/+Ai6oHTGRxvYWC+MvJRvpKI2z92viU/IkzjPPFwpf2L19I4aNuBSNGYByE=
X-Received: by 2002:a25:1455:: with SMTP id 82mr29921123ybu.403.1620081939643;
 Mon, 03 May 2021 15:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210430134754.179242-1-jolsa@kernel.org>
In-Reply-To: <20210430134754.179242-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 May 2021 15:45:28 -0700
Message-ID: <CAEf4BzbEjvccUDabpTiPOiXK=vfcmHaXjeaTL8gCr08=6fBqhg@mail.gmail.com>
Subject: Re: [RFC] bpf: Fix crash on mm_init trampoline attachment
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 6:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> There are 2 mm_init functions in kernel.
>
> One in kernel/fork.c:
>   static struct mm_struct *mm_init(struct mm_struct *mm,
>                                    struct task_struct *p,
>                                    struct user_namespace *user_ns)
>
> And another one in init/main.c:
>   static void __init mm_init(void)
>
> The BTF data will get the first one, which is most likely
> (in my case) mm_init from init/main.c without arguments.
>
> Then in runtime when we want to attach to 'mm_init' the
> kalsyms contains address of the one from kernel/fork.c.
>
> So we have function model with no arguments and using it
> to attach function with 3 arguments.. as result the trampoline
> will not save function's arguments and we get crash because
> trampoline changes argument registers:
>
>   BUG: unable to handle page fault for address: 0000607d87a1d558
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 0 P4D 0
>   Oops: 0002 [#1] SMP PTI
>   CPU: 6 PID: 936 Comm: systemd Not tainted 5.12.0-rc4qemu+ #191
>   RIP: 0010:mm_init+0x223/0x2a0
>   ...
>   Call Trace:
>    ? bpf_trampoline_6442453476_0+0x3b/0x1000
>    dup_mm+0x66/0x5f0
>    ? __lock_task_sighand+0x3a/0x70
>    copy_process+0x17d0/0x1b50
>    kernel_clone+0x97/0x3c0
>    __do_sys_clone+0x60/0x80
>    do_syscall_64+0x33/0x40
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   RIP: 0033:0x7f1dc9b3201f
>
> I think there might be more cases like this, but I don't have
> an idea yet how to solve this in generic way. The rename in
> this change fix it for this instance.

Just retroactively renaming functions and waiting for someone else to
report similar issues is probably not the best strategy. Should
resolve_btfids detect all name duplicates and emit warnings for them?
It would be good to also remove such name-conflicting FUNCs from BTF
(though currently it's not easy). And fail if such a function is
referenced from .BTF_ids section.

Thoughts?

>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  init/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 53b278845b88..bc1bfe57daf7 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -818,7 +818,7 @@ static void __init report_meminit(void)
>  /*
>   * Set up kernel memory allocators
>   */
> -static void __init mm_init(void)
> +static void __init init_mem(void)
>  {
>         /*
>          * page_ext requires contiguous pages,
> @@ -905,7 +905,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
>         vfs_caches_init_early();
>         sort_main_extable();
>         trap_init();
> -       mm_init();
> +       init_mem();

nit: given trap_init and ftrace_init, mem_init probably would be a better name?

>
>         ftrace_init();
>
> --
> 2.30.2
>
