Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2774C612FEE
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 06:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJaFnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 01:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiJaFnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 01:43:01 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DF9BF5B
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 22:42:38 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id n7-20020a056e02148700b002ffbfe5a9aeso9194088ilk.19
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 22:42:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzbA52sJDjFIyoI7T1NX6PoWiiHdclyrQvjiX+dCe0w=;
        b=3dHQ3N4n5g8ftrNGwR+GgSvIbce4w4gEhbaPzIgE66BLAnFfkk5W0INgZsZhSQeVSw
         bqk1BN4Yd2XA3g8hkNB8266GbpLh1oswJKIjd69SQDcO8QBPOYxQdPAuFPFf1BwM2SiB
         3UdQFrwsAcFXkptmF5efoAm3n5wsicOnyluOQvul9vhLQdTmcJEyMKKHpb9Xp2L0qw6a
         KhwVOhYv8FwuNP61NkyMrULbVQo9uA7n/XAdGpLliLqZP4nzBzIOjO9m0y0QY+Y/0Xev
         If5d9Nv8Sbhn9ioiLaceUuQOBj7QN51L1f0wpQ5IypEtTSU6wUmuj1Ie2+KEtGLefd0W
         eIHQ==
X-Gm-Message-State: ACrzQf28mXeQ6yaYl5hlAFDASbLBJIvzPKeAuFu+EomwZScdxr5wKlBT
        1pvDC8soajr5lmVHPrUsP2W2w0ZVeWR+2CArSTvMpw/foqsu
X-Google-Smtp-Source: AMsMyM5sBQZhX8eAVAtYIGSKzXZ0Ll9g1e+TyTHpiJj+GdE8rly+4c0MXh00VtslsI1cuEGyRpToJEPe62h7rE4vVzfbkWwqPiFc
MIME-Version: 1.0
X-Received: by 2002:a92:6b0e:0:b0:2ff:df3e:995b with SMTP id
 g14-20020a926b0e000000b002ffdf3e995bmr5828202ilc.193.1667194957717; Sun, 30
 Oct 2022 22:42:37 -0700 (PDT)
