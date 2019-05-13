Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F421B3EC
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfEMKXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:23:09 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:34660 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEMKXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 06:23:08 -0400
Received: by mail-it1-f200.google.com with SMTP id m140so8407350ita.1
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 03:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MD+QokhW6aQWfWqFuW7b35hDHc6Efu2abU5/OSovxBE=;
        b=Dq/4seJXtF5F53wF6d0F1pfWK/v2sqCcrgJoFl2tTVkmNVPT+FqZN0mNBCIFwSmkYU
         kSQhqRbzv+8eEYIXKi+W+V6vpIAzEcWC1QbdUImK8jUS4Yv5M3DYSKJnmuVNXdGWwSeb
         AImaK39Esrri07BUJmC82WW7eDvj3jpJ3Ce2WDU+m0VbT3aVARa5vuMmdaEzrCrVUYja
         DVcYDwhHEOfBbUe39AyQ3QMM25tUWyQUn/cIhO8HGbLvd2iJHmwZj+Z8xAmtNIKSxlfM
         JddYtqs1a8GkaltiOMWb1QtpXtgMg28RlWLMnQ/BAPRzTgkN5RjJ/lsBIt9dTnEX82qb
         S6iw==
X-Gm-Message-State: APjAAAXznS+4bGesJcGMSpZ8AcdST0vwASyhne/AC/MuxK606iIRR1jt
        wugrdq4rYUGhn3CrNNTtV41X162qCUR5LPYsSKFPqS277mIK
X-Google-Smtp-Source: APXvYqypmz9GTUMulQ4YmTfkPtqRuVD/rXyFolzhHSBiWGAf2piQHL04tnXddD/X840pGS32563fffMIdXuqZJG44r1bPnVrHJjW
MIME-Version: 1.0
X-Received: by 2002:a5d:8d81:: with SMTP id b1mr9537878ioj.83.1557742987986;
 Mon, 13 May 2019 03:23:07 -0700 (PDT)
Date:   Mon, 13 May 2019 03:23:07 -0700
In-Reply-To: <000000000000050c5f0588363ad6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073512b0588c24d09@google.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
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

syzbot has found a reproducer for the following crash on:

HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=16b64110a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
dashboard link: https://syzkaller.appspot.com/bug?extid=200d4bb11b23d929335f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1634c900a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com

usb 1-1: config 0 descriptor??
usb 1-1: reset high-speed USB device number 2 using dummy_hcd
usb 1-1: device descriptor read/64, error -71
usb 1-1: Using ep0 maxpacket: 8
usb 1-1: Loading firmware file isl3887usb
usb 1-1: Direct firmware load for isl3887usb failed with error -2
usb 1-1: Firmware not found.
==================================================================
BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
drivers/net/wireless/intersil/p54/p54usb.c:936
Read of size 8 at addr ffff88809803f588 by task kworker/1:0/17

CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.1.0-rc3-319004-g43151d6 #6
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

Allocated by task 0:
(stack is not available)

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88809803f180
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 8 bytes to the right of
  1024-byte region [ffff88809803f180, ffff88809803f580)
The buggy address belongs to the page:
page:ffffea0002600f00 count:1 mapcount:0 mapping:ffff88812c3f4a00 index:0x0  
compound_mapcount: 0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000200 ffff88812c3f4a00
raw: 0000000000000000 00000000800e000e 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809803f480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809803f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88809803f580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                       ^
  ffff88809803f600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809803f680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

