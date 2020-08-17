Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1558246FB7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389258AbgHQRwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:52:20 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:34980 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbgHQRvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 13:51:22 -0400
Received: by mail-io1-f71.google.com with SMTP id k20so10017597iog.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 10:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tef9SyC/DPbeM4vGO9X8D7q/BkFTLwMgzsKkMCcRRfY=;
        b=g02eYerJadzxAvw97OOvYr1wTnl2cYXBCv6DusIJ9hIHh7oaPSbp5If2Uc6MH75mSB
         eH/+x5ODjIFXYOpf3En0p/OaiNk47ScxCaMiCGcqZ/pt8FOHvkoQd3NkK3ZE/6HATJjw
         mebCXZcjm3oLrVq482wFTRCrL2G9+Xj3JlVYwk/RlYHpL4kRwxif+XMQEIroh96+wtcK
         X5qS6KNzhs8uhPmFLL6Thi8Dw5mWvOm/iN/mhBR7DiHUaMMHiypLQipdsmiHQEeY9swJ
         4izTK6OMO2G2ILf7WXG0c6ZD2mTF0PaBTjyHxd5F0Z0atbxAQsV8w4SO6LK5N5P1Mh/P
         8hgA==
X-Gm-Message-State: AOAM531KIHWANL3B1WBY5E9z7AdebqturWkiznAf5MYZg4CZwOwgd6cZ
        V341ZrOkhRjfNElNdoTtJQyKYSvw9B3rjn79lObgoi5gIyH4
X-Google-Smtp-Source: ABdhPJzsDWXHbORSENDAZjQHsVROvP425ZbcV35BXeYXiXRrUfjPOzhoidxjUoFMg+GQnjyPIe2MW/KmGPKvfyOcP727hATbvgkc
MIME-Version: 1.0
X-Received: by 2002:a92:4414:: with SMTP id r20mr14870589ila.299.1597686681560;
 Mon, 17 Aug 2020 10:51:21 -0700 (PDT)
Date:   Mon, 17 Aug 2020 10:51:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ded4605ad166bda@google.com>
Subject: KMSAN: uninit-value in smsc95xx_reset
From:   syzbot <syzbot+c74c24b43c9ae534f0e0@syzkaller.appspotmail.com>
To:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        glider@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1496679e900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=c74c24b43c9ae534f0e0
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d8cc86900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117e8fbe900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c74c24b43c9ae534f0e0@syzkaller.appspotmail.com

smsc95xx 1-1:1.0 (unnamed net_device) (uninitialized): Failed to read reg index 0x00000030: -32
smsc95xx 1-1:1.0 (unnamed net_device) (uninitialized): Error reading E2P_CMD
=====================================================
BUG: KMSAN: uninit-value in smsc95xx_reset+0x353/0x3eb0 drivers/net/usb/smsc95xx.c:1039
CPU: 1 PID: 27 Comm: kworker/1:1 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 smsc95xx_reset+0x353/0x3eb0 drivers/net/usb/smsc95xx.c:1039
 smsc95xx_bind+0x8b3/0x1720 drivers/net/usb/smsc95xx.c:1289
 usbnet_probe+0x1152/0x3f90 drivers/net/usb/usbnet.c:1737
 usb_probe_interface+0xece/0x1550 drivers/usb/core/driver.c:374
 really_probe+0xf20/0x20b0 drivers/base/dd.c:529
 driver_probe_device+0x293/0x390 drivers/base/dd.c:701
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:807
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x4e2/0x7f0 drivers/base/dd.c:873
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:920
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x3b0e/0x40d0 drivers/base/core.c:2680
 usb_set_configuration+0x380f/0x3f10 drivers/usb/core/message.c:2032
 usb_generic_driver_probe+0x138/0x300 drivers/usb/core/generic.c:241
 usb_probe_device+0x311/0x490 drivers/usb/core/driver.c:272
 


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
