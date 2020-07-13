Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE621D153
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgGMIFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:05:19 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48678 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgGMIFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 04:05:19 -0400
Received: by mail-io1-f71.google.com with SMTP id r9so7571479ioa.15
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 01:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=21l/VJU15KAsnv6DFGRRcwLsfDDBxLOaO9Owh599Apk=;
        b=ommoKmrdDE70cmprj+Jnf7CzHrl7uEGFcMfobwA+bQHJJcc67r4PR+ibA+Z4smeH3h
         VPIode8lFNc677MIgKJs3LO6gdYgDKRlAebbU4ibJ9nLXr35HLr8Nj3RWl0c1YUX4e4Y
         ve+hHesl/J2vKvcJ+WxqjgdQgL2bwP+CNQmLHbPAXElTj0Btol9oIqYgvuiS5b3OJh96
         3WAfapK8WTc0Obrjcv4p+cwDGZMkxNO6DxXE8O8SIvExtuqXk/ykO5AYexv/nc0405sr
         qoIkq0WckzKlV+d1Sva1+sK2eU7n/UuijT96dyCezIbrE3aEE4hpY9QKwW43fx8c5HGH
         EkBA==
X-Gm-Message-State: AOAM530bxaSwGGiji8LtAbUVB2dmclAk1SKVYSz+rNjr+EWDU3GFcao0
        Mr7MdPfWMXubrVJEH4IgsTWYZEYES7go4nghGlvoi+gdXFSV
X-Google-Smtp-Source: ABdhPJyBTWanyyS9AkrkocASW9iTXQVQVoUAT/nfbhm2a2oxMn8CtwX8bai8tBU+PpeR+VSF1pbBo3d2ffHh9pFwrYPfOtaTfzst
MIME-Version: 1.0
X-Received: by 2002:a05:6638:236:: with SMTP id f22mr90526977jaq.18.1594627518110;
 Mon, 13 Jul 2020 01:05:18 -0700 (PDT)
Date:   Mon, 13 Jul 2020 01:05:18 -0700
In-Reply-To: <000000000000d411cf05a8ffc4a6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c421ef05aa4e2649@google.com>
Subject: Re: WARNING: suspicious RCU usage in tipc_l2_send_msg
From:   syzbot <syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    4437dd6e Merge tag 'io_uring-5.8-2020-07-12' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b7869f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=47bbc6b678d317cccbe0
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c005af100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.8.0-rc4-syzkaller #0 Not tainted
-----------------------------
net/tipc/bearer.c:466 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/0:1/12:
 #0: ffff88821adc9538 ((wq_completion)cryptd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821adc9538 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88821adc9538 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88821adc9538 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88821adc9538 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88821adc9538 ((wq_completion)cryptd){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90000d2fda8 ((work_completion)(&cpu_queue->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244

stack backtrace:
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cryptd cryptd_queue_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 tipc_l2_send_msg+0x354/0x420 net/tipc/bearer.c:466
 tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
 cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
 cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

