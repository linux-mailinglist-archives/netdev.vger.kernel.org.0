Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18C1A83D1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbgDNPvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440940AbgDNPvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:51:11 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB20CC061A0C;
        Tue, 14 Apr 2020 08:51:11 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id s18so10368527ioe.10;
        Tue, 14 Apr 2020 08:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4cAyVbZ5COn1OcRqgq9nR7fLvg4V1HkON81sQ7ObhuU=;
        b=M7vtx7Ln812XR9re0r9ZDNtO/hiwSJp5CEqqgv2pc8Y2OjQKDtWwOS3CYL6rt3RPz0
         mwVy9PVKaq3SVzxkCdlXwrGLaQ4OW5MsZlpDwnppdoF9apHhqRAq5783Y9AR483tzs1b
         +ocnJs1zoH4T3kX7jQqTzqqplSGGNkb8clc/YVpD+rUn3mXw31rpdty2n4+BW5yKRmqE
         UhnSG3Dd74p2lBT38ag5yxw8vmMiU5sQeHQO/keZ3bJGzEu3cSW2pm6dSyvcMass/CS3
         G3VrDl4HVxx/tP3PODLlbqJ2qwCIHB0gVtlEsBBRtPo1gVoPwf33Gz0lvwgBK1mteIR7
         qqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4cAyVbZ5COn1OcRqgq9nR7fLvg4V1HkON81sQ7ObhuU=;
        b=acxsXWuMKdXt7099V8cgBE2wyvd9MHWMNBdbTlfazfmU6ENYqWQqAC7eA1PFOxFaEx
         /oX70M9Cm3kACA+nDFyAyvg31olYaqxuksdG2cmfrhWdDcnIUH1gtDJ9uekdlerD5qBp
         1LLILRsEPuHDVxubrNzummZB/fhpYjHoNHIKpfJkhs+xePNtL+uqs6FFjkfqZsKwDiW3
         gHXbWU8cBLgKGwqlqXXMbh33KWyeWHqMJkBCulgUZZxRXbzo+QqRLfWsV766MeiLUVuS
         LMVPHrsV/l0iFCCTjBeqxlS5if7+e4bOVcFC/my4RHBtdwKSoYNdU08azwMpelznQ4zZ
         PWcw==
X-Gm-Message-State: AGi0PubDNPdGY46F7B829VQNIY7lw/higDLY4lXNKRgYp6j312fI1qZp
        erDqnYFFwuAkfg4sBIUArL7G6OR8Go06k+x1Z5c=
X-Google-Smtp-Source: APiQypJom1qT9CGtZyGfBzB/8Nk8sayobqgdaf2m8OHsxrE9Xnj1ZapGSrh/Sv6+0IV8YLP5LUEe+G0Es8jRtvWynWY=
X-Received: by 2002:a02:9642:: with SMTP id c60mr21342669jai.87.1586879470745;
 Tue, 14 Apr 2020 08:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200412191824.GA109724@laptop> <CAKgT0Udn3sE4iZci2dRNun6i3DMoG==kuksX_gLXWQORXA1kWA@mail.gmail.com>
 <20200413215508.GA122208@laptop>
