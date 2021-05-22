Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E8638D4FB
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 11:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhEVJ6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 05:58:46 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:33603 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhEVJ6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 05:58:43 -0400
Received: by mail-il1-f199.google.com with SMTP id y10-20020a92c74a0000b02901bcf3518959so14151144ilp.0
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 02:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ywMXOuHA2a+EPDo5pSK8Z3W8CzmLp58Zct4OoCAHv4c=;
        b=SiHj4BwEDJhWs11CfSsVBnWAf+aKC77wdHf0Xl8wU2e/DNlaqM44uLgCnJHDhfswI3
         Yn0Fie9QUUfm8mMIdEK6PBP+eBqqgr+FWEYlZ/z4sRxKdOqOjlHgmnTTWfJIESOsT2qE
         TZTBWjL5myLmFhFe38fr20pEkuniw+Yw4LSqAMvSAleSB+lZHK++gLJxAH5ZZ/KOq8nG
         0eJy+GnVmsn38722RnIfOcybEhCGURVMEl+Xb5oE83Uh+DWiUZQy6E5pX57fyR/aNI1g
         U3ySgcM3seZETQAiGCZ/3Hqfxyy1gi6n4U0Ebo5FDXvcvzpcTsnnm+fjoCEsM2XQYGJC
         rltg==
X-Gm-Message-State: AOAM532PN2oB9BeXiMeBVc9WLyA1DNnn4HjdeDhvHW4lCk2eQ2m9wx//
        Gd4Fv8BRBE8qhDhBpvDr9YKAc2/jEZahSVIy7OPB1XAE3azI
X-Google-Smtp-Source: ABdhPJzA9cpGrW4+bWYFku+YXWEuUYsHm4977G1mRrPaNzWezoiTk+rXJ8gTunbfIuQVfkQ7og3ltZHXtl6KM7VqoRVyy8Ao96E9
MIME-Version: 1.0
X-Received: by 2002:a6b:690c:: with SMTP id e12mr4267497ioc.69.1621677439036;
 Sat, 22 May 2021 02:57:19 -0700 (PDT)
Date:   Sat, 22 May 2021 02:57:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1b1fc05c2e8333c@google.com>
Subject: [syzbot] KMSAN: uninit-value in ieee802154_rx
From:   syzbot <syzbot+2789bd545fa0d4a22f07@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bdefec9a minor fix
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11cee1d7d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6842a91012889c
dashboard link: https://syzkaller.appspot.com/bug?extid=2789bd545fa0d4a22f07
compiler:       Debian clang version 11.0.1-2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2789bd545fa0d4a22f07@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ieee802154_subif_frame net/mac802154/rx.c:67 [inline]
BUG: KMSAN: uninit-value in __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
BUG: KMSAN: uninit-value in ieee802154_rx+0x19c4/0x20e0 net/mac802154/rx.c:284
CPU: 0 PID: 6808 Comm: syz-executor.3 Not tainted 5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ieee802154_subif_frame net/mac802154/rx.c:67 [inline]
 __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
 ieee802154_rx+0x19c4/0x20e0 net/mac802154/rx.c:284
 ieee802154_tasklet_handler+0x193/0x2e0 net/mac802154/main.c:35
 tasklet_action_common+0x3de/0x640 kernel/softirq.c:557
 tasklet_action+0x30/0x40 kernel/softirq.c:577
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 do_softirq+0x123/0x1c0 kernel/softirq.c:248
 </IRQ>
 __local_bh_enable_ip+0xa1/0xb0 kernel/softirq.c:198
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
 __dev_queue_xmit+0x3b4a/0x4600 net/core/dev.c:4221
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 dgram_sendmsg+0x1142/0x15d0 net/ieee802154/socket.c:682
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f5e549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55585fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000500
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 ieee802154_parse_frame_start net/mac802154/rx.c:156 [inline]
 __ieee802154_rx_handle_packet net/mac802154/rx.c:198 [inline]
 ieee802154_rx+0xd92/0x20e0 net/mac802154/rx.c:284
 ieee802154_tasklet_handler+0x193/0x2e0 net/mac802154/main.c:35
 tasklet_action_common+0x3de/0x640 kernel/softirq.c:557
 tasklet_action+0x30/0x40 kernel/softirq.c:577
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345

Local variable ----hdr.i@ieee802154_rx created at:
 __ieee802154_rx_handle_packet net/mac802154/rx.c:196 [inline]
 ieee802154_rx+0xb3d/0x20e0 net/mac802154/rx.c:284
 __ieee802154_rx_handle_packet net/mac802154/rx.c:196 [inline]
 ieee802154_rx+0xb3d/0x20e0 net/mac802154/rx.c:284
=====================================================
=====================================================
BUG: KMSAN: uninit-value in ieee802154_subif_frame net/mac802154/rx.c:69 [inline]
BUG: KMSAN: uninit-value in __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
BUG: KMSAN: uninit-value in ieee802154_rx+0x1a9f/0x20e0 net/mac802154/rx.c:284
CPU: 0 PID: 6808 Comm: syz-executor.3 Tainted: G    B             5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 ieee802154_subif_frame net/mac802154/rx.c:69 [inline]
 __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
 ieee802154_rx+0x1a9f/0x20e0 net/mac802154/rx.c:284
 ieee802154_tasklet_handler+0x193/0x2e0 net/mac802154/main.c:35
 tasklet_action_common+0x3de/0x640 kernel/softirq.c:557
 tasklet_action+0x30/0x40 kernel/softirq.c:577
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345
 do_softirq+0x123/0x1c0 kernel/softirq.c:248
 </IRQ>
 __local_bh_enable_ip+0xa1/0xb0 kernel/softirq.c:198
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
 __dev_queue_xmit+0x3b4a/0x4600 net/core/dev.c:4221
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4227
 dgram_sendmsg+0x1142/0x15d0 net/ieee802154/socket.c:682
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2433
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x127/0x180 arch/x86/entry/common.c:142
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:167
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:210
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f5e549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55585fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000500
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 ieee802154_parse_frame_start net/mac802154/rx.c:156 [inline]
 __ieee802154_rx_handle_packet net/mac802154/rx.c:198 [inline]
 ieee802154_rx+0xd92/0x20e0 net/mac802154/rx.c:284
 ieee802154_tasklet_handler+0x193/0x2e0 net/mac802154/main.c:35
 tasklet_action_common+0x3de/0x640 kernel/softirq.c:557
 tasklet_action+0x30/0x40 kernel/softirq.c:577
 __do_softirq+0x1b9/0x715 kernel/softirq.c:345

Local variable ----hdr.i@ieee802154_rx created at:
 __ieee802154_rx_handle_packet net/mac802154/rx.c:196 [inline]
 ieee802154_rx+0xb3d/0x20e0 net/mac802154/rx.c:284
 __ieee802154_rx_handle_packet net/mac802154/rx.c:196 [inline]
 ieee802154_rx+0xb3d/0x20e0 net/mac802154/rx.c:284
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
