Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32114250D9
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfEUNnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:43:08 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:39639 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfEUNnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:43:07 -0400
Received: by mail-it1-f200.google.com with SMTP id q13so2614268itk.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 06:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jLJejxO088kPkjN8PKszSE40ivieYqyEUzvvlokmejY=;
        b=CpdzqB3mHDvZD/7Zbg0W3vHAw6ctXNwe/JMcjsiVtI9doKoImE7dfyvwmA6UT2OC3+
         7OHy73ZdifiYqzkJkylXt07dCHlZyM2wrlm9zIaqt4TiIsfIPmcgZVtUJOSDEU18sES1
         fE9uVFAhdsQ5GO4GeISbtqkNbt60Tl5t7+GUEgrN9cg+us3LE2zbxz3J5s0KshrUJtiu
         1CsY/jLKJqazjk/GGpaXYUTJ5bopMLmZpZ5lVNv31F/I34z5vjhU9itHJZkqNkmrw942
         C5982oEsQIkKkyv/OQxWAT3NXvP+BVUZydPnQGoSlPMVZW7iUU6NG9Bc5odT4GSV6xOD
         8qCg==
X-Gm-Message-State: APjAAAVXTdhDtp1AHvge5JRqeLIyYGBuiVVC0REpLuLIguLXvBHb/6S5
        7rhbvA59iATS9xJBSHf9LE3TsbrmDUmQrc6dKDHYcTZUc66Y
X-Google-Smtp-Source: APXvYqzDwKRq8hBbdKNxthldB6WPxRa1GafVEA37fW2u9wbyF0o2kRigYXBprR2zZENPsg2K81IOhOteuf7vr+13X4iHamWY+8W5
MIME-Version: 1.0
X-Received: by 2002:a24:4d1:: with SMTP id 200mr3572102itb.92.1558446186523;
 Tue, 21 May 2019 06:43:06 -0700 (PDT)
Date:   Tue, 21 May 2019 06:43:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005974af0589660739@google.com>
Subject: memory leak in llc_conn_ac_send_sabme_cmd_p_set_x
From:   syzbot <syzbot+6b825a6494a04cc0e3f7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e4e228a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=6b825a6494a04cc0e3f7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bc3512a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10418252a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6b825a6494a04cc0e3f7@syzkaller.appspotmail.com

