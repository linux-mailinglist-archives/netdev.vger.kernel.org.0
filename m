Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86066AB1AF
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 19:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCESNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 13:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjCESNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 13:13:16 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9FD86B6;
        Sun,  5 Mar 2023 10:13:13 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so3981590wmq.1;
        Sun, 05 Mar 2023 10:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mqbwrljujP18pr0J91izh0ShFnouuP4ylInXLNUV8Cs=;
        b=mrIagg7oJ7aDVmWnAj0hUhf5gOjMZ6uWu7Xkp/YNgl+BhGZHc+VjssWiEj9yo0Yo49
         S4YMsbmXObUMS/JIyziURTTVXKKV8B5/zcI5eMWEva2HfbreX/5Ld3/JMkwexiKn+9UZ
         o7xQCiUogLWxR/fnCy+vNZS+COUvZKeXCImGgECwxuk0QmP77LzWsYUGzY85k0X/ZJoG
         N6Jv4wU+YRNyjz7YECRny8izLNjVqdIn5BIM7/PBASCxi8WIpH97EBwfX+U/BF2d210a
         Ww7Qw3cFEZtX3w6scPm73EXaE0Smcc1fARIevDcpeVKIM/mn2VvqTe4z/VGHKXjLoaWt
         A+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mqbwrljujP18pr0J91izh0ShFnouuP4ylInXLNUV8Cs=;
        b=CSepapxC18ZqOPvQV8QC8tHXwwlGg37Hb8g/pmbMRC5f3it9C8u93RjJCCwg4GD3JF
         cs6VfMx39NRa4gqxRlMYv1Q7M1iWRZ5MhXQ9NQDB1/gUTPvibLmp0Rd2ooBfG+X9644H
         ep6XK23UXe0QglT2Ftzxh4/rYj7F1f9o1OD0zwkhVYa8I6g5c7IQX13OAm6g8Icoe8cA
         Y/5g6XciqDaTpQzs8c9VUeKwCvaWYizzm2NwSpWPApTeKjDT9QJaXFp1Yd5HkTwAQ8JH
         5usYe1AfDqtg86XCK7lwD4o6anBDPjLtSkTVeMY8eZaGGvzYqXtIuSe35Yy9xgH/73le
         y33A==
X-Gm-Message-State: AO0yUKVRvI1f9M2ItqwwBQNwyzs8dQF6d7jZQA4qJTYcjOYn6Eof+QbT
        2iEHLXcCBdcAVjAG10UrwrU=
X-Google-Smtp-Source: AK7set9leCI9y/0pNB2cBetQqJXtFdQEO1uvCDpNMJM8iL+srfkDePZQ1bR8FJyV6BX7q9Txd18Fxw==
X-Received: by 2002:a05:600c:4ece:b0:3de:d52:2cd2 with SMTP id g14-20020a05600c4ece00b003de0d522cd2mr7578238wmq.4.1678039991269;
        Sun, 05 Mar 2023 10:13:11 -0800 (PST)
Received: from ?IPv6:2a02:168:6806:0:f511:380:84eb:e6f7? ([2a02:168:6806:0:f511:380:84eb:e6f7])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c431500b003daf672a616sm7970342wme.22.2023.03.05.10.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 10:13:10 -0800 (PST)
Message-ID: <449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com>
Subject: Re: [PATCH net-next v2 4/6] net: mdio: scan bus based on bus
 capabilities for C22 and C45
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Sun, 05 Mar 2023 19:13:09 +0100
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
References: <20230116-net-next-remove-probe-capabilities-v2-0-15513b05e1f4@walle.cc>
         <20230116-net-next-remove-probe-capabilities-v2-4-15513b05e1f4@walle.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-18 at 11:01 +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
>=20
> Now that all MDIO bus drivers which set probe_capabilities to
> MDIOBUS_C22_C45 have been converted to use the name API for C45
> transactions, perform the scanning of the bus based on which methods
> the bus provides.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Hello,

On a Turris Omnia (Armada 385, Marvell 88E6176) this commit results
in a strange boot behaviour. I see two distinct multi-second freezes
in dmesg. Usually (up to the commit before), the (monolithic) kernel
starts init after ~1.6 seconds, now it takes more than 6....

dmesg output below. Any idea, why this is happening?

