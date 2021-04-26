Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9CB36ACC9
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 09:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhDZHSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 03:18:01 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:40501 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhDZHR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 03:17:57 -0400
Received: by mail-il1-f200.google.com with SMTP id d3-20020a056e021c43b029016bec7d6e48so26882661ilg.7
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 00:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aZoDBeOoD4HH+wnQuUDnZ6oaHuFcciPpeTQUoAg8opQ=;
        b=pciSjnxrDIi5QzyB8ZQR61Bq7zOUPDpJkdb80DPUERiFvkGCkWoEFack+nP6PbOWLP
         y0275cD1wMlEMUlcp6QksRQPpajO3OdgPPqI8E0l3WVXzH3KuWycjq+QWmrbXc9Sn+9a
         64WyG5mMxKfJ9WUbbukX9+KCs8PyLJPiZyo/O/zB27Ywvb+dhacn01ErYZMybcODothg
         Bqh76SKyBe0y3WabbudDpmYcL0jpbhDkzdb3Y7PevZIE8ZeDWQJRFR7wiQydjbkoS7W4
         2WknMkSIxMzEgQwm2+1/i97Kbp3Y60mTrOqJLU62EqcWLmD/S+QUHcSEiRA3UE9D+Ey2
         YLpg==
X-Gm-Message-State: AOAM531C2DU4bqs4y9s3V24EZMeyK0bPvEa307Cu2DxpQ8fu0JqplWbs
        N8NMCa79eWAwUibI7LJ/hu8DDublNSXhpB9DYLz5ulEP/OB5
X-Google-Smtp-Source: ABdhPJyWVYJl/tvpehfpgjUiEeAuUue2OwpCuQRuYiBfz2+ofRjTq3wtsND6IIxj8EOTova385M12ftqWQvthxZ99JMhvUSJupuo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:120e:: with SMTP id a14mr12659253ilq.273.1619421434264;
 Mon, 26 Apr 2021 00:17:14 -0700 (PDT)
Date:   Mon, 26 Apr 2021 00:17:14 -0700
In-Reply-To: <000000000000174a1c05bfd45183@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054c19f05c0daef75@google.com>
Subject: Re: [syzbot] KASAN: null-ptr-deref Write in rhashtable_free_and_destroy
 (2)
From:   syzbot <syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    9f4ad9e4 Linux 5.12
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12e92c5dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39164acdef826e06
dashboard link: https://syzkaller.appspot.com/bug?extid=860268315ba86ea6b96b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13438cb9d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d37705d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:70 [inline]
BUG: KASAN: null-ptr-deref in try_to_grab_pending.part.0+0x26/0x770 kernel/workqueue.c:1257
Write of size 8 at addr 0000000000000088 by task kworker/0:0/5

CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events cfg80211_destroy_iface_wk
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report.cold+0x5f/0xd8 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 test_and_set_bit include/asm-generic/bitops/instrumented-atomic.h:70 [inline]
 try_to_grab_pending.part.0+0x26/0x770 kernel/workqueue.c:1257
 try_to_grab_pending+0xa1/0xd0 kernel/workqueue.c:1310
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3098
 rhashtable_free_and_destroy+0x2b/0x920 lib/rhashtable.c:1137
 mesh_table_free net/mac80211/mesh_pathtbl.c:70 [inline]
 mesh_pathtbl_unregister+0x42/0xa0 net/mac80211/mesh_pathtbl.c:812
 ieee80211_teardown_sdata+0x216/0x2d0 net/mac80211/iface.c:691
 unregister_netdevice_many+0xc4c/0x1760 net/core/dev.c:10953
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10870
 unregister_netdevice include/linux/netdevice.h:2884 [inline]
 _cfg80211_unregister_wdev+0x485/0x740 net/wireless/core.c:1127
 ieee80211_if_remove+0x1df/0x300 net/mac80211/iface.c:2020
 ieee80211_del_iface+0x12/0x20 net/mac80211/cfg.c:144
 rdev_del_virtual_intf net/wireless/rdev-ops.h:57 [inline]
 cfg80211_destroy_ifaces+0x223/0x770 net/wireless/core.c:341
 cfg80211_destroy_iface_wk+0x2c/0x40 net/wireless/core.c:354
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
==================================================================

