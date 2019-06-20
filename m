Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FC44CDF0
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfFTMrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:47:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:40900 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfFTMrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 08:47:06 -0400
Received: by mail-io1-f72.google.com with SMTP id v11so5004095iop.7
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 05:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iNr4pXoRjHYJxCsQLDFZzgF3wWUq5wqzMUmtkVEWxlA=;
        b=fZl1RwqEoHjmg4egwgd7b62uNon9DFfrOxJe1GcS1u36JPfn8XpSxsVfdDLgSYkAE3
         tXTk4cSTEKM1q3GhOvUZMsLeExQxauiJ47lekvCNbDNO4cCWNUgcp/6cxss5qEl5Ovz5
         fWBOlgd006VId9elLZLac26qyFoA/WhWq52Vp1w6H9J7ckf4V2I9ixoThs1ob0z8ZObx
         8U2hDDmKzrYPDWgkkTALn3/Ynq7mLkiC+wVubAbeJvjMK2OoRy+6El35Zyx3sBkSQ5aH
         Pc6AQ+8yVF+Xr68nZaFj398HW/qIoSjQd3Zg+dOI3TWr+Y7E79+/+wVqfMUVBBQ1iCKD
         z6Uw==
X-Gm-Message-State: APjAAAWTygA/9jZlcU3TSzyjz/KvW7n8RaBKRsi6nktR3gF/gC5blH9B
        vXpiIfBCH4WAorPMHvPyns0qo2dsFclrAJ0gIp9tQPdTluA8
X-Google-Smtp-Source: APXvYqxBEHjp/DDJw2j8KTmEawpYVu43gY57TO7tXs5XOqKu3i1FHbungXu60i/kZebeYG996fqJaVdfNDLYBo+ixzhSL8MOVyTb
MIME-Version: 1.0
X-Received: by 2002:a5e:9701:: with SMTP id w1mr7660813ioj.294.1561034825492;
 Thu, 20 Jun 2019 05:47:05 -0700 (PDT)
Date:   Thu, 20 Jun 2019 05:47:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000417551058bc0bef9@google.com>
Subject: kernel BUG at ./include/linux/scatterlist.h:LINE!
From:   syzbot <syzbot+ef0daa6ce95facb233c1@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        vakul.garg@nxp.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    bed3c0d8 Merge tag 'for-5.2-rc5-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=138d485ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=ef0daa6ce95facb233c1
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13175731a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126947faa00000

The bug was bisected to:

commit f295b3ae9f5927e084bd5decdff82390e3471801
Author: Vakul Garg <vakul.garg@nxp.com>
Date:   Wed Mar 20 02:03:36 2019 +0000

     net/tls: Add support of AES128-CCM based ciphers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1738b732a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14b8b732a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b8b732a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ef0daa6ce95facb233c1@syzkaller.appspotmail.com
Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")

RAX: ffffffffffffffda RBX: 00007ffd6d3365b0 RCX: 0000000000441ba9
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000100000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
kernel BUG at ./include/linux/scatterlist.h:97!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8023 Comm: syz-executor694 Not tainted 5.2.0-rc5+ #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:sg_assign_page include/linux/scatterlist.h:97 [inline]
RIP: 0010:sg_set_page include/linux/scatterlist.h:119 [inline]
RIP: 0010:sk_msg_page_add include/linux/skmsg.h:246 [inline]
RIP: 0010:tls_sw_do_sendpage net/tls/tls_sw.c:1170 [inline]
RIP: 0010:tls_sw_sendpage+0x11b5/0x11e0 net/tls/tls_sw.c:1229
Code: c1 38 c1 0f 8c 12 fe ff ff 4c 89 f7 e8 14 bb 27 fb e9 05 fe ff ff e8  
0a 92 ee fa 44 8b 7c 24 18 e9 b2 fe ff ff e8 fb 91 ee fa <0f> 0b e8 f4 91  
ee fa 0f 0b e8 ed 91 ee fa 4c 89 f7 48 c7 c6 87 e5
RSP: 0018:ffff888094adf7c0 EFLAGS: 00010293
RAX: ffffffff86871ff5 RBX: 0000000000000001 RCX: ffff888095bfc300
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888094adf998 R08: ffffffff8687170c R09: fffff9400045851f
R10: fffff9400045851f R11: 1ffffd400045851e R12: 0000000000000000
R13: 0000000000000080 R14: ffffea00022c28c0 R15: 1ffff110124d0d01
FS:  0000555556a2f880(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc5c9d1f18 CR3: 00000000a8a2c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  inet_sendpage+0x16d/0x340 net/ipv4/af_inet.c:815
  kernel_sendpage net/socket.c:3642 [inline]
  sock_sendpage+0xd3/0x120 net/socket.c:940
  pipe_to_sendpage+0x23e/0x310 fs/splice.c:449
  splice_from_pipe_feed fs/splice.c:500 [inline]
  __splice_from_pipe+0x2f7/0x8a0 fs/splice.c:624
  splice_from_pipe fs/splice.c:659 [inline]
  generic_splice_sendpage+0x172/0x200 fs/splice.c:829
  do_splice_from fs/splice.c:848 [inline]
  do_splice fs/splice.c:1155 [inline]
  __do_sys_splice fs/splice.c:1425 [inline]
  __se_sys_splice+0x12ec/0x1db0 fs/splice.c:1405
  __x64_sys_splice+0xe5/0x100 fs/splice.c:1405
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441ba9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 bb 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd6d336548 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00007ffd6d3365b0 RCX: 0000000000441ba9
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000100000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 3b5328faabff785c ]---
RIP: 0010:sg_assign_page include/linux/scatterlist.h:97 [inline]
RIP: 0010:sg_set_page include/linux/scatterlist.h:119 [inline]
RIP: 0010:sk_msg_page_add include/linux/skmsg.h:246 [inline]
RIP: 0010:tls_sw_do_sendpage net/tls/tls_sw.c:1170 [inline]
RIP: 0010:tls_sw_sendpage+0x11b5/0x11e0 net/tls/tls_sw.c:1229
Code: c1 38 c1 0f 8c 12 fe ff ff 4c 89 f7 e8 14 bb 27 fb e9 05 fe ff ff e8  
0a 92 ee fa 44 8b 7c 24 18 e9 b2 fe ff ff e8 fb 91 ee fa <0f> 0b e8 f4 91  
ee fa 0f 0b e8 ed 91 ee fa 4c 89 f7 48 c7 c6 87 e5
RSP: 0018:ffff888094adf7c0 EFLAGS: 00010293
RAX: ffffffff86871ff5 RBX: 0000000000000001 RCX: ffff888095bfc300
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888094adf998 R08: ffffffff8687170c R09: fffff9400045851f
R10: fffff9400045851f R11: 1ffffd400045851e R12: 0000000000000000
R13: 0000000000000080 R14: ffffea00022c28c0 R15: 1ffff110124d0d01
FS:  0000555556a2f880(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc5c9d1f18 CR3: 00000000a8a2c000 CR4: 00000000001406e0
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
