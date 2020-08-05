Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F85B23CE10
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgHESLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 14:11:33 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:32881 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbgHESJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:09:24 -0400
Received: by mail-io1-f70.google.com with SMTP id a12so32284904ioo.0
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 11:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YloGL6E01nHExHJj20pzTeVaG7arypuWNvc/TTQM6GU=;
        b=BaQEaVj/rv1UZPkv3vuNNdxu5JOU5phUawq/jZ2xWyOn4zs7sRtd54ybStiDBOuGfF
         4b3zEMs/Iy6OJrdvHhOHm2kv/aqKJdvZPuKS6I8J3SiTHs0aIVByULSP2s1DviI0lzWs
         IebdzO9+SEzthERXNacMbPoL/hghOuBWVmQeaIDaU95oHbpSkAvVZMxIJzI2R3NIDh0S
         YErFKAnZhFXUJB7Pr4WieuH7i7Cjl3OXhYosU9J8XEmiaQNw+1suRAQA6IWIAf3VJdV0
         zdWF/pbrTeVr0gYqvleyZThlJeXoBwXNgg7MHFJDzuDR3eeCSxu7/ZUiYTUGeOMhhGvv
         iExA==
X-Gm-Message-State: AOAM531PMr9AE66imjKnXkY97Un+msKSB0zkeLq77pV4erkg/cqpWBV3
        CC15GsTkjhC7bnmxz7bMZQaWjRVz2+e7FY5Y0IauRyK9T9k5
X-Google-Smtp-Source: ABdhPJxKKv7Wr77Bbzsv5urdfzRqc3Ro2et+RbGkg6ws9iwd9GeFuikYIHMlqbLtnzqWa1N3LL1eyj/v5jRCbV2oUEfjHNWPBA2z
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr5753725jat.53.1596650962939;
 Wed, 05 Aug 2020 11:09:22 -0700 (PDT)
Date:   Wed, 05 Aug 2020 11:09:22 -0700
In-Reply-To: <000000000000b087a705ac2369dd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000079f28205ac254528@google.com>
Subject: Re: INFO: trying to register non-static key in l2cap_chan_del
From:   syzbot <syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    4c900a6b farsync: switch from 'pci_' to 'dma_' API
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1561801a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91a13b78c7dc258d
dashboard link: https://syzkaller.appspot.com/bug?extid=abfc0f5e668d4099af73
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bdcc3a900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:894 [inline]
 register_lock_class+0x157d/0x1630 kernel/locking/lockdep.c:1206
 __lock_acquire+0xfa/0x56e0 kernel/locking/lockdep.c:4259
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:358 [inline]
 lock_sock_nested+0x3b/0x110 net/core/sock.c:3019
 l2cap_sock_teardown_cb+0x88/0x400 net/bluetooth/l2cap_sock.c:1520
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc90000cbfb60 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff8880931bd000 RCX: ffffffff8728bc2f
RDX: 1ffff11014549a8c RSI: ffffffff8728be7c RDI: ffff8880a2a4d000
RBP: 0000000000000005 R08: 0000000000000001 R09: ffff8880a2a4d067
R10: 0000000000000009 R11: 0000000000000001 R12: 000000000000006f
R13: ffff8880a2a4d000 R14: 0000000000000000 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000929e6000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 l2cap_sock_teardown_cb+0x374/0x400 net/bluetooth/l2cap_sock.c:1547
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:823
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
CR2: 0000000000000000
---[ end trace ecb0577583d92fc1 ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc90000cbfb60 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff8880931bd000 RCX: ffffffff8728bc2f
RDX: 1ffff11014549a8c RSI: ffffffff8728be7c RDI: ffff8880a2a4d000
RBP: 0000000000000005 R08: 0000000000000001 R09: ffff8880a2a4d067
R10: 0000000000000009 R11: 0000000000000001 R12: 000000000000006f
R13: ffff8880a2a4d000 R14: 0000000000000000 R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000929e6000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

