Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD27540032F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349906AbhICQX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349758AbhICQX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:23:58 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B602C061575;
        Fri,  3 Sep 2021 09:22:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n27so13166152eja.5;
        Fri, 03 Sep 2021 09:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PQ254Rhn6kGNPlEusFL3jTJsf/62drn9dNDQBhsIYK0=;
        b=S66y+NXADLwET0o15RQ3On72lRs6tMqdhlu+aVgkCZECPhfg+ixhxsW28N/S6PgzYM
         R4ubBFDO0b4XMsVCFh1jq2CCEFsdVzUJy6XQWUc7gXJsukXltoJl84O1HrX7w7tHYAkB
         hUsOAgsGu0pJG9hHG4jFXdrvyEnlUKIWDdubZdwxIqnqbtojD+HX5kK0ga+Mav1I7rko
         T2GSaw20EZJgWXfeMt8VqZmtMgeb0/lnVf1GjjLS4VY5IfwP7D6RI7t5wDZLAtmiB1QA
         8nlhyN7cAvzhfETooUk/2RltoryjKFGopgc6pBBQYioosR5V+Jrh9k6kg+JkFM0PgHk+
         1vdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PQ254Rhn6kGNPlEusFL3jTJsf/62drn9dNDQBhsIYK0=;
        b=QoxWpo17lGQnVyDTY8e2+HBAo5SJjd6dunCigp/Xg8QV0nVxnxOATNPd9qArd95EoS
         vZEuP4Ue8rQyACCVVCVvf+MwWprjStHyTK8ScXtGbO7dqNRkmOXcbRpmpqGH9pitnlSh
         z9Ws3HexaPaDyRrSACwDdNvs34R+ocU7XWRUsJhHxhhC2g7wfLHTPc+Zo8SRC4/7JMXd
         uq3uC5DXlbrx1IMEEMbsbL/9T26JjFPB2gnYJ20H5TBSTfK/02t3hpQAzk5xz7lOh/sD
         Ooat03ShHMvLs2UZARUvWzjU86zGc2MkeS3Ljk1YJLYzGTnTIf8qJTdYlkD5l35I7LyI
         IUYA==
X-Gm-Message-State: AOAM530DocIBFbrhpeJAsFAF2mAg5QCtaYenuPgJNTfGrZ/EH5ADW3X3
        yg6TXXmE+aELBTON6PAuU74=
X-Google-Smtp-Source: ABdhPJztPq7XGISMZSB6dvo3aBprDN2dkP0PFl2dpY33ZSIdLu6ckcIg3su3z+RdnOoo2S1Re/vLqg==
X-Received: by 2002:a17:906:5953:: with SMTP id g19mr5117225ejr.443.1630686175231;
        Fri, 03 Sep 2021 09:22:55 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id j24sm3185617edj.56.2021.09.03.09.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:22:54 -0700 (PDT)
Date:   Fri, 3 Sep 2021 19:22:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210903162253.5utsa45zy6h4v76t@skbuf>
References: <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210902202905.GN22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ trimming the CC list, I'm sure most people don't care, if they do,
  they can watch the mailing list ]

