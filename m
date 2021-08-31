Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C63FCFE0
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhHaXTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:19:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240914AbhHaXTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 19:19:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5QiQx5ZSL0etrjDmmCNM/mi0KhOe57UM28EHdznm0ac=; b=hubwgUG8pFRwFN3WeagN9+QNR8
        o4DI/TvWlUqTSqtYMtaUGaeAWfKWFwWS5vaAegm81MxeBoFaVRqGjVe+HfM/lwAU4CfgHLtJvu5L7
        aJdzYJaHvAs5tqy4X22cIZEWFw/tG5yv54ePSpj0l8t/oLq5UI/5WEtYurua4FUoGNDc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLD10-004m8m-Vo; Wed, 01 Sep 2021 01:18:03 +0200
Date:   Wed, 1 Sep 2021 01:18:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YS64qgBu6yv8lEfD@lunn.ch>
References: <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 3) And if possible boot logs with dev_dbg changed to dev_info in
> device_link_add() and device_links_check_suppliers()

Rev C.

Here is everything:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.12.0-rc4-00011-gea718c699055-dirty (andrew@lenovo) (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 20210110, G
NU ld (GNU Binutils for Debian) 2.37) #20 Tue Aug 31 18:06:09 CDT 2021
[    0.000000] CPU: ARMv7 Processor [410fc051] revision 1 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] OF: fdt: Machine model: ZII VF610 Development Board, Rev C
[    0.000000] printk: bootconsole [earlycon0] enabled
[    0.000000] Memory policy: Data cache writeback
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000080000000-0x000000009fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080000000-0x000000009fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x000000009fffffff]
[    0.000000] On node 0 totalpages: 131072
[    0.000000]   Normal zone: 1024 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 130048
[    0.000000] Kernel command line: root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait earlyprintk
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 508208K/524288K available (7168K kernel code, 931K rwdata, 1644K rodata, 1024K init, 250K bss, 16080K reserved, 0K cma-r
eserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] ftrace: allocating 25455 entries in 50 pages
[    0.000000] ftrace: allocated 50 pages with 3 groups
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] L2C-310 erratum 769419 enabled
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 cache controller enabled, 8 ways, 512 kB
[    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x06060000
[    0.000000] random: get_random_bytes called from start_kernel+0x32c/0x470 with crng_init=0
[    0.000009] sched_clock: 64 bits at 166MHz, resolution 5ns, wraps every 4398046511102ns
[    0.015010] clocksource: arm_global_timer: mask: 0xffffffffffffffff max_cycles: 0x2674622ffc, max_idle_ns: 440795203810 ns
[    0.025738] Switching to timer-based delay loop, resolution 5ns
[    0.031679] Console: colour dummy device 80x30
[    0.035135] printk: console [tty0] enabled
[    0.038268] printk: bootconsole [earlycon0] disabled
[    0.042336] Calibrating delay loop (skipped), value calculated using timer frequency.. 333.47 BogoMIPS (lpj=1667368)
[    0.042403] pid_max: default: 32768 minimum: 301
[    0.042758] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.042819] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
[    0.044134] CPU: Testing write buffer coherency: ok
[    0.045371] Setting up static identity map for 0x80100000 - 0x8010003c
[    0.046513] devtmpfs: initialized
[    0.058285] VFP support v0.3: implementor 41 architecture 2 part 30 variant 5 rev 1
[    0.058654] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.058725] futex hash table entries: 256 (order: -1, 3072 bytes, linear)
[    0.058923] pinctrl core: initialized pinctrl subsystem
[    0.060776] NET: Registered protocol family 16
[    0.062307] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.075858] platform 40044000.spi: Linked as a consumer to 40048000.iomuxc
[    0.076094] platform 4003b000.adc: Linked as a consumer to 40048000.iomuxc
[    0.076279] platform 4002c000.spi: Linked as a sync state only consumer to 40048000.iomuxc
[    0.076327] platform 4002c000.spi: Linked as a consumer to 40048000.iomuxc
[    0.076514] platform 4002a000.serial: Linked as a consumer to 40048000.iomuxc
[    0.076702] platform 40029000.serial: Linked as a consumer to 40048000.iomuxc
[    0.076915] platform 40028000.serial: Linked as a consumer to 40048000.iomuxc
[    0.077102] platform 40027000.serial: Linked as a consumer to 40048000.iomuxc
[    0.077794] platform 4002c000.spi: Linked as a sync state only consumer to 40049000.gpio
[    0.079223] platform 4002c000.spi: Linked as a sync state only consumer to 4004c000.gpio
[    0.082051] platform 40066000.i2c: Linked as a consumer to 4004a000.gpio
[    0.082252] platform 40066000.i2c: Linked as a consumer to 40048000.iomuxc
[    0.082494] platform 40066000.i2c: Linked as a sync state only consumer to 40049000.gpio
[    0.083140] platform 40067000.i2c: Linked as a consumer to 40048000.iomuxc
[    0.085386] platform 40080000.bus: Linked as a sync state only consumer to 40048000.iomuxc
[    0.085622] platform 40080000.bus: Linked as a sync state only consumer to 4004c000.gpio
[    0.087821] platform 400b2000.esdhc: Linked as a consumer to 40048000.iomuxc
[    0.089182] platform 400d0000.ethernet: Linked as a consumer to 40048000.iomuxc
[    0.089428] platform 400d0000.ethernet: Linked as a sync state only consumer to 4004c000.gpio
[    0.090067] platform 400d1000.ethernet: Linked as a consumer to 40048000.iomuxc
[    0.090730] platform 400e6000.i2c: Linked as a consumer to 40048000.iomuxc
[    0.090978] platform 400e6000.i2c: Linked as a sync state only consumer to 4004c000.gpio
[    0.092164] platform gpio-leds: Linked as a consumer to 40048000.iomuxc
[    0.092411] platform gpio-leds: Linked as a sync state only consumer to 4004b000.gpio
[    0.092885] platform 4003b000.adc: Linked as a consumer to regulator-vcc-3v3-mcu
[    0.093441] platform 40034000.usb: Linked as a consumer to regulator-usb0-vbus
[    0.093649] platform regulator-usb0-vbus: Linked as a consumer to 40049000.gpio
[    0.093850] platform regulator-usb0-vbus: Linked as a consumer to 40048000.iomuxc
[    0.095808] platform mdio-mux: Linked as a consumer to 40049000.gpio
[    0.096022] platform mdio-mux: Linked as a consumer to 40048000.iomuxc
[    0.097352] vf610-pinctrl 40048000.iomuxc: initialized IMX pinctrl driver
[    0.108955] Kprobes globally optimized
[    0.215992] platform regulator-usb0-vbus: probe deferral - supplier 40049000.gpio not ready
[    0.216878] SCSI subsystem initialized
[    0.217522] usbcore: registered new interface driver usbfs
[    0.217683] usbcore: registered new interface driver hub
[    0.217824] usbcore: registered new device driver usb
[    0.218474] platform 40066000.i2c: probe deferral - supplier 4004a000.gpio not ready
[    0.219685] i2c i2c-0: IMX I2C adapter registered
[    0.219852] i2c i2c-0: using dma0chan0 (tx) and dma0chan1 (rx) for DMA transfers
[    0.221038] i2c 1-0070: Linked as a consumer to 4004c000.gpio
[    0.221289] i2c 1-0070: Linked as a consumer to 40048000.iomuxc
[    0.221492] i2c i2c-1: IMX I2C adapter registered
[    0.221625] i2c i2c-1: using dma0chan16 (tx) and dma0chan17 (rx) for DMA transfers
[    0.221698] imx-i2c 400e6000.i2c: Dropping the link to 4004c000.gpio
[    0.222145] pps_core: LinuxPPS API ver. 1 registered
[    0.222188] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.222290] PTP clock support registered
[    0.222905] Advanced Linux Sound Architecture Driver Initialized.
[    0.268543] clocksource: Switched to clocksource arm_global_timer
[    0.634728] NET: Registered protocol family 2
[    0.635842] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 4096 bytes, linear)
[    0.635943] TCP established hash table entries: 4096 (order: 2, 16384 bytes, linear)
[    0.636068] TCP bind hash table entries: 4096 (order: 2, 16384 bytes, linear)
[    0.636190] TCP: Hash tables configured (established 4096 bind 4096)
[    0.636470] UDP hash table entries: 256 (order: 0, 4096 bytes, linear)
[    0.636551] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes, linear)
[    0.636879] NET: Registered protocol family 1
[    0.639687] RPC: Registered named UNIX socket transport module.
[    0.639749] RPC: Registered udp transport module.
[    0.639780] RPC: Registered tcp transport module.
[    0.639808] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.642391] workingset: timestamp_bits=30 max_order=17 bucket_order=0
[    0.657373] io scheduler mq-deadline registered
[    0.657455] io scheduler kyber registered
[    0.658814] gpio-23 (sx1503-irq): hogged as input
[    0.664005] gpio-98 (eth0-intrp): hogged as input
[    0.677195] 40027000.serial: ttyLP0 at MMIO 0x40027000 (irq = 19, base_baud = 5210526) is a FSL_LPUART
[    1.291559] printk: console [ttyLP0] enabled
[    1.295642] 40028000.serial: ttyLP1 at MMIO 0x40028000 (irq = 20, base_baud = 5210526) is a FSL_LPUART
[    1.305537] 40029000.serial: ttyLP2 at MMIO 0x40029000 (irq = 21, base_baud = 5210526) is a FSL_LPUART
[    1.315290] 4002a000.serial: ttyLP3 at MMIO 0x4002a000 (irq = 22, base_baud = 5210526) is a FSL_LPUART
[    1.360010] brd: module loaded
[    1.362289] at24 0-0050: supply vcc not found, using dummy regulator
[    1.367686] at24 0-0050: Linked as a consumer to regulator.0
[    1.374685] at24 0-0050: 256 byte 24c02 EEPROM, read-only
[    1.385241] spi-nor spi0.0: m25p128 (16384 Kbytes)
[    1.392931] fsl-dspi 4002c000.spi: Dropping the link to 40049000.gpio
[    1.398313] fsl-dspi 4002c000.spi: Dropping the link to 4004c000.gpio
[    1.411512] spi-nor spi1.0: n25q00 (131072 Kbytes)
[    1.421718] spi-nor spi1.2: n25q00 (131072 Kbytes)
[    1.430163] libphy: Fixed MDIO Bus: probed
[    1.439542] mdio_bus 400d0000.ethernet-1: Linked as a sync state only consumer to 4004c000.gpio
[    1.447185] mdio_bus 400d0000.ethernet-1: Linked as a sync state only consumer to 40048000.iomuxc
[    1.454900] libphy: fec_enet_mii_bus: probed
[    1.478153] mdio_bus 400d0000.ethernet-1:00: Linked as a consumer to 4004c000.gpio
[    1.484753] mdio_bus 400d0000.ethernet-1:00: Linked as a consumer to 40048000.iomuxc
[    1.492867] fec 400d0000.ethernet: Dropping the link to 4004c000.gpio
[    1.504139] fec 400d1000.ethernet: Invalid MAC address: 00:00:00:00:00:00
[    1.509763] fec 400d1000.ethernet: Using random MAC address: 86:cc:e2:6b:14:52
[    1.517154] libphy: fec_enet_mii_bus: probed
[    1.521523] usbcore: registered new interface driver asix
[    1.525784] usbcore: registered new interface driver ax88179_178a
[    1.530746] usbcore: registered new interface driver cdc_ether
[    1.535388] usbcore: registered new interface driver net1080
[    1.539902] usbcore: registered new interface driver cdc_subset
[    1.544650] usbcore: registered new interface driver zaurus
[    1.549100] usbcore: registered new interface driver cdc_ncm
[    1.553487] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.558763] ehci-platform: EHCI generic platform driver
[    1.563182] usbcore: registered new interface driver usb-storage
[    1.568721] platform 40034000.usb: probe deferral - supplier regulator-usb0-vbus not ready
[    1.587769] snvs_rtc 400a7000.snvs:snvs-rtc-lp: registered as rtc0
[    1.592824] snvs_rtc 400a7000.snvs:snvs-rtc-lp: setting system clock to 2021-08-31T23:07:25 UTC (1630451245)
[    1.601721] i2c /dev entries driver
[    1.609055] i2c i2c-1: Added multiplexed i2c bus 2
[    1.614256] i2c i2c-1: Added multiplexed i2c bus 3
[    1.619194] i2c i2c-1: Added multiplexed i2c bus 4
[    1.624001] i2c i2c-1: Added multiplexed i2c bus 5
[    1.628764] i2c i2c-1: Added multiplexed i2c bus 6
[    1.633465] i2c i2c-1: Added multiplexed i2c bus 7
[    1.638180] i2c i2c-1: Added multiplexed i2c bus 8
[    1.643056] i2c i2c-1: Added multiplexed i2c bus 9
[    1.646603] pca954x 1-0070: registered 8 multiplexed busses for I2C switch pca9548
[    1.657429] sdhci: Secure Digital Host Controller Interface driver
[    1.662415] sdhci: Copyright(c) Pierre Ossman
[    1.665495] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.671279] leds-gpio gpio-leds: Dropping the link to 4004b000.gpio
[    1.677287] usbcore: registered new interface driver usbhid
[    1.681644] usbhid: USB HID core driver
[    1.684988] vf610-adc 4003b000.adc: Linked as a consumer to regulator.1
[    1.705844] NET: Registered protocol family 17
[    1.747018] mmc0: SDHCI controller on 400b2000.esdhc [400b2000.esdhc] using ADMA
[    1.757323] lm75 10-0048: supply vs not found, using dummy regulator
[    1.762801] lm75 10-0048: Linked as a consumer to regulator.0
[    1.771806] lm75 10-0048: hwmon0: sensor 'lm75'
[    1.775772] at24 10-0050: supply vcc not found, using dummy regulator
[    1.781313] at24 10-0050: Linked as a consumer to regulator.0
[    1.789929] at24 10-0050: 512 byte 24c04 EEPROM, writable, 1 bytes/write
[    1.796044] at24 10-0052: supply vcc not found, using dummy regulator
[    1.801527] at24 10-0052: Linked as a consumer to regulator.0
[    1.810012] at24 10-0052: 512 byte 24c04 EEPROM, writable, 1 bytes/write
[    1.816481] pca953x 10-0018: supply vcc not found, using dummy regulator
[    1.822251] pca953x 10-0018: Linked as a consumer to regulator.0
[    1.827009] pca953x 10-0018: using no AI
[    1.834047] platform sff3: Linked as a consumer to 10-0020
[    1.838453] platform sff2: Linked as a consumer to 10-0020
[    1.842908] i2c 10-0020: Linked as a consumer to 40049000.gpio
[    1.847643] i2c 10-0020: Linked as a consumer to 40048000.iomuxc
[    1.860624] pca953x 10-0022: supply vcc not found, using dummy regulator
[    1.866334] pca953x 10-0022: Linked as a consumer to regulator.0
[    1.871160] pca953x 10-0022: using no AI
[    1.878025] i2c i2c-10: IMX I2C adapter registered
[    1.881721] i2c i2c-10: using dma0chan2 (tx) and dma0chan3 (rx) for DMA transfers
[    1.887989] imx-i2c 40066000.i2c: Dropping the link to 40049000.gpio
[    1.894950] mdio_bus 0.1: Linked as a sync state only consumer to 40049000.gpio
[    1.901214] mdio_bus 0.1: Linked as a sync state only consumer to 40048000.iomuxc
[    1.907514] libphy: mdio_mux: probed
[    1.910276] mdio_bus 0.1:00: Linked as a consumer to 40049000.gpio
[    1.915348] mdio_bus 0.1:00: Linked as a consumer to 40048000.iomuxc
[    1.920693] mdio_bus 0.1:00: Linked as a sync state only consumer to 0.1:00
[    1.926760] mv88e6085 0.1:00: switch 0xa10 detected: Marvell 88E6390X, revision 1
[    1.942194] mdio_bus !mdio-mux!mdio@1!switch@0!mdio: Linked as a sync state only consumer to 0.1:00
[    1.950156] libphy: mdio: probed
[    1.952481] mmc0: host does not support reading read-only switch, assuming write-enable
[    1.963210] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:01: Linked as a consumer to 0.1:00
[    1.970021] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:01: probe deferral - supplier 0.1:00 not ready
[    1.978320] mmc0: new high speed SDHC card at address aaaa
[    1.985170] mmcblk0: mmc0:aaaa SU04G 3.69 GiB 
[    1.992443] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:02: Linked as a consumer to 0.1:00
[    1.999277] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:02: probe deferral - supplier 0.1:00 not ready
[    2.012242] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:03: Linked as a consumer to 0.1:00
[    2.019085] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:03: probe deferral - supplier 0.1:00 not ready
[    2.026995]  mmcblk0: p1 p2 p3 < p5 >
[    2.030498] mmcblk0: p5 size 440320 extends beyond EOD, truncated
[    2.043234] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:04: Linked as a consumer to 0.1:00
[    2.050044] mdio_bus !mdio-mux!mdio@1!switch@0!mdio:04: probe deferral - supplier 0.1:00 not ready
[    2.059198] mv88e6085 0.1:00: Dropping the link to 0.1:00
[    2.064608] mdio_bus 0.2: Linked as a sync state only consumer to 40049000.gpio
[    2.070898] mdio_bus 0.2: Linked as a sync state only consumer to 40048000.iomuxc
[    2.077196] libphy: mdio_mux: probed
[    2.079960] mdio_bus 0.2:00: Linked as a consumer to 40049000.gpio
[    2.085043] mdio_bus 0.2:00: Linked as a consumer to 40048000.iomuxc
[    2.090387] mdio_bus 0.2:00: Linked as a sync state only consumer to 0.2:00
[    2.096466] mv88e6085 0.2:00: switch 0xa10 detected: Marvell 88E6390X, revision 1
[    2.111052] mdio_bus !mdio-mux!mdio@2!switch@0!mdio: Linked as a sync state only consumer to 0.2:00
[    2.119003] libphy: mdio: probed
[    2.126170] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:01: Linked as a consumer to 0.2:00
[    2.132949] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:01: probe deferral - supplier 0.2:00 not ready
[    2.145815] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:02: Linked as a consumer to 0.2:00
[    2.152565] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:02: probe deferral - supplier 0.2:00 not ready
[    2.165415] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:03: Linked as a consumer to 0.2:00
[    2.172164] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:03: probe deferral - supplier 0.2:00 not ready
[    2.185026] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:04: Linked as a consumer to 0.2:00
[    2.191777] mdio_bus !mdio-mux!mdio@2!switch@0!mdio:04: probe deferral - supplier 0.2:00 not ready
[    2.309663] mv88e6085 0.1:00: configuring for fixed/ link mode
[    2.319255] mv88e6085 0.1:00: Link is Up - 100Mbps/Full - flow control off
[    2.329241] mv88e6085 0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
[    2.346853] mv88e6085 0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
[    2.364287] mv88e6085 0.1:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:03] driver [Generic PHY] (irq=POLL)
[    2.380887] mv88e6085 0.1:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:04] driver [Generic PHY] (irq=POLL)
[    2.397258] Generic PHY !mdio-mux!mdio@2!switch@0!mdio:01: Dropping the link to 0.2:00
[    2.408469] mv88e6085 0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
[    2.423691] Generic PHY !mdio-mux!mdio@2!switch@0!mdio:02: Dropping the link to 0.2:00
[    2.432750] mv88e6085 0.2:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
[    2.447887] Generic PHY !mdio-mux!mdio@2!switch@0!mdio:03: Dropping the link to 0.2:00
[    2.456943] mv88e6085 0.2:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:03] driver [Generic PHY] (irq=POLL)
[    2.472080] Generic PHY !mdio-mux!mdio@2!switch@0!mdio:04: Dropping the link to 0.2:00
[    2.481149] mv88e6085 0.2:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:04] driver [Generic PHY] (irq=POLL)
[    2.495310] mv88e6085 0.1:00: Linked as a consumer to 400d1000.ethernet
[    2.500779] DSA: tree 0 setup
[    2.502536] mv88e6085 0.2:00: Dropping the link to 0.2:00
[    2.507780] libphy: mdio_mux: probed

This is based on:

Commit ea718c699055c8566eb64432388a04974c43b2ea (HEAD, refs/bisect/bad)
Author: Saravana Kannan <saravanak@google.com>
Date:   Tue Mar 2 13:11:32 2021 -0800

    Revert "Revert "driver core: Set fw_devlink=on by default""
    
    This reverts commit 3e4c982f1ce75faf5314477b8da296d2d00919df.
    
    Since all reported issues due to fw_devlink=on should be addressed by
    this series, revert the revert. fw_devlink=on Take II.
    
    Signed-off-by: Saravana Kannan <saravanak@google.com>
    Link: https://lore.kernel.org/r/20210302211133.2244281-4-saravanak@google.com
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

     Andrew
