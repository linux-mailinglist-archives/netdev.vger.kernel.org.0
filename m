Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3FB6F24E2
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 15:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjD2Nik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 09:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjD2Nij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 09:38:39 -0400
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAEC18E
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 06:38:36 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-32aff21222eso12060715ab.3
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 06:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682775515; x=1685367515;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+6oCk54X/Jaxknm1PIuX7KDVYLEjXhRmn2TTkqp/tYA=;
        b=a3AIVRm2pMNAdyD4pfRxiAd+ZvtqWFeDGk4IIwGFAmM2HDo9Vi/8FLQvR/M9acF5NI
         IF1g0g/JraKE2yxCFQMKIncnadRHecBaJgmz6j4L+rLcEHbyGCqC88Bmlwnlk4Uvllbm
         G5CSk32cC45t50cg0cs5g9YMsk5acltTPmB71lue1PbSlHTqxqVsKzqj7M8pNM6egTwT
         +SuqiwswO3nTlmXSgQvHOtSn79gYmRI51MQZ8ZxsJ1VYdUT4k61cjg0aodIvs+AwUVA3
         VVEFVBg5OYbiGitR2HO4j4FmtmVMbElO4EUYamrJDzbmen4KH/eeQFt7NOuvWYZ4sf0H
         rqIw==
X-Gm-Message-State: AC+VfDwsZ4jyfVzbiErz+Z0qzo1SYoN8qpM1GsKEgWemOZgfE9nysw3T
        2r6EJnyD/bQfIPNC7fwq7zPPvc7EsYy61h3ZhHdP6WsrUEuw
X-Google-Smtp-Source: ACHHUZ7I6COAqC3y7WUPHJOUGDC7AfqiyyZAJgcjDwvAGdJWRqmiR50GZfhyhMC7no28TI7JMO/ZAwGTB53wC57TbhNi5KKYUEta
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:107:b0:328:fb47:ede4 with SMTP id
 t7-20020a056e02010700b00328fb47ede4mr4742005ilm.3.1682775515399; Sat, 29 Apr
 2023 06:38:35 -0700 (PDT)
Date:   Sat, 29 Apr 2023 06:38:35 -0700
In-Reply-To: <000000000000e5ee7305f0f975e8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5100205fa79b4c9@google.com>
Subject: Re: [syzbot] [net?] WARNING in print_bfs_bug (2)
From:   syzbot <syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    042334a8d424 atlantic:hw_atl2:hw_atl2_utils_fw: Remove unn..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11869168280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7205cdba522fe4bc
dashboard link: https://syzkaller.appspot.com/bug?extid=630f83b42d801d922b8b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147328f8280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1665151c280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e9818e554a99/disk-042334a8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/de8daea0ee8b/vmlinux-042334a8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/71f9842dcf98/bzImage-042334a8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com

netlink: 4 bytes leftover after parsing attributes in process `syz-executor204'.
------------[ cut here ]------------
lockdep bfs error:-1
WARNING: CPU: 0 PID: 10222 at kernel/locking/lockdep.c:2077 print_bfs_bug+0x22/0x30 kernel/locking/lockdep.c:2077
Modules linked in:
CPU: 0 PID: 10222 Comm: syz-executor204 Not tainted 6.3.0-syzkaller-07921-g042334a8d424 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
RIP: 0010:print_bfs_bug+0x22/0x30 kernel/locking/lockdep.c:2077
Code: 84 00 00 00 00 00 66 90 55 89 fd 53 e8 c7 34 a9 02 89 c3 e8 60 fd ff ff 85 db 74 10 89 ee 48 c7 c7 20 68 4c 8a e8 3e bb e7 ff <0f> 0b 5b 5d c3 66 0f 1f 84 00 00 00 00 00 53 31 c9 31 d2 31 f6 48
RSP: 0018:ffffc9000e906ba0 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888021769dc0 RSI: ffffffff814bef47 RDI: 0000000000000001
RBP: 00000000ffffffff R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88802176a950
R13: 0000000000000037 R14: ffffc9000e906cc8 R15: 0000000000000000
FS:  0000555556212300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6c98af3140 CR3: 000000002236d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 check_irq_usage+0x56c/0x1a40 kernel/locking/lockdep.c:2845
 check_prev_add kernel/locking/lockdep.c:3112 [inline]
 check_prevs_add kernel/locking/lockdep.c:3227 [inline]
 validate_chain kernel/locking/lockdep.c:3842 [inline]
 __lock_acquire+0x2f39/0x5df0 kernel/locking/lockdep.c:5074
 lock_acquire kernel/locking/lockdep.c:5691 [inline]
 lock_acquire+0x1b1/0x520 kernel/locking/lockdep.c:5656
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 mm_cid_put kernel/sched/sched.h:3270 [inline]
 mm_cid_put kernel/sched/sched.h:3265 [inline]
 switch_mm_cid kernel/sched/sched.h:3298 [inline]
 prepare_task_switch kernel/sched/core.c:5117 [inline]
 context_switch kernel/sched/core.c:5258 [inline]
 __schedule+0x26a3/0x5770 kernel/sched/core.c:6625
 preempt_schedule_common+0x45/0xb0 kernel/sched/core.c:6794
 preempt_schedule_thunk+0x1a/0x20 arch/x86/entry/thunk_64.S:34
 __mutex_lock_common kernel/locking/mutex.c:728 [inline]
 __mutex_lock+0xfe5/0x1350 kernel/locking/mutex.c:747
 team_nl_team_get+0x10f/0x1c0 drivers/net/team/team.c:2320
 team_nl_cmd_options_set+0xa0/0xc80 drivers/net/team/team.c:2543
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2546
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6c98a82b29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd09390778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000eee12 RCX: 00007f6c98a82b29
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffd09390918
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd0939078c
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