On Thu, Sep 02, 2021 at 09:29:05PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 11:21:24PM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 09:03:01PM +0100, Russell King (Oracle) wrote:
> > > # systemctl list-dependencies networking.service
> > > networking.service
> > >   ├─ifupdown-pre.service
> > >   ├─system.slice
> > >   └─network.target
> > > # systemctl list-dependencies ifupdown-pre.service
> > > ifupdown-pre.service
> > >   ├─system.slice
> > >   └─systemd-udevd.service
> > > 
> > > Looking in the service files for a better idea:
> > > 
> > > networking.service:
> > > Requires=ifupdown-pre.service
> > > Wants=network.target
> > > After=local-fs.target network-pre.target apparmor.service systemd-sysctl.service systemd-modules-load.service ifupdown-pre.service
> > > Before=network.target shutdown.target network-online.target
> > > 
> > > ifupdown-pre.service:
> > > Wants=systemd-udevd.service
> > > After=systemd-udev-trigger.service
> > > Before=network.target
> > > 
> > > So, the dependency you mention is already present. As is a dependency
> > > on udev. The problem is udev does all the automatic module loading
> > > asynchronously and in a multithreaded way.
> > > 
> > > I don't think there's a way to make systemd wait for all module loads
> > > to complete.
> > 
> > So ifupdown-pre.service has a call to "udevadm settle". This "watches
> > the udev event queue, and exits if all current events are handled",
> > according to the man page. But which current events? ifupdown-pre.service
> > does not have the dependency on systemd-modules-load.service, just
> > networking.service does. So maybe ifupdown-pre.service does not wait for
> > DSA to finish initializing, then it tells networking.service that all is ok.
> 
> ifupdown-pre.service does have a call to udevadm settle, and that
> does get called from what I can tell.
> 
> systemd-modules-load.service is an entire red herring. The only
> module listed in the various modules-load.d directories is "tun"
> for openvpn (which isn't currently being used.)
> 
> As I've already told you (and you seem to have ignored), DSA gets
> loaded by udev, not by systemd-modules-load.service.
> systemd-modules-load.service is irrelevant to my situation.
> 
> I think there's a problem with "and exits if all current events are
> handled" - does that mean it's fired off a modprobe process which
> is in progress, or does that mean that the modprobe process has
> completed.
> 
> Given that we can see that ifup is being run while the DSA module is
> still in the middle of probing, the latter interpretation can not be
> true - unless systemd is ignoring the dependencies. Or just in
> general, systemd being systemd (I have very little faith in systemd
> behaving as it should.)

So I've set a fresh installation of Debian Buster on my Turris MOX,
which has 3 mv88e6xxx switches, and I've put the mv88e6xxx driver inside
the rootfs as a module to be loaded by udev based on modaliases just
like you've said.  Additionally, the PHY driver is also a module.
The kernel is built straight from the v5.13 tag, absolutely no changes.

Literally the only changes I've done to this system are:
1. install bridge-utils
2. create this file, it is sourced by /etc/network/interfaces:
root@debian:~# cat /etc/network/interfaces.d/bridge
auto br0
iface br0 inet manual
        bridge_ports lan1 lan2 lan3 lan4 lan5 lan6 lan7 lan8 lan9 lan10 lan11 lan12 lan13 lan14 lan15 lan16 lan17 lan18 lan19 lan20 lan21 lan22 lan23 lan24 sfp
        bridge_maxwait 0

I've rebooted the board about 10 times and it has never skipped
enslaving a port to the bridge.

Here are my logs:

CZ.NIC Turris Mox Secure Firmware version v2021.01.22 (Jan 22 2021 17:10:27)
Initializing DDR... done


U-Boot 2018.11 (Dec 16 2018 - 12:50:19 +0000), Build: jenkins-turris-os-packages-kittens-mox-90

DRAM:  1 GiB
Enabling Armada 3720 wComphy-0: SGMII1        3.125 Gbps
Comphy-1: PEX0          5 Gbps
Comphy-2: USB3_HOST0    5 Gbps
MMC:   sdhci@d8000: 0
Loading Environment from SPI Flash... SF: Detected w25q64dw with page size 256 Bytes, erase size 4 KiB, total 8 MiB
OK
Model: CZ.NIC Turris Mox Board
Net:   eth0: neta@30000
Turris Mox:
  Board version: 22
  RAM size: 1024 MiB
  Serial Number: 0000000D3000801C
  ECDSA Public Key: 020096edae3f978d4b5dfcbf147ffc4b3acf2710b2af3ff8cdf4c0b84d02d8dfcbf7c3ea3e438b2c1aa4d2161b34723d9051928b6c9f5e89edcb9db52450fc0b5741b6
  SD/eMMC version: SD
Module Topology:
   1: Peridot Switch Module (8-port)
   2: Peridot Switch Module (8-port)
   3: Peridot Switch Module (8-port)
   4: SFP Module

Hit any key to stop autoboot:  0
gpio: pin GPIO221 (gpio 57) value is 0
gpio: pin GPIO220 (gpio 56) value is 1
SF: Detected w25q64dw with page size 256 Bytes, erase size 4 KiB, total 8 MiB
device 0 offset 0x7f0000, size 0x10000
SF: 65536 bytes @ 0x7f0000 Read: OK
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:1...
Found /extlinux/extlinux.conf
Retrieving file: /extlinux/extlinux.conf
176 bytes read in 14 ms (11.7 KiB/s)
1:      Debian Buster
Retrieving file: /extlinux/../Image
47782400 bytes read in 2039 ms (22.3 MiB/s)
append: console=ttyMV0,115200 root=PARTUUID=195a145f-3cbc-4b24-a833-5eddf2969b5a rw rootwait
Retrieving file: /extlinux/../armada-3720-turris-mox.dtb
20223 bytes read in 26 ms (758.8 KiB/s)
## Flattened Device Tree blob at 04f00000
   Booting using the fdt blob at 0x4f00000
   Loading Device Tree to 000000003bf14000, end 000000003bf1befe ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 5.13.0 (tigrisor@skbuf) (aarch64-none-linux-gnu-gcc (GNU Toolchain for the A-profile Architecture 10.2-2020.11 (arm-10.16)) 10.2.1 20201103, GNU ld (GNU Toolchain for the A-pro
file Architecture 10.2-2020.11 (arm-10.16)) 2.35.1.20201028) #54 SMP PREEMPT Fri Sep 3 14:43:30 EEST 2021
[    0.000000] Machine model: CZ.NIC Turris Mox Board
[    0.000000] efi: UEFI not found.
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x3fde59c0-0x3fde7fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000]   node   0: [mem 0x0000000004000000-0x00000000041fffff]
[    0.000000]   node   0: [mem 0x0000000004200000-0x000000003fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] On node 0 totalpages: 262144
[    0.000000]   DMA zone: 4096 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 262144 pages, LIFO batch:63
[    0.000000] cma: Reserved 32 MiB at 0x000000003cc00000
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.1
[    0.000000] percpu: Embedded 482 pages/cpu s1934168 r8192 d31912 u1974272
[    0.000000] pcpu-alloc: s1934168 r8192 d31912 u1974272 alloc=482*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: detected: GIC system register CPU interface
[    0.000000] CPU features: detected: ARM erratum 845719
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 258048
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: console=ttyMV0,115200 root=PARTUUID=195a145f-3cbc-4b24-a833-5eddf2969b5a rw rootwait
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 931320K/1048576K available (22272K kernel code, 4550K rwdata, 10356K rodata, 9344K init, 11760K bss, 84488K reserved, 32768K cma-reserved)
[    0.000000] trace event string verifier disabled
[    0.000000] Running RCU self tests
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu:     RCU lockdep checking is enabled.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000]  Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
[    0.000000] GICv3: 192 SPIs implemented
[    0.000000] GICv3: 0 Extended SPIs implemented
[    0.000000] GICv3: Distributor has no Range Selector support
[    0.000000] Root IRQ handler: gic_handle_irq
[    0.000000] GICv3: 16 PPIs implemented
[    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x00000000d1d40000
[    0.000000] random: get_random_bytes called from start_kernel+0x3d8/0x5d4 with crng_init=0
[    0.000000] arch_timer: cp15 timer(s) running at 12.50MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x2e2049cda, max_idle_ns: 440795202628 ns
[    0.000001] sched_clock: 56 bits at 12MHz, resolution 80ns, wraps every 4398046511080ns
[    0.002616] Console: colour dummy device 80x25
[    0.002687] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.002710] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.002732] ... MAX_LOCK_DEPTH:          48
[    0.002754] ... MAX_LOCKDEP_KEYS:        8192
[    0.002776] ... CLASSHASH_SIZE:          4096
[    0.002797] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.002819] ... MAX_LOCKDEP_CHAINS:      65536
[    0.002840] ... CHAINHASH_SIZE:          32768
[    0.002862]  memory used by lock dependency info: 6877 kB
[    0.002884]  memory used for stack traces: 4224 kB
[    0.002906]  per task-struct memory footprint: 2688 bytes
[    0.003094] Calibrating delay loop (skipped), value calculated using timer frequency.. 25.00 BogoMIPS (lpj=50000)
[    0.003138] pid_max: default: 32768 minimum: 301
[    0.003510] LSM: Security Framework initializing
[    0.003754] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
[    0.003795] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
[    0.013822] Running RCU-tasks wait API self tests
[    0.118377] rcu: Hierarchical SRCU implementation.
[    0.121770] EFI services will not be available.
[    0.123197] smp: Bringing up secondary CPUs ...
[    0.129494] Detected VIPT I-cache on CPU1
[    0.129542] GICv3: CPU1: found redistributor 1 region 0:0x00000000d1d60000
[    0.129643] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.130957] smp: Brought up 1 node, 2 CPUs
[    0.131045] SMP: Total of 2 processors activated.
[    0.131077] CPU features: detected: 32-bit EL0 Support
[    0.131104] CPU features: detected: 32-bit EL1 Support
[    0.131135] CPU features: detected: CRC32 instructions
[    0.137511] Callback from call_rcu_tasks_trace() invoked.
[    0.198818] CPU: All CPU(s) started at EL2
[    0.199004] alternatives: patching kernel code
[    0.203270] devtmpfs: initialized
[    0.246144] KASLR disabled due to lack of seed
[    0.249205] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.249298] futex hash table entries: 512 (order: 4, 65536 bytes, linear)
[    0.252663] pinctrl core: initialized pinctrl subsystem
[    0.260829] DMI not present or invalid.
[    0.263534] NET: Registered protocol family 16
[    0.273637] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
[    0.274304] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.275007] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.275524] audit: initializing netlink subsys (disabled)
[    0.276525] audit: type=2000 audit(0.272:1): state=initialized audit_enabled=0 res=1
[    0.283221] thermal_sys: Registered thermal governor 'step_wise'
[    0.283262] thermal_sys: Registered thermal governor 'power_allocator'
[    0.283941] cpuidle: using governor menu
[    0.285205] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.285524] ASID allocator initialised with 65536 entries
[    0.293724] Serial: AMBA PL011 UART driver
[    0.328155] Callback from call_rcu_tasks() invoked.
[    0.528710] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.528765] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.528795] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.528826] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    0.549030] cryptd: max_cpu_qlen set to 1000
[    0.631518] raid6: neonx8   gen()  1545 MB/s
[    0.700244] raid6: neonx8   xor()  1090 MB/s
[    0.768968] raid6: neonx4   gen()  1583 MB/s
[    0.837706] raid6: neonx4   xor()  1084 MB/s
[    0.906882] raid6: neonx2   gen()  1480 MB/s
[    0.975201] raid6: neonx2   xor()  1005 MB/s
[    1.043921] raid6: neonx1   gen()  1290 MB/s
[    1.112647] raid6: neonx1   xor()   871 MB/s
[    1.181364] raid6: int64x8  gen()  1196 MB/s
[    1.250082] raid6: int64x8  xor()   641 MB/s
[    1.318810] raid6: int64x4  gen()  1334 MB/s
[    1.387527] raid6: int64x4  xor()   683 MB/s
[    1.456259] raid6: int64x2  gen()  1159 MB/s
[    1.524977] raid6: int64x2  xor()   621 MB/s
[    1.593706] raid6: int64x1  gen()   861 MB/s
[    1.662413] raid6: int64x1  xor()   430 MB/s
[    1.662444] raid6: using algorithm neonx4 gen() 1583 MB/s
[    1.662473] raid6: .... xor() 1084 MB/s, rmw enabled
[    1.662501] raid6: using neon recovery algorithm
[    1.664879] ACPI: Interpreter disabled.
[    1.677029] iommu: Default domain type: Passthrough
[    1.679150] vgaarb: loaded
[    1.682077] SCSI subsystem initialized
[    1.683241] libata version 3.00 loaded.
[    1.685143] usbcore: registered new interface driver usbfs
[    1.685550] usbcore: registered new interface driver hub
[    1.685815] usbcore: registered new device driver usb
[    1.690055] pps_core: LinuxPPS API ver. 1 registered
[    1.690094] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.690204] PTP clock support registered
[    1.690950] EDAC MC: Ver: 3.0.0
[    1.701303] FPGA manager framework
[    1.702258] Advanced Linux Sound Architecture Driver Initialized.
[    1.706558] Bluetooth: Core ver 2.22
[    1.706806] NET: Registered protocol family 31
[    1.706838] Bluetooth: HCI device and connection manager initialized
[    1.706951] Bluetooth: HCI socket layer initialized
[    1.707008] Bluetooth: L2CAP socket layer initialized
[    1.707180] Bluetooth: SCO socket layer initialized
[    1.710823] clocksource: Switched to clocksource arch_sys_counter
[    2.289470] VFS: Disk quotas dquot_6.6.0
[    2.289782] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.291786] pnp: PnP ACPI: disabled
[    2.341080] NET: Registered protocol family 2
[    2.341648] IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    2.345448] tcp_listen_portaddr_hash hash table entries: 512 (order: 3, 45056 bytes, linear)
[    2.345608] TCP established hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    2.345933] TCP bind hash table entries: 8192 (order: 7, 655360 bytes, linear)
[    2.347187] TCP: Hash tables configured (established 8192 bind 8192)
[    2.347903] UDP hash table entries: 512 (order: 4, 98304 bytes, linear)
[    2.348150] UDP-Lite hash table entries: 512 (order: 4, 98304 bytes, linear)
[    2.349667] NET: Registered protocol family 1
[    2.354471] RPC: Registered named UNIX socket transport module.
[    2.354551] RPC: Registered udp transport module.
[    2.354584] RPC: Registered tcp transport module.
[    2.354615] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.354668] PCI: CLS 0 bytes, default 64
[    2.358652] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[    2.359972] kvm [1]: IPA Size Limit: 40 bits
[    2.381204] kvm [1]: vgic-v2@d1da0000
[    2.381325] kvm [1]: GIC system register CPU interface enabled
[    2.381708] kvm [1]: vgic interrupt IRQ9
[    2.383265] kvm [1]: Hyp mode initialized successfully
[    2.416311] Initialise system trusted keyrings
[    2.417624] workingset: timestamp_bits=42 max_order=18 bucket_order=0
[    2.422502] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.425268] NFS: Registering the id_resolver key type
[    2.425464] Key type id_resolver registered
[    2.425526] Key type id_legacy registered
[    2.425756] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    2.425845] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    2.427170] fuse: init (API version 7.33)
[    2.428210] 9p: Installing v9fs 9p2000 file system support
[    2.475384] xor: measuring software checksum speed
[    2.480527]    8regs           :  1966 MB/sec
[    2.484986]    32regs          :  2327 MB/sec
[    2.494573]    arm64_neon      :  1041 MB/sec
[    2.494603] xor: using function: 32regs (2327 MB/sec)
[    2.494654] Key type asymmetric registered
[    2.495419] Asymmetric key parser 'x509' registered
[    2.495702] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    2.496776] io scheduler mq-deadline registered
[    2.496831] io scheduler kyber registered
[    2.600042] EINJ: ACPI disabled.
[    2.650427] mv_xor d0060900.xor: Marvell shared XOR driver
[    2.766143] mv_xor d0060900.xor: Marvell XOR (Descriptor Mode): ( xor cpy intr )
[    2.882192] mv_xor d0060900.xor: Marvell XOR (Descriptor Mode): ( xor cpy intr )
[    2.882952] debugfs: Directory 'd0060900.xor' with parent 'dmaengine' already present!
[    2.942503] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.961295] SuperH (H)SCI(F) driver initialized
[    2.964171] msm_serial: driver initialized
[    2.973924] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    3.043037] brd: module loaded
[    3.110377] loop: module loaded
[    3.116450] megasas: 07.714.04.00-rc1
[    3.139783] spi-nor spi0.0: w25q64dw (8192 Kbytes)
[    3.143912] 5 fixed-partitions partitions found on MTD device spi0.0
[    3.143976] Creating 5 MTD partitions on "spi0.0":
[    3.144045] 0x000000000000-0x000000020000 : "secure-firmware"
[    3.167631] 0x000000020000-0x000000180000 : "a53-firmware"
[    3.186540] 0x000000180000-0x000000190000 : "u-boot-env"
[    3.206480] 0x000000190000-0x0000007f0000 : "Rescue system"
[    3.226539] 0x0000007f0000-0x000000800000 : "dtb"
[    3.250087] moxtet spi0.1: Found MOX A (CPU) module
[    3.250147] moxtet spi0.1: Found MOX E (8 port switch) module
[    3.250182] moxtet spi0.1: Found MOX E (8 port switch) module
[    3.250214] moxtet spi0.1: Found MOX E (8 port switch) module
[    3.250247] moxtet spi0.1: Found MOX D (SFP cage) module
[    3.252902]
[    3.252930] =============================
[    3.252939] [ BUG: Invalid wait context ]
[    3.252948] 5.13.0 #54 Not tainted
[    3.252958] -----------------------------
[    3.252966] swapper/0/1 is trying to lock:
[    3.252976] ffff000000e1e460 (&info->irq_lock){....}-{3:3}, at: armada_37xx_irq_set_type+0x50/0x174
[    3.253026] other info that might help us debug this:
[    3.253034] context-{5:5}
[    3.253042] 5 locks held by swapper/0/1:
[    3.253052]  #0: ffff0000003321a0 (&dev->mutex){....}-{4:4}, at: device_driver_attach+0x40/0xd0
[    3.253093]  #1: ffff800012c9b4c8 (spi_add_lock){+.+.}-{4:4}, at: spi_add_device+0xa0/0x1f0
[    3.253135]  #2: ffff000001fae190 (&dev->mutex){....}-{4:4}, at: __device_attach+0x3c/0x184
[    3.253171]  #3: ffff000001fac688 (request_class){+.+.}-{4:4}, at: __setup_irq+0xb8/0x760
[    3.253210]  #4: ffff000001fac4f8 (lock_class){....}-{2:2}, at: __setup_irq+0xdc/0x760
[    3.253245] stack backtrace:
[    3.253255] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0 #54
[    3.253268] Hardware name: CZ.NIC Turris Mox Board (DT)
[    3.253277] Call trace:
[    3.253285]  dump_backtrace+0x0/0x1b0
[    3.253303]  show_stack+0x18/0x24
[    3.253318]  dump_stack+0xf8/0x168
[    3.253334]  __lock_acquire+0x7d8/0x1c5c
[    3.253351]  lock_acquire.part.0+0xe4/0x220
[    3.253365]  lock_acquire+0x68/0x8c
[    3.253380]  _raw_spin_lock_irqsave+0x88/0x144
[    3.253394]  armada_37xx_irq_set_type+0x50/0x174
[    3.253410]  __irq_set_trigger+0x60/0x18c
[    3.253423]  __setup_irq+0x2b0/0x760
[    3.253436]  request_threaded_irq+0xec/0x1b0
[    3.253449]  moxtet_probe+0x208/0x710
[    3.253464]  spi_probe+0x84/0xe4
[    3.253478]  really_probe+0xe4/0x510
[    3.253491]  driver_probe_device+0x64/0xcc
[    3.253504]  __device_attach_driver+0xb8/0x114
[    3.253518]  bus_for_each_drv+0x78/0xd0
[    3.253531]  __device_attach+0xdc/0x184
[    3.253544]  device_initial_probe+0x14/0x20
[    3.253557]  bus_probe_device+0x9c/0xa4
[    3.253569]  device_add+0x378/0x874
[    3.253585]  spi_add_device+0xf8/0x1f0
[    3.253601]  of_register_spi_device+0x20c/0x35c
[    3.253616]  spi_register_controller+0x670/0x8f0
[    3.253631]  devm_spi_register_controller+0x24/0x80
[    3.253647]  a3700_spi_probe+0x2c4/0x3c0
[    3.253660]  platform_probe+0x68/0xe0
[    3.253675]  really_probe+0xe4/0x510
[    3.253688]  driver_probe_device+0x64/0xcc
[    3.253701]  device_driver_attach+0xc8/0xd0
[    3.253714]  __driver_attach+0x94/0x13c
[    3.253726]  bus_for_each_dev+0x70/0xd0
[    3.253739]  driver_attach+0x24/0x30
[    3.253751]  bus_add_driver+0x108/0x1f0
[    3.253763]  driver_register+0x78/0x130
[    3.253777]  __platform_driver_register+0x28/0x34
[    3.253791]  a3700_spi_driver_init+0x1c/0x28
[    3.253807]  do_one_initcall+0x88/0x450
[    3.253820]  kernel_init_freeable+0x308/0x390
[    3.253834]  kernel_init+0x14/0x120
[    3.253850]  ret_from_fork+0x10/0x34
[    3.269950] libphy: Fixed MDIO Bus: probed
[    3.273594] tun: Universal TUN/TAP device driver, 1.6
[    3.274249] CAN device driver interface
[    3.279899] thunder_xcv, ver 1.0
[    3.280038] thunder_bgx, ver 1.0
[    3.280151] nicpf, ver 1.0
[    3.284189] hclge is initializing
[    3.284281] hns3: Hisilicon Ethernet Network Driver for Hip08 Family - version
[    3.284299] hns3: Copyright (c) 2017 Huawei Corporation.
[    3.284474] e1000: Intel(R) PRO/1000 Network Driver
[    3.284492] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.284617] e1000e: Intel(R) PRO/1000 Network Driver
[    3.284632] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    3.284752] igb: Intel(R) Gigabit Ethernet Network Driver
[    3.284767] igb: Copyright (c) 2007-2014 Intel Corporation.
[    3.284863] igbvf: Intel(R) Gigabit Virtual Function Network Driver
[    3.284878] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.286657] libphy: orion_mdio_bus: probed
[    3.294134] mvneta d0030000.ethernet eth0: Using hardware mac address d8:58:d7:00:ca:6c
[    3.295128] sky2: driver version 1.30
[    3.300789] VFIO - User Level meta-driver version: 0.3
[    3.306650] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.306686] ehci-pci: EHCI PCI platform driver
[    3.306887] ehci-platform: EHCI generic platform driver
[    3.307310] ehci-orion: EHCI orion driver
[    3.308132] orion-ehci d005e000.usb: EHCI Host Controller
[    3.308192] orion-ehci d005e000.usb: new USB bus registered, assigned bus number 1
[    3.308474] orion-ehci d005e000.usb: irq 23, io mem 0xd005e000
[    3.322825] orion-ehci d005e000.usb: USB 2.0 started, EHCI 1.00
[    3.324630] hub 1-0:1.0: USB hub found
[    3.324737] hub 1-0:1.0: 1 port detected
[    3.325845] ehci-exynos: EHCI Exynos driver
[    3.326314] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.326382] ohci-pci: OHCI PCI platform driver
[    3.326506] ohci-platform: OHCI generic platform driver
[    3.327105] ohci-exynos: OHCI Exynos driver
[    3.327628] usbcore: registered new interface driver cdc_acm
[    3.327649] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    3.327787] usbcore: registered new interface driver usb-storage
[    3.328001] usbcore: registered new interface driver usbserial_generic
[    3.328063] usbserial: USB Serial support registered for generic
[    3.328147] usbcore: registered new interface driver aircable
[    3.328206] usbserial: USB Serial support registered for aircable
[    3.328289] usbcore: registered new interface driver ark3116
[    3.328349] usbserial: USB Serial support registered for ark3116
[    3.328437] usbcore: registered new interface driver belkin_sa
[    3.328496] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    3.328581] usbcore: registered new interface driver ch341
[    3.328638] usbserial: USB Serial support registered for ch341-uart
[    3.328726] usbcore: registered new interface driver cp210x
[    3.328784] usbserial: USB Serial support registered for cp210x
[    3.328877] usbcore: registered new interface driver cyberjack
[    3.328936] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    3.329021] usbcore: registered new interface driver cypress_m8
[    3.329079] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    3.329138] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    3.329196] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    3.329281] usbcore: registered new interface driver digi_acceleport
[    3.329343] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    3.329401] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    3.329486] usbcore: registered new interface driver io_edgeport
[    3.329544] usbserial: USB Serial support registered for Edgeport 2 port adapter
[    3.329602] usbserial: USB Serial support registered for Edgeport 4 port adapter
[    3.329662] usbserial: USB Serial support registered for Edgeport 8 port adapter
[    3.329721] usbserial: USB Serial support registered for EPiC device
[    3.329809] usbcore: registered new interface driver io_ti
[    3.329869] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[    3.329928] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[    3.330015] usbcore: registered new interface driver empeg
[    3.330074] usbserial: USB Serial support registered for empeg
[    3.330169] usbcore: registered new interface driver f81534a_ctrl
[    3.330250] usbcore: registered new interface driver f81232
[    3.330310] usbserial: USB Serial support registered for f81232
[    3.330368] usbserial: USB Serial support registered for f81534a
[    3.330456] usbcore: registered new interface driver f81534
[    3.330515] usbserial: USB Serial support registered for Fintek F81532/F81534
[    3.330600] usbcore: registered new interface driver ftdi_sio
[    3.330659] usbserial: USB Serial support registered for FTDI USB Serial Device
[    3.330857] usbcore: registered new interface driver garmin_gps
[    3.330922] usbserial: USB Serial support registered for Garmin GPS usb/tty
[    3.331010] usbcore: registered new interface driver ipaq
[    3.331071] usbserial: USB Serial support registered for PocketPC PDA
[    3.331168] usbcore: registered new interface driver ipw
[    3.331227] usbserial: USB Serial support registered for IPWireless converter
[    3.331312] usbcore: registered new interface driver ir_usb
[    3.331377] usbserial: USB Serial support registered for IR Dongle
[    3.331463] usbcore: registered new interface driver iuu_phoenix
[    3.331523] usbserial: USB Serial support registered for iuu_phoenix
[    3.331608] usbcore: registered new interface driver keyspan
[    3.331668] usbserial: USB Serial support registered for Keyspan - (without firmware)
[    3.331735] usbserial: USB Serial support registered for Keyspan 1 port adapter
[    3.331794] usbserial: USB Serial support registered for Keyspan 2 port adapter
[    3.331857] usbserial: USB Serial support registered for Keyspan 4 port adapter
[    3.331946] usbcore: registered new interface driver keyspan_pda
[    3.332006] usbserial: USB Serial support registered for Keyspan PDA
[    3.332067] usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
[    3.332153] usbcore: registered new interface driver kl5kusb105
[    3.332213] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    3.332302] usbcore: registered new interface driver kobil_sct
[    3.332362] usbserial: USB Serial support registered for KOBIL USB smart card terminal
[    3.332456] usbcore: registered new interface driver mct_u232
[    3.332517] usbserial: USB Serial support registered for MCT U232
[    3.332601] usbcore: registered new interface driver metro_usb
[    3.332661] usbserial: USB Serial support registered for Metrologic USB to Serial
[    3.332745] usbcore: registered new interface driver mos7720
[    3.332808] usbserial: USB Serial support registered for Moschip 2 port adapter
[    3.332894] usbcore: registered new interface driver mos7840
[    3.332954] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    3.333040] usbcore: registered new interface driver mxuport
[    3.333100] usbserial: USB Serial support registered for MOXA UPort
[    3.333188] usbcore: registered new interface driver navman
[    3.333248] usbserial: USB Serial support registered for navman
[    3.333336] usbcore: registered new interface driver omninet
[    3.333396] usbserial: USB Serial support registered for ZyXEL - omni.net usb
[    3.333483] usbcore: registered new interface driver opticon
[    3.333543] usbserial: USB Serial support registered for opticon
[    3.333627] usbcore: registered new interface driver option
[    3.333688] usbserial: USB Serial support registered for GSM modem (1-port)
[    3.333815] usbcore: registered new interface driver oti6858
[    3.333876] usbserial: USB Serial support registered for oti6858
[    3.333962] usbcore: registered new interface driver pl2303
[    3.334022] usbserial: USB Serial support registered for pl2303
[    3.334109] usbcore: registered new interface driver qcaux
[    3.334170] usbserial: USB Serial support registered for qcaux
[    3.334255] usbcore: registered new interface driver qcserial
[    3.334320] usbserial: USB Serial support registered for Qualcomm USB modem
[    3.334412] usbcore: registered new interface driver quatech2
[    3.334474] usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    3.334560] usbcore: registered new interface driver safe_serial
[    3.334621] usbserial: USB Serial support registered for safe_serial
[    3.334707] usbcore: registered new interface driver sierra
[    3.334934] usbserial: USB Serial support registered for Sierra USB modem
[    3.335041] usbcore: registered new interface driver usb_serial_simple
[    3.335106] usbserial: USB Serial support registered for carelink
[    3.335166] usbserial: USB Serial support registered for zio
[    3.335227] usbserial: USB Serial support registered for funsoft
[    3.335286] usbserial: USB Serial support registered for flashloader
[    3.335349] usbserial: USB Serial support registered for google
[    3.335408] usbserial: USB Serial support registered for libtransistor
[    3.335475] usbserial: USB Serial support registered for vivopay
[    3.335536] usbserial: USB Serial support registered for moto_modem
[    3.335596] usbserial: USB Serial support registered for motorola_tetra
[    3.335656] usbserial: USB Serial support registered for novatel_gps
[    3.335716] usbserial: USB Serial support registered for hp4x
[    3.335776] usbserial: USB Serial support registered for suunto
[    3.335836] usbserial: USB Serial support registered for siemens_mpi
[    3.335932] usbcore: registered new interface driver spcp8x5
[    3.335993] usbserial: USB Serial support registered for SPCP8x5
[    3.336081] usbcore: registered new interface driver ssu100
[    3.336142] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    3.336236] usbcore: registered new interface driver symbolserial
[    3.336298] usbserial: USB Serial support registered for symbol
[    3.336385] usbcore: registered new interface driver ti_usb_3410_5052
[    3.336452] usbserial: USB Serial support registered for TI USB 3410 1 port adapter
[    3.336514] usbserial: USB Serial support registered for TI USB 5052 2 port adapter
[    3.336606] usbcore: registered new interface driver upd78f0730
[    3.336669] usbserial: USB Serial support registered for upd78f0730
[    3.336759] usbcore: registered new interface driver visor
[    3.336821] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    3.336883] usbserial: USB Serial support registered for Sony Clie 5.0
[    3.336948] usbserial: USB Serial support registered for Sony Clie 3.5
[    3.337038] usbcore: registered new interface driver wishbone_serial
[    3.337102] usbserial: USB Serial support registered for wishbone_serial
[    3.337189] usbcore: registered new interface driver whiteheat
[    3.337252] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    3.337314] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    3.337406] usbcore: registered new interface driver xsens_mt
[    3.337469] usbserial: USB Serial support registered for xsens_mt
[    3.346631] i2c /dev entries driver
[    3.360127] armada_37xx_wdt d0008300.watchdog: Initial timeout 120 sec
[    3.368426] sdhci: Secure Digital Host Controller Interface driver
[    3.368459] sdhci: Copyright(c) Pierre Ossman
[    3.370502] Synopsys Designware Multimedia Card Interface Driver
[    3.373576] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.379205] ledtrig-cpu: registered to indicate activity on CPUs
[    3.384471] usbcore: registered new interface driver usbhid
[    3.384504] usbhid: USB HID core driver
[    3.403044] GACT probability NOT on
[    3.403099] Mirror/redirect action on
[    3.403230] u32 classifier
[    3.403244]     input device check on
[    3.403257]     Actions configured
[    3.403463] Initializing XFRM netlink socket
[    3.403749] NET: Registered protocol family 10
[    3.406489] Segment Routing with IPv6
[    3.406615] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.407957] NET: Registered protocol family 17
[    3.408039] NET: Registered protocol family 15
[    3.408579] can: controller area network core
[    3.408735] NET: Registered protocol family 29
[    3.408754] can: raw protocol
[    3.408775] can: broadcast manager protocol
[    3.408804] can: netlink gateway - max_hops=1
[    3.409021] 8021q: 802.1Q VLAN Support v1.8
[    3.409141] 9pnet: Installing 9P2000 support
[    3.409294] Key type dns_resolver registered
[    3.410102] registered taskstats version 1
[    3.410159] Loading compiled-in X.509 certificates
[    3.411555] Btrfs loaded, crc32c=crc32c-generic, zoned=no
[    3.424259] d0012000.serial: ttyMV0 at MMIO 0xd0012000 (irq = 0, base_baud = 1562500) is a mvebu-uart
[    6.178813] printk: console [ttyMV0] enabled
[    6.191496] i2c i2c-0: Not using recovery: no suitable method provided
[    6.198898] i2c i2c-0:  PXA I2C adapter
[    6.212395] mvneta d0040000.ethernet eth1: Using device tree mac address d8:58:d7:00:ca:6d
[    6.231158] xenon-sdhci d00d8000.sdhci: Got CD GPIO
[    6.264897] Turris Mox serial number 0000000D3000801C
[    6.270202]            board version 22
[    6.274218]            burned RAM size 1024 MiB
[    6.277463] xenon-sdhci d00d0000.sdhci: allocated mmc-pwrseq
[    6.365164] random: fast init done
[    6.366866] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    6.415033] random: crng init done
[    6.475127] mmc0: SDHCI controller on d00d8000.sdhci [d00d8000.sdhci] using ADMA
[    6.545422] ALSA device list:
[    6.548661]   No soundcards found.
[    6.576389] mmc1: SDHCI controller on d00d0000.sdhci [d00d0000.sdhci] using ADMA
[    6.584720] Waiting for root device PARTUUID=195a145f-3cbc-4b24-a833-5eddf2969b5a...
[    6.630705] mmc0: new ultra high speed SDR104 SDHC card at address 0007
[    6.639424] mmcblk0: mmc0:0007 SL32G 29.0 GiB
[    6.653280]  mmcblk0: p1 p2
[    6.699987] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.
[    6.710523] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    6.719093] devtmpfs: mounted
[    6.732709] Freeing unused kernel memory: 9344K
[    6.737711] Run /sbin/init as init process
[    6.742099]   with arguments:
[    6.745285]     /sbin/init
[    6.748201]   with environment:
[    6.751627]     HOME=/
[    6.754229]     TERM=linux
[    7.280996] systemd[1]: System time before build time, advancing clock.
[    7.427575] systemd[1]: systemd 241 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2
 +IDN -PCRE2 default-hierarchy=hybrid)
