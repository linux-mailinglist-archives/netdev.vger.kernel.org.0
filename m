Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90F86F2294
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 05:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347206AbjD2DLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 23:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjD2DLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 23:11:51 -0400
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516581FD0
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 20:11:49 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7639ebbef32so70688139f.2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 20:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682737908; x=1685329908;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YD2i4IPlwbK4zPwgM4t3+h9xw/jbTfupJpZlr6kcoHs=;
        b=lwGU/y/k77HyXimfYpyDijL3wegG2fgG7DaNut1I7mNsw8pzPqVISPV87ExQABmywd
         OgMWtgVHtW+PsENmWf2IiPvd839nrswKdVlFId+vZXRkf2ygxl2NF/d2tUXHxf5YhVKL
         8vJaMayEvJmzdwv1ES/UkjgTbBOsUNnl09joB4G9Q/Z37fsMJkIm9butg7uEZ6Sq6fVo
         c1tDWw9pUeiJ7c0P4ZFCjxQTjaHN0BesuIQeQVwI7CWeaY8MSyJ/u4tkxz8BOAzlSIDq
         3qf2sK+Ml70pBLV87J/2N51spbMp1y8rgYsbaYopsdR7yBdPLGFvl6X5iBL1/SaHCsuh
         fTjQ==
X-Gm-Message-State: AC+VfDwk9P8i/0so5k06ptI0wjwmZ/W4ogS67tWCYSpYqmldaTYfUmgt
        cYcrVzBVwLAKZu2vACtzMEZJZaxc/9/rXH/PtgZzksxeerk+
X-Google-Smtp-Source: ACHHUZ7QAUwhyObclYFAuRIVRAvxlvqji4eWGadx8L2GQtt9fl2o0Ki6oOm01GszjRYE56r2iKlNqIyLxubeJKapH4cr7I3MsY/2
MIME-Version: 1.0
X-Received: by 2002:a6b:d004:0:b0:762:f8d4:6fe with SMTP id
 x4-20020a6bd004000000b00762f8d406femr3817314ioa.3.1682737908657; Fri, 28 Apr
 2023 20:11:48 -0700 (PDT)
Date:   Fri, 28 Apr 2023 20:11:48 -0700
In-Reply-To: <0000000000009ff60505e2fab2e6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004bb41105fa70f361@google.com>
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in ethnl_set_linkmodes (2)
From:   syzbot <syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    81af97bdef5e printk: Export console trace point for kcsan/..
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10d4b844280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee7e125556b25104
dashboard link: https://syzkaller.appspot.com/bug?extid=ef6edd9f1baaa54d6235
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1543bf0c280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158f4664280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/00b0f311889c/disk-81af97bd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a3291e9cce5a/vmlinux-81af97bd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/09b5e66af8b4/bzImage-81af97bd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
BUG: KMSAN: uninit-value in ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
 ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
 ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
 ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
 genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
 __sys_sendmsg net/socket.c:2584 [inline]
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 tun_get_link_ksettings+0x37/0x60 drivers/net/tun.c:3544
 __ethtool_get_link_ksettings+0x17b/0x260 net/ethtool/ioctl.c:441
 ethnl_set_linkmodes+0xee/0x19d0 net/ethtool/linkmodes.c:327
 ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
 genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
 genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
 __sys_sendmsg net/socket.c:2584 [inline]
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 tun_set_link_ksettings+0x37/0x60 drivers/net/tun.c:3553
 ethtool_set_link_ksettings+0x600/0x690 net/ethtool/ioctl.c:609
 __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
 dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
 dev_ioctl+0xb07/0x1270 net/core/dev_ioctl.c:524
 sock_do_ioctl+0x295/0x540 net/socket.c:1213
 sock_ioctl+0x729/0xd90 net/socket.c:1316
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x222/0x400 fs/ioctl.c:856
 __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Local variable link_ksettings created at:
 ethtool_set_link_ksettings+0x54/0x690 net/ethtool/ioctl.c:577
 __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
 dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078

CPU: 1 PID: 4952 Comm: syz-executor743 Not tainted 6.3.0-syzkaller-g81af97bdef5e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
