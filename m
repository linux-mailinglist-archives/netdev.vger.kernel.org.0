Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ECC31498D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhBIHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIHfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 02:35:54 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1592CC061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 23:35:14 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id x3so10415004qti.5
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 23:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VxU9PMMlm0cJYv5FlM8nWSRQFbnHMT6a6kZn8VAvqmU=;
        b=RkwthBqL6RxhZjL+2Bz/oYdwFXTyhqhSHIWJz4QpwjiU2TFpBBzoXY1lC0cjAilqJh
         03Br+jkZCjPMv9aCI42k+zsZs3rfaBovcCaD+bMHKKSTH9xB08bgnnaPjfDLWpemL5ZC
         1Zjjxzy/BlgXpOrTIV435Dfc0xk278J67zlI9Nirgv15IiGy+LaxLbGzmIwyT73NdhXq
         IboIGmQBK6sRmnMBCNC+U6cQfdGdEZ1LGRT6TwTRO0dRSTi7DPxAv6jARaYnuaActd7N
         8iz7xh2r1fEPfix6BEp2XKId+foVpGOpcCsrCeD6txRpGst3CWSVcxS5roiNwhoypSHP
         C+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VxU9PMMlm0cJYv5FlM8nWSRQFbnHMT6a6kZn8VAvqmU=;
        b=foyDo593ebYYBiMSHJCiyQ86pJJ/jFx3yvdGE1ncUxQM2B1cME1fDQyvZJzQ1ES6u3
         xdHOrXrxhSZBlnilxx3/OdI290AkRBPTIdeqtuJ+mpRgLobeJfIK/VfQKekoV2yPa6a+
         QBSHDseiJZZli05Sbm8QjjcLqoWnIU3iysC9j/bnuy2m0c2wh1yFBP53cjs//rLotJi9
         BBAqszty7zHgYDW3QBKjQOHm5pS5tJhZfvfcT34EwAXbvffyJ/8ahMN1lNaLoCb3r9Rz
         uz1RpWvoBGnwkDEuTzeOQ0NCI4JobHJ5XuLj39rz6/bGFzPw7TMFc3mmkAzbFqg+0vUP
         XeCA==
X-Gm-Message-State: AOAM533/mC8zZzEMEu2w2Jo3eifJ75WrAfF/m4nKYF9GVYZFDaK6nnBJ
        /6RRQZzCM/wG5x4G8SteaQ2n+C6szK/0FjkG8GnsLQ==
X-Google-Smtp-Source: ABdhPJzPP9PemfEVryVImDWBPwq7LJJVug/bP7dt4dL1hN5gSqCMzeT4yrB5gi0a36nTdEEmIABs7JmIhDSfBJFd0go=
X-Received: by 2002:a05:622a:c9:: with SMTP id p9mr18543023qtw.337.1612856112858;
 Mon, 08 Feb 2021 23:35:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000364d5505babe13f5@google.com>
In-Reply-To: <000000000000364d5505babe13f5@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 9 Feb 2021 08:35:00 +0100
Message-ID: <CACT4Y+aDGsVkzTkQ551XUpT0Z1vuiGTubvtKne+VYjK3zX67kQ@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in bpf_iter_prog_supported
To:     syzbot <syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     Alexander Potapenko <glider@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 7, 2021 at 1:20 PM syzbot
<syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ac5f64d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=df698232b2ac45c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=580f4f2a272e452d55cb
> compiler:       Debian clang version 11.0.1-2
> userspace arch: i386
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+580f4f2a272e452d55cb@syzkaller.appspotmail.com

+BPF maintainers

> =====================================================
> BUG: KMSAN: uninit-value in bpf_iter_prog_supported+0x3dd/0x6a0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/bpf_iter.c:329
> CPU: 0 PID: 18494 Comm: bpf_preload Not tainted 5.10.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack syzkaller/managers/upstream-kmsan-gce-386/kernel/lib/dump_stack.c:77 [inline]
>  dump_stack+0x21c/0x280 syzkaller/managers/upstream-kmsan-gce-386/kernel/lib/dump_stack.c:118
>  kmsan_report+0xfb/0x1e0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x5f/0xa0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan_instr.c:197
>  bpf_iter_prog_supported+0x3dd/0x6a0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/bpf_iter.c:329
>  check_attach_btf_id syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/verifier.c:11772 [inline]
>  bpf_check+0x11872/0x1c380 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/verifier.c:11900
>  bpf_prog_load syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:2210 [inline]
>  __do_sys_bpf+0x17483/0x1aee0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:4399
>  __se_sys_bpf+0x8e/0xa0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:4357
>  __x64_sys_bpf+0x4a/0x70 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/syscall.c:4357
>  do_syscall_64+0x9f/0x140 syzkaller/managers/upstream-kmsan-gce-386/kernel/arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fb70b5ab469
> Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffdbb4cde38 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 000000000065b110 RCX: 00007fb70b5ab469
> RDX: 0000000000000078 RSI: 00007ffdbb4cdef0 RDI: 0000000000000005
> RBP: 00007ffdbb4cdef0 R08: 0000001000000017 R09: 0000000000000000
> R10: 00007ffdbb4ce0e8 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffdbb4cdf20 R14: 0000000000000000 R15: 0000000000000000
>
> Uninit was created at:
>  kmsan_save_stack_with_flags syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan.c:121 [inline]
>  kmsan_internal_poison_shadow+0x5c/0xf0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan.c:104
>  kmsan_slab_alloc+0x8d/0xe0 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/kmsan/kmsan_hooks.c:76
>  slab_alloc_node syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/slub.c:2906 [inline]
>  slab_alloc syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/slub.c:2915 [inline]
>  kmem_cache_alloc_trace+0x893/0x1000 syzkaller/managers/upstream-kmsan-gce-386/kernel/mm/slub.c:2932
>  kmalloc syzkaller/managers/upstream-kmsan-gce-386/kernel/./include/linux/slab.h:552 [inline]
>  bpf_iter_reg_target+0x81/0x3f0 syzkaller/managers/upstream-kmsan-gce-386/kernel/kernel/bpf/bpf_iter.c:276
>  bpf_sk_storage_map_iter_init+0x6a/0x85 syzkaller/managers/upstream-kmsan-gce-386/kernel/net/core/bpf_sk_storage.c:870
>  do_one_initcall+0x362/0x8d0 syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1220
>  do_initcall_level+0x1e7/0x35a syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1293
>  do_initcalls+0x127/0x1cb syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1309
>  do_basic_setup+0x33/0x36 syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1329
>  kernel_init_freeable+0x238/0x38b syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1529
>  kernel_init+0x1f/0x840 syzkaller/managers/upstream-kmsan-gce-386/kernel/init/main.c:1418
>  ret_from_fork+0x1f/0x30 syzkaller/managers/upstream-kmsan-gce-386/kernel/arch/x86/entry/entry_64.S:296
> =====================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000364d5505babe13f5%40google.com.
