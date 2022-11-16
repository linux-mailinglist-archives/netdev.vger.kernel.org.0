Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD5462BAF0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiKPLHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbiKPLGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:06:16 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28114D5E6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:38 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id k21-20020a5e8915000000b006de391b332fso2264534ioj.4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y/RJPsEgy0Rt4EiS/uq3Zj3pIjH/+R3or2rXQIcNyLg=;
        b=UHIydZTovfjHYkzGvlepNJmjUe7sIS63czzf28xnWL5JhVmv1X/ZhC0GKASX6ioYN9
         DTgqYgfkdH8Gcukj3uBOpUH7+K4mp4Fynn3GWtMJ3fgRMZ0qdZlNhzFsMLQUvufK7mS8
         YkkGcohXdeevuTrwJZ9ij1zTSQ6EmHfE6G3qOXVGF0gp/szUnlemZ6D9xTditKo3vtrV
         LIlTfQ+/hBcFWqVC/8KDP4i6l2KOFf2iTBMSlXLM4qD58dPZGIt7aY3RY5gj7C5Y37bF
         X/muvEsk8ewtrWaxlG6t4SCcxAQlwFr9UwpjBIylgZeqUYKWNHEr0CRqb/t6S541YQo+
         sg3w==
X-Gm-Message-State: ANoB5pmA3s4NCpWLA8evE9R3e1vgwut0/IjHl4TXvsGr0Sj2shZtrWkP
        xBqxPBG4Lz0zLrLExdaS4lvEAW71G36EWW7kQZR26/ZhIxQB
X-Google-Smtp-Source: AA0mqf762l6bpTs1z8M/zUr687r3QAwbb3QrIBWaUjqjxsm1qk+r15Dl1GrmCDeQ1rXDq7mKlM6Qcxy61tasg/GEbbVro3S7EJiQ
MIME-Version: 1.0
X-Received: by 2002:a6b:b343:0:b0:6d5:2f6e:834 with SMTP id
 c64-20020a6bb343000000b006d52f6e0834mr9766145iof.181.1668595958115; Wed, 16
 Nov 2022 02:52:38 -0800 (PST)
Date:   Wed, 16 Nov 2022 02:52:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b7a8005ed94455b@google.com>
Subject: [syzbot] WARNING in nci_send_cmd
From:   syzbot <syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    9500fc6e9e60 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16ebd49e880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b25c9f218686dd5e
dashboard link: https://syzkaller.appspot.com/bug?extid=43475bf3cfbd6e41f5b7
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150027ae880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141717ae880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1363e60652f7/disk-9500fc6e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fcc4da811bb6/vmlinux-9500fc6e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b554298f1fa/Image-9500fc6e.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3079 at kernel/workqueue.c:1438 is_chained_work kernel/workqueue.c:1382 [inline]
WARNING: CPU: 1 PID: 3079 at kernel/workqueue.c:1438 __queue_work+0x878/0x8b4 kernel/workqueue.c:1438
Modules linked in:
CPU: 1 PID: 3079 Comm: syz-executor103 Not tainted 6.1.0-rc5-syzkaller-32269-g9500fc6e9e60 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __queue_work+0x878/0x8b4 kernel/workqueue.c:1382
lr : is_chained_work kernel/workqueue.c:1382 [inline]
lr : __queue_work+0x878/0x8b4 kernel/workqueue.c:1438
sp : ffff80000ffcb710
x29: ffff80000ffcb710 x28: ffff0000c22b8000 x27: 0000000000000000
x26: ffff0000ca031a10 x25: ffff0000c22b8000 x24: 0000000000000100
x23: 0000000100000000 x22: 00000000000f000a x21: ffff0000ca152400
x20: 0000000000000008 x19: ffff0000cb1e20f8 x18: 00000000000001ac
x17: 0000000000000000 x16: ffff80000dc18158 x15: ffff0000c22b8000
x14: 00000000000000c0 x13: 00000000ffffffff x12: ffff0000c22b8000
x11: ff808000081306bc x10: 0000000000000000 x9 : ffff8000081306bc
x8 : ffff0000c22b8000 x7 : ffff80000b25d5e8 x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000cb1e20f8 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 is_chained_work kernel/workqueue.c:1382 [inline]
 __queue_work+0x878/0x8b4 kernel/workqueue.c:1438
 queue_work_on+0xb0/0x15c kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 nci_send_cmd+0xe8/0x154 net/nfc/nci/core.c:1376
 nci_reset_req net/nfc/nci/core.c:166 [inline]
 __nci_request net/nfc/nci/core.c:107 [inline]
 nci_open_device+0x168/0x518 net/nfc/nci/core.c:502
 nci_dev_up+0x20/0x30 net/nfc/nci/core.c:631
 nfc_dev_up+0xcc/0x1b0 net/nfc/core.c:118
 nfc_genl_dev_up+0x40/0x78 net/nfc/netlink.c:770
 genl_family_rcv_msg_doit net/netlink/genetlink.c:756 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
 genl_rcv_msg+0x458/0x4f4 net/netlink/genetlink.c:850
 netlink_rcv_skb+0xe8/0x1d4 net/netlink/af_netlink.c:2540
 genl_rcv+0x38/0x50 net/netlink/genetlink.c:861
 netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1319
 netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x2f8/0x440 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x1ac/0x228 net/socket.c:2565
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2572
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 42
hardirqs last  enabled at (41): [<ffff80000c0b7c04>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (41): [<ffff80000c0b7c04>] _raw_spin_unlock_irqrestore+0x48/0x8c kernel/locking/spinlock.c:194
hardirqs last disabled at (42): [<ffff80000812fd60>] queue_work_on+0x78/0x15c kernel/workqueue.c:1542
softirqs last  enabled at (8): [<ffff80000801c38c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (6): [<ffff80000801c358>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---
nci: __nci_request: wait_for_completion_interruptible_timeout failed 0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