Best regards, Klaus

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 6.2.0-rc3+ (xxxx) (arm-linux-gnueabihf-gcc (De=
bian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40) #1 SMP Sun M=
ar  5 16:20:57 CET 2023
[    0.000000] CPU: ARMv7 Processor [414fc091] revision 1 (ARMv7), cr=3D10c=
5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instr=
uction cache
[    0.000000] OF: fdt: Machine model: Turris Omnia
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x000000002fffffff]
[    0.000000]   HighMem  [mem 0x0000000030000000-0x000000003fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000003ffff=
fff]
[    0.000000] percpu: Embedded 12 pages/cpu s19604 r8192 d21356 u49152
[    0.000000] pcpu-alloc: s19604 r8192 d21356 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 26041=
6
[    0.000000] Kernel command line: console=3DttyS0,115200 quiet root=3DPAR=
TUUID=3D262ecdb3-01 mvneta.txq_number=3D2 mvneta.rxq_number=3D2
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes, linear)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 1022716K/1048576K available (7168K kernel code, 590K=
 rwdata, 1776K rodata, 1024K init, 233K bss, 25860K reserved, 0K cma-reserv=
ed, 262144K highmem)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D=
2.
[    0.000000] 	Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 2=
5 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] L2C: DT/platform modifies aux control register: 0x06070000 -=
> 0x16070000
[    0.000000] L2C-310 enabling early BRESP for Cortex-A9
[    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
[    0.000000] L2C-310 D prefetch enabled, offset 1 lines
[    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
[    0.000000] L2C-310 Coherent cache controller enabled, 16 ways, 1024 kB
[    0.000000] L2C-310 Coherent: CACHE_ID 0x410054c9, AUX_CTRL 0x56070001
[    0.000000] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    0.000001] sched_clock: 64 bits at 800MHz, resolution 1ns, wraps every =
4398046511103ns
[    0.000012] clocksource: arm_global_timer: mask: 0xffffffffffffffff max_=
cycles: 0xb881274fa3, max_idle_ns: 440795210636 ns
[    0.000026] Switching to timer-based delay loop, resolution 1ns
[    0.000153] Ignoring duplicate/late registration of read_current_timer d=
elay
[    0.000159] clocksource: armada_370_xp_clocksource: mask: 0xffffffff max=
_cycles: 0xffffffff, max_idle_ns: 76450417870 ns
[    0.000302] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 1600.00 BogoMIPS (lpj=3D3200000)
[    0.000310] pid_max: default: 32768 minimum: 301
[    0.000396] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes, =
linear)
[    0.000403] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 by=
tes, linear)
[    0.000726] CPU: Testing write buffer coherency: ok
[    0.000749] CPU0: Spectre v2: using BPIALL workaround
[    0.000864] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.001188] cblist_init_generic: Setting adjustable number of callback q=
ueues.
[    0.001192] cblist_init_generic: Setting shift to 1 and lim to 1.
[    0.001241] Setting up static identity map for 0x100000 - 0x100060
[    0.001314] mvebu-soc-id: MVEBU SoC ID=3D0x6820, Rev=3D0x4
[    0.001393] mvebu-pmsu: Initializing Power Management Service Unit
[    0.001458] rcu: Hierarchical SRCU implementation.
[    0.001460] rcu: 	Max phase no-delay instances is 1000.
[    0.001631] smp: Bringing up secondary CPUs ...
[    0.001833] Booting CPU 1
[    0.001955] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.001962] CPU1: Spectre v2: using BPIALL workaround
[    0.002016] smp: Brought up 1 node, 2 CPUs
[    0.002020] SMP: Total of 2 processors activated (3200.00 BogoMIPS).
[    0.002025] CPU: All CPU(s) started in SVC mode.
[    0.002291] devtmpfs: initialized
[    0.004089] VFP support v0.3: implementor 41 architecture 3 part 30 vari=
ant 9 rev 4
[    0.004132] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 7645041785100000 ns
[    0.004141] futex hash table entries: 512 (order: 3, 32768 bytes, linear=
)
[    0.004196] pinctrl core: initialized pinctrl subsystem
[    0.004478] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.004981] DMA: preallocated 256 KiB pool for atomic coherent allocatio=
ns
[    0.005337] thermal_sys: Registered thermal governor 'step_wise'
[    0.005440] mvebu-pmsu: CPU hotplug support is currently broken on Armad=
a 38x: disabling
[    0.005445] mvebu-pmsu: CPU idle is currently broken on Armada 38x: disa=
bling
[    0.010021] SCSI subsystem initialized
[    0.010039] libata version 3.00 loaded.
[    0.010094] usbcore: registered new interface driver usbfs
[    0.010107] usbcore: registered new interface driver hub
[    0.010123] usbcore: registered new device driver usb
[    0.010716] clocksource: Switched to clocksource arm_global_timer
[    0.011194] NET: Registered PF_INET protocol family
[    0.011303] IP idents hash table entries: 16384 (order: 5, 131072 bytes,=
 linear)
