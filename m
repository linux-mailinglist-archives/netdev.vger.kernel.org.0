Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5396F29D98A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389854AbgJ1W4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:56:00 -0400
Received: from depni-mx.sinp.msu.ru ([213.131.7.21]:25 "EHLO
        depni-mx.sinp.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389695AbgJ1Wx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:53:27 -0400
Received: from spider (unknown [176.192.246.239])
        by depni-mx.sinp.msu.ru (Postfix) with ESMTPSA id 484511BF44D;
        Wed, 28 Oct 2020 17:34:51 +0300 (MSK)
From:   Serge Belyshev <belyshev@depni.sinp.msu.ru>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
        <877drabmoq.fsf@depni.sinp.msu.ru>
        <c9cbe7ae-ca05-1462-3c6b-6582586f3857@gmail.com>
Date:   Wed, 28 Oct 2020 17:34:47 +0300
In-Reply-To: <c9cbe7ae-ca05-1462-3c6b-6582586f3857@gmail.com> (Heiner
        Kallweit's message of "Wed, 28 Oct 2020 15:04:25 +0100")
Message-ID: <87361yberc.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain


>> [    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])
>> 

> Please provide the following info in addition:
> - dmesg
> - lspci -v
> - cat /proc/interrupts

Attached below.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg.txt

[    0.000000] Linux version 5.9.0-10641-g424a646e072a (ssb@spider) (gcc 4.9.4, GNU ld (GNU Binutils for Debian) 2.35.1) #1379 SMP Wed Oct 28 14:04:32 MSK 2020
[    0.000000] Command line: root=/dev/sda ro rootfstype=ext4 tsc_khz=3315112 hugepagesz=2M hugepagesz=1G lapic_timer_c2_ok idle=halt hpet=nolegsup mitigations=off threadirqs rqshare=all BOOT_IMAGE=/boot/bzImage.test 
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfedffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfee0000-0x00000000cfee2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfee3000-0x00000000cfeeffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfef0000-0x00000000cfefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3314.922 MHz processor
[    0.004224] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.004226] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.012522] AGP: No AGP bridge found
[    0.012600] last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.012602] MTRR default type: uncachable
[    0.012602] MTRR fixed ranges enabled:
[    0.012603]   00000-9FFFF write-back
[    0.012604]   A0000-BFFFF uncachable
[    0.012605]   C0000-C7FFF write-protect
[    0.012605]   C8000-FFFFF uncachable
[    0.012606] MTRR variable ranges enabled:
[    0.012607]   0 base 000000000000 mask FFFF80000000 write-back
[    0.012608]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.012609]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.012609]   3 base 0000CFF00000 mask FFFFFFF00000 uncachable
[    0.012610]   4 base 000100000000 mask FFFF00000000 write-back
[    0.012611]   5 base 000200000000 mask FFFFE0000000 write-back
[    0.012611]   6 base 000220000000 mask FFFFF0000000 write-back
[    0.012612]   7 disabled
[    0.012613] TOM2: 0000000230000000 aka 8960M
[    0.013756] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.013868] e820: update [mem 0xcff00000-0xffffffff] usable ==> reserved
[    0.013873] last_pfn = 0xcfee0 max_arch_pfn = 0x400000000
[    0.013884] Using GB pages for direct mapping
[    0.014159] ACPI: Early table checksum verification disabled
[    0.014164] ACPI: RSDP 0x00000000000F73F0 000014 (v00 GBT   )
[    0.014168] ACPI: RSDT 0x00000000CFEE3000 000038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.014173] ACPI: FACP 0x00000000CFEE3040 000074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.014177] ACPI: DSDT 0x00000000CFEE30C0 00677D (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.014180] ACPI: FACS 0x00000000CFEE0000 000040
[    0.014182] ACPI: SSDT 0x00000000CFEE9900 0012F6 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.014185] ACPI: HPET 0x00000000CFEEAC00 000038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.014187] ACPI: MCFG 0x00000000CFEEAC40 00003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.014190] ACPI: APIC 0x00000000CFEE9840 0000BC (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.014197] ACPI: Local APIC address 0xfee00000
[    0.014214] Zone ranges:
[    0.014215]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.014217]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.014218]   Normal   [mem 0x0000000100000000-0x000000022fffffff]
[    0.014219] Movable zone start for each node
[    0.014220] Early memory node ranges
[    0.014221]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.014222]   node   0: [mem 0x0000000000100000-0x00000000cfedffff]
[    0.014223]   node   0: [mem 0x0000000100000000-0x000000022fffffff]
[    0.014231] Zeroed struct page in unavailable ranges: 386 pages
[    0.014232] Initmem setup node 0 [mem 0x0000000000001000-0x000000022fffffff]
[    0.014234] On node 0 totalpages: 2096766
[    0.014235]   DMA zone: 64 pages used for memmap
[    0.014235]   DMA zone: 21 pages reserved
[    0.014236]   DMA zone: 3998 pages, LIFO batch:0
[    0.014275]   DMA32 zone: 13244 pages used for memmap
[    0.014276]   DMA32 zone: 847584 pages, LIFO batch:63
[    0.026312]   Normal zone: 19456 pages used for memmap
[    0.026314]   Normal zone: 1245184 pages, LIFO batch:63
[    0.044686] ACPI: PM-Timer IO Port: 0x3008
[    0.044688] ACPI: Local APIC address 0xfee00000
[    0.044692] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.044693] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.044694] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.044695] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.044696] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
[    0.044697] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
[    0.044698] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.044699] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.044711] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.044713] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.044714] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.044716] ACPI: IRQ0 used by override.
[    0.044717] ACPI: IRQ9 used by override.
[    0.044719] Using ACPI (MADT) for SMP configuration information
[    0.044720] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.044723] smpboot: Allowing 8 CPUs, 2 hotplug CPUs
[    0.044734] [mem 0xcff00000-0xdfffffff] available for PCI devices
[    0.044737] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.048473] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.049112] percpu: Embedded 39 pages/cpu s129304 r0 d30440 u262144
[    0.049116] pcpu-alloc: s129304 r0 d30440 u262144 alloc=1*2097152
[    0.049117] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.049129] Built 1 zonelists, mobility grouping on.  Total pages: 2063981
[    0.049132] Kernel command line: root=/dev/sda ro rootfstype=ext4 tsc_khz=3315112 hugepagesz=2M hugepagesz=1G lapic_timer_c2_ok idle=halt hpet=nolegsup mitigations=off threadirqs rqshare=all BOOT_IMAGE=/boot/bzImage.test 
[    0.051055] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.052003] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
[    0.052025] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.067515] AGP: Checking aperture...
[    0.075809] AGP: No AGP bridge found
[    0.075811] AGP: Node 0: aperture [bus addr 0xc4000000-0xc5ffffff] (32MB)
[    0.075813] Aperture pointing to e820 RAM. Ignoring.
[    0.075814] AGP: Your BIOS doesn't leave an aperture memory hole
[    0.075815] AGP: Please enable the IOMMU option in the BIOS setup
[    0.075815] AGP: This costs you 64MB of RAM
[    0.075817] AGP: Mapping aperture over RAM [mem 0xc4000000-0xc7ffffff] (65536KB)
[    0.110702] Memory: 8079852K/8387064K available (12290K kernel code, 4301K rwdata, 3348K rodata, 884K init, 3232K bss, 306956K reserved, 0K cma-reserved)
[    0.110747] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.110814] rcu: Hierarchical RCU implementation.
[    0.110816] 	Tracing variant of Tasks RCU enabled.
[    0.110817] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[    0.110828] NR_IRQS: 4352, nr_irqs: 488, preallocated irqs: 16
[    0.113298] Console: colour VGA+ 80x25
[    0.120718] printk: console [tty0] enabled
[    0.120800] ACPI: Core revision 20200925
[    0.120950] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.121099] APIC: Switch to symmetric I/O mode setup
[    0.121786] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.171088] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x2fc85ca8eb6, max_idle_ns: 440795217995 ns
[    0.171208] Calibrating delay loop (skipped), value calculated using timer frequency.. 6629.84 BogoMIPS (lpj=33149220)
[    0.171328] pid_max: default: 32768 minimum: 301
[    0.171458] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.171599] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.171857] LVT offset 0 assigned for vector 0xf9
[    0.171937] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.172018] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.172189] Freeing SMP alternatives memory: 32K
[    0.308780] smpboot: CPU0: AMD Phenom(tm) II X6 1100T Processor (family: 0x10, model: 0xa, stepping: 0x0)
[    0.308981] Performance Events: AMD PMU driver.
[    0.309061] ... version:                0
[    0.309137] ... bit width:              48
[    0.309213] ... generic registers:      4
[    0.309288] ... value mask:             0000ffffffffffff
[    0.309368] ... max period:             00007fffffffffff
[    0.309447] ... fixed-purpose events:   0
[    0.309523] ... event mask:             000000000000000f
[    0.309663] rcu: Hierarchical SRCU implementation.
[    0.309764] MCE: In-kernel MCE decoding enabled.
[    0.309902] smp: Bringing up secondary CPUs ...
[    0.310038] x86: Booting SMP configuration:
[    0.310114] .... node  #0, CPUs:      #1
[    0.010104] __common_interrupt: 1.55 No irq handler for vector
[    0.311207]  #2
[    0.010104] __common_interrupt: 2.55 No irq handler for vector
[    0.311207]  #3
[    0.010104] __common_interrupt: 3.55 No irq handler for vector
[    0.311207]  #4
[    0.010104] __common_interrupt: 4.55 No irq handler for vector
[    0.313562]  #5
[    0.010104] __common_interrupt: 5.55 No irq handler for vector
[    0.313830] smp: Brought up 1 node, 6 CPUs
[    0.313830] smpboot: Max logical packages: 2
[    0.313830] smpboot: Total of 6 processors activated (39779.06 BogoMIPS)
[    0.321648] devtmpfs: initialized
[    0.321648] random: get_random_u32 called from bucket_table_alloc.isra.32+0x6f/0x180 with crng_init=0
[    0.321648] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.321648] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[    0.321648] NET: Registered protocol family 16
[    0.321943] thermal_sys: Registered thermal governor 'step_wise'
[    0.321960] cpuidle: using governor ladder
[    0.321960] cpuidle: using governor menu
[    0.321960] node 0 link 0: io port [9000, ffff]
[    0.321960] TOM: 00000000d0000000 aka 3328M
[    0.321960] Fam 10h mmconf [mem 0xe0000000-0xe00fffff]
[    0.321960] node 0 link 0: mmio [a0000, bffff]
[    0.321960] node 0 link 0: mmio [d0000000, dfffffff]
[    0.321960] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.321960] node 0 link 0: mmio [e0000000, e06fffff] ==> [e0100000, e06fffff]
[    0.321960] TOM2: 0000000230000000 aka 8960M
[    0.321960] bus: [bus 00-06] on node 0 link 0
[    0.321960] bus: 00 [io  0x0000-0xffff]
[    0.321960] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.321960] bus: 00 [mem 0xd0000000-0xdfffffff]
[    0.321960] bus: 00 [mem 0xe0700000-0xffffffff]
[    0.321960] bus: 00 [mem 0xe0100000-0xe06fffff]
[    0.321960] bus: 00 [mem 0x230000000-0xfcffffffff]
[    0.321960] ACPI: bus type PCI registered
[    0.321960] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.321960] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.321960] PCI: Using configuration type 1 for base access
[    0.325171] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.325171] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[    0.325516] cryptd: max_cpu_qlen set to 1000
[    0.325516] ACPI: Added _OSI(Module Device)
[    0.325516] ACPI: Added _OSI(Processor Device)
[    0.325516] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.325516] ACPI: Added _OSI(Processor Aggregator Device)
[    0.325516] ACPI: Added _OSI(Linux-Dell-Video)
[    0.325516] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.331226] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.331226] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.331226] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.331336] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.331457] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.331577] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.331698] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.331822] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.331943] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.332064] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.332184] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.332308] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.332429] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.332550] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.332670] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.332794] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.332915] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.333036] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.333157] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.333280] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.333401] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.333521] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.333642] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.333766] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.333887] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.334007] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.334128] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.334251] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.334372] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.334493] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.334614] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.334738] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKA (20200925/dspkginit-440)
[    0.334858] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKB (20200925/dspkginit-440)
[    0.334979] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKC (20200925/dspkginit-440)
[    0.335100] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - LNKD (20200925/dspkginit-440)
[    0.335341] ACPI: Interpreter enabled
[    0.335341] ACPI: (supports S0 S5)
[    0.335341] ACPI: Using IOAPIC for interrupt routing
[    0.341211] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.341211] ACPI: Enabled 6 GPEs in block 00 to 1F
[    0.341535] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.341623] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    0.341788] PCI host bridge to bus 0000:00
[    0.341866] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.341950] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.342035] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.342144] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.342254] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff window]
[    0.342363] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.342453] pci 0000:00:00.0: [1002:5956] type 00 class 0x060000
[    0.342542] pci 0000:00:00.0: [Firmware Bug]: reg 0x1c: invalid BAR (can't size)
[    0.342729] pci 0000:00:02.0: [1002:5978] type 01 class 0x060400
[    0.342823] pci 0000:00:02.0: enabling Extended Tags
[    0.342921] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.343067] pci 0000:00:06.0: [1002:597c] type 01 class 0x060400
[    0.343161] pci 0000:00:06.0: enabling Extended Tags
[    0.343259] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.343395] pci 0000:00:07.0: [1002:597d] type 01 class 0x060400
[    0.343489] pci 0000:00:07.0: enabling Extended Tags
[    0.343585] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.343724] pci 0000:00:09.0: [1002:597e] type 01 class 0x060400
[    0.343818] pci 0000:00:09.0: enabling Extended Tags
[    0.343917] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.344056] pci 0000:00:0a.0: [1002:597f] type 01 class 0x060400
[    0.344149] pci 0000:00:0a.0: enabling Extended Tags
[    0.344245] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.344391] pci 0000:00:12.0: [1002:4380] type 00 class 0x010601
[    0.344487] pci 0000:00:12.0: reg 0x10: [io  0xff00-0xff07]
[    0.344576] pci 0000:00:12.0: reg 0x14: [io  0xfe00-0xfe03]
[    0.344663] pci 0000:00:12.0: reg 0x18: [io  0xfd00-0xfd07]
[    0.344752] pci 0000:00:12.0: reg 0x1c: [io  0xfc00-0xfc03]
[    0.344840] pci 0000:00:12.0: reg 0x20: [io  0xfb00-0xfb0f]
[    0.344928] pci 0000:00:12.0: reg 0x24: [mem 0xfe02f000-0xfe02f3ff]
[    0.345099] pci 0000:00:13.0: [1002:4387] type 00 class 0x0c0310
[    0.345195] pci 0000:00:13.0: reg 0x10: [mem 0xfe02e000-0xfe02efff]
[    0.345383] pci 0000:00:13.1: [1002:4388] type 00 class 0x0c0310
[    0.345479] pci 0000:00:13.1: reg 0x10: [mem 0xfe02d000-0xfe02dfff]
[    0.345674] pci 0000:00:13.2: [1002:4389] type 00 class 0x0c0310
[    0.345771] pci 0000:00:13.2: reg 0x10: [mem 0xfe02c000-0xfe02cfff]
[    0.351221] pci 0000:00:13.3: [1002:438a] type 00 class 0x0c0310
[    0.351232] pci 0000:00:13.3: reg 0x10: [mem 0xfe02b000-0xfe02bfff]
[    0.351233] pci 0000:00:13.4: [1002:438b] type 00 class 0x0c0310
[    0.351242] pci 0000:00:13.4: reg 0x10: [mem 0xfe02a000-0xfe02afff]
[    0.351242] pci 0000:00:13.5: [1002:4386] type 00 class 0x0c0320
[    0.351242] pci 0000:00:13.5: reg 0x10: [mem 0xfe029000-0xfe0290ff]
[    0.351242] pci 0000:00:13.5: supports D1 D2
[    0.351242] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.351242] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.351244] pci 0000:00:14.0: reg 0x10: [io  0x0b00-0x0b0f]
[    0.351244] pci 0000:00:14.1: [1002:438c] type 00 class 0x01018a
[    0.351244] pci 0000:00:14.1: reg 0x10: [io  0x0000-0x0007]
[    0.351244] pci 0000:00:14.1: reg 0x14: [io  0x0000-0x0003]
[    0.351244] pci 0000:00:14.1: reg 0x18: [io  0x0000-0x0007]
[    0.351244] pci 0000:00:14.1: reg 0x1c: [io  0x0000-0x0003]
[    0.351244] pci 0000:00:14.1: reg 0x20: [io  0xf900-0xf90f]
[    0.351244] pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.351244] pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.351244] pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.351244] pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.351244] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.351244] pci 0000:00:14.2: reg 0x10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.351244] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.351245] pci 0000:00:14.3: [1002:438d] type 00 class 0x060100
[    0.351245] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.351247] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.351247] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.351247] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.351247] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.351247] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.351247] pci 0000:01:00.0: [10de:1200] type 00 class 0x030000
[    0.351247] pci 0000:01:00.0: reg 0x10: [mem 0xf8000000-0xf9ffffff]
[    0.351247] pci 0000:01:00.0: reg 0x14: [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.351247] pci 0000:01:00.0: reg 0x1c: [mem 0xdc000000-0xdfffffff 64bit pref]
[    0.351247] pci 0000:01:00.0: reg 0x24: [io  0xbf00-0xbf7f]
[    0.351247] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.351247] pci 0000:01:00.0: enabling Extended Tags
[    0.351247] pci 0000:01:00.1: [10de:0e0c] type 00 class 0x040300
[    0.351247] pci 0000:01:00.1: reg 0x10: [mem 0xfbffc000-0xfbffffff]
[    0.351247] pci 0000:01:00.1: enabling Extended Tags
[    0.351247] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.351247] pci 0000:00:02.0:   bridge window [io  0xb000-0xbfff]
[    0.351247] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.351297] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.351454] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.351550] pci 0000:02:00.0: reg 0x10: [io  0xae00-0xaeff]
[    0.351651] pci 0000:02:00.0: reg 0x18: [mem 0xfdfff000-0xfdffffff 64bit]
[    0.351761] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.351850] pci 0000:02:00.0: enabling Extended Tags
[    0.351996] pci 0000:02:00.0: supports D1 D2
[    0.352073] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.352205] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.352327] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.352407] pci 0000:00:06.0:   bridge window [io  0xa000-0xafff]
[    0.352490] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.352576] pci 0000:00:06.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.352729] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.352825] pci 0000:03:00.0: reg 0x10: [io  0xee00-0xeeff]
[    0.352926] pci 0000:03:00.0: reg 0x18: [mem 0xfddff000-0xfddfffff 64bit]
[    0.353034] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.353123] pci 0000:03:00.0: enabling Extended Tags
[    0.353269] pci 0000:03:00.0: supports D1 D2
[    0.353346] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.353476] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.353598] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.353678] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.353761] pci 0000:00:07.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.353846] pci 0000:00:07.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.354010] pci 0000:04:00.0: [197b:2363] type 00 class 0x010601
[    0.354148] pci 0000:04:00.0: reg 0x24: [mem 0xfdbfe000-0xfdbfffff]
[    0.354279] pci 0000:04:00.0: PME# supported from D3hot
[    0.354414] pci 0000:04:00.1: [197b:2363] type 00 class 0x010185
[    0.354509] pci 0000:04:00.1: reg 0x10: [io  0xdf00-0xdf07]
[    0.361218] pci 0000:04:00.1: reg 0x14: [io  0xde00-0xde03]
[    0.361218] pci 0000:04:00.1: reg 0x18: [io  0xdd00-0xdd07]
[    0.361218] pci 0000:04:00.1: reg 0x1c: [io  0xdc00-0xdc03]
[    0.361218] pci 0000:04:00.1: reg 0x20: [io  0xdb00-0xdb0f]
[    0.361218] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.361243] pci 0000:00:09.0: PCI bridge to [bus 04]
[    0.361243] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.361243] pci 0000:00:09.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.361243] pci 0000:00:09.0:   bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.361244] pci 0000:05:00.0: [197b:2363] type 00 class 0x010601
[    0.361245] pci 0000:05:00.0: reg 0x24: [mem 0xfd9fe000-0xfd9fffff]
[    0.361245] pci 0000:05:00.0: PME# supported from D3hot
[    0.361245] pci 0000:05:00.1: [197b:2363] type 00 class 0x010185
[    0.361245] pci 0000:05:00.1: reg 0x10: [io  0xcf00-0xcf07]
[    0.361245] pci 0000:05:00.1: reg 0x14: [io  0xce00-0xce03]
[    0.361245] pci 0000:05:00.1: reg 0x18: [io  0xcd00-0xcd07]
[    0.361245] pci 0000:05:00.1: reg 0x1c: [io  0xcc00-0xcc03]
[    0.361245] pci 0000:05:00.1: reg 0x20: [io  0xcb00-0xcb0f]
[    0.361245] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.361245] pci 0000:00:0a.0: PCI bridge to [bus 05]
[    0.361245] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
[    0.361245] pci 0000:00:0a.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.361245] pci 0000:00:0a.0:   bridge window [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.361245] pci_bus 0000:06: extended config space not accessible
[    0.361246] pci 0000:06:06.0: [1412:1724] type 00 class 0x040100
[    0.361249] pci 0000:06:06.0: reg 0x10: [io  0x9f00-0x9f1f]
[    0.361249] pci 0000:06:06.0: reg 0x14: [io  0x9e00-0x9e7f]
[    0.361249] pci 0000:06:06.0: supports D2
[    0.361250] pci 0000:06:07.0: [1412:1724] type 00 class 0x040100
[    0.361250] pci 0000:06:07.0: reg 0x10: [io  0x9d00-0x9d1f]
[    0.361250] pci 0000:06:07.0: reg 0x14: [io  0x9c00-0x9c7f]
[    0.361250] pci 0000:06:07.0: supports D2
[    0.361250] pci 0000:06:0e.0: [104c:8024] type 00 class 0x0c0010
[    0.361250] pci 0000:06:0e.0: reg 0x10: [mem 0xfd7ff000-0xfd7ff7ff]
[    0.361250] pci 0000:06:0e.0: reg 0x14: [mem 0xfd7f8000-0xfd7fbfff]
[    0.361250] pci 0000:06:0e.0: supports D1 D2
[    0.361250] pci 0000:06:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.361250] pci 0000:00:14.4: PCI bridge to [bus 06] (subtractive decode)
[    0.361250] pci 0000:00:14.4:   bridge window [io  0x9000-0x9fff]
[    0.361250] pci 0000:00:14.4:   bridge window [mem 0xfd700000-0xfd7fffff]
[    0.361250] pci 0000:00:14.4:   bridge window [mem 0xfd600000-0xfd6fffff pref]
[    0.361250] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    0.361250] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window] (subtractive decode)
[    0.361250] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    0.361250] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff window] (subtractive decode)
[    0.361250] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xfebfffff window] (subtractive decode)
[    0.361250] pci_bus 0000:00: on NUMA node 0
[    0.361250] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361250] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361250] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361377] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361516] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361656] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361795] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.361935] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.362541] iommu: Default domain type: Translated 
[    0.362641] pci 0000:01:00.0: vgaarb: setting as boot VGA device
[    0.362641] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.362641] pci 0000:01:00.0: vgaarb: bridge control possible
[    0.362641] vgaarb: loaded
[    0.362641] SCSI subsystem initialized
[    0.362641] libata version 3.00 loaded.
[    0.362641] ACPI: bus type USB registered
[    0.362641] usbcore: registered new interface driver usbfs
[    0.362641] usbcore: registered new interface driver hub
[    0.362641] usbcore: registered new device driver usb
[    0.362641] videodev: Linux video capture interface: v2.00
[    0.362641] pps_core: LinuxPPS API ver. 1 registered
[    0.362641] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.362641] EDAC MC: Ver: 3.0.0
[    0.362641] Advanced Linux Sound Architecture Driver Initialized.
[    0.362641] PCI: Using ACPI for IRQ routing
[    0.372727] PCI: pci_cache_line_size set to 64 bytes
[    0.372793] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.372794] e820: reserve RAM buffer [mem 0xcfee0000-0xcfffffff]
[    0.372800] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.372800] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.373705] clocksource: Switched to clocksource tsc-early
[    0.373705] pnp: PnP ACPI init
[    0.373705] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.373705] system 00:00: [io  0x0220-0x0225] has been reserved
[    0.373705] system 00:00: [io  0x0290-0x0294] has been reserved
[    0.373705] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.373705] pnp 00:01: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0007ffff pref]
[    0.373705] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.373705] pnp 00:01: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.373705] system 00:01: [io  0x3100-0x311f] has been reserved
[    0.373705] system 00:01: [io  0x0228-0x022f] has been reserved
[    0.373705] system 00:01: [io  0x040b] has been reserved
[    0.373705] system 00:01: [io  0x04d6] has been reserved
[    0.373705] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.373705] system 00:01: [io  0x0c14] has been reserved
[    0.373705] system 00:01: [io  0x0c50-0x0c52] has been reserved
[    0.373705] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
[    0.373705] system 00:01: [io  0x0c6f] has been reserved
[    0.373705] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.373705] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.373705] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
[    0.373705] system 00:01: [io  0x3000-0x30fe] has been reserved
[    0.373705] system 00:01: [io  0x3210-0x3217] has been reserved
[    0.373705] system 00:01: [io  0x0b10-0x0b1f] has been reserved
[    0.373705] system 00:01: [io  0x0238-0x023f] has been reserved
[    0.373705] system 00:01: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.373742] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.373845] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.374072] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.374221] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.374316] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.374359] system 00:06: [mem 0xe0000000-0xefffffff] has been reserved
[    0.374447] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.374564] system 00:07: [mem 0x000d6000-0x000d7fff] has been reserved
[    0.374658] system 00:07: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.374743] system 00:07: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.374828] system 00:07: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.374913] system 00:07: [mem 0xcfee0000-0xcfeeffff] could not be reserved
[    0.374998] system 00:07: [mem 0xffff0000-0xffffffff] has been reserved
[    0.375082] system 00:07: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.375167] system 00:07: [mem 0x00100000-0xcfedffff] could not be reserved
[    0.375253] system 00:07: [mem 0xcfef0000-0xcfefffff] has been reserved
[    0.375337] system 00:07: [mem 0xcff00000-0xcfffffff] could not be reserved
[    0.375422] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.375507] system 00:07: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.375592] system 00:07: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.375683] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.375698] pnp: PnP ACPI: found 8 devices
[    0.381848] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.381992] NET: Registered protocol family 2
[    0.382158] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 65536 bytes, linear)
[    0.382290] TCP established hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    0.382532] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes, linear)
[    0.384456] TCP: Hash tables configured (established 65536 bind 65536)
[    0.384590] UDP hash table entries: 4096 (order: 5, 131072 bytes, linear)
[    0.384713] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes, linear)
[    0.384897] NET: Registered protocol family 1
[    0.384994] pci 0000:01:00.0: BAR 6: assigned [mem 0xfa000000-0xfa07ffff pref]
[    0.385104] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.385184] pci 0000:00:02.0:   bridge window [io  0xb000-0xbfff]
[    0.385267] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.385352] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.385464] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdf00000-0xfdf1ffff pref]
[    0.385573] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.385652] pci 0000:00:06.0:   bridge window [io  0xa000-0xafff]
[    0.385735] pci 0000:00:06.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.385819] pci 0000:00:06.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.385931] pci 0000:03:00.0: BAR 6: assigned [mem 0xfdd00000-0xfdd1ffff pref]
[    0.386040] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.386119] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.386202] pci 0000:00:07.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.386286] pci 0000:00:07.0:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.386398] pci 0000:00:09.0: PCI bridge to [bus 04]
[    0.386477] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.386560] pci 0000:00:09.0:   bridge window [mem 0xfdb00000-0xfdbfffff]
[    0.386645] pci 0000:00:09.0:   bridge window [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.386756] pci 0000:00:0a.0: PCI bridge to [bus 05]
[    0.386835] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
[    0.386918] pci 0000:00:0a.0:   bridge window [mem 0xfd900000-0xfd9fffff]
[    0.387003] pci 0000:00:0a.0:   bridge window [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.387115] pci 0000:00:14.4: PCI bridge to [bus 06]
[    0.387195] pci 0000:00:14.4:   bridge window [io  0x9000-0x9fff]
[    0.387280] pci 0000:00:14.4:   bridge window [mem 0xfd700000-0xfd7fffff]
[    0.387366] pci 0000:00:14.4:   bridge window [mem 0xfd600000-0xfd6fffff pref]
[    0.387480] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.387563] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.387646] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.387730] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff window]
[    0.387815] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xfebfffff window]
[    0.387900] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.387981] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.388063] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.388172] pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
[    0.388252] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.388335] pci_bus 0000:02: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.388444] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.388524] pci_bus 0000:03: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.388610] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.388718] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.388799] pci_bus 0000:04: resource 1 [mem 0xfdb00000-0xfdbfffff]
[    0.388882] pci_bus 0000:04: resource 2 [mem 0xfda00000-0xfdafffff 64bit pref]
[    0.388990] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.389071] pci_bus 0000:05: resource 1 [mem 0xfd900000-0xfd9fffff]
[    0.389154] pci_bus 0000:05: resource 2 [mem 0xfd800000-0xfd8fffff 64bit pref]
[    0.389262] pci_bus 0000:06: resource 0 [io  0x9000-0x9fff]
[    0.389343] pci_bus 0000:06: resource 1 [mem 0xfd700000-0xfd7fffff]
[    0.389425] pci_bus 0000:06: resource 2 [mem 0xfd600000-0xfd6fffff pref]
[    0.389510] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7 window]
[    0.389592] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff window]
[    0.389675] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.389760] pci_bus 0000:06: resource 7 [mem 0x000c0000-0x000dffff window]
[    0.389844] pci_bus 0000:06: resource 8 [mem 0xd0000000-0xfebfffff window]
[    0.431862] pci 0000:00:13.0: quirk_usb_early_handoff+0x0/0x670 took 40908 usecs
[    0.471836] pci 0000:00:13.1: quirk_usb_early_handoff+0x0/0x670 took 38919 usecs
[    0.511833] pci 0000:00:13.2: quirk_usb_early_handoff+0x0/0x670 took 38945 usecs
[    0.551832] pci 0000:00:13.3: quirk_usb_early_handoff+0x0/0x670 took 38946 usecs
[    0.591832] pci 0000:00:13.4: quirk_usb_early_handoff+0x0/0x670 took 38948 usecs
[    0.592084] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.592227] pci 0000:01:00.1: D0 power state depends on 0000:01:00.0
[    0.592318] pci 0000:04:00.0: async suspend disabled to avoid multi-function power-on ordering issue
[    0.592435] pci 0000:04:00.1: async suspend disabled to avoid multi-function power-on ordering issue
[    0.592551] pci 0000:05:00.0: async suspend disabled to avoid multi-function power-on ordering issue
[    0.592668] pci 0000:05:00.1: async suspend disabled to avoid multi-function power-on ordering issue
[    0.592791] PCI: CLS 64 bytes, default 64
[    0.593100] PCI-DMA: Disabling AGP.
[    0.593435] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.593516] PCI-DMA: using GART IOMMU.
[    0.593592] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.595537] LVT offset 1 assigned for vector 0x400
[    0.595627] LVT offset 1 assigned
[    0.595862] perf: AMD IBS detected (0x0000001f)
[    0.596030] kvm: Nested Virtualization enabled
[    0.596110] SVM: kvm: Nested Paging enabled
[    0.597351] workingset: timestamp_bits=62 max_order=21 bucket_order=0
[    0.598405] fuse: init (API version 7.31)
[    0.598681] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.598792] io scheduler mq-deadline registered
[    0.598869] io scheduler kyber registered
[    0.599679] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.599794] ACPI: Power Button [PWRB]
[    0.599910] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.600019] ACPI: Power Button [PWRF]
[    0.600353] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.600510] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.601015] Linux agpgart interface v0.103
[    0.601189] nouveau 0000:01:00.0: vgaarb: deactivate vga console
[    0.602612] Console: switching to colour dummy device 80x25
[    0.602643] nouveau 0000:01:00.0: NVIDIA GF114 (0ce000a1)
[    0.743140] nouveau 0000:01:00.0: bios: version 70.24.11.00.00
[    0.765720] nouveau 0000:01:00.0: fb: 1024 MiB GDDR5
[    0.819608] [TTM] Zone  kernel: Available graphics memory: 4073030 KiB
[    0.819611] [TTM] Zone   dma32: Available graphics memory: 2097152 KiB
[    0.819613] [TTM] Initializing pool allocator
[    0.819618] [TTM] Initializing DMA pool allocator
[    0.819629] nouveau 0000:01:00.0: DRM: VRAM: 1024 MiB
[    0.819631] nouveau 0000:01:00.0: DRM: GART: 1048576 MiB
[    0.819635] nouveau 0000:01:00.0: DRM: TMDS table version 2.0
[    0.819637] nouveau 0000:01:00.0: DRM: DCB version 4.0
[    0.819640] nouveau 0000:01:00.0: DRM: DCB outp 00: 02000300 00000000
[    0.819643] nouveau 0000:01:00.0: DRM: DCB outp 01: 01000302 00020030
[    0.819645] nouveau 0000:01:00.0: DRM: DCB outp 02: 04011380 00000000
[    0.819647] nouveau 0000:01:00.0: DRM: DCB outp 03: 08011382 00020030
[    0.819649] nouveau 0000:01:00.0: DRM: DCB outp 04: 02022362 00020010
[    0.819652] nouveau 0000:01:00.0: DRM: DCB conn 00: 00001030
[    0.819654] nouveau 0000:01:00.0: DRM: DCB conn 01: 00010130
[    0.819656] nouveau 0000:01:00.0: DRM: DCB conn 02: 00002261
[    0.820411] nouveau 0000:01:00.0: DRM: MM: using COPY0 for buffer copies
[    0.942910] nouveau 0000:01:00.0: DRM: allocated 1280x3072 fb: 0x60000, bo (____ptrval____)
[    0.942997] fbcon: nouveaudrmfb (fb0) is primary device
[    1.075590] Console: switching to colour frame buffer device 160x64
[    1.082158] nouveau 0000:01:00.0: [drm] fb0: nouveaudrmfb frame buffer device
[    1.082407] [drm] Initialized nouveau 1.3.1 20120801 for 0000:01:00.0 on minor 0
[    1.083880] brd: module loaded
[    1.085511] loop: module loaded
[    1.088979] ahci 0000:00:12.0: version 3.0
[    1.089110] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    1.089250] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.089260] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.089749] scsi host0: ahci
[    1.089885] scsi host1: ahci
[    1.089988] scsi host2: ahci
[    1.090085] scsi host3: ahci
[    1.090128] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    1.090135] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    1.090142] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    1.090149] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    1.108644] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    1.108654] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    1.108987] scsi host4: ahci
[    1.109105] scsi host5: ahci
[    1.109153] ata5: SATA max UDMA/133 abar m8192@0xfdbfe000 port 0xfdbfe100 irq 17
[    1.109160] ata6: SATA max UDMA/133 abar m8192@0xfdbfe000 port 0xfdbfe180 irq 17
[    1.121475] ahci 0000:05:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    1.121484] ahci 0000:05:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    1.121824] scsi host6: ahci
[    1.121941] scsi host7: ahci
[    1.121987] ata7: SATA max UDMA/133 abar m8192@0xfd9fe000 port 0xfd9fe100 irq 18
[    1.121993] ata8: SATA max UDMA/133 abar m8192@0xfd9fe000 port 0xfd9fe180 irq 18
[    1.122382] scsi host8: pata_atiixp
[    1.122488] scsi host9: pata_atiixp
[    1.122523] ata9: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf900 irq 14
[    1.122528] ata10: DUMMY
[    1.122574] pata_jmicron 0000:04:00.1: enabling device (0000 -> 0001)
[    1.122882] scsi host10: pata_jmicron
[    1.122975] scsi host11: pata_jmicron
[    1.123010] ata11: PATA max UDMA/100 cmd 0xdf00 ctl 0xde00 bmdma 0xdb00 irq 18
[    1.123015] ata12: PATA max UDMA/100 cmd 0xdd00 ctl 0xdc00 bmdma 0xdb08 irq 18
[    1.123040] pata_jmicron 0000:05:00.1: enabling device (0000 -> 0001)
[    1.123331] scsi host12: pata_jmicron
[    1.123641] scsi host13: pata_jmicron
[    1.124771] ata13: PATA max UDMA/100 cmd 0xcf00 ctl 0xce00 bmdma 0xcb00 irq 19
[    1.126595] ata14: PATA max UDMA/100 cmd 0xcd00 ctl 0xcc00 bmdma 0xcb08 irq 19
[    1.128611] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
[    1.130432] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
[    1.132445] tun: Universal TUN/TAP device driver, 1.6
[    1.134456] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    1.168662] libphy: r8169: probed
[    1.188751] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
[    1.188925] r8169 0000:02:00.0 eth0: jumbo features [frames: 4074 bytes, tx checksumming: ko]
[    1.190550] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    1.193231] libphy: r8169: probed
[    1.195042] r8169 0000:03:00.0 eth1: RTL8168b/8111b, 00:1a:4d:5d:6b:e3, XID 380, IRQ 19
[    1.196741] r8169 0000:03:00.0 eth1: jumbo features [frames: 4074 bytes, tx checksumming: ko]
[    1.198964] PPP generic driver version 2.4.2
[    1.201167] PPP BSD Compression module registered
[    1.203274] PPP Deflate Compression module registered
[    1.205517] PPP MPPE Compression module registered
[    1.207718] NET: Registered protocol family 24
[    1.209928] Fusion MPT base driver 3.04.20
[    1.212221] Copyright (c) 1999-2008 LSI Corporation
[    1.214450] Fusion MPT SAS Host driver 3.04.20
[    1.216725] Fusion MPT misc device (ioctl) driver 3.04.20
[    1.218919] mptctl: Registered with Fusion MPT base driver
[    1.221109] mptctl: /dev/mptctl @ (major,minor=10,220)
[    1.293090] firewire_ohci 0000:06:0e.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    1.293575] aoe: AoE v85 initialised.
[    1.295325] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.297597] ehci-pci: EHCI PCI platform driver
[    1.299928] ehci-pci 0000:00:13.5: EHCI Host Controller
[    1.302063] ehci-pci 0000:00:13.5: new USB bus registered, assigned bus number 1
[    1.304339] ehci-pci 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    1.306659] ehci-pci 0000:00:13.5: debug port 1
[    1.308796] ehci-pci 0000:00:13.5: irq 19, io mem 0xfe029000
[    1.331254] ehci-pci 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    1.331482] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.09
[    1.333588] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.335858] usb usb1: Product: EHCI Host Controller
[    1.338141] usb usb1: Manufacturer: Linux 5.9.0-10641-g424a646e072a ehci_hcd
[    1.340493] usb usb1: SerialNumber: 0000:00:13.5
[    1.342906] hub 1-0:1.0: USB hub found
[    1.345084] hub 1-0:1.0: 10 ports detected
[    1.347501] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.349620] ohci-pci: OHCI PCI platform driver
[    1.351966] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    1.354175] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 2
[    1.356513] ohci-pci 0000:00:13.0: irq 16, io mem 0xfe02e000
[    1.425319] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.09
[    1.425494] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.427704] usb usb2: Product: OHCI PCI host controller
[    1.429910] usb usb2: Manufacturer: Linux 5.9.0-10641-g424a646e072a ohci_hcd
[    1.432226] usb usb2: SerialNumber: 0000:00:13.0
[    1.432719] ata5: SATA link down (SStatus 0 SControl 300)
[    1.434497] hub 2-0:1.0: USB hub found
[    1.436681] ata6: SATA link down (SStatus 0 SControl 300)
[    1.438823] hub 2-0:1.0: 2 ports detected
[    1.443473] ohci-pci 0000:00:13.1: OHCI PCI host controller
[    1.445530] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus number 3
[    1.447859] ohci-pci 0000:00:13.1: irq 17, io mem 0xfe02d000
[    1.515306] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.09
[    1.515477] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.517803] usb usb3: Product: OHCI PCI host controller
[    1.520039] usb usb3: Manufacturer: Linux 5.9.0-10641-g424a646e072a ohci_hcd
[    1.522393] usb usb3: SerialNumber: 0000:00:13.1
[    1.524737] hub 3-0:1.0: USB hub found
[    1.526886] hub 3-0:1.0: 2 ports detected
[    1.529313] ohci-pci 0000:00:13.2: OHCI PCI host controller
[    1.531380] ohci-pci 0000:00:13.2: new USB bus registered, assigned bus number 4
[    1.533649] ohci-pci 0000:00:13.2: irq 18, io mem 0xfe02c000
[    1.571253] ata2: softreset failed (device not ready)
[    1.571444] ata2: applying PMP SRST workaround and retrying
[    1.573455] ata4: softreset failed (device not ready)
[    1.575551] ata4: applying PMP SRST workaround and retrying
[    1.591257] ata1: softreset failed (device not ready)
[    1.591442] ata1: applying PMP SRST workaround and retrying
[    1.593299] ata3: softreset failed (device not ready)
[    1.595330] ata3: applying PMP SRST workaround and retrying
[    1.605304] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.09
[    1.605467] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.607295] usb usb4: Product: OHCI PCI host controller
[    1.609499] usb usb4: Manufacturer: Linux 5.9.0-10641-g424a646e072a ohci_hcd
[    1.611256] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.611625] usb usb4: SerialNumber: 0000:00:13.2
[    1.613873] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.616055] hub 4-0:1.0: USB hub found
[    1.618223] ata8.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.19, max UDMA/66
[    1.620360] hub 4-0:1.0: 2 ports detected
[    1.622770] ata7.00: ATA-9: WDC WD30EFRX-68AX9N0, 80.00A80, max UDMA/133
[    1.624950] ohci-pci 0000:00:13.3: OHCI PCI host controller
[    1.627013] ata7.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    1.627026] ata8.00: configured for UDMA/66 (SET_XFERMODE skipped)
[    1.629175] ohci-pci 0000:00:13.3: new USB bus registered, assigned bus number 5
[    1.631943] ata7.00: configured for UDMA/133
[    1.633563] tsc: Refined TSC clocksource calibration: 3315.095 MHz
[    1.633591] ohci-pci 0000:00:13.3: irq 17, io mem 0xfe02b000
[    1.642429] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2fc8fffde36, max_idle_ns: 440795210942 ns
[    1.644775] clocksource: Switched to clocksource tsc
[    1.705307] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.09
[    1.705480] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.707806] usb usb5: Product: OHCI PCI host controller
[    1.710117] usb usb5: Manufacturer: Linux 5.9.0-10641-g424a646e072a ohci_hcd
[    1.712454] usb usb5: SerialNumber: 0000:00:13.3
[    1.714870] hub 5-0:1.0: USB hub found
[    1.717034] hub 5-0:1.0: 2 ports detected
[    1.719522] ohci-pci 0000:00:13.4: OHCI PCI host controller
[    1.721622] ohci-pci 0000:00:13.4: new USB bus registered, assigned bus number 6
[    1.724026] ohci-pci 0000:00:13.4: irq 18, io mem 0xfe02a000
[    1.741275] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.741487] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.743870] ata4.00: ATA-9: WDC WD30EFRX-68AX9N0, 80.00A80, max UDMA/133
[    1.746020] ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    1.748343] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.750776] ata2.00: ATA-9: WDC WD30EFRX-68AX9N0, 80.00A80, max UDMA/133
[    1.752923] ata2.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    1.755219] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.757627] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.759768] ata4.00: configured for UDMA/133
[    1.762046] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.764311] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.766467] ata2.00: configured for UDMA/133
[    1.769142] ata1.00: ATA-9: INTEL SSDSC2CW240A3, 400i, max UDMA/133
[    1.770968] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    1.773277] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.775492] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.778303] ata3.00: ATA-9: WDC WD30EFRX-68AX9N0, 80.00A80, max UDMA/133
[    1.779957] ata3.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 32), AA
[    1.782249] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.785075] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.786680] ata3.00: configured for UDMA/133
[    1.788940] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.791153] ata1.00: configured for UDMA/133
[    1.793452] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW24 400i PQ: 0 ANSI: 5
[    1.795325] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.09
[    1.795841] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.795890] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)
[    1.795897] sd 0:0:0:0: [sda] Write Protect is off
[    1.795898] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.795906] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.797913] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.800387] scsi 1:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68A 0A80 PQ: 0 ANSI: 5
[    1.802539] usb usb6: Product: OHCI PCI host controller
[    1.802541] usb usb6: Manufacturer: Linux 5.9.0-10641-g424a646e072a ohci_hcd
[    1.804986] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.805026] sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.73 TiB)
[    1.805028] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.805034] sd 1:0:0:0: [sdb] Write Protect is off
[    1.805035] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.805044] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.807183] usb usb6: SerialNumber: 0000:00:13.4
[    1.807320] hub 6-0:1.0: USB hub found
[    1.809729] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68A 0A80 PQ: 0 ANSI: 5
[    1.811972] hub 6-0:1.0: 2 ports detected
[    1.812125] net firewire0: IP over IEEE 1394 on card 0000:06:0e.0
[    1.812153] firewire_core 0000:06:0e.0: created device fw0: GUID 00cd667300001a4d, S400
[    1.812171] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.814457] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.814482] sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.73 TiB)
[    1.814484] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    1.814489] sd 2:0:0:0: [sdc] Write Protect is off
[    1.814490] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.814502] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.816729] uhci_hcd: USB Universal Host Controller Interface driver
[    1.819124] scsi 3:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68A 0A80 PQ: 0 ANSI: 5
[    1.819212] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.821327] usbcore: registered new interface driver cdc_acm
[    1.823769] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.823803] sd 3:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.73 TiB)
[    1.823805] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    1.823810] sd 3:0:0:0: [sdd] Write Protect is off
[    1.823811] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.823819] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.825902] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    1.825915] usbcore: registered new interface driver usblp
[    1.828420] scsi 6:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68A 0A80 PQ: 0 ANSI: 5
[    1.830535] usbcore: registered new interface driver cdc_wdm
[    1.832977] sd 6:0:0:0: Attached scsi generic sg4 type 0
[    1.833008] sd 6:0:0:0: [sde] 5860533168 512-byte logical blocks: (3.00 TB/2.73 TiB)
[    1.833009] sd 6:0:0:0: [sde] 4096-byte physical blocks
[    1.833015] sd 6:0:0:0: [sde] Write Protect is off
[    1.833016] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.833024] sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.835171] usbcore: registered new interface driver usb-storage
[    1.843413] scsi 7:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.19 PQ: 0 ANSI: 5
[    1.844433] usbcore: registered new interface driver usbserial_generic
[    1.855319] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.855917] usbserial: USB Serial support registered for generic
[    1.908918] usbcore: registered new interface driver ftdi_sio
[    1.911345] usbserial: USB Serial support registered for FTDI USB Serial Device
[    1.913758] usbcore: registered new interface driver option
[    1.916197] usbserial: USB Serial support registered for GSM modem (1-port)
[    1.918589] usbcore: registered new interface driver pl2303
[    1.920994] usbserial: USB Serial support registered for pl2303
[    1.923405] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.925821] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.928497] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.930873] mousedev: PS/2 mouse device common for all mice
[    1.933405] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    1.935082] sd 6:0:0:0: [sde] Attached SCSI disk
[    1.935800] rtc_cmos 00:02: RTC can wake from S4
[    1.938215] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.940920] rtc_cmos 00:02: registered as rtc0
[    1.945603] rtc_cmos 00:02: setting system clock to 2020-10-28T11:05:18 UTC (1603883118)
[    1.948031] rtc_cmos 00:02: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.950467] i2c /dev entries driver
[    1.953212] ACPI Warning: SystemIO range 0x0000000000000B00-0x0000000000000B08 conflicts with OpRegion 0x0000000000000B00-0x0000000000000B0F (\SOR1) (20200925/utaddress-213)
[    1.958019] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.960717] usbcore: registered new interface driver uvcvideo
[    1.963279] USB Video Class driver (1.1.1)
[    1.965841] gspca_main: v2.14.0 registered
[    1.968389] it87: Found IT8718F chip at 0x228, revision 4
[    1.970928] it87: Beeping is supported
[    1.973736] it87_wdt: Chip IT8718 revision 4 initialized. timeout=60 sec (nowayout=0 testmode=0)
[    1.976067] EDAC amd64: F10h detected (node 0).
[    1.976359] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.981279] EDAC amd64: Node 0: DRAM ECC enabled.
[    1.981280] EDAC amd64: MCT channel count: 2
[    1.981374] EDAC MC0: Giving out device to module amd64_edac controller F10h: DEV 0000:00:18.3 (INTERRUPT)
[    1.989110] EDAC MC: DCT0 chip selects:
[    1.989111] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[    1.991821] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[    1.994389] EDAC amd64: MC: 4:     0MB 5:     0MB
[    1.996952] EDAC amd64: MC: 6:     0MB 7:     0MB
[    1.999476] EDAC MC: DCT1 chip selects:
[    1.999477] EDAC amd64: MC: 0:  1024MB 1:  1024MB
[    2.002027] EDAC amd64: MC: 2:  1024MB 3:  1024MB
[    2.004522] EDAC amd64: MC: 4:     0MB 5:     0MB
[    2.007038] EDAC amd64: MC: 6:     0MB 7:     0MB
[    2.009472] EDAC amd64: using x4 syndromes.
[    2.011913] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
[    2.014440] AMD64 EDAC driver v3.5.0
[    2.017160] usbcore: registered new interface driver usbhid
[    2.019391] usbhid: USB HID core driver
[    2.022193] snd_hda_intel 0000:00:14.2: position_fix set to 1 for device 1458:a022
[    2.024417] snd_hda_intel 0000:01:00.1: Disabling MSI
[    2.033442] random: fast init done
[    2.034634] snd_hda_codec_generic hdaudioC1D0: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    2.035255] snd_hda_codec_generic hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.037793] snd_hda_codec_generic hdaudioC1D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.040327] snd_hda_codec_generic hdaudioC1D0:    mono: mono_out=0x0
[    2.042778] snd_hda_codec_generic hdaudioC1D0:    dig-out=0x5/0x0
[    2.045227] snd_hda_codec_generic hdaudioC1D0:    inputs:
[    2.048655] snd_hda_codec_generic hdaudioC1D1: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    2.050118] snd_hda_codec_generic hdaudioC1D1:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.052605] snd_hda_codec_generic hdaudioC1D1:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.055105] snd_hda_codec_generic hdaudioC1D1:    mono: mono_out=0x0
[    2.057523] snd_hda_codec_generic hdaudioC1D1:    dig-out=0x5/0x0
[    2.059921] snd_hda_codec_generic hdaudioC1D1:    inputs:
[    2.062886] snd_hda_codec_realtek hdaudioC0D3: autoconfig for ALC889A: line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[    2.064711] snd_hda_codec_realtek hdaudioC0D3:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.067125] snd_hda_codec_realtek hdaudioC0D3:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    2.069541] snd_hda_codec_realtek hdaudioC0D3:    mono: mono_out=0x0
[    2.071912] snd_hda_codec_realtek hdaudioC0D3:    dig-out=0x1e/0x0
[    2.074238] snd_hda_codec_realtek hdaudioC0D3:    inputs:
[    2.076521] snd_hda_codec_realtek hdaudioC0D3:      Rear Mic=0x18
[    2.078806] snd_hda_codec_realtek hdaudioC0D3:      Front Mic=0x19
[    2.081020] snd_hda_codec_realtek hdaudioC0D3:      Line=0x1a
[    2.083280] snd_hda_codec_realtek hdaudioC0D3:      CD=0x1c
[    2.085450] snd_hda_codec_realtek hdaudioC0D3:    dig-in=0x1f
[    2.087916] snd_hda_codec_generic hdaudioC1D2: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    2.089796] snd_hda_codec_generic hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.092005] snd_hda_codec_generic hdaudioC1D2:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.094151] snd_hda_codec_generic hdaudioC1D2:    mono: mono_out=0x0
[    2.096296] snd_hda_codec_generic hdaudioC1D2:    dig-out=0x5/0x0
[    2.098406] snd_hda_codec_generic hdaudioC1D2:    inputs:
[    2.101609] snd_hda_codec_generic hdaudioC1D3: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    2.102695] snd_hda_codec_generic hdaudioC1D3:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.104390] snd_ice1724 0000:06:06.0: juli@: analog I/O detected
[    2.104899] snd_hda_codec_generic hdaudioC1D3:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.109209] snd_hda_codec_generic hdaudioC1D3:    mono: mono_out=0x0
[    2.111189] snd_hda_codec_generic hdaudioC1D3:    dig-out=0x5/0x0
[    2.113150] snd_hda_codec_generic hdaudioC1D3:    inputs:
[    2.116167] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input4
[    2.117029] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input5
[    2.118969] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input6
[    2.120929] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input7
[    2.128330] sr 7:0:0:0: [sr0] scsi3-mmc drive: 12x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.128519] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.138664] input: HDA ATI SB Rear Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    2.138884] input: HDA ATI SB Front Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    2.140325] input: HDA ATI SB Line as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[    2.142300] input: HDA ATI SB Line Out Front as /devices/pci0000:00/0000:00:14.2/sound/card0/input11
[    2.144298] input: HDA ATI SB Line Out Surround as /devices/pci0000:00/0000:00:14.2/sound/card0/input12
[    2.146286] input: HDA ATI SB Line Out CLFE as /devices/pci0000:00/0000:00:14.2/sound/card0/input13
[    2.148174] input: HDA ATI SB Line Out Side as /devices/pci0000:00/0000:00:14.2/sound/card0/input14
[    2.171253] usb 2-1: new full-speed USB device number 2 using ohci-pci
[    2.204330] snd_ice1724 0000:06:07.0: juli@: analog I/O detected
[    2.220433] usbcore: registered new interface driver snd-usb-audio
[    2.220645] pktgen: Packet Generator for packet performance testing. Version: 2.75
[    2.222428] sr 7:0:0:0: Attached scsi CD-ROM sr0
[    2.222491] sr 7:0:0:0: Attached scsi generic sg5 type 5
[    2.222725] xt_time: kernel timezone is -0000
[    2.226486] NET: Registered protocol family 10
[    2.228748] Segment Routing with IPv6
[    2.230511] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    2.232638] NET: Registered protocol family 17
[    2.234507] Bridge firewalling registered
[    2.236507] 8021q: 802.1Q VLAN Support v1.8
[    2.238883] microcode: CPU0: patch_level=0x010000bf
[    2.239937] microcode: CPU1: patch_level=0x010000bf
[    2.240929] microcode: CPU2: patch_level=0x010000bf
[    2.241969] microcode: CPU3: patch_level=0x010000bf
[    2.242962] microcode: CPU4: patch_level=0x010000bf
[    2.243887] microcode: CPU5: patch_level=0x010000bf
[    2.244086] microcode: Microcode Update Driver: v2.2.
[    2.244088] IPI shorthand broadcast: enabled
[    2.247135] sched_clock: Marking stable (2243968267, 104874)->(2291004700, -46931559)
[    2.249074] registered taskstats version 1
[    2.251013] printk: console [netcon0] enabled
[    2.252753] netconsole: network logging started
[    2.254738] acpi_cpufreq: overriding BIOS provided _PSD data
[    2.256672] ALSA device list:
[    2.258352]   #0: HDA ATI SB at 0xfe024000 irq 16
[    2.260232]   #1: HDA NVidia at 0xfbffc000 irq 19
[    2.262072]   #2: ESI Juli@ at 0x9f00, irq 20
[    2.263935]   #3: ESI Juli@ at 0x9d00, irq 21
[    2.448300] usb 2-1: New USB device found, idVendor=046d, idProduct=c531, bcdDevice=21.00
[    2.448459] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.449863] usb 2-1: Product: USB Receiver
[    2.451850] usb 2-1: Manufacturer: Logitech
[    2.460542] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:13.0/usb2/2-1/2-1:1.0/0003:046D:C531.0001/input/input15
[    2.460793] hid-generic 0003:046D:C531.0001: input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:13.0-1/input0
[    2.466763] input: Logitech USB Receiver Keyboard as /devices/pci0000:00/0000:00:13.0/usb2/2-1/2-1:1.1/0003:046D:C531.0002/input/input16
[    2.531317] input: Logitech USB Receiver Consumer Control as /devices/pci0000:00/0000:00:13.0/usb2/2-1/2-1:1.1/0003:046D:C531.0002/input/input17
[    2.531524] input: Logitech USB Receiver System Control as /devices/pci0000:00/0000:00:13.0/usb2/2-1/2-1:1.1/0003:046D:C531.0002/input/input18
[    2.533563] hid-generic 0003:046D:C531.0002: input: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:13.0-1/input1
[    2.586104] EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
[    2.586273] VFS: Mounted root (ext4 filesystem) readonly on device 8:0.
[    2.589055] devtmpfs: mounted
[    2.591360] Freeing unused kernel image (initmem) memory: 884K
[    2.631231] Write protecting the kernel read-only data: 18432k
[    2.632116] Freeing unused kernel image (text/rodata gap) memory: 2044K
[    2.633974] Freeing unused kernel image (rodata/data gap) memory: 748K
[    2.636009] rodata_test: all tests were successful
[    2.638371] Run /sbin/init as init process
[    2.640742]   with arguments:
[    2.640743]     /sbin/init
[    2.640743]   with environment:
[    2.640743]     HOME=/
[    2.640744]     TERM=linux
[    2.640744]     tsc_khz=3315112
[    2.640744]     rqshare=all
[    2.640745]     BOOT_IMAGE=/boot/bzImage.test
[    2.713352] proc: Unknown parameter 'compatible'
[    3.298054] random: perl: uninitialized urandom read (4 bytes read)
[    3.941662] pktcdvd: pktcdvd0: writer mapped to sr0
[    4.091242] usb 4-2: new full-speed USB device number 2 using ohci-pci
[    4.171248] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[    4.362306] usb 4-2: New USB device found, idVendor=1546, idProduct=01a8, bcdDevice= 3.01
[    4.362565] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.365099] usb 4-2: Product: u-blox GNSS receiver
[    4.367516] usb 4-2: Manufacturer: u-blox AG - www.u-blox.com
[    4.370441] cdc_acm 4-2:1.0: ttyACM0: USB ACM device
[    4.631248] usb 1-9: new high-speed USB device number 5 using ehci-pci
[    4.853277] usb 1-9: New USB device found, idVendor=058f, idProduct=6362, bcdDevice= 1.00
[    4.853484] usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.855979] usb 1-9: Product: Mass Storage Device
[    4.858410] usb 1-9: Manufacturer: Generic
[    4.860861] usb 1-9: SerialNumber: 058F63626376
[    4.863666] usb-storage 1-9:1.0: USB Mass Storage device detected
[    4.865917] scsi host14: usb-storage 1-9:1.0
[    5.441233] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[    5.441440] usb usb3-port1: attempt power cycle
[    5.941929] scsi 14:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    5.942798] scsi 14:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    5.945291] scsi 14:0:0:2: Direct-Access     Generic  USB xD/SM Reader 1.02 PQ: 0 ANSI: 0
[    5.947797] scsi 14:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    5.949994] sd 14:0:0:0: Attached scsi generic sg6 type 0
[    5.952487] sd 14:0:0:1: Attached scsi generic sg7 type 0
[    5.955027] sd 14:0:0:2: Attached scsi generic sg8 type 0
[    5.957589] sd 14:0:0:3: Attached scsi generic sg9 type 0
[    6.022325] sd 14:0:0:2: [sdh] Attached SCSI removable disk
[    6.025418] sd 14:0:0:3: [sdi] Attached SCSI removable disk
[    6.027546] sd 14:0:0:0: [sdf] Attached SCSI removable disk
[    6.029431] sd 14:0:0:1: [sdg] Attached SCSI removable disk
[    7.041235] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[    8.301234] usb usb3-port1: Cannot enable. Maybe the USB cable is bad?
[    8.301456] usb usb3-port1: unable to enumerate USB device
[    8.435948] EXT4-fs (sda): re-mounted. Opts: (null)
[    8.456724] EXT4-fs (sda): re-mounted. Opts: data=ordered
[    8.766319] random: dd: uninitialized urandom read (512 bytes read)
[    8.769746] random: perl: uninitialized urandom read (4 bytes read)
[    8.799532] random: crng init done
[    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=lspci-v.txt

00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 Host Bridge
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD790 Host Bridge
	Flags: bus master, 66MHz, medium devsel, latency 32
	Memory at <ignored> (64-bit, non-prefetchable)
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [9c] HyperTransport: #1a

00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (external gfx0 port A) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0, IRQ 24
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff [size=4K]
	Memory behind bridge: f8000000-fbffffff [size=64M]
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff [size=256M]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot-), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (external gfx0 port A)
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110] Virtual Channel
	Kernel driver in use: pcieport

00:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port C) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0, IRQ 25
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000a000-0000afff [size=4K]
	Memory behind bridge: fdf00000-fdffffff [size=1M]
	Prefetchable memory behind bridge: 00000000fde00000-00000000fdefffff [size=1M]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot-), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port C)
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110] Virtual Channel
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0, IRQ 26
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000e000-0000efff [size=4K]
	Memory behind bridge: fdd00000-fddfffff [size=1M]
	Prefetchable memory behind bridge: 00000000fdc00000-00000000fdcfffff [size=1M]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot-), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (PCI express gpp port D)
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110] Virtual Channel
	Kernel driver in use: pcieport

00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port E) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0, IRQ 27
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff [size=4K]
	Memory behind bridge: fdb00000-fdbfffff [size=1M]
	Prefetchable memory behind bridge: 00000000fda00000-00000000fdafffff [size=1M]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot-), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port E)
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110] Virtual Channel
	Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port F) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0, IRQ 28
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff [size=4K]
	Memory behind bridge: fd900000-fd9fffff [size=1M]
	Prefetchable memory behind bridge: 00000000fd800000-00000000fd8fffff [size=1M]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot-), MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port F)
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [110] Virtual Channel
	Kernel driver in use: pcieport

00:12.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 Non-Raid-5 SATA (prog-if 01 [AHCI 1.0])
	Subsystem: Gigabyte Technology Co., Ltd Gigabyte GA-MA69G-S3H Motherboard
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 22
	I/O ports at ff00 [size=8]
	I/O ports at fe00 [size=4]
	I/O ports at fd00 [size=8]
	I/O ports at fc00 [size=4]
	I/O ports at fb00 [size=16]
	Memory at fe02f000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
	Kernel driver in use: ahci

