Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575516A162A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 06:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBXFOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 00:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBXFOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 00:14:04 -0500
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97D426CC3
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 21:14:02 -0800 (PST)
Received: by mail-il1-f205.google.com with SMTP id q7-20020a92d407000000b00316e14800eeso5634898ilm.20
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 21:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kqZ7XneuRntTCBB1DZi7ITesqdwZnc0FmX8gi2f8IgI=;
        b=XaOKAQ8ZXApms/B8kqkFjV8Y8nvz9u2CVSCFSV/suHMsm3UXvIqF7vzOkD03c4otWS
         1yvFwJoILgjRzT3ax2k7GwWTuQw8ULErXy9pc+pbqDtbFMeQbIf4alN9Zgf2sZuBLVUt
         t3XC3QLx3Lmls1aqb7GW10aD6OJUbsAeBzjIbqaNp7f3Iw7XQgUXc01CaN7vlSQ3yWKa
         K6zmmyfu0Vbu6xNIzYU3HKD66zjltj8LD6I3lvi4srPKYHbTIRYEjgWqSkcUFCdjTY82
         vWuYbJRecTyXoZnpTgcy02ugwWzorU9QIUVI4xDDcj/JxRQQdZiRHrVTcPnvtglfGKWa
         U39g==
X-Gm-Message-State: AO0yUKWq+YmSgSZColcMdhbKvnfjnO3hNShM1YVrw/JxKqBqzdFSWAvb
        Na+ZLCHiWaBH9Xn8ls88mc+68li0r9RLoY+vPgjcw7ZvcljA
X-Google-Smtp-Source: AK7set+rWLsS+TAbBoMMXe2k+M/IiKXhTtVcO1gk5OOQLBp1vCNKZVNA+/uatAbgYnSCZvRDeHyQ+MNo9ypzYhjjVTROj1dMwJdK
MIME-Version: 1.0
X-Received: by 2002:a6b:c8ce:0:b0:745:451b:1280 with SMTP id
 y197-20020a6bc8ce000000b00745451b1280mr1575714iof.4.1677215640961; Thu, 23
 Feb 2023 21:14:00 -0800 (PST)
Date:   Thu, 23 Feb 2023 21:14:00 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007dceb405f56b32dc@google.com>
Subject: [syzbot] [wireless?] memory leak in htc_connect_service
From:   syzbot <syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com, toke@toke.dk
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

HEAD commit:    c9c3395d5e3d Linux 6.2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d3dd78c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eeb87d4dfcdb4cc0
dashboard link: https://syzkaller.appspot.com/bug?extid=b68fbebe56d8362907e8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16523630c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a3de27480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/54c384e0e6b1/disk-c9c3395d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c963b4b4fee5/vmlinux-c9c3395d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc3ecf1163b5/bzImage-c9c3395d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810a980800 (size 240):
  comm "kworker/1:1", pid 24, jiffies 4294947427 (age 16.220s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83b971c6>] __alloc_skb+0x206/0x270 net/core/skbuff.c:552
    [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
    [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wireless/ath/ath9k/htc_hst.c:259
    [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath/ath9k/htc_drv_init.c:137 [inline]
    [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
    [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
    [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:521
    [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
    [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/base/firmware_loader/main.c:1107
    [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:2436
    [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
    [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

BUG: memory leak
unreferenced object 0xffff888100b81a00 (size 512):
  comm "kworker/1:1", pid 24, jiffies 4294947427 (age 16.220s)
  hex dump (first 32 bytes):
    00 00 00 0a 00 00 00 00 00 02 01 02 00 00 02 01  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81514fab>] __do_kmalloc_node mm/slab_common.c:967 [inline]
    [<ffffffff81514fab>] __kmalloc_node_track_caller+0x4b/0x120 mm/slab_common.c:988
    [<ffffffff83b970a5>] kmalloc_reserve net/core/skbuff.c:492 [inline]
    [<ffffffff83b970a5>] __alloc_skb+0xe5/0x270 net/core/skbuff.c:565
    [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
    [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wireless/ath/ath9k/htc_hst.c:259
    [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath/ath9k/htc_drv_init.c:137 [inline]
    [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
    [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
    [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:521
    [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
    [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/base/firmware_loader/main.c:1107
    [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:2436
    [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
    [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

BUG: memory leak
unreferenced object 0xffff88810a88d100 (size 240):
  comm "kworker/0:2", pid 2491, jiffies 4294948230 (age 8.190s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83b971c6>] __alloc_skb+0x206/0x270 net/core/skbuff.c:552
    [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
    [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wireless/ath/ath9k/htc_hst.c:259
    [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath/ath9k/htc_drv_init.c:137 [inline]
    [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
    [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
    [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:521
    [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
    [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/base/firmware_loader/main.c:1107
    [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:2436
    [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
    [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

BUG: memory leak
unreferenced object 0xffff88810646b200 (size 512):
  comm "kworker/0:2", pid 2491, jiffies 4294948230 (age 8.190s)
  hex dump (first 32 bytes):
    00 00 00 0a 00 00 00 00 00 02 01 02 00 00 02 01  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81514fab>] __do_kmalloc_node mm/slab_common.c:967 [inline]
    [<ffffffff81514fab>] __kmalloc_node_track_caller+0x4b/0x120 mm/slab_common.c:988
    [<ffffffff83b970a5>] kmalloc_reserve net/core/skbuff.c:492 [inline]
    [<ffffffff83b970a5>] __alloc_skb+0xe5/0x270 net/core/skbuff.c:565
    [<ffffffff82eb3731>] alloc_skb include/linux/skbuff.h:1270 [inline]
    [<ffffffff82eb3731>] htc_connect_service+0x121/0x230 drivers/net/wireless/ath/ath9k/htc_hst.c:259
    [<ffffffff82ec03a5>] ath9k_htc_connect_svc drivers/net/wireless/ath/ath9k/htc_drv_init.c:137 [inline]
    [<ffffffff82ec03a5>] ath9k_init_htc_services.constprop.0+0xe5/0x390 drivers/net/wireless/ath/ath9k/htc_drv_init.c:157
    [<ffffffff82ec0747>] ath9k_htc_probe_device+0xf7/0x8a0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:959
    [<ffffffff82eb3ef5>] ath9k_htc_hw_init+0x35/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:521
    [<ffffffff82eb68dd>] ath9k_hif_usb_firmware_cb+0xcd/0x1f0 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
    [<ffffffff82aa835b>] request_firmware_work_func+0x4b/0x90 drivers/base/firmware_loader/main.c:1107
    [<ffffffff8129a35a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff8129ac7d>] worker_thread+0x5d/0x5b0 kernel/workqueue.c:2436
    [<ffffffff812a4fa9>] kthread+0x129/0x170 kernel/kthread.c:376
    [<ffffffff81002dcf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
