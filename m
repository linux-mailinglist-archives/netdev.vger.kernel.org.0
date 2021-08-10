Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2743E550F
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhHJIZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:25:52 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:50778 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbhHJIZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 04:25:49 -0400
Received: by mail-io1-f70.google.com with SMTP id e18-20020a5d92520000b029057d0eab404aso14056931iol.17
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 01:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DTBo3khEZOU+h0oQTiTa1/X9B14yYY7SYQPoR8l9cKU=;
        b=Wg2AEFGDgar4TMgW6t3Gd5Vid4igvW5SMxOGg9scTzelr3C55PoNB5DG4IN73ikIVm
         zkzeGATJGCEoCr7uNmvI2vqQG5ALMhQx/mJZkxSF9Cjwp5qqW8RAT4Bxj7bWzPHI3qG1
         buSg/LGK/KsmyQsksnAcnjtZOwS5m3U05UUL5IhXDithhhikNegDGbzFuCeFTMoreLsq
         Zz6Gj/eweGkN64Y19TlEkDkhwVpXon/qrdllmNvallFBoN+rJmjbbSsbrOVzG6IjjbsM
         KI3i0R/h7DPcACjng3NyTXX7WG+J4j9RTam9eqYNpBRaSCMNCVMO4eSC931QV7s2urIF
         ec6A==
X-Gm-Message-State: AOAM532vYgkqhC7aRN4N4xaIRq1/ip9o4qAqHLwt1gH/8sETUtS8UJn8
        NDEYHvASQe+z/Xt+CjEYL7bKfmHE2La5IbjNPMQUhcvsyGL8
X-Google-Smtp-Source: ABdhPJxSL822WJcCgEbOO8zBDc7ubIaooAsY9ZVzeKi/C7SZFs4XhU60TfzMZrMZfxNgN2jJJwohzAP36i8gzJ6IZ9/CkOYBTXw2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b43:: with SMTP id f3mr409047ilu.94.1628583926914;
 Tue, 10 Aug 2021 01:25:26 -0700 (PDT)
Date:   Tue, 10 Aug 2021 01:25:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007365d805c9303e63@google.com>
Subject: [syzbot] KMSAN: uninit-value in crc_ccitt
From:   syzbot <syzbot+6d38e380afc486ec44a1@syzkaller.appspotmail.com>
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

HEAD commit:    ee9407ea37bf kmsan: core: massage include/linux/sched.h
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1656babe300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=92983a87b2ce6cdb
dashboard link: https://syzkaller.appspot.com/bug?extid=6d38e380afc486ec44a1
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d38e380afc486ec44a1@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in crc_ccitt_byte include/linux/crc-ccitt.h:15 [inline]
BUG: KMSAN: uninit-value in crc_ccitt+0x364/0x3f0 lib/crc-ccitt.c:102
CPU: 1 PID: 9742 Comm: syz-executor.4 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/report.c:121
 __msan_warning+0xd7/0x160 mm/kmsan/instrumentation.c:201
 crc_ccitt_byte include/linux/crc-ccitt.h:15 [inline]
 crc_ccitt+0x364/0x3f0 lib/crc-ccitt.c:102
 ieee802154_tx+0x300/0x800 net/mac802154/tx.c:72
 ieee802154_subif_start_xmit+0x16a/0x250 net/mac802154/tx.c:132
 __netdev_start_xmit include/linux/netdevice.h:4944 [inline]
 netdev_start_xmit include/linux/netdevice.h:4958 [inline]
 xmit_one+0x2b6/0x760 net/core/dev.c:3654
 dev_hard_start_xmit+0x196/0x420 net/core/dev.c:3670
 sch_direct_xmit+0x554/0x1b90 net/sched/sch_generic.c:336
 qdisc_restart net/sched/sch_generic.c:401 [inline]
 __qdisc_run+0x35b/0x490 net/sched/sch_generic.c:409
 qdisc_run include/net/pkt_sched.h:131 [inline]
 __dev_xmit_skb net/core/dev.c:3857 [inline]
 __dev_queue_xmit+0x1e3f/0x5440 net/core/dev.c:4214
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4279
 dgram_sendmsg+0x1142/0x15d0 net/ieee802154/socket.c:682
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2337
 ___sys_sendmsg net/socket.c:2391 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2420
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x132/0x1b0 arch/x86/entry/common.c:149
 do_fast_syscall_32+0x77/0xd0 arch/x86/entry/common.c:179
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:222
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fa3549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f559d5fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/core.c:106 [inline]
 kmsan_internal_chain_origin+0xab/0x120 mm/kmsan/core.c:244
 kmsan_memmove_metadata+0x23b/0x2c0 mm/kmsan/core.c:192
 __msan_memcpy+0x5e/0x90 mm/kmsan/instrumentation.c:111
 ieee802154_hdr_push+0xcd7/0xdd0 net/ieee802154/header_ops.c:117
 ieee802154_header_create+0xd07/0x1070 net/mac802154/iface.c:404
 wpan_dev_hard_header include/net/cfg802154.h:374 [inline]
 dgram_sendmsg+0xf4b/0x15d0 net/ieee802154/socket.c:670
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2337
 ___sys_sendmsg net/socket.c:2391 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2420
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x132/0x1b0 arch/x86/entry/common.c:149
 do_fast_syscall_32+0x77/0xd0 arch/x86/entry/common.c:179
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:222
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/core.c:106 [inline]
 kmsan_internal_chain_origin+0xab/0x120 mm/kmsan/core.c:244
 kmsan_memmove_metadata+0x23b/0x2c0 mm/kmsan/core.c:192
 __msan_memcpy+0x5e/0x90 mm/kmsan/instrumentation.c:111
 ieee802154_hdr_push_addr net/ieee802154/header_ops.c:35 [inline]
 ieee802154_hdr_push+0x2b0/0xdd0 net/ieee802154/header_ops.c:89
 ieee802154_header_create+0xd07/0x1070 net/mac802154/iface.c:404
 wpan_dev_hard_header include/net/cfg802154.h:374 [inline]
 dgram_sendmsg+0xf4b/0x15d0 net/ieee802154/socket.c:670
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2337
 ___sys_sendmsg net/socket.c:2391 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2420
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x132/0x1b0 arch/x86/entry/common.c:149
 do_fast_syscall_32+0x77/0xd0 arch/x86/entry/common.c:179
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:222
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/core.c:106 [inline]
 kmsan_internal_chain_origin+0xab/0x120 mm/kmsan/core.c:244
 kmsan_memmove_metadata+0x23b/0x2c0 mm/kmsan/core.c:192
 __msan_memcpy+0x5e/0x90 mm/kmsan/instrumentation.c:111
 ieee802154_header_create+0xcd1/0x1070 net/mac802154/iface.c:402
 wpan_dev_hard_header include/net/cfg802154.h:374 [inline]
 dgram_sendmsg+0xf4b/0x15d0 net/ieee802154/socket.c:670
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2337
 ___sys_sendmsg net/socket.c:2391 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2420
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x132/0x1b0 arch/x86/entry/common.c:149
 do_fast_syscall_32+0x77/0xd0 arch/x86/entry/common.c:179
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:222
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Local variable ----dst_addr@dgram_sendmsg created at:
 dgram_sendmsg+0x8a/0x15d0 net/ieee802154/socket.c:607
 dgram_sendmsg+0x8a/0x15d0 net/ieee802154/socket.c:607
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
