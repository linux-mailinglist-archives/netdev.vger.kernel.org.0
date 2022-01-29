Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879944A2B42
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 03:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345241AbiA2CYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 21:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240775AbiA2CYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 21:24:13 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C323C061714;
        Fri, 28 Jan 2022 18:24:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ah7so22069644ejc.4;
        Fri, 28 Jan 2022 18:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ioqlrOoxPOn1cJr5twTUz/ZAacFjKHM4+voE3E//iSs=;
        b=CASHMVwCeM+4y3Jpl/vIYfS+zeNUNj8P+t636ctaFVdltdF7DciXVJ81svIRXkqbKm
         ryjlV/HVnJqiR5mWaHlNYfTELn8xBnY+H+H3XTQRPvZ57PPOSX9UffHbphlpcbqWlzFj
         bJqDT+4XzUe5LcG2dF2L8HM1ph3fmFQqi4O0IZCmdhjv1jPrnCDt5Fti18hMutCGC9d9
         qH0DSqYXriorUuwX/Err82v1rflI1MRB40HNbUUi6+JayQXJgHHaJm0kaKRkNAzhlfPx
         7le1un/agFwATjP1M9GbOUFbYJEQAOfUq69OrQS7yyUqQ5m4pW1HbjDT38KjPAd2WJjm
         WJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ioqlrOoxPOn1cJr5twTUz/ZAacFjKHM4+voE3E//iSs=;
        b=vvVUoepeY3+xhl5uyno3VZD4t4nHArn+NE4znQJGOem4dcVgVOHkCptPIdHs7ZcuF2
         jVmNY8tVIXkrhmfWeeDCMY9oO6HX5nYWmT4qjrL9/R8oxFXXDX9vAO9ZVde+ULajw77W
         Zo+CLkEIG6xFUn8WtyEuifxUhb2T1r3gOYkd7Iyuf9mXYfjqgs4XGVSTNGng23t3vpgA
         RnllhO+yocn1dbuYXKESyAR0T5PgcP1cO0SOeMUmXBL3oNlIT7neWABhYra+w0HprJ3+
         61KAQoo/Ne57NmMDVJziYCql3iuSzx61uQRpo81z5VIfLE0H+inCnoWqWMmsjRJ9YgnL
         kmmQ==
X-Gm-Message-State: AOAM530Lg0lZ8lkwJ7uxXg1NTZOBE0OjgGtWmaAhyUlO4CyX5ASti9Dt
        2Ss9Wj6KRmELwhUTz5RW7zEUV5+zqiwU2y6Ylqd3bgJdd1qMsQ==
X-Google-Smtp-Source: ABdhPJyzNuD+ImDU5MLhQEYrGVYT905Xsa2FNjWRM0pKSwOMW0QmGamaCXKqnOoNS+sWhtgs4rRYryTOGncUg3sokVM=
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr5202514ejm.434.1643423051190;
 Fri, 28 Jan 2022 18:24:11 -0800 (PST)
MIME-Version: 1.0
References: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
In-Reply-To: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sat, 29 Jan 2022 10:23:59 +0800
Message-ID: <CAABZP2xampOLo8k93OLgaOfv9LreJ+f0g0_1mXwqtrv_LKewQg@mail.gmail.com>
Subject: Re: BUG: Kernel NULL pointer dereference on write at 0x00000000 (rtmsg_ifinfo_build_skb)
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        rcu <rcu@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Paul

I don't have an IBM machine, but I tried to analyze the problem using
my x86_64 kvm virtual machine, I can't reproduce the bug using my
x86_64 kvm virtual machine.

I saw the panic is caused by registration of sit device (A sit device
is a type of virtual network device that takes our IPv6 traffic,
encapsulates/decapsulates it in IPv4 packets, and sends/receives it
over the IPv4 Internet to another host)

