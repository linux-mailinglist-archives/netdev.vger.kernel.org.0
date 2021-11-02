Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF39E442900
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhKBH7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 03:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhKBH7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 03:59:34 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC67C061714;
        Tue,  2 Nov 2021 00:56:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v20so14754558plo.7;
        Tue, 02 Nov 2021 00:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=P01u1Z2pTAc6NXbU7xAW5Y31omtvs1jeH++ZR+XDb3k=;
        b=JvTNRTkdjuqN2xV1shdKDXH13JJf+4etgglDmAEN7lXvIym+ZhF1kDyqWUz2U1FEVu
         hAGVZNqxrz1P6sbsfH2PJCF/UCtljS4UlH2kFASqiW0cVxVe6KKzSV0Al+cwebvfLrKQ
         VvCTT+j23m7reKmhjKoeTyAiWxgljbAnlXNhFaH+UBLM1XpS3BzpECWugmAAjuJVdZIH
         vi99LWL0OYLy4mJVwsoaJAW+VkNNxeaeDL9+X3NyO/csUU3hXlb1ihqmOt6DbBjGEKcQ
         QovsaQHHvfWUM39cFmWZEvoXpX6ZfLtgQz8hqfvHi7x5t6EmA6mmdvX6C05oJdL4I4T2
         Lk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=P01u1Z2pTAc6NXbU7xAW5Y31omtvs1jeH++ZR+XDb3k=;
        b=rM/Dd6ZJMaRGiPWNpeQzh8hSsmyZVn0rpVuCRUAVwtwKiHpS+AlfFwUmDpx99bvsIm
         ijBQwXWRuOS+Yghn6PnOWx9Mjyz9RmyroNKuGWz0nMJKczFgeGotPLQgRUhDBpF2+5K5
         0P6SLwkNOaKsf0S+vKwJJcxHYvIcrJhVtGQ5ciBNY2eikKXvfiz/PR1ildO9Rvnp6OgT
         RbVbMscbT4zUQ/HAJ7VjNAcyaqc7SgPB+uiVAJjTl7BK3g5yapWD2UhyfRZJfBvo53Ks
         oeUdTi6UYUQKqKYP8I1huXLOOT3SLpRT2iDonI3sEElwBueK7oKbrgci6CL4LAPpkBo+
         yeQw==
X-Gm-Message-State: AOAM532kH5GVQAPOj5rKMof2E51a+YbteAWf8/C4Y7tnBUv919/6uZjp
        z+scbuAOP3Gdx5BaPwRSTjUPYmvmED2NCUyf4lx23fZi9rYxaug=
X-Google-Smtp-Source: ABdhPJw10+wVR8EG6gzyeEhwDA5giNRx9gNibX+Z9l3Xqc39FTDrS+ZDZrfO6jQ8rDmHXqinzbRXwuNVCjJmnLgAhjI=
X-Received: by 2002:a17:90a:6b0b:: with SMTP id v11mr4883334pjj.178.1635839818783;
 Tue, 02 Nov 2021 00:56:58 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Tue, 2 Nov 2021 15:56:47 +0800
Message-ID: <CACkBjsYs8NYWe2Gue8bW5qo6uU_X=JwugPCQTx30+_Dwp0gfbA@mail.gmail.com>
Subject: WARNING: locking bug in do_ipv6_setsockopt
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: f25a5481af12 Merge tag 'libnvdimm-fixes-5.15-rc8'
git tree: upstream
console output: https://paste.ubuntu.com/p/nk3R6rmF8j/
kernel config: https://paste.ubuntu.com/p/ygjjwKn86x/

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7252 at kernel/locking/lockdep.c:897
look_up_lock_class.isra.0+0x6c/0xe0 kernel/locking/lockdep.c:897
Modules linked in:
CPU: 0 PID: 7252 Comm: syz-executor Not tainted 5.15.0-rc7+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:look_up_lock_class.isra.0+0x6c/0xe0 kernel/locking/lockdep.c:897
Code: 48 85 c0 75 0a eb 59 48 8b 00 48 85 c0 74 51 48 3b 50 40 75 f2
48 8b 0e 48 39 88 b0 00 00 00 74 41 48 81 3f 40 e4 ef 8e 74 38 <0f> 0b
48 83 c4 08 c3 9c 59 80 e5 02 74 c0 e8 91 47 ac fa 85 c0 74
RSP: 0018:ffffc90007f2f728 EFLAGS: 00010006
RAX: ffffffff8fd48380 RBX: ffffffff902488e0 RCX: ffffffff8aa6dfe0
RDX: ffffffff905bf3c0 RSI: ffff8880127b38b8 RDI: ffff8880127b38a0
RBP: ffff8880127b38a0 R08: 0000000000000001 R09: 0000000000000000
R10: ffff888063e32a0b R11: ffffed100c7c6541 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8880127b38b8 R15: 1ffff92000fe5eef
FS: 00007f7d8ac4c700(0000) GS:ffff888063e00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000001d598000 CR4: 0000000000350ef0
Call Trace:
register_lock_class+0xc4/0x1950 kernel/locking/lockdep.c:1246
__lock_acquire+0x106/0x57e0 kernel/locking/lockdep.c:4894
lock_acquire kernel/locking/lockdep.c:5625 [inline]
lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
__raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
_raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:178
spin_lock_bh include/linux/spinlock.h:368 [inline]
lock_sock_nested+0x5d/0xf0 net/core/sock.c:3206
lock_sock include/net/sock.h:1615 [inline]
do_ipv6_setsockopt.isra.0+0x30b/0x4260 net/ipv6/ipv6_sockglue.c:418
ipv6_setsockopt+0x113/0x190 net/ipv6/ipv6_sockglue.c:1003
udpv6_setsockopt+0x76/0xc0 net/ipv6/udp.c:1647
__sys_setsockopt+0x2db/0x610 net/socket.c:2176
__do_sys_setsockopt net/socket.c:2187 [inline]
__se_sys_setsockopt net/socket.c:2184 [inline]
__x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7d8d6e3c4d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7d8ac4bc58 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f7d8d80a0a0 RCX: 00007f7d8d6e3c4d
RDX: 0000000000000036 RSI: 0000000000000029 RDI: 0000000000000005
RBP: 00007f7d8d75cd80 R08: 0000000000000008 R09: 0000000000000000
R10: 00000000200000c0 R11: 0000000000000246 R12: 00007f7d8d80a0a0
R13: 00007ffcb83da37f R14: 00007ffcb83da520 R15: 00007f7d8ac4bdc0
