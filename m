Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDC8382AFA
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhEQL2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:28:37 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56215 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbhEQL2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:28:36 -0400
Received: by mail-io1-f71.google.com with SMTP id p2-20020a5d98420000b029043b3600ac76so204279ios.22
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:27:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=phWGX5D48i6duaIRhXo6DP/xmvEEcuuIMR6IgKKz4xc=;
        b=Mr7g+GHF7XmJnXEjilHfL+KiwKyODYFJcLaQEnv4aY5YK6AP4D3GapD7SeL7GyYEwc
         QqtqAqg7kCjBj91QTO7ZEEhe4wwCx22e6F3HhTCp5Jdaatuov0i3PO+NqM2gGU1ea87H
         q0V1BO4YIEV1sWj6g4dCZ71VTNcrPd0w/D+77x6ygV2Fg2mf/rtQ36bflOQGlKNgneq0
         8D0R0x4/hzsM6qSFgEMdPq+rZt/qtkuwK1+DCYb4GKoUKlmxlo0hKU1OgviNJA3Ekfs2
         e7eN/0kU5mviErKbtgyVnGbHr7Fh0fzoGswEHFQ3GKdqorQq0iKLqAB1mZsakCZCEDaF
         078g==
X-Gm-Message-State: AOAM531IGwRM8JBevPhFK4m/MI9pM0zZAz/ou2HpXzzJuyU2J2dnIiJa
        /Wpxvoiu5/k8WOyhF+va8PGlHwxWGnszhpKSyFBEZxleg6CW
X-Google-Smtp-Source: ABdhPJwRcMNlRBHcNqOaealrKrgBweS8+VDPtypmMK9pTCYzqPIYDK/ygpir3G/uhypQW46GB5bhX7+JJOqTCDTV7aLn2gZqu7wE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa7:: with SMTP id l7mr51973435ilv.307.1621250840097;
 Mon, 17 May 2021 04:27:20 -0700 (PDT)
Date:   Mon, 17 May 2021 04:27:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a77d205c284e0d2@google.com>
Subject: [syzbot] KMSAN: uninit-value in virtio_net_hdr_to_skb
From:   syzbot <syzbot+106457891e3cf3b273a9@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tannerlove@google.com,
        willemb@google.com, xie.he.0141@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4ebaab5f kmsan: drop unneeded references to kmsan_context_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17ac508ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ab8076fe8508c0d3
dashboard link: https://syzkaller.appspot.com/bug?extid=106457891e3cf3b273a9
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138f4972d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1624ffced00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+106457891e3cf3b273a9@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in virtio_net_hdr_to_skb+0x1414/0x14f0 include/linux/virtio_net.h:86
CPU: 0 PID: 8426 Comm: syz-executor777 Not tainted 5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 virtio_net_hdr_to_skb+0x1414/0x14f0 include/linux/virtio_net.h:86
 packet_snd net/packet/af_packet.c:2994 [inline]
 packet_sendmsg+0x85b8/0x99d0 net/packet/af_packet.c:3031
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 kernel_sendmsg+0x22c/0x2f0 net/socket.c:694
 sock_no_sendpage+0x205/0x2b0 net/core/sock.c:2860
 kernel_sendpage+0x47a/0x590 net/socket.c:3631
 sock_sendpage+0x161/0x1a0 net/socket.c:947
 pipe_to_sendpage+0x3e4/0x520 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x5e3/0xff0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x1d5/0x2c0 fs/splice.c:746
 do_splice_from fs/splice.c:767 [inline]
 do_splice+0x23c3/0x2c10 fs/splice.c:1079
 __do_splice fs/splice.c:1144 [inline]
 __do_sys_splice fs/splice.c:1350 [inline]
 __se_sys_splice+0x8fa/0xb50 fs/splice.c:1332
 __x64_sys_splice+0x6e/0x90 fs/splice.c:1332
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x449a39
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8ed790b2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00000000004cf518 RCX: 0000000000449a39
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000004cf510 R08: 000000000004ffe0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cf51c
R13: 000000000049e46c R14: 6d32cc5e8ead0600 R15: 0000000000022000

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:121
 kmsan_alloc_page+0xd0/0x1e0 mm/kmsan/kmsan_shadow.c:274
 __alloc_pages_nodemask+0x827/0xf90 mm/page_alloc.c:5044
 alloc_pages_current+0x7b6/0xb60 mm/mempolicy.c:2277
 alloc_pages include/linux/gfp.h:561 [inline]
 alloc_slab_page mm/slub.c:1653 [inline]
 allocate_slab+0x364/0x1260 mm/slub.c:1793
 new_slab mm/slub.c:1856 [inline]
 new_slab_objects mm/slub.c:2602 [inline]
 ___slab_alloc+0xd42/0x1930 mm/slub.c:2765
 __slab_alloc mm/slub.c:2805 [inline]
 slab_alloc_node mm/slub.c:2886 [inline]
 slab_alloc mm/slub.c:2931 [inline]
 kmem_cache_alloc_trace+0xc53/0x1030 mm/slub.c:2948
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 ____ip_mc_inc_group+0x4d7/0x10b0 net/ipv4/igmp.c:1435
 __ip_mc_inc_group net/ipv4/igmp.c:1470 [inline]
 ip_mc_inc_group net/ipv4/igmp.c:1476 [inline]
 ip_mc_up+0x1ec/0x410 net/ipv4/igmp.c:1775
 inetdev_event+0x2036/0x20e0 net/ipv4/devinet.c:1573
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0x123/0x290 kernel/notifier.c:410
 __dev_notify_flags+0x5ac/0xba0 net/core/dev.c:2075
 dev_change_flags+0x1f8/0x280 net/core/dev.c:8762
 do_setlink+0x17f6/0x7890 net/core/rtnetlink.c:2708
 __rtnl_newlink net/core/rtnetlink.c:3376 [inline]
 rtnl_newlink+0x2fc4/0x3d80 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x143b/0x18e0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x6fa/0x810 net/netlink/af_netlink.c:2502
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5571
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x11d6/0x14a0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x1740/0x1840 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 __sys_sendto+0x9ea/0xc60 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1985
 __x64_sys_sendto+0x6e/0x90 net/socket.c:1985
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xae
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