sit device is registered in function sit_init_net:
1895    static int __net_init sit_init_net(struct net *net)
1896    {
1897        struct sit_net *sitn = net_generic(net, sit_net_id);
1898        struct ip_tunnel *t;
1899        int err;
1900
1901        sitn->tunnels[0] = sitn->tunnels_wc;
1902        sitn->tunnels[1] = sitn->tunnels_l;
1903        sitn->tunnels[2] = sitn->tunnels_r;
1904        sitn->tunnels[3] = sitn->tunnels_r_l;
1905
1906        if (!net_has_fallback_tunnels(net))
1907            return 0;
1908
1909        sitn->fb_tunnel_dev = alloc_netdev(sizeof(struct ip_tunnel), "sit0",
1910                           NET_NAME_UNKNOWN,
1911                           ipip6_tunnel_setup);
1912        if (!sitn->fb_tunnel_dev) {
1913            err = -ENOMEM;
1914            goto err_alloc_dev;
1915        }
1916        dev_net_set(sitn->fb_tunnel_dev, net);
1917        sitn->fb_tunnel_dev->rtnl_link_ops = &sit_link_ops;
1918        /* FB netdevice is special: we have one, and only one per netns.
1919         * Allowing to move it to another netns is clearly unsafe.
1920         */
1921        sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
1922
1923        err = register_netdev(sitn->fb_tunnel_dev);
register_netdev on line 1923 will call if_nlmsg_size indirectly.

On the other hand, the function that calls the paniced strlen is if_nlmsg_size:
(gdb) disassemble if_nlmsg_size
Dump of assembler code for function if_nlmsg_size:
   0xffffffff81a0dc20 <+0>:    nopl   0x0(%rax,%rax,1)
   0xffffffff81a0dc25 <+5>:    push   %rbp
   0xffffffff81a0dc26 <+6>:    push   %r15
   0xffffffff81a0dd04 <+228>:    je     0xffffffff81a0de20 <if_nlmsg_size+512>
   0xffffffff81a0dd0a <+234>:    mov    0x10(%rbp),%rdi
   ...
 => 0xffffffff81a0dd0e <+238>:    callq  0xffffffff817532d0 <strlen>
   0xffffffff81a0dd13 <+243>:    add    $0x10,%eax
   0xffffffff81a0dd16 <+246>:    movslq %eax,%r12

and the C code for 0xffffffff81a0dd0e is following (line 524):
515    static size_t rtnl_link_get_size(const struct net_device *dev)
516    {
517        const struct rtnl_link_ops *ops = dev->rtnl_link_ops;
518        size_t size;
519
520        if (!ops)
521            return 0;
522
523        size = nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
524               nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */

But ops is assigned the value of sit_link_ops in function sit_init_net
line 1917, so I guess something must happened between the calls.

Do we have KASAN in IBM machine? would KASAN help us find out what
happened in between?

Hope I can be of more helpful.

Thanks
Sincerely
Zhouyi

On Wed, Jan 26, 2022 at 3:24 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Linux folks,
>
>
> I do not know, if this is an rcutorture issue, or if rcutorture found a
> bug with `rtmsg_ifinfo_build_skb()`.
>
>
> Building Linux 5.17-rc1+ (dd81e1c7d5fb) under Ubuntu 21.04 with
>
>      CONFIG_TORTURE_TEST=y
>      CONFIG_RCU_TORTURE_TEST=y
>
> and
>
>      $ clang --version
>      Ubuntu clang version 12.0.0-3ubuntu1~21.04.2
>      Target: powerpc64le-unknown-linux-gnu
>      Thread model: posix
>      InstalledDir: /usr/bin
>      $ make -j100 LLVM=1 LLVM_IAS=0 bindeb-pkg
I build the kernel in LLVM/Clang also
>
> and booting it on an IBM S822LC, Linux paniced with a null pointer
> dereference, and the watchdog rebooted, and I found the message below in
> `/sys/fs/pstore/dmesg-nvram-2.enc.z`.
>
> ```
> [    T1] Key type id_legacy registered
> [    T1] SGI XFS with ACLs, security attributes, no debug enabled
> [    T1] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
> 248)
> [    T1] io scheduler mq-deadline registered
> [    T1] io scheduler kyber registered
> [  T198] cryptomgr_test (198) used greatest stack depth: 13536 bytes left
> [    T1] pci 0021:10:00.0: enabling device (0141 -> 0143)
> [    T1] Using unsupported 1024x768 (null) at 3fe882010000, depth=32,
> pitch=4096
> [    T1] Console: switching to colour frame buffer device 128x48
> [    T1] fb0: Open Firmware frame buffer device on
> /pciex@3fffe41100000/pci@0/pci@0/pci@b/pci@0/vga@0
> [    T1] hvc0: raw protocol on /ibm,opal/consoles/serial@0 (boot console)
> [    T1] hvc0: No interrupts property, using OPAL event
> [    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    T1] Non-volatile memory driver v1.3
> [    T1] brd: module loaded
> [    T1] loop: module loaded
> [    T1] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 (March
> 14, 2017)
> [    T1] ahci 0021:0e:00.0: version 3.0
> [    T1] ahci 0021:0e:00.0: enabling device (0141 -> 0143)
> [    T1] ahci 0021:0e:00.0: AHCI 0001.0000 32 slots 4 ports 6 Gbps 0xf
> impl SATA mode
> [    T1] ahci 0021:0e:00.0: flags: 64bit ncq sntf led only pmp fbs pio
> slum part sxs
> [    T1] scsi host0: ahci
> [    T1] scsi host1: ahci
> [    T1] scsi host2: ahci
> [    T1] scsi host3: ahci
> [    T1] ata1: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000100 irq 39
> [    T1] ata2: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000180 irq 39
> [    T1] ata3: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000200 irq 39
> [    T1] ata4: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000280 irq 39
> [    T1] e100: Intel(R) PRO/100 Network Driver
> [    T1] e100: Copyright(c) 1999-2006 Intel Corporation
> [    T1] e1000: Intel(R) PRO/1000 Network Driver
> [    T1] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    T1] e1000e: Intel(R) PRO/1000 Network Driver
> [    T1] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    T1] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    T1] ehci-pci: EHCI PCI platform driver
> [    T1] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    T1] ohci-pci: OHCI PCI platform driver
> [    T1] rtc-opal opal-rtc: registered as rtc0
> [    T1] rtc-opal opal-rtc: setting system clock to 2022-01-24T18:21:45
> UTC (1643048505)
> [    T1] i2c_dev: i2c /dev entries driver
> [    T1] device-mapper: uevent: version 1.0.3
> [    T1] device-mapper: ioctl: 4.45.0-ioctl (2021-03-22) initialised:
> dm-devel@redhat.com
> [    T1] powernv-cpufreq: cpufreq pstate min 0xffffffd5 nominal
> 0xffffffef max 0x0
> [    T1] powernv-cpufreq: Workload Optimized Frequency is disabled in
> the platform
> [    T1] powernv_idle_driver registered
> [    T1] nx_compress_powernv: coprocessor found on chip 0, CT 3 CI 1
> [    T1] nx_compress_powernv: coprocessor found on chip 8, CT 3 CI 9
> [    T1] usbcore: registered new interface driver usbhid
> [    T1] usbhid: USB HID core driver
> [    T1] ipip: IPv4 and MPLS over IPv4 tunneling driver
> [    T1] NET: Registered PF_INET6 protocol family
> [    T1] Segment Routing with IPv6
> [    T1] In-situ OAM (IOAM) with IPv6
> [    T1] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [    T1] BUG: Kernel NULL pointer dereference on write at 0x00000000
> [    T1] Faulting instruction address: 0xc0000000008e2400
> [    T1] Oops: Kernel access of bad area, sig: 11 [#1]
> [    T1] LE PAGE_SIZE=64K MMU=Hash PREEMPT SMP NR_CPUS=16 NUMA PowerNV
> [    T1] Modules linked in:
> [    T1] CPU: 11 PID: 1 Comm: swapper/0 Not tainted
> 5.17.0-rc1-00032-gdd81e1c7d5fb #29
> [    T1] NIP:  c0000000008e2400 LR: c000000000d65db0 CTR: c000000000f0bb60
> [    T1] REGS: c0000000125033e0 TRAP: 0380   Not tainted
> (5.17.0-rc1-00032-gdd81e1c7d5fb)
> [    T1] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 42800c40
> XER: 00000000
> [    T1] CFAR: c000000000d65dac IRQMASK: 0
> [    T1] GPR00: c000000000d65b40 c000000012503680 c00000000290c600
> 0000000000000000
> [    T1] GPR04: ffffffffffffffff 00000000ffffffff 0000000000000000
> 0000000000000cc0
> [    T1] GPR08: 0000000000000000 0000000000000000 ffffffffffffffff
> 0000000000000001
> [    T1] GPR12: 0000000000000000 c000007fffff6c00 c000000000012478
> 0000000000000000
> [    T1] GPR16: 0000000000000000 0000000000000000 0000000000000000
> 0000000000000000
> [    T1] GPR20: 0000000000000000 c000000002810100 0000000000000cc0
> 0000000000000000
> [    T1] GPR24: 0000000000000010 c00000000294cf50 0000000000000000
> 0000000000000000
> [    T1] GPR28: 0000000000000000 c00000001ec61000 0000000000000000
> c000000012503680
> [    T1] NIP [c0000000008e2400] strlen+0x10/0x30
> [    T1] LR [c000000000d65db0] if_nlmsg_size+0x150/0x360
> [    T1] Call Trace:
> [    T1] [c000000012503680] [c0000000125036c0] 0xc0000000125036c0
> (unreliable)
> [    T1] [c0000000125036f0] [c000000000d65b40]
> rtmsg_ifinfo_build_skb+0x80/0x1a0
> [    T1] [c0000000125037b0] [c000000000d66be0] rtmsg_ifinfo+0x70/0xd0
> [    T1] [c000000012503800] [c000000000d4de50]
> register_netdevice+0x690/0x770
> [    T1] [c000000012503890] [c000000000d4e2bc] register_netdev+0x4c/0x80
> [    T1] [c0000000125038c0] [c000000000f4784c] sit_init_net+0x10c/0x1d0
> [    T1] [c000000012503910] [c000000000d33c0c] ops_init+0x13c/0x1b0
> [    T1] [c000000012503970] [c000000000d331bc]
> register_pernet_operations+0xec/0x1e0
> [    T1] [c0000000125039d0] [c000000000d33440]
> register_pernet_device+0x60/0xd0
> [    T1] [c000000012503a20] [c000000002085478] sit_init+0x54/0x160
> [    T1] [c000000012503ab0] [c000000000011ba8] do_one_initcall+0xd8/0x3b0
> [    T1] [c000000012503c70] [c000000002006064] do_initcall_level+0xe4/0x1c4
> [    T1] [c000000012503cc0] [c000000002005f20] do_initcalls+0x84/0xe4
> [    T1] [c000000012503d40] [c000000002005c7c]
> kernel_init_freeable+0x160/0x1ec
> [    T1] [c000000012503da0] [c0000000000124ac] kernel_init+0x3c/0x270
> [    T1] [c000000012503e10] [c00000000000cd64]
> ret_from_kernel_thread+0x5c/0x64
> [    T1] Instruction dump:
> [    T1] eb81ffe0 7c0803a6 4e800020 00000000 00000000 00000000 60000000
> 60000000
> [    T1] 3883ffff 60000000 60000000 60000000 <8ca40001> 28050000
> 4082fff8 7c632050
> [    T1] ---[ end trace 0000000000000000 ]---
> [    T1]
> [  T206] ata4: SATA link down (SStatus 0 SControl 300)
> [  T204] ata3: SATA link down (SStatus 0 SControl 300)
> [  T200] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  T200] ata1.00: ATA-10: ST1000NX0313         00LY266 00LY265IBM, BE33,
> max UDMA/133
> [  T200] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 32), AA
> [  T200] ata1.00: configured for UDMA/133
> [    T7] scsi 0:0:0:0: Direct-Access     ATA      ST1000NX0313     BE33
> PQ: 0 ANSI: 5
> [    T7] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [  T209] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00
> TB/932 GiB)
> [  T209] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [  T209] sd 0:0:0:0: [sda] Write Protect is off
> [  T209] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [  T209] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [  T209]  sda: sda1 sda2
> [  T209] sd 0:0:0:0: [sda] Attached SCSI removable disk
> [    T1] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> ```
>
>
> Kind regards,
>
> Paul

On Wed, Jan 26, 2022 at 3:24 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Linux folks,
>
>
> I do not know, if this is an rcutorture issue, or if rcutorture found a
> bug with `rtmsg_ifinfo_build_skb()`.
>
>
> Building Linux 5.17-rc1+ (dd81e1c7d5fb) under Ubuntu 21.04 with
>
>      CONFIG_TORTURE_TEST=y
>      CONFIG_RCU_TORTURE_TEST=y
>
> and
>
>      $ clang --version
>      Ubuntu clang version 12.0.0-3ubuntu1~21.04.2
>      Target: powerpc64le-unknown-linux-gnu
>      Thread model: posix
>      InstalledDir: /usr/bin
>      $ make -j100 LLVM=1 LLVM_IAS=0 bindeb-pkg
I build the kernel in LLVM/Clang also
>
> and booting it on an IBM S822LC, Linux paniced with a null pointer
> dereference, and the watchdog rebooted, and I found the message below in
> `/sys/fs/pstore/dmesg-nvram-2.enc.z`.
>
> ```
> [    T1] Key type id_legacy registered
> [    T1] SGI XFS with ACLs, security attributes, no debug enabled
> [    T1] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
> 248)
> [    T1] io scheduler mq-deadline registered
> [    T1] io scheduler kyber registered
> [  T198] cryptomgr_test (198) used greatest stack depth: 13536 bytes left
> [    T1] pci 0021:10:00.0: enabling device (0141 -> 0143)
> [    T1] Using unsupported 1024x768 (null) at 3fe882010000, depth=32,
> pitch=4096
> [    T1] Console: switching to colour frame buffer device 128x48
> [    T1] fb0: Open Firmware frame buffer device on
> /pciex@3fffe41100000/pci@0/pci@0/pci@b/pci@0/vga@0
> [    T1] hvc0: raw protocol on /ibm,opal/consoles/serial@0 (boot console)
> [    T1] hvc0: No interrupts property, using OPAL event
> [    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    T1] Non-volatile memory driver v1.3
> [    T1] brd: module loaded
> [    T1] loop: module loaded
> [    T1] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 (March
> 14, 2017)
> [    T1] ahci 0021:0e:00.0: version 3.0
> [    T1] ahci 0021:0e:00.0: enabling device (0141 -> 0143)
> [    T1] ahci 0021:0e:00.0: AHCI 0001.0000 32 slots 4 ports 6 Gbps 0xf
> impl SATA mode
> [    T1] ahci 0021:0e:00.0: flags: 64bit ncq sntf led only pmp fbs pio
> slum part sxs
> [    T1] scsi host0: ahci
> [    T1] scsi host1: ahci
> [    T1] scsi host2: ahci
> [    T1] scsi host3: ahci
> [    T1] ata1: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000100 irq 39
> [    T1] ata2: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000180 irq 39
> [    T1] ata3: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000200 irq 39
> [    T1] ata4: SATA max UDMA/133 abar m2048@0x3fe881000000 port
> 0x3fe881000280 irq 39
> [    T1] e100: Intel(R) PRO/100 Network Driver
> [    T1] e100: Copyright(c) 1999-2006 Intel Corporation
> [    T1] e1000: Intel(R) PRO/1000 Network Driver
> [    T1] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    T1] e1000e: Intel(R) PRO/1000 Network Driver
> [    T1] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    T1] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    T1] ehci-pci: EHCI PCI platform driver
> [    T1] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    T1] ohci-pci: OHCI PCI platform driver
> [    T1] rtc-opal opal-rtc: registered as rtc0
> [    T1] rtc-opal opal-rtc: setting system clock to 2022-01-24T18:21:45
> UTC (1643048505)
> [    T1] i2c_dev: i2c /dev entries driver
> [    T1] device-mapper: uevent: version 1.0.3
> [    T1] device-mapper: ioctl: 4.45.0-ioctl (2021-03-22) initialised:
> dm-devel@redhat.com
> [    T1] powernv-cpufreq: cpufreq pstate min 0xffffffd5 nominal
> 0xffffffef max 0x0
> [    T1] powernv-cpufreq: Workload Optimized Frequency is disabled in
> the platform
> [    T1] powernv_idle_driver registered
> [    T1] nx_compress_powernv: coprocessor found on chip 0, CT 3 CI 1
> [    T1] nx_compress_powernv: coprocessor found on chip 8, CT 3 CI 9
> [    T1] usbcore: registered new interface driver usbhid
> [    T1] usbhid: USB HID core driver
> [    T1] ipip: IPv4 and MPLS over IPv4 tunneling driver
> [    T1] NET: Registered PF_INET6 protocol family
> [    T1] Segment Routing with IPv6
> [    T1] In-situ OAM (IOAM) with IPv6
> [    T1] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [    T1] BUG: Kernel NULL pointer dereference on write at 0x00000000
> [    T1] Faulting instruction address: 0xc0000000008e2400
> [    T1] Oops: Kernel access of bad area, sig: 11 [#1]
> [    T1] LE PAGE_SIZE=64K MMU=Hash PREEMPT SMP NR_CPUS=16 NUMA PowerNV
> [    T1] Modules linked in:
> [    T1] CPU: 11 PID: 1 Comm: swapper/0 Not tainted
> 5.17.0-rc1-00032-gdd81e1c7d5fb #29
> [    T1] NIP:  c0000000008e2400 LR: c000000000d65db0 CTR: c000000000f0bb60
> [    T1] REGS: c0000000125033e0 TRAP: 0380   Not tainted
> (5.17.0-rc1-00032-gdd81e1c7d5fb)
> [    T1] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 42800c40
> XER: 00000000
> [    T1] CFAR: c000000000d65dac IRQMASK: 0
> [    T1] GPR00: c000000000d65b40 c000000012503680 c00000000290c600
> 0000000000000000
> [    T1] GPR04: ffffffffffffffff 00000000ffffffff 0000000000000000
> 0000000000000cc0
> [    T1] GPR08: 0000000000000000 0000000000000000 ffffffffffffffff
> 0000000000000001
> [    T1] GPR12: 0000000000000000 c000007fffff6c00 c000000000012478
> 0000000000000000
> [    T1] GPR16: 0000000000000000 0000000000000000 0000000000000000
> 0000000000000000
> [    T1] GPR20: 0000000000000000 c000000002810100 0000000000000cc0
> 0000000000000000
> [    T1] GPR24: 0000000000000010 c00000000294cf50 0000000000000000
> 0000000000000000
> [    T1] GPR28: 0000000000000000 c00000001ec61000 0000000000000000
> c000000012503680
> [    T1] NIP [c0000000008e2400] strlen+0x10/0x30
> [    T1] LR [c000000000d65db0] if_nlmsg_size+0x150/0x360
> [    T1] Call Trace:
> [    T1] [c000000012503680] [c0000000125036c0] 0xc0000000125036c0
> (unreliable)
> [    T1] [c0000000125036f0] [c000000000d65b40]
> rtmsg_ifinfo_build_skb+0x80/0x1a0
> [    T1] [c0000000125037b0] [c000000000d66be0] rtmsg_ifinfo+0x70/0xd0
> [    T1] [c000000012503800] [c000000000d4de50]
> register_netdevice+0x690/0x770
> [    T1] [c000000012503890] [c000000000d4e2bc] register_netdev+0x4c/0x80
> [    T1] [c0000000125038c0] [c000000000f4784c] sit_init_net+0x10c/0x1d0
> [    T1] [c000000012503910] [c000000000d33c0c] ops_init+0x13c/0x1b0
> [    T1] [c000000012503970] [c000000000d331bc]
> register_pernet_operations+0xec/0x1e0
> [    T1] [c0000000125039d0] [c000000000d33440]
> register_pernet_device+0x60/0xd0
> [    T1] [c000000012503a20] [c000000002085478] sit_init+0x54/0x160
> [    T1] [c000000012503ab0] [c000000000011ba8] do_one_initcall+0xd8/0x3b0
> [    T1] [c000000012503c70] [c000000002006064] do_initcall_level+0xe4/0x1c4
> [    T1] [c000000012503cc0] [c000000002005f20] do_initcalls+0x84/0xe4
> [    T1] [c000000012503d40] [c000000002005c7c]
> kernel_init_freeable+0x160/0x1ec
> [    T1] [c000000012503da0] [c0000000000124ac] kernel_init+0x3c/0x270
> [    T1] [c000000012503e10] [c00000000000cd64]
> ret_from_kernel_thread+0x5c/0x64
> [    T1] Instruction dump:
> [    T1] eb81ffe0 7c0803a6 4e800020 00000000 00000000 00000000 60000000
> 60000000
> [    T1] 3883ffff 60000000 60000000 60000000 <8ca40001> 28050000
> 4082fff8 7c632050
> [    T1] ---[ end trace 0000000000000000 ]---
> [    T1]
> [  T206] ata4: SATA link down (SStatus 0 SControl 300)
> [  T204] ata3: SATA link down (SStatus 0 SControl 300)
> [  T200] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  T200] ata1.00: ATA-10: ST1000NX0313         00LY266 00LY265IBM, BE33,
> max UDMA/133
> [  T200] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 32), AA
> [  T200] ata1.00: configured for UDMA/133
> [    T7] scsi 0:0:0:0: Direct-Access     ATA      ST1000NX0313     BE33
> PQ: 0 ANSI: 5
> [    T7] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [  T209] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00
> TB/932 GiB)
> [  T209] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [  T209] sd 0:0:0:0: [sda] Write Protect is off
> [  T209] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [  T209] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [  T209]  sda: sda1 sda2
> [  T209] sd 0:0:0:0: [sda] Attached SCSI removable disk
> [    T1] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> ```
>
>
> Kind regards,
>
> Paul
