Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF22F22B889
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgGWVUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:20:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56440 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgGWVUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:20:06 -0400
Received: by mail-io1-f69.google.com with SMTP id f21so4903866ioo.23
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:20:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8OsQi/rtngRly2aes5OHJCr6XU7KTICHzhKX0xPzoq4=;
        b=jJWD2zvyH7KswzdQX4NdfxCZtBnnKXFqFCP3uTqZnZT5qAVwxyqpb/Al+iPixNMTpU
         NuK1MbguCEjd4o2qQ32QU8PizHZfC0RyGmxwHdPzt6A9Myq5jXz4cqOXhl8G8ItLVBs9
         /QoQ65MuLZ5P1X0MzvvQROrtBAvTnMc2MeBpV0gSa4Vqk/9UErwcdjQPu5UbgDxyVpTd
         CYUojw6x1tVP0JkLEFrRNGtQnmA0x2dJzgtcJ4A4fM4+6AreP7VQsbwL/UOSaZJVuREP
         MRzN6Fur3fbHEO6A0NeZqBNRFbjbURfqhmMZ7Qu5ZtX0HVhrEDABENofvk56ZArplodX
         ceXA==
X-Gm-Message-State: AOAM530y/IGnCSUfoMaLolRhl6I1knmOmCAvdnkrB0BqggEIo53BeL24
        r/yD2dRor7lAL7NIfnaSBdVTqHvLFkhMY+l5XZzB47TcO6H2
X-Google-Smtp-Source: ABdhPJySXYoykumIrlUktwKjkmXgW7KFAwAJVGuQHGNXzGRgHXRiekNfL/HLAh/yfSaCAJV29uQD4tvuHcS03PqthES9It126o4f
MIME-Version: 1.0
X-Received: by 2002:a92:150d:: with SMTP id v13mr6690732ilk.297.1595539205575;
 Thu, 23 Jul 2020 14:20:05 -0700 (PDT)
Date:   Thu, 23 Jul 2020 14:20:05 -0700
In-Reply-To: <CAM_iQpXTe-DCr2MozGTik-SxOt8wiTehe6YkNhZGtDWfbHNPTA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000092da5105ab226b64@google.com>
Subject: Re: KASAN: use-after-free Read in macvlan_dev_get_iflink
From:   syzbot <syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in macvlan_get_link_net

general protection fault, probably for non-canonical address 0xdffffc00000000b3: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
CPU: 0 PID: 8229 Comm: syz-executor.0 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:read_pnet include/net/net_namespace.h:330 [inline]
RIP: 0010:dev_net include/linux/netdevice.h:2261 [inline]
RIP: 0010:macvlan_get_link_net+0x43/0x60 drivers/net/macvlan.c:1667
Code: c6 f0 0b 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 dc cb d6 fc bb 98 05 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 be cb d6 fc 48 8b 03 5b 41 5e 41
RSP: 0018:ffffc90004e47110 EFLAGS: 00010202
RAX: 00000000000000b3 RBX: 0000000000000598 RCX: ffff88808f57c040
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888089dc8000
RBP: ffffc90004e47228 R08: ffffffff866c14ae R09: fffffbfff12b7531
R10: fffffbfff12b7531 R11: 0000000000000000 R12: 1ffff110113b904b
R13: ffff888089dc825f R14: ffff888089dc8bf0 R15: dffffc0000000000
FS:  00007f40720ea700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005623955cb160 CR3: 000000009dc8e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rtnl_fill_link_netnsid net/core/rtnetlink.c:1569 [inline]
 rtnl_fill_ifinfo+0x3355/0x4650 net/core/rtnetlink.c:1758
 rtmsg_ifinfo_build_skb+0xe2/0x180 net/core/rtnetlink.c:3706
 rollback_registered_many+0xc9b/0x14a0 net/core/dev.c:8972
 unregister_netdevice_many+0x46/0x260 net/core/dev.c:10113
 __rtnl_newlink net/core/rtnetlink.c:3381 [inline]
 rtnl_newlink+0x1876/0x1c10 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb99
Code: Bad RIP value.
RSP: 002b:00007f40720e9c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000502680 RCX: 000000000045cb99
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a40 R14: 00000000004cd2f6 R15: 00007f40720ea6d4
Modules linked in:
---[ end trace 45c7e0a1442252cb ]---
RIP: 0010:read_pnet include/net/net_namespace.h:330 [inline]
RIP: 0010:dev_net include/linux/netdevice.h:2261 [inline]
RIP: 0010:macvlan_get_link_net+0x43/0x60 drivers/net/macvlan.c:1667
Code: c6 f0 0b 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 dc cb d6 fc bb 98 05 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 be cb d6 fc 48 8b 03 5b 41 5e 41
RSP: 0018:ffffc90004e47110 EFLAGS: 00010202
RAX: 00000000000000b3 RBX: 0000000000000598 RCX: ffff88808f57c040
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888089dc8000
RBP: ffffc90004e47228 R08: ffffffff866c14ae R09: fffffbfff12b7531
R10: fffffbfff12b7531 R11: 0000000000000000 R12: 1ffff110113b904b
R13: ffff888089dc825f R14: ffff888089dc8bf0 R15: dffffc0000000000
FS:  00007f40720ea700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005623955cb160 CR3: 000000009dc8e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         9506a941 net: fix a race condition in dev_get_iflink()
git tree:       https://github.com/congwang/linux.git net
console output: https://syzkaller.appspot.com/x/log.txt?x=1569d430900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1a5a263f7a540cb
dashboard link: https://syzkaller.appspot.com/bug?extid=95eec132c4bd9b1d8430
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

