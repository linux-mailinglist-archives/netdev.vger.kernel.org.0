Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D792714914C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 23:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgAXWrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 17:47:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:45834 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgAXWrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 17:47:10 -0500
Received: by mail-il1-f200.google.com with SMTP id w6so2676913ill.12
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 14:47:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GyfX6QdtSm5FDCLxpCdzonVwcZRhU9kbKHjsX9ZfODQ=;
        b=di9QZ8czCJVZxfd7/YdotCHXDYF4TlIYRn5V3GbgoJOb1NH8xJZGgupIZEU+vcrhVU
         sCCi4Is7gkDQbrFvwlPhqLlhhDlLMkc9jyA4X4I6C+ZUPgZ33oB7dYr2j3kqVrpDgCx6
         F/JHrHYstxPGQr9PT/Y4lm/jAv1PPIsO40lNk9X/ozpv2srNiKizLfKPL7SS+nWCDFWU
         6nU2Ufjs0cv5fDqkviaHZpdwbFp7xKBz66o50RmXgb7HTdqkPVv6DiK7r2cp7PBpw9eS
         +mKvGYY3Y0fhp8eYh55/yOYh9B8FSKQ3jQseyyGF5T6fnPcT/GFUV5bm8XoMF4ctii22
         w9Cw==
X-Gm-Message-State: APjAAAU+sryGRQYXaMU1T5TC6o0PaHc7CaQ/r4Q+OQMVqJ4d3qfoFEO+
        izHQl55yVs2bwrVGJF0CiMhONB/HK8iYt7azk6wCknxh9yMF
X-Google-Smtp-Source: APXvYqxuCViQajD/HxO7K5v1pP/+idG4DMJdLcZ+snnQQMEvOxuWCxNbQXMbtCwk1rd0WPXZ3bpjHd5tV6z2AasvbMyug+d5qxgm
MIME-Version: 1.0
X-Received: by 2002:a92:8458:: with SMTP id l85mr5344761ild.296.1579906029661;
 Fri, 24 Jan 2020 14:47:09 -0800 (PST)
Date:   Fri, 24 Jan 2020 14:47:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad33b8059cea8966@google.com>
Subject: memory leak in em_nbyte_change
From:   syzbot <syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4703d911 Merge tag 'xarray-5.5' of git://git.infradead.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1031e335e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=15478c61c836a72e
dashboard link: https://syzkaller.appspot.com/bug?extid=03c4738ed29d5d366ddf
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1277ce01e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16681611e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888121850a40 (size 32):
  comm "syz-executor927", pid 7193, jiffies 4294941655 (age 19.840s)
  hex dump (first 32 bytes):
    00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
    [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
    [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
    [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
    [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
    [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
    [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
    [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
    [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
    [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
    [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
    [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
    [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

BUG: memory leak
unreferenced object 0xffff888115438ea0 (size 32):
  comm "syz-executor927", pid 7194, jiffies 4294942248 (age 13.910s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
    [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
    [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
    [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
    [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
    [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
    [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
    [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
    [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
    [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
    [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
    [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
    [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

BUG: memory leak
unreferenced object 0xffff88811c962180 (size 32):
  comm "syz-executor927", pid 7195, jiffies 4294942844 (age 7.950s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
    [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
    [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
    [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
    [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
    [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
    [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
    [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
    [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
    [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
    [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
    [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
    [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
