Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0C2F6594
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbhANQRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:17:00 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:44925 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbhANQQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:16:59 -0500
Received: by mail-io1-f71.google.com with SMTP id a1so9241573ioa.11
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 08:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aAzDGgnw82km7tFkTHNpceySUwV+QRWaKQm/V+YoTp8=;
        b=PDB5gOEjFeYVMXeEz1A+91lLrbJ3SWtP0C7ke6uwIdd25c3LrABxeOVhMYkO6cXYDg
         4w6dxws2aZkW1hLK1ztbZvYUJylrYAH0UiGIFGzHaBUDGwmJslLIbcxZXgu03ORbggJD
         DloLWNswgcE0Qj/FAhlkbT9etSOSV72cQYt0rwdvPy/t8qAuSG+SzBpiGAYHgsACkMiK
         UpjhNZEOV2tBIuhibRr2MfO7AHi0fMMSzGP1hrfgO3Tzl/3CNH3J4BN/Gz12kdqD5k87
         jFIID8AlDFxOWqBL4bQ7ttQs0FJ3UKlydmIsYmI6t78uygPtePcD/RGvHOU6EP4dwQy1
         +CdQ==
X-Gm-Message-State: AOAM533lhjKMGfAvbIXTGZD5uXn34jjFJIqg/XxH30WMyDhGTImsbUz3
        CRA4KLbUyok9Dwnc3vdEStdh3tDnVYYdyvG22gJOBhvTagli
X-Google-Smtp-Source: ABdhPJyVxHQB+PMGONU+BKbygYzx/3LLO/BG3GBIqaxYxNKHAQQECoohNXpR1VwHv7evsbJlna5XnUO9REpseqcaFlibFKehyUUG
MIME-Version: 1.0
X-Received: by 2002:a02:aa83:: with SMTP id u3mr7006293jai.38.1610640978128;
 Thu, 14 Jan 2021 08:16:18 -0800 (PST)
