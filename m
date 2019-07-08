Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1228F61B2A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 09:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfGHHRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 03:17:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55332 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGHHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 03:17:08 -0400
Received: by mail-io1-f70.google.com with SMTP id f22so18051580ioh.22
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 00:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Gn80oO4XYMAOVKBGMnOSHzTx+81UaZglCxw6gRYjbG0=;
        b=VCPfjuJ30TWzUwZP9o2hPRqX09Aqq/GlFdDkGEI+KxZGuVAKckrjrDQJWpYK/nhon+
         gDZ4mkTA7rN+0vue4y8ppra/LZMHNyKYucO+B5WdwDlUUFkE/ACJ29fum8V/XFfz1827
         6xgAlJsVbRK1VAGhAKMfRVKWbAEB03Gj9ZAuIso5eF5v6GXEtIWUu4egYgBCadb9AZO1
         6IQSVOhedLhd6spySmQcZX3FMcJTgJag0F0ACTTif5tFftd5QwE+RQSsGxgQKpCMf4on
         ZbM+Ejr7+dHMLZYhVkpUfkrpCVODZTN0jtpcsNetORNICD/cfjBAqaiQamww9Xl8FyVk
         YslA==
X-Gm-Message-State: APjAAAVXxzK9qKRdis3kHgMPXSC8wFqA5Pe3HhYQMK5VVJekU7bRcgXi
        tELvUe9DqXwrfhKXruw8Ilp8egI/OFlSbQzl3giwGJgcklLP
X-Google-Smtp-Source: APXvYqzZ3tM8OYLS29FUeOoOntB1b9wp7bg1+O4gdNJWOSGIt4/II1rMLZL1KXH3w5kGDbVgCyF3SI1TOBm6ExNEwNVolK2Zwhz1
MIME-Version: 1.0
X-Received: by 2002:a5d:8747:: with SMTP id k7mr16963614iol.20.1562570227370;
 Mon, 08 Jul 2019 00:17:07 -0700 (PDT)
Date:   Mon, 08 Jul 2019 00:17:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000056d70a058d263bbc@google.com>
Subject: general protection fault in send_hsr_supervision_frame
From:   syzbot <syzbot+097ef84cdc95843fbaa8@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    537de0c8 ipv4: Fix NULL pointer dereference in ipv4_neigh_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16d2af63a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90f5d2d9c1e7421c
dashboard link: https://syzkaller.appspot.com/bug?extid=097ef84cdc95843fbaa8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a9361da00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a4c753a00000

The bug was bisected to:

commit b9a1e627405d68d475a3c1f35e685ccfb5bbe668
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu Jul 4 00:21:13 2019 +0000

     hsr: implement dellink to clean up resources

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10b86c77a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12b86c77a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14b86c77a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+097ef84cdc95843fbaa8@syzkaller.appspotmail.com
Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10432 Comm: syz-executor357 Not tainted 5.2.0-rc6+ #76
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:send_hsr_supervision_frame+0x38/0xf20 net/hsr/hsr_device.c:255
Code: 89 fd 41 54 53 48 83 ec 50 89 75 bc e8 81 d2 5c fa 49 8d 45 10 48 89  
c2 48 89 45 d0 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f  
85 dc 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b
RSP: 0018:ffff8880ae809c50 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff871403d7
RDX: 0000000000000002 RSI: ffffffff8713f08f RDI: 0000000000000000
RBP: ffff8880ae809cc8 R08: ffff88809e014600 R09: ffffed1015d06c70
R10: ffffed1015d06c6f R11: ffff8880ae83637b R12: ffff888097eff000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f85a5cd2700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006de0a0 CR3: 00000000a1151000 CR4: 00000000001406f0
Call Trace:
  <IRQ>
  hsr_announce+0x12f/0x3b0 net/hsr/hsr_device.c:339
  call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
  __do_softirq+0x25c/0x94c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x180/0x1d0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:767  
