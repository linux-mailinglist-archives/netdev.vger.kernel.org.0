Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90041A8A09
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504315AbgDNSpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504293AbgDNSpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:45:53 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BA7C061A0C;
        Tue, 14 Apr 2020 11:45:52 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 198so597328lfo.7;
        Tue, 14 Apr 2020 11:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K5Un9PWem7bDnQl21XNpLy8Olc7skeDSO/FPYiP57i0=;
        b=soYSMmvItaIHzt+nhLVTN1PtOlcIsGfe8xgRJqtRQLwFD/LMKIbgSNzm9xc1JtJyTT
         nbcS0jd8YQrmT7M1jSyg630zpfrM4BAVEC2X/EnG+/Vgnvm507EnhIulKOtqVjyXOV2p
         tP96FDeraFESr9Nl5fvuu0y2V7xlDUJIRBqbrLydUOkwPlF29kADORzU8Jj4fk2jPvz/
         uqYtp31LuCI9egHs+CYI8CTfhir+s0dhRHf/ATKFbHCDsOQ8oTlMg4t2H2TqpcDoni52
         aI3MW+niXWrJFbd5xG1suYn4NzFa9GkHvAKlV0bEdxrYbmxaMTBOXoLEXlh60nJ/11K1
         viqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K5Un9PWem7bDnQl21XNpLy8Olc7skeDSO/FPYiP57i0=;
        b=LN4cMKRFbzS63Iw7M2pBivfQjo9oB1/wqG11skhcFIx8tbFgvOLbAdhvAXIon19tLA
         d49oWkHNbFBF2jKKn+YT/1uJPLIk6XY5psGwgcyuVnNaXcpY8fgKep4Grnut39GCMFxX
         ulByctDy0xZZYQvgx5aGiySR+9WDl/p8WI9UX5v5CQ2VWqA3QNCrziLAvYg031r/uSkX
         VUoBBzT0p0qp/wt1oaHIHKMXKJ232uJNr2bLTbUzRiSjXDbYtDUDKG761Fh1VYei0UVo
         xF6p6E8cCd55QCL0cJf8bIGbUr8xYrakSpWxaxUN8PUBCyh3xIH8UQaO8sSJzRwXjOBN
         ogKA==
X-Gm-Message-State: AGi0PuYzOKQjjsAQv5TsrUsmceLAfGDuLTcV2vEzrwQC2LK9bHHyNdaQ
        06t7R05FqSAry+E3Aps3FysrTg2qOzmFDw==
X-Google-Smtp-Source: APiQypJa2f18MsCAnFslWRY67gbC+vGxbbYouHd8dTvhw52a67eu7fnx6kAZzvKLKAOaEnmtvc7a7g==
X-Received: by 2002:a05:6512:14a:: with SMTP id m10mr710009lfo.152.1586889949717;
        Tue, 14 Apr 2020 11:45:49 -0700 (PDT)
Received: from laptop ([178.170.168.10])
        by smtp.gmail.com with ESMTPSA id c22sm9518263ljh.66.2020.04.14.11.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:45:48 -0700 (PDT)
Date:   Tue, 14 Apr 2020 21:45:47 +0300
From:   Maxim Zhukov <mussitantesmortem@gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, mussitantesmortem@gmail.com
Subject: Re: [Intel-wired-lan] BUG: e1000: infinitely loop at
 e1000_set_link_ksettings
Message-ID: <20200414184547.ue7mvj6olmr76m2i@laptop>
References: <20200412191824.GA109724@laptop>
 <CAKgT0Udn3sE4iZci2dRNun6i3DMoG==kuksX_gLXWQORXA1kWA@mail.gmail.com>
 <20200413215508.GA122208@laptop>
 <CAKgT0UeThCT2FrccmP1TdNuWD9S2cgXOhu2423MQteOKw5Xpvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeThCT2FrccmP1TdNuWD9S2cgXOhu2423MQteOKw5Xpvw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:50:59AM -0700, Alexander Duyck wrote:
> On Mon, Apr 13, 2020 at 2:55 PM Maxim Zhukov
> <mussitantesmortem@gmail.com> wrote:
> >
> > On Mon, Apr 13, 2020 at 11:47:21AM -0700, Alexander Duyck wrote:
> > > On Sun, Apr 12, 2020 at 4:12 PM Maxim Zhukov
> > > <mussitantesmortem@gmail.com> wrote:
> > > >
> > > > On Qemu X86 (kernel 5.4.31):
> > > What version of QEMU are you running? That would tell us more about
> > > how the device is being emulated.
> > $ qemu-system-i386 --version
> > QEMU emulator version 4.2.0
> > Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
> > >
> > > > The system-maintenance daemon hangout on D-state at startup on
> > > > ioctl(ETHTOOL_SSET) for setup advertising, duplex, etc...
> > > >
> > > > kgdb stacktrace:
> > > >
> > > > ----
> > > >
> > >
> > > I am dropping the first backtrace since it is a symptom of the trace
> > > below. Essentially the issue is all calls to e1000_reinit_locked get
> > > stuck because the __E1000_RESETTING bit is stuck set because this
> > > first thread is stuck waiting on napi_disable to succeed.
> > >
> > > > Also stalled workers backtrace:
> > > >
> > > > #3  0xc19e0870 in schedule () at kernel/sched/core.c:4150
> > > > #4  0xc19e2f3e in schedule_timeout (timeout=<optimized out>) at kernel/time/timer.c:1895
> > > > #5  0xc19e3041 in schedule_timeout_uninterruptible (timeout=<optimized out>) at kernel/time/timer.c:1929
> > > > #6  0xc10b3dd1 in msleep (msecs=<optimized out>) at kernel/time/timer.c:2048
> > > > #7  0xc1771fb4 in napi_disable (n=0xdec0b7d8) at net/core/dev.c:6240
> > > > #8  0xc15f0e87 in e1000_down (adapter=0xdec0b540) at drivers/net/ethernet/intel/e1000/e1000_main.c:522
> > > > #9  0xc15f0f35 in e1000_reinit_locked (adapter=0xdec0b540) at drivers/net/ethernet/intel/e1000/e1000_main.c:545
> > > > #10 0xc15f6ecd in e1000_reset_task (work=0xdec0bca0) at drivers/net/ethernet/intel/e1000/e1000_main.c:3506
> > > > #11 0xc106c882 in process_one_work (worker=0xdef4d840, work=0xdec0bca0) at kernel/workqueue.c:2272
> > > > #12 0xc106ccc6 in worker_thread (__worker=0xdef4d840) at kernel/workqueue.c:2418
> > > > #13 0xc1070657 in kthread (_create=0xdf508800) at kernel/kthread.c:255
> > > > #14 0xc19e4078 in ret_from_fork () at arch/x86/entry/entry_32.S:813
> > >
> > > So the question I would have is what is causing napi_disable to stall
> > > out? I have looked over the latest QEMU code and the driver code and
> > > both the Tx and Rx paths should have been shut down at the point where
> > > napi_disable is called. I'm assuming there is little to no traffic
> > > present so the NAPI thread shouldn't be stuck in the polling state for
> > > that reason. The only other thing I can think of is that somehow this
> > > is getting scheduled after the interface was already brought down
> > > causing napi_disable to be called a second time for the same NAPI
> > > instance.
> > In the log below udhcpc sends discover packets in the raw mode (https://git.busybox.net/busybox/tree/networking/udhcp/dhcpc.c#n738), maybe it's triggered stall?
> >
> > >
> > > A dmesg log for the system at the time of the hang might be useful as
> > > it could include some information on what other configuration options
> > > might have been changed that led to us blocking on the napi_disable
> > > call.
> >
> > running command:
> > qemu-system-i386 \
> >         -kernel bzImage \
> >         -drive file=rootfs.ext2,index=0,media=disk,format=raw \
> >         -drive file=storage.ext2,index=1,media=disk,format=raw \
> >         -smp 2 \
> >         -m 2047M \
> >         -enable-kvm \
> >         -append "console=ttyS0 root=/dev/sda rw storage=/dev/sdb rw virtfs_tag=host0" \
> >         -netdev tap,id=mynet1,ifname=tap0,script=no,downscript=no -device e1000,netdev=mynet1,mac=02:88:b1:e7:d1:f7 \
> >         -netdev tap,id=mynet2,ifname=tap1,script=no,downscript=no -device e1000,netdev=mynet2,mac=02:70:67:e7:d1:f7 \
> >         -virtfs local,path=./share/,mount_tag=host0,security_model=mapped-file,id=host0 \
> >         -nographic
> >
> >
> > dmesg:
> >
> > ---------
> > [    2.113622] Run /sbin/init as init process
> > [    2.145965] random: init: uninitialized urandom read (4 bytes read)
> > [    3.175813] random: modprobe: uninitialized urandom read (4 bytes read)
> > [    3.182942] modprobe (1267) used greatest stack depth: 5904 bytes left
> > [    3.193894] EXT4-fs (sdb): mounting ext2 file system using the ext4 subsystem
> > [    3.196343] EXT4-fs (sdb): warning: mounting unchecked fs, running e2fsck is recommended
> > [    3.406740] EXT4-fs (sdb): mounted filesystem without journal. Opts: (null)
> > [    3.408419] ext2 filesystem being mounted at /boot supports timestamps until 2038 (0x7fffffff)
> > [    3.412388] random: sh: uninitialized urandom read (4 bytes read)
> > [    3.415512] random: startup.sh: uninitialized urandom read (4 bytes read)
> > [    3.907569] 8021q: adding VLAN 0 to HW filter on device eth0
> > [    3.909715] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> > [    3.912057] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > [    3.922927] 8021q: adding VLAN 0 to HW filter on device x86eth100
> > [    3.934933] 8021q: adding VLAN 0 to HW filter on device eth1
> > [    3.936800] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> > [    3.939092] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> > [    3.948995] 8021q: adding VLAN 0 to HW filter on device x86eth200
> > [    4.178555] e1000 0000:00:04.0 eth1: Reset adapter
> > [    4.219492] dmsd[wrkr] (1350) used greatest stack depth: 5536 bytes left
> > [    4.368172] random: crng init done
> > [    4.369034] random: 6 urandom warning(s) missed due to ratelimiting
> > [    4.502536] 8021q: adding VLAN 0 to HW filter on device x86eth100
> > [    4.520655] 8021q: adding VLAN 0 to HW filter on device x86eth200
> > [    4.558841] br1: port 1(x86eth100) entered blocking state
> > [    4.560342] br1: port 1(x86eth100) entered disabled state
> > [    4.561649] device x86eth100 entered promiscuous mode
> > [    4.562823] device eth0 entered promiscuous mode
> > [    9.705295] 8021q: adding VLAN 0 to HW filter on device eth0
> > [   11.731948] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> > ----
> >
> > syslog:
> >
> > ----
> > Apr 14 00:31:23 [ALRT] default_port_status_set[1716]: ioctl(eth0, ETHTOOL_SSET)
> > Apr 14 00:31:23 [ALRT] default_port_status_set[1716]: ifup eth0
> > Apr 14 00:31:23 [INFO] kernel: [    9.705295] 8021q: adding VLAN 0 to HW filter on device eth0
> > Apr 14 00:31:23 [ALRT] default_port_status_set[1717]: ioctl(eth1, ETHTOOL_SSET)                                   <<<<<<<<<<< last ioctl
> > Apr 14 00:31:24 [INFO] udhcpc[1545]: sending discover
> > Apr 14 00:31:25 [INFO] kernel: [   11.731948] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> > ----
> >
> >
> > >
> > > Other than that, how easy is it to trigger this hang. Is this
> > > happening every time you start the guest, or does this just happen
> > > periodically?
> > It's happening periodically, sometimes the chance is very low.
> >
> > I did't find the way for reproduce this hang (I tried to call ioctl + ifups in several configurations)
> >
> > Thanks for your attention!
> 
> Thanks for the logs. I'll have to look it over and see if I can figure
> out what is going on. It looks like something is triggering a reset
> for eth1 almost immediately after the link is up. I'm suspecting some
> sort of race during initialization time resulting in us coming up and
> triggering the reset while the interface is actually down and causing
> the hang.
I can add debug logs to the driver but I'm afraid that chance for stall
will decrease.
> 
> One other question. Are you always seeing this on eth1 or is it
> cycling between eth1 and eth0 when it occurs?
Always on eth1

For check this bug I wrote the script:

---
#!/bin/sh

(
REBOOT_COUNT=$(cat ./reboot_counter);
echo '---------';
echo "Reboot: $REBOOT_COUNT";
echo '---------';
let "REBOOT_COUNT += 1"
echo "$REBOOT_COUNT" > ./reboot_counter
sleep 10;
ip r;
reboot -f;
) &
---

Hang stats:

| Reboot status | nth |
|---------------+-----|
| Success       | 196 |
| Hang on eth0  |     |
| Hang on eth1  | 6   |
|---------------+-----|
| Total         | 202 |


Short log:
13th reboot -- hang on eth1
111th reboot -- hang on eth1
147th reboot -- hang on eth1
170th reboot -- hang on eth1
191th reboot -- hang on eth1
202th reboot -- hang on eth1


So, network configuration on QEMU:

eth0, eth1 -- base ifaces
x86eth100, x86eth200 -- macvlans on eth0, eth1 respectively
br1 contains x86eth100


more logs:

dmesg:
****************
[    3.658000] random: sh: uninitialized urandom read (4 bytes read)
[    3.661278] random: startup.sh: uninitialized urandom read (4 bytes read)
[    4.095810] 8021q: adding VLAN 0 to HW filter on device eth0
[    4.097484] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    4.099593] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    4.111557] 8021q: adding VLAN 0 to HW filter on device x86eth100
[    4.123555] 8021q: adding VLAN 0 to HW filter on device eth1
[    4.125155] e1000: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    4.127227] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[    4.138795] 8021q: adding VLAN 0 to HW filter on device x86eth200
[    4.141440] dsys/start (1300) used greatest stack depth: 5772 bytes left
[    4.368570] e1000 0000:00:04.0 eth1: Reset adapter
[    4.409060] dmsd[wrkr] (1351) used greatest stack depth: 5536 bytes left
[    4.560352] random: crng init done
[    4.561013] random: 6 urandom warning(s) missed due to ratelimiting
[    4.690782] 8021q: adding VLAN 0 to HW filter on device x86eth100
[    4.706602] 8021q: adding VLAN 0 to HW filter on device x86eth200
[    4.745669] br1: port 1(x86eth100) entered blocking state
[    4.747024] br1: port 1(x86eth100) entered disabled state
[    4.748539] device x86eth100 entered promiscuous mode
[    4.749829] device eth0 entered promiscuous mode
****************
syslog:
****************
Apr 14 19:33:07 [ALRT] switch_preinit[1280]: ifup eth0
Apr 14 19:33:07 [ALRT] vlan_add[1294]: macvlan add x86eth100
Apr 14 19:33:07 [ALRT] switch_preinit[1280]: ifup eth1
Apr 14 19:33:07 [ALRT] vlan_add[1300]: macvlan add x86eth200
Apr 14 19:33:08 [ALRT] default_port_status_set[1351]: ioctl(eth0, ETHTOOL_SSET)
Apr 14 19:33:08 [ALRT] default_port_status_set[1351]: ifdown eth0
Apr 14 19:33:08 [ALRT] default_port_status_set[1351]: ioctl(eth1, ETHTOOL_SSET)
Apr 14 19:33:08 [ALRT] default_port_status_set[1351]: ifdown eth1
Apr 14 19:33:08 [INFO] kernel: [    4.745669] br1: port 1(x86eth100) entered blocking state
Apr 14 19:33:08 [INFO] kernel: [    4.747024] br1: port 1(x86eth100) entered disabled state
Apr 14 19:33:08 [INFO] kernel: [    4.748539] device x86eth100 entered promiscuous mode
Apr 14 19:33:08 [INFO] kernel: [    4.749829] device eth0 entered promiscuous mode
Apr 14 19:33:08 [INFO] udhcpc[1546]: started, v1.31.1
Apr 14 19:33:11 [INFO] udhcpc[1546]: sending discover
Apr 14 19:33:13 [ALRT] default_port_status_set[1717]: ioctl(eth1, ETHTOOL_SSET)
Apr 14 19:33:14 [INFO] udhcpc[1546]: sending discover
****************


