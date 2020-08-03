Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141E123A919
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgHCPFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:05:23 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:33774 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgHCPFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:05:22 -0400
Received: by mail-il1-f199.google.com with SMTP id e4so13927527ilr.0
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cwHAmIAnWDXaQ8U+cgz3uBI7B40rqObvLOBOdb+Z848=;
        b=osfAaub9tzM+cXyk5+PjwMXkFvBunZN1bFjrQ3ipXRpXFVNYtai/XCwEZtiQtsc2fN
         X2EyhpmLPgwvFbSTaXCI7VBKn/ALJ7DZtGj9tnyqxcUDrh/p9fyYeNd6fRsEmYXSmqQq
         jHYwBjrTwJbn365k5B/Oxv+ZAXuuO2rVgzzJr/8BXAiDDE2ACONMJDKIpmw8mk9+odMZ
         3hD+PRgjIKDYazaU+dvaruauZV4o0/rmYqbxPUQBu9mnJnw0g93l8jr9YbRICVBSa17o
         pZ6RAeHMNK/vZRTibMTa+4uwPZ/EoUV7zBd4SpObp6YIGvJLNambqK99z3vJcKVVJaog
         FVLg==
X-Gm-Message-State: AOAM533bd+QMJajc6nDEOuIPcNqJAlU3R80i0GYiQzwuX/z8Tl9sEqgc
        r3qCcHPgYrmQx5lya/T2+6npMPNjnkFHotAwCQEgn8vu2BMa
X-Google-Smtp-Source: ABdhPJynY1P/Ats+QjnU0eZn1C6aGDytmEJlnR20o3Pr43gms75ovSxM3yYUFPnfz9XxtEny6CaMM1EUKc79LPamNTb2xxmMA0Xn
MIME-Version: 1.0
X-Received: by 2002:a6b:3bd4:: with SMTP id i203mr231137ioa.205.1596467121253;
 Mon, 03 Aug 2020 08:05:21 -0700 (PDT)
Date:   Mon, 03 Aug 2020 08:05:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a876b805abfa77e0@google.com>
Subject: KASAN: slab-out-of-bounds Read in hci_le_meta_evt
From:   syzbot <syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5a30a789 Merge tag 'x86-urgent-2020-08-02' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11cd21cc900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=24ebd650e20bd263ca01
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fd4504900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14aa36a4900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+24ebd650e20bd263ca01@syzkaller.appspotmail.com

Bluetooth: hci0: unknown advertising packet type: 0x2b
==================================================================
BUG: KASAN: slab-out-of-bounds in hci_le_direct_adv_report_evt net/bluetooth/hci_event.c:5850 [inline]
BUG: KASAN: slab-out-of-bounds in hci_le_meta_evt+0x380c/0x3eb0 net/bluetooth/hci_event.c:5914
Read of size 1 at addr ffff8880a727de0c by task kworker/u5:0/1535

CPU: 1 PID: 1535 Comm: kworker/u5:0 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 hci_le_direct_adv_report_evt net/bluetooth/hci_event.c:5850 [inline]
 hci_le_meta_evt+0x380c/0x3eb0 net/bluetooth/hci_event.c:5914
 hci_event_packet+0x245a/0x86f5 net/bluetooth/hci_event.c:6167
 hci_rx_work+0x22e/0xb10 net/bluetooth/hci_core.c:4705
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6834:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x550 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:377 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0xbd/0x450 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:503
 vfs_write+0x59d/0x6b0 fs/read_write.c:578
 ksys_write+0x12d/0x250 fs/read_write.c:631
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6627:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 tomoyo_find_next_domain+0x81d/0x1f77 security/tomoyo/domain.c:885
 tomoyo_bprm_check_security security/tomoyo/tomoyo.c:101 [inline]
 tomoyo_bprm_check_security+0x121/0x1a0 security/tomoyo/tomoyo.c:91
 security_bprm_check+0x45/0xa0 security/security.c:840
 search_binary_handler fs/exec.c:1737 [inline]
 exec_binprm fs/exec.c:1790 [inline]
 __do_execve_file+0x1577/0x2ee0 fs/exec.c:1926
 do_execveat_common fs/exec.c:1980 [inline]
 do_execve+0x35/0x50 fs/exec.c:1997
 __do_sys_execve fs/exec.c:2073 [inline]
 __se_sys_execve fs/exec.c:2068 [inline]
 __x64_sys_execve+0x7c/0xa0 fs/exec.c:2068
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a727dc00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 12 bytes to the right of
 512-byte region [ffff8880a727dc00, ffff8880a727de00)
The buggy address belongs to the page:
page:ffffea00029c9f40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00029e3848 ffffea0002731b88 ffff8880aa000a80
raw: 0000000000000000 ffff8880a727d000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a727dd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880a727dd80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880a727de00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff8880a727de80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a727df00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
