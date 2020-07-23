Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D1622B8AB
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgGWVaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:30:09 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:39000 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgGWVaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:30:08 -0400
Received: by mail-il1-f199.google.com with SMTP id f66so4403327ilh.6
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iJhRwEB1xHBmgw6l/JGnS6BQGfboMUGTe4J+3YIhjrY=;
        b=rekOE9TyIfDtGMcLUnEuRSneU/LQRN1fwq7q0lwE6UUJtOHWp7Kh4jj3/ymtNVo/xz
         WT6EHksNE6WCEBeI6E6VN6iYTKTdqNGWg/pm27Plflc958e303N3cI8q2wLhBTo6KZbN
         Kad7UvWRNVC8xY3R/9xJYlnnCZrU0o8Tqu/9iFcMkjLgi034cL+nyU6/JQpW15Q2fam/
         rwWktMdPTvbrQRJEa3DOvDHFviypNLCnG6K6vwCf1fF5uGZSzXqBwrDL2YF1xbfE7hhZ
         U/xHfGD30Hr81cCLwamIr3hUTLsDujYvNwONQl/KgKbHaquwSpU2Q30lKV0o5iMxJ8KT
         ygmg==
X-Gm-Message-State: AOAM5333jFXy3ZLv7MRnwSnlz/4lW92Mthlzkl1PY6roIbNFlaDsS21H
        7hLOY29MfoYd3foVC4/IKXC7rYWM4q+blg2Rigl7Ga3EaYVC
X-Google-Smtp-Source: ABdhPJwzg4AcXVHS74igdyEENBPIPx4X3QHdLVDcd8HF8wK0jLWE1igjbSfZQ522tmQtsAdQ3QKfceaajl9hJTRpS5Sa5vToljm3
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:50:: with SMTP id i16mr399043ilr.173.1595539807520;
 Thu, 23 Jul 2020 14:30:07 -0700 (PDT)
Date:   Thu, 23 Jul 2020 14:30:07 -0700
In-Reply-To: <CAM_iQpXq9dYj67Lrv73UazJWG5UVVuMO0iFwJJWg7S_H-z1YcA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073cea505ab228feb@google.com>
Subject: Re: KASAN: use-after-free Read in vlan_dev_get_iflink
From:   syzbot <syzbot+d702fd2351989927037c@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in vlan_get_link_net

general protection fault, probably for non-canonical address 0xdffffc00000000b3: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
CPU: 1 PID: 8207 Comm: syz-executor.3 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:read_pnet include/net/net_namespace.h:330 [inline]
RIP: 0010:dev_net include/linux/netdevice.h:2261 [inline]
RIP: 0010:vlan_get_link_net+0x46/0x70 net/8021q/vlan_netlink.c:279
Code: fa 48 c1 ea 03 80 3c 02 00 75 2e 48 8b 9b 70 0c 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 98 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 10 48 8b 83 98 05 00 00 5b c3 e8 86 1f 63 fa eb cb
RSP: 0018:ffffc90004706eb8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888092c85230
RDX: 00000000000000b3 RSI: ffffffff874ffe39 RDI: 0000000000000598
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8a7b8647
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90004706f80
R13: 0000000000000030 R14: ffff8880930ba900 R15: ffff8880930cc000
FS:  00007f4a9113a700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643b6ad2140 CR3: 000000009335e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rtnl_fill_link_netnsid net/core/rtnetlink.c:1569 [inline]
 rtnl_fill_ifinfo+0x1bc5/0x3c40 net/core/rtnetlink.c:1758
 rtmsg_ifinfo_build_skb+0xcd/0x1a0 net/core/rtnetlink.c:3706
 rollback_registered_many+0xb7d/0xf60 net/core/dev.c:8972
 unregister_netdevice_many.part.0+0x1a/0x2f0 net/core/dev.c:10113
 unregister_netdevice_many+0x36/0x50 net/core/dev.c:10112
 __rtnl_newlink+0x13bd/0x1750 net/core/rtnetlink.c:3381
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3398
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1f9
Code: Bad RIP value.
RSP: 002b:00007f4a91139c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b580 RCX: 000000000045c1f9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffc004cce8f R14: 00007f4a9113a9c0 R15: 000000000078bfac
Modules linked in:
---[ end trace e42f7b565341dee6 ]---
RIP: 0010:read_pnet include/net/net_namespace.h:330 [inline]
RIP: 0010:dev_net include/linux/netdevice.h:2261 [inline]
RIP: 0010:vlan_get_link_net+0x46/0x70 net/8021q/vlan_netlink.c:279
Code: fa 48 c1 ea 03 80 3c 02 00 75 2e 48 8b 9b 70 0c 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 98 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 10 48 8b 83 98 05 00 00 5b c3 e8 86 1f 63 fa eb cb
RSP: 0018:ffffc90004706eb8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888092c85230
RDX: 00000000000000b3 RSI: ffffffff874ffe39 RDI: 0000000000000598
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8a7b8647
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90004706f80
R13: 0000000000000030 R14: ffff8880930ba900 R15: ffff8880930cc000
FS:  00007f4a9113a700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643b6ad2140 CR3: 000000009335e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         9506a941 net: fix a race condition in dev_get_iflink()
git tree:       https://github.com/congwang/linux.git net
console output: https://syzkaller.appspot.com/x/log.txt?x=158bd540900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dddbcb5a9f4192db
dashboard link: https://syzkaller.appspot.com/bug?extid=d702fd2351989927037c
compiler:       gcc (GCC) 10.1.0-syz 20200507