Date:   Thu, 14 Jan 2021 08:16:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005cb43b05b8de9356@google.com>
Subject: KMSAN: uninit-value in nf_conntrack_udplite_packet (2)
From:   syzbot <syzbot+e5b49f0d1e69d0c0fcb4@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11eb6ce7500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2cdf4151c9653e32
dashboard link: https://syzkaller.appspot.com/bug?extid=e5b49f0d1e69d0c0fcb4
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13922a3f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c6c2f7500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e5b49f0d1e69d0c0fcb4@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in udplite_error net/netfilter/nf_conntrack_proto_udp.c:162 [inline]
BUG: KMSAN: uninit-value in nf_conntrack_udplite_packet+0x7b2/0x12d0 net/netfilter/nf_conntrack_proto_udp.c:188
CPU: 1 PID: 8615 Comm: syz-executor710 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 udplite_error net/netfilter/nf_conntrack_proto_udp.c:162 [inline]
 nf_conntrack_udplite_packet+0x7b2/0x12d0 net/netfilter/nf_conntrack_proto_udp.c:188
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1768 [inline]
 nf_conntrack_in+0x10fb/0x298f net/netfilter/nf_conntrack_core.c:1846
 ipv4_conntrack_local+0x225/0x3b0 net/netfilter/nf_conntrack_proto.c:200
 nf_hook_entry_hookfn include/linux/netfilter.h:136 [inline]
 nf_hook_slow+0x17b/0x460 net/netfilter/core.c:589
 nf_hook include/linux/netfilter.h:256 [inline]
 __ip_local_out+0x7a6/0x860 net/ipv4/ip_output.c:115
 ip_local_out net/ipv4/ip_output.c:124 [inline]
 ip_send_skb+0xb3/0x340 net/ipv4/ip_output.c:1568
 udp_send_skb+0x1568/0x1be0 net/ipv4/udp.c:948
 udp_push_pending_frames net/ipv4/udp.c:976 [inline]
 udp_sendpage+0x805/0xb90 net/ipv4/udp.c:1347
 inet_sendpage+0x1da/0x2f0 net/ipv4/af_inet.c:831
 kernel_sendpage+0x47a/0x590 net/socket.c:3646
 sock_sendpage+0x15e/0x1a0 net/socket.c:944
 pipe_to_sendpage+0x3f4/0x530 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x5e3/0xff0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:743
 do_splice_from fs/splice.c:764 [inline]
 do_splice+0x2365/0x3550 fs/splice.c:1059
 __do_splice fs/splice.c:1137 [inline]
 __do_sys_splice fs/splice.c:1343 [inline]
 __se_sys_splice+0x8f8/0xb40 fs/splice.c:1325
 __x64_sys_splice+0x6e/0x90 fs/splice.c:1325
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444059
Code: e8 6c 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd20373dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000444059
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007ffd20373df0 R08: 0000000080000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000024bb2
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 __msan_chain_origin+0x57/0xa0 mm/kmsan/kmsan_instr.c:147
 udp_send_skb+0x17aa/0x1be0 net/ipv4/udp.c:943
 udp_push_pending_frames net/ipv4/udp.c:976 [inline]
 udp_sendpage+0x805/0xb90 net/ipv4/udp.c:1347
 inet_sendpage+0x1da/0x2f0 net/ipv4/af_inet.c:831
 kernel_sendpage+0x47a/0x590 net/socket.c:3646
 sock_sendpage+0x15e/0x1a0 net/socket.c:944
 pipe_to_sendpage+0x3f4/0x530 fs/splice.c:364
 splice_from_pipe_feed fs/splice.c:418 [inline]
 __splice_from_pipe+0x5e3/0xff0 fs/splice.c:562
 splice_from_pipe fs/splice.c:597 [inline]
 generic_splice_sendpage+0x1d5/0x2d0 fs/splice.c:743
 do_splice_from fs/splice.c:764 [inline]
 do_splice+0x2365/0x3550 fs/splice.c:1059
 __do_splice fs/splice.c:1137 [inline]
 __do_sys_splice fs/splice.c:1343 [inline]
 __se_sys_splice+0x8f8/0xb40 fs/splice.c:1325
 __x64_sys_splice+0x6e/0x90 fs/splice.c:1325
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 skb_copy_from_linear_data_offset include/linux/skbuff.h:3660 [inline]
 skb_copy_bits+0x2a6/0x1050 net/core/skbuff.c:2195
 tpacket_rcv+0x5591/0x7f90 net/packet/af_packet.c:2324
 __netif_receive_skb_one_core net/core/dev.c:5315 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5429
 process_backlog+0x523/0xc10 net/core/dev.c:6319
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:121 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:289
 kmsan_memcpy_memmove_metadata+0x25e/0x2d0 mm/kmsan/kmsan.c:226
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:246
 __msan_memcpy+0x46/0x60 mm/kmsan/kmsan_instr.c:110
 pskb_expand_head+0x3eb/0x1df0 net/core/skbuff.c:1631
 __skb_cow include/linux/skbuff.h:3165 [inline]
 skb_cow_head include/linux/skbuff.h:3199 [inline]
 batadv_skb_head_push+0x2ce/0x410 net/batman-adv/soft-interface.c:75
 batadv_send_skb_packet+0x1ed/0x970 net/batman-adv/send.c:86
 batadv_send_broadcast_skb+0x76/0x90 net/batman-adv/send.c:127
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:394 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:420 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0xb3a/0xf00 net/batman-adv/bat_iv_ogm.c:1712
 process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
 worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
 kthread+0x51c/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:121
 kmsan_alloc_page+0xd3/0x1f0 mm/kmsan/kmsan_shadow.c:274
 __alloc_pages_nodemask+0x84e/0xfb0 mm/page_alloc.c:4989
 __alloc_pages include/linux/gfp.h:511 [inline]
 __alloc_pages_node include/linux/gfp.h:524 [inline]
 alloc_pages_node include/linux/gfp.h:538 [inline]
 __page_frag_cache_refill mm/page_alloc.c:5065 [inline]
 page_frag_alloc+0x35b/0x890 mm/page_alloc.c:5095
 __napi_alloc_skb+0x1c0/0xab0 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2870 [inline]
 page_to_skb+0x142/0x1640 drivers/net/virtio_net.c:389
 receive_mergeable+0xee6/0x5be0 drivers/net/virtio_net.c:949
 receive_buf+0x2db/0x2ba0 drivers/net/virtio_net.c:1059
 virtnet_receive drivers/net/virtio_net.c:1351 [inline]
 virtnet_poll+0xa51/0x1d10 drivers/net/virtio_net.c:1456
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
