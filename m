Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F78EF700
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbfKEIMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:12:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:42917 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387950AbfKEIMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:12:09 -0500
Received: by mail-il1-f198.google.com with SMTP id n16so4122182ilm.9
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:12:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MNsgBgp8YCyHfQxHpWh+K7NZzzxWLacy49o1D1fvmaQ=;
        b=BjE/qHejvY+pZLkOb4NkQxe/jPJY/iR1J3W6ZcS2khajJEmPiVLePeqSuhIYlky6KH
         xs7AYp0FfLIN0x1Hfp5m3HuzPrHCkf6UfdFkpVoViv5dq+RsLlVsCPhLtgnPXlVlBDxj
         rmbWC8hSGLGKdG2kGPubqPeVal9kz5O9ljywNNYuH25EXaoPiS374XdDcUeDU17f4VzP
         raGj39cRDNzks03Hh5qg93YOK5Ny0aUD4+wVrPheA7kr0e65oAcclVsZ20u+YnRS/sRM
         nM7iliqrjNKDBBOyskpj0iXwetgVx+mIe5RDZUL5cl4bkpXfc1mueFNXwdF+fFQ795YQ
         yv0Q==
X-Gm-Message-State: APjAAAWcBxNQVVHzgF9JiqY2dJgXRrVjXaobKDgNFg1zlT6NjDiYejZs
        fkZJUjGSfmZiOFEuB2qMiedEIxsi96Nuk5V0/UvCcLjjbk6V
X-Google-Smtp-Source: APXvYqyil8jtfPt3fyJcKPPAVKuy/zVCOqm0SMAQe6BaI34ILCuRathPelUZfGBQhxtO9WnKrqJ06U5sOpt0+bMFk+Q9R7AVsGfx
MIME-Version: 1.0
X-Received: by 2002:a6b:6815:: with SMTP id d21mr9481899ioc.176.1572941528270;
 Tue, 05 Nov 2019 00:12:08 -0800 (PST)
Date:   Tue, 05 Nov 2019 00:12:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b9220059694fd26@google.com>
Subject: BUG: corrupted list in hsr_add_node
From:   syzbot <syzbot+3924327f9ad5f4d2b343@syzkaller.appspotmail.com>
To:     arvid.brodin@alten.se, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ae8a76fb Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d6e1cce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1de9aacc9fbbc754
dashboard link: https://syzkaller.appspot.com/bug?extid=3924327f9ad5f4d2b343
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3924327f9ad5f4d2b343@syzkaller.appspotmail.com

