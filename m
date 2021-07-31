Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BBA3DC8E9
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhGaXY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 19:24:26 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35477 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhGaXYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 19:24:24 -0400
Received: by mail-io1-f70.google.com with SMTP id i10-20020a5e850a0000b029053ee90daa50so8557990ioj.2
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 16:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=b0eqpglLPImvUJ+g7sgJQ9riaNStRu/07p0XmihlFR0=;
        b=nsZd+cHt+J5WJ7cuFAhgHdQw7XJniFsz2IyqVEutP5Fb5Q/+FO/F5rc8JC/kNfKPWM
         Q9P0w32IfDAINdrJ8w1Xz8GRTLHcgegmdXa9zcqwzNzrsgt5PQw9r+GAR3LagpUvS8jb
         l9XP1OSR2N3lF3rCGTgwXlQIEMYKquzvmfM0HN3sXEXzILDmSjgPRr6QtSrmpJj1TAeW
         W7A38/o4O4HNVJ7VwJGM/L8itbyDejIWcHFE3uWhcRg2H64Jx3IeamHKvivBfng2FJm0
         5cvJNVgJ/6tn7o2b7W0EehwwMHR3fvlyem+WAJmOYpQoTvyaXA8IbmhVK05BlrIY2Hre
         +yXA==
X-Gm-Message-State: AOAM530GYsvgQXmyOlVcYZffmQTPx0XoEhz8NZhl/IQ1EBV+7xxRdlDU
        h7QrCIXUSZ1LFfFLPYqMErSIUGTec2wlIpOgUE0lRXvyqaWV
X-Google-Smtp-Source: ABdhPJxIQ8qiGxauZyMjuJdj67nwIWcQHBp9kt0BauLVZSrGGJHazfFHH33nrFfijtwQtwalPVmB1AMyro9tWKQHoC3qEWj2MH6U
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1646:: with SMTP id a6mr7931078jat.1.1627773856541;
 Sat, 31 Jul 2021 16:24:16 -0700 (PDT)
Date:   Sat, 31 Jul 2021 16:24:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e6ec705c873a2d3@google.com>
Subject: [syzbot] bpf test error: BUG: sleeping function called from invalid
 context in stack_depot_save
From:   syzbot <syzbot+698b7bcef78dd8162024@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f1fdee33f5b4 Merge branch 'sockmap fixes picked up by stre..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1661b4d4300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6da37c7627210105
dashboard link: https://syzkaller.appspot.com/bug?extid=698b7bcef78dd8162024
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+698b7bcef78dd8162024@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at mm/page_alloc.c:5167
in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 8427, name: syz-fuzzer
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffff8143f9ad>] copy_process+0x1dcd/0x74d0 kernel/fork.c:2061
softirqs last  enabled at (0): [<ffffffff8143f9ee>] copy_process+0x1e0e/0x74d0 kernel/fork.c:2065
softirqs last disabled at (0): [<0000000000000000>] 0x0
CPU: 1 PID: 8427 Comm: syz-fuzzer Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
 prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5167
 __alloc_pages+0x12f/0x500 mm/page_alloc.c:5363
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2433 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5301
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2793 [inline]
 __vmalloc_area_node mm/vmalloc.c:2863 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2966
 __vmalloc_node mm/vmalloc.c:3015 [inline]
 vzalloc+0x67/0x80 mm/vmalloc.c:3085
 n_tty_open+0x16/0x170 drivers/tty/n_tty.c:1848
 tty_ldisc_open+0x9b/0x110 drivers/tty/tty_ldisc.c:449
 tty_ldisc_setup+0x43/0x100 drivers/tty/tty_ldisc.c:766
 tty_init_dev.part.0+0x1f4/0x610 drivers/tty/tty_io.c:1453
 tty_init_dev include/linux/err.h:36 [inline]
 tty_open_by_driver drivers/tty/tty_io.c:2098 [inline]
 tty_open+0xb16/0x1000 drivers/tty/tty_io.c:2146
 chrdev_open+0x266/0x770 fs/char_dev.c:414
 do_dentry_open+0x4c8/0x11d0 fs/open.c:826
 do_open fs/namei.c:3374 [inline]
 path_openat+0x1c23/0x27f0 fs/namei.c:3507
 do_filp_open+0x1aa/0x400 fs/namei.c:3534
 do_sys_openat2+0x16d/0x420 fs/open.c:1204
 do_sys_open fs/open.c:1220 [inline]
 __do_sys_openat fs/open.c:1236 [inline]
 __se_sys_openat fs/open.c:1231 [inline]
 __x64_sys_openat+0x13f/0x1f0 fs/open.c:1231
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4af20a
Code: e8 3b 82 fb ff 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 4c 8b 54 24 28 4c 8b 44 24 30 4c 8b 4c 24 38 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 40 ff ff ff ff 48 c7 44 24 48
RSP: 002b:000000c0000df3f8 EFLAGS: 00000216 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000000c00001c000 RCX: 00000000004af20a
RDX: 0000000000000000 RSI: 000000c000165a80 RDI: ffffffffffffff9c
RBP: 000000c0000df470 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: 00000000000001a9
R13: 00000000000001a8 R14: 0000000000000200 R15: 000000c000337ea0
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
