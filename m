Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0796F45580D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245161AbhKRJe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:34:28 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:57049 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243529AbhKRJe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:34:26 -0500
Received: by mail-io1-f69.google.com with SMTP id r199-20020a6b2bd0000000b005e234972ddfso3169930ior.23
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 01:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WkXPHSDdF1/3uLg3WzVhRO8Ez4oXsew4MO68MI5bYBw=;
        b=jAxlF5pv19LhBVLeJ7MP6frqQ6Fwt9tTP48TDiADnbvgNqIoRVR+vqUsxqjWGhUuwg
         jbKy71Y0eqem5oTOEJ090b0iZ+Qtg6HKw/Aljxf3nNhvMuLzTUNjrnl0DgiNaZq64OJU
         nDh2ROOq5hXFH5me9gBrJILdO4qGJQp389LEKyvwu/NNGvUDSzYToQFiPUkkowksSgmt
         eLXgp0L6qKsJQh3RxvoG8Jjta55xIgHEkk2ar2vGyIWf/yG7IbLzEMhEUlMqlF+xZy0D
         4yjyBGDaG51pXnd4I5vKw8jdibDn1CsOJEuWAa/5CWTBl3qqZxRVCbFuqe3ag7z0RkTK
         UqWg==
X-Gm-Message-State: AOAM532dRAx/hDGUPzEl3QJVDES8ArzYKMZx3IXCFPjI/SaSPwrN00LJ
        jxISW0KDg4sS1b88pXuVogL21RDpO2l3WDvMuwJ96iYca2I9
X-Google-Smtp-Source: ABdhPJzDlXBCvYsnc0HSMfL9ECwM5IDifVksfqYDpVp4pU6koI0n8kWLUV9BFkj1rma2pBpTFH++Qo5fc/gIe2LcW91j2Q/X08yO
MIME-Version: 1.0
X-Received: by 2002:a02:1949:: with SMTP id b70mr19221470jab.7.1637227886297;
 Thu, 18 Nov 2021 01:31:26 -0800 (PST)
Date:   Thu, 18 Nov 2021 01:31:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009448bd05d10cd2bc@google.com>
Subject: [syzbot] WARNING: refcount bug in nsim_destroy
From:   syzbot <syzbot+0d65c9e2e3bcb8873be4@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    66f4beaa6c1d Merge branch 'linus' of git://git.kernel.org/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15ff99c6b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a262045c4c15a9e0
dashboard link: https://syzkaller.appspot.com/bug?extid=0d65c9e2e3bcb8873be4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d65c9e2e3bcb8873be4@syzkaller.appspotmail.com

netdevsim netdevsim4 netdevsim2 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 1 PID: 13920 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 1 PID: 13920 Comm: syz-executor.4 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 9e 9c 81 09 31 ff 89 de e8 6d 11 9d fd 84 db 75 e0 e8 84 0d 9d fd 48 c7 c7 60 cb e4 89 c6 05 7e 9c 81 09 01 e8 78 77 1c 05 <0f> 0b eb c4 e8 68 0d 9d fd 0f b6 1d 6d 9c 81 09 31 ff 89 de e8 38
RSP: 0018:ffffc90002d5f1e8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815f39c8 RDI: fffff520005abe2f
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ed79e R11: 0000000000000000 R12: 0000000000000001
R13: ffffc90002d5f330 R14: ffff88807c3545b0 R15: ffff888071c4a400
FS:  00007fa593aa9700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ca2c000 CR3: 000000003d640000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 dev_put include/linux/netdevice.h:4166 [inline]
 unregister_netdevice_many+0x12c9/0x1790 net/core/dev.c:11114
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:11011
 unregister_netdevice include/linux/netdevice.h:2989 [inline]
 nsim_destroy+0x3f/0x190 drivers/net/netdevsim/netdev.c:382
 __nsim_dev_port_del+0x191/0x250 drivers/net/netdevsim/dev.c:1429
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1442 [inline]
 nsim_dev_reload_destroy+0x12b/0x300 drivers/net/netdevsim/dev.c:1650
 nsim_dev_reload_down+0xdf/0x180 drivers/net/netdevsim/dev.c:964
 devlink_reload+0x53b/0x6b0 net/core/devlink.c:4042
 devlink_nl_cmd_reload+0x6ed/0x11d0 net/core/devlink.c:4163
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa596533ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa593aa9188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa596646f60 RCX: 00007fa596533ae9
RDX: 0000000000000000 RSI: 00000000200003c0 RDI: 0000000000000003
RBP: 00007fa59658df6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffed384289f R14: 00007fa593aa9300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
