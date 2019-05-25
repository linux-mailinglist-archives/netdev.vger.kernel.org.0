Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D85B2A5D4
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 19:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfEYRiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 13:38:06 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:57612 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEYRiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 13:38:06 -0400
Received: by mail-it1-f200.google.com with SMTP id p23so11828673itc.7
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 10:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=C1QpvOqRQF2vRExtqnpzqBeyxJrBH7Be9SR2G/geGRo=;
        b=GQz9O7l2UgONKtcatVqjewiw+B+lH9TKYhr154TuVdngPnkG7/rQaAoVKrZrou46V+
         BnN53ZCbd1nxYweJVQx2mQ1QF6aVagNVg7+0d3Wc/pvnnCjnQGLhWSK4uIOwiqaxBKuw
         H7wf7McwdzDgEo+KiaqiK+pAtVLfbhxoazBbbFQZDd/BIFPZNjm+BricFYzdPCCmxz1T
         hXlxePmZ8cKFYV02UB9jxJFkpqGG5l2b+8CNjRlow/8dtijXTzQzQeFeXiUE72Akwq5X
         /ABuh6PiSfOdtQLwdrhBQHQ4Tg71TuIjHPXd5aJnIUAzgV3zUU9S1RRgQpbdgKBZojEZ
         gCMg==
X-Gm-Message-State: APjAAAWJTB4ENNsFJBdRro/FikOCBFTOBPMScp8WX5nuAlNl98Zjj5A/
        JTJGkjNgpsNEKcpyOoNq7Du/Lp3x7f/148V6/O5hqE1yZtUb
X-Google-Smtp-Source: APXvYqwCJ6U/tfPvT9K8pyvAxiPB4BF1A6afdUmApSOMSTBTtvia1yPma71VW5KxJPLlU+oC2PfBv3gQwxhAo5PbDK5eeS/VbGhe
MIME-Version: 1.0
X-Received: by 2002:a24:cdc6:: with SMTP id l189mr13278586itg.177.1558805885300;
 Sat, 25 May 2019 10:38:05 -0700 (PDT)
Date:   Sat, 25 May 2019 10:38:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000113abb0589b9c77c@google.com>
Subject: memory leak in pfkey_xfrm_policy2msg_prep
From:   syzbot <syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4dde821e Merge tag 'xfs-5.2-fixes-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176fcb8aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=4f0529365f7f2208d9f0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179bd84ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124004a2a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com

ed '10.128.1.31' (ECDSA) to the list of known hosts.
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888126306200 (size 224):
   comm "softirq", pid 0, jiffies 4294944009 (age 13.770s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000dbfa6a53>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000dbfa6a53>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000dbfa6a53>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000dbfa6a53>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000963741ad>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<000000006fea5c94>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000006fea5c94>] pfkey_xfrm_policy2msg_prep+0x2a/0x50  
net/key/af_key.c:2054
     [<0000000069777b1f>] dump_sp net/key/af_key.c:2692 [inline]
     [<0000000069777b1f>] dump_sp+0x64/0x110 net/key/af_key.c:2682
     [<000000006ac00402>] xfrm_policy_walk+0xd4/0x230  
net/xfrm/xfrm_policy.c:1841
     [<00000000f7271518>] pfkey_dump_sp+0x2a/0x30 net/key/af_key.c:2719
     [<00000000652376b8>] pfkey_do_dump+0x3b/0xe0 net/key/af_key.c:289
     [<000000006ac94254>] pfkey_spddump+0x81/0xb0 net/key/af_key.c:2746
     [<000000006bacb6ca>] pfkey_process+0x28a/0x2d0 net/key/af_key.c:2836
     [<0000000037320f8e>] pfkey_sendmsg+0x188/0x2e0 net/key/af_key.c:3675
     [<0000000026dba653>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<0000000026dba653>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000004931d76f>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2292
     [<00000000ca71443f>] __sys_sendmsg+0x80/0xf0 net/socket.c:2330
     [<000000005d43081c>] __do_sys_sendmsg net/socket.c:2339 [inline]
     [<000000005d43081c>] __se_sys_sendmsg net/socket.c:2337 [inline]
     [<000000005d43081c>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2337
     [<000000005fdf8054>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000000c8dd476>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
