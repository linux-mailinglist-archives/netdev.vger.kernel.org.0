Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA98723D2B4
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgHEUPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:15:18 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:37828 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgHEQUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:20:12 -0400
Received: by mail-io1-f71.google.com with SMTP id f6so17759565ioa.4
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 09:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gf59HPMENV3tGrAXq5hE5QTaFPtfjI08GkK5Z/pVw18=;
        b=mDuXyOUQcwK1nXw7IlnIB/+Y2KH2SKVBglr4lqHXnTuzoUX+yvNnZo1OIM7yGTrWKn
         7oj9rKfQCwve5tjJW1KfJF/PSUHtHDqoKWLRooFYdCgh12O31D2xu+Rz2hkhSlAL5wFy
         8LYKz6Oq9Fa2RIC6Mox5eYWqstwjKyXtKLVGUSR0j3LtOeA6aZEOkKhDWnxHcK7u4ICN
         5CJJCjJSUEXjhvUODF0K8ABhZPFpvcNyC8WJFuHZq0q8+Oo3Wg609fsu4TJX7BFyeArs
         adBBz8R26e7lXEHjSMHUHpzV29hxUaHWrXCmLELlUReKrnHqld8nbd7l042FyQeNs7OX
         vNNA==
X-Gm-Message-State: AOAM5326k2m7uur12yXegcNKJuJ+4O8AusKZ/k2I3dlFQvr8eahmPKM8
        B8eoeWObiBnGltn42B5k97Lii++r2NJop6Fctbhbbmf+P6EV
X-Google-Smtp-Source: ABdhPJxl0BPdl6oM/s7HLtGwzvDPhEYlmelG5KgJF5rbDcL7n1B3Q6UoxJACGDSfOLK8hC/Y8LQyi/I8pkm2k0uNJ6e3zo992gYj
MIME-Version: 1.0
X-Received: by 2002:a5d:9a86:: with SMTP id c6mr4183230iom.27.1596643761561;
 Wed, 05 Aug 2020 09:09:21 -0700 (PDT)
Date:   Wed, 05 Aug 2020 09:09:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003da5f105ac239832@google.com>
Subject: general protection fault in bt_accept_unlink
From:   syzbot <syzbot+a9c8613ce9eafbd86441@syzkaller.appspotmail.com>
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

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1639b284900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=a9c8613ce9eafbd86441
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a9c8613ce9eafbd86441@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xf777682000003777: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xbbbb61000001bbb8-0xbbbb61000001bbbf]
CPU: 0 PID: 9028 Comm: kworker/0:6 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__list_del_entry_valid+0x81/0xef lib/list_debug.c:51
Code: 0f 84 df 00 00 00 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 e0 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 51 49 8b 14 24 48 39 ea 0f 85 97 00 00 00 49 8d 7d
RSP: 0018:ffffc900091afb18 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffff8880a71664b8 RCX: ffffffff8724984f
RDX: 17776c2000003777 RSI: ffffffff8717d437 RDI: ffff8880a71664c0
RBP: ffff8880a71664b8 R08: 0000000000000001 R09: ffff8880a7166067
R10: 0000000000000009 R11: 00000000000ccae8 R12: bbbb61000001bbbb
R13: bb60000000bbbbbb R14: 00000060000000bb R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000ca8660 CR3: 000000009115f000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_init include/linux/list.h:204 [inline]
 bt_accept_unlink+0x26/0x280 net/bluetooth/af_bluetooth.c:187
 l2cap_sock_teardown_cb+0x197/0x400 net/bluetooth/l2cap_sock.c:1544
 l2cap_chan_del+0xad/0x1300 net/bluetooth/l2cap_core.c:618
 l2cap_chan_close+0x118/0xb10 net/bluetooth/l2cap_core.c:824
 l2cap_chan_timeout+0x173/0x450 net/bluetooth/l2cap_core.c:436
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
---[ end trace 89227449b8393688 ]---
RIP: 0010:__list_del_entry_valid+0x81/0xef lib/list_debug.c:51
Code: 0f 84 df 00 00 00 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 e0 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 51 49 8b 14 24 48 39 ea 0f 85 97 00 00 00 49 8d 7d
RSP: 0018:ffffc900091afb18 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffff8880a71664b8 RCX: ffffffff8724984f
RDX: 17776c2000003777 RSI: ffffffff8717d437 RDI: ffff8880a71664c0
RBP: ffff8880a71664b8 R08: 0000000000000001 R09: ffff8880a7166067
R10: 0000000000000009 R11: 00000000000ccae8 R12: bbbb61000001bbbb
R13: bb60000000bbbbbb R14: 00000060000000bb R15: 0000000000000005
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000ca8660 CR3: 000000009d89f000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
