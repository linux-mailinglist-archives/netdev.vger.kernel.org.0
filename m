Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547344AD385
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349973AbiBHIdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349972AbiBHIdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:33:32 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45429C03FEC0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 00:33:30 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id f9-20020a92cb49000000b002be1f9405a3so4012527ilq.16
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 00:33:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Zu1f5wks8CG9qf+bEyfbwDDqbLe9bidYWfVJmudyP5c=;
        b=8AqkR3Otf6c/J5PTcBFZhdOa7bDoyCxoIzc9fYqXMQWhozxugTNXP89CcHCdd7dXII
         hax71ca/ljui00BHKvNmnMGNrvvv07S4gHg2l+f5GCguY5uPzuEVYcRmfdYCkh5Ybwa+
         hoyju9Sd3daayhw3dcYuxUgjcyfIunuD4uy6w9JKb5PjK7xEU0kvIpn9ByuDYMjuh3d5
         S2626YPUmopZZKRVuUyHHgWBNAhB9OoYpCFDHoXYe+evRo5Bszsl37R620PEQ5Zlm743
         qY18iHgGdPkaS1rR4mzmg2hZpGqhmgOA5JoxY/gVWsdVms4x166Ppz/yBQNJpJAuWo63
         ohqA==
X-Gm-Message-State: AOAM531JLtEOG2HrrWnLmyVtkk/Q+7YC9oMOxtJ4VZQoSzLa+0MIjQE3
        XE7XJeU1LJUruKfUtKMX3h9ayhf1tqxVHJsNCwacVvONi5a1
X-Google-Smtp-Source: ABdhPJz2gSdVhCHqfIAKJccadNo+Pwyc0aWv5nW4Iwpv1ik7Vv8sD+fb4hjvadw87gBxqOfFORmeIByV5Ol5nUDZY0Wah4vaPz+t
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2dd4:: with SMTP id l20mr1577514iow.115.1644309209624;
 Tue, 08 Feb 2022 00:33:29 -0800 (PST)
Date:   Tue, 08 Feb 2022 00:33:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005733c005d77d9215@google.com>
Subject: [syzbot] KCSAN: data-race in wg_packet_decrypt_worker /
 wg_packet_rx_poll (2)
From:   syzbot <syzbot+d1de830e4ecdaac83d89@syzkaller.appspotmail.com>
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

HEAD commit:    2ade8eef993c Merge tag 'ata-5.17-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112ef758700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1dcc3374da7c1f7c
dashboard link: https://syzkaller.appspot.com/bug?extid=d1de830e4ecdaac83d89
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d1de830e4ecdaac83d89@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in wg_packet_decrypt_worker / wg_packet_rx_poll

write to 0xffff888127d03888 of 8 bytes by interrupt on cpu 1:
 counter_validate drivers/net/wireguard/receive.c:328 [inline]
 wg_packet_rx_poll+0x436/0x11f0 drivers/net/wireguard/receive.c:468
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
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

read to 0xffff888127d03888 of 8 bytes by task 1912 on cpu 0:
 decrypt_packet drivers/net/wireguard/receive.c:259 [inline]
 wg_packet_decrypt_worker+0x23a/0x780 drivers/net/wireguard/receive.c:508
 process_one_work+0x3f6/0x960 kernel/workqueue.c:2307
 worker_thread+0x616/0xa70 kernel/workqueue.c:2454
 kthread+0x1bf/0x1e0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

value changed: 0x0000000000000bb9 -> 0x0000000000000bba

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 1912 Comm: kworker/0:3 Not tainted 5.17.0-rc3-syzkaller-00013-g2ade8eef993c-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg1 wg_packet_decrypt_worker
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
