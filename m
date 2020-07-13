Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342EF21E2CD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGMWE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:04:29 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:47911 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgGMWES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:04:18 -0400
Received: by mail-il1-f200.google.com with SMTP id o2so10566952ilg.14
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 15:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VYaQhK1OFicJIaHCcryGtlpC5pWiSqEfCjBdVZPlxUE=;
        b=SXkGngfXjhSpXWlU4N8RHHMFT6FAb0NjXifDbiNs6xvlZJQNfad9qsZnldoyYNpL77
         E54FKhcEPqRhz3DJK754GnDe/5aUzE4ebrRm7JggG4VvE0PIz5ag7W8QB1R3hqwef8Xq
         2FsEL4EU0heYzd3Mb0v34sF6crSa0G5Xk76AU/7lJTFbTiJvXrBhJzzqUPdde2emqpQ2
         0DYSDPtX0jOAJMYOavY139D7V8rrLnpXGVIz/zwJLPe9CJVBUxNiusl5gBpyvI8qXayw
         wwL/buBVNYTx2szHbVMrgvK2m3VKKqvCSoLXGS0AyRqci1YeNJt+wJB62XDAwet3Wyaw
         koCA==
X-Gm-Message-State: AOAM5311fopgBGEF4Qtnq9Tw1cDeVFcGcBTcG8rZC3CsUJsWQev0KrTF
        bB7rLDb86vpoDJKTxqJTZ+876FkGzigdf2Rqgv0674HnMNZV
X-Google-Smtp-Source: ABdhPJxJFAZDCVUZad9+x2ZMmZk4ywzT3ColQhP/sirBtj7OSntgsxOzALdOnTzjbm03aeNfL336nCDFPMArKlwIe0oDgwcgwb7S
MIME-Version: 1.0
X-Received: by 2002:a05:6638:14b:: with SMTP id y11mr2497565jao.49.1594677857039;
 Mon, 13 Jul 2020 15:04:17 -0700 (PDT)
Date:   Mon, 13 Jul 2020 15:04:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000333b4e05aa59df5e@google.com>
Subject: general protection fault in __xfrm6_tunnel_spi_lookup
From:   syzbot <syzbot+27016009dfe6ab82bff1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    be978f8f Add linux-next specific files for 20200713
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=156005af100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3fe4fccb94cbc1a6
dashboard link: https://syzkaller.appspot.com/bug?extid=27016009dfe6ab82bff1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150269c0900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164e1d77100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+27016009dfe6ab82bff1@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000104: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000820-0x0000000000000827]
CPU: 0 PID: 6792 Comm: syz-executor232 Not tainted 5.8.0-rc4-next-20200713-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ipv6_addr_equal include/net/ipv6.h:579 [inline]
RIP: 0010:xfrm6_addr_equal include/net/xfrm.h:1699 [inline]
RIP: 0010:__xfrm6_tunnel_spi_lookup+0x22b/0x3b0 net/ipv6/xfrm6_tunnel.c:82
Code: 89 e0 48 c1 e8 03 80 3c 28 00 0f 85 5b 01 00 00 4d 8b 24 24 4d 85 e4 74 53 e8 31 fa 7b fa 49 8d 7c 24 20 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 2d 01 00 00 4d 8b 7c 24 20 49 8d 7c 24 28 48 89
RSP: 0018:ffffc90001277580 EFLAGS: 00010202
RAX: 0000000000000104 RBX: ffffffffffffffff RCX: ffffffff86f83788
RDX: ffff8880947443c0 RSI: ffffffff86f8373f RDI: 0000000000000820
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff888094744c90
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000800
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000162d880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000098519000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xfrm6_tunnel_spi_lookup+0x8a/0x1d0 net/ipv6/xfrm6_tunnel.c:95
 ipcomp6_tunnel_attach net/ipv6/ipcomp6.c:119 [inline]
 ipcomp6_init_state net/ipv6/ipcomp6.c:159 [inline]
 ipcomp6_init_state+0x1de/0x700 net/ipv6/ipcomp6.c:139
 __xfrm_init_state+0x9a6/0x14b0 net/xfrm/xfrm_state.c:2498
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2525
 pfkey_msg2xfrm_state net/key/af_key.c:1291 [inline]
 pfkey_add+0x1a10/0x2b70 net/key/af_key.c:1508
 pfkey_process+0x66d/0x7a0 net/key/af_key.c:2834
 pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3673
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2363
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2417
 __sys_sendmmsg+0x195/0x480 net/socket.c:2507
 __do_sys_sendmmsg net/socket.c:2536 [inline]
 __se_sys_sendmmsg net/socket.c:2533 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2533
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4403d9
Code: Bad RIP value.
RSP: 002b:00007ffeb96d2058 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403d9
RDX: 0000000000000393 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401be0
R13: 0000000000401c70 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 224ae9c97b2f647b ]---
RIP: 0010:ipv6_addr_equal include/net/ipv6.h:579 [inline]
RIP: 0010:xfrm6_addr_equal include/net/xfrm.h:1699 [inline]
RIP: 0010:__xfrm6_tunnel_spi_lookup+0x22b/0x3b0 net/ipv6/xfrm6_tunnel.c:82
Code: 89 e0 48 c1 e8 03 80 3c 28 00 0f 85 5b 01 00 00 4d 8b 24 24 4d 85 e4 74 53 e8 31 fa 7b fa 49 8d 7c 24 20 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 2d 01 00 00 4d 8b 7c 24 20 49 8d 7c 24 28 48 89
RSP: 0018:ffffc90001277580 EFLAGS: 00010202
RAX: 0000000000000104 RBX: ffffffffffffffff RCX: ffffffff86f83788
RDX: ffff8880947443c0 RSI: ffffffff86f8373f RDI: 0000000000000820
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff888094744c90
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000800
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000162d880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000180 CR3: 0000000098519000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
