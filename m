Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE5CBE2EB
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437796AbfIYQ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 12:56:10 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36513 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392155AbfIYQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 12:56:09 -0400
Received: by mail-io1-f71.google.com with SMTP id g126so626314iof.3
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 09:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5EmqL+of08xAVfukGFLBL9/jaJmIT9fADYg1gtcGy8Y=;
        b=TSzw2mHs4Q+gPM0nBGW14U/aPK4jtHKIM34bL2KOHcTjmV40nKIOJW66LtN2S7hyAV
         2rv+QIhKSjOEnCL9j3DN3c87JshVNjFExauuCsTNT2CaTNd3zzinahI7NkU7AgPGiVt+
         0kMwwz0ioX+Dw480wrrLgz//GRqXfiDpbcdhNgqTDXrt6NugUkoLL8sqwkeYVB1iUtfl
         /Z+CKM1iGO2u6o3UblODJVk2ZCYffI0eLP3nuLElLZ+xkmnv2G+u7deW0Dw7AvFqNNIp
         7aCaU69n2eYFTOsAzhVbScSVIfnL/lrXaQZDvzrqoJQoXS0iSoEa5ma2c6M6ZSALMFNv
         B/dg==
X-Gm-Message-State: APjAAAWZHw5u0x4CWAujE1A+0n70gh2bC08ZRiS6HZl0Ohf1XFc2OZGv
        mWB4qXr9MHo+2S0SLU9Lgndb1iEwRFZW6QZXPySEonefxW7S
X-Google-Smtp-Source: APXvYqwNXm4kV7k3ZsR/VKlW8vmlLlfW9GPPWk8o0ifNIN8kRArQgOR0J5o4qxHkIFz3JlbSYLrMb1gW5hw4KdWQ+L4LFfPObMvu
MIME-Version: 1.0
X-Received: by 2002:a92:1a4f:: with SMTP id z15mr1196176ill.199.1569430567717;
 Wed, 25 Sep 2019 09:56:07 -0700 (PDT)
Date:   Wed, 25 Sep 2019 09:56:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d2bf605936387c5@google.com>
Subject: KASAN: use-after-free Read in move_expired_inodes
From:   syzbot <syzbot+8c1cf49d27ac637b47c0@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b41dae06 Merge tag 'xfs-5.4-merge-7' of git://git.kernel.o..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135e0ee3600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dfcf592db22b9132
dashboard link: https://syzkaller.appspot.com/bug?extid=8c1cf49d27ac637b47c0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8c1cf49d27ac637b47c0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in move_expired_inodes+0x8c8/0x9c0  
fs/fs-writeback.c:1241
Read of size 8 at addr ffff88805929a868 by task kworker/u4:8/10864

CPU: 1 PID: 10864 Comm: kworker/u4:8 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: writeback wb_workfn (flush-8:0)
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:618
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  move_expired_inodes+0x8c8/0x9c0 fs/fs-writeback.c:1241
  queue_io+0x1c5/0x590 fs/fs-writeback.c:1290
  wb_writeback+0xa99/0xd90 fs/fs-writeback.c:1882
  wb_check_start_all fs/fs-writeback.c:2010 [inline]
  wb_do_writeback fs/fs-writeback.c:2036 [inline]
  wb_workfn+0xb0e/0x11e0 fs/fs-writeback.c:2070
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 21365:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:493 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:466
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:501
  slab_post_alloc_hook mm/slab.h:520 [inline]
  slab_alloc mm/slab.c:3319 [inline]
  kmem_cache_alloc+0x121/0x710 mm/slab.c:3483
  ext4_alloc_inode+0x1f/0x640 fs/ext4/super.c:1073
  alloc_inode+0x68/0x1e0 fs/inode.c:227
  new_inode_pseudo+0x19/0xf0 fs/inode.c:916
  new_inode+0x1f/0x40 fs/inode.c:945
  __ext4_new_inode+0x3d5/0x4e50 fs/ext4/ialloc.c:829
  ext4_create+0x236/0x5e0 fs/ext4/namei.c:2587
  lookup_open+0x12be/0x1a50 fs/namei.c:3224
  do_last fs/namei.c:3314 [inline]
  path_openat+0x14ac/0x4630 fs/namei.c:3525
  do_filp_open+0x1a1/0x280 fs/namei.c:3555
  do_sys_open+0x3fe/0x5d0 fs/open.c:1089
  __do_sys_openat fs/open.c:1116 [inline]
  __se_sys_openat fs/open.c:1110 [inline]
  __x64_sys_openat+0x9d/0x100 fs/open.c:1110
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 21405:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:455
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:463
  __cache_free mm/slab.c:3425 [inline]
  kmem_cache_free+0x86/0x320 mm/slab.c:3693
  ext4_free_in_core_inode+0x28/0x30 fs/ext4/super.c:1120
  i_callback+0x44/0x80 fs/inode.c:216
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2157 [inline]
  rcu_core+0x581/0x1560 kernel/rcu/tree.c:2377
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2386
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff88805929a500
  which belongs to the cache ext4_inode_cache(33:syz2) of size 2000
The buggy address is located 872 bytes inside of
  2000-byte region [ffff88805929a500, ffff88805929acd0)
The buggy address belongs to the page:
page:ffffea000164a680 refcount:1 mapcount:0 mapping:ffff88809b51f8c0  
index:0xffff88805929afff
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00016446c8 ffffea00028cc3c8 ffff88809b51f8c0
raw: ffff88805929afff ffff88805929a500 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88805929a700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805929a780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88805929a800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                           ^
  ffff88805929a880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805929a900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
