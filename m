Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646E0140B55
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAQNqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:46:13 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:33227 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgAQNqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:46:13 -0500
Received: by mail-io1-f70.google.com with SMTP id i8so15101135ioi.0
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 05:46:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6yTFvZSIUTFje0iuJnrv+aFaKQQ7ngAb+Df8VB7qUuE=;
        b=DpDJb4Xf7NmALUYL1BjPjBTeRf+iggOtdCVxHTIleDXHPSUyrsSzCPQQtfxRDMJHjD
         vPdIrjVSD3SAE8fQ4ljN7JoyjXTRN7STPIptvtbhm3nXZ+KBr/jzKy4J9yXSdGEeD3/0
         E+x5jabOu2PMZIpfXJngqnLcF7/+eXjmyo8jbEEJDvgeqlkiiVozDePc3YcFQLNHAAh3
         peX5vBXl85jaz/bC4o5doi0QDOpmDKB5qN8XrvFsWwF5ceEIhlYDptNgW3rXJ6IKHwLF
         LNcMP+5/5I7CrRrWzYrCSiXBbzJoUIySmJD1QnVL01qEfqUQ9VjTx89obBhHvt7HNVZE
         RLUA==
X-Gm-Message-State: APjAAAWUjUKTDMRiVCurn0Fldt/7/VURlSGRii6vvG7Un3VP5zi9+kC0
        KWia5FsDARvfjeGGr9KVsBQHGcB/Y3KJeTYXYdaZBEIG9DlE
X-Google-Smtp-Source: APXvYqxGuic3bOydwwi/re48vM4+4utcWXYqsSf8/oQciD92zM4NBaFfeVipZ8ahJOjxWMX5uvXia/u/ukkMhiS7X6s2W7BrGeRv
MIME-Version: 1.0
X-Received: by 2002:a5e:dd03:: with SMTP id t3mr30554369iop.128.1579268772517;
 Fri, 17 Jan 2020 05:46:12 -0800 (PST)
Date:   Fri, 17 Jan 2020 05:46:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030dddb059c562a3f@google.com>
Subject: general protection fault in can_rx_register
From:   syzbot <syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev.kurt@vandijck-laurijssen.be,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org,
        o.rempel@pengutronix.de, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f5ae2ea6 Fix built-in early-load Intel microcode alignment
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1033df15e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=c3ea30e1e2485573f953
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/  
c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13204f15e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138f5db9e00000

The bug was bisected to:

commit 9868b5d44f3df9dd75247acd23dddff0a42f79be
Author: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Date:   Mon Oct 8 09:48:33 2018 +0000

     can: introduce CAN_REQUIRED_SIZE macro

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129bfdb9e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=119bfdb9e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=169bfdb9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
Fixes: 9868b5d44f3d ("can: introduce CAN_REQUIRED_SIZE macro")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9593 Comm: syz-executor302 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hlist_add_head_rcu include/linux/rculist.h:528 [inline]
RIP: 0010:can_rx_register+0x43b/0x600 net/can/af_can.c:476
Code: 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 89 22 8a fa 4c  
89 33 4d 89 e5 49 c1 ed 03 48 b8 00 00 00 00 00 fc ff df <41> 80 7c 05 00  
00 74 08 4c 89 e7 e8 c5 21 8a fa 4d 8b 34 24 4c 89
RSP: 0018:ffffc90003e27d00 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880a77336c8 RCX: ffff88809306a100
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a77336c0
RBP: ffffc90003e27d58 R08: ffffffff87289cd6 R09: fffff520007c4f94
R10: fffff520007c4f94 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000001 R14: ffff88809fbcf000 R15: ffff8880a7733690
FS:  00007fb132f26700(0000) GS:ffff8880aec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000178f590 CR3: 00000000996d6000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  raw_enable_filters net/can/raw.c:189 [inline]
  raw_enable_allfilters net/can/raw.c:255 [inline]
  raw_bind+0x326/0x1230 net/can/raw.c:428
  __sys_bind+0x2bd/0x3a0 net/socket.c:1649
  __do_sys_bind net/socket.c:1660 [inline]
  __se_sys_bind net/socket.c:1658 [inline]
  __x64_sys_bind+0x7a/0x90 net/socket.c:1658
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446ba9
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fb132f25d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000006dbc88 RCX: 0000000000446ba9
RDX: 0000000000000008 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000006dbc80 R08: 00007fb132f26700 R09: 0000000000000000
R10: 00007fb132f26700 R11: 0000000000000246 R12: 00000000006dbc8c
R13: 0000000000000000 R14: 0000000000000000 R15: 068500100000003c
Modules linked in:
---[ end trace 0dedabb13ca8e7d7 ]---
RIP: 0010:hlist_add_head_rcu include/linux/rculist.h:528 [inline]
RIP: 0010:can_rx_register+0x43b/0x600 net/can/af_can.c:476
Code: 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 89 22 8a fa 4c  
89 33 4d 89 e5 49 c1 ed 03 48 b8 00 00 00 00 00 fc ff df <41> 80 7c 05 00  
00 74 08 4c 89 e7 e8 c5 21 8a fa 4d 8b 34 24 4c 89
RSP: 0018:ffffc90003e27d00 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880a77336c8 RCX: ffff88809306a100
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a77336c0
RBP: ffffc90003e27d58 R08: ffffffff87289cd6 R09: fffff520007c4f94
R10: fffff520007c4f94 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000001 R14: ffff88809fbcf000 R15: ffff8880a7733690
FS:  00007fb132f26700(0000) GS:ffff8880aec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000178f590 CR3: 00000000996d6000 CR4: 00000000001406f0
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