[    7.452699] systemd[1]: Detected architecture arm64.

Welcome to Debian GNU/Linux 10 (buster)!

[    7.533288] systemd[1]: Set hostname to <debian>.
[    8.213379] systemd[1]: File /lib/systemd/system/systemd-journald.service:12 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
[    8.231403] systemd[1]: Proceeding WITHOUT firewalling in effect! (This warning is only shown for the first loaded unit using IP firewalling.)
[    8.548609] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[    8.568149] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[    8.596890] systemd[1]: Created slice system-getty.slice.
[  OK  ] Created slice system-getty.slice.
[    8.615777] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Started Forward Password R&uests to Wall Directory Watch.
[    8.639105] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Listening on Journal Audit Socket.
[  OK  ] Reached target Slices.
[  OK  ] Listening on Journal Socket.
         Starting udev Coldplug all Devices...
[  OK  ] Reached target Swap.
[  OK  ] Created slice system-serial\x2dgetty.slice.
[  OK  ] Listening on Journal Socket (/dev/log).
         Starting Journal Service...
         Starting Nameserver information manager...
         Starting Load Kernel Modules...
[  OK  ] Started Dispatch Password &ts to Console Directory Watch.
[  OK  ] Reached target Local Encrypted Volumes.
[  OK  ] Reached target Paths.
         Starting Remount Root and Kernel File Systems...
         Mounting Huge Pages File System...
         Mounting Kernel Debug File System...
[  OK  ] Listening on initctl Compatibility Named Pipe.
         Mounting POSIX Message Queue File System...
         Starting Create list of re&odes for the current kernel...
[  OK  ] Set up automount EFI System Partition Automount.
[  OK  ] Started Load Kernel Modules.
[  OK  ] Started Journal Service.
[  OK  ] Started Remount Root and Kernel File Systems.
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Mounted Kernel Debug File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Started Create list of req& nodes for the current kernel.
[  OK  ] Started Nameserver information manager.
         Starting Load/Save Random Seed...
         Starting Create System Users...
         Starting Flush Journal to Persistent Storage...
         Mounting FUSE Control File System...
         Mounting Kernel Configuration File System...
         Starting Apply Kernel Variables...
[  OK  ] Started Load/Save Random Seed.
[  OK  ] Started Create System Users.
[  OK  ] Mounted FUSE Control File System.
[  OK  ] Mounted Kernel Configuration File System.
[  OK  ] Started Apply Kernel Variables.
[   10.095144] systemd-journald[155]: Received request to flush runtime journal from PID 1
         Starting Create Static Device Nodes in /dev...
[  OK  ] Started Flush Journal to Persistent Storage.
[  OK  ] Started Create Static Device Nodes in /dev.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
         Starting Create Volatile Files and Directories...
         Starting udev Kernel Device Manager...
[  OK  ] Started Create Volatile Files and Directories.
         Starting Update UTMP about System Boot/Shutdown...
         Starting Network Time Synchronization...
[  OK  ] Started udev Kernel Device Manager.
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Time Synchronized.
[  OK  ] Started udev Coldplug all Devices.
         Starting Helper to synchronize boot up for ifupdown...
[  OK  ] Reached target System Initialization.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Started Daily rotation of log files.
[  OK  ] Started Daily man-db regeneration.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Reached target Basic System.
[  OK  ] Started D-Bus System Message Bus.
         Starting WPA supplicant...
[  OK  ] Started Regular background program processing daemon.
         Starting System Logging Service...
         Starting Login Service...
[  OK  ] Started WPA supplicant.
[  OK  ] Started System Logging Service.
[  OK  ] Started Login Service.
[   13.274049] libphy: SFP I2C Bus: probed
[   13.314945] sfp sfp: Host maximum power 3.0W
[  OK  ] Found device /dev/ttyMV0.
[   13.539517] rtc-ds1307 0-006f: registered as rtc0
[   13.631544] rtc-ds1307 0-006f: setting system clock to 2021-09-03T14:58:44 UTC (1630681124)
[   13.692007] sfp sfp: module UBNT             UF-RJ45-1G       rev 1.0  sn X20072804742     dc 200617
[   13.999172] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
[   14.187660] libphy: mdio: probed
[   14.667438] mv88e6085 d0032004.mdio-mii:11: switch 0x1900 detected: Marvell 88E6190, revision 1
[   14.811649] libphy: mdio: probed
[   15.372650] mv88e6085 d0032004.mdio-mii:12: switch 0x1900 detected: Marvell 88E6190, revision 1
[   15.549621] libphy: mdio: probed
[  OK  ] Listening on Load/Save RF &itch Status /dev/rfkill Watch.
[   19.952471] mv88e6085 d0032004.mdio-mii:10 lan1 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:01] driver [Marvell 88E6390 Family] (irq=68)
[   20.067840] mv88e6085 d0032004.mdio-mii:10 lan2 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:02] driver [Marvell 88E6390 Family] (irq=69)
[   20.175861] mv88e6085 d0032004.mdio-mii:10 lan3 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:03] driver [Marvell 88E6390 Family] (irq=70)
[   20.283663] mv88e6085 d0032004.mdio-mii:10 lan4 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:04] driver [Marvell 88E6390 Family] (irq=71)
[   20.383820] mv88e6085 d0032004.mdio-mii:10 lan5 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:05] driver [Marvell 88E6390 Family] (irq=72)
[   20.487836] mv88e6085 d0032004.mdio-mii:10 lan6 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:06] driver [Marvell 88E6390 Family] (irq=73)
[   20.603670] mv88e6085 d0032004.mdio-mii:10 lan7 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:07] driver [Marvell 88E6390 Family] (irq=74)
[   20.723826] mv88e6085 d0032004.mdio-mii:10 lan8 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:08] driver [Marvell 88E6390 Family] (irq=75)
[   20.771335] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   20.823451] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   20.948653] mv88e6085 d0032004.mdio-mii:11 lan9 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:01] driver [Marvell 88E6390 Family] (irq=93)
[   21.067851] mv88e6085 d0032004.mdio-mii:11 lan10 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:02] driver [Marvell 88E6390 Family] (irq=94)
[   21.187808] mv88e6085 d0032004.mdio-mii:11 lan11 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:03] driver [Marvell 88E6390 Family] (irq=95)
[   21.307670] mv88e6085 d0032004.mdio-mii:11 lan12 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:04] driver [Marvell 88E6390 Family] (irq=96)
[   21.427648] mv88e6085 d0032004.mdio-mii:11 lan13 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:05] driver [Marvell 88E6390 Family] (irq=97)
[   21.547827] mv88e6085 d0032004.mdio-mii:11 lan14 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:06] driver [Marvell 88E6390 Family] (irq=98)
[   21.667813] mv88e6085 d0032004.mdio-mii:11 lan15 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:07] driver [Marvell 88E6390 Family] (irq=99)
[   21.787653] mv88e6085 d0032004.mdio-mii:11 lan16 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:08] driver [Marvell 88E6390 Family] (irq=100)
[   21.834131] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   21.916795] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   21.988511] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   22.011969] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   22.071686] mv88e6085 d0032004.mdio-mii:12 lan17 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:01] driver [Marvell 88E6390 Family] (irq=118)
[*     ] A start job is running for Helper t&ot up for ifupdown (13s / 3min 3s)
[   22.185013] mv88e6085 d0032004.mdio-mii:12 lan18 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:02] driver [Marvell 88E6390 Family] (irq=119)
[   22.292157] mv88e6085 d0032004.mdio-mii:12 lan19 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:03] driver [Marvell 88E6390 Family] (irq=120)
[   22.411728] mv88e6085 d0032004.mdio-mii:12 lan20 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:04] driver [Marvell 88E6390 Family] (irq=121)
[   22.531548] mv88e6085 d0032004.mdio-mii:12 lan21 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:05] driver [Marvell 88E6390 Family] (irq=122)
[**    ] A start job is running for Helper t&ot up for ifupdown (14s / 3min 3s)
[   22.759852] mv88e6085 d0032004.mdio-mii:12 lan23 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:07] driver [Marvell 88E6390 Family] (irq=124)
[   22.873149] mv88e6085 d0032004.mdio-mii:12 lan24 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:08] driver [Marvell 88E6390 Family] (irq=125)
[   22.913750] mv88e6085 d0032004.mdio-mii:12: configuring for inband/2500base-x link mode
[   22.962545] DSA: tree 0 setup
[   23.004338] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  OK  ] Started Helper to synchronize boot up for ifupdown.
         Starting Raise network interfaces...
[   27.951983] br0: port 1(lan1) entered blocking state
[   27.957316] br0: port 1(lan1) entered disabled state
[   27.999338] device lan1 entered promiscuous mode
[   28.702754] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[   28.712064] device eth1 entered promiscuous mode
[   28.720468] mv88e6085 d0032004.mdio-mii:10 lan1: configuring for phy/ link mode
[   28.732861] 8021q: adding VLAN 0 to HW filter on device lan1
[   28.740431] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   28.752951] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   28.776954] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   28.789545] br0: port 2(lan2) entered blocking state
[   28.798480] br0: port 2(lan2) entered disabled state
[   28.851520] device lan2 entered promiscuous mode
[   28.977123] mv88e6085 d0032004.mdio-mii:10 lan2: configuring for phy/ link mode
[   28.986419] 8021q: adding VLAN 0 to HW filter on device lan2
[   29.020755] br0: port 3(lan3) entered blocking state
[   29.026437] br0: port 3(lan3) entered disabled state
[   29.088327] device lan3 entered promiscuous mode
[   29.260286] mv88e6085 d0032004.mdio-mii:10 lan3: configuring for phy/ link mode
[   29.270103] 8021q: adding VLAN 0 to HW filter on device lan3
[   29.309081] br0: port 4(lan4) entered blocking state
[   29.314490] br0: port 4(lan4) entered disabled state
[   29.373039] device lan4 entered promiscuous mode
[   29.533417] mv88e6085 d0032004.mdio-mii:10 lan4: configuring for phy/ link mode
[   29.543366] 8021q: adding VLAN 0 to HW filter on device lan4
[   29.578403] br0: port 5(lan5) entered blocking state
[   29.583815] br0: port 5(lan5) entered disabled state
[   29.648198] device lan5 entered promiscuous mode
[   29.825242] mv88e6085 d0032004.mdio-mii:10 lan5: configuring for phy/ link mode
[   29.836200] 8021q: adding VLAN 0 to HW filter on device lan5
[   29.868455] br0: port 6(lan6) entered blocking state
[   29.873813] br0: port 6(lan6) entered disabled state
[   29.940199] device lan6 entered promiscuous mode
[   30.111810] mv88e6085 d0032004.mdio-mii:10 lan6: configuring for phy/ link mode
[   30.121640] 8021q: adding VLAN 0 to HW filter on device lan6
[   30.160666] br0: port 7(lan7) entered blocking state
[   30.166044] br0: port 7(lan7) entered disabled state
[   30.227103] device lan7 entered promiscuous mode
[   30.387080] mv88e6085 d0032004.mdio-mii:10 lan7: configuring for phy/ link mode
[   30.397060] 8021q: adding VLAN 0 to HW filter on device lan7
[   30.437569] br0: port 8(lan8) entered blocking state
[   30.442964] br0: port 8(lan8) entered disabled state
[   30.513711] device lan8 entered promiscuous mode
[   30.679697] mv88e6085 d0032004.mdio-mii:10 lan8: configuring for phy/ link mode
[   30.689480] 8021q: adding VLAN 0 to HW filter on device lan8
[   30.729330] br0: port 9(lan9) entered blocking state
[   30.734702] br0: port 9(lan9) entered disabled state
[   30.846495] device lan9 entered promiscuous mode
[   30.975568] mv88e6085 d0032004.mdio-mii:11 lan9: configuring for phy/ link mode
[   30.985333] 8021q: adding VLAN 0 to HW filter on device lan9
[   31.021532] br0: port 10(lan10) entered blocking state
[   31.027117] br0: port 10(lan10) entered disabled state
[   31.106968] device lan10 entered promiscuous mode
[   31.263923] mv88e6085 d0032004.mdio-mii:11 lan10: configuring for phy/ link mode
[   31.275460] 8021q: adding VLAN 0 to HW filter on device lan10
[   31.293929] br0: port 11(lan11) entered blocking state
[   31.299385] br0: port 11(lan11) entered disabled state
[   31.364320] device lan11 entered promiscuous mode
[   31.520862] mv88e6085 d0032004.mdio-mii:11 lan11: configuring for phy/ link mode
[   31.530753] 8021q: adding VLAN 0 to HW filter on device lan11
[   31.564777] br0: port 12(lan12) entered blocking state
[   31.570358] br0: port 12(lan12) entered disabled state
[   31.647327] device lan12 entered promiscuous mode
[   31.808186] mv88e6085 d0032004.mdio-mii:11 lan12: configuring for phy/ link mode
[   31.819286] 8021q: adding VLAN 0 to HW filter on device lan12
[   31.837931] br0: port 13(lan13) entered blocking state
[   31.843520] br0: port 13(lan13) entered disabled state
[   31.887243] mv88e6085 d0032004.mdio-mii:10 lan1: Link is Up - 1Gbps/Full - flow control off
[   31.916529] device lan13 entered promiscuous mode
[   32.088645] mv88e6085 d0032004.mdio-mii:11 lan13: configuring for phy/ link mode
[   32.099686] 8021q: adding VLAN 0 to HW filter on device lan13
[   32.118267] br0: port 14(lan14) entered blocking state
[   32.123831] br0: port 14(lan14) entered disabled state
[   32.210141] device lan14 entered promiscuous mode
[   32.381240] mv88e6085 d0032004.mdio-mii:11 lan14: configuring for phy/ link mode
[   32.392326] 8021q: adding VLAN 0 to HW filter on device lan14
[   32.423522] br0: port 15(lan15) entered blocking state
[   32.429206] br0: port 15(lan15) entered disabled state
[  *** ] A start job is running for Raise network interfaces (23s / 5min 18s)
[   32.519449] device lan15 entered promiscuous mode
[   32.676263] mv88e6085 d0032004.mdio-mii:11 lan15: configuring for phy/ link mode
[   32.686147] 8021q: adding VLAN 0 to HW filter on device lan15
[   32.722537] br0: port 16(lan16) entered blocking state
[   32.728098] br0: port 16(lan16) entered disabled state
[   32.813021] device lan16 entered promiscuous mode
[ ***  ] A [   32.981681] 8021q: adding VLAN 0 to HW filter on device lan16
start job is running for Raise network interfaces (24s / 5min 18s)
[   33.023104] br0: port 17(lan17) entered blocking state
[   33.028724] br0: port 17(lan17) entered disabled state
[   33.157859] device lan17 entered promiscuous mode
[   33.246839] mv88e6085 d0032004.mdio-mii:10 lan4: Link is Up - 1Gbps/Full - flow control rx/tx
[   33.298705] mv88e6085 d0032004.mdio-mii:12 lan17: configuring for phy/ link mode
[   33.310916] 8021q: adding VLAN 0 to HW filter on device lan17
[   33.338191] br0: port 18(lan18) entered blocking state
[   33.343664] br0: port 18(lan18) entered disabled state
[***   ] A start job is running for Raise network interfaces (24s / 5min 18s)
[   33.600619] mv88e6085 d0032004.mdio-mii:12 lan18: configuring for phy/ link mode
[   33.610687] 8021q: adding VLAN 0 to HW filter on device lan18
[   33.645258] br0: port 19(lan19) entered blocking state
[   33.650881] br0: port 19(lan19) entered disabled state
[   33.743360] device lan19 entered promiscuous mode
[   33.903909] mv88e6085 d0032004.mdio-mii:12 lan19: configuring for phy/ link mode
[   33.913815] 8021q: adding VLAN 0 to HW filter on device lan19
[   33.950285] br0: port 20(lan20) entered blocking state
[**    ] A start job is running for Raise network interfaces (25s / 5min 18s)
[   34.051244] device lan20 entered promiscuous mode
[   34.211940] mv88e6085 d0032004.mdio-mii:12 lan20: configuring for phy/ link mode
[   34.221916] 8021q: adding VLAN 0 to HW filter on device lan20
[   34.257884] br0: port 21(lan21) entered blocking state
[   34.263435] br0: port 21(lan21) entered disabled state
[   34.356787] device lan21 entered promiscuous mode
[*     ] A start job is running for Raise network interfaces (25s / 5min 18s)
[   34.529248] mv88e6085 d0032004.mdio-mii:12 lan21: configuring for phy/ link mode
[   34.539326] 8021q: adding VLAN 0 to HW filter on device lan21
[   34.572161] br0: port 22(lan22) entered blocking state
[   34.577677] br0: port 22(lan22) entered disabled state
[   34.672115] device lan22 entered promiscuous mode
[   34.832973] mv88e6085 d0032004.mdio-mii:12 lan22: configuring for phy/ link mode
[   34.844913] 8021q: adding VLAN 0 to HW filter on device lan22
[   34.863258] br0: port 23(lan23) entered blocking state
[   34.868705] br0: port 23(lan23) entered disabled state
[**    ] A start job is running for Raise network interfaces (26s / 5min 18s)
[   35.128525] mv88e6085 d0032004.mdio-mii:12 lan23: configuring for phy/ link mode
[   35.138491] 8021q: adding VLAN 0 to HW filter on device lan23
[   35.173996] br0: port 24(lan24) entered blocking state
[   35.179598] br0: port 24(lan24) entered disabled state
[   35.275868] device lan24 entered promiscuous mode
[   35.435492] mv88e6085 d0032004.mdio-mii:12 lan24: configuring for phy/ link mode
[***   ] A start job is running for Raise network interfaces (26s / 5min 18s)
[   35.486010] br0: port 25(sfp) entered blocking state
[   35.491356] br0: port 25(sfp) entered disabled state
[   35.590444] device sfp entered promiscuous mode
[   35.768390] mv88e6085 d0032004.mdio-mii:12 sfp: configuring for inband/sgmii link mode
[   35.810307] 8021q: adding VLAN 0 to HW filter on device sfp
[   35.855689] br0: port 4(lan4) entered blocking state
[   35.860972] br0: port 4(lan4) entered forwarding state
[   35.866582] br0: port 2(lan2) entered blocking state
[   35.871933] br0: port 2(lan2) entered forwarding state
[   35.877509] br0: port 1(lan1) entered blocking state
[ ***  ] A start job is running for Raise network interfaces (27s / 5min 18s)
[   36.055956] mv88e6085 d0032004.mdio-mii:12 sfp: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
[  OK  ] Started Raise network interfaces.
[  OK  ] Reached target Network.
         Starting Permit User Sessions...
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Getty on tty1.
[  OK  ] Started Serial Getty on ttyMV0.
[  OK  ] Reached target Login Prompts.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.
         Starting Update UTMP about System Runlevel Changes...
