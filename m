Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6D83315C5
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhCHSUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhCHSUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:20:17 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B934C06174A;
        Mon,  8 Mar 2021 10:20:17 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id v14so9690412ilj.11;
        Mon, 08 Mar 2021 10:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNTQykiI9gA2t58YTI7cpBAyD2RcDTE2cehocQiIsBU=;
        b=Qvdlw4/eGJUQgFcaFQMmB//pgdcE82a6uVoEhi+VW5BG3QPeDbykzxT7ulGFQ2kZOF
         kHS0DESygRuhGIev8l8/pge56Ty4LkL4jLH+AVsbZ1+WanyY0WAiwlgxJ4i+oxOgNT14
         qwNkDI5q96ghhUQUPHaGH3vf/Qxleo6Q/sHucCjMlKPoehB1Rt7PxVTjf4caI6Gxvwh2
         vAlbRhB2tJfBukUHmMCfXE6TypxKI/q6c6S9Lfr0rk/DpgIkbe3BZ/Z+5DyMVkG+kDqY
         OPv9td3Fi65Y2OKfSHoFFlM8FkYbG0z8d3LRiXzztUvyQBBAqbPNjhOzw1yUYiOzBLNX
         5o6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNTQykiI9gA2t58YTI7cpBAyD2RcDTE2cehocQiIsBU=;
        b=EbgR2aAfufJBl4ovkw0VInCCaRHP+6zT2R+PBxrTYW5DTWVRq2vB7moyAJXbcj616b
         M2TZQHzKGkYhQGQrAFIcxhBORxnfGkoEcvWabtGM1HVYTEJOs/nyLQWR2B4Dlppou+4T
         moieldNwThZ59JZ1GBQHFTWIAV/SXuO3Nd+G5ISiYR6tDZvHXZIgQQxEtXgfo+XRA/7T
         Z/4EwK5gCsANRj7PfI3qCDsrUUq4kn5SLNT9mRLdGXYeVbxDkm0LAAk6Txl5ZTcroNJG
         e5HyH49LFLhQ/jRHF+1160XW8V6WeRtK75JONwbvldP5tQ9fCpCDWGiKXCSrgp23Trkd
         u/1A==
X-Gm-Message-State: AOAM5316KSMy+yTs0TG6EEhiFzswYe19b7TINkuZVZvJYjy9GGcFFEjw
        dnfS9p8g40I7bOJE2lBLykbbOjKc5Nn+3O11SN21kiVHP+jUpQ==
X-Google-Smtp-Source: ABdhPJy89frhoCx9bvGw9K5vGvSrxgh7FXPcmlVGtNQlAXPd5imSMyLiL6waukggKHiZKTTahiR0/ynRBDGNav9hDKI=
X-Received: by 2002:a05:6e02:ef4:: with SMTP id j20mr19420597ilk.199.1615227616365;
 Mon, 08 Mar 2021 10:20:16 -0800 (PST)
MIME-Version: 1.0
References: <20210308032529.435224-1-ztong0001@gmail.com> <CAKgT0UftdTobwgA6hi=CdOfQ+1fdozhPs89fDmapbvcp7jLASw@mail.gmail.com>
 <CAA5qM4BG2PNvvLFDngQRe4kBL5zATUOnaHt_-2s7Y47CcJF+bA@mail.gmail.com> <CAKgT0UeqMEiv9vvsRE+3Wb0e9-f8E_n3QWEHGmu32bza_W5=Sw@mail.gmail.com>
In-Reply-To: <CAKgT0UeqMEiv9vvsRE+3Wb0e9-f8E_n3QWEHGmu32bza_W5=Sw@mail.gmail.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Mon, 8 Mar 2021 13:20:05 -0500
Message-ID: <CAA5qM4Cp6LxgfF+3pgFoRO25QGtjDiEF5LyLtJEqYLXKm-W0jQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] fix a couple of atm->phy_data related issues
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have this emulated device in QEMU,
-- and I agree with you that probably no one has been using it for a while
IMHO, given the quality of the driver it also make sense to drop the
support completely
or we at least need to fix some obvious issues here.
Best,
- Tong

