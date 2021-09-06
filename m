Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF87D401E20
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243913AbhIFQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:18:24 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:56461 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234132AbhIFQSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 12:18:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2A770CC00FC;
        Mon,  6 Sep 2021 18:17:12 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  6 Sep 2021 18:17:09 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 98A0FCC00F8;
        Mon,  6 Sep 2021 18:17:08 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 6E9AF340D60; Mon,  6 Sep 2021 18:17:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 6A284340D5D;
        Mon,  6 Sep 2021 18:17:08 +0200 (CEST)
Date:   Mon, 6 Sep 2021 18:17:08 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     syzbot <syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com>
cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: kmalloc bug in hash_ip_create
In-Reply-To: <000000000000ea2f2605cb1ff6f6@google.com>
Message-ID: <b891cfcd-eecf-b1a8-594-e744aebd55f@netfilter.org>
References: <000000000000ea2f2605cb1ff6f6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

I'm going to send the patch which fixes the issue together with the other 
ones in the same bunch.

Best regards,
Jozsef

On Fri, 3 Sep 2021, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13246f25300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
> dashboard link: https://syzkaller.appspot.com/bug?extid=3493b1873fb3ea827986
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11602f35300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8fbf5300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8430 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 8430 Comm: syz-executor792 Not tainted 5.14.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 8d 12 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 21 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 21 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
> RSP: 0018:ffffc9000108f280 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc9000108f3a0 RCX: 0000000000000000
> RDX: ffff88801bfd5580 RSI: ffffffff81a4f621 RDI: 0000000000000003
> RBP: 0000000000400dc0 R08: 000000007fffffff R09: 00000000ffffffff
> R10: ffffffff81a4f5de R11: 000000000000001f R12: 0000000200000018
> R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888028b41a00
> FS:  0000000002409300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000006 CR3: 00000000127f1000 CR4: 0000000000350ee0
> Call Trace:
>  hash_ip_create+0x4bb/0x13d0 net/netfilter/ipset/ip_set_hash_gen.h:1524
>  ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
>  nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f029
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd662e8c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f029
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 0000000000403010 R08: 0000000000000005 R09: 0000000000400488
> R10: 0000000000000001 R11: 0000000000000246 R12: 00000000004030a0
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