udit: type=1400 audit(1558393947.426:36): avc:  denied  { map } for   
pid=7313 comm="syz-executor559" path="/root/syz-executor559750539"  
dev="sda1" ino=16482 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023  
tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811eb3de00 (size 224):
   comm "syz-executor559", pid 7315, jiffies 4294943019 (age 10.300s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 a0 38 24 81 88 ff ff 00 c0 f2 15 81 88 ff ff  ..8$............
   backtrace:
     [<000000008d1c66a1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000008d1c66a1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000008d1c66a1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000008d1c66a1>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000447d9496>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<000000000cdbf82f>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000000cdbf82f>] llc_alloc_frame+0x66/0x110 net/llc/llc_sap.c:54
     [<000000002418b52e>] llc_conn_ac_send_sabme_cmd_p_set_x+0x2f/0x140  
net/llc/llc_c_ac.c:777
     [<000000001372ae17>] llc_exec_conn_trans_actions net/llc/llc_conn.c:475  
[inline]
     [<000000001372ae17>] llc_conn_service net/llc/llc_conn.c:400 [inline]
     [<000000001372ae17>] llc_conn_state_process+0x1ac/0x640  
net/llc/llc_conn.c:75
     [<00000000f27e53c1>] llc_establish_connection+0x110/0x170  
net/llc/llc_if.c:109
     [<00000000291b2ca0>] llc_ui_connect+0x10e/0x370 net/llc/af_llc.c:477
     [<000000000f9c740b>] __sys_connect+0x11d/0x170 net/socket.c:1840
     [<000000008a003fc2>] __do_sys_connect net/socket.c:1851 [inline]
     [<000000008a003fc2>] __se_sys_connect net/socket.c:1848 [inline]
     [<000000008a003fc2>] __x64_sys_connect+0x1e/0x30 net/socket.c:1848
     [<00000000b60c96dc>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000005e719825>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811b4b9a00 (size 512):
   comm "syz-executor559", pid 7315, jiffies 4294943019 (age 10.300s)
   hex dump (first 32 bytes):
     01 80 c2 00 00 00 00 00 00 00 00 00 00 03 00 05  ................
     7f 00 40 00 00 00 00 00 40 00 40 00 00 00 00 00  ..@.....@.@.....
   backtrace:
     [<00000000a87c3e1c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000a87c3e1c>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000a87c3e1c>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000a87c3e1c>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001c8b2279>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001c8b2279>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<00000000d33d0fcb>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:142
     [<00000000e52bad65>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:210
     [<000000000cdbf82f>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000000cdbf82f>] llc_alloc_frame+0x66/0x110 net/llc/llc_sap.c:54
     [<000000002418b52e>] llc_conn_ac_send_sabme_cmd_p_set_x+0x2f/0x140  
net/llc/llc_c_ac.c:777
     [<000000001372ae17>] llc_exec_conn_trans_actions net/llc/llc_conn.c:475  
[inline]
     [<000000001372ae17>] llc_conn_service net/llc/llc_conn.c:400 [inline]
     [<000000001372ae17>] llc_conn_state_process+0x1ac/0x640  
net/llc/llc_conn.c:75
     [<00000000f27e53c1>] llc_establish_connection+0x110/0x170  
net/llc/llc_if.c:109
     [<00000000291b2ca0>] llc_ui_connect+0x10e/0x370 net/llc/af_llc.c:477
     [<000000000f9c740b>] __sys_connect+0x11d/0x170 net/socket.c:1840
     [<000000008a003fc2>] __do_sys_connect net/socket.c:1851 [inline]
     [<000000008a003fc2>] __se_sys_connect net/socket.c:1848 [inline]
     [<000000008a003fc2>] __x64_sys_connect+0x1e/0x30 net/socket.c:1848
     [<00000000b60c96dc>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000005e719825>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811eb3da00 (size 224):
   comm "softirq", pid 0, jiffies 4294943120 (age 9.290s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 a0 38 24 81 88 ff ff 00 c0 f2 15 81 88 ff ff  ..8$............
   backtrace:
     [<000000008d1c66a1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000008d1c66a1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000008d1c66a1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000008d1c66a1>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000447d9496>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<000000000cdbf82f>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000000cdbf82f>] llc_alloc_frame+0x66/0x110 net/llc/llc_sap.c:54
     [<000000002418b52e>] llc_conn_ac_send_sabme_cmd_p_set_x+0x2f/0x140  
net/llc/llc_c_ac.c:777
     [<000000001372ae17>] llc_exec_conn_trans_actions net/llc/llc_conn.c:475  
[inline]
     [<000000001372ae17>] llc_conn_service net/llc/llc_conn.c:400 [inline]
     [<000000001372ae17>] llc_conn_state_process+0x1ac/0x640  
net/llc/llc_conn.c:75
     [<00000000992b281d>] llc_process_tmr_ev net/llc/llc_c_ac.c:1441 [inline]
     [<00000000992b281d>] llc_conn_tmr_common_cb+0xe0/0x1b0  
net/llc/llc_c_ac.c:1327
     [<000000004f6c55dd>] llc_conn_ack_tmr_cb+0x1e/0x30  
net/llc/llc_c_ac.c:1350
     [<00000000193fb32d>] call_timer_fn+0x45/0x1e0 kernel/time/timer.c:1322
     [<0000000053c16cfc>] expire_timers kernel/time/timer.c:1366 [inline]
     [<0000000053c16cfc>] __run_timers kernel/time/timer.c:1685 [inline]
     [<0000000053c16cfc>] __run_timers kernel/time/timer.c:1653 [inline]
     [<0000000053c16cfc>] run_timer_softirq+0x256/0x740  
kernel/time/timer.c:1698
     [<000000008e2ef06a>] __do_softirq+0x115/0x35e kernel/softirq.c:293
     [<00000000454b734b>] invoke_softirq kernel/softirq.c:374 [inline]
     [<00000000454b734b>] irq_exit+0xbb/0xe0 kernel/softirq.c:414
     [<000000007efb1950>] exiting_irq arch/x86/include/asm/apic.h:536  
[inline]
     [<000000007efb1950>] smp_apic_timer_interrupt+0x7b/0x170  
arch/x86/kernel/apic/apic.c:1067
     [<0000000049ee97a9>] apic_timer_interrupt+0xf/0x20  
arch/x86/entry/entry_64.S:806
     [<00000000d4cf6e4f>] native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60
     [<000000000074c20d>] arch_cpu_idle+0xa/0x10  
arch/x86/kernel/process.c:571
     [<0000000053e88ad1>] default_idle_call+0x1e/0x40 kernel/sched/idle.c:93

executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