[   36.809305] mv88e6085 d0032004.mdio-mii:12 lan19: Link is Up - 1Gbps/Full - flow control off
[  OK  ] Started Update UTMP about System Runlevel Changes.
[   37.648158] mv88e6085 d0032004.mdio-mii:12 lan22: Link is Up - 1Gbps/Full - flow control rx/tx

Debian GNU/Linux 10 debian ttyMV0

debian login: [   38.264408] mv88e6085 d0032004.mdio-mii:12 lan21: Link is Up - 1Gbps/Full - flow control off
[   38.405414] mv88e6085 d0032004.mdio-mii:12 lan24: Link is Up - 1Gbps/Full - flow control off
[   39.108579] br0: port 19(lan19) entered blocking state
[   39.114042] br0: port 19(lan19) entered forwarding state
[   39.120107] br0: port 22(lan22) entered blocking state
[   39.125619] br0: port 22(lan22) entered forwarding state
[   39.131694] br0: port 21(lan21) entered blocking state
[   39.137187] br0: port 21(lan21) entered forwarding state
[   39.143438] br0: port 24(lan24) entered blocking state
[   39.148828] br0: port 24(lan24) entered forwarding state
[   39.235766] mv88e6085 d0032004.mdio-mii:12 sfp: Link is Up - 1Gbps/Full - flow control off
[   39.245097] br0: port 25(sfp) entered blocking state
[   39.250328] br0: port 25(sfp) entered forwarding state

debian login: root
Password:
Last login: Fri Sep  3 14:55:36 UTC 2021 on ttyMV0
Linux debian 5.13.0 #54 SMP PREEMPT Fri Sep 3 14:43:30 EEST 2021 aarch64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
root@debian:~# bridge link
6: lan1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
7: lan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
8: lan3@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
9: lan4@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
10: lan5@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
11: lan6@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
12: lan7@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
13: lan8@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
14: lan9@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
15: lan10@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
16: lan11@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
17: lan12@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
18: lan13@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
19: lan14@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
20: lan15@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
21: lan16@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
22: lan17@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
23: lan18@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
24: lan19@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
25: lan20@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
26: lan21@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
27: lan22@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
28: lan23@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
29: lan24@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
30: sfp@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
root@debian:~#
root@debian:~#
root@debian:~# zcat /proc/config.gz | grep MV88E
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6XXX_PTP=y
root@debian:~# zcat /proc/config.gz | grep MARVELL_PHY
CONFIG_MARVELL_PHY=m
root@debian:~#
root@debian:~# reboot
[  OK  ] Stopped target Timers.
[  OK  ] Stopped Daily man-db regeneration.
[  OK  ] Stopped target Graphical Interface.
[  OK  ] Stopped Daily Cleanup of Temporary Directories.
[  OK  ] Stopped Daily apt upgrade and clean activities.
[  OK  ] Stopped Daily apt download activities.
[  OK  ] Stopped target Multi-User System.
         Stopping Login Service...
         Stopping Regular background program processing daemon...
[  OK  ] Closed Load/Save RF Kill Switch Status /dev/rfkill Watch.
         Stopping System Logging Service...
[  OK  ] Stopped Daily rotation of log files.
[  OK  ] Stopped target System Time Synchronized.
[  OK  ] Unset automount EFI System Partition Automount.
[  OK  ] Reached target Unmount All Filesystems.         Stopping Serial Getty on ttyMV0...
[  OK  ] Stopped Regular background program processing daemon.
[  OK  ] Stopped System Logging Service.
[  OK  ] Stopped Login Service.
[  OK  ] Stopped Getty on tty1.
[  OK  ] Stopped Serial Getty on ttyMV0.
[  OK  ] Removed slice system-serial\x2dgetty.slice.
         Stopping Permit User Sessions...
[  OK  ] Removed slice system-getty.slice.
[  OK  ] Stopped Permit User Sessions.
[  OK  ] Stopped target Remote File Systems.
[  OK  ] Stopped target Network.
         Stopping WPA supplicant...
         Stopping Raise network interfaces...
[  OK  ] Stopped WPA supplicant.
         Stopping D-Bus System Message Bus...
[  OK  ] Stopped D-Bus System Message Bus.
[  OK  ] Stopped target Basic System.
[  OK  ] Stopped target Sockets.
[  OK  ] Closed Syslog Socket.
[  OK  ] Stopped target Slices.
[  OK  ] Removed slice User and Session Slice.
[  OK  ] Stopped target Paths.
[  OK  ] Closed D-Bus System Message Bus Socket.
[  OK  ] Stopped target System In[  195.669814] br0: port 25(sfp) entered disabled state
itialization.
[  195.677987] br0: port 24(lan24) entered disabled state
[  195.684954] br0: port 22(lan22) entered disabled state
[  195.690424] br0: port 21(lan21) entered disabled state
[  195.695831] br0: port 19(lan19) entered disabled state
[  195.701424] br0: port 4(lan4) entered disabled state
[  195.706746] br0: port 2(lan2) entered disabled state
[  195.712109] br0: port 1(lan1) entered disabled state
[  OK  ] Stopped target Swap.
         Stopping Network Time Synchronization...
[  OK  ] Stopped target Local Encrypted Volumes.
[  OK  ] Stopped Dispatch Password &ts to Console Directory Watch.
[  OK  ] Stopped Forward Password R&uests to Wall Directory Watch.
[  195.802072] mv88e6085 d0032004.mdio-mii:10 lan1: Link is Down
         Stopping Load/Save Random Seed...
[  195.837223] device lan1 left promiscuous mode
[  195.849150] br0: port 1(lan1) entered disabled state
         Stopping Update UTMP about System Boot/Shutdown...
[  OK  ] Stopped Network Time Synchronization.
[  OK  ] Stopped Load/Save Random Seed.
[  OK  ] Stopped Update UTMP about System Boot/Shutdown.
[  OK  ] Stopped Create Volatile Files and Directories.
[  196.048795] mv88e6085 d0032004.mdio-mii:10 lan2: Link is Down
[  196.072198] device lan2 left promiscuous mode
[  196.077091] br0: port 2(lan2) entered disabled state
[  196.241416] device lan3 left promiscuous mode
[  196.246184] br0: port 3(lan3) entered disabled state
[  196.396942] mv88e6085 d0032004.mdio-mii:10 lan4: Link is Down
[  196.415172] device lan4 left promiscuous mode
[  196.419870] br0: port 4(lan4) entered disabled state
[  196.593587] device lan5 left promiscuous mode
[  196.598437] br0: port 5(lan5) entered disabled state
[  196.779118] device lan6 left promiscuous mode
[  196.783938] br0: port 6(lan6) entered disabled state
[  196.974068] device lan7 left promiscuous mode
[  196.979019] br0: port 7(lan7) entered disabled state
[  197.149726] device lan8 left promiscuous mode
[  197.154425] br0: port 8(lan8) entered disabled state
[  197.326241] device lan9 left promiscuous mode
[  197.331419] br0: port 9(lan9) entered disabled state
[  197.510176] device lan10 left promiscuous mode
[  197.515454] br0: port 10(lan10) entered disabled state
[  197.691364] device lan11 left promiscuous mode
[  197.696326] br0: port 11(lan11) entered disabled state
[  197.873439] device lan12 left promiscuous mode
[  197.878695] br0: port 12(lan12) entered disabled state
[  198.047244] device lan13 left promiscuous mode
[  198.052190] br0: port 13(lan13) entered disabled state
[  198.226487] device lan14 left promiscuous mode
[  198.231501] br0: port 14(lan14) entered disabled state
[  198.406228] device lan15 left promiscuous mode
[  198.411234] br0: port 15(lan15) entered disabled state
[  198.586247] device lan16 left promiscuous mode
[  198.591207] br0: port 16(lan16) entered disabled state
[  198.763583] device lan17 left promiscuous mode
[  198.768515] br0: port 17(lan17) entered disabled state
[  198.930386] device lan18 left promiscuous mode
[  198.935484] br0: port 18(lan18) entered disabled state
[  199.072990] mv88e6085 d0032004.mdio-mii:12 lan19: Link is Down
[  199.106432] device lan19 left promiscuous mode
[  199.111401] br0: port 19(lan19) entered disabled state
[  199.255244] device lan20 left promiscuous mode
[  199.260174] br0: port 20(lan20) entered disabled state
[  199.385663] mv88e6085 d0032004.mdio-mii:12 lan21: Link is Down
[  199.405532] device lan21 left promiscuous mode
[  199.410324] br0: port 21(lan21) entered disabled state
[  199.540077] mv88e6085 d0032004.mdio-mii:12 lan22: Link is Down
[  199.558987] device lan22 left promiscuous mode
[  199.563775] br0: port 22(lan22) entered disabled state
[  199.719260] device lan23 left promiscuous mode
[  199.724364] br0: port 23(lan23) entered disabled state
[  199.857384] mv88e6085 d0032004.mdio-mii:12 lan24: Link is Down
[  199.877739] device lan24 left promiscuous mode
[  199.882610] br0: port 24(lan24) entered disabled state
[  200.001263] mv88e6085 d0032004.mdio-mii:12 sfp: Link is Down
[  200.027373] device eth1 left promiscuous mode
[  200.042175] device sfp left promiscuous mode
[  200.046860] br0: port 25(sfp) entered disabled state
[  OK  ] Stopped Raise network interfaces.
[  OK  ] Stopped Apply Kernel Variables.
[  OK  ] Stopped Load Kernel Modules.
[  OK  ] Stopped target Local File Systems.
[  OK  ] Stopped target Local File Systems (Pre).
[  OK  ] Stopped Create Static Device Nodes in /dev.
[  OK  ] Stopped Create System Users.
[  OK  ] Stopped Remount Root and Kernel File Systems.
[  OK  ] Reached target Shutdown.
[  OK  ] Reached target Final Step.
[  OK  ] Started Reboot.
[  OK  ] Reached target Reboot.
[  200.784076] watchdog: watchdog0: watchdog did not stop!
[  200.828060] printk: systemd-shutdow: 26 output lines suppressed due to ratelimiting
[  201.007812] systemd-shutdown[1]: Syncing filesystems and block devices.
[  202.545261] systemd-shutdown[1]: Sending SIGTERM to remaining processes...
[  202.586684] systemd-journald[155]: Received SIGTERM from PID 1 (systemd-shutdow).
[  202.618143] systemd-shutdown[1]: Sending SIGKILL to remaining processes...
[  202.647208] systemd-shutdown[1]: Hardware watchdog 'Armada 37xx Watchdog', version 0
[  202.661982] systemd-shutdown[1]: Unmounting file systems.
[  202.676279] [813]: Remounting '/' read-only in with options '(null)'.
[  202.745351] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null). Quota mode: none.
[  202.769007] systemd-shutdown[1]: All filesystems unmounted.
[  202.775189] systemd-shutdown[1]: Deactivating swaps.
[  202.781370] systemd-shutdown[1]: All swaps deactivated.
[  202.786941] systemd-shutdown[1]: Detaching loop devices.
[  202.810183] systemd-shutdown[1]: All loop devices detached.
[  202.873078] kvm: exiting hardware virtualization
[  202.973908] reboot: Restarting system




So since what you've said you suspect is happening is that there might
be races between the ifupdown scripts not waiting for mv88e6xxx probing
to finish, and udev loading the mv88e6xxx module, I've added this patch
to the kernel and re-tested:


-----------------------------[ cut here ]-----------------------------
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..e86e9719b022 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6183,6 +6183,8 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	int port;
 	int err;
 
