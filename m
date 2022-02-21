Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D614BD7BB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 09:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbiBUIQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 03:16:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238554AbiBUIQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 03:16:18 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9752311C06;
        Mon, 21 Feb 2022 00:15:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645431350; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=k5x6oVAljLuBpLPRoOGNsamUR7Eiv8GhSDAxlsruYthWyQ9Dj1+7z3NYlMPN//r0iLdzPvRRCzjeLQASM0EMqDJgd4dtwI6HG/98Lsv0R4k4rPnMdYFSRKjBCj0DyjNaqpmTS2cG7rWuyStVz/i6o8FrnLN2GlcZWhY4AGsrm+E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1645431350; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=GmBkFG7aVvc04mbd27QW3Z6rAMUmjJC+FlesKAAb+mo=; 
        b=l4sChsBPP1+JrIfYOBMt8Vig0FpbJmOmdBwf8k+Dgiet2OJ2+qvz4HRLFxMfd/YrivtBL6+00eM/JIN96Pe8QOyePLccxNHQhofqv3XQ1EVAT/yQJFOlI2rLvPPElSQFyPtp5ecDnFjJcNDjNi3LBOhZgovVEUODBVtuvs+ojhw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645431350;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=GmBkFG7aVvc04mbd27QW3Z6rAMUmjJC+FlesKAAb+mo=;
        b=wAd9ZI/MMLbDfhwHB4PzA3+PGyxOh+RfdN8ytOoiXTR71+7KBSgmrCJq85JFPapa
        JXq+10harmXncPps5pbCrZL6OKlVqwHKzrmbh6gf8wOyqY8dO2aiWwgpEBhMEsC1gDy
        R8+v/CJABd1WXWgSBtSt/vOyrEhmt4n8chkzdR1E=
Received: from anirudhrb.com (49.207.203.0 [49.207.203.0]) by mx.zohomail.com
        with SMTPS id 16454313464331010.5526723272824; Mon, 21 Feb 2022 00:15:46 -0800 (PST)
Date:   Mon, 21 Feb 2022 13:45:37 +0530
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     syzbot <syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] INFO: task hung in vhost_work_dev_flush
Message-ID: <YhNKKd6ylpCi66C5@anirudhrb.com>
References: <00000000000057702a05d8532b18@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000057702a05d8532b18@google.com>
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 03:23:24PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e6251ab4551f Merge tag 'nfs-for-5.17-2' of git://git.linux..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=163caa3c700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=266de9da75c71a45
> dashboard link: https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108514a4700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ca671c700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com

Sent a patch for this here:
https://lore.kernel.org/lkml/20220221072852.31820-1-mail@anirudhrb.com/

> 
> INFO: task syz-executor117:3632 blocked for more than 143 seconds.
>       Not tainted 5.17.0-rc3-syzkaller-00029-ge6251ab4551f #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor117 state:D stack:27512 pid: 3632 ppid:  3631 flags:0x00004002
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:4986 [inline]
>  __schedule+0xab2/0x4db0 kernel/sched/core.c:6295
>  schedule+0xd2/0x260 kernel/sched/core.c:6368
>  schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x174/0x270 kernel/sched/completion.c:138
>  vhost_work_dev_flush.part.0+0xbb/0xf0 drivers/vhost/vhost.c:243
>  vhost_work_dev_flush drivers/vhost/vhost.c:238 [inline]
>  vhost_poll_flush+0x5e/0x80 drivers/vhost/vhost.c:252
>  vhost_vsock_flush drivers/vhost/vsock.c:710 [inline]
>  vhost_vsock_dev_release+0x1be/0x4b0 drivers/vhost/vsock.c:757
>  __fput+0x286/0x9f0 fs/file_table.c:311
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0xb29/0x2a30 kernel/exit.c:806
>  do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>  __do_sys_exit_group kernel/exit.c:946 [inline]
>  __se_sys_exit_group kernel/exit.c:944 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:944
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fbf04b83b89
> RSP: 002b:00007fff5bc9ca18 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007fbf04bf8330 RCX: 00007fbf04b83b89
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00007fff5bc9cc08
> R10: 00007fff5bc9cc08 R11: 0000000000000246 R12: 00007fbf04bf8330
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
>  </TASK>
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/26:
>  #0: ffffffff8bb83c20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6460
> 2 locks held by getty/3275:
>  #0: ffff88807f0db098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
>  #1: ffffc90002b662e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2077
> 1 lock held by vhost-3632/3633:
> 
> =============================================
> 
> NMI backtrace for cpu 0
> CPU: 0 PID: 26 Comm: khungtaskd Not tainted 5.17.0-rc3-syzkaller-00029-ge6251ab4551f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
>  watchdog+0xc1d/0xf50 kernel/hung_task.c:369
>  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 PID: 3633 Comm: vhost-3632 Not tainted 5.17.0-rc3-syzkaller-00029-ge6251ab4551f #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:check_kcov_mode kernel/kcov.c:166 [inline]
> RIP: 0010:__sanitizer_cov_trace_pc+0xd/0x60 kernel/kcov.c:200
> Code: 00 00 e9 c6 41 66 02 66 0f 1f 44 00 00 48 8b be b0 01 00 00 e8 b4 ff ff ff 31 c0 c3 90 65 8b 05 29 f7 89 7e 89 c1 48 8b 34 24 <81> e1 00 01 00 00 65 48 8b 14 25 00 70 02 00 a9 00 01 ff 00 74 0e
> RSP: 0018:ffffc90000cd7c78 EFLAGS: 00000246
> RAX: 0000000080000000 RBX: ffff888079ca8a80 RCX: 0000000080000000
> RDX: 0000000000000000 RSI: ffffffff86d3f8fb RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffc90000cd7c77
> R10: ffffffff86d3f8ed R11: 0000000000000001 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffdf716a3b8 CR3: 00000000235b6000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
>  vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
>  vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
>  vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:	00 00                	add    %al,(%rax)
>    2:	e9 c6 41 66 02       	jmpq   0x26641cd
>    7:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
>    d:	48 8b be b0 01 00 00 	mov    0x1b0(%rsi),%rdi
>   14:	e8 b4 ff ff ff       	callq  0xffffffcd
>   19:	31 c0                	xor    %eax,%eax
>   1b:	c3                   	retq
>   1c:	90                   	nop
>   1d:	65 8b 05 29 f7 89 7e 	mov    %gs:0x7e89f729(%rip),%eax        # 0x7e89f74d
>   24:	89 c1                	mov    %eax,%ecx
>   26:	48 8b 34 24          	mov    (%rsp),%rsi
> * 2a:	81 e1 00 01 00 00    	and    $0x100,%ecx <-- trapping instruction
>   30:	65 48 8b 14 25 00 70 	mov    %gs:0x27000,%rdx
>   37:	02 00
>   39:	a9 00 01 ff 00       	test   $0xff0100,%eax
>   3e:	74 0e                	je     0x4e
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000057702a05d8532b18%40google.com.
