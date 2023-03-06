Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9EF6AB6EA
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjCFHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 02:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCFHWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:22:53 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855501C7CC
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 23:22:51 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id v14-20020a92c80e000000b0031faea6493cso1446472iln.11
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 23:22:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZoa4m6FEfnQaYMSu4CgCJx4+GY8uuz4pvBCiPijuw0=;
        b=Zym00yrsKNRJPm7KfTrdydA84EWqxv7uyA4wkQJzEf+t409AX0UApzQShA3GjRpPir
         3nDxDxSI7RqPOrzgA9+tQu8a027uDSexgeulv85rcQkBlLX6Ur7/zY1boUG1k6edsRo3
         rn7FWdqLYM5JzTzdg0Wt71R91XPjqCHQyVImvbMU+w5pMa6rw7oz470G/7o7S0CvsdiI
         AWye2qNnXKx8V7jJ/MV5wwI1Awfh4HmQSslzmmjWlSKGCoV4VbWeopy4fOWlVYxHR20p
         aO+5Nrd1KrytdBaHDpZQfUWzpOh9mzUX/ZBm4iRJYxzgb0MUwE28g/TQKLT6yU8OkXRN
         JGoQ==
X-Gm-Message-State: AO0yUKXO5Eq0PyPMbrCsoULVCO3F/OENFpboPRbevcTreVTnmnEzb65A
        j48KuneTdUXrjIDQ3euoqDuUFrItZf1c1MisZATXVNDLIo/d
X-Google-Smtp-Source: AK7set93N6rJzgsUJtWwSTMcs7aQ81sO3w7Wq4CfHTV4TScoHLpiKcssCsNEdoqZu3tX7gG19NKXLTXiWl350WJP/e56mh5hqK1o
MIME-Version: 1.0
X-Received: by 2002:a5d:8858:0:b0:745:33df:c498 with SMTP id
 t24-20020a5d8858000000b0074533dfc498mr4767773ios.3.1678087370881; Sun, 05 Mar
 2023 23:22:50 -0800 (PST)
Date:   Sun, 05 Mar 2023 23:22:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a4c51705f63629cb@google.com>
Subject: [syzbot] [wireless?] KMSAN: uninit-value in ath9k_hw_init
From:   syzbot <syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, kvalo@kernel.org, linux-kernel@vger.kernel.org,
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

HEAD commit:    944070199c5e kmsan: add memsetXX tests
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=172481f2c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46c642641b9ef616
dashboard link: https://syzkaller.appspot.com/bug?extid=df61b36319e045c00a08
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15055432c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1010b19cc80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/055bbd57e905/disk-94407019.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/82472690bcfe/vmlinux-94407019.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db3f379532ab/bzImage-94407019.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com

ath9k_htc 6-1:1.0: ath9k_htc: HTC initialized with 33 credits
=====================================================
BUG: KMSAN: uninit-value in ath9k_hw_read_revisions drivers/net/wireless/ath/ath9k/hw.c:289 [inline]
BUG: KMSAN: uninit-value in __ath9k_hw_init drivers/net/wireless/ath/ath9k/hw.c:572 [inline]
BUG: KMSAN: uninit-value in ath9k_hw_init+0x11e0/0x2d60 drivers/net/wireless/ath/ath9k/hw.c:700
 ath9k_hw_read_revisions drivers/net/wireless/ath/ath9k/hw.c:289 [inline]
 __ath9k_hw_init drivers/net/wireless/ath/ath9k/hw.c:572 [inline]
 ath9k_hw_init+0x11e0/0x2d60 drivers/net/wireless/ath/ath9k/hw.c:700
 ath9k_init_priv drivers/net/wireless/ath/ath9k/htc_drv_init.c:662 [inline]
 ath9k_init_device drivers/net/wireless/ath/ath9k/htc_drv_init.c:839 [inline]
 ath9k_htc_probe_device+0xf48/0x3b60 drivers/net/wireless/ath/ath9k/htc_drv_init.c:963
 ath9k_htc_hw_init+0x4f/0x100 drivers/net/wireless/ath/ath9k/htc_hst.c:521
 ath9k_hif_usb_firmware_cb+0x2eb/0x800 drivers/net/wireless/ath/ath9k/hif_usb.c:1243
 request_firmware_work_func+0x130/0x240 drivers/base/firmware_loader/main.c:1107
 process_one_work+0xb0d/0x1410 kernel/workqueue.c:2289
 worker_thread+0x107b/0x1d60 kernel/workqueue.c:2436
 kthread+0x31f/0x430 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Local variable val created at:
 ath9k_regread+0x62/0x1b0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:239
 ath9k_hw_read_revisions drivers/net/wireless/ath/ath9k/hw.c:287 [inline]
 __ath9k_hw_init drivers/net/wireless/ath/ath9k/hw.c:572 [inline]
 ath9k_hw_init+0x5be/0x2d60 drivers/net/wireless/ath/ath9k/hw.c:700

CPU: 0 PID: 115 Comm: kworker/0:2 Not tainted 6.2.0-syzkaller-81157-g944070199c5e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Workqueue: events request_firmware_work_func
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
