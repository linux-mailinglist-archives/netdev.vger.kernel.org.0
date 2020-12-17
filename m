Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4602DCDF6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgLQI6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:58:50 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:45082 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbgLQI6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 03:58:50 -0500
Received: by mail-io1-f72.google.com with SMTP id x7so26640081ion.12
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 00:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5cdTyg19qBt9YC2udx7QDD/ru4hNARFKf9MbeLvUc/Q=;
        b=iBPtphVAzjt6WuFiU2P+kiDYDGSzxfVgke3+itQBQOcWg/Zu3VoPr5XP7lbjG1FUJU
         8A2yaonX62BxnkS+2R+49VTxGhw/dkLeZbVNQWFSPdZCSt5LfezaB9/hie4p/8YpNUcM
         oTzXRAixCTVlDQ8TwcQC+mLwkndq3MO2BR2O3ByWwuumMKj9oWCbltwZzDdsbnABaGQd
         lq4DFS94JIGM0+0LaaFRwaQves3MOX6Yst+b1R8+7TaytRc6bYO5LWFmiM/Tnv+9s1aG
         fqDeCyOrhQpDH7qSZwzdw0uQqtf3rBpE7OQYkU2QBn2lnj+yBtVHDPYnJlv6WrhrT286
         euVw==
X-Gm-Message-State: AOAM531ZVepq9aYZxU5lGa0y0rdxU4H7nIUlBDhALc6A93q7I1NZOpoO
        FNGcsHflliwQbNtmM8y9vKm6kvo5u+LEAH4GZf7FcJmFjusG
X-Google-Smtp-Source: ABdhPJyroSQRk3u2Kgqk9k1IMqZK+ZIarvm8U7vD5XMcHIe/xISvRPgvS3PTj7MYKw3HdAMLaRIftbrvL+w3mJGJZtgWCvzAVCJq
MIME-Version: 1.0
X-Received: by 2002:a05:6638:154:: with SMTP id y20mr46705828jao.119.1608195489267;
 Thu, 17 Dec 2020 00:58:09 -0800 (PST)
Date:   Thu, 17 Dec 2020 00:58:09 -0800
In-Reply-To: <000000000000705ff605b5f2b656@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000de052a05b6a5301c@google.com>
Subject: Re: BUG: unable to handle kernel paging request in smc_nl_handle_smcr_dev
From:   syzbot <syzbot+600fef7c414ee7e2d71b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    5e60366d Merge tag 'fallthrough-fixes-clang-5.11-rc1' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17842c13500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=503d0089cd701d6d
dashboard link: https://syzkaller.appspot.com/bug?extid=600fef7c414ee7e2d71b
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d8e41f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17962287500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+600fef7c414ee7e2d71b@syzkaller.appspotmail.com

infiniband syz1: set active
infiniband syz1: added macvtap0
RDS/IB: syz1: added
smc: adding ib device syz1 with port count 1
smc:    ib device syz1 port 1 has pnetid 
BUG: unable to handle page fault for address: ffffffffffffff74
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD b48f067 P4D b48f067 PUD b491067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8688 Comm: syz-executor225 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:smc_set_pci_values net/smc/smc_core.h:396 [inline]
RIP: 0010:smc_nl_handle_smcr_dev.isra.0+0x4e1/0x1280 net/smc/smc_ib.c:422
Code: fc ff df 48 8d bb 74 ff ff ff 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 29 0d 00 00 <0f> b7 83 74 ff ff ff 48 8d bb 76 ff ff ff 48 89 fa 48 c1 ea 03 66
RSP: 0018:ffffc90001f87220 EFLAGS: 00010246
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffff74
RBP: ffffffff8d5ac140 R08: 0000000000000001 R09: ffffc90001f87308
R10: fffff520003f0e64 R11: 1ffffffff1e2db6c R12: 000000001b556831
R13: ffff888013e29540 R14: dffffc0000000000 R15: ffff88802a360014
FS:  00000000015bf880(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffff74 CR3: 000000002687b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 smc_nl_prep_smcr_dev net/smc/smc_ib.c:469 [inline]
 smcr_nl_get_device+0xdf/0x1f0 net/smc/smc_ib.c:481
 genl_lock_dumpit+0x60/0x90 net/netlink/genetlink.c:623
 netlink_dump+0x4d9/0xb90 net/netlink/af_netlink.c:2268
 __netlink_dump_start+0x665/0x920 net/netlink/af_netlink.c:2373
 genl_family_rcv_msg_dumpit+0x2af/0x310 net/netlink/genetlink.c:686
 genl_family_rcv_msg net/netlink/genetlink.c:780 [inline]
 genl_rcv_msg+0x43c/0x590 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x907/0xe40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443fd9
Code: e8 6c 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe909694e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443fd9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 00007ffe909694f0 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000001bbbbbb R11: 0000000000000246 R12: 00007ffe90969500
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: ffffffffffffff74
---[ end trace 45a80c2d5f347bdc ]---
RIP: 0010:smc_set_pci_values net/smc/smc_core.h:396 [inline]
RIP: 0010:smc_nl_handle_smcr_dev.isra.0+0x4e1/0x1280 net/smc/smc_ib.c:422
Code: fc ff df 48 8d bb 74 ff ff ff 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 29 0d 00 00 <0f> b7 83 74 ff ff ff 48 8d bb 76 ff ff ff 48 89 fa 48 c1 ea 03 66
RSP: 0018:ffffc90001f87220 EFLAGS: 00010246
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffffffff74
RBP: ffffffff8d5ac140 R08: 0000000000000001 R09: ffffc90001f87308
R10: fffff520003f0e64 R11: 1ffffffff1e2db6c R12: 000000001b556831
R13: ffff888013e29540 R14: dffffc0000000000 R15: ffff88802a360014
FS:  00000000015bf880(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffff74 CR3: 000000002687b000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

