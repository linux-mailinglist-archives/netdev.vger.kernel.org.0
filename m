Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F221730636E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhA0SgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbhA0SgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:36:18 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE285C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:35:37 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id z22so2158533qto.7
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 10:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44jOD3nZVoOvFATWCEVSb6OwVXBmxVqEX3xVTS4M3cs=;
        b=XYj+X1ygiZcbLbGvnTnY1ARwHD44UNiFvk2lMHAxxIA67HguuPqfK/eD02vSMCH9xs
         AmctZ+p+P5Qdry+s8/CuJ40CWYWfjSPlpKliOOlKImKbIk/ItQmgth6IupeQlo7PKAb+
         n5rY+A1fWXelbYDVPdoC/0da5i7Hkh8vIUhhwvnFNwC647xQ9XLmg8Wvwhpm3r0PRCRZ
         70n35NMzqd6SqavpEwxPU/zNsV8mE8L3ppPa9KIgF1tWlVOrg6P5x1xZN+NhBzgcXLcr
         tQGd7Mfaruqjl2qMjuAdq4QT+ZMzQi80+TneOnpah1W1m3nxLt3KSvnanVvGAHAgIRw0
         Xvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=44jOD3nZVoOvFATWCEVSb6OwVXBmxVqEX3xVTS4M3cs=;
        b=PHF1Ikm2u0qZKDDe25rWE+oS0vbdA+slnwDWjrHjTN6EuVWg1R8r7qEvyQnHbVhFIX
         C9M/eDdYkx+rs7RxlsF3PvS0ZB9PsS4qGW6YqhDBTQkLIp/2RZSC/+cXvIXPnGWo/V2q
         fUWIYnVUv69EzWnfLD0YnxLBsAg8vB4gMqBfgOPgkS2phIgUfHG6QqEghQnyIt0+Ha1C
         xH1Gau0u7Zw43buB+HHAWUu6NvzQCLboCt09dh9RBE/IoCTWs/0vjJC3NtjX0AkOgIc5
         58Qvq+NuKZ16OGUQbRvRFVkFgnFCNJLPQT/RPqQzdWVFLfL9iXdiXU/cYjajTVCJXMKs
         VMrg==
X-Gm-Message-State: AOAM533cgvozehSDUPXxAec9qxBicmXRzMYQTzW39iLB66J6LR3TjcSA
        ybiOm9kwGMSLtu7kvhja+iV7ef92/R3cbsKce1HfxQ==
X-Google-Smtp-Source: ABdhPJyyUdsHNxpiBTK5V6JVwIHLWxywC4KPQOacz+7AoBgDLvKzgLZIrFIbwC9MffmwCdTxb5aSS62z2tthMPg1GWw=
X-Received: by 2002:a05:622a:c9:: with SMTP id p9mr10883068qtw.337.1611772536831;
 Wed, 27 Jan 2021 10:35:36 -0800 (PST)
MIME-Version: 1.0
References: <000000000000dfc44f05b9d2e864@google.com> <20210127054509.2187-1-hdanton@sina.com>
 <CACT4Y+aTkZZn7BCbn5HPph_9wjw6vtz5Qo6+c933Rgf-nq5BMA@mail.gmail.com> <20210127122409.8808-1-hdanton@sina.com>
