Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18F9133E0F
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 10:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgAHJOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 04:14:34 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:52287 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbgAHJON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 04:14:13 -0500
Received: by mail-il1-f200.google.com with SMTP id n9so1637464ilm.19
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 01:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eKvPrM3J4OMclQf0daCV6iUfOPitvsR7tyDSKaZDybw=;
        b=eJWbS7DGTsIrzpRuKRu6Ls7A+TbOb3HVNfIojfz+gdlB48DNrZdbOq1bExI0MQqYNB
         unU/QIuXvYKVWqmCAb7oPSUkd5nptUCO3q/bcbILyUU2zRTfyxWOMz5jzCHWn9IGUV3I
         pChZpoEAmvQwBmCGugzBeiaft4kRVDx0F/mY9RGhzjmJNO5cz+zsqn0ndzDhhz3DNsMV
         b2qF6nAIX4epFGIRH+IxBeTy3Y5qhONK2JhepWi/hA6owyrIg+DDg+lcnOwIncyn6bY7
         iXRWwAyjMkS4sc3SchkEx7Gte101mqxZYik0UtgHV2uhb1Jrc5y+s5gmGPK3frNd/YY4
         vGUg==
X-Gm-Message-State: APjAAAXvwO49PHZUZicd+AGMmAtBSWM3C8Kyv3L4HRciYXe1fvcqWzQd
        QYMf6cmCZaUDmbyyY6H9F75h9RlfYxurOCt3hLhCy4WXWR8j
X-Google-Smtp-Source: APXvYqyLKkmplA0KNmj5Pr1HqxCTBXQBFnffc3PQ1vyQACyacZrcHQPr71+usYdJ+50cPsGcvyfbWYZlZzFOVcm3uJbkWeCjS3x2
MIME-Version: 1.0
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr3117747ilq.38.1578474852389;
 Wed, 08 Jan 2020 01:14:12 -0800 (PST)
Date:   Wed, 08 Jan 2020 01:14:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd1cb0059b9d50b7@google.com>
Subject: general protection fault in hash_net4_uadt
From:   syzbot <syzbot+b8e32edde51fdcc8c2c4@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, info@metux.net, jeremy@azazel.net,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
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

HEAD commit:    c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1452e656e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=b8e32edde51fdcc8c2c4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ef2459e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=113b9459e00000

The bug was bisected to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

     netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=146e1469e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=166e1469e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=126e1469e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b8e32edde51fdcc8c2c4@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and  
protocol version 7")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9328 Comm: syz-executor866 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_net4_uadt+0x200/0x940  
net/netfilter/ipset/ip_set_hash_net.c:146
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 92 06 00 00 4c 89  
e2 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 57
RSP: 0018:ffffc90002007190 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90002007320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff86801a0d RDI: ffff88809aba2048
RBP: ffffc900020072b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000000
R13: 0000000009000000 R14: ffff8880a485b000 R15: 0000000000000002
FS:  0000000001f44880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000446 CR3: 00000000a8e94000 CR4: 00000000001406f0
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
RIP: 0033:0x440669
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffde779c858 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440669
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000048 R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401ef0
R13: 0000000000401f80 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace e8c4a3e1455d3dc0 ]---
RIP: 0010:hash_net4_uadt+0x200/0x940  
net/netfilter/ipset/ip_set_hash_net.c:146
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 92 06 00 00 4c 89  
e2 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 57
RSP: 0018:ffffc90002007190 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90002007320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff86801a0d RDI: ffff88809aba2048
RBP: ffffc900020072b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000000
R13: 0000000009000000 R14: ffff8880a485b000 R15: 0000000000000002
FS:  0000000001f44880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000446 CR3: 00000000a8e94000 CR4: 00000000001406f0
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
