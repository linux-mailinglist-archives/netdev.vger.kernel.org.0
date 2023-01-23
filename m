Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E858677742
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjAWJTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbjAWJTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:19:08 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119D813D76;
        Mon, 23 Jan 2023 01:19:08 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id v6so5688640ilq.3;
        Mon, 23 Jan 2023 01:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=khbEyLQVzE+wEgtx4xTJNiAeXhs9nRut8aUoBD868I4=;
        b=c5CCjblE7nqmKdY2/9z9j+8xM213QIM8+77v4+/hLB3r6tGuhE6Dz9ESZKrkBTtCUs
         GeaM3CXq3ic+V4UiJqOYGkjMcauo+Yj4bxRvdaQPlVWopNUUDLGQpxTD3u71cJZR6I7T
         va5/jkgO4k/sgyAyKgDUDFeUogsJ/Yxdtr1mC4YiSvdQh/VywnU5+ERFhYpiudO3M1GW
         Q3VU2j/56mzbk8rkkQ6rY670pCPCOxcRwOVAFB4daLKOa9CjiWBiImtKLGw2/0CSiKNE
         iWlNeqmWoxGulN8un4DfKJMLV3VYCIvE/N9mmuaIdozVab8fItWQqxFeJge5PjvUzSOF
         /Y3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=khbEyLQVzE+wEgtx4xTJNiAeXhs9nRut8aUoBD868I4=;
        b=R8AtiV/xUY1VZQifggkwhh41K2gBKjDzRTrfUOG53VVt7xjazwNp4hMV0N/H+jG7Fg
         MspwQPFW1YOPSR6HYlffop98VZptGelf9COhyJ2awRQQfQpXJ+z1lpDL8tpBPlgzOjSD
         WVM9he8SRybhY0xek8XBtoSwuldCU9vMJH0Jhzo3uDdNZv4+qbnBHpYuoGu0Y3Dw0QmM
         3F9y9B3+Ae8MVV2WPB4rb713VO0d+j9s2Y75b46A2Pq9Mty3kCBfSWkCx11FWxvvLCSm
         bX5VBCtUx7C/z/Uk750eCp4Hl1so6yG1ZcwEDPtCllK6JFi0TYMwefsLK2N1iYLiLrqG
         au0g==
X-Gm-Message-State: AFqh2kpAGTdM8W/55b1ZroYN8NvEWoEcfX4RCHDm7CQ9dFHB7n8io+7Z
        rpxbbqanDZaoeRFTSLYUbNA=
X-Google-Smtp-Source: AMrXdXvHdP4NczA/igMGEEpX6VwKUZSVKU5LDJyYypxGA3qxDRcW+ssoSEIwPM9ZiuhZGygXpEq3jw==
X-Received: by 2002:a92:ce8f:0:b0:30f:48ea:3554 with SMTP id r15-20020a92ce8f000000b0030f48ea3554mr10222882ilo.16.1674465547351;
        Mon, 23 Jan 2023 01:19:07 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id l18-20020a02ccf2000000b003a5f25b1888sm5575587jaq.35.2023.01.23.01.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:19:06 -0800 (PST)
From:   Sungwoo Kim <happiness.sung.woo@gmail.com>
X-Google-Original-From: Sungwoo Kim <git@sung-woo.kim>
Cc:     wuruoyu@me.com, benquike@gmail.com, daveti@purdue.edu,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: Bluetooth: L2cap: use-after-free in l2cap_sock_kill
Date:   Mon, 23 Jan 2023 04:17:09 -0500
Message-Id: <20230123091708.4112735-1-git@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a racy bug between l2cap_chan_timeout() and l2cap_sock_release()
cause by SIGKILL.
Sorry for the less context and no fix here.
For the l2cap_sock.c in the stack trace, please refer this file
for your convenience:
https://gist.github.com/swkim101/5c3b8cb7c7d7172aef23810c9412f323

This is discovered by FuzzBT on top of Syzkaller with Sungwoo Kim (me).
Other contributors for FuzzBT project are Ruoyu Wu(wuruoyu@me.com)
and Hui Peng(benquike@gmail.com).

