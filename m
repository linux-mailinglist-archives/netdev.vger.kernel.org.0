Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB63A5E4EC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGCNMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:12:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49491 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCNMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:12:06 -0400
Received: by mail-io1-f70.google.com with SMTP id x24so2550314ioh.16
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 06:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0LKzWy3rKCKUf2ADkmhCBlAO8nooReUA+k7uMtJw9z8=;
        b=Z8hJGBIGqmcUPjJvMWnp+TZzr7184WpCro4nnwnp+O9WwYN/iqXsDvOFekjpg1j1wa
         M5YaBiPeZoKsaygXwP9O41ij6vMskZLldDNqo1klIECqqBWYC+GH2KAbBv2jC9NJq6XN
         +kux/vR4cc5AOeuG2iIFFLJIqXUOK8Mn+qYxq47rqqB8rqHTLznoIUsvKIO8Sdxwt8w9
         m2TC7/YpZMHkTrwGsFfdopxGpuHNCF75+KaURtajTL4DiP4PEOL91C/8XcrZ89l+UWlw
         o/CVHGCAWrhja9xHZ7Kr8cU2VAxCcedg/GRbWuowgm1mLxTopzbBgsiU2PShUJzjjkAi
         PVQw==
X-Gm-Message-State: APjAAAXhC2Kjh1lAOXaMZrYHIwrTaUEep5TktlgUpJTk2E+xzsvXafu4
        PqfqcKCETfALS66ZOhPsIkDHEU1f3aWfG1EX84N5sSpxanQJ
X-Google-Smtp-Source: APXvYqzjw5aaitiWWD6dEocipz83t7ATXlepPRhnUXEFvzDxK0lxT2Q2XJhDNQIEV9xnvLBTPgvvzofYGptzSTHYKvri+paEh/nX
MIME-Version: 1.0
X-Received: by 2002:a02:b696:: with SMTP id i22mr10221274jam.87.1562159525386;
 Wed, 03 Jul 2019 06:12:05 -0700 (PDT)
Date:   Wed, 03 Jul 2019 06:12:05 -0700
In-Reply-To: <00000000000035c756058848954a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097dfa5058cc69be3@google.com>
Subject: Re: KASAN: use-after-free Read in hci_cmd_timeout
From:   syzbot <syzbot+19a9f729f05272857487@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    eca94432 Bluetooth: Fix faulty expression for minimum encr..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1006cc8ba00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6451f0da3d42d53
dashboard link: https://syzkaller.appspot.com/bug?extid=19a9f729f05272857487
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125b7999a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176deefba00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+19a9f729f05272857487@syzkaller.appspotmail.com

Bluetooth: hci0: command 0xfc11 tx timeout
==================================================================
BUG: KASAN: use-after-free in hci_cmd_timeout+0x1fe/0x220  
net/bluetooth/hci_core.c:2614
Read of size 8 at addr ffff88809e8a3c48 by task kworker/0:5/9461

CPU: 0 PID: 9461 Comm: kworker/0:5 Not tainted 5.2.0-rc7+ #40
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events hci_cmd_timeout
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  hci_cmd_timeout+0x1fe/0x220 net/bluetooth/hci_core.c:2614
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9446:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc mm/slab.c:3326 [inline]
  kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3488
  skb_clone+0x154/0x3d0 net/core/skbuff.c:1321
  hci_cmd_work+0xe0/0x2a0 net/bluetooth/hci_core.c:4495
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Freed by task 1501:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kmem_cache_free+0x86/0x260 mm/slab.c:3698
  kfree_skbmem net/core/skbuff.c:620 [inline]
  kfree_skbmem+0xc5/0x150 net/core/skbuff.c:614
  __kfree_skb net/core/skbuff.c:677 [inline]
  kfree_skb net/core/skbuff.c:694 [inline]
  kfree_skb+0xf0/0x390 net/core/skbuff.c:688
  hci_dev_do_open+0xb20/0x1760 net/bluetooth/hci_core.c:1550
  hci_power_on+0x10d/0x580 net/bluetooth/hci_core.c:2171
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88809e8a3b80
  which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 200 bytes inside of
  224-byte region [ffff88809e8a3b80, ffff88809e8a3c60)
The buggy address belongs to the page:
page:ffffea00027a28c0 refcount:1 mapcount:0 mapping:ffff88821baabb40  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00027b2d08 ffffea00021b83c8 ffff88821baabb40
raw: 0000000000000000 ffff88809e8a3040 000000010000000c 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809e8a3b00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809e8a3b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809e8a3c00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                               ^
  ffff88809e8a3c80: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
  ffff88809e8a3d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

