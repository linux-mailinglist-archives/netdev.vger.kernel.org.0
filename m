Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3168ACEC50
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfJGS7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 14:59:35 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34136 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbfJGS7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 14:59:13 -0400
Received: by mail-io1-f71.google.com with SMTP id z10so28402896ioj.1
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 11:59:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GrVx4R2TSBBXTVnwndCSWUFdFGmwDx1aYPlI5rVweMs=;
        b=hm1m+/iJP0mgDo61WVJFNlI6Ha6wohJ8tKZfL0OHQfBYV7TNKXKVI1b1zZtvVfcOM0
         Gzlu6LMpc7D2RdS0UW0B1AKqVOZAdltL23d/1c3vjYemKRMDLTnuqDGcMic8lRNxYL0b
         hr6DV4xL3DFAIWxW2ClueK1v6hrZ0CYYygnMygjtXp2firnXw3HHVdIbbnUFKGY3O+yn
         po+gu1XDW88qdJPNwKXjvyQWW9JV2eN7lB6ZbkoV0ODkMZDCvhM1SgSpxOxluBf/Bh7G
         WCPS3o4yKHdKgCKdXVUjRCI0HcsORVmGNGmF33SRQmPC30INaCwIxjKOpJyIEqWpRJv2
         GVTQ==
X-Gm-Message-State: APjAAAX5i2JowJdyXjJcVqaLj/LTqWZ5AhNEmcsj8FFO2JRuS4uTJ92T
        /SBWNGOI/PevAgJ1JGx4j62MWlNqPkcA5nfw1oMzm47DJyuR
X-Google-Smtp-Source: APXvYqwejDKuAeexkMPDzZGVQwxrmuUIqx1wT/LFpoCz8L6mzXx+bksAIbMy/P68xH31YByWdWefyeK1irDcA0xmWbUjabXPP2Ip
MIME-Version: 1.0
X-Received: by 2002:a05:6602:10d:: with SMTP id s13mr16461353iot.244.1570474751494;
 Mon, 07 Oct 2019 11:59:11 -0700 (PDT)
Date:   Mon, 07 Oct 2019 11:59:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b11343059456a5f5@google.com>
Subject: general protection fault in devlink_get_from_attrs
From:   syzbot <syzbot+896295c817162503d359@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    056ddc38 Merge branch 'stmmac-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1590218f600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=896295c817162503d359
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a6a6c3600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fd50dd600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+896295c817162503d359@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8790 Comm: syz-executor447 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:devlink_get_from_attrs+0x32/0x300 net/core/devlink.c:124
Code: 41 55 41 54 53 48 89 f3 48 83 ec 10 48 89 7d c8 e8 03 f6 bf fb 48 8d  
7b 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 84 02 00 00 4c 8b 6b 08 4d 85 ed 0f 84 d9 01 00
RSP: 0018:ffff8880944bf438 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff85b31cdd RDI: 0000000000000008
RBP: ffff8880944bf470 R08: 1ffffffff13360d4 R09: fffffbfff13360d5
R10: ffff8880944bf470 R11: ffffffff899b06a7 R12: ffff8880a1fa47b8
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880a1fa4830
FS:  00000000015e8880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000284 CR3: 00000000a1620000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  devlink_health_reporter_get_from_cb net/core/devlink.c:4991 [inline]
  devlink_nl_cmd_health_reporter_dump_get_dumpit+0x15b/0x930  
net/core/devlink.c:5246
  genl_lock_dumpit+0x86/0xc0 net/netlink/genetlink.c:529
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
  __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2352
  genl_family_rcv_msg_dumpit net/netlink/genetlink.c:614 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:710 [inline]
  genl_rcv_msg+0xc9b/0x1000 net/netlink/genetlink.c:730
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:741
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4401e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe414d6368 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401e9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a70
R13: 0000000000401b00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 9a97fc0240c52134 ]---
RIP: 0010:devlink_get_from_attrs+0x32/0x300 net/core/devlink.c:124
Code: 41 55 41 54 53 48 89 f3 48 83 ec 10 48 89 7d c8 e8 03 f6 bf fb 48 8d  
7b 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 84 02 00 00 4c 8b 6b 08 4d 85 ed 0f 84 d9 01 00
RSP: 0018:ffff8880944bf438 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff85b31cdd RDI: 0000000000000008
RBP: ffff8880944bf470 R08: 1ffffffff13360d4 R09: fffffbfff13360d5
R10: ffff8880944bf470 R11: ffffffff899b06a7 R12: ffff8880a1fa47b8
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880a1fa4830
FS:  00000000015e8880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000284 CR3: 00000000a1620000 CR4: 00000000001406e0
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
