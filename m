Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EEE64496D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbiLFQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiLFQhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:37:10 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5A72FC19
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:36:01 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id e141so19296643ybh.3
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DKTbnFauBQSq1w24uvDzVUdb+ndoW+9zAbYxO8lWcTE=;
        b=M9aQ+y4eDXXcRdNdGyXp3iY7CVYirhqmxy7pKTAhXywDRlsMaI2LW7EJosQFwsgfzQ
         gC2cz3W2SGPyWZqcC48bDwyFYzp2cLUyzTTZr09BXOxxatqR5o4ZsbPd3HeM1U+XRyXu
         z4+1wMyPV+KNCVTZmwtGwwxOLN2JaQi4y+YncHzrrmA5DxQ1FgKMGvpr/vOKgT4MCavm
         wZ9pjy9J1WjTl7FKMXIzrA1BcO7BwDOp1TIR9W+BtvsY4NxX2drTl51Y4eYFRCguuy82
         IEtFQoxonRCXcYK2BJXnzrcT3WtGBuzMWlvl8couqSxhqiwmnVtbl3OhWItuDTxrJQib
         5ROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DKTbnFauBQSq1w24uvDzVUdb+ndoW+9zAbYxO8lWcTE=;
        b=Q+kmBJzbrS1qU+oxVpnoljmTY/FFsw6i4KK1DF0ohMjQf8MUq9HKZEh+6v5jz+1smN
         7s6rEr3FConzCCbE7qXUNh7eG8nHaTTc/SDWe9eqGsvntUDmSUFM9nuY8K/qINDEsCQb
         A6AG2oWr7SXSkTajvB0vm/dn91asSjNfIi8vVegWFDFRsLgaZh7303zNX/44JL0tUc4l
         gmUAvQs+vkBYF0pcRUqyllEjf4OKrXo85LM/YlNfYYUwdpZ+unRBhpzaa7hqGxfwSpNv
         ktPMLb+TY5sMGFUS5o/vCuv7RZZYwGurosM2XDUgH4Ki8+N9mzWA97+C4muU9EyN3fwz
         nAjQ==
X-Gm-Message-State: ANoB5pndB5Zpw38NVYZP5GdX0JP8sptZrS1vt6qwzVMeLr1GgZ3HWenO
        vg4ZGDku6CbuFu9izOeuJMEqOvzjUNbtYJpb/WRqVA==
X-Google-Smtp-Source: AA0mqf7oUc2FCf8TX05o/BZPs2p9ArEI2y7o7INhXojo67oMb7nBs7XQQeiynfdbxN1fl3mksBb4xGv7XfwCXkjNgrA=
X-Received: by 2002:a25:d655:0:b0:6fc:1c96:c9fe with SMTP id
 n82-20020a25d655000000b006fc1c96c9femr23163963ybg.36.1670344560743; Tue, 06
 Dec 2022 08:36:00 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrfcV_07hbj8NUuZrA8FH-kaRsrFy-2metecpTuE5kKHn5w@mail.gmail.com>
In-Reply-To: <CAO4mrfcV_07hbj8NUuZrA8FH-kaRsrFy-2metecpTuE5kKHn5w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 17:35:49 +0100
Message-ID: <CANn89i++YUnpUTGFZOfRqfzsU2mriToHr4PBYnQDgGhTxMRKrQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in can_rcv_filter
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     socketcan@hartkopp.net, mkl@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 4:26 PM Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developers,
>
> Recently, when using our tool to fuzz kernel, the following crash was triggered.
>
> HEAD commit: 147307c69ba
> git tree: linux-next
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1_c7TZ6WzCT-VLBimUP3xnkMpJPhjOAPY/view?usp=share_link
> kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link
>
> Unfortunately, I didn't have a reproducer for this crash.

Well, public syzbot instance has something better, with a repro....

syzbot found the following issue on:

