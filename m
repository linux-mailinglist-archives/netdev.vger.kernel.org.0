Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914B71E7E7
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 07:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfEOF2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 01:28:06 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:53043 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEOF2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 01:28:06 -0400
Received: by mail-it1-f197.google.com with SMTP id 73so1330768itl.2
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 22:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xITO4LMjns8xgRj22LzdjFUrCDzUiFsmGkIMv5L+L3k=;
        b=JjwZO6czeccNJeFhpQUeMaRIwMWkydoWpDyYN1nDB2KfdgR7dsa1cE+B+R2OiIVZYq
         QTA1Zw08bTkyTKfApdym1g37/RGe+7MBaN8LeuYdE9Br/ccWZG1me9JUvTa6KKlsjIg6
         g9t0NQ/7CMJhYQH9lb8rMO99Mem1aYRMI8iHTpI9cchg33kpxfXGFUSawlIqWTSh6nrb
         1bvOZ1hS+Ro0Lcj3FuE3wIyuaiUXbCFUWy9jia/qMIsF870l0rYZkjzErQuXrupkzE2D
         o02sdpCjsf/T/9Fe/4j2/p27AIXUMF1oTzIp/Q1AMycUtsG+Omci/2MWEaGBJMmTT8hq
         7RNQ==
X-Gm-Message-State: APjAAAX2B/t8QYLDR1fn6rYzHetP1FbW0V0G05Xma3QpPUTbx/SL2lNI
        r6Dby2vzNVri7ZqQv9+mblMCyub6OYE80f6vZaO4a8DcdKSY
X-Google-Smtp-Source: APXvYqx84ozCvl1LtJXc2wNe4ICy9zxdQJD91pctT7S7DOsaKLc440ipX1NMnK0cQcLuzuVl7iOGisF0ocLsqELR8OMYk+vMvY9V
MIME-Version: 1.0
X-Received: by 2002:a24:dac7:: with SMTP id z190mr6331441itg.57.1557898084915;
 Tue, 14 May 2019 22:28:04 -0700 (PDT)
Date:   Tue, 14 May 2019 22:28:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f29ffd0588e669d4@google.com>
Subject: KASAN: use-after-free Read in timer_is_static_object (2)
From:   syzbot <syzbot+81215bf96c82318c7e74@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63863ee8 Merge tag 'gcc-plugins-v5.2-rc1' of ssh://gitolit..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=128b8d74a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=52ff73a1f6d0b441
dashboard link: https://syzkaller.appspot.com/bug?extid=81215bf96c82318c7e74
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+81215bf96c82318c7e74@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in timer_is_static_object+0x80/0x90  
kernel/time/timer.c:608
Read of size 8 at addr ffff8880a5e88da8 by task kworker/0:2/2851

CPU: 0 PID: 2851 Comm: kworker/0:2 Not tainted 5.1.0+ #7
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: pencrypt padata_serial_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  timer_is_static_object+0x80/0x90 kernel/time/timer.c:608
  debug_object_activate+0x298/0x4f0 lib/debugobjects.c:510
  debug_timer_activate kernel/time/timer.c:710 [inline]
  __mod_timer kernel/time/timer.c:1035 [inline]
  mod_timer kernel/time/timer.c:1096 [inline]
  add_timer+0x3c6/0x930 kernel/time/timer.c:1132
  __queue_delayed_work+0x1af/0x270 kernel/workqueue.c:1648
  queue_delayed_work_on+0x19a/0x200 kernel/workqueue.c:1673
  queue_delayed_work include/linux/workqueue.h:509 [inline]
  schedule_delayed_work include/linux/workqueue.h:610 [inline]
  tls_encrypt_done+0x44c/0x560 net/tls/tls_sw.c:477
  aead_request_complete include/crypto/internal/aead.h:75 [inline]
  pcrypt_aead_serial+0x7f/0xb0 crypto/pcrypt.c:123
  padata_serial_worker+0x2a8/0x4b0 kernel/padata.c:349
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2268
  worker_thread+0x98/0xe40 kernel/workqueue.c:2414
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 9310:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  kmem_cache_alloc_trace+0x151/0x760 mm/slab.c:3586
  kmalloc include/linux/slab.h:547 [inline]
  kzalloc include/linux/slab.h:742 [inline]
  tls_set_sw_offload+0x123e/0x1640 net/tls/tls_sw.c:2193
  do_tls_setsockopt_conf net/tls/tls_main.c:527 [inline]
  do_tls_setsockopt net/tls/tls_main.c:574 [inline]
  tls_setsockopt+0x7cd/0x8d0 net/tls/tls_main.c:593
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3130
  __sys_setsockopt+0x180/0x280 net/socket.c:2078
  __do_sys_setsockopt net/socket.c:2089 [inline]
  __se_sys_setsockopt net/socket.c:2086 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2086
  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9303:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3463 [inline]
  kfree+0xcf/0x230 mm/slab.c:3786
  tls_sw_free_resources_tx+0x3b3/0x6e0 net/tls/tls_sw.c:2100
  tls_sk_proto_close+0x5fa/0x780 net/tls/tls_main.c:289
  inet_release+0x105/0x1f0 net/ipv4/af_inet.c:432
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:474
  __sock_release+0xd3/0x2b0 net/socket.c:607
  sock_close+0x1b/0x30 net/socket.c:1279
  __fput+0x302/0x890 fs/file_table.c:279
  ____fput+0x16/0x20 fs/file_table.c:312
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:167
  prepare_exit_to_usermode arch/x86/entry/common.c:198 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:276 [inline]
  do_syscall_64+0x57e/0x670 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a5e88d00
  which belongs to the cache kmalloc-512 of size 512
The buggy address is located 168 bytes inside of
  512-byte region [ffff8880a5e88d00, ffff8880a5e88f00)
The buggy address belongs to the page:
page:ffffea000297a200 count:1 mapcount:0 mapping:ffff8880aa400940 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00012ac408 ffffea0002947608 ffff8880aa400940
raw: 0000000000000000 ffff8880a5e88080 0000000100000006 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a5e88c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a5e88d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880a5e88d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                   ^
  ffff8880a5e88e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a5e88e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
