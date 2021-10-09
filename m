Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BC1427785
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 07:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbhJIFWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 01:22:42 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:54167 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244290AbhJIFWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 01:22:16 -0400
Received: by mail-il1-f200.google.com with SMTP id x4-20020a923004000000b00258f6abf8feso7120353ile.20
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 22:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qKSYJ/XBrp/2GqQtjIUo2OP1HXBHWhXQVpcO4ycWl/A=;
        b=hYfrjaex78UkE0bG0wmrmUpvCaPwvEkXh63aFRmsxM8Z6iqlwZn31aMb/Dxa+BBQdA
         R/f5LSH9azFSZXHCFehMiaWCWRifZRKc8PjzYZUlp/iBopqNEfpmdI6CpPWya32dBx93
         GePrdtxT3wBI4zg59oL/ZmdBsL1Mxgr0gnxRuk2sUyohOPqcOC0WgQ1f1ELQeBJg3X9A
         xkuKv0Enm44i0h+kXpbVE/v8raADhav9eF3r04IoDt07VzGza9u65m4hl4GP/crsD2Aq
         6V/G8GCZMdG9EH1T1BUqwhYaf7m7vvA0c0VWYGTNlxIpm1lKlQLqCfzr0zy6PLIsS8h2
         4x2Q==
X-Gm-Message-State: AOAM531lRKfwsDvxZ1T1ErHG9Wrwn4zXvxti/Cq1pNhPWqWXV3oRo/VG
        1yzursVEkpXybxd7WOE8PipK7ePL8tMVr7SpmJ+EEcUYyZpA
X-Google-Smtp-Source: ABdhPJzu4OoJGujlCIRLF4RCXEwDKkpm4BZzZ5NR365YWHMJvHJmr2En5KhAZGtRygW8kXhmUxJpnCHQnUGc8/a2mGvdwXDrYpVb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3052:: with SMTP id u18mr10288726jak.148.1633756820093;
 Fri, 08 Oct 2021 22:20:20 -0700 (PDT)
Date:   Fri, 08 Oct 2021 22:20:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e93f4205cde4a661@google.com>
Subject: [syzbot] KMSAN: uninit-value in hci_loglink_complete_evt
From:   syzbot <syzbot+5da5c010bb611b9399a8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    90f502f5d016 kmsan: speculatively unpoison curent_thread_i..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10a65fcb300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978f1b2d7a5aad3e
dashboard link: https://syzkaller.appspot.com/bug?extid=5da5c010bb611b9399a8
compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5da5c010bb611b9399a8@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_handle include/net/bluetooth/hci_core.h:988 [inline]
BUG: KMSAN: uninit-value in hci_loglink_complete_evt+0x18c/0x580 net/bluetooth/hci_event.c:5088
 hci_conn_hash_lookup_handle include/net/bluetooth/hci_core.h:988 [inline]
 hci_loglink_complete_evt+0x18c/0x580 net/bluetooth/hci_event.c:5088
 hci_event_packet+0x11fc/0x22e0 net/bluetooth/hci_event.c:6462
 hci_rx_work+0x6ae/0xd10 net/bluetooth/hci_core.c:5136
 process_one_work+0xdc7/0x1760 kernel/workqueue.c:2297
 worker_thread+0x1101/0x22b0 kernel/workqueue.c:2444
 kthread+0x66b/0x780 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30

Uninit was created at:
 slab_alloc_node mm/slub.c:3221 [inline]
 __kmalloc_node_track_caller+0x8d2/0x1340 mm/slub.c:4955
 kmalloc_reserve net/core/skbuff.c:355 [inline]
 __alloc_skb+0x4db/0xe40 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1116 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x182/0x8f0 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write fs/read_write.c:507 [inline]
 vfs_write+0x1295/0x1f20 fs/read_write.c:594
 ksys_write+0x28c/0x520 fs/read_write.c:647
 __do_sys_write fs/read_write.c:659 [inline]
 __se_sys_write fs/read_write.c:656 [inline]
 __x64_sys_write+0xdb/0x120 fs/read_write.c:656
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
=====================================================
Kernel panic - not syncing: panic_on_kmsan set ...
CPU: 1 PID: 6382 Comm: kworker/u5:2 Tainted: G    B             5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci4 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ff/0x28e lib/dump_stack.c:106
 dump_stack+0x25/0x28 lib/dump_stack.c:113
 panic+0x44f/0xdeb kernel/panic.c:232
 kmsan_report+0x2ee/0x300 mm/kmsan/report.c:186
 __msan_warning+0xd7/0x150 mm/kmsan/instrumentation.c:208
 hci_conn_hash_lookup_handle include/net/bluetooth/hci_core.h:988 [inline]
 hci_loglink_complete_evt+0x18c/0x580 net/bluetooth/hci_event.c:5088
 hci_event_packet+0x11fc/0x22e0 net/bluetooth/hci_event.c:6462
 hci_rx_work+0x6ae/0xd10 net/bluetooth/hci_core.c:5136
 process_one_work+0xdc7/0x1760 kernel/workqueue.c:2297
 worker_thread+0x1101/0x22b0 kernel/workqueue.c:2444
 kthread+0x66b/0x780 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