Also I enabled kernel tracing:

*normal* boot:
***************************************************************************************************
   dwatcher/init-1280  [001] ....     4.336631: e1000_set_mac <-dev_set_mac_address
   dwatcher/init-1280  [001] ....     4.336633: e1000_rar_set <-e1000_set_mac
   dwatcher/init-1280  [001] ....     4.336679: e1000_open <-__dev_open
   dwatcher/init-1280  [001] ....     4.336680: e1000_setup_all_tx_resources <-e1000_open
   dwatcher/init-1280  [001] ....     4.336687: e1000_setup_all_rx_resources <-e1000_open
   dwatcher/init-1280  [001] ....     4.336691: e1000_power_up_phy <-e1000_open
   dwatcher/init-1280  [001] ....     4.336691: e1000_read_phy_reg <-e1000_power_up_phy
   dwatcher/init-1280  [001] ....     4.336755: e1000_write_phy_reg <-e1000_power_up_phy
   dwatcher/init-1280  [001] d...     4.336756: e1000_write_phy_reg_ex <-e1000_write_phy_reg
   dwatcher/init-1280  [001] ....     4.336773: e1000_configure <-e1000_open
   dwatcher/init-1280  [001] ....     4.336773: e1000_set_rx_mode <-e1000_configure
   dwatcher/init-1280  [001] ....     4.336783: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.336816: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.340073: e1000_config_collision_dist <-e1000_configure
   dwatcher/init-1280  [001] ....     4.340097: e1000_setup_rctl <-e1000_configure
   dwatcher/init-1280  [001] ....     4.340105: e1000_configure_rx <-e1000_configure
   dwatcher/init-1280  [001] ....     4.340152: e1000_alloc_rx_buffers <-e1000_configure
   dwatcher/init-1280  [001] ....     4.340168: e1000_request_irq <-e1000_open
   dwatcher/init-1280  [001] ....     4.340238: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1280  [001] ....     4.340247: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] d.h.     4.340252: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1280  [001] ....     4.340318: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] ..s.     4.340344: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     4.340345: e1000_clean_rx_irq <-e1000_clean
   dwatcher/init-1280  [001] ....     4.340792: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1280  [001] ....     4.340802: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.340849: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.340866: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.342538: e1000_watchdog <-process_one_work
     kworker/1:1-23    [001] ....     4.342539: e1000_has_link <-e1000_watchdog
     kworker/1:1-23    [001] ....     4.342539: e1000_check_for_link <-e1000_has_link
     kworker/1:1-23    [001] ....     4.342553: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.342615: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.342677: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.342739: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.342757: e1000_config_fc_after_link_up <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.342757: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.342819: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.342881: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.342943: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.343004: e1000_get_speed_and_duplex <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.343010: e1000_force_mac_fc <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.343019: e1000_get_speed_and_duplex <-e1000_watchdog
     kworker/1:1-23    [001] ....     4.344422: e1000_update_stats <-e1000_watchdog
   dwatcher/init-1280  [000] ....     4.344443: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
   dwatcher/init-1280  [000] ....     4.344445: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
   dwatcher/init-1280  [000] ....     4.344493: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
   dwatcher/init-1280  [000] ....     4.344541: e1000_write_vfta <-e1000_vlan_rx_add_vid
     kworker/1:1-23    [001] d...     4.344784: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:1-23    [001] d...     4.344846: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:1-23    [001] ....     4.344925: e1000_update_adaptive <-e1000_watchdog
        Deuteron-1279  [000] d.h.     4.344941: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1279  [000] ..s.     4.344978: e1000_clean <-net_rx_action
        Deuteron-1279  [000] ..s.     4.344979: e1000_clean_rx_irq <-e1000_clean
        Deuteron-1279  [000] ..s.     4.344979: e1000_update_itr <-e1000_clean
        Deuteron-1279  [000] ..s.     4.344980: e1000_update_itr <-e1000_clean
     kworker/1:1-23    [001] ....     4.346179: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:1-23    [001] ....     4.346190: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.346222: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.346239: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.346256: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [001] .Ns.     4.349430: e1000_xmit_frame <-dev_hard_start_xmit
        Deuteron-1279  [000] d.h.     4.349504: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1279  [000] ..s.     4.349535: e1000_clean <-net_rx_action
        Deuteron-1279  [000] ..s.     4.349536: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
        Deuteron-1279  [000] ..s.     4.349538: e1000_clean_rx_irq <-e1000_clean
        Deuteron-1279  [000] ..s.     4.349538: e1000_update_itr <-e1000_clean
        Deuteron-1279  [000] ..s.     4.349539: e1000_update_itr <-e1000_clean
      dsys/start-1294  [001] ....     4.351818: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1294  [001] ....     4.351830: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.351852: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.351886: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.351903: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.351920: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352400: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1294  [001] ....     4.352409: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352435: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352457: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352474: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352491: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352896: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1294  [001] ....     4.352905: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352930: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352947: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352963: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.352980: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353437: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1294  [001] ....     4.353447: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353472: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353489: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353505: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353522: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353928: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1294  [001] ....     4.353937: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353962: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353978: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.353995: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1294  [001] ....     4.354012: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.355670: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:1-23    [001] ....     4.355680: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.355700: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.355717: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.355734: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.355750: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.356152: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:1-23    [001] ....     4.356161: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.356186: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.356202: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.356219: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.356235: e1000_rar_set <-e1000_set_rx_mode
        Deuteron-1298  [001] .Ns.     4.359325: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] d.h.     4.359377: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] .Ns.     4.359412: e1000_clean <-net_rx_action
          <idle>-0     [000] .Ns.     4.359413: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
          <idle>-0     [000] .Ns.     4.359415: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] .Ns.     4.359415: e1000_update_itr <-e1000_clean
          <idle>-0     [000] .Ns.     4.359416: e1000_update_itr <-e1000_clean
   dwatcher/init-1280  [001] ....     4.361586: e1000_set_mac <-dev_set_mac_address
   dwatcher/init-1280  [001] ....     4.361587: e1000_rar_set <-e1000_set_mac
   dwatcher/init-1280  [001] ....     4.361627: e1000_open <-__dev_open
   dwatcher/init-1280  [001] ....     4.361627: e1000_setup_all_tx_resources <-e1000_open
   dwatcher/init-1280  [001] ....     4.361634: e1000_setup_all_rx_resources <-e1000_open
   dwatcher/init-1280  [001] ....     4.361638: e1000_power_up_phy <-e1000_open
   dwatcher/init-1280  [001] ....     4.361639: e1000_read_phy_reg <-e1000_power_up_phy
   dwatcher/init-1280  [001] ....     4.361702: e1000_write_phy_reg <-e1000_power_up_phy
   dwatcher/init-1280  [001] d...     4.361703: e1000_write_phy_reg_ex <-e1000_write_phy_reg
   dwatcher/init-1280  [001] ....     4.364462: e1000_configure <-e1000_open
   dwatcher/init-1280  [001] ....     4.364462: e1000_set_rx_mode <-e1000_configure
   dwatcher/init-1280  [001] ....     4.364473: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.364491: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.364977: e1000_config_collision_dist <-e1000_configure
   dwatcher/init-1280  [001] ....     4.365001: e1000_setup_rctl <-e1000_configure
   dwatcher/init-1280  [001] ....     4.365009: e1000_configure_rx <-e1000_configure
   dwatcher/init-1280  [001] ....     4.365044: e1000_alloc_rx_buffers <-e1000_configure
   dwatcher/init-1280  [001] ....     4.365058: e1000_request_irq <-e1000_open
          <idle>-0     [000] d.h.     4.365113: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1280  [001] ....     4.365116: e1000_set_rx_mode <-__dev_set_rx_mode
          <idle>-0     [000] d.h.     4.365122: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1280  [001] ....     4.365125: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.365153: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] ..s.     4.365162: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     4.365163: e1000_clean_rx_irq <-e1000_clean
   dwatcher/init-1280  [001] ....     4.365682: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1280  [001] ....     4.365692: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.365710: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1280  [001] ....     4.365727: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.367324: e1000_watchdog <-process_one_work
     kworker/1:1-23    [001] ....     4.367325: e1000_has_link <-e1000_watchdog
     kworker/1:1-23    [001] ....     4.367325: e1000_check_for_link <-e1000_has_link
     kworker/1:1-23    [001] ....     4.367338: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.367400: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.367462: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.367524: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.367542: e1000_config_fc_after_link_up <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.367542: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.367604: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.367666: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.367727: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.367789: e1000_get_speed_and_duplex <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.367795: e1000_force_mac_fc <-e1000_config_fc_after_link_up
     kworker/1:1-23    [001] ....     4.367804: e1000_get_speed_and_duplex <-e1000_watchdog
     kworker/1:1-23    [001] ....     4.369191: e1000_update_stats <-e1000_watchdog
     kworker/1:1-23    [001] d...     4.369508: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:1-23    [001] d...     4.369571: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:1-23    [001] ....     4.369701: e1000_update_adaptive <-e1000_watchdog
           klogd-1291  [000] d.h.     4.369720: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1280  [001] ....     4.369721: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
   dwatcher/init-1280  [001] ....     4.369722: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
           klogd-1291  [000] d.h.     4.369746: e1000_intr <-__handle_irq_event_percpu
           klogd-1291  [000] ..s.     4.369772: e1000_clean <-net_rx_action
           klogd-1291  [000] ..s.     4.369772: e1000_clean_rx_irq <-e1000_clean
           klogd-1291  [000] ..s.     4.369773: e1000_update_itr <-e1000_clean
           klogd-1291  [000] ..s.     4.369773: e1000_update_itr <-e1000_clean
   dwatcher/init-1280  [001] ....     4.369797: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
   dwatcher/init-1280  [001] ....     4.369817: e1000_write_vfta <-e1000_vlan_rx_add_vid
     kworker/1:1-23    [001] ....     4.371089: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:1-23    [001] ....     4.371099: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.371117: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.371134: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.371151: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [001] ..s.     4.372340: e1000_xmit_frame <-dev_hard_start_xmit
        Deuteron-1279  [000] d.h.     4.372385: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1279  [000] d.h.     4.372423: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1279  [000] ..s.     4.372435: e1000_clean <-net_rx_action
        Deuteron-1279  [000] ..s.     4.372436: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
        Deuteron-1279  [000] ..s.     4.372438: e1000_clean_rx_irq <-e1000_clean
        Deuteron-1279  [000] ..s.     4.372439: e1000_update_itr <-e1000_clean
        Deuteron-1279  [000] ..s.     4.372439: e1000_update_itr <-e1000_clean
          <idle>-0     [001] .Ns.     4.374431: e1000_xmit_frame <-dev_hard_start_xmit
      dmsd[wrkr]-1299  [000] d.h.     4.374495: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1299  [000] d.h.     4.374517: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1299  [000] ..s.     4.374545: e1000_clean <-net_rx_action
      dmsd[wrkr]-1299  [000] ..s.     4.374545: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
      dmsd[wrkr]-1299  [000] ..s.     4.374547: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1299  [000] ..s.     4.374547: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1299  [000] ..s.     4.374548: e1000_update_itr <-e1000_clean
      dsys/start-1300  [001] ....     4.377987: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1300  [001] ....     4.377999: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378017: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378034: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378051: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378068: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378536: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1300  [001] ....     4.378545: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378563: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378581: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378598: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.378614: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379051: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1300  [001] ....     4.379059: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379076: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379093: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379110: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379127: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379592: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1300  [001] ....     4.379602: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379619: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379636: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379653: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.379670: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.380085: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1300  [001] ....     4.380093: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.380110: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.380127: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.380144: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ....     4.380161: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.381805: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:1-23    [001] ....     4.381815: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.381832: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.381849: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.381866: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.381883: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.382352: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:1-23    [001] ....     4.382361: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.382378: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.382395: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.382412: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.382428: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1300  [001] ..s.     4.386216: e1000_xmit_frame <-dev_hard_start_xmit
        Deuteron-1279  [000] d.h.     4.386277: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1279  [000] d.h.     4.386287: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1279  [000] ..s.     4.386364: e1000_clean <-net_rx_action
        Deuteron-1279  [000] ..s.     4.386365: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
        Deuteron-1279  [000] ..s.     4.386366: e1000_clean_rx_irq <-e1000_clean
        Deuteron-1279  [000] ..s.     4.386367: e1000_update_itr <-e1000_clean
        Deuteron-1279  [000] ..s.     4.386367: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1299  [001] ..s.     4.390329: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] d.h.     4.390390: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.     4.390398: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] .Ns.     4.390432: e1000_clean <-net_rx_action
          <idle>-0     [000] .Ns.     4.390433: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
          <idle>-0     [000] .Ns.     4.390434: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] .Ns.     4.390435: e1000_update_itr <-e1000_clean
          <idle>-0     [000] .Ns.     4.390435: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1351  [001] ....     4.485965: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1351  [001] ....     4.485977: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.485986: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1351  [001] ....     4.485988: e1000_get_link <-dev_ethtool
      dmsd[wrkr]-1351  [001] ....     4.485988: e1000_has_link <-e1000_get_link
      dmsd[wrkr]-1351  [001] ....     4.486001: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1351  [001] ....     4.486008: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.486086: e1000_set_link_ksettings <-ethtool_set_settings
      dmsd[wrkr]-1351  [001] ....     4.486087: e1000_down <-e1000_set_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.497495: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.497499: e1000_reset <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.497506: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.509397: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.509404: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.516587: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.516594: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.516594: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.516610: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.516673: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.516730: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.516844: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.516902: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517016: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517073: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517132: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.517194: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517251: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517370: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517427: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517541: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517598: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517712: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517769: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517883: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.517941: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518055: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518112: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518171: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.518177: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518239: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518305: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518368: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518425: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518487: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518544: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518607: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518664: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518726: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518783: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518853: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518910: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.518972: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519029: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519091: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519148: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519211: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519268: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519365: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519422: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519484: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519541: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519603: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519660: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519722: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519780: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519842: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519899: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.519961: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.520018: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.520080: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.520138: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.520371: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.520494: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.521414: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.522629: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.522638: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.522700: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.522701: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.522718: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.522780: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.522780: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.522797: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.522797: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] ....     4.522859: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] d...     4.522859: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.522877: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.522877: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.522939: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.523001: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.523001: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.523018: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.523018: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.523035: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523097: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.523097: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.523130: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523206: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523311: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523376: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523449: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523512: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523582: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523642: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523712: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523772: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523843: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523903: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.523973: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524033: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524103: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524163: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524234: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524327: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524398: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524458: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.524824: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.524826: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.524828: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.524828: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] ....     4.524889: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] ....     4.524949: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.524950: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.524950: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
