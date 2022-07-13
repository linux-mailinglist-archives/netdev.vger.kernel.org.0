Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D115357345F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 12:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiGMKfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 06:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbiGMKfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 06:35:09 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9433AEDB67
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 03:35:07 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id 1-20020a056e0220c100b002dc2923add3so6090358ilq.7
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 03:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=/gNbNii7yMVWS8fxbVS9LZCYRdyRODnecdP2k3C4uIE=;
        b=LAbOMbiQ4kYGY3ht0ej/Rv74fNqqZMmFHt8LxmRDU2zLdKipCe7QBYUbd7ivtGB8r+
         N/6xVZw/G4jdjv83bcg1rMvLaGXseUADB2ZkOS5GDjzX/SKVVJrEqFRVC2cB8iydHyK9
         M4Jw5wJzVlKnR4cSVB5+E5RUEdnnqen7BsijM+vqt/uejd4uucUi7yRpIL2EFdGLReSE
         E7pVMx1sEpiEcEbd00Pjp41XcHGI887kUir7rEkNcKncHSLosdyTq50TyFleyRB8FskX
         oziu41dBAg1WGqT3+Bovml5ttbU2KJushLLduNC31yZOQnsZISaps7bvBlwqvx4ObkEO
         DJEA==
X-Gm-Message-State: AJIora8nJoFjh5jZe9Pa58qK0Tl4YO4eS55BVaN4QL0Sof9gCZjBb9xn
        V1aJG6L1uCQaQtERqq11dDcXXjxLiiXWxXGuCfNl8HE4gvpb
X-Google-Smtp-Source: AGRyM1u39feVJMmVXdQykAP9gk0+Sn4axFDWtMo/oH1I3W6U5Uo5jJH972oB31GqLPTTVGl5/rxZUeBzPstCYklnew7dLEAj8YY2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:300f:b0:335:b12d:3126 with SMTP id
 r15-20020a056638300f00b00335b12d3126mr1477619jak.210.1657708506885; Wed, 13
 Jul 2022 03:35:06 -0700 (PDT)
Date:   Wed, 13 Jul 2022 03:35:06 -0700
In-Reply-To: <181f7180015.1ea4d3b3328398.7889962633178976958@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1b55a05e3ad5692@google.com>
Subject: Re: [syzbot] memory leak in cfg80211_inform_single_bss_frame_data
From:   syzbot <syzbot+7a942657a255a9d9b18a@syzkaller.appspotmail.com>
To:     code@siddh.me, davem@davemloft.net, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in regulatory_init_db