+	msleep(5000);
+
 	if (!np && !pdata)
 		return -EINVAL;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b71e87909f0e..866683c53f5e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -822,6 +822,7 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 	}
 
 	list_for_each_entry(dp, &dst->ports, list) {
+		msleep(2000);
 		err = dsa_port_setup(dp);
 		if (err) {
 			dsa_port_devlink_teardown(dp);
-----------------------------[ cut here ]-----------------------------

and it still works just fine (note that this is the reason why the
kernel version is now "-dirty"):


CZ.NIC Turris Mox Secure Firmware version v2021.01.22 (Jan 22 2021 17:10:27)
Initializing DDR... done


U-Boot 2018.11 (Dec 16 2018 - 12:50:19 +0000), Build: jenkins-turris-os-packages-kittens-mox-90

DRAM:  1 GiB
Enabling Armada 3720 wComphy-0: SGMII1        3.125 Gbps
Comphy-1: PEX0          5 Gbps
Comphy-2: USB3_HOST0    5 Gbps
MMC:   sdhci@d8000: 0
Loading Environment from SPI Flash... SF: Detected w25q64dw with page size 256 Bytes, erase size 4 KiB, total 8 MiB
OK
Model: CZ.NIC Turris Mox Board
Net:   eth0: neta@30000
Turris Mox:
  Board version: 22
  RAM size: 1024 MiB
  Serial Number: 0000000D3000801C
  ECDSA Public Key: 020096edae3f978d4b5dfcbf147ffc4b3acf2710b2af3ff8cdf4c0b84d02d8dfcbf7c3ea3e438b2c1aa4d2161b34723d9051928b6c9f5e89edcb9db52450fc0b5741b6
  SD/eMMC version: SD
Module Topology:
   1: Peridot Switch Module (8-port)
   2: Peridot Switch Module (8-port)
   3: Peridot Switch Module (8-port)
   4: SFP Module

Hit any key to stop autoboot:  0
gpio: pin GPIO221 (gpio 57) value is 0
gpio: pin GPIO220 (gpio 56) value is 1
SF: Detected w25q64dw with page size 256 Bytes, erase size 4 KiB, total 8 MiB
device 0 offset 0x7f0000, size 0x10000
SF: 65536 bytes @ 0x7f0000 Read: OK
switch to partitions #0, OK
mmc0 is current device
Scanning mmc 0:1...
Found /extlinux/extlinux.conf
Retrieving file: /extlinux/extlinux.conf
176 bytes read in 14 ms (11.7 KiB/s)
1:      Debian Buster
Retrieving file: /extlinux/../Image
47782400 bytes read in 2039 ms (22.3 MiB/s)
append: console=ttyMV0,115200 root=PARTUUID=2f03a128-2d77-4827-85ae-9410e96b7cd2 rw rootwait
Retrieving file: /extlinux/../armada-3720-turris-mox.dtb
20223 bytes read in 26 ms (758.8 KiB/s)
## Flattened Device Tree blob at 04f00000
   Booting using the fdt blob at 0x4f00000
   Loading Device Tree to 000000003bf14000, end 000000003bf1befe ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd034]
[    0.000000] Linux version 5.13.0-dirty (tigrisor@skbuf) (aarch64-none-linux-gnu-gcc (GNU Toolchain for the A-profile Architecture 10.2-2020.11 (arm-10.16)) 10.2.1 20201103, GNU ld (GNU Toolchain for the
 A-profile Architecture 10.2-2020.11 (arm-10.16)) 2.35.1.20201028) #57 SMP PREEMPT Fri Sep 3 18:58:44 EEST 2021
[    0.000000] Machine model: CZ.NIC Turris Mox Board
[    0.000000] efi: UEFI not found.
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] NUMA: NODE_DATA [mem 0x3fde59c0-0x3fde7fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
[    0.000000]   node   0: [mem 0x0000000004000000-0x00000000041fffff]
[    0.000000]   node   0: [mem 0x0000000004200000-0x000000003fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] On node 0 totalpages: 262144
[    0.000000]   DMA zone: 4096 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 262144 pages, LIFO batch:63
[    0.000000] cma: Reserved 32 MiB at 0x000000003cc00000
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.1
[    0.000000] percpu: Embedded 482 pages/cpu s1934168 r8192 d31912 u1974272
[    0.000000] pcpu-alloc: s1934168 r8192 d31912 u1974272 alloc=482*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: detected: GIC system register CPU interface
[    0.000000] CPU features: detected: ARM erratum 845719
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 258048
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: console=ttyMV0,115200 root=PARTUUID=2f03a128-2d77-4827-85ae-9410e96b7cd2 rw rootwait
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 931320K/1048576K available (22272K kernel code, 4550K rwdata, 10356K rodata, 9344K init, 11760K bss, 84488K reserved, 32768K cma-reserved)
[    0.000000] trace event string verifier disabled
[    0.000000] Running RCU self tests
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu:     RCU lockdep checking is enabled.
[    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=2.
[    0.000000]  Trampoline variant of Tasks RCU enabled.
[    0.000000]  Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
[    0.000000] GICv3: 192 SPIs implemented
[    0.000000] GICv3: 0 Extended SPIs implemented
[    0.000000] GICv3: Distributor has no Range Selector support
[    0.000000] Root IRQ handler: gic_handle_irq
[    0.000000] GICv3: 16 PPIs implemented
[    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x00000000d1d40000
[    0.000000] random: get_random_bytes called from start_kernel+0x3d8/0x5d4 with crng_init=0
[    0.000000] arch_timer: cp15 timer(s) running at 12.50MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x2e2049cda, max_idle_ns: 440795202628 ns
[    0.000001] sched_clock: 56 bits at 12MHz, resolution 80ns, wraps every 4398046511080ns
[    0.002618] Console: colour dummy device 80x25
[    0.002689] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.002712] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.002734] ... MAX_LOCK_DEPTH:          48
[    0.002756] ... MAX_LOCKDEP_KEYS:        8192
[    0.002778] ... CLASSHASH_SIZE:          4096
[    0.002799] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.002821] ... MAX_LOCKDEP_CHAINS:      65536
[    0.002842] ... CHAINHASH_SIZE:          32768
[    0.002864]  memory used by lock dependency info: 6877 kB
[    0.002886]  memory used for stack traces: 4224 kB
[    0.002908]  per task-struct memory footprint: 2688 bytes
[    0.003093] Calibrating delay loop (skipped), value calculated using timer frequency.. 25.00 BogoMIPS (lpj=50000)
[    0.003136] pid_max: default: 32768 minimum: 301
[    0.003508] LSM: Security Framework initializing
[    0.003751] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
[    0.003792] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
[    0.013859] Running RCU-tasks wait API self tests
[    0.118378] rcu: Hierarchical SRCU implementation.
[    0.121757] EFI services will not be available.
[    0.123181] smp: Bringing up secondary CPUs ...
[    0.129365] Detected VIPT I-cache on CPU1
[    0.129415] GICv3: CPU1: found redistributor 1 region 0:0x00000000d1d60000
[    0.129516] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.130768] smp: Brought up 1 node, 2 CPUs
[    0.130856] SMP: Total of 2 processors activated.
[    0.130888] CPU features: detected: 32-bit EL0 Support
[    0.130916] CPU features: detected: 32-bit EL1 Support
[    0.130947] CPU features: detected: CRC32 instructions
[    0.137655] Callback from call_rcu_tasks_trace() invoked.
[    0.198677] CPU: All CPU(s) started at EL2
[    0.198862] alternatives: patching kernel code
[    0.203210] devtmpfs: initialized
[    0.246026] KASLR disabled due to lack of seed
[    0.249070] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.249163] futex hash table entries: 512 (order: 4, 65536 bytes, linear)
[    0.252571] pinctrl core: initialized pinctrl subsystem
[    0.260715] DMI not present or invalid.
[    0.263435] NET: Registered protocol family 16
[    0.273512] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
[    0.274183] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.274885] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.275405] audit: initializing netlink subsys (disabled)
[    0.276406] audit: type=2000 audit(0.272:1): state=initialized audit_enabled=0 res=1
[    0.283112] thermal_sys: Registered thermal governor 'step_wise'
[    0.283151] thermal_sys: Registered thermal governor 'power_allocator'
[    0.283807] cpuidle: using governor menu
[    0.285077] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.285389] ASID allocator initialised with 65536 entries
[    0.293623] Serial: AMBA PL011 UART driver
[    0.328381] Callback from call_rcu_tasks() invoked.
[    0.529059] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.529113] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[    0.529143] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.529174] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[    0.552655] cryptd: max_cpu_qlen set to 1000
[    0.635282] raid6: neonx8   gen()  1547 MB/s
[    0.703855] raid6: neonx8   xor()  1089 MB/s
[    0.772424] raid6: neonx4   gen()  1584 MB/s
[    0.840963] raid6: neonx4   xor()  1083 MB/s
[    0.909617] raid6: neonx2   gen()  1487 MB/s
[    0.978090] raid6: neonx2   xor()  1005 MB/s
[    1.046666] raid6: neonx1   gen()  1289 MB/s
[    1.115210] raid6: neonx1   xor()   871 MB/s
[    1.183758] raid6: int64x8  gen()  1196 MB/s
[    1.252293] raid6: int64x8  xor()   641 MB/s
[    1.320860] raid6: int64x4  gen()  1334 MB/s
[    1.389399] raid6: int64x4  xor()   683 MB/s
[    1.457956] raid6: int64x2  gen()  1160 MB/s
[    1.526502] raid6: int64x2  xor()   624 MB/s
[    1.595045] raid6: int64x1  gen()   862 MB/s
[    1.663587] raid6: int64x1  xor()   430 MB/s
[    1.663619] raid6: using algorithm neonx4 gen() 1584 MB/s
[    1.663648] raid6: .... xor() 1083 MB/s, rmw enabled
[    1.663676] raid6: using neon recovery algorithm
[    1.666064] ACPI: Interpreter disabled.
[    1.678110] iommu: Default domain type: Passthrough
[    1.680305] vgaarb: loaded
[    1.683083] SCSI subsystem initialized
[    1.684378] libata version 3.00 loaded.
[    1.686171] usbcore: registered new interface driver usbfs
[    1.686543] usbcore: registered new interface driver hub
[    1.686804] usbcore: registered new device driver usb
[    1.691093] pps_core: LinuxPPS API ver. 1 registered
[    1.691134] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.691245] PTP clock support registered
[    1.692046] EDAC MC: Ver: 3.0.0
[    1.702325] FPGA manager framework
[    1.703269] Advanced Linux Sound Architecture Driver Initialized.
[    1.707581] Bluetooth: Core ver 2.22
[    1.707825] NET: Registered protocol family 31
[    1.707857] Bluetooth: HCI device and connection manager initialized
[    1.707972] Bluetooth: HCI socket layer initialized
[    1.708029] Bluetooth: L2CAP socket layer initialized
[    1.708289] Bluetooth: SCO socket layer initialized
[    1.711802] clocksource: Switched to clocksource arch_sys_counter
[    2.290329] VFS: Disk quotas dquot_6.6.0
[    2.290646] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.292573] pnp: PnP ACPI: disabled
[    2.341848] NET: Registered protocol family 2
[    2.342419] IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    2.346244] tcp_listen_portaddr_hash hash table entries: 512 (order: 3, 45056 bytes, linear)
[    2.346405] TCP established hash table entries: 8192 (order: 4, 65536 bytes, linear)
[    2.346732] TCP bind hash table entries: 8192 (order: 7, 655360 bytes, linear)
[    2.347983] TCP: Hash tables configured (established 8192 bind 8192)
[    2.348699] UDP hash table entries: 512 (order: 4, 98304 bytes, linear)
[    2.348949] UDP-Lite hash table entries: 512 (order: 4, 98304 bytes, linear)
[    2.350473] NET: Registered protocol family 1
[    2.355366] RPC: Registered named UNIX socket transport module.
[    2.355444] RPC: Registered udp transport module.
[    2.355477] RPC: Registered tcp transport module.
[    2.355508] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.355562] PCI: CLS 0 bytes, default 64
[    2.360135] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counters available
[    2.361193] kvm [1]: IPA Size Limit: 40 bits
[    2.382298] kvm [1]: vgic-v2@d1da0000
[    2.382420] kvm [1]: GIC system register CPU interface enabled
[    2.382898] kvm [1]: vgic interrupt IRQ9
[    2.384712] kvm [1]: Hyp mode initialized successfully
[    2.421961] Initialise system trusted keyrings
[    2.423311] workingset: timestamp_bits=42 max_order=18 bucket_order=0
[    2.428278] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.430717] NFS: Registering the id_resolver key type
[    2.430922] Key type id_resolver registered
[    2.430983] Key type id_legacy registered
[    2.431211] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    2.431302] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    2.432604] fuse: init (API version 7.33)
[    2.433671] 9p: Installing v9fs 9p2000 file system support
[    2.479960] xor: measuring software checksum speed
[    2.485085]    8regs           :  1966 MB/sec
[    2.489553]    32regs          :  2327 MB/sec
[    2.499245]    arm64_neon      :  1050 MB/sec
[    2.499277] xor: using function: 32regs (2327 MB/sec)
[    2.499330] Key type asymmetric registered
[    2.499504] Asymmetric key parser 'x509' registered
[    2.499930] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    2.500958] io scheduler mq-deadline registered
[    2.501014] io scheduler kyber registered
[    2.604314] EINJ: ACPI disabled.
[    2.654651] mv_xor d0060900.xor: Marvell shared XOR driver
[    2.771135] mv_xor d0060900.xor: Marvell XOR (Descriptor Mode): ( xor cpy intr )
[    2.887091] mv_xor d0060900.xor: Marvell XOR (Descriptor Mode): ( xor cpy intr )
[    2.887959] debugfs: Directory 'd0060900.xor' with parent 'dmaengine' already present!
[    2.947369] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.966183] SuperH (H)SCI(F) driver initialized
[    2.969072] msm_serial: driver initialized
[    2.978835] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    3.048005] brd: module loaded
[    3.115507] loop: module loaded
[    3.121535] megasas: 07.714.04.00-rc1
[    3.144983] spi-nor spi0.0: w25q64dw (8192 Kbytes)
[    3.149426] 5 fixed-partitions partitions found on MTD device spi0.0
[    3.149489] Creating 5 MTD partitions on "spi0.0":
[    3.149559] 0x000000000000-0x000000020000 : "secure-firmware"
[    3.172940] 0x000000020000-0x000000180000 : "a53-firmware"
[    3.195515] 0x000000180000-0x000000190000 : "u-boot-env"
[    3.215457] 0x000000190000-0x0000007f0000 : "Rescue system"
[    3.235616] 0x0000007f0000-0x000000800000 : "dtb"
[    3.258955] moxtet spi0.1: Found MOX A (CPU) module
[    3.259015] moxtet spi0.1: Found MOX E (8 port switch) module
[    3.259049] moxtet spi0.1: Found MOX E (8 port switch) module
[    3.259082] moxtet spi0.1: Found MOX E (8 port switch) module
[    3.259114] moxtet spi0.1: Found MOX D (SFP cage) module
[    3.261722]
[    3.261753] =============================
[    3.261762] [ BUG: Invalid wait context ]
[    3.261771] 5.13.0-dirty #57 Not tainted
[    3.261781] -----------------------------
[    3.261789] swapper/0/1 is trying to lock:
[    3.261799] ffff000000ee3460 (&info->irq_lock){....}-{3:3}, at: armada_37xx_irq_set_type+0x50/0x174
[    3.261848] other info that might help us debug this:
[    3.261856] context-{5:5}
[    3.261865] 5 locks held by swapper/0/1:
[    3.261875]  #0: ffff0000003321a0 (&dev->mutex){....}-{4:4}, at: device_driver_attach+0x40/0xd0
[    3.261916]  #1: ffff800012c9b4c8 (spi_add_lock){+.+.}-{4:4}, at: spi_add_device+0xa0/0x1f0
[    3.261957]  #2: ffff000001f93190 (&dev->mutex){....}-{4:4}, at: __device_attach+0x3c/0x184
[    3.261993]  #3: ffff000001f91288 (request_class){+.+.}-{4:4}, at: __setup_irq+0xb8/0x760
[    3.262031]  #4: ffff000001f910f8 (lock_class){....}-{2:2}, at: __setup_irq+0xdc/0x760
[    3.262067] stack backtrace:
[    3.262077] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.13.0-dirty #57
[    3.262089] Hardware name: CZ.NIC Turris Mox Board (DT)
[    3.262099] Call trace:
[    3.262106]  dump_backtrace+0x0/0x1b0
[    3.262125]  show_stack+0x18/0x24
[    3.262140]  dump_stack+0xf8/0x168
[    3.262155]  __lock_acquire+0x7d8/0x1c5c
[    3.262172]  lock_acquire.part.0+0xe4/0x220
[    3.262187]  lock_acquire+0x68/0x8c
[    3.262201]  _raw_spin_lock_irqsave+0x88/0x144
[    3.262215]  armada_37xx_irq_set_type+0x50/0x174
[    3.262231]  __irq_set_trigger+0x60/0x18c
[    3.262244]  __setup_irq+0x2b0/0x760
[    3.262256]  request_threaded_irq+0xec/0x1b0
[    3.262270]  moxtet_probe+0x208/0x710
[    3.262284]  spi_probe+0x84/0xe4
[    3.262299]  really_probe+0xe4/0x510
[    3.262312]  driver_probe_device+0x64/0xcc
[    3.262325]  __device_attach_driver+0xb8/0x114
[    3.262338]  bus_for_each_drv+0x78/0xd0
[    3.262351]  __device_attach+0xdc/0x184
[    3.262364]  device_initial_probe+0x14/0x20
[    3.262377]  bus_probe_device+0x9c/0xa4
[    3.262390]  device_add+0x378/0x874
[    3.262406]  spi_add_device+0xf8/0x1f0
[    3.262422]  of_register_spi_device+0x20c/0x35c
[    3.262437]  spi_register_controller+0x670/0x8f0
[    3.262452]  devm_spi_register_controller+0x24/0x80
[    3.262467]  a3700_spi_probe+0x2c4/0x3c0
[    3.262481]  platform_probe+0x68/0xe0
[    3.262496]  really_probe+0xe4/0x510
[    3.262508]  driver_probe_device+0x64/0xcc
[    3.262521]  device_driver_attach+0xc8/0xd0
[    3.262534]  __driver_attach+0x94/0x13c
[    3.262547]  bus_for_each_dev+0x70/0xd0
[    3.262559]  driver_attach+0x24/0x30
[    3.262571]  bus_add_driver+0x108/0x1f0
[    3.262584]  driver_register+0x78/0x130
[    3.262597]  __platform_driver_register+0x28/0x34
[    3.262612]  a3700_spi_driver_init+0x1c/0x28
[    3.262627]  do_one_initcall+0x88/0x450
[    3.262641]  kernel_init_freeable+0x308/0x390
[    3.262655]  kernel_init+0x14/0x120
[    3.262671]  ret_from_fork+0x10/0x34
[    3.278719] libphy: Fixed MDIO Bus: probed
[    3.282363] tun: Universal TUN/TAP device driver, 1.6
[    3.282976] CAN device driver interface
[    3.288635] thunder_xcv, ver 1.0
[    3.288777] thunder_bgx, ver 1.0
[    3.288889] nicpf, ver 1.0
[    3.293110] hclge is initializing
[    3.293201] hns3: Hisilicon Ethernet Network Driver for Hip08 Family - version
[    3.293220] hns3: Copyright (c) 2017 Huawei Corporation.
[    3.293381] e1000: Intel(R) PRO/1000 Network Driver
[    3.293398] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.293536] e1000e: Intel(R) PRO/1000 Network Driver
[    3.293551] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    3.293670] igb: Intel(R) Gigabit Ethernet Network Driver
[    3.293685] igb: Copyright (c) 2007-2014 Intel Corporation.
[    3.293773] igbvf: Intel(R) Gigabit Virtual Function Network Driver
[    3.293788] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    3.295577] libphy: orion_mdio_bus: probed
[    3.303201] mvneta d0030000.ethernet eth0: Using hardware mac address d8:58:d7:00:ca:6c
[    3.304236] sky2: driver version 1.30
[    3.310005] VFIO - User Level meta-driver version: 0.3
[    3.316074] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.316108] ehci-pci: EHCI PCI platform driver
[    3.316222] ehci-platform: EHCI generic platform driver
[    3.316624] ehci-orion: EHCI orion driver
[    3.317434] orion-ehci d005e000.usb: EHCI Host Controller
[    3.317494] orion-ehci d005e000.usb: new USB bus registered, assigned bus number 1
[    3.317775] orion-ehci d005e000.usb: irq 23, io mem 0xd005e000
[    3.335809] orion-ehci d005e000.usb: USB 2.0 started, EHCI 1.00
[    3.337643] hub 1-0:1.0: USB hub found
[    3.337748] hub 1-0:1.0: 1 port detected
[    3.338865] ehci-exynos: EHCI Exynos driver
[    3.339341] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.339420] ohci-pci: OHCI PCI platform driver
[    3.339542] ohci-platform: OHCI generic platform driver
[    3.340145] ohci-exynos: OHCI Exynos driver
[    3.340666] usbcore: registered new interface driver cdc_acm
[    3.340686] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    3.340823] usbcore: registered new interface driver usb-storage
[    3.341034] usbcore: registered new interface driver usbserial_generic
[    3.341097] usbserial: USB Serial support registered for generic
[    3.341182] usbcore: registered new interface driver aircable
[    3.341240] usbserial: USB Serial support registered for aircable
[    3.341323] usbcore: registered new interface driver ark3116
[    3.341386] usbserial: USB Serial support registered for ark3116
[    3.341473] usbcore: registered new interface driver belkin_sa
[    3.341535] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    3.341620] usbcore: registered new interface driver ch341
[    3.341679] usbserial: USB Serial support registered for ch341-uart
[    3.341763] usbcore: registered new interface driver cp210x
[    3.341821] usbserial: USB Serial support registered for cp210x
[    3.341910] usbcore: registered new interface driver cyberjack
[    3.341971] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    3.342057] usbcore: registered new interface driver cypress_m8
[    3.342116] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    3.342175] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    3.342233] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    3.342318] usbcore: registered new interface driver digi_acceleport
[    3.342377] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    3.342440] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    3.342525] usbcore: registered new interface driver io_edgeport
[    3.342584] usbserial: USB Serial support registered for Edgeport 2 port adapter
[    3.342643] usbserial: USB Serial support registered for Edgeport 4 port adapter
[    3.342704] usbserial: USB Serial support registered for Edgeport 8 port adapter
[    3.342762] usbserial: USB Serial support registered for EPiC device
[    3.342847] usbcore: registered new interface driver io_ti
[    3.342911] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[    3.342970] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[    3.343060] usbcore: registered new interface driver empeg
[    3.343119] usbserial: USB Serial support registered for empeg
[    3.343214] usbcore: registered new interface driver f81534a_ctrl
[    3.343292] usbcore: registered new interface driver f81232
[    3.343355] usbserial: USB Serial support registered for f81232
[    3.343414] usbserial: USB Serial support registered for f81534a
[    3.343498] usbcore: registered new interface driver f81534
[    3.343557] usbserial: USB Serial support registered for Fintek F81532/F81534
[    3.343642] usbcore: registered new interface driver ftdi_sio
[    3.343709] usbserial: USB Serial support registered for FTDI USB Serial Device
[    3.343908] usbcore: registered new interface driver garmin_gps
[    3.343978] usbserial: USB Serial support registered for Garmin GPS usb/tty
[    3.344063] usbcore: registered new interface driver ipaq
[    3.344126] usbserial: USB Serial support registered for PocketPC PDA
[    3.344222] usbcore: registered new interface driver ipw
[    3.344282] usbserial: USB Serial support registered for IPWireless converter
[    3.344367] usbcore: registered new interface driver ir_usb
[    3.344426] usbserial: USB Serial support registered for IR Dongle
[    3.344519] usbcore: registered new interface driver iuu_phoenix
[    3.344578] usbserial: USB Serial support registered for iuu_phoenix
[    3.344663] usbcore: registered new interface driver keyspan
[    3.344723] usbserial: USB Serial support registered for Keyspan - (without firmware)
[    3.344783] usbserial: USB Serial support registered for Keyspan 1 port adapter
[    3.344842] usbserial: USB Serial support registered for Keyspan 2 port adapter
[    3.344900] usbserial: USB Serial support registered for Keyspan 4 port adapter
[    3.344989] usbcore: registered new interface driver keyspan_pda
[    3.345049] usbserial: USB Serial support registered for Keyspan PDA
[    3.345108] usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
[    3.345195] usbcore: registered new interface driver kl5kusb105
[    3.345255] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    3.345341] usbcore: registered new interface driver kobil_sct
[    3.345404] usbserial: USB Serial support registered for KOBIL USB smart card terminal
[    3.345492] usbcore: registered new interface driver mct_u232
[    3.345552] usbserial: USB Serial support registered for MCT U232
[    3.345637] usbcore: registered new interface driver metro_usb
[    3.345697] usbserial: USB Serial support registered for Metrologic USB to Serial
[    3.345781] usbcore: registered new interface driver mos7720
[    3.345842] usbserial: USB Serial support registered for Moschip 2 port adapter
[    3.345934] usbcore: registered new interface driver mos7840
[    3.345993] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    3.346080] usbcore: registered new interface driver mxuport
[    3.346140] usbserial: USB Serial support registered for MOXA UPort
[    3.346225] usbcore: registered new interface driver navman
[    3.346285] usbserial: USB Serial support registered for navman
[    3.346374] usbcore: registered new interface driver omninet
[    3.346435] usbserial: USB Serial support registered for ZyXEL - omni.net usb
[    3.346521] usbcore: registered new interface driver opticon
[    3.346581] usbserial: USB Serial support registered for opticon
[    3.346666] usbcore: registered new interface driver option
[    3.346726] usbserial: USB Serial support registered for GSM modem (1-port)
[    3.346845] usbcore: registered new interface driver oti6858
[    3.346909] usbserial: USB Serial support registered for oti6858
[    3.346995] usbcore: registered new interface driver pl2303
[    3.347055] usbserial: USB Serial support registered for pl2303
[    3.347146] usbcore: registered new interface driver qcaux
[    3.347206] usbserial: USB Serial support registered for qcaux
[    3.347293] usbcore: registered new interface driver qcserial
[    3.347354] usbserial: USB Serial support registered for Qualcomm USB modem
[    3.347447] usbcore: registered new interface driver quatech2
[    3.347510] usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    3.347597] usbcore: registered new interface driver safe_serial
[    3.347657] usbserial: USB Serial support registered for safe_serial
[    3.347897] usbcore: registered new interface driver sierra
[    3.347968] usbserial: USB Serial support registered for Sierra USB modem
[    3.348075] usbcore: registered new interface driver usb_serial_simple
[    3.348138] usbserial: USB Serial support registered for carelink
[    3.348199] usbserial: USB Serial support registered for zio
[    3.348258] usbserial: USB Serial support registered for funsoft
[    3.348318] usbserial: USB Serial support registered for flashloader
[    3.348386] usbserial: USB Serial support registered for google
[    3.348446] usbserial: USB Serial support registered for libtransistor
[    3.348506] usbserial: USB Serial support registered for vivopay
[    3.348569] usbserial: USB Serial support registered for moto_modem
[    3.348629] usbserial: USB Serial support registered for motorola_tetra
[    3.348690] usbserial: USB Serial support registered for novatel_gps
[    3.348749] usbserial: USB Serial support registered for hp4x
[    3.348808] usbserial: USB Serial support registered for suunto
[    3.348869] usbserial: USB Serial support registered for siemens_mpi
[    3.348962] usbcore: registered new interface driver spcp8x5
[    3.349027] usbserial: USB Serial support registered for SPCP8x5
[    3.349116] usbcore: registered new interface driver ssu100
[    3.349178] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    3.349270] usbcore: registered new interface driver symbolserial
[    3.349332] usbserial: USB Serial support registered for symbol
[    3.349420] usbcore: registered new interface driver ti_usb_3410_5052
[    3.349482] usbserial: USB Serial support registered for TI USB 3410 1 port adapter
[    3.349547] usbserial: USB Serial support registered for TI USB 5052 2 port adapter
[    3.349636] usbcore: registered new interface driver upd78f0730
[    3.349698] usbserial: USB Serial support registered for upd78f0730
[    3.349796] usbcore: registered new interface driver visor
[    3.349858] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    3.349920] usbserial: USB Serial support registered for Sony Clie 5.0
[    3.349981] usbserial: USB Serial support registered for Sony Clie 3.5
[    3.350075] usbcore: registered new interface driver wishbone_serial
[    3.350138] usbserial: USB Serial support registered for wishbone_serial
[    3.350225] usbcore: registered new interface driver whiteheat
[    3.350288] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    3.350350] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    3.350438] usbcore: registered new interface driver xsens_mt
[    3.350504] usbserial: USB Serial support registered for xsens_mt
[    3.359690] i2c /dev entries driver
[    3.373411] armada_37xx_wdt d0008300.watchdog: Initial timeout 120 sec
[    3.381713] sdhci: Secure Digital Host Controller Interface driver
[    3.381746] sdhci: Copyright(c) Pierre Ossman
[    3.383872] Synopsys Designware Multimedia Card Interface Driver
[    3.386891] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.392537] ledtrig-cpu: registered to indicate activity on CPUs
[    3.397849] usbcore: registered new interface driver usbhid
[    3.397882] usbhid: USB HID core driver
[    3.416859] GACT probability NOT on
[    3.416920] Mirror/redirect action on
[    3.417054] u32 classifier
[    3.417068]     input device check on
[    3.417197]     Actions configured
[    3.417411] Initializing XFRM netlink socket
[    3.417741] NET: Registered protocol family 10
[    3.420284] Segment Routing with IPv6
[    3.420411] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.421631] NET: Registered protocol family 17
[    3.421708] NET: Registered protocol family 15
[    3.422264] can: controller area network core
[    3.422426] NET: Registered protocol family 29
[    3.422445] can: raw protocol
[    3.422465] can: broadcast manager protocol
[    3.422494] can: netlink gateway - max_hops=1
[    3.422708] 8021q: 802.1Q VLAN Support v1.8
[    3.422831] 9pnet: Installing 9P2000 support
[    3.422983] Key type dns_resolver registered
[    3.423893] registered taskstats version 1
[    3.423949] Loading compiled-in X.509 certificates
[    3.425234] Btrfs loaded, crc32c=crc32c-generic, zoned=no
[    3.437820] d0012000.serial: ttyMV0 at MMIO 0xd0012000 (irq = 0, base_baud = 1562500) is a mvebu-uart
[    6.194018] printk: console [ttyMV0] enabled
[    6.206632] i2c i2c-0: Not using recovery: no suitable method provided
[    6.214025] i2c i2c-0:  PXA I2C adapter
[    6.227511] mvneta d0040000.ethernet eth1: Using device tree mac address d8:58:d7:00:ca:6d
[    6.246203] xenon-sdhci d00d8000.sdhci: Got CD GPIO
[    6.285177] Turris Mox serial number 0000000D3000801C
[    6.287404] xenon-sdhci d00d0000.sdhci: allocated mmc-pwrseq
[    6.290448]            board version 22
[    6.290457]            burned RAM size 1024 MiB
[    6.385404] mmc0: SDHCI controller on d00d8000.sdhci [d00d8000.sdhci] using ADMA
[    6.406170] random: fast init done
[    6.412742] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    6.445304] random: crng init done
[    6.459989] ALSA device list:
[    6.463119]   No soundcards found.
[    6.485243] mmc1: SDHCI controller on d00d0000.sdhci [d00d0000.sdhci] using ADMA
[    6.585897] Waiting for root device PARTUUID=2f03a128-2d77-4827-85ae-9410e96b7cd2...
[    6.631356] mmc0: new ultra high speed SDR104 SDHC card at address 0007
[    6.640024] mmcblk0: mmc0:0007 SL32G 29.0 GiB
[    6.653810]  mmcblk0: p1 p2
[    6.696623] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null). Quota mode: none.
[    6.706910] VFS: Mounted root (ext4 filesystem) on device 179:2.
[    6.715643] devtmpfs: mounted
[    6.728360] Freeing unused kernel memory: 9344K
[    6.733198] Run /sbin/init as init process
[    6.737457]   with arguments:
[    6.740542]     /sbin/init
[    6.743338]   with environment:
[    6.746599]     HOME=/
[    6.749054]     TERM=linux
[    7.496861] systemd[1]: System time before build time, advancing clock.
[    7.736132] systemd[1]: systemd 241 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2
 +IDN -PCRE2 default-hierarchy=hybrid)
