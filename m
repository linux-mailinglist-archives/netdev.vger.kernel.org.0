Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AA3FBCD7
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhH3TXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 15:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbhH3TXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 15:23:41 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E214C06175F
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 12:22:47 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso19770482otp.1
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 12:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJKnuuFCd5awKtbgLO6rUtFjGmCb0A0Nsttc7G/tr2E=;
        b=pPL3/DNYCxboctG6Wsloy2QPWQ4/dxzuXrSwx38sGQwSZnnHfpi+p6VbPhfoqKjssL
         LhRbhNb6721xU3oOaxC3r9j/WbXZle6iG+RSeGdbnMxY0PvdseSpF/CxWQMcl6NYAGoq
         bJL6btZq8B6yOWwJY2c0qeImbjuAni4R2zywEXVHmXXuePP2miwH1W/nRZUzto/9h1fv
         /ZnI7LiRRXSiILpAgR1stvBJt6wsVOpzGeitcKdji+s9t00eesSHU38XriChB1Q44gT9
         RA2h2krqH8g9QADTau6p7Zavtqn2srM+6QbuYFYKNzC8DxMFfDDgJYgAUj4GcGjIYCe+
         nMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJKnuuFCd5awKtbgLO6rUtFjGmCb0A0Nsttc7G/tr2E=;
        b=JLDxXK3eoR7ntMG0ZDrG2N8TRHHTsn5aOYJg9b/TDBAEVYAc2DExsHjUNA7GTtiPBE
         vc+oDsqpDUcvxugreS1hjzZkIEFOJkQAAfYIj8kM97vSoQ/g4vwKXjlgz3ppdSDRwL6U
         8MdBlwzlRuxff4emfeg9dcOEhsCjVw7VmIW/YpZHXx2bZFT6MAWfwYqk9f4MYNjGhX3b
         gNLXMVm/pZ7NLZn6aSmyssD6k5ai+fVLVbrdDj9z33SYgj6wpCOSXOfGWjnSnENI5kIT
         e/RZ6VJ2MySqSK7zQmo4lrjSoTC9eVAU/lo6B6mRZ/PrjfchkrKNiNpiZRbgETQ5G84F
         6B0Q==
X-Gm-Message-State: AOAM531iY14ifxKqUFJKpQCiQEHIIVA4eJYR25Zc9igYHOCy+PAkOEhn
        r1sv6dpol1tUNiMzxth0FYWcbIizI4Cz82EbMDpESg==
X-Google-Smtp-Source: ABdhPJzqiUlmRzEF2xz9OpH5XCE0y9WV/7tue2/CzkPeL1qph/JCSKwrc6+lWdCWrwfRXEiiqPbr6U0BOES2NAR1zOs=
X-Received: by 2002:a9d:450b:: with SMTP id w11mr20646252ote.254.1630351366100;
 Mon, 30 Aug 2021 12:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000011360d05cacbb622@google.com>
In-Reply-To: <00000000000011360d05cacbb622@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 30 Aug 2021 21:22:34 +0200
Message-ID: <CACT4Y+a9gTY4Mr=UsGiNGL7oXDc5dtV6-WXf2fC_vP5dDdGXRQ@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in sock_from_file
To:     syzbot <syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 at 21:19, syzbot
<syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    93717cde744f Add linux-next specific files for 20210830
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b851fe300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c643ef5289990dd1
> dashboard link: https://syzkaller.appspot.com/bug?extid=f9704d1878e290eddf73
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com

+io_uring maintainers as this looks io_uring-related

> general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> CPU: 1 PID: 6072 Comm: syz-executor.0 Not tainted 5.14.0-next-20210830-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:sock_from_file+0x20/0x90 net/socket.c:505
> Code: f5 ff ff ff c3 0f 1f 44 00 00 41 54 53 48 89 fb e8 85 e9 62 fa 48 8d 7b 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 4f 45 31 e4 48 81 7b 28 80 f1 8a 8a 74 0c e8 58 e9
> RSP: 0018:ffffc9000a2df8e8 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002f91000
> RDX: 0000000000000005 RSI: ffffffff8713203b RDI: 0000000000000028
> RBP: ffff8880983c2c80 R08: ffffffff899aee40 R09: ffffffff81e21978
> R10: 0000000000000027 R11: 0000000000000009 R12: dffffc0000000000
> R13: 1ffff11013078599 R14: 0000000000000003 R15: ffff8880983c2c80
> FS:  00007fe7b0454700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005591dffa5180 CR3: 00000000974cb000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_sendmsg+0x98/0x640 fs/io_uring.c:4681
>  io_issue_sqe+0x14de/0x6ba0 fs/io_uring.c:6578
>  __io_queue_sqe+0x90/0xb50 fs/io_uring.c:6864
>  io_req_task_submit+0xbf/0x1b0 fs/io_uring.c:2218
>  tctx_task_work+0x166/0x610 fs/io_uring.c:2143
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>  handle_signal_work kernel/entry/common.c:146 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4665f9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe7b0454188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000001000 RBX: 000000000056bf80 RCX: 00000000004665f9
> RDX: 0000000000000000 RSI: 000000000000688c RDI: 0000000000000003
> RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
> R13: 00007fffeee6585f R14: 00007fe7b0454300 R15: 0000000000022000
> Modules linked in:
> ---[ end trace 6f9e359dd487b8fa ]---
> RIP: 0010:sock_from_file+0x20/0x90 net/socket.c:505
> Code: f5 ff ff ff c3 0f 1f 44 00 00 41 54 53 48 89 fb e8 85 e9 62 fa 48 8d 7b 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 4f 45 31 e4 48 81 7b 28 80 f1 8a 8a 74 0c e8 58 e9
> RSP: 0018:ffffc9000a2df8e8 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002f91000
> RDX: 0000000000000005 RSI: ffffffff8713203b RDI: 0000000000000028
> RBP: ffff8880983c2c80 R08: ffffffff899aee40 R09: ffffffff81e21978
> R10: 0000000000000027 R11: 0000000000000009 R12: dffffc0000000000
> R13: 1ffff11013078599 R14: 0000000000000003 R15: ffff8880983c2c80
> FS:  00007fe7b0454700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb81002c710 CR3: 00000000974cb000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 3 bytes skipped:
>    0:   ff c3                   inc    %ebx
>    2:   0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
>    7:   41 54                   push   %r12
>    9:   53                      push   %rbx
>    a:   48 89 fb                mov    %rdi,%rbx
>    d:   e8 85 e9 62 fa          callq  0xfa62e997
>   12:   48 8d 7b 28             lea    0x28(%rbx),%rdi
>   16:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   1d:   fc ff df
>   20:   48 89 fa                mov    %rdi,%rdx
>   23:   48 c1 ea 03             shr    $0x3,%rdx
> * 27:   80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   2b:   75 4f                   jne    0x7c
>   2d:   45 31 e4                xor    %r12d,%r12d
>   30:   48 81 7b 28 80 f1 8a    cmpq   $0xffffffff8a8af180,0x28(%rbx)
>   37:   8a
>   38:   74 0c                   je     0x46
>   3a:   e8                      .byte 0xe8
>   3b:   58                      pop    %rax
>   3c:   e9                      .byte 0xe9
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
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000011360d05cacbb622%40google.com.