HEAD commit:    e3cb714fb489 Merge branch 'for-next/core' into for-kernelci
git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16e55ae3880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ec7118319bfb771e
dashboard link: https://syzkaller.appspot.com/bug?extid=2d7f58292cb5b29eb5ad
compiler:       Debian clang version
13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld
(GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1164b38d880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f61223880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/832eb1866f2c/disk-e3cb714f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5fd572b7d96d/vmlinux-e3cb714f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/34c82908beda/Image-e3cb714f.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2d7f58292cb5b29eb5ad@syzkaller.appspotmail.com

>
> I'm wondering if there is a data race between can_receive and
> sock_close, which leads to the invalid null value of dev and
> dev_rcv_lists. I hope the following report is helpful.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
>
> BUG: unable to handle page fault for address: 0000000000006020
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 132110067 P4D 132110067 PUD 1320b6067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 0 PID: 13844 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:can_rcv_filter+0x44/0x4e0 net/can/af_can.c:584
> Code: 00 00 00 e8 3e 86 0f fd 49 8b 9e d8 00 00 00 48 89 df e8 af 81
> 0f fd 44 8b 23 48 8d bd 20 60 00 00 e8 a0 81 0f fd 48 89 2c 24 <8b> 9d
> 20 60 00 00 45 31 ed 31 ff 89 de e8 9a 1c fc fc 85 db 0f 84
> RSP: 0018:ffffc90000003d50 EFLAGS: 00010246
> RAX: ffff88813bc274d8 RBX: ffff8881310c5a10 RCX: ffffffff842b9940
> RDX: 0000000000000522 RSI: 0000000000000000 RDI: 0000000000006020
> RBP: 0000000000000000 R08: 0000000000006023 R09: 0000000000000000
> R10: 0001ffffffffffff R11: 00018881310c5a04 R12: 0000000000000000
> R13: ffff888106fb8880 R14: ffff8881308cba00 R15: 0000000000000000
> FS:  00007fc9368b0700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000006020 CR3: 0000000132249000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000020000180 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Call Trace:
>  <IRQ>
>  can_receive+0x182/0x1f0 net/can/af_can.c:664
>  canfd_rcv+0x9a/0x120 net/can/af_can.c:703
>  __netif_receive_skb_one_core net/core/dev.c:5482 [inline]
>  __netif_receive_skb+0x8b/0x1b0 net/core/dev.c:5596
>  process_backlog+0x23f/0x3b0 net/core/dev.c:5924
>  __napi_poll+0x65/0x420 net/core/dev.c:6485
>  napi_poll net/core/dev.c:6552 [inline]
>  net_rx_action+0x37e/0x730 net/core/dev.c:6663
>  __do_softirq+0xf2/0x2c9 kernel/softirq.c:571
>  do_softirq+0xb1/0xf0 kernel/softirq.c:472
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0x6f/0x80 kernel/softirq.c:396
>  local_bh_enable+0x1b/0x20 include/linux/bottom_half.h:33
>  netif_rx+0x63/0x1c0 net/core/dev.c:5003
>  can_send+0x521/0x5b0 net/can/af_can.c:286
>  bcm_can_tx+0x2f0/0x3f0 net/can/bcm.c:302
>  bcm_tx_setup net/can/bcm.c:1020 [inline]
>  bcm_sendmsg+0x1f78/0x2c50 net/can/bcm.c:1351
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0x38f/0x500 net/socket.c:2476
>  ___sys_sendmsg net/socket.c:2530 [inline]
>  __sys_sendmsg+0x197/0x230 net/socket.c:2559
>  __do_sys_sendmsg net/socket.c:2568 [inline]
>  __se_sys_sendmsg net/socket.c:2566 [inline]
>  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x4697f9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc9368afc48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
> RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000006
> RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
> R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffe26483e60
>  </TASK>
> Modules linked in:
> CR2: 0000000000006020
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:can_rcv_filter+0x44/0x4e0 net/can/af_can.c:584
> Code: 00 00 00 e8 3e 86 0f fd 49 8b 9e d8 00 00 00 48 89 df e8 af 81
> 0f fd 44 8b 23 48 8d bd 20 60 00 00 e8 a0 81 0f fd 48 89 2c 24 <8b> 9d
> 20 60 00 00 45 31 ed 31 ff 89 de e8 9a 1c fc fc 85 db 0f 84
> RSP: 0018:ffffc90000003d50 EFLAGS: 00010246
> RAX: ffff88813bc274d8 RBX: ffff8881310c5a10 RCX: ffffffff842b9940
> RDX: 0000000000000522 RSI: 0000000000000000 RDI: 0000000000006020
> RBP: 0000000000000000 R08: 0000000000006023 R09: 0000000000000000
> R10: 0001ffffffffffff R11: 00018881310c5a04 R12: 0000000000000000
> R13: ffff888106fb8880 R14: ffff8881308cba00 R15: 0000000000000000
> FS:  00007fc9368b0700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000006020 CR3: 0000000132249000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000020000180 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> ----------------
> Code disassembly (best guess):
>    0: 00 00                add    %al,(%rax)
>    2: 00 e8                add    %ch,%al
>    4: 3e 86 0f              xchg   %cl,%ds:(%rdi)
>    7: fd                    std
>    8: 49 8b 9e d8 00 00 00 mov    0xd8(%r14),%rbx
>    f: 48 89 df              mov    %rbx,%rdi
>   12: e8 af 81 0f fd        callq  0xfd0f81c6
>   17: 44 8b 23              mov    (%rbx),%r12d
>   1a: 48 8d bd 20 60 00 00 lea    0x6020(%rbp),%rdi
>   21: e8 a0 81 0f fd        callq  0xfd0f81c6
>   26: 48 89 2c 24          mov    %rbp,(%rsp)
> * 2a: 8b 9d 20 60 00 00    mov    0x6020(%rbp),%ebx <-- trapping instruction
>   30: 45 31 ed              xor    %r13d,%r13d
>   33: 31 ff                xor    %edi,%edi
>   35: 89 de                mov    %ebx,%esi
>   37: e8 9a 1c fc fc        callq  0xfcfc1cd6
>   3c: 85 db                test   %ebx,%ebx
>   3e: 0f                    .byte 0xf
>   3f: 84                    .byte 0x84
>
> Best,
> Wei
