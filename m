Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B853D433
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 03:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349866AbiFDBCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 21:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiFDBCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 21:02:24 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A12396B3
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 18:02:22 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id r9-20020a92cd89000000b002d16798b3cfso7308473ilb.22
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 18:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a+3cX63j0HBxXf0a3L3zpLBULDl2FODnZzb1/pTxks0=;
        b=GEFI0euJTAugjNn8u7q4KNgbwaMaQkuBal2hjHFOPPZSdpS4sJV/5bYOQBJNnxA5CB
         fRIvUdS8+5RHfYQFxtJg07A+gV/RWHSwMjDCDppLIAB9365v9TampSI32NW3/sdcF602
         xUHq3zRPX00XmuBbwZNuAxNRuGFCuorElU4Ep01OOLj3oWyG2ORkusg9wNlJuLqkKJzx
         Qcfi78DqZCUsKeaeaznlyIydE25vRk6i3t24Jg25fP3IaqHfkIq3L86Fp40uz2+5IwcL
         tSJeVqoD+9Fa9lOfSvHa8nmEOgwDzbGu6rwqQ1gL1tijKBVNGlerFwAAwTN7OErMYX3Z
         8DEw==
X-Gm-Message-State: AOAM533IXMxcLmt6aC0gsq9SUNeGIytozTp1NC0dAzBpJv56ic1uXkXB
        2D3KmqjPu6yq8E5wNwbe1aYIH/wB7VteoGrVvBNAVD1hHb4L
X-Google-Smtp-Source: ABdhPJwiDZ5m2kBfl7tNv3jbfR1q82b6i15VD7p6BurmnmTaDg4W4iwGe9cNfOy66GUpVbRjXFu9HIC9+Sb688Us1P29KXFmBov9
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:154a:b0:2d1:d151:3c26 with SMTP id
 j10-20020a056e02154a00b002d1d1513c26mr7030398ilu.24.1654304542187; Fri, 03
 Jun 2022 18:02:22 -0700 (PDT)
Date:   Fri, 03 Jun 2022 18:02:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009667e705e094ca3c@google.com>
Subject: [syzbot] kernel BUG in __skb_gso_segment
From:   syzbot <syzbot+7160965e6a93d826048a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com, mst@redhat.com, netdev@vger.kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2c5ca23f7414 Merge tag 'ovl-update-5.19' of git://git.kern..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11330935f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b19cdd2d45cc221
dashboard link: https://syzkaller.appspot.com/bug?extid=7160965e6a93d826048a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1724add5f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1324cbf9f00000

The issue was bisected to:

commit dfed913e8b55a0c2c4906f1242fd38fd9a116e49
Author: Hangbin Liu <liuhangbin@gmail.com>
Date:   Mon Apr 25 01:45:02 2022 +0000

    net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=169079bdf00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=159079bdf00000
console output: https://syzkaller.appspot.com/x/log.txt?x=119079bdf00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7160965e6a93d826048a@syzkaller.appspotmail.com
Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")

------------[ cut here ]------------
kernel BUG at include/linux/skbuff.h:2699!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3601 Comm: syz-executor210 Not tainted 5.18.0-syzkaller-11338-g2c5ca23f7414 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__skb_pull include/linux/skbuff.h:2699 [inline]
RIP: 0010:skb_mac_gso_segment+0x48f/0x530 net/core/gro.c:136
Code: 00 48 c7 c7 00 96 d4 8a c6 05 cb d3 45 06 01 e8 26 bb d0 01 e9 2f fd ff ff 49 c7 c4 ea ff ff ff e9 f1 fe ff ff e8 91 84 19 fa <0f> 0b 48 89 df e8 97 44 66 fa e9 7f fd ff ff e8 ad 44 66 fa e9 48
RSP: 0018:ffffc90002e2f4b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000012 RCX: 0000000000000000
RDX: ffff88805bb58000 RSI: ffffffff8760ed0f RDI: 0000000000000004
RBP: 0000000000005dbc R08: 0000000000000004 R09: 0000000000000fe0
R10: 0000000000000fe4 R11: 0000000000000000 R12: 0000000000000fe0
R13: ffff88807194d780 R14: 1ffff920005c5e9b R15: 0000000000000012
FS:  000055555730f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200015c0 CR3: 0000000071ff8000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 __skb_gso_segment+0x327/0x6e0 net/core/dev.c:3411
 skb_gso_segment include/linux/netdevice.h:4749 [inline]
 validate_xmit_skb+0x6bc/0xf10 net/core/dev.c:3669
 validate_xmit_skb_list+0xbc/0x120 net/core/dev.c:3719
 sch_direct_xmit+0x3d1/0xbe0 net/sched/sch_generic.c:327
 __dev_xmit_skb net/core/dev.c:3815 [inline]
 __dev_queue_xmit+0x14a1/0x3a00 net/core/dev.c:4219
 packet_snd net/packet/af_packet.c:3071 [inline]
 packet_sendmsg+0x21cb/0x5550 net/packet/af_packet.c:3102
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2492
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x132/0x220 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f4b95da06c9
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd7defc4c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffd7defc4f0 RCX: 00007f4b95da06c9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000000003 R08: bb1414ac00000050 R09: bb1414ac00000050
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd7defc4e0 R14: 00007ffd7defc4d8 R15: 00007ffd7defc4d4
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__skb_pull include/linux/skbuff.h:2699 [inline]
RIP: 0010:skb_mac_gso_segment+0x48f/0x530 net/core/gro.c:136
Code: 00 48 c7 c7 00 96 d4 8a c6 05 cb d3 45 06 01 e8 26 bb d0 01 e9 2f fd ff ff 49 c7 c4 ea ff ff ff e9 f1 fe ff ff e8 91 84 19 fa <0f> 0b 48 89 df e8 97 44 66 fa e9 7f fd ff ff e8 ad 44 66 fa e9 48
RSP: 0018:ffffc90002e2f4b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000012 RCX: 0000000000000000
RDX: ffff88805bb58000 RSI: ffffffff8760ed0f RDI: 0000000000000004
RBP: 0000000000005dbc R08: 0000000000000004 R09: 0000000000000fe0
R10: 0000000000000fe4 R11: 0000000000000000 R12: 0000000000000fe0
R13: ffff88807194d780 R14: 1ffff920005c5e9b R15: 0000000000000012
FS:  000055555730f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200015c0 CR3: 0000000071ff8000 CR4: 0000000000350ee0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
