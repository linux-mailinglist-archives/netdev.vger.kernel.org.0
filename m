Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761B41FFA64
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbgFRRgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:36:22 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:50037 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732250AbgFRRgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:36:19 -0400
Received: by mail-io1-f71.google.com with SMTP id d20so4715547iom.16
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2hGkj3pgqjZzii+yGvLKkGedjI+miZLqyudGh7JCriU=;
        b=C3k5P2I4CJVabaHBNnNx6q0L2oD7oAU87DnYwfQRB7AlPev1R6OPElsrScZ+nHaAb8
         PNRXGv1sXoE0wZqXIt3Z/Ae0REbWok2U4bwXYT0BKxUCvHA1X+tVf9URzTOUgWr87nnl
         0t/kCH0aDD8eIPx1mmV2fGRkwO6RvlSi2yD/wBfGBNrrJcly179HqXejPjFPPDgrEzu1
         luRvvo8b+dvJpnHM0fHEk0/Ir52Y0vKELaziAv62HWuwxyv3jJ4qkV5E0UFALxzaT7qT
         qGcrI/eTuLCLhsR4Jl2WqLI3R0TKj9xVUPhy7vTJUAwObyChtLmUhVjX4HESq1I9zyGh
         BHxQ==
X-Gm-Message-State: AOAM531TgHTCX/HtOIkyne4xI6XNZaPVcBlNBjV3aI4PLJj33ZLLpBJB
        lk0jmgdhQUJFtMug4E/v9y+Ex+G3GqEpTdCo1CZQDRMC0pFb
X-Google-Smtp-Source: ABdhPJzTvCc06gUmd5iur0PoN68suH1/NYP/Fkvt6V830f59jikYJEFQR+bvNz2AJDcKP2icSvokS4s9hF26wrj3aZITqm0ixyqu
MIME-Version: 1.0
X-Received: by 2002:a6b:14cc:: with SMTP id 195mr3333136iou.117.1592501777584;
 Thu, 18 Jun 2020 10:36:17 -0700 (PDT)
Date:   Thu, 18 Jun 2020 10:36:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1d8d405a85f360d@google.com>
Subject: KMSAN: uninit-value in hash_ip6_add
From:   syzbot <syzbot+89bacaf2be1277d1e6de@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, gregkh@linuxfoundation.org, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f0d5ec90 kmsan: apply __no_sanitize_memory to dotraplinkag..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=126592fa100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86e4f8af239686c6
dashboard link: https://syzkaller.appspot.com/bug?extid=89bacaf2be1277d1e6de
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+89bacaf2be1277d1e6de@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __read_once_size include/linux/compiler.h:206 [inline]
BUG: KMSAN: uninit-value in hash_ip6_add+0x14eb/0x30c0 net/netfilter/ipset/ip_set_hash_gen.h:892
CPU: 1 PID: 31730 Comm: syz-executor.3 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __read_once_size include/linux/compiler.h:206 [inline]
 hash_ip6_add+0x14eb/0x30c0 net/netfilter/ipset/ip_set_hash_gen.h:892
 hash_ip6_uadt+0x8e6/0xad0 net/netfilter/ipset/ip_set_hash_ip.c:267
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1732
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1820
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1845
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __do_sys_sendmsg net/socket.c:2458 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2456
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2456
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ca59
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fea85396c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fe260 RCX: 000000000045ca59
RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000942 R14: 00000000004cc0a6 R15: 00007fea853976d4

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 ip6_netmask include/linux/netfilter/ipset/pfxlen.h:49 [inline]
 hash_ip6_netmask net/netfilter/ipset/ip_set_hash_ip.c:185 [inline]
 hash_ip6_uadt+0x9df/0xad0 net/netfilter/ipset/ip_set_hash_ip.c:263
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1732
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1820
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1845
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __do_sys_sendmsg net/socket.c:2458 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2456
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2456
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 ip_set_get_ipaddr6+0x26a/0x300 net/netfilter/ipset/ip_set_core.c:325
 hash_ip6_uadt+0x450/0xad0 net/netfilter/ipset/ip_set_hash_ip.c:255
 call_ad+0x2dc/0xbc0 net/netfilter/ipset/ip_set_core.c:1732
 ip_set_ad+0xad2/0x1110 net/netfilter/ipset/ip_set_core.c:1820
 ip_set_uadd+0xf6/0x110 net/netfilter/ipset/ip_set_core.c:1845
 nfnetlink_rcv_msg+0xb86/0xcf0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 nfnetlink_rcv+0x3b5/0x3ab0 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __do_sys_sendmsg net/socket.c:2458 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2456
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2456
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2802 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4436
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1175 [inline]
 netlink_sendmsg+0x7d3/0x14d0 net/netlink/af_netlink.c:1893
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2362
 ___sys_sendmsg net/socket.c:2416 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2449
 __do_sys_sendmsg net/socket.c:2458 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2456
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2456
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