.................
      dmsd[wrkr]-1351  [001] ....     4.524991: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.524991: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.524999: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.525010: e1000_up <-e1000_set_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.525011: e1000_configure <-e1000_up
      dmsd[wrkr]-1351  [001] ....     4.525011: e1000_set_rx_mode <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.525019: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525034: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525048: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525062: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525077: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525496: e1000_vlan_filter_on_off <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.525518: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dmsd[wrkr]-1351  [001] ....     4.525519: e1000_vlan_rx_add_vid <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.525525: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dmsd[wrkr]-1351  [001] ....     4.525560: e1000_config_collision_dist <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.525584: e1000_setup_rctl <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.525592: e1000_configure_rx <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.525627: e1000_alloc_rx_buffers <-e1000_configure
          <idle>-0     [000] d.h.     4.525704: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.     4.525748: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] .Ns.     4.525769: e1000_clean <-net_rx_action
          <idle>-0     [000] .Ns.     4.525770: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1351  [001] ....     4.525801: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525813: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525844: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525861: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525878: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.525894: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:1-23    [001] ....     4.528158: e1000_watchdog <-process_one_work
     kworker/1:1-23    [001] ....     4.528158: e1000_has_link <-e1000_watchdog
     kworker/1:1-23    [001] ....     4.528159: e1000_check_for_link <-e1000_has_link
     kworker/1:1-23    [001] ....     4.528172: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.528234: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.528346: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/1:1-23    [001] ....     4.528347: e1000_update_stats <-e1000_watchdog
     kworker/1:1-23    [001] ....     4.528347: e1000_update_adaptive <-e1000_watchdog
          <idle>-0     [000] d.H.     4.528384: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.H.     4.528408: e1000_intr <-__handle_irq_event_percpu
     ksoftirqd/0-9     [000] ..s.     4.528481: e1000_clean <-net_rx_action
     ksoftirqd/0-9     [000] ..s.     4.528482: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1351  [001] ....     4.528506: e1000_close <-__dev_close_many
      dmsd[wrkr]-1351  [001] ....     4.528507: e1000_down <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.540584: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.540586: e1000_reset <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.540588: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.552527: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.552532: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.559398: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.559405: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.559406: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.559422: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.559484: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.559541: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.559655: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.559713: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.559827: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.559884: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.559943: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.560006: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560063: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560179: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560236: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560365: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560423: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560537: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560594: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560708: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560766: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560881: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560939: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.560998: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.561003: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561065: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561122: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561185: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561242: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561334: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561391: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561455: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561512: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561574: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561631: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561694: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561751: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561813: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561871: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561933: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.561990: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562052: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562110: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562172: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562238: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562318: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562377: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562441: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562499: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562564: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562623: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562687: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562745: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562809: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562868: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562932: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.562990: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.563229: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.563373: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.564330: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.565462: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.565469: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.565530: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.565530: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.565546: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.565606: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.565606: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.565622: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.565622: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] ....     4.565682: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] d...     4.565682: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.565698: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.565699: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.565759: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.565819: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.565819: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.565834: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.565835: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.565850: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.565910: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.565910: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.565940: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566001: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566071: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566132: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566202: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566262: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566366: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566427: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566497: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566557: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566627: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566687: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566758: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566818: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566888: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.566948: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.567018: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.567078: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.567149: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.567209: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] .N..     4.567602: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1351  [001] .N..     4.567605: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1351  [001] .N..     4.567607: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1351  [001] .N..     4.567607: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] .N..     4.567667: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] .N..     4.567728: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] .N..     4.567728: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] .N..     4.567728: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
..................
      dmsd[wrkr]-1351  [001] .N..     4.567769: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] .N..     4.567769: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] .N..     4.567778: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] .N..     4.567788: e1000_power_down_phy <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.567802: e1000_free_tx_resources <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.567802: e1000_clean_tx_ring <-e1000_free_tx_resources
      dmsd[wrkr]-1351  [001] ....     4.567803: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.567803: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
...................
      dmsd[wrkr]-1351  [001] ....     4.567844: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.567844: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.567854: e1000_free_rx_resources <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.567854: e1000_clean_rx_ring <-e1000_free_rx_resources
      dmsd[wrkr]-1351  [001] ....     4.568528: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1351  [001] ....     4.568537: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.568544: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1351  [001] ....     4.568546: e1000_get_link <-dev_ethtool
      dmsd[wrkr]-1351  [001] ....     4.568546: e1000_has_link <-e1000_get_link
      dmsd[wrkr]-1351  [001] ....     4.568554: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1351  [001] ....     4.568560: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.568609: e1000_set_link_ksettings <-ethtool_set_settings
      dmsd[wrkr]-1351  [001] ....     4.568609: e1000_down <-e1000_set_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.580584: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.580586: e1000_reset <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.580588: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.592430: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.592435: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.599587: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.599593: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.599593: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.599609: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.599672: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.599730: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.599844: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.599901: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600015: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600072: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600131: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.600193: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600251: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600369: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600426: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600540: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600598: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600712: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600769: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600883: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.600940: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601054: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601111: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601170: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.601176: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601238: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601324: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601387: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601444: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601507: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601564: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601626: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601684: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601746: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601803: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601865: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601923: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.601985: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602042: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602104: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602162: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602224: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602306: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602369: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602427: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602491: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602550: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602614: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602672: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602737: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602795: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602859: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602918: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.602984: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.603042: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.603106: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.603165: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.603428: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.603554: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.604521: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.605661: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.605668: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.605729: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.605729: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.605745: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.605805: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.605805: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.605820: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.605820: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] ....     4.605881: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] d...     4.605881: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.605897: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.605897: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.605957: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.606017: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.606018: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.606033: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.606033: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.606048: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606108: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.606108: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.606124: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606184: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606255: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606349: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606420: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606480: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606550: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606610: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606681: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606741: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606811: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606871: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.606942: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607002: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607072: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607132: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607203: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607263: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607366: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607427: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.607795: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.607797: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.607799: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.607799: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] ....     4.607860: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] ....     4.607920: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.607920: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.607921: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
