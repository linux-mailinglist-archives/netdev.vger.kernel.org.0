Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623D0225A2F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgGTIiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:38:22 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36535 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgGTIiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:38:21 -0400
Received: by mail-io1-f70.google.com with SMTP id g17so10816451iob.3
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/pOe/UkZvEbGdAr/dvElx60N9w3UN5J6FPFhS9jd4kw=;
        b=npp0QZqFQWwWgIudKlNWvikbgtWAr/I8PmGXNE6UGyo5cAam5NZSg7k4ZcrJ3kXd4Y
         Yd5QbmqrEG6mLLcukpTVQgEfipQcBTm55HqT+aymEFAvxescgXGGb7Kq5S9IkmI7eYff
         8isaC9XpccT5rRKMubKWb2N6wdWksAOWv3WnvvX8X/UFcvEPXVuF1zsu/ydz3yPqsI42
         PQGSBRDh7EbaBLvsq90li1tpaB7nCvICDlk+weMGCdz2JrhpZYPE+e3xefedy7euZEVI
         xg6LnZCzgB2YGxrjPyYPzmZy0/p9IYB1RpPofg05z1TkD51FQsSPUWsTH0QtE5IXCvOF
         pAFw==
X-Gm-Message-State: AOAM531w/90JbbZr5k3u2YO/mNlqlqII078sHopKZSb4TVeTnihV2pDx
        xuLIyfh3anb29dSCZTZ5DEebQcps5qwcGE+/BJd7PV3htere
X-Google-Smtp-Source: ABdhPJwnov5TdEhruF9H8/3cc9pPFy7sHqEeJyx5tApwl0rCBv55Mu9kWxW0CC1ay4unneBlIl+JTwxC+/vGYsVMxLrVry4yK6wL
MIME-Version: 1.0
X-Received: by 2002:a6b:4409:: with SMTP id r9mr21589476ioa.158.1595234300358;
 Mon, 20 Jul 2020 01:38:20 -0700 (PDT)
Date:   Mon, 20 Jul 2020 01:38:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce768d05aadb6da0@google.com>
Subject: KASAN: use-after-free Read in xfrm6_tunnel_alloc_spi
From:   syzbot <syzbot+12f1afb7271ae16d5d9e@syzkaller.appspotmail.com>
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

syzbot found the following issue on:

HEAD commit:    4c43049f Add linux-next specific files for 20200716
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15243307100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c76d72659687242
dashboard link: https://syzkaller.appspot.com/bug?extid=12f1afb7271ae16d5d9e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12f1afb7271ae16d5d9e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:124 [inline]
BUG: KASAN: use-after-free in xfrm6_tunnel_alloc_spi+0x779/0x8a0 net/ipv6/xfrm6_tunnel.c:174
Read of size 4 at addr ffff88808b7da400 by task syz-executor.4/8451
CPU: 0 PID: 8451 Comm: syz-executor.4 Not tainted 5.8.0-rc5-next-20200716-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:124 [inline]
 xfrm6_tunnel_alloc_spi+0x779/0x8a0 net/ipv6/xfrm6_tunnel.c:174
 ipcomp6_tunnel_create net/ipv6/ipcomp6.c:84 [inline]
 ipcomp6_tunnel_attach net/ipv6/ipcomp6.c:124 [inline]
 ipcomp6_init_state net/ipv6/ipcomp6.c:159 [inline]
 ipcomp6_init_state+0x2af/0x700 net/ipv6/ipcomp6.c:139
 __xfrm_init_state+0x9a6/0x14b0 net/xfrm/xfrm_state.c:2498
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2525
 pfkey_msg2xfrm_state net/key/af_key.c:1291 [inline]
 pfkey_add+0x1a10/0x2b70 net/key/af_key.c:1508
 pfkey_process+0x66d/0x7a0 net/key/af_key.c:2834
 pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3673
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x480 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1d9
Code: Bad RIP value.
RSP: 002b:00007f09fcf03c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000025a40 RCX: 000000000045c1d9
RDX: 0400000000000282 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 000000000078bf48 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007ffc814f8eff R14: 00007f09fcf049c0 R15: 000000000078bf0c
The buggy address belongs to the page:
page:00000000166c48c0 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x8b7da
flags: 0xfffe0000000000()
raw: 00fffe0000000000 ffffea00029cc808 ffffea00029b8b88 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffff7f 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88808b7da300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88808b7da380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88808b7da400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88808b7da480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88808b7da500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
