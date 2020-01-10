Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBE3137486
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgAJROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:14:10 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:48119 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgAJROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:14:09 -0500
Received: by mail-io1-f69.google.com with SMTP id 13so1922020iof.14
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 09:14:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nmhULovwynitNLCgwItQp1OEiya5Jm8Qq6n5tj/eRUs=;
        b=jO3t2RXwkgVlzOCStrFSyCn/s1yGrcciBE7JtQMGLzaq/NY6h564ZFW5Yd+0BejDDq
         ppIYGLuiUggM9YeCiNomOBvpKcdisBS0QNxZepCeS3JnSgND78u3GsgHxZrn8+7oeK9g
         AqsveRX5pjd+LJNSrmVsYX56OU6x89FFafFA7/wkWpBLcoS3/sUOe9ZY3KZulEvsIvOm
         9e7NxVp/skeU/SgDPpVO0yX+IwlRlxyAx3kbi4d6OQjPipC+tFRVBIxMj4e7MElYxMhd
         FKqfRDOoxZM1O1lNXHvg/bSqQ9V8fQ7SPo/efulcc9sJoiiqth75yT2hku/bcbuMA2xA
         D7Ow==
X-Gm-Message-State: APjAAAWfe58AgA3hT3ZG//xonqdU1JwxTftMRgjMFaC8fBFF30AAdNDR
        Ul9gjZeVqvIYvvG7tUKILeUqyLcKPtdoYX/QF9Oo3WpvS7d0
X-Google-Smtp-Source: APXvYqwIcvRnSREhU6FGyu6kiXLUiSc5LNam3xpjv102fL9nki//2m9HJvENMbcHVLiYuUBQ5fRiMfye0ZU+qoBPvOV6T/VB5ksJ
MIME-Version: 1.0
X-Received: by 2002:a92:af4b:: with SMTP id n72mr3572342ili.288.1578676448703;
 Fri, 10 Jan 2020 09:14:08 -0800 (PST)
Date:   Fri, 10 Jan 2020 09:14:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0bdb4059bcc4068@google.com>
Subject: KASAN: slab-out-of-bounds Read in xfrm_lookup_with_ifid
From:   syzbot <syzbot+18bd12c034e089442dc1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4a4a52d4 vmxnet3: Remove always false conditional statement
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1176a915e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff06bf0a19e7467d
dashboard link: https://syzkaller.appspot.com/bug?extid=18bd12c034e089442dc1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+18bd12c034e089442dc1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in xfrm_lookup_with_ifid+0x214d/0x2390  
net/xfrm/xfrm_policy.c:3079
Read of size 4 at addr ffff88809514d4dc by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:639
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:134
  xfrm_lookup_with_ifid+0x214d/0x2390 net/xfrm/xfrm_policy.c:3079
  xfrmi_xmit2 net/xfrm/xfrm_interface.c:275 [inline]
  xfrmi_xmit+0x3ef/0x11a0 net/xfrm/xfrm_interface.c:366
  __netdev_start_xmit include/linux/netdevice.h:4459 [inline]
  netdev_start_xmit include/linux/netdevice.h:4473 [inline]
  xmit_one net/core/dev.c:3420 [inline]
  dev_hard_start_xmit+0x1a3/0x9b0 net/core/dev.c:3436
  __dev_queue_xmit+0x2b05/0x35c0 net/core/dev.c:4013
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_direct_output+0x16/0x20 net/core/neighbour.c:1527
  neigh_output include/net/neighbour.h:510 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  ndisc_send_skb+0xf1f/0x1490 net/ipv6/ndisc.c:505
  ndisc_send_rs+0x134/0x720 net/ipv6/ndisc.c:699
  addrconf_rs_timer+0x30f/0x6e0 net/ipv6/addrconf.c:3879
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9477:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
  __do_kmalloc mm/slab.c:3656 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3665
  kmalloc include/linux/slab.h:561 [inline]
  tomoyo_realpath_from_path+0xc5/0x660 security/tomoyo/realpath.c:252
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_check_open_permission+0x2a3/0x3e0 security/tomoyo/file.c:771
  tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
  tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
  security_file_open+0x71/0x300 security/security.c:1497
  do_dentry_open+0x37a/0x1380 fs/open.c:784
  vfs_open+0xa0/0xd0 fs/open.c:914
  do_last fs/namei.c:3420 [inline]
  path_openat+0x10df/0x4500 fs/namei.c:3537
  do_filp_open+0x1a1/0x280 fs/namei.c:3567
  do_sys_open+0x3fe/0x5d0 fs/open.c:1097
  __do_sys_open fs/open.c:1115 [inline]
  __se_sys_open fs/open.c:1110 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1110
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9477:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:335 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  tomoyo_realpath_from_path+0x1a7/0x660 security/tomoyo/realpath.c:289
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_check_open_permission+0x2a3/0x3e0 security/tomoyo/file.c:771
  tomoyo_file_open security/tomoyo/tomoyo.c:319 [inline]
  tomoyo_file_open+0xa9/0xd0 security/tomoyo/tomoyo.c:314
  security_file_open+0x71/0x300 security/security.c:1497
  do_dentry_open+0x37a/0x1380 fs/open.c:784
  vfs_open+0xa0/0xd0 fs/open.c:914
  do_last fs/namei.c:3420 [inline]
  path_openat+0x10df/0x4500 fs/namei.c:3537
  do_filp_open+0x1a1/0x280 fs/namei.c:3567
  do_sys_open+0x3fe/0x5d0 fs/open.c:1097
  __do_sys_open fs/open.c:1115 [inline]
  __se_sys_open fs/open.c:1110 [inline]
  __x64_sys_open+0x7e/0xc0 fs/open.c:1110
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809514c000
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1244 bytes to the right of
  4096-byte region [ffff88809514c000, ffff88809514d000)
The buggy address belongs to the page:
page:ffffea0002545300 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
raw: 00fffe0000010200 ffffea0000d56708 ffffea00017bdb88 ffff8880aa402000
raw: 0000000000000000 ffff88809514c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809514d380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809514d400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff88809514d480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                     ^
  ffff88809514d500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809514d580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
