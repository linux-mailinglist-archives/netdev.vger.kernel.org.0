Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4616E9B2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgBYPMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:12:21 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:39502 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730813AbgBYPMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:12:21 -0500
Received: by mail-qv1-f68.google.com with SMTP id y8so5832079qvk.6
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 07:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wU9p9MPXNeIkwgBrSPZEEZj2oNyPMSFuq/Tht05gaPU=;
        b=j5AkE2xtQ17H2R6MPojFpZZtqmZIQa2CJiEW4UQA/47+VIxjrmBUtO50yCZT+OGHw+
         1JfRAkyUsZNS4d+ZWjWIoaRrt8WIkVx4Kyj5YifyIE5Nt1FXsjY12DzaZS9S/Z5PkwWG
         U6TyldnJMg87Pj0UH5wQGRolRR6HiK7KTrcnKAQ/qGqdo3he2mGUljGab8WLAvNrRGaT
         8EuBLQnemyFed5a7QqCk40VsdKSIevXQ6CberyOEgx87RdxjbHtDTYkgr7v4r8zWsi7q
         bG+iOh+jHrWI4OqGsLRveYdixVdepSDgWY279fHReU8gHA1+ZNJ3ToLc3tPM8m6avw64
         r3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wU9p9MPXNeIkwgBrSPZEEZj2oNyPMSFuq/Tht05gaPU=;
        b=WVbl1SknnzadcGtDiC28fHNQR9N41gV8gPu53vfguC2zX8/fr984AcpZs7KfqiZc4p
         HMFVycHxI2u5xEhA6tTFtCDws7GYwFS44WmK0TQzBaH2p64wST1mq1UaXoS3DhElN4+F
         nUPzUfTrq3c/7SBo8aoYKVYk12FWLCR7vJE9mFQ1gkrugBCkFnSALO1d8Cn/8QkL27x4
         h/sSukxhFuk73lRa/FxOl2qKYGYwrQDOUFkDLb5RiLhu0e7uBXJfcYhqiDzo4SVN6DRu
         Bhj0Ue00zYzmIUVCNpZ4YOPMC0Yd84/A9GopkofVW2I1MAevUcYOn5qn2ehsCjVMItMy
         Xnmw==
X-Gm-Message-State: APjAAAUdS6I+Y0nE90Fyxl+BS9AYiTjZZojlqQrHY/EBEmIaWHCWnJ5s
        iR6B001gy1hqfKA64DV2RdwcKmXhqunewk9QcA7IDw==
X-Google-Smtp-Source: APXvYqwJbR7p7RTF+9sG2rFoHFYbbw0fE4nNPEEYBmE36C/dIVavXoYqMMpmMMENMNch9K3svEaXhiQQ1ZmpmrtjAE8=
X-Received: by 2002:ad4:4e50:: with SMTP id eb16mr50758445qvb.34.1582643539498;
 Tue, 25 Feb 2020 07:12:19 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a719a9059f62246e@google.com> <CAHC9VhTh6s1m7YBZp-3XO3q2EcjtMKUTcXwRzDTj_LSJd+cHTA@mail.gmail.com>
 <CACT4Y+Y3QN9=c5JvJkecCtdQGTxHYRXMhS4f1itwU5JEZmcYtA@mail.gmail.com>
 <db643ed6efb6fa04fe5753af68d13f1b2ffcf821.camel@redhat.com> <CACT4Y+a6Lp=YGYrxDubwrXiMKc5R5WhehR+Q5E1jEu452d0tfA@mail.gmail.com>
In-Reply-To: <CACT4Y+a6Lp=YGYrxDubwrXiMKc5R5WhehR+Q5E1jEu452d0tfA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 25 Feb 2020 16:12:08 +0100
Message-ID: <CACT4Y+aWC1Cffa-ywb0SOeCgUWddR=e4m8HizSR3ezzSr=iKag@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in cipso_v4_sock_setattr
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        syzbot <syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com>,
        cpaasch@apple.com, David Miller <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        matthieu.baerts@tessares.net, netdev <netdev@vger.kernel.org>,
        peter.krystad@linux.intel.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 4:09 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following crash on:
