Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE9133E10
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgAHJOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:14:34 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:35892 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727533AbgAHJON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 04:14:13 -0500
Received: by mail-il1-f199.google.com with SMTP id t2so1668122ilp.3
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 01:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F/P15y+45Tei818irWpEYcChAf5MbUWYAiT/aHn7HYM=;
        b=MXns95rQpdj+J4Uo+pRmKdVEDMf6RkYqWitgyVDsUGDCVuSa1S1oLz2Wkw1ZCCC6Im
         aZ1TMRv79lyYZOMTquBNDTQ0TKVLwuYLVPwgs/mCMhEtG5F8NZnd1jg9ti5SIFC2/YfS
         C6v0keSuezyEdUbW4Jo0G+Z5B7Q4iLMjsqDWbGfnA+3rsin8fG65Cub9p/JvxVMglX1X
         kVb9l5sLkHfQDqwQY9oGFf2Ze5bK7CIm1xVBzsLOgwJSLXOJrKpl4OtppzJTASZrh260
         XrFZrPkByTCQDbJIpJ/pRfASutE8NLD7MJlMW2obdbTPrx7ALeDG5+biNUr9Z3/AET9s
         8JGA==
X-Gm-Message-State: APjAAAWBTCDpPF04/Au3ilsW88xZdsaYOhdNMSCwrgekc1uWUPVgNYpo
        fwX1As8EXnXa/E472TZ2j2bzizIrYEkjEVb1gp8FBD1ZfI/v
X-Google-Smtp-Source: APXvYqxUcNzrjW0BysF6oHz3h1UVdbiXZWFrmKdX8ldU2I6Bcc+gqGARURnjCYr353FoFciNtk5dmF6MQ20T0gJ0qVS17CPmA7RC
MIME-Version: 1.0
X-Received: by 2002:a02:c951:: with SMTP id u17mr3362349jao.27.1578474852557;
 Wed, 08 Jan 2020 01:14:12 -0800 (PST)
Date:   Wed, 08 Jan 2020 01:14:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dfa984059b9d50f8@google.com>
Subject: general protection fault in hash_netnet4_uadt
From:   syzbot <syzbot+654d1074cc322943fbba@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        info@metux.net, jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11714949e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=654d1074cc322943fbba
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a79485e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13090dfee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+654d1074cc322943fbba@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9713 Comm: syz-executor012 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_netnet4_uadt+0x1ff/0xdf0  
net/netfilter/ipset/ip_set_hash_netnet.c:174
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e8 09 00 00 48 89  
da 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48  
89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 ad
RSP: 0018:ffffc90001d67180 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff868394cc RDI: ffff88809afd9464
RBP: ffffc90001d672b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffffc90001d67320
R13: 00000000d3650000 R14: ffffc90001d67200 R15: ffff8880a7fb0b00
FS:  00000000006dd880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000f86 CR3: 00000000a8cc9000 CR4: 00000000001406e0
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
RIP: 0033:0x440939
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd199baef8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440939
RDX: 0000000020000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000006cb018 R08: 0000000000000008 R09: 00000000004002c8
R10: 000000000000000c R11: 0000000000000246 R12: 00000000004021c0
R13: 0000000000402250 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 9a567dbaf42c9317 ]---
RIP: 0010:hash_netnet4_uadt+0x1ff/0xdf0  
net/netfilter/ipset/ip_set_hash_netnet.c:174
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 e8 09 00 00 48 89  
da 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48  
89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 ad
RSP: 0018:ffffc90001d67180 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff868394cc RDI: ffff88809afd9464
RBP: ffffc90001d672b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffffc90001d67320
R13: 00000000d3650000 R14: ffffc90001d67200 R15: ffff8880a7fb0b00
FS:  00000000006dd880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000f86 CR3: 00000000a8cc9000 CR4: 00000000001406e0
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
