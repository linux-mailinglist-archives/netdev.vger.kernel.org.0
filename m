Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B13199C9B
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbgCaRL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:11:26 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:43201 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731305AbgCaRLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:11:20 -0400
Received: by mail-io1-f69.google.com with SMTP id f4so12482136iov.10
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 10:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a8jWcyU4AaXCOGMPCx48sd6dQUcn7wUNlWEz5d+WVL4=;
        b=lpLtW3zn/gtZfVQU2+ieFckIx3o3IhuoDmuDsaq3Bw1Dm2VJa04yN69LdOtGe1YR9Y
         qtliGESbhvn6iLYbgdlXkWI4gw6bE4TopiVSvUpiJm4ntIVIu/roQtU5rVqNyXRPnqaB
         0+GWJLxVMKNuOvGp9DXM0Rr7X9pspkybLhPGFLGQW0sq8K9SplFWf2BQvYfztwMJKU9W
         txG4QQv454L+QecrfosROizXuDtyLoIhGUuBazZxky78utmay+i7K6W+Zypea7D8obsS
         r8EMKT8eQTYqJ527BLyLy9dJonF9CgfvEfePIpjJonYIcCJdAG78yG/4xwHofHtnXu29
         Ji1w==
X-Gm-Message-State: ANhLgQ3mTaxnt7R0iK/tRj4YoQnxsQaBcMbJVFcVL3q9nUW0R//Wz7I8
        WOlmNUEARwnRhDfC4y9QFCi+8UZ1BgVnXt88LNWi0G1e3IqP
X-Google-Smtp-Source: ADFU+vvabsKXyDqzAXhY3ZGG45UVtgo5uArV1RcSUMLoa46v+2v2Ra8TL+FPsQFL5tJ49B5imEZHU+9VbhLTQKn7+VukiPGppqrs
MIME-Version: 1.0
X-Received: by 2002:a05:6602:690:: with SMTP id m16mr15894324iox.81.1585674676141;
 Tue, 31 Mar 2020 10:11:16 -0700 (PDT)
Date:   Tue, 31 Mar 2020 10:11:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cd049f05a229a776@google.com>
Subject: WARNING in tcf_exts_destroy
From:   syzbot <syzbot+0973b62b47d85718a84b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15cd62ebe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=0973b62b47d85718a84b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ff65a3e00000

The bug was bisected to:

commit 599be01ee567b61f4471ee8078870847d0a11e8e
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 05:14:35 2020 +0000

    net_sched: fix an OOB access in cls_tcindex

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14558983e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16558983e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12558983e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0973b62b47d85718a84b@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")

------------[ cut here ]------------
virt_to_cache: Object is not a Slab page!
WARNING: CPU: 1 PID: 9596 at mm/slab.h:475 virt_to_cache mm/slab.h:475 [inline]
WARNING: CPU: 1 PID: 9596 at mm/slab.h:475 kfree+0x1cf/0x2b0 mm/slab.c:3749
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9596 Comm: syz-executor.0 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:virt_to_cache mm/slab.h:475 [inline]
RIP: 0010:kfree+0x1cf/0x2b0 mm/slab.c:3749
Code: 50 ff e9 67 fe ff ff 80 3d 59 0d d2 08 00 75 1c 48 c7 c6 00 63 35 88 48 c7 c7 f8 49 47 89 c6 05 42 0d d2 08 01 e8 79 f5 94 ff <0f> 0b f6 c7 02 75 6b 48 83 3d aa 5c e4 07 00 0f 85 4e ff ff ff 0f
RSP: 0018:ffffc90002297040 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000286 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c4e91 RDI: fffff52000452dfa
RBP: ffffffff8c6187e0 R08: ffff88808f282040 R09: ffffed1015ce45c9
R10: ffffed1015ce45c8 R11: ffff8880ae722e43 R12: ffffffff862da922
R13: dffffc0000000000 R14: ffff88809f212910 R15: 0000000000000000
 tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
 tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
 tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5431
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c849
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f176bb01c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f176bb026d4 RCX: 000000000045c849
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009fd R14: 00000000004ccb4d R15: 000000000076bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
