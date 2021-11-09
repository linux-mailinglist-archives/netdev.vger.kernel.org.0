Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606DB44B915
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243181AbhKIW6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbhKIW6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 17:58:41 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F71C08B2CC
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 14:39:06 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so3131939wme.0
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 14:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jA/4RJpaH4m2WSVrDPCYphtg9Wi1iLRKOjZENRMh2+g=;
        b=Jc1efR6lUrCdnc9z67tz8bnlA3JCrGXirTuP/E/O5xxATDVuQpbBRJMR1MMWOjeq+2
         UWA15FdHV/QhwZ6RkhGtDa+dwDkNwECVrq8YTP0ts7yWXunWPTYPCbxzLxnaxseXlO1+
         DPQbPiGKRdX13rWsGeSp1/lPSUA7VZr1WfEnTVMYJuZnKdD2zBj3Dqws7Rg1p0dqQkNf
         mvO+ESzWr2nneeASz+8dLyPniophkAosMRHlwvEqYCJNM/p6YoCyjv2vl7ITcubUZtRq
         VfDKXiEaf9+4nqN0pWsK2RljrL2eBoYNR/cZIKaY0CrkYkiaCPWDUf8Et3sC9bs5TjVP
         Sl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jA/4RJpaH4m2WSVrDPCYphtg9Wi1iLRKOjZENRMh2+g=;
        b=zqSRwYXe8QrYF1lBS+qDUfpQnJm02KHkzNtDr8LthC9Ur/e8zU6pDqpPyuNgEcdewP
         2SMmCkD1FyHtqO5NPZyfod5nHAi0coMV1lkWjk5uRtwrrUKt7ddwVgi4gXykTrByyBWD
         rF/zrgaMezARZFfFW8ZZwDFlmpPQThaeRUcWjAa7Ml+tZP4zO+/PPsZ2rWI1lrlcYnU7
         KUCim5S0DDgIUY/0ZlOhFKVLvkCW+RsyEMttsBVt7oNCpzMVfw2cYVaqA/oHi9PeAvSB
         tqsUu7I4qWpGBPJLHT20YDzRYE2hhakmpbPN3lMnvxwwIauR1qewleogNZR96/HdIX+D
         sKZQ==
X-Gm-Message-State: AOAM530zcP7N2m6MzW7BUWBKVHj3QXCwLtJ8nzaoBeByCiwyVJHWhJTA
        IwbZROOROzdwPtXKPicY5tqpvlCDbF49FCUNQgmZqw==
X-Google-Smtp-Source: ABdhPJy6ZvIAGhjwHNa2K82Ak3hX8mWmKPXYq4otAJnR6W/6/gieOfWqHtpZ+mlXQ/9+c3axSeDYsEl6keeA3ABhPgM=
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr11535482wms.88.1636497544809;
 Tue, 09 Nov 2021 14:39:04 -0800 (PST)
MIME-Version: 1.0
References: <20211109222447.3251621-1-songliubraving@fb.com>
In-Reply-To: <20211109222447.3251621-1-songliubraving@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 9 Nov 2021 14:38:52 -0800
Message-ID: <CANn89iLULCxZ+p-zkZVTLObLvJ+z34nEqS-e3nmA8MK0cKzi=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix btf_task_struct_ids w/o CONFIG_DEBUG_INFO_BTF
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, Kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 9, 2021 at 2:25 PM Song Liu <songliubraving@fb.com> wrote:
>
> This fixes KASAN oops like
>
> BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> Read of size 4 at addr ffffffff90297404 by task swapper/0/1
>
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
> Hardware name: ... Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
> __kasan_report mm/kasan/report.c:442 [inline]
> kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
> task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> do_one_initcall+0x103/0x650 init/main.c:1295
> do_initcall_level init/main.c:1368 [inline]
> do_initcalls init/main.c:1384 [inline]
> do_basic_setup init/main.c:1403 [inline]
> kernel_init_freeable+0x6b1/0x73a init/main.c:1606
> kernel_init+0x1a/0x1d0 init/main.c:1497
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> </TASK>
>

Please add a Fixes: tag

Also you can add

Reported-by: syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com


> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/bpf/btf.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index cdb0fba656006..6db929a5826d4 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6342,10 +6342,14 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
>         .arg4_type      = ARG_ANYTHING,
>  };
>
> +#ifdef CONFIG_DEBUG_INFO_BTF
>  BTF_ID_LIST_GLOBAL(btf_task_struct_ids)
>  BTF_ID(struct, task_struct)
>  BTF_ID(struct, file)
>  BTF_ID(struct, vm_area_struct)
> +#else
> +u32 btf_task_struct_ids[3];
> +#endif

What about adding to  BTF_ID_LIST_GLOBAL() another argument ?

BTF_ID_LIST_GLOBAL(btf_task_struct_ids, 3)

This would avoid this #ifdef

I understand commit 079ef53673f2e3b3ee1728800311f20f28eed4f7
hardcoded a [5] value, maybe we can do slightly better with exact
boundary checks for KASAN.

>
>  /* BTF ID set registration API for modules */
>
> --
> 2.30.2
>
