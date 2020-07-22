Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5DB229F27
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgGVSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:22:26 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33482 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbgGVSWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:22:25 -0400
Received: by mail-il1-f197.google.com with SMTP id c1so1685168ilr.0
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QjAGu9qJnwW6/qpQxapaqa4yJAD+AqPFmsWbiZctomo=;
        b=R6mn310Qid6qlFqf3LJoVOzH0HQ7uJHxb1WfKXurZJGnZLODxD8KTUsHX8AzzI7/Q9
         iSSTZWmudEKi8/Jdqf+sY2NkxmjZA192MgGhsvh+MYFhtnryOMakYKv16yuK5Q8dmF3E
         PWGsC5RtRFbatgKJGgewNV/XuUeXbfff9VfpTEnlJ1rAB3g1Ue160sVTRgDY3qcO2KLk
         NZskzOJN/2xSBKeZD0A4IXlwbw4E72rYw3P/Yt4zihloL2NhNqfnm8R0lzvpuRiBdbIX
         U0Fx9CnJLAr5bMcXpgpk6WxhT9k5usVpWJAlMNVTh4kFhi3BP7jRFhNsEeSrKjkhTmU7
         nnjg==
X-Gm-Message-State: AOAM5310oKDiixLN0l99FEUPIVXzAEUDj6nB+L9y0NFGN6QV8aUCbYUU
        8nCBlZ6KyXsR3GwUCEZVJuQPmL0A0BTzTrJoIkRA+7rdDsmx
X-Google-Smtp-Source: ABdhPJyv9Y36o2lRORaYSsCQ5+3Ea7k5E30s3qWxOKD2y+Au+jhhPCs8O2cfnaS2ij0qdEfKkjDb0NPUIe2Yy/9Xj2WTo2GXEk4S
MIME-Version: 1.0
X-Received: by 2002:a6b:9388:: with SMTP id v130mr1048036iod.134.1595442143656;
 Wed, 22 Jul 2020 11:22:23 -0700 (PDT)
Date:   Wed, 22 Jul 2020 11:22:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b813605ab0bd243@google.com>
Subject: KASAN: slab-out-of-bounds Write in sctp_setsockopt
From:   syzbot <syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4f1b4da5 Merge branch 'net-atlantic-various-features'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14b3a040900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b7b67c0c1819c87
dashboard link: https://syzkaller.appspot.com/bug?extid=0e4699d000d8b874d8dc
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c93358900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ab61f0900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e4699d000d8b874d8dc@syzkaller.appspotmail.com

sctp: [Deprecated]: syz-executor496 (pid 6834) Use of struct sctp_assoc_value in delayed_ack socket option.
Use struct sctp_sack_info instead
==================================================================
BUG: KASAN: slab-out-of-bounds in sctp_setsockopt_delayed_ack net/sctp/socket.c:2771 [inline]
BUG: KASAN: slab-out-of-bounds in sctp_setsockopt net/sctp/socket.c:4499 [inline]
BUG: KASAN: slab-out-of-bounds in sctp_setsockopt+0x9488/0x95e0 net/sctp/socket.c:4431
Write of size 4 at addr ffff8880a2709288 by task syz-executor496/6834

CPU: 0 PID: 6834 Comm: syz-executor496 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 sctp_setsockopt_delayed_ack net/sctp/socket.c:2771 [inline]
 sctp_setsockopt net/sctp/socket.c:4499 [inline]
 sctp_setsockopt+0x9488/0x95e0 net/sctp/socket.c:4431
 __sys_setsockopt+0x337/0x6a0 net/socket.c:2137
 __do_sys_setsockopt net/socket.c:2153 [inline]
 __se_sys_setsockopt net/socket.c:2150 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2150
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440229
Code: Bad RIP value.
RSP: 002b:00007ffc07ceda28 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440229
RDX: 0000000000000010 RSI: 0000000000000084 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
R10: 0000000020000100 R11: 0000000000000246 R12: 0000000000401a30
R13: 0000000000401ac0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6834:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc_track_caller+0x178/0x330 mm/slab.c:3671
 memdup_user+0x22/0xd0 mm/util.c:172
 sctp_setsockopt net/sctp/socket.c:4452 [inline]
 sctp_setsockopt+0x17a/0x95e0 net/sctp/socket.c:4431
 __sys_setsockopt+0x337/0x6a0 net/socket.c:2137
 __do_sys_setsockopt net/socket.c:2153 [inline]
 __se_sys_setsockopt net/socket.c:2150 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2150
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 4827:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 tomoyo_path2_perm+0x28a/0x600 security/tomoyo/file.c:947
 tomoyo_path_rename+0xd2/0x130 security/tomoyo/tomoyo.c:279
 security_path_rename+0x1b5/0x2e0 security/security.c:1135
 do_renameat2+0x481/0xbf0 fs/namei.c:4446
 __do_sys_rename fs/namei.c:4496 [inline]
 __se_sys_rename fs/namei.c:4494 [inline]
 __x64_sys_rename+0x5d/0x80 fs/namei.c:4494
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a2709280
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 8 bytes inside of
 32-byte region [ffff8880a2709280, ffff8880a27092a0)
The buggy address belongs to the page:
page:ffffea000289c240 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a2709fc1
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00026c1108 ffffea00026ae848 ffff8880aa0001c0
raw: ffff8880a2709fc1 ffff8880a2709000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a2709180: 06 fc fc fc fc fc fc fc 06 fc fc fc fc fc fc fc
 ffff8880a2709200: 06 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a2709280: 00 fc fc fc fc fc fc fc 05 fc fc fc fc fc fc fc
                      ^
 ffff8880a2709300: fb fb fb fb fc fc fc fc 06 fc fc fc fc fc fc fc
 ffff8880a2709380: 06 fc fc fc fc fc fc fc 06 fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
