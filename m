Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7884E10D015
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 01:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfK2AFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 19:05:07 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:41603 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfK2AFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 19:05:06 -0500
Received: by mail-io1-f72.google.com with SMTP id p2so19004496ioh.8
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 16:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=w/HvLkOSu/v5/h3baM8jZB3a9xl/Qrwfh5SeJXgTDvA=;
        b=QGoQYi8RcxbEZw4Lrq+DEhRuRUPWO64YFRvKu2/w8iedAcutzKIujog3Ml8+XjMTkz
         JtirqUxwZoH8MvEMFwi/VB5bKibtK/tJs27UtFXvOEpwb6WRHEoaCEzaODpBjtTJfT/N
         X1dwvDRBrtOt7uBj1sbE2nFw9mJ/6vsew9AdrjblAwA8+3F/yv2oU2xfE8vob0sNhCDn
         BU9fH9PBJLxv+L3OsumteJeTyCKuI1cQooRQjyFju+hIhHov1blX3J30Dosnh89+5lLz
         VLbmBI4xELi1MN9vGjYvYgZyrMoMKvCPIwTjLW34TAsPQua7FWU1/Siu/rpq/9oMvjsB
         mOqQ==
X-Gm-Message-State: APjAAAUlBNhi4X2vG2qmNNbCwwvxzxk7wv+dlpu4okD/uQx5jp9qNjQg
        TMU6aRC/Su2A7ACzxVm7Axg6+YGkxDl2ryXjEDeeOuiLxKO4
X-Google-Smtp-Source: APXvYqymwSQ1v3AUjhQQYR7YffI3wT8H0KBte/hHJIiGucB2l82dyqjQ/Nj4W/ozbfwXFBgZutxwaMtceUqaSB7OUZIChTztBMqZ
MIME-Version: 1.0
X-Received: by 2002:a92:ce06:: with SMTP id b6mr48880153ilo.14.1574985905877;
 Thu, 28 Nov 2019 16:05:05 -0800 (PST)
Date:   Thu, 28 Nov 2019 16:05:05 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000723a32059870fbd4@google.com>
Subject: general protection fault in smack_socket_sendmsg (2)
From:   syzbot <syzbot+131d2229316b7012ac06@syzkaller.appspotmail.com>
To:     a@unstable.cc, andrew@lunn.ch, b.a.t.m.a.n@lists.open-mesh.org,
        casey@schaufler-ca.com, davem@davemloft.net, f.fainelli@gmail.com,
        jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, serge@hallyn.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com,
        vivien.didelot@savoirfairelinux.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0be0ee71 vfs: properly and reliably lock f_pos in fdget_po..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c49ef2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=330a1f54d1edb817
dashboard link: https://syzkaller.appspot.com/bug?extid=131d2229316b7012ac06
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bb67cee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12460136e00000

The bug was bisected to:

commit 8ae5bcdc5d98a99e59f194101e7acd2e9d055758
Author: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Date:   Fri May 19 21:00:54 2017 +0000

     net: dsa: add MDB notifier

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17ec2f5ae00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=141c2f5ae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=101c2f5ae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+131d2229316b7012ac06@syzkaller.appspotmail.com
Fixes: 8ae5bcdc5d98 ("net: dsa: add MDB notifier")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 7989 Comm: kworker/1:4 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
RIP: 0010:smack_socket_sendmsg+0x5b/0x480 security/smack/smack_lsm.c:3675
Code: e8 fa 03 6b fe 4c 89 e8 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 ef e8  
74 46 a4 fe 4d 8b 65 00 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00  
74 08 48 89 df e8 56 46 a4 fe 4c 8b 33 49 8d 9e 08
RSP: 0018:ffff88808a58f9c8 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff8880a1270280
RDX: 0000000000000000 RSI: ffff88808a58fb18 RDI: 0000000000000000
RBP: ffff88808a58fa80 R08: ffffffff83442500 R09: ffff88808a58fb86
R10: ffffed10114b1f72 R11: 0000000000000000 R12: ffff8880a124c114
R13: ffff88808a58fb18 R14: dffffc0000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe2d48c9e78 CR3: 0000000098a23000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  security_socket_sendmsg+0x6c/0xd0 security/security.c:2013
  sock_sendmsg net/socket.c:655 [inline]
  kernel_sendmsg+0x77/0x140 net/socket.c:678
  rxrpc_send_keepalive+0x254/0x3c0 net/rxrpc/output.c:655
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:376 [inline]
  rxrpc_peer_keepalive_worker+0x76e/0xb40 net/rxrpc/peer_event.c:437
  process_one_work+0x7ef/0x10e0 kernel/workqueue.c:2269
  worker_thread+0xc01/0x1630 kernel/workqueue.c:2415
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 8b748724da7e3b28 ]---
RIP: 0010:smack_socket_sendmsg+0x5b/0x480 security/smack/smack_lsm.c:3675
Code: e8 fa 03 6b fe 4c 89 e8 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 ef e8  
74 46 a4 fe 4d 8b 65 00 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00  
74 08 48 89 df e8 56 46 a4 fe 4c 8b 33 49 8d 9e 08
RSP: 0018:ffff88808a58f9c8 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff8880a1270280
RDX: 0000000000000000 RSI: ffff88808a58fb18 RDI: 0000000000000000
RBP: ffff88808a58fa80 R08: ffffffff83442500 R09: ffff88808a58fb86
R10: ffffed10114b1f72 R11: 0000000000000000 R12: ffff8880a124c114
R13: ffff88808a58fb18 R14: dffffc0000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe2d48c9e78 CR3: 0000000098a23000 CR4: 00000000001406e0
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
