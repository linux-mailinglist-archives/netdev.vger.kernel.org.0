Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85ED1169038
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 17:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBVQSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 11:18:11 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:47250 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgBVQSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 11:18:11 -0500
Received: by mail-io1-f71.google.com with SMTP id 13so5080617iof.14
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 08:18:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q5WXcymNK0iXLaBPmc/IaN0k5lkicg+bQcyotVKvKB0=;
        b=TRULd3vBhPm1gnyIgPe8sdFXa4HwfozjRCLgQlmoW6L8VR2gbXWE0/zWc+W+/NSrPN
         TMdV7/PF//Nwn0KBp80r5St+wxZ1cLx/RkDCnEK0MWa4uyS504BQ6gYwh4AZ3xB3g765
         8urYrFbl1mfaHhnHWv+3yY/DxUtuM8Z0PSHIlmQ/l7pwUNoox7BHbWMhs49KafrCiy0F
         UG24a2BWEwuK9V736d6/Lu9dPu4fKKhupw+NTGWmFjSvij2EF4b3gC8FHxc5VHHvh8Iy
         3Oj+lejiyLfBM176lkU6qUiIL0oMMB/1/GT1VcbUAJhyz4z3xMCrwBTPu58xV1sjXGGC
         rDLg==
X-Gm-Message-State: APjAAAUUPhf/wul648/EQxgMVyVoRgqxiZYRxv1CmwSVbCkk9Kn5qQ84
        Df4GzYPjmaeTckSAkrjc3usjaEPVehTGGyIUWT2145xUrECx
X-Google-Smtp-Source: APXvYqwWx5iFusHoDsY4SnJEiNdRCrpAU5DWoTP+SeoLzwE3OOC6e3KWiGMxWwQ3SZ+I2FhhRkvjif9JZT2G0kiG/yYGtSPGJdo/
MIME-Version: 1.0
X-Received: by 2002:a92:ca82:: with SMTP id t2mr45884845ilo.242.1582388289189;
 Sat, 22 Feb 2020 08:18:09 -0800 (PST)
Date:   Sat, 22 Feb 2020 08:18:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dfc074059f2c7b57@google.com>
Subject: KMSAN: uninit-value in nf_flow_table_offload_setup
From:   syzbot <syzbot+8fbe17d9bdd5c8815211@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8bbbc5cf kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=17325b4ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd0e9a6b0e555cc3
dashboard link: https://syzkaller.appspot.com/bug?extid=8fbe17d9bdd5c8815211
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c39881e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11924edde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8fbe17d9bdd5c8815211@syzkaller.appspotmail.com

batman_adv: batadv0: Interface activated: batadv_slave_1
=====================================================
BUG: KMSAN: uninit-value in list_splice include/linux/list.h:437 [inline]
BUG: KMSAN: uninit-value in nf_flow_table_block_setup net/netfilter/nf_flow_table_offload.c:826 [inline]
BUG: KMSAN: uninit-value in nf_flow_table_offload_setup+0x964/0xac0 net/netfilter/nf_flow_table_offload.c:883
CPU: 1 PID: 11672 Comm: syz-executor942 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 list_splice include/linux/list.h:437 [inline]
 nf_flow_table_block_setup net/netfilter/nf_flow_table_offload.c:826 [inline]
 nf_flow_table_offload_setup+0x964/0xac0 net/netfilter/nf_flow_table_offload.c:883
 nft_register_flowtable_net_hooks net/netfilter/nf_tables_api.c:6185 [inline]
 nf_tables_newflowtable+0x233c/0x3e30 net/netfilter/nf_tables_api.c:6302
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:433 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x155e/0x3ab0 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x451/0x5f0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2437
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2437
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443709
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffe96ae538 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443709
RDX: 0000000000000000 RSI: 0000000020003e00 RDI: 0000000000000003
RBP: 00007fffe96ae550 R08: 0000000001bbbbbb R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000404ca0 R14: 0000000000000000 R15: 0000000000000000

Local variable ----bo@nf_flow_table_offload_setup created at:
 nf_flow_table_offload_setup+0xba/0xac0 net/netfilter/nf_flow_table_offload.c:876
 nf_flow_table_offload_setup+0xba/0xac0 net/netfilter/nf_flow_table_offload.c:876
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
