Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9AE33AC40
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCOH2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhCOH20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 03:28:26 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61C0C061762
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 00:28:25 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id by2so7310036qvb.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 00:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uKhPP1SmtCDUM1Z5eH/8Bg4ljp6/SQAjUlLSSrlkCSs=;
        b=WTyhMHRladFkScqo4bafqy9e1JpwXtO3epDX9syPtpjqsC3Pz1WeZ1o8ehmTFwH0uJ
         X0w6zzefNEvbaYekZpBjd6ub/H3+FsRT70ZkRrZ7fXmRSJz80vOj68AwcL1q5GV2iYTc
         yIn3Bn/Pc8tV6tM1h/Yx6ZDeJuWWkpdJ2WJNCaJ2V3YTRUcTxrBai4rrvKYs2aPNPfsm
         aqFhWQbrBAUDHM2vwVUjZTERxNK3sr5T410PcsM++4HnY3R9piMTyTX0juKzpAQYpbr7
         3v8MQ6z1JmuFBYNchONF++EkuzlhFciVj8iQRyq1dMp7bWPF2qnYEqksFsW1OQzyjsDI
         0t3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uKhPP1SmtCDUM1Z5eH/8Bg4ljp6/SQAjUlLSSrlkCSs=;
        b=l5B/euyPlEHI85Te3NOLRLw17DIv91BNMDlhqKEVy9FVrozHqrfk2mvh5SnMX4xBxs
         Bks7Wj1uaOQpx/Gf6z/4fG6sq0XC+nsYL1PgvxMY8G91WWHwwftluKdI4LfCVcQcyJeY
         NydNXgOjsFzy5urxmhyIVMWIaIdcsJvSWTrEbiuatEZOhaVZpErsYYyl7ujk66LjV79O
         hx9kOmbqQCYgnCF84QOQE+2KwLI8bCamL+UBc+NX9J0p2VZvNaXKEXntm7NPU50hiIzL
         Py97dcPR78eiBSDm+2DE37YjufimCG3wo1I76863BqodNUUzqLHnmhOrjTXvO0tW+qIG
         f8SA==
X-Gm-Message-State: AOAM530OuFeKAyZQv9p64z0eIGvZ0Kg4AfnG22R+tVS0frIrDzKKnfcj
        4gieusp1I8ctLxbUkuhChOzQXYe+ezzR+kMAJeS2oQ==
X-Google-Smtp-Source: ABdhPJwhDXNF9x08r7Nf21MNjgZkZ0IXXfyCYE6NTm1Hq4D7TB7RoRon/z5sX4rPuX5Aj/oleYY1EcPvrezPSD6GmEM=
X-Received: by 2002:ad4:410d:: with SMTP id i13mr9238750qvp.44.1615793304479;
 Mon, 15 Mar 2021 00:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c7910505bd889abc@google.com>
In-Reply-To: <000000000000c7910505bd889abc@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 15 Mar 2021 08:28:13 +0100
Message-ID: <CACT4Y+Z+ph1d4gVhhDSYuRH67g7t211503JyeMbd+13bCKs7rw@mail.gmail.com>
Subject: Re: [syzbot] memory leak in copy_process (2)
To:     syzbot <syzbot+44908bb56d2bfe56b28e@syzkaller.appspotmail.com>
Cc:     Christian Brauner <christian@brauner.io>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 1:48 AM syzbot
<syzbot+44908bb56d2bfe56b28e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    88fe4924 Merge tag 'char-misc-5.12-rc3' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10252462d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=815a716b5d0a8bdf
> dashboard link: https://syzkaller.appspot.com/bug?extid=44908bb56d2bfe56b28e
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14180dc6d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167cf68ad00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+44908bb56d2bfe56b28e@syzkaller.appspotmail.com

+bpf maintainers
Looking at the reproducer I think it's an issue in bpf_preload.


