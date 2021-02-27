Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE336326BED
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 07:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhB0GDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 01:03:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:44823 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhB0GDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 01:03:00 -0500
Received: by mail-io1-f69.google.com with SMTP id e11so98365ioh.11
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 22:02:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5Rvpq0XsNHUHuj6bSqvupVKIf/dYlzM+MjqKaai2hjk=;
        b=XpNgcg0lvNrSMwTLyaQ9aszg/IAp9OLLt3k7dVdpNEJJ6xPN1sDFJcmL1f0Wn8eI8n
         oYdI6gorOeIXLbC0XLmT5BJM2Y4o/5iLfO9TxR1UDzVgm3xtFvim66wmP/8MHGmtB0yv
         CKRHuYa1xEDnUEFbYPKW1LfukFUHodZyygLmThBL9QV2ohHg1MZ6FfGxVsbyOM/c/13f
         gfcXcBTsyaCr0r8sEQHZakWRUJkZg5amGNMPSNsMistTfeRYCfT6GnLy4I/9q4KcsbhV
         AGixo9fzn1U3jlFo+1HwL5a00TiiiVXaG13Zq5tdp1V1nZ9KyJTpkfjuNg7NPCK8wUwb
         8Hew==
X-Gm-Message-State: AOAM5316/DRWR0FWTZ3iGTuTfvX/KKCubQrIaV2mFOGOAvfLOp7A0rpr
        ZNldrdrB2vdH7puce4JSQJuSXa4qUid0riUzTmcovUZh472Z
X-Google-Smtp-Source: ABdhPJw4kba9ucswxdfQlxaeZpaCCLfHIH7Vpaw2l1GUdYWI54Wr0v40j2xE0mFfTAMOeF4urdAxezMiymwCPxksbCKM2hVjiHwl
MIME-Version: 1.0
X-Received: by 2002:a92:da11:: with SMTP id z17mr5148259ilm.45.1614405739499;
 Fri, 26 Feb 2021 22:02:19 -0800 (PST)
Date:   Fri, 26 Feb 2021 22:02:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a054ee05bc4b2009@google.com>
Subject: BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low! (2)
From:   syzbot <syzbot+9bbbacfbf1e04d5221f7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    557c223b selftests/bpf: No need to drop the packet when th..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=156409a8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8307379601586a
dashboard link: https://syzkaller.appspot.com/bug?extid=9bbbacfbf1e04d5221f7

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9bbbacfbf1e04d5221f7@syzkaller.appspotmail.com

netlink: 'syz-executor.4': attribute type 10 has an invalid length.
BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
turning off the locking correctness validator.
CPU: 1 PID: 22786 Comm: syz-executor.4 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 add_chain_cache kernel/locking/lockdep.c:3540 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3621 [inline]
 validate_chain kernel/locking/lockdep.c:3642 [inline]
 __lock_acquire.cold+0x3af/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 do_write_seqcount_begin_nested include/linux/seqlock.h:520 [inline]
 do_write_seqcount_begin include/linux/seqlock.h:545 [inline]
 psi_group_change+0x123/0x8d0 kernel/sched/psi.c:707
 psi_task_change+0x142/0x220 kernel/sched/psi.c:807
 psi_enqueue kernel/sched/stats.h:82 [inline]
 enqueue_task kernel/sched/core.c:1590 [inline]
 activate_task kernel/sched/core.c:1613 [inline]
 ttwu_do_activate+0x25b/0x660 kernel/sched/core.c:2991
 ttwu_queue kernel/sched/core.c:3188 [inline]
 try_to_wake_up+0x60e/0x14a0 kernel/sched/core.c:3466
 wake_up_worker kernel/workqueue.c:837 [inline]
 insert_work+0x2a0/0x370 kernel/workqueue.c:1346
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1644
 mod_delayed_work_on+0xdd/0x1e0 kernel/workqueue.c:1718
 mod_delayed_work include/linux/workqueue.h:537 [inline]
 addrconf_mod_dad_work net/ipv6/addrconf.c:328 [inline]
 addrconf_dad_start net/ipv6/addrconf.c:4013 [inline]
 addrconf_add_linklocal+0x321/0x590 net/ipv6/addrconf.c:3186
 addrconf_addr_gen+0x3a4/0x3e0 net/ipv6/addrconf.c:3313
 addrconf_dev_config+0x26c/0x410 net/ipv6/addrconf.c:3360
 addrconf_notify+0x362/0x23e0 net/ipv6/addrconf.c:3593
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2063
 call_netdevice_notifiers_extack net/core/dev.c:2075 [inline]
 call_netdevice_notifiers net/core/dev.c:2089 [inline]
 dev_open net/core/dev.c:1592 [inline]
 dev_open+0x132/0x150 net/core/dev.c:1580
 team_port_add drivers/net/team/team.c:1210 [inline]
 team_add_slave+0xa53/0x1c20 drivers/net/team/team.c:1967
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2519
 do_setlink+0x920/0x3a70 net/core/rtnetlink.c:2715
 __rtnl_newlink+0xdc6/0x1710 net/core/rtnetlink.c:3376
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2db3282188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffea3f3a6af R14: 00007f2db3282300 R15: 0000000000022000
team0: Device ipvlan0 failed to register rx_handler


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
