Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C2311926
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhBFC42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:56:28 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:36264 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhBFCsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:48:54 -0500
Received: by mail-il1-f199.google.com with SMTP id z5so7998403ilq.3
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 18:48:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BXozcHqNYuL5j2Ska5b3mqD7pLflP2CE2Wr1H6P2MX0=;
        b=ZaWES+SoeFCufA4qmOrV5kkP722p23nd24Cmp87N8fXcA3G0dS+McJK7g10jgc2oTN
         wa5VGiEjFWvJeuXSCPO38/q0J7a3Rv5rinnTKGa6axGUqvJjsTqXYDQqRab8ROMjkD51
         X8zYKq2L7fwCgHQqpl0g3qGKBFlRqeaDauS5xELnVx9lBs76eX+mFiR7iK8OCdRi1KkO
         4ZbjgCrfO+Adw10dOeBQmA5vTqGujgvEoQgMmZvAISbHlwhhNF5Fy18Ai8h24eRgi5sp
         D4LYEPTr6mCdSyWPUy0u/CfUrY/U2gDmV4NIaZaGBq8Fp30LMw7h3BK9knElcu1iNnot
         ronA==
X-Gm-Message-State: AOAM530MYUUlRWJ99iyxwQf9EgPrlYD5AkWJmcHaqTSgo9kja1i68ksc
        wicdM7M0lUSVoIDuoMVtJ+bmFBK1ukR6x8KaMRpUXzXIkIIb
X-Google-Smtp-Source: ABdhPJzlQYkIcI9RY/kXSUXwETZdsy0ASDWYf6DwgQRuoWNcihGqo3Lt7D4qI90RprB72OOXkeVlamomeR4LfTBtkqpJQh/69rWB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1343:: with SMTP id k3mr6566311ilr.102.1612579693247;
 Fri, 05 Feb 2021 18:48:13 -0800 (PST)
Date:   Fri, 05 Feb 2021 18:48:13 -0800
In-Reply-To: <00000000000060c28405b5df4b1b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9c04b05baa1f7b6@google.com>
Subject: Re: WARNING: ODEBUG bug in slave_kobj_release
From:   syzbot <syzbot+7bce4c2f7e1768ec3fe0@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    4d469ec8 Merge branch '1GbE' of git://git.kernel.org/pub/s..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10aa7b54d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9804f8fe1c4e3869
dashboard link: https://syzkaller.appspot.com/bug?extid=7bce4c2f7e1768ec3fe0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ce5ac4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176a96c4d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7bce4c2f7e1768ec3fe0@syzkaller.appspotmail.com

kobject_add_internal failed for bonding_slave (error: -12 parent: virt_wifi0)
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 8733 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 8733 Comm: syz-executor025 Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd c0 f5 9e 89 4c 89 ee 48 c7 c7 c0 e9 9e 89 e8 3b 30 f8 04 <0f> 0b 83 05 85 00 e1 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90001ede980 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88801c729bc0 RSI: ffffffff815b6395 RDI: fffff520003dbd22
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815af56e R11: 0000000000000000 R12: ffffffff894d8d20
R13: ffffffff899ef040 R14: ffffffff8161bfd0 R15: 1ffff920003dbd3b
FS:  00007f756d575700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000490a00 CR3: 000000001881a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_object_assert_init lib/debugobjects.c:890 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:861
 debug_timer_assert_init kernel/time/timer.c:737 [inline]
 debug_assert_init kernel/time/timer.c:782 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1202
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1252
 __cancel_work_timer+0xa6/0x520 kernel/workqueue.c:3098
 slave_kobj_release+0x48/0xe0 drivers/net/bonding/bond_main.c:1492
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 bond_kobj_init drivers/net/bonding/bond_main.c:1513 [inline]
 bond_alloc_slave drivers/net/bonding/bond_main.c:1530 [inline]
 bond_enslave+0x20f3/0x4d40 drivers/net/bonding/bond_main.c:1732
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2519
 do_setlink+0x920/0x3a70 net/core/rtnetlink.c:2715
 __rtnl_newlink+0xdc1/0x1700 net/core/rtnetlink.c:3376
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a619
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 16 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f756d5752f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004d62c8 RCX: 000000000044a619
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 00000000004d62c0 R08: 0000000000000002 R09: 0000000000003031
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049f6f4
R13: 00007f756d575300 R14: 0000000000000002 R15: 0000000000022000