> Warning: Permanently added '10.128.0.41' (ECDSA) to the list of known hosts.
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff888101b41d00 (size 120):
>   comm "kworker/u4:0", pid 8, jiffies 4294944270 (age 12.780s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8125dc56>] alloc_pid+0x66/0x560 kernel/pid.c:180
>     [<ffffffff81226405>] copy_process+0x1465/0x25e0 kernel/fork.c:2115
>     [<ffffffff81227943>] kernel_clone+0xf3/0x670 kernel/fork.c:2493
>     [<ffffffff812281a1>] kernel_thread+0x61/0x80 kernel/fork.c:2545
>     [<ffffffff81253464>] call_usermodehelper_exec_work kernel/umh.c:172 [inline]
>     [<ffffffff81253464>] call_usermodehelper_exec_work+0xc4/0x120 kernel/umh.c:158
>     [<ffffffff812591c9>] process_one_work+0x2c9/0x600 kernel/workqueue.c:2275
>     [<ffffffff81259ab9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2421
>     [<ffffffff812611c8>] kthread+0x178/0x1b0 kernel/kthread.c:292
>     [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> BUG: memory leak
> unreferenced object 0xffff888110ef5c00 (size 232):
>   comm "kworker/u4:0", pid 8414, jiffies 4294944270 (age 12.780s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     e0 b7 04 01 81 88 ff ff c0 56 ba 0f 81 88 ff ff  .........V......
>   backtrace:
>     [<ffffffff8154a0cf>] kmem_cache_zalloc include/linux/slab.h:674 [inline]
>     [<ffffffff8154a0cf>] __alloc_file+0x1f/0xf0 fs/file_table.c:101
>     [<ffffffff8154a809>] alloc_empty_file+0x69/0x120 fs/file_table.c:150
>     [<ffffffff8154a8f3>] alloc_file+0x33/0x1b0 fs/file_table.c:192
>     [<ffffffff8154ab22>] alloc_file_pseudo+0xb2/0x140 fs/file_table.c:232
>     [<ffffffff81559218>] create_pipe_files+0x138/0x2e0 fs/pipe.c:911
>     [<ffffffff8126c793>] umd_setup+0x33/0x220 kernel/usermode_driver.c:104
>     [<ffffffff81253574>] call_usermodehelper_exec_async+0xb4/0x1b0 kernel/umh.c:101
>     [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> BUG: memory leak
> unreferenced object 0xffff888110cafc90 (size 24):
>   comm "kworker/u4:0", pid 8414, jiffies 4294944270 (age 12.780s)
>   hex dump (first 24 bytes):
>     00 00 00 00 00 00 00 00 b0 0e 94 00 81 88 ff ff  ................
>     00 00 00 00 00 00 00 00                          ........
>   backtrace:
>     [<ffffffff820e15ca>] kmem_cache_zalloc include/linux/slab.h:674 [inline]
>     [<ffffffff820e15ca>] lsm_file_alloc security/security.c:569 [inline]
>     [<ffffffff820e15ca>] security_file_alloc+0x2a/0xb0 security/security.c:1470
>     [<ffffffff8154a10d>] __alloc_file+0x5d/0xf0 fs/file_table.c:106
>     [<ffffffff8154a809>] alloc_empty_file+0x69/0x120 fs/file_table.c:150
>     [<ffffffff8154a8f3>] alloc_file+0x33/0x1b0 fs/file_table.c:192
>     [<ffffffff8154ab22>] alloc_file_pseudo+0xb2/0x140 fs/file_table.c:232
>     [<ffffffff81559218>] create_pipe_files+0x138/0x2e0 fs/pipe.c:911
>     [<ffffffff8126c793>] umd_setup+0x33/0x220 kernel/usermode_driver.c:104
>     [<ffffffff81253574>] call_usermodehelper_exec_async+0xb4/0x1b0 kernel/umh.c:101
>     [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> BUG: memory leak
> unreferenced object 0xffff888110ef5e00 (size 232):
>   comm "kworker/u4:0", pid 8414, jiffies 4294944270 (age 12.780s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     e0 b7 04 01 81 88 ff ff 00 59 ba 0f 81 88 ff ff  .........Y......
>   backtrace:
>     [<ffffffff8154a0cf>] kmem_cache_zalloc include/linux/slab.h:674 [inline]
>     [<ffffffff8154a0cf>] __alloc_file+0x1f/0xf0 fs/file_table.c:101
>     [<ffffffff8154a809>] alloc_empty_file+0x69/0x120 fs/file_table.c:150
>     [<ffffffff8154a8f3>] alloc_file+0x33/0x1b0 fs/file_table.c:192
>     [<ffffffff8154ac22>] alloc_file_clone+0x22/0x70 fs/file_table.c:244
>     [<ffffffff81559262>] create_pipe_files+0x182/0x2e0 fs/pipe.c:922
>     [<ffffffff8126c80d>] umd_setup+0xad/0x220 kernel/usermode_driver.c:115
>     [<ffffffff81253574>] call_usermodehelper_exec_async+0xb4/0x1b0 kernel/umh.c:101
>     [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> BUG: memory leak
> unreferenced object 0xffff888110cafc18 (size 24):
>   comm "kworker/u4:0", pid 8414, jiffies 4294944270 (age 12.780s)
>   hex dump (first 24 bytes):
>     00 00 00 00 00 00 00 00 b0 0e 94 00 81 88 ff ff  ................
>     00 00 00 00 00 00 00 00                          ........
>   backtrace:
>     [<ffffffff820e15ca>] kmem_cache_zalloc include/linux/slab.h:674 [inline]
>     [<ffffffff820e15ca>] lsm_file_alloc security/security.c:569 [inline]
>     [<ffffffff820e15ca>] security_file_alloc+0x2a/0xb0 security/security.c:1470
>     [<ffffffff8154a10d>] __alloc_file+0x5d/0xf0 fs/file_table.c:106
>     [<ffffffff8154a809>] alloc_empty_file+0x69/0x120 fs/file_table.c:150
>     [<ffffffff8154a8f3>] alloc_file+0x33/0x1b0 fs/file_table.c:192
>     [<ffffffff8154ac22>] alloc_file_clone+0x22/0x70 fs/file_table.c:244
>     [<ffffffff81559262>] create_pipe_files+0x182/0x2e0 fs/pipe.c:922
>     [<ffffffff8126c80d>] umd_setup+0xad/0x220 kernel/usermode_driver.c:115
>     [<ffffffff81253574>] call_usermodehelper_exec_async+0xb4/0x1b0 kernel/umh.c:101
>     [<ffffffff8100227f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000c7910505bd889abc%40google.com.
