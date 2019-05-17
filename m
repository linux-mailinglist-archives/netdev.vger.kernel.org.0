Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442AB21D8A
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfEQSkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:40:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52460 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbfEQSkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:40:06 -0400
Received: by mail-io1-f71.google.com with SMTP id n82so6075870iod.19
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 11:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pc1ZOBiodFIfLl7ABdn3nfhRF80uG71nN0Nl/mP40/8=;
        b=j7JwcRnTbBW89ca/zp07ccGz9fayaLXxZNIa+wxwQxGP6Idru+svaAQQKZ4dZKrGqK
         8HtNgiacYGwfNgYw9YtAbMLvg3VF/lAEbX64eP+VnbGJD1deIX5SONBOxs7mifRWoyyc
         2CZRy6MPYQ2KQxYMF8RC3bQ/B9R0UARMnDxl4qMPITeeMD+hdeIvmZqH44v0VcV9M0XT
         8J7LamzKWVncrWt4WIxaAmxBX5hSJdwyiJYwUm0sD/B5rvM7zsjm0TLtO+3yciSRFT/f
         D89KpDZ9Z5kCp4raAJ8DS4JnOGKxI4nQvFjFFPj5RwbiEvCnbKEwLIckb6hGwqEd8BhE
         YB3w==
X-Gm-Message-State: APjAAAXcG3IMAjxwf77yXaIAjnlqWT4Z0XTzdkW4LDPPBfIZZRcwl0xb
        VP93FGVgp7kz4Z47eZz5yM4b3NwEA7dkJXclwVuOouUhIS4p
X-Google-Smtp-Source: APXvYqzxE/lUYFkEPn8eDP8vQOgpONADWLlVB8PiA7iXhedwDuOUTG9Vwvb04G8sz0v8SNGbwD/Wbhgj0/bzO5YQG6J4+aOZCQty
MIME-Version: 1.0
X-Received: by 2002:a5e:8409:: with SMTP id h9mr3005977ioj.187.1558118405045;
 Fri, 17 May 2019 11:40:05 -0700 (PDT)
Date:   Fri, 17 May 2019 11:40:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d1491058919b662@google.com>
Subject: KASAN: use-after-free Read in tls_push_sg
From:   syzbot <syzbot+66fbe4719f6ef22754ee@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    35c99ffa Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10ff3322a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
dashboard link: https://syzkaller.appspot.com/bug?extid=66fbe4719f6ef22754ee
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+66fbe4719f6ef22754ee@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in tls_push_sg+0x5e2/0x680 net/tls/tls_main.c:139
Read of size 4 at addr ffff888066f4d584 by task syz-executor.1/28368

CPU: 0 PID: 28368 Comm: syz-executor.1 Not tainted 5.1.0+ #9
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
  tls_push_sg+0x5e2/0x680 net/tls/tls_main.c:139
  tls_push_partial_record net/tls/tls_main.c:208 [inline]
  tls_complete_pending_work include/net/tls.h:382 [inline]
  tls_sk_proto_close+0x4a8/0x780 net/tls/tls_main.c:282
  inet_release+0x105/0x1f0 net/ipv4/af_inet.c:432
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:474
  __sock_release+0xd3/0x2b0 net/socket.c:607
  sock_close+0x1b/0x30 net/socket.c:1279
  __fput+0x302/0x890 fs/file_table.c:279
  ____fput+0x16/0x20 fs/file_table.c:312
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:168
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x594/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x412b61
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 e4 1a 00 00 c3 48  
83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48  
89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fff8622b0f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000412b61
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: 00000000bb5eab81 R09: 00000000bb5eab85
R10: 00007fff8622b1d0 R11: 0000000000000293 R12: 000000000073c900
R13: 000000000073c900 R14: 00000000002190c3 R15: 000000000073bfac

Allocated by task 28369:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3690 [inline]
  __kmalloc+0x15c/0x740 mm/slab.c:3699
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:742 [inline]
  tls_get_rec+0x104/0x590 net/tls/tls_sw.c:322
  tls_sw_sendmsg+0xda5/0x17b0 net/tls/tls_sw.c:928
  inet_sendmsg+0x147/0x5e0 net/ipv4/af_inet.c:802
  sock_sendmsg_nosec net/socket.c:660 [inline]
  sock_sendmsg+0xf2/0x170 net/socket.c:671
  __sys_sendto+0x262/0x380 net/socket.c:1964
  __do_sys_sendto net/socket.c:1976 [inline]
  __se_sys_sendto net/socket.c:1972 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1972
  do_syscall_64+0x103/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 4964:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3462 [inline]
  kfree+0xcf/0x230 mm/slab.c:3785
  tls_tx_records+0x4c6/0x760 net/tls/tls_sw.c:408
  tx_work_handler+0xba/0xf0 net/tls/tls_sw.c:2150
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2268
  worker_thread+0x98/0xe40 kernel/workqueue.c:2414
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888066f4d280
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 772 bytes inside of
  2048-byte region [ffff888066f4d280, ffff888066f4da80)
The buggy address belongs to the page:
page:ffffea00019bd300 count:1 mapcount:0 mapping:ffff8880aa400c40 index:0x0  
compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002413588 ffffea0001aa2a08 ffff8880aa400c40
raw: 0000000000000000 ffff888066f4c180 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888066f4d480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888066f4d500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888066f4d580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff888066f4d600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888066f4d680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
