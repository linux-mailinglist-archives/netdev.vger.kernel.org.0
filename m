Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD613D114
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 01:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgAPAZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 19:25:13 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:35044 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgAPAZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 19:25:12 -0500
Received: by mail-io1-f72.google.com with SMTP id x10so11532065iob.2
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E/oWkfdcQbDfePZTjWHYErwHEs0VAeL7p12HZGFsEIk=;
        b=sutFbou7b3h+tJHY15MICZ2qD1i1nNQg/aFhwOrN1Ex6GmT/I5TSBG+cqHzxUrIFJv
         3UGk9sBgJbet1Q7h5rt+2ko4qB3DV5zSW4bzxMxDy7tmPm3oIUD7o0QcrjazlaybQEh2
         73DWNpJpSIzGB/WiNl8X0lzr5IEKZFJ01wDj2mh9ZwHyT370Eek3VW1EUdJ80XrhAzk6
         PfeeTZOOE/p3XyeAApdSUbfWfeNm7fohN7mi6FByQrJ2vGZSKlY20vy/E0POVG+2XVQa
         7goh7k8Ut6G/o4iTAOBDaK0hZ3NANworF6JT2fVRGbr7DR+SJX/nX0hvqQJ8oqsk0vnL
         3qOA==
X-Gm-Message-State: APjAAAX1PcEQdjMfYKn5lGYILJhJwQzb2uD9njePYuP2FIh/khL2553Z
        ohfZvdedO7cWrigJsA9Xy7NdbR5Ul/OL4wU//CPiaTiMjTv7
X-Google-Smtp-Source: APXvYqx2DjN1NUxxTZJDCofOduxEolLGzZZA42hjKihqgv1QIIIN1OvWPIckaKHBUaWrkaJYI6IQBHwhDpVTmUJckIxSYYVVmScE
MIME-Version: 1.0
X-Received: by 2002:a02:c6d5:: with SMTP id r21mr25963661jan.129.1579134311682;
 Wed, 15 Jan 2020 16:25:11 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:25:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3599c059c36db0d@google.com>
Subject: BUG: corrupted list in nf_tables_commit
From:   syzbot <syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16218315e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=37a6804945a3a13b1572
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16ad1821e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d8fc35e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com

list_del corruption, ffff88808c9bb000->prev is LIST_POISON2  
(dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:48!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9707 Comm: syz-executor974 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4f lib/list_debug.c:48
Code: be fd 0f 0b 4c 89 ea 4c 89 f6 48 c7 c7 20 66 71 88 e8 c0 e7 be fd 0f  
0b 4c 89 e2 4c 89 f6 48 c7 c7 80 66 71 88 e8 ac e7 be fd <0f> 0b 4c 89 f6  
48 c7 c7 40 67 71 88 e8 9b e7 be fd 0f 0b cc cc cc
RSP: 0018:ffffc900020273f0 EFLAGS: 00010282
RAX: 000000000000004e RBX: ffff88808c9bb000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e5396 RDI: fffff52000404e70
RBP: ffffc90002027408 R08: 000000000000004e R09: ffffed1015d06621
R10: ffffed1015d06620 R11: ffff8880ae833107 R12: dead000000000122
R13: ffff888093e70d80 R14: ffff88808c9bb000 R15: dffffc0000000000
FS:  0000000000d18880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003ac0 CR3: 0000000096a25000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_del_entry include/linux/list.h:131 [inline]
  list_del_rcu include/linux/rculist.h:148 [inline]
  nf_tables_commit+0x1068/0x3b30 net/netfilter/nf_tables_api.c:7183
  nfnetlink_rcv_batch+0xc78/0x17a0 net/netfilter/nfnetlink.c:485
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
  nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
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
RIP: 0033:0x441aa9
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcfa467588 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441aa9
RDX: 0000000000000042 RSI: 0000000020003ac0 RDI: 0000000000000003
RBP: 0000000000006f6c R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004028d0
R13: 0000000000402960 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 9581ba900963d50f ]---
RIP: 0010:__list_del_entry_valid.cold+0x37/0x4f lib/list_debug.c:48
Code: be fd 0f 0b 4c 89 ea 4c 89 f6 48 c7 c7 20 66 71 88 e8 c0 e7 be fd 0f  
0b 4c 89 e2 4c 89 f6 48 c7 c7 80 66 71 88 e8 ac e7 be fd <0f> 0b 4c 89 f6  
48 c7 c7 40 67 71 88 e8 9b e7 be fd 0f 0b cc cc cc
RSP: 0018:ffffc900020273f0 EFLAGS: 00010282
RAX: 000000000000004e RBX: ffff88808c9bb000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e5396 RDI: fffff52000404e70
RBP: ffffc90002027408 R08: 000000000000004e R09: ffffed1015d06621
R10: ffffed1015d06620 R11: ffff8880ae833107 R12: dead000000000122
R13: ffff888093e70d80 R14: ffff88808c9bb000 R15: dffffc0000000000
FS:  0000000000d18880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020003ac0 CR3: 0000000096a25000 CR4: 00000000001406f0
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
