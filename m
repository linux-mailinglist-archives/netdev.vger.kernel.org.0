Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66DD240A39
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgHJPj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:39:29 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:38176 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgHJPj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:39:26 -0400
Received: by mail-io1-f70.google.com with SMTP id e73so1465763iof.5
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 08:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gHZ8chDzSmVfqCZYobXifUF8tI0k1CLJAjBpo1Aob1g=;
        b=dpGLuhPxz7p7LH6iaEwudCHUYshmvbGeffw9Tl5cOjQGBiZzxh5wKY9OvO41wwK8BS
         0Ea0smMJrlLpkUya33FbJv1XLiqoL2RWTNAU8x/dxF4dndQKur8la2y7DH0T7psqwhwk
         azOwwVo+9yS7E4jW8Lq1+6hXI+uWaGVlO2pqhU7kIVbks030Cej27V3Hnyu64GQqY/DQ
         5LZaj/KukksrWdbmtpXMnpZ1erX4HDMZkZ404ge3IDYBFc9+x3np+3YaCCE4M/AULnYr
         WgxG1CffjPpMJEqG+UTkbgPkXnuyPoeHf8MBNJEkdqVYdUVpqCilSY+z+kAfIY/GB5mI
         q26Q==
X-Gm-Message-State: AOAM530KHmvYZLKeErjGUlETvpQFWIMJ9l4QHpk5RfyS5lCxOoW6AaEH
        ++epM/IiBpLAcOhD+NfT8Yq3fAfvL6qsrdbEXh9J8mBMCM+B
X-Google-Smtp-Source: ABdhPJys4BhvEg9Pbf2v4lOJ3eCwpwGbLc0aKfQhZxcrGrwl/gD3kT13oQlbawtD9TmpjBKwXLUKCblWWRKiO2aqYenWG0LpEIgj
MIME-Version: 1.0
X-Received: by 2002:a92:c8c1:: with SMTP id c1mr18477676ilq.42.1597073965948;
 Mon, 10 Aug 2020 08:39:25 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:39:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ba6be05ac87c2ff@google.com>
Subject: KASAN: global-out-of-bounds Read in fl_dump_key
From:   syzbot <syzbot+fb2e9e2cc0c13aa477f3@syzkaller.appspotmail.com>
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

syzbot found the following issue on:

HEAD commit:    7c7ab580 net: Convert to use the fallthrough macro
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17dab184900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7bb894f55faf8242
dashboard link: https://syzkaller.appspot.com/bug?extid=fb2e9e2cc0c13aa477f3
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fb2e9e2cc0c13aa477f3@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: global-out-of-bounds in fl_dump_key+0x209e/0x22f0 net/sched/cls_flower.c:2781
Read of size 4 at addr ffffffff88deedf4 by task syz-executor.3/14802

CPU: 1 PID: 14802 Comm: syz-executor.3 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0x5/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 fl_dump_key+0x209e/0x22f0 net/sched/cls_flower.c:2781
 fl_tmplt_dump+0xc9/0x250 net/sched/cls_flower.c:3098
 tc_chain_fill_node+0x48d/0x7c0 net/sched/cls_api.c:2681
 tc_chain_notify+0x187/0x2e0 net/sched/cls_api.c:2707
 tc_ctl_chain+0xb30/0x1000 net/sched/cls_api.c:2893
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2357
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2411
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2444
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ce69
Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fce49ce7c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002c100 RCX: 000000000045ce69
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 000000000118c1e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118c1ac
R13: 00007ffc941c811f R14: 00007fce49ce89c0 R15: 000000000118c1ac

The buggy address belongs to the variable:
 cooling_device_attr_group+0x354/0x680

Memory state around the buggy address:
 ffffffff88deec80: 00 00 03 fa fa fa fa fa 07 fa fa fa fa fa fa fa
 ffffffff88deed00: 05 fa fa fa fa fa fa fa 07 fa fa fa fa fa fa fa
>ffffffff88deed80: 06 fa fa fa fa fa fa fa 00 00 fa fa fa fa fa fa
                                                             ^
 ffffffff88deee00: 04 fa fa fa fa fa fa fa 04 fa fa fa fa fa fa fa
 ffffffff88deee80: 05 fa fa fa fa fa fa fa 05 fa fa fa fa fa fa fa
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