00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 USB (OHCI0) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd SB600 USB (OHCI0)
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
	Memory at fe02e000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 USB (OHCI1) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd SB600 USB (OHCI1)
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
	Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 USB (OHCI2) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd SB600 USB (OHCI2)
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.3 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 USB (OHCI3) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd SB600 USB (OHCI3)
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
	Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.4 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 USB (OHCI4) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd SB600 USB (OHCI4)
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci

00:13.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB600 USB Controller (EHCI) (prog-if 20 [EHCI])
	Subsystem: Gigabyte Technology Co., Ltd SB600 USB Controller (EHCI)
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 19
	Memory at fe029000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci-pci

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller (rev 14)
	Subsystem: Gigabyte Technology Co., Ltd GA-MA770-DS3rev2.0 Motherboard
	Flags: 66MHz, medium devsel
	I/O ports at 0b00 [size=16]
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB600 IDE (prog-if 8a [ISA Compatibility mode controller, supports both channels switched to PCI native mode, supports bus mastering])
	Subsystem: Gigabyte Technology Co., Ltd Gigabyte GA-MA69G-S3H Motherboard
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
	Memory at 000001f0 (32-bit, non-prefetchable) [virtual] [size=8]
	Memory at 000003f0 (type 3, non-prefetchable) [virtual]
	Memory at 00000170 (32-bit, non-prefetchable) [virtual] [size=8]
	Memory at 00000370 (type 3, non-prefetchable) [virtual]
	I/O ports at f900 [virtual] [size=16]
	Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA)
	Subsystem: Gigabyte Technology Co., Ltd GA-MA770-DS3rev2.0 Motherboard
	Flags: bus master, slow devsel, latency 32, IRQ 16
	Memory at fe024000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB600 PCI to LPC Bridge
	Subsystem: Gigabyte Technology Co., Ltd SB600 PCI to LPC Bridge
	Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Flags: bus master, VGA palette snoop, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=64
	I/O behind bridge: 00009000-00009fff [size=4K]
	Memory behind bridge: fd700000-fd7fffff [size=1M]
	Prefetchable memory behind bridge: fd600000-fd6fffff [size=1M]

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
	Flags: fast devsel

