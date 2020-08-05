Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF16023CD80
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgHERfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728370AbgHERfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:35:06 -0400
Received: from mail-io1-xd48.google.com (mail-io1-xd48.google.com [IPv6:2607:f8b0:4864:20::d48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833B1C001FC1
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 08:30:28 -0700 (PDT)
Received: by mail-io1-xd48.google.com with SMTP id 189so7728121iov.16
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 08:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A1AQFUtZc3oUBC+ELHd0XSkjPz6GoWRGj0v6BMelR/0=;
        b=FPO+1OuYgey2XCRKh2vP/jYO5omVOJb0mHUCk8oK3gSpJxspYyS3/dBGHxlCrdrSnF
         /9qCC4V8g9bI5Fz8RP7nGZ1RaTa53UDnJsQn8k6F0aS71lhJW1UFY6EBCXjNJBfKHe4s
         56jA5XvoUWHNmgKzwTQ1o/2mRqMomUBM8lDgsQdKx2jPTByQ/22xjxf1RcD72LdRGatY
         2ABQU2MLF6HucCa4C9oNWD2dZyMxMC0pPTR5w0LEYAeuyExYZ1UFy6dRjT1Du+txfEMI
         4pkkqkMv9cIkmGli7q6yX8Rn3QFfGjKcP6F8PygF6cgYWYIZymfXE4tItDi8XQSNrTba
         JaNA==
X-Gm-Message-State: AOAM533gZqttD7NoIfOs6JYhVy9SfKo9btYvBuWJHdwBS/AzdQIpxTvp
        hJOpYvBrZmo52fVn62ZEdXf+CQ39bYP24pi3QtkH+AX5lMRH
X-Google-Smtp-Source: ABdhPJykkigbEi+M0gISZNJMdIPXT3ju2NiFa2v2XCWKQqEk8ic4jWaTpxRf/FDS3gSAkV6njowu7TVDsJBm9V9nFFyGPEY0qALC
MIME-Version: 1.0
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr3127653iof.70.1596629836200;
 Wed, 05 Aug 2020 05:17:16 -0700 (PDT)
Date:   Wed, 05 Aug 2020 05:17:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039829c05ac205a4c@google.com>
Subject: KMSAN: uninit-value in do_xdp_generic
From:   syzbot <syzbot+007ef8d907f2fb6e17ca@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, glider@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    93f54a72 instrumented.h: fix KMSAN support
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16fa5198900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa4f3b91169c2501
dashboard link: https://syzkaller.appspot.com/bug?extid=007ef8d907f2fb6e17ca
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+007ef8d907f2fb6e17ca@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in netif_receive_generic_xdp net/core/dev.c:4670 [inline]
BUG: KMSAN: uninit-value in do_xdp_generic+0x1312/0x24f0 net/core/dev.c:4735
CPU: 1 PID: 11582 Comm: syz-executor.1 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1df/0x240 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 netif_receive_generic_xdp net/core/dev.c:4670 [inline]
 do_xdp_generic+0x1312/0x24f0 net/core/dev.c:4735
 __netif_receive_skb_core+0x9a0/0x5890 net/core/dev.c:5107
 __netif_receive_skb_one_core net/core/dev.c:5279 [inline]
 __netif_receive_skb net/core/dev.c:5395 [inline]
 netif_receive_skb_internal net/core/dev.c:5497 [inline]
 netif_receive_skb+0x56c/0xff0 net/core/dev.c:5556
 tun_rx_batched include/linux/skbuff.h:4327 [inline]
 tun_get_user+0x6df8/0x72f0 drivers/net/tun.c:1972
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2001
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xd98/0x1480 fs/read_write.c:578
 ksys_write+0x267/0x450 fs/read_write.c:631
 __do_sys_write fs/read_write.c:643 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:640
 __ia32_sys_write+0x4a/0x70 fs/read_write.c:640
 do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
 __do_fast_syscall_32+0x2aa/0x400 arch/x86/entry/common.c:477
 do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1b549
Code: Bad RIP value.
RSP: 002b:00000000f54910cc EFLAGS: 00000296 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000240
RDX: 000000000000000c RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 pskb_expand_head+0x20b/0x1b00 net/core/skbuff.c:1627
 netif_receive_generic_xdp net/core/dev.c:4616 [inline]
 do_xdp_generic+0x58c/0x24f0 net/core/dev.c:4735
 __netif_receive_skb_core+0x9a0/0x5890 net/core/dev.c:5107
 __netif_receive_skb_one_core net/core/dev.c:5279 [inline]
 __netif_receive_skb net/core/dev.c:5395 [inline]
 netif_receive_skb_internal net/core/dev.c:5497 [inline]
 netif_receive_skb+0x56c/0xff0 net/core/dev.c:5556
 tun_rx_batched include/linux/skbuff.h:4327 [inline]
 tun_get_user+0x6df8/0x72f0 drivers/net/tun.c:1972
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2001
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xd98/0x1480 fs/read_write.c:578
 ksys_write+0x267/0x450 fs/read_write.c:631
 __do_sys_write fs/read_write.c:643 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:640
 __ia32_sys_write+0x4a/0x70 fs/read_write.c:640
 do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
 __do_fast_syscall_32+0x2aa/0x400 arch/x86/entry/common.c:477
 do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
