Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEB62884D7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbgJIIDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:03:32 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:35874 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732644AbgJIID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:03:29 -0400
Received: by mail-io1-f80.google.com with SMTP id q126so5664908iof.3
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 01:03:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Rvx7NbZ6B7vi+U6k35vJXxZn6dZ+LZeTCuQdj51s5PA=;
        b=Gr1jeRXFJg1MGdMdQXgKgsC/Xbv4ww1SPzBtob5dSHxDrN48biL5pHDKH8C1UvK1Yw
         VCApH3DP4lj06QWLgUgMKqpsrsvS2VJcD9OLz5V6dh9Zfm/sRqVaJVoh/yiFFOvUtmNA
         Hw21W3e6+4Ef6vqDN6uoEnXE4i5EYM5dOGU1ZxuV+QNbhaSJwlaS1WSKmJONPOIu19tr
         3jU1xdME9k6jm0q2SoMGdLtAU5wKv+MkORN0yoFvZRPgHpl3EFNkkpZEQNHNZfOk1gTT
         Y3lqtMamMIXyXDRM1xdDP+8jRKw/RkntZTSBPDslOJPXwpcY0v/+qYVS+exd1+H9xwwO
         8VMQ==
X-Gm-Message-State: AOAM531f69L6JvOjY5rPInwUqhbY3bcRKVaDj1U/pCsjLj0l4kGVYvS1
        miNt1NOlVOpPB2cf27ae6XaCFNXN0hlLHWK/whe0mxNkQ32U
X-Google-Smtp-Source: ABdhPJwEUFducMP4LN+SpAwXA0k51N+2gmE3z6WZwNEfI6YT4hbhhp4vOcf1cT74/DHfutug3In6x90GS4ii2y6apDzIOoBNHjMG
MIME-Version: 1.0
X-Received: by 2002:a92:c949:: with SMTP id i9mr9329395ilq.252.1602230606856;
 Fri, 09 Oct 2020 01:03:26 -0700 (PDT)
Date:   Fri, 09 Oct 2020 01:03:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b8ac905b1386290@google.com>
Subject: KASAN: use-after-free Read in ieee80211_scan_rx
From:   syzbot <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c85fb28b Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1658aa8b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c06bcf3cc963d91c
dashboard link: https://syzkaller.appspot.com/bug?extid=9250865a55539d384347
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ieee80211_scan_rx+0x749/0x780 net/mac80211/scan.c:269
Read of size 4 at addr ffff88808b2ae32c by task ksoftirqd/0/9

CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 ieee80211_scan_rx+0x749/0x780 net/mac80211/scan.c:269
 __ieee80211_rx_handle_packet net/mac80211/rx.c:4591 [inline]
 ieee80211_rx_list+0x1ea2/0x23a0 net/mac80211/rx.c:4779
 ieee80211_rx_napi+0xf7/0x3d0 net/mac80211/rx.c:4800
 ieee80211_rx include/net/mac80211.h:4435 [inline]
 ieee80211_tasklet_handler+0xd3/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x237/0x470 kernel/softirq.c:559
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298
 run_ksoftirqd kernel/softirq.c:652 [inline]
 run_ksoftirqd+0xcf/0x170 kernel/softirq.c:644
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 12531:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 __do_kmalloc mm/slab.c:3659 [inline]
 __kmalloc+0x1b0/0x360 mm/slab.c:3668
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 cfg80211_conn_scan+0x1af/0xfb0 net/wireless/sme.c:81
 cfg80211_sme_connect net/wireless/sme.c:586 [inline]
 cfg80211_connect+0x1616/0x2010 net/wireless/sme.c:1258
 nl80211_connect+0x1646/0x2220 net/wireless/nl80211.c:10392
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 360:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3422 [inline]
 kfree+0x10e/0x2b0 mm/slab.c:3760
 ___cfg80211_scan_done+0x2ae/0x5f0 net/wireless/scan.c:505
 __cfg80211_scan_done+0x1f/0x30 net/wireless/scan.c:521
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2896 [inline]
 call_rcu+0x15e/0x7c0 kernel/rcu/tree.c:2970
 neigh_parms_release net/core/neighbour.c:1662 [inline]
 neigh_parms_release+0x1e3/0x260 net/core/neighbour.c:1652
 inetdev_destroy net/ipv4/devinet.c:325 [inline]
 inetdev_event+0xca6/0x14fd net/ipv4/devinet.c:1599
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2033
 call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
 call_netdevice_notifiers net/core/dev.c:2059 [inline]
 rollback_registered_many+0x77a/0x1250 net/core/dev.c:9347
 rollback_registered net/core/dev.c:9392 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10490
 unregister_netdevice include/linux/netdevice.h:2789 [inline]
 ppp_release+0x216/0x240 drivers/net/ppp/ppp_generic.c:403
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
 exit_to_user_mode_prepare+0x1e1/0x200 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7e/0x2e0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88808b2ae300
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 44 bytes inside of
 192-byte region [ffff88808b2ae300, ffff88808b2ae3c0)
The buggy address belongs to the page:
page:00000000f60d3173 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8b2ae
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002252108 ffffea000287e0c8 ffff8880aa040000
raw: 0000000000000000 ffff88808b2ae000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808b2ae200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808b2ae280: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88808b2ae300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88808b2ae380: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88808b2ae400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
