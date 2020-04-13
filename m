Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA861A6EC5
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389348AbgDMVzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 17:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389285AbgDMVzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 17:55:13 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B6EC0A3BDC;
        Mon, 13 Apr 2020 14:55:13 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m8so10364615lji.1;
        Mon, 13 Apr 2020 14:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U05ipgzYQFfvdz8yfENntAM8U1md1dSKVlkDdwMaaWo=;
        b=PgbYl0/IEVy9QV439pqqfgjOL9KN8LJvK2HYSGiqObb6oYeZEPxMt4LwR5HZpuqdrN
         R1et6Btb1iZbepuJvggBC1O6WhA+iSa7z92Uvvm2Psl8QdsBW9823fds/eOFeXPj4kea
         pcZ3TmQrwgQUWTzzdjqwcgLzyTEgsq9pBfEDnVHgJUdbR9sQbgK1ZeKlPL4i4P+1zgr1
         gslyU+oXop2wgL4fuNNCP+ChPVlT9gHJA/L55g5lhTvtIx7E6TyENPtps6tx/HUETxni
         3jfE9c4vu0FVLecVkJWNGEn+fhdAY/U3ERxCFCtNtUzhfhwnKb4bc9G1YREzOqJqT6W7
         hFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U05ipgzYQFfvdz8yfENntAM8U1md1dSKVlkDdwMaaWo=;
        b=pnnQJnlgZS0018ghCl9npq0pe6KRhHVTGPGvuaH8HcgA6miHPEuJseai9zvCl0bFjc
         b6s5V2/+8mIwB1EDKjhWPWge/aroX5DyqhnPLkSDtfs6SQrqntbOdQ1ARMwL5NXnyY9w
         8244CbXPfyGMcfbuBrNv7AlWbHUSZh9cHxPbQjerKWV/fhGv4/IFY93L3VAX1AoTDYr0
         C+SmZTeLdLp6dsUS/hli7kKrGmlaPWGvHK0OfTlLFwz1d2VSDAdq0f2BwzQfiFSqyYnM
         W6PtI06sVAK0kGVRmtdbwNY0ZYTUzNVku9dbVzFI5Xr/TBk6nqYMHzEAUS8jWfZwojBU
         4jMg==
X-Gm-Message-State: AGi0PuYO43DE94b0sGUdHn8pvVmjh1WBnibZfSW7dSqEvTItiZRpoyPs
        3Sxf/mcVsV54/S4Z/sjWkPI=
X-Google-Smtp-Source: APiQypKdLAMv+BKSoxci/0KZ/l3cZ8gLqjLxKWB81P2PlZGyPMV5SiylbxiNTvd7aaT+gtYLZHCGvw==
X-Received: by 2002:a2e:b558:: with SMTP id a24mr10905390ljn.56.1586814911613;
        Mon, 13 Apr 2020 14:55:11 -0700 (PDT)
Received: from laptop ([178.170.168.10])
        by smtp.gmail.com with ESMTPSA id t81sm8913077lff.52.2020.04.13.14.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 14:55:10 -0700 (PDT)
Date:   Tue, 14 Apr 2020 00:55:08 +0300
From:   Maxim Zhukov <mussitantesmortem@gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-wired-lan] BUG: e1000: infinitely loop at
 e1000_set_link_ksettings
Message-ID: <20200413215508.GA122208@laptop>
References: <20200412191824.GA109724@laptop>
 <CAKgT0Udn3sE4iZci2dRNun6i3DMoG==kuksX_gLXWQORXA1kWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Udn3sE4iZci2dRNun6i3DMoG==kuksX_gLXWQORXA1kWA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 11:47:21AM -0700, Alexander Duyck wrote:
