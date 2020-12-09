Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE02D3E16
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgLIJDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:03:53 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:33500 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728630AbgLIJDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:03:52 -0500
Received: by mail-io1-f72.google.com with SMTP id t23so756858ioh.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 01:03:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pCg9ztFovQSMSdHHqXzDsgJzAHlx4/5H0ssw+mDzOcM=;
        b=pm9Jy+b3U+SxcgCjVIFUJ3m22XyccpbHEHH3wik6niVwGJ8kcm9FIAWUCn2UooSXNV
         b/OdhZMrvX12etZ5BuHecUNCN9am/ilek2c9TiQi4t9rwjvFizVhLQe37RC6oniNQEth
         5t0JHSragsZnwH10UGFpGXbUARCzdHAe9GoEKmhUMmrWv6aEJO6j+r7LsjmWGfRgSRZD
         XZWfRpvAPPThSVxSsf3mttOJwngjQtsiMEB9HftQsvvd9ho/c8zOOiFllnUmhyiil/B+
         IzyUClDWiiNmKXIGn9xooC7fC0NgODN39qPEuTWaOAxg9e5AOaL8vU3hyx/BuJEj+Qem
         DXXg==
X-Gm-Message-State: AOAM532uRVtdoUhXBomY+imHIi2zcRLPchAudQnYtpGsfCX7okoe27ea
        1Gs+TZeMqwW+IPWgS1oN+FbAw1bA2at0ZN84uKCUmP31EkaP
X-Google-Smtp-Source: ABdhPJyLvpOsROcoK5EDCWBWV0mBhklN7V2CXAzU92Btl9jwqKU9+Ht0vkdSKshvgTS8ZLkhHz8WbeGWxGEtqjXROXowso+PQlTF
MIME-Version: 1.0
X-Received: by 2002:a5e:9906:: with SMTP id t6mr1514061ioj.183.1607504591672;
 Wed, 09 Dec 2020 01:03:11 -0800 (PST)
Date:   Wed, 09 Dec 2020 01:03:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002959f405b604541c@google.com>
Subject: KMSAN: uninit-value in smsc75xx_read_eeprom (2)
From:   syzbot <syzbot+341170ccba949fac01a2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, steve.glendinning@shawell.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    73d62e81 kmsan: random: prevent boot-time reports in _mix_..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1256cc13500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eef728deea880383
dashboard link: https://syzkaller.appspot.com/bug?extid=341170ccba949fac01a2
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+341170ccba949fac01a2@syzkaller.appspotmail.com

cdc_ether: probe of 5-1:1.0 failed with error -22
smsc75xx v1.0.0
=====================================================
BUG: KMSAN: uninit-value in smsc75xx_eeprom_confirm_not_busy drivers/net/usb/smsc75xx.c:333 [inline]
BUG: KMSAN: uninit-value in smsc75xx_read_eeprom+0x266/0xa10 drivers/net/usb/smsc75xx.c:352
CPU: 1 PID: 8502 Comm: kworker/1:0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 smsc75xx_eeprom_confirm_not_busy drivers/net/usb/smsc75xx.c:333 [inline]
 smsc75xx_read_eeprom+0x266/0xa10 drivers/net/usb/smsc75xx.c:352
 smsc75xx_init_mac_address drivers/net/usb/smsc75xx.c:771 [inline]
 smsc75xx_bind+0xc71/0x13f0 drivers/net/usb/smsc75xx.c:1489
 usbnet_probe+0x1169/0x3e90 drivers/net/usb/usbnet.c:1712
 usb_probe_interface+0xfcc/0x1520 drivers/usb/core/driver.c:396
 really_probe+0xebd/0x2420 drivers/base/dd.c:558
 driver_probe_device+0x293/0x390 drivers/base/dd.c:738
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:844
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x538/0x860 drivers/base/dd.c:912
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:959
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x399e/0x3f20 drivers/base/core.c:2936
 usb_set_configuration+0x39cf/0x4010 drivers/usb/core/message.c:2159
 usb_generic_driver_probe+0x138/0x300 drivers/usb/core/generic.c:238
 usb_probe_device+0x317/0x570 drivers/usb/core/driver.c:293
 really_probe+0xebd/0x2420 drivers/base/dd.c:558
 driver_probe_device+0x293/0x390 drivers/base/dd.c:738
 __device_attach_driver+0x63f/0x830 drivers/base/dd.c:844
 bus_for_each_drv+0x2ca/0x3f0 drivers/base/bus.c:431
 __device_attach+0x538/0x860 drivers/base/dd.c:912
 device_initial_probe+0x4a/0x60 drivers/base/dd.c:959
 bus_probe_device+0x177/0x3d0 drivers/base/bus.c:491
 device_add+0x399e/0x3f20 drivers/base/core.c:2936
 usb_new_device+0x1bd6/0x2a30 drivers/usb/core/hub.c:2554
 hub_port_connect drivers/usb/core/hub.c:5222 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5362 [inline]
 port_event drivers/usb/core/hub.c:5508 [inline]
 hub_event+0x5bc9/0x8890 drivers/usb/core/hub.c:5590
 process_one_work+0x121c/0x1fc0 kernel/workqueue.c:2272
 worker_thread+0x10cc/0x2740 kernel/workqueue.c:2418
 kthread+0x51c/0x560 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Local variable ----buf.i.i92@smsc75xx_read_eeprom created at:
 __smsc75xx_read_reg drivers/net/usb/smsc75xx.c:322 [inline]
 smsc75xx_read_reg drivers/net/usb/smsc75xx.c:147 [inline]
 smsc75xx_eeprom_confirm_not_busy drivers/net/usb/smsc75xx.c:327 [inline]
 smsc75xx_read_eeprom+0x124/0xa10 drivers/net/usb/smsc75xx.c:352
 __smsc75xx_read_reg drivers/net/usb/smsc75xx.c:322 [inline]
 smsc75xx_read_reg drivers/net/usb/smsc75xx.c:147 [inline]
 smsc75xx_eeprom_confirm_not_busy drivers/net/usb/smsc75xx.c:327 [inline]
 smsc75xx_read_eeprom+0x124/0xa10 drivers/net/usb/smsc75xx.c:352
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