.................
      dmsd[wrkr]-1351  [001] ....     4.607961: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.607962: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.607970: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.607981: e1000_up <-e1000_set_link_ksettings
      dmsd[wrkr]-1351  [001] ....     4.607981: e1000_configure <-e1000_up
      dmsd[wrkr]-1351  [001] ....     4.607981: e1000_set_rx_mode <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.607989: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608004: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608019: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608033: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608047: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608433: e1000_vlan_filter_on_off <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.608447: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dmsd[wrkr]-1351  [001] ....     4.608447: e1000_vlan_rx_add_vid <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.608453: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dmsd[wrkr]-1351  [001] ....     4.608483: e1000_config_collision_dist <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.608503: e1000_setup_rctl <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.608510: e1000_configure_rx <-e1000_configure
      dmsd[wrkr]-1351  [001] ....     4.608539: e1000_alloc_rx_buffers <-e1000_configure
     ksoftirqd/1-15    [001] ..s.     4.608610: e1000_xmit_frame <-dev_hard_start_xmit
      dmsd[wrkr]-1351  [001] ....     4.608706: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608717: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] d.h.     4.608738: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1351  [001] ....     4.608764: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608781: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] .Ns.     4.608810: e1000_clean <-net_rx_action
          <idle>-0     [000] .Ns.     4.608811: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1351  [001] ....     4.608813: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1351  [001] ....     4.608836: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     4.610452: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....     4.610453: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....     4.610453: e1000_check_for_link <-e1000_has_link
     kworker/0:1-33    [000] ....     4.610480: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     4.610553: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     4.610616: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-33    [000] ....     4.610616: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] ....     4.610616: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] ....     4.610619: e1000_reset_task <-process_one_work
     kworker/0:1-33    [000] ....     4.611720: e1000_reinit_locked <-e1000_reset_task
     kworker/0:1-33    [000] ....     4.611721: e1000_down <-e1000_reinit_locked
      dmsd[wrkr]-1351  [001] ....     4.612042: e1000_close <-__dev_close_many
     kworker/0:1-33    [000] ....     4.623581: e1000_down_and_stop <-e1000_down
     kworker/0:1-33    [000] ....     4.623582: e1000_reset <-e1000_down
     kworker/0:1-33    [000] ....     4.623585: e1000_reset_hw <-e1000_reset
     kworker/0:1-33    [000] ....     4.635572: e1000_io_write <-e1000_reset_hw
     kworker/0:1-33    [000] ....     4.635578: e1000_io_write <-e1000_reset_hw
     kworker/0:1-33    [000] ....     4.642423: e1000_init_hw <-e1000_reset
     kworker/0:1-33    [000] ....     4.642430: e1000_read_eeprom <-e1000_init_hw
     kworker/0:1-33    [000] ....     4.642431: e1000_acquire_eeprom <-e1000_read_eeprom
     kworker/0:1-33    [000] ....     4.642449: e1000_shift_out_ee_bits <-e1000_read_eeprom
     kworker/0:1-33    [000] ....     4.642513: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.642572: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.642688: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.642746: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.642863: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.642921: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.642981: e1000_shift_out_ee_bits <-e1000_read_eeprom
     kworker/0:1-33    [000] ....     4.643046: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643104: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643220: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643323: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643440: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643499: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643622: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643679: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643793: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643850: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.643964: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.644021: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
     kworker/0:1-33    [000] ....     4.644080: e1000_shift_in_ee_bits <-e1000_read_eeprom
     kworker/0:1-33    [000] ....     4.644085: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644148: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644205: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644267: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644358: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644421: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644478: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644540: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644597: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644659: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644716: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644778: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644835: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644897: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.644954: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645016: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645073: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645135: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645192: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645254: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645311: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645374: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645431: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645494: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645551: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645616: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645674: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645738: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645797: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645861: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645919: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.645983: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
     kworker/0:1-33    [000] ....     4.646042: e1000_standby_eeprom <-e1000_read_eeprom
     kworker/0:1-33    [000] ....     4.646311: e1000_release_eeprom <-e1000_read_eeprom
     kworker/0:1-33    [000] ....     4.646438: e1000_set_media_type <-e1000_init_hw
     kworker/0:1-33    [000] ....     4.647430: e1000_rar_set <-e1000_init_hw
     kworker/0:1-33    [000] ....     4.648546: e1000_setup_link <-e1000_init_hw
     kworker/0:1-33    [000] ....     4.648553: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.648613: e1000_write_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] d...     4.648614: e1000_write_phy_reg_ex <-e1000_write_phy_reg
     kworker/0:1-33    [000] ....     4.648629: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.648689: e1000_write_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] d...     4.648689: e1000_write_phy_reg_ex <-e1000_write_phy_reg
     kworker/0:1-33    [000] ....     4.648704: e1000_phy_reset <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.648704: e1000_read_phy_reg <-e1000_phy_reset
     kworker/0:1-33    [000] ....     4.648764: e1000_write_phy_reg <-e1000_phy_reset
     kworker/0:1-33    [000] d...     4.648764: e1000_write_phy_reg_ex <-e1000_write_phy_reg
     kworker/0:1-33    [000] ....     4.648780: e1000_phy_setup_autoneg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.648781: e1000_read_phy_reg <-e1000_phy_setup_autoneg
     kworker/0:1-33    [000] ....     4.648841: e1000_read_phy_reg <-e1000_phy_setup_autoneg
     kworker/0:1-33    [000] ....     4.648901: e1000_write_phy_reg <-e1000_phy_setup_autoneg
     kworker/0:1-33    [000] d...     4.648901: e1000_write_phy_reg_ex <-e1000_write_phy_reg
     kworker/0:1-33    [000] ....     4.648916: e1000_write_phy_reg <-e1000_phy_setup_autoneg
     kworker/0:1-33    [000] d...     4.648917: e1000_write_phy_reg_ex <-e1000_write_phy_reg
     kworker/0:1-33    [000] ....     4.648932: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.648992: e1000_write_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] d...     4.648992: e1000_write_phy_reg_ex <-e1000_write_phy_reg
     kworker/0:1-33    [000] ....     4.649007: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649068: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649138: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649198: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649268: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649363: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649434: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649494: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649564: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649624: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649694: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649754: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649824: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649884: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.649954: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.650014: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.650084: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.650144: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.650215: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.650309: e1000_read_phy_reg <-e1000_setup_link
     kworker/0:1-33    [000] ....     4.650673: e1000_update_mng_vlan <-e1000_reset
     kworker/0:1-33    [000] ....     4.650675: e1000_reset_adaptive <-e1000_reset
     kworker/0:1-33    [000] ....     4.650677: e1000_phy_get_info <-e1000_reset
     kworker/0:1-33    [000] ....     4.650677: e1000_read_phy_reg <-e1000_phy_get_info
     kworker/0:1-33    [000] ....     4.650738: e1000_read_phy_reg <-e1000_phy_get_info
     kworker/0:1-33    [000] ....     4.650798: e1000_clean_tx_ring <-e1000_down
     kworker/0:1-33    [000] ....     4.650798: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
     kworker/0:1-33    [000] ....     4.650800: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
..................
     kworker/0:1-33    [000] ....     4.650843: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
     kworker/0:1-33    [000] ....     4.650843: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
     kworker/0:1-33    [000] ....     4.650851: e1000_clean_rx_ring <-e1000_down
     kworker/0:1-33    [000] ....     4.650862: e1000_up <-e1000_reinit_locked
     kworker/0:1-33    [000] ....     4.650862: e1000_configure <-e1000_up
     kworker/0:1-33    [000] ....     4.650863: e1000_set_rx_mode <-e1000_configure
     kworker/0:1-33    [000] ....     4.650871: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     4.650885: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     4.650900: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     4.650914: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     4.650928: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     4.651309: e1000_vlan_filter_on_off <-e1000_configure
     kworker/0:1-33    [000] ....     4.651323: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
     kworker/0:1-33    [000] ....     4.651324: e1000_vlan_rx_add_vid <-e1000_configure
     kworker/0:1-33    [000] ....     4.651329: e1000_write_vfta <-e1000_vlan_rx_add_vid
     kworker/0:1-33    [000] ....     4.651359: e1000_config_collision_dist <-e1000_configure
     kworker/0:1-33    [000] ....     4.651379: e1000_setup_rctl <-e1000_configure
     kworker/0:1-33    [000] ....     4.651386: e1000_configure_rx <-e1000_configure
     kworker/0:1-33    [000] ....     4.651415: e1000_alloc_rx_buffers <-e1000_configure
     kworker/0:1-33    [000] dNh.     4.651468: e1000_intr <-__handle_irq_event_percpu
     ksoftirqd/0-9     [000] ..s.     4.651492: e1000_clean <-net_rx_action
     ksoftirqd/0-9     [000] ..s.     4.651492: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1351  [001] ....     4.652460: e1000_down <-e1000_close
     kworker/0:1-33    [000] ....     4.653436: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....     4.653436: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....     4.653437: e1000_check_for_link <-e1000_has_link
     kworker/0:1-33    [000] ....     4.653450: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     4.653512: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     4.653572: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-33    [000] ....     4.653573: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] ....     4.653573: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] d.h.     4.653591: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s.     4.653629: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s.     4.653629: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1351  [001] ....     4.664444: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.664445: e1000_reset <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.664447: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.676606: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.676612: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1351  [001] ....     4.683585: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.683592: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.683592: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.683608: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.683671: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.683728: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.683842: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.683899: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684014: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684071: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684130: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.684192: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684249: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684384: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684441: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684556: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684613: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684727: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684785: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684899: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.684956: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685080: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685137: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685197: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.685204: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685268: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685367: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685432: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685490: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685555: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685613: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685678: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685736: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685800: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685858: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685923: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.685981: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686045: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686104: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686168: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686226: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686317: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686376: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686439: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686497: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686559: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686616: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686678: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686735: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686797: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686854: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686917: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.686974: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.687036: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.687093: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.687155: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1351  [001] ....     4.687213: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.687477: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1351  [001] ....     4.687600: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.688533: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.689664: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1351  [001] ....     4.689671: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.689732: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.689732: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.689748: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.689808: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.689808: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.689823: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.689823: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] ....     4.689883: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1351  [001] d...     4.689884: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.689900: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.689900: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.689960: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] ....     4.690020: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.690020: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.690035: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1351  [001] d...     4.690036: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.690051: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690111: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] d...     4.690111: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1351  [001] ....     4.690127: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690187: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690257: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690351: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690422: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690482: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690552: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690613: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690683: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690743: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690813: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690873: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.690943: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691003: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691074: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691134: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691204: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691264: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691368: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691428: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1351  [001] ....     4.691801: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.691803: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.691805: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1351  [001] ....     4.691805: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] ....     4.691865: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1351  [001] ....     4.691926: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.691926: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.691926: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
....................
      dmsd[wrkr]-1351  [001] ....     4.691969: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.691969: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.691978: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1351  [001] ....     4.691989: e1000_power_down_phy <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.692018: e1000_free_tx_resources <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.692018: e1000_clean_tx_ring <-e1000_free_tx_resources
      dmsd[wrkr]-1351  [001] ....     4.692018: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.692018: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
