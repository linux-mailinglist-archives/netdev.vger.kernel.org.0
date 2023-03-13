Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8666B7CDA
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCMPzH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 11:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjCMPzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:55:05 -0400
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117375FE9B
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:54:23 -0700 (PDT)
Received: by mail-il1-f208.google.com with SMTP id d3-20020a056e02050300b00317999dcfb1so6822907ils.4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:54:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678722835;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/P4nyi7jmV9gI9/8CWk2ut4YSoCbdN8RC307sLyIPI=;
        b=nZFq+X0PbVx4bR5tq1rCtpE+hwaabZ0tAHHpDQR4dfBTLWeh/1n3DGgtajWDNzHImC
         8H5JpmqFweGg3W3UFR9qw3+l0fOG/Ho7zVW9HIRcoRTqpaBv+a8YaGZ8sQVCPeRFvNMz
         8G019wQ3Sr1lmcp4QQeU0e9jQ4N8JrG5A8AGwKXkT79dmx7oCuZmRPNUHNw2hMYJESsO
         QQx+dKMw7NmavJlfMZ2dPFuGcTUE+olJpsmGXBppylEov95MR3JjXDU/AvFDqegww8Ak
         7tinXZ3VNzuVKCJ82o4CgXDowzG6k5wfMdgJetGDCEgIfXjGAMXSBUaTlIPkfMEoZh53
         dBVg==
X-Gm-Message-State: AO0yUKVJtL3Z4p/zgABK5QA0FQ2FgTjzfRU6iPzG+nhNutD1GRWR4QYz
        7GfybDrLfXxRHiSS7LkFJVpOUbNrMz913GKMOdJamQSsovm9
X-Google-Smtp-Source: AK7set/BqNfTut+qZJwpUuAaYvTdOcGsx97zaAGRHv/k5SDPIS7KdELDAfe2ydg7+LcHHoC4wLDzEXcmoAMcDxhyB7ANZG+dBTKI
MIME-Version: 1.0
X-Received: by 2002:a92:dac7:0:b0:310:d631:cd72 with SMTP id
 o7-20020a92dac7000000b00310d631cd72mr102422ilq.2.1678722835401; Mon, 13 Mar
 2023 08:53:55 -0700 (PDT)
Date:   Mon, 13 Mar 2023 08:53:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047d32505f6ca1e86@google.com>
Subject: [syzbot] net test error: WARNING: suspicious RCU usage in veth_set_xdp_features
From:   syzbot <syzbot+c3d0d9c42d59ff644ea6@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    064d70527aaa Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1155fa8ac80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=732758ed7ee39a7
dashboard link: https://syzkaller.appspot.com/bug?extid=c3d0d9c42d59ff644ea6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/684589f5f27e/disk-064d7052.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c0a3e4044ee2/vmlinux-064d7052.xz
kernel image: https://storage.googleapis.com/syzbot-assets/27e1b018eb4e/bzImage-064d7052.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c3d0d9c42d59ff644ea6@syzkaller.appspotmail.com

chnl_net:caif_netlink_parms(): no params data found
=============================
WARNING: suspicious RCU usage
6.3.0-rc1-syzkaller-00144-g064d70527aaa #0 Not tainted
-----------------------------
drivers/net/veth.c:1265 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.0/5084:
 #0: ffffffff8e102ec8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e102ec8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e8/0xd50 net/core/rtnetlink.c:6171

stack backtrace:
CPU: 1 PID: 5084 Comm: syz-executor.0 Not tainted 6.3.0-rc1-syzkaller-00144-g064d70527aaa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x136/0x150 lib/dump_stack.c:106
 lockdep_rcu_suspicious+0x208/0x3a0 kernel/locking/lockdep.c:6599
 veth_set_xdp_features+0x1c7/0x250 drivers/net/veth.c:1265
 veth_newlink+0x729/0x9d0 drivers/net/veth.c:1891
 rtnl_newlink_create net/core/rtnetlink.c:3440 [inline]
 __rtnl_newlink+0x10c2/0x1840 net/core/rtnetlink.c:3657
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3670
 rtnetlink_rcv_msg+0x43d/0xd50 net/core/rtnetlink.c:6174
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 __sys_sendto+0x23a/0x340 net/socket.c:2142
 __do_sys_sendto net/socket.c:2154 [inline]
 __se_sys_sendto net/socket.c:2150 [inline]
 __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2150
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe359c3e12c
Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
RSP: 002b:00007ffd5c9024c0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fe35a8d4620 RCX: 00007fe359c3e12c
RDX: 000000000000002c RSI: 00007fe35a8d4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffd5c902514 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007fe35a8d4670 R14: 0000000000000003 R15: 0000000000000000
 </TASK>
bridge0: port 1(bridge_slave_0) entered blocking state
bridge0: port 1(bridge_slave_0) entered disabled state
bridge_slave_0: entered allmulticast mode
bridge_slave_0: entered promiscuous mode
bridge0: port 2(bridge_slave_1) entered blocking state
bridge0: port 2(bridge_slave_1) entered disabled state
bridge_slave_1: entered allmulticast mode
bridge_slave_1: entered promiscuous mode
bond0: (slave bond_slave_0): Enslaving as an active interface with an up link
bond0: (slave bond_slave_1): Enslaving as an active interface with an up link
team0: Port device team_slave_0 added
team0: Port device team_slave_1 added
batman_adv: batadv0: Adding interface: batadv_slave_0
batman_adv: batadv0: The MTU of interface batadv_slave_0 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
batman_adv: batadv0: Not using interface batadv_slave_0 (retrying later): interface not active
batman_adv: batadv0: Adding interface: batadv_slave_1
batman_adv: batadv0: The MTU of interface batadv_slave_1 is too small (1500) to handle the transport of batman-adv packets. Packets going over this interface will be fragmented on layer2 which could impact the performance. Setting the MTU to 1560 would solve the problem.
batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
hsr_slave_0: entered promiscuous mode
hsr_slave_1: entered promiscuous mode
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
hsr0: Slave A (hsr_slave_0) is not up; please bring it up to get a fully working HSR network
hsr0: Slave B (hsr_slave_1) is not up; please bring it up to get a fully working HSR network
8021q: adding VLAN 0 to HW filter on device batadv0
veth0_vlan: entered promiscuous mode
veth1_vlan: entered promiscuous mode
veth0_macvtap: entered promiscuous mode
veth1_macvtap: entered promiscuous mode
batman_adv: batadv0: Interface activated: batadv_slave_0
batman_adv: batadv0: Interface activated: batadv_slave_1
netdevsim netdevsim0 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
