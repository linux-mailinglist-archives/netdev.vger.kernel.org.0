Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3043A69E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhJYWfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:35:47 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:57281 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbhJYWfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:35:46 -0400
Received: by mail-il1-f197.google.com with SMTP id h17-20020a056e021d9100b0025a38d5fea8so3588579ila.23
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vyhnJoZIovOdZyzH8Y8MrbUmNDPLYUWR/YD6MJ+0O5M=;
        b=V1mDJGQZJbYVQWeLH744x9cIUhhXyYCfdE+rqrxQHabB2i5rXjTqecm9nhse6b1C3k
         JnHyDpsoFtnJ4xItmUmi4hT/Q3O9MH43k65schVVjvPxYFo7DoFSP2bApc+lUQpz8Anj
         9pJ1OlJ3I4RbEyjACKiqFCimKUnJS9GhhjfVA0uVO0Rj4lcL9zy5OYbhbtju8c/If+Ji
         sajoy5ss2E1Y4Bbt4W6GVC5Qtg6bk9gGlcgA6BCphCqKhYSnWFBZtxU0phAUV4vM/qVC
         H58VQXMJ4xLEK/X171hEghok1W1KQl8hfe5b+WenYITvV5HPqH8EVJ/GLgZ+aQZCe9KF
         wHFw==
X-Gm-Message-State: AOAM533gwUnS7G794QVdUy1Rp+dQIM1mk7Jkm9DnOg31OVtfZfi8HbW/
        CQH8GBRWrr1e0Cxd4EZOL2L4Pc5sJedWftN6C5liJ5mTUuvV
X-Google-Smtp-Source: ABdhPJxcekNuFURt+wY3TpojJBaYMtxjZZ9itMECXazo2bnY4iJCYwLHHeehCVLVTlUNB9ifOjIXhJzrR84h5WPzQ2a186BleC8D
MIME-Version: 1.0
X-Received: by 2002:a6b:8d8a:: with SMTP id p132mr12406022iod.96.1635201203634;
 Mon, 25 Oct 2021 15:33:23 -0700 (PDT)
Date:   Mon, 25 Oct 2021 15:33:23 -0700
In-Reply-To: <000000000000f632ba05c3cb12c2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e1063f05cf34f2a8@google.com>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
From:   syzbot <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mudongliangabcd@gmail.com, netdev@vger.kernel.org,
        phind.uet@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    87066fdd2e30 Revert "mm/secretmem: use refcount_t instead ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b55554b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d25eeb482b0f99b
