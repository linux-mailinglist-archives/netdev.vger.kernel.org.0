Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8D2B728A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 07:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbfISFPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 01:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387504AbfISFPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 01:15:49 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3AC218AF;
        Thu, 19 Sep 2019 05:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568870147;
        bh=+F97g8sywaBdDmXy+WnETYNndQJbk2uNSotSgQELzl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZ++X25Nr1vegFi0/+ASO/swL0almkHCvgg4Hh98LHRVDOhjMGhyTNJFqLSMu5g7y
         PwM9rf0HQXA5OSqK/rlmK4UCJi9+tJlJRESYRDSvMcuohbBwuRL4+wLW4+OQjFY3Xg
         YISssXuGi0f+thaWl6STOw6qkN5a257ScLIUkVqA=
Date:   Wed, 18 Sep 2019 22:15:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     steffen.klassert@secunet.com,
        syzbot <syzbot+f39ab8494f6015e62360@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, ilyal@mellanox.com,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: INFO: task hung in cancel_delayed_work_sync
Message-ID: <20190919051545.GB666@sol.localdomain>
Mail-Followup-To: steffen.klassert@secunet.com,
        syzbot <syzbot+f39ab8494f6015e62360@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, ilyal@mellanox.com,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000001348750592a8ef50@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001348750592a8ef50@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 03:19:06AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    f4b752a6 mlx4: fix spelling mistake "veify" -> "verify"
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1183c7fa600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
> dashboard link: https://syzkaller.appspot.com/bug?extid=f39ab8494f6015e62360
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14426d85600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110c1af1600000
> 
> The bug was bisected to:
> 
> commit 3c4d7559159bfe1e3b94df3a657b2cda3a34e218
> Author: Dave Watson <davejwatson@fb.com>
> Date:   Wed Jun 14 18:37:39 2017 +0000
> 
>     tls: kernel TLS support
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144a4ffa600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=164a4ffa600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=124a4ffa600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f39ab8494f6015e62360@syzkaller.appspotmail.com
> Fixes: 3c4d7559159b ("tls: kernel TLS support")
> 
> INFO: task syz-executor279:9995 blocked for more than 143 seconds.
>       Not tainted 5.3.0-rc7+ #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor279 D24264  9995   9994 0x00000000
> Call Trace:
>  context_switch kernel/sched/core.c:3254 [inline]
>  __schedule+0x755/0x1580 kernel/sched/core.c:3880
>  schedule+0xd9/0x260 kernel/sched/core.c:3947
>  schedule_timeout+0x717/0xc50 kernel/time/timer.c:1783
>  do_wait_for_common kernel/sched/completion.c:83 [inline]
>  __wait_for_common kernel/sched/completion.c:104 [inline]
>  wait_for_common kernel/sched/completion.c:115 [inline]
>  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
>  __flush_work+0x508/0xa50 kernel/workqueue.c:3040
>  __cancel_work_timer+0x3d9/0x540 kernel/workqueue.c:3127
>  cancel_delayed_work_sync+0x1b/0x20 kernel/workqueue.c:3259
>  tls_sw_cancel_work_tx+0x68/0x80 net/tls/tls_sw.c:2063
>  tls_sk_proto_close+0x4ac/0x990 net/tls/tls_main.c:299
>  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
>  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
>  __sock_release+0xce/0x280 net/socket.c:590
>  sock_close+0x1e/0x30 net/socket.c:1268
>  __fput+0x2ff/0x890 fs/file_table.c:280
>  ____fput+0x16/0x20 fs/file_table.c:313
>  task_work_run+0x145/0x1c0 kernel/task_work.c:113
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x401f40
> Code: ff ff ff 25 62 63 20 00 68 08 00 00 00 e9 60 ff ff ff ff 25 5a 63 20
> 00 68 09 00 00 00 e9 50 ff ff ff ff 25 52 63 20 00 68 0a <00> 00 00 e9 40 ff
> ff ff ff 25 4a 63 20 00 68 0b 00 00 00 e9 30 ff
> RSP: 002b:00007fffd8200d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000401f40
> RDX: ffffffffffffffc1 RSI: 1201000000003618 RDI: 0000000000000004
> RBP: 00007fffd8200d70 R08: 0000000000000000 R09: 1201000000003618
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000403170 R14: 0000000000000000 R15: 0000000000000000
> INFO: lockdep is turned off.
> NMI backtrace for cpu 1
> CPU: 1 PID: 1057 Comm: khungtaskd Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
>  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
>  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
>  watchdog+0x9d0/0xef0 kernel/hung_task.c:289
>  kthread+0x361/0x430 kernel/kthread.c:255
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xe/0x10
> arch/x86/include/asm/irqflags.h:60
> 

Reproducer involves pcrypt, so probably the pcrypt deadlock again...
https://lkml.kernel.org/linux-crypto/20190817054743.GE8209@sol.localdomain/

#syz dup: INFO: task hung in aead_recvmsg
