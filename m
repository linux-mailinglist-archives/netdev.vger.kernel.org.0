Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAC17027B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfGVOj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:39:59 -0400
Received: from vps.xff.cz ([195.181.215.36]:34924 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfGVOj7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 10:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xff.cz; s=mail;
        t=1563806396; bh=oa/8tWYBHravqsd8qwUeZUroQUesvG7fMghkarDxCEs=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=BNpUp9H9ke1JFXEfGfPNOkRAdplPoAnUlzUa9ax5FrhpGpOtxc6j+lnS4M4Varc7W
         KXb17WfninHDK0GzG5igI/bPMjHx+HSMyGBhASHOgyXBuBxWTRSsLAUhF3GGfbysKW
         7t6FjoBhtpuGQ7Vk/zHwn9EM3I6znfNZM9QzGJDU=
Date:   Mon, 22 Jul 2019 16:39:55 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megi@xff.cz>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Message-ID: <20190722143955.uwzvcmhc4bdr2zr5@core.my.home>
Mail-Followup-To: Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian  Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
 <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722134023.GD8972@lunn.ch>
 <BN8PR12MB3266678A3ABD0EBF429C9766D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722141943.GE8972@lunn.ch>
 <BN8PR12MB3266BEC39374BE3E9CD2647DD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uu4auieocc6ol7kb"
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266BEC39374BE3E9CD2647DD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uu4auieocc6ol7kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 22, 2019 at 02:26:45PM +0000, Jose Abreu wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Jul/22/2019, 15:19:43 (UTC+00:00)
> 
> > On Mon, Jul 22, 2019 at 01:58:20PM +0000, Jose Abreu wrote:
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Date: Jul/22/2019, 14:40:23 (UTC+00:00)
> > > 
> > > > Does this mean that all stmmac variants support 1G? There are none
> > > > which just support Fast Ethernet?
> > > 
> > > This glue logic drivers sometimes reflect a custom IP that's Synopsys 
> > > based but modified by customer, so I can't know before-hand what's the 
> > > supported max speed. There are some old versions that don't support 1G 
> > > but I expect that PHY driver limits this ...
> > 
> > If a Fast PHY is used, then yes, it would be limited. But sometimes a
> > 1G PHY is used because they are cheaper than a Fast PHY.
> >  
> > > > I'm also not sure the change fits the problem. Why did it not
> > > > negotiate 100FULL rather than 10Half? You are only moving the 1G
> > > > speeds around, so 100 speeds should of been advertised and selected.
> > > 
> > > Hmm, now that I'm looking at it closer I agree with you. Maybe link 
> > > partner or PHY doesn't support 100M ?
> > 
> > In the working case, ethtool shows the link partner supports 10, 100,
> > and 1G. So something odd is going on here.
> > 
> > You fix does seems reasonable, and it has been reported to fix the
> > issue, but it would be good to understand what is going on here.
> 
> Agreed!
> 
> Ondrej, can you please share dmesg log and ethtool output with the fixed 
> patch ?

See the attachment, or this link:

  https://megous.com/dl/tmp/dmesg-5.3-working

regards,
	Ondrej

> ---
> Thanks,
> Jose Miguel Abreu

--uu4auieocc6ol7kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-5.3-working"

[    0.000000] Machine model: OrangePi 3
[    0.000000] cma: Reserved 64 MiB at 0x00000000bc000000
[    0.000000] On node 0 totalpages: 524288
[    0.000000]   DMA32 zone: 8192 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages reserved
[    0.000000]   DMA32 zone: 524288 pages, LIFO batch:63
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.1
[    0.000000] percpu: Embedded 22 pages/cpu s53208 r8192 d28712 u90112
[    0.000000] pcpu-alloc: s53208 r8192 d28712 u90112 alloc=22*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] Speculative Store Bypass Disable mitigation not required
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 516096
[    0.000000] Kernel command line: console=ttyS0,115200 console=tty1 root=/dev/mmcblk0p3 rootfstype=f2fs rw elevator=noop rootwait panic=3 quiet
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 1962168K/2097152K available (13822K kernel code, 804K rwdata, 4028K rodata, 2048K init, 619K bss, 69448K reserved, 65536K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] arch_timer: cp15 timer(s) running at 24.00MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x588fe9dc0, max_idle_ns: 440795202592 ns
[    0.000004] sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every 4398046511097ns
[    0.000205] Console: colour dummy device 80x25
[    0.000214] printk: console [tty1] enabled
[    0.000244] Calibrating delay loop (skipped), value calculated using timer frequency.. 48.00 BogoMIPS (lpj=96000)
[    0.000251] pid_max: default: 32768 minimum: 301
[    0.000376] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes, linear)
[    0.000389] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes, linear)
[    0.000844] *** VALIDATE proc ***
[    0.001011] *** VALIDATE cgroup1 ***
[    0.001017] *** VALIDATE cgroup2 ***
[    0.001597] ASID allocator initialised with 32768 entries
[    0.001667] rcu: Hierarchical SRCU implementation.
[    0.002044] smp: Bringing up secondary CPUs ...
[    0.002673] Detected VIPT I-cache on CPU1
[    0.002721] CPU1: Booted secondary processor 0x0000000001 [0x410fd034]
[    0.003242] Detected VIPT I-cache on CPU2
[    0.003270] CPU2: Booted secondary processor 0x0000000002 [0x410fd034]
[    0.003764] Detected VIPT I-cache on CPU3
[    0.003789] CPU3: Booted secondary processor 0x0000000003 [0x410fd034]
[    0.003853] smp: Brought up 1 node, 4 CPUs
[    0.003856] SMP: Total of 4 processors activated.
[    0.003861] CPU features: detected: 32-bit EL0 Support
[    0.003865] CPU features: detected: CRC32 instructions
[    0.004200] CPU: All CPU(s) started at EL2
[    0.004229] alternatives: patching kernel code
[    0.004264] random: get_random_u64 called from compute_layout+0x94/0xe8 with crng_init=0
[    0.005805] devtmpfs: initialized
[    0.009740] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.009753] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.011917] pinctrl core: initialized pinctrl subsystem
[    0.012603] NET: Registered protocol family 16
[    0.013482] cpuidle: using governor ladder
[    0.013562] cpuidle: using governor menu
[    0.013817] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.014827] DMA: preallocated 256 KiB pool for atomic allocations
[    0.030511] cryptd: max_cpu_qlen set to 1000
[    0.036889] vcc33-wifi: supplied by vcc-5v
[    0.037068] vcc-wifi-io: supplied by vcc33-wifi
[    0.037624] SCSI subsystem initialized
[    0.037791] usbcore: registered new interface driver usbfs
[    0.037823] usbcore: registered new interface driver hub
[    0.037889] usbcore: registered new device driver usb
[    0.037991] mc: Linux media interface: v0.10
[    0.038015] videodev: Linux video capture interface: v2.00
[    0.038083] pps_core: LinuxPPS API ver. 1 registered
[    0.038086] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.038097] PTP clock support registered
[    0.038335] Advanced Linux Sound Architecture Driver Initialized.
[    0.038736] Bluetooth: Core ver 2.22
[    0.038759] NET: Registered protocol family 31
[    0.038762] Bluetooth: HCI device and connection manager initialized
[    0.038770] Bluetooth: HCI socket layer initialized
[    0.038775] Bluetooth: L2CAP socket layer initialized
[    0.038786] Bluetooth: SCO socket layer initialized
[    0.039250] clocksource: Switched to clocksource arch_sys_counter
[    0.039464] FS-Cache: Loaded
[    0.043990] thermal_sys: Registered thermal governor 'fair_share'
[    0.043994] thermal_sys: Registered thermal governor 'bang_bang'
[    0.043998] thermal_sys: Registered thermal governor 'step_wise'
[    0.044451] NET: Registered protocol family 2
[    0.044904] tcp_listen_portaddr_hash hash table entries: 1024 (order: 2, 16384 bytes, linear)
[    0.044938] TCP established hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.045075] TCP bind hash table entries: 16384 (order: 6, 262144 bytes, linear)
[    0.045371] TCP: Hash tables configured (established 16384 bind 16384)
[    0.045462] UDP hash table entries: 1024 (order: 3, 32768 bytes, linear)
[    0.045512] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes, linear)
[    0.045678] NET: Registered protocol family 1
[    0.046075] RPC: Registered named UNIX socket transport module.
[    0.046077] RPC: Registered udp transport module.
[    0.046080] RPC: Registered tcp transport module.
[    0.046082] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.046531] Unpacking initramfs...
[    0.422703] Freeing initrd memory: 7524K
[    0.423446] kvm [1]: IPA Size Limit: 40bits
[    0.424027] kvm [1]: vgic interrupt IRQ1
[    0.424145] kvm [1]: Hyp mode initialized successfully
[    0.676316] Initialise system trusted keyrings
[    0.676486] workingset: timestamp_bits=46 max_order=19 bucket_order=0
[    0.681208] zbud: loaded
[    0.682566] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.683718] NFS: Registering the id_resolver key type
[    0.683743] Key type id_resolver registered
[    0.683746] Key type id_legacy registered
[    0.683756] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.683764] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.684932] Key type cifs.idmap registered
[    0.685039] fuse: init (API version 7.31)
[    0.685317] SGI XFS with ACLs, security attributes, no debug enabled
[    0.708181] NET: Registered protocol family 38
[    0.708196] Key type asymmetric registered
[    0.708200] Asymmetric key parser 'x509' registered
[    0.708261] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    0.708429] io scheduler mq-deadline registered
[    0.708588] io scheduler bfq registered
[    0.708847] sun50i-de2-bus 1000000.bus: Error couldn't map SRAM to device
[    0.708874] fbcon: Taking over console
[    0.709288] sun4i-usb-phy 5100400.phy: Couldn't request ID GPIO
[    0.709493] sun50i-usb3-phy 5210000.phy: failed to get phy clock
[    0.712901] sun50i-h6-r-pinctrl 7022000.pinctrl: initialized sunXi PIO driver
[    0.719403] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.722997] panfrost 1800000.gpu: clock rate = 432000000
[    0.723015] panfrost 1800000.gpu: bus_clock rate = 100000000
[    0.723032] panfrost 1800000.gpu: failed to get regulator: -517
[    0.723048] panfrost 1800000.gpu: regulator init failed -517
[    0.723408] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    0.729561] loop: module loaded
[    0.742760] zram: Added device: zram0
[    0.743419] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[    0.745108] libphy: Fixed MDIO Bus: probed
[    0.745263] tun: Universal TUN/TAP device driver, 1.6
[    0.745888] Broadcom 43xx driver loaded [ Features: NLS ]
[    0.746016] usbcore: registered new interface driver rt2800usb
[    0.746047] usbcore: registered new interface driver r8152
[    0.746097] usbcore: registered new interface driver cdc_ether
[    0.746123] usbcore: registered new interface driver cdc_eem
[    0.746163] usbcore: registered new interface driver cdc_ncm
[    0.746559] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.746563] ehci-platform: EHCI generic platform driver
[    0.746691] ehci-platform 5101000.usb: EHCI Host Controller
[    0.746713] ehci-platform 5101000.usb: new USB bus registered, assigned bus number 1
[    0.746791] ehci-platform 5101000.usb: irq 22, io mem 0x05101000
[    0.759269] ehci-platform 5101000.usb: USB 2.0 started, EHCI 1.00
[    0.759400] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.03
[    0.759407] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.759412] usb usb1: Product: EHCI Host Controller
[    0.759417] usb usb1: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a ehci_hcd
[    0.759422] usb usb1: SerialNumber: 5101000.usb
[    0.759729] hub 1-0:1.0: USB hub found
[    0.759761] hub 1-0:1.0: 1 port detected
[    0.760114] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.760127] ohci-platform: OHCI generic platform driver
[    0.760232] ohci-platform 5101400.usb: Generic Platform OHCI controller
[    0.760247] ohci-platform 5101400.usb: new USB bus registered, assigned bus number 2
[    0.760314] ohci-platform 5101400.usb: irq 23, io mem 0x05101400
[    0.823385] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.03
[    0.823392] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.823397] usb usb2: Product: Generic Platform OHCI controller
[    0.823402] usb usb2: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a ohci_hcd
[    0.823407] usb usb2: SerialNumber: 5101400.usb
[    0.823677] hub 2-0:1.0: USB hub found
[    0.823700] hub 2-0:1.0: 1 port detected
[    0.824295] usbcore: registered new interface driver cdc_acm
[    0.824298] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    0.824338] usbcore: registered new interface driver usblp
[    0.824368] usbcore: registered new interface driver cdc_wdm
[    0.824398] usbcore: registered new interface driver uas
[    0.824462] usbcore: registered new interface driver usb-storage
[    0.824531] usbcore: registered new interface driver ch341
[    0.824553] usbserial: USB Serial support registered for ch341-uart
[    0.824580] usbcore: registered new interface driver cp210x
[    0.824599] usbserial: USB Serial support registered for cp210x
[    0.824642] usbcore: registered new interface driver ftdi_sio
[    0.824662] usbserial: USB Serial support registered for FTDI USB Serial Device
[    0.824746] usbcore: registered new interface driver pl2303
[    0.824768] usbserial: USB Serial support registered for pl2303
[    0.825365] vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
[    0.825374] vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 3
[    0.825400] vhci_hcd: created sysfs vhci_hcd.0
[    0.825520] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.03
[    0.825527] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.825532] usb usb3: Product: USB/IP Virtual Host Controller
[    0.825537] usb usb3: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a vhci_hcd
[    0.825542] usb usb3: SerialNumber: vhci_hcd.0
[    0.825830] hub 3-0:1.0: USB hub found
[    0.825857] hub 3-0:1.0: 8 ports detected
[    0.826211] vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
[    0.826218] vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 4
[    0.826267] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    0.826352] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.03
[    0.826358] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.826363] usb usb4: Product: USB/IP Virtual Host Controller
[    0.826368] usb usb4: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a vhci_hcd
[    0.826373] usb usb4: SerialNumber: vhci_hcd.0
[    0.826609] hub 4-0:1.0: USB hub found
[    0.826631] hub 4-0:1.0: 8 ports detected
[    0.827100] usbcore: registered new device driver usbip-host
[    0.827541] mousedev: PS/2 mouse device common for all mice
[    0.827976] sun6i-rtc 7000000.rtc: registered as rtc0
[    0.827981] sun6i-rtc 7000000.rtc: RTC enabled
[    0.828056] i2c /dev entries driver
[    0.828223] sun50i-h6-r-pinctrl 7022000.pinctrl: 7022000.pinctrl supply vcc-pl not found, using dummy regulator
[    0.828645] axp20x-i2c 0-0036: AXP20x variant AXP806 found
[    0.833559] input: axp20x-pek as /devices/platform/soc/7081400.i2c/i2c-0/0-0036/axp221-pek/input/input0
[    0.834617] dcdca: supplied by vcc-5v
[    0.835642] dcdcc: supplied by vcc-5v
[    0.836192] dcdcd: supplied by vcc-5v
[    0.836748] dcdce: supplied by vcc-5v
[    0.837315] aldo1: supplied by vcc-5v
[    0.837861] aldo2: supplied by vcc-5v
[    0.838401] aldo3: supplied by vcc-5v
[    0.838963] bldo1: supplied by vcc-5v
[    0.839932] bldo2: supplied by vcc-5v
[    0.840465] bldo3: supplied by vcc-5v
[    0.841022] bldo4: supplied by vcc-5v
[    0.841572] cldo1: supplied by vcc-5v
[    0.842119] cldo2: supplied by vcc-5v
[    0.842677] cldo3: supplied by vcc-5v
[    0.843232] sw: supplied by regulator-dummy
[    0.843386] axp20x-i2c 0-0036: AXP20X driver loaded
[    0.843491] IR NEC protocol handler initialized
[    0.843494] IR RC5(x/sz) protocol handler initialized
[    0.843496] IR RC6 protocol handler initialized
[    0.843498] IR JVC protocol handler initialized
[    0.843500] IR Sony protocol handler initialized
[    0.843503] IR SANYO protocol handler initialized
[    0.843505] IR Sharp protocol handler initialized
[    0.843507] IR MCE Keyboard/mouse protocol handler initialized
[    0.843509] IR XMP protocol handler initialized
[    0.843789] usbcore: registered new interface driver uvcvideo
[    0.843791] USB Video Class driver (1.1.1)
[    0.844695] sunxi-wdt 7020400.watchdog: Watchdog enabled (timeout=16 sec, nowayout=0)
[    0.844882] device-mapper: uevent: version 1.0.3
[    0.845083] device-mapper: ioctl: 4.40.0-ioctl (2019-01-18) initialised: dm-devel@redhat.com
[    0.845089] Bluetooth: HCI UART driver ver 2.3
[    0.845094] Bluetooth: HCI UART protocol H4 registered
[    0.845155] Bluetooth: HCI UART protocol Broadcom registered
[    0.846235] cpufreq: cpufreq_online: CPU0: Running at unlisted freq: 912000 KHz
[    0.846617] cpufreq: cpufreq_online: CPU0: Unlisted initial frequency changed to: 1080000 KHz
[    0.847162] sun50i-h6-r-pinctrl 7022000.pinctrl: 7022000.pinctrl supply vcc-pm not found, using dummy regulator
[    0.847659] ledtrig-cpu: registered to indicate activity on CPUs
[    0.847695] hidraw: raw HID events driver (C) Jiri Kosina
[    0.847793] usbcore: registered new interface driver usbhid
[    0.847795] usbhid: USB HID core driver
[    0.848350] cedrus 1c0e000.video-codec: Device registered as /dev/video0
[    0.848730] gnss: GNSS driver registered with major 242
[    0.851607] usbcore: registered new interface driver snd-usb-audio
[    0.852532] GACT probability NOT on
[    0.861521] wireguard: WireGuard 0.0.20190702 loaded. See www.wireguard.com for information.
[    0.861525] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
[    0.861598] ipip: IPv4 and MPLS over IPv4 tunneling driver
[    0.861845] Initializing XFRM netlink socket
[    0.862116] NET: Registered protocol family 10
[    0.862579] Segment Routing with IPv6
[    0.862882] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    0.863295] NET: Registered protocol family 17
[    0.863309] NET: Registered protocol family 15
[    0.863343] Bridge firewalling registered
[    0.863419] Bluetooth: RFCOMM TTY layer initialized
[    0.863428] Bluetooth: RFCOMM socket layer initialized
[    0.863448] Bluetooth: RFCOMM ver 1.11
[    0.863452] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    0.863454] Bluetooth: BNEP filters: protocol multicast
[    0.863458] Bluetooth: BNEP socket layer initialized
[    0.863460] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    0.863463] Bluetooth: HIDP socket layer initialized
[    0.863507] l2tp_core: L2TP core driver, V2.0
[    0.863508] l2tp_netlink: L2TP netlink interface
[    0.863530] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    0.863643] DECnet: Routing cache hash table of 1024 buckets, 16Kbytes
[    0.863667] NET: Registered protocol family 12
[    0.863679] 8021q: 802.1Q VLAN Support v1.8
[    0.863705] Key type dns_resolver registered
[    0.864088] registered taskstats version 1
[    0.864090] Loading compiled-in X.509 certificates
[    0.872926] Key type encrypted registered
[    0.878595] sun4i-usb-phy 5100400.phy: Couldn't request ID GPIO
[    0.881048] sun50i-h6-pinctrl 300b000.pinctrl: initialized sunXi PIO driver
[    0.881200] sun50i-h6-pinctrl 300b000.pinctrl: 300b000.pinctrl supply vcc-ph not found, using dummy regulator
[    0.881433] printk: console [ttyS0] disabled
[    0.902200] 5000000.serial: ttyS0 at MMIO 0x5000000 (irq = 18, base_baud = 1500000) is a 16550A
[    0.930600] printk: console [ttyS0] enabled
[    0.951853] 5000400.serial: ttyS1 at MMIO 0x5000400 (irq = 19, base_baud = 1500000) is a 16550A
[    0.951912] serial serial0: tty port ttyS1 registered
[    0.952018] hci_uart_bcm serial0-0: serial0-0 supply vbat not found, using dummy regulator
[    0.952049] hci_uart_bcm serial0-0: serial0-0 supply vddio not found, using dummy regulator
[    0.961698] sun4i-drm display-engine: bound 1100000.mixer (ops 0xffffff8010e9a2c8)
[    0.961800] sun4i-drm display-engine: bound 6510000.tcon-top (ops 0xffffff8010e9e3c8)
[    0.961937] sun4i-drm display-engine: bound 6515000.lcd-controller (ops 0xffffff8010e967d8)
[    0.961971] sun8i-dw-hdmi 6000000.hdmi: 6000000.hdmi supply hvcc not found, using dummy regulator
[    0.962154] sun8i-dw-hdmi 6000000.hdmi: Detected HDMI TX controller v2.12a with HDCP (DWC HDMI 2.0 TX PHY)
[    0.962399] sun8i-dw-hdmi 6000000.hdmi: registered DesignWare HDMI I2C bus driver
[    0.991255] rc_core: IR keymap rc-cec not found
[    0.994488] Registered IR keymap rc-empty
[    0.994545] rc rc0: dw_hdmi as /devices/platform/soc/6000000.hdmi/rc/rc0
[    0.994609] input: dw_hdmi as /devices/platform/soc/6000000.hdmi/rc/rc0/input1
[    0.994791] sun4i-drm display-engine: bound 6000000.hdmi (ops 0xffffff8010e99670)
[    0.994794] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.994795] [drm] No driver support for vblank timestamp query.
[    0.994933] [drm] Initialized sun4i-drm 1.0.0 20150629 for display-engine on minor 0
[    1.030061] random: fast init done
[    1.140721] Console: switching to colour frame buffer device 240x67
[    1.173718] sun4i-drm display-engine: fb0: sun4i-drmdrmfb frame buffer device
[    1.173990] panfrost 1800000.gpu: clock rate = 432000000
[    1.174005] panfrost 1800000.gpu: bus_clock rate = 100000000
[    1.174101] panfrost 1800000.gpu: mali-t720 id 0x720 major 0x1 minor 0x1 status 0x0
[    1.174105] panfrost 1800000.gpu: features: 00000000,10309e40, issues: 00000000,21054400
[    1.174109] panfrost 1800000.gpu: Features: L2:0x07110206 Shader:0x00000000 Tiler:0x00000809 Mem:0x1 MMU:0x00002821 AS:0xf JS:0x7
[    1.174111] panfrost 1800000.gpu: shader_present=0x3 l2_present=0x1
[    1.174678] [drm] Initialized panfrost 1.0.0 20180908 for 1800000.gpu on minor 1
[    1.175156] dwmac-sun8i 5020000.ethernet: PTP uses main clock
[    1.175693] xhci-hcd xhci-hcd.3.auto: xHCI Host Controller
[    1.175704] xhci-hcd xhci-hcd.3.auto: new USB bus registered, assigned bus number 5
[    1.175808] xhci-hcd xhci-hcd.3.auto: hcc params 0x0220f064 hci version 0x100 quirks 0x0000000002010010
[    1.175833] xhci-hcd xhci-hcd.3.auto: irq 24, io mem 0x05200000
[    1.176017] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.03
[    1.176020] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.176023] usb usb5: Product: xHCI Host Controller
[    1.176026] usb usb5: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a xhci-hcd
[    1.176028] usb usb5: SerialNumber: xhci-hcd.3.auto
[    1.176226] hub 5-0:1.0: USB hub found
[    1.176240] hub 5-0:1.0: 1 port detected
[    1.176345] xhci-hcd xhci-hcd.3.auto: xHCI Host Controller
[    1.176352] xhci-hcd xhci-hcd.3.auto: new USB bus registered, assigned bus number 6
[    1.176360] xhci-hcd xhci-hcd.3.auto: Host supports USB 3.0 SuperSpeed
[    1.176386] usb usb6: We don't know the algorithms for LPM for this host, disabling LPM.
[    1.176426] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.03
[    1.176429] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.176432] usb usb6: Product: xHCI Host Controller
[    1.176435] usb usb6: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a xhci-hcd
[    1.176437] usb usb6: SerialNumber: xhci-hcd.3.auto
[    1.176575] hub 6-0:1.0: USB hub found
[    1.176587] hub 6-0:1.0: 1 port detected
[    1.177598] thermal thermal_zone0: failed to read out thermal zone (-16)
[    1.177631] thermal thermal_zone1: failed to read out thermal zone (-16)
[    1.177870] sun50i-h6-pinctrl 300b000.pinctrl: 300b000.pinctrl supply vcc-pf not found, using dummy regulator
[    1.178174] sunxi-mmc 4020000.mmc: Got CD GPIO
[    1.203389] sunxi-mmc 4020000.mmc: initialized, max. request size: 16384 KB, uses new timings mode
[    1.203965] sunxi-mmc 4021000.mmc: allocated mmc-pwrseq
[    1.239482] mmc0: host does not support reading read-only switch, assuming write-enable
[    1.242266] mmc0: new high speed SDHC card at address aaaa
[    1.243053] mmcblk0: mmc0:aaaa SC32G 29.7 GiB 
[    1.245094]  mmcblk0: p1 p2 p3
[    1.303877] Bluetooth: hci0: BCM: chip id 130
[    1.304159] Bluetooth: hci0: BCM: features 0x0f
[    1.306148] Bluetooth: hci0: BCM4345C5
[    1.306152] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0000
[    1.431794] sunxi-mmc 4021000.mmc: initialized, max. request size: 16384 KB, uses new timings mode
[    1.432870] dwmac-sun8i 5020000.ethernet: PTP uses main clock
[    1.448878] mmc1: queuing unknown CIS tuple 0x80 (2 bytes)
[    1.450368] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    1.451884] mmc1: queuing unknown CIS tuple 0x80 (3 bytes)
[    1.454566] mmc1: queuing unknown CIS tuple 0x80 (7 bytes)
[    1.457841] mmc1: queuing unknown CIS tuple 0x81 (9 bytes)
[    1.508685] mmc1: new high speed SDIO card at address 0001
[    1.511037] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43456-sdio for chip BCM4345/9
[    1.511182] brcmfmac mmc1:0001:1: Direct firmware load for brcm/brcmfmac43456-sdio.xunlong,orangepi-3.txt failed with error -2
[    1.511404] usb 6-1: new SuperSpeed Gen 1 USB device number 2 using xhci-hcd
[    1.536122] usb 6-1: New USB device found, idVendor=05e3, idProduct=0626, bcdDevice= 6.54
[    1.536126] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.536129] usb 6-1: Product: USB3.1 Hub
[    1.536132] usb 6-1: Manufacturer: GenesysLogic
[    1.539399] dwmac-sun8i 5020000.ethernet: Current syscon value is not the default 58000 (expect 50000)
[    1.539413] dwmac-sun8i 5020000.ethernet: No HW DMA feature register supported
[    1.539415] dwmac-sun8i 5020000.ethernet: RX Checksum Offload Engine supported
[    1.539418] dwmac-sun8i 5020000.ethernet: COE Type 2
[    1.539420] dwmac-sun8i 5020000.ethernet: TX Checksum insertion supported
[    1.539423] dwmac-sun8i 5020000.ethernet: Normal descriptors
[    1.539426] dwmac-sun8i 5020000.ethernet: Chain mode enabled
[    1.539505] libphy: stmmac: probed
[    1.560897] hub 6-1:1.0: USB hub found
[    1.561189] hub 6-1:1.0: 4 ports detected
[    1.604397] ehci-platform 5311000.usb: EHCI Host Controller
[    1.604411] ehci-platform 5311000.usb: new USB bus registered, assigned bus number 7
[    1.604471] ehci-platform 5311000.usb: irq 25, io mem 0x05311000
[    1.614585] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43456-sdio for chip BCM4345/9
[    1.614656] brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may have limited channels available
[    1.615076] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/9 wl0: Jun 16 2017 12:38:26 version 7.45.96.2 (66c4e21@sh-git) (r) FWID 01-1813af84
[    1.659269] usb 5-1: new high-speed USB device number 2 using xhci-hcd
[    1.675254] ehci-platform 5311000.usb: USB 2.0 started, EHCI 1.00
[    1.675354] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.03
[    1.675357] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.675361] usb usb7: Product: EHCI Host Controller
[    1.675363] usb usb7: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a ehci_hcd
[    1.675366] usb usb7: SerialNumber: 5311000.usb
[    1.675601] hub 7-0:1.0: USB hub found
[    1.675617] hub 7-0:1.0: 1 port detected
[    1.676010] ohci-platform 5311400.usb: Generic Platform OHCI controller
[    1.676021] ohci-platform 5311400.usb: new USB bus registered, assigned bus number 8
[    1.676091] ohci-platform 5311400.usb: irq 26, io mem 0x05311400
[    1.739320] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001, bcdDevice= 5.03
[    1.739323] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.739326] usb usb8: Product: Generic Platform OHCI controller
[    1.739328] usb usb8: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a ohci_hcd
[    1.739331] usb usb8: SerialNumber: 5311400.usb
[    1.739515] hub 8-0:1.0: USB hub found
[    1.739529] hub 8-0:1.0: 1 port detected
[    1.739919] usb_phy_generic usb_phy_generic.4.auto: usb_phy_generic.4.auto supply vcc not found, using dummy regulator
[    1.740079] musb-hdrc musb-hdrc.5.auto: MUSB HDRC host driver
[    1.740084] musb-hdrc musb-hdrc.5.auto: new USB bus registered, assigned bus number 9
[    1.740146] usb usb9: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.03
[    1.740149] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.740153] usb usb9: Product: MUSB HDRC host driver
[    1.740155] usb usb9: Manufacturer: Linux 5.3.0-rc1-00094-g7d082263f65a musb-hcd
[    1.740158] usb usb9: SerialNumber: musb-hdrc.5.auto
[    1.740310] hub 9-0:1.0: USB hub found
[    1.740323] hub 9-0:1.0: 1 port detected
[    1.740635] sun6i-rtc 7000000.rtc: setting system clock to 2019-07-22T13:48:21 UTC (1563803301)
[    1.740708] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    1.750388] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    1.750549] ALSA device list:
[    1.750552]   #0: Dummy 1
[    1.750555]   #1: Loopback 1
[    1.751413] Freeing unused kernel memory: 2048K
[    1.771259] Run /init as init process
[    1.825623] usb 5-1: New USB device found, idVendor=05e3, idProduct=0610, bcdDevice= 6.54
[    1.825630] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.825633] usb 5-1: Product: USB2.1 Hub
[    1.825636] usb 5-1: Manufacturer: GenesysLogic
[    1.880817] hub 5-1:1.0: USB hub found
[    1.881145] hub 5-1:1.0: 4 ports detected
[    2.000045] Bluetooth: hci0: BCM4345C5 (003.006.006) build 0038
[    2.000740] Bluetooth: hci0: BCM: Using default device address (43:45:c5:00:1f:ac)
[    2.435373] F2FS-fs (mmcblk0p3): Mounted with checkpoint version = 58e966d1
[    3.090732] systemd[1]: systemd 242.32-3-arch running in system mode. (+PAM +AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
[    3.090997] systemd[1]: Detected architecture arm64.
[    3.094359] systemd[1]: Set hostname to <l10>.
[    3.664342] systemd[1]: Condition check resulted in Arbitrary Executable File Formats File System Automount Point being skipped.
[    3.664384] random: systemd: uninitialized urandom read (16 bytes read)
[    3.664409] systemd[1]: Reached target Swap.
[    3.664616] random: systemd: uninitialized urandom read (16 bytes read)
[    3.667743] systemd[1]: Listening on Journal Socket (/dev/log).
[    3.680859] systemd[1]: Condition check resulted in Journal Audit Socket being skipped.
[    3.680954] random: systemd: uninitialized urandom read (16 bytes read)
[    3.681982] systemd[1]: Listening on udev Kernel Socket.
[    3.682204] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    3.682445] systemd[1]: Listening on udev Control Socket.
[    4.253914] systemd-journald[387]: Received request to flush runtime journal from PID 1
[    4.936393] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[    5.442451] dwmac-sun8i 5020000.ethernet eth0: PHY [stmmac-0:01] driver [RTL8211E Gigabit Ethernet]
[    5.442462] dwmac-sun8i 5020000.ethernet eth0: phy: setting supported 00,00000000,000062ff advertising 00,00000000,000062ff
[    5.443791] dwmac-sun8i 5020000.ethernet eth0: No Safety Features support found
[    5.443801] dwmac-sun8i 5020000.ethernet eth0: No MAC Management Counters available
[    5.443805] dwmac-sun8i 5020000.ethernet eth0: PTP not supported by HW
[    5.443812] dwmac-sun8i 5020000.ethernet eth0: configuring for phy/rgmii link mode
[    5.443823] dwmac-sun8i 5020000.ethernet eth0: phylink_mac_config: mode=phy/rgmii/Unknown/Unknown adv=00,00000000,000062ff pause=10 link=0 an=1
[    5.448927] dwmac-sun8i 5020000.ethernet eth0: phy link down rgmii/Unknown/Unknown
[    5.784492] zram0: detected capacity change from 0 to 402653184
[    5.838129] random: crng init done
[    5.838138] random: 7 urandom warning(s) missed due to ratelimiting
[    5.919346] Adding 393212k swap on /dev/zram0.  Priority:10 extents:1 across:393212k SS
[   10.559750] dwmac-sun8i 5020000.ethernet eth0: phy link up rgmii/1Gbps/Full
[   10.559768] dwmac-sun8i 5020000.ethernet eth0: phylink_mac_config: mode=phy/rgmii/1Gbps/Full adv=00,00000000,00000000 pause=0f link=1 an=0
[   10.559782] dwmac-sun8i 5020000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
[   10.559808] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready



Settings for eth0:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Half 1000baseT/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full
	                        100baseT/Half 100baseT/Full
	                        1000baseT/Half 1000baseT/Full
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full
	                                     100baseT/Half 100baseT/Full
	                                     1000baseT/Full
	Link partner advertised pause frame use: Symmetric Receive-only
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 1
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: d
	Wake-on: d
	Current message level: 0x0000003f (63)
			       drv probe link timer ifdown ifup
	Link detected: yes


--uu4auieocc6ol7kb--
