Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C320E630
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404049AbgF2VpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgF2Sho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:44 -0400
Received: from mail-io1-xd46.google.com (mail-io1-xd46.google.com [IPv6:2607:f8b0:4864:20::d46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDBBC030F03
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:11:17 -0700 (PDT)
Received: by mail-io1-xd46.google.com with SMTP id 14so1261941ioz.17
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fHNShTIFKimzlTuSuHsOSN8MhkqtCX4a3iQZfPeFGNk=;
        b=KTKh2bb4oyRx/bap0EeJq6V9OrdZbnG/BduLhvOF2NFc3IqfdLx+bc+0yFZBzpFfEM
         x6oxf6kaML3FDps8jnLx2hpQItHoy8zeUHnRN1SOV192oiynG1zs5fkCHtKQ6ry5ek11
         t/4mVtJYUOg5rxvBrokU/e1n29eS+7LPdxXpeOX2HTlmftc4dHXFKpKpS9N5Y6BngDgw
         3MVvDgS+vKV0jAU51+39ILYgsys5RONWwRwHNwqSuwZX4wt1RT2+png4A7llO3pqB3RI
         cSqcyjiV24sOO/XgZ6iK9sw8dOilmClboVd2ek5mZjsIFAQZsIPhav4wj/caa4GydOmw
         /v5A==
X-Gm-Message-State: AOAM532C8ADRrvijKp68CYoOYMxPbZINat3lcVzSJZXBmpM196kguoA2
        rteDfmhDlC5WTrpKDjho3CHygivXpUb4LjLHsK2aInyBJmIf
X-Google-Smtp-Source: ABdhPJysiOaUNCY1J4HnT+7BtSo8nTwGdQ9+J7zWVN+86liAyR0PJzzajluP2G91WNKtFm0zWVNujfGJaPc71DuMmFALwhrQmBw+
MIME-Version: 1.0
X-Received: by 2002:a05:6602:140b:: with SMTP id t11mr17540527iov.198.1593447076756;
 Mon, 29 Jun 2020 09:11:16 -0700 (PDT)
Date:   Mon, 29 Jun 2020 09:11:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa90bb05a93b4e52@google.com>
Subject: KMSAN: uninit-value in macvlan_start_xmit
From:   syzbot <syzbot+301cccce1b286fa6449e@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, dong.menglong@zte.com.cn,
        edumazet@google.com, glider@google.com,
        linux-kernel@vger.kernel.org, maheshb@google.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f0d5ec90 kmsan: apply __no_sanitize_memory to dotraplinkag..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1565759b100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86e4f8af239686c6
dashboard link: https://syzkaller.appspot.com/bug?extid=301cccce1b286fa6449e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132ae8f5100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=156200f3100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+301cccce1b286fa6449e@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in macvlan_queue_xmit drivers/net/macvlan.c:521 [inline]
BUG: KMSAN: uninit-value in macvlan_start_xmit+0x3ea/0xb50 drivers/net/macvlan.c:562
CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 macvlan_queue_xmit drivers/net/macvlan.c:521 [inline]
 macvlan_start_xmit+0x3ea/0xb50 drivers/net/macvlan.c:562
 __netdev_start_xmit include/linux/netdevice.h:4533 [inline]
 netdev_start_xmit include/linux/netdevice.h:4547 [inline]
 xmit_one net/core/dev.c:3477 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3493
 __dev_queue_xmit+0x2f8d/0x3b20 net/core/dev.c:4052
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4085
 hsr_xmit net/hsr/hsr_forward.c:228 [inline]
 hsr_forward_do net/hsr/hsr_forward.c:285 [inline]
 hsr_forward_skb+0x2614/0x30d0 net/hsr/hsr_forward.c:361
 hsr_handle_frame+0x3be/0x500 net/hsr/hsr_slave.c:44
 __netif_receive_skb_core+0x21ce/0x5870 net/core/dev.c:5089
 __netif_receive_skb_one_core net/core/dev.c:5186 [inline]
 __netif_receive_skb net/core/dev.c:5302 [inline]
 process_backlog+0x936/0x1410 net/core/dev.c:6134
 napi_poll net/core/dev.c:6572 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6640
 __do_softirq+0x311/0x83d kernel/softirq.c:293
 run_ksoftirqd+0x25/0x40 kernel/softirq.c:608
 smpboot_thread_fn+0x493/0x980 kernel/smpboot.c:165
 kthread+0x4b5/0x4f0 kernel/kthread.c:269
 ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:353

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1636
 __skb_pad+0x47f/0x900 net/core/skbuff.c:1804
 __skb_put_padto include/linux/skbuff.h:3244 [inline]
 skb_put_padto include/linux/skbuff.h:3263 [inline]
 send_hsr_supervision_frame+0x122d/0x1500 net/hsr/hsr_device.c:301
 hsr_announce+0x1e2/0x370 net/hsr/hsr_device.c:332
 call_timer_fn+0x218/0x510 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers+0xcff/0x1210 kernel/time/timer.c:1774
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1787
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xb9/0x180 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0x56a2/0x5dc0 mm/page_alloc.c:4848
 __alloc_pages include/linux/gfp.h:504 [inline]
 __alloc_pages_node include/linux/gfp.h:517 [inline]
 alloc_pages_node include/linux/gfp.h:531 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4923 [inline]
 page_frag_alloc+0x3ae/0x910 mm/page_alloc.c:4953
 __napi_alloc_skb+0x193/0xa60 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2876 [inline]
 page_to_skb+0x1a2/0x1390 drivers/net/virtio_net.c:384
 receive_mergeable drivers/net/virtio_net.c:935 [inline]
 receive_buf+0xec6/0x8d20 drivers/net/virtio_net.c:1045
 virtnet_receive drivers/net/virtio_net.c:1335 [inline]
 virtnet_poll+0x64b/0x19f0 drivers/net/virtio_net.c:1440
 napi_poll net/core/dev.c:6572 [inline]
 net_rx_action+0x786/0x1aa0 net/core/dev.c:6640
 __do_softirq+0x311/0x83d kernel/softirq.c:293
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
