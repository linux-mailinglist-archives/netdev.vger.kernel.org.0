Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EF64E69BF
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 21:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353350AbiCXUV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 16:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353344AbiCXUV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 16:21:57 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5D1AF1DB
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 13:20:22 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id g16-20020a05660203d000b005f7b3b0642eso3773435iov.16
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 13:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=k+/Px3J18ct4MWwIC9SB1CG75VmFLpzvG31ThQP4l6M=;
        b=R3HLV+jEfGJ8s1CvkgaMdbH7mBvAmUyU3dA19X0HKm4ljxT0qu+Ger87jdneAbeC/C
         u9FopkLUXGQTQg515cyzvmQWL+IyAIxG9Fsdt7r3kd30w7h8vFWgvbNnDaH9+Y86y9ss
         JapFL8OBX+w6TN62SI1HaWp+rtoCRlxrVUeghTd+rAgRrGBTgAV07D6zlP0CSwxKpc+T
         AOIuG7GsNGWTlwYBfVCzGwD11uKleXDZtSBuG6+2+dDYr4wP0xhqJK/L99t8B6Qs81DU
         ijpwV5O0Ti8k08/UI4dRqbFhRK7AH0bv3uxewzi/rNfqNxdmPIJ4NhTI+OltnUCjKKuO
         DjIA==
X-Gm-Message-State: AOAM530BWmWWomLqndtDRy459TUqEzNE8PBQXaf2EbfjPMWxuvTHFiu2
        G1Li3oZC+FNSzL9M91cZ4O8Ichm3rAAVM+SPMMAQrtW5Xnq8
X-Google-Smtp-Source: ABdhPJzOJ6i0rxvmuhErCiMqlfNJkUONDof8H6bBYgiAmTddEX2Ubyx5+lqv9B4zQP4Fv0f1/ImTjlvSa03h5CaRqdghuhK7H1Jn
MIME-Version: 1.0
X-Received: by 2002:a92:c541:0:b0:2c8:2488:154d with SMTP id
 a1-20020a92c541000000b002c82488154dmr3796717ilj.229.1648153222218; Thu, 24
 Mar 2022 13:20:22 -0700 (PDT)
Date:   Thu, 24 Mar 2022 13:20:22 -0700
In-Reply-To: <00000000000009442305b65af1fa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005887f405dafc930d@google.com>
Subject: Re: [syzbot] INFO: task hung in netdev_run_todo (2)
From:   syzbot <syzbot+9d77543f47951a63d5c1@syzkaller.appspotmail.com>
To:     Larry.Finger@lwfinger.net, davem@davemloft.net,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        payroll@tennesseecarriers.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    ed4643521e6a Merge tag 'arm-dt-5.18' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105db1dd700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=77631dc57d015556
dashboard link: https://syzkaller.appspot.com/bug?extid=9d77543f47951a63d5c1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a8af6d700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17dacda3700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d77543f47951a63d5c1@syzkaller.appspotmail.com

