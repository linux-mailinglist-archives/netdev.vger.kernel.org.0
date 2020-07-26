Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADED022E2CB
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 23:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGZVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 17:43:21 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:52566 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGZVnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 17:43:21 -0400
Received: by mail-il1-f198.google.com with SMTP id o17so10106727ilt.19
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 14:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nAqhAZrp6ZJGNDfnLfTIkbQ8+pw1kWgohuV82v6isQ4=;
        b=kCigpIQyuH/fGgrgejvYLk12m9EKqaN3cLN1TrkvzQOQeiyfydJmKDTOFqKyWNipkH
         QrOIv8u0tLd7QnfYWJvH9mKs4seIzJNvKhK/YPhxJbP3mKKmnbuNhNbrveGQF5DQgMTy
         XnAtsdMM6YgzgX0G4dopJ/hbFwJWN3WcWAW43X48b3b5SlsH24pPSLGD8hZUYEyhVSbv
         jb4HDdNp11gILwdsMvc0ZOr0rJf4vJSfLPUOyWARKXeNtoLAFE2w3Hy3dia+vI4/JMs/
         wxh/hqw4KIXc1gDEpO/0sS5cO5q0q2597O4keebAIQUIdNDiOdmVs3APFtLYTKEe3g6G
         GGXQ==
X-Gm-Message-State: AOAM530HJvVkLHno5syOZGmmYyFkRekpc+85NdGX6Mr2+HVsOlOtc0yt
        OH+QywpywAdVFbAVQ4zeaCzVecJsCQCTj04XAk+l1xRTfHZ2
X-Google-Smtp-Source: ABdhPJxhAvmMdgn2oYHl9DTNIo33R2en4NDhOaB9yqmt70XbzVOZv52k/R+zcZNzycxJn+tCdq3LLZknvLPm5I++5vnF4p7CK/vF
MIME-Version: 1.0
X-Received: by 2002:a02:bb05:: with SMTP id y5mr13588273jan.98.1595799799952;
 Sun, 26 Jul 2020 14:43:19 -0700 (PDT)
Date:   Sun, 26 Jul 2020 14:43:19 -0700
In-Reply-To: <00000000000065efbf05ab480bff@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000357d0105ab5f1854@google.com>
Subject: Re: KMSAN: uninit-value in strstr
From:   syzbot <syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, jmaloy@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    93f54a72 instrumented.h: fix KMSAN support
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=15692a74900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c534a9fad6323722
dashboard link: https://syzkaller.appspot.com/bug?extid=a73d24a22eeeebe5f244
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f4b9df100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14dd9d8c900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in strlen lib/string.c:552 [inline]
BUG: KMSAN: uninit-value in strstr+0xfe/0x2e0 lib/string.c:991
CPU: 0 PID: 8431 Comm: syz-executor953 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1df/0x240 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 strlen lib/string.c:552 [inline]
 strstr+0xfe/0x2e0 lib/string.c:991
 tipc_nl_node_reset_link_stats+0x434/0xa90 net/tipc/node.c:2504
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x1592/0x1740 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1370/0x1400 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444249
Code: Bad RIP value.
RSP: 002b:00007ffe249b7e28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002e0 RCX: 0000000000444249
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00000000006ce018 R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e70
R13: 0000000000401f00 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4478
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1370/0x1400 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

