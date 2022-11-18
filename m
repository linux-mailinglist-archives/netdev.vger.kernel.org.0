Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19A62F2B8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbiKRKif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiKRKie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:38:34 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F80BA181
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:38:32 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id j7-20020a056e02154700b003025b3c0ea3so3106830ilu.10
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B7rT5D+HD/NGgTOqEGVfQWh3AC4EcDUMZJA/cRRvNis=;
        b=IzQI5WfCZuTTxD/zXSn4ddco/+LrBFF9da7Sc0+m3254jWhm4HuCq7vYZmwtpZw/5y
         1ZpxZnHphLuwOJ0uaQSG+d4letqLeJpnLTKiZr7nModYUatlxyJmMqHENPwL0eQ+FEig
         7jkiCcRbXiaPm9L/BZoRHztBlRiznvIGC6pkFKyF7X3nCzfFfNrEt7N7CstrVPXzUUOu
         +8wIosVPWXvyr6/EjqQMTNPgzhwHFAqmC622Ld8Wsj0X1ZLx/JTt06aCvvKjIwd9MvD3
         CHocVX4Z/oC8ikWvSolktwj6Qc72bLhW8WaTkKoIQt22qPMpuuBPTFRIADYI07R4E+VA
         +PvA==
X-Gm-Message-State: ANoB5plQ72/n4omXF3HsbdaL91cITpMPV/WTPmWR1nh1zrrcAPbzQPu1
        fSuBNvKPSfgzDAIyzx9XFpr1DLc4hs1P0nJe6RCvptqbJ7BN
X-Google-Smtp-Source: AA0mqf4JOEguQPyJ2ydkLVLZWq5JhAmNtCDXzMr1MqSY2DNseMpscjjgZ9VATzrrKEMlVDX8MmozUo0fZ2FhavA2UaD2jQa7hX2W
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4419:b0:375:2b75:93d with SMTP id
 bp25-20020a056638441900b003752b75093dmr2797008jab.235.1668767911809; Fri, 18
 Nov 2022 02:38:31 -0800 (PST)
Date:   Fri, 18 Nov 2022 02:38:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098976a05edbc4ebc@google.com>
Subject: [syzbot] BUG: corrupted list in __netif_napi_del (3)
From:   syzbot <syzbot+f39fd41c33711aecf0c1@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    68d268d08931 Merge branch 'net-try_cmpxchg-conversions'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14299759880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=893a728fb1a6b263
dashboard link: https://syzkaller.appspot.com/bug?extid=f39fd41c33711aecf0c1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/399b143cdec5/disk-68d268d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf1a3fd0fc27/vmlinux-68d268d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5649c9fe4b21/bzImage-68d268d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f39fd41c33711aecf0c1@syzkaller.appspotmail.com

list_del corruption, ffff88804eace160->prev is LIST_POISON2 (dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:56!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 4247 Comm: syz-executor.4 Not tainted 6.1.0-rc4-syzkaller-01115-g68d268d08931 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__list_del_entry_valid.cold+0x37/0x72 lib/list_debug.c:56
Code: e8 d2 62 f0 ff 0f 0b 48 89 ee 48 c7 c7 80 10 a8 8a e8 c1 62 f0 ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 40 11 a8 8a e8 ad 62 f0 ff <0f> 0b 48 89 ee 48 c7 c7 20 10 a8 8a e8 9c 62 f0 ff 0f 0b 4c 89 ea
RSP: 0018:ffffc9000a116ed0 EFLAGS: 00010282
RAX: 000000000000004e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8165772c RDI: fffff52001422dcc
RBP: ffff88804eace160 R08: 000000000000004e R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: dead000000000122
R13: ffff88804eab6050 R14: ffff88804eace000 R15: ffff88804eace000
FS:  00007fa8ab74e700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002040f030 CR3: 000000007efb8000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry include/linux/list.h:134 [inline]
 list_del_rcu include/linux/rculist.h:157 [inline]
 __netif_napi_del.part.0+0x118/0x530 net/core/dev.c:6458
 __netif_napi_del+0x40/0x50 net/core/dev.c:6454
 veth_napi_del_range+0xcd/0x560 drivers/net/veth.c:1041
 veth_napi_del drivers/net/veth.c:1055 [inline]
 veth_close+0x164/0x500 drivers/net/veth.c:1385
 __dev_close_many+0x1b6/0x2e0 net/core/dev.c:1501
 __dev_close net/core/dev.c:1513 [inline]
 __dev_change_flags+0x2ce/0x750 net/core/dev.c:8528
 dev_change_flags+0x97/0x170 net/core/dev.c:8602
 do_setlink+0x9f1/0x3bb0 net/core/rtnetlink.c:2827
 rtnl_group_changelink net/core/rtnetlink.c:3344 [inline]
 __rtnl_newlink+0xb90/0x1840 net/core/rtnetlink.c:3600
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
 rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa8aaa8b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa8ab74e168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa8aababf80 RCX: 00007fa8aaa8b639
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007fa8aaae6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe720d839f R14: 00007fa8ab74e300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid.cold+0x37/0x72 lib/list_debug.c:56
Code: e8 d2 62 f0 ff 0f 0b 48 89 ee 48 c7 c7 80 10 a8 8a e8 c1 62 f0 ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 40 11 a8 8a e8 ad 62 f0 ff <0f> 0b 48 89 ee 48 c7 c7 20 10 a8 8a e8 9c 62 f0 ff 0f 0b 4c 89 ea
RSP: 0018:ffffc9000a116ed0 EFLAGS: 00010282
RAX: 000000000000004e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8165772c RDI: fffff52001422dcc
RBP: ffff88804eace160 R08: 000000000000004e R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: dead000000000122
R13: ffff88804eab6050 R14: ffff88804eace000 R15: ffff88804eace000
FS:  00007fa8ab74e700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020513030 CR3: 000000007efb8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