> > > > >
> > > > > HEAD commit:    ca7e1fd1 Merge tag 'linux-kselftest-5.6-rc3' of git://git...
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=179f0931e00000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=a61f2164c515c07f
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=f4dfece964792d80b139
> > > > > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fdfdede00000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17667de9e00000
> > > > >
> > > > > The bug was bisected to:
> > > > >
> > > > > commit 2303f994b3e187091fd08148066688b08f837efc
> > > > > Author: Peter Krystad <peter.krystad@linux.intel.com>
> > > > > Date:   Wed Jan 22 00:56:17 2020 +0000
> > > > >
> > > > >     mptcp: Associate MPTCP context with TCP socket
> > > > >
> > > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14fbec81e00000
> > > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=16fbec81e00000
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=12fbec81e00000
> > > > >
> > > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > > Reported-by: syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com
> > > > > Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> > > > >
> > > > > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > > > #PF: supervisor instruction fetch in kernel mode
> > > > > #PF: error_code(0x0010) - not-present page
> > > > > PGD 8e171067 P4D 8e171067 PUD 93fa2067 PMD 0
> > > > > Oops: 0010 [#1] PREEMPT SMP KASAN
> > > > > CPU: 0 PID: 8984 Comm: syz-executor066 Not tainted 5.6.0-rc2-syzkaller #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > > RIP: 0010:0x0
> > > > > Code: Bad RIP value.
> > > > > RSP: 0018:ffffc900020b7b80 EFLAGS: 00010246
> > > > > RAX: 1ffff110124ba600 RBX: 0000000000000000 RCX: ffff88809fefa600
> > > > > RDX: ffff8880994cdb18 RSI: 0000000000000000 RDI: ffff8880925d3140
> > > > > RBP: ffffc900020b7bd8 R08: ffffffff870225be R09: fffffbfff140652a
> > > > > R10: fffffbfff140652a R11: 0000000000000000 R12: ffff8880925d35d0
> > > > > R13: ffff8880925d3140 R14: dffffc0000000000 R15: 1ffff110124ba6ba
> > > > > FS:  0000000001a0b880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > CR2: ffffffffffffffd6 CR3: 00000000a6d6f000 CR4: 00000000001406f0
> > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > Call Trace:
> > > > >  cipso_v4_sock_setattr+0x34b/0x470 net/ipv4/cipso_ipv4.c:1888
> > > > >  netlbl_sock_setattr+0x2a7/0x310 net/netlabel/netlabel_kapi.c:989
> > > > >  smack_netlabel security/smack/smack_lsm.c:2425 [inline]
> > > > >  smack_inode_setsecurity+0x3da/0x4a0 security/smack/smack_lsm.c:2716
> > > > >  security_inode_setsecurity+0xb2/0x140 security/security.c:1364
> > > > >  __vfs_setxattr_noperm+0x16f/0x3e0 fs/xattr.c:197
> > > > >  vfs_setxattr fs/xattr.c:224 [inline]
> > > > >  setxattr+0x335/0x430 fs/xattr.c:451
> > > > >  __do_sys_fsetxattr fs/xattr.c:506 [inline]
> > > > >  __se_sys_fsetxattr+0x130/0x1b0 fs/xattr.c:495
> > > > >  __x64_sys_fsetxattr+0xbf/0xd0 fs/xattr.c:495
> > > > >  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
> > > > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > >
> > > > Netdev folks, I'm not very familiar with the multipath TCP code so I
> > > > was wondering if you might help me out a bit with this report.  Based
> > > > on the stack trace above it looks like for a given AF_INET sock "sk",
> > > > inet_sk(sk)->is_icsk is true but inet_csk(sk) is NULL; should this be
> > > > possible under normal conditions or is there an issue somewhere?
> > >
> > > Paolo has submitted some patch for testing for this bug, not sure if
> > > you have seen it, just in case:
> > > https://groups.google.com/forum/#!msg/syzkaller-bugs/dqwnTBh-MQw/LhgSZYGsBgAJ
> >
> > I sent the patch to the syzbot ML only, for testing before posting on
> > netdev, so Paul likely have not seen it yet, sorry.
> >
> > @Dmitry: I did not get any reply yet from syzbot, are there any
> > problems or is this the usual time-frame?
>
> The testing is queued after bisection of this guy:
> https://syzkaller.appspot.com/bug?id=c0a75a31c5fa84e6e5d3131fd98a5b56e2141b9a
> which has been running since 6pm yesterday...


It's stuck in this boot-broken region. And git bisect degrades to
linear behavior on skipped commits (why?).
If only kernel would have proper presubmit testing to avoid at least
boot breakages... :)