==================================================================
BUG: KASAN: use-after-free in l2cap_sock_kill (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/sock.h:986 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1281) 
Read of size 8 at addr ffff88800f7f4060 by task l2cap-server/1764
CPU: 0 PID: 1764 Comm: l2cap-server Not tainted 6.1.0-rc2 #129
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
dump_stack_lvl (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/lib/dump_stack.c:105) 
print_address_description+0x7e/0x360 
print_report (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:187 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:389) 
? __virt_addr_valid (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/mmzone.h:1855 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/mm/physaddr.c:65) 
? kasan_complete_mode_report_info (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report_generic.c:104 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report_generic.c:127 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report_generic.c:136) 
? l2cap_sock_kill (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/sock.h:986 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1281) 
kasan_report (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:? /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/report.c:484) 
? l2cap_sock_kill (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/sock.h:986 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1281) 
kasan_check_range (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:85 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:115 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:128 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:159 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:180 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:189) 
__kasan_check_read (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/shadow.c:31) 
l2cap_sock_kill (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/sock.h:986 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1281) 
l2cap_sock_teardown_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/bluetooth/bluetooth.h:304 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1475 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1612) 
l2cap_chan_close (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:885) 
? __kasan_check_write (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/shadow.c:37) 
l2cap_sock_shutdown (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/kcsan-checks.h:231 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/sock.h:2470 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1321 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1377) 
? _raw_write_unlock (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/asm-generic/qrwlock.h:122 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/rwlock_api_smp.h:225 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/locking/spinlock.c:342) 
l2cap_sock_release (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1453) 
sock_close (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/socket.c:1382) 
? sock_mmap (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/socket.c:?) 
__fput (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/fsnotify.h:? /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/fsnotify.h:99 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/fsnotify.h:341 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/fs/file_table.c:306) 
____fput (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/fs/file_table.c:348) 
task_work_run (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/task_work.c:165) 
do_exit (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/exit.c:?) 
do_group_exit (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/exit.c:943) 
? __kasan_check_write (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/shadow.c:37) 
get_signal (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/signal.c:2863) 
? _raw_spin_unlock (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/spinlock_api_smp.h:142 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/locking/spinlock.c:186) 
? finish_task_switch (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./arch/x86/include/asm/current.h:15 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/sched/core.c:5065) 
arch_do_signal_or_restart (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/kernel/signal.c:869) 
exit_to_user_mode_prepare (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/entry/common.c:383) 
syscall_exit_to_user_mode (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./arch/x86/include/asm/current.h:15 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/entry/common.c:261 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/entry/common.c:283 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/entry/common.c:296) 
do_syscall_64 (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/common.c:50 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/common.c:80) 
? sysvec_apic_timer_interrupt (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/kernel/apic/apic.c:1107) 
entry_SYSCALL_64_after_hwframe (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/entry_64.S:120) 
RIP: 0033:0x7f66c14db970
Code: Unable to access opcode bytes at 0x7f66c14db946.

Code starting with the faulting instruction
===========================================
RSP: 002b:00007ffe166a5508 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: 0000000000000013 RBX: 0000000000000013 RCX: 00007f66c14db970
RDX: 0000000000000013 RSI: 00007ffe166a56d0 RDI: 0000000000000002
RBP: 00007ffe166a56d0 R08: 00007f66c1a28440 R09: 0000000000000013
R10: 0000000000000078 R11: 0000000000000246 R12: 0000000000000013
R13: 0000000000000001 R14: 00007f66c179a520 R15: 0000000000000013
 </TASK>
Allocated by task 77:
kasan_set_track (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:51) 
kasan_save_alloc_info (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:432 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:498) 
__kasan_kmalloc (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:356) 
__kmalloc (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slab_common.c:943 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slab_common.c:968) 
sk_prot_alloc (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/sock.c:2028) 
sk_alloc (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/sock.c:2083) 
l2cap_sock_alloc (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1903) 
l2cap_sock_new_connection_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1504) 
l2cap_connect (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:102 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:4277) 
l2cap_bredr_sig_cmd (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:5634 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:5927) 
l2cap_recv_frame (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:7851 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:7919) 
l2cap_recv_acldata (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:8601 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:8631) 
hci_rx_work (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/bluetooth/hci_core.h:1121 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/hci_core.c:3937 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/hci_core.c:4189) 
process_one_work (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2225) 
worker_thread (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:816 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2107 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2159 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2408) 
kthread (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/kthread.c:361) 
ret_from_fork (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/entry_64.S:306) 
Freed by task 52:
kasan_set_track (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:51) 
kasan_save_free_info (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/generic.c:508) 
____kasan_slab_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/slub_def.h:164 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:214) 
__kasan_slab_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/kasan/common.c:244) 
slab_free_freelist_hook (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:381 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:1747) 
__kmem_cache_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:3656 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slub.c:3674) 
kfree (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/mm/slab_common.c:1007) 
__sk_destruct (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/cred.h:288 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/sock.c:2147) 
__sk_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/sock_diag.h:87 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/sock.c:2175) 
sk_free (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/instrumented.h:? /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/atomic/atomic-instrumented.h:176 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/refcount.h:272 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/refcount.h:315 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/linux/refcount.h:333 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/core/sock.c:2188) 
l2cap_sock_kill (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/bluetooth/bluetooth.h:286 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1284) 
l2cap_sock_close_cb (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_sock.c:1576) 
l2cap_chan_timeout (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/./include/net/bluetooth/bluetooth.h:296 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/net/bluetooth/l2cap_core.c:462) 
process_one_work (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2225) 
worker_thread (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:816 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2107 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2159 /home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/workqueue.c:2408) 
kthread (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/kernel/kthread.c:361) 
ret_from_fork (/home/sungwoo/fuzzbt/v6.1-rc2-bzimage/arch/x86/entry/entry_64.S:306) 
The buggy address belongs to the object at ffff88800f7f4000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 96 bytes inside of
 1024-byte region [ffff88800f7f4000, ffff88800f7f4400)
The buggy address belongs to the physical page:
page:00000000b8d65c1d refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88800f7f6800 pfn:0xf7f4
head:00000000b8d65c1d order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffffc0010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0010200 ffffea0000993408 ffffea0000991308 ffff888005841dc0
raw: ffff88800f7f6800 0000000000080002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88800f7f3f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88800f7f3f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88800f7f4000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff88800f7f4080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88800f7f4100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