In-Reply-To: <20210127122409.8808-1-hdanton@sina.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 27 Jan 2021 19:35:25 +0100
Message-ID: <CACT4Y+YKmhJ2eBe0+WmRHs_yNmuAc6r-x5FQi+QAtT=LPdS4tg@mail.gmail.com>
Subject: Re: upstream test error: INFO: trying to register non-static key in nsim_get_stats64
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 1:24 PM Hillf Danton <hdanton@sina.com> wrote:
>
> On Wed, 27 Jan 2021 10:07:24 +0100 Dmitry Vyukov <dvyukov@google.com> wrote:
> >On Wed, Jan 27, 2021 at 6:45 AM Hillf Danton <hdanton@sina.com> wrote:
> >>
> >> Tue, 26 Jan 2021 11:46:24 -0800
> >> > syzbot found the following issue on:
> >> >
> >> > HEAD commit:    c7230a48 Merge tag 'spi-fix-v5.11-rc5' of git://git.kernel..
> >> > git tree:       upstream
> >> > console output: https://syzkaller.appspot.com/x/log.txt?x=17731f94d00000
> >> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9c312983a0475388
> >> > dashboard link: https://syzkaller.appspot.com/bug?extid=e74a6857f2d0efe3ad81
> >> > userspace arch: arm
> >> >
> >> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> > Reported-by: syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com
> >> >
> >> > batman_adv: batadv0: Not using interface batadv_slave_1 (retrying later): interface not active
> >> > device hsr_slave_0 entered promiscuous mode
> >> > device hsr_slave_1 entered promiscuous mode
> >> >
> >> > INFO: trying to register non-static key.
> >> > the code is fine but needs lockdep annotation.
> >> > turning off the locking correctness validator.
> >> > CPU: 0 PID: 4695 Comm: syz-executor.0 Not tainted 5.11.0-rc5-syzkaller #0
> >> > Hardware name: ARM-Versatile Express
> >> > Backtrace:
> >> > [<826fc5b8>] (dump_backtrace) from [<826fc82c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
> >> > [<826fc814>] (show_stack) from [<8270d1f8>] (__dump_stack lib/dump_stack.c:79 [inline])
> >> > [<826fc814>] (show_stack) from [<8270d1f8>] (dump_stack+0xa8/0xc8 lib/dump_stack.c:120)
> >> > [<8270d150>] (dump_stack) from [<802bf9c0>] (assign_lock_key kernel/locking/lockdep.c:935 [inline])
> >> > [<8270d150>] (dump_stack) from [<802bf9c0>] (register_lock_class+0xabc/0xb68 kernel/locking/lockdep.c:1247)
> >> > [<802bef04>] (register_lock_class) from [<802baa2c>] (__lock_acquire+0x84/0x32d4 kernel/locking/lockdep.c:4711)
> >> > [<802ba9a8>] (__lock_acquire) from [<802be840>] (lock_acquire.part.0+0xf0/0x554 kernel/locking/lockdep.c:5442)
> >> > [<802be750>] (lock_acquire.part.0) from [<802bed10>] (lock_acquire+0x6c/0x74 kernel/locking/lockdep.c:5415)
> >> > [<802beca4>] (lock_acquire) from [<81560548>] (seqcount_lockdep_reader_access include/linux/seqlock.h:103 [inline])
> >> > [<802beca4>] (lock_acquire) from [<81560548>] (__u64_stats_fetch_begin include/linux/u64_stats_sync.h:164 [inline])
> >> > [<802beca4>] (lock_acquire) from [<81560548>] (u64_stats_fetch_begin include/linux/u64_stats_sync.h:175 [inline])
> >> > [<802beca4>] (lock_acquire) from [<81560548>] (nsim_get_stats64+0xdc/0xf0 drivers/net/netdevsim/netdev.c:70)
> >> > [<8156046c>] (nsim_get_stats64) from [<81e2efa0>] (dev_get_stats+0x44/0xd0 net/core/dev.c:10405)
> >> > [<81e2ef5c>] (dev_get_stats) from [<81e53204>] (rtnl_fill_stats+0x38/0x120 net/core/rtnetlink.c:1211)
> >> > [<81e531cc>] (rtnl_fill_stats) from [<81e59d58>] (rtnl_fill_ifinfo+0x6d4/0x148c net/core/rtnetlink.c:1783)
> >> > [<81e59684>] (rtnl_fill_ifinfo) from [<81e5ceb4>] (rtmsg_ifinfo_build_skb+0x9c/0x108 net/core/rtnetlink.c:3798)
> >> > [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3830 [inline])
> >> > [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3821 [inline])
> >> > [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo+0x44/0x70 net/core/rtnetlink.c:3839)
> >> > [<81e5d068>] (rtmsg_ifinfo) from [<81e45c2c>] (register_netdevice+0x664/0x68c net/core/dev.c:10103)
> >> > [<81e455c8>] (register_netdevice) from [<815608bc>] (nsim_create+0xf8/0x124 drivers/net/netdevsim/netdev.c:317)
> >> > [<815607c4>] (nsim_create) from [<81561184>] (__nsim_dev_port_add+0x108/0x188 drivers/net/netdevsim/dev.c:941)
> >> > [<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_port_add_all drivers/net/netdevsim/dev.c:990 [inline])
> >> > [<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_probe+0x5cc/0x750 drivers/net/netdevsim/dev.c:1119)
> >> > [<81561b0c>] (nsim_dev_probe) from [<815661dc>] (nsim_bus_probe+0x10/0x14 drivers/net/netdevsim/bus.c:287)
> >> > [<815661cc>] (nsim_bus_probe) from [<811724c0>] (really_probe+0x100/0x50c drivers/base/dd.c:554)
> >> > [<811723c0>] (really_probe) from [<811729c4>] (driver_probe_device+0xf8/0x1c8 drivers/base/dd.c:740)
> >> > [<811728cc>] (driver_probe_device) from [<81172fe4>] (__device_attach_driver+0x8c/0xf0 drivers/base/dd.c:846)
> >> > [<81172f58>] (__device_attach_driver) from [<8116fee0>] (bus_for_each_drv+0x88/0xd8 drivers/base/bus.c:431)
> >> > [<8116fe58>] (bus_for_each_drv) from [<81172c6c>] (__device_attach+0xdc/0x1d0 drivers/base/dd.c:914)
> >> > [<81172b90>] (__device_attach) from [<8117305c>] (device_initial_probe+0x14/0x18 drivers/base/dd.c:961)
> >> > [<81173048>] (device_initial_probe) from [<81171358>] (bus_probe_device+0x90/0x98 drivers/base/bus.c:491)
> >> > [<811712c8>] (bus_probe_device) from [<8116e77c>] (device_add+0x320/0x824 drivers/base/core.c:3109)
> >> > [<8116e45c>] (device_add) from [<8116ec9c>] (device_register+0x1c/0x20 drivers/base/core.c:3182)
> >> > [<8116ec80>] (device_register) from [<81566710>] (nsim_bus_dev_new drivers/net/netdevsim/bus.c:336 [inline])
> >> > [<8116ec80>] (device_register) from [<81566710>] (new_device_store+0x178/0x208 drivers/net/netdevsim/bus.c:215)
> >> > [<81566598>] (new_device_store) from [<8116fcb4>] (bus_attr_store+0x2c/0x38 drivers/base/bus.c:122)
> >> > [<8116fc88>] (bus_attr_store) from [<805b4b8c>] (sysfs_kf_write+0x48/0x54 fs/sysfs/file.c:139)
> >> > [<805b4b44>] (sysfs_kf_write) from [<805b3c90>] (kernfs_fop_write_iter+0x128/0x1ec fs/kernfs/file.c:296)
> >> > [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (call_write_iter include/linux/fs.h:1901 [inline])
> >> > [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (new_sync_write fs/read_write.c:518 [inline])
> >> > [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (vfs_write+0x3dc/0x57c fs/read_write.c:605)
> >> > [<804d1f20>] (vfs_write) from [<804d2604>] (ksys_write+0x68/0xec fs/read_write.c:658)
> >> > [<804d259c>] (ksys_write) from [<804d2698>] (__do_sys_write fs/read_write.c:670 [inline])
> >> > [<804d259c>] (ksys_write) from [<804d2698>] (sys_write+0x10/0x14 fs/read_write.c:667)
> >> > [<804d2688>] (sys_write) from [<80200060>] (ret_fast_syscall+0x0/0x2c arch/arm/mm/proc-v7.S:64)
> >>
> >> Init u64 stats for aa32.
> >>
> >>
> >> --- a/drivers/net/netdevsim/netdev.c
> >> +++ b/drivers/net/netdevsim/netdev.c
> >> @@ -296,6 +296,7 @@ nsim_create(struct nsim_dev *nsim_dev, s
> >>         dev_net_set(dev, nsim_dev_net(nsim_dev));
> >>         ns = netdev_priv(dev);
> >>         ns->netdev = dev;
> >> +       u64_stats_init(&ns->syncp);
> >>         ns->nsim_dev = nsim_dev;
> >>         ns->nsim_dev_port = nsim_dev_port;
> >>         ns->nsim_bus_dev = nsim_dev->nsim_bus_dev;
> >
> >Hi Hillf,
> >
> Hi Dmitry,
>
> >Thanks for looking into it.
> >This would be good to fix asap upstream because it boot-breaks 32-bit
> >arches (arm32). Do you mind sending a proper patch?
> >
> I'd like to do that but the barrier is, you see,
>
> 1/ I could not test it because I dont have (or access to) such a device,
> 2/ if the diff makes sense, anyone can feel free to prepare a patch and
> send it out to the maintainer because I prefer Cc much more than sob.
>
> That is it. Simple and pure.

I've run syzkaller with this patch and the warning goes away, so you may add:
Tested-by: Dmitry Vyukov <dvyukov@google.com>

Just in case, syzbot uses qemu-system-arm to test arm32 on x86_64. So
if you have a typical x86_64 machine, you may test this. I will
document more details soon.
