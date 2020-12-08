Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B932D2A39
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgLHMC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:02:58 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40370 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbgLHMC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:02:57 -0500
Received: by mail-il1-f197.google.com with SMTP id b18so15716589ilr.7
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 04:02:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ptLqDQ6cimNz4gFNOQpJaAWoh4l9vnK6+rwqXMdFNUM=;
        b=kIRnz8dJZnK2+ayfj4dZDtNxwePbmrzs9sKIl8nwUswyayiJUtxuzTaNgrD6N0ofNc
         75siQBCnL79VTFcTY6UmTRzO/qcSGneCdD0VWnihYxBP2f7gCreEt8TQIBJ8l2szAtae
         LHDg9/anIPHJGyuj1Cr7X0/2rNUBxslv4TJSES6VA+vyR+kOVqvlKRTuoGL6wQwsZ69t
         mpA78uyaryHWQKaDP3bkkAIep2OoaZEMrNTC27ZGIHuLhKyhrkC4F7MD1ZSbtM/kqfXp
         NGVee/oLzpee6TQ5qr64U4JPRACpSF1AzgcElcKTjN0fN6HJ8s1r6LRqwnQJW/lv/HdW
         5iUQ==
X-Gm-Message-State: AOAM531miptN9D574lFSgWJWbAAvJ3iz+DbKZbDSiJqT5ae/WTUKCRwA
        IC9fycBpPZF1Co7MoSIi19/vc3ZVfV1ajhpJS+hDNYQkle+7
X-Google-Smtp-Source: ABdhPJxGsYHsqnMHtduKr+6+ilPgQEtkjeZWRKy+Rznj6g2RNN7KdCMNnbGX8YMsjaOulGn4sGFV0IkOzspizk95l7yOWztrWiHO
MIME-Version: 1.0
X-Received: by 2002:a05:6602:8d:: with SMTP id h13mr24559903iob.163.1607428931082;
 Tue, 08 Dec 2020 04:02:11 -0800 (PST)
Date:   Tue, 08 Dec 2020 04:02:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000705ff605b5f2b656@google.com>
Subject: BUG: unable to handle kernel paging request in smc_nl_handle_smcr_dev
From:   syzbot <syzbot+600fef7c414ee7e2d71b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b1f7b098 Merge branch 's390-qeth-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=164d246b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ac2dabe250b3a58
dashboard link: https://syzkaller.appspot.com/bug?extid=600fef7c414ee7e2d71b
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+600fef7c414ee7e2d71b@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffffffffffff84
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD b08f067 P4D b08f067 PUD b091067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 21334 Comm: syz-executor.1 Not tainted 5.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:smc_set_pci_values net/smc/smc_core.h:396 [inline]
RIP: 0010:smc_nl_handle_smcr_dev.isra.0+0x4bd/0x11b0 net/smc/smc_ib.c:422
Code: 00 00 00 fc ff df 48 8d 7b 84 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 59 0c 00 00 <0f> b7 43 84 48 8d 7b 86 48 89 fa 48 c1 ea 03 66 89 84 24 ee 00 00
RSP: 0018:ffffc900018b7228 EFLAGS: 00010246
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffff84
RBP: ffffffff8ccc6120 R08: 0000000000000001 R09: ffffc900018b7310
R10: fffff52000316e65 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802f52d540 R14: dffffc0000000000 R15: ffff888062412014
FS:  00007f9ce0405700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffff84 CR3: 0000000013c46000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 smc_nl_prep_smcr_dev net/smc/smc_ib.c:469 [inline]
 smcr_nl_get_device+0xdf/0x1f0 net/smc/smc_ib.c:481
 genl_lock_dumpit+0x60/0x90 net/netlink/genetlink.c:623
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2268
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2373
 genl_family_rcv_msg_dumpit+0x2af/0x310 net/netlink/genetlink.c:686
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0x434/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2331
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2385
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2418
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e0f9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f9ce0404c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e0f9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffda3a6b65f R14: 00007f9ce04059c0 R15: 000000000119bf8c
Modules linked in:
CR2: ffffffffffffff84
---[ end trace 7323b30ca37a03b9 ]---
RIP: 0010:smc_set_pci_values net/smc/smc_core.h:396 [inline]
RIP: 0010:smc_nl_handle_smcr_dev.isra.0+0x4bd/0x11b0 net/smc/smc_ib.c:422
Code: 00 00 00 fc ff df 48 8d 7b 84 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 59 0c 00 00 <0f> b7 43 84 48 8d 7b 86 48 89 fa 48 c1 ea 03 66 89 84 24 ee 00 00
RSP: 0018:ffffc900018b7228 EFLAGS: 00010246
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffff84
RBP: ffffffff8ccc6120 R08: 0000000000000001 R09: ffffc900018b7310
R10: fffff52000316e65 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802f52d540 R14: dffffc0000000000 R15: ffff888062412014
FS:  00007f9ce0405700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffff84 CR3: 0000000013c46000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
