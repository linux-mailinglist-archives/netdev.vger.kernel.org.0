Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4EDE7AA8
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388624AbfJ1VAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:00:14 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39841 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729596AbfJ1VAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:00:14 -0400
Received: by mail-pl1-f196.google.com with SMTP id t12so1660444plo.6
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 14:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=P/TNBkzS9c/yuaoKTyq62ByC/G1jJQ84tbNvzb7SgP4=;
        b=o0C9HsFtBU9Sra7x6IaGLFH7PguNxhPeWMy7ynv9qa03nFGgs3b/LqSleDwmrFa7hV
         HIpIl3ADXvcn4z/BekGETXFni2nBKstLman9EpDxXkk/x/PQ7fD5ZYSRriRgARzPcng5
         cAQASlDGW/NyW9Ys9CeBjqFTY/FDG6qDALiUmt2PvyDSvVFkCxVrpx14R+M9p+Bo7O5O
         4drW68U7DNRMUwdRVG+2EMbuu2DP5GhNnhPzMZXhyIPDaUrTSgEYX/0gMGUqpgIxjq/S
         Yf1WyoN4mnZMtAeR4hftKH7MSME6xXhzVvIWdCrToeqTYuc0g1Xd568hzngj7UmhwBXI
         sNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P/TNBkzS9c/yuaoKTyq62ByC/G1jJQ84tbNvzb7SgP4=;
        b=Pfeq0TDlj8fyTapcjp/eW0gjG5JtDies8zPPp35S3UGYByVrMkPAjW5Hk0OAfxvZIH
         ZPKuJgcgwLKhSPmBGUwZkMDyRB1YaG989z32GDd9pTJOA5f/93nsQ1UCUaDLLMq3HrLI
         A0zPADbqEigMRhYUajT1wb7jc50y5miZ/kh/7lFrAsYh1ZUpzkKLoplIgoTwC7abFJg7
         qNfuV6mb9uZ1ZW2VzXKsOcZO6NV+hjO8xCJWoQclJyZ3CSVDhQh0Wubb34ws2daSR7is
         7sYGAJgFTc5tmeDeZbe+uPDVH7ZQF0/yPA/sGDJ6Trl5ibcUXNvh7MRb5EsBpGBzZyJg
         hhiQ==
X-Gm-Message-State: APjAAAWV4R6+0W6lhNbPm+41SMHeWse/+/SLIhUXsqpXfuPyG8KLDcZE
        I5Ef+zvOQZay5dPAXPrq3j1y/Q==
X-Google-Smtp-Source: APXvYqx+2ejtwliH32Lrsh/HKKbawYZkx6gTkSPqk4stHnkUm7zC43dfFaIO4KnDQRSPXO/qOp1v1A==
X-Received: by 2002:a17:902:b20b:: with SMTP id t11mr52091plr.89.1572296413030;
        Mon, 28 Oct 2019 14:00:13 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id a8sm10678707pfc.20.2019.10.28.14.00.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 14:00:12 -0700 (PDT)
Subject: Re: INFO: task hung in io_wq_destroy
To:     syzbot <syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        idosch@mellanox.com, kimbrownkd@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, petrm@mellanox.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, wanghai26@huawei.com,
        yuehaibing@huawei.com
References: <000000000000f86a4f0595fdb152@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f1a79e81-b41f-ba48-9bf3-aeae708f73ba@kernel.dk>
Date:   Mon, 28 Oct 2019 15:00:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <000000000000f86a4f0595fdb152@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/19 1:42 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    139c2d13 Add linux-next specific files for 20191025
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=137a3e97600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=28fd7a693df38d29
> dashboard link: https://syzkaller.appspot.com/bug?extid=0f1cc17f85154f400465
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15415bdf600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101fa6e4e00000
> 
> The bug was bisected to:
> 
> commit 3f982fff29b4ad339b36e9cf43422d1039f9917a
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Oct 24 17:35:03 2019 +0000
> 
>       Merge branch 'for-5.5/drivers' into for-next
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17f7e44ce00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=140fe44ce00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=100fe44ce00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0f1cc17f85154f400465@syzkaller.appspotmail.com
> Fixes: 3f982fff29b4 ("Merge branch 'for-5.5/drivers' into for-next")
> 
> INFO: task syz-executor696:18072 blocked for more than 143 seconds.
>         Not tainted 5.4.0-rc4-next-20191025 #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> syz-executor696 D28160 18072   9609 0x00004004
> Call Trace:
>    context_switch kernel/sched/core.c:3385 [inline]
>    __schedule+0x94a/0x1e70 kernel/sched/core.c:4070
>    schedule+0xdc/0x2b0 kernel/sched/core.c:4144
>    schedule_timeout+0x717/0xc50 kernel/time/timer.c:1871
>    do_wait_for_common kernel/sched/completion.c:83 [inline]
>    __wait_for_common kernel/sched/completion.c:104 [inline]
>    wait_for_common kernel/sched/completion.c:115 [inline]
>    wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
>    io_wq_destroy+0x247/0x470 fs/io-wq.c:784
>    io_finish_async+0x102/0x180 fs/io_uring.c:2890
>    io_ring_ctx_free fs/io_uring.c:3615 [inline]
>    io_ring_ctx_wait_and_kill+0x249/0x710 fs/io_uring.c:3683
>    io_uring_release+0x42/0x50 fs/io_uring.c:3691
>    __fput+0x2ff/0x890 fs/file_table.c:280
>    ____fput+0x16/0x20 fs/file_table.c:313
>    task_work_run+0x145/0x1c0 kernel/task_work.c:113
>    tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>    exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>    prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>    syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>    do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4019d0
> Code: 01 f0 ff ff 0f 83 20 0c 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
> 44 00 00 83 3d fd 2c 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 f4 0b 00 00 c3 48 83 ec 08 e8 5a 01 00 00
> RSP: 002b:00007ffdcb9bf4b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00000000004019d0
> RDX: 0000000000401970 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000670
> R13: 0000000000402ae0 R14: 0000000000000000 R15: 0000000000000000
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/1078:
>    #0: ffffffff88faba80 (rcu_read_lock){....}, at:
> debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5336
> 1 lock held by rsyslogd/9148:
>    #0: ffff888099aa8660 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110
> fs/file.c:801
> 2 locks held by getty/9238:
>    #0: ffff88809a77f090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f472e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9239:
>    #0: ffff8880a7bc7090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f4f2e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9240:
>    #0: ffff8880a83e7090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f3d2e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9241:
>    #0: ffff88808e706090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f292e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9242:
>    #0: ffff8880a7b75090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f312e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9243:
>    #0: ffff8880a130f090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f532e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 2 locks held by getty/9244:
>    #0: ffff88809b09e090 (&tty->ldisc_sem){++++}, at:
> ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
>    #1: ffffc90005f212e0 (&ldata->atomic_read_lock){+.+.}, at:
> n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> 
> =============================================
> 
> NMI backtrace for cpu 0
> CPU: 0 PID: 1078 Comm: khungtaskd Not tainted 5.4.0-rc4-next-20191025 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>    __dump_stack lib/dump_stack.c:77 [inline]
>    dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>    nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
>    nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
>    arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
>    trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>    check_hung_uninterruptible_tasks kernel/hung_task.c:269 [inline]
>    watchdog+0xc8f/0x1350 kernel/hung_task.c:353
>    kthread+0x361/0x430 kernel/kthread.c:255
>    ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10
> arch/x86/include/asm/irqflags.h:60

This is fixed in my for-next branch for a few days at least, unfortunately
linux-next is still on the old one. Next version should be better.

-- 
Jens Axboe

