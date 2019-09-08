Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CBFACB1E
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 08:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfIHGIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 02:08:10 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37357 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfIHGIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 02:08:10 -0400
Received: by mail-io1-f69.google.com with SMTP id f24so13659365ion.4
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 23:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pme/QyPd22Xy2cwaK6YbwcbICE7ZavNElMJ6SFqTvEw=;
        b=FggQrNlEqKXV4Q8xv+7jNs/ODM0/9yfHg2wJI/ng0Y7nT/SoTCLXAvKA0yZxQqC3aW
         Ki+BRkKnxp77iPj0uU+jG/EQ8XWrGIMTZPEapXHR+gu0K25PRvAyTCbnmoe7lEKh2xiD
         yo4jTIIRveu2TWGysXFUkF6m6TlIZmd6tvzO0qQmEmXXAiOzTp1X855yhvcUW/I4vEOh
         AELgKQ1FNt43rdws1P+Q1J9gKIT8hyy5VRJ2Bkvpior9wUevwPvFEiMe09C9iyUhnOCp
         /lRInrxz8Wqy67+8bLSu8zJi23cVQ+P+86BWPbKaqul+rlEV0kRJLJ1UdLXuGPLqYCKk
         l9Ww==
X-Gm-Message-State: APjAAAWXqCATOpkGT2AD8Xy1ddGXER0dfdqJOucmlk7jiAKk2HrCgnTS
        amHnnyuYScQsDclLLGlJhA1WbMyp1x2BYy70XIlZOdfH9qBW
X-Google-Smtp-Source: APXvYqyhXBluX4Epw8DMyHITdtSUARQAN6IyMuVguPAvBPmcn+W6hc9lTzPpawSouCjJ0Spf/aBn9uvslGB9EGBssBbRjbyER7X0
MIME-Version: 1.0
X-Received: by 2002:a02:354b:: with SMTP id y11mr19669445jae.53.1567922888809;
 Sat, 07 Sep 2019 23:08:08 -0700 (PDT)
Date:   Sat, 07 Sep 2019 23:08:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d2a5c60592047e58@google.com>
Subject: general protection fault in cbs_destroy
From:   syzbot <syzbot+3a8d6a998cbb73bcf337@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14854e71600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
dashboard link: https://syzkaller.appspot.com/bug?extid=3a8d6a998cbb73bcf337
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17998f9e600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10421efa600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3a8d6a998cbb73bcf337@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device batadv0
netlink: 24 bytes leftover after parsing attributes in process  
`syz-executor457'.
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9249 Comm: syz-executor457 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_del_entry_valid+0x6b/0x100 lib/list_debug.c:51
Code: 4c 89 f7 e8 97 d0 58 fe 48 ba 00 01 00 00 00 00 ad de 49 8b 1e 48 39  
d3 74 54 48 83 c2 22 49 39 d7 74 5e 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00  
74 08 4c 89 ff e8 66 d0 58 fe 49 8b 17 4c 39 f2 75
RSP: 0018:ffff88809898f568 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: dead000000000122 RSI: 0000000000000004 RDI: ffff88809fb5a7e8
RBP: ffff88809898f588 R08: dffffc0000000000 R09: ffffed1013131ea8
R10: ffffed1013131ea8 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809fb5a480 R14: ffff88809fb5a7e0 R15: 0000000000000000
FS:  00005555568cb880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000610 CR3: 00000000a3968000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_del_entry include/linux/list.h:131 [inline]
  list_del include/linux/list.h:139 [inline]
  cbs_destroy+0x85/0x3e0 net/sched/sch_cbs.c:435
  qdisc_create+0xff8/0x13e0 net/sched/sch_api.c:1302
  tc_modify_qdisc+0x989/0x1ea0 net/sched/sch_api.c:1652
  rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x19e/0x3d0 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5241
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x787/0x900 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x993/0xc50 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x60d/0x910 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x17c/0x200 net/socket.c:2363
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441b59
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe29572cf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441b59
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 00007ffe29572d10 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 0000000000000000
R13: 00000000004030f0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 226030e488aca074 ]---
RIP: 0010:__list_del_entry_valid+0x6b/0x100 lib/list_debug.c:51
Code: 4c 89 f7 e8 97 d0 58 fe 48 ba 00 01 00 00 00 00 ad de 49 8b 1e 48 39  
d3 74 54 48 83 c2 22 49 39 d7 74 5e 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00  
74 08 4c 89 ff e8 66 d0 58 fe 49 8b 17 4c 39 f2 75
RSP: 0018:ffff88809898f568 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: dead000000000122 RSI: 0000000000000004 RDI: ffff88809fb5a7e8
RBP: ffff88809898f588 R08: dffffc0000000000 R09: ffffed1013131ea8
R10: ffffed1013131ea8 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809fb5a480 R14: ffff88809fb5a7e0 R15: 0000000000000000
FS:  00005555568cb880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000610 CR3: 00000000a3968000 CR4: 00000000001406f0
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
