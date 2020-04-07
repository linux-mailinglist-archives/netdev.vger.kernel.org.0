Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BB51A0A8D
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgDGJ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:56:45 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45573 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbgDGJ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:56:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id o18so960797qko.12
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wOvU8XbPeciAVuMkk94uCPCE8fOwB8s2h2DZgFPF+lI=;
        b=tt81uMJuBtlesP98X1T0RIiaiUiPYLoOuerlBYu9yxMWEFu9A0CTSdBwhQzhWRNVjL
         9hFiYtVL60xs1vfkP+hmJ/5DrRrf65DKUypMVi6WCyAtHJRAF0mgHufnw4RMGY0bvqve
         4+W6UiFxZlXtN709TsERNrr8+XbICXrUQXFBDLUGAUeq8Nn1bVx2MczRJ6rmRdrzor2A
         iqQByCNIZwkfuW0zTxcOJFgksMyoSM2m0p2XpdGCxLNOw/WIAYlDwzbVvYYNv7jBHA6W
         4Pg2QcDxFQ1wZc4ozCXWJ0TwN5NIkviK5VW/pDSoM9Ew8dAnKkM0eR6X4ZLxhQ21Wgc/
         0DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wOvU8XbPeciAVuMkk94uCPCE8fOwB8s2h2DZgFPF+lI=;
        b=O5ZsYBQkDzIYCLJt9dLlg1eTBzWjdraUvXCazVSfAEd27t0pC2xMjyiMcpwaNL0t0C
         ZKbqGbq0UNsEvkY6ZIN/hqJCbubPWNoYskOr4iH7wbWo92IY9g6awXCqXXZnbXe3IxDQ
         OMyFxytF5N59hRNI/wJL4kxAUM3YL/dYDPAr+5H0+uMtxWodeX0p/p9g8OnfevRByvyY
         V+B8z/cwS6RC7wI8ZUVfySaO+zx7rVUn9erkCJtCyawCMLwDAtl110EVt6KOx1/e8D7B
         k7tlLWHRnJLV+r5wKr4xBOv9hQQa8ZpxiYaImOmwH/kR0e3a38CBZg3NLkhr0+5UXbH/
         eKpg==
X-Gm-Message-State: AGi0PuZoL8exn+PlVb+FvA/1tdwXwBupiajISr4yOpBcoAQksfBPj3d1
        PcKHKE0Ra6C5emMpW64LFIdjDKJr8pmOEjMEQqvcLA==
X-Google-Smtp-Source: APiQypIrHCaGuQCjUmPSy0FTruafk+m/gHJzlMFr46V09puGrz9Tz+8jGD/WYBJ0gcI+UjmSNKBFWp8/vldVa9o5GXQ=
X-Received: by 2002:a37:8d86:: with SMTP id p128mr1330952qkd.250.1586253403265;
 Tue, 07 Apr 2020 02:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075245205a2997f68@google.com> <20200406172151.GJ80989@unreal>
 <20200406174440.GR20941@ziepe.ca>
In-Reply-To: <20200406174440.GR20941@ziepe.ca>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 7 Apr 2020 11:56:30 +0200
Message-ID: <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
Subject: Re: WARNING in ib_umad_kill_port
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 7:44 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Mon, Apr 06, 2020 at 08:21:51PM +0300, Leon Romanovsky wrote:
> > + RDMA
> >
> > On Sun, Apr 05, 2020 at 11:37:15PM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    304e0242 net_sched: add a temporary refcnt for struct tcin..
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=119dd16de00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=9627a92b1f9262d5d30c
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com
> > >
> > > sysfs group 'power' not found for kobject 'umad1'
> > > WARNING: CPU: 1 PID: 31308 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
> > > WARNING: CPU: 1 PID: 31308 at fs/sysfs/group.c:279 sysfs_remove_group+0x155/0x1b0 fs/sysfs/group.c:270
> > > Kernel panic - not syncing: panic_on_warn set ...
> > > CPU: 1 PID: 31308 Comm: kworker/u4:10 Not tainted 5.6.0-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Workqueue: events_unbound ib_unregister_work
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> > >  panic+0x2e3/0x75c kernel/panic.c:221
> > >  __warn.cold+0x2f/0x35 kernel/panic.c:582
> > >  report_bug+0x27b/0x2f0 lib/bug.c:195
> > >  fixup_bug arch/x86/kernel/traps.c:175 [inline]
> > >  fixup_bug arch/x86/kernel/traps.c:170 [inline]
> > >  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
> > >  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
> > >  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> > > RIP: 0010:sysfs_remove_group fs/sysfs/group.c:279 [inline]
> > > RIP: 0010:sysfs_remove_group+0x155/0x1b0 fs/sysfs/group.c:270
> > > Code: 48 89 d9 49 8b 14 24 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 01 00 75 41 48 8b 33 48 c7 c7 60 c3 39 88 e8 93 c3 5f ff <0f> 0b eb 95 e8 22 62 cb ff e9 d2 fe ff ff 48 89 df e8 15 62 cb ff
> > > RSP: 0018:ffffc90001d97a60 EFLAGS: 00010282
> > > RAX: 0000000000000000 RBX: ffffffff88915620 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: ffffffff815ca861 RDI: fffff520003b2f3e
> > > RBP: 0000000000000000 R08: ffff8880a78fc2c0 R09: ffffed1015ce66a1
> > > R10: ffffed1015ce66a0 R11: ffff8880ae733507 R12: ffff88808e5ba070
> > > R13: ffffffff88915bc0 R14: ffff88808e5ba008 R15: dffffc0000000000
> > >  dpm_sysfs_remove+0x97/0xb0 drivers/base/power/sysfs.c:794
> > >  device_del+0x18b/0xd30 drivers/base/core.c:2687
> > >  cdev_device_del+0x15/0x80 fs/char_dev.c:570
> > >  ib_umad_kill_port+0x45/0x250 drivers/infiniband/core/user_mad.c:1327
> > >  ib_umad_remove_one+0x18a/0x220 drivers/infiniband/core/user_mad.c:1409
> > >  remove_client_context+0xbe/0x110 drivers/infiniband/core/device.c:724
> > >  disable_device+0x13b/0x230 drivers/infiniband/core/device.c:1270
> > >  __ib_unregister_device+0x91/0x180 drivers/infiniband/core/device.c:1437
> > >  ib_unregister_work+0x15/0x30 drivers/infiniband/core/device.c:1547
> > >  process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
> > >  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
> > >  kthread+0x388/0x470 kernel/kthread.c:268
> > >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > > Kernel Offset: disabled
> > > Rebooting in 86400 seconds..
>
> I'm not sure what could be done wrong here to elicit this:
>
>  sysfs group 'power' not found for kobject 'umad1'
>
> ??
>
> I've seen another similar sysfs related trigger that we couldn't
> figure out.
>
> Hard to investigate without a reproducer.
>
> Jason


Based on all of the sysfs-related bugs I've seen, my bet would be on
some races. E.g. one thread registers devices, while another
unregisters these.
