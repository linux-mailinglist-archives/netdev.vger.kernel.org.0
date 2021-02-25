Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38D32542D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhBYQ7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:59:31 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:47558 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbhBYQ64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:58:56 -0500
Received: by mail-io1-f70.google.com with SMTP id o4so4819484ioh.14
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 08:58:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BPbe88GcXlpz0yaOYhUzPhZwlga1V2ICU1dgMJbmTmU=;
        b=dGWqp14dYImG1qpV/WmLN3CjVkhHKq7UwEiLPpvSBxng5I4qoMcOQQrkdwqUKzrdmw
         1H3fWrylsDVqjNxLgSRgjEalRhIRUp8l5nH6F4gyb7o7ztP4Xg3WFOyJ81JA8F/6cK7F
         O60Da5Qd3qT1Bd7wAJeUR6B/Y7cAbe3nqbhVRoLjBfKddVlkaH2e0Gacbr/mtn7hJJbs
         ZPe9ecBLZJhdYEZd95nHakGfNseaIOTQLgEVzWt8LTrWzUSkDzVPpVqOgVkcvXksp80Z
         pc5rnWHgd+gx8uwiLIw6mNOsOtK5+drFrrvN4TKr8mUe1IGzAtTQB1s9bcdVQ0+Gtxjg
         BB6A==
X-Gm-Message-State: AOAM5320YQhHATHpE/ot8aZPxjkdwMCEaVWfwfcIH1+zgEBzXxI5rs9S
        n5AXvXadW263DgU6GgIWqNHx1/IZZ31VQhDbUM5pCsfHV++8
X-Google-Smtp-Source: ABdhPJzkzeO1lwwnQ83blFrR5MbrVv+jbYw+MK2hJLd1ji7p8ObeUOTGMooaD1yc484Cp4eSSteTvUFgSZtx4bBXyv0U+BSRxMEI
MIME-Version: 1.0
X-Received: by 2002:a02:3ec7:: with SMTP id s190mr4084646jas.11.1614272293550;
 Thu, 25 Feb 2021 08:58:13 -0800 (PST)
Date:   Thu, 25 Feb 2021 08:58:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0c3fe05bc2c0eeb@google.com>
Subject: WARNING in __alloc_skb
From:   syzbot <syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org,
        mani@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    291009f6 Merge tag 'pm-5.11-rc8' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1481fbacd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1106b4b91e8dfab8
dashboard link: https://syzkaller.appspot.com/bug?extid=80dccaee7c6630fa9dcf
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1358ba02d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12dfb1e2d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com

netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8482 at mm/page_alloc.c:4979 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
Modules linked in:
CPU: 0 PID: 8482 Comm: syz-executor948 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4979
Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
RSP: 0018:ffffc90001777aa0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff920002eef58 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000060a20
RBP: 0000000000020a20 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff86f1b13e R11: 0000000000000000 R12: 000000000000000b
R13: 0000000000400180 R14: 0000000000060a20 R15: ffff888018932dc0
FS:  000000000192b300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020400000 CR3: 0000000025ae7000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __alloc_pages include/linux/gfp.h:511 [inline]
 __alloc_pages_node include/linux/gfp.h:524 [inline]
 alloc_pages_node include/linux/gfp.h:538 [inline]
 kmalloc_large_node+0x60/0x110 mm/slub.c:3999
 __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
 __kmalloc_reserve net/core/skbuff.c:150 [inline]
 __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
 __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
 netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
 qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
 qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x442fe9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc007c27a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007ffc007c27b8 RCX: 0000000000442fe9
RDX: 0000000000400000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc007c27c0
R13: 00007ffc007c27e0 R14: 00000000004b8018 R15: 00000000004004b8


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
