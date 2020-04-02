Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16AB19C8F6
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 20:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389281AbgDBSnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 14:43:13 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33280 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388764AbgDBSnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 14:43:13 -0400
Received: by mail-io1-f71.google.com with SMTP id w25so3729428iom.0
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 11:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yoqnUjRtu8mgbvv/13mBn4nrRvAQngPro3mOt8IGEyc=;
        b=bk+3/MHuxUi2EaWLwPUtAyoYHH3QdM/YkimD7nEr1lt9uX075FCKrLW4i2U9hqHGSe
         3MdwjvHgTAIN3wJcyDRKDJObw3LjF/pa8xtQq5TxkX81BlKdoH/21MVQyexyUhQKF6oW
         xBiXDrEGdTWu9UtNQt8/AeXtGJkgYVDpPJyGdA92UTzI4r1ThuBRZqDXgGh68za/yJWk
         hk64qowVMvyKbunrRzKNitKZEtRWoKIncoW6S7M3ZRWO2eqKh22YoObAb5R6GvcOQYJY
         Q6CsW83g1YFF5rb/WoeTsmU9fsA8e1RHr9zDjv5uR2MrzEmLD0cj5eFBWeOYelw4A1rC
         LlKg==
X-Gm-Message-State: AGi0Pubo2djKFEs1fExel2DACE3fDXEfFjgJvwe89dFIIFrMWZjE+LpN
        h3Txx0kLZml+jLYML7/A3Mo08l7mS+3A2ouzXpNXZh7TXJsb
X-Google-Smtp-Source: APiQypJTLL+G338lLsPPlftz5FYyt7Zj4Yb5dOSEJfqQHqIdaImyApgkIj3rO3pVWniQSbfg9V8Od7ErArR2SgzZISGoixPw66T9
MIME-Version: 1.0
X-Received: by 2002:a02:55c5:: with SMTP id e188mr4602763jab.57.1585852992156;
 Thu, 02 Apr 2020 11:43:12 -0700 (PDT)
Date:   Thu, 02 Apr 2020 11:43:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000043794505a2532c6b@google.com>
Subject: general protection fault in macsec_upd_offload
From:   syzbot <syzbot+7022ab7c383875c17eff@syzkaller.appspotmail.com>
To:     antoine.tenart@bootlin.com, davem@davemloft.net,
        dbogdanov@marvell.com, irusskikh@marvell.com,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mayflowerera@gmail.com,
        mstarovoitov@marvell.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    304e0242 net_sched: add a temporary refcnt for struct tcin..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17a6940be00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
dashboard link: https://syzkaller.appspot.com/bug?extid=7022ab7c383875c17eff
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1099dadbe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a63197e00000

The bug was bisected to:

commit 01cacb00b35cb62b139f07d5f84bcf0eeda8eff6
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Fri Mar 27 21:48:51 2020 +0000

    mptcp: add netlink-based PM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16133ebde00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15133ebde00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11133ebde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7022ab7c383875c17eff@syzkaller.appspotmail.com
Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")

batman_adv: batadv0: Interface activated: batadv_slave_1
netlink: 'syz-executor343': attribute type 1 has an invalid length.
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 7006 Comm: syz-executor343 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_u8 include/net/netlink.h:1543 [inline]
RIP: 0010:macsec_upd_offload+0x1c9/0x5a0 drivers/net/macsec.c:2597
Code: fd 00 f0 ff ff 0f 87 23 03 00 00 e8 01 c5 d0 fc 48 8b 5c 24 38 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 1b 03 00 00
RSP: 0018:ffffc90001797558 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff84a2244d
RDX: 0000000000000000 RSI: ffffffff84a2245f RDI: 0000000000000004
RBP: ffff8880a8372000 R08: ffff888095cae5c0 R09: ffffc90001797588
R10: fffff520002f2eb3 R11: ffffc9000179759f R12: 0000000000000000
R13: ffff88809ffaff80 R14: 1ffff920002f2eab R15: 0000000000000000
FS:  0000000000a6a880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdd4d1316c0 CR3: 0000000093074000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4438a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 6b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdc14392d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004438a9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00007ffdc14392f0 R08: 00000000bb1414ac R09: 00000000bb1414ac
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdc1439320
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 98b6a7926fe123d8 ]---
RIP: 0010:nla_get_u8 include/net/netlink.h:1543 [inline]
RIP: 0010:macsec_upd_offload+0x1c9/0x5a0 drivers/net/macsec.c:2597
Code: fd 00 f0 ff ff 0f 87 23 03 00 00 e8 01 c5 d0 fc 48 8b 5c 24 38 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 04 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 1b 03 00 00
RSP: 0018:ffffc90001797558 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff84a2244d
RDX: 0000000000000000 RSI: ffffffff84a2245f RDI: 0000000000000004
RBP: ffff8880a8372000 R08: ffff888095cae5c0 R09: ffffc90001797588
R10: fffff520002f2eb3 R11: ffffc9000179759f R12: 0000000000000000
R13: ffff88809ffaff80 R14: 1ffff920002f2eab R15: 0000000000000000
FS:  0000000000a6a880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdd4d1316c0 CR3: 0000000093074000 CR4: 00000000001406e0
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