[inline]
RIP: 0010:lock_is_held_type+0x272/0x320 kernel/locking/lockdep.c:4343
Code: ff df c7 83 7c 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 88  
00 00 00 48 83 3d 86 a0 5b 07 00 74 31 48 8b 7d c0 57 9d <0f> 1f 44 00 00  
48 83 c4 20 44 89 e0 5b 41 5c 41 5d 41 5e 41 5f 5d
RSP: 0018:ffff8880a13f71e8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1164e7e RBX: ffff88809e014600 RCX: ffff88809e014e80
RDX: dffffc0000000000 RSI: ffffffff88ba3700 RDI: 0000000000000286
RBP: ffff8880a13f7230 R08: ffff88809e014600 R09: ffffed1015d06c70
R10: ffffed1015d06c6f R11: ffff8880ae83637b R12: 0000000000000001
R13: ffff88809e014ef8 R14: ffffffff88ba3700 R15: 0000000000000003
  lock_is_held include/linux/lockdep.h:356 [inline]
  rcu_read_lock_held kernel/rcu/update.c:270 [inline]
  rcu_read_lock_held+0xa3/0xd0 kernel/rcu/update.c:262
  xa_head include/linux/xarray.h:1128 [inline]
  xas_start+0x1ce/0x560 lib/xarray.c:187
  xas_load+0x21/0x150 lib/xarray.c:232
  find_get_entry+0x144/0x770 mm/filemap.c:1506
  pagecache_get_page+0x4c/0x850 mm/filemap.c:1608
  find_get_page_flags include/linux/pagemap.h:266 [inline]
  ext4_mb_load_buddy_gfp+0x595/0x13e0 fs/ext4/mballoc.c:1190
  ext4_mb_load_buddy fs/ext4/mballoc.c:1241 [inline]
  ext4_mb_regular_allocator+0x7e0/0x1260 fs/ext4/mballoc.c:2190
  ext4_mb_new_blocks+0x1881/0x3c10 fs/ext4/mballoc.c:4539
  ext4_ext_map_blocks+0x2b83/0x5250 fs/ext4/extents.c:4414
  ext4_map_blocks+0x8c5/0x18e0 fs/ext4/inode.c:640
  ext4_alloc_file_blocks+0x287/0xac0 fs/ext4/extents.c:4603
  ext4_fallocate+0x8ba/0x2060 fs/ext4/extents.c:4888
  vfs_fallocate+0x4aa/0xa50 fs/open.c:309
  ioctl_preallocate+0x197/0x210 fs/ioctl.c:490
  file_ioctl fs/ioctl.c:506 [inline]
  do_vfs_ioctl+0x1170/0x1380 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x448e19
Code: e8 dc e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b 05 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f85a5cd1d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000006e5a08 RCX: 0000000000448e19
RDX: 0000000020000080 RSI: 0000000040305828 RDI: 0000000000000003
RBP: 00000000006e5a00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e5a0c
R13: f4a25a5f72695f65 R14: 6761000000000000 R15: 00046c7465677568
Modules linked in:
---[ end trace 1a213132b72d6860 ]---
RIP: 0010:send_hsr_supervision_frame+0x38/0xf20 net/hsr/hsr_device.c:255
Code: 89 fd 41 54 53 48 83 ec 50 89 75 bc e8 81 d2 5c fa 49 8d 45 10 48 89  
c2 48 89 45 d0 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f  
85 dc 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4d 8b
RSP: 0018:ffff8880ae809c50 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff871403d7
RDX: 0000000000000002 RSI: ffffffff8713f08f RDI: 0000000000000000
RBP: ffff8880ae809cc8 R08: ffff88809e014600 R09: ffffed1015d06c70
R10: ffffed1015d06c6f R11: ffff8880ae83637b R12: ffff888097eff000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f85a5cd2700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006de0a0 CR3: 00000000a1151000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
