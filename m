Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222E2276D6D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgIXJ2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:28:09 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:42387 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgIXJ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:26:26 -0400
Received: by mail-io1-f77.google.com with SMTP id w3so1945712iou.9
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Xx3C4JNesC+v7KtUAOM42iev2K1jVtLzKqz0VdkuiaU=;
        b=ExdvNGNd0VwhXDNOHXDKhIGQbAP8SRRHMWmWnywr1x7nxnGikd4z6HeaqE819EfreZ
         tT1KdBzIeojq1z9pBxjgFMvosaSP4sTtohJrgcIyxeglKtwbPavIGtb1a5sbSLSNGYla
         G9sTZrb7aChp8AauRRkbLnTOmVa5NlF1xe8M2wie+9WlPxgiRhIUusQiy1UZn5CZbSUR
         pg7+jfx98R+VYEVNW3K+kTSfBJdmZ6XnWiVzQvDwjyEQECWMzRLS3g7K7Nc+UfGSwUXd
         fsm/G5/ikvPsmUgFTLsbtdM+6WCUItcLVGLqHkwExO09l3KU8mLQCqVRwRWDCQnAS5I2
         YryA==
X-Gm-Message-State: AOAM533e+3yogHVm+hh1Dvc1zOTh/LzI8+I7ew5+kI+sFCqJBm4mQvsD
        NphJUk/P2Z+s4Y97LOTX74srDclufNPPsxf9K0OjGhi7XFVR
X-Google-Smtp-Source: ABdhPJw1wh70zo2cujRhmnbxOdFtQlKJnCID2iuvOdd8eQJEWZQSzAiembA2d8txLrPHeqqSzusfx4yxX2+HZ1NVoF1xF4jUijVr
MIME-Version: 1.0
X-Received: by 2002:a6b:3e06:: with SMTP id l6mr2565402ioa.160.1600939585354;
 Thu, 24 Sep 2020 02:26:25 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:26:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ac2d105b00bcb72@google.com>
Subject: KMSAN: uninit-value in hwsim_cloned_frame_received_nl
From:   syzbot <syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johannes@sipsolutions.net,
        kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c5a13b33 kmsan: clang-format core
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12a19c03900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=20f149ad694ba4be
dashboard link: https://syzkaller.appspot.com/bug?extid=b2645b5bf1512b81fa22
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118689ab900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104fc409900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in hwsim_cloned_frame_received_nl+0x104e/0x13e0 drivers/net/wireless/mac80211_hwsim.c:3553
CPU: 1 PID: 8531 Comm: syz-executor177 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:219
 hwsim_cloned_frame_received_nl+0x104e/0x13e0 drivers/net/wireless/mac80211_hwsim.c:3553
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x1703/0x18a0 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x6d7/0x7e0 net/netlink/af_netlink.c:2470
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11c8/0x1490 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173a/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x401a73
Code: ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 83 3d bd 8c 2d 00 00 75 17 49 89 ca b8 2c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 f1 0b 00 00 c3 48 83 ec 08 e8 57 01 00 00
RSP: 002b:00007ffc0c9fdd58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffc0c9fddd0 RCX: 0000000000401a73
RDX: 0000000000000034 RSI: 00007ffc0c9fde20 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffc0c9fdd60 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffc0c9fde20 R15: 0000000000000003

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:143 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:126
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2907 [inline]
 __kmalloc_node_track_caller+0x9aa/0x12f0 mm/slub.c:4511
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 hwsim_cloned_frame_received_nl+0x20e/0x13e0 drivers/net/wireless/mac80211_hwsim.c:3498
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x1703/0x18a0 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x6d7/0x7e0 net/netlink/af_netlink.c:2470
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11c8/0x1490 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173a/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