list_add corruption. next->prev should be prev (ffff88809a7ba700), but was  
ffff88808b433c00. (next=ffff88809c320b60).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:23!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__list_add_valid.cold+0xf/0x3c lib/list_debug.c:23
Code: 67 fe eb d5 4c 89 e7 e8 ea 4b 67 fe eb a3 4c 89 f7 e8 e0 4b 67 fe e9  
56 ff ff ff 4c 89 e1 48 c7 c7 e0 fd e6 87 e8 50 27 15 fe <0f> 0b 48 89 f2  
4c 89 e1 4c 89 ee 48 c7 c7 20 ff e6 87 e8 39 27 15
RSP: 0018:ffff8880a98ae848 EFLAGS: 00010286
RAX: 0000000000000075 RBX: 000000010002e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ccbc6 RDI: ffffed1015315cfb
RBP: ffff8880a98ae860 R08: 0000000000000075 R09: ffffed1015d06159
R10: ffffed1015d06158 R11: ffff8880ae830ac7 R12: ffff88809c320b60
R13: ffff8880a79fdb00 R14: ffff88809c320b60 R15: ffff88809a7ba700
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000d43ea0 CR3: 000000008e786000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __list_add_rcu include/linux/rculist.h:70 [inline]
  list_add_tail_rcu include/linux/rculist.h:119 [inline]
  hsr_add_node+0x330/0x4d0 net/hsr/hsr_framereg.c:155
  hsr_get_node+0x3db/0x530 net/hsr/hsr_framereg.c:199
  hsr_fill_frame_info net/hsr/hsr_forward.c:315 [inline]
  hsr_forward_skb+0x3d0/0x1d30 net/hsr/hsr_forward.c:358
  hsr_dev_xmit+0x72/0xa0 net/hsr/hsr_device.c:231
  __netdev_start_xmit include/linux/netdevice.h:4425 [inline]
  netdev_start_xmit include/linux/netdevice.h:4439 [inline]
  xmit_one net/core/dev.c:3420 [inline]
  dev_hard_start_xmit+0x1a3/0x9b0 net/core/dev.c:3436
  __dev_queue_xmit+0x2c6c/0x3720 net/core/dev.c:4013
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  br_dev_queue_push_xmit+0x3f3/0x5e0 net/bridge/br_forward.c:52
  br_nf_dev_queue_xmit+0x34e/0x14b0 net/bridge/br_netfilter_hooks.c:800
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  br_nf_post_routing+0x1502/0x1d30 net/bridge/br_netfilter_hooks.c:848
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  br_forward_finish+0x215/0x400 net/bridge/br_forward.c:65
  br_nf_hook_thresh+0x2e9/0x370 net/bridge/br_netfilter_hooks.c:1019
  br_nf_forward_finish+0x66c/0xa90 net/bridge/br_netfilter_hooks.c:564
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  br_nf_forward_ip net/bridge/br_netfilter_hooks.c:634 [inline]
  br_nf_forward_ip+0xc74/0x21e0 net/bridge/br_netfilter_hooks.c:575
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_slow+0xbc/0x1e0 net/netfilter/core.c:512
  nf_hook include/linux/netfilter.h:262 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  __br_forward+0x393/0xb00 net/bridge/br_forward.c:109
  deliver_clone+0x61/0xc0 net/bridge/br_forward.c:125
  maybe_deliver+0x2c7/0x390 net/bridge/br_forward.c:181
  br_flood+0x13a/0x3d0 net/bridge/br_forward.c:223
  br_handle_frame_finish+0xb46/0x1670 net/bridge/br_input.c:162
  br_nf_hook_thresh+0x2e9/0x370 net/bridge/br_netfilter_hooks.c:1019
  br_nf_pre_routing_finish_ipv6+0x6fa/0xdb0  
net/bridge/br_netfilter_ipv6.c:206
  NF_HOOK include/linux/netfilter.h:307 [inline]
  br_nf_pre_routing_ipv6+0x456/0x840 net/bridge/br_netfilter_ipv6.c:236
  br_nf_pre_routing+0x18af/0x22d1 net/bridge/br_netfilter_hooks.c:505
  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
  nf_hook_bridge_pre net/bridge/br_input.c:223 [inline]
  br_handle_frame+0x806/0x1340 net/bridge/br_input.c:348
  __netif_receive_skb_core+0x10ad/0x3450 net/core/dev.c:5051
  __netif_receive_skb_one_core+0xa8/0x1a0 net/core/dev.c:5148
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5264
  process_backlog+0x206/0x750 net/core/dev.c:6096
  napi_poll net/core/dev.c:6533 [inline]
  net_rx_action+0x508/0x1120 net/core/dev.c:6601
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 580ee54eb1827b06 ]---
RIP: 0010:__list_add_valid.cold+0xf/0x3c lib/list_debug.c:23
Code: 67 fe eb d5 4c 89 e7 e8 ea 4b 67 fe eb a3 4c 89 f7 e8 e0 4b 67 fe e9  
56 ff ff ff 4c 89 e1 48 c7 c7 e0 fd e6 87 e8 50 27 15 fe <0f> 0b 48 89 f2  
4c 89 e1 4c 89 ee 48 c7 c7 20 ff e6 87 e8 39 27 15
RSP: 0018:ffff8880a98ae848 EFLAGS: 00010286
RAX: 0000000000000075 RBX: 000000010002e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ccbc6 RDI: ffffed1015315cfb
RBP: ffff8880a98ae860 R08: 0000000000000075 R09: ffffed1015d06159
R10: ffffed1015d06158 R11: ffff8880ae830ac7 R12: ffff88809c320b60
R13: ffff8880a79fdb00 R14: ffff88809c320b60 R15: ffff88809a7ba700
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000d43ea0 CR3: 000000008e786000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
