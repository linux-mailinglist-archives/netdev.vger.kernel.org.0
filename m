Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7434A6BC1
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244794AbiBBGwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbiBBGwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:52:37 -0500
Received: from mail-io1-xd47.google.com (mail-io1-xd47.google.com [IPv6:2607:f8b0:4864:20::d47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D1DC061775
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 22:43:19 -0800 (PST)
Received: by mail-io1-xd47.google.com with SMTP id n13-20020a056602340d00b006361f2312deso626427ioz.9
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 22:43:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TNl+o4xe1hTSGSvtmbeiUvDNfb+TUX8jFchFwMWN6ps=;
        b=aGhEsyGq1beHvSI9QhHZ9o/F6JxKREghmCP2q1otMgdx9yvjHlz4OYWztCWdvmATVA
         x1YnPGt0tiZUSirk2YfXunedv78jf2k2v1nNW+WGx8MxRbeRY3HkjGh3kbMlYC98pzRY
         0CBz6bZ7U4FdAo3rh3vHu4UfReWw8lMAKV4Oy04t/LsL7/VkkYEMguP6sLGzXme+J6Bd
         NLZ043XOM2qfbc5RuTluWyVdfzmcbguwQp3lrSHGRwpN56vvg7iwOEScI2DjpTjfOt6G
         0kNeFjZggTh3ckZQ8fTZV3YVNSE6LVT0GWYuQi93jpoldl/lBGeZ12x1B+vYkFNAZEjm
         S78Q==
X-Gm-Message-State: AOAM531ExBdbEC/V1wFWpmHuu8C9cqxLjdlY4WIkCHeoK8uCzaWFpX2I
        ig39fNYvWW52exxWC86izZrPUyCdteoz9FqoLdPdi7LlN/4T
X-Google-Smtp-Source: ABdhPJxLyTp4zvyNH5kn1riAtyec1TsAvt6pgM0F8yYgyD4oCSh8hCZcROoVSXz/WFzKpwy0lvOD4IdQFRrXqAyp9PtOMIKcD68b
MIME-Version: 1.0
X-Received: by 2002:a92:cbcf:: with SMTP id s15mr16752186ilq.161.1643784197922;
 Tue, 01 Feb 2022 22:43:17 -0800 (PST)
Date:   Tue, 01 Feb 2022 22:43:17 -0800
In-Reply-To: <00000000000027db6705d6e6e88a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034665005d7035599@google.com>
Subject: Re: [syzbot] possible deadlock in ___neigh_create
From:   syzbot <syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com>
To:     daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e4d2763f9aaf Merge branch 'lan966x-ptp'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15b941f0700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e029d3b2ccd4c91a
dashboard link: https://syzkaller.appspot.com/bug?extid=5239d0e1778a500d477a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f9a76c700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.17.0-rc1-syzkaller-00547-ge4d2763f9aaf #0 Not tainted
--------------------------------------------
kworker/1:5/3747 is trying to acquire lock:
ffffffff8d4ddef0 (&tbl->lock){+.-.}-{2:2}, at: ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652

but task is already holding lock:
ffffffff8d4ddef0 (&tbl->lock){+.-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tbl->lock);
  lock(&tbl->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by kworker/1:5/3747:
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:631 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:658 [inline]
 #0: ffff888010c65d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x890/0x1650 kernel/workqueue.c:2278
 #1: ffffc90002d1fdb8 ((work_completion)(&(&tbl->managed_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8c4/0x1650 kernel/workqueue.c:2282
 #2: ffffffff8d4ddef0 (&tbl->lock){+.-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572
 #3: ffffffff8bb83ae0 (rcu_read_lock){....}-{1:2}, at: ip6_nd_hdr net/ipv6/ndisc.c:466 [inline]
 #3: ffffffff8bb83ae0 (rcu_read_lock){....}-{1:2}, at: ndisc_send_skb+0x84b/0x17f0 net/ipv6/ndisc.c:502
 #4: ffffffff8bb83a80 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #4: ffffffff8bb83a80 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x2ad/0x14f0 net/ipv6/ip6_output.c:112

stack backtrace:
CPU: 1 PID: 3747 Comm: kworker/1:5 Not tainted 5.17.0-rc1-syzkaller-00547-ge4d2763f9aaf #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient neigh_managed_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2956 [inline]
 check_deadlock kernel/locking/lockdep.c:2999 [inline]
 validate_chain kernel/locking/lockdep.c:3788 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5027
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
 _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:334
 ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
 ip6_finish_output2+0x1070/0x14f0 net/ipv6/ip6_output.c:123
 __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
 __ip6_finish_output+0x61e/0xe90 net/ipv6/ip6_output.c:170
 ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:451 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
 ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
 ndisc_solicit+0x2cd/0x4f0 net/ipv6/ndisc.c:742
 neigh_probe+0xc2/0x110 net/core/neighbour.c:1040
 __neigh_event_send+0x37d/0x1570 net/core/neighbour.c:1201
 neigh_event_send include/net/neighbour.h:470 [inline]
 neigh_managed_work+0x162/0x250 net/core/neighbour.c:1574
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

