Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DAC134711
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgAHQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:04:14 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:52404 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgAHQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:04:11 -0500
Received: by mail-il1-f200.google.com with SMTP id n9so2414735ilm.19
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:04:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0ql51vCXD/7O9m49nxhLaO28UcXFQ02g+94droshIoE=;
        b=EMS4TWsRgglNH/hn/+8b8fh6hvS/tO7QwRET6Enb6M187GTEBiEGf5r9NkArX9Y5Le
         YACSP70mUaoG97ds1lM4WQklkvlZvih8Fq+Krzxm8r59/yGZZDHfY4oJKUb1ple6PBd5
         e64FJhDfjAxk66PoDsXihoaAKxYf2uBlOMF9nL4j6l0RJsgvSSOP9CUimcm4CeiqB/fM
         WQ++pJFTA9P81Lq0CFMitqzei9BopV/IFfhesAvkDciZgr/HMMtD+58HRiQDULEqZFcJ
         mb2iybONiwMvuf+itTmJ6xwroGCpBPUnHa5Q6gJdGUKG76l+oqSiGWV2hdlgNAovGbSs
         Ym4Q==
X-Gm-Message-State: APjAAAV+YIJ687dX7KosKF6EtH/UpDIrdmhMw7P5QMDXbdaChEStFvtE
        wGdKVYL2j016n1KX4bkNVTA6WYHWIruCL7EQsyZlMjAqyG88
X-Google-Smtp-Source: APXvYqzbavVTTUHbb/1qru7jc96xgIWfpvJ3CU5HKJ2OEEM3kmMgwTfD66qOwZQBjyWEktuzti8EI50faSKzA7oAtHUBrdjaxlg+
MIME-Version: 1.0
X-Received: by 2002:a02:cd31:: with SMTP id h17mr4602297jaq.94.1578499450243;
 Wed, 08 Jan 2020 08:04:10 -0800 (PST)
Date:   Wed, 08 Jan 2020 08:04:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002902c059ba30b4b@google.com>
Subject: general protection fault in hash_ipportip6_uadt
From:   syzbot <syzbot+19df0457b3f8383e02bd@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=17a8e885e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=19df0457b3f8383e02bd
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ccdf51e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123dd5fee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+19df0457b3f8383e02bd@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9515 Comm: syz-executor397 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_ipportip6_uadt+0x226/0xa00  
net/netfilter/ipset/ip_set_hash_ipportip.c:285
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 14 07 00 00 4c 89  
ea 45 8b 76 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 d9
RSP: 0018:ffffc90001d07170 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90001d07320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867d0153 RDI: ffff888094d55430
RBP: ffffc90001d072b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffff8880a6f34c00
R13: 0000000000000000 R14: 0000000004000000 R15: 0000000000000002
FS:  0000000001348880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 00000000a2c54000 CR4: 00000000001406f0
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
RIP: 0033:0x441469
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe390fa778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441469
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000000166ea R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402290
R13: 0000000000402320 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 12a892406cf2adb8 ]---
RIP: 0010:hash_ipportip6_uadt+0x226/0xa00  
net/netfilter/ipset/ip_set_hash_ipportip.c:285
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 14 07 00 00 4c 89  
ea 45 8b 76 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 d9
RSP: 0018:ffffc90001d07170 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc90001d07320 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867d0153 RDI: ffff888094d55430
RBP: ffffc90001d072b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffff8880a6f34c00
R13: 0000000000000000 R14: 0000000004000000 R15: 0000000000000002
FS:  0000000001348880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 00000000a2c54000 CR4: 00000000001406f0
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
