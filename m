Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C66F35D7A7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344847AbhDMF6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:58:50 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54605 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344790AbhDMF6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 01:58:37 -0400
Received: by mail-io1-f71.google.com with SMTP id s6so10351409iom.21
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 22:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OaHTjR/nmaSdf3qrZfC3UuSGJvdUuFV++rwAwVRpbI0=;
        b=R105//nOZz1tFPg++s0Pif3LxxKCC408ZwhM2YoMMn89i4rSMIZBXD3TmhEuEBhJtV
         oLbUUSJrq8uZypFo4zEXg0bw2BX5l6Thvga9v121HhEkljGUetUh+f2phz9+4I0ZkaU4
         B9F4Gn7NoVG0qjYqYMAq1h5LDurfd44MrjqAuKVNCPTcN/Qab4nWwhfG1pyqsn4y7yVS
         rLqUdWqNk63sQHzNpfcA4hQO9zVbMxdoL8DpEnQ1GXl9RsVgS/ojyIg2LOS16lN+ArSx
         jb4sr23tedia/ROPZXi7JfNv/Kmxi7UZc2zyEQDNHmH2wpenz3qGkHkmMMNXtOdiaJ1s
         uKwQ==
X-Gm-Message-State: AOAM533+EWm6Du5zATHhDyRt20CEb/Q3crqv3JWnNpis5xQJrtkNAAZJ
        vWsR/PgF2eM9GRknT4aofegW3D9ETQ/NtVNs5yw2ubk20yqV
X-Google-Smtp-Source: ABdhPJz8BKOHZJgPvwwGhRTvvTaARVh/ADkeXVxzQnyQlVNRGaix5R+iCXNtYhnr47TNG9zaa+Khk1xekhuZugE4IimpTPcBKw/v
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2182:: with SMTP id j2mr27111406ila.89.1618293498004;
 Mon, 12 Apr 2021 22:58:18 -0700 (PDT)
Date:   Mon, 12 Apr 2021 22:58:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000174a1c05bfd45183@google.com>
Subject: [syzbot] KASAN: null-ptr-deref Write in rhashtable_free_and_destroy (2)
From:   syzbot <syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d93a0d43 Merge tag 'block-5.12-2021-04-02' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12d81cfcd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=71a75beb62b62a34
dashboard link: https://syzkaller.appspot.com/bug?extid=860268315ba86ea6b96b
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:70 [inline]
BUG: KASAN: null-ptr-deref in try_to_grab_pending+0xee/0xa50 kernel/workqueue.c:1257
Write of size 8 at addr 0000000000000088 by task kworker/0:3/4787

CPU: 0 PID: 4787 Comm: kworker/0:3 Not tainted 5.12.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events cfg80211_destroy_iface_wk
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x176/0x24e lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report+0x152/0x200 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:135 [inline]
 kasan_check_range+0x2b5/0x2f0 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:70 [inline]
 try_to_grab_pending+0xee/0xa50 kernel/workqueue.c:1257
 __cancel_work_timer+0x81/0x5b0 kernel/workqueue.c:3098
 rhashtable_free_and_destroy+0x25/0x8b0 lib/rhashtable.c:1137
 mesh_table_free net/mac80211/mesh_pathtbl.c:70 [inline]
 mesh_pathtbl_unregister+0x4b/0xa0 net/mac80211/mesh_pathtbl.c:812
 unregister_netdevice_many+0x12ea/0x18e0 net/core/dev.c:10951
 unregister_netdevice_queue+0x2a9/0x300 net/core/dev.c:10868
 unregister_netdevice include/linux/netdevice.h:2884 [inline]
 _cfg80211_unregister_wdev+0x17b/0x5b0 net/wireless/core.c:1127
 ieee80211_if_remove+0x1cc/0x250 net/mac80211/iface.c:2020
 ieee80211_del_iface+0x12/0x20 net/mac80211/cfg.c:144
 rdev_del_virtual_intf net/wireless/rdev-ops.h:57 [inline]
 cfg80211_destroy_ifaces+0x182/0x250 net/wireless/core.c:341
 cfg80211_destroy_iface_wk+0x30/0x40 net/wireless/core.c:354
 process_one_work+0x789/0xfd0 kernel/workqueue.c:2275
 worker_thread+0xac1/0x1300 kernel/workqueue.c:2421
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
