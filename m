Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCE3D01F8
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhGTSNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:13:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39644 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhGTSMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:12:50 -0400
Received: by mail-io1-f69.google.com with SMTP id v2-20020a5d94020000b02905058dc6c376so15990811ion.6
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 11:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=c29Zpmh2drA8z9f2QtsKjTAhAT7jxLXKxt7SJBDG2Jo=;
        b=ED39P6idL+U4p6bufhGEbQQlAH/0r+dIRGLxuDmzk4TH/tX8J+A378ymuGe3G5mZAx
         xBUpefnKlKgxnbJzPTU0DNevc2UeBYfd84vbWRh9X07MNae7toSRQ7jkCSYKsPuz21/n
         MKz4mKTnRo6jOhN7RlSTuC7jtfX8+KHOHe9hCWtIXLfYfJjCMp5f7Wd21LOm9cWh7jzk
         9NSq4YRuOBpL+C5trYe/udlNgvEk8uzu3A9W9jozDNdUy0Flh1oUAYD9ba5CBsXuvFms
         bsBXQgxN+IDjkNIdy5znBLg1D56gp4ZVP3A6VitGmBktOHhwtRTElaZm75afIcwEVv0t
         WLRg==
X-Gm-Message-State: AOAM533xnQ/q918OPhbxKNsWOM4SQOxmJJEXaZn6vGKYBsRZqDatzh9J
        UUKtfWVprTUweFqUA/S3KKJk2tXcN1p/xpybFdFkQzWaWvht
X-Google-Smtp-Source: ABdhPJyuuBSvc3bEeyJo8/ukJQWb+JSE1ZZZoNDNav3znZClfoY07Px7daak/CZAwkaykpim8yzoCWNddCanUtBC2tLUBIDotPJN
MIME-Version: 1.0
X-Received: by 2002:a92:dd82:: with SMTP id g2mr283024iln.279.1626807207540;
 Tue, 20 Jul 2021 11:53:27 -0700 (PDT)
Date:   Tue, 20 Jul 2021 11:53:27 -0700
In-Reply-To: <000000000000bd7c8a05c719ecf2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b93ea105c7929192@google.com>
Subject: Re: [syzbot] WARNING in internal_create_group
From:   syzbot <syzbot+9937dc42271cd87d4b98@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    8cae8cd89f05 seq_file: disallow extremely large seq buffer..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=116f92ec300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7273c75708b55890
dashboard link: https://syzkaller.appspot.com/bug?extid=9937dc42271cd87d4b98
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fc287c300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=178cbf6a300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9937dc42271cd87d4b98@syzkaller.appspotmail.com

RSP: 002b:00007ffd8de69d18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fa49
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000004
RBP: 00000000004034b0 R08: 0000000000000000 R09: 00000000004004a0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403540
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8435 at fs/sysfs/group.c:116 internal_create_group+0x911/0xb20 fs/sysfs/group.c:116
Modules linked in:
CPU: 0 PID: 8435 Comm: syz-executor570 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:internal_create_group+0x911/0xb20 fs/sysfs/group.c:116
Code: 0f 85 e8 f7 ff ff 41 bd ea ff ff ff e9 34 fd ff ff e8 53 3b 82 ff 48 8b 7c 24 08 e8 89 11 ff ff e9 20 fd ff ff e8 3f 3b 82 ff <0f> 0b 41 bd ea ff ff ff e9 0e fd ff ff e8 2d 3b 82 ff 48 8b 14 24
RSP: 0018:ffffc900010ff2a8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880284f0000 RSI: ffffffff81f34d91 RDI: 0000000000000003
RBP: ffff88801fd7b9a8 R08: 0000000000000000 R09: ffff88801fd7b9af
R10: ffffffff81f3453e R11: 0000000000000000 R12: 0000000000000000
R13: ffff8881455db770 R14: 0000000000000000 R15: ffff8881455db77c
FS:  0000000000990300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f56bbe93740 CR3: 000000001dd48000 CR4: 0000000000350ef0
Call Trace:
 blk_register_queue+0xda/0x570 block/blk-sysfs.c:871
 __device_add_disk+0x7b5/0xd10 block/genhd.c:529
 add_disk include/linux/genhd.h:217 [inline]
 nbd_dev_add+0x73f/0x940 drivers/block/nbd.c:1733
 nbd_genl_connect+0x551/0x1820 drivers/block/nbd.c:1842
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43fa49
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd8de69d18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 000000000043fa49
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000004
RBP: 00000000004034b0 R08: 0000000000000000 R09: 00000000004004a0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403540
R13: 0000000000000000 R14: 00000000004ad018 R15: 00000000004004a0

