Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F75435FC5
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhJUK6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:58:42 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38527 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhJUK6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:58:41 -0400
Received: by mail-io1-f70.google.com with SMTP id m7-20020a6b7b47000000b005dc506c5e04so127913iop.5
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 03:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cIc8+j3oAPKWVDAb13EaaI+nMLJ+8MqmmZ141/mbwg0=;
        b=aEG2tZzj1dtOBYjmNBCJIHPECFKRl5dBMHIF3LcA1DrJZbExJLNMa+fL9Btik4YrlB
         JE2XgRPBnVjv31YtYAMqZ/ROuHQiw7pwpq/x+rZM+xhU+9CuV6btQu1jAsYe3CNHYr3p
         jVE/OkyFJxJ4gH2M7UoHb+BmlCEzszfCqEA8TqyNK9maTQFTahi4QeI6qyGdwXNIXKpj
         ORzZ4174ZpAMHUj8slILyjlBEy9UcOTWACzX2ia3vhKF4oxZLy2ZbLUn2QX2RD0BXIZf
         3XnAVUhBQHRIR9j5o9aREPHgmSfvM7Ct+nKv6GYSQ9xvP9xgWTR9KbMLqqv6YHETe/nj
         s9mw==
X-Gm-Message-State: AOAM53170Ku9kR0xG46ZEc0Q4AbT2PAp3Cv7h7ymf/WFmC/lWxoLZZY4
        lsKcSP5csPDGsY+PVrXU6jVbmkn7okHE5jKe5S2G6/rvBXrO
X-Google-Smtp-Source: ABdhPJxslh1hVb4zXK1d2A/WLLg2PizAlgkQwwzTh7YfG5omaF6dwkVX4yLlNYpicB74Vf5hG7NqgncGi26qSfMUJM02wxn9Bjot
MIME-Version: 1.0
X-Received: by 2002:a92:2c0d:: with SMTP id t13mr2995480ile.99.1634813785617;
 Thu, 21 Oct 2021 03:56:25 -0700 (PDT)
Date:   Thu, 21 Oct 2021 03:56:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f73ca505cedabe2b@google.com>
Subject: [syzbot] KMSAN: uninit-value in hci_phy_link_complete_evt
From:   syzbot <syzbot+6f0fd088eee9708bb4e9@syzkaller.appspotmail.com>
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

HEAD commit:    d6493d2046c4 kmsan: test: pick the first KMSAN report
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=161f4d42b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d9607827325e244
dashboard link: https://syzkaller.appspot.com/bug?extid=6f0fd088eee9708bb4e9
compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12573768b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12756f68b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f0fd088eee9708bb4e9@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_handle include/net/bluetooth/hci_core.h:988 [inline]
BUG: KMSAN: uninit-value in hci_phy_link_complete_evt+0x1a9/0x8b0 net/bluetooth/hci_event.c:5047
 hci_conn_hash_lookup_handle include/net/bluetooth/hci_core.h:988 [inline]
 hci_phy_link_complete_evt+0x1a9/0x8b0 net/bluetooth/hci_event.c:5047
 hci_event_packet+0x893/0x22e0 net/bluetooth/hci_event.c:6458
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
CPU: 0 PID: 144 Comm: kworker/u5:0 Tainted: G    B             5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ff/0x28e lib/dump_stack.c:106
 dump_stack+0x25/0x28 lib/dump_stack.c:113
 panic+0x44f/0xdeb kernel/panic.c:232
 kmsan_report+0x2ee/0x300 mm/kmsan/report.c:168
 __msan_warning+0xa9/0xf0 mm/kmsan/instrumentation.c:199
 hci_conn_hash_lookup_handle include/net/bluetooth/hci_core.h:988 [inline]
 hci_phy_link_complete_evt+0x1a9/0x8b0 net/bluetooth/hci_event.c:5047
 hci_event_packet+0x893/0x22e0 net/bluetooth/hci_event.c:6458
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
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