[    7.761667] systemd[1]: Detected architecture arm64.

Welcome to Debian GNU/Linux 10 (buster)!

[    7.842391] systemd[1]: Set hostname to <debian>.
[    8.464466] systemd[1]: File /lib/systemd/system/systemd-journald.service:12 configures an IP firewall (IPAddressDeny=any), but the local system does not support BPF/cgroup based firewalling.
[    8.482246] systemd[1]: Proceeding WITHOUT firewalling in effect! (This warning is only shown for the first loaded unit using IP firewalling.)
[    8.812437] systemd[1]: Created slice system-getty.slice.
[  OK  ] Created slice system-getty.slice.
[    8.835144] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[    8.856242] systemd[1]: Condition check resulted in Arbitrary Executable File Formats File System Automount Point being skipped.
[    8.869090] systemd[1]: Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[    8.892112] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[  OK  ] Set up automount EFI System Partition Automount.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Created slice system-serial\x2dgetty.slice.
[  OK  ] Listening on Journal Socket.
         Starting Nameserver information manager...
         Mounting Huge Pages File System...
         Mounting POSIX Message Queue File System...
         Starting Load Kernel Modules...
         Mounting Kernel Debug File System...
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Listening on udev Kernel Socket.
         Starting udev Coldplug all Devices...
[  OK  ] Listening on Syslog Socket.
[  OK  ] Listening on Journal Audit Socket.
         Starting Journal Service...
[  OK  ] Started Forward Password R&uests to Wall Directory Watch.
[  OK  ] Reached target Slices.
         Starting Remount Root and Kernel File Systems...
         Starting Create list of re&odes for the current kernel...
[  OK  ] Reached target Swap.
[  OK  ] Started Dispatch Password &ts to Console Directory Watch.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Local Encrypted Volumes.
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Started Load Kernel Modules.
[  OK  ] Mounted Kernel Debug File System.
[  OK  ] Started Remount Root and Kernel File Systems.
[  OK  ] Started Create list of req& nodes for the current kernel.
[  OK  ] Started Nameserver information manager.
         Starting Create System Users...
         Starting Load/Save Random Seed...
         Mounting Kernel Configuration File System...
         Starting Apply Kernel Variables...
         Mounting FUSE Control File System...
[  OK  ] Started Journal Service.
[  OK  ] Started Create System Users.
[  OK  ] Started Load/Save Random Seed.
[  OK  ] Mounted Kernel Configuration File System.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Mounted FUSE Control File System.
         Starting Create Static Device Nodes in /dev...
         Starting Flush Journal to Persistent Storage...
[   10.279549] systemd-journald[159]: Received request to flush runtime journal from PID 1
[  OK  ] Started Flush Journal to Persistent Storage.
[  OK  ] Started Create Static Device Nodes in /dev.
         Starting udev Kernel Device Manager...
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
         Starting Create Volatile Files and Directories...
