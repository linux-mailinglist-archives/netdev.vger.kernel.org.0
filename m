Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8911F4929
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgFIV6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:58:24 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44609 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgFIV6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:58:13 -0400
Received: by mail-io1-f72.google.com with SMTP id v14so193302iob.11
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 14:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pw0UgTHVe4ORi9w9G47RxZH+2R3g4C+RyCbV9ziJVuQ=;
        b=JGNK+YdN7MmXZOG+6FduLRERsYRhYcncJUGq1xFBKJYjsJi6gk0Z0wMiRzCbc/lC7n
         k7FHmt4TkZXoJQDS2tBv++wEHHOpmvvPnly97JlOEZDgBjYrV4fhLWF/Qz5BJGtgry50
         hjpHHfWTPi1+KV3fajH4LcGGamhz7uq2/lSKI4utvOmJWhg/Unwr196IL8iZtcl1lCg7
         5zwTdc0Z/zY+EHzrzSL17R5R9lEJnbyxKV9ys0qejlNihW+8RPuJz+No4665Os0wVQJ8
         uPxIVlbMoO+S6QiUFS7lQ7hEa+cGX0vyJQGBxUOeBWO6h0W9oyKhZWo7vuWhuQKIVT/D
         Fr3g==
X-Gm-Message-State: AOAM532zTJ7hZvxyL1XyjF+jG2XrwJtmtBHxHU24Zev4FAScctpurKk+
        giSeCCouQODwZi9wuPt/wllT9Q2FGmGt8jl20g+a0OT7iTDT
X-Google-Smtp-Source: ABdhPJzLGtUrYFSaKZsCsFiJTeD8F6gQ2x4xdGfJQRk1G0TMrdZjwyUwp8nP0wCHl1E4+iAeiQQ3NndOOrF/LrO47sXaQuRjGCp1
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr229920iow.70.1591739892592;
 Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
Date:   Tue, 09 Jun 2020 14:58:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df74f605a7add28b@google.com>
Subject: memory leak in ctnetlink_start
From:   syzbot <syzbot+b005af2cfb0411e617de@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128a9df2100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a1aa05456dfd557
dashboard link: https://syzkaller.appspot.com/bug?extid=b005af2cfb0411e617de
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17304a96100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168a9df2100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b005af2cfb0411e617de@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811c797900 (size 128):
  comm "syz-executor256", pid 6458, jiffies 4294947022 (age 13.050s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000004276332a>] kmalloc include/linux/slab.h:555 [inline]
    [<000000004276332a>] kzalloc include/linux/slab.h:669 [inline]
    [<000000004276332a>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
    [<000000000047e6fb>] ctnetlink_start+0x3a/0x80 net/netfilter/nf_conntrack_netlink.c:998
    [<00000000a431a924>] __netlink_dump_start+0x1a3/0x2e0 net/netlink/af_netlink.c:2343
    [<0000000016b073fa>] netlink_dump_start include/linux/netlink.h:246 [inline]
    [<0000000016b073fa>] ctnetlink_get_conntrack+0x26d/0x2f0 net/netfilter/nf_conntrack_netlink.c:1611
    [<00000000d311138b>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
    [<0000000008feca87>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
    [<0000000088caad78>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
    [<0000000052160488>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<0000000052160488>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
    [<00000000ee36d991>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
    [<00000000dee2cafe>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000dee2cafe>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<00000000b0b655cb>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<000000005bba2f8d>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
    [<0000000060ac6563>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<000000002f7b34b0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000941009bb>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
