Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931821ED365
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 17:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgFCPcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 11:32:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:39984 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgFCPcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 11:32:16 -0400
Received: by mail-il1-f197.google.com with SMTP id s4so1772020ilc.7
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 08:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hCfKtti0OOVEwdCy57euieZ5015RvD0tBSXcPV4JeNE=;
        b=aVwoqmO2DgcInI5RF2UtdOLjDp255T529LD0eO4vHNRlq0F3Kd6LRKbWjKzTkFvvre
         4Rnd30LYIqdOqdx1CB2748pJaL3qGCwRj8QIInF7u570QY80Vv/7zrXawV1/1/9GIGD9
         C+/NOTrGthr7GsrzYQTW5rnFzVMt53rMEGJb4iyTsr6/WrDmV4+sbgFx0jntta7DBIek
         zIEbeihzwvOoTMyt/omN3rK22PceUVhGcxMDQeAXJJTIBh8s6vYoQGlTYCGLO9iRYclZ
         +j5z4KIvECCSgXIJ5jNCVN9ckz6iXIjzir+ri6QXkE+HTSUOgrXFK+ZViM3KRaEUhu/P
         Mm9w==
X-Gm-Message-State: AOAM532oefFh7IjYVv19vJAWPWGP4V0BCwlWgsFV5UlGL/XBydhZ6SQu
        ZVrvlR2mgErrhUvjHJwW5a4LWkbaZ0fCHWfrvTtihvYDNBYX
X-Google-Smtp-Source: ABdhPJx4U0590dX2/3irztPqwY6mlmIxvcKI04nXLzNoErep5Repsw38p7vnSr+V9eNu+fWjmsmu1UaYe9DvHSmLOtLJCVAOP6C6
MIME-Version: 1.0
X-Received: by 2002:a02:3f58:: with SMTP id c24mr458448jaf.16.1591198334553;
 Wed, 03 Jun 2020 08:32:14 -0700 (PDT)
Date:   Wed, 03 Jun 2020 08:32:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f94e205a72fbb2f@google.com>
Subject: WARNING: locking bug in ath9k_htc_wait_for_target
From:   syzbot <syzbot+644c73760fbf6c60a6c4@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2089c6ed usb: core: kcov: collect coverage from usb comple..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=12576bd6100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7479d3935864b1b
dashboard link: https://syzkaller.appspot.com/bug?extid=644c73760fbf6c60a6c4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179a24fe100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16576bd6100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+644c73760fbf6c60a6c4@syzkaller.appspotmail.com

usb 1-1: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
usb 1-1: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 5 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:183 [inline]
WARNING: CPU: 0 PID: 5 at kernel/locking/lockdep.c:183 hlock_class kernel/locking/lockdep.c:172 [inline]
WARNING: CPU: 0 PID: 5 at kernel/locking/lockdep.c:183 check_wait_context kernel/locking/lockdep.c:4029 [inline]
WARNING: CPU: 0 PID: 5 at kernel/locking/lockdep.c:183 __lock_acquire+0x2194/0x6650 kernel/locking/lockdep.c:4305
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 panic+0x2aa/0x6e1 kernel/panic.c:221
 __warn.cold+0x2f/0x30 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x1e0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:183 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:172 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4029 [inline]
RIP: 0010:__lock_acquire+0x2194/0x6650 kernel/locking/lockdep.c:4305
Code: d2 0f 85 91 33 00 00 44 8b 35 38 f2 c1 06 45 85 f6 0f 85 b8 fb ff ff 48 c7 c6 c0 fa e6 85 48 c7 c7 00 fb e6 85 e8 84 6b ed ff <0f> 0b e9 9e fb ff ff e8 f0 89 c0 00 85 c0 0f 84 db fb ff ff 48 c7
RSP: 0018:ffff8881da1d7748 EFLAGS: 00010086
RAX: 0000000000000000 RBX: bd37a6f4de9bd740 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff812a339d RDI: ffffed103b43aedb
RBP: ffff8881da19ebd0 R08: ffff8881da19e300 R09: fffffbfff0e20bd1
R10: ffffffff87105e83 R11: fffffbfff0e20bd0 R12: ffff8881da19e300
R13: ffff8881c679e460 R14: 0000000000000000 R15: 0000000000000000
 lock_acquire+0x18b/0x7c0 kernel/locking/lockdep.c:4934
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
 _raw_spin_lock_irq+0x2d/0x40 kernel/locking/spinlock.c:167
 do_wait_for_common kernel/sched/completion.c:86 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion_timeout+0x172/0x280 kernel/sched/completion.c:157
 ath9k_htc_wait_for_target.isra.0+0xb9/0x1b0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:89
 ath9k_htc_probe_device+0x1a4/0x1da0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:949
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x274/0x510 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:1005
 process_one_work+0x965/0x1630 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x326/0x430 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
