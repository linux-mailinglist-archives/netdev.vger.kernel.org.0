Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8038969B14
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbfGOS7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:59:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36276 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729237AbfGOS7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:59:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so8158928pgm.3;
        Mon, 15 Jul 2019 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wV1tVFXp4Dk7551aJryL+rhxiRYGF53mCFjrqi8D++Y=;
        b=h2SLQDT1wFXz44rIFDfbQvFcKkb4upCgqv88sm6e+FnD+DDZF+/OmKp/KKlbKRnoBB
         tNINZSJ3lnHjJ/iYRfuG5zpbA0mH8n0Bm3gMy5l1tf3b39D72eSRxE1L64MG8RDvm755
         r5KvK26ryaMG7xIn1+VcaKrs9WO4+f8u1Wp/3gh1i++zJU22dTmNMvFAbJPbqfNu6Efg
         /V1KXp4qqsTGjA+ErnOlluMnKPqaLHDXo11qDieYPBq+A6xALgrQWFt5ZPW30CrCbHet
         KVDCcWjcDbVPtbQCpyROdGbyiFuMrW2vfyA29Mj2Wi78PyBjNcmod7mDFsLCQa6CK15W
         6/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wV1tVFXp4Dk7551aJryL+rhxiRYGF53mCFjrqi8D++Y=;
        b=dOpmxaew8Wmg3/jPWTPjsRtc596DI7xVIaE4l8Chy1ibiAyo5a7Lt0+Oix9wqQJ+zI
         ieUhrFRNHaVB1rf5UtZIJwwLWtBjqcfWXOjm0TCjU86CM6GFadMwPxM2enKe78OeCYy+
         IjkIkn1k2fF2w/CZKaMDnrar3gF2vGW+4VVayNDA5eGKt1yk/lhfPqXYE7oYDT6Wh0AW
         QuzteNZb0vprX9WHVIFkgliqYvotHc/gjDEyCPO10Z1UyGiwn3p4r0qlYW9vCsYRa6Ju
         pcIn8+hPUm5Wlg7ep6Dz2yZl6puFEfD/qmvM6UIRdTDcIM3JI54/p6lZF7Y7dixEgVer
         6WBQ==
X-Gm-Message-State: APjAAAVrb0R+6ZuijCXAAbx0ysGqhz3X3rDaBMEb+DmhJkJvM1KIQdlM
        1L5lc9zCEyizlPQqEHekZWEQYMUsCfWSibu9fgpIrDA+ReA=
X-Google-Smtp-Source: APXvYqwxVRz+kIkvMG7J0OELs3hTazVOrhRz8J56PbkcZ0aYpvLx67RGZ4nyusTrPkF6M3cYuWdNCgYXvO+MkimFsRk=
X-Received: by 2002:a63:8a43:: with SMTP id y64mr28271790pgd.104.1563217149340;
 Mon, 15 Jul 2019 11:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d018ea058d9c46e3@google.com> <be6c249e-3b99-8388-5b13-547645b2fac9@hartkopp.net>
