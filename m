Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB0C4B5416
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355588AbiBNPBx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Feb 2022 10:01:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355594AbiBNPBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 10:01:51 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E454E398
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:01:36 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id n20-20020a6bed14000000b0060faa0aefd3so10589494iog.20
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:01:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=8ISOFJrUX7TTDN1d8462PfAwV8Iwk0AQ8GlhdTqRwMU=;
        b=TncMGjFxrn65ntSeeWVwqOU7mc6LmQQ40If33glc2vhH+O2CJ3aqTGBC3f/n7HhFPE
         n9B1MaURzTwTJ/I5UkhcIXow5KjVfwE+z1XlYuoFYJPKyFZBlDUrLkHeRAqqt01VmEj0
         MucjNl/Qa8P+ZljZUYI6bkdK+DWGtJpmyMoDaqT/NV35SI3kDhI6nMX0DdfXMtF4kQYx
         EF8HEweWTV8blluAyRU2iINVuQxoN8JbE0lr+ngtutsp+NsmXhe9y4HUXo1c3MUppEGK
         ZfBNx4/59TP6fuPe4bJErVCbPlxHbs6sqfwsBSjVKHpdFzeboGaCHSz4MW/UpnBo0nEH
         xf+A==
X-Gm-Message-State: AOAM530Q2T48vdLh+BIQ5346gwSz6AJRp2rhTnNY6XVJREiG5+cbj3PE
        ai3f8KDG/124PMdPTpbs/5W1BDU4QdkvrYQl4Fqb2q5OnFoX
X-Google-Smtp-Source: ABdhPJzFUFU+N1EXifo+xLa0SWYo1ZWSBzjOlAOakoCkahWkjry7Q5i7sp0/eJ+ph2i4+LmLfCEYp901OhpP5o43QXLcxVmBcsJn
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d0e:: with SMTP id q14mr21233jaj.291.1644850894256;
 Mon, 14 Feb 2022 07:01:34 -0800 (PST)
Date:   Mon, 14 Feb 2022 07:01:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042c23305d7fbb189@google.com>
Subject: [syzbot] bpf-next test error: WARNING: suspicious RCU usage in hsr_node_get_first
From:   syzbot <syzbot+284f395a179db7a165b1@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, ast@kernel.org, claudiajkang@gmail.com,
        daniel@iogearbox.net, davem@davemloft.net, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marco.wenzel@a-eberle.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    9c3de619e13e libbpf: Use dynamically allocated buffer when..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=101b14a4700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3fa7f88a3821006b
dashboard link: https://syzkaller.appspot.com/bug?extid=284f395a179db7a165b1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+284f395a179db7a165b1@syzkaller.appspotmail.com

batman_adv: batadv0: The MTU of interface batadv_slave_1 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
=============================
WARNING: suspicious RCU usage
5.17.0-rc2-syzkaller-00955-g9c3de619e13e #0 Not tainted
-----------------------------
net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/3604:
 #0: ffffffff8d32caa8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d32caa8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5591
 #1: ffff888019e195f0 (&hsr->list_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:354 [inline]
 #1: ffff888019e195f0 (&hsr->list_lock){+...}-{2:2}, at: hsr_create_self_node+0x225/0x650 net/hsr/hsr_framereg.c:108

stack backtrace:
CPU: 1 PID: 3604 Comm: syz-executor.0 Not tainted 5.17.0-rc2-syzkaller-00955-g9c3de619e13e #0
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
RIP: 0033:0x7fa727558e1c
Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
RSP: 002b:00007ffe062c7d90 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fa7285f1320 RCX: 00007fa727558e1c
RDX: 0000000000000048 RSI: 00007fa7285f1370 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffe062c7de4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007fa7285f1370 R14: 0000000000000003 R15: 0000000000000000
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
syz-executor.0 (3604) used greatest stack depth: 22592 bytes left


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
