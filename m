Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB8D39E120
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFGPsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:48:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:41618 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhFGPsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:48:17 -0400
Received: by mail-il1-f199.google.com with SMTP id v15-20020a92d24f0000b02901e85881a504so5851264ilg.8
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 08:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=INHA8ZEnrl18BkANOT7Nn30hsnu7iHrn0GE/AclKKVs=;
        b=SMeArZvlLXWqPbRLOPpX1G/gpUIr39+oO5KfnTHl3zK+j7nihoWX+KG0dRAaK5oMQ4
         1ugWlzX69p1Ng0I3he82jeyDhqvqPqdWU85MPVM3YwTO60zdXoenU+tMXsRi14dossuX
         qG8Y37PlX7ze0HSj0D4c3XjpnWIujbwSn4QNnlRRBaWP/mD0QHlf3oh+U8qoS69JRgGR
         cY01+NO30FCZMVEUUlSaSVCzsoWbEMJygoYmNRSr/lArqif2k1gbBoIfck/K7+OCjmzE
         FMKdisikSNhIYuAVhcm9RV/sPnpQ2ytDbmGthHMmoSachhymUtC8AO5RoulOqzjv1Z+d
         v7gQ==
X-Gm-Message-State: AOAM532plguuTmQLjtKOBR2VTBJLz1b8oo64vQ3apRmWiww4Yvdes0rl
        xUE6iNUqEVXyPUdm6IsbjXjE5LC06BeQXo6QUKBhhNmyUeJq
X-Google-Smtp-Source: ABdhPJzwA6WXEXD9nC5toM6mIdr2yQ3UPrc/70NhvH7vkSC/ePqYEsb0kgPJ3EgBWwxp+fNe3Cra+mT5CMCWo4cI0YEQUyB76KHe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1809:: with SMTP id a9mr4996983ilv.221.1623080786195;
 Mon, 07 Jun 2021 08:46:26 -0700 (PDT)
Date:   Mon, 07 Jun 2021 08:46:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b3f96105c42ef146@google.com>
Subject: [syzbot] general protection fault in kcm_sendmsg
From:   syzbot <syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kadlec@netfilter.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        paskripkin@gmail.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, unixbhaskar@gmail.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org, zhengyongjun3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1a802423 virtio-net: fix for skb_over_panic inside big mode
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=159b08afd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
dashboard link: https://syzkaller.appspot.com/bug?extid=65badd5e74ec62cb67dc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104624afd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e36197d00000

The issue was bisected to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11739740300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13739740300000
console output: https://syzkaller.appspot.com/x/log.txt?x=15739740300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
CPU: 1 PID: 8423 Comm: syz-executor788 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:skb_end_pointer include/linux/skbuff.h:1419 [inline]
RIP: 0010:skb_has_frag_list include/linux/skbuff.h:3566 [inline]
RIP: 0010:kcm_sendmsg+0xdd7/0x2240 net/kcm/kcmsock.c:1069
Code: fb 05 0f 84 25 0b 00 00 e8 b6 f3 48 f9 48 8b 44 24 18 4c 8d a8 c8 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 5d 11 00 00 48 8b 44 24 18 48 8d a8 c4 00 00 00
RSP: 0018:ffffc900017ef9b8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000019 RSI: ffffffff882be8ca RDI: 0000000000000003
RBP: ffff8880361685aa R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff882bec2b R11: 0000000000000000 R12: 00000000fffffe00
R13: 00000000000000c8 R14: ffff88802ab74540 R15: ffff888036168000
FS:  0000000000c0e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c4467bb930 CR3: 0000000023a8c000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43fcb9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff00f21778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043fcb9
RDX: 0000000000000000 RSI: 0000000020001c80 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fff00f21918 R09: 00007fff00f21918
R10: 00007fff00f21918 R11: 0000000000000246 R12: 0000000000403540
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 0000000000400488
Modules linked in:
---[ end trace 458d0f6d0de61f61 ]---
RIP: 0010:skb_end_pointer include/linux/skbuff.h:1419 [inline]
RIP: 0010:skb_has_frag_list include/linux/skbuff.h:3566 [inline]
RIP: 0010:kcm_sendmsg+0xdd7/0x2240 net/kcm/kcmsock.c:1069
Code: fb 05 0f 84 25 0b 00 00 e8 b6 f3 48 f9 48 8b 44 24 18 4c 8d a8 c8 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 5d 11 00 00 48 8b 44 24 18 48 8d a8 c4 00 00 00
RSP: 0018:ffffc900017ef9b8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000019 RSI: ffffffff882be8ca RDI: 0000000000000003
RBP: ffff8880361685aa R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff882bec2b R11: 0000000000000000 R12: 00000000fffffe00
R13: 00000000000000c8 R14: ffff88802ab74540 R15: ffff888036168000
FS:  0000000000c0e300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000c0e2c0 CR3: 0000000023a8c000 CR4: 00000000001506f0
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
