Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA391A4BAC
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 23:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgDJVwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 17:52:15 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55027 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgDJVwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 17:52:14 -0400
Received: by mail-io1-f72.google.com with SMTP id n18so3424924ioj.21
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 14:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=T7YM+n2o30irCMiquDxbhwJ3TtAy+TuePhxU1RwrqII=;
        b=h+DraOUk+hR0LgjOTUqTpO90IH+lKwVf+pO50TZjCRF3aYHSLIkmMoNo8xrp5kWyzt
         /KURKSGIMzK7RmvgQ9oeNQcFNfTkeLWtabnP4sGP+Fvyjrdh28lsZBZfeF/hhEdF6kqE
         eZPrW1CD1mRGNMaT9hWDpIlQzwCc+YbRSqxZnYSN5ssbTE1VFz0rhi5MgbKHrg0Kc89f
         8cMrdUiMth8YF3Ghv3q4/ksU2peTuRONPC0tY7/E99xU2h1KsEKqummQBak/4/YEtatB
         8YMOlsX2raFe7HZ0ugAvy7ILa00u2JrVvA/xeH0encB0anna1ZLhRIn3uVH8x5THBVME
         QP/A==
X-Gm-Message-State: AGi0PuY5tTt5XYWZ9orxLziF5SYI/13rB6io+bhgDe1I3FDM3C3DKoAI
        8f3dHXxfehmu6jrqDPHVMWWdRJqnm3BQd14hg7aLOdaj7+Qw
X-Google-Smtp-Source: APiQypINnu5lH2n9SpdEblVQq2DMRmIg7wGuhAA0xfhRZraUiiJYq6nudVRFoaoVTRN6TR6pWaGWkM5Z84b6qTD3dFC+6hQherk+
MIME-Version: 1.0
X-Received: by 2002:a92:d209:: with SMTP id y9mr7031801ily.3.1586555533203;
 Fri, 10 Apr 2020 14:52:13 -0700 (PDT)
Date:   Fri, 10 Apr 2020 14:52:13 -0700
In-Reply-To: <0000000000001fdbd605a00712b1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9205905a2f6be8e@google.com>
Subject: Re: WARNING: locking bug in finish_lock_switch
From:   syzbot <syzbot+91e3de3393c461e632ee@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    c0cc2711 Merge tag 'modules-for-v5.7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1688f9e7e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3010ccb0f380f660
dashboard link: https://syzkaller.appspot.com/bug?extid=91e3de3393c461e632ee
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e8bdb3e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137d4743e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+91e3de3393c461e632ee@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 12239 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:183 [inline]
WARNING: CPU: 1 PID: 12239 at kernel/locking/lockdep.c:183 check_wait_context kernel/locking/lockdep.c:4043 [inline]
WARNING: CPU: 1 PID: 12239 at kernel/locking/lockdep.c:183 __lock_acquire+0x8e4/0x2b90 kernel/locking/lockdep.c:4294
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 12239 Comm: syz-executor479 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:183 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4043 [inline]
RIP: 0010:__lock_acquire+0x8e4/0x2b90 kernel/locking/lockdep.c:4294
Code: 25 53 13 08 00 0f 85 bf fe ff ff 48 c7 c7 c9 4a e5 88 48 c7 c6 0b 16 ea 88 31 c0 e8 96 e8 ec ff 48 ba 00 00 00 00 00 fc ff df <0f> 0b 31 db e9 bb fe ff ff 31 db e9 aa fe ff ff 48 c7 c1 b4 d0 6b
RSP: 0018:ffffc90004157790 EFLAGS: 00010046
RAX: a6653ee74a817d00 RBX: 000000000000063f RCX: ffff8880a161c200
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffffffff815cab06
RBP: ffffc900041578f8 R08: ffffffff8178eeb6 R09: fffffbfff125c9c9
R10: fffffbfff125c9c9 R11: 0000000000000000 R12: 0000000000000004
R13: 1ffffffff16aa39e R14: ffff8880a161cb10 R15: 0000000000000001
 lock_acquire+0x169/0x480 kernel/locking/lockdep.c:4923
 finish_lock_switch+0x21/0x30 kernel/sched/core.c:3116
 finish_task_switch+0x24f/0x550 kernel/sched/core.c:3217
 context_switch kernel/sched/core.c:3381 [inline]
 __schedule+0x80d/0xc90 kernel/sched/core.c:4094
 preempt_schedule_irq+0xca/0x150 kernel/sched/core.c:4351
 retint_kernel+0x1b/0x2b
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:759 [inline]
RIP: 0010:lock_acquire+0x1c7/0x480 kernel/locking/lockdep.c:4926
Code: c1 e8 03 80 3c 10 00 74 0c 48 c7 c7 30 a0 2b 89 e8 5e a2 58 00 48 83 3d f6 2f d3 07 00 0f 84 8e 02 00 00 48 8b 7c 24 20 57 9d <0f> 1f 44 00 00 65 48 8b 04 25 28 00 00 00 48 3b 44 24 58 0f 85 70
RSP: 0018:ffffc90004157ba0 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1257406 RBX: 1ffff110142c3958 RCX: dffffc0000000000
RDX: dffffc0000000000 RSI: ffffffff8ad6a208 RDI: 0000000000000286
RBP: 0000000000000000 R08: dffffc0000000000 R09: fffffbfff16a99d9
R10: fffffbfff16a99d9 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880a161cac4 R15: ffff88809e15a138
 flush_workqueue+0x125/0x15a0 kernel/workqueue.c:2777
 hci_dev_open+0x205/0x2d0 net/bluetooth/hci_core.c:1651
 hci_sock_bind+0x15ba/0x1aa0 net/bluetooth/hci_sock.c:1200
 __sys_bind+0x283/0x360 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x76/0x80 net/socket.c:1671
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4469f9
Code: e8 6c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe4cbb32d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 00000000004469f9
RDX: 0000000000000006 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 0000000000000005 R14: 0000000000000004 R15: 00007fe4cbb336d0
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..

