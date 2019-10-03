Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E3EC9830
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 08:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfJCGSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 02:18:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35060 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfJCGSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 02:18:08 -0400
Received: by mail-io1-f70.google.com with SMTP id r5so3600364iop.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 23:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gBSQkU41ZLVR6bUYLDQYs/WhgJL7Xhhm/K97Y0QyX7E=;
        b=qFctfN/ozTKCZ96g38eIbFglkIIrfZ90WQsO0kv61KpqwWDeFE8A86/hVK9FC8IMfU
         S2jhlo8Y5EpYB1FsTZBlBjrUc2muE8zNxMfo/ytpfk82f9+M1ttbar/VHVGzXny/OoEo
         EcX08cW/mj7nV618iiqC+fzvvZOaxRYpvq2tvkYM+kAUr0RLcqdSrmwhECjUuOsyH7I4
         l7e14r4/EdEWDr31/Vxut8Kfbdgrk80SH+Ha8oPTzC/KCDSF4OWiPPGOuM02g8/dCeKO
         kqw9WaMZ4z/qJTO/p5kptgcxMiIndFFdKpekC0d6tv8J+dSOea91093ALBHLPSrX5o+D
         4NkA==
X-Gm-Message-State: APjAAAX7TXjuPNsTPaL730CpLdk6ZO7yE8dt1RMArR9q5rSNXplA9wTe
        ScwW3Rc7Oe+VXB+xENgPV2cq9b5Pu7Dhv0sbjW1owA6xGA3o
X-Google-Smtp-Source: APXvYqyPWsGmsYzObJIZ/MF2L7Heo9bZifiycB3TxiMa7aWNjl+XOaK6BJwyXu6fx7wFW6GAnxH7ZgGG9qebcGQrUaRJ34hGrI0T
MIME-Version: 1.0
X-Received: by 2002:a02:1cc5:: with SMTP id c188mr8051949jac.26.1570083487128;
 Wed, 02 Oct 2019 23:18:07 -0700 (PDT)
Date:   Wed, 02 Oct 2019 23:18:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084a5a10593fb8c3f@google.com>
Subject: KASAN: use-after-free Read in rds_inc_put
From:   syzbot <syzbot+322126673a98080e677f@syzkaller.appspotmail.com>
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

HEAD commit:    a32db7e1 Add linux-next specific files for 20191002
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10ff857b600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=599cf05035799eef
dashboard link: https://syzkaller.appspot.com/bug?extid=322126673a98080e677f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+322126673a98080e677f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in rds_inc_put+0x141/0x150 net/rds/recv.c:82
Read of size 8 at addr ffff88806f5371b0 by task syz-executor.0/18418

CPU: 1 PID: 18418 Comm: syz-executor.0 Not tainted 5.4.0-rc1-next-20191002  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  rds_inc_put+0x141/0x150 net/rds/recv.c:82
  rds_clear_recv_queue+0x157/0x380 net/rds/recv.c:770
  rds_release+0x117/0x3d0 net/rds/af_rds.c:73
  __sock_release+0xce/0x280 net/socket.c:591
  sock_close+0x1e/0x30 net/socket.c:1269
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x904/0x2e60 kernel/exit.c:817
  do_group_exit+0x135/0x360 kernel/exit.c:921
  get_signal+0x47c/0x2500 kernel/signal.c:2734
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459a29
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4088663cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000075bf28 RCX: 0000000000459a29
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000075bf28
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf2c
R13: 00007ffe10e1ad8f R14: 00007f40886649c0 R15: 000000000075bf2c

Allocated by task 12004:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:518
  slab_post_alloc_hook mm/slab.h:584 [inline]
  slab_alloc mm/slab.c:3319 [inline]
  kmem_cache_alloc+0x121/0x710 mm/slab.c:3483
  kmem_cache_zalloc include/linux/slab.h:680 [inline]
  __rds_conn_create+0x63f/0x20b0 net/rds/connection.c:193
  rds_conn_create_outgoing+0x4b/0x60 net/rds/connection.c:351
  rds_sendmsg+0x19a4/0x35b0 net/rds/send.c:1294
  sock_sendmsg_nosec net/socket.c:638 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:658
  __sys_sendto+0x262/0x380 net/socket.c:1953
  __do_sys_sendto net/socket.c:1965 [inline]
  __se_sys_sendto net/socket.c:1961 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1961
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9330:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kmem_cache_free+0x86/0x320 mm/slab.c:3693
  rds_conn_destroy+0x61f/0x880 net/rds/connection.c:501
  rds_loop_kill_conns net/rds/loop.c:213 [inline]
  rds_loop_exit_net+0x2fc/0x4a0 net/rds/loop.c:219
  ops_exit_list.isra.0+0xaa/0x150 net/core/net_namespace.c:172
  cleanup_net+0x4e2/0xa60 net/core/net_namespace.c:594
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88806f537168
  which belongs to the cache rds_connection of size 232
The buggy address is located 72 bytes inside of
  232-byte region [ffff88806f537168, ffff88806f537250)
The buggy address belongs to the page:
page:ffffea0001bd4dc0 refcount:1 mapcount:0 mapping:ffff88809bcbd1c0  
index:0xffff88806f537608
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffff88809bcfb338 ffffea00026b0248 ffff88809bcbd1c0
raw: ffff88806f537608 ffff88806f537040 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88806f537080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88806f537100: 00 00 00 00 00 fc fc fc fc fc fc fc fc fb fb fb
> ffff88806f537180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                      ^
  ffff88806f537200: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
  ffff88806f537280: fc fc fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
