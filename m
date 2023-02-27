Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101B46A4A07
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjB0Smy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjB0Smx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:42:53 -0500
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAAC26A6
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:42:52 -0800 (PST)
Received: by mail-il1-f205.google.com with SMTP id k2-20020a056e0205a200b0031703f4bcabso4385299ils.0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:42:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qzxtfmmZrqXjh+Bj23y/tmPD29T4/gAlA0rwqV7QgHE=;
        b=gGlz2edg5izLvlhhsO3lcePQqMBWbYz834GNz+qkG8yrAfEYCKKonkRDZ/kqZ9GKHP
         yJIaAQBqXXhA1yeIcAn4vufMyq/5Cw5kcuiXrpcSjy8iBkCSDbiD6Kr2nUy+aEPxOWkS
         mmgryd8KpcZvNKNHIF+7GZPY42xp7YCung0ejZuq22qJdCbm8nRhhiDrfloevA6/ZX+m
         vip6nmOG3t88RJ6OfLbt9FjSpQp6dTYEMrNgIDUhYfsnQ/u4CKgH+zrNBi62sorlaiVQ
         ovgxq7ZExYUT+YHetyA9kSptSYr//56sLz0TZ2yrlZO8UEtxUJ1YtVJDrIfeLN8wYDo3
         dfIQ==
X-Gm-Message-State: AO0yUKWfHkK0PyJ126V6S6NLg2bCkUxQEhR1mwGQdAeO2T+I7B+exnrP
        RS/fptaytJ+qvd0TR4myQ92viC09PY4HoEPF/t8L3DOG2sa4
X-Google-Smtp-Source: AK7set+RksJty87smpbv3BnzjFwdJIfUbN/G0jn4L/nzaz3XPLXdMAELIKph4iHNuEK6av1z9peIU+ACjo4CSl6dpmF7sCRJ4rjj
MIME-Version: 1.0
X-Received: by 2002:a02:2286:0:b0:3c5:d3e:9c82 with SMTP id
 o128-20020a022286000000b003c50d3e9c82mr26037jao.5.1677523371657; Mon, 27 Feb
 2023 10:42:51 -0800 (PST)
Date:   Mon, 27 Feb 2023 10:42:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab939e05f5b2d8cc@google.com>
Subject: [syzbot] [net?] KASAN: null-ptr-deref Read in __fl_put
From:   syzbot <syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
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

HEAD commit:    5b7c4cabbb65 Merge tag 'net-next-6.3' of git://git.kernel...
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10874f28c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c74c134cc415a89b
dashboard link: https://syzkaller.appspot.com/bug?extid=baabf3efa7c1e57d28b2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166c5e50c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1094ca50c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b3d83e162bd2/disk-5b7c4cab.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ad7e8c0fc7b5/vmlinux-5b7c4cab.xz
kernel image: https://storage.googleapis.com/syzbot-assets/060fac08a8fd/bzImage-5b7c4cab.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: null-ptr-deref in __refcount_add_not_zero include/linux/refcount.h:152 [inline]
BUG: KASAN: null-ptr-deref in __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
BUG: KASAN: null-ptr-deref in refcount_inc_not_zero include/linux/refcount.h:245 [inline]
BUG: KASAN: null-ptr-deref in maybe_get_net include/net/net_namespace.h:269 [inline]
BUG: KASAN: null-ptr-deref in tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
BUG: KASAN: null-ptr-deref in __fl_put net/sched/cls_flower.c:513 [inline]
BUG: KASAN: null-ptr-deref in __fl_put+0x13e/0x3b0 net/sched/cls_flower.c:508
Read of size 4 at addr 000000000000014c by task syz-executor548/5082

CPU: 0 PID: 5082 Comm: syz-executor548 Not tainted 6.2.0-syzkaller-05251-g5b7c4cabbb65 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_report mm/kasan/report.c:420 [inline]
 kasan_report+0xec/0x130 mm/kasan/report.c:517
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 __refcount_add_not_zero include/linux/refcount.h:152 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 maybe_get_net include/net/net_namespace.h:269 [inline]
 tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
 __fl_put net/sched/cls_flower.c:513 [inline]
 __fl_put+0x13e/0x3b0 net/sched/cls_flower.c:508
 fl_change+0x101b/0x4ab0 net/sched/cls_flower.c:2341
 tc_new_tfilter+0x97c/0x2290 net/sched/cls_api.c:2310
 rtnetlink_rcv_msg+0x996/0xd50 net/core/rtnetlink.c:6165
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:722 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:745
 ____sys_sendmsg+0x334/0x900 net/socket.c:2504
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2558
 __sys_sendmmsg+0x18f/0x460 net/socket.c:2644
 __do_sys_sendmmsg net/socket.c:2673 [inline]
 __se_sys_sendmmsg net/socket.c:2670 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2670
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f3613969d19
Code: 28 c3 e8 1a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc884e0c88 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f36139d7ed0 RCX: 00007f3613969d19
RDX: 04924924924926d3 RSI: 0000000020000200 RDI: 0000000000000004
RBP: 00007ffc884e0c98 R08: 00007f36139d7e40 R09: 00007f36139d7e40
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc884e0ca0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
