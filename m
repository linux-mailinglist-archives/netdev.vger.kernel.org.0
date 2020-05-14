Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E471D2E77
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgENLhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:37:20 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39542 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgENLhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:37:19 -0400
Received: by mail-io1-f72.google.com with SMTP id d10so2161354iod.6
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 04:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4Mof+U9cD9u9+KN0Yeu8IB5SFQ1hpQEdck5Z1RIH1b8=;
        b=NQWh5STP8zwKJtwpH9CKKVv6kGfGPfFoE6zyv9HEjTKgPsXIoS8Gi5Zld4misQ3qbk
         klRoZol542H/ga17VXESwAW3faAUuwnG+ZmEm6/fT78UMni/PbDL0nXlTUqlGcQs7o2l
         ib0tPKTpZQvmsUavCuVrC6HXN61cQt0BStK08K4NJIrDIO0BPjlk1o30pOgnwsYmtG0c
         rfDVvDJ3ncn58t6ZyXPzpneUlA8HQFRYpI05IRRhxwBwJ7eKoeg3Z8+idMBjeTqiJQIp
         TtmbvmXl6mVW7l/0BjrroTw54X15G6fuNx2F1Lv5osKewAGkKMycg6dFQN7U8jt3M6LD
         PBWg==
X-Gm-Message-State: AGi0PuZu6pRASMzQ9n/c4uTr9hBOvacJfBTdcQYEFLk1O1pwC8BNhoHs
        jXER6qD1qcSU355o4wlBpgTYPQOYbOJQuW/zr3AoxW8pD6zS
X-Google-Smtp-Source: APiQypLuqE7mcXIlYj421PfwWvs20jce8sEeawo0C4lsAdsiUQeSoUMxGO9mNZ6AJQivuPzseLDRxcH6iG3Vm1TYrDrybJ/muj2D
MIME-Version: 1.0
X-Received: by 2002:a02:b88e:: with SMTP id p14mr3883256jam.36.1589456238302;
 Thu, 14 May 2020 04:37:18 -0700 (PDT)
Date:   Thu, 14 May 2020 04:37:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000785a6905a59a1e4a@google.com>
Subject: linux-next boot error: WARNING: suspicious RCU usage in bpq_device_event
From:   syzbot <syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com>
To:     allison@lohutok.net, ap420073@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c9529331 Add linux-next specific files for 20200514
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17119f48100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=404a80e135048067
dashboard link: https://syzkaller.appspot.com/bug?extid=bb82cafc737c002d11ca
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bb82cafc737c002d11ca@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.7.0-rc5-next-20200514-syzkaller #0 Not tainted
-----------------------------
drivers/net/hamradio/bpqether.c:149 RCU-list traversed in non-reader section!!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by ip/3967:
 #0: ffffffff8a7bad88 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a7bad88 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5458

stack backtrace:
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 bpq_get_ax25_dev drivers/net/hamradio/bpqether.c:149 [inline]
 bpq_device_event+0x796/0x8ee drivers/net/hamradio/bpqether.c:538
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:2016 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2001
 call_netdevice_notifiers_extack net/core/dev.c:2028 [inline]
 call_netdevice_notifiers net/core/dev.c:2042 [inline]
 __dev_notify_flags+0x121/0x2c0 net/core/dev.c:8279
 dev_change_flags+0x100/0x160 net/core/dev.c:8317
 do_setlink+0xa1c/0x35d0 net/core/rtnetlink.c:2605
 __rtnl_newlink+0xad0/0x1590 net/core/rtnetlink.c:3273
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7f76dcdfcdc7
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 8b 05 4a 49 2b 00 85 c0 75 2e 48 63 ff 48 63 d2 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 a1 f0 2a 00 f7 d8 64 89 02 48
RSP: 002b:00007ffd45eccf28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000005ebd27cd RCX: 00007f76dcdfcdc7
RDX: 0000000000000000 RSI: 00007ffd45eccf70 RDI: 0000000000000003
RBP: 00007ffd45eccf70 R08: 0000000000001000 R09: fefefeff77686d74
R10: 00000000000005e9 R11: 0000000000000246 R12: 00007ffd45eccfb0
R13: 0000561a2ddea3c0 R14: 00007ffd45ed5030 R15: 0000000000000000
ip (3967) used greatest stack depth: 23144 bytes left


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
