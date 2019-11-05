Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E632F085E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbfKEVaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:30:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:51985 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbfKEVaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:30:11 -0500
Received: by mail-il1-f197.google.com with SMTP id x2so16260004ilk.18
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:30:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1xkanS+/tT8hR6RPQXjHlC3jGkbXrPci9yKxX6hZLBs=;
        b=fggD5+b52DaWK73TrHCiQrBiJ+qWFgNo0YAYhVmLC+Xl90S8JoW88+KBH0E8mqpJPR
         4sUHJvKOhfObfiBgcTgM+uZHWT+ETe8V5S+EkBSdPIL7yqdyAfUMZCkR8+oJXVUaKS+n
         vOs8mvYvEyjRJjJXPFhAYZcmASzIEppV8GglXvIbrsstlDOCi1Sso8I6CNMeoaZTj05Z
         QvuBpbr88SBNtjNJFm+8WCi5RBZruRlw11HomUjPzMEsG5SSEKNozcjGctsNiI5EjTiH
         pw3u6Ryfo2gOAGO0cfsKOJ1kJjms82059qgNb0y/271/LVdHsVyRNx6DFxa35cVwR63T
         Fwdw==
X-Gm-Message-State: APjAAAWtQO/vKF+5vrqmNJIw2/xqR0D+CUL2X9+6TAxLp8fBfUHg7uFH
        2QbmYt8TpuCZg5pFs4jlSmP3uVzv6A83uqntz2zgjF1t9Ba/
X-Google-Smtp-Source: APXvYqxW0UxrmegVMqG77ZjE2Pn1zkX0CYaF3xrMaltdjM3HIpoHKlF/HTAbmWtXzBL0sW/Im6X5G2ADbqivW97fgwHc6xVcx3ZZ
MIME-Version: 1.0
X-Received: by 2002:a92:99d1:: with SMTP id t78mr34831691ilk.122.1572989409341;
 Tue, 05 Nov 2019 13:30:09 -0800 (PST)
Date:   Tue, 05 Nov 2019 13:30:09 -0800
In-Reply-To: <0000000000005ed7710596937e86@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fabba10596a022a4@google.com>
Subject: Re: KASAN: use-after-free Read in j1939_xtp_rx_abort_one
From:   syzbot <syzbot+db4869ba599c0de9b13e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    a99d8080 Linux 5.4-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15565bcce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=896c87b73c6fcda6
dashboard link: https://syzkaller.appspot.com/bug?extid=db4869ba599c0de9b13e
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1435c078e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139a3542e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+db4869ba599c0de9b13e@syzkaller.appspotmail.com

vcan0: j1939_tp_rxtimer: 0x00000000533cdfdb: rx timeout, send abort
vcan0: j1939_xtp_rx_abort_one: 0x00000000533cdfdb: 0x00000: (3) A timeout  
occurred and this is the connection abort to close the session.
==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x96/0x1be0  
kernel/locking/lockdep.c:3828
Read of size 8 at addr ffff888097f09080 by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5c0 mm/kasan/report.c:374
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:506
  kasan_report+0x26/0x50 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __lock_acquire+0x96/0x1be0 kernel/locking/lockdep.c:3828
  lock_acquire+0x158/0x250 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x34/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  j1939_session_list_lock net/can/j1939/transport.c:238 [inline]
  j1939_session_get_by_addr net/can/j1939/transport.c:530 [inline]
  j1939_xtp_rx_abort_one+0x89/0x3f0 net/can/j1939/transport.c:1242
  j1939_xtp_rx_abort net/can/j1939/transport.c:1270 [inline]
  j1939_tp_cmd_recv net/can/j1939/transport.c:1940 [inline]
  j1939_tp_recv+0x648/0xb80 net/can/j1939/transport.c:1973
  j1939_can_recv+0x424/0x650 net/can/j1939/main.c:100
  deliver net/can/af_can.c:568 [inline]
  can_rcv_filter+0x3c0/0x8b0 net/can/af_can.c:602
  can_receive+0x2ac/0x3b0 net/can/af_can.c:659
  can_rcv+0xe4/0x220 net/can/af_can.c:685
  __netif_receive_skb_one_core net/core/dev.c:4929 [inline]
  __netif_receive_skb+0x136/0x370 net/core/dev.c:5043
  process_backlog+0x4d8/0x930 net/core/dev.c:5874
  napi_poll net/core/dev.c:6311 [inline]
  net_rx_action+0x5ef/0x10d0 net/core/dev.c:6379
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:766
  run_ksoftirqd+0x64/0xf0 kernel/softirq.c:603
  smpboot_thread_fn+0x5b3/0x9a0 kernel/smpboot.c:165
  kthread+0x332/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 7892:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:510
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  kmem_cache_alloc_trace+0x221/0x2f0 mm/slab.c:3550
  kmalloc include/linux/slab.h:556 [inline]
  kzalloc include/linux/slab.h:690 [inline]
  j1939_priv_create net/can/j1939/main.c:122 [inline]
  j1939_netdev_start+0x177/0x730 net/can/j1939/main.c:251
  j1939_sk_bind+0x2c0/0xac0 net/can/j1939/socket.c:438
  __sys_bind+0x2c2/0x3a0 net/socket.c:1647
  __do_sys_bind net/socket.c:1658 [inline]
  __se_sys_bind net/socket.c:1656 [inline]
  __x64_sys_bind+0x7a/0x90 net/socket.c:1656
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7891:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  __j1939_priv_release net/can/j1939/main.c:154 [inline]
  kref_put include/linux/kref.h:65 [inline]
  j1939_priv_put net/can/j1939/main.c:159 [inline]
  j1939_netdev_stop+0x20c/0x230 net/can/j1939/main.c:291
  j1939_sk_release+0x61f/0x7e0 net/can/j1939/socket.c:580
  __sock_release net/socket.c:590 [inline]
  sock_close+0xe1/0x260 net/socket.c:1268
  __fput+0x2e4/0x740 fs/file_table.c:280
  ____fput+0x15/0x20 fs/file_table.c:313
  task_work_run+0x17e/0x1b0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop arch/x86/entry/common.c:163 [inline]
  prepare_exit_to_usermode+0x459/0x580 arch/x86/entry/common.c:194
  syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:274
  do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888097f08000
  which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4224 bytes inside of
  8192-byte region [ffff888097f08000, ffff888097f0a000)
The buggy address belongs to the page:
page:ffffea00025fc200 refcount:1 mapcount:0 mapping:ffff8880aa4021c0  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000251a608 ffffea0002500e08 ffff8880aa4021c0
raw: 0000000000000000 ffff888097f08000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888097f08f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888097f09000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888097f09080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff888097f09100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888097f09180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