........................
      dmsd[wrkr]-1351  [001] ....     4.692059: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.692059: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1351  [001] ....     4.692070: e1000_free_rx_resources <-e1000_close
      dmsd[wrkr]-1351  [001] ....     4.692070: e1000_clean_rx_ring <-e1000_free_rx_resources
       dlinkwtch-1358  [001] ....     4.706267: e1000_get_link_ksettings <-ethtool_get_settings
       dlinkwtch-1358  [001] ....     4.706318: e1000_get_pauseparam <-dev_ethtool
       dlinkwtch-1358  [001] ....     4.706331: e1000_get_link_ksettings <-ethtool_get_settings
       dlinkwtch-1358  [001] ....     4.706340: e1000_get_pauseparam <-dev_ethtool
      dsys/start-1507  [001] .N..     4.962493: e1000_vlan_rx_kill_vid <-vlan_kill_rx_filter_info
      dsys/start-1507  [001] .N..     4.962503: e1000_write_vfta <-e1000_vlan_rx_kill_vid
      dsys/start-1507  [001] .N..     4.962512: e1000_vlan_filter_on_off <-e1000_vlan_rx_kill_vid
      dsys/start-1507  [001] ....     4.964096: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
      dsys/start-1507  [001] ....     4.964097: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
      dsys/start-1507  [001] ....     4.964117: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dsys/start-1507  [001] ....     4.964124: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dsys/start-1512  [001] .N..     4.977565: e1000_vlan_rx_kill_vid <-vlan_kill_rx_filter_info
      dsys/start-1512  [001] .N..     4.977590: e1000_write_vfta <-e1000_vlan_rx_kill_vid
      dsys/start-1512  [001] .N..     4.977615: e1000_vlan_filter_on_off <-e1000_vlan_rx_kill_vid
      dsys/start-1512  [001] ....     4.979326: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
      dsys/start-1512  [001] ....     4.979327: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
      dsys/start-1512  [001] ....     4.979346: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dsys/start-1512  [001] ....     4.979353: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dsys/start-1530  [001] ....     5.014807: e1000_get_link_ksettings <-__ethtool_get_link_ksettings
      dsys/start-1530  [001] ....     5.017576: e1000_fix_features <-__netdev_update_features
      dmsd[wrkr]-1717  [001] ....     9.128882: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1717  [001] ....     9.128893: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1717  [001] ....     9.128901: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1717  [001] ....     9.128924: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1717  [001] ....     9.128931: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1717  [001] ....     9.130929: e1000_set_link_ksettings <-ethtool_set_settings
      dmsd[wrkr]-1717  [001] ....     9.130930: e1000_reset <-e1000_set_link_ksettings
      dmsd[wrkr]-1717  [001] ....     9.130934: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1717  [001] ....     9.142453: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1717  [001] ....     9.142460: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1717  [001] ....     9.149386: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1717  [001] ....     9.149393: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1717  [001] ....     9.149393: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1717  [001] ....     9.149410: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1717  [001] ....     9.149472: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.149529: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.149644: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.149701: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.149815: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.149872: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.149931: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1717  [001] ....     9.149994: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150051: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150165: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150222: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150364: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150422: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150536: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150593: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150708: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150767: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150883: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.150941: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151002: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1717  [001] ....     9.151008: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151072: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151131: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151195: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151253: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151317: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151376: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151440: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151498: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151562: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151621: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151685: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151743: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151807: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151866: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151936: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.151993: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152055: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152113: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152180: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152237: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152312: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152369: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152431: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152489: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152551: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152608: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152670: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152727: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152790: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152847: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152909: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1717  [001] ....     9.152966: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1717  [001] ....     9.153199: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1717  [001] ....     9.153320: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1717  [001] ....     9.154415: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1717  [001] ....     9.155593: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1717  [001] ....     9.155600: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.155661: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] d...     9.155661: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [001] ....     9.155676: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.155736: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] d...     9.155736: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [001] ....     9.155751: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.155752: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1717  [001] ....     9.155812: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1717  [001] d...     9.155812: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [001] ....     9.155828: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.155828: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1717  [001] ....     9.155888: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1717  [001] ....     9.155948: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1717  [001] d...     9.155949: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [001] ....     9.155964: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1717  [001] d...     9.155964: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [001] ....     9.155979: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156039: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] d...     9.156039: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [001] ....     9.156069: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156130: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156200: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156260: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156364: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156425: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156495: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156555: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156625: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156685: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156756: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156816: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156886: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.156946: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157016: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157076: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157146: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157206: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157305: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157365: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1717  [001] ....     9.157734: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1717  [001] ....     9.157736: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1717  [001] ....     9.157738: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1717  [001] ....     9.157738: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1717  [001] ....     9.157799: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1717  [000] ....     9.159515: e1000_open <-__dev_open
      dmsd[wrkr]-1717  [000] ....     9.159517: e1000_setup_all_tx_resources <-e1000_open
      dmsd[wrkr]-1717  [000] ....     9.159524: e1000_setup_all_rx_resources <-e1000_open
      dmsd[wrkr]-1717  [000] ....     9.159529: e1000_power_up_phy <-e1000_open
      dmsd[wrkr]-1717  [000] ....     9.159529: e1000_read_phy_reg <-e1000_power_up_phy
      dmsd[wrkr]-1717  [000] ....     9.159596: e1000_write_phy_reg <-e1000_power_up_phy
      dmsd[wrkr]-1717  [000] d...     9.159596: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1717  [000] ....     9.159614: e1000_configure <-e1000_open
      dmsd[wrkr]-1717  [000] ....     9.159614: e1000_set_rx_mode <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.159624: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.159642: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.160101: e1000_vlan_filter_on_off <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.160117: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dmsd[wrkr]-1717  [000] ....     9.160118: e1000_vlan_rx_add_vid <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.160125: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dmsd[wrkr]-1717  [000] ....     9.160160: e1000_config_collision_dist <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.160183: e1000_setup_rctl <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.160192: e1000_configure_rx <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.160227: e1000_alloc_rx_buffers <-e1000_configure
      dmsd[wrkr]-1717  [000] ....     9.160241: e1000_request_irq <-e1000_open
      dmsd[wrkr]-1717  [000] d.h.     9.160425: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1717  [000] ..s.     9.160453: e1000_clean <-net_rx_action
      dmsd[wrkr]-1717  [000] ..s.     9.160454: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1717  [000] ..s.     9.160454: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1717  [000] ..s.     9.160455: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1717  [000] ....     9.160471: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.160480: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.160498: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.160990: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.161000: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1717  [000] ....     9.161017: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     9.162649: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....     9.162650: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....     9.162650: e1000_check_for_link <-e1000_has_link
     kworker/0:1-33    [000] ....     9.162663: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     9.162725: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     9.162788: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-33    [000] ....     9.162788: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] d...     9.163095: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] d...     9.163157: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] ....     9.163236: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] d.h.     9.163252: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s.     9.163332: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s.     9.163332: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] ..s.     9.163333: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ..s.     9.163333: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1718  [000] ....     9.170194: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1718  [000] ....     9.170209: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1718  [000] ....     9.170218: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1718  [000] ....     9.170243: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1718  [000] ....     9.170251: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1718  [000] ....     9.170377: e1000_set_link_ksettings <-ethtool_set_settings
      dmsd[wrkr]-1718  [000] ....     9.170378: e1000_reset <-e1000_set_link_ksettings
      dmsd[wrkr]-1718  [000] ....     9.170381: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1718  [000] ....     9.182473: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1718  [000] ....     9.182479: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1718  [000] ....     9.189439: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1718  [000] ....     9.189445: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1718  [000] ....     9.189446: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1718  [000] ....     9.189462: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1718  [000] ....     9.189524: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.189581: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.189695: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.189752: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.189866: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.189923: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.189982: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1718  [000] ....     9.190044: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190101: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190215: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190307: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190421: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190478: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190592: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190650: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190763: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190821: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190934: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.190992: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191050: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1718  [000] ....     9.191056: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191118: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191175: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191237: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191305: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191367: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191424: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191486: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191544: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191606: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191663: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191725: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191782: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191844: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191901: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.191963: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192020: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192082: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192139: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192202: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192259: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192322: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192379: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192441: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192498: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192560: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192617: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192679: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192736: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192798: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192855: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192917: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1718  [000] ....     9.192974: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1718  [000] ....     9.193207: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1718  [000] ....     9.193364: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1718  [000] ....     9.194240: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1718  [000] ....     9.195384: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1718  [000] ....     9.195391: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195452: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] d...     9.195465: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.195480: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195540: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] d...     9.195541: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.195556: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195556: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1718  [000] ....     9.195616: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1718  [000] d...     9.195616: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.195632: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195633: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1718  [000] ....     9.195693: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1718  [000] ....     9.195753: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1718  [000] d...     9.195753: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.195768: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1718  [000] d...     9.195768: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.195783: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195843: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] d...     9.195843: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.195859: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195919: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.195989: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196049: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196119: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196179: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196250: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196343: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196414: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196474: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196544: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196604: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196674: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196734: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196804: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196864: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196934: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.196994: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.197064: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.197124: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1718  [000] ....     9.197519: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1718  [000] ....     9.197522: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1718  [000] ....     9.197523: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1718  [000] ....     9.197524: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1718  [000] ....     9.197584: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1718  [000] ....     9.197757: e1000_open <-__dev_open
      dmsd[wrkr]-1718  [000] ....     9.197757: e1000_setup_all_tx_resources <-e1000_open
      dmsd[wrkr]-1718  [000] ....     9.197765: e1000_setup_all_rx_resources <-e1000_open
      dmsd[wrkr]-1718  [000] ....     9.197768: e1000_power_up_phy <-e1000_open
      dmsd[wrkr]-1718  [000] ....     9.197769: e1000_read_phy_reg <-e1000_power_up_phy
      dmsd[wrkr]-1718  [000] ....     9.197832: e1000_write_phy_reg <-e1000_power_up_phy
      dmsd[wrkr]-1718  [000] d...     9.197832: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1718  [000] ....     9.197847: e1000_configure <-e1000_open
      dmsd[wrkr]-1718  [000] ....     9.197848: e1000_set_rx_mode <-e1000_configure
      dmsd[wrkr]-1718  [000] ....     9.197855: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1718  [000] .N..     9.198610: e1000_vlan_filter_on_off <-e1000_configure
      dmsd[wrkr]-1718  [000] .N..     9.198627: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dmsd[wrkr]-1718  [000] .N..     9.198627: e1000_vlan_rx_add_vid <-e1000_configure
      dmsd[wrkr]-1718  [000] .N..     9.198645: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dmsd[wrkr]-1718  [000] .N..     9.198692: e1000_config_collision_dist <-e1000_configure
      dmsd[wrkr]-1718  [000] .N..     9.198744: e1000_setup_rctl <-e1000_configure
      dmsd[wrkr]-1718  [000] .N..     9.198762: e1000_configure_rx <-e1000_configure
      dmsd[wrkr]-1718  [000] .N..     9.198805: e1000_alloc_rx_buffers <-e1000_configure
      dmsd[wrkr]-1718  [000] .N..     9.198821: e1000_request_irq <-e1000_open
      dmsd[wrkr]-1718  [000] d.h.     9.198895: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1718  [000] d.h.     9.198902: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1718  [000] ..s.     9.198951: e1000_clean <-net_rx_action
      dmsd[wrkr]-1718  [000] ..s.     9.198951: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1718  [000] ..s.     9.198952: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1718  [000] ..s.     9.198952: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1718  [000] ....     9.198985: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1718  [000] ....     9.198995: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1718  [000] ....     9.199741: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1718  [000] ....     9.199751: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....     9.201479: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....     9.201479: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....     9.201479: e1000_check_for_link <-e1000_has_link
     kworker/0:1-33    [000] ....     9.201493: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     9.201555: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....     9.201617: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-33    [000] ....     9.201618: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] d...     9.201924: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] d...     9.201986: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] ....     9.202065: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] d.h.     9.202081: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] d.h.     9.202089: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s.     9.202133: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s.     9.202133: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] ..s.     9.202133: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ..s.     9.202134: e1000_update_itr <-e1000_clean
          <idle>-0     [000] d.h.     9.656710: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.     9.656738: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.     9.656752: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     9.656753: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.     9.656754: e1000_update_itr <-e1000_clean
          <idle>-0     [000] ..s.     9.656754: e1000_update_itr <-e1000_clean
          <idle>-0     [000] d.h.     9.695295: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.     9.695303: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.     9.695331: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     9.695332: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.     9.695333: e1000_update_itr <-e1000_clean
          <idle>-0     [000] ..s.     9.695333: e1000_update_itr <-e1000_clean
          <idle>-0     [000] d.h.    10.161717: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.    10.161743: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.    10.161758: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.    10.161759: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.    10.161769: e1000_rx_checksum.isra.46 <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    10.161783: e1000_rx_checksum.isra.46 <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    10.161785: e1000_rx_checksum.isra.46 <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    10.161787: e1000_rx_checksum.isra.46 <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    10.161788: e1000_alloc_rx_buffers <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    10.161792: e1000_update_itr <-e1000_clean
          <idle>-0     [000] .Ns.    10.161792: e1000_update_itr <-e1000_clean
          <idle>-0     [000] d.h.    11.133927: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.    11.133954: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.    11.133967: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.    11.133968: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.    11.133969: e1000_rx_checksum.isra.46 <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    11.133981: e1000_alloc_rx_buffers <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    11.133985: e1000_update_itr <-e1000_clean
          <idle>-0     [000] .Ns.    11.133985: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    11.175433: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....    11.175434: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....    11.175434: e1000_check_for_link <-e1000_has_link
     kworker/0:1-33    [000] ....    11.175448: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.175532: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.175594: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.175656: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.175674: e1000_config_fc_after_link_up <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.175674: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.175736: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.175798: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.175860: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.175922: e1000_get_speed_and_duplex <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.175928: e1000_force_mac_fc <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.175940: e1000_get_speed_and_duplex <-e1000_watchdog
     kworker/0:1-33    [000] ....    11.177328: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] d...    11.177638: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] d...    11.177700: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] ....    11.177779: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] d.h.    11.177795: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] d.h.    11.177834: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s.    11.177848: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s.    11.177849: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] ..s.    11.177849: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ..s.    11.177849: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] .N..    11.179067: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179078: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179117: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179136: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179630: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179639: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179669: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.179687: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.180127: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.180136: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.180165: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.180183: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.180200: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.182092: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.182102: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.182146: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.182183: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.182200: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.182680: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.182688: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.182720: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.182738: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.182755: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183179: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183188: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183213: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183231: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183248: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183723: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183732: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183757: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183776: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.183792: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184369: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.184380: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184412: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184431: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184448: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184464: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184870: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.184880: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184914: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184932: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184949: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.184965: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.185407: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.185427: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.185473: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.185493: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.185513: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.185530: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.239367: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....    11.239368: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....    11.239368: e1000_check_for_link <-e1000_has_link
     kworker/0:1-33    [000] ....    11.239380: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.239441: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.239501: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.239561: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.239577: e1000_config_fc_after_link_up <-e1000_check_for_link
     kworker/0:1-33    [000] ....    11.239577: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.239637: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.239697: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.239758: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.239818: e1000_get_speed_and_duplex <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.239823: e1000_force_mac_fc <-e1000_config_fc_after_link_up
     kworker/0:1-33    [000] ....    11.239830: e1000_get_speed_and_duplex <-e1000_watchdog
     kworker/0:1-33    [000] ....    11.241203: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] d...    11.241512: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] d...    11.241575: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] .N..    11.241705: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] dNh.    11.241722: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] dNh.    11.241750: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] .Ns.    11.241777: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] .Ns.    11.241778: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] .Ns.    11.241778: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] .Ns.    11.241779: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    11.243092: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.243102: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.243120: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.243626: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.243634: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.243651: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.244102: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.244111: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.244128: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.244145: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.246003: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.246014: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.246032: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.246049: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.246552: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.246561: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.246578: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.246595: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247033: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247042: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247059: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247075: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247554: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247563: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247580: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] .N..    11.247596: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.248076: e1000_get_link_ksettings <-__ethtool_get_link_ksettings
     kworker/0:1-33    [000] ....    11.248083: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
     kworker/0:1-33    [000] ....    11.250255: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.250265: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.250325: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.250342: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.250359: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252003: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.252014: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252031: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252048: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252065: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252535: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    11.252543: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252560: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252577: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    11.252593: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] ..s.    11.255438: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] d.H.    11.255519: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.H.    11.255538: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.    11.255580: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.    11.255581: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
          <idle>-0     [000] ..s.    11.255581: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.    11.255582: e1000_update_itr <-e1000_clean
          <idle>-0     [000] ..s.    11.255582: e1000_update_itr <-e1000_clean
          <idle>-0     [000] ..s.    11.399373: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] d.H.    11.399456: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.H.    11.399489: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.    11.399530: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.    11.399530: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
          <idle>-0     [000] ..s.    11.399532: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.    11.399532: e1000_update_itr <-e1000_clean
          <idle>-0     [000] ..s.    11.399533: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    11.431573: e1000_xmit_frame <-dev_hard_start_xmit
     kworker/0:1-33    [000] d.h.    11.431622: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] d.h.    11.431640: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s1    11.431666: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s1    11.431666: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
     kworker/0:1-33    [000] ..s1    11.431668: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] ..s1    11.431668: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ..s1    11.431668: e1000_update_itr <-e1000_clean
          <idle>-0     [000] d.h.    12.185284: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.    12.185309: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.    12.185325: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.    12.185326: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.    12.185328: e1000_rx_checksum.isra.46 <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    12.185343: e1000_alloc_rx_buffers <-e1000_clean_rx_irq
          <idle>-0     [000] .Ns.    12.185347: e1000_update_itr <-e1000_clean
          <idle>-0     [000] .Ns.    12.185347: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    12.455605: e1000_xmit_frame <-dev_hard_start_xmit
     kworker/0:1-33    [000] d.h.    12.455697: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] d.h.    12.455736: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s1    12.455766: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s1    12.455767: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
     kworker/0:1-33    [000] ..s1    12.455768: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] ..s1    12.455769: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ..s1    12.455769: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    12.455802: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    12.455817: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.455850: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.455868: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.455885: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.456353: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    12.456362: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.456413: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.456432: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.456448: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.456465: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] ..s.    12.458375: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] dNH.    12.458449: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] dNH.    12.458460: e1000_intr <-__handle_irq_event_percpu
     ksoftirqd/0-9     [000] ..s.    12.458495: e1000_clean <-net_rx_action
     ksoftirqd/0-9     [000] ..s.    12.458496: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
     ksoftirqd/0-9     [000] ..s.    12.458497: e1000_clean_rx_irq <-e1000_clean
     ksoftirqd/0-9     [000] ..s.    12.458498: e1000_update_itr <-e1000_clean
     ksoftirqd/0-9     [000] ..s.    12.458498: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    12.519488: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    12.519501: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.519529: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.519549: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.519568: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.519588: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.519606: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520024: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    12.520033: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520050: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520066: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520082: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520098: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520114: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520556: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-33    [000] ....    12.520564: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520581: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520597: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520613: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520630: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    12.520646: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-33    [000] ....    13.223485: e1000_watchdog <-process_one_work
     kworker/0:1-33    [000] ....    13.223487: e1000_has_link <-e1000_watchdog
     kworker/0:1-33    [000] ....    13.223487: e1000_update_stats <-e1000_watchdog
     kworker/0:1-33    [000] d...    13.223756: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] d...    13.223818: e1000_read_phy_reg <-e1000_update_stats
     kworker/0:1-33    [000] ....    13.223893: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-33    [000] d.h.    13.223927: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] d.h.    13.223945: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-33    [000] ..s.    13.223968: e1000_clean <-net_rx_action
     kworker/0:1-33    [000] ..s.    13.223969: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-33    [000] ..s.    13.223970: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ..s.    13.223970: e1000_update_itr <-e1000_clean
     kworker/0:1-33    [000] ....    13.223984: e1000_update_phy_info_task <-process_one_work
     kworker/0:1-33    [000] ....    13.223985: e1000_phy_get_info <-e1000_update_phy_info_task
     kworker/0:1-33    [000] ....    13.223985: e1000_read_phy_reg <-e1000_phy_get_info
     kworker/0:1-33    [000] ....    13.224070: e1000_read_phy_reg <-e1000_phy_get_info