On Mon, Mar 8, 2021 at 1:06 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> Hi Tong,
>
> Is this direct-assigned hardware or is QEMU being used to emulate the
> hardware here? Admittedly I don't know that much about ATM, so I am
> not sure when/if those phys would have gone out of production. However
> since the code dates back to 2005 I am guessing it is on the old side.
>
> Ultimately the decision is up to Chas. However if there has been code
> in place for this long that would trigger this kind of null pointer
> dereference then it kind of points to the fact that those phys have
> probably not been in use since at least back when Linus switched over
> to git in 2005.
>
> Thanks,
>
> - Alex
>
> On Mon, Mar 8, 2021 at 9:55 AM Tong Zhang <ztong0001@gmail.com> wrote:
> >
> > Hi Alex,
> > attached is the kernel log for zatm(uPD98402) -- I also have
> > idt77252's log -- which is similar to this one --
> > I think it makes sense to drop if no one is actually using it --
> > - Tong
> >
> > [    5.740774] BUG: KASAN: null-ptr-deref in uPD98402_start+0x5e/0x219
> > [uPD98402]
> > [    5.741179] Write of size 4 at addr 000000000000002c by task modprobe/96
> > [    5.741548]
> > [    5.741637] CPU: 0 PID: 96 Comm: modprobe Not tainted 5.12.0-rc2-dirty #71
> > [    5.742017] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> > BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> > [    5.742635] Call Trace:
> > [    5.742775]  dump_stack+0x8a/0xb5
> > [    5.742966]  kasan_report.cold+0x10f/0x111
> > [    5.743197]  ? uPD98402_start+0x5e/0x219 [uPD98402]
> > [    5.743473]  uPD98402_start+0x5e/0x219 [uPD98402]
> > [    5.743739]  zatm_init_one+0x10b5/0x1311 [zatm]
> > [    5.743998]  ? zatm_int.cold+0x30/0x30 [zatm]
> > [    5.744246]  ? _raw_write_lock_irqsave+0xd0/0xd0
> > [    5.744507]  ? __mutex_lock_slowpath+0x10/0x10
> > [    5.744757]  ? _raw_spin_unlock_irqrestore+0xd/0x20
> > [    5.745030]  ? zatm_int.cold+0x30/0x30 [zatm]
> > [    5.745278]  local_pci_probe+0x6f/0xb0
> > [    5.745492]  pci_device_probe+0x171/0x240
> > [    5.745718]  ? pci_device_remove+0xe0/0xe0
> > [    5.745949]  ? kernfs_create_link+0xb6/0x110
> > [    5.746190]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
> > [    5.746482]  really_probe+0x161/0x420
> > [    5.746691]  driver_probe_device+0x6d/0xd0
> > [    5.746923]  device_driver_attach+0x82/0x90
> > [    5.747158]  ? device_driver_attach+0x90/0x90
> > [    5.747402]  __driver_attach+0x60/0x100
> > [    5.747621]  ? device_driver_attach+0x90/0x90
> > [    5.747864]  bus_for_each_dev+0xe1/0x140
> > [    5.748075]  ? subsys_dev_iter_exit+0x10/0x10
> > [    5.748320]  ? klist_node_init+0x61/0x80
> > [    5.748542]  bus_add_driver+0x254/0x2a0
> > [    5.748760]  driver_register+0xd3/0x150
> > [    5.748977]  ? 0xffffffffc0030000
> > [    5.749163]  do_one_initcall+0x84/0x250
> > [    5.749380]  ? trace_event_raw_event_initcall_finish+0x150/0x150
> > [    5.749714]  ? _raw_spin_unlock_irqrestore+0xd/0x20
> > [    5.749987]  ? create_object+0x395/0x510
> > [    5.750210]  ? kasan_unpoison+0x21/0x50
> > [    5.750427]  do_init_module+0xf8/0x350
> > [    5.750640]  load_module+0x40c5/0x4410
> > [    5.750854]  ? module_frob_arch_sections+0x20/0x20
> > [    5.751123]  ? kernel_read_file+0x1cd/0x3e0
> > [    5.751364]  ? __do_sys_finit_module+0x108/0x170
> > [    5.751628]  __do_sys_finit_module+0x108/0x170
> > [    5.751879]  ? __ia32_sys_init_module+0x40/0x40
> > [    5.752126]  ? file_open_root+0x200/0x200
> > [    5.752353]  ? do_sys_open+0x85/0xe0
> > [    5.752556]  ? filp_open+0x50/0x50
> > [    5.752750]  ? fpregs_assert_state_consistent+0x4d/0x60
> > [    5.753042]  ? exit_to_user_mode_prepare+0x2f/0x130
> > [    5.753316]  do_syscall_64+0x33/0x40
> > [    5.753519]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [    5.753802] RIP: 0033:0x7ff64032dcf7
> >  ff c3 48 c7 c6 01 00 00 00 e9 a1
> > [    5.755029] RSP: 002b:00007ffd250ea358 EFLAGS: 00000246 ORIG_RAX:
> > 0000000000000139
> > [    5.755449] RAX: ffffffffffffffda RBX: 0000000001093a70 RCX: 00007ff64032dcf7
> > [    5.755847] RDX: 0000000000000000 RSI: 00000000010929e0 RDI: 0000000000000003
> > [    5.756242] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
> > [    5.756635] R10: 00007ff640391300 R11: 0000000000000246 R12: 00000000010929e0
> > [    5.757029] R13: 0000000000000000 R14: 0000000001092dd0 R15: 0000000000000001
> >
> > On Mon, Mar 8, 2021 at 12:47 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Mon, Mar 8, 2021 at 12:39 AM Tong Zhang <ztong0001@gmail.com> wrote:
> > > >
> > > > there are two drivers(zatm and idt77252) using PRIV() (i.e. atm->phy_data)
> > > > to store private data, but the driver happens to populate wrong
> > > > pointers: atm->dev_data. which actually cause null-ptr-dereference in
> > > > following PRIV(dev). This patch series attemps to fix those two issues
> > > > along with a typo in atm struct.
> > > >
> > > > Tong Zhang (3):
> > > >   atm: fix a typo in the struct description
> > > >   atm: uPD98402: fix incorrect allocation
> > > >   atm: idt77252: fix null-ptr-dereference
> > > >
> > > >  drivers/atm/idt77105.c | 4 ++--
> > > >  drivers/atm/uPD98402.c | 2 +-
> > > >  include/linux/atmdev.h | 2 +-
> > > >  3 files changed, 4 insertions(+), 4 deletions(-)
> > >
> > > For the 2 phys you actually seen null pointer dereferences or are your
> > > changes based on just code review?
> > >
> > > I ask because it seems like this code has been this way since 2005 and
> > > in the case of uPD98402_start the code doesn't seem like it should
> > > function the way it was as PRIV is phy_data and there being issues
> > > seems pretty obvious since the initialization of things happens
> > > immediately after the allocation.
> > >
> > > I'm just wondering if it might make more sense to drop the code if it
> > > hasn't been run in 15+ years rather than updating it?
