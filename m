Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7061426407A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgIJIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:48:30 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:45584 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgIJIsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:48:22 -0400
Received: by mail-il1-f206.google.com with SMTP id m80so3988581ilb.12
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 01:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ss+NDibV+9A1A4nhUiuCZmAy2xJiaoswkCsDPh/ljK0=;
        b=MY+VpXJ7NSjQ9qxQTRB4MFuwSBNmArWo2pOYyeNIAnU24KK5fyxoG6XOb2TLrS+C0Z
         Nf0biXmcCJsHNoZjaUydKzmsYSZdwa5expgYgCW76irwVejj6+shPttdNBowPUw6jUGi
         1lu5SsitLYUjbu4/dwXc7g1iac48eXDVgkuSf3NKJabqQn1jreZGh/Ba13Kvvnw+kbaR
         SPfZo7ulAuyYLN6Ddb24mHxqbXjawofr1gr9y1VuXbQLBVTvyk+0afUrCB0to1lJ+9zl
         zMGyYJH7rjvyW2GELK+uPhr1W0F2BzWTKr8M4GKNYaAIb0EeOYGsQMrShSAusWz6HF8h
         sodg==
X-Gm-Message-State: AOAM5323XjdH0wdUB4Y2QpDD9YR8w/GKj8R+nEBgcr+c3kAwP30dqEW5
        OvOHOG6kE1WK6XIRMVlvzlOBiv1cfZBsvxIIRR+2I/grUhcL
X-Google-Smtp-Source: ABdhPJwskIZBJxIhH+SvsruZKozcsWaPSpr2Ik9ydDFAt2JAIkl+GjSkZWwUURXqIRfRMllMo5kAD/PUXnvUAnZN3Uy6qTbXqPii
MIME-Version: 1.0
X-Received: by 2002:a05:6638:144:: with SMTP id y4mr7640549jao.61.1599727701395;
 Thu, 10 Sep 2020 01:48:21 -0700 (PDT)
Date:   Thu, 10 Sep 2020 01:48:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000610c6805aef1a1b8@google.com>
Subject: kernel BUG at net/rxrpc/conn_object.c:LINE!
From:   syzbot <syzbot+52071f826a617b9c76ed@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f5499c67 nfc: pn533/usb.c: fix spelling of "functions"
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16415055900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b946b3cd0adc99
dashboard link: https://syzkaller.appspot.com/bug?extid=52071f826a617b9c76ed
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16be260d900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100b7cdd900000

The issue was bisected to:

commit 245500d853e9f20036cec7df4f6984ece4c6bf26
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 1 10:15:32 2020 +0000

    rxrpc: Rewrite the client connection manager

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11950759900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13950759900000
console output: https://syzkaller.appspot.com/x/log.txt?x=15950759900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+52071f826a617b9c76ed@syzkaller.appspotmail.com
Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")

rxrpc: Assertion failed
------------[ cut here ]------------
kernel BUG at net/rxrpc/conn_object.c:481!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 234 Comm: kworker/u4:5 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:rxrpc_destroy_all_connections.cold+0x11/0x13 net/rxrpc/conn_object.c:481
Code: c0 48 c7 c1 00 b0 14 89 48 89 f2 48 c7 c7 80 ac 14 89 e8 04 4d 0c fa 0f 0b e8 be 15 23 fa 48 c7 c7 80 af 14 89 e8 f1 4c 0c fa <0f> 0b 41 57 41 56 41 55 41 54 55 53 48 89 f3 48 83 ec 20 48 89 3c
RSP: 0018:ffffc90000f57b18 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff8880945a8000 RCX: 0000000000000000
RDX: ffff8880a85ca200 RSI: ffffffff815dbd97 RDI: fffff520001eaf55
RBP: ffff8880945a8064 R08: 0000000000000017 R09: ffff8880ae731927
R10: 0000000000000000 R11: 0000000034333254 R12: ffff8880945a8068
R13: ffff8880945a8078 R14: ffff8880945a8078 R15: ffff8880945a7eb8
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdbae898020 CR3: 00000000963ae000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rxrpc_exit_net+0x1a4/0x2e0 net/rxrpc/net_ns.c:119
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace b82f4cc98146655f ]---
RIP: 0010:rxrpc_destroy_all_connections.cold+0x11/0x13 net/rxrpc/conn_object.c:481
Code: c0 48 c7 c1 00 b0 14 89 48 89 f2 48 c7 c7 80 ac 14 89 e8 04 4d 0c fa 0f 0b e8 be 15 23 fa 48 c7 c7 80 af 14 89 e8 f1 4c 0c fa <0f> 0b 41 57 41 56 41 55 41 54 55 53 48 89 f3 48 83 ec 20 48 89 3c
RSP: 0018:ffffc90000f57b18 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff8880945a8000 RCX: 0000000000000000
RDX: ffff8880a85ca200 RSI: ffffffff815dbd97 RDI: fffff520001eaf55
RBP: ffff8880945a8064 R08: 0000000000000017 R09: ffff8880ae731927
R10: 0000000000000000 R11: 0000000034333254 R12: ffff8880945a8068
R13: ffff8880945a8078 R14: ffff8880945a8078 R15: ffff8880945a7eb8
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdbae89e000 CR3: 0000000093fd8000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
