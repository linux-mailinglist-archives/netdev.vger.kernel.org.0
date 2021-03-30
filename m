Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9E634E8BC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhC3NQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:16:31 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:40040 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhC3NQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:16:21 -0400
Received: by mail-il1-f200.google.com with SMTP id s10so14109991ilo.7
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WAX5U5X8sKjifaaBpzkwzscw8GSABnmlWm112owArns=;
        b=O67QXIPyTtcqP3OxaDFbCJOc1nYa+XUoSA8loJq/SLvZv7zpGGyEyfB8nmnfd2nV5n
         Cd2JvV80cGlQx9D2cuztwOGFBpsNfW2PQqIA2Kpls1xXUjS4PiD0T3nXk+g9GatrijY0
         7MlIJQyzDlQvN9GOVVJEA4Y/QvCdyx+mq5rg4lMWW/4ECf/XHQJwiVRdSLkfJX0FQIeO
         tURW5G0nSgN+N9GUuXUZaUGMWfZHlG4wTMOFb4lCAau0xUQIK7qd3mN5e9m+OTKFNu9K
         rh6rZrb/Krzwhxuq1uHUVns3SREDPJEqI3uFN6PGpCYUmq11s2LRIDzp/1Pw48kBdynD
         ZrBA==
X-Gm-Message-State: AOAM531v+C35FET2XiREg+LRt3wM1aPrXM/rRmxgUvQ6nEa7t8ND3laf
        iW7BVxTLrlTAgW/ebLIFESgj4meYTYesY7Ju6sQX5HG8PBUu
X-Google-Smtp-Source: ABdhPJxD8aybgWIAK1kKIKCyMSCFKg722/+wDzmikIBxygSWo+hpFQweHkLLw0ctafqMC45C9dtvzN6op6gfxkbVkQAt+bIt+CEU
MIME-Version: 1.0
X-Received: by 2002:a6b:7c42:: with SMTP id b2mr8382879ioq.125.1617110181382;
 Tue, 30 Mar 2021 06:16:21 -0700 (PDT)
Date:   Tue, 30 Mar 2021 06:16:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ec91da05bec0cd7c@google.com>
Subject: [syzbot] memory leak in radix_tree_insert
From:   syzbot <syzbot+739016799a89c530b32a@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        loic.poulain@linaro.org, necip@google.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1e43c377 Merge tag 'xtensa-20210329' of git://github.com/j..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12837016d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=efa6933adb0d4748
dashboard link: https://syzkaller.appspot.com/bug?extid=739016799a89c530b32a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1792a211d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17c5b21ad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+739016799a89c530b32a@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810ffa0900 (size 576):
  comm "syz-executor055", pid 8413, jiffies 4294943689 (age 19.180s)
  hex dump (first 32 bytes):
    3c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  <...............
    b0 91 09 10 81 88 ff ff 18 09 fa 0f 81 88 ff ff  ................
  backtrace:
    [<ffffffff822f6f68>] radix_tree_node_alloc.constprop.0+0x78/0x180 lib/radix-tree.c:274
    [<ffffffff822f887c>] __radix_tree_create lib/radix-tree.c:622 [inline]
    [<ffffffff822f887c>] radix_tree_insert+0x13c/0x310 lib/radix-tree.c:710
    [<ffffffff840cc337>] qrtr_tx_wait net/qrtr/qrtr.c:274 [inline]
    [<ffffffff840cc337>] qrtr_node_enqueue+0x547/0x610 net/qrtr/qrtr.c:342
    [<ffffffff840ce1a2>] qrtr_bcast_enqueue+0x62/0xc0 net/qrtr/qrtr.c:885
    [<ffffffff840ccf1e>] qrtr_sendmsg+0x20e/0x500 net/qrtr/qrtr.c:986
    [<ffffffff8363a836>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363a836>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363a957>] sock_write_iter+0xf7/0x180 net/socket.c:1001
    [<ffffffff81545057>] call_write_iter include/linux/fs.h:1977 [inline]
    [<ffffffff81545057>] new_sync_write+0x1d7/0x2b0 fs/read_write.c:518
    [<ffffffff815486d1>] vfs_write+0x351/0x400 fs/read_write.c:605
    [<ffffffff81548a4b>] ksys_write+0x12b/0x160 fs/read_write.c:658
    [<ffffffff842df20d>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888112449860 (size 32):
  comm "syz-executor055", pid 8414, jiffies 4294944254 (age 13.530s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 68 98 44 12 81 88 ff ff  ........h.D.....
    68 98 44 12 81 88 ff ff 01 00 00 00 00 00 00 00  h.D.............
  backtrace:
    [<ffffffff840cc2ff>] kmalloc include/linux/slab.h:554 [inline]
    [<ffffffff840cc2ff>] kzalloc include/linux/slab.h:684 [inline]
    [<ffffffff840cc2ff>] qrtr_tx_wait net/qrtr/qrtr.c:271 [inline]
    [<ffffffff840cc2ff>] qrtr_node_enqueue+0x50f/0x610 net/qrtr/qrtr.c:342
    [<ffffffff840ce1a2>] qrtr_bcast_enqueue+0x62/0xc0 net/qrtr/qrtr.c:885
    [<ffffffff840ccf1e>] qrtr_sendmsg+0x20e/0x500 net/qrtr/qrtr.c:986
    [<ffffffff8363a836>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363a836>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363a957>] sock_write_iter+0xf7/0x180 net/socket.c:1001
    [<ffffffff81545057>] call_write_iter include/linux/fs.h:1977 [inline]
    [<ffffffff81545057>] new_sync_write+0x1d7/0x2b0 fs/read_write.c:518
    [<ffffffff815486d1>] vfs_write+0x351/0x400 fs/read_write.c:605
    [<ffffffff81548a4b>] ksys_write+0x12b/0x160 fs/read_write.c:658
    [<ffffffff842df20d>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
