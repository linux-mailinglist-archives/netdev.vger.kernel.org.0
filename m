Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB734641CE
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 23:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344739AbhK3W4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 17:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbhK3W4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 17:56:48 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57053C061574;
        Tue, 30 Nov 2021 14:53:28 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 131so57399969ybc.7;
        Tue, 30 Nov 2021 14:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IWmAAXa9pjC4EoqzChkZJaBqSIgJLKarMG+xKoHvRDs=;
        b=VmwSq84INeu/Qn3AsnjWJ0DU7BawUMaHEwht0V2qDRsbDAKFVMFTWtLa0+FbSAZcd2
         W5csmdUvHO3LDaG4XQiuLRKzEPQ+AEgvEv5GCeh0V6i6YY0tB8yxAY5RvyOgYHIxr6wN
         wdpGvxtWnaWOWshLRHa5vNrSHBcHchSIRbYNDt8Xt9c/Vivwh3+dG+QJ4bfzpoRXMb27
         ixkRqrTaTaos4/NyZ7VMAprmNyQwHiWR/HlCj0Nf08P+mbopAZxUmXVVYYu3Ujo99OUI
         6yHUi+UBd+BZh4UqrYdBieJhc0vWPX/aXEN2bRLgnL4LQqIuQqbGVJZumNkX58i25c8C
         lssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IWmAAXa9pjC4EoqzChkZJaBqSIgJLKarMG+xKoHvRDs=;
        b=gevsea9fSM17IIG/YGJnNpCHBWoDnR3A1RhnbdLmMeXg0g6Dhmyvc+kRfMbC3KK0aD
         GZ4LQjGOuvMr/B1yz1f0KU+T2PbERNwzN6BI8duc2Towa+OIBm9q/ZaRPgHFDqAEDSOD
         C3fD47JhlHO/1XOEwrJTI9DM3fPmjH9GjCVWRBZYIYUz7fAOJ+is2lw8qVX4YEq9bjJE
         Y9WOBl9amNiNCM/TnhrdFYZ9nChjdxJ9NyYESFjJnvmPUBhjjIISzxD7X+DQlxLJWTXs
         eJsZ0N5J7s9Q5l4kiIpFlYKtVYM+YhSU5PT8NNyeowfAIYSFSWOUA5PlX/LXLXdh8/Dh
         UibQ==
X-Gm-Message-State: AOAM532yh3USp2IBr6AifnRHjY6ux9eUyZ9dgGgFpn7jFqgKVjOm4Wow
        jC0bD6yl84SN7GHldUuG2xuXrzwOjUG4mYZRzTY=
X-Google-Smtp-Source: ABdhPJzUU4qXaHZ7S/0ey52ccLEJxZXY/ZqwQOyktHVC6pgjLhE3jqkNaxjz8nDisWn7VsfLQ8vZEeZYXJhieuHwWBc=
X-Received: by 2002:a25:54e:: with SMTP id 75mr2440929ybf.393.1638312807553;
 Tue, 30 Nov 2021 14:53:27 -0800 (PST)
MIME-Version: 1.0
References: <1638027102-22686-1-git-send-email-cuibixuan@linux.alibaba.com>
In-Reply-To: <1638027102-22686-1-git-send-email-cuibixuan@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Nov 2021 14:53:16 -0800
Message-ID: <CAEf4BzbV=s+C=dFS5YfAdJhiBv+3ocanaZ-NNHoPz8RzHhGCbQ@mail.gmail.com>
Subject: Re: [PATCH -next] bpf: Add oversize check before call kvmalloc()
To:     Bixuan Cui <cuibixuan@linux.alibaba.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 27, 2021 at 7:32 AM Bixuan Cui <cuibixuan@linux.alibaba.com> wrote:
>
> Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") add
> the oversize check. When the allocation is larger than what kvmalloc()
> supports, the following warning triggered:
>
> WARNING: CPU: 1 PID: 372 at mm/util.c:597 kvmalloc_node+0x111/0x120
> mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 372 Comm: syz-executor.4 Not tainted 5.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 7d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 60
> 20 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 4f 20 d1 ff <0f> 0b e9
> 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 36
> RSP: 0018:ffffc90002bf7c98 EFLAGS: 00010216
> RAX: 00000000000000ec RBX: 1ffff9200057ef9f RCX: ffffc9000ac63000
> RDX: 0000000000040000 RSI: ffffffff81a6a621 RDI: 0000000000000003
> RBP: 0000000000102cc0 R08: 000000007fffffff R09: 00000000ffffffff
> R10: ffffffff81a6a5de R11: 0000000000000000 R12: 00000000ffff9aaa
> R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
> FS:  00007f05f2573700(0000) GS:ffff8880b9d00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f424000 CR3: 0000000027d2c000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  kvmalloc include/linux/slab.h:741 [inline]
>  map_lookup_elem kernel/bpf/syscall.c:1090 [inline]
>  __sys_bpf+0x3a5b/0x5f00 kernel/bpf/syscall.c:4603
>  __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The type of 'value_size' is u32, its value may exceed INT_MAX.
>
> Reported-by: syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com
> Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
> ---
>  kernel/bpf/syscall.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1033ee8..f5bc380 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1094,6 +1094,10 @@ static int map_lookup_elem(union bpf_attr *attr)
>         }
>
>         value_size = bpf_map_value_size(map);
> +       if (value_size > INT_MAX) {
> +               err = -EINVAL;

-E2BIG makes a bit more sense in this scenario?

> +               goto err_put;
> +       }
>
>         err = -ENOMEM;
>         value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
> --
> 1.8.3.1
>