***************************************************************************************************


Boot with *hangs*:

***************************************************************************************************
   dwatcher/init-1279  [001] ....     4.196171: e1000_set_mac <-dev_set_mac_address
   dwatcher/init-1279  [001] ....     4.196173: e1000_rar_set <-e1000_set_mac
   dwatcher/init-1279  [001] ....     4.196216: e1000_open <-__dev_open
   dwatcher/init-1279  [001] ....     4.196216: e1000_setup_all_tx_resources <-e1000_open
   dwatcher/init-1279  [001] ....     4.196222: e1000_setup_all_rx_resources <-e1000_open
   dwatcher/init-1279  [001] ....     4.196226: e1000_power_up_phy <-e1000_open
   dwatcher/init-1279  [001] ....     4.196226: e1000_read_phy_reg <-e1000_power_up_phy
   dwatcher/init-1279  [001] ....     4.198922: e1000_write_phy_reg <-e1000_power_up_phy
   dwatcher/init-1279  [001] d...     4.198923: e1000_write_phy_reg_ex <-e1000_write_phy_reg
   dwatcher/init-1279  [001] ....     4.198942: e1000_configure <-e1000_open
   dwatcher/init-1279  [001] ....     4.198942: e1000_set_rx_mode <-e1000_configure
   dwatcher/init-1279  [001] ....     4.198952: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.198978: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.199560: e1000_config_collision_dist <-e1000_configure
   dwatcher/init-1279  [001] ....     4.199583: e1000_setup_rctl <-e1000_configure
   dwatcher/init-1279  [001] ....     4.199591: e1000_configure_rx <-e1000_configure
   dwatcher/init-1279  [001] ....     4.199645: e1000_alloc_rx_buffers <-e1000_configure
   dwatcher/init-1279  [001] ....     4.199661: e1000_request_irq <-e1000_open
   dwatcher/init-1279  [001] ....     4.199752: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1279  [001] ....     4.199761: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] d.h.     4.199766: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1279  [001] ....     4.199793: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] ..s.     4.199812: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     4.199813: e1000_clean_rx_irq <-e1000_clean
   dwatcher/init-1279  [001] ....     4.200351: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1279  [001] ....     4.200361: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.200390: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.200409: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.201979: e1000_watchdog <-process_one_work
     kworker/1:2-1082  [001] ....     4.201979: e1000_has_link <-e1000_watchdog
     kworker/1:2-1082  [001] ....     4.201980: e1000_check_for_link <-e1000_has_link
     kworker/1:2-1082  [001] ....     4.201994: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.202056: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.202171: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.202235: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.202253: e1000_config_fc_after_link_up <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.202253: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.202315: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.202377: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.202439: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.202500: e1000_get_speed_and_duplex <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.202507: e1000_force_mac_fc <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.202515: e1000_get_speed_and_duplex <-e1000_watchdog
     kworker/1:2-1082  [001] ....     4.203863: e1000_update_stats <-e1000_watchdog
     kworker/1:2-1082  [001] d...     4.204178: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:2-1082  [001] d...     4.204241: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:2-1082  [001] ....     4.204368: e1000_update_adaptive <-e1000_watchdog
           klogd-1290  [000] d.h.     4.204393: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1279  [001] ....     4.204395: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
   dwatcher/init-1279  [001] ....     4.204395: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
           klogd-1290  [000] ..s.     4.204435: e1000_clean <-net_rx_action
           klogd-1290  [000] ..s.     4.204436: e1000_clean_rx_irq <-e1000_clean
           klogd-1290  [000] ..s.     4.204436: e1000_update_itr <-e1000_clean
           klogd-1290  [000] ..s.     4.204437: e1000_update_itr <-e1000_clean
   dwatcher/init-1279  [001] ....     4.204484: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
   dwatcher/init-1279  [001] ....     4.204504: e1000_write_vfta <-e1000_vlan_rx_add_vid
     kworker/1:2-1082  [001] ....     4.205802: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:2-1082  [001] ....     4.205814: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.205848: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.205867: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.205886: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [001] ..s.     4.210140: e1000_xmit_frame <-dev_hard_start_xmit
        Deuteron-1278  [000] d.h.     4.210204: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1278  [000] ..s.     4.210249: e1000_clean <-net_rx_action
        Deuteron-1278  [000] ..s.     4.210250: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
        Deuteron-1278  [000] ..s.     4.210252: e1000_clean_rx_irq <-e1000_clean
        Deuteron-1278  [000] ..s.     4.210252: e1000_update_itr <-e1000_clean
        Deuteron-1278  [000] ..s.     4.210253: e1000_update_itr <-e1000_clean
      dsys/start-1293  [000] ....     4.211820: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1293  [000] ....     4.211843: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.211885: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.211928: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.211947: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.211966: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.212560: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1293  [000] .N..     4.212569: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.212608: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.212628: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.212656: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.212675: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.213208: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1293  [000] .N..     4.213216: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.213256: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.213275: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.213293: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] .N..     4.213312: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.213739: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1293  [000] ....     4.213749: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.213788: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.213807: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.213825: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.213844: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.214315: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1293  [000] ....     4.214324: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.214363: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.214382: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.214400: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1293  [000] ....     4.214418: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216061: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-36    [000] ....     4.216123: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216147: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216182: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216202: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216221: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216646: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/0:1-36    [000] ....     4.216654: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216694: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216713: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216731: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ....     4.216749: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:1-36    [000] ..s1     4.217236: e1000_xmit_frame <-dev_hard_start_xmit
     kworker/0:1-36    [000] d.H1     4.217283: e1000_intr <-__handle_irq_event_percpu
     kworker/0:1-36    [000] ..s1     4.217333: e1000_clean <-net_rx_action
     kworker/0:1-36    [000] ..s1     4.217334: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
     kworker/0:1-36    [000] ..s1     4.217335: e1000_clean_rx_irq <-e1000_clean
     kworker/0:1-36    [000] ..s1     4.217335: e1000_update_itr <-e1000_clean
     kworker/0:1-36    [000] ..s1     4.217335: e1000_update_itr <-e1000_clean
          <idle>-0     [000] .Ns.     4.220141: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] dNH.     4.220187: e1000_intr <-__handle_irq_event_percpu
     ksoftirqd/0-9     [000] ..s.     4.220235: e1000_clean <-net_rx_action
     ksoftirqd/0-9     [000] ..s.     4.220235: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
     ksoftirqd/0-9     [000] ..s.     4.220236: e1000_clean_rx_irq <-e1000_clean
     ksoftirqd/0-9     [000] ..s.     4.220237: e1000_update_itr <-e1000_clean
     ksoftirqd/0-9     [000] ..s.     4.220237: e1000_update_itr <-e1000_clean
   dwatcher/init-1279  [001] ....     4.223131: e1000_set_mac <-dev_set_mac_address
   dwatcher/init-1279  [001] ....     4.223132: e1000_rar_set <-e1000_set_mac
   dwatcher/init-1279  [001] ....     4.223173: e1000_open <-__dev_open
   dwatcher/init-1279  [001] ....     4.223173: e1000_setup_all_tx_resources <-e1000_open
   dwatcher/init-1279  [001] ....     4.223179: e1000_setup_all_rx_resources <-e1000_open
   dwatcher/init-1279  [001] ....     4.223182: e1000_power_up_phy <-e1000_open
   dwatcher/init-1279  [001] ....     4.223183: e1000_read_phy_reg <-e1000_power_up_phy
   dwatcher/init-1279  [001] ....     4.223246: e1000_write_phy_reg <-e1000_power_up_phy
   dwatcher/init-1279  [001] d...     4.223247: e1000_write_phy_reg_ex <-e1000_write_phy_reg
   dwatcher/init-1279  [001] ....     4.223264: e1000_configure <-e1000_open
   dwatcher/init-1279  [001] ....     4.223264: e1000_set_rx_mode <-e1000_configure
   dwatcher/init-1279  [001] ....     4.225962: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.225983: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.226539: e1000_config_collision_dist <-e1000_configure
   dwatcher/init-1279  [001] ....     4.226562: e1000_setup_rctl <-e1000_configure
   dwatcher/init-1279  [001] ....     4.226571: e1000_configure_rx <-e1000_configure
   dwatcher/init-1279  [001] ....     4.226608: e1000_alloc_rx_buffers <-e1000_configure
   dwatcher/init-1279  [001] ....     4.226624: e1000_request_irq <-e1000_open
   dwatcher/init-1279  [001] ....     4.226662: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1279  [001] ....     4.226671: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.226705: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [000] d.h.     4.226706: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.     4.226722: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.     4.226755: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     4.226756: e1000_clean_rx_irq <-e1000_clean
   dwatcher/init-1279  [001] ....     4.227268: e1000_set_rx_mode <-__dev_set_rx_mode
   dwatcher/init-1279  [001] ....     4.227278: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.227298: e1000_rar_set <-e1000_set_rx_mode
   dwatcher/init-1279  [001] ....     4.227317: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.228900: e1000_watchdog <-process_one_work
     kworker/1:2-1082  [001] ....     4.228900: e1000_has_link <-e1000_watchdog
     kworker/1:2-1082  [001] ....     4.228900: e1000_check_for_link <-e1000_has_link
     kworker/1:2-1082  [001] ....     4.228914: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.228977: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.229039: e1000_read_phy_reg <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.229147: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.229166: e1000_config_fc_after_link_up <-e1000_check_for_link
     kworker/1:2-1082  [001] ....     4.229167: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.229229: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.229292: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.229354: e1000_read_phy_reg <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.229415: e1000_get_speed_and_duplex <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.229422: e1000_force_mac_fc <-e1000_config_fc_after_link_up
     kworker/1:2-1082  [001] ....     4.229430: e1000_get_speed_and_duplex <-e1000_watchdog
     kworker/1:2-1082  [001] ....     4.230797: e1000_update_stats <-e1000_watchdog
     kworker/1:2-1082  [001] d...     4.231126: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:2-1082  [001] d...     4.231190: e1000_read_phy_reg <-e1000_update_stats
     kworker/1:2-1082  [001] ....     4.231317: e1000_update_adaptive <-e1000_watchdog
   dwatcher/init-1279  [001] ....     4.231338: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
           klogd-1290  [000] d.h.     4.231338: e1000_intr <-__handle_irq_event_percpu
   dwatcher/init-1279  [001] ....     4.231338: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
           klogd-1290  [000] d.h.     4.231367: e1000_intr <-__handle_irq_event_percpu
           klogd-1290  [000] ..s.     4.231395: e1000_clean <-net_rx_action
           klogd-1290  [000] ..s.     4.231395: e1000_clean_rx_irq <-e1000_clean
           klogd-1290  [000] ..s.     4.231396: e1000_update_itr <-e1000_clean
           klogd-1290  [000] ..s.     4.231396: e1000_update_itr <-e1000_clean
   dwatcher/init-1279  [001] ....     4.231422: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
   dwatcher/init-1279  [001] ....     4.231442: e1000_write_vfta <-e1000_vlan_rx_add_vid
     kworker/1:2-1082  [001] ....     4.232711: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:2-1082  [001] ....     4.232722: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.232743: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.232761: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.232780: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [001] ..s.     4.234149: e1000_xmit_frame <-dev_hard_start_xmit
        Deuteron-1278  [000] d.h.     4.234195: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1278  [000] d.h.     4.234235: e1000_intr <-__handle_irq_event_percpu
        Deuteron-1278  [000] ..s.     4.234249: e1000_clean <-net_rx_action
        Deuteron-1278  [000] ..s.     4.234250: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
        Deuteron-1278  [000] ..s.     4.234252: e1000_clean_rx_irq <-e1000_clean
        Deuteron-1278  [000] ..s.     4.234252: e1000_update_itr <-e1000_clean
        Deuteron-1278  [000] ..s.     4.234252: e1000_update_itr <-e1000_clean
          <idle>-0     [001] .Ns.     4.236161: e1000_xmit_frame <-dev_hard_start_xmit
      dmsd[wrkr]-1298  [000] d.h.     4.236219: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1298  [000] d.h.     4.236228: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1298  [000] ..s.     4.236258: e1000_clean <-net_rx_action
      dmsd[wrkr]-1298  [000] ..s.     4.236258: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
      dmsd[wrkr]-1298  [000] ..s.     4.236260: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1298  [000] ..s.     4.236260: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1298  [000] ..s.     4.236261: e1000_update_itr <-e1000_clean
      dsys/start-1299  [001] ....     4.239896: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1299  [001] ....     4.239909: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.239931: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.239950: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.239968: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.239987: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.240474: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1299  [001] ....     4.240484: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.240504: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.240523: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.240541: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.240560: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.240994: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1299  [001] ....     4.241003: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241021: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241040: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241059: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241116: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241556: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1299  [001] ....     4.241566: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241585: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241604: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241631: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.241649: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.242122: e1000_set_rx_mode <-__dev_set_rx_mode
      dsys/start-1299  [001] ....     4.242131: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.242151: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.242170: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.242189: e1000_rar_set <-e1000_set_rx_mode
      dsys/start-1299  [001] ....     4.242208: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.243808: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:2-1082  [001] ....     4.243819: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.243838: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.243857: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.243876: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.243895: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.244370: e1000_set_rx_mode <-__dev_set_rx_mode
     kworker/1:2-1082  [001] ....     4.244378: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.244397: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.244416: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.244435: e1000_rar_set <-e1000_set_rx_mode
     kworker/1:2-1082  [001] ....     4.244453: e1000_rar_set <-e1000_set_rx_mode
          <idle>-0     [001] ..s.     4.247205: e1000_xmit_frame <-dev_hard_start_xmit
      dmsd[wrkr]-1298  [000] d.h.     4.247253: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1298  [000] d.h.     4.247283: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1298  [000] ..s.     4.247314: e1000_clean <-net_rx_action
      dmsd[wrkr]-1298  [000] ..s.     4.247315: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
      dmsd[wrkr]-1298  [000] ..s.     4.247317: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1298  [000] ..s.     4.247317: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1298  [000] ..s.     4.247318: e1000_update_itr <-e1000_clean
        iptables-1344  [001] ..s.     4.331112: e1000_xmit_frame <-dev_hard_start_xmit
          <idle>-0     [000] d.h.     4.331192: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] d.h.     4.331229: e1000_intr <-__handle_irq_event_percpu
          <idle>-0     [000] ..s.     4.331243: e1000_clean <-net_rx_action
          <idle>-0     [000] ..s.     4.331244: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean
          <idle>-0     [000] ..s.     4.331246: e1000_clean_rx_irq <-e1000_clean
          <idle>-0     [000] ..s.     4.331247: e1000_update_itr <-e1000_clean
          <idle>-0     [000] ..s.     4.331247: e1000_update_itr <-e1000_clean
      dmsd[wrkr]-1350  [000] ....     4.345298: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1350  [000] ....     4.345309: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.345318: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1350  [000] ....     4.345322: e1000_get_link <-dev_ethtool
      dmsd[wrkr]-1350  [000] ....     4.345323: e1000_has_link <-e1000_get_link
      dmsd[wrkr]-1350  [000] ....     4.345335: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1350  [000] ....     4.345343: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.345412: e1000_set_link_ksettings <-ethtool_set_settings
      dmsd[wrkr]-1350  [000] ....     4.345413: e1000_down <-e1000_set_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.357374: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.357376: e1000_reset <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.357379: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.369407: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.369425: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.376378: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.376385: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.376386: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.376402: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.376464: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.376522: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.376636: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.376693: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.376807: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.376864: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.376923: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.376986: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377043: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377162: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377219: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377333: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377391: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377505: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377562: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377676: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377733: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377847: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377904: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.377963: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.377969: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378031: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378098: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378161: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378218: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378285: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378343: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378405: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378462: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378524: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378581: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378643: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378701: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378763: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378820: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378882: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.378939: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379001: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379059: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379157: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379215: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379277: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379334: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379396: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379453: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379515: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379573: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379635: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379692: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379754: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379811: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379873: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.379931: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.380164: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.380287: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.381308: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.382564: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.382571: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.382632: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.382633: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.382648: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.382708: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.382708: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.382724: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.382724: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] ....     4.382784: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] d...     4.382784: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.382800: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.382801: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.382861: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.382921: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.382921: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.382936: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.382936: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.382951: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.383011: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.383012: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.383042: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.383160: e1000_read_phy_reg <-e1000_setup_link
