Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323E123BD75
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 17:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgHDPp1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Aug 2020 11:45:27 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:32783 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgHDPpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 11:45:19 -0400
Received: by mail-io1-f71.google.com with SMTP id a12so29466473ioo.0
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 08:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=n5bm4gcX2kNCxzaBvmn7KzMz6UUigjSuxKBSRxaemkE=;
        b=cx60sqPXlai/Ux5GArG0UBdLpnYwiwxySRjT5JYvG5HRAwYcsszq73UeFnOJ1DUXUp
         uHaEIzEhgaqi9O+Of2y3LSCBX39Bl6Cz54NvuZ0fpsIKPpgXXKLqPBokBJrNBAlQuy6a
         AC6427son7IKXzTKxfFdMzRjYy/Zf7mVjNmJgSID8mJd+8vQ0jRlKLnxg0tKy/6qq4EV
         nRZXsLBpNkbcdf/Xfq5Cn46Kgq4j6qS0ziRbdIZEeCiEWAxFrDJOU7AwPw4Ufu2nfw4z
         aZdXe7xPE7oeW070hpMcrcRSKc7zYvxztQ75mwYsLBw4TISV4PJxUwqfzw2DBuoGmXBM
         AIUw==
X-Gm-Message-State: AOAM5309ZLvluh1Opkzq8WTxjAZeRAre3wsgR5wYFw8x+Jn90WggvGng
        F5+uHT/90DevTbXzVf94fOxjKvmwkO3UAq+pZ1AQ/0P5ZDmG
X-Google-Smtp-Source: ABdhPJy1cdxDpzvGfhVRtIMEDpdmgz7EcWhpOxoFCyylPH/oZnvCcOULqX7nonn4KKETfmaZXzi8gArn4/Ej0i6QWjQCG8UqLsb6
MIME-Version: 1.0
X-Received: by 2002:a02:3e11:: with SMTP id s17mr6398336jas.67.1596555919196;
 Tue, 04 Aug 2020 08:45:19 -0700 (PDT)
Date:   Tue, 04 Aug 2020 08:45:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d871805ac0f2416@google.com>
Subject: WARNING: suspicious RCU usage in ovs_flow_tbl_masks_cache_size
From:   syzbot <syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2f631133 net: Pass NULL to skb_network_protocol() when we ..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12c1f770900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91a13b78c7dc258d
dashboard link: https://syzkaller.appspot.com/bug?extid=f612c02823acb02ff9bc
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e8430a900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123549fc900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f612c02823acb02ff9bc@syzkaller.appspotmail.com

netlink: 'syz-executor210': attribute type 2 has an invalid length.
device  entered promiscuous mode
=============================
WARNING: suspicious RCU usage
5.8.0-rc7-syzkaller #0 Not tainted
-----------------------------
net/openvswitch/flow_table.c:940 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor210/6812:
 #0: ffffffff8a8319b0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:741
 #1: ffffffff8aa786a8 (ovs_mutex){+.+.}-{3:3}, at: ovs_lock net/openvswitch/datapath.c:105 [inline]
 #1: ffffffff8aa786a8 (ovs_mutex){+.+.}-{3:3}, at: ovs_dp_cmd_new+0x4db/0xea0 net/openvswitch/datapath.c:1707

stack backtrace:
CPU: 0 PID: 6812 Comm: syz-executor210 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 ovs_flow_tbl_masks_cache_size+0xc3/0xe0 net/openvswitch/flow_table.c:940
 ovs_dp_cmd_fill_info+0x4e4/0x880 net/openvswitch/datapath.c:1539
 ovs_dp_cmd_new+0x584/0xea0 net/openvswitch/datapath.c:1728
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2359
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2413
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2446
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4402d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd71bb22a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402d9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
