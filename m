Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA022409F8
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgHJPhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:37:25 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44675 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgHJPhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:37:19 -0400
Received: by mail-io1-f71.google.com with SMTP id m12so7307720iov.11
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 08:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=z1AnOwdvWOgDWEgXiKkcjmRiNUEEMgZuTHLJ/I6p2U0=;
        b=o06eiuCWI5sKHp1Pd+O582PWXppS/9oKCfxuKcxAm4YJPVS7Nj30CRV4BNRb9+6Ixk
         umrQC+hT9ZRILjPWnHqj+Jo9H6SiFNrSWhOfbQICsVX62f8ItMs6mMqX4/Q4J8g7Y5Mw
         RFrOcvxU/TGpOcc4lzJ11eDwzxcYX6LixoDxedV45UTwWVwZh0AEemVVJ9iL9Oys0cc1
         jZLXmgs2O8APtzEYV0DovpxdqMegWOC/s1XnwMN2gDLNlpaYxJ/KrC5gL20EHMOi2Zd1
         zpDA7CASpTdK+h8dlRQhf656AfYEDK+0irfg/BEpL0gosJTPKldIQ+kh3S9ol/pOGv5p
         V8Kw==
X-Gm-Message-State: AOAM532yTkQ0vHdDKr1UST694kXhvBVnWOwgKg7Vn7fH8td91NMOJwc3
        qIADYlEuUUiapmNOkZjLOIz+v5IAeLA3bX57PtElBYjkKIwX
X-Google-Smtp-Source: ABdhPJzXLcVGEGL1RIokA2/PYg0AZsJOdunpdyy5jMuU1F4eyFVV7w5W5h7P9PJORJ+cv6ygCXpWaKs/UO+7RBVKWAPhNuhbLQpM
MIME-Version: 1.0
X-Received: by 2002:a92:cf09:: with SMTP id c9mr14933190ilo.38.1597073838960;
 Mon, 10 Aug 2020 08:37:18 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:37:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9f93a05ac87ba78@google.com>
Subject: KMSAN: uninit-value in hsr_get_node
From:   syzbot <syzbot+d205b494fafacf899b18@syzkaller.appspotmail.com>
To:     alex.shi@linux.alibaba.com, ap420073@gmail.com,
        davem@davemloft.net, frextrite@gmail.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1198be02900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=d205b494fafacf899b18
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d205b494fafacf899b18@syzkaller.appspotmail.com

hsr_slave_0: hsr_addr_subst_dest: Unknown node
hsr_slave_1: hsr_addr_subst_dest: Unknown node
=====================================================
BUG: KMSAN: uninit-value in hsr_get_node+0x3d3/0x750 net/hsr/hsr_framereg.c:191
CPU: 0 PID: 3953 Comm: syz-executor.5 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 hsr_get_node+0x3d3/0x750 net/hsr/hsr_framereg.c:191
 hsr_fill_frame_info net/hsr/hsr_forward.c:315 [inline]
 hsr_forward_skb+0x90c/0x3600 net/hsr/hsr_forward.c:358
 hsr_dev_xmit+0x133/0x230 net/hsr/hsr_device.c:221
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one+0x3cf/0x750 net/core/dev.c:3556
 dev_hard_start_xmit net/core/dev.c:3572 [inline]
 __dev_queue_xmit+0x3aad/0x4470 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 __bpf_tx_skb net/core/filter.c:2086 [inline]
 __bpf_redirect_common net/core/filter.c:2125 [inline]
 __bpf_redirect+0x1479/0x16b0 net/core/filter.c:2132
 ____bpf_clone_redirect net/core/filter.c:2165 [inline]
 bpf_clone_redirect+0x498/0x650 net/core/filter.c:2137
 ___bpf_prog_run+0x4498/0x98e0 kernel/bpf/core.c:1516
 __bpf_prog_run512+0x12e/0x190 kernel/bpf/core.c:1694
 bpf_test_run+0x52d/0xed0 include/linux/filter.h:734
 bpf_prog_test_run_skb+0x1053/0x2ad0 net/bpf/test_run.c:459
 bpf_prog_test_run kernel/bpf/syscall.c:2983 [inline]
 __do_sys_bpf+0xb364/0x1a4c0 kernel/bpf/syscall.c:4135
 __se_sys_bpf+0x8e/0xa0 kernel/bpf/syscall.c:4075
 __ia32_sys_bpf+0x4a/0x70 kernel/bpf/syscall.c:4075
 do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
 __do_fast_syscall_32+0x2af/0x480 arch/x86/entry/common.c:477
 do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f1d549
Code: Bad RIP value.
RSP: 002b:00000000f55170cc EFLAGS: 00000296 ORIG_RAX: 0000000000000165
RAX: ffffffffffffffda RBX: 000000000000000a RCX: 0000000020000740
RDX: 0000000000000028 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xeab/0x12e0 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 pskb_expand_head+0x26e/0x1e30 net/core/skbuff.c:1627
 skb_ensure_writable+0x4d1/0x590 net/core/skbuff.c:5457
 __bpf_try_make_writable net/core/filter.c:1624 [inline]
 bpf_try_make_writable net/core/filter.c:1630 [inline]
 bpf_try_make_head_writable net/core/filter.c:1638 [inline]
 ____bpf_clone_redirect net/core/filter.c:2159 [inline]
 bpf_clone_redirect+0x26c/0x650 net/core/filter.c:2137
 ___bpf_prog_run+0x4498/0x98e0 kernel/bpf/core.c:1516
 __bpf_prog_run512+0x12e/0x190 kernel/bpf/core.c:1694
 bpf_test_run+0x52d/0xed0 include/linux/filter.h:734
 bpf_prog_test_run_skb+0x1053/0x2ad0 net/bpf/test_run.c:459
 bpf_prog_test_run kernel/bpf/syscall.c:2983 [inline]
 __do_sys_bpf+0xb364/0x1a4c0 kernel/bpf/syscall.c:4135
 __se_sys_bpf+0x8e/0xa0 kernel/bpf/syscall.c:4075
 __ia32_sys_bpf+0x4a/0x70 kernel/bpf/syscall.c:4075
 do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
 __do_fast_syscall_32+0x2af/0x480 arch/x86/entry/common.c:477
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
