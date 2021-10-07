Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415DC424D4A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbhJGGcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhJGGcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 02:32:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57635C061746;
        Wed,  6 Oct 2021 23:30:57 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r2so4704565pgl.10;
        Wed, 06 Oct 2021 23:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=XO3lRP3cXCeiA36lTiqks/6MdSscV2guR0tRwbpc/co=;
        b=TZLOwgtLn0f+U1XNxuBm2KRW16/C3qqQ6jnIXuY45BbooKD95XebnJpVdinf4d7nSl
         K1Thjte4I7kraCYbZAbuhG5IXLrK8T9G/dZzXqPwPKKKtLkA9vnDUwKwfhOFEtQW6Q7f
         EEXAdS4U1vSHsv96aDBWcjKQfKfcuDgkh09Nx6QCLsK1y+QenakRKtKIu/lnX/ZQOpYs
         H3Kr4XnAm0Tig0l8BLj77s0qh8YyD6NfZxoKZZjUdfhkv3OdRX3uGGdR3xiCc+giTJmJ
         RSglLuaKpvl+QTZ3qpaNFSdQ3cD8Wk4iRQLMybmVroW6y6wt9dWxT5Api2uK/LvoP+GB
         lzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XO3lRP3cXCeiA36lTiqks/6MdSscV2guR0tRwbpc/co=;
        b=o8cexz4G+UfpD52lK7q3JzMPv9JtGt67+E98ilIUL5zwWimcf2cunil8k6McFTT4UU
         IvbxGk9xd5emAuSO09mUAIWoQ1xl5JqmikNswqR1XOxqvw90QUKCXZLo3j47yTQ9I+8b
         uSq0W6mV61xM+aZJUQLmQa2rWJULvpHUTa8DH3h/LoJOLHv2txa+c/1cO9Ok0rKmra8k
         fm2b2RnHYQ1O15quUlEdLYrmF/W8TS6oLc+A45ie0cMREpBxKvOtm/gwIuXcUDgwGLpp
         wVd0e50fBFnvhX42WP+5rr5nueD8glu7A+Eib0rWKP9YNgaV7sG9YOxXS0Srl1aDHq+f
         3YWQ==
X-Gm-Message-State: AOAM5339AqezSwlbVGSmzXTjxyZLc3zl1wg/+TZyiAVbfP3g3Q+diQIV
        rmDAU8zvFLZgx7o+Te9hpwjEc5OjUvDyDvxPJA==
X-Google-Smtp-Source: ABdhPJwzjU7Qu19WUal3/nl1ajSXJc0XwY+mwUT5eBKbS2enAVCCGSEUgs1wyTLEnZ93Fno9LPq7lFgBS4euZ3vpsWk=
X-Received: by 2002:a63:2c02:: with SMTP id s2mr1992750pgs.205.1633588256780;
 Wed, 06 Oct 2021 23:30:56 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 7 Oct 2021 14:30:45 +0800
Message-ID: <CACkBjsbBav-b7R0Lc9m1KX39hc3vNs=+zppUgwBwjPLR09LPFQ@mail.gmail.com>
Subject: INFO: task hung in default_device_exit_batch
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        changbin.du@intel.com, christian.brauner@ubuntu.com,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 60a9483534ed Merge tag 'warning-fixes-20211005'
git tree: upstream
console output:
https://drive.google.com/file/d/1O9MGWT8Uz9KMQOs-sDxUh60WcV-aXBwc/view?usp=sharing
kernel config: https://drive.google.com/file/d/1u-ncYGLkq3xqdlNQYJz8-G6Fhf3H-moP/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task kworker/u8:0:8 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc4+ #22
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:0    state:D stack:12328 pid:    8 ppid:     2 flags:0x00004000
Workqueue: netns cleanup_net
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x323/0xae0 kernel/sched/core.c:6287
 schedule+0x36/0xe0 kernel/sched/core.c:6366
 schedule_timeout+0x189/0x430 kernel/time/timer.c:1857
 wait_woken+0x38/0x80 kernel/sched/wait.c:453
 rtnl_lock_unregistering net/core/dev.c:11537 [inline]
 default_device_exit_batch+0xd3/0x1c0 net/core/dev.c:11564
 ops_exit_list.isra.8+0x73/0x80 net/core/net_namespace.c:171
 cleanup_net+0x2e6/0x4e0 net/core/net_namespace.c:591
 process_one_work+0x359/0x850 kernel/workqueue.c:2297
 worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 39 Comm: khungtaskd Not tainted 5.15.0-rc4+ #22
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:106
 nmi_cpu_backtrace+0x1e9/0x210 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x120/0x180 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0x4e1/0x980 kernel/hung_task.c:295
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0,2-3:
NMI backtrace for cpu 2 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
NMI backtrace for cpu 0
CPU: 0 PID: 3018 Comm: systemd-journal Not tainted 5.15.0-rc4+ #22
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
RIP: 0033:0x7f614e2500e0
Code: 8b 83 c8 00 00 00 48 8b 48 70 48 c1 e9 04 48 85 c9 0f 84 f2 01
00 00 31 d2 48 89 e8 48 f7 f1 48 c1 e2 04 48 03 93 d0 00 00 00 <4c> 8b
3a 4d 85 ff 74 8a 48 8d 44 24 50 4c 8d 64 24 48 48 89 44 24
RSP: 002b:00007ffe89863740 EFLAGS: 00010202
RAX: 0001392b77a9677a RBX: 00005594ff7b3e80 RCX: 000000000000aa9c
RDX: 00007f614b767320 RSI: 0000000000000000 RDI: 00005594ff7b3e80
RBP: d0b5b3f369f2992c R08: 00007ffe89863818 R09: 00007ffe89863820
R10: 00007f614e27aee8 R11: 00007f614d8aa060 R12: 00005594ff7b3e80
R13: 0000000000000032 R14: 00005594ff7bde00 R15: 00007ffe89863820
FS:  00007f614e55f8c0 GS:  0000000000000000
NMI backtrace for cpu 3 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 3 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 3 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
