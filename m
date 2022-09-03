Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E885ABEB1
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 13:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiICLPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 07:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiICLPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 07:15:32 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5246DFAC
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:15:29 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id i14-20020a5d934e000000b006892db5bcd4so2782083ioo.22
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 04:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yy+lwjd7AR62brDcwzrE9i7LclpeqCg0V3x3Lzyxlg4=;
        b=hGe8WBAFEWGbgKij4eSY2iFIiIzOGehdBfA/bI2LGY2S36dx/mCFKVe0FzpEs52O+K
         11BJb7VBc2gYaA9U6YGAiUrpcJOy1upiO8LlFDI6cBRbhxczll6Kjs5sz4B+coD8yoXL
         4HBqZDV+OTek1eaIh+pmCc7PLmC+wdVjGOrCENozPYrXJHaGg5+ECpbiqct8DARuQ1zn
         tvMBa7n4MnigwQbsVDlyqi+WlE5AtlLDCkM5M3v1TQXC38bp/WVrZC5lwDnnA4/NWULS
         tuctR2uPF1nMrPpaJePLjZJf65mpGNRZw5IvD8DS0icYDIrWEIb5/KY3AfeECzutWR0I
         b84A==
X-Gm-Message-State: ACgBeo1tV0eFafBtdsV0czZhvUcgKOL9L5pCm2jsBBrqsrwjbTmPpLYb
        41Lj1Em3LNwHdO6+0cWwsrwDq8fvAuXX8LlS7fpfoTcQAYyf
X-Google-Smtp-Source: AA6agR7sFjl20OjcwPk9Bv2JsbbjeglcTpIDgL4huWUXUZlEgBogeU6pNedM2ni8my5SongrvJssOQ7ApTyovaeTRlBdu8ASpA01
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4a:b0:2f0:c6ca:110a with SMTP id
 f10-20020a056e020b4a00b002f0c6ca110amr2049354ilu.252.1662203728478; Sat, 03
 Sep 2022 04:15:28 -0700 (PDT)
Date:   Sat, 03 Sep 2022 04:15:28 -0700
In-Reply-To: <0000000000006efbd905e61a66f1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7cad805e7c3f663@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in __rxe_do_task
From:   syzbot <syzbot+ab99dc4c6e961eed8b8e@syzkaller.appspotmail.com>
To:     fgheet255t@gmail.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        lizhijian@fujitsu.com, netdev@vger.kernel.org,
        rpearsonhpe@gmail.com, syzkaller-bugs@googlegroups.com,
        yanjun.zhu@linux.dev, zyjzyj2000@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    05a5474efe93 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14e4bddb080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=892a57667b7af6cf
dashboard link: https://syzkaller.appspot.com/bug?extid=ab99dc4c6e961eed8b8e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17718427080000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cdeb0ae7599a/disk-05a5474e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d59d928441e6/vmlinux-05a5474e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab99dc4c6e961eed8b8e@syzkaller.appspotmail.com

infiniband syz0: set active
infiniband syz0: added ip6gre0
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 1d64c067 P4D 1d64c067 PUD 22925067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3780 Comm: syz-executor.1 Not tainted 6.0.0-rc3-syzkaller-00123-g05a5474efe93 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000413eb40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880776e25c8 RCX: 0000000000000000
RDX: ffff88807932bb00 RSI: ffffffff86d530bb RDI: 0000000000000000
RBP: ffffed100eedc4c8 R08: 0000000000000001 R09: ffff8880776e269f
R10: ffffed100eedc4d3 R11: 0000000000000000 R12: 0000000000000000
R13: ffffed100eedc4c9 R14: ffff8880776e2640 R15: ffff8880776e2648
FS:  00007f1d65587700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000001bd9d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __rxe_do_task+0x56/0xc0 drivers/infiniband/sw/rxe/rxe_task.c:18
 rxe_qp_do_cleanup+0x102/0x770 drivers/infiniband/sw/rxe/rxe_qp.c:800
 execute_in_process_context+0x37/0x150 kernel/workqueue.c:3359
 __rxe_cleanup+0x21a/0x400 drivers/infiniband/sw/rxe/rxe_pool.c:276
 rxe_create_qp+0x2be/0x340 drivers/infiniband/sw/rxe/rxe_verbs.c:441
 create_qp+0x5ac/0x960 drivers/infiniband/core/verbs.c:1233
 ib_create_qp_kernel+0x9d/0x310 drivers/infiniband/core/verbs.c:1344
 ib_create_qp include/rdma/ib_verbs.h:3732 [inline]
 create_mad_qp+0x177/0x2d0 drivers/infiniband/core/mad.c:2910
 ib_mad_port_open drivers/infiniband/core/mad.c:2991 [inline]
 ib_mad_init_device+0xd51/0x13f0 drivers/infiniband/core/mad.c:3082
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:721
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1332
 ib_register_device drivers/infiniband/core/device.c:1420 [inline]
 ib_register_device+0x83e/0xb20 drivers/infiniband/core/device.c:1366
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1138
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:521
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:195 [inline]
 rxe_newlink+0xa9/0xd0 drivers/infiniband/sw/rxe/rxe.c:176
 nldev_newlink+0x32e/0x5c0 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f1d64489279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1d65587168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1d6459bf80 RCX: 00007f1d64489279
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00007f1d644e32e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd40d1b80f R14: 00007f1d65587300 R15: 0000000000022000
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc9000413eb40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880776e25c8 RCX: 0000000000000000
RDX: ffff88807932bb00 RSI: ffffffff86d530bb RDI: 0000000000000000
RBP: ffffed100eedc4c8 R08: 0000000000000001 R09: ffff8880776e269f
R10: ffffed100eedc4d3 R11: 0000000000000000 R12: 0000000000000000
R13: ffffed100eedc4c9 R14: ffff8880776e2640 R15: ffff8880776e2648
FS:  00007f1d65587700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000001bd9d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

