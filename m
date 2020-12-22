Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B32E0744
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 09:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgLVIg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 03:36:59 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:49039 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgLVIg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 03:36:58 -0500
Received: by mail-io1-f71.google.com with SMTP id 191so7002942iob.15
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 00:36:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hbIYI2nNfJN0lgT9jqFdKDFFA7rUxry5dC2vCJ5BxXw=;
        b=t660PtLE+Y324Yf545JU1alZuVqxJzH6CeP5zhSic+JMmxiHNn0S5YBETb1g7bN8Nt
         TNFVXMq/tkNb0WnDS9LVRxNnR2p7Gre1YdefoN3EGHVhSQfBNw/I6HX9UbLzrFjsts/S
         udLfD0V9/kTmoywaRxiBB5BgFSb7a64yhxceiwiPYw8qcfg9z2CA3Z+ungnxteN030kw
         skmfAzuadZAIcraXBBPc+0iij/BJrSUSJpm8/wvKnZ2U3685IKuaCgRLK5WsOvAHFne4
         /9qtSnfZyz1YakJZEvnQj77l35hPTxTR875YZEekTj3ynv0UIB63gW5AhZ/uMPBf0ryX
         URwQ==
X-Gm-Message-State: AOAM530js/GoDQlfjfuTneZZzgnCJ5xz+d+2mqxW14NYHiX4fhV/Gp6R
        avfwZdFqYZ8v1OtnRTuLwDxccU7jE3EVAHo8kzoJ6ZaKm02L
X-Google-Smtp-Source: ABdhPJy9/gcTlDyiLUB3PnVSzz+gaZzjAIu3HCANs889rw+mhD89BT2CU12Z0k0Pqkxz+skRj5OGiblKY/H7djo88Iho4H9rg/9J
MIME-Version: 1.0
X-Received: by 2002:a6b:5006:: with SMTP id e6mr17160983iob.79.1608626176796;
 Tue, 22 Dec 2020 00:36:16 -0800 (PST)
Date:   Tue, 22 Dec 2020 00:36:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d82efe05b70977e2@google.com>
Subject: general protection fault in find_match (2)
From:   syzbot <syzbot+b08cdcfff539328e6c32@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3db1a3fa Merge tag 'staging-5.11-rc1' of git://git.kernel...
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1103eadf500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2764fc28a92339f9
dashboard link: https://syzkaller.appspot.com/bug?extid=b08cdcfff539328e6c32
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b08cdcfff539328e6c32@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000004b: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000258-0x000000000000025f]
CPU: 1 PID: 13682 Comm: syz-executor.5 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ip6_ignore_linkdown include/net/addrconf.h:407 [inline]
RIP: 0010:find_match.part.0+0xcc/0xc70 net/ipv6/route.c:753
Code: f9 0f b6 45 c0 84 c0 0f 84 39 04 00 00 e8 ec a0 c4 f9 49 8d bf 5c 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 91
RSP: 0018:ffffc900022cf000 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff88801c2cc2a0 RCX: ffffc90013d33000
RDX: 000000000000004b RSI: ffffffff87abfc74 RDI: 000000000000025c
RBP: ffffc900022cf070 R08: 0000000000000001 R09: ffffc900022cf250
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f94614f2700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f75a1fccdb8 CR3: 000000002d8c6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 find_match net/ipv6/route.c:840 [inline]
 __find_rr_leaf+0x17f/0xd10 net/ipv6/route.c:841
 find_rr_leaf net/ipv6/route.c:862 [inline]
 rt6_select net/ipv6/route.c:906 [inline]
 fib6_table_lookup+0x5b3/0xa20 net/ipv6/route.c:2193
 ip6_pol_route+0x1e1/0x11c0 net/ipv6/route.c:2229
 pol_lookup_func include/net/ip6_fib.h:583 [inline]
 fib6_rule_lookup+0x111/0x6f0 net/ipv6/fib6_rules.c:115
 ip6_route_output_flags_noref+0x2c2/0x360 net/ipv6/route.c:2510
 ip6_route_output_flags+0x8b/0x310 net/ipv6/route.c:2523
 ip6_route_output include/net/ip6_route.h:98 [inline]
 ip6_dst_lookup_tail+0xb3a/0x1700 net/ipv6/ip6_output.c:1024
 ip6_dst_lookup_flow+0x8c/0x1d0 net/ipv6/ip6_output.c:1154
 ip6_sk_dst_lookup_flow+0x55c/0x990 net/ipv6/ip6_output.c:1192
 udpv6_sendmsg+0x18a5/0x2bd0 net/ipv6/udp.c:1508
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2336
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2390
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2423
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e149
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f94614f1c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e149
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000005
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffd9413345f R14: 00007f94614f29c0 R15: 000000000119bf8c
Modules linked in:
---[ end trace a9799337710952e8 ]---
RIP: 0010:ip6_ignore_linkdown include/net/addrconf.h:407 [inline]
RIP: 0010:find_match.part.0+0xcc/0xc70 net/ipv6/route.c:753
Code: f9 0f b6 45 c0 84 c0 0f 84 39 04 00 00 e8 ec a0 c4 f9 49 8d bf 5c 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 91
RSP: 0018:ffffc900022cf000 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff88801c2cc2a0 RCX: ffffc90013d33000
RDX: 000000000000004b RSI: ffffffff87abfc74 RDI: 000000000000025c
RBP: ffffc900022cf070 R08: 0000000000000001 R09: ffffc900022cf250
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f94614f2700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000002d8c6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
