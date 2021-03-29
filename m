Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E153D34D430
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhC2Pns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:43:48 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:56046 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhC2PnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:43:25 -0400
Received: by mail-il1-f197.google.com with SMTP id x15so9229355ilg.22
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=11Jgk0Ybij/b9+77MLmHBIB7rsbHzrsqppF6FNx4xwI=;
        b=eQq6eDX13dBgU24tM4VknO4IHYHtM1GJdYkoQ5O7YZaqVgQuiMXBW86nPphW71ZDY7
         +AjVuimeBrYi9Q+ZIFGRLxrZYuppT5Gl4kBcG++tDRti1axm2MNjJia/UIi70W+mIaW0
         tVwmk08DGnszEbkf9B5bJu0cwoqqm/19ooFivBZa6Glu33mohcVDu46PwPnMSFC+8fG/
         5YREZu7HZ29/ZKAcwVDFTpT9Zuyw51i9r7R4AHXCKrRTjPXlfbsu6wO45yJxLFqfJU8C
         M6FUwi61cDdKykJRoo/6pRFI9p2RzvqDo74WWGIC95bmneQVdAQ4bD+xD0nXziQI3auu
         4FGw==
X-Gm-Message-State: AOAM531fimFKHPH4Rfz5dmkPZuGwYWHIlFP4aoJXUZhfLsjiq9DcSNit
        vct7Ng4ryD8KKuqcppsPBN/pUkrDd6EKOFRQrqpJKl+h3xni
X-Google-Smtp-Source: ABdhPJz8zeIyEqRKfcoVrDZIzYWt5r9ri8oz55kzE/0T7CMpBE5VvW4ZdeGzCcdB8X02mTUzYaeYS73vQtlPhu15IFu1k7Lms3jB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1348:: with SMTP id k8mr22482210ilr.277.1617032604540;
 Mon, 29 Mar 2021 08:43:24 -0700 (PDT)
Date:   Mon, 29 Mar 2021 08:43:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fbe1cf05beaebdd4@google.com>
Subject: [syzbot] KMSAN: uninit-value in hci_event_packet (3)
From:   syzbot <syzbot+b12240a286aa7cd4f3fb@syzkaller.appspotmail.com>
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

HEAD commit:    29ad81a1 arch/x86: add missing include to sparsemem.h
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=100da362d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c7da2160236454
dashboard link: https://syzkaller.appspot.com/bug?extid=b12240a286aa7cd4f3fb
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e08faed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147a978ad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b12240a286aa7cd4f3fb@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_add+0x718/0x1890 net/bluetooth/hci_conn.c:553
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_add+0x718/0x1890 net/bluetooth/hci_conn.c:553
 hci_conn_request_evt net/bluetooth/hci_event.c:2756 [inline]
 hci_event_packet+0x18851/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_add include/net/bluetooth/hci_core.h:862 [inline]
BUG: KMSAN: uninit-value in hci_conn_add+0x1467/0x1890 net/bluetooth/hci_conn.c:587
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_add include/net/bluetooth/hci_core.h:862 [inline]
 hci_conn_add+0x1467/0x1890 net/bluetooth/hci_conn.c:587
 hci_conn_request_evt net/bluetooth/hci_event.c:2756 [inline]
 hci_event_packet+0x18851/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 hci_conn_add+0x601/0x1890 net/bluetooth/hci_conn.c:532
 hci_conn_request_evt net/bluetooth/hci_event.c:2756 [inline]
 hci_event_packet+0x18851/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_add+0x17a3/0x1890 net/bluetooth/hci_conn.c:593
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_add+0x17a3/0x1890 net/bluetooth/hci_conn.c:593
 hci_conn_request_evt net/bluetooth/hci_event.c:2756 [inline]
 hci_event_packet+0x18851/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 hci_conn_add+0x601/0x1890 net/bluetooth/hci_conn.c:532
 hci_conn_request_evt net/bluetooth/hci_event.c:2756 [inline]
 hci_event_packet+0x18851/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_hash_lookup_ba include/net/bluetooth/hci_core.h:980 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2753 [inline]
 hci_event_packet+0x18669/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_conn_request_evt net/bluetooth/hci_event.c:2769 [inline]
 hci_event_packet+0x18a27/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.c:605
 ksys_write+0x275/0x500 fs/read_write.c:658
 __do_sys_write fs/read_write.c:670 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:667
 __x64_sys_write+0x4a/0x70 fs/read_write.c:667
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================
=====================================================
BUG: KMSAN: uninit-value in hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
BUG: KMSAN: uninit-value in hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
BUG: KMSAN: uninit-value in hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
CPU: 1 PID: 8218 Comm: kworker/u5:2 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 hci_proto_connect_ind include/net/bluetooth/hci_core.h:1404 [inline]
 hci_conn_request_evt net/bluetooth/hci_event.c:2719 [inline]
 hci_event_packet+0xf7bb/0x39e50 net/bluetooth/hci_event.c:6157
 hci_rx_work+0x744/0xcf0 net/bluetooth/hci_core.c:4971
 process_one_work+0x1219/0x1fe0 kernel/workqueue.c:2275
 worker_thread+0x10ec/0x2340 kernel/workqueue.c:2421
 kthread+0x521/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_poison_shadow+0x5c/0xf0 mm/kmsan/kmsan.c:104
 kmsan_slab_alloc+0x8d/0xe0 mm/kmsan/kmsan_hooks.c:76
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0xa37/0x1430 mm/slub.c:4527
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2f8/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1099 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:389 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x880 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write fs/read_write.c:518 [inline]
 vfs_write+0x1083/0x1b00 fs/read_write.

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
