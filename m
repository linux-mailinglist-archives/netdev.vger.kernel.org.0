Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69355FCB51
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 21:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJLTK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 15:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJLTK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 15:10:56 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A06CD5EE
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 12:10:54 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id i4-20020a056e02152400b002fa876e95b3so14028687ilu.17
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 12:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t8nF4IQtb58XajClhN/mJflKMS7BVWwTL21p2c0pUdE=;
        b=vSZoNhmgT5E3vgYzyEs4fiDnVdNDRkz9V0bn0Dv6uGAEVEj0SxB/gC+01AsqT5BsnY
         DFXn1GKVA+zrW4wq7mb4/LxqapBZsowostY03RFKD+6v97OzV7PaHmvZazsFhZijCk86
         eC1OKQ+AMMbKpJ19rQevMI/RbNrcCntAordEs4j/DkVs6tZnpiQN7B5wGiivD94CYu/M
         QzB9vsunOGalqnGQxRNz4rlRtVnE57uew7dAuNtpCMGV9uMYofY9FzhF5XmxUrx3y61E
         fCO8VC4buQo/GKtAzVogVpLC8R65G0rdJ2DGszz802OL4vOpYMTxLJd0XJ7womfPGXYt
         071g==
X-Gm-Message-State: ACrzQf2MHbYsS7aqMBsZlGKe3g5W9dGZ1RLgVDRblFjO0hPC9WhVVyFM
        uRzRbThndHFFnKoHxj6rVEapV8eYfT2BB5LWaDS+Q7qXX4vf
X-Google-Smtp-Source: AMsMyM769wpn0lgVxSpHUE8r7EbiB7B0ALKp6b6ZDTt0s75rSoUraJvBc3vF/4gqzjhy6gQZ1/K6MtPnwGw9ZMbA1m6J1v6HB9rN
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2589:b0:363:bc7a:19eb with SMTP id
 s9-20020a056638258900b00363bc7a19ebmr8309629jat.80.1665601853939; Wed, 12 Oct
 2022 12:10:53 -0700 (PDT)
Date:   Wed, 12 Oct 2022 12:10:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7639205eadb267a@google.com>
Subject: [syzbot] KMSAN: uninit-value in hsr_fill_frame_info (2)
From:   syzbot <syzbot+b11c500e990cac6ba129@syzkaller.appspotmail.com>
To:     claudiajkang@gmail.com, davem@davemloft.net,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        glider@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d6e2c8c7eb40 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=143fe3c6f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65d9eb7bfd2865c9
dashboard link: https://syzkaller.appspot.com/bug?extid=b11c500e990cac6ba129
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1257629ef00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17959c21f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b11c500e990cac6ba129@syzkaller.appspotmail.com

hsr0: VLAN not yet supported
=====================================================
BUG: KMSAN: uninit-value in hsr_fill_frame_info+0x495/0x770 net/hsr/hsr_forward.c:526
 hsr_fill_frame_info+0x495/0x770 net/hsr/hsr_forward.c:526
 fill_frame_info net/hsr/hsr_forward.c:605 [inline]
 hsr_forward_skb+0x7c4/0x3630 net/hsr/hsr_forward.c:619
 hsr_dev_xmit+0x23a/0x530 net/hsr/hsr_device.c:222
 __netdev_start_xmit include/linux/netdevice.h:4778 [inline]
 netdev_start_xmit include/linux/netdevice.h:4792 [inline]
 xmit_one+0x2f4/0x840 net/core/dev.c:3532
 dev_hard_start_xmit+0x186/0x440 net/core/dev.c:3548
 __dev_queue_xmit+0x22ee/0x3500 net/core/dev.c:4176
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4209
 packet_snd net/packet/af_packet.c:3063 [inline]
 packet_sendmsg+0x6671/0x7d60 net/packet/af_packet.c:3094
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 __sys_sendto+0x9ef/0xc70 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0x19c/0x210 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x51/0xa0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:754 [inline]
 slab_alloc_node mm/slub.c:3231 [inline]
 __kmalloc_node_track_caller+0xde3/0x14f0 mm/slub.c:4962
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1300 [inline]
 alloc_skb_with_frags+0x1df/0xd60 net/core/skbuff.c:5995
 sock_alloc_send_pskb+0xdf4/0xfc0 net/core/sock.c:2600
 packet_alloc_skb net/packet/af_packet.c:2911 [inline]
 packet_snd net/packet/af_packet.c:3006 [inline]
 packet_sendmsg+0x506f/0x7d60 net/packet/af_packet.c:3094
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 __sys_sendto+0x9ef/0xc70 net/socket.c:2040
 __do_sys_sendto net/socket.c:2052 [inline]
 __se_sys_sendto net/socket.c:2048 [inline]
 __x64_sys_sendto+0x19c/0x210 net/socket.c:2048
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x51/0xa0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 1 PID: 3506 Comm: syz-executor134 Not tainted 5.18.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
