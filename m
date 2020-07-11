Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B448521C57D
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 19:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgGKRYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 13:24:18 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:44615 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbgGKRYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 13:24:18 -0400
Received: by mail-il1-f198.google.com with SMTP id x2so5992689ila.11
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 10:24:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IeGXPwtj2lsocZhYj09imRNrIavWv4B/gviXUgmP6a4=;
        b=uOS+h2GR2WS8xk86mmiF48inCu0IzxxILYtbO23NbhEnowdE8fSFn25HQQ0hU79vZ1
         OxI6fC2DAec+B/ygN9A95cSSy8j1fg0aFni3gvQ2CvpYwwGbPa2LBS7WiwiC+9oG6JNd
         HSZ2Xq2Xxk9qPIT87HnYw0Fq0IUYkX8ilV29serUdp9/yxM/WgLyfciIRU4+dlnVmfoc
         2r3enLho5GWY1i5CIC6dhPq5O4+2tLiIWSc+6MsvzjVxLEm+lQ4tZS097TCWiAkT5qnO
         OE1Hf3CXTBwz1B+60EPZypUWhxwyNY6bBRs/9wFUoLXUcp0v8sYx4n1ei00n1MiTBdrr
         nSKg==
X-Gm-Message-State: AOAM532HZKHxIIqFFbnreHv1mIzZ1iDgkX8EXrYkvFh402KF/FZoEJdP
        Bbsitkzvx+f815EEmwERsYl86KMALFCyB2O3CjzdIwgGx2xp
X-Google-Smtp-Source: ABdhPJxaO1pCSySsaIduXc9iXrSEjRgRRv4V2aSfFjff9Q2pVX2H9MA/gZA7sif7lcNU5fsE2CTGnmSeDJcub/k2Df8CHeVubeIF
MIME-Version: 1.0
X-Received: by 2002:a92:5fc7:: with SMTP id i68mr16491282ill.126.1594488257247;
 Sat, 11 Jul 2020 10:24:17 -0700 (PDT)
Date:   Sat, 11 Jul 2020 10:24:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c01a305aa2dba34@google.com>
Subject: INFO: trying to register non-static key in addrconf_notify
From:   syzbot <syzbot+bf9c23e0afdec81d9470@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102d01a3100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=bf9c23e0afdec81d9470
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bf9c23e0afdec81d9470@syzkaller.appspotmail.com

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 317 Comm: kworker/u4:6 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 register_lock_class+0xf06/0x1520 kernel/locking/lockdep.c:893
 __lock_acquire+0x102/0x2c30 kernel/locking/lockdep.c:4259
 lock_acquire+0x160/0x720 kernel/locking/lockdep.c:4959
 __raw_write_lock_bh include/linux/rwlock_api_smp.h:203 [inline]
 _raw_write_lock_bh+0x31/0x40 kernel/locking/spinlock.c:319
 addrconf_ifdown+0x5f8/0x1670 net/ipv6/addrconf.c:3734
 addrconf_notify+0x3f9/0x3a60 net/ipv6/addrconf.c:3602
 notifier_call_chain kernel/notifier.c:83 [inline]
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:2027 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2039 [inline]
 call_netdevice_notifiers net/core/dev.c:2053 [inline]
 rollback_registered_many+0xbe3/0x14a0 net/core/dev.c:8968
 unregister_netdevice_many+0x46/0x260 net/core/dev.c:10113
 ip6gre_exit_batch_net+0x435/0x460 net/ipv6/ip6_gre.c:1608
 ops_exit_list net/core/net_namespace.c:189 [inline]
 cleanup_net+0x79c/0xba0 net/core/net_namespace.c:603
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