................
      dmsd[wrkr]-1350  [000] ....     4.384346: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.384408: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.384785: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.384788: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.384790: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.384790: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] ....     4.384851: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] ....     4.384911: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.384911: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.384912: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
..............
      dmsd[wrkr]-1350  [000] ....     4.384959: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.384959: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.384968: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.384980: e1000_up <-e1000_set_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.384980: e1000_configure <-e1000_up
      dmsd[wrkr]-1350  [000] ....     4.384981: e1000_set_rx_mode <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.384989: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385006: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385022: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385038: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385053: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385451: e1000_vlan_filter_on_off <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.385465: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dmsd[wrkr]-1350  [000] ....     4.385465: e1000_vlan_rx_add_vid <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.385471: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dmsd[wrkr]-1350  [000] ....     4.385503: e1000_config_collision_dist <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.385531: e1000_setup_rctl <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.385538: e1000_configure_rx <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.385571: e1000_alloc_rx_buffers <-e1000_configure
      dmsd[wrkr]-1350  [000] dNh.     4.385622: e1000_intr <-__handle_irq_event_percpu
      dmsd[wrkr]-1350  [000] dNh.     4.385642: e1000_intr <-__handle_irq_event_percpu
     ksoftirqd/0-9     [000] ..s.     4.385665: e1000_clean <-net_rx_action
     ksoftirqd/0-9     [000] ..s.     4.385665: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1350  [000] ....     4.385827: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385841: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385862: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385880: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385899: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.385917: e1000_rar_set <-e1000_set_rx_mode
     kworker/0:2-1170  [000] ....     4.387188: e1000_watchdog <-process_one_work
     kworker/0:2-1170  [000] ....     4.387189: e1000_has_link <-e1000_watchdog
     kworker/0:2-1170  [000] ....     4.387189: e1000_check_for_link <-e1000_has_link
     kworker/0:2-1170  [000] ....     4.387223: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:2-1170  [000] ....     4.387286: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:2-1170  [000] ....     4.387373: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:2-1170  [000] ....     4.387373: e1000_update_stats <-e1000_watchdog
     kworker/0:2-1170  [000] ....     4.387373: e1000_update_adaptive <-e1000_watchdog
     kworker/0:2-1170  [000] d.h.     4.387401: e1000_intr <-__handle_irq_event_percpu
     kworker/0:2-1170  [000] d.h.     4.387470: e1000_intr <-__handle_irq_event_percpu
     kworker/0:2-1170  [000] ..s.     4.387495: e1000_clean <-net_rx_action
     kworker/0:2-1170  [000] ..s.     4.387495: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1350  [000] ....     4.387781: e1000_close <-__dev_close_many
      dmsd[wrkr]-1350  [000] ....     4.387782: e1000_down <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.399433: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.399434: e1000_reset <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.399437: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.411362: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.411368: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.418185: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.418191: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.418192: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.418208: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.418271: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418346: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418463: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418521: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418638: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418696: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418757: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.418821: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.418883: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419000: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419059: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419243: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419302: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419418: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419477: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419593: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419652: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419768: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419827: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419887: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.419894: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.419958: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420017: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420112: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420171: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420235: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420294: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420358: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420417: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420481: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420539: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420604: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420662: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420727: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420785: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420849: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420908: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.420972: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421031: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421111: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421169: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421234: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421292: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421356: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421415: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421479: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421538: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421602: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421665: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421730: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421788: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421852: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.421911: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.422164: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.422291: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.423490: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.424950: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.424959: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.425022: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.425022: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.425039: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.425142: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.425142: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.425160: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.425161: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] ....     4.425222: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] d...     4.425223: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.425241: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.425241: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.425303: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.425365: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.425365: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.425382: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.425382: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.425399: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.425461: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.425461: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.425497: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.425559: e1000_read_phy_reg <-e1000_setup_link
