Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F1627A8C3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgI1HhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:37:17 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:57043 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgI1HhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:37:17 -0400
Received: by mail-il1-f207.google.com with SMTP id d16so89623ila.23
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:37:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4/JzsdKszztej2WyY/DrDGTTnouC9MBFSHfHUXPiqFs=;
        b=DjPv9jBDXBkkcfIBPq1LW0DZFKJ4jnuc9pWcUsgem5uUM9zMvXtBkxHimsswS99GjF
         7zKZ5TeDi4u+wmxJl9SjSxusoHlMWmzo3OBa95msVoMYdzLZWBv/NbbvL90u0PooA4xs
         tkV+CuiZ4qiOGK7Cjgw/OMkaOOPe2lnlrW63LQ3e7s8eyZGBqdnIPpHzx9feAUKKDq3H
         7jgGwjg3cQ76TaXEG+o+quJ7BPsuS53WY+8nY2XFrK9NFN04FPVT7qFsRu0TlA/iAToY
         qm2SEWK6daHdNdLNgRSdT+055PFP6g+qBR7aXg/X3Mt8SvgfLXGZ36AXlaA91SDZ65+8
         CvsQ==
X-Gm-Message-State: AOAM533rFq6ZX6YWQplaHp0RrujfGEOtMUKMqo5ZQmoaMtSZz/IJXaQ1
        aTRcD88iiCEFS+cZlssQS70JVssmThgWmp1LeEaSzndAeTIF
X-Google-Smtp-Source: ABdhPJzG9AlYyvLZe/KXHItiwqcv9vpEPO3Eh2G2B7nTWLiUYkpDmQpPIls0Erfc8w9yibExuLhYp7vO47oP8ZNI/8/lpzDsrbka
MIME-Version: 1.0
X-Received: by 2002:a92:1504:: with SMTP id v4mr135357ilk.26.1601278636604;
 Mon, 28 Sep 2020 00:37:16 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:37:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005243f805b05abc7c@google.com>
Subject: KASAN: null-ptr-deref Read in tcf_idrinfo_destroy
From:   syzbot <syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    05943249 net: atlantic: fix build when object tree is sepa..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15054509900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=151e3e714d34ae4ce7e8
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+151e3e714d34ae4ce7e8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:56 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in __tcf_idr_release net/sched/act_api.c:162 [inline]
BUG: KASAN: null-ptr-deref in tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:548
Read of size 4 at addr 0000000000000010 by task kworker/u4:0/7

CPU: 1 PID: 7 Comm: kworker/u4:0 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 __kasan_report mm/kasan/report.c:517 [inline]
 kasan_report.cold+0x5/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:162 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:548
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7 Comm: kworker/u4:0 Tainted: G    B             5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 end_report+0x4d/0x53 mm/kasan/report.c:104
 __kasan_report mm/kasan/report.c:520 [inline]
 kasan_report.cold+0xd/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 __tcf_idr_release net/sched/act_api.c:162 [inline]
 tcf_idrinfo_destroy+0x129/0x1d0 net/sched/act_api.c:548
 tc_action_net_exit include/net/act_api.h:151 [inline]
 police_exit_net+0x168/0x360 net/sched/act_police.c:390
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:189
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