In-Reply-To: <be6c249e-3b99-8388-5b13-547645b2fac9@hartkopp.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 15 Jul 2019 11:58:57 -0700
Message-ID: <CAM_iQpXDDyXPn8C6Z1R-GdcarFpiRd3-S_E6GQrEaVdvjFfxeA@mail.gmail.com>
Subject: Re: INFO: task hung in unregister_netdevice_notifier (3)
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 10:23 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
> Hello all,
>
> On 14.07.19 06:07, syzbot wrote:
> > syzbot has found a reproducer for the following crash on:
>
> the internal users of the CAN networking subsystem like CAN_BCM and
> CAN_RAW hold a number of CAN identifier subscriptions ('filters') for
> CAN netdevices (only type ARPHRD_CAN) in their socket data structures.
>
> The per-socket netdevice notifier is used to manage the ad-hoc removal
> of these filters at netdevice removal time.
>
> What I can see in the console output at
>
> https://syzkaller.appspot.com/x/log.txt?x=10e45f0fa00000
>
> seems to be a race between an unknown register_netdevice_notifier() call
> ("A") and the unregister_netdevice_notifier() ("B") likely invoked by
> bcm_release() ("C"):
>
> [ 1047.294207][ T1049]  schedule+0xa8/0x270
> [ 1047.318401][ T1049]  rwsem_down_write_slowpath+0x70a/0xf70
> [ 1047.324114][ T1049]  ? downgrade_write+0x3c0/0x3c0
> [ 1047.438644][ T1049]  ? mark_held_locks+0xf0/0xf0
> [ 1047.443483][ T1049]  ? lock_acquire+0x190/0x410
> [ 1047.448191][ T1049]  ? unregister_netdevice_notifier+0x7e/0x390
> [ 1047.547227][ T1049]  down_write+0x13c/0x150
> [ 1047.579535][ T1049]  ? down_write+0x13c/0x150
> [ 1047.584106][ T1049]  ? __down_timeout+0x2d0/0x2d0
> [ 1047.635356][ T1049]  ? mark_held_locks+0xf0/0xf0
> [ 1047.640721][ T1049]  unregister_netdevice_notifier+0x7e/0x390  <- "B"
> [ 1047.646667][ T1049]  ? __sock_release+0x89/0x280
> [ 1047.709126][ T1049]  ? register_netdevice_notifier+0x630/0x630 <- "A"
> [ 1047.715203][ T1049]  ? __kasan_check_write+0x14/0x20
> [ 1047.775138][ T1049]  bcm_release+0x93/0x5e0                    <- "C"
> [ 1047.795337][ T1049]  __sock_release+0xce/0x280
> [ 1047.829016][ T1049]  sock_close+0x1e/0x30
>
> The question to me is now:
>
> Is the problem located in an (un)register_netdevice_notifier race OR is
> it generally a bad idea to call unregister_netdevice_notifier() in a
> sock release?

To me it doesn't look like anything wrong in CAN. If you look at a few
more reports from syzbot for the same bug, it actually indicates
something else is holding the pernet_ops_rwsem which caused this
hung task.

When NMI is kicked, it shows nf_ct_iterate_cleanup() was getting
stuck:


NMI backtrace for cpu 0
CPU: 0 PID: 1044 Comm: khungtaskd Not tainted 5.2.0-rc5+ #42
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
 arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0x9b7/0xec0 kernel/hung_task.c:289
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6877 Comm: kworker/u4:1 Not tainted 5.2.0-rc5+ #42
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x50 kernel/kcov.c:95
Code: 89 25 e4 bc 15 09 41 bc f4 ff ff ff e8 6d 04 ea ff 48 c7 05 ce
bc 15 09 00 00 00 00 e9 a4 e9 ff ff 90 90 90 90 90 90 90 90 90 <55> 48
89 e5 48 8b 75 08 65 48 8b 04 25 c0 fd 01 00 65 8b 15 f0 3a
RSP: 0018:ffff888088fe7ac0 EFLAGS: 00000046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff817637c6
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: ffff888088fe7af8 R08: ffff888096406340 R09: fffffbfff118bda9
R10: fffffbfff118bda8 R11: ffffffff88c5ed43 R12: ffffffff85b86d11
R13: ffff888096406340 R14: 0000000000000001 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000099e59000 CR4: 00000000001406e0
Call Trace:
 __local_bh_enable_ip+0x11a/0x270 kernel/softirq.c:171
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 get_next_corpse net/netfilter/nf_conntrack_core.c:2015 [inline]
 nf_ct_iterate_cleanup+0x217/0x4e0 net/netfilter/nf_conntrack_core.c:2038
 nf_conntrack_cleanup_net_list+0x7a/0x240 net/netfilter/nf_conntrack_core.c:2225
 nf_conntrack_pernet_exit+0x159/0x1a0
net/netfilter/nf_conntrack_standalone.c:1151
 ops_exit_list.isra.0+0xfc/0x150 net/core/net_namespace.c:168
 cleanup_net+0x4e2/0xa40 net/core/net_namespace.c:575
 process_one_work+0x989/0x1790 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
