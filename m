Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B89A2F490B
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbhAMKzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:55:08 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:47225 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbhAMKzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 05:55:07 -0500
Received: by mail-io1-f72.google.com with SMTP id q21so2174247ios.14
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 02:54:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pN8xDEE5xQjbgKTdp2157QdrIzHjJq1F8I0UZYWoDaY=;
        b=jCLW4GR9q8M8ubBFP75rqdIltSD5OI100YL+uh9uvNBOaOesNU71BbEL+9sGrRpFO0
         dB4eVQeFXiMmti++s9/OHHbLtvaHmiiXQiKRzQxu80hHoVCYv0OBljmCCjwSOcmHp3xA
         zTreSKsZ9r7J/Qr3iH3OFBsJduQ06i1M1VmDcQBSuyiy3AxKjKI96HvhnZjKzlWUSN/L
         /S7hsP3t8waYpzOOaZzI/QYgJF7D82E3nasbxBwp5rgcFlsszzycgOF+DfeeuNm7Zt/e
         M6kSVSq0RC2TYp1HqgtTRPUuzOWRM9gz9e5gEstH7LYAjzi7Sa2xw6+EJXA4P62FntHX
         nMgw==
X-Gm-Message-State: AOAM531VL92lphm4e+eL+WghS6OpGf1Ppv+dFH1zwOn5WurCDjL2h/zR
        PdR/63+g6JttfNAUBn6Ff6H7KeTNiJuWXozJwQMDF8KO6aI/
X-Google-Smtp-Source: ABdhPJzs5GOx/1dTa36RqPdyycvkHmXYVB7jXGp9xyAhp/E1czJKyaX0c0LyMRFkimIcl048Zv+iv2xX4Jl2MEO0wRlDGh9KybnQ
MIME-Version: 1.0
X-Received: by 2002:a6b:8d0f:: with SMTP id p15mr1247538iod.56.1610535266418;
 Wed, 13 Jan 2021 02:54:26 -0800 (PST)
Date:   Wed, 13 Jan 2021 02:54:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000074026d05b8c5f676@google.com>
Subject: KASAN: use-after-free Read in skb_release_head_state
From:   syzbot <syzbot+60c13361d933487eed83@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    996e435f Merge tag 'zonefs-5.11-rc3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149f3770d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bacfc914704718d3
dashboard link: https://syzkaller.appspot.com/bug?extid=60c13361d933487eed83
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60c13361d933487eed83@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in skb_dst_drop include/net/dst.h:269 [inline]
BUG: KASAN: use-after-free in skb_release_head_state+0x223/0x250 net/core/skbuff.c:653
Read of size 8 at addr ffff888020b57a58 by task syz-executor.3/23125

CPU: 0 PID: 23125 Comm: syz-executor.3 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 skb_dst_drop include/net/dst.h:269 [inline]
 skb_release_head_state+0x223/0x250 net/core/skbuff.c:653
 skb_release_all net/core/skbuff.c:667 [inline]
 __kfree_skb net/core/skbuff.c:683 [inline]
 kfree_skb net/core/skbuff.c:701 [inline]
 kfree_skb+0xfa/0x3f0 net/core/skbuff.c:695
 hci_dev_do_open+0xa4a/0x1a00 net/bluetooth/hci_core.c:1619
 hci_dev_open+0x132/0x300 net/bluetooth/hci_core.c:1685
 hci_sock_ioctl+0x5b6/0x840 net/bluetooth/hci_sock.c:1025
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1037
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e087
Code: 48 83 c4 08 48 89 d8 5b 5d c3 66 0f 1f 84 00 00 00 00 00 48 89 e8 48 f7 d8 48 39 c3 0f 92 c0 eb 92 66 90 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 6d b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff4e2da0d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e087
RDX: 0000000000000000 RSI: 00000000400448c9 RDI: 0000000000000003
RBP: 00007fff4e2da0f0 R08: 0000000000000000 R09: 00007fd7d2806700
R10: 00007fd7d28069d0 R11: 0000000000000246 R12: 0000000002df8914
R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8520:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
 kasan_slab_alloc include/linux/kasan.h:205 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 slab_alloc mm/slub.c:2899 [inline]
 kmem_cache_alloc+0x1c6/0x440 mm/slub.c:2904
 skb_clone+0x14f/0x3c0 net/core/skbuff.c:1449
 hci_cmd_work+0x18f/0x390 net/bluetooth/hci_core.c:5007
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Freed by task 8519:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:356
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:362
 kasan_slab_free include/linux/kasan.h:188 [inline]
 slab_free_hook mm/slub.c:1547 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1580
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:627
 __kfree_skb net/core/skbuff.c:684 [inline]
 kfree_skb net/core/skbuff.c:701 [inline]
 kfree_skb+0x140/0x3f0 net/core/skbuff.c:695
 hci_cmd_work+0x182/0x390 net/bluetooth/hci_core.c:5005
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff888020b57a00
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 88 bytes inside of
 232-byte region [ffff888020b57a00, ffff888020b57ae8)
The buggy address belongs to the page:
page:00000000508c5c1a refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888020b57140 pfn:0x20b57
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00008b8b88 ffffea000098cd48 ffff888010e75640
raw: ffff888020b57140 00000000000c000b 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888020b57900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888020b57980: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
>ffff888020b57a00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888020b57a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
 ffff888020b57b00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
