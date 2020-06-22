Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0964E203CB1
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgFVQhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:37:12 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:37912 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729551AbgFVQhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:37:12 -0400
Received: by mail-il1-f199.google.com with SMTP id c8so12394826ilm.5
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OQVd837vUUZyqXrdrpMrwkGptseXear+Lwmn/fPWLqI=;
        b=i9o9u3jKZPtaAiaX2yOddcUErr9OBRRimW6fByQ4ZB52kU/4nvPRP24jLtlcdWZXiu
         c1rPcfju44NLp9an0fBW6WlFdwYTuTN1mr/fwCBi1M1nUES2KOCc2QdxQmc2+Yy8J+gM
         fQ6N5AVscATEU4jYBie9R87HN3g7ve2esUMbNsSokVsG3RNQHE8HxxuaBglTTe8ASVoV
         aVJpeUtQ9tDUVWlW0XZLRJ8a6KooZxnFaTV6aekZOM+6+8qMBeKhgFi/lpPajb0tdYcn
         IPpUIVB00amAgmiOjo5QTuN4jzRjXwwruwvGA07PxYokIpKrfBmkDpGGcHzpydbYGXmO
         yFrg==
X-Gm-Message-State: AOAM533bQ7BH9ZVX90SPoZXAqDxLnFipbHH4up7jVate1Evn3et0Aphk
        zEfuf6gw6S8Tk5c/rJqFEBydWkfUxsCX+KER9sJeMaJuUAa7
X-Google-Smtp-Source: ABdhPJxEmIkHYx2hokP1bZua0PeGWC0tmgsT0u4JgSZw2AqRkRYXgEBDQxl2p2O+m0XOVe5/yula3g/KrqtE+D5Qsae4AXOa2W6H
MIME-Version: 1.0
X-Received: by 2002:a02:a70d:: with SMTP id k13mr19171288jam.100.1592843830829;
 Mon, 22 Jun 2020 09:37:10 -0700 (PDT)
Date:   Mon, 22 Jun 2020 09:37:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b8269a05a8aeda77@google.com>
Subject: KASAN: use-after-free Read in tipc_udp_nl_dump_remoteip (2)
From:   syzbot <syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    67c20de3 net: Add MODULE_DESCRIPTION entries to network mo..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13ff86a5100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45c80de7244166e1
dashboard link: https://syzkaller.appspot.com/bug?extid=3039ddf6d7b13daf3787
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1126c695100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122afe35100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3039ddf6d7b13daf3787@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
BUG: KASAN: use-after-free in tipc_udp_nl_dump_remoteip+0xb92/0xba0 net/tipc/udp_media.c:467
Read of size 2 at addr ffff8880a7da0c14 by task syz-executor132/7030

CPU: 0 PID: 7030 Comm: syz-executor132 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 nla_parse_nested_deprecated include/net/netlink.h:1218 [inline]
 tipc_udp_nl_dump_remoteip+0xb92/0xba0 net/tipc/udp_media.c:467
 genl_lock_dumpit+0x7f/0xb0 net/netlink/genetlink.c:575
 netlink_dump+0x50b/0xe70 net/netlink/af_netlink.c:2245
 __netlink_dump_start+0x63f/0x910 net/netlink/af_netlink.c:2353
 genl_family_rcv_msg_dumpit.isra.0+0x296/0x300 net/netlink/genetlink.c:638
 genl_family_rcv_msg net/netlink/genetlink.c:733 [inline]
 genl_rcv_msg+0x781/0x9c0 net/netlink/genetlink.c:753
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:764
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4452c9
Code: Bad RIP value.
RSP: 002b:00007ffd2abff858 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004452c9
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000000f7f6 R08: 0000000000000000 R09: 00000000004002e0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402460
R13: 00000000004024f0 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7032:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 __kmalloc_reserve.isra.0+0x39/0xe0 net/core/skbuff.c:142
 __alloc_skb+0xef/0x5a0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x97b/0xe10 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 7032:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 skb_free_head+0x8b/0xa0 net/core/skbuff.c:590
 skb_release_data+0x617/0x8a0 net/core/skbuff.c:610
 skb_release_all+0x46/0x60 net/core/skbuff.c:664
 __kfree_skb net/core/skbuff.c:678 [inline]
 consume_skb net/core/skbuff.c:837 [inline]
 consume_skb+0xf3/0x3f0 net/core/skbuff.c:831
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x53f/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880a7da0c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 20 bytes inside of
 512-byte region [ffff8880a7da0c00, ffff8880a7da0e00)
The buggy address belongs to the page:
page:ffffea00029f6800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000261b188 ffffea0002884808 ffff8880aa000a80
raw: 0000000000000000 ffff8880a7da0000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a7da0b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a7da0b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a7da0c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff8880a7da0c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a7da0d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
