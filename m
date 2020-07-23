Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADEC22B1FE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgGWO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:58:20 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:50235 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbgGWO6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:58:20 -0400
Received: by mail-io1-f70.google.com with SMTP id a6so3311616ioh.17
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q0ZgbO8GtEdRvyw0bvEo/jdDk4UK/gOhQSqxnTvxDlY=;
        b=fxn7Q8Sz3lrpR4cYsPHJF+L3cmgHNblO2SSfVSdgJ74WNX/9zKkG171YAYjSoiAgvt
         hmVubMeHoCCqEH85CzgpgZvPghg38Sdh+ajwvcpsurEhh7wnhUWsBBvAreL/j4iVzAYa
         ZwMnLnLe4ISUYNpWswjzSpm9Vqq1qCXjrYDNetzeq7pJ2g03cira3Db9ppz/QISkdntQ
         43e6dumkcGf7gk70UxYGNCrtuZJShE8yaqHXM1ICvxsz0mOzExF2aDIq12BG9qin/ElZ
         zXHVDHFbu1auzjWtMxfOpoELsXeOmss3gZCpzAoJvxCjc+F22oVzfmtdGl/CgyJihYlq
         ljBA==
X-Gm-Message-State: AOAM5330abZtnHO7g0M9OwfMp/+1u9Sbk4J5dN3+K1lhfJ+fdchTyJJM
        v5/fQ955Npl4j1gsVNJcE5XJYd+7XtgqNDcBFvAQQ8LbmqfU
X-Google-Smtp-Source: ABdhPJzAyr0kLVrsIFlIh+xfzSOeLGJMby+IHsn67Qpw5oskvBlvabl8WnqjAzC997yhpPzRONnjCGQiLFs7cauEBKQUOZJlkZR5
MIME-Version: 1.0
X-Received: by 2002:a5e:8a03:: with SMTP id d3mr5434141iok.38.1595516298417;
 Thu, 23 Jul 2020 07:58:18 -0700 (PDT)
Date:   Thu, 23 Jul 2020 07:58:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033616805ab1d16a2@google.com>
Subject: KASAN: slab-out-of-bounds Read in sock_def_write_space
From:   syzbot <syzbot+81195db9708feb4a4c51@syzkaller.appspotmail.com>
To:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        navid.emamdoost@gmail.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d15be546 Merge tag 'media/v5.8-3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=160cb130900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f87a5e4232fdb267
dashboard link: https://syzkaller.appspot.com/bug?extid=81195db9708feb4a4c51
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81195db9708feb4a4c51@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __lock_acquire+0x3c7b/0x56e0 kernel/locking/lockdep.c:4250
Read of size 8 at addr ffff88805316dad8 by task syz-executor.2/12672

CPU: 0 PID: 12672 Comm: syz-executor.2 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __lock_acquire+0x3c7b/0x56e0 kernel/locking/lockdep.c:4250
 lock_acquire+0x1f1/0xad0 kernel/locking/lockdep.c:4959
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xc0 kernel/locking/spinlock.c:159
 __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122
 sock_def_write_space+0x1fd/0x630 net/core/sock.c:2927
 sock_wfree+0x1cc/0x240 net/core/sock.c:2060
 skb_release_head_state+0x9f/0x250 net/core/skbuff.c:651
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb net/core/skbuff.c:678 [inline]
 kfree_skb.part.0+0x89/0x350 net/core/skbuff.c:696
 kfree_skb+0x7d/0x100 include/linux/refcount.h:270
 skb_queue_purge+0x14/0x30 net/core/skbuff.c:3077
 qrtr_tun_release+0x40/0x60 net/qrtr/tun.c:118
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb72/0x2a40 kernel/exit.c:805
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 do_signal+0x82/0x2520 arch/x86/kernel/signal.c:810
 exit_to_usermode_loop arch/x86/entry/common.c:235 [inline]
 __prepare_exit_to_usermode+0x156/0x1f0 arch/x86/entry/common.c:269
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f7a9ccc8cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000078bf08 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000078bf08
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffc40009e7f R14: 00007f7a9ccc99c0 R15: 000000000078bf0c

Allocated by task 27975:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc mm/slab.c:3320 [inline]
 kmem_cache_alloc+0x12c/0x3b0 mm/slab.c:3484
 kmem_cache_zalloc include/linux/slab.h:659 [inline]
 alloc_buffer_head+0x20/0x140 fs/buffer.c:3346
 alloc_page_buffers+0x167/0x590 fs/buffer.c:857
 create_empty_buffers+0x2c/0x820 fs/buffer.c:1562
 ext4_block_write_begin+0x10c2/0x1410 fs/ext4/inode.c:1042
 ext4_da_write_begin+0x3e4/0x11d0 fs/ext4/inode.c:2997
 generic_perform_write+0x20a/0x4f0 mm/filemap.c:3318
 ext4_buffered_write_iter+0x235/0x4a0 fs/ext4/file.c:270
 ext4_file_write_iter+0x1f3/0x13d0 fs/ext4/file.c:655
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:503
 vfs_write+0x59d/0x6b0 fs/read_write.c:578
 ksys_write+0x12d/0x250 fs/read_write.c:631
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88805316d9f8
 which belongs to the cache buffer_head of size 168
The buggy address is located 56 bytes to the right of
 168-byte region [ffff88805316d9f8, ffff88805316daa0)
The buggy address belongs to the page:
page:ffffea00014c5b40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00014c2288 ffffea000216da08 ffff88821bc46e00
raw: 0000000000000000 ffff88805316d000 0000000100000011 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88805316d980: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc 00
 ffff88805316da00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88805316da80: 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00 00
                                                    ^
 ffff88805316db00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88805316db80: 00 fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
