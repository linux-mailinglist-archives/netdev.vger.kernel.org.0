Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD9E133E1F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgAHJOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:14:39 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:52071 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgAHJON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 04:14:13 -0500
Received: by mail-il1-f197.google.com with SMTP id v13so1627736ili.18
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 01:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FT33tEfkvMIpM8nwKiXW4vOEy6gcoBd6uE3ed+Lj2r8=;
        b=jod5qriblW5vcFNIbnqFtFhVZmO7ay5ZOfbAHsWv95pU7wccFUTr2hhT+JSsId0y4q
         Y4UXLNDGZbXEfgtVcvOnccs3al0Ad63920Ms/ni1bDOA1P2htvVDACOqEL96PpGOmHDy
         Y2nvhXBwtoeFmRJmM9IudK9ZSy5usmh96s9kGj1I4tvvXrfSfEQbcqoCGe3L+8BOzqnr
         foqhLZ1OxmgXblUbSow39z/5c9fAHNJBo6KwWj9p5DkJsCnI0pywnSE+mYnzMJotPFV5
         0craR+6oL944+8QCUJidtC2yZKst7WlEUbk3sXSjaC1SfhltdbAQLKy2qj/LkCYfm3bv
         Qgog==
X-Gm-Message-State: APjAAAVjlHuy/QbYzMiOtYrgZxKV9e+e4QKc8V5eLi25d177KP6rkx5n
        aRYcqjvdoi25xXwLSj7kUztCLAJCpWFOWVbfHm+dhbZSzln2
X-Google-Smtp-Source: APXvYqxbMIKjRvFuosKghfGoy3BjVGmmXy4mMhp+xL43bQLhsiTEfyIcmZlRjEy4TItFtlDewE06NUgjqXH1S69+SJt2YSZtSI69
MIME-Version: 1.0
X-Received: by 2002:a6b:f404:: with SMTP id i4mr2576079iog.175.1578474852194;
 Wed, 08 Jan 2020 01:14:12 -0800 (PST)
Date:   Wed, 08 Jan 2020 01:14:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000da2154059b9d5055@google.com>
Subject: general protection fault in hash_ip6_uadt
From:   syzbot <syzbot+7f87c1e8811ab0c1ca1f@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fe1469e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=7f87c1e8811ab0c1ca1f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1483fec6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fd2325e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7f87c1e8811ab0c1ca1f@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9593 Comm: syz-executor705 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_ip6_uadt+0x1f2/0x670 net/netfilter/ipset/ip_set_hash_ip.c:242
Code: 11 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85 c2 03 00 00 4c  
89 f2 8b 48 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 80
RSP: 0018:ffffc90001dd71b0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff920003bae3a RCX: 0000000002000000
RDX: 0000000000000000 RSI: ffffffff8679051b RDI: ffff8880a24000e0
RBP: ffffc90001dd72b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffffc90001dd7320
R13: ffff8880a6731200 R14: 0000000000000000 R15: ffffc90001dd7200
FS:  0000000001d64880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000058 CR3: 00000000a85bc000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg net/socket.c:2424 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4403a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcb1400f28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403a9
RDX: 0000000020000000 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401c30
R13: 0000000000401cc0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 2613125a52c78203 ]---
RIP: 0010:hash_ip6_uadt+0x1f2/0x670 net/netfilter/ipset/ip_set_hash_ip.c:242
Code: 11 48 89 fa 83 e2 07 83 c2 03 38 ca 7c 08 84 c9 0f 85 c2 03 00 00 4c  
89 f2 8b 48 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 80
RSP: 0018:ffffc90001dd71b0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff920003bae3a RCX: 0000000002000000
RDX: 0000000000000000 RSI: ffffffff8679051b RDI: ffff8880a24000e0
RBP: ffffc90001dd72b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffffc90001dd7320
R13: ffff8880a6731200 R14: 0000000000000000 R15: ffffc90001dd7200
FS:  0000000001d64880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000058 CR3: 00000000a85bc000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
