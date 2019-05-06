Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADE5148C9
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfEFLQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 07:16:26 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:38172 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfEFLQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 07:16:07 -0400
Received: by mail-it1-f200.google.com with SMTP id r198so11254831itb.3
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 04:16:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wfo46abTbmuRXvxeTUG8sMq7sgvtISG77eUoUAEQFR8=;
        b=krNx/SDjIf2avW4BEysGnUeWAVDJprSy7w4wNEq3SFj/+D8vesffKtcF1HdFtAxRxE
         YAnVzyhk7Ls3hb83MmJbAL424FCkqVk5wCJg0wt/9+5ZgwBugm5Dk3P7dVNT+EZpmNFJ
         0bO1L4X2IitDM0zZ0s1vdDrjMI6pPwWDrkpqF5WMWLc9GbDAbqy3dzyA8TiwoS4i70D+
         6ZhrIZUfyq7rkQRU+4BVvarTuDNbpx0ga6ElAXyCwX2ooYQPn6rVD2fnTMXaOw7ea/O7
         3TrlBL6uxdIyCxYdfFVl4GC/bFOzJPJPusOZ8eAKKF3E8GPkXaxL15cEBo9dzjQU6kAk
         axOg==
X-Gm-Message-State: APjAAAVz01rsN5fF7RS+zMf0PfHSDYdcg4gynqtBMulHMN4aEJqxa6K+
        0E2ZekJz6DXlGKS1BGlZWMZJi5/0Y1AhFo2gSHMPUHZzvsGo
X-Google-Smtp-Source: APXvYqzztlzlI6lMg9dhbdBE2nMsatxOpEwiQJkKfQh2hgdzj0WiGZDn2eO24DJhUe9O8pBYwusHdq0rIw///dxTCUPu68EKeRG3
MIME-Version: 1.0
X-Received: by 2002:a6b:3ac3:: with SMTP id h186mr12861180ioa.63.1557141366572;
 Mon, 06 May 2019 04:16:06 -0700 (PDT)
Date:   Mon, 06 May 2019 04:16:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000050c5f0588363ad6@google.com>
Subject: KASAN: use-after-free Read in p54u_load_firmware_cb
From:   syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, chunkeey@googlemail.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=142b312ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
dashboard link: https://syzkaller.appspot.com/bug?extid=200d4bb11b23d929335f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com

usb 4-1: Direct firmware load for isl3887usb failed with error -2
usb 4-1: Firmware not found.
==================================================================
BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
drivers/net/wireless/intersil/p54/p54usb.c:936
Read of size 8 at addr ffff888098bf3588 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc3-319004-g43151d6 #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xe8/0x16e lib/dump_stack.c:113
  print_address_description+0x6c/0x236 mm/kasan/report.c:187
  kasan_report.cold+0x1a/0x3c mm/kasan/report.c:317
  p54u_load_firmware_cb.cold+0x97/0x13a  
drivers/net/wireless/intersil/p54/p54usb.c:936
  request_firmware_work_func+0x12d/0x249  
drivers/base/firmware_loader/main.c:785
  process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
  worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
  kthread+0x313/0x420 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

The buggy address belongs to the page:
page:ffffea000262fcc0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfff00000000000()
raw: 00fff00000000000 0000000000000000 ffffffff02620101 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888098bf3480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888098bf3500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ffff888098bf3580: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                       ^
  ffff888098bf3600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff888098bf3680: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
