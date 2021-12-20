Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7678B47A313
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 01:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhLTATW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 19:19:22 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:54094 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhLTATV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 19:19:21 -0500
Received: by mail-il1-f199.google.com with SMTP id x8-20020a92dc48000000b002b2abc6e1cbso1371376ilq.20
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 16:19:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=l9fTUvv2W/zZfQTMkIdtNjjZgc0Pa7tFnb0ccwxYLoA=;
        b=H2jvufn72h2gRkJh/cLJQ66+tmLHjwJJxz2CKaY/+mMFImiLBed5mJrvTw7twHf3kx
         lqtSWFtK28L76CT3zmHi6efFUEeJmO9Vm+XNiUwky384kZpaXcF+2IYNQEZpk3yWL5A4
         34B5odCMnq/2x8H6bmlCYxSCukS7rlz2pZtTSLTyiwZrcgma8CjB2x/XI6XBiDJUOdjd
         dY3+uoWv0X5C5BDZYkGeE2C6meCq8U4ZRKovrRr/KvCGS2/vrW/RYoLnG52oL2cZ2eVG
         SwdIR7Rt07nHbcOui+RBvvAf8xEjQjYOKu1qqNSkFnq5LJWIPbJXeNt9xRu6i6TUHc8o
         GzdA==
X-Gm-Message-State: AOAM533ZqXbhB5pA5h4NISBzyPCaT0lzSy9mpf0+vh43TcGo75uIq824
        lrGuXNy3Bw/pZYefwpqrcL5ML0cwc2SJE8ppAj8/Jd2CTk74
X-Google-Smtp-Source: ABdhPJxOGXB3IQKkBe2reRag0j8Rq6ERvZTRV6O7cNbr6KdgPOxJTSTD94OCKIG8rQvT1ZC7/hOsET7H6pUU7GB6/ETyoHXoyvHP
MIME-Version: 1.0
X-Received: by 2002:a92:c265:: with SMTP id h5mr1891529ild.36.1639959560697;
 Sun, 19 Dec 2021 16:19:20 -0800 (PST)
Date:   Sun, 19 Dec 2021 16:19:20 -0800
In-Reply-To: <0000000000007ea16705d0cfbb53@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000fbea205d388d749@google.com>
Subject: Re: [syzbot] kernel BUG in pskb_expand_head
From:   syzbot <syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com>
To:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        eric.dumazet@gmail.com, hawk@kernel.org,
        intel-wired-lan-owner@osuosl.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    434ed2138994 Merge branch 'tc-action-offload'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1722300db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7488eea316146357
dashboard link: https://syzkaller.appspot.com/bug?extid=4c63f36709a642f801c5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14141ca3b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com

skbuff: skb_over_panic: text:ffffffff88257728 len:4096 put:4096 head:ffff8880769c1400 data:ffff8880769c1400 tail:0x1000 end:0xc0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113 net/core/skbuff.c:113
Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 a0 82 ad 8a ff 74 24 10 ff 74 24 20 e8 13 20 c2 ff <0f> 0b e8 6c 3d 35 f8 4c 8b 64 24 18 e8 f2 9e 7c f8 48 c7 c1 40 8f
RSP: 0018:ffffc90000d279e0 EFLAGS: 00010286
RAX: 000000000000008b RBX: ffff88801c5b8640 RCX: 0000000000000000
RDX: ffff888011938000 RSI: ffffffff815f21d8 RDI: fffff520001a4f2e
RBP: ffffffff8aad8f80 R08: 000000000000008b R09: 0000000000000000
R10: ffffffff815ebf7e R11: 0000000000000000 R12: ffffffff88257728
R13: 0000000000001000 R14: ffffffff8aad8260 R15: 00000000000000c0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f14858bf718 CR3: 0000000072e5c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:118 [inline]
 skb_over_panic net/core/skbuff.c:118 [inline] net/core/skbuff.c:1986
 skb_put.cold+0x24/0x24 net/core/skbuff.c:1986 net/core/skbuff.c:1986
 isotp_rcv_cf net/can/isotp.c:570 [inline]
 isotp_rcv_cf net/can/isotp.c:570 [inline] net/can/isotp.c:668
 isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668 net/can/isotp.c:668
 deliver net/can/af_can.c:574 [inline]
 deliver net/can/af_can.c:574 [inline] net/can/af_can.c:635
 can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635 net/can/af_can.c:635
 can_receive+0x31d/0x580 net/can/af_can.c:665 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5350 net/core/dev.c:5350
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5464 net/core/dev.c:5464
 process_backlog+0x2a5/0x6c0 net/core/dev.c:5796 net/core/dev.c:5796
 __napi_poll+0xaf/0x440 net/core/dev.c:6364 net/core/dev.c:6364
 napi_poll net/core/dev.c:6431 [inline]
 napi_poll net/core/dev.c:6431 [inline] net/core/dev.c:6518
 net_rx_action+0x801/0xb40 net/core/dev.c:6518 net/core/dev.c:6518
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd kernel/softirq.c:921 [inline] kernel/softirq.c:913
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164 kernel/smpboot.c:164
 kthread+0x405/0x4f0 kernel/kthread.c:327 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295 arch/x86/entry/entry_64.S:295
 </TASK>
Modules linked in:
---[ end trace 076cfcb09686117c ]---
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113 net/core/skbuff.c:113
Code: f8 4c 8b 4c 24 10 8b 4b 70 41 56 45 89 e8 4c 89 e2 41 57 48 89 ee 48 c7 c7 a0 82 ad 8a ff 74 24 10 ff 74 24 20 e8 13 20 c2 ff <0f> 0b e8 6c 3d 35 f8 4c 8b 64 24 18 e8 f2 9e 7c f8 48 c7 c1 40 8f
RSP: 0018:ffffc90000d279e0 EFLAGS: 00010286
RAX: 000000000000008b RBX: ffff88801c5b8640 RCX: 0000000000000000
RDX: ffff888011938000 RSI: ffffffff815f21d8 RDI: fffff520001a4f2e
RBP: ffffffff8aad8f80 R08: 000000000000008b R09: 0000000000000000
R10: ffffffff815ebf7e R11: 0000000000000000 R12: ffffffff88257728
R13: 0000000000001000 R14: ffffffff8aad8260 R15: 00000000000000c0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f14858bf718 CR3: 0000000072e5c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