> On Sun, Apr 12, 2020 at 4:12 PM Maxim Zhukov
> <mussitantesmortem@gmail.com> wrote:
> >
> > On Qemu X86 (kernel 5.4.31):
> What version of QEMU are you running? That would tell us more about
> how the device is being emulated.
$ qemu-system-i386 --version
QEMU emulator version 4.2.0
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
>
> > The system-maintenance daemon hangout on D-state at startup on
> > ioctl(ETHTOOL_SSET) for setup advertising, duplex, etc...
> >
> > kgdb stacktrace:
> >
> > ----
> >
> 
> I am dropping the first backtrace since it is a symptom of the trace
> below. Essentially the issue is all calls to e1000_reinit_locked get
> stuck because the __E1000_RESETTING bit is stuck set because this
> first thread is stuck waiting on napi_disable to succeed.
> 
> > Also stalled workers backtrace:
> >
> > #3  0xc19e0870 in schedule () at kernel/sched/core.c:4150
> > #4  0xc19e2f3e in schedule_timeout (timeout=<optimized out>) at kernel/time/timer.c:1895
> > #5  0xc19e3041 in schedule_timeout_uninterruptible (timeout=<optimized out>) at kernel/time/timer.c:1929
> > #6  0xc10b3dd1 in msleep (msecs=<optimized out>) at kernel/time/timer.c:2048
> > #7  0xc1771fb4 in napi_disable (n=0xdec0b7d8) at net/core/dev.c:6240
> > #8  0xc15f0e87 in e1000_down (adapter=0xdec0b540) at drivers/net/ethernet/intel/e1000/e1000_main.c:522
> > #9  0xc15f0f35 in e1000_reinit_locked (adapter=0xdec0b540) at drivers/net/ethernet/intel/e1000/e1000_main.c:545
> > #10 0xc15f6ecd in e1000_reset_task (work=0xdec0bca0) at drivers/net/ethernet/intel/e1000/e1000_main.c:3506
> > #11 0xc106c882 in process_one_work (worker=0xdef4d840, work=0xdec0bca0) at kernel/workqueue.c:2272
> > #12 0xc106ccc6 in worker_thread (__worker=0xdef4d840) at kernel/workqueue.c:2418
> > #13 0xc1070657 in kthread (_create=0xdf508800) at kernel/kthread.c:255
> > #14 0xc19e4078 in ret_from_fork () at arch/x86/entry/entry_32.S:813
> 
> So the question I would have is what is causing napi_disable to stall
> out? I have looked over the latest QEMU code and the driver code and
> both the Tx and Rx paths should have been shut down at the point where
> napi_disable is called. I'm assuming there is little to no traffic
> present so the NAPI thread shouldn't be stuck in the polling state for
> that reason. The only other thing I can think of is that somehow this
> is getting scheduled after the interface was already brought down
> causing napi_disable to be called a second time for the same NAPI
> instance.
In the log below udhcpc sends discover packets in the raw mode (https://git.busybox.net/busybox/tree/networking/udhcp/dhcpc.c#n738), maybe it's triggered stall?

> 
> A dmesg log for the system at the time of the hang might be useful as
> it could include some information on what other configuration options
> might have been changed that led to us blocking on the napi_disable
> call.

running command:
qemu-system-i386 \
        -kernel bzImage \
        -drive file=rootfs.ext2,index=0,media=disk,format=raw \
        -drive file=storage.ext2,index=1,media=disk,format=raw \
        -smp 2 \
        -m 2047M \
        -enable-kvm \
        -append "console=ttyS0 root=/dev/sda rw storage=/dev/sdb rw virtfs_tag=host0" \
        -netdev tap,id=mynet1,ifname=tap0,script=no,downscript=no -device e1000,netdev=mynet1,mac=02:88:b1:e7:d1:f7 \
        -netdev tap,id=mynet2,ifname=tap1,script=no,downscript=no -device e1000,netdev=mynet2,mac=02:70:67:e7:d1:f7 \
        -virtfs local,path=./share/,mount_tag=host0,security_model=mapped-file,id=host0 \
        -nographic


dmesg:

---------
[    2.113622] Run /sbin/init as init process
[    2.145965] random: init: uninitialized urandom read (4 bytes read)
[    3.175813] random: modprobe: uninitialized urandom read (4 bytes read)
[    3.182942] modprobe (1267) used greatest stack depth: 5904 bytes left
[    3.193894] EXT4-fs (sdb): mounting ext2 file system using the ext4 subsystem
[    3.196343] EXT4-fs (sdb): warning: mounting unchecked fs, running e2fsck is recommended
[    3.406740] EXT4-fs (sdb): mounted filesystem without journal. Opts: (null)
[    3.408419] ext2 filesystem being mounted at /boot supports timestamps until 2038 (0x7fffffff)
[    3.412388] random: sh: uninitialized urandom read (4 bytes read)
[    3.415512] random: startup.sh: uninitialized urandom read (4 bytes read)
[    3.907569] 8021q: adding VLAN 0 to HW filter on device eth0
[    3.909715] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    3.912057] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    3.922927] 8021q: adding VLAN 0 to HW filter on device x86eth100
[    3.934933] 8021q: adding VLAN 0 to HW filter on device eth1
[    3.936800] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    3.939092] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[    3.948995] 8021q: adding VLAN 0 to HW filter on device x86eth200
[    4.178555] e1000 0000:00:04.0 eth1: Reset adapter
[    4.219492] dmsd[wrkr] (1350) used greatest stack depth: 5536 bytes left
[    4.368172] random: crng init done
[    4.369034] random: 6 urandom warning(s) missed due to ratelimiting
[    4.502536] 8021q: adding VLAN 0 to HW filter on device x86eth100
[    4.520655] 8021q: adding VLAN 0 to HW filter on device x86eth200
[    4.558841] br1: port 1(x86eth100) entered blocking state
[    4.560342] br1: port 1(x86eth100) entered disabled state
[    4.561649] device x86eth100 entered promiscuous mode
[    4.562823] device eth0 entered promiscuous mode
[    9.705295] 8021q: adding VLAN 0 to HW filter on device eth0
[   11.731948] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
----

syslog:

----
Apr 14 00:31:23 [ALRT] default_port_status_set[1716]: ioctl(eth0, ETHTOOL_SSET)
Apr 14 00:31:23 [ALRT] default_port_status_set[1716]: ifup eth0
Apr 14 00:31:23 [INFO] kernel: [    9.705295] 8021q: adding VLAN 0 to HW filter on device eth0
Apr 14 00:31:23 [ALRT] default_port_status_set[1717]: ioctl(eth1, ETHTOOL_SSET)                                   <<<<<<<<<<< last ioctl
Apr 14 00:31:24 [INFO] udhcpc[1545]: sending discover
Apr 14 00:31:25 [INFO] kernel: [   11.731948] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
----


> 
> Other than that, how easy is it to trigger this hang. Is this
> happening every time you start the guest, or does this just happen
> periodically?
It's happening periodically, sometimes the chance is very low.

I did't find the way for reproduce this hang (I tried to call ioctl + ifups in several configurations)

Thanks for your attention!
