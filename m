Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE604044E5
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 07:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350660AbhIIFUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 01:20:35 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:33592 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350542AbhIIFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 01:20:33 -0400
Received: by mail-il1-f200.google.com with SMTP id h10-20020a056e020d4a00b00227fc2e6687so1069861ilj.0
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 22:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f3hT4JE/CvcilmtBix+GJkLPDC0aJEDxVIYiUI/wdA8=;
        b=RquRt5cDT6SD0Ti33/bXZ4hv7SCeh4aLzLgSENpM3/AROhSHspIPKniJXy+ssKu1zl
         6M2JSB+nTRpkq4GvmLJbg2V+Cps6DcZv91e2tjXzxt3Uv5fT/2qSJVW0u/ym7W/UcNlj
         wbl9KMa0x0N3oKXtuyQvN0nLAn2yiXtpB2pmnz0RMlLIaFKeo0xA5HgERtbLEPN5SXjD
         cgW0RfpUAlF4WzDiW1OQGQFRk66YUIVfFq/id2CP/hZxrvqxir7hz4QmCVTeLr/xNK2X
         7ZddaRaAvkjnrV82As27L1jtfrhlmAiB9c06bQtnFv6v4KFOzDSrGatF5OjmBPC2lIMy
         SyXA==
X-Gm-Message-State: AOAM531q8BQU4Jd6msshH4lHN+ebZsjzOB6etj/ri1zrLwzRdDChco0D
        ACSmRHmlRLpBkCCtha3481bpYGyzV0aJkrR4sYchQ/EqPFLc
X-Google-Smtp-Source: ABdhPJzbDwn39QD2pajtS0BqmGDWmZtqRx2uVNYFsfektWfDvS67tn9qgxfRmfFzU378bdyJkt+CMASHgEcycqPuk4LAwGuAvBOt
MIME-Version: 1.0
X-Received: by 2002:a6b:f214:: with SMTP id q20mr1142800ioh.84.1631164764876;
 Wed, 08 Sep 2021 22:19:24 -0700 (PDT)
Date:   Wed, 08 Sep 2021 22:19:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006173bf05cb892427@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_ipport_create
From:   syzbot <syzbot+a568bbab323b96631e61@syzkaller.appspotmail.com>
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

HEAD commit:    626bf91a292e Merge tag 'net-5.15-rc1' of git://git.kernel...
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150107a5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e23f04679ec35e
dashboard link: https://syzkaller.appspot.com/bug?extid=a568bbab323b96631e61
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178b5d0d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fad1dd300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a568bbab323b96631e61@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8419 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8419 Comm: syz-executor852 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 3d 13 0d 00 49 89 c5 e9 69 ff ff ff e8 50 9d d0 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 3f 9d d0 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 26
RSP: 0018:ffffc9000110f288 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000110f3a0 RCX: 0000000000000000
RDX: ffff88807ad9d580 RSI: ffffffff81a57421 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: ffff8880b9d3298b
R10: ffffffff81a573de R11: 000000000000001f R12: 0000000200000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888027ea2a00
FS:  0000000001147300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd51c03d0c8 CR3: 00000000726fe000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_ipport_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
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
RSP: 002b:00007fff01c17cc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 0000000020001080 RDI: 0000000000000003
RBP: 0000000000403020 R08: 0000000000000009 R09: 0000000000400488
R10: 0000000000000003 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
