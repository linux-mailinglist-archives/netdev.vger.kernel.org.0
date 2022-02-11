Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2637D4B1D89
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 05:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbiBKE5Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 23:57:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiBKE5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 23:57:21 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E2226ED
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 20:57:20 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id k12-20020a92c24c000000b002bc9876bf27so5304136ilo.21
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 20:57:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=kcbMTGf4ThT8HO5Mt7WKPPdEbptzj8mzIaWRHlsij1o=;
        b=qvJ7zi8AqpB8ap0wHj8t4KPgqbXCyf5PC1nP9uK7RaMqx2Z7pweDK3ST42YRhAqYmM
         BDUom0l7ewQaUetWGTAEgpNfNHwh6oaQ2f4+gvCsVz/HqpLxdQa3lLtR3E/s4/O0iK2M
         dNcLEf8cYlFcl1QOWP32kBB56ipmo7TstIpAoi3hc39TzclmRX51QH7iiKbT2CDTK8BK
         5grjjciczDLwGfm1ZwaPeKV0p09nOIJqeGxF4wk1MAkoksxPxc0YZ/hLVNIG66Hj7tyQ
         m/inDOF992mEoBOGALHJS+/5D/7ZLgfsJNG9na8E3I2tkLI+hAE4Wkxhrm/T0KcZpi7m
         /GYg==
X-Gm-Message-State: AOAM5339llQpohq078vfMXTpnI0u56BhC423MI9LwDnIRMG8hO05ZHYD
        OuAhc0XKhBkOp+/bkPcvx5jQCJLbelrwsGD6YUvc7uThhqkg
X-Google-Smtp-Source: ABdhPJwhJpHjOrV/NFpwJWwL3TvphCCOOtIBqKNKSVEkbgl7OVIGhvvWC2rkp7VB3IkRpN40hKCkfI5UF91RN/XvA9fN3fZMPITQ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1487:: with SMTP id n7mr29261ilk.109.1644555439753;
 Thu, 10 Feb 2022 20:57:19 -0800 (PST)
Date:   Thu, 10 Feb 2022 20:57:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ccd19405d7b6e687@google.com>
Subject: [syzbot] linux-next test error: WARNING: suspicious RCU usage in hsr_node_get_first
From:   syzbot <syzbot+787eccd42a00a400e647@syzkaller.appspotmail.com>
To:     claudiajkang@gmail.com, davem@davemloft.net,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, marco.wenzel@a-eberle.de,
        netdev@vger.kernel.org, olteanv@gmail.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    554f92dbda16 Add linux-next specific files for 20220208
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13655472700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=540b1094b49a74bd
dashboard link: https://syzkaller.appspot.com/bug?extid=787eccd42a00a400e647
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+787eccd42a00a400e647@syzkaller.appspotmail.com

batman_adv: batadv0: The MTU of interface batadv_slave_1 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
=============================
WARNING: suspicious RCU usage
5.17.0-rc3-next-20220208-syzkaller #0 Not tainted
-----------------------------
net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/3596:
 #0: ffffffff8d3357e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d3357e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5591
 #1: ffff88807ec9d5f0 (&hsr->list_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 #1: ffff88807ec9d5f0 (&hsr->list_lock){+...}-{2:2}, at: hsr_create_self_node+0x225/0x650 net/hsr/hsr_framereg.c:108

stack backtrace:
CPU: 1 PID: 3596 Comm: syz-executor.0 Not tainted 5.17.0-rc3-next-20220208-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 hsr_node_get_first+0x9b/0xb0 net/hsr/hsr_framereg.c:34
 hsr_create_self_node+0x22d/0x650 net/hsr/hsr_framereg.c:109
 hsr_dev_finalize+0x2c1/0x7d0 net/hsr/hsr_device.c:514
 hsr_newlink+0x315/0x730 net/hsr/hsr_netlink.c:102
 __rtnl_newlink+0x107c/0x1760 net/core/rtnetlink.c:3481
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3529
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5594
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 __sys_sendto+0x21c/0x320 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3148504e1c
Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
RSP: 002b:00007ffeab5f2ab0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f314959d320 RCX: 00007f3148504e1c
RDX: 0000000000000048 RSI: 00007f314959d370 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffeab5f2b04 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007f314959d370 R14: 0000000000000003 R15: 0000000000000000
 </TASK>
device hsr_slave_0 entered promiscuous mode
device hsr_slave_1 entered promiscuous mode
netdevsim netdevsim0 netdevsim0: renamed from eth0
netdevsim netdevsim0 netdevsim1: renamed from eth1
netdevsim netdevsim0 netdevsim2: renamed from eth2
netdevsim netdevsim0 netdevsim3: renamed from eth3
bridge0: port 2(bridge_slave_1) entered blocking state
bridge0: port 2(bridge_slave_1) entered forwarding state
bridge0: port 1(bridge_slave_0) entered blocking state
bridge0: port 1(bridge_slave_0) entered forwarding state
8021q: adding VLAN 0 to HW filter on device bond0
8021q: adding VLAN 0 to HW filter on device team0
IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
8021q: adding VLAN 0 to HW filter on device batadv0
device veth0_vlan entered promiscuous mode
device veth1_vlan entered promiscuous mode
device veth0_macvtap entered promiscuous mode
device veth1_macvtap entered promiscuous mode
batman_adv: batadv0: Interface activated: batadv_slave_0
batman_adv: batadv0: Interface activated: batadv_slave_1
netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
syz-executor.0 (3596) used greatest stack depth: 22424 bytes left


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
