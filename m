Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF3C10259C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfKSNk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:40:56 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:47009 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:40:56 -0500
Received: by mail-pj1-f66.google.com with SMTP id a16so2670686pjs.13
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 05:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8pE8pPkHkDDLt3QigEfCxoiBA949a7luPGzhbzhkI8E=;
        b=J3EQbUz3UlT7bDooirHZ0kCufikX3d3TZJjTS5WunWoT4SnMtg7rjpXYFNnMAFrjge
         2TBI5xp6AjPS70M1xrVel+xlMr6XLnw3OEI1jft40g+MyR3TByFgOHV1E3d+mx3WMOl3
         vFZxBav8Wlole8vtayznoAWir5K48IFtZ7NA6HNPyxZJ06yKRfcux9VM6yTBG34Ax9ze
         ti8YdQxJ1MeNN3ll1JKQtMMuXObzPry6yMKtWF9ZCAeCqhPrjpOnTdiN9l/O4QOKI161
         VvUgCRDAH0Gnu2wtsNX+DnutAMf6lWaZTlITHnGc41PjgaT5e4/gGAGlJ0hhmjuSqJVn
         jlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8pE8pPkHkDDLt3QigEfCxoiBA949a7luPGzhbzhkI8E=;
        b=Vuud7fBBkX+tayZcOcXrkH+Y4W/gazxfcGVjYzMX1hUzi1Zy57Piv7mqxOW5k6CQXz
         t91hZPS4PAjaopw2WfrUXf9WNSFA6V3Lp6fjPs0awnShB6gGOOCxGnjmz4hr/w5YHv20
         wZXRWfRWOQK2b4M5T7UQLe8OwiTli9242Lj7BE6H+ZHbihoQz35RVuR3aLpkJtcc5J5p
         Lc6pHWZipDEpYRmadOnquUBj5t7qLgiXllg7Nwcv4z1nEx0fD+6MBvzmANBAvyv8BorQ
         U38OGMOeT8uoyHjzfaPvNlug4BcvX++CQyfgNzQEy+AS9vEhOhU9sXyESv/t/WTZFqaa
         DgZg==
X-Gm-Message-State: APjAAAVyQ1LIEooqrWay7nGeokj7T3j1CQE+Sm5CzzIaE+3egO83BQXt
        0P+zFf3LBbOL8Yzm5uMT8jQ0sa1IZfpFv0+C7bZUlQ==
X-Google-Smtp-Source: APXvYqwFXOSBIQi6BDrDLOlhUUYL/kCooazHhgSGB/efL9ax/Op0/j0hQdhssBB/UyJ5k3mlBTO7Y9NYE1s2U4JDgUo=
X-Received: by 2002:a17:90a:35d0:: with SMTP id r74mr6527470pjb.47.1574170855102;
 Tue, 19 Nov 2019 05:40:55 -0800 (PST)
MIME-Version: 1.0
References: <000000000000caab290588c4083e@google.com>
In-Reply-To: <000000000000caab290588c4083e@google.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 19 Nov 2019 14:40:42 +0100
Message-ID: <CAAeHK+wPRC7BFG4_p3jy6d00ahAK2g4Yb_2JtD2MO_3Q8BPp8A@mail.gmail.com>
Subject: Re: general protection fault in drain_workqueue
To:     syzbot <syzbot+09139d1a5ed6b898e29d@syzkaller.appspotmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, petkan@nucleusys.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 2:27 PM syzbot
<syzbot+09139d1a5ed6b898e29d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=17022474a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
> dashboard link: https://syzkaller.appspot.com/bug?extid=09139d1a5ed6b898e29d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15752dc8a00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+09139d1a5ed6b898e29d@syzkaller.appspotmail.com
>
> pegasus 4-1:0.103: can't reset MAC
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN PTI
> CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.1.0-rc3-319004-g43151d6 #6
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:__lock_acquire+0xadc/0x37c0 kernel/locking/lockdep.c:3573
> Code: 00 0f 85 c1 1d 00 00 48 81 c4 10 01 00 00 5b 5d 41 5c 41 5d 41 5e 41
> 5f c3 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f
> 85 35 1e 00 00 49 81 7d 00 00 19 01 96 0f 84 e8 f5
> RSP: 0018:ffff8880a8476e08 EFLAGS: 00010002
> RAX: dffffc0000000000 RBX: ffff8880a8469880 RCX: 0000000000000000
> RDX: 0000000000000010 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> R10: ffff8880a8477160 R11: ffff8880a8469880 R12: 0000000000000000
> R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3a1f740000 CR3: 0000000090bc0000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   lock_acquire+0x10d/0x2f0 kernel/locking/lockdep.c:4211
>   __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>   __mutex_lock+0xfe/0x12b0 kernel/locking/mutex.c:1072
>   drain_workqueue+0x29/0x470 kernel/workqueue.c:2934
>   destroy_workqueue+0x23/0x6d0 kernel/workqueue.c:4320
>   pegasus_dec_workqueue drivers/net/usb/pegasus.c:1133 [inline]
>   pegasus_dec_workqueue drivers/net/usb/pegasus.c:1129 [inline]
>   pegasus_probe+0x1073/0x15e0 drivers/net/usb/pegasus.c:1228
>   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2023
>   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
>   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
>   really_probe+0x2da/0xb10 drivers/base/dd.c:509
>   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
>   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
>   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
>   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
>   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
>   device_add+0xad2/0x16e0 drivers/base/core.c:2106
>   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
>   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
>   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
>   port_event drivers/usb/core/hub.c:5350 [inline]
>   hub_event+0x138e/0x3b00 drivers/usb/core/hub.c:5432
>   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
>   process_scheduled_works kernel/workqueue.c:2331 [inline]
>   worker_thread+0x7b0/0xe20 kernel/workqueue.c:2417
>   kthread+0x313/0x420 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
> Modules linked in:
> ---[ end trace 01015c397d4bdcc4 ]---
> RIP: 0010:__lock_acquire+0xadc/0x37c0 kernel/locking/lockdep.c:3573
> Code: 00 0f 85 c1 1d 00 00 48 81 c4 10 01 00 00 5b 5d 41 5c 41 5d 41 5e 41
> 5f c3 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f
> 85 35 1e 00 00 49 81 7d 00 00 19 01 96 0f 84 e8 f5
> RSP: 0018:ffff8880a8476e08 EFLAGS: 00010002
> RAX: dffffc0000000000 RBX: ffff8880a8469880 RCX: 0000000000000000
> RDX: 0000000000000010 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> R10: ffff8880a8477160 R11: ffff8880a8469880 R12: 0000000000000000
> R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880ad000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3a1f740000 CR3: 0000000090bc0000 CR4: 00000000001406f0
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

Hasn't happened for a while, probably got fixed.

#syz invalid
