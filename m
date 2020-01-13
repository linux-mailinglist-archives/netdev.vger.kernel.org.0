Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE40139A3D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 20:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgAMTeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 14:34:15 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:39717 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgAMTeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 14:34:12 -0500
Received: by mail-il1-f199.google.com with SMTP id n6so8694920ile.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 11:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iKgXkUUifDTHe1wYti7XokONx9JjbAC539M6HstQB/k=;
        b=RgS2oAYp0jGaUaqv5KCKV+YyGQulTP0eaeVL7b6EC5ZxiJd1KOCh0dZjGey+M15U1v
         olqNORAHxDnxQDXD0S7nvTd7RoFnRwb8Xi+M/yuq5pB5yiZQs38RpUT2m6ZaX1/ZEHqg
         UwoAzx5LcoHib7q3s1X7WrWJtes5E0Sx2cxkkkxge2tBa/J/plMpCGCh6C6B9yWbJiK0
         r2NPsdXS/4c9PrenZ7zgckh751HROvX0mSfQJ1VhRraFmZghn0ZGg1wJl2HremcJx1C6
         KeFjTP3fO57bN/KZeNG2VGphOYXlMctdK84/1MGbmcI/lEcmnjm6pgciWI9DIsYZtNd2
         vdZw==
X-Gm-Message-State: APjAAAXrIzxk8NKJal5F6fnx7pTH8FkPhm8FC0KEl92mMGRVfitUt6Dr
        D0c0gy0Ha67OVc2bTYrisxVB4nBgWI9HcIngNUhVcvsKsY0Z
X-Google-Smtp-Source: APXvYqzaNcVpE7dne1l1ihiEgfr6Zy2LxQzVYEVdovLQ5xW8OKaJwY513n5SHhDdl21ILG0FBwo9bbP7vlQ9sXE0LfOo+H5i3o5w
MIME-Version: 1.0
X-Received: by 2002:a6b:6e06:: with SMTP id d6mr13077449ioh.95.1578944051034;
 Mon, 13 Jan 2020 11:34:11 -0800 (PST)
Date:   Mon, 13 Jan 2020 11:34:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048427b059c0a8f9d@google.com>
Subject: WARNING: locking bug in finish_task_switch
From:   syzbot <syzbot+edec84a8b77e5a0cae31@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        johan.hedberg@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kernel@stlinux.com, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, marcel@holtmann.org,
        mchehab@kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, patrice.chotard@st.com,
        peter.griffin@linaro.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6c09d7db Add linux-next specific files for 20200110
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150b6a9ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7dc7ab9739654fbe
dashboard link: https://syzkaller.appspot.com/bug?extid=edec84a8b77e5a0cae31
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d005e1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1527b6aee00000

The bug was bisected to:

commit 7152c88e556bcbee525689063c260cd296f295a8
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Tue Oct 18 19:44:11 2016 +0000

     [media] c8sectpfe: don't break long lines

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10930c21e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12930c21e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14930c21e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+edec84a8b77e5a0cae31@syzkaller.appspotmail.com
Fixes: 7152c88e556b ("[media] c8sectpfe: don't break long lines")

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 9970 at kernel/locking/lockdep.c:167 hlock_class  
kernel/locking/lockdep.c:167 [inline]
WARNING: CPU: 1 PID: 9970 at kernel/locking/lockdep.c:167 hlock_class  
kernel/locking/lockdep.c:156 [inline]
WARNING: CPU: 1 PID: 9970 at kernel/locking/lockdep.c:167  
__lock_acquire+0x21dd/0x4a00 kernel/locking/lockdep.c:3950
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9970 Comm: syz-executor719 Not tainted  
5.5.0-rc5-next-20200110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:176 [inline]
  fixup_bug arch/x86/kernel/traps.c:171 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:269
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:288
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:167 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:156 [inline]
RIP: 0010:__lock_acquire+0x21dd/0x4a00 kernel/locking/lockdep.c:3950
Code: 05 98 39 4a 09 85 c0 75 a0 48 c7 c6 e0 91 4b 88 48 c7 c7 20 92 4b 88  
4c 89 9d 30 ff ff ff 4c 89 95 70 ff ff ff e8 b2 ff ea ff <0f> 0b 31 db 4c  
8b 95 70 ff ff ff 4c 8b 9d 30 ff ff ff e9 22 f8 ff
RSP: 0018:ffffc90002d87738 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 00000000000005e3 RCX: 0000000000000000
RDX: 0000000040000000 RSI: ffffffff815e8546 RDI: fffff520005b0ed9
RBP: ffffc90002d87850 R08: ffff8880903f8380 R09: fffffbfff13748ed
R10: fffffbfff13748ec R11: ffffffff89ba4763 R12: 000000009ecb23e7
R13: ffffffff8aa50270 R14: ffff8880903f8c48 R15: 0000000000000000
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
  finish_lock_switch kernel/sched/core.c:3123 [inline]
  finish_task_switch+0x13f/0x750 kernel/sched/core.c:3224
  context_switch kernel/sched/core.c:3388 [inline]
  __schedule+0x93c/0x1f90 kernel/sched/core.c:4081
  preempt_schedule_irq+0xb5/0x160 kernel/sched/core.c:4338
  retint_kernel+0x1b/0x2b
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752  
[inline]
RIP: 0010:lock_acquire+0x20b/0x410 kernel/locking/lockdep.c:4487
Code: 9c 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 d3 01 00 00 48  
83 3d a9 a4 58 08 00 0f 84 53 01 00 00 48 8b 7d c8 57 9d <0f> 1f 44 00 00  
48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 65 8b
RSP: 0018:ffffc90002d87ae0 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff13675eb RBX: ffff8880903f8380 RCX: ffffffff815ad05a
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000286
RBP: ffffc90002d87b28 R08: 0000000000000004 R09: fffffbfff1708c51
R10: fffffbfff1708c50 R11: ffff8880903f8380 R12: ffff888094a93d28
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  flush_workqueue+0x126/0x14c0 kernel/workqueue.c:2775
  hci_dev_open+0xe0/0x280 net/bluetooth/hci_core.c:1626
  hci_sock_bind+0x4bf/0x12d0 net/bluetooth/hci_sock.c:1189
  __sys_bind+0x239/0x290 net/socket.c:1662
  __do_sys_bind net/socket.c:1673 [inline]
  __se_sys_bind net/socket.c:1671 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1671
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4483b9
Code: e8 9c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 3b 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb43a523d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000006e4a18 RCX: 00000000004483b9
RDX: 0000000000000006 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 00000000006e4a10 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e4a1c
R13: 00007ffc78f07a4f R14: 00007fb43a5249c0 R15: 20c49ba5e353f7cf
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