dashboard link: https://syzkaller.appspot.com/bug?extid=7a942657a255a9d9b18a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=171cf464b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1396b19f300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810f3c7980 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294948721 (age 17.180s)
  hex dump (first 32 bytes):
    e5 90 aa e8 34 cf 05 00 00 00 00 00 00 00 00 00  ....4...........
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff83ee74a9>] cfg80211_inform_single_bss_frame_data+0x139/0x640 net/wireless/scan.c:2383
    [<ffffffff83ee79fb>] cfg80211_inform_bss_frame_data+0x4b/0x470 net/wireless/scan.c:2444
    [<ffffffff83f8865e>] ieee80211_bss_info_update+0x16e/0x460 net/mac80211/scan.c:190
    [<ffffffff83f9687a>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff83f9687a>] ieee80211_rx_mgmt_probe_beacon+0x61a/0x970 net/mac80211/ibss.c:1608
    [<ffffffff83f972dc>] ieee80211_ibss_rx_queued_mgmt+0x23c/0x6e0 net/mac80211/ibss.c:1635
    [<ffffffff83f99347>] ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
    [<ffffffff83f99347>] ieee80211_iface_work+0x5f7/0x770 net/mac80211/iface.c:1493
    [<ffffffff81265dbf>] process_one_work+0x2cf/0x620 kernel/workqueue.c:2297
    [<ffffffff812666c9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2444
    [<ffffffff8126fc48>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff810022cf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff88810f3c7b00 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294948721 (age 17.180s)
  hex dump (first 32 bytes):
    f5 90 aa e8 34 cf 05 00 00 00 00 00 00 00 00 00  ....4...........
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff83ee74a9>] cfg80211_inform_single_bss_frame_data+0x139/0x640 net/wireless/scan.c:2383
    [<ffffffff83ee79fb>] cfg80211_inform_bss_frame_data+0x4b/0x470 net/wireless/scan.c:2444
    [<ffffffff83f8865e>] ieee80211_bss_info_update+0x16e/0x460 net/mac80211/scan.c:190
    [<ffffffff83f9687a>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff83f9687a>] ieee80211_rx_mgmt_probe_beacon+0x61a/0x970 net/mac80211/ibss.c:1608
    [<ffffffff83f972dc>] ieee80211_ibss_rx_queued_mgmt+0x23c/0x6e0 net/mac80211/ibss.c:1635
    [<ffffffff83f99347>] ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
    [<ffffffff83f99347>] ieee80211_iface_work+0x5f7/0x770 net/mac80211/iface.c:1493
    [<ffffffff81265dbf>] process_one_work+0x2cf/0x620 kernel/workqueue.c:2297
    [<ffffffff812666c9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2444
    [<ffffffff8126fc48>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff810022cf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff88810f3c7680 (size 96):
  comm "kworker/u4:1", pid 146, jiffies 4294948731 (age 17.080s)
  hex dump (first 32 bytes):
    e9 20 ac e8 34 cf 05 00 00 00 00 00 00 00 00 00  . ..4...........
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff83ee74a9>] cfg80211_inform_single_bss_frame_data+0x139/0x640 net/wireless/scan.c:2383
    [<ffffffff83ee79fb>] cfg80211_inform_bss_frame_data+0x4b/0x470 net/wireless/scan.c:2444
    [<ffffffff83f8865e>] ieee80211_bss_info_update+0x16e/0x460 net/mac80211/scan.c:190
    [<ffffffff83f9687a>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff83f9687a>] ieee80211_rx_mgmt_probe_beacon+0x61a/0x970 net/mac80211/ibss.c:1608
    [<ffffffff83f972dc>] ieee80211_ibss_rx_queued_mgmt+0x23c/0x6e0 net/mac80211/ibss.c:1635
    [<ffffffff83f99347>] ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
    [<ffffffff83f99347>] ieee80211_iface_work+0x5f7/0x770 net/mac80211/iface.c:1493
    [<ffffffff81265dbf>] process_one_work+0x2cf/0x620 kernel/workqueue.c:2297
    [<ffffffff812666c9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2444
    [<ffffffff8126fc48>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff810022cf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

BUG: memory leak
unreferenced object 0xffff888111520f80 (size 96):
  comm "kworker/u4:1", pid 146, jiffies 4294948731 (age 17.080s)
  hex dump (first 32 bytes):
    fb 20 ac e8 34 cf 05 00 00 00 00 00 00 00 00 00  . ..4...........
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff83ee74a9>] cfg80211_inform_single_bss_frame_data+0x139/0x640 net/wireless/scan.c:2383
    [<ffffffff83ee79fb>] cfg80211_inform_bss_frame_data+0x4b/0x470 net/wireless/scan.c:2444
    [<ffffffff83f8865e>] ieee80211_bss_info_update+0x16e/0x460 net/mac80211/scan.c:190
    [<ffffffff83f9687a>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff83f9687a>] ieee80211_rx_mgmt_probe_beacon+0x61a/0x970 net/mac80211/ibss.c:1608
    [<ffffffff83f972dc>] ieee80211_ibss_rx_queued_mgmt+0x23c/0x6e0 net/mac80211/ibss.c:1635
    [<ffffffff83f99347>] ieee80211_iface_process_skb net/mac80211/iface.c:1439 [inline]
    [<ffffffff83f99347>] ieee80211_iface_work+0x5f7/0x770 net/mac80211/iface.c:1493
    [<ffffffff81265dbf>] process_one_work+0x2cf/0x620 kernel/workqueue.c:2297
    [<ffffffff812666c9>] worker_thread+0x59/0x5d0 kernel/workqueue.c:2444
    [<ffffffff8126fc48>] kthread+0x188/0x1d0 kernel/kthread.c:319
    [<ffffffff810022cf>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


