Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C6318503
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 06:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBKFyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 00:54:02 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:44560 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBKFyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 00:54:01 -0500
Received: by mail-il1-f200.google.com with SMTP id a9so5153158ilm.11
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 21:53:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Wkq911BJFvp1tS//mvCstSI7Y+mPtfptFUT/RZukAV4=;
        b=t9CO0ggZF2Yed+feoVMAXwA2gojPYEPCARujjL4TbR6eyzxzYPZQ9oF1bLA6R9Jvi1
         zO1ahzFjGLMdoSdZtrHBm+KYmEUtPHxK0160x+y0aY0mYmpbEAIU2fzK11llLi5FsCQq
         fu/MxP5+F/2xDlB6y13g+Bq+Gxzrgv2GE2R7xoLA5mj2V1qk5A5SnODI3YeYlWBLHVCz
         KI4feD2URNksUzygiwQsGSRYLjrjnzP7hOhXxC5wV6yhYdEncX7xFLAZwYTiqC9FlwYh
         bCDtl7sD27aEvF8SosH9++bd8Gnujg5XVSjuSPYVhzr98YK+5urrYwV/ePD0Ssp/IfWe
         +aUw==
X-Gm-Message-State: AOAM532wbyqkAdovUC7e0VHDiRJzL3EyDWgsRphGVZbdAmwqpEAk2RfH
        wAhSq1IATTng17H/ApllpXHHNrPMOFbyizYSN6to57cJRr8j
X-Google-Smtp-Source: ABdhPJx7oqpHj50ldn6lnChFwjAb7y4NQ+j7E1KudbURX6pUSb+1PWg/BH9leyWa3+aiTAQbgFs3sfOezf5YH8oTI5DUooStBY3r
MIME-Version: 1.0
X-Received: by 2002:a05:6638:40b:: with SMTP id q11mr6918081jap.133.1613022800439;
 Wed, 10 Feb 2021 21:53:20 -0800 (PST)
Date:   Wed, 10 Feb 2021 21:53:20 -0800
In-Reply-To: <0000000000005243f805b05abc7c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000008f12905bb0923e0@google.com>
Subject: Re: KASAN: null-ptr-deref Read in tcf_idrinfo_destroy
From:   syzbot <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    291009f6 Merge tag 'pm-5.11-rc8' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14470d18d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a53fd47f16f22f8c
dashboard link: https://syzkaller.appspot.com/bug?extid=151e3e714d34ae4ce7e8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f45814d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f4aff8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:71 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in __tcf_idr_release net/sched/act_api.c:178 [inline]
BUG: KASAN: null-ptr-deref in tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
Read of size 4 at addr 0000000000000010 by task kworker/u4:5/204

CPU: 0 PID: 204 Comm: kworker/u4:5 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 __kasan_report mm/kasan/report.c:400 [inline]
 kasan_report.cold+0x5f/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:178 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 204 Comm: kworker/u4:5 Tainted: G    B             5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 panic+0x306/0x73d kernel/panic.c:231
 end_report+0x58/0x5e mm/kasan/report.c:100
 __kasan_report mm/kasan/report.c:403 [inline]
 kasan_report.cold+0x67/0xd5 mm/kasan/report.c:413
 check_memory_region_inline mm/kasan/generic.c:179 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:185
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:178 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:598
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:190
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:604
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Kernel Offset: disabled
Rebooting in 86400 seconds..

