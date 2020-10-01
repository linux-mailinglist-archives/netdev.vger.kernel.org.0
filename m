Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5096B27FD4D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbgJAK3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:29:18 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:55858 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731647AbgJAK3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:29:17 -0400
Received: by mail-io1-f77.google.com with SMTP id t187so3195891iof.22
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 03:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QxfnSPKGQDCFCLiF87wD/G1Td7QoNzVZUJ2E9Aaohoc=;
        b=AZKsXPysPvycyo2oj4WMR6gdFfvb1OWYyXIX73MnoIl6xujEg5UDOqI9J30qSkCszl
         6SsC7sJ7ZPBQx40WrTw2JZDZdGyHbMJJp5LHLxX9ZuV2HEZWYEliUTK0sz6RbHx52kK/
         aVtGrXi+DtdYobDWHiUiO1iLKhVTktIr/GE06i4qeeIKEdsINZdm9SUWeamRpQEv/Rnq
         UrlphdSZV9cZn4MILhPmE7LDp/ZTc0cL+HHIuwDX5zJhjTBQL1Dv3rrP5/MgbKdzhfsP
         JLpWLcQyTVhJsr1qcHDac36fNwrw3FimnLlhEOKrNGVdF1xPXS4jZTbDOXZU/AC/f9/c
         s3oQ==
X-Gm-Message-State: AOAM533yFhavT3DnFuxzI9dGCeiGvCYiDKsXBTu1FEQZSVeqeXOogygT
        AcbLH5lAjfIgR0g0/eafTJwASN1adpkySb7iABhdRA3BLmzr
X-Google-Smtp-Source: ABdhPJwKuv3/SgAWQSCle5P2lNmjUlMIDW2FcgIk7h6NlfiRO4Mu+/XZouoBmR0Mp4mbLkk0GeBrJnCvMC0vyfYwVCwqIyg/O/6X
MIME-Version: 1.0
X-Received: by 2002:a92:9a13:: with SMTP id t19mr1798694ili.269.1601548156895;
 Thu, 01 Oct 2020 03:29:16 -0700 (PDT)
Date:   Thu, 01 Oct 2020 03:29:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fb885a05b0997c54@google.com>
Subject: KMSAN: uninit-value in batadv_nc_worker
From:   syzbot <syzbot+da9194708de785081f11@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5edb1df2 kmsan: drop the _nosanitize string functions
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=10cc55a7900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4991d22eb136035c
dashboard link: https://syzkaller.appspot.com/bug?extid=da9194708de785081f11
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+da9194708de785081f11@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
BUG: KMSAN: uninit-value in batadv_nc_worker+0x1c0/0x1d70 net/batman-adv/network-coding.c:718
CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:201
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
 batadv_nc_worker+0x1c0/0x1d70 net/batman-adv/network-coding.c:718
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:293
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:143 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:126
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2907 [inline]
 slab_alloc mm/slub.c:2916 [inline]
 __kmalloc+0x2bb/0x4b0 mm/slub.c:3982
 kmalloc_array+0x90/0x140 include/linux/slab.h:594
 batadv_hash_new+0x129/0x530 net/batman-adv/hash.c:52
 batadv_originator_init+0x9b/0x370 net/batman-adv/originator.c:211
 batadv_mesh_init+0x4dc/0x9d0 net/batman-adv/main.c:204
 batadv_softif_init_late+0x6d8/0xa30 net/batman-adv/soft-interface.c:857
 register_netdevice+0xbbc/0x37d0 net/core/dev.c:9760
 __rtnl_newlink net/core/rtnetlink.c:3454 [inline]
 rtnl_newlink+0x2e77/0x3ed0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x142b/0x18c0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x6d7/0x7e0 net/netlink/af_netlink.c:2470
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5581
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x11c8/0x1490 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x173a/0x1840 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
