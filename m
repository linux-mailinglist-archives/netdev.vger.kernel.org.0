Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFD395326
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfHTBSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:18:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53003 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbfHTBSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:18:07 -0400
Received: by mail-io1-f71.google.com with SMTP id q5so4797634iof.19
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 18:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aapZa0aWZhJLmZbO8tbDCnMW4n/uSxRYhoOWmflvYeI=;
        b=U83bLRhjYdBRfgDkc6vAlzjQ7wcqTBl+bHYBuJEQ9D98Gnr3+bpZ2wnm2TtbIPOTa7
         6vtR2qq+Ukz4SbdGWdMqtZxy7RQAEus6c3AXHRGV2uoeVWcMLq4uVknns8n0W4Ul/FjZ
         tzheLyH+za5hPOp9YDV0nUkBIhkQyORtLaKNz9rUxwFUOlN7StpiULQzHy8rIfBsQXBF
         1cmu34vTOsXjA6rjq2izi7ALKhMBq1U7Lr00iOceB4RLyOa+3c2oGs1bPHGbBaLzWs89
         JMQPtdTyaN+qq/fQHLZ7Awvppmei+cMe1kF+nYRT7qmL7wY8jseN8n4WLaQFMe5eIsxb
         SELg==
X-Gm-Message-State: APjAAAVfeuG8SoqL8salf8rlgyBoFerTYA4SebOAUybAEiHobpCnIhK1
        1cDoN5Zn2auqFyFPbmQRLwLnsSEYsgggg2W3zZFfsnaABj3A
X-Google-Smtp-Source: APXvYqx7ASRpFwP5v9LMLT+L3CDmS2N+a/epXEs1yURQsv0MuOD1wm6GJbWBTXdXer9T5iX+m3F0TTTCiwqN3aZjB/AMnbIaVs3k
MIME-Version: 1.0
X-Received: by 2002:a6b:b8d7:: with SMTP id i206mr10982249iof.229.1566263886306;
 Mon, 19 Aug 2019 18:18:06 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:18:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009167320590823a8c@google.com>
Subject: general protection fault in xsk_poll
From:   syzbot <syzbot+c82697e3043781e08802@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    da657043 Add linux-next specific files for 20190819
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16af124c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=739a9b3ab3d8c770
dashboard link: https://syzkaller.appspot.com/bug?extid=c82697e3043781e08802
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e1922600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1445bf02600000

The bug was bisected to:

commit 77cd0d7b3f257fd0e3096b4fdcff1a7d38e99e10
Author: Magnus Karlsson <magnus.karlsson@intel.com>
Date:   Wed Aug 14 07:27:17 2019 +0000

     xsk: add support for need_wakeup flag in AF_XDP rings

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e1ea4c600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e1ea4c600000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e1ea4c600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP  
rings")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 7959 Comm: syz-executor611 Not tainted 5.3.0-rc5-next-20190819  
#68
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:xsk_poll+0x95/0x540 net/xdp/xsk.c:386
Code: 80 3c 02 00 0f 85 70 04 00 00 4c 8b a3 88 04 00 00 48 b8 00 00 00 00  
00 fc ff df 49 8d bc 24 96 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 bf 03 00 00
RSP: 0018:ffff8880926f7850 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff88809a141700 RCX: ffffffff859b07aa
RDX: 0000000000000012 RSI: ffffffff859b07c4 RDI: 0000000000000096
RBP: ffff8880926f7880 R08: ffff88809698a580 R09: ffffed1013428329
R10: ffffed1013428328 R11: ffff88809a141947 R12: 0000000000000000
R13: 0000000000000304 R14: ffff888095d4d840 R15: ffff888092bdd020
FS:  0000555557529880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 0000000098281000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  sock_poll+0x15e/0x480 net/socket.c:1256
  vfs_poll include/linux/poll.h:90 [inline]
  do_pollfd fs/select.c:859 [inline]
  do_poll fs/select.c:907 [inline]
  do_sys_poll+0x7c2/0xde0 fs/select.c:1001
  __do_sys_ppoll fs/select.c:1101 [inline]
  __se_sys_ppoll fs/select.c:1081 [inline]
  __x64_sys_ppoll+0x259/0x310 fs/select.c:1081
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440159
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd9fbd16e8 EFLAGS: 00000246 ORIG_RAX: 000000000000010f
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440159
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000020000280
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004019e0
R13: 0000000000401a70 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace da907175426b4065 ]---
RIP: 0010:xsk_poll+0x95/0x540 net/xdp/xsk.c:386
Code: 80 3c 02 00 0f 85 70 04 00 00 4c 8b a3 88 04 00 00 48 b8 00 00 00 00  
00 fc ff df 49 8d bc 24 96 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 bf 03 00 00
RSP: 0018:ffff8880926f7850 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff88809a141700 RCX: ffffffff859b07aa
RDX: 0000000000000012 RSI: ffffffff859b07c4 RDI: 0000000000000096
RBP: ffff8880926f7880 R08: ffff88809698a580 R09: ffffed1013428329
R10: ffffed1013428328 R11: ffff88809a141947 R12: 0000000000000000
R13: 0000000000000304 R14: ffff888095d4d840 R15: ffff888092bdd020
FS:  0000555557529880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 0000000098281000 CR4: 00000000001406e0
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