[  OK  ] Started udev Kernel Device Manager.
[  OK  ] Started Create Volatile Files and Directories.
         Starting Network Time Synchronization...
         Starting Update UTMP about System Boot/Shutdown...
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Time Synchronized.
[  OK  ] Started udev Coldplug all Devices.
         Starting Helper to synchronize boot up for ifupdown...
[  OK  ] Reached target System Initialization.
[  OK  ] Started Daily apt download activities.
[  OK  ] Started Daily rotation of log files.
[  OK  ] Started Daily apt upgrade and clean activities.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
         Starting System Logging Service...
[  OK  ] Started Regular background program processing daemon.
         Starting Login Service...
[  OK  ] Started D-Bus System Message Bus.
         Starting WPA supplicant...
[  OK  ] Started System Logging Service.
[  OK  ] Started Login Service.
[  OK  ] Started WPA supplicant.
[   13.980338] libphy: SFP I2C Bus: probed
[   14.009675] sfp sfp: Host maximum power 3.0W
[  OK  ] Found device /dev/ttyMV0.
[   14.149780] rtc-ds1307 0-006f: registered as rtc0
[   14.167539] rtc-ds1307 0-006f: setting system clock to 2021-09-03T16:13:56 UTC (1630685636)
[   14.360995] sfp sfp: module UBNT             UF-RJ45-1G       rev 1.0  sn X20072804742     dc 200617
[  OK  ] Listening on Load/Save RF &itch Status /dev/rfkill Watch.
[   19.701453] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
[   19.755021] libphy: mdio: probed
[    **] A start job is running for Helper t&ot up for ifupdown (17s / 3min 3s)
[   26.101349] mv88e6085 d0032004.mdio-mii:11: switch 0x1900 detected: Marvell 88E6190, revision 1
[**    ] A start job is running for Helper t&ot up for ifupdown (22s / 3min 3s)
[   31.733283] mv88e6085 d0032004.mdio-mii:12: switch 0x1900 detected: Marvell 88E6190, revision 1
[ ***  ] A start job is running for Helper t&ot up for ifupdown (32s / 3min 3s)
[     *] A start job is running for Helper t&ot up for ifupdown (34s / 3min 3s)
[  *** ] A start job is running for Helper t&ot up for ifupdown (36s / 3min 3s)
[*     ] A start job is running for Helper t&ot up for ifupdown (38s / 3min 3s)
[  *** ] A start job is running for Helper t&ot up for ifupdown (41s / 3min 3s)
[    **] A start job is running for Helper t&ot up for ifupdown (43s / 3min 3s)
[***   ] A start job is running for Helper t&ot up for ifupdown (45s / 3min 3s)
[***   ] A start job is running for Helper t&ot up for ifupdown (47s / 3min 3s)
[     *] A start job is running for Helper t&ot up for ifupdown (49s / 3min 3s)
[ ***  ] A start job is running for Helper t&ot up for ifupdown (51s / 3min 3s)
[   ***] A start job is running for Helper t&ot up for ifupdown (55s / 3min 3s)
[   ***] A start job is running for Helper t&ot up for ifupdown (57s / 3min 3s)
[*     ] A start job is running for Helper t&t up for ifupdown (1min / 3min 3s)
[  *** ] A start job is running for Helper t&p for ifupdown (1min 2s / 3min 3s)
[    **] A start job is running for Helper t&p for ifupdown (1min 4s / 3min 3s)
[***   ] A start job is running for Helper t&p for ifupdown (1min 6s / 3min 3s)
[ ***  ] A start job is running for Helper t&p for ifupdown (1min 8s / 3min 3s)
[     *] A start job is running for Helper t& for ifupdown (1min 10s / 3min 3s)
[ ***  ] A start job is running for Helper t& for ifupdown (1min 12s / 3min 3s)
[   81.775633] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   81.892313] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[**    ] A start job is running for Helper t& for ifupdown (1min 14s / 3min 3s)
[  *** ] A start job is running for Helper t& for ifupdown (1min 19s / 3min 3s)
[*     ] A start job is running for Helper t& for ifupdown (1min 21s / 3min 3s)
[  *** ] A start job is running for Helper t& for ifupdown (1min 23s / 3min 3s)
[    **] A start job is running for Helper t& for ifupdown (1min 25s / 3min 3s)
[**    ] A start job is running for Helper t& for ifupdown (1min 27s / 3min 3s)
[ ***  ] A start job is running for Helper t& for ifupdown (1min 29s / 3min 3s)
[     *] A start job is running for Helper t& for ifupdown (1min 31s / 3min 3s)
[***   ] A start job is running for Helper t& for ifupdown (1min 34s / 3min 3s)
[***   ] A start job is running for Helper t& for ifupdown (1min 36s / 3min 3s)
[  105.071836] mv88e6085 d0032004.mdio-mii:12: configuring for inband/2500base-x link mode
[  105.202675] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[    **] A start job is running for Helper t& for ifupdown (1min 38s / 3min 3s)
[  OK  ] Started Helper to synchronize boot up for ifupdown.
         Starting Raise network interfaces...
[  112.175932] br0: port 1(lan1) entered blocking state
[  112.181344] br0: port 1(lan1) entered disabled state
[  112.213622] device lan1 entered promiscuous mode
[  112.929794] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[  112.939067] device eth1 entered promiscuous mode
[  112.947940] mv88e6085 d0032004.mdio-mii:10 lan1: configuring for phy/ link mode
[  112.961946] 8021q: adding VLAN 0 to HW filter on device lan1
[  112.968134] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  112.976870] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  112.997847] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  113.001097] br0: port 2(lan2) entered blocking state
[  113.011937] br0: port 2(lan2) entered disabled state
[  113.069548] device lan2 entered promiscuous mode
[  113.213040] mv88e6085 d0032004.mdio-mii:10 lan2: configuring for phy/ link mode
[  113.222844] 8021q: adding VLAN 0 to HW filter on device lan2
[  113.250418] br0: port 3(lan3) entered blocking state
[  113.255930] br0: port 3(lan3) entered disabled state
[  113.319009] device lan3 entered promiscuous mode
[  113.489865] mv88e6085 d0032004.mdio-mii:10 lan3: configuring for phy/ link mode
[  113.499686] 8021q: adding VLAN 0 to HW filter on device lan3
[  113.527708] br0: port 4(lan4) entered blocking state
[  113.533011] br0: port 4(lan4) entered disabled state
[  113.581209] device lan4 entered promiscuous mode
[  113.742658] mv88e6085 d0032004.mdio-mii:10 lan4: configuring for phy/ link mode
[  113.753956] 8021q: adding VLAN 0 to HW filter on device lan4
[  113.773541] br0: port 5(lan5) entered blocking state
[  113.778827] br0: port 5(lan5) entered disabled state
[  113.828562] device lan5 entered promiscuous mode
[  113.990160] mv88e6085 d0032004.mdio-mii:10 lan5: configuring for phy/ link mode
[  114.001244] 8021q: adding VLAN 0 to HW filter on device lan5
[  114.037983] br0: port 6(lan6) entered blocking state
[  114.043361] br0: port 6(lan6) entered disabled state
[  114.098279] device lan6 entered promiscuous mode
[  114.268780] mv88e6085 d0032004.mdio-mii:10 lan6: configuring for phy/ link mode
[  114.278544] 8021q: adding VLAN 0 to HW filter on device lan6
[  114.318853] br0: port 7(lan7) entered blocking state
[  114.324215] br0: port 7(lan7) entered disabled state
[  114.393278] device lan7 entered promiscuous mode
[  114.556662] mv88e6085 d0032004.mdio-mii:10 lan7: configuring for phy/ link mode
[  114.566431] 8021q: adding VLAN 0 to HW filter on device lan7
[  114.606874] br0: port 8(lan8) entered blocking state
[  114.612274] br0: port 8(lan8) entered disabled state
[  114.669046] device lan8 entered promiscuous mode
[  114.837700] mv88e6085 d0032004.mdio-mii:10 lan8: configuring for phy/ link mode
[  114.847701] 8021q: adding VLAN 0 to HW filter on device lan8
[  114.882902] br0: port 9(lan9) entered blocking state
[  114.888278] br0: port 9(lan9) entered disabled state
[  115.008157] device lan9 entered promiscuous mode
[  115.137708] mv88e6085 d0032004.mdio-mii:11 lan9: configuring for phy/ link mode
[  115.147541] 8021q: adding VLAN 0 to HW filter on device lan9
[  115.183458] br0: port 10(lan10) entered blocking state
[  115.189156] br0: port 10(lan10) entered disabled state
[  115.272476] device lan10 entered promiscuous mode
[  115.432961] mv88e6085 d0032004.mdio-mii:11 lan10: configuring for phy/ link mode
[  115.445011] 8021q: adding VLAN 0 to HW filter on device lan10
[  115.462663] br0: port 11(lan11) entered blocking state
[  115.468107] br0: port 11(lan11) entered disabled state
[  115.527421] device lan11 entered promiscuous mode
[  115.690067] mv88e6085 d0032004.mdio-mii:11 lan11: configuring for phy/ link mode
[  115.700797] 8021q: adding VLAN 0 to HW filter on device lan11
[  115.734482] br0: port 12(lan12) entered blocking state
[  115.740030] br0: port 12(lan12) entered disabled state
[  115.812842] device lan12 entered promiscuous mode
[  115.984629] mv88e6085 d0032004.mdio-mii:11 lan12: configuring for phy/ link mode
[  115.994581] 8021q: adding VLAN 0 to HW filter on device lan12
[  116.018519] br0: port 13(lan13) entered blocking state
[  116.023990] br0: port 13(lan13) entered disabled state
[  116.086564] device lan13 entered promiscuous mode
[  116.253393] mv88e6085 d0032004.mdio-mii:11 lan13: configuring for phy/ link mode
[  116.263270] 8021q: adding VLAN 0 to HW filter on device lan13
[  116.286742] br0: port 14(lan14) entered blocking state
[  116.292191] br0: port 14(lan14) entered disabled state
[  116.354713] device lan14 entered promiscuous mode
[  116.515098] mv88e6085 d0032004.mdio-mii:11 lan14: configuring for phy/ link mode
[  116.524951] 8021q: adding VLAN 0 to HW filter on device lan14
[  116.551131] br0: port 15(lan15) entered blocking state
[  116.552791] mv88e6085 d0032004.mdio-mii:10 lan2: Link is Up - 1Gbps/Full - flow control off
[  116.556818] br0: port 15(lan15) entered disabled state
[  116.601479] mv88e6085 d0032004.mdio-mii:10 lan1: Link is Up - 1Gbps/Full - flow control off
[  116.645693] device lan15 entered promiscuous mode
[***   ] A start job is running for Raise ne&k interfaces (1min 47s / 6min 42s)
[  116.789452] mv88e6085 d0032004.mdio-mii:11 lan15: configuring for phy/ link mode
[  116.799565] 8021q: adding VLAN 0 to HW filter on device lan15
[  116.835127] br0: port 16(lan16) entered blocking state
[  116.840664] br0: port 16(lan16) entered disabled state
[  116.917675] device lan16 entered promiscuous mode
[  117.077850] mv88e6085 d0032004.mdio-mii:11 lan16: configuring for phy/ link mode
[  117.088060] 8021q: adding VLAN 0 to HW filter on device lan16
[  117.122275] br0: port 17(lan17) entered blocking state
[ ***  ] A start job is running for Raise ne&k interfaces (1min 48s / 6min 42s)
[  117.240834] device lan17 entered promiscuous mode
[  117.346299] mv88e6085 d0032004.mdio-mii:10 lan4: Link is Up - 1Gbps/Full - flow control rx/tx
[  117.380642] mv88e6085 d0032004.mdio-mii:12 lan17: configuring for phy/ link mode
[  117.389929] 8021q: adding VLAN 0 to HW filter on device lan17
[  117.420135] br0: port 18(lan18) entered blocking state
[  117.425755] br0: port 18(lan18) entered disabled state
[  117.521519] device lan18 entered promiscuous mode
[  117.678400] mv88e6085 d0032004.mdio-mii:12 lan18: configuring for phy/ link mode
[  117.688779] 8021q: adding VLAN 0 to HW filter on device lan18
[  117.722416] br0: port 19(lan19) entered blocking state
[  *** ] A start job is running for Raise ne&k interfaces (1min 48s / 6min 42s)
[  117.819299] device lan19 entered promiscuous mode
[  117.981260] mv88e6085 d0032004.mdio-mii:12 lan19: configuring for phy/ link mode
[  117.991535] 8021q: adding VLAN 0 to HW filter on device lan19
[  118.011239] br0: port 20(lan20) entered blocking state
[  118.016700] br0: port 20(lan20) entered disabled state
[   ***] A start job is running for Raise ne&k interfaces (1min 49s / 6min 42s)
[  118.262759] mv88e6085 d0032004.mdio-mii:12 lan20: configuring for phy/ link mode
[  118.273829] 8021q: adding VLAN 0 to HW filter on device lan20
[  118.293549] br0: port 21(lan21) entered blocking state
[  118.299056] br0: port 21(lan21) entered disabled state
[  118.398286] device lan21 entered promiscuous mode
[  118.557655] mv88e6085 d0032004.mdio-mii:12 lan21: configuring for phy/ link mode
[  118.567560] 8021q: adding VLAN 0 to HW filter on device lan21
[  118.613802] br0: port 22(lan22) entered blocking state
[  118.619362] br0: port 22(lan22) entered disabled state
[    **] A start job is running for Raise ne&k interfaces (1min 49s / 6min 42s)
[  118.874460] mv88e6085 d0032004.mdio-mii:12 lan22: configuring for phy/ link mode
[  118.886459] 8021q: adding VLAN 0 to HW filter on device lan22
[  118.904730] br0: port 23(lan23) entered blocking state
[  118.910200] br0: port 23(lan23) entered disabled state
[  118.985279] device lan23 entered promiscuous mode
[  119.156980] mv88e6085 d0032004.mdio-mii:12 lan23: configuring for phy/ link mode
[  119.166915] 8021q: adding VLAN 0 to HW filter on device lan23
[  119.202835] br0: port 24(lan24) entered blocking state
[     *] A start job is running for Raise ne&k interfaces (1min 50s / 6min 42s)
[  119.308959] device lan24 entered promiscuous mode
[  119.468972] mv88e6085 d0032004.mdio-mii:12 lan24: configuring for phy/ link mode
[  119.478993] 8021q: adding VLAN 0 to HW filter on device lan24
[  119.507115] br0: port 25(sfp) entered blocking state
[  119.512442] br0: port 25(sfp) entered disabled state
[    **] A start job is running for Raise ne&k interfaces (1min 50s / 6min 42s)
[  119.767728] mv88e6085 d0032004.mdio-mii:12 sfp: configuring for inband/sgmii link mode
[  119.810885] 8021q: adding VLAN 0 to HW filter on device sfp
[  119.854604] br0: port 4(lan4) entered blocking state
[  119.859880] br0: port 4(lan4) entered forwarding state
[  119.865470] br0: port 2(lan2) entered blocking state
[  119.870828] br0: port 2(lan2) entered forwarding state
[  119.876309] br0: port 1(lan1) entered blocking state
[  119.881531] br0: port 1(lan1) entered forwarding state
[  120.029236] mv88e6085 d0032004.mdio-mii:12 sfp: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
[  OK  ] Started Raise network interfaces.
[  OK  ] Reached target Network.
         Starting Permit User Sessions...
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Serial Getty on ttyMV0.
[  OK  ] Started Getty on tty1.
[  OK  ] Reached target Login Prompts.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.
[  120.764019] mv88e6085 d0032004.mdio-mii:12 lan19: Link is Up - 1Gbps/Full - flow control off
         Starting Update UTMP about System Runlevel Changes...
[  OK  ] Started Update UTMP about System Runlevel Changes.
[  121.689465] mv88e6085 d0032004.mdio-mii:12 lan22: Link is Up - 1Gbps/Full - flow control rx/tx

Debian GNU/Linux 10 debian ttyMV0