[    0.012144] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, =
4096 bytes, linear)
[    0.012157] Table-perturb hash table entries: 65536 (order: 6, 262144 by=
tes, linear)
[    0.012164] TCP established hash table entries: 8192 (order: 3, 32768 by=
tes, linear)
[    0.012201] TCP bind hash table entries: 8192 (order: 5, 131072 bytes, l=
inear)
[    0.012316] TCP: Hash tables configured (established 8192 bind 8192)
[    0.012363] UDP hash table entries: 512 (order: 2, 16384 bytes, linear)
[    0.012389] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes, lin=
ear)
[    0.012498] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.013022] workingset: timestamp_bits=3D14 max_order=3D18 bucket_order=
=3D4
[    0.013133] Unpacking initramfs...
[    0.013356] NET: Registered PF_ALG protocol family
[    0.013390] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.013406] io scheduler bfq registered
[    0.018260] armada-38x-pinctrl f1018000.pinctrl: registered pinctrl driv=
er
[    0.018567] gpio gpiochip0: Static allocation of GPIO base is deprecated=
, use dynamic allocation.
[    0.018922] gpio gpiochip1: Static allocation of GPIO base is deprecated=
, use dynamic allocation.
[    0.019318] mv_xor f1060800.xor: Marvell shared XOR driver
[    0.047355] mv_xor f1060800.xor: Marvell XOR (Descriptor Mode): ( xor cp=
y intr )
[    0.047527] mv_xor f1060900.xor: Marvell shared XOR driver
[    0.075302] mv_xor f1060900.xor: Marvell XOR (Descriptor Mode): ( xor cp=
y intr )
[    0.075544] Serial: 8250/16550 driver, 5 ports, IRQ sharing disabled
[    0.076072] printk: console [ttyS0] disabled
[    0.076106] f1012000.serial: ttyS0 at MMIO 0xf1012000 (irq =3D 38, base_=
baud =3D 15625000) is a 16550A
[    0.076131] printk: console [ttyS0] enabled
[    0.076545] f1012100.serial: ttyS1 at MMIO 0xf1012100 (irq =3D 39, base_=
baud =3D 15625000) is a 16550A
[    0.077023] ahci-mvebu f10a8000.sata: AHCI 0001.0000 32 slots 2 ports 6 =
Gbps 0x3 impl platform mode
[    0.077035] ahci-mvebu f10a8000.sata: flags: 64bit ncq sntf led only pmp=
 fbs pio slum part sxs=20
[    0.077454] scsi host0: ahci-mvebu
[    0.077669] scsi host1: ahci-mvebu
[    0.077746] ata1: SATA max UDMA/133 mmio [mem 0xf10a8000-0xf10a9fff] por=
t 0x100 irq 40
[    0.077752] ata2: SATA max UDMA/133 mmio [mem 0xf10a8000-0xf10a9fff] por=
t 0x180 irq 40
[    0.078389] spi-nor spi0.0: s25fl164k (8192 Kbytes)
[    0.186266] Freeing initrd memory: 4576K
[    0.194291] 3 fixed-partitions partitions found on MTD device spi0.0
[    0.194305] Creating 3 MTD partitions on "spi0.0":
[    0.194310] 0x000000000000-0x0000000f0000 : "U-Boot"
[    0.194494] 0x000000100000-0x000000800000 : "Rescue system"
[    0.194609] 0x0000000f0000-0x000000100000 : "u-boot-env"
[    0.202428] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    0.392679] ata2: SATA link down (SStatus 0 SControl 300)
[    0.554721] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.555400] ata1.00: supports DRM functions and may not be fully accessi=
ble
[    0.555404] ata1.00: ATA-10: KINGSTON SKC600MS512G, S4800105, max UDMA/1=
33
[    0.555410] ata1.00: 1000215216 sectors, multi 1: LBA48 NCQ (depth 32)
[    0.556078] ata1.00: Features: Trust Dev-Sleep
[    0.556178] ata1.00: supports DRM functions and may not be fully accessi=
ble
[    0.556830] ata1.00: configured for UDMA/133
[    0.557003] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SKC600M 01=
05 PQ: 0 ANSI: 5
[    0.557513] sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: (512 G=
B/477 GiB)
[    0.557521] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.557542] sd 0:0:0:0: [sda] Write Protect is off
[    0.557548] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.557582] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.557650] sd 0:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
[    0.558138]  sda: sda1
[    0.558252] sd 0:0:0:0: [sda] Attached SCSI removable disk
*** FREEZE ***
[    2.779254] mvneta_bm f10c8000.bm: Buffer Manager for network controller=
 enabled
