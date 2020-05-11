Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1381A1CE27E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgEKSVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:21:38 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:55730 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbgEKSVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:21:21 -0400
Received: by mail-il1-f198.google.com with SMTP id l6so10101407ils.22
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SgahX+xxxn/F7kqBauPLeHjVaGE2RHw7Ce+/vWGFtFE=;
        b=NY1pjZforOjMn9z5PWQutwYvcVNgUXRL+4s//AN2uewoWyPtpMUIiwq5+BF1EgyYK/
         UIggPQW9jwL037mh7CPfgVXVFpGg/FQVyYogZg6UJh/fx2/B3K8iZlgf1TOfUUrMRDX4
         8QKAov0tHbDRrPK1mgapamv0HptradagCOjQFafjgKFH/GsiJSKbkIPAU52fTFyrRNjk
         dGn8HeZrzWGFfbeOrzohm2xk6MBcOXk2J4VEuchmPaJsn8lNue8fnZoFLzlAwrDpyTZM
         hIa5eSZjw4peQnDC63pLmSYrvcvtoVSzT/A1p3pHbM6W1ELROW4t1Bv2+T8GmXdVOPA0
         6Uag==
X-Gm-Message-State: AGi0PuYwcSttzkMwqkg3V0+vuQD2swKkFdk0QgMEfMUprCopespx+jFJ
        3gjJ35hJePMttyioe62rcRc64OVth0BVWDR+TOh7cpQx3Vxz
X-Google-Smtp-Source: APiQypKf7bSUzReoBubrJJvUiUvyovPF/1cgFZo3lRblXXTsfhO31Itpcb+CmqOsJ11ccV5fWsYnw7Iq4kf2WwOppWFc3QVc1Rth
MIME-Version: 1.0
X-Received: by 2002:a02:c9d0:: with SMTP id c16mr16961066jap.80.1589221280642;
 Mon, 11 May 2020 11:21:20 -0700 (PDT)
Date:   Mon, 11 May 2020 11:21:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e723d205a56369c2@google.com>
Subject: KMSAN: uninit-value in hash_net6_del
From:   syzbot <syzbot+3fba3936436897a34c8a@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, gregkh@linuxfoundation.org, info@metux.net,
        jeremy@azazel.net, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    21c44613 kmsan: page_alloc: more assuring comment
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12f13632100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5915107b3106aaa
dashboard link: https://syzkaller.appspot.com/bug?extid=3fba3936436897a34c8a
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3fba3936436897a34c8a@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __read_once_size include/linux/compiler.h:206 [inline]
BUG: KMSAN: uninit-value in hash_net6_del+0xa54/0x23e0 net/netfilter/ipset/ip_set_hash_gen.h:1069
CPU: 0 PID: 32550 Comm: syz-executor.3 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __read_once_size include/linux/compiler.h:206 [inline]
 hash_net6_del+0xa54/0x23e0 net/netfilter/ipset/ip_set_hash_gen.h:1069
 hash_net6_uadt+0xab6/0xd80 net/netfilter/ipset/ip_set_hash_net.c:343
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1731
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1819
 ip_set_udel+0xf9/0x110 net/netfilter/ipset/ip_set_core.c:1853
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2478
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f20cf9cbc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fd660 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020001080 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000092a R14: 00000000004cbc77 R15: 00007f20cf9cc6d4

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ip6_netmask include/linux/netfilter/ipset/pfxlen.h:51 [inline]
 hash_net6_uadt+0xa07/0xd80 net/netfilter/ipset/ip_set_hash_net.c:334
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1731
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1819
 ip_set_udel+0xf9/0x110 net/netfilter/ipset/ip_set_core.c:1853
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2478
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 ip_set_get_ipaddr6+0x26a/0x300 net/netfilter/ipset/ip_set_core.c:324
 hash_net6_uadt+0x4a6/0xd80 net/netfilter/ipset/ip_set_hash_net.c:320
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1731
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1819
 ip_set_udel+0xf9/0x110 net/netfilter/ipset/ip_set_core.c:1853
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2478
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2801 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4420
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1081 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2439
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2439
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
