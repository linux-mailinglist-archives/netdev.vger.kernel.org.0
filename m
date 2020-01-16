Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B1913D3DD
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 06:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgAPFpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 00:45:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:52098 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgAPFpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 00:45:10 -0500
Received: by mail-il1-f200.google.com with SMTP id v13so15205251ili.18
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 21:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nUWpGQHDm6wJiD+qGbWs1eyfWOotGc7QheWrkXQpqSQ=;
        b=QN4ciuolKQU+e07nTSlHkYC5JXgINYzE2MfPIHgWCgblhXOSXsjTaAMr3ceS7KatgQ
         h2cX9NVlTAhMNoi4dGSv54Wvt/3+9MkXiShhgSI7I5HE7e5AcejDgY9SOfE2H68kv3Sz
         lwbLEQdBWx74E/gnYK82tg6117X97fUgHj7wSU4/XszlCxWGuVyncGLUkc6gslPgHAqb
         E4domTzZigMszhQ1nXbb+Trqv40FjQYt5mRYeiEUFomtX/+HEv8Vp/shLLRDkkbFUmSj
         TvcFRpN3Vy19424pUyhClG+7s5fSfYq6b+DWzsfmjFOw46ycmWisZtgrSsfW9TxVq2j0
         vjJw==
X-Gm-Message-State: APjAAAVDeJwmeoHFwdc5zFAqBO4dLdKgfuG0c7zguBAcc6qmIUlylsMo
        lJD+tLefUTYKUjgkMJW14zUb+g0+3jC74Ihf6K6UZ+W7w0yQ
X-Google-Smtp-Source: APXvYqznDF+aM84QyTizrFIO8KZi8H/MFev1nBzqXonXTHvbm2J4DzLdm1SGD2N9D+X+vxWOXkMpmQTCf0sxOzC8QpNV9zylYUar
MIME-Version: 1.0
X-Received: by 2002:a5e:8516:: with SMTP id i22mr25910766ioj.130.1579153509823;
 Wed, 15 Jan 2020 21:45:09 -0800 (PST)
Date:   Wed, 15 Jan 2020 21:45:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ffbba3059c3b5352@google.com>
Subject: memory leak in nf_tables_parse_netdev_hooks
From:   syzbot <syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e32659e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0eee3ce463efd
dashboard link: https://syzkaller.appspot.com/bug?extid=f9d4095107fc8749c69c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16fae421e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e41c76e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff8881292d4580 (size 96):
   comm "syz-executor052", pid 7129, jiffies 4294942632 (age 13.530s)
   hex dump (first 32 bytes):
     40 d2 15 1c 81 88 ff ff 40 d2 15 1c 81 88 ff ff  @.......@.......
     60 53 c3 82 ff ff ff ff 00 a0 2c 2a 81 88 ff ff  `S........,*....
   backtrace:
     [<0000000059912bf5>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000059912bf5>] slab_post_alloc_hook mm/slab.h:586 [inline]
     [<0000000059912bf5>] slab_alloc mm/slab.c:3320 [inline]
     [<0000000059912bf5>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3549
     [<00000000ab9f7d85>] kmalloc include/linux/slab.h:556 [inline]
     [<00000000ab9f7d85>] nft_netdev_hook_alloc+0x3f/0xd0  
net/netfilter/nf_tables_api.c:1624
     [<0000000074e6bb65>] nf_tables_parse_netdev_hooks+0xac/0x230  
net/netfilter/nf_tables_api.c:1673
     [<00000000cd387efd>] nf_tables_flowtable_parse_hook  
net/netfilter/nf_tables_api.c:5936 [inline]
     [<00000000cd387efd>] nf_tables_newflowtable+0x41e/0x930  
net/netfilter/nf_tables_api.c:6137
     [<00000000526e3994>] nfnetlink_rcv_batch+0x662/0x8c0  
net/netfilter/nfnetlink.c:433
     [<000000006c5402bf>] nfnetlink_rcv_skb_batch  
net/netfilter/nfnetlink.c:543 [inline]
     [<000000006c5402bf>] nfnetlink_rcv+0x189/0x1c0  
net/netfilter/nfnetlink.c:561
     [<00000000b752f9f7>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1302 [inline]
     [<00000000b752f9f7>] netlink_unicast+0x223/0x310  
net/netlink/af_netlink.c:1328
     [<00000000a0e23793>] netlink_sendmsg+0x2c0/0x570  
net/netlink/af_netlink.c:1917
     [<000000006e0aea94>] sock_sendmsg_nosec net/socket.c:639 [inline]
     [<000000006e0aea94>] sock_sendmsg+0x54/0x70 net/socket.c:659
     [<00000000a60c26dd>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
     [<00000000d412f616>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
     [<000000001179a6b0>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
     [<000000004a6699d1>] __do_sys_sendmsg net/socket.c:2426 [inline]
     [<000000004a6699d1>] __se_sys_sendmsg net/socket.c:2424 [inline]
     [<000000004a6699d1>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424
     [<00000000a05aa7d1>] do_syscall_64+0x73/0x220  
arch/x86/entry/common.c:294
     [<00000000bad17b52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