[    2.780632] mvneta f1070000.ethernet eth0: Using device tree mac address=
 d8:58:d7:00:6f:b9
[    2.781609] mvneta f1030000.ethernet eth1: Using device tree mac address=
 d8:58:d7:00:6f:b7
[    2.782547] mvneta f1034000.ethernet eth2: Using device tree mac address=
 d8:58:d7:00:6f:b8
[    2.782747] orion-ehci f1058000.usb: EHCI Host Controller
[    2.782761] orion-ehci f1058000.usb: new USB bus registered, assigned bu=
s number 1
[    2.782807] orion-ehci f1058000.usb: irq 45, io mem 0xf1058000
[    2.798726] orion-ehci f1058000.usb: USB 2.0 started, EHCI 1.00
[    2.799034] hub 1-0:1.0: USB hub found
[    2.799053] hub 1-0:1.0: 1 port detected
[    2.799415] xhci-hcd f10f0000.usb3: xHCI Host Controller
[    2.799427] xhci-hcd f10f0000.usb3: new USB bus registered, assigned bus=
 number 2
[    2.799475] xhci-hcd f10f0000.usb3: hcc params 0x0a000990 hci version 0x=
100 quirks 0x0000000000010010
[    2.799497] xhci-hcd f10f0000.usb3: irq 46, io mem 0xf10f0000
[    2.799506] xhci-hcd f10f0000.usb3: xHCI Host Controller
[    2.799513] xhci-hcd f10f0000.usb3: new USB bus registered, assigned bus=
 number 3
[    2.799525] xhci-hcd f10f0000.usb3: Host supports USB 3.0 SuperSpeed
[    2.799776] hub 2-0:1.0: USB hub found
[    2.799793] hub 2-0:1.0: 1 port detected
[    2.799927] usb usb3: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    2.800135] hub 3-0:1.0: USB hub found
[    2.800152] hub 3-0:1.0: 1 port detected
[    2.800329] xhci-hcd f10f8000.usb3: xHCI Host Controller
[    2.800340] xhci-hcd f10f8000.usb3: new USB bus registered, assigned bus=
 number 4
[    2.800383] xhci-hcd f10f8000.usb3: hcc params 0x0a000990 hci version 0x=
100 quirks 0x0000000000010010
[    2.800404] xhci-hcd f10f8000.usb3: irq 47, io mem 0xf10f8000
[    2.800414] xhci-hcd f10f8000.usb3: xHCI Host Controller
[    2.800421] xhci-hcd f10f8000.usb3: new USB bus registered, assigned bus=
 number 5