01:00.0 VGA compatible controller: NVIDIA Corporation GF114 [GeForce GTX 560 Ti] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Micro-Star International Co., Ltd. [MSI] GF114 [GeForce GTX 560 Ti]
	Flags: bus master, fast devsel, latency 0, IRQ 29
	Memory at f8000000 (32-bit, non-prefetchable) [size=32M]
	Memory at d0000000 (64-bit, prefetchable) [size=128M]
	Memory at dc000000 (64-bit, prefetchable) [size=64M]
	I/O ports at bf00 [size=128]
	Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
	Capabilities: [60] Power Management version 3
	Capabilities: [68] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Capabilities: [100] Virtual Channel
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
	Kernel driver in use: nouveau

01:00.1 Audio device: NVIDIA Corporation GF114 HDMI Audio Controller (rev a1)
	Subsystem: Micro-Star International Co., Ltd. [MSI] GF114 HDMI Audio Controller
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at fbffc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [60] Power Management version 3
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Kernel driver in use: snd_hda_intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 01)
	Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
	Flags: bus master, fast devsel, latency 0, IRQ 18
	I/O ports at ae00 [size=256]
	Memory at fdfff000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at fdf00000 [virtual] [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
	Capabilities: [48] Vital Product Data
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [84] Vendor Specific Information: Len=4c <?>
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [12c] Virtual Channel
	Capabilities: [148] Device Serial Number 00-00-00-00-10-ec-81-68
	Capabilities: [154] Power Budgeting <?>
	Kernel driver in use: r8169

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 01)
	Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
	Flags: bus master, fast devsel, latency 0, IRQ 19
	I/O ports at ee00 [size=256]
	Memory at fddff000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at fdd00000 [virtual] [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
	Capabilities: [48] Vital Product Data
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [84] Vendor Specific Information: Len=4c <?>
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [12c] Virtual Channel
	Capabilities: [148] Device Serial Number 00-00-00-00-10-ec-81-68
	Capabilities: [154] Power Budgeting <?>
	Kernel driver in use: r8169

04:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Gigabyte Technology Co., Ltd Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fdbfe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [68] Power Management version 2
	Capabilities: [50] Express Legacy Endpoint, MSI 01
	Kernel driver in use: ahci

04:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02) (prog-if 85 [PCI native mode-only controller, supports bus mastering])
	Subsystem: Gigabyte Technology Co., Ltd Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 18
	I/O ports at df00 [size=8]
	I/O ports at de00 [size=4]
	I/O ports at dd00 [size=8]
	I/O ports at dc00 [size=4]
	I/O ports at db00 [size=16]
	Capabilities: [68] Power Management version 2
	Kernel driver in use: pata_jmicron

05:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Gigabyte Technology Co., Ltd Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at fd9fe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [68] Power Management version 2
	Capabilities: [50] Express Legacy Endpoint, MSI 01
	Kernel driver in use: ahci

05:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02) (prog-if 85 [PCI native mode-only controller, supports bus mastering])
	Subsystem: Gigabyte Technology Co., Ltd Motherboard
	Flags: bus master, fast devsel, latency 0, IRQ 19
	I/O ports at cf00 [size=8]
	I/O ports at ce00 [size=4]
	I/O ports at cd00 [size=8]
	I/O ports at cc00 [size=4]
	I/O ports at cb00 [size=16]
	Capabilities: [68] Power Management version 2
	Kernel driver in use: pata_jmicron

06:06.0 Multimedia audio controller: VIA Technologies Inc. VT1720/24 [Envy24PT/HT] PCI Multi-Channel Audio Controller (rev 01)
	Subsystem: Device 3031:4553
	Flags: bus master, medium devsel, latency 32, IRQ 20
	I/O ports at 9f00 [size=32]
	I/O ports at 9e00 [size=128]
	Capabilities: [80] Power Management version 1
	Kernel driver in use: snd_ice1724

06:07.0 Multimedia audio controller: VIA Technologies Inc. VT1720/24 [Envy24PT/HT] PCI Multi-Channel Audio Controller (rev 01)
	Subsystem: Device 3031:4553
	Flags: bus master, medium devsel, latency 32, IRQ 21
	I/O ports at 9d00 [size=32]
	I/O ports at 9c00 [size=128]
	Capabilities: [80] Power Management version 1
	Kernel driver in use: snd_ice1724

06:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Motherboard
	Flags: bus master, medium devsel, latency 32, IRQ 22
	Memory at fd7ff000 (32-bit, non-prefetchable) [size=2K]
	Memory at fd7f8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: firewire_ohci


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=proc-interrupts.txt

           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       
  0:         19          0          0          0          0          0   IO-APIC   2-edge      timer
  1:          0          0      11963          0          0          0   IO-APIC   1-edge      i8042
  8:          0          0          0          6          0          0   IO-APIC   8-edge      rtc0
  9:          0          1          0          0          0          0   IO-APIC   9-fasteoi   acpi
 14:          0          0          0          0          0          0   IO-APIC  14-edge      pata_atiixp
 16:          0      30741          0          0          0          0   IO-APIC  16-fasteoi   ohci_hcd:usb2, snd_hda_intel:card0
 17:          0          0          0          4          0          0   IO-APIC  17-fasteoi   ahci[0000:04:00.0], ohci_hcd:usb3, ohci_hcd:usb5
 18:          0          0          0          0     132579          0   IO-APIC  18-fasteoi   ahci[0000:05:00.0], pata_jmicron, ohci_hcd:usb4, ohci_hcd:usb6, eth0
 19:        981          0          0          0          0          0   IO-APIC  19-fasteoi   pata_jmicron, ehci_hcd:usb1, snd_hda_intel:card1
 20:          0          0          0          0   44071716          0   IO-APIC  20-fasteoi   snd_ice1724
 21:          0          0          0          0          0          0   IO-APIC  21-fasteoi   snd_ice1724
 22:          0          0     234798          0          0          0   IO-APIC  22-fasteoi   ahci[0000:00:12.0], firewire_ohci
 29:          0     337452          0          0          0          0   PCI-MSI 524288-edge      nvkm
NMI:          0          0          0          0          0          0   Non-maskable interrupts
LOC:     273255     265579     199591     280086     427156     457313   Local timer interrupts
SPU:          0          0          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0          0          0   APIC ICR read retries
RES:     287366     410769     559049     767654     994070    1099757   Rescheduling interrupts
CAL:      58214      62273      77283      93163     108101     122646   Function call interrupts
TLB:     192241     205978     251919     346266     404849     572530   TLB shootdowns
THR:          0          0          0          0          0          0   Threshold APIC interrupts
DFR:          0          0          0          0          0          0   Deferred Error APIC interrupts
MCE:          0          0          0          0          0          0   Machine check exceptions
MCP:         38         38         38         38         38         38   Machine check polls
ERR:    3525400
MIS:          0
PIN:          0          0          0          0          0          0   Posted-interrupt notification event
NPI:          0          0          0          0          0          0   Nested posted-interrupt event
PIW:          0          0          0          0          0          0   Posted-interrupt wakeup event

--=-=-=--
