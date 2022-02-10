Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3EF4B09A4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbiBJJhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:37:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238259AbiBJJhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:37:23 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2583810B4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:37:25 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id b3-20020a056e020c8300b002be19f9e043so3561335ile.13
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 01:37:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WMAa1QK9Kxhsy8/kVs+uPN7XYVttZNgIOYjzv5RISB8=;
        b=pwuYwlymrS/4XuGtUmUfmXhni1PC1Z6sWlykPYkmrmBH6hpkAuRLCpmrFjSfnGYyx8
         wSMYUPi7rlrfj5P0KOQsSxvvHD4S8qsHyOxFY6p/raK2dHpN4hXPdlJUmlEmr70vJEeY
         rnXZuZcXfWmnHI3QEwJU7GG8FEKf9J9FYP5StZWoKXBZOAw3Fel5ZRO1OYzN+flZIIet
         20e/lZh6+lJTGgkCo0uSrMYiX3iXXPExlpIi9q6L920f+4BRWqAV4OBE68nD9nwFXBZi
         b/bsoMqMkRNVLB+NfbIIhlIbrsUQ7Swo7NtuOssf2qLVkA1zAQ9bNIZyAkyzVZGXxpu4
         2RfQ==
X-Gm-Message-State: AOAM532fpUfSHe1cLgdUXWN2gXwMXWEe6Mm2UKGKHkBD3w6AcFdqiDY2
        CckBjghyet0ZayCdSoY1JJJaGI+ymRalD+PSpy2GKjxLWQqN
X-Google-Smtp-Source: ABdhPJxlrs0tfruePAiedbMxqBIY+mk2PNpErSRsdCCar4qxDMSvU2QoKxJYzkZUwwESzwTp/eQucdtG2jk87AYhZKvF2bcIcwBV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a21:: with SMTP id g1mr1474902ile.154.1644485844491;
 Thu, 10 Feb 2022 01:37:24 -0800 (PST)
Date:   Thu, 10 Feb 2022 01:37:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009962dc05d7a6b27f@google.com>
Subject: [syzbot] WARNING in mroute_clean_tables
From:   syzbot <syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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

Hello,

syzbot found the following issue on:

HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1109f758700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=a7c030a05218db921de5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com

------------[ cut here ]------------
RTNL: assertion failed at net/core/dev.c (10367)
WARNING: CPU: 0 PID: 29585 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Modules linked in:
CPU: 0 PID: 29585 Comm: syz-executor.4 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Code: 0f 85 9b ee ff ff e8 59 f1 4a fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 0e a1 51 06 01 e8 3c 8a d8 01 <0f> 0b e9 70 ee ff ff e8 2e f1 4a fa 4c 89 e7 e8 c6 22 59 fa e9 ee
RSP: 0018:ffffc90003f976d8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815fa058 RDI: fffff520007f2ecd
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815f3dbe R11: 0000000000000000 R12: ffffc90003f97850
R13: dffffc0000000000 R14: ffffc90003f97748 R15: ffff888075174000
FS:  00007ff7a83c1700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f76931c2fc0 CR3: 000000006a1c3000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mroute_clean_tables+0x271/0xb50 net/ipv4/ipmr.c:1282
 ipmr_free_table net/ipv4/ipmr.c:411 [inline]
 ipmr_rules_init net/ipv4/ipmr.c:259 [inline]
 ipmr_net_init net/ipv4/ipmr.c:3059 [inline]
 ipmr_net_init+0x3f0/0x4e0 net/ipv4/ipmr.c:3051
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x54f/0xbb0 net/core/net_namespace.c:331
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:475
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2e15/0x7310 kernel/fork.c:2167
 kernel_clone+0xe7/0xab0 kernel/fork.c:2555
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2672
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff7a9a4c059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff7a83c1118 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007ff7a9b5ef60 RCX: 00007ff7a9a4c059
RDX: 0000000020000080 RSI: 0000000020000050 RDI: 0000000046000080
RBP: 00007ff7a9aa608d R08: 0000000020000100 R09: 0000000020000100
R10: 00000000200000c0 R11: 0000000000000202 R12: 0000000000000000
R13: 00007ffff1377c7f R14: 00007ff7a83c1300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