[    2.800431] xhci-hcd f10f8000.usb3: Host supports USB 3.0 SuperSpeed
[    2.800671] hub 4-0:1.0: USB hub found
[    2.800687] hub 4-0:1.0: 1 port detected
[    2.800824] usb usb5: We don't know the algorithms for LPM for this host=
, disabling LPM.
[    2.801039] hub 5-0:1.0: USB hub found
[    2.801055] hub 5-0:1.0: 1 port detected
[    2.801293] usbcore: registered new interface driver uas
[    2.801337] usbcore: registered new interface driver usb-storage
[    2.801815] armada38x-rtc f10a3800.rtc: registered as rtc0
[    2.801892] armada38x-rtc f10a3800.rtc: setting system clock to 2023-03-=
05T16:48:56 UTC (1678034936)
[    2.803556] at24 1-0054: 8192 byte 24c64 EEPROM, writable, 1 bytes/write
[    2.803591] i2c i2c-0: Added multiplexed i2c bus 1
[    2.803627] i2c i2c-0: Added multiplexed i2c bus 2
[    2.803657] i2c i2c-0: Added multiplexed i2c bus 3
[    2.803688] i2c i2c-0: Added multiplexed i2c bus 4
[    2.803717] i2c i2c-0: Added multiplexed i2c bus 5
[    2.803796] i2c i2c-0: Added multiplexed i2c bus 6
[    2.803828] i2c i2c-0: Added multiplexed i2c bus 7
[    2.804026] pca953x 8-0071: using no AI
[    2.805622] i2c i2c-0: Added multiplexed i2c bus 8
[    2.805630] pca954x 0-0070: registered 8 multiplexed busses for I2C mux =
pca9547
[    2.807069] orion_wdt: Initial timeout 171 sec
[    2.807255] sdhci: Secure Digital Host Controller Interface driver
[    2.807259] sdhci: Copyright(c) Pierre Ossman
[    2.807320] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.816014] marvell-cesa f1090000.crypto: CESA device successfully regis=
tered
[    2.816451] NET: Registered PF_INET6 protocol family
[    2.817118] Segment Routing with IPv6
[    2.817146] In-situ OAM (IOAM) with IPv6
[    2.817208] NET: Registered PF_PACKET protocol family
[    2.817323] Registering SWP/SWPB emulation handler
[    2.838752] mmc0: SDHCI controller on f10d8000.sdhci [f10d8000.sdhci] us=
ing ADMA
[    2.915557] sfp sfp: Host maximum power 3.0W
[    2.919406] mv88e6085 f1072004.mdio-mii:10: switch 0x1760 detected: Marv=
ell 88E6176, revision 1
[    2.942956] mmc0: new high speed MMC card at address 0001
[    2.943334] mmcblk0: mmc0:0001 H8G4a\x92 7.28 GiB=20
[    2.944348]  mmcblk0: p1
[    2.944624] mmcblk0boot0: mmc0:0001 H8G4a\x92 4.00 MiB=20
[    2.944926] mmcblk0boot1: mmc0:0001 H8G4a\x92 4.00 MiB=20
[    2.945157] mmcblk0rpmb: mmc0:0001 H8G4a\x92 4.00 MiB, chardev (250:0)
[    3.246121] sfp sfp: module TP-LINK          TL-SM321B        rev      s=
n 1403076900       dc 140401
[    3.246143] mvneta f1034000.ethernet eth2: switched to inband/1000base-x=
 link mode
*** FREEZE ***
[    5.956754] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[    5.958419] mv88e6085 f1072004.mdio-mii:10: configuring for fixed/rgmii-=
id link mode
[    5.959693] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[    5.963191] mv88e6085 f1072004.mdio-mii:10: Link is Up - 1Gbps/Full - fl=
ow control off
[    6.030496] mv88e6085 f1072004.mdio-mii:10 lan0 (uninitialized): PHY [mv=
88e6xxx-1:00] driver [Marvell 88E1540] (irq=3D68)
[    6.102678] mv88e6085 f1072004.mdio-mii:10 lan1 (uninitialized): PHY [mv=
88e6xxx-1:01] driver [Marvell 88E1540] (irq=3D69)
[    6.174861] mv88e6085 f1072004.mdio-mii:10 lan2 (uninitialized): PHY [mv=
88e6xxx-1:02] driver [Marvell 88E1540] (irq=3D70)
[    6.246141] mv88e6085 f1072004.mdio-mii:10 lan3 (uninitialized): PHY [mv=
88e6xxx-1:03] driver [Marvell 88E1540] (irq=3D71)
[    6.318682] mv88e6085 f1072004.mdio-mii:10 lan4 (uninitialized): PHY [mv=
88e6xxx-1:04] driver [Marvell 88E1540] (irq=3D72)
[    6.321598] device eth1 entered promiscuous mode
[    6.322472] device eth0 entered promiscuous mode
[    6.322491] DSA: tree 0 setup
[    6.323315] Freeing unused kernel image (initmem) memory: 1024K
[    6.323453] Run /init as init process
[    6.323457]   with arguments:
[    6.323459]     /init
[    6.323461]   with environment:
[    6.323463]     HOME=3D/
[    6.323465]     TERM=3Dlinux

