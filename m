Return-Path: <netdev+bounces-2287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99053700FC6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 22:34:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D375281C53
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 20:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53FD111E;
	Fri, 12 May 2023 20:34:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0227F4
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 20:34:49 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2486A10B
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:34:48 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-76984376366so1526042539f.3
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683923687; x=1686515687;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Jbdlq6Qh2gIvbCvuqqmkF7qyFanKC+s6l78ieWXaEQ=;
        b=cUUg5p0dCUfRteVZOBkR7QdijL+7maq9aqJ5dBzdgxzEGbfaBzNXsr0Qq6+10igNG8
         FcoYigDKtrpLjQXCXAqXOIpM9NvmcXakn7RcU1RClwOQceD00+3+n69Suaakv8Vd1AgV
         0ZyGr8s0EPmsShDLH6EiOrO/bzyQo6fQIjIaeoTO4HHC3SJNvVDz3ZoR9iQdw+D0/dUX
         9Gjo9V0Oog9ryFFNRC9e7jhRWFZ40By8Q7PcRyQqssRpLXpMNCpMFjfJBrCTQL+Z6/76
         +YxLWXnmfRbPTumF2aSeXCFksDUhWY6bguxbdWxS1lYElahvJNDDydWIu2GdaDWUWJqc
         t3Fg==
X-Gm-Message-State: AC+VfDy/gILged8FN8NZdUbjP/x9ngzSS7ziQfrlDpDN32FyZY7tbLi9
	oPRXbc90jAQCu07MlYsNc/JXHb1ebMXusLTUu9scJzouCiEI
X-Google-Smtp-Source: ACHHUZ75RRPVogNTRfUpjWWSirB/LfsHA7kwauVX9LwfzKRe4UnntCZBUDvPWYCdDrHdwQ/ZRl5xYQYoQCfxDj74PNDqKlzssjKS
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:b1d5:0:b0:40f:99ae:dba8 with SMTP id
 u21-20020a02b1d5000000b0040f99aedba8mr7589353jah.1.1683923687453; Fri, 12 May
 2023 13:34:47 -0700 (PDT)
Date: Fri, 12 May 2023 13:34:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000383da505fb8509b7@google.com>
Subject: [syzbot] [wireless?] memory leak in hwsim_new_radio_nl
From: syzbot <syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, johannes@sipsolutions.net, 
	kuba@kernel.org, kvalo@kernel.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    105131df9c3b Merge tag 'dt-fixes-6.4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1193dc92280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9562c0bfb72fa2
dashboard link: https://syzkaller.appspot.com/bug?extid=904ce6fbb38532d9795c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b4577c280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a9e29e280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/029c9c553eb9/disk-105131df.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c807843227d1/vmlinux-105131df.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dfce3441d47b/bzImage-105131df.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com

Warning: Permanently added '10.128.1.177' (ECDSA) to the list of known hosts.
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810e2ac920 (size 32):
  comm "syz-executor238", pid 4983, jiffies 4294944120 (age 14.000s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff815458a4>] kmalloc_trace+0x24/0x90 mm/slab_common.c:1057
    [<ffffffff830fc4fb>] kmalloc include/linux/slab.h:559 [inline]
    [<ffffffff830fc4fb>] hwsim_new_radio_nl+0x43b/0x660 drivers/net/wireless/virtual/mac80211_hwsim.c:5962
    [<ffffffff83f4aa6e>] genl_family_rcv_msg_doit.isra.0+0xee/0x150 net/netlink/genetlink.c:968
    [<ffffffff83f4ada7>] genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
    [<ffffffff83f4ada7>] genl_rcv_msg+0x2d7/0x430 net/netlink/genetlink.c:1065
    [<ffffffff83f49111>] netlink_rcv_skb+0x91/0x1e0 net/netlink/af_netlink.c:2546
    [<ffffffff83f4a118>] genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
    [<ffffffff83f4805b>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
    [<ffffffff83f4805b>] netlink_unicast+0x39b/0x4d0 net/netlink/af_netlink.c:1365
    [<ffffffff83f4852a>] netlink_sendmsg+0x39a/0x720 net/netlink/af_netlink.c:1913
    [<ffffffff83db5258>] sock_sendmsg_nosec net/socket.c:724 [inline]
    [<ffffffff83db5258>] sock_sendmsg+0x58/0xb0 net/socket.c:747
    [<ffffffff83db5817>] ____sys_sendmsg+0x397/0x430 net/socket.c:2503
    [<ffffffff83db9e08>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2557
    [<ffffffff83db9fac>] __sys_sendmsg+0x8c/0x100 net/socket.c:2586
    [<ffffffff84a127b9>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84a127b9>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810e2ac800 (size 32):
  comm "syz-executor238", pid 4984, jiffies 4294944700 (age 8.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff815458a4>] kmalloc_trace+0x24/0x90 mm/slab_common.c:1057
    [<ffffffff830fc4fb>] kmalloc include/linux/slab.h:559 [inline]
    [<ffffffff830fc4fb>] hwsim_new_radio_nl+0x43b/0x660 drivers/net/wireless/virtual/mac80211_hwsim.c:5962
    [<ffffffff83f4aa6e>] genl_family_rcv_msg_doit.isra.0+0xee/0x150 net/netlink/genetlink.c:968
    [<ffffffff83f4ada7>] genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
    [<ffffffff83f4ada7>] genl_rcv_msg+0x2d7/0x430 net/netlink/genetlink.c:1065
    [<ffffffff83f49111>] netlink_rcv_skb+0x91/0x1e0 net/netlink/af_netlink.c:2546
    [<ffffffff83f4a118>] genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
    [<ffffffff83f4805b>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
    [<ffffffff83f4805b>] netlink_unicast+0x39b/0x4d0 net/netlink/af_netlink.c:1365
    [<ffffffff83f4852a>] netlink_sendmsg+0x39a/0x720 net/netlink/af_netlink.c:1913
    [<ffffffff83db5258>] sock_sendmsg_nosec net/socket.c:724 [inline]
    [<ffffffff83db5258>] sock_sendmsg+0x58/0xb0 net/socket.c:747
    [<ffffffff83db5817>] ____sys_sendmsg+0x397/0x430 net/socket.c:2503
    [<ffffffff83db9e08>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2557
    [<ffffffff83db9fac>] __sys_sendmsg+0x8c/0x100 net/socket.c:2586
    [<ffffffff84a127b9>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84a127b9>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

