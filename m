Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D834728E
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfFOXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:36:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48225 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfFOXgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:36:07 -0400
Received: by mail-io1-f71.google.com with SMTP id z19so7525234ioi.15
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 16:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A0xxLEpAS6xzeE3IwS+rre1Bstu3yn+UJKPxvopq0AE=;
        b=rZdXehrwcbeMgBKK4dNuEenJ6oNyUEwj/EOhbyR3RNqUewoAZSvcG76a02HAD8WMT/
         SgzbCTlYHY03NnO/8ik8TqwhZWzMVgA7RS8oARxWrHKcJ5QEtnEb4/vqHX2bsIukKQh9
         XWuf6IXzDddLz1WzckU3NlvrxnE/KydQfQmKyTWqbK3UCeLXn4ijYp6iUomcST0njymy
         NBiPT/XZbUbgShV+7DxGzWmhW83/jLpQVP5/ztkl1BkZ35S/vRI1XBHDjjs6TGsae67r
         jixGwy2HCo/H8ehvbYvGU5nVI6YhYObQxlm9/gaV8hosGO+rDsfQOYLJM5tZhT3WD6Bq
         JW3Q==
X-Gm-Message-State: APjAAAUpF+0BN0ohyritBcM/CqGKUUfLIXaN3Sq1Qt2KI+IQtV79QKRq
        v9bf+xyFgtDlsMasw/6LzxPY1kXl+F3O4R3d0jFRxQ5hoTp+
X-Google-Smtp-Source: APXvYqw15q1PS+pa+HxNorc6r9EeGlkrFu+2dK/kQTJ2k7U2BiQnU/gI0aXvWrXQHdWa/7vNJQUOhd9jPLLa1uVcQB5rX7hiT5wr
MIME-Version: 1.0
X-Received: by 2002:a6b:90c1:: with SMTP id s184mr35599437iod.244.1560641766135;
 Sat, 15 Jun 2019 16:36:06 -0700 (PDT)
Date:   Sat, 15 Jun 2019 16:36:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017a264058b653a58@google.com>
Subject: general protection fault in sctp_sched_prio_sched
From:   syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    35fc07ae Merge branch 'tcp-add-three-static-keys'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=118e5caea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e8b7a9cd7feeb720
dashboard link: https://syzkaller.appspot.com/bug?extid=c1a380d42b190ad1e559
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11551df1a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12417076a00000

The bug was bisected to:

commit 4ff40b86262b73553ee47cc3784ce8ba0f220bd8
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jan 21 18:42:09 2019 +0000

     sctp: set chunk transport correctly when it's a new asoc

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=104d1df1a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=124d1df1a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=144d1df1a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com
Fixes: 4ff40b86262b ("sctp: set chunk transport correctly when it's a new  
asoc")

kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8330 Comm: syz-executor666 Not tainted 5.2.0-rc3+ #52
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:sctp_sched_prio_sched+0x96/0x6f0 net/sctp/stream_sched_prio.c:132
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 0d 05 00 00 48 b8 00 00 00 00  
00 fc ff df 4c 8b 73 50 4d 8d 6e 20 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f  
85 f4 04 00 00 4d 8b 7e 20 4d 85 ff 0f 84 f8 00 00
RSP: 0018:ffff88809e4e7448 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880a9533b80 RCX: 1ffff11010347201
RDX: 0000000000000004 RSI: ffffffff8696a77e RDI: ffff8880a9533bd0
RBP: ffff88809e4e7488 R08: ffff88808bf8e300 R09: ffff88809e4e7580
R10: ffffed1013c9cee2 R11: 0000000000000003 R12: ffff8880a9533bc0
R13: 0000000000000020 R14: 0000000000000000 R15: ffff8880a4e92380
FS:  00007f48c9337700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f48c9315e78 CR3: 000000009db54000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  sctp_sched_prio_enqueue+0x117/0x170 net/sctp/stream_sched_prio.c:243
  sctp_cmd_send_msg net/sctp/sm_sideeffect.c:1101 [inline]
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1748 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1184 [inline]
  sctp_do_sm+0x2fd0/0x5190 net/sctp/sm_sideeffect.c:1155
  sctp_primitive_SEND+0xa0/0xd0 net/sctp/primitive.c:163
  sctp_sendmsg_to_asoc+0x1118/0x1f10 net/sctp/socket.c:1944
  sctp_sendmsg+0x109a/0x17d0 net/sctp/socket.c:2102
  inet_sendmsg+0x141/0x5d0 net/ipv4/af_inet.c:798
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:665
  sock_write_iter+0x27c/0x3e0 net/socket.c:994
  call_write_iter include/linux/fs.h:1872 [inline]
  new_sync_write+0x4d3/0x770 fs/read_write.c:483
  __vfs_write+0xe1/0x110 fs/read_write.c:496
  vfs_write+0x20c/0x580 fs/read_write.c:558
  ksys_write+0x14f/0x290 fs/read_write.c:611
  __do_sys_write fs/read_write.c:623 [inline]
  __se_sys_write fs/read_write.c:620 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:620
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x447a69
Code: e8 cc e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 3b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f48c9336d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000006ddc38 RCX: 0000000000447a69
RDX: 0000000000010094 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006ddc30 R08: 00007f48c9337700 R09: 0000000000000000
R10: 00007f48c9337700 R11: 0000000000000246 R12: 00000000006ddc3c
R13: 00007f48c9336d90 R14: 00007f48c93379c0 R15: 00000000006ddc3c
Modules linked in:
---[ end trace 01e405583d741588 ]---
RIP: 0010:sctp_sched_prio_sched+0x96/0x6f0 net/sctp/stream_sched_prio.c:132
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 0d 05 00 00 48 b8 00 00 00 00  
00 fc ff df 4c 8b 73 50 4d 8d 6e 20 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f  
85 f4 04 00 00 4d 8b 7e 20 4d 85 ff 0f 84 f8 00 00
RSP: 0018:ffff88809e4e7448 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880a9533b80 RCX: 1ffff11010347201
RDX: 0000000000000004 RSI: ffffffff8696a77e RDI: ffff8880a9533bd0
RBP: ffff88809e4e7488 R08: ffff88808bf8e300 R09: ffff88809e4e7580
R10: ffffed1013c9cee2 R11: 0000000000000003 R12: ffff8880a9533bc0
R13: 0000000000000020 R14: 0000000000000000 R15: ffff8880a4e92380
FS:  00007f48c9337700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000460687 CR3: 000000009db54000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