debian login: [  122.252852] mv88e6085 d0032004.mdio-mii:12 lan21: Link is Up - 1Gbps/Full - flow control off
[  122.284829] mv88e6085 d0032004.mdio-mii:12 lan24: Link is Up - 1Gbps/Full - flow control off
[  122.891518] br0: port 19(lan19) entered blocking state
[  122.896979] br0: port 19(lan19) entered forwarding state
[  122.904944] br0: port 22(lan22) entered blocking state
[  122.910397] br0: port 22(lan22) entered forwarding state
[  122.918002] br0: port 21(lan21) entered blocking state
[  122.923620] br0: port 21(lan21) entered forwarding state
[  122.929512] br0: port 24(lan24) entered blocking state
[  122.934908] br0: port 24(lan24) entered forwarding state
[  123.151731] mv88e6085 d0032004.mdio-mii:12 sfp: Link is Up - 1Gbps/Full - flow control off
[  123.152250] br0: port 25(sfp) entered blocking state
[  123.166112] br0: port 25(sfp) entered forwarding state
root
Password:
Last login: Fri Sep  3 16:06:06 UTC 2021 on ttyMV0
Linux debian 5.13.0-dirty #57 SMP PREEMPT Fri Sep 3 18:58:44 EEST 2021 aarch64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
root@debian:~# bridge link
6: lan1@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
7: lan2@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
8: lan3@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
9: lan4@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
10: lan5@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
11: lan6@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
12: lan7@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
13: lan8@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
14: lan9@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
15: lan10@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
16: lan11@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
17: lan12@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
18: lan13@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
19: lan14@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
20: lan15@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
21: lan16@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
22: lan17@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
23: lan18@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
24: lan19@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
25: lan20@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
26: lan21@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
27: lan22@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
28: lan23@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
29: lan24@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
30: sfp@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
root@debian:~# dmesg | tail -200
[   14.009675] sfp sfp: Host maximum power 3.0W
[   14.149780] rtc-ds1307 0-006f: registered as rtc0
[   14.167539] rtc-ds1307 0-006f: setting system clock to 2021-09-03T16:13:56 UTC (1630685636)
[   14.360995] sfp sfp: module UBNT             UF-RJ45-1G       rev 1.0  sn X20072804742     dc 200617
[   19.701453] mv88e6085 d0032004.mdio-mii:10: switch 0x3900 detected: Marvell 88E6390, revision 1
[   19.755021] libphy: mdio: probed
[   26.101349] mv88e6085 d0032004.mdio-mii:11: switch 0x1900 detected: Marvell 88E6190, revision 1
[   26.157327] libphy: mdio: probed
[   31.733283] mv88e6085 d0032004.mdio-mii:12: switch 0x1900 detected: Marvell 88E6190, revision 1
[   31.798548] libphy: mdio: probed
[   41.496657] mv88e6085 d0032004.mdio-mii:10 lan1 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:01] driver [Marvell 88E6390 Family] (irq=68)
[   43.636674] mv88e6085 d0032004.mdio-mii:10 lan2 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:02] driver [Marvell 88E6390 Family] (irq=69)
[   45.780622] mv88e6085 d0032004.mdio-mii:10 lan3 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:03] driver [Marvell 88E6390 Family] (irq=70)
[   47.890173] mv88e6085 d0032004.mdio-mii:10 lan4 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:04] driver [Marvell 88E6390 Family] (irq=71)
[   50.004524] mv88e6085 d0032004.mdio-mii:10 lan5 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:05] driver [Marvell 88E6390 Family] (irq=72)
[   52.148524] mv88e6085 d0032004.mdio-mii:10 lan6 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:06] driver [Marvell 88E6390 Family] (irq=73)
[   54.292404] mv88e6085 d0032004.mdio-mii:10 lan7 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:07] driver [Marvell 88E6390 Family] (irq=74)
[   56.436542] mv88e6085 d0032004.mdio-mii:10 lan8 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch0@10!mdio:08] driver [Marvell 88E6390 Family] (irq=75)
[   58.512133] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   60.591811] mv88e6085 d0032004.mdio-mii:10: configuring for inband/2500base-x link mode
[   64.756483] mv88e6085 d0032004.mdio-mii:11 lan9 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:01] driver [Marvell 88E6390 Family] (irq=93)
[   66.885776] mv88e6085 d0032004.mdio-mii:11 lan10 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:02] driver [Marvell 88E6390 Family] (irq=94)
[   68.991006] mv88e6085 d0032004.mdio-mii:11 lan11 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:03] driver [Marvell 88E6390 Family] (irq=95)
[   71.124470] mv88e6085 d0032004.mdio-mii:11 lan12 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:04] driver [Marvell 88E6390 Family] (irq=96)
[   73.264703] mv88e6085 d0032004.mdio-mii:11 lan13 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:05] driver [Marvell 88E6390 Family] (irq=97)
[   75.412538] mv88e6085 d0032004.mdio-mii:11 lan14 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:06] driver [Marvell 88E6390 Family] (irq=98)
[   77.560780] mv88e6085 d0032004.mdio-mii:11 lan15 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:07] driver [Marvell 88E6390 Family] (irq=99)
[   79.700652] mv88e6085 d0032004.mdio-mii:11 lan16 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch1@11!mdio:08] driver [Marvell 88E6390 Family] (irq=100)
[   81.775633] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   81.892313] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   81.894712] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[   83.854388] mv88e6085 d0032004.mdio-mii:11: configuring for inband/2500base-x link mode
[   88.024793] mv88e6085 d0032004.mdio-mii:12 lan17 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:01] driver [Marvell 88E6390 Family] (irq=118)
[   90.160469] mv88e6085 d0032004.mdio-mii:12 lan18 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:02] driver [Marvell 88E6390 Family] (irq=119)
[   92.284706] mv88e6085 d0032004.mdio-mii:12 lan19 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:03] driver [Marvell 88E6390 Family] (irq=120)
[   94.420438] mv88e6085 d0032004.mdio-mii:12 lan20 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:04] driver [Marvell 88E6390 Family] (irq=121)
[   96.564646] mv88e6085 d0032004.mdio-mii:12 lan21 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:05] driver [Marvell 88E6390 Family] (irq=122)
[   98.708635] mv88e6085 d0032004.mdio-mii:12 lan22 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:06] driver [Marvell 88E6390 Family] (irq=123)
[  100.852727] mv88e6085 d0032004.mdio-mii:12 lan23 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:07] driver [Marvell 88E6390 Family] (irq=124)
[  102.999295] mv88e6085 d0032004.mdio-mii:12 lan24 (uninitialized): PHY [!soc!internal-regs@d0000000!mdio@32004!switch2@12!mdio:08] driver [Marvell 88E6390 Family] (irq=125)
[  105.071836] mv88e6085 d0032004.mdio-mii:12: configuring for inband/2500base-x link mode
[  105.202675] mv88e6085 d0032004.mdio-mii:11: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  105.210102] mv88e6085 d0032004.mdio-mii:12: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  107.137587] DSA: tree 0 setup
[  112.175932] br0: port 1(lan1) entered blocking state
[  112.181344] br0: port 1(lan1) entered disabled state
[  112.213622] device lan1 entered promiscuous mode
[  112.929794] mvneta d0040000.ethernet eth1: configuring for inband/2500base-x link mode
[  112.939067] device eth1 entered promiscuous mode
[  112.947940] mv88e6085 d0032004.mdio-mii:10 lan1: configuring for phy/ link mode
[  112.961946] 8021q: adding VLAN 0 to HW filter on device lan1
[  112.968134] mvneta d0040000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  112.976870] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  112.997847] mv88e6085 d0032004.mdio-mii:10: Link is Up - 2.5Gbps/Full - flow control rx/tx
[  113.001097] br0: port 2(lan2) entered blocking state
[  113.011937] br0: port 2(lan2) entered disabled state
[  113.069548] device lan2 entered promiscuous mode
[  113.213040] mv88e6085 d0032004.mdio-mii:10 lan2: configuring for phy/ link mode
[  113.222844] 8021q: adding VLAN 0 to HW filter on device lan2
[  113.250418] br0: port 3(lan3) entered blocking state
[  113.255930] br0: port 3(lan3) entered disabled state
[  113.319009] device lan3 entered promiscuous mode
[  113.489865] mv88e6085 d0032004.mdio-mii:10 lan3: configuring for phy/ link mode
[  113.499686] 8021q: adding VLAN 0 to HW filter on device lan3
[  113.527708] br0: port 4(lan4) entered blocking state
[  113.533011] br0: port 4(lan4) entered disabled state
[  113.581209] device lan4 entered promiscuous mode
[  113.742658] mv88e6085 d0032004.mdio-mii:10 lan4: configuring for phy/ link mode
[  113.753956] 8021q: adding VLAN 0 to HW filter on device lan4
[  113.773541] br0: port 5(lan5) entered blocking state
[  113.778827] br0: port 5(lan5) entered disabled state
[  113.828562] device lan5 entered promiscuous mode
[  113.990160] mv88e6085 d0032004.mdio-mii:10 lan5: configuring for phy/ link mode
[  114.001244] 8021q: adding VLAN 0 to HW filter on device lan5
[  114.037983] br0: port 6(lan6) entered blocking state
[  114.043361] br0: port 6(lan6) entered disabled state
[  114.098279] device lan6 entered promiscuous mode
[  114.268780] mv88e6085 d0032004.mdio-mii:10 lan6: configuring for phy/ link mode
[  114.278544] 8021q: adding VLAN 0 to HW filter on device lan6
[  114.318853] br0: port 7(lan7) entered blocking state
[  114.324215] br0: port 7(lan7) entered disabled state
[  114.393278] device lan7 entered promiscuous mode
[  114.556662] mv88e6085 d0032004.mdio-mii:10 lan7: configuring for phy/ link mode
[  114.566431] 8021q: adding VLAN 0 to HW filter on device lan7
[  114.606874] br0: port 8(lan8) entered blocking state
[  114.612274] br0: port 8(lan8) entered disabled state
[  114.669046] device lan8 entered promiscuous mode
[  114.837700] mv88e6085 d0032004.mdio-mii:10 lan8: configuring for phy/ link mode
[  114.847701] 8021q: adding VLAN 0 to HW filter on device lan8
[  114.882902] br0: port 9(lan9) entered blocking state
[  114.888278] br0: port 9(lan9) entered disabled state
[  115.008157] device lan9 entered promiscuous mode
[  115.137708] mv88e6085 d0032004.mdio-mii:11 lan9: configuring for phy/ link mode
[  115.147541] 8021q: adding VLAN 0 to HW filter on device lan9
[  115.183458] br0: port 10(lan10) entered blocking state
[  115.189156] br0: port 10(lan10) entered disabled state
[  115.272476] device lan10 entered promiscuous mode
[  115.432961] mv88e6085 d0032004.mdio-mii:11 lan10: configuring for phy/ link mode
[  115.445011] 8021q: adding VLAN 0 to HW filter on device lan10
[  115.462663] br0: port 11(lan11) entered blocking state
[  115.468107] br0: port 11(lan11) entered disabled state
[  115.527421] device lan11 entered promiscuous mode
[  115.690067] mv88e6085 d0032004.mdio-mii:11 lan11: configuring for phy/ link mode
[  115.700797] 8021q: adding VLAN 0 to HW filter on device lan11
[  115.734482] br0: port 12(lan12) entered blocking state
[  115.740030] br0: port 12(lan12) entered disabled state
[  115.812842] device lan12 entered promiscuous mode
[  115.984629] mv88e6085 d0032004.mdio-mii:11 lan12: configuring for phy/ link mode
[  115.994581] 8021q: adding VLAN 0 to HW filter on device lan12
[  116.018519] br0: port 13(lan13) entered blocking state
[  116.023990] br0: port 13(lan13) entered disabled state
[  116.086564] device lan13 entered promiscuous mode
[  116.253393] mv88e6085 d0032004.mdio-mii:11 lan13: configuring for phy/ link mode
[  116.263270] 8021q: adding VLAN 0 to HW filter on device lan13
[  116.286742] br0: port 14(lan14) entered blocking state
[  116.292191] br0: port 14(lan14) entered disabled state
[  116.354713] device lan14 entered promiscuous mode
[  116.515098] mv88e6085 d0032004.mdio-mii:11 lan14: configuring for phy/ link mode
[  116.524951] 8021q: adding VLAN 0 to HW filter on device lan14
[  116.551131] br0: port 15(lan15) entered blocking state
[  116.552791] mv88e6085 d0032004.mdio-mii:10 lan2: Link is Up - 1Gbps/Full - flow control off
[  116.556818] br0: port 15(lan15) entered disabled state
[  116.601479] mv88e6085 d0032004.mdio-mii:10 lan1: Link is Up - 1Gbps/Full - flow control off
[  116.645693] device lan15 entered promiscuous mode
[  116.789452] mv88e6085 d0032004.mdio-mii:11 lan15: configuring for phy/ link mode
[  116.799565] 8021q: adding VLAN 0 to HW filter on device lan15
[  116.835127] br0: port 16(lan16) entered blocking state
[  116.840664] br0: port 16(lan16) entered disabled state
[  116.917675] device lan16 entered promiscuous mode
[  117.077850] mv88e6085 d0032004.mdio-mii:11 lan16: configuring for phy/ link mode
[  117.088060] 8021q: adding VLAN 0 to HW filter on device lan16
[  117.122275] br0: port 17(lan17) entered blocking state
[  117.127897] br0: port 17(lan17) entered disabled state
[  117.240834] device lan17 entered promiscuous mode
[  117.346299] mv88e6085 d0032004.mdio-mii:10 lan4: Link is Up - 1Gbps/Full - flow control rx/tx
[  117.380642] mv88e6085 d0032004.mdio-mii:12 lan17: configuring for phy/ link mode
[  117.389929] 8021q: adding VLAN 0 to HW filter on device lan17
[  117.420135] br0: port 18(lan18) entered blocking state
[  117.425755] br0: port 18(lan18) entered disabled state
[  117.521519] device lan18 entered promiscuous mode
[  117.678400] mv88e6085 d0032004.mdio-mii:12 lan18: configuring for phy/ link mode
[  117.688779] 8021q: adding VLAN 0 to HW filter on device lan18
[  117.722416] br0: port 19(lan19) entered blocking state
[  117.728060] br0: port 19(lan19) entered disabled state
[  117.819299] device lan19 entered promiscuous mode
[  117.981260] mv88e6085 d0032004.mdio-mii:12 lan19: configuring for phy/ link mode
[  117.991535] 8021q: adding VLAN 0 to HW filter on device lan19
[  118.011239] br0: port 20(lan20) entered blocking state
[  118.016700] br0: port 20(lan20) entered disabled state
[  118.089394] device lan20 entered promiscuous mode
[  118.262759] mv88e6085 d0032004.mdio-mii:12 lan20: configuring for phy/ link mode
[  118.273829] 8021q: adding VLAN 0 to HW filter on device lan20
[  118.293549] br0: port 21(lan21) entered blocking state
[  118.299056] br0: port 21(lan21) entered disabled state
[  118.398286] device lan21 entered promiscuous mode
[  118.557655] mv88e6085 d0032004.mdio-mii:12 lan21: configuring for phy/ link mode
[  118.567560] 8021q: adding VLAN 0 to HW filter on device lan21
[  118.613802] br0: port 22(lan22) entered blocking state
[  118.619362] br0: port 22(lan22) entered disabled state
[  118.721963] device lan22 entered promiscuous mode
[  118.874460] mv88e6085 d0032004.mdio-mii:12 lan22: configuring for phy/ link mode
[  118.886459] 8021q: adding VLAN 0 to HW filter on device lan22
[  118.904730] br0: port 23(lan23) entered blocking state
[  118.910200] br0: port 23(lan23) entered disabled state
[  118.985279] device lan23 entered promiscuous mode
[  119.156980] mv88e6085 d0032004.mdio-mii:12 lan23: configuring for phy/ link mode
[  119.166915] 8021q: adding VLAN 0 to HW filter on device lan23
[  119.202835] br0: port 24(lan24) entered blocking state
[  119.208429] br0: port 24(lan24) entered disabled state
[  119.308959] device lan24 entered promiscuous mode
[  119.468972] mv88e6085 d0032004.mdio-mii:12 lan24: configuring for phy/ link mode
[  119.478993] 8021q: adding VLAN 0 to HW filter on device lan24
[  119.507115] br0: port 25(sfp) entered blocking state
[  119.512442] br0: port 25(sfp) entered disabled state
[  119.592347] device sfp entered promiscuous mode
[  119.767728] mv88e6085 d0032004.mdio-mii:12 sfp: configuring for inband/sgmii link mode
[  119.810885] 8021q: adding VLAN 0 to HW filter on device sfp
[  119.854604] br0: port 4(lan4) entered blocking state
[  119.859880] br0: port 4(lan4) entered forwarding state
[  119.865470] br0: port 2(lan2) entered blocking state
[  119.870828] br0: port 2(lan2) entered forwarding state
[  119.876309] br0: port 1(lan1) entered blocking state
[  119.881531] br0: port 1(lan1) entered forwarding state
[  120.029236] mv88e6085 d0032004.mdio-mii:12 sfp: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
[  120.050472] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[  120.764019] mv88e6085 d0032004.mdio-mii:12 lan19: Link is Up - 1Gbps/Full - flow control off
[  121.689465] mv88e6085 d0032004.mdio-mii:12 lan22: Link is Up - 1Gbps/Full - flow control rx/tx
[  122.252852] mv88e6085 d0032004.mdio-mii:12 lan21: Link is Up - 1Gbps/Full - flow control off
[  122.284829] mv88e6085 d0032004.mdio-mii:12 lan24: Link is Up - 1Gbps/Full - flow control off
[  122.891518] br0: port 19(lan19) entered blocking state
[  122.896979] br0: port 19(lan19) entered forwarding state
[  122.904944] br0: port 22(lan22) entered blocking state
[  122.910397] br0: port 22(lan22) entered forwarding state
[  122.918002] br0: port 21(lan21) entered blocking state
[  122.923620] br0: port 21(lan21) entered forwarding state
[  122.929512] br0: port 24(lan24) entered blocking state
[  122.934908] br0: port 24(lan24) entered forwarding state
[  123.151731] mv88e6085 d0032004.mdio-mii:12 sfp: Link is Up - 1Gbps/Full - flow control off
[  123.152250] br0: port 25(sfp) entered blocking state
[  123.166112] br0: port 25(sfp) entered forwarding state
root@debian:~#


Any idea what else might be different between our systems, any other
services? As mentioned, my installation is absolutely fresh and there
isn't much going on.
