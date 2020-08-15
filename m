Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C9424536F
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgHOWBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgHOVv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:26 -0400
Received: from mail-io1-xd47.google.com (mail-io1-xd47.google.com [IPv6:2607:f8b0:4864:20::d47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB41C00039B
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:19:25 -0700 (PDT)
Received: by mail-io1-xd47.google.com with SMTP id e12so7743162ioc.8
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GpKlYOLTQ3NZOHf3k+bXCS8gLg7b2ROCnIxYzCs9K7Y=;
        b=CZRqUyEdAtBZF09j1CDqzr+VSqjli5bBi1/t3IKFDm/FzPXKVFknvhuFgu2bx0xtsv
         9fVq0rHWe1aqhfZUG5uCa0LALsBV3Ke9IqbtyCibzuT1l2YaHL2Vib68eHyEtqZiHGQ6
         YmV968MUq6vhRr9BWT658BtA0/Ejd3i1c1HHd1j0r04/KoyGYfTKZhc5M+J1QrdR7ocC
         igqKaDO4kX8YzCqnXGHFL5cSOnWauJPgbLFLw9r7W7tdXS4c/8bhO2sRRpbqps57ft6K
         0SDYfs7CQLfwV26HNEtGnfg3oWbH92tdG9PnRsZVdvO2lRCsZqzv88fSrZo9QOdhHi18
         FLNg==
X-Gm-Message-State: AOAM530SX1NQ0o+KlaRCudlb131co/kUBCaGZEwAhlwKe8OjxK+SeikQ
        yiXnRz9rIKSPwaO8GY3+L+DdGulF2sypQpYWspIfbY2WUecf
X-Google-Smtp-Source: ABdhPJzgWk0fNRRV9SxWB4STKsUr+rNsP+8+REIA7cb/c2NKeIHdOl1bkAZJR4qeWpTJhROEEuaRmDE7QKSDCrP/+Du82uxCBax8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:792:: with SMTP id q18mr7200462ils.104.1597511965051;
 Sat, 15 Aug 2020 10:19:25 -0700 (PDT)
Date:   Sat, 15 Aug 2020 10:19:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000033913705acedbd6b@google.com>
Subject: memory leak in read_adv_mon_features
From:   syzbot <syzbot+f7f6e564f4202d8601c6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7fca4dee Merge tag 'powerpc-5.9-2' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ea92a1900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e320bbff976a5cdc
dashboard link: https://syzkaller.appspot.com/bug?extid=f7f6e564f4202d8601c6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1286db9a900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1143ddf6900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f7f6e564f4202d8601c6@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88812b18e6e0 (size 32):
  comm "syz-executor286", pid 6490, jiffies 4294993450 (age 13.120s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 00 10 00 00 00 00 00  ........ .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f286b99c>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000f286b99c>] read_adv_mon_features+0xa1/0x150 net/bluetooth/mgmt.c:4180
    [<00000000f0f16504>] hci_mgmt_cmd net/bluetooth/hci_sock.c:1603 [inline]
    [<00000000f0f16504>] hci_sock_sendmsg+0xb01/0xc60 net/bluetooth/hci_sock.c:1738
    [<000000001560da71>] sock_sendmsg_nosec net/socket.c:651 [inline]
    [<000000001560da71>] sock_sendmsg+0x4c/0x60 net/socket.c:671
    [<000000007d7be9f6>] sock_write_iter+0xc5/0x140 net/socket.c:998
    [<00000000e3633d41>] call_write_iter include/linux/fs.h:1882 [inline]
    [<00000000e3633d41>] new_sync_write+0x173/0x210 fs/read_write.c:503
    [<0000000021a87df2>] vfs_write+0x21d/0x280 fs/read_write.c:578
    [<0000000003f07ff6>] ksys_write+0xd8/0x120 fs/read_write.c:631
    [<0000000003a7df09>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005ecd28f6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88812b18e660 (size 32):
  comm "syz-executor286", pid 6495, jiffies 4294993998 (age 7.640s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 00 10 00 00 00 00 00  ........ .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f286b99c>] kmalloc include/linux/slab.h:559 [inline]
    [<00000000f286b99c>] read_adv_mon_features+0xa1/0x150 net/bluetooth/mgmt.c:4180
    [<00000000f0f16504>] hci_mgmt_cmd net/bluetooth/hci_sock.c:1603 [inline]
    [<00000000f0f16504>] hci_sock_sendmsg+0xb01/0xc60 net/bluetooth/hci_sock.c:1738
    [<000000001560da71>] sock_sendmsg_nosec net/socket.c:651 [inline]
    [<000000001560da71>] sock_sendmsg+0x4c/0x60 net/socket.c:671
    [<000000007d7be9f6>] sock_write_iter+0xc5/0x140 net/socket.c:998
    [<00000000e3633d41>] call_write_iter include/linux/fs.h:1882 [inline]
    [<00000000e3633d41>] new_sync_write+0x173/0x210 fs/read_write.c:503
    [<0000000021a87df2>] vfs_write+0x21d/0x280 fs/read_write.c:578
    [<0000000003f07ff6>] ksys_write+0xd8/0x120 fs/read_write.c:631
    [<0000000003a7df09>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000005ecd28f6>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
