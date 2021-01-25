Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BA4304B1B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbhAZEtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:49:45 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:42199 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbhAYJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:25:02 -0500
Received: by mail-io1-f71.google.com with SMTP id k26so18082251ios.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 01:24:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0Fb4rwegTwb56Mr7ykus3R8M8PDXB2O7qEzvQDOjkTc=;
        b=lcPDitiz8mk3s+PAJfxCymPR1BQlVk1EfL8hX0J6JNG1fZt+u33ln8qBoYG9xHmx1w
         YDtk2sJBfCN6Rw3ZCT3vLQz2pFhUgqxdd6iOmSrldv1C62VqZumqdW/4oK1lpoYelaJh
         wTY+I+QCfyzejMbwz4tcn1sfN4o5SE3Kw0wWFM3zZlROAPU9LjVxauQK9WGSW0mLxtxD
         VXsw6JJ7qjHMu8xxmkICbG2bHpzjt4IRQ2Taq1Exd9f281tBq/1kT+EVhC8HeK2nbp60
         mf3op2vHIfbsqE7YbXtbND6cE9W/yF2cx8R2IVEmn31lSuRjSEQn9qrfPikeP7O+tTrU
         cK/Q==
X-Gm-Message-State: AOAM53151zWAj00E2ygHUlNdQTa3uFL5HPq3T45DkuNjxbEkvBRcH9uK
        7h93MMCAZlg5PP4eOfSLS2m449PJySOQ0lqbb0ZEDhR62LaZ
X-Google-Smtp-Source: ABdhPJyENOcvDGfGuto0tBK8tVnA1dRaVnkvxurx8tif2F2+iW1IskSa66Cplsmx2RK253y3kQ0fZ1iET5wXUvaLKhtv2zMnXHrM
MIME-Version: 1.0
X-Received: by 2002:a6b:6016:: with SMTP id r22mr81296iog.93.1611566657135;
 Mon, 25 Jan 2021 01:24:17 -0800 (PST)
Date:   Mon, 25 Jan 2021 01:24:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000216a9f05b9b61a72@google.com>
Subject: KASAN: slab-out-of-bounds Write in hci_chan_del
From:   syzbot <syzbot+2483a91bbbf64347d474@syzkaller.appspotmail.com>
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

HEAD commit:    45dfb8a5 Merge tag 'task_work-2021-01-19' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c913b8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39701af622f054a9
dashboard link: https://syzkaller.appspot.com/bug?extid=2483a91bbbf64347d474
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2483a91bbbf64347d474@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in instrument_atomic_write include/linux/instrumented.h:86 [inline]
BUG: KASAN: slab-out-of-bounds in set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
BUG: KASAN: slab-out-of-bounds in hci_chan_del+0x130/0x200 net/bluetooth/hci_conn.c:1746
Write of size 8 at addr ffff88801b8d3dc8 by task syz-executor.4/15313

CPU: 1 PID: 15313 Comm: syz-executor.4 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2c6 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:396 [inline]
 kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_write include/linux/instrumented.h:86 [inline]
 set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
 hci_chan_del+0x130/0x200 net/bluetooth/hci_conn.c:1746
 l2cap_conn_del+0x478/0x7b0 net/bluetooth/l2cap_core.c:1906
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8167 [inline]
 l2cap_disconn_cfm+0x98/0xd0 net/bluetooth/l2cap_core.c:8160
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1462 [inline]
 hci_conn_hash_flush+0x127/0x260 net/bluetooth/hci_conn.c:1565
 hci_dev_do_close+0x569/0x1110 net/bluetooth/hci_core.c:1776
 hci_unregister_dev+0x223/0xfe0 net/bluetooth/hci_core.c:3872
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xc5c/0x2ae0 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x427/0x20f0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: Unable to access opcode bytes at RIP 0x45e1ef.
RSP: 002b:00007f8ad2dfbcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000119bf88 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000119bf88
RBP: 000000000119bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffe86791b2f R14: 00007f8ad2dfc9c0 R15: 000000000119bf8c

Allocated by task 10445:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:401 [inline]
 ____kasan_kmalloc.constprop.0+0x7f/0xa0 mm/kasan/common.c:429
 kasan_kmalloc include/linux/kasan.h:219 [inline]
 __do_kmalloc mm/slab.c:3659 [inline]
 __kmalloc+0x20c/0x440 mm/slab.c:3668
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 tomoyo_get_name+0x234/0x480 security/tomoyo/memory.c:173
 tomoyo_parse_name_union+0xbc/0x160 security/tomoyo/util.c:260
 tomoyo_update_path_acl security/tomoyo/file.c:395 [inline]
 tomoyo_write_file+0x4c0/0x7f0 security/tomoyo/file.c:1022
 tomoyo_write_domain2+0x116/0x1d0 security/tomoyo/common.c:1152
 tomoyo_add_entry security/tomoyo/common.c:2042 [inline]
 tomoyo_supervisor+0xbc4/0xef0 security/tomoyo/common.c:2103
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
 tomoyo_path_perm+0x39e/0x400 security/tomoyo/file.c:838
 tomoyo_path_symlink+0x94/0xe0 security/tomoyo/tomoyo.c:200
 security_path_symlink+0xdf/0x150 security/security.c:1111
 do_symlinkat+0x123/0x2c0 fs/namei.c:3987
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88801b8d3d00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 72 bytes to the right of
 128-byte region [ffff88801b8d3d00, ffff88801b8d3d80)
The buggy address belongs to the page:
page:000000005d65c789 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88801b8d3700 pfn:0x1b8d3
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea0000997a88 ffffea00008a2e48 ffff888010040400
raw: ffff88801b8d3700 ffff88801b8d3000 000000010000000f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801b8d3c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801b8d3d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88801b8d3d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                              ^
 ffff88801b8d3e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801b8d3e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
