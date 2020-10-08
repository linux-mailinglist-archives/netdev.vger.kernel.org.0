Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62E82870F0
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgJHItU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:49:20 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:35629 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbgJHItU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:49:20 -0400
Received: by mail-io1-f79.google.com with SMTP id t11so3260387ios.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 01:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f+10NVtEqPkPrqlOFKfyrYJbYbqdgRkPJ4VeacWpwfI=;
        b=Dai52EuBm0426Y1HCDHra4zXVdEAMJ7O7zX/UPztthHierBKCl6iAY48HTirHp+49j
         VasCKI+UteHHZ7UM13bu6CVfofawrcGmrmNefsVF/RPWTqKVUbbJpBIAmCK5nF0OHm+Y
         tQLIswXi4O9vKYQ503fizBXzf608pYryuwBdQ24lDKNYnnbL2YEnuuI8RbYY/mDMrGxc
         M9c0L3L4+9W3KLXPyVrfF5Hq/34h87joeO3f1jhKsw5bBU1cd1qR4iLLzD5CMAuGif/M
         Jogq5DfyjWSHoEWLAkWom1nuE0rusamFUM3GGMf4IioLkz/XgGQIgKo2R+zZH8jPnk6L
         Ui9g==
X-Gm-Message-State: AOAM531Al7FYuol4MF703yZiUsWO521abuHyhKagH5YzXjpxLFkB6m9o
        klsXfTuC0g45VyNB5OqjV9/JGvuG/6oWW1Amf3J5lj5I+AQI
X-Google-Smtp-Source: ABdhPJyk3UNlTM4c+hpJnJvAXopHFksNs4HcyTugRqEXzxYMgCfQ55719frlg/+O2BwutZoIwmH5Ad/dm63Tgp991ON8aQh1+mwi
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:664:: with SMTP id l4mr6155140ilt.81.1602146959303;
 Thu, 08 Oct 2020 01:49:19 -0700 (PDT)
Date:   Thu, 08 Oct 2020 01:49:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000632b7e05b124e8b6@google.com>
Subject: KMSAN: uninit-value in ieee80211_sta_tx_notify
From:   syzbot <syzbot+beae481026cb095addca@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5edb1df2 kmsan: drop the _nosanitize string functions
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1279b1c0500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4991d22eb136035c
dashboard link: https://syzkaller.appspot.com/bug?extid=beae481026cb095addca
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+beae481026cb095addca@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ieee80211_ac_from_tid net/mac80211/ieee80211_i.h:2034 [inline]
BUG: KMSAN: uninit-value in ieee80211_sta_tx_wmm_ac_notify net/mac80211/mlme.c:2490 [inline]
BUG: KMSAN: uninit-value in ieee80211_sta_tx_notify+0x4be/0xda0 net/mac80211/mlme.c:2522
CPU: 1 PID: 8613 Comm: kworker/u4:1 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy18 ieee80211_beacon_connection_loss_work
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:201
 ieee80211_ac_from_tid net/mac80211/ieee80211_i.h:2034 [inline]
 ieee80211_sta_tx_wmm_ac_notify net/mac80211/mlme.c:2490 [inline]
 ieee80211_sta_tx_notify+0x4be/0xda0 net/mac80211/mlme.c:2522
 __ieee80211_tx_status+0x2d3b/0x4450 net/mac80211/status.c:1013
 ieee80211_tx_status+0x223/0x270 net/mac80211/status.c:1129
 ieee80211_tasklet_handler+0x34e/0x3c0 net/mac80211/main.c:239
 tasklet_action_common+0x416/0x6a0 kernel/softirq.c:562
 tasklet_action+0x30/0x40 kernel/softirq.c:580
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:299
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:344 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:196
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 __ieee80211_tx_skb_tid_band+0x28e/0x390 net/mac80211/tx.c:5352
 ieee80211_tx_skb_tid net/mac80211/ieee80211_i.h:2003 [inline]
 ieee80211_tx_skb net/mac80211/ieee80211_i.h:2012 [inline]
 ieee80211_send_nullfunc+0x59a/0x6d0 net/mac80211/mlme.c:1095
 ieee80211_mgd_probe_ap_send+0x897/0xb40 net/mac80211/mlme.c:2593
 ieee80211_mgd_probe_ap+0x6b3/0x760 net/mac80211/mlme.c:2669
 ieee80211_beacon_connection_loss_work+0x156/0x270 net/mac80211/mlme.c:2788
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:293
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:143
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:268 [inline]
 kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:292
 __alloc_pages_nodemask+0xf34/0x1120 mm/page_alloc.c:4927
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 alloc_pages_node include/linux/gfp.h:536 [inline]
 __page_frag_cache_refill mm/page_alloc.c:5002 [inline]
 page_frag_alloc+0x35b/0x880 mm/page_alloc.c:5032
 __netdev_alloc_skb+0xc3d/0xc90 net/core/skbuff.c:456
 netdev_alloc_skb include/linux/skbuff.h:2821 [inline]
 dev_alloc_skb include/linux/skbuff.h:2834 [inline]
 __ieee80211_beacon_get+0x37e3/0x4df0 net/mac80211/tx.c:4819
 ieee80211_beacon_get_tim+0x109/0x800 net/mac80211/tx.c:4933
 ieee80211_beacon_get include/net/mac80211.h:4845 [inline]
 mac80211_hwsim_beacon_tx+0x1c3/0xb80 drivers/net/wireless/mac80211_hwsim.c:1676
 __iterate_interfaces net/mac80211/util.c:737 [inline]
 ieee80211_iterate_active_interfaces_atomic+0x40a/0x610 net/mac80211/util.c:773
 mac80211_hwsim_beacon+0x11d/0x2e0 drivers/net/wireless/mac80211_hwsim.c:1717
 __run_hrtimer+0x7cd/0xf00 kernel/time/hrtimer.c:1524
 __hrtimer_run_queues kernel/time/hrtimer.c:1588 [inline]
 hrtimer_run_softirq+0x3bf/0x690 kernel/time/hrtimer.c:1605
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:299
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
