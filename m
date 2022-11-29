Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E29A63BCE8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiK2J2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiK2J2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:28:36 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3130131F80
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:28:35 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id 13-20020a056e0216cd00b003023e8b7d03so11502489ilx.7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DwHYHMia3SWsCol0zN9hefpCR+EbC2cAXKhyYNd3Nv0=;
        b=HtLid0UlIyZc+gUlUexr+eSbUsQb1wIOsCS6PEROfBtPDpStb5928aP6HNntUr4q+4
         GFYApN2QqM1PxZA6Z+tftkJVt28PmDL/r1v+4TZtMXbTovEsTAZIQbJRGlGzUPoZMJaa
         78zq0WFB9YSTX7pXw4krLRMsO3lkMbD003fMNsHtd7bdQ688KP2nWRuG29usAcCsX9c+
         tKLVq9MCovyu2XG9S/jw35HgJdX3ubkEj0bhr2yxYCrfwiBmnRNhPWU2KeqO2NjHL9xk
         m+/XpnFW0shG1ZCUut2Au5R4MOOZQKNENknp5Fdg7ziuVfk85fHv17A1XVqFG/NiYTcw
         6VfA==
X-Gm-Message-State: ANoB5pn4XRjLse0edwEo83h335JWI9VicdOarcEKPgwLGr1dLaF2De4+
        JS36zFSnPt6ZHa67MCwLtfsTSsT44B3VDD22t/JUuuyUws/X
X-Google-Smtp-Source: AA0mqf4SlM8ZeHbB1FFBLv6NUjJCFRWfI2GPv7cccYZgGVE2lI1V1zt406ZHnpm7RPupUcg/iYBCP6IjCXRt7LgVhJ3S5L9rx0od
MIME-Version: 1.0
X-Received: by 2002:a92:7310:0:b0:302:571f:8d7f with SMTP id
 o16-20020a927310000000b00302571f8d7fmr25219913ilc.53.1669714114517; Tue, 29
 Nov 2022 01:28:34 -0800 (PST)
Date:   Tue, 29 Nov 2022 01:28:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ac218905ee989c07@google.com>
Subject: [syzbot] WARNING in batadv_nc_purge_paths
From:   syzbot <syzbot+5b817d9e3b5fb5f051fc@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pabeni@redhat.com, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
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

HEAD commit:    65762d97e6fa Merge branch 'for-next/perf' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1558f7fd880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56d0c7c3a2304e8f
dashboard link: https://syzkaller.appspot.com/bug?extid=5b817d9e3b5fb5f051fc
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/52f702197b30/disk-65762d97.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72189c2789ce/vmlinux-65762d97.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec0349196c98/Image-65762d97.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5b817d9e3b5fb5f051fc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3498 at kernel/softirq.c:376 __local_bh_enable_ip+0x180/0x1a4 kernel/softirq.c:376
Modules linked in:
CPU: 1 PID: 3498 Comm: kworker/u4:11 Not tainted 6.1.0-rc6-syzkaller-32653-g65762d97e6fa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: bat_events batadv_nc_worker

pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __local_bh_enable_ip+0x180/0x1a4 kernel/softirq.c:376
lr : __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:167 [inline]
lr : _raw_spin_unlock_bh+0x48/0x58 kernel/locking/spinlock.c:210
sp : ffff80001398bc60
x29: ffff80001398bc60
 x28: ffff80000d2fb000
 x27: ffff80000d2fb000

x26: 000000000000007e
 x25: 0000000000000004
 x24: 0000000000000000

x23: ffff0000f2dcdf80
 x22: 0000000000000000
 x21: ffff00011ed2b480

x20: ffff80000bf44c08
 x19: 0000000000000201
 x18: 0000000000000163

x17: ffff80000c0cd83c
 x16: ffff80000dbe6158
 x15: ffff00011ed2b480

x14: 00000000000000c8
 x13: 00000000ffffffff
 x12: ffff00011ed2b480

x11: ff808000095cfff8
 x10: 00000000ffffffff
 x9 : ffff80000d2d09a0

x8 : 0000000000000201
 x7 : ffff80000bf44a98
 x6 : 0000000000000000

x5 : 0000000000000000
 x4 : 0000000000000001
 x3 : 0000000000000000

x2 : 0000000000000001
 x1 : 0000000000000201
 x0 : ffff80000bf44c08

Call trace:
 __local_bh_enable_ip+0x180/0x1a4 kernel/softirq.c:376
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:167 [inline]
 _raw_spin_unlock_bh+0x48/0x58 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:395 [inline]
 batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
 batadv_nc_worker+0x3a8/0x484 net/batman-adv/network-coding.c:722
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 28503233
hardirqs last  enabled at (28503231): [<ffff800008106f78>] __local_bh_enable_ip+0x13c/0x1a4 kernel/softirq.c:401
hardirqs last disabled at (28503233): [<ffff80000c0809a4>] __el1_irq arch/arm64/kernel/entry-common.c:468 [inline]
hardirqs last disabled at (28503233): [<ffff80000c0809a4>] el1_interrupt+0x24/0x68 arch/arm64/kernel/entry-common.c:486
softirqs last  enabled at (28503230): [<ffff80000bf44c08>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (28503230): [<ffff80000bf44c08>] batadv_nc_purge_paths+0x1d0/0x214 net/batman-adv/network-coding.c:471
softirqs last disabled at (28503232): [<ffff80000bf44a98>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (28503232): [<ffff80000bf44a98>] batadv_nc_purge_paths+0x60/0x214 net/batman-adv/network-coding.c:442
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
