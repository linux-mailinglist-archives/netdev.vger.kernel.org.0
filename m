Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20EF3CA0C8
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhGOOjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:39:13 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:48867 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbhGOOjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:39:12 -0400
Received: by mail-io1-f70.google.com with SMTP id f2-20020a6b62020000b02905094eaa65fdso3788000iog.15
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 07:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4HZUJQeBGZ+NVG0aXehK/sNcAjBRJ2CKQkm2snQI6AE=;
        b=WHQWt/Tvc/bQZIDUoaMAmLy+t+gzdcckN4xaejYDGgg4MKeQwtOyLmuuXvqJN7STCR
         ZmXkKflflPAfMGRJN8xCzf3jmqqJlGFDJMM1vF6BffLE8FZ9YU8C2rf5M+ZjikpcDgNX
         a3wRa/Krty5eD7abuO6F+mTBLWfTsdvELKRRN/Wuiphl+cVW+p83JG02zQIrXL+hFi6k
         RCI5iglOoE6Ww3q9xLIb3aja4wsXq/bRMD4XiXv1CiMSQFYMy9A6hHMqEaoM0cgrbeMX
         yUIkcsGiv7Q8g0I6izcazedCenhmdDhdDpwzcZDcJ5pNNnSDTYTyMD5ppPhMg5/ZDgeb
         P9DA==
X-Gm-Message-State: AOAM533tMBFkefJq+j300mBz1/4f2QWZQYeU/Xd/iNoNL1AdzQXKSDem
        eKoj46e4ZipGypcenWbSMu02+XCd2QiP8py1r6ZW9Xa0oYSa
X-Google-Smtp-Source: ABdhPJzNaMhJ0NPfS3lxheTwOkZOIxBRPuxh7EcJseVxeVinrsnAt8ZUGrKnGk5En2w9syUWnFumGonuBwUmZaY6/f8Cnzpi0mRI
MIME-Version: 1.0
X-Received: by 2002:a92:b748:: with SMTP id c8mr2919947ilm.302.1626359779406;
 Thu, 15 Jul 2021 07:36:19 -0700 (PDT)
Date:   Thu, 15 Jul 2021 07:36:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000edbbe305c72a64d9@google.com>
Subject: [syzbot] general protection fault in nf_tables_dump_flowtable
From:   syzbot <syzbot+58a66a56fa9d7f98d19b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    222722bc6ebf virtio_net: check virtqueue_add_sgs() return ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=100acffc300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51ea6c9df4ed04c4
dashboard link: https://syzkaller.appspot.com/bug?extid=58a66a56fa9d7f98d19b

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+58a66a56fa9d7f98d19b@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xfbd59c0000000054: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead0000000002a0-0xdead0000000002a7]
CPU: 1 PID: 30836 Comm: syz-executor.2 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nf_tables_dump_flowtable+0x453/0xbc0 net/netfilter/nf_tables_api.c:7617
Code: 5c 31 ff 89 de e8 ad 7a 16 fa 85 db 0f 85 67 ff ff ff e8 60 73 16 fa 48 8b 04 24 48 05 a0 01 00 00 48 89 44 24 10 48 c1 e8 03 <80> 3c 28 00 0f 85 bb 06 00 00 48 8b 04 24 48 8b 98 a0 01 00 00 48
RSP: 0018:ffffc9000592f1e0 EFLAGS: 00010a02
RAX: 1bd5a00000000054 RBX: 0000000000000000 RCX: ffffc9000dede000
RDX: 0000000000040000 RSI: ffffffff875f0eb0 RDI: 0000000000000003
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8d6aef17
R10: ffffffff875f0ea3 R11: 000000000000003f R12: 0000000000000000
R13: ffff8880722d6544 R14: 0000000000000000 R15: ffff8880722d6548
FS:  00007fb776e0f700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000014a53ad CR3: 00000000715c8000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2278
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2383
 netlink_dump_start include/linux/netlink.h:258 [inline]
 nft_netlink_dump_start_rcu+0x9c/0x1b0 net/netfilter/nf_tables_api.c:859
 nf_tables_getflowtable+0x582/0x6b0 net/netfilter/nf_tables_api.c:7707
 nfnetlink_rcv_msg+0x6c6/0x13a0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x85b/0xda0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb776e0f188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffd108f5eef R14: 00007fb776e0f300 R15: 0000000000022000
Modules linked in:
---[ end trace 79a86b7be1217444 ]---
RIP: 0010:nf_tables_dump_flowtable+0x453/0xbc0 net/netfilter/nf_tables_api.c:7617
Code: 5c 31 ff 89 de e8 ad 7a 16 fa 85 db 0f 85 67 ff ff ff e8 60 73 16 fa 48 8b 04 24 48 05 a0 01 00 00 48 89 44 24 10 48 c1 e8 03 <80> 3c 28 00 0f 85 bb 06 00 00 48 8b 04 24 48 8b 98 a0 01 00 00 48
RSP: 0018:ffffc9000592f1e0 EFLAGS: 00010a02
RAX: 1bd5a00000000054 RBX: 0000000000000000 RCX: ffffc9000dede000
RDX: 0000000000040000 RSI: ffffffff875f0eb0 RDI: 0000000000000003
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8d6aef17
R10: ffffffff875f0ea3 R11: 000000000000003f R12: 0000000000000000
R13: ffff8880722d6544 R14: 0000000000000000 R15: ffff8880722d6548
FS:  00007fb776e0f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000030eb708 CR3: 00000000715c8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