.....
      dmsd[wrkr]-1350  [000] ....     4.426745: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.426807: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.427269: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.427272: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.427274: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.427275: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] ....     4.427337: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] ....     4.427399: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.427400: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.427400: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
.........
      dmsd[wrkr]-1350  [000] ....     4.427448: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.427448: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.427459: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.427473: e1000_power_down_phy <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.427488: e1000_free_tx_resources <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.427488: e1000_clean_tx_ring <-e1000_free_tx_resources
      dmsd[wrkr]-1350  [000] ....     4.427488: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.427488: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
.........
      dmsd[wrkr]-1350  [000] ....     4.427536: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.427536: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.427550: e1000_free_rx_resources <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.427550: e1000_clean_rx_ring <-e1000_free_rx_resources
      dmsd[wrkr]-1350  [000] ....     4.428223: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1350  [000] ....     4.428234: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.428243: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1350  [000] ....     4.428245: e1000_get_link <-dev_ethtool
      dmsd[wrkr]-1350  [000] ....     4.428245: e1000_has_link <-e1000_get_link
      dmsd[wrkr]-1350  [000] ....     4.428256: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1350  [000] ....     4.428264: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.428331: e1000_set_link_ksettings <-ethtool_set_settings
      dmsd[wrkr]-1350  [000] ....     4.428332: e1000_down <-e1000_set_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.440242: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.440244: e1000_reset <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.440247: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.452365: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.452372: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.459211: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.459219: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.459219: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.459238: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.459303: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459361: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459477: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459536: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459652: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459711: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459771: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.459836: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.459893: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460007: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460101: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460216: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460273: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460387: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460444: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460558: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460616: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460730: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460787: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460846: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.460851: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460913: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.460970: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461032: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461098: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461161: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461218: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461280: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461337: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461399: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461457: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461519: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461576: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461639: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461696: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461758: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461815: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461877: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461934: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.461997: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462054: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462117: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462174: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462237: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462294: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462356: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462413: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462475: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462532: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462594: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462651: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462713: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.462771: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.463003: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.463158: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.464178: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.465432: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.465440: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.465500: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.465500: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.465516: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.465576: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.465576: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.465591: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.465591: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] ....     4.465651: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] d...     4.465652: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.465668: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.465668: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.465728: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.465788: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.465788: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.465803: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.465804: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.465819: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.465879: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.465879: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.465895: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.465955: e1000_read_phy_reg <-e1000_setup_link
.......
      dmsd[wrkr]-1350  [000] ....     4.467138: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.467199: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.467567: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.467570: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.467572: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.467572: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] ....     4.467632: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] ....     4.467692: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.467693: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.467693: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
......
      dmsd[wrkr]-1350  [000] ....     4.467734: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.467734: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.467743: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.467754: e1000_up <-e1000_set_link_ksettings
      dmsd[wrkr]-1350  [000] ....     4.467755: e1000_configure <-e1000_up
      dmsd[wrkr]-1350  [000] ....     4.467755: e1000_set_rx_mode <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.467764: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.467780: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.467796: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.467812: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.467827: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.468229: e1000_vlan_filter_on_off <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.468243: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dmsd[wrkr]-1350  [000] ....     4.468243: e1000_vlan_rx_add_vid <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.468249: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dmsd[wrkr]-1350  [000] ....     4.468294: e1000_config_collision_dist <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.468313: e1000_setup_rctl <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.468320: e1000_configure_rx <-e1000_configure
      dmsd[wrkr]-1350  [000] ....     4.468353: e1000_alloc_rx_buffers <-e1000_configure
      dmsd[wrkr]-1350  [000] dNh.     4.468417: e1000_intr <-__handle_irq_event_percpu
     ksoftirqd/0-9     [000] ..s.     4.468469: e1000_xmit_frame <-dev_hard_start_xmit
     ksoftirqd/0-9     [000] ..s.     4.468478: e1000_clean <-net_rx_action
     ksoftirqd/0-9     [000] ..s.     4.468479: e1000_clean_rx_irq <-e1000_clean
      dmsd[wrkr]-1350  [000] ....     4.468603: e1000_set_rx_mode <-__dev_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.468615: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.468636: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.468654: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.468673: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.468691: e1000_rar_set <-e1000_set_rx_mode
      dmsd[wrkr]-1350  [000] ....     4.469229: e1000_close <-__dev_close_many
      dmsd[wrkr]-1350  [000] ....     4.469229: e1000_down <-e1000_close
     kworker/0:1-36    [000] ....     4.470179: e1000_watchdog <-process_one_work
     kworker/0:1-36    [000] ....     4.470180: e1000_has_link <-e1000_watchdog
     kworker/0:1-36    [000] ....     4.470180: e1000_check_for_link <-e1000_has_link
     kworker/0:1-36    [000] ....     4.470205: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-36    [000] ....     4.470289: e1000_read_phy_reg <-e1000_check_for_link
     kworker/0:1-36    [000] ....     4.470361: e1000_config_dsp_after_link_change <-e1000_check_for_link
     kworker/0:1-36    [000] ....     4.470361: e1000_update_stats <-e1000_watchdog
     kworker/0:1-36    [000] ....     4.470362: e1000_update_adaptive <-e1000_watchdog
     kworker/0:1-36    [000] ....     4.470362: e1000_reset_task <-process_one_work
     kworker/0:1-36    [000] ....     4.471433: e1000_reinit_locked <-e1000_reset_task
     kworker/0:1-36    [000] ....     4.471434: e1000_down <-e1000_reinit_locked
      dmsd[wrkr]-1350  [000] ....     4.481381: e1000_down_and_stop <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.481382: e1000_reset <-e1000_down
      dmsd[wrkr]-1350  [000] ....     4.481385: e1000_reset_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.493345: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.493350: e1000_io_write <-e1000_reset_hw
      dmsd[wrkr]-1350  [000] ....     4.500375: e1000_init_hw <-e1000_reset
      dmsd[wrkr]-1350  [000] ....     4.500382: e1000_read_eeprom <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.500383: e1000_acquire_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.500398: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.500461: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.500518: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.500632: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.500689: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.500803: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.500860: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.500919: e1000_shift_out_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.500981: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] ....     4.501039: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501159: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501217: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501331: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501388: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501502: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501559: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501674: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501731: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501845: e1000_raise_ee_clk.isra.7 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501903: e1000_lower_ee_clk.isra.8 <-e1000_shift_out_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.501962: e1000_shift_in_ee_bits <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] .N..     4.501967: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502029: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502120: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502184: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502241: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502304: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502361: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502423: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502480: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502543: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502600: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502662: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502719: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502781: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502839: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502901: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.502958: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503020: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503117: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503180: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503238: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503300: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503357: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503419: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503477: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503539: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503596: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503658: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503715: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503778: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503835: e1000_raise_ee_clk.isra.7 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503897: e1000_lower_ee_clk.isra.8 <-e1000_shift_in_ee_bits
      dmsd[wrkr]-1350  [000] .N..     4.503954: e1000_standby_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.504234: e1000_release_eeprom <-e1000_read_eeprom
      dmsd[wrkr]-1350  [000] ....     4.504357: e1000_set_media_type <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.505394: e1000_rar_set <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.506656: e1000_setup_link <-e1000_init_hw
      dmsd[wrkr]-1350  [000] ....     4.506664: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.506724: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.506724: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.506740: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.506800: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] d...     4.506800: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.506815: e1000_phy_reset <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.506816: e1000_read_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] ....     4.506876: e1000_write_phy_reg <-e1000_phy_reset
      dmsd[wrkr]-1350  [000] d...     4.506876: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.506892: e1000_phy_setup_autoneg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] ....     4.506892: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.506953: e1000_read_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] ....     4.507013: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.507013: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.507028: e1000_write_phy_reg <-e1000_phy_setup_autoneg
      dmsd[wrkr]-1350  [000] d...     4.507028: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] ....     4.507043: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] .N..     4.507140: e1000_write_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] dN..     4.507140: e1000_write_phy_reg_ex <-e1000_write_phy_reg
      dmsd[wrkr]-1350  [000] .N..     4.507157: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] .N..     4.507218: e1000_read_phy_reg <-e1000_setup_link
.....
      dmsd[wrkr]-1350  [000] .N..     4.508379: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] .N..     4.508439: e1000_read_phy_reg <-e1000_setup_link
      dmsd[wrkr]-1350  [000] .N..     4.508808: e1000_update_mng_vlan <-e1000_reset
      dmsd[wrkr]-1350  [000] .N..     4.508810: e1000_reset_adaptive <-e1000_reset
      dmsd[wrkr]-1350  [000] .N..     4.508812: e1000_phy_get_info <-e1000_reset
      dmsd[wrkr]-1350  [000] .N..     4.508812: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] .N..     4.508873: e1000_read_phy_reg <-e1000_phy_get_info
      dmsd[wrkr]-1350  [000] .N..     4.508933: e1000_clean_tx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] .N..     4.508933: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] .N..     4.508935: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
...........
      dmsd[wrkr]-1350  [000] .N..     4.508976: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] .N..     4.508977: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] .N..     4.508985: e1000_clean_rx_ring <-e1000_down
      dmsd[wrkr]-1350  [000] .N..     4.508996: e1000_power_down_phy <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.509027: e1000_free_tx_resources <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.509028: e1000_clean_tx_ring <-e1000_free_tx_resources
      dmsd[wrkr]-1350  [000] ....     4.509028: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.509028: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
..........
      dmsd[wrkr]-1350  [000] ....     4.509108: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.509108: e1000_unmap_and_free_tx_resource.isra.56 <-e1000_clean_tx_ring
      dmsd[wrkr]-1350  [000] ....     4.509120: e1000_free_rx_resources <-e1000_close
      dmsd[wrkr]-1350  [000] ....     4.509120: e1000_clean_rx_ring <-e1000_free_rx_resources
       dlinkwtch-1356  [000] ....     4.523362: e1000_get_link_ksettings <-ethtool_get_settings
       dlinkwtch-1356  [000] ....     4.523377: e1000_get_pauseparam <-dev_ethtool
       dlinkwtch-1356  [000] ....     4.523393: e1000_get_link_ksettings <-ethtool_get_settings
       dlinkwtch-1356  [000] ....     4.523404: e1000_get_pauseparam <-dev_ethtool
      dsys/start-1506  [000] .N..     4.788347: e1000_vlan_rx_kill_vid <-vlan_kill_rx_filter_info
      dsys/start-1506  [000] .N..     4.788360: e1000_write_vfta <-e1000_vlan_rx_kill_vid
      dsys/start-1506  [000] .N..     4.788372: e1000_vlan_filter_on_off <-e1000_vlan_rx_kill_vid
      dsys/start-1506  [000] ....     4.789638: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
      dsys/start-1506  [000] ....     4.789639: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
      dsys/start-1506  [000] ....     4.789659: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dsys/start-1506  [000] ....     4.789666: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dsys/start-1510  [000] .N..     4.803419: e1000_vlan_rx_kill_vid <-vlan_kill_rx_filter_info
      dsys/start-1510  [000] .N..     4.803429: e1000_write_vfta <-e1000_vlan_rx_kill_vid
      dsys/start-1510  [000] .N..     4.803438: e1000_vlan_filter_on_off <-e1000_vlan_rx_kill_vid
      dsys/start-1510  [000] ....     4.804708: e1000_vlan_rx_add_vid <-vlan_add_rx_filter_info
      dsys/start-1510  [000] ....     4.804709: e1000_vlan_filter_on_off <-e1000_vlan_rx_add_vid
      dsys/start-1510  [000] ....     4.804728: e1000_update_mng_vlan <-e1000_vlan_filter_on_off
      dsys/start-1510  [000] ....     4.804736: e1000_write_vfta <-e1000_vlan_rx_add_vid
      dsys/start-1529  [000] ....     4.839787: e1000_get_link_ksettings <-__ethtool_get_link_ksettings
      dsys/start-1529  [000] ....     4.842031: e1000_fix_features <-__netdev_update_features
      dmsd[wrkr]-1716  [001] ....     9.953579: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1716  [001] ....     9.953590: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1716  [001] ....     9.953599: e1000_get_pauseparam <-dev_ethtool
      dmsd[wrkr]-1716  [001] ....     9.953621: e1000_get_link_ksettings <-ethtool_get_settings
      dmsd[wrkr]-1716  [001] ....     9.953628: e1000_get_speed_and_duplex <-e1000_get_link_ksettings
      dmsd[wrkr]-1716  [000] ....     9.955210: e1000_set_link_ksettings <-ethtool_set_settings
`
***************************************************************************************************







