Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA3CEC48
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfJGS7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 14:59:13 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:48867 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728702AbfJGS7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 14:59:12 -0400
Received: by mail-io1-f72.google.com with SMTP id w16so28288817ioc.15
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 11:59:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hcZ/rOmgx1gUO3ejejbmSDSQ+0Pvz2P/r/ne8Sia82Q=;
        b=hyyZuByDpjmFZtkJ6g5KT3LhXAxK40m9x8nIS7V01oZz5yPV+A7dpNiebaDxjP755L
         IRIEcQ/c5Qk9EkQGD9MZNMGOg78QtebNPqOJL3NPnDulAEiajRPQHHZn+n2l8cog89lT
         hAaUoYRO71Qv6dh7wuWi3Bm9iIzqLdAE3Imr5gyT4coMDoPh+jSf6XEwyO7Q+Aj3v9kT
         XWNIDobTsH6Tfk9efl6fqp2QnkBjLv/u3NfqWkGSN55EdO9Ikxcj3qPyLXKo+jdqaxQl
         5xc1WZ/1/LEUm/DH+alFbBYW5+MNzExWv/156cY7EA/Jsy+rc/AxmcsM9sle3kTaqvsy
         se8Q==
X-Gm-Message-State: APjAAAWmSd5yzwuLr39XmwgIptr4Tpy/Dv9OmZVACtiqPZYbdc/GrD0e
        Q57zFMBnEg3f/1RbEOsQu0JPhO3MVV20F4ozMiaRuj6WuNuE
X-Google-Smtp-Source: APXvYqwKDV9bkJ3CbD1lTn7nhWmSEDVsQCa6LfIBWdqWXDABkI5OnzYeetKhzne6hfaVlJekLNHvwRkLfMslrr+O8HcvmHuuqZf4
MIME-Version: 1.0
X-Received: by 2002:a6b:9109:: with SMTP id t9mr23918993iod.16.1570474751802;
 Mon, 07 Oct 2019 11:59:11 -0700 (PDT)
Date:   Mon, 07 Oct 2019 11:59:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b5c8d0059456a5c7@google.com>
Subject: general protection fault in rxrpc_error_report
From:   syzbot <syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e278c1600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=611164843bd48cc2190c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1014304e600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134663de600000

The bug was bisected to:

commit 2baec2c3f854d1f79c7bb28386484e144e864a14
Author: David Howells <dhowells@redhat.com>
Date:   Wed May 24 16:02:32 2017 +0000

     rxrpc: Support network namespacing

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15edda32600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17edda32600000
console output: https://syzkaller.appspot.com/x/log.txt?x=13edda32600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com
Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rxrpc_lookup_peer_icmp_rcu net/rxrpc/peer_event.c:37 [inline]
RIP: 0010:rxrpc_error_report+0x23b/0x1a80 net/rxrpc/peer_event.c:175
Code: ff ff ff ba 24 00 00 00 31 f6 48 89 df e8 ed ff 0f fb 49 8d be 5c 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 16
RSP: 0018:ffff8880a99174a0 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff8880a9917500 RCX: 0000000000000000
RDX: 000000000000004b RSI: 0000000000000000 RDI: 000000000000025c
RBP: ffff8880a99175a0 R08: 0000000000000004 R09: ffff8880a9917500
R10: ffffed1015322ea4 R11: 0000000000000003 R12: ffff888098ca4d40
R13: ffff88808dce9330 R14: 0000000000000000 R15: ffff8880a9917640
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004cde30 CR3: 0000000008c6d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  sock_queue_err_skb+0x34c/0x7c0 net/core/skbuff.c:4401
  ip_icmp_error+0x3e3/0x580 net/ipv4/ip_sockglue.c:415
  __udp4_lib_err+0x609/0x1320 net/ipv4/udp.c:713
  udp_err+0x25/0x30 net/ipv4/udp.c:723
  icmp_socket_deliver+0x1ea/0x370 net/ipv4/icmp.c:768
  icmp_unreach+0x34a/0xaa0 net/ipv4/icmp.c:885
  icmp_rcv+0xede/0x15a0 net/ipv4/icmp.c:1067
  ip_protocol_deliver_rcu+0x5a/0x8b0 net/ipv4/ip_input.c:204
  ip_local_deliver_finish+0x23b/0x390 net/ipv4/ip_input.c:231
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip_local_deliver+0x1e9/0x520 net/ipv4/ip_input.c:252
  dst_input include/net/dst.h:442 [inline]
  ip_rcv_finish+0x1d9/0x2e0 net/ipv4/ip_input.c:413
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip_rcv+0xe8/0x3f0 net/ipv4/ip_input.c:523
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5004
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5118
  process_backlog+0x206/0x750 net/core/dev.c:5929
  napi_poll net/core/dev.c:6352 [inline]
  net_rx_action+0x4d6/0x1030 net/core/dev.c:6418
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 7d3172ee2e4a713b ]---
RIP: 0010:rxrpc_lookup_peer_icmp_rcu net/rxrpc/peer_event.c:37 [inline]
RIP: 0010:rxrpc_error_report+0x23b/0x1a80 net/rxrpc/peer_event.c:175
Code: ff ff ff ba 24 00 00 00 31 f6 48 89 df e8 ed ff 0f fb 49 8d be 5c 02  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 16
RSP: 0018:ffff8880a99174a0 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffff8880a9917500 RCX: 0000000000000000
RDX: 000000000000004b RSI: 0000000000000000 RDI: 000000000000025c
RBP: ffff8880a99175a0 R08: 0000000000000004 R09: ffff8880a9917500
R10: ffffed1015322ea4 R11: 0000000000000003 R12: ffff888098ca4d40
R13: ffff88808dce9330 R14: 0000000000000000 R15: ffff8880a9917640
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004cde30 CR3: 0000000008c6d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
