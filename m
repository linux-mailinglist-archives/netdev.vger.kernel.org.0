Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D754AD479
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353277AbiBHJNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353144AbiBHJNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:13:23 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ED0C0401F0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 01:13:23 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id x6-20020a056602160600b00637be03f7b8so6852096iow.17
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 01:13:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d853FYKiMfJBLFjIJPTK0l7nRNte7hxVebJY6lt/Hww=;
        b=hOL8gN1CCZK+0ijwmO//WFQ84GZOtYawadghe5vg9yo7AdT7V1wJUTHQwdGDhkNchi
         huhGDqFfMGg+0kPw3bG6IM7VdsQQIZvIbl1lbJeZ6zq9UeA5pEaEKXtKd76kPx1vgGDE
         pJUdXJtBqWRfZKNMDFTf/3QvOeXEYus1fKFYqVXBWsIRN+Y00zqfZYuUfHK3CpF6L155
         JirFXP43tLVsVuk87TYULsSiCOS/TwKJRIXGmOUO2xHqE7kGfSXcK3rpOYMCoL56C8qM
         7xEzqoq1w1X5bsS1ArUwyC8M5PmJ6HlB3eGczhRSfWEyvNhtPrBDyIbBpG7penbfu30v
         yugg==
X-Gm-Message-State: AOAM531uRWpqNj4U5TbGuk+swxyHAe6hLHwj8BgYYcN0dF7PF8K2dHn2
        6ObHW1cOeJz5zt4RV1Sn4B640VbiFcr5W1zoJT3eDSaIOSnv
X-Google-Smtp-Source: ABdhPJyl5someFze/leMXY+UMeZB6KyqLyKyMR1xHO5v+gqxDic6OW0E2pPO816147akPaw6tPNqw/l+tSUjpJorZcF2e+VR7EY+
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2182:: with SMTP id j2mr1752703ila.304.1644311602369;
 Tue, 08 Feb 2022 01:13:22 -0800 (PST)
Date:   Tue, 08 Feb 2022 01:13:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5988505d77e20e4@google.com>
Subject: [syzbot] KCSAN: data-race in wg_packet_handshake_receive_worker /
 wg_packet_rx_poll (3)
From:   syzbot <syzbot+ed414b05fe54c96947f8@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    455e73a07f6e Merge tag 'clk-for-linus' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=131009feb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1f9a6122410716
dashboard link: https://syzkaller.appspot.com/bug?extid=ed414b05fe54c96947f8
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ed414b05fe54c96947f8@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in wg_packet_handshake_receive_worker / wg_packet_rx_poll

read to 0xffff88813238a9e0 of 8 bytes by interrupt on cpu 1:
 update_rx_stats drivers/net/wireguard/receive.c:28 [inline]
 wg_packet_consume_data_done drivers/net/wireguard/receive.c:365 [inline]
 wg_packet_rx_poll+0xf6b/0x11f0 drivers/net/wireguard/receive.c:481
 __napi_poll+0x65/0x3f0 net/core/dev.c:6365
 napi_poll net/core/dev.c:6432 [inline]
 net_rx_action+0x29e/0x650 net/core/dev.c:6519
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 do_softirq+0xb1/0xf0 kernel/softirq.c:459
 __local_bh_enable_ip+0x68/0x70 kernel/softirq.c:383
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:167 [inline]
 _raw_spin_unlock_bh+0x33/0x40 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 ptr_ring_consume_bh include/linux/ptr_ring.h:367 [inline]
 wg_packet_decrypt_worker+0x73c/0x780 drivers/net/wireguard/receive.c:506
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

write to 0xffff88813238a9e0 of 8 bytes by task 5035 on cpu 0:
 update_rx_stats drivers/net/wireguard/receive.c:28 [inline]
 wg_receive_handshake_packet drivers/net/wireguard/receive.c:205 [inline]
 wg_packet_handshake_receive_worker+0x54a/0x6e0 drivers/net/wireguard/receive.c:220
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x2c7/0x2e0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

value changed: 0x0000000000000aa8 -> 0x0000000000000ac8

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 5035 Comm: kworker/0:60 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-kex-wg2 wg_packet_handshake_receive_worker
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