BUG: memory leak
unreferenced object 0xffff888145137a00 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937939 (age 68.850s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    ff ff ff ff 00 00 00 00 00 00 00 00 30 30 00 00  ............00..
  backtrace:
    [<ffffffff86ff026b>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff86ff026b>] kzalloc include/linux/slab.h:733 [inline]
    [<ffffffff86ff026b>] regulatory_hint_core net/wireless/reg.c:3216 [inline]
    [<ffffffff86ff026b>] regulatory_init_db+0x22f/0x2de net/wireless/reg.c:4277
    [<ffffffff81000fe3>] do_one_initcall+0x63/0x2e0 init/main.c:1295
    [<ffffffff86f4eb10>] do_initcall_level init/main.c:1368 [inline]
    [<ffffffff86f4eb10>] do_initcalls init/main.c:1384 [inline]
    [<ffffffff86f4eb10>] do_basic_setup init/main.c:1403 [inline]
    [<ffffffff86f4eb10>] kernel_init_freeable+0x255/0x2cf init/main.c:1610
    [<ffffffff845b427a>] kernel_init+0x1a/0x1c0 init/main.c:1499
    [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

BUG: memory leak
unreferenced object 0xffff88810a760180 (size 96):
  comm "kworker/u4:2", pid 43, jiffies 4294943904 (age 9.220s)
  hex dump (first 32 bytes):
    fa fd 93 53 ad e3 05 00 00 00 00 00 00 00 00 00  ...S............
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff840740b6>] cfg80211_inform_single_bss_frame_data+0x186/0x6a0 net/wireless/scan.c:2445
    [<ffffffff8407461b>] cfg80211_inform_bss_frame_data+0x4b/0x460 net/wireless/scan.c:2506
    [<ffffffff84115816>] ieee80211_bss_info_update+0x196/0x440 net/mac80211/scan.c:190
    [<ffffffff841240e2>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff841240e2>] ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
    [<ffffffff841240e2>] ieee80211_ibss_rx_queued_mgmt+0x7d2/0x11a0 net/mac80211/ibss.c:1639
    [<ffffffff84126b81>] ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
    [<ffffffff84126b81>] ieee80211_iface_work+0x601/0x780 net/mac80211/iface.c:1581
    [<ffffffff8127130f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff81271c39>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
    [<ffffffff8127b955>] kthread+0x125/0x160 kernel/kthread.c:376
    [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

BUG: memory leak
unreferenced object 0xffff88810a760100 (size 96):
  comm "kworker/u4:0", pid 8, jiffies 4294943986 (age 8.400s)
  hex dump (first 32 bytes):
    36 80 a0 53 ad e3 05 00 00 00 00 00 00 00 00 00  6..S............
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff840740b6>] cfg80211_inform_single_bss_frame_data+0x186/0x6a0 net/wireless/scan.c:2445
    [<ffffffff8407461b>] cfg80211_inform_bss_frame_data+0x4b/0x460 net/wireless/scan.c:2506
    [<ffffffff84115816>] ieee80211_bss_info_update+0x196/0x440 net/mac80211/scan.c:190
    [<ffffffff841240e2>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff841240e2>] ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
    [<ffffffff841240e2>] ieee80211_ibss_rx_queued_mgmt+0x7d2/0x11a0 net/mac80211/ibss.c:1639
    [<ffffffff84126b81>] ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
    [<ffffffff84126b81>] ieee80211_iface_work+0x601/0x780 net/mac80211/iface.c:1581
    [<ffffffff8127130f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff81271c39>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
    [<ffffffff8127b955>] kthread+0x125/0x160 kernel/kthread.c:376
    [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

BUG: memory leak
unreferenced object 0xffff888114cb9100 (size 96):
  comm "kworker/u4:3", pid 53, jiffies 4294944017 (age 8.090s)
  hex dump (first 32 bytes):
    95 32 a5 53 ad e3 05 00 00 00 00 00 00 00 00 00  .2.S............
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff840740b6>] cfg80211_inform_single_bss_frame_data+0x186/0x6a0 net/wireless/scan.c:2445
    [<ffffffff8407461b>] cfg80211_inform_bss_frame_data+0x4b/0x460 net/wireless/scan.c:2506
    [<ffffffff84115816>] ieee80211_bss_info_update+0x196/0x440 net/mac80211/scan.c:190
    [<ffffffff841240e2>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff841240e2>] ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
    [<ffffffff841240e2>] ieee80211_ibss_rx_queued_mgmt+0x7d2/0x11a0 net/mac80211/ibss.c:1639
    [<ffffffff84126b81>] ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
    [<ffffffff84126b81>] ieee80211_iface_work+0x601/0x780 net/mac80211/iface.c:1581
    [<ffffffff8127130f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff81271c39>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
    [<ffffffff8127b955>] kthread+0x125/0x160 kernel/kthread.c:376
    [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

BUG: memory leak
unreferenced object 0xffff888114afa500 (size 96):
  comm "kworker/u4:3", pid 53, jiffies 4294944037 (age 7.890s)
  hex dump (first 32 bytes):
    1c 46 a8 53 ad e3 05 00 00 00 00 00 00 00 00 00  .F.S............
    00 00 00 00 00 00 00 00 28 00 00 00 01 00 06 10  ........(.......
  backtrace:
    [<ffffffff840740b6>] cfg80211_inform_single_bss_frame_data+0x186/0x6a0 net/wireless/scan.c:2445
    [<ffffffff8407461b>] cfg80211_inform_bss_frame_data+0x4b/0x460 net/wireless/scan.c:2506
    [<ffffffff84115816>] ieee80211_bss_info_update+0x196/0x440 net/mac80211/scan.c:190
    [<ffffffff841240e2>] ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
    [<ffffffff841240e2>] ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
    [<ffffffff841240e2>] ieee80211_ibss_rx_queued_mgmt+0x7d2/0x11a0 net/mac80211/ibss.c:1639
    [<ffffffff84126b81>] ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
    [<ffffffff84126b81>] ieee80211_iface_work+0x601/0x780 net/mac80211/iface.c:1581
    [<ffffffff8127130f>] process_one_work+0x2bf/0x600 kernel/workqueue.c:2289
    [<ffffffff81271c39>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
    [<ffffffff8127b955>] kthread+0x125/0x160 kernel/kthread.c:376
    [<ffffffff8100225f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

[   75.59820


Tested on:

commit:         b047602d Merge tag 'trace-v5.19-rc5' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10cfa478080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=689b5fe7168a1260
dashboard link: https://syzkaller.appspot.com/bug?extid=7a942657a255a9d9b18a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
