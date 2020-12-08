Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2852D2450
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLHH0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgLHH0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:26:22 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7FEC061794
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 23:25:42 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id b9so11376784qtr.2
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 23:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a48Lc0r9Pex+nfdSjXokaIFSEHhKwRZpwM5apuHQUXw=;
        b=ZVhbIhkK26XpUkqdyi6SZYbjrNClTqoRwngPEaPyNDsVq5bgkBC2R9ohv7mXlvFeOS
         fKGR8Gk03lYtRwX8mJuITy2ZztQiHAGIeJIKgIKt158473V0dFzphvn/VBtepEz5b3yC
         eU/hwOBonpXFdqZJ6/Ke8+tWHDFr+9kok8Q7pImQvsoc6eWG/aF78Zdbvzpu/1AA4lm7
         Vc+RfofKwGboJt9vbP8iZhaoWqQNOTDH7XdWek6uL/DE3sYkhjmKCFYzmbQYe4czzzLM
         Dqx9CK/Cv1LIAOJ97bDuwEYSSH5U+ScczEVVg+3roXWu3QOtT9J/cCxlCBrliBqv/+TF
         ziAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a48Lc0r9Pex+nfdSjXokaIFSEHhKwRZpwM5apuHQUXw=;
        b=PSTjlryAOqRu/B3UnFSLOI8kS7Ev1saqMJ9ZloEDEvEcpHyAmyRrvk4fBm6KCchL8n
         8peHo263FXe2LsV6mmMKJPaPWupC08NxoP7B3p1uuVLd9FK0Nj9iUOOp/0luP21SG+2y
         kaW19iR3yyzXYOX221THSkfaxpPJlAI7OyXcL/vqPWmbHczIHdwTBpczTkt7enVDdpAv
         t0QB6X//Ij/CX7OS/tVZt/wEpnHSGY7xhfXPxCwW01fGt3pHa9m9Cc51v5IYz7qdOQVq
         5/opGyluipiIKLUa0tVKeWCXU6SEamG38cQOP/FOqGfr11ScC+e0xr2dO7czPk6tOkDQ
         W50g==
X-Gm-Message-State: AOAM530tl15hoZmGyNRR3vsD15KnohZ8VrMaSBKafWbrxbVRb/NA23Cx
        VFImxgSNLUfSBJhpdaI3iG3KjpCbFvriHOAMfrbzCQ==
X-Google-Smtp-Source: ABdhPJyJdpFX+jh8hbZjH/CvWHSVOuvzztK0ZIPUiUSrhvJryT5dOBuqbwRTaLFdbeSLhIMD+pqsbecHyYQjdfGImdM=
X-Received: by 2002:ac8:4e1c:: with SMTP id c28mr28117287qtw.67.1607412341539;
 Mon, 07 Dec 2020 23:25:41 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a4832105b5de5453@google.com>
In-Reply-To: <000000000000a4832105b5de5453@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 8 Dec 2020 08:25:30 +0100
Message-ID: <CACT4Y+aEfWE2xUKZ4CDcBQuUN1TO=GVLu5CuPi0WAZ2A1jjE0w@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_lru_populate
To:     syzbot <syzbot+ec2234240c96fdd26b93@syzkaller.appspotmail.com>,
        guro@fb.com, Eric Dumazet <edumazet@google.com>
Cc:     andrii@kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 12:43 PM syzbot
<syzbot+ec2234240c96fdd26b93@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    bcd684aa net/nfc/nci: Support NCI 2.x initial sequence
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12001bd3500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3cb098ab0334059f
> dashboard link: https://syzkaller.appspot.com/bug?extid=ec2234240c96fdd26b93
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7f2ef500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=103833f7500000
>
> The issue was bisected to:
>
> commit b93ef089d35c3386dd197e85afb6399bbd54cfb3
> Author: Martin KaFai Lau <kafai@fb.com>
> Date:   Mon Nov 16 20:01:13 2020 +0000
>
>     bpf: Fix the irq and nmi check in bpf_sk_storage for tracing usage
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1103b837500000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1303b837500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1503b837500000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ec2234240c96fdd26b93@syzkaller.appspotmail.com
> Fixes: b93ef089d35c ("bpf: Fix the irq and nmi check in bpf_sk_storage for tracing usage")

I assume this is also

#syz fix: bpf: Avoid overflows involving hash elem_size


> BUG: unable to handle page fault for address: fffff5200471266c
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 23fff2067 P4D 23fff2067 PUD 101a4067 PMD 32e3a067 PTE 0
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8503 Comm: syz-executor608 Not tainted 5.10.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:bpf_common_lru_populate kernel/bpf/bpf_lru_list.c:569 [inline]
> RIP: 0010:bpf_lru_populate+0xd8/0x5e0 kernel/bpf/bpf_lru_list.c:614
> Code: 03 4d 01 e7 48 01 d8 48 89 4c 24 10 4d 89 fe 48 89 44 24 08 e8 99 23 eb ff 49 8d 7e 12 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 18 38 d0 7f 08 84 c0 0f 85 80 04 00 00 49 8d 7e 13 41 c6
> RSP: 0018:ffffc9000126fc20 EFLAGS: 00010202
> RAX: 1ffff9200471266c RBX: dffffc0000000000 RCX: ffffffff8184e3e2
> RDX: 0000000000000002 RSI: ffffffff8184e2e7 RDI: ffffc90023893362
> RBP: 00000000000000bc R08: 000000000000107c R09: 0000000000000000
> R10: 000000000000107c R11: 0000000000000000 R12: 0000000000000001
> R13: 000000000000107c R14: ffffc90023893350 R15: ffffc900234832f0
> FS:  0000000000fe0880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffff5200471266c CR3: 000000001ba62000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  prealloc_init kernel/bpf/hashtab.c:319 [inline]
>  htab_map_alloc+0xf6e/0x1230 kernel/bpf/hashtab.c:507
>  find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
>  map_create kernel/bpf/syscall.c:829 [inline]
>  __do_sys_bpf+0xa81/0x5170 kernel/bpf/syscall.c:4374
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x4402e9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffe77af23b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402e9
> RDX: 0000000000000040 RSI: 0000000020000000 RDI: 0d00000000000000
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401af0
> R13: 0000000000401b80 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> CR2: fffff5200471266c
> ---[ end trace 4f3928bacde7b3ed ]---
> RIP: 0010:bpf_common_lru_populate kernel/bpf/bpf_lru_list.c:569 [inline]
> RIP: 0010:bpf_lru_populate+0xd8/0x5e0 kernel/bpf/bpf_lru_list.c:614
> Code: 03 4d 01 e7 48 01 d8 48 89 4c 24 10 4d 89 fe 48 89 44 24 08 e8 99 23 eb ff 49 8d 7e 12 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <0f> b6 04 18 38 d0 7f 08 84 c0 0f 85 80 04 00 00 49 8d 7e 13 41 c6
> RSP: 0018:ffffc9000126fc20 EFLAGS: 00010202
> RAX: 1ffff9200471266c RBX: dffffc0000000000 RCX: ffffffff8184e3e2
> RDX: 0000000000000002 RSI: ffffffff8184e2e7 RDI: ffffc90023893362
> RBP: 00000000000000bc R08: 000000000000107c R09: 0000000000000000
> R10: 000000000000107c R11: 0000000000000000 R12: 0000000000000001
> R13: 000000000000107c R14: ffffc90023893350 R15: ffffc900234832f0
> FS:  0000000000fe0880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffff5200471266c CR3: 000000001ba62000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000a4832105b5de5453%40google.com.
