Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9365B16BBA6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgBYIPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:15:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46652 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbgBYIPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 03:15:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id k29so6747797pfp.13;
        Tue, 25 Feb 2020 00:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JNNd2bdxbtTuAveeMNYu2rne/nDWJzxUKnXBeyH3YUI=;
        b=IgvcARmY39OQ8qgdL2/BnxXsIWu/1I81wsnUwtExrpdKdWwBD2KpgqPIEvsg/kNibq
         iMm/Jc5LDpIVGfot/Z/Xi1nhQiUZsIGe1Kmp4YB/Io2KyQmP8CrI3alAbTmFC31Z92lu
         TYr8M9lfkCMBg+ULfx0WNE/QxUJKOvWtxQf0rzLmHE227OHE7tHUKSJv8FtfXR8mwUCQ
         4auTchBgx9K1rho0m4YhRxnJvZweCPlbgB1X9GEqjYqTGreybuVOXbvgOi+7YfJ6OHJ9
         XnP3JTxYKt5RlSNAM7HjYxfnrDAwygIR6cnSpZkUAQ8VdmVTsCy1FggJ3sbYbGJt3xnd
         YDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JNNd2bdxbtTuAveeMNYu2rne/nDWJzxUKnXBeyH3YUI=;
        b=tGHZeIeRRzAnYCAymK17JWrxbmNWOu387LUsjCLU70nfA8V4jY320z7jRzu6SyF2bO
         vzjTdZ6IFOTzqTFvPuWzbvSlcQF4wm6/3QjKIwFY7ZS14rCCxuik8GK7R2h5kxVQsx14
         HaVGCwC3ilDr5bx3WrvhMD3BIp/N7sa6p8IY7nEUxSWxJC4c1HDQnhR2j1WMj/CQOBja
         JKcevsLVz8A/qGChJowoxvA+23FWwPeCeEKQkZY+argF/VxreUqWHSE4hqP4Qc0r7lkS
         i3+o2ORZoZU1i8QHUJVMFwocVuS11liWGWYq2UXYBFEIQmqe/TvAi/gBD/UKNrS53gX6
         s2YA==
X-Gm-Message-State: APjAAAUomtG581g0KQgQGRPIEnST2DAgbIEJMZMkq/ENMkmipjE8LyN3
        tds/qkal7S0IV/6rEpNToqY=
X-Google-Smtp-Source: APXvYqxrneHTBL7LNljIpISBO5CZEvUgfX38OpFBVOhrT2iGF4iMbOMZQY6oaGRFxHdkA//BGcq9yg==
X-Received: by 2002:a63:e04a:: with SMTP id n10mr55747399pgj.341.1582618531022;
        Tue, 25 Feb 2020 00:15:31 -0800 (PST)
Received: from [192.168.0.5] (cpe-72-130-144-74.hawaii.res.rr.com. [72.130.144.74])
        by smtp.gmail.com with ESMTPSA id h26sm16386363pfr.9.2020.02.25.00.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 00:15:30 -0800 (PST)
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 inet_release
To:     syzbot <syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000050bd7c059f61fd8c@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3f2984d7-f854-2457-8bbe-7e8b1a377d66@gmail.com>
Date:   Tue, 25 Feb 2020 00:15:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <00000000000050bd7c059f61fd8c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/20 12:08 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    54dedb5b Merge tag 'for-linus-5.6-rc3-tag' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=168f7de9e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3e57a6b450fb9883
> dashboard link: https://syzkaller.appspot.com/bug?extid=1938db17e275e85dc328
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1681fe09e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD a0113067 P4D a0113067 PUD a8771067 PMD 0 
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 10686 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0x0
> Code: Bad RIP value.
> RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
> RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
> RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
> R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
> R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
> FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  inet_release+0x165/0x1c0 net/ipv4/af_inet.c:427
>  __sock_release net/socket.c:605 [inline]
>  sock_close+0xe1/0x260 net/socket.c:1283
>  __fput+0x2e4/0x740 fs/file_table.c:280
>  ____fput+0x15/0x20 fs/file_table.c:313
>  task_work_run+0x176/0x1b0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
>  prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
>  syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
>  do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45c429
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f2ae75dac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: 0000000000000000 RBX: 00007f2ae75db6d4 RCX: 000000000045c429
> RDX: 0000000000000001 RSI: 000000000000011a RDI: 0000000000000004
> RBP: 000000000076bf20 R08: 0000000000000038 R09: 0000000000000000
> R10: 0000000020000180 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 0000000000000a9d R14: 00000000004ccfb4 R15: 000000000076bf2c
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace 82567b5207e87bae ]---
> RIP: 0010:0x0
> Code: Bad RIP value.
> RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
> RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
> RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
> R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
> R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
> FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

Note to ULP maintainers

Probably the code for IPV6_ADDRFORM  needs some care if a TCP socket got ULP enabled ?

