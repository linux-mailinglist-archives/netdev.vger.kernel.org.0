Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB9F67242D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjARQw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjARQw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:52:56 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F97A5D3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:52:55 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id n18-20020a056e02101200b0030f2b79c2ffso2276309ilj.20
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:52:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CUF80VzlHqe0u3cUtU7I01bid/TGucfa6cXL81Xyavo=;
        b=wCD/PP5PydMrKSEjQmSUpFDkatmpNp46fwRa7UeK07m0gpa+OKunVr6md51SeC+0fH
         SVhq1u1ZOEQnHEE6b5RaCCLSvaYpd2Y3eXjoa9xp/mGjyPcqgESOmngiCTpqkYupMe8X
         olLLAFTmrGSohtlFt93BwIEY2M/d33+3P/D4B0b59+6BD65gp62J5BzcPCgpJqljmJWE
         Hn9EmJ+eKjDKHden6Ili8BmE1s3mjrsktGCjdIJ+SpS/qMeDmIBTl1MQ/+VTaP6fzsV/
         bEmURlfnq0rBMlBj3KQUrFDDerbDJ/Isb1lA05MPsMj6T04kogGDuBz+hwG7JGUuhQlN
         gG2g==
X-Gm-Message-State: AFqh2kpSuKm8bcFBjeHirLye23STJRfOSyWBCcs6+yohrK8HuCwN0URK
        oMx0FOOp7Ho8yc0slWN7zj5pL009XCt3FwVOJo2Q1CwQYRND
X-Google-Smtp-Source: AMrXdXv08pIf4C9Y2+YsDPxfNJC1X8DT8RXxxyXWaYvzbCwU0ndKM7Z37YkBcjrAb/Dv/q51cGKWGjHyPdN1d5thBzAsBPbCEwwl
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4410:b0:3a5:e65b:5d57 with SMTP id
 bp16-20020a056638441000b003a5e65b5d57mr605002jab.305.1674060775129; Wed, 18
 Jan 2023 08:52:55 -0800 (PST)
Date:   Wed, 18 Jan 2023 08:52:55 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d58eae05f28ca51f@google.com>
Subject: [syzbot] kernel BUG in ip_frag_next
From:   syzbot <syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, saeed@kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0c68c8e5ec68 net: mdio: cavium: Remove unneeded simicolons
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=147c7051480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4695869845c5f393
dashboard link: https://syzkaller.appspot.com/bug?extid=c8a2e66e37eee553c4fd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173fca39480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=107ba0a9480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/15c191498614/disk-0c68c8e5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c4c9368d89c/vmlinux-0c68c8e5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/083770efc7c4/bzImage-0c68c8e5.xz

The issue was bisected to:

commit eedade12f4cb7284555c4c0314485e9575c70ab7
Author: Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Fri Jan 13 13:52:04 2023 +0000

    net: kfree_skb_list use kmem_cache_free_bulk

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1136ec41480000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1336ec41480000
console output: https://syzkaller.appspot.com/x/log.txt?x=1536ec41480000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")

raw_sendmsg: syz-executor409 forgot to set AF_INET. Fix it!
------------[ cut here ]------------
kernel BUG at net/ipv4/ip_output.c:724!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5073 Comm: syz-executor409 Not tainted 6.2.0-rc3-syzkaller-00457-g0c68c8e5ec68 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
RIP: 0010:ip_frag_next+0xa03/0xa50 net/ipv4/ip_output.c:724
Code: e8 82 b1 86 f9 e9 95 fa ff ff 48 8b 3c 24 e8 74 b1 86 f9 e9 5b f8 ff ff 4c 89 ff e8 67 b1 86 f9 e9 1f f8 ff ff e8 3d ad 38 f9 <0f> 0b 48 89 54 24 20 4c 89 44 24 18 e8 4c b1 86 f9 48 8b 54 24 20
RSP: 0018:ffffc90003a6f6b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90003a6f818 RCX: 0000000000000000
RDX: ffff8880772c0000 RSI: ffffffff8848a583 RDI: 0000000000000005
RBP: 00000000000005c8 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffff2 R11: 0000000000000000 R12: ffff888026841dc0
R13: ffffc90003a6f81c R14: 00000000fffffff2 R15: ffffc90003a6f830
FS:  0000555555b08300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005622b70166a8 CR3: 000000007780f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ip_do_fragment+0x873/0x17d0 net/ipv4/ip_output.c:902
 ip_fragment.constprop.0+0x16b/0x240 net/ipv4/ip_output.c:581
 __ip_finish_output net/ipv4/ip_output.c:304 [inline]
 __ip_finish_output+0x2de/0x650 net/ipv4/ip_output.c:288
 ip_finish_output+0x31/0x280 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip_mc_output+0x21f/0x710 net/ipv4/ip_output.c:415
 dst_output include/net/dst.h:444 [inline]
 ip_local_out net/ipv4/ip_output.c:126 [inline]
 ip_send_skb net/ipv4/ip_output.c:1586 [inline]
 ip_push_pending_frames+0x129/0x2b0 net/ipv4/ip_output.c:1606
 raw_sendmsg+0x1338/0x2df0 net/ipv4/raw.c:645
 inet_sendmsg+0x9d/0xe0 net/ipv4/af_inet.c:827
 sock_sendmsg_nosec net/socket.c:722 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:745
 __sys_sendto+0x23a/0x340 net/socket.c:2142
 __do_sys_sendto net/socket.c:2154 [inline]
 __se_sys_sendto net/socket.c:2150 [inline]
 __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2150
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f8efa22c499
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd43ed3198 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffd43ed31b8 RCX: 00007f8efa22c499
RDX: 000000000000fcf2 RSI: 0000000020000380 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000020001380 R09: 000000000000006e
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd43ed31c0
R13: 00007ffd43ed31e0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ip_frag_next+0xa03/0xa50 net/ipv4/ip_output.c:724
Code: e8 82 b1 86 f9 e9 95 fa ff ff 48 8b 3c 24 e8 74 b1 86 f9 e9 5b f8 ff ff 4c 89 ff e8 67 b1 86 f9 e9 1f f8 ff ff e8 3d ad 38 f9 <0f> 0b 48 89 54 24 20 4c 89 44 24 18 e8 4c b1 86 f9 48 8b 54 24 20
RSP: 0018:ffffc90003a6f6b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90003a6f818 RCX: 0000000000000000
RDX: ffff8880772c0000 RSI: ffffffff8848a583 RDI: 0000000000000005
RBP: 00000000000005c8 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffff2 R11: 0000000000000000 R12: ffff888026841dc0
R13: ffffc90003a6f81c R14: 00000000fffffff2 R15: ffffc90003a6f830
FS:  0000555555b08300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557162e92068 CR3: 000000007780f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