INFO: task kworker/1:2:3649 blocked for more than 143 seconds.
      Tainted: G        W         5.17.0-syzkaller-04443-ged4643521e6a #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:2     state:D stack:24952 pid: 3649 ppid:     2 flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5073 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6382
 schedule+0xd2/0x1f0 kernel/sched/core.c:6454
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6513
 __mutex_lock_common kernel/locking/mutex.c:673 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:733
 netdev_run_todo+0x70f/0xaa0 net/core/dev.c:9967
 r871xu_dev_remove+0x24f/0x2c0 drivers/staging/rtl8712/usb_intf.c:599
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 __device_release_driver+0x627/0x760 drivers/base/dd.c:1209
 device_release_driver_internal drivers/base/dd.c:1242 [inline]
 device_release_driver+0x26/0x40 drivers/base/dd.c:1265
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x278/0x6ec drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5202 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5502 [inline]
 port_event drivers/usb/core/hub.c:5660 [inline]
 hub_event+0x1e74/0x4680 drivers/usb/core/hub.c:5742
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 process_scheduled_works kernel/workqueue.c:2352 [inline]
 worker_thread+0x854/0x1080 kernel/workqueue.c:2438
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Tainted: G        W         5.17.0-syzkaller-04443-ged4643521e6a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:369
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3639 Comm: syz-executor169 Tainted: G        W         5.17.0-syzkaller-04443-ged4643521e6a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:____rb_erase_color lib/rbtree.c:259 [inline]
RIP: 0010:rb_erase+0x516/0x1210 lib/rbtree.c:445
Code: 48 89 f9 48 c1 e9 03 80 3c 19 00 0f 85 bb 0b 00 00 49 8d 7d 10 4c 89 60 08 48 89 f8 48 c1 e8 03 80 3c 18 00 0f 85 90 0b 00 00 <4d> 89 ec 4d 8b 6d 10 e9 cb fd ff ff 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90002befa38 EFLAGS: 00000046
RAX: 1ffff1100fd8aaf4 RBX: dffffc0000000000 RCX: 1ffff110173873d1
RDX: ffffed10173873d0 RSI: ffff8880b9c39e80 RDI: ffff88807ec557a0
RBP: ffff88801da05790 R08: ffff8880b9c39e40 R09: 0000000000000000
R10: 0000000000000006 R11: ffff8880b9c3a958 R12: ffff88801d7d5790
R13: ffff88807ec55790 R14: ffff88801da05791 R15: ffff8880b9c39e80
FS:  00005555558cf300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f945ed6a01d CR3: 00000000222c0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rb_erase_cached include/linux/rbtree.h:126 [inline]
 __dequeue_entity kernel/sched/fair.c:624 [inline]
 set_next_entity+0x334/0x5e0 kernel/sched/fair.c:4522
 pick_next_task_fair+0x6ad/0xe20 kernel/sched/fair.c:7348
 __pick_next_task kernel/sched/core.c:5695 [inline]
 pick_next_task kernel/sched/core.c:5768 [inline]
 __schedule+0x3e8/0x4940 kernel/sched/core.c:6346
 schedule+0xd2/0x1f0 kernel/sched/core.c:6454
 freezable_schedule include/linux/freezer.h:172 [inline]
 do_nanosleep+0x24e/0x690 kernel/time/hrtimer.c:2044
 hrtimer_nanosleep+0x1f9/0x4a0 kernel/time/hrtimer.c:2097
 common_nsleep+0xa2/0xc0 kernel/time/posix-timers.c:1227
 __do_sys_clock_nanosleep kernel/time/posix-timers.c:1267 [inline]
 __se_sys_clock_nanosleep kernel/time/posix-timers.c:1245 [inline]
 __x64_sys_clock_nanosleep+0x2f4/0x430 kernel/time/posix-timers.c:1245
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f945ed4a2aa
Code: 83 ff 03 74 3b 48 83 ec 28 b8 fa ff ff ff 83 ff 02 49 89 ca 0f 44 f8 64 8b 04 25 18 00 00 00 85 c0 75 2d b8 e6 00 00 00 0f 05 <89> c2 f7 da 3d 00 f0 ff ff b8 00 00 00 00 0f 47 c2 48 83 c4 28 c3
RSP: 002b:00007ffcdea2c300 EFLAGS: 00000246 ORIG_RAX: 00000000000000e6
RAX: ffffffffffffffda RBX: 00000000000f4240 RCX: 00007f945ed4a2aa
RDX: 00007ffcdea2c340 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 000000000000126b R08: 00000000000002cc R09: 00007ffcdea53080
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000adfd3
R13: 00007ffcdea2c37c R14: 00007ffcdea2c390 R15: 00007ffcdea2c380
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.178 msecs
----------------
Code disassembly (best guess):
   0:	48 89 f9             	mov    %rdi,%rcx
   3:	48 c1 e9 03          	shr    $0x3,%rcx
   7:	80 3c 19 00          	cmpb   $0x0,(%rcx,%rbx,1)
   b:	0f 85 bb 0b 00 00    	jne    0xbcc
  11:	49 8d 7d 10          	lea    0x10(%r13),%rdi
  15:	4c 89 60 08          	mov    %r12,0x8(%rax)
  19:	48 89 f8             	mov    %rdi,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
  24:	0f 85 90 0b 00 00    	jne    0xbba
* 2a:	4d 89 ec             	mov    %r13,%r12 <-- trapping instruction
  2d:	4d 8b 6d 10          	mov    0x10(%r13),%r13
  31:	e9 cb fd ff ff       	jmpq   0xfffffe01
  36:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3d:	fc ff df

