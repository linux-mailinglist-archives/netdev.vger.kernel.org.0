Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87A833114
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfFCNbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:31:10 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:56760 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfFCNbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:31:05 -0400
Received: by mail-it1-f198.google.com with SMTP id l124so15087512itg.6
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Xd9c0wiNMk6Apek2lhhQ7MeiJewPRVMefJXoiTf1Kzk=;
        b=dC8SDWeJdUCpImWH3D7olFYtX+dlGXJDQ83GmFRW25BtXzfLJoXEXDz2SYtZiqUMD/
         d4wbF3CktV9B7/ahndaXzdbKV2snuqgTUe8pWoVrj3PfdnCHT+8/5FH8kNgyCoqNzibe
         i3+HAQjp2so7sxumCqWEaK54QjCjcgZyrOCB6P4ujGN9PJn4UGEGicJajWsTjoJymsgw
         ZClT0rqighHf4l6HQ2MHp9MyDJz3VhttpNgDalnNYyzgFQEHz3Bbqe1/HswxaPpBTDSE
         iA0E6LKAMvN4SgiUPBbP+WnShV8V0KHNTZRGzfoROvSa9NijPjwPd/RPqHkwHjsb8eNT
         TsIA==
X-Gm-Message-State: APjAAAUH6fQpv7A53715yT21KjuediI6Q30Fm/kHyJ+Tt3tV4DSeKOh0
        58ETA1oNlc8903IfZo1K+2oIS3lAC/4DkbwNswTNR/VlYWcP
X-Google-Smtp-Source: APXvYqzgujQbAIS/Q+3FyQrH3nuh9kfgM04XgvloUsUlk8OX4StVb91+53wTYXM1u9UxnN/Ag0AEck9BFvOQ2gzYiBIaW0D8pNES
MIME-Version: 1.0
X-Received: by 2002:a24:6e90:: with SMTP id w138mr17164666itc.150.1559568664806;
 Mon, 03 Jun 2019 06:31:04 -0700 (PDT)
Date:   Mon, 03 Jun 2019 06:31:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044cec9058a6b6003@google.com>
Subject: INFO: trying to register non-static key in mwifiex_unregister_dev
From:   syzbot <syzbot+373e6719b49912399d21@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        gbhat@marvell.com, huxinming820@gmail.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        nishants@marvell.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    69bbe8c7 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=1448d0f2a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=193d8457178b3229
dashboard link: https://syzkaller.appspot.com/bug?extid=373e6719b49912399d21
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e57ca6a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1106eda2a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+373e6719b49912399d21@syzkaller.appspotmail.com

usb 1-1: Using ep0 maxpacket: 8
usb 1-1: config 0 has an invalid interface number: 182 but max is 0
usb 1-1: config 0 has no interface number 0
usb 1-1: New USB device found, idVendor=1286, idProduct=2052,  
bcdDevice=61.43
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
usb 1-1: Direct firmware load for mrvl/usbusb8997_combo_v4.bin failed with  
error -2
usb 1-1: Failed to get firmware mrvl/usbusb8997_combo_v4.bin
usb 1-1: info: _mwifiex_fw_dpc: unregister device
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.2.0-rc1+ #10
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  assign_lock_key kernel/locking/lockdep.c:774 [inline]
  register_lock_class+0x11ae/0x1240 kernel/locking/lockdep.c:1083
  __lock_acquire+0x11d/0x5340 kernel/locking/lockdep.c:3673
  lock_acquire+0x100/0x2b0 kernel/locking/lockdep.c:4302
  del_timer_sync+0x3a/0x130 kernel/time/timer.c:1277
  mwifiex_usb_cleanup_tx_aggr  
drivers/net/wireless/marvell/mwifiex/usb.c:1358 [inline]
  mwifiex_unregister_dev+0x416/0x690  
drivers/net/wireless/marvell/mwifiex/usb.c:1370
  _mwifiex_fw_dpc+0x577/0xda0 drivers/net/wireless/marvell/mwifiex/main.c:651
  request_firmware_work_func+0x126/0x242  
drivers/base/firmware_loader/main.c:785
  process_one_work+0x905/0x1570 kernel/workqueue.c:2268
  worker_thread+0x96/0xe20 kernel/workqueue.c:2414
  kthread+0x30b/0x410 kernel/kthread.c:254
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list  
hint: 0x0
WARNING: CPU: 1 PID: 21 at lib/debugobjects.c:325  
debug_print_object+0x160/0x250 lib/debugobjects.c:325


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