[    6.784292][   T24] kasan: GPF could be caused by NULL-ptr deref or
user memory access
[    6.787429][   T24] general protection fault: 0000 [#1] PREEMPT SMP KASAN
[    6.789312][   T24] CPU: 1 PID: 24 Comm: kworker/u4:2 Not tainted
5.3.0-rc1-syzkaller #0
[    6.791623][   T24] Hardware name: Google Google Compute
Engine/Google Compute Engine, BIOS Google 01/01/2011
[    6.791623][   T24] Workqueue: events_unbound async_run_entry_fn
[    6.795328][   T24] RIP: 0010:dma_direct_max_mapping_size+0x5d/0x128
[    6.795328][   T24] Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85
c2 00 00 00 4c 8b a3 38 03 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89
e2 48 c1 ea 03 <80> 3c 02 00 0f 85 aa 00 00 00 48 8d bb 48 03 00 00 4d
8b 2c 24 48
[    6.795328][   T24] RSP: 0000:ffff8880a9adf728 EFLAGS: 00010246
[    6.806015][   T24] RAX: dffffc0000000000 RBX: ffff88821962b300
RCX: ffffffff8716d938
[    6.806015][   T24] RDX: 0000000000000000 RSI: 0000000000000040
RDI: ffff88821962b638
[    6.806015][   T24] RBP: ffff8880a9adf740 R08: ffffed101443d28d
R09: ffffed101443d28d
[    6.806015][   T24] R10: ffffed101443d28c R11: ffff8880a21e9467
R12: 0000000000000000
[    6.806015][   T24] R13: ffff88821962b300 R14: ffff8880a28a6a70
R15: 0000000000000200
[    6.818295][   T24] FS:  0000000000000000(0000)
GS:ffff8880ae900000(0000) knlGS:0000000000000000
[    6.818446][   T24] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.818446][   T24] CR2: 0000000000000000 CR3: 0000000008a6d000
CR4: 00000000001406e0
[    6.818446][   T24] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[    6.818446][   T24] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[    6.829410][   T24] Call Trace:
[    6.829410][   T24]  dma_max_mapping_size+0xa2/0xc0
[    6.831705][   T24]  __scsi_init_queue+0x197/0x4f0
[    6.831705][   T24]  scsi_mq_alloc_queue+0xb7/0x150
[    6.831705][   T24]  scsi_alloc_sdev+0x7b7/0xb80
[    6.831705][   T24]  scsi_probe_and_add_lun+0x86a/0x37c0
[    6.831705][   T24]  ? __kasan_check_read+0x11/0x20
[    6.839613][   T24]  ? scsi_alloc_sdev+0xb80/0xb80
[    6.839613][   T24]  ? mark_lock+0xc3/0x1190
[    6.839613][   T24]  ? mark_held_locks+0xb8/0x130
[    6.839613][   T24]  ? _raw_spin_unlock_irqrestore+0x82/0xd0
[    6.839613][   T24]  ? __pm_runtime_resume+0xb4/0x110
[    6.839613][   T24]  ? lockdep_hardirqs_on+0x424/0x5c0
[    6.839613][   T24]  ? _raw_spin_unlock_irqrestore+0x82/0xd0
[    6.839613][   T24]  ? trace_hardirqs_on+0x28/0x1a0
[    6.851380][    T1] slram: not enough parameters.
[    6.839613][   T24]  ? _raw_spin_unlock_irqrestore+0x6d/0xd0
[    6.839613][   T24]  ? __pm_runtime_resume+0xb4/0x110
[    6.839613][   T24]  __scsi_scan_target+0x1fd/0xc90
[    6.839613][   T24]  ? scsi_add_device+0x30/0x30
[    6.839613][   T24]  ? mark_held_locks+0xb8/0x130
[    6.839613][   T24]  ? _raw_spin_unlock_irqrestore+0x82/0xd0
[    6.839613][   T24]  ? __pm_runtime_resume+0xb4/0x110
[    6.839613][   T24]  ? lockdep_hardirqs_on+0x424/0x5c0
[    6.839613][   T24]  ? _raw_spin_unlock_irqrestore+0x82/0xd0
[    6.839613][   T24]  ? trace_hardirqs_on+0x28/0x1a0
[    6.839613][   T24]  scsi_scan_channel.part.8+0xd6/0x140
[    6.857364][    T1] ftl_cs: FTL header not found.
[    6.854615][   T24]  scsi_scan_host_selected+0x20c/0x300
[    6.865470][    T1] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    6.854615][   T24]  ? scsi_scan_host+0x3c0/0x3c0
[    6.854615][   T24]  do_scsi_scan_host+0x1b3/0x250
[    6.854615][   T24]  ? lock_downgrade+0x900/0x900
[    6.854615][   T24]  ? scsi_scan_host+0x3c0/0x3c0
[    6.854615][   T24]  do_scan_async+0x3c/0x450
[    6.854615][   T24]  ? scsi_scan_host+0x3c0/0x3c0
[    6.854615][   T24]  async_run_entry_fn+0xf9/0x4b0
[    6.854615][   T24]  process_one_work+0x856/0x1630
[    6.854615][   T24]  ? pwq_dec_nr_in_flight+0x2c0/0x2c0
[    6.854615][   T24]  ? lock_acquire+0x194/0x410
[    6.854615][   T24]  worker_thread+0x85/0xb60
[    6.854615][   T24]  ? __kthread_parkme+0x47/0x1a0
[    6.854615][   T24]  kthread+0x331/0x3f0
[    6.854615][   T24]  ? process_one_work+0x1630/0x1630
[    6.854615][   T24]  ? kthread_cancel_delayed_work_sync+0x10/0x10
[    6.854615][   T24]  ret_from_fork+0x24/0x30
[    6.854615][   T24] Modules linked in:
[    6.907103][   T24] ---[ end trace 14068796cd600dc6 ]---
[    6.908603][   T24] RIP: 0010:dma_direct_max_mapping_size+0x5d/0x128
[    6.909683][    T1] eql: Equalizer2002: Simon Janes (simon@ncm.com)
and David S. Miller (davem@redhat.com)
[    6.910361][   T24] Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85
c2 00 00 00 4c 8b a3 38 03 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89
e2 48 c1 ea 03 <80> 3c 02 00 0f 85 aa 00 00 00 48 8d bb 48 03 00 00 4d
8b 2c 24 48
[    6.918535][   T24] RSP: 0000:ffff8880a9adf728 EFLAGS: 00010246
[    6.919167][    T1] MACsec IEEE 802.1AE
[    6.920089][   T24] RAX: dffffc0000000000 RBX: ffff88821962b300
RCX: ffffffff8716d938
[    6.921513][    T1] tun: Universal TUN/TAP device driver, 1.6
[    6.923553][   T24] RDX: 0000000000000000 RSI: 0000000000000040
RDI: ffff88821962b638
[    6.932178][   T24] RBP: ffff8880a9adf740 R08: ffffed101443d28d
R09: ffffed101443d28d
[    6.946172][   T24] R10: ffffed101443d28c R11: ffff8880a21e9467
R12: 0000000000000000
[    6.952330][   T24] R13: ffff88821962b300 R14: ffff8880a28a6a70
R15: 0000000000000200
[    6.956636][   T24] FS:  0000000000000000(0000)
GS:ffff8880ae900000(0000) knlGS:0000000000000000
[    6.964469][   T24] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.968832][   T24] CR2: 0000000000000000 CR3: 0000000008a6d000
CR4: 00000000001406e0
[    6.971517][   T24] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[    6.977961][   T24] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[    6.983019][   T24] Kernel panic - not syncing: Fatal exception
[    6.983346][    T1] vcan: Virtual CAN interface driver
[    6.987331][   T24] Kernel Offset: disabled
[    6.988609][   T24] Rebooting in 86400 seconds..
