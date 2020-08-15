Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BDA245371
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgHOWBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgHOVvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:25 -0400
Received: from mail-io1-xd48.google.com (mail-io1-xd48.google.com [IPv6:2607:f8b0:4864:20::d48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A67C00055F
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:19:25 -0700 (PDT)
Received: by mail-io1-xd48.google.com with SMTP id f22so7770516iof.20
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t8QMO3n4KROmSRkoKVG2lLOeJzzDaqBTfQOpgHU7bgA=;
        b=ZQpsAQIzygsKwubfWAAvLwAAfM05uE6JPXrTZokeTW06kgdVHZ3cAgWBCsXFym1IkY
         XJtngvsV33UwURFpamattga+NlazurseZBzVMuw+qcqRW0JyG3U0KVrV6FSMNFHiAfmC
         h+iL+UX6Qo2jty9t4o+0dfhG5ys8paHffxUWnEj4zkAiSUqOZcuTpQ+W+oBqynMwDFz9
         91sS0Gght5X/KDomx9/BBYQLyHC6jn5lDFp/nurjMos2qBq/MZ52IFxfP3KJNgTSO/4m
         cil+qA5a5qUfrtjdmP5VVljIiZFvErWcMsjsl5Tq0Xybg4ZzWECayecvU+kkS1wG+XMj
         lSgQ==
X-Gm-Message-State: AOAM531q1TJXn1Y7Xvmhdp1OgpetuzkmM6kiNz4QyznvpVgN3k+u5spd
        isyRM6I7rb9N2eugMgZfuz6YqrRwOIZrLn4bZHuXJ0VUEQ5l
X-Google-Smtp-Source: ABdhPJwuiQ330unLGWYjqFD92eeYv7ieCWrxq3Aup/qHbAfQlSVCCMJLJOr7JsR076+ho+SlBCbpNUu4pGvr8oOWH/UxiyB1o8EX
MIME-Version: 1.0
X-Received: by 2002:a02:866d:: with SMTP id e100mr7502553jai.83.1597511964807;
 Sat, 15 Aug 2020 10:19:24 -0700 (PDT)
Date:   Sat, 15 Aug 2020 10:19:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002fe0e605acedbdfc@google.com>
Subject: KMSAN: uninit-value in hci_chan_lookup_handle
From:   syzbot <syzbot+4c14a8f574461e1c3659@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16c0e1e2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=4c14a8f574461e1c3659
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16fd6aa6900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105910ce900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c14a8f574461e1c3659@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __hci_chan_lookup_handle net/bluetooth/hci_conn.c:1741 [inline]
BUG: KMSAN: uninit-value in hci_chan_lookup_handle+0x1e3/0x310 net/bluetooth/hci_conn.c:1757
CPU: 0 PID: 8496 Comm: kworker/u5:2 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __hci_chan_lookup_handle net/bluetooth/hci_conn.c:1741 [inline]
 hci_chan_lookup_handle+0x1e3/0x310 net/bluetooth/hci_conn.c:1757
 hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4992 [inline]
 hci_event_packet+0x14e10/0x39d30 net/bluetooth/hci_event.c:6176
 hci_rx_work+0x6df/0xd30 net/bluetooth/hci_core.c:4705
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xeab/0x12e0 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:377 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0x18a/0x890 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xf9a/0x17c0 fs/read_write.c:578
 ksys_write+0x275/0x500 fs/read_write.c:631
 __do_sys_write fs/read_write.c:643 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:640
 __x64_sys_write+0x4a/0x70 fs/read_write.c:640
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
