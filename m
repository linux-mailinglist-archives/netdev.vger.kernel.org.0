Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D9B41CB60
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345569AbhI2R6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:58:03 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:48040 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343675AbhI2R6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:58:02 -0400
Received: by mail-io1-f69.google.com with SMTP id t4-20020a056602140400b005d60162d0c4so3695462iov.14
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8EkP+0NB8mdZ019aGNAgeV/WzYJeLcjm5TRKX1/Ca/Y=;
        b=ewqRpzJgWhaEK/jgPaGZ6Dbe1cGZ8fnwiKb5McJTzc18u3gLh3PPnRbmyoQFz36QjT
         /aogpSxZcrheVJmSBWLE3IFsIU7WYZ7356ymQ/5A3CTl3VNWhS1Zk2ltXhIC02z2EWcu
         UmJZP3quLuEAT08of+5KKFUCV5ydeCw28T0xHK49TIU0NRec3Eoi1kkPLEi3gfayQs3E
         quJXUnsTRUSha4Q28C9wxmpUyaRse4ws35TwfPR9AsNgVVGHTP0TP+hfA4Jmu8QieKup
         cmrkct+lzGyZq/1TfUuHzM40QJMllZ/I6qZsrmoScEO1yZLsth6dhritg/ogZ1Iwy3zy
         oN9w==
X-Gm-Message-State: AOAM530mKVW/54BGPBLGTPgFh/1ltTcpO5mVmxAK3RRWSX55QtqzWfPB
        UkWDugWl0POCqLK7XCJ3BcbeSoo65LusDg3b5W35HfnzGadw
X-Google-Smtp-Source: ABdhPJxUHoL5xvF2va6rKr2jDyegz+Do0jKBNzgXgYqC13RdD+FG2aN7OXGu9w34driWjQusArCJTbbQsjBYKxSPDBowFKfSVkUG
MIME-Version: 1.0
X-Received: by 2002:a5e:c00e:: with SMTP id u14mr776832iol.13.1632938180630;
 Wed, 29 Sep 2021 10:56:20 -0700 (PDT)
Date:   Wed, 29 Sep 2021 10:56:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000325b0905cd260c86@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_netportnet_create
From:   syzbot <syzbot+60c1bad54e53f88e8c4f@syzkaller.appspotmail.com>
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

HEAD commit:    0513e464f900 Merge tag 'perf-tools-fixes-for-v5.15-2021-09..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1567e17f300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
dashboard link: https://syzkaller.appspot.com/bug?extid=60c1bad54e53f88e8c4f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15403413300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15041b5b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60c1bad54e53f88e8c4f@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6527 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 6527 Comm: syz-executor600 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 ad 18 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 98 d0 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 98 d0 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
RSP: 0018:ffffc900011ef288 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc900011ef3a0 RCX: 0000000000000000
RDX: ffff88801c058000 RSI: ffffffff81a56291 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: ffff8880b9c32a0b
R10: ffffffff81a5624e R11: 000000000000001f R12: 0000000080000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff88801b33d000
FS:  000055555632e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f13792ab6c0 CR3: 0000000071744000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_netportnet_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
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
RIP: 0033:0x7fd5133b21c9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe43b70828 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd5133b21c9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000003
RBP: 00007fd5133761b0 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 00007fd513376240
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
