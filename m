Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C7A1F4D62
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 07:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgFJF5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 01:57:15 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42640 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgFJF5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 01:57:14 -0400
Received: by mail-il1-f198.google.com with SMTP id j71so771359ilg.9
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 22:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yOgbcmbmkDjbAdsXtHmX68CQ4GSO0HPYQRr+QH3lVlA=;
        b=G5qnNFKHmGADQ17Oytf/buPD/okVTeLY9qY2G58/H0UUsh+LU2rwAhKKYlvlFmh8SW
         9pEby6gwGjcDJPjScm13PEaAJoqOnD66154AKxhPNVwDWrpFm2i6EDmQK+bcU+cXsfN4
         Rsbj2ibPtuZFOwv1INralKsK01or0IR7MkV2ClDxxQ+Y1TTD8VUaTl5cHRc7cyDxeq/p
         5xQwASIwuOXjhub0nbYI0K1CgF1MQ5AH0vfQtHibWTmrjnGikQK/iwKOU6+VJZgMI0rG
         BcLy8pt02CheMSOgCewqWB5SwJz9s0lR8y0yqh6KaJKCYzJJS23uUmsAEI4iiXUwEN88
         aulQ==
X-Gm-Message-State: AOAM532pv8kc6dZNoXLk35k2z0opzHzwkgdx9tGjvqXMHRzVuJg7ssyb
        6o5o7GxfJvnKrloyveYEJle4MiYudJoj0YoRku29LfXShVc+
X-Google-Smtp-Source: ABdhPJwM9DQcjI9A2nOZL/NLJkcyaBlzTyndTAn1jVtBa5B6ws3rmYes8+pC+/GO7tDN1EPO5Z21Pp5D4fu/qaj6xXG/i93EoOMd
MIME-Version: 1.0
X-Received: by 2002:a05:6602:22d6:: with SMTP id e22mr1770839ioe.128.1591768632010;
 Tue, 09 Jun 2020 22:57:12 -0700 (PDT)
Date:   Tue, 09 Jun 2020 22:57:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e02b3505a7b48345@google.com>
Subject: KASAN: use-after-free Read in tipc_named_reinit
From:   syzbot <syzbot+e9cc557752ab126c1b99@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cb8e59cc Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12eccfd2100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a16ddbc78955e3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=e9cc557752ab126c1b99
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e9cc557752ab126c1b99@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:252 [inline]
BUG: KASAN: use-after-free in tipc_named_reinit+0x913/0x946 net/tipc/name_distr.c:344
Read of size 8 at addr ffff8880580d2000 by task kworker/1:1/27

CPU: 1 PID: 27 Comm: kworker/1:1 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events tipc_net_finalize_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __read_once_size include/linux/compiler.h:252 [inline]
 tipc_named_reinit+0x913/0x946 net/tipc/name_distr.c:344
 tipc_net_finalize net/tipc/net.c:138 [inline]
 tipc_net_finalize+0x1cf/0x310 net/tipc/net.c:131
 tipc_net_finalize_work+0x55/0x80 net/tipc/net.c:150
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

Allocated by task 22186:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 tipc_nametbl_init+0x1b5/0x490 net/tipc/name_table.c:852
 tipc_init_net+0x381/0x5c0 net/tipc/core.c:79
 ops_init+0xaf/0x420 net/core/net_namespace.c:151
 setup_net+0x2de/0x860 net/core/net_namespace.c:341
 copy_net_ns+0x293/0x590 net/core/net_namespace.c:482
 create_new_namespaces+0x3fb/0xb30 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
 ksys_unshare+0x43d/0x8e0 kernel/fork.c:2984
 __do_sys_unshare kernel/fork.c:3052 [inline]
 __se_sys_unshare kernel/fork.c:3050 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3050
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 191:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 tipc_exit_net+0x2c/0x270 net/tipc/core.c:113
 ops_exit_list.isra.0+0xa8/0x150 net/core/net_namespace.c:186
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

The buggy address belongs to the object at ffff8880580d0000
 which belongs to the cache kmalloc-16k of size 16384
The buggy address is located 8192 bytes inside of
 16384-byte region [ffff8880580d0000, ffff8880580d4000)
The buggy address belongs to the page:
page:ffffea0001603400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0001603400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0001509008 ffff8880aa001c50 ffff8880aa002380
raw: 0000000000000000 ffff8880580d0000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880580d1f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880580d1f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880580d2000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880580d2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880580d2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
