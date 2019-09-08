Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9045ACB22
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfIHGIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 02:08:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:43085 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfIHGIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 02:08:10 -0400
Received: by mail-io1-f70.google.com with SMTP id x21so13599946ion.10
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 23:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yj2YlnjQctkoAeKZE0Ar/EAaQjrJLRb0J232XbUHJfo=;
        b=FX1p+tTA1mltqnZI5guMGDeZTuLJsA1W2bvDv5Yj+duEev0EcA8zX8cVuXY2urBenq
         aI03nQRy+rWMhNracW9Q54awAhq5Hiv4omeghOKCCAKvcVfWgPFXWCgJD2iuN1LMFLib
         NXymeCAVO8es3LTYGlA7UAXI184sN3eYuFcjTkHwYJqMmCuN8yFqT2vQgnTabeSmlz93
         zbbJ4ukwADd1e4xfSlxtg7l5EGaU97A8UipEGa9aTiqsiPXCQO/CJoSMEwCyDDUEvr/K
         rGfyK/MKE8PNgbZjIK++ISK9TZgJhpV0j7s/NS5NfTYaIUx13bEIh/i6xriueF6lru/Y
         xsNg==
X-Gm-Message-State: APjAAAXcWBQ+J82S/swnjfXtj35aHdI+RMk6Wx/CjB37Ic0LTpCX3Y1J
        ILZmqXkOzTloVBaDbMJ+0MdRQmCmL97CJGn8m2t7dHdHgpj2
X-Google-Smtp-Source: APXvYqwmI1aFlAqTwWmQxVB30mGTagesQQ3MCsrUwiIsySxUImRW5PRiDjIoPCzJdoWabpITqQQGkkEQcmU2vCRTdhETnTXOeMKy
MIME-Version: 1.0
X-Received: by 2002:a5d:9c4c:: with SMTP id 12mr7436761iof.5.1567922889635;
 Sat, 07 Sep 2019 23:08:09 -0700 (PDT)
Date:   Sat, 07 Sep 2019 23:08:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df42500592047e0a@google.com>
Subject: general protection fault in qdisc_put
From:   syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>
To:     akinobu.mita@gmail.com, akpm@linux-foundation.org,
        davem@davemloft.net, dvyukov@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org, mhocko@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10244dd6600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=d5870a903591faaca4ae
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174743fe600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f8c43e600000

The bug was bisected to:

commit e41d58185f1444368873d4d7422f7664a68be61d
Author: Dmitry Vyukov <dvyukov@google.com>
Date:   Wed Jul 12 21:34:35 2017 +0000

     fault-inject: support systematic fault injection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f66bc6600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=100e6bc6600000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f66bc6600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
Fixes: e41d58185f14 ("fault-inject: support systematic fault injection")

RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9699 Comm: syz-executor169 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:qdisc_put+0x25/0x90 net/sched/sch_generic.c:983
Code: 00 00 00 00 00 55 48 89 e5 41 54 49 89 fc 53 e8 c1 52 bf fb 49 8d 7c  
24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 04 3c 03 7e 54 41 8b 5c 24 10 31 ff 83 e3 01
RSP: 0018:ffff8880944c7488 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880945c8540 RCX: ffffffff85b49e8a
RDX: 0000000000000002 RSI: ffffffff85b3228f RDI: 0000000000000010
RBP: ffff8880944c7498 R08: ffff888099d50480 R09: ffffed1012898e45
R10: ffffed1012898e44 R11: 0000000000000003 R12: 0000000000000000
R13: ffff8880945c8540 R14: ffff888094894500 R15: ffff8880945c857c
FS:  0000555557553880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000610 CR3: 000000008c29d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  sfb_destroy+0x61/0x80 net/sched/sch_sfb.c:468
  qdisc_create+0xbc6/0x1210 net/sched/sch_api.c:1285
  tc_modify_qdisc+0x524/0x1c50 net/sched/sch_api.c:1652
  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
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
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4424f9
Code: e8 9c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffed10bed8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004424f9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 97e52c48ae7a3cc1 ]---
RIP: 0010:qdisc_put+0x25/0x90 net/sched/sch_generic.c:983
Code: 00 00 00 00 00 55 48 89 e5 41 54 49 89 fc 53 e8 c1 52 bf fb 49 8d 7c  
24 10 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 04 3c 03 7e 54 41 8b 5c 24 10 31 ff 83 e3 01
RSP: 0018:ffff8880944c7488 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880945c8540 RCX: ffffffff85b49e8a
RDX: 0000000000000002 RSI: ffffffff85b3228f RDI: 0000000000000010
RBP: ffff8880944c7498 R08: ffff888099d50480 R09: ffffed1012898e45
R10: ffffed1012898e44 R11: 0000000000000003 R12: 0000000000000000
R13: ffff8880945c8540 R14: ffff888094894500 R15: ffff8880945c857c
FS:  0000555557553880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000610 CR3: 000000008c29d000 CR4: 00000000001406e0
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
