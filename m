Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1378813CA6E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAORJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:09:13 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:52651 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgAORJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:09:13 -0500
Received: by mail-il1-f198.google.com with SMTP id n9so13884845ilm.19
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 09:09:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Qbzb5A9NTIdexzU3+GDyxXanOmczlUCSWJ+llDlUeKE=;
        b=G3mSJRmR2KQnlNdWzQ7PPjudZlz24C3WU0li5s3XnER4n3eEP81RdGAV84ug0cSQGw
         qA52zJg244QvgW39JxW1wHcPE9qiQ5QlcAngJ20PEllx40vRMRCXBtwNR1tuZMtftKtZ
         3oNUsVBRAZRuyVIDw9MAUhqtzrJ3Vdak2nkdlwcyHp3lbwmJYRAkcLvYVP4uNK9NCQxy
         t1oGZFLQDuFfT6lPCOMCziUlR2/0VxWftT6pWkUVmBbLL5U2xZ+cXd9dDLRTA12m0dZo
         MZDeOqwfMhL+g3STK0sdqSLj2ylTULhbXFGku9mSNGtKoOBeIyeDNKZ4mPsNv7jMCZo1
         iyew==
X-Gm-Message-State: APjAAAUTMkFIqUDBVb4ca1gUvVJQknSCGXobPSxGWWJeRIY5f2SmR7n6
        pm+ftlSt8LOuMPOr6dTv0JkvOM0I+8N4ku1nO8PBtw9L3JOG
X-Google-Smtp-Source: APXvYqzgkin2QCBDKr+TM7mcvH98bIkCbsyiNGMto6b1TNj7A+Aq/twS6IkaV5fRkY2Wzhc/j9ccf9Q1q6yftx8JhzxOKT0o2ns9
MIME-Version: 1.0
X-Received: by 2002:a02:2446:: with SMTP id q6mr23887453jae.78.1579108152572;
 Wed, 15 Jan 2020 09:09:12 -0800 (PST)
Date:   Wed, 15 Jan 2020 09:09:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f03ed059c30c4a0@google.com>
Subject: KASAN: use-after-free Read in rds_inc_put (2)
From:   syzbot <syzbot+8a25042506b5a9f010cd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    95e20af9 Merge tag 'nfs-for-5.5-2' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=119575e1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=8a25042506b5a9f010cd
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8a25042506b5a9f010cd@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rds_inc_put+0x19e/0x1b0 net/rds/recv.c:82
Read of size 8 at addr ffff8880a8dd6650 by task syz-executor.5/9920

CPU: 1 PID: 9920 Comm: syz-executor.5 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:135
  rds_inc_put+0x19e/0x1b0 net/rds/recv.c:82
  rds_clear_recv_queue+0x157/0x380 net/rds/recv.c:770
  rds_release+0x117/0x430 net/rds/af_rds.c:73
  __sock_release+0xce/0x280 net/socket.c:592
  sock_close+0x1e/0x30 net/socket.c:1270
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0xba9/0x2f50 kernel/exit.c:801
  do_group_exit+0x135/0x360 kernel/exit.c:899
  get_signal+0x47c/0x24f0 kernel/signal.c:2734
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:352 [inline]
  do_fast_syscall_32+0xbbd/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f49a39
Code: Bad RIP value.
RSP: 002b:00000000f5d2412c EFLAGS: 00000292 ORIG_RAX: 00000000000000f0
RAX: fffffffffffffe00 RBX: 000000000817aff8 RCX: 0000000000000080
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000817affc
RBP: 00000000f5d24228 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 25007:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:521
  slab_post_alloc_hook mm/slab.h:584 [inline]
  slab_alloc mm/slab.c:3320 [inline]
  kmem_cache_alloc+0x121/0x710 mm/slab.c:3484
  kmem_cache_zalloc include/linux/slab.h:660 [inline]
  __rds_conn_create+0x63a/0x20a0 net/rds/connection.c:193
  rds_conn_create_outgoing+0x4b/0x60 net/rds/connection.c:351
  rds_sendmsg+0x19a4/0x35b0 net/rds/send.c:1294
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __compat_sys_sendmsg net/compat.c:642 [inline]
  __do_compat_sys_sendmsg net/compat.c:649 [inline]
  __se_compat_sys_sendmsg net/compat.c:646 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139

Freed by task 72:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:335 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
  __cache_free mm/slab.c:3426 [inline]
  kmem_cache_free+0x86/0x320 mm/slab.c:3694
  rds_conn_destroy+0x61f/0x880 net/rds/connection.c:501
  rds_loop_kill_conns net/rds/loop.c:213 [inline]
  rds_loop_exit_net+0x2fc/0x4a0 net/rds/loop.c:219
  ops_exit_list.isra.0+0xb1/0x160 net/core/net_namespace.c:172
  cleanup_net+0x538/0xaf0 net/core/net_namespace.c:597
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a8dd6608
  which belongs to the cache rds_connection of size 232
The buggy address is located 72 bytes inside of
  232-byte region [ffff8880a8dd6608, ffff8880a8dd66f0)
The buggy address belongs to the page:
page:ffffea0002a37580 refcount:1 mapcount:0 mapping:ffff8880a8eec380  
index:0xffff8880a8dd6e20
raw: 00fffe0000000200 ffff8880a86c8938 ffffea000292e348 ffff8880a8eec380
raw: ffff8880a8dd6e20 ffff8880a8dd6040 000000010000000b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a8dd6500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880a8dd6580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
> ffff8880a8dd6600: fc fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                  ^
  ffff8880a8dd6680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
  ffff8880a8dd6700: fc fc fc fc fc fc 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
