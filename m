Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE67B2349D5
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733149AbgGaREZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:04:25 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44658 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbgGaREY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:04:24 -0400
Received: by mail-il1-f197.google.com with SMTP id y82so14767956ilk.11
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 10:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=T7yNAJOOUUV5ZW56bzSWmQNu1iWF/gosltU2CY3LEEI=;
        b=IwgVE6MAHMybejehr1iG4LlrTwbQVcIhIc9TWWGPfdW6EUTc26WEedDnBjulX5hOYb
         bR2qEyhg5SAxv+U+V/9f3rJyRJ2Cy6qA4/V0zq4T3M8kK27J7cqeKH2Da5/F1Gsr18Xy
         uqDJVpgsMr0XhiATVLrjIyVbDDRid1ML18EzDZhHo7zF+MqElPlOx4azxEhxjUjZ8rai
         cFHKntuStki56ytp30Jqga3q3X+2TNOtXIIPKSd3bs5tbQLS0Q+njtQtHqE9TN7CNUaD
         VMhev4eHnYqa4bmNxg75voWHGEQyqD/M06mvSTQC6vgXyALuAJhPC227/sA73EHl7y9w
         lwnA==
X-Gm-Message-State: AOAM533RhGdiaqwbr8ab8wY7LJak3Xst/uPTQbKO2ATqu2xpEn7bZRgJ
        5YxyMagUQnc5ZrgKU4NRgQ/f4ThokcX1q4ScOJemEe1/nnXz
X-Google-Smtp-Source: ABdhPJzIh8xpe2wBgjTQUAX8fa8pif8PvMzPZ11SRZSDkLOc+iOr47CV5TtNVRHPZ7xQL8t3zg/lVgUbaapqpDkcw4W3SQ0QuJQE
MIME-Version: 1.0
X-Received: by 2002:a02:3445:: with SMTP id z5mr5956432jaz.134.1596215062282;
 Fri, 31 Jul 2020 10:04:22 -0700 (PDT)
Date:   Fri, 31 Jul 2020 10:04:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5c9ad05abbfc71b@google.com>
Subject: KASAN: slab-out-of-bounds Read in qrtr_endpoint_post (2)
From:   syzbot <syzbot+1917d778024161609247@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    83bdc727 random32: remove net_rand_state from the latent e..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b2f56c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=1917d778024161609247
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ac9b60900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14256c5c900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1917d778024161609247@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in skb_put_data include/linux/skbuff.h:2260 [inline]
BUG: KASAN: slab-out-of-bounds in qrtr_endpoint_post+0x659/0x1150 net/qrtr/qrtr.c:492
Read of size 4294967294 at addr ffff8880a201b650 by task syz-executor462/6791

CPU: 1 PID: 6791 Comm: syz-executor462 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:183 [inline]
 check_memory_region+0x2b5/0x2f0 mm/kasan/generic.c:192
 memcpy+0x25/0x60 mm/kasan/common.c:105
 skb_put_data include/linux/skbuff.h:2260 [inline]
 qrtr_endpoint_post+0x659/0x1150 net/qrtr/qrtr.c:492
 qrtr_tun_write_iter+0xc6/0x120 net/qrtr/tun.c:92
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xa08/0xc70 fs/read_write.c:578
 ksys_write+0x11b/0x220 fs/read_write.c:631
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440259
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd2181ec68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440259
RDX: 0000000000000010 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a60
R13: 0000000000401af0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6791:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x24b/0x330 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 kzalloc+0x16/0x30 include/linux/slab.h:669
 qrtr_tun_write_iter+0x76/0x120 net/qrtr/tun.c:83
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xa08/0xc70 fs/read_write.c:578
 ksys_write+0x11b/0x220 fs/read_write.c:631
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 4860:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 simple_xattr_set+0x5ae/0x5e0 fs/xattr.c:923
 __vfs_removexattr+0x3b9/0x3f0 fs/xattr.c:377
 vfs_removexattr+0xa5/0x190 fs/xattr.c:396
 removexattr fs/xattr.c:691 [inline]
 path_removexattr+0x174/0x240 fs/xattr.c:705
 __do_sys_lremovexattr fs/xattr.c:725 [inline]
 __se_sys_lremovexattr fs/xattr.c:722 [inline]
 __x64_sys_lremovexattr+0x59/0x70 fs/xattr.c:722
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a201b640
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 16 bytes inside of
 32-byte region [ffff8880a201b640, ffff8880a201b660)
The buggy address belongs to the page:
page:ffffea00028806c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a201bfc1
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027cd3c8 ffffea00027a46c8 ffff8880aa4001c0
raw: ffff8880a201bfc1 ffff8880a201b000 000000010000003c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a201b500: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a201b580: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a201b600: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
                                                 ^
 ffff8880a201b680: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 ffff8880a201b700: 00 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
