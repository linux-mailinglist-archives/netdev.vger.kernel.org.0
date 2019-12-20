Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1B12740F
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfLTDpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:45:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:36239 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfLTDpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:45:10 -0500
Received: by mail-io1-f72.google.com with SMTP id 144so5228043iou.3
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:45:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dna2/NTPZH/v2wYRfNU5J9PqMpJUPBNX/S2Lv/VYKxU=;
        b=sUWhuPqhDwDW4fr+hy1I+YPRcOZu2KNprnjBfk3VHnuqtqyEVH+Ivf3ZS512vFLIoa
         Jk3sL9FFb9K0lJNxvDonej5VUhJzmJl7WCGU1zYdG0hjaTlFQLhhd9MaIq9/03pXn/cC
         OW0j025I8fTGcSlvGcDxN+NV+eS7564XIZ+YDjSRMlOkbt9lMDOg708ykHMEUBv0IiDn
         5GgFYUALsi2x2XNQkhQvirF2I3ZeAurbjk7jThIGGgnD3xk+stS+YHGQPoUW2lMeGRC3
         AGF3pmzK4AWn44WZSzNRt9clY/c/5/5bRLIVBnecAr402v1Gtpp8RPDums4GQqHnKJqi
         zu1A==
X-Gm-Message-State: APjAAAXa5v6f9jOunPvaRmhH++4g4fqsdLZSl1czlqOJhUFhUEK2QaHs
        ZeYMMKtYVP/D0lg9RPF/e/q22j2aa0UdN3b9IkEoYSHl9QBk
X-Google-Smtp-Source: APXvYqwsZ7Yidf95uPacXveyO65URZZ4u0gPzEyHLq/OkVbPj5QWLBhZu2dKkoZBKj5OJ+K4Sv8NWhBI+cIecQ9T0Y4BAjQBfGUm
MIME-Version: 1.0
X-Received: by 2002:a92:c703:: with SMTP id a3mr9596649ilp.63.1576813509434;
 Thu, 19 Dec 2019 19:45:09 -0800 (PST)
Date:   Thu, 19 Dec 2019 19:45:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001b6443059a1a815d@google.com>
Subject: general protection fault in sctp_stream_free (2)
From:   syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>
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

HEAD commit:    6fa9a115 Merge branch 'stmmac-fixes'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10c4fe99e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=216dca5e1758db87
dashboard link: https://syzkaller.appspot.com/bug?extid=9a1bc632e78a1a98488b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178ada71e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f23a6e00000

The bug was bisected to:

commit 951c6db954a1adefab492f6da805decacabbd1a7
Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Tue Dec 17 01:01:16 2019 +0000

     sctp: fix memleak on err handling of stream initialization

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ffbdb6e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10007db6e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17ffbdb6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com
Fixes: 951c6db954a1 ("sctp: fix memleak on err handling of stream  
initialization")

RBP: 0000000000000004 R08: 0000000000000008 R09: 00007ffc57730031
R10: 0000000020000040 R11: 0000000000000246 R12: 0000000000401f20
R13: 0000000000401fb0 R14: 0000000000000000 R15: 0000000000000000
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9129 Comm: syz-executor521 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:sctp_stream_free+0xe4/0x180 net/sctp/stream.c:183
Code: 07 48 89 d1 48 69 d2 aa 00 00 00 48 c1 e1 0c 48 29 d0 48 8d 04 40 48  
8d 34 c1 e8 57 24 54 fc 48 8d 78 08 48 89 fa 48 c1 ea 03 <42> 80 3c 32 00  
75 6f 48 8b 78 08 e8 1c 4c 77 fa 41 0f b6 45 00 84
RSP: 0018:ffffc90001e17770 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff838f50f6
RDX: 0000000000000001 RSI: ffffffff838f5170 RDI: 0000000000000008
RBP: ffffc90001e177a8 R08: ffff888094206000 R09: fffffbfff16599c2
R10: fffffbfff16599c1 R11: ffffffff8b2cce0f R12: ffff8880a70126e8
R13: ffffed1014e024df R14: dffffc0000000000 R15: ffff8880a70120a8
FS:  0000000000f03880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 000000000986d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  sctp_association_free+0x235/0x7e0 net/sctp/associola.c:350
  sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:934 [inline]
  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1322 [inline]
  sctp_side_effects net/sctp/sm_sideeffect.c:1189 [inline]
  sctp_do_sm+0x3a6a/0x5190 net/sctp/sm_sideeffect.c:1160
  sctp_primitive_ABORT+0xa0/0xd0 net/sctp/primitive.c:104
  sctp_close+0x259/0x960 net/sctp/socket.c:1513
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  __sock_release+0xce/0x280 net/socket.c:592
  sock_close+0x1e/0x30 net/socket.c:1270
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x8e7/0x2ef0 kernel/exit.c:797
  do_group_exit+0x135/0x360 kernel/exit.c:895
  __do_sys_exit_group kernel/exit.c:906 [inline]
  __se_sys_exit_group kernel/exit.c:904 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:904
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43f2f8
Code: Bad RIP value.
RSP: 002b:00007ffc5773ea88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043f2f8
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf0c8 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000020000040 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 0df255c71a71b566 ]---
RIP: 0010:sctp_stream_free+0xe4/0x180 net/sctp/stream.c:183
Code: 07 48 89 d1 48 69 d2 aa 00 00 00 48 c1 e1 0c 48 29 d0 48 8d 04 40 48  
8d 34 c1 e8 57 24 54 fc 48 8d 78 08 48 89 fa 48 c1 ea 03 <42> 80 3c 32 00  
75 6f 48 8b 78 08 e8 1c 4c 77 fa 41 0f b6 45 00 84
RSP: 0018:ffffc90001e17770 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff838f50f6
RDX: 0000000000000001 RSI: ffffffff838f5170 RDI: 0000000000000008
RBP: ffffc90001e177a8 R08: ffff888094206000 R09: fffffbfff16599c2
R10: fffffbfff16599c1 R11: ffffffff8b2cce0f R12: ffff8880a70126e8
R13: ffffed1014e024df R14: dffffc0000000000 R15: ffff8880a70120a8
FS:  0000000000f03880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000043f2ce CR3: 000000000986d000 CR4: 00000000001406e0
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
