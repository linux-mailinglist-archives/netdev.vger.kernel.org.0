Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B24140117F
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 22:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhIEUX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 16:23:29 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:34733 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbhIEUX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 16:23:28 -0400
Received: by mail-io1-f70.google.com with SMTP id a9-20020a5ec309000000b005baa3f77016so3718389iok.1
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 13:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=c5leV5y9rccNMKyaVLsPr4ci3Qbh+DuXsgXg1dI/SAo=;
        b=VqBVMsebJeivkyZ9GWp86KbtugZHOiSX+b5EEYZlU04+sWIJ4KhhhrpHAYSkLFDBvu
         QGPCdPa+rIdGtBVC03zpDFtRhHdkW1zcLMsy9zLwRXkEAUmXyovxUpkkGThb1JY2xhwU
         9xFmM/Ure5c9D036ebkweezjjbcZp+olHTddPydT6KvklR5ztprO7vE3E2gQjoO/Nr+2
         tYvBfH8A7rKr1MO6jig51dMQ+3UNQX2MxotAxfGwBuXXa0je6PyZcQJVEDVdN2KvxGcR
         1J7pPZZ3nAKYneUDhjtr7lKb5FSIlofgTiYobR3mhhq1vCOheyYGUfaHA1encxtpLz1D
         4e2g==
X-Gm-Message-State: AOAM531oFSs4VH/gC4r6IgLtafqigaPL1h+lWD+TBQ/5vZwtAW9FvKx3
        Wdgt7P+JdlPSB8IgJLcLwYg1IrhUXer8EsX5egaYKJVVhAqH
X-Google-Smtp-Source: ABdhPJzbK8MusWS7FLnSncUFAZP00mUWU/cDuvnVsoO1YTOA709AMU9z/9Qk3/ShWZzIlwWHSrb7ihPmjRDKqEZOB1KKKb1v9t45
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1107:: with SMTP id u7mr6089430ilk.39.1630873344357;
 Sun, 05 Sep 2021 13:22:24 -0700 (PDT)
Date:   Sun, 05 Sep 2021 13:22:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005d3d5f05cb454a4b@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_mac_create
From:   syzbot <syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, w@1wt.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f1583cb1be35 Merge tag 'linux-kselftest-next-5.15-rc1' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e15a43300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa56a640db99eb1
dashboard link: https://syzkaller.appspot.com/bug?extid=ee5cb15f4a0e85e0d54e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c97493300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d974b5300000

The issue was bisected to:

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 16:45:49 2021 +0000

    mm: don't allow oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1780855d300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1440855d300000
console output: https://syzkaller.appspot.com/x/log.txt?x=1040855d300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8439 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 8439 Comm: syz-executor737 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 4d 17 0d 00 49 89 c5 e9 69 ff ff ff e8 30 3e d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 1f 3e d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 06
RSP: 0018:ffffc90001097290 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000001f RCX: 0000000000000000
RDX: ffff888074f06240 RSI: ffffffff81a41371 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001f
R10: ffffffff81a4132e R11: 000000000000001f R12: 0000000400000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888029e5d3c0
FS:  00000000019c3300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000106 CR3: 0000000023af8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_mac_create+0x3bb/0xf50 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcc15b62a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 0000000000403020 R08: 0000000000000005 R09: 0000000000400488
R10: 0000000000000002 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