Date:   Sun, 30 Oct 2022 22:42:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039e9d105ec4e13ed@google.com>
Subject: [syzbot] WARNING in cancel_delayed_work_sync
From:   syzbot <syzbot+dd9906bb8e89b22b1be7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bbed346d5a96 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=131b44ac880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a4a45d2d827c1e
dashboard link: https://syzkaller.appspot.com/bug?extid=dd9906bb8e89b22b1be7
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8e91bc79312/disk-bbed346d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1cb3fb3b77e/vmlinux-bbed346d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd9906bb8e89b22b1be7@syzkaller.appspotmail.com

ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 25883 at lib/debugobjects.c:505 debug_print_object lib/debugobjects.c:502 [inline]
WARNING: CPU: 1 PID: 25883 at lib/debugobjects.c:505 debug_object_assert_init+0x144/0x198 lib/debugobjects.c:892
Modules linked in:
CPU: 1 PID: 25883 Comm: syz-executor.0 Not tainted 6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : debug_print_object lib/debugobjects.c:502 [inline]
pc : debug_object_assert_init+0x144/0x198 lib/debugobjects.c:892
lr : debug_print_object lib/debugobjects.c:502 [inline]
lr : debug_object_assert_init+0x144/0x198 lib/debugobjects.c:892
sp : ffff8000157f3ae0
x29: ffff8000157f3ae0 x28: ffff0000c55b1a80 x27: 0000000000000024
x26: ffff8000157f3be8 x25: ffff800008134bec x24: ffff0000c55b1a80
x23: ffff80000efab740 x22: ffff80000d30c000 x21: ffff80000f0a5000
x20: ffff80000bfff5b8 x19: ffff0000ca0749d0 x18: 00000000000000c0
x17: 203a657079742074 x16: ffff80000db49158 x15: ffff0000c55b1a80
x14: 0000000000000000 x13: 00000000ffffffff x12: 0000000000040000
x11: 0000000000003457 x10: ffff800012a3d000 x9 : db08ffd6148ab200
x8 : db08ffd6148ab200 x7 : ffff80000819545c x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000100000000 x0 : 0000000000000054
Call trace:
 debug_print_object lib/debugobjects.c:502 [inline]
 debug_object_assert_init+0x144/0x198 lib/debugobjects.c:892
 debug_timer_assert_init kernel/time/timer.c:792 [inline]
 debug_assert_init kernel/time/timer.c:837 [inline]
 del_timer+0x34/0x1a8 kernel/time/timer.c:1257
 try_to_grab_pending+0x84/0x54c kernel/workqueue.c:1275
 __cancel_work_timer+0x74/0x2ac kernel/workqueue.c:3119
 cancel_delayed_work_sync+0x24/0x38 kernel/workqueue.c:3301
 mgmt_index_removed+0x158/0x198 net/bluetooth/mgmt.c:8952
 hci_sock_bind+0x710/0xb1c net/bluetooth/hci_sock.c:1218
 __sys_bind+0x148/0x1b0 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __arm64_sys_bind+0x28/0x3c net/socket.c:1785
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
irq event stamp: 286
hardirqs last  enabled at (285): [<ffff80000bfc89b4>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (285): [<ffff80000bfc89b4>] _raw_spin_unlock_irqrestore+0x48/0x8c kernel/locking/spinlock.c:194
hardirqs last disabled at (286): [<ffff80000812cb28>] try_to_grab_pending+0xac/0x54c kernel/workqueue.c:1264
softirqs last  enabled at (264): [<ffff80000b1c7458>] spin_unlock_bh include/linux/spinlock.h:394 [inline]
softirqs last  enabled at (264): [<ffff80000b1c7458>] lock_sock_nested+0xc0/0xd8 net/core/sock.c:3400
softirqs last disabled at (262): [<ffff80000b1c7420>] spin_lock_bh include/linux/spinlock.h:354 [inline]
softirqs last disabled at (262): [<ffff80000b1c7420>] lock_sock_nested+0x88/0xd8 net/core/sock.c:3396
---[ end trace 0000000000000000 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 25883 at kernel/workqueue.c:635 set_work_data kernel/workqueue.c:635 [inline]
WARNING: CPU: 0 PID: 25883 at kernel/workqueue.c:635 clear_work_data kernel/workqueue.c:698 [inline]
WARNING: CPU: 0 PID: 25883 at kernel/workqueue.c:635 __cancel_work_timer+0x29c/0x2ac kernel/workqueue.c:3162
Modules linked in:
CPU: 0 PID: 25883 Comm: syz-executor.0 Tainted: G        W          6.0.0-rc7-syzkaller-18095-gbbed346d5a96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : set_work_data kernel/workqueue.c:635 [inline]
pc : clear_work_data kernel/workqueue.c:698 [inline]
pc : __cancel_work_timer+0x29c/0x2ac kernel/workqueue.c:3162
lr : set_work_data kernel/workqueue.c:635 [inline]
lr : clear_work_data kernel/workqueue.c:698 [inline]
lr : __cancel_work_timer+0x29c/0x2ac kernel/workqueue.c:3162
sp : ffff8000157f3bd0
x29: ffff8000157f3c10 x28: ffff0000c55b1a80 x27: 0000000000000024
x26: ffff8000157f3be8 x25: ffff800008134bec x24: ffff0000c55b1a80
x23: ffff000112628600 x22: 0000000000000000 x21: 0000001fffffffc0
x20: 0000000000000000 x19: ffff0000ca074988 x18: 00000000000000c0
x17: ffff80000dd0b198 x16: ffff80000db49158 x15: ffff0000c55b1a80
x14: 0000000000000000 x13: 00000000ffffffff x12: 0000000000040000
x11: 000000000001dc58 x10: ffff800012a3d000 x9 : ffff80000812e20c
x8 : 000000000001dc59 x7 : ffff80000813754c x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000002
x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 set_work_data kernel/workqueue.c:635 [inline]
 clear_work_data kernel/workqueue.c:698 [inline]
 __cancel_work_timer+0x29c/0x2ac kernel/workqueue.c:3162
 cancel_delayed_work_sync+0x24/0x38 kernel/workqueue.c:3301
 mgmt_index_removed+0x158/0x198 net/bluetooth/mgmt.c:8952
 hci_sock_bind+0x710/0xb1c net/bluetooth/hci_sock.c:1218
 __sys_bind+0x148/0x1b0 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __arm64_sys_bind+0x28/0x3c net/socket.c:1785
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:636
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
irq event stamp: 366
hardirqs last  enabled at (365): [<ffff80000bfb8138>] __exit_to_kernel_mode arch/arm64/kernel/entry-common.c:84 [inline]
hardirqs last  enabled at (365): [<ffff80000bfb8138>] exit_to_kernel_mode+0xe8/0x118 arch/arm64/kernel/entry-common.c:94
hardirqs last disabled at (366): [<ffff80000bfb5fbc>] el1_dbg+0x24/0x5c arch/arm64/kernel/entry-common.c:404
softirqs last  enabled at (360): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (289): [<ffff800008017c14>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:79
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
