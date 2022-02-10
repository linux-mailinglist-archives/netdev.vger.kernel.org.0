Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832834B0E5F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242160AbiBJN1S convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 08:27:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbiBJN1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:27:17 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ABE1B5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:27:18 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id n13-20020a056602340d00b006361f2312deso4039989ioz.9
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:27:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=DlpPZGGKliMKcWhjenaLMpD1ZyJmKZB8Ha4yhKNSbSo=;
        b=dyPSl6SnC1E4oFKouIXPc+BPDPBtcVYzQhUHl2XKpmSxNvXxYEpVbmdV994PKWR7p9
         ozyg1439sLZkA1AF0lu+bt8iM/YxuJALg1A+8bZvUmELRFoJLFrU8g86YIRAlSQndC7u
         zfGy8YH3STET6cYEaEu1BRDkciLI8qQJuXzi/grqPJqetiXa7SCi1nvKn8iFHwEN5qps
         Rn2ZcezUp9YoHlk+U66cEhb/VvDi1CowD+Zj2e5c2vYe6/9Q5rqzgHnVJ8dKzRMimSjN
         4CPYol/p48Idqi+j4l0TIGhTX0R3ifwXKULj4SEntysq3bhmdmx8mticSgFbZ5CYvF3I
         Nu2w==
X-Gm-Message-State: AOAM532292QiYo2xog+ozUwWdQ2NXX96r9nLRjBXrOidfJuHa/Dn4PHU
        U8f/v53eOwqXg+AUPJ9AiDrcfIuzqybJfJXw1TLtTykH6cyJ
X-Google-Smtp-Source: ABdhPJxktaqc2MT8TGypSv3S6tvzNRIrDITqBFmZIMUyTf+hsDOhN0yqT8VFBTUt97hEaujKN31FgFE53ED94o/E0F7FMTp9X6eh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1906:: with SMTP id w6mr3703475ilu.43.1644499637838;
 Thu, 10 Feb 2022 05:27:17 -0800 (PST)
Date:   Thu, 10 Feb 2022 05:27:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf2b0705d7a9e8ac@google.com>
Subject: [syzbot] net-next test error: WARNING: suspicious RCU usage in hsr_node_get_first
From:   syzbot <syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, claudiajkang@gmail.com, davem@davemloft.net,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        marco.wenzel@a-eberle.de, netdev@vger.kernel.org,
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

HEAD commit:    45230829827b Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12e2f52c700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3fa7f88a3821006b
dashboard link: https://syzkaller.appspot.com/bug?extid=f0eb4f3876de066b128c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com

batman_adv: batadv0: The MTU of interface batadv_slave_1 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
=============================
WARNING: suspicious RCU usage
5.17.0-rc2-syzkaller-00903-g45230829827b #0 Not tainted
-----------------------------
net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/3597:
 #0: ffffffff8d32ca28 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d32ca28 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5591
 #1: ffff888073fa55f0 (&hsr->list_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #1: ffff888073fa55f0 (&hsr->list_lock){+...}-{2:2}, at: hsr_create_self_node+0x225/0x650 net/hsr/hsr_framereg.c:108

stack backtrace:
CPU: 1 PID: 3597 Comm: syz-executor.0 Not tainted 5.17.0-rc2-syzkaller-00903-g45230829827b #0
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
RIP: 0033:0x7fca68e2ae1c
Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
RSP: 002b:00007ffcd2955580 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fca69ec3320 RCX: 00007fca68e2ae1c
RDX: 0000000000000048 RSI: 00007fca69ec3370 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffcd29555d4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007fca69ec3370 R14: 0000000000000003 R15: 0000000000000000
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
syz-executor.0 (3597) used greatest stack depth: 22400 bytes left


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
