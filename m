Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE323E4244
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhHIJPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:15:42 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39524 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbhHIJPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:15:42 -0400
Received: by mail-io1-f69.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so12174146iot.6
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:15:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RjkbFNrrVBART2aGoDoxvr5ihDxXKR2cIK4wiVkoauE=;
        b=S05o3+ciyJTCz83DbV6faFXFxLcpGGMJrHZpRfUnSykZIYto7ZcvPkFCeQKEm4ocwC
         ABiHyOcmfN9vJMp9tHUYm6CZMurvesZqwn4NILWFP7FqgBWocyv6cYgI4vGEJ6PCQdl0
         KrZYigs2IX2fqK3ZUpQq8oQjhQq+vhtiQxmAh2DWYO9vqwthYY3SRWdgu2FtgbdF4r6j
         DCThDi+bhMiWaehfho/g3NFOco543wy5W1EdYmGpmsR/QItBky492ZE/y3P2pSu2aze/
         1SUJXXdM9yBtAdJzu3Pl/9XbMqm7VFvp28CrQsyzx1ZHkQWIqw/ByaeVUAf4Nz9Ck6JX
         gZ4w==
X-Gm-Message-State: AOAM532Puiff7h2684orzTkGgwGdynY530xwEBSiwQkj0MzoQCh4Ns/m
        ErMpnCILUlA4o/97uaT3hUzE0QPU4r3WXVS3CB5AWLS8WTG6
X-Google-Smtp-Source: ABdhPJyhAhQbaDSGHnfWtJhkg916LXcEM+T7wTnMtq5aw8SlzQ2G6skTzgyz2eI2TWbdeF+V67C/Yza5Hel+KbbJl19TRcmCeu35
MIME-Version: 1.0
X-Received: by 2002:a02:2243:: with SMTP id o64mr21981569jao.40.1628500521742;
 Mon, 09 Aug 2021 02:15:21 -0700 (PDT)
Date:   Mon, 09 Aug 2021 02:15:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d797a05c91cd391@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in ipcomp_free_scratches
From:   syzbot <syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1159e25c1374 qede: fix crash in rmmod qede while automatic..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10870601300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bfd78f4abd4edaa6
dashboard link: https://syzkaller.appspot.com/bug?extid=b9cfd1cc5d57ee0a09ab
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com

netlink: 'syz-executor.1': attribute type 5 has an invalid length.
BUG: unable to handle page fault for address: ffffe8fffe8ff008
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 1083f067 P4D 1083f067 PUD 18f72067 PMD 61e2b067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 7380 Comm: syz-executor.1 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ipcomp_free_scratches+0xbc/0x160 net/xfrm/xfrm_ipcomp.c:203
Code: fa 48 c1 ea 03 80 3c 1a 00 0f 85 99 00 00 00 4a 8b 04 fd 80 48 31 8b 4c 01 f0 48 89 c2 49 89 c7 48 c1 ea 03 80 3c 1a 00 75 74 <49> 8b 3f e8 5c 1c e5 f9 e8 f7 c0 a9 f9 89 ef 48 c7 c6 58 70 6c 8d
RSP: 0018:ffffc900024c7530 EFLAGS: 00010246
RAX: ffffe8fffe8ff008 RBX: dffffc0000000000 RCX: ffffc9000bbf5000
RDX: 1ffffd1fffd1fe01 RSI: ffffffff87cbda1b RDI: ffffffff8b314880
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87cbda98 R11: 0000000000000001 R12: 0000000000000007
R13: fffffbfff1ad8e44 R14: 0000607f44cff008 R15: ffffe8fffe8ff008
FS:  00007fa69c568700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffe8fffe8ff008 CR3: 000000006ffee000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ipcomp_free_data net/xfrm/xfrm_ipcomp.c:312 [inline]
 ipcomp_init_state+0x77c/0xa40 net/xfrm/xfrm_ipcomp.c:364
 ipcomp6_init_state+0xc2/0x700 net/ipv6/ipcomp6.c:154
 __xfrm_init_state+0x995/0x15c0 net/xfrm/xfrm_state.c:2648
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2675
 pfkey_msg2xfrm_state net/key/af_key.c:1287 [inline]
 pfkey_add+0x1a64/0x2cd0 net/key/af_key.c:1504
 pfkey_process+0x685/0x7e0 net/key/af_key.c:2837
 pfkey_sendmsg+0x43a/0x820 net/key/af_key.c:3676
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x331/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmmsg+0x195/0x470 net/socket.c:2532
 __do_sys_sendmmsg net/socket.c:2561 [inline]
 __se_sys_sendmmsg net/socket.c:2558 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2558
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa69c568188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665e9
RDX: 0000000000000393 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007fffa498908f R14: 00007fa69c568300 R15: 0000000000022000
Modules linked in:
CR2: ffffe8fffe8ff008
---[ end trace 9d9c0a7eca692b29 ]---
RIP: 0010:ipcomp_free_scratches+0xbc/0x160 net/xfrm/xfrm_ipcomp.c:203
Code: fa 48 c1 ea 03 80 3c 1a 00 0f 85 99 00 00 00 4a 8b 04 fd 80 48 31 8b 4c 01 f0 48 89 c2 49 89 c7 48 c1 ea 03 80 3c 1a 00 75 74 <49> 8b 3f e8 5c 1c e5 f9 e8 f7 c0 a9 f9 89 ef 48 c7 c6 58 70 6c 8d
RSP: 0018:ffffc900024c7530 EFLAGS: 00010246
RAX: ffffe8fffe8ff008 RBX: dffffc0000000000 RCX: ffffc9000bbf5000
RDX: 1ffffd1fffd1fe01 RSI: ffffffff87cbda1b RDI: ffffffff8b314880
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87cbda98 R11: 0000000000000001 R12: 0000000000000007
R13: fffffbfff1ad8e44 R14: 0000607f44cff008 R15: ffffe8fffe8ff008
FS:  00007fa69c568700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffe8fffe8ff008 CR3: 000000006ffee000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