In-Reply-To: <20200413215508.GA122208@laptop>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 14 Apr 2020 08:50:59 -0700
Message-ID: <CAKgT0UeThCT2FrccmP1TdNuWD9S2cgXOhu2423MQteOKw5Xpvw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] BUG: e1000: infinitely loop at e1000_set_link_ksettings
To:     Maxim Zhukov <mussitantesmortem@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 2:55 PM Maxim Zhukov
<mussitantesmortem@gmail.com> wrote:
>
> On Mon, Apr 13, 2020 at 11:47:21AM -0700, Alexander Duyck wrote:
> > On Sun, Apr 12, 2020 at 4:12 PM Maxim Zhukov
> > <mussitantesmortem@gmail.com> wrote:
> > >
> > > On Qemu X86 (kernel 5.4.31):
> > What version of QEMU are you running? That would tell us more about
> > how the device is being emulated.
> $ qemu-system-i386 --version
> QEMU emulator version 4.2.0
> Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
> >
> > > The system-maintenance daemon hangout on D-state at startup on
> > > ioctl(ETHTOOL_SSET) for setup advertising, duplex, etc...
> > >
> > > kgdb stacktrace:
> > >
> > > ----
> > >
> >
> > I am dropping the first backtrace since it is a symptom of the trace
> > below. Essentially the issue is all calls to e1000_reinit_locked get
> > stuck because the __E1000_RESETTING bit is stuck set because this
> > first thread is stuck waiting on napi_disable to succeed.
> >
> > > Also stalled workers backtrace:
> > >
> > > #3  0xc19e0870 in schedule () at kernel/sched/core.c:4150
> > > #4  0xc19e2f3e in schedule_timeout (timeout=<optimized out>) at kernel/time/timer.c:1895
> > > #5  0xc19e3041 in schedule_timeout_uninterruptible (timeout=<optimized out>) at kernel/time/timer.c:1929
> > > #6  0xc10b3dd1 in msleep (msecs=<optimized out>) at kernel/time/timer.c:2048
> > > #7  0xc1771fb4 in napi_disable (n=0xdec0b7d8) at net/core/dev.c:6240
> > > #8  0xc15f0e87 in e1000_down (adapter=0xdec0b540) at drivers/net/ethernet/intel/e1000/e1000_main.c:522
> > > #9  0xc15f0f35 in e1000_reinit_locked (adapter=0xdec0b540) at drivers/net/ethernet/intel/e1000/e1000_main.c:545
> > > #10 0xc15f6ecd in e1000_reset_task (work=0xdec0bca0) at drivers/net/ethernet/intel/e1000/e1000_main.c:3506
> > > #11 0xc106c882 in process_one_work (worker=0xdef4d840, work=0xdec0bca0) at kernel/workqueue.c:2272
> > > #12 0xc106ccc6 in worker_thread (__worker=0xdef4d840) at kernel/workqueue.c:2418
> > > #13 0xc1070657 in kthread (_create=0xdf508800) at kernel/kthread.c:255
> > > #14 0xc19e4078 in ret_from_fork () at arch/x86/entry/entry_32.S:813
> >
> > So the question I would have is what is causing napi_disable to stall
> > out? I have looked over the latest QEMU code and the driver code and
> > both the Tx and Rx paths should have been shut down at the point where
> > napi_disable is called. I'm assuming there is little to no traffic
> > present so the NAPI thread shouldn't be stuck in the polling state for
> > that reason. The only other thing I can think of is that somehow this
> > is getting scheduled after the interface was already brought down
> > causing napi_disable to be called a second time for the same NAPI
> > instance.
> In the log below udhcpc sends discover packets in the raw mode (https://git.busybox.net/busybox/tree/networking/udhcp/dhcpc.c#n738), maybe it's triggered stall?
>
> >
> > A dmesg log for the system at the time of the hang might be useful as
> > it could include some information on what other configuration options
> > might have been changed that led to us blocking on the napi_disable
> > call.
>
> running command:
> qemu-system-i386 \
>         -kernel bzImage \
>         -drive file=rootfs.ext2,index=0,media=disk,format=raw \
>         -drive file=storage.ext2,index=1,media=disk,format=raw \
>         -smp 2 \
>         -m 2047M \
>         -enable-kvm \
>         -append "console=ttyS0 root=/dev/sda rw storage=/dev/sdb rw virtfs_tag=host0" \
>         -netdev tap,id=mynet1,ifname=tap0,script=no,downscript=no -device e1000,netdev=mynet1,mac=02:88:b1:e7:d1:f7 \
>         -netdev tap,id=mynet2,ifname=tap1,script=no,downscript=no -device e1000,netdev=mynet2,mac=02:70:67:e7:d1:f7 \
>         -virtfs local,path=./share/,mount_tag=host0,security_model=mapped-file,id=host0 \
>         -nographic
>
>
> dmesg:
>
> ---------
> [    2.113622] Run /sbin/init as init process
> [    2.145965] random: init: uninitialized urandom read (4 bytes read)
> [    3.175813] random: modprobe: uninitialized urandom read (4 bytes read)
> [    3.182942] modprobe (1267) used greatest stack depth: 5904 bytes left
> [    3.193894] EXT4-fs (sdb): mounting ext2 file system using the ext4 subsystem
> [    3.196343] EXT4-fs (sdb): warning: mounting unchecked fs, running e2fsck is recommended
> [    3.406740] EXT4-fs (sdb): mounted filesystem without journal. Opts: (null)
> [    3.408419] ext2 filesystem being mounted at /boot supports timestamps until 2038 (0x7fffffff)
> [    3.412388] random: sh: uninitialized urandom read (4 bytes read)
> [    3.415512] random: startup.sh: uninitialized urandom read (4 bytes read)
> [    3.907569] 8021q: adding VLAN 0 to HW filter on device eth0
> [    3.909715] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> [    3.912057] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [    3.922927] 8021q: adding VLAN 0 to HW filter on device x86eth100
> [    3.934933] 8021q: adding VLAN 0 to HW filter on device eth1
> [    3.936800] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> [    3.939092] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [    3.948995] 8021q: adding VLAN 0 to HW filter on device x86eth200
> [    4.178555] e1000 0000:00:04.0 eth1: Reset adapter
> [    4.219492] dmsd[wrkr] (1350) used greatest stack depth: 5536 bytes left
> [    4.368172] random: crng init done
> [    4.369034] random: 6 urandom warning(s) missed due to ratelimiting
> [    4.502536] 8021q: adding VLAN 0 to HW filter on device x86eth100
> [    4.520655] 8021q: adding VLAN 0 to HW filter on device x86eth200
> [    4.558841] br1: port 1(x86eth100) entered blocking state
> [    4.560342] br1: port 1(x86eth100) entered disabled state
> [    4.561649] device x86eth100 entered promiscuous mode
> [    4.562823] device eth0 entered promiscuous mode
> [    9.705295] 8021q: adding VLAN 0 to HW filter on device eth0
> [   11.731948] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> ----
>
> syslog:
>
> ----
> Apr 14 00:31:23 [ALRT] default_port_status_set[1716]: ioctl(eth0, ETHTOOL_SSET)
> Apr 14 00:31:23 [ALRT] default_port_status_set[1716]: ifup eth0
> Apr 14 00:31:23 [INFO] kernel: [    9.705295] 8021q: adding VLAN 0 to HW filter on device eth0
> Apr 14 00:31:23 [ALRT] default_port_status_set[1717]: ioctl(eth1, ETHTOOL_SSET)                                   <<<<<<<<<<< last ioctl
> Apr 14 00:31:24 [INFO] udhcpc[1545]: sending discover
> Apr 14 00:31:25 [INFO] kernel: [   11.731948] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> ----
>
>
> >
> > Other than that, how easy is it to trigger this hang. Is this
> > happening every time you start the guest, or does this just happen
> > periodically?
> It's happening periodically, sometimes the chance is very low.
>
> I did't find the way for reproduce this hang (I tried to call ioctl + ifups in several configurations)
>
> Thanks for your attention!

Thanks for the logs. I'll have to look it over and see if I can figure
out what is going on. It looks like something is triggering a reset
for eth1 almost immediately after the link is up. I'm suspecting some
sort of race during initialization time resulting in us coming up and
triggering the reset while the interface is actually down and causing
the hang.

One other question. Are you always seeing this on eth1 or is it
cycling between eth1 and eth0 when it occurs?
