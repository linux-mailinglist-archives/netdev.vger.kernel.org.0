Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37985F39B7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJCXTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJCXT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:19:28 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22427DA4
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 16:19:25 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id m11-20020a4aab8b000000b00476743c0743so7739125oon.10
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 16:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=VGcbGVo5EeRIspWaXuVbIythoRBXwh6D5w64nz1CLzY=;
        b=IomZeUPkfgDJRYsh63clN1u/7IgYmacG1Vk3VFlHuVCrTGKRXPMI1exMPWHBvXJ2eV
         JSZSyLzzApQZufoH9P2LrSr+TiC/01Thl5W48I+qLGVrw7LZrFAFOklMuS7JfC0F6CHy
         fFdMyARypn0IDGCvLWmeW30oBru6/7XCCb9UH03qnZ5cr8MxzsYVfHQfH4RUpuJtDzwp
         EdbHzmwD/W1UQ3tPwh87eNDBSqfbRMuJRDF1jaB9b/MHkXdMQaMU6Y2gr8/YrByd8fGj
         5kfDc/yoM82vg7TIAPvXcbB/a/dkKK7na8T1jzY4QAoTiOxqIHfwqSRAWtMfDMjZYTdF
         S12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=VGcbGVo5EeRIspWaXuVbIythoRBXwh6D5w64nz1CLzY=;
        b=g8ZDO7aunZUlAUyCQSMoE0VHbTjaudRhK2gi4ICaTHxxOMBDg2TaGSb8mJ9P411ZES
         sXlcF8LkZhpOHrxS2YuhGFYt2s70IiQvDjF9yL8qEi1o3KczQ+Njlf1MiXI/+tZQM8B5
         jSnaCXeHCLAbfTZva8t3JFfXgi6PLB3l7tVC+2dGMvj4H7HZmk40tMu1RfMB1l5qcG0P
         gyleZ5u1O1gCxO8HzqriPGUP5iizZhJ4pVaf6kjakcrV9ic0RzFlQonjMZGg3+Etgrro
         POmfaZke3ZlG7LIbRXCwDqHPbvTMVTCrOQVp9kHwXoOBpKIy8ZqLAokKPsCRPNC77Ug1
         bJEg==
X-Gm-Message-State: ACrzQf2M6dWxygD1JxCQewJtk5txAU+ZNCl2Ug6yU3P8QmO3ShF2Wo0U
        zWgTOpOjKTKLM87+8EFWA+VziSf73r1Mq2sFMxAGsg==
X-Google-Smtp-Source: AMsMyM41pEI8QxZKAFnvkpDY27kfb/rp4+/Xhz+HCqWFG+54FENGbhuu3eqbSa6BkYB9PvPh4kAAKe2HmgunRWXDt4I=
X-Received: by 2002:a05:6830:827:b0:65a:9b2:cf7d with SMTP id
 t7-20020a056830082700b0065a09b2cf7dmr8819801ots.288.1664839164052; Mon, 03
 Oct 2022 16:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
 <69516f245575e5ed09b3e291bcd784e2@matoro.tk> <CAPv3WKc4LKtZoyW3ixXfhvvYeOTkNVfTSdGWWWuKZS2hmOStDQ@mail.gmail.com>
 <3cb296514a3078cf99e0ce62e3a0b8c4@matoro.tk>
In-Reply-To: <3cb296514a3078cf99e0ce62e3a0b8c4@matoro.tk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 4 Oct 2022 01:19:12 +0200
Message-ID: <CAPv3WKeG15sdu67tkZE0yk8mpYUXWKMtt6Qaokg1XCP8i+JDng@mail.gmail.com>
Subject: Re: [net-next] net: mvpp2: Add TX flow control support for jumbo frames
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, andrew@lunn.ch, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, jon@solid-run.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I didn't notice your email, it landed in my spam:/

pon., 3 pa=C5=BA 2022 o 16:24 matoro <matoro_mailinglist_kernel@matoro.tk>
napisa=C5=82(a):
>
> Sure thing Marcin.  Here's the whole log including u-boot.  I wonder if
> the DT has something to do with it?
>
> > [    6.388177] mvpp2 f2000000.ethernet: DT is too old, Flow control not
> > supported
>
> I am using the precompiled DT that SolidRun ships with their Ubuntu
> image:
> https://solidrun.atlassian.net/wiki/spaces/developer/pages/197493959/Clea=
rFog+CN9130+Base+Quick+Start+Guide
>
> $ sha256sum /boot/cn9130-cf-base.dtb
> 411ad5f9d9626dde04ad0623b7615822bf4ebd84cc4d05ed5540425c8d246ee6
> /boot/cn9130-cf-base.dtb
>
>
>
> BootROM - 2.03
> Starting CP-0 IOROM 1.07
> Booting from SPI NOR flash 1 (0x32)
> Found valid image at boot postion 0x000
> lNOTICE:  Starting binary extension
> NOTICE:  SVC: DEV ID: CN913x, FREQ Mode: 0x0
> NOTICE:  SVC: AVS work point changed from 0x2e5 to 0x2dd
> w/o ecc; strap value=3D0
> 4GB capacity; strap value=3D0
> mv_ddr: 14.0.0-g3f9b544 (Mar 22 2022 - 15:49:55)
> SSCG_EN
> Synopsys DDR43 PHY Firmware version: A-2017.11
> SNPS DDR: 1D training passed
> SNPS DDR: 2D training passed
> SNPS DDR: training completed
> dma memcmp pass
> mv_ddr: completed successfully
> NOTICE:  Cold boot
> NOTICE:  Booting Trusted Firmware
> NOTICE:  BL1: v2.3(release):v2.3-864-g1898bd0b0 (Marvell-devel-18.12.0)
> NOTICE:  BL1: Built : 15:49:55, Mar 22 2022
> NOTICE:  BL1: Booting BL2
> NOTICE:  BL2: v2.3(release):v2.3-864-g1898bd0b0 (Marvell-devel-18.12.0)
> NOTICE:  BL2: Built : 15:49:55, Mar 22 2022
> NOTICE:  SCP_BL2 contains 7 concatenated images
> NOTICE:  Skipping MG CP1 related image
> NOTICE:  Load image to CP0 MG
> NOTICE:  Loading MG image from address 0x403114c Size 0xe0f0 to MG at
> 0xf2100000
> NOTICE:  Skipping MSS CP3 related image
> NOTICE:  Skipping MSS CP2 related image
> NOTICE:  Skipping MSS CP1 related image
> NOTICE:  Load image to CP0 MSS AP0
> NOTICE:  Loading MSS image from addr. 0x4044930 Size 0x1cfc to MSS at
> 0xf2280000
> NOTICE:  Done
> NOTICE:  Load image to AP0 MSS
> NOTICE:  Loading MSS image from addr. 0x404662c Size 0x5400 to MSS at
> 0xf0580000
> NOTICE:  Done
> NOTICE:  BL1: Booting BL31
> lNOTICE:  BL31: v2.3(release):v2.3-864-g1898bd0b0
> (Marvell-devel-18.12.0)
> NOTICE:  BL31: Built : 15:49:55, Mar 22 2022
>
>
> U-Boot 2019.10-10.0.0-00016-gea54b74dd8 (Mar 22 2022 - 15:49:54 +0000)
>
> Model: SolidRun CN9130 based SOM ClearFog Base
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> SoC: cn9130-A1; AP807-B0; CP115-A0
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
> Clock:  CPU     2000 [MHz]
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
>          DDR     1200 [MHz]
> ERROR:   mrvl_sip_smc_handler: unhandled SMC (0x82000014)
>          FABRIC  1200 [MHz]
>          MSS     200  [MHz]
> LLC Enabled (Exclusive Mode)
> DRAM:  4 GiB
> Running in RAM - U-Boot at: 0x7fef1000
>                   Env at:    0x7ff9cd86
> Comphy chip #0:
> Comphy-0: SATA1
> Comphy-1: USB3_HOST0
> Comphy-2: SFI0          10.3125 Gbps
> Comphy-3: SGMII1        1.25 Gbps
> Comphy-4: USB3_HOST1
> Comphy-5: PEX2
> UTMI PHY 0 initialized to USB Host0
> UTMI PHY 1 initialized to USB Host1
> PCIE-0: Link down
> NAND:  0 MiB
> MMC:   sdhci@6e0000: 0, sdhci@780000: 1
> Loading Environment from SPI Flash...
> Bus spi@700680 CS0 address is not set correct.
> SF: Detected w25q64cv with page size 256 Bytes, erase size 4 KiB, total
> 8 MiB
> OK
> get_fdtfile_from_tlv_eeprom: could not identify carrier, defaulting to
> Clearfog Pro!
> Net:
> Error: mvpp2-0 address not set.
>
> Error: mvpp2-0 address not set.
>
> Error: mvpp2-1 address not set.
>
> Error: mvpp2-2 address not set.
> eth-1: mvpp2-0
> Error: mvpp2-1 address not set.
> , eth-1: mvpp2-1
> Error: mvpp2-2 address not set.
> , eth-1: mvpp2-2
> Hit any key to stop autoboot:  0
> Card did not respond to voltage select!
> switch to partitions #0, OK
> mmc0(part 0) is current device
> ** No partition table - mmc 0 **
> starting USB...
> Bus usb3@500000: Register 2000120 NbrPorts 2
> Starting the controller
> USB XHCI 1.00
> Bus usb3@510000: Register 2000120 NbrPorts 2
> Starting the controller
> USB XHCI 1.00
> scanning bus usb3@500000 for devices... 1 USB Device(s) found
> scanning bus usb3@510000 for devices... 1 USB Device(s) found
>         scanning usb for storage devices... 0 Storage Device(s) found
>
> Device 0: unknown device
> scanning bus for devices...
>    Device 0: (1:0) Vendor: ATA Prod.: Dogfish SSD 128G Rev: U032
>              Type: Hard Disk
>              Capacity: 122104.3 MB =3D 119.2 GB (250069680 x 512)
>
> Device 0: (1:0) Vendor: ATA Prod.: Dogfish SSD 128G Rev: U032
>              Type: Hard Disk
>              Capacity: 122104.3 MB =3D 119.2 GB (250069680 x 512)
> ... is now current device
> Scanning scsi 0:1...
> Found /boot/extlinux/extlinux.conf
> Retrieving file: /boot/extlinux/extlinux.conf
> 227 bytes read in 8 ms (27.3 KiB/s)
> 1:      arch
> Retrieving file: /boot/initramfs-linux.img
> 7340269 bytes read in 120 ms (58.3 MiB/s)
> Retrieving file: /boot/Image
> 41071104 bytes read in 636 ms (61.6 MiB/s)
> append: root=3DPARTUUID=3Ddb9d2d5d-01 rootfstype=3Dext4 rw
> console=3DttyS0,115200 mitigations=3Doff audit=3D0
> Retrieving file: /boot/cn9130-cf-base.dtb
> 22934 bytes read in 7 ms (3.1 MiB/s)
> ## Flattened Device Tree blob at 06f00000
>     Booting using the fdt blob at 0x6f00000
>     Loading Ramdisk to 7eed8000, end 7f5d80ed ... OK
>     Loading Device Tree to 000000007eecf000, end 000000007eed7995 ... OK
>
> Starting kernel ...
>
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd083]
> [    0.000000] Linux version 5.19.8-1-aarch64-ARCH (builduser@leming)
> (aarch64-unknown-linux-gnu-gcc (GCC) 12.1.0, GNU ld (GNU Binutils) 2.38)
> #1 SMP PREEMPT Thu Sep 8 18:20:33 MDT 2022
> [    0.000000] Machine model: SolidRun CN9130 based SOM Clearfog Base
> [    0.000000] efi: UEFI not found.
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000000000-0x00000000ffffffff]
> [    0.000000]   DMA32    empty
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
> [    0.000000]   node   0: [mem 0x0000000004000000-0x00000000041fffff]
> [    0.000000]   node   0: [mem 0x0000000004200000-0x00000000bfffffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000013fffffff]
> [    0.000000] Initmem setup node 0 [mem
> 0x0000000000000000-0x000000013fffffff]
> [    0.000000] cma: Reserved 64 MiB at 0x00000000bc000000
> [    0.000000] psci: probing for conduit method from DT.
> [    0.000000] psci: PSCIv1.1 detected in firmware.
> [    0.000000] psci: Using standard PSCI v0.2 function IDs
> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
> [    0.000000] psci: SMC Calling Convention v1.2
> [    0.000000] percpu: Embedded 21 pages/cpu s45480 r8192 d32344 u86016
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] CPU features: detected: Spectre-v2
> [    0.000000] CPU features: detected: Spectre-BHB
> [    0.000000] CPU features: kernel page table isolation forced OFF by
> mitigations=3Doff
> [    0.000000] CPU features: detected: ARM erratum 1742098
> [    0.000000] CPU features: detected: ARM errata 1165522, 1319367, or
> 1530923
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages:
> 1032192
> [    0.000000] Kernel command line: root=3DPARTUUID=3Ddb9d2d5d-01
> rootfstype=3Dext4 rw console=3DttyS0,115200 mitigations=3Doff audit=3D0
> [    0.000000] audit: disabled (until reboot)
> [    0.000000] Dentry cache hash table entries: 524288 (order: 10,
> 4194304 bytes, linear)
> [    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152
> bytes, linear)
> [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
> [    0.000000] software IO TLB: mapped [mem
> 0x00000000b8000000-0x00000000bc000000] (64MB)
> [    0.000000] Memory: 3931788K/4194304K available (19328K kernel code,
> 4140K rwdata, 9868K rodata, 6592K init, 946K bss, 196980K reserved,
> 65536K cma-reserved)
> [    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4,
> Nodes=3D1
> [    0.000000] rcu: Preemptible hierarchical RCU implementation.
> [    0.000000] rcu:     RCU restricting CPUs from NR_CPUS=3D64 to
> nr_cpu_ids=3D4.
> [    0.000000]  Trampoline variant of Tasks RCU enabled.
> [    0.000000]  Tracing variant of Tasks RCU enabled.
> [    0.000000] rcu: RCU calculated value of scheduler-enlistment delay
> is 100 jiffies.
> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=3D16,
> nr_cpu_ids=3D4
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] GIC: Adjusting CPU interface base to 0x00000000f022f000
> [    0.000000] Root IRQ handler: gic_handle_irq
> [    0.000000] GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:160, num:32)
> [    0.000000] GICv2m: range[mem 0xf0280000-0xf0280fff], SPI[160:191]
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:192, num:32)
> [    0.000000] GICv2m: range[mem 0xf0290000-0xf0290fff], SPI[192:223]
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:224, num:32)
> [    0.000000] GICv2m: range[mem 0xf02a0000-0xf02a0fff], SPI[224:255]
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:256, num:32)
> [    0.000000] GICv2m: range[mem 0xf02b0000-0xf02b0fff], SPI[256:287]
> [    0.000000] rcu: srcu_init: Setting srcu_struct sizes based on
> contention.
> [    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff
> max_cycles: 0x5c40939b5, max_idle_ns: 440795202646 ns
> [    0.000000] sched_clock: 56 bits at 25MHz, resolution 40ns, wraps
> every 4398046511100ns
> [    0.000202] Console: colour dummy device 80x25
> [    0.000226] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 50.00 BogoMIPS (lpj=3D25000)
> [    0.000232] pid_max: default: 32768 minimum: 301
> [    0.000317] LSM: Security Framework initializing
> [    0.000325] Yama: becoming mindful.
> [    0.000390] Mount-cache hash table entries: 8192 (order: 4, 65536
> bytes, linear)
> [    0.000401] Mountpoint-cache hash table entries: 8192 (order: 4,
> 65536 bytes, linear)
> [    0.000892] spectre-v4 mitigation disabled by command-line option
> [    0.001219] cblist_init_generic: Setting adjustable number of
> callback queues.
> [    0.001224] cblist_init_generic: Setting shift to 2 and lim to 1.
> [    0.001265] cblist_init_generic: Setting shift to 2 and lim to 1.
> [    0.001360] rcu: Hierarchical SRCU implementation.
> [    0.001363] rcu:     Max phase no-delay instances is 400.
> [    0.002428] EFI services will not be available.
> [    0.002659] smp: Bringing up secondary CPUs ...
> [    0.003156] Detected PIPT I-cache on CPU1
> [    0.003191] CPU1: Booted secondary processor 0x0000000001
> [0x410fd083]
> [    0.003704] Detected PIPT I-cache on CPU2
> [    0.003729] CPU2: Booted secondary processor 0x0000000100
> [0x410fd083]
> [    0.004235] Detected PIPT I-cache on CPU3
> [    0.004253] CPU3: Booted secondary processor 0x0000000101
> [0x410fd083]
> [    0.004295] smp: Brought up 1 node, 4 CPUs
> [    0.004300] SMP: Total of 4 processors activated.
> [    0.004303] CPU features: detected: 32-bit EL0 Support
> [    0.004305] CPU features: detected: 32-bit EL1 Support
> [    0.004308] CPU features: detected: CRC32 instructions
> [    0.004350] spectre-v2 mitigation disabled by command line option
> [    0.004350] spectre-v2 mitigation disabled by command line option
> [    0.004889] CPU: All CPU(s) started at EL2
> [    0.004910] alternatives: patching kernel code
> [    0.005597] devtmpfs: initialized
> [    0.007583] Registered cp15_barrier emulation handler
> [    0.007591] Registered setend emulation handler
> [    0.007683] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    0.007691] futex hash table entries: 1024 (order: 4, 65536 bytes,
> linear)
> [    0.008274] pinctrl core: initialized pinctrl subsystem
> [    0.008650] DMI not present or invalid.
> [    0.008966] NET: Registered PF_NETLINK/PF_ROUTE protocol family
> [    0.009458] DMA: preallocated 512 KiB GFP_KERNEL pool for atomic
> allocations
> [    0.009554] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA pool for
> atomic allocations
> [    0.009690] DMA: preallocated 512 KiB GFP_KERNEL|GFP_DMA32 pool for
> atomic allocations
> [    0.010088] thermal_sys: Registered thermal governor 'fair_share'
> [    0.010092] thermal_sys: Registered thermal governor 'bang_bang'
> [    0.010093] thermal_sys: Registered thermal governor 'step_wise'
> [    0.010096] thermal_sys: Registered thermal governor 'user_space'
> [    0.010097] thermal_sys: Registered thermal governor
> 'power_allocator'
> [    0.010449] cpuidle: using governor ladder
> [    0.010459] cpuidle: using governor menu
> [    0.010531] hw-breakpoint: found 6 breakpoint and 4 watchpoint
> registers.
> [    0.010583] ASID allocator initialised with 65536 entries
> [    0.010587] HugeTLB: can optimize 4095 vmemmap pages for
> hugepages-1048576kB
> [    0.010590] HugeTLB: can optimize 127 vmemmap pages for
> hugepages-32768kB
> [    0.010592] HugeTLB: can optimize 7 vmemmap pages for
> hugepages-2048kB
> [    0.010594] HugeTLB: can optimize 0 vmemmap pages for hugepages-64kB
> [    0.011139] Serial: AMBA PL011 UART driver
> [    0.024235] HugeTLB registered 1.00 GiB page size, pre-allocated 0
> pages
> [    0.024240] HugeTLB registered 32.0 MiB page size, pre-allocated 0
> pages
> [    0.024243] HugeTLB registered 2.00 MiB page size, pre-allocated 0
> pages
> [    0.024245] HugeTLB registered 64.0 KiB page size, pre-allocated 0
> pages
> [    0.024449] cryptd: max_cpu_qlen set to 1000
> [    0.041403] raid6: neonx8   gen()  5937 MB/s
> [    0.058436] raid6: neonx4   gen()  5799 MB/s
> [    0.075473] raid6: neonx2   gen()  4810 MB/s
> [    0.092512] raid6: neonx1   gen()  3484 MB/s
> [    0.109545] raid6: int64x8  gen()  3394 MB/s
> [    0.126579] raid6: int64x4  gen()  3298 MB/s
> [    0.143614] raid6: int64x2  gen()  3202 MB/s
> [    0.160652] raid6: int64x1  gen()  2430 MB/s
> [    0.160654] raid6: using algorithm neonx8 gen() 5937 MB/s
> [    0.177684] raid6: .... xor() 4129 MB/s, rmw enabled
> [    0.177686] raid6: using neon recovery algorithm
> [    0.177995] ACPI: Interpreter disabled.
> [    0.179417] ap0_sd_vccq: Bringing 3300000uV into 1800000-1800000uV
> [    0.179970] iommu: Default domain type: Translated
> [    0.179973] iommu: DMA domain TLB invalidation policy: strict mode
> [    0.180350] SCSI subsystem initialized
> [    0.180524] usbcore: registered new interface driver usbfs
> [    0.180545] usbcore: registered new interface driver hub
> [    0.180564] usbcore: registered new device driver usb
> [    0.180719] usb_phy_generic cp0_usb3_phy@0: dummy supplies not
> allowed for exclusive requests
> [    0.180819] usb_phy_generic cp0_usb3_phy@1: dummy supplies not
> allowed for exclusive requests
> [    0.181084] pps_core: LinuxPPS API ver. 1 registered
> [    0.181086] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
> Rodolfo Giometti <giometti@linux.it>
> [    0.181092] PTP clock support registered
> [    0.181201] EDAC MC: Ver: 3.0.0
> [    0.181764] FPGA manager framework
> [    0.181804] Advanced Linux Sound Architecture Driver Initialized.
> [    0.182060] NetLabel: Initializing
> [    0.182062] NetLabel:  domain hash size =3D 128
> [    0.182064] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
> [    0.182085] NetLabel:  unlabeled traffic allowed by default
> [    0.182158] vgaarb: loaded
> [    0.182327] clocksource: Switched to clocksource arch_sys_counter
> [    0.182463] VFS: Disk quotas dquot_6.6.0
> [    0.182484] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
> bytes)
> [    0.182628] pnp: PnP ACPI: disabled
> [    0.186174] NET: Registered PF_INET protocol family
> [    0.186296] IP idents hash table entries: 65536 (order: 7, 524288
> bytes, linear)
> [    0.187736] tcp_listen_portaddr_hash hash table entries: 2048 (order:
> 3, 32768 bytes, linear)
> [    0.187777] Table-perturb hash table entries: 65536 (order: 6, 262144
> bytes, linear)
> [    0.187784] TCP established hash table entries: 32768 (order: 6,
> 262144 bytes, linear)
> [    0.187890] TCP bind hash table entries: 32768 (order: 7, 524288
> bytes, linear)
> [    0.188093] TCP: Hash tables configured (established 32768 bind
> 32768)
> [    0.188194] MPTCP token hash table entries: 4096 (order: 4, 98304
> bytes, linear)
> [    0.188229] UDP hash table entries: 2048 (order: 4, 65536 bytes,
> linear)
> [    0.188271] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes,
> linear)
> [    0.188419] NET: Registered PF_UNIX/PF_LOCAL protocol family
> [    0.188662] RPC: Registered named UNIX socket transport module.
> [    0.188665] RPC: Registered udp transport module.
> [    0.188667] RPC: Registered tcp transport module.
> [    0.188669] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.188674] PCI: CLS 0 bytes, default 64
> [    0.188826] Trying to unpack rootfs image as initramfs...
> [    0.188831] Initramfs unpacking failed: invalid magic at start of
> compressed archive
> [    0.190588] Freeing initrd memory: 7168K
> [    0.190966] kvm [1]: IPA Size Limit: 44 bits
> [    0.191783] kvm [1]: vgic interrupt IRQ9
> [    0.191847] kvm [1]: Hyp mode initialized successfully
> [    0.192599] Initialise system trusted keyrings
> [    0.192719] workingset: timestamp_bits=3D46 max_order=3D20 bucket_orde=
r=3D0
> [    0.195134] zbud: loaded
> [    0.196164] NFS: Registering the id_resolver key type
> [    0.196177] Key type id_resolver registered
> [    0.196179] Key type id_legacy registered
> [    0.196224] nfs4filelayout_init: NFSv4 File Layout Driver
> Registering...
> [    0.196230] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver
> Registering...
> [    0.196241] ntfs3: Max link count 4000
> [    0.196243] ntfs3: Read-only LZX/Xpress compression included
> [    0.196360] SGI XFS with ACLs, security attributes, quota, no debug
> enabled
> [    0.217102] NET: Registered PF_ALG protocol family
> [    0.217110] xor: measuring software checksum speed
> [    0.218132]    8regs           :  9705 MB/sec
> [    0.219083]    32regs          : 10417 MB/sec
> [    0.220430]    arm64_neon      :  7358 MB/sec
> [    0.220432] xor: using function: 32regs (10417 MB/sec)
> [    0.220444] Key type asymmetric registered
> [    0.220446] Asymmetric key parser 'x509' registered
> [    0.220478] Block layer SCSI generic (bsg) driver version 0.4 loaded
> (major 242)
> [    0.220559] io scheduler mq-deadline registered
> [    0.220562] io scheduler kyber registered
> [    0.220577] io scheduler bfq registered
> [    0.227708] armada-ap806-pinctrl f06f4000.system-controller:pinctrl:
> registered pinctrl driver
> [    0.228139] armada-cp110-pinctrl f2440000.system-controller:pinctrl:
> registered pinctrl driver
> [    0.230774] IPMI message handler: version 39.2
> [    0.237186] mv_xor_v2 f0400000.xor: Marvell Version 2 XOR driver
> [    0.237487] mv_xor_v2 f0420000.xor: Marvell Version 2 XOR driver
> [    0.237762] mv_xor_v2 f0440000.xor: Marvell Version 2 XOR driver
> [    0.238024] mv_xor_v2 f0460000.xor: Marvell Version 2 XOR driver
> [    0.238535] mv_xor_v2 f26a0000.xor: Marvell Version 2 XOR driver
> [    0.238823] mv_xor_v2 f26c0000.xor: Marvell Version 2 XOR driver
> [    0.242700] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.243756] printk: console [ttyS0] disabled
> [    0.243794] f0512000.serial: ttyS0 at MMIO 0xf0512000 (irq =3D 22,
> base_baud =3D 12500000) is a 16550A
> [    1.465298] printk: console [ttyS0] enabled
> [    1.470256] msm_serial: driver initialized
> [    1.475252] omap_rng f2760000.trng: Random Number Generator ver.
> 203b34c
> [    1.475555] random: crng init done
> [    1.486591] ahci f2540000.sata: supply ahci not found, using dummy
> regulator
> [    1.493747] ahci f2540000.sata: supply phy not found, using dummy
> regulator
> [    1.501307] platform f2540000.sata:sata-port@0: supply target not
> found, using dummy regulator
> [    1.510453] platform f2540000.sata:sata-port@1: supply target not
> found, using dummy regulator
> [    1.519247] ahci f2540000.sata: masking port_map 0x3 -> 0x3
> [    1.524877] ahci f2540000.sata: AHCI 0001.0000 32 slots 2 ports 6
> Gbps 0x3 impl platform mode
> [    1.533444] ahci f2540000.sata: flags: 64bit ncq sntf led only pmp
> fbs pio slum part sxs
> [    1.542154] scsi host0: ahci
> [    1.545281] scsi host1: ahci
> [    1.548251] ata1: SATA max UDMA/133 mmio [mem 0xf2540000-0xf256ffff]
> port 0x100 irq 24
> [    1.556209] ata2: SATA max UDMA/133 mmio [mem 0xf2540000-0xf256ffff]
> port 0x180 irq 24
> [    1.566478] spi-nor spi2.0: s25fl064k (8192 Kbytes)
> [    1.572135] spi-nor spi2.1: unrecognized JEDEC id bytes: ff ff ff ff
> ff ff
> [    1.581463] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
> Driver
> [    1.588036] ehci-pci: EHCI PCI platform driver
> [    1.592518] ehci-platform: EHCI generic platform driver
> [    1.597842] ehci-orion: EHCI orion driver
> [    1.601940] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.608155] ohci-pci: OHCI PCI platform driver
> [    1.612633] ohci-platform: OHCI generic platform driver
> [    1.617957] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.624620] xhci-hcd f2500000.usb3: xHCI Host Controller
> [    1.630035] xhci-hcd f2500000.usb3: new USB bus registered, assigned
> bus number 1
> [    1.637608] xhci-hcd f2500000.usb3: hcc params 0x0a000990 hci version
> 0x100 quirks 0x0000000000010010
> [    1.646898] xhci-hcd f2500000.usb3: irq 25, io mem 0xf2500000
> [    1.652749] xhci-hcd f2500000.usb3: xHCI Host Controller
> [    1.658141] xhci-hcd f2500000.usb3: new USB bus registered, assigned
> bus number 2
> [    1.665667] xhci-hcd f2500000.usb3: Host supports USB 3.0 SuperSpeed
> [    1.672128] usb usb1: New USB device found, idVendor=3D1d6b,
> idProduct=3D0002, bcdDevice=3D 5.19
> [    1.680433] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,
> SerialNumber=3D1
> [    1.687688] usb usb1: Product: xHCI Host Controller
> [    1.692589] usb usb1: Manufacturer: Linux 5.19.8-1-aarch64-ARCH
> xhci-hcd
> [    1.699324] usb usb1: SerialNumber: f2500000.usb3
> [    1.704238] hub 1-0:1.0: USB hub found
> [    1.708023] hub 1-0:1.0: 1 port detected
> [    1.712124] usb usb2: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    1.720305] usb usb2: New USB device found, idVendor=3D1d6b,
> idProduct=3D0003, bcdDevice=3D 5.19
> [    1.728610] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,
> SerialNumber=3D1
> [    1.735908] usb usb2: Product: xHCI Host Controller
> [    1.740810] usb usb2: Manufacturer: Linux 5.19.8-1-aarch64-ARCH
> xhci-hcd
> [    1.747582] usb usb2: SerialNumber: f2500000.usb3
> [    1.752476] hub 2-0:1.0: USB hub found
> [    1.756298] hub 2-0:1.0: 1 port detected
> [    1.760519] xhci-hcd f2510000.usb3: xHCI Host Controller
> [    1.765972] xhci-hcd f2510000.usb3: new USB bus registered, assigned
> bus number 3
> [    1.773572] xhci-hcd f2510000.usb3: hcc params 0x0a000990 hci version
> 0x100 quirks 0x0000000000010010
> [    1.782897] xhci-hcd f2510000.usb3: irq 26, io mem 0xf2510000
> [    1.788748] xhci-hcd f2510000.usb3: xHCI Host Controller
> [    1.794185] xhci-hcd f2510000.usb3: new USB bus registered, assigned
> bus number 4
> [    1.801753] xhci-hcd f2510000.usb3: Host supports USB 3.0 SuperSpeed
> [    1.808196] usb usb3: New USB device found, idVendor=3D1d6b,
> idProduct=3D0002, bcdDevice=3D 5.19
> [    1.816548] usb usb3: New USB device strings: Mfr=3D3, Product=3D2,
> SerialNumber=3D1
> [    1.823842] usb usb3: Product: xHCI Host Controller
> [    1.828745] usb usb3: Manufacturer: Linux 5.19.8-1-aarch64-ARCH
> xhci-hcd
> [    1.835513] usb usb3: SerialNumber: f2510000.usb3
> [    1.840428] hub 3-0:1.0: USB hub found
> [    1.844252] hub 3-0:1.0: 1 port detected
> [    1.848347] usb usb4: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    1.856558] usb usb4: New USB device found, idVendor=3D1d6b,
> idProduct=3D0003, bcdDevice=3D 5.19
> [    1.864933] usb usb4: New USB device strings: Mfr=3D3, Product=3D2,
> SerialNumber=3D1
> [    1.869485] ata1: SATA link down (SStatus 0 SControl 300)
> [    1.872262] usb usb4: Product: xHCI Host Controller
> [    1.882580] usb usb4: Manufacturer: Linux 5.19.8-1-aarch64-ARCH
> xhci-hcd
> [    1.889315] usb usb4: SerialNumber: f2510000.usb3
> [    1.894302] hub 4-0:1.0: USB hub found
> [    1.898090] hub 4-0:1.0: 1 port detected
> [    1.902530] SPI driver max3421-hcd has no spi_device_id for
> maxim,max3421
> [    1.909552] usbcore: registered new interface driver uas
> [    1.914924] usbcore: registered new interface driver usb-storage
> [    1.921047] usbcore: registered new interface driver ums-alauda
> [    1.927056] usbcore: registered new interface driver ums-cypress
> [    1.933167] usbcore: registered new interface driver ums-datafab
> [    1.939226] usbcore: registered new interface driver ums_eneub6250
> [    1.945511] usbcore: registered new interface driver ums-freecom
> [    1.951559] usbcore: registered new interface driver ums-isd200
> [    1.957581] usbcore: registered new interface driver ums-jumpshot
> [    1.963759] usbcore: registered new interface driver ums-karma
> [    1.969697] usbcore: registered new interface driver ums-onetouch
> [    1.975845] usbcore: registered new interface driver ums-realtek
> [    1.981957] usbcore: registered new interface driver ums-sddr09
> [    1.987917] usbcore: registered new interface driver ums-sddr55
> [    1.993940] usbcore: registered new interface driver ums-usbat
> [    1.999882] usbcore: registered new interface driver
> usbserial_generic
> [    2.006526] usbserial: USB Serial support registered for generic
> [    2.013350] mousedev: PS/2 mouse device common for all mice
> [    2.019691] armada38x-rtc f2284000.rtc: registered as rtc0
> [    2.025219] armada38x-rtc f2284000.rtc: setting system clock to
> 2022-10-03T14:13:40 UTC (1664806420)
> [    2.034414] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    2.035519] pca953x 0-0020: supply vcc not found, using dummy
> regulator
> [    2.044901] ata2.00: ATA-9: Dogfish SSD 128GB, U0324A0, max UDMA/133
> [    2.047341] pca953x 0-0020: using no AI
> [    2.053657] ata2.00: 250069680 sectors, multi 1: LBA48 NCQ (depth 32)
> [    2.058882] gpio-2032 (pcie1.0-clkreq): hogged as input
> [    2.070265] gpio-2035 (pcie1.0-w-disable): hogged as output/low
> [    2.070825] ata2.00: configured for UDMA/133
> [    2.076528] gpio-2037 (usb3-current-limit): hogged as input
> [    2.080718] scsi 1:0:0:0: Direct-Access     ATA      Dogfish SSD 128G
> 4A0  PQ: 0 ANSI: 5
> [    2.086726] gpio-2038 (usb3-power): hogged as output/high
> [    2.094612] sd 1:0:0:0: Attached scsi generic sg0 type 0
> [    2.094699] sd 1:0:0:0: [sda] 250069680 512-byte logical blocks: (128
> GB/119 GiB)
> [    2.094742] sd 1:0:0:0: [sda] Write Protect is off
> [    2.094807] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    2.094885] sd 1:0:0:0: [sda] Preferred minimum I/O size 512 bytes
> [    2.101117] gpio-2043 (m.2 devslp): hogged as output/low
> [    2.109730]  sda: sda1
> [    2.114451] device-mapper: uevent: version 1.0.3
> [    2.117593] sd 1:0:0:0: [sda] Attached SCSI removable disk
> [    2.126541] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28)
> initialised: dm-devel@redhat.com
> [    2.160041] sdhci: Secure Digital Host Controller Interface driver
> [    2.166258] sdhci: Copyright(c) Pierre Ossman
> [    2.171073] Synopsys Designware Multimedia Card Interface Driver
> [    2.177713] sdhci-pltfm: SDHCI platform and OF driver helper
> [    2.184537] ledtrig-cpu: registered to indicate activity on CPUs
> [    2.191354] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
> [    2.197974] hid: raw HID events driver (C) Jiri Kosina
> [    2.203196] usbcore: registered new interface driver usbhid
> [    2.208797] usbhid: USB HID core driver
> [    2.214965] mmc0: SDHCI controller on f06e0000.sdhci [f06e0000.sdhci]
> using ADMA 64-bit
> [    2.216547] Initializing XFRM netlink socket
> [    2.227519] NET: Registered PF_INET6 protocol family
> [    2.235034] Segment Routing with IPv6
> [    2.238745] In-situ OAM (IOAM) with IPv6
> [    2.242743] mip6: Mobile IPv6
> [    2.245728] NET: Registered PF_PACKET protocol family
> [    2.250886] Key type dns_resolver registered
> [    2.255553] registered taskstats version 1
> [    2.259684] Loading compiled-in X.509 certificates
> [    2.264874] zswap: loaded using pool lzo/zbud
> [    2.269373] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating
> architecture page table helpers
> [    2.278745] Key type ._fscrypt registered
> [    2.281935] mmc0: new high speed MMC card at address 0001
> [    2.282776] Key type .fscrypt registered
> [    2.282778] Key type fscrypt-provisioning registered
> [    2.283203] Btrfs loaded, crc32c=3Dcrc32c-generic, zoned=3Dyes,
> fsverity=3Dno
> [    2.288552] mmcblk0: mmc0:0001 8GTF4R 7.28 GiB
> [    2.292472] Key type encrypted registered
> [    2.298442] mmcblk0boot0: mmc0:0001 8GTF4R 4.00 MiB
> [    2.318192] mmcblk0boot1: mmc0:0001 8GTF4R 4.00 MiB
> [    2.323939] mmcblk0rpmb: mmc0:0001 8GTF4R 512 KiB, chardev (508:0)
> [    2.695034] hw perfevents: enabled with armv8_cortex_a72 PMU driver,
> 7 counters available
> [    2.704629] gpio-59 (phy_reset): hogged as output/high
> [    2.710712] dw-pcie f2640000.pcie: error -ENXIO: IRQ index 1 not
> found
> [    2.717461] armada8k-pcie f2640000.pcie: host bridge
> /cp0/pcie@f2640000 ranges:
> [    2.724846] armada8k-pcie f2640000.pcie:      MEM
> 0x00e1000000..0x00e1efffff -> 0x00e1000000
> [    2.733353] armada8k-pcie f2640000.pcie: iATU unroll: disabled
> [    2.739214] armada8k-pcie f2640000.pcie: Detected iATU regions: 8
> outbound, 8 inbound
> [    3.747169] armada8k-pcie f2640000.pcie: Phy link never came up
> [    3.753178] armada8k-pcie f2640000.pcie: PCI host bridge to bus
> 0000:00
> [    3.759828] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    3.765340] pci_bus 0000:00: root bus resource [mem
> 0xe1000000-0xe1efffff]
> [    3.772265] pci 0000:00:00.0: [11ab:0110] type 01 class 0x060400
> [    3.778308] pci 0000:00:00.0: reg 0x10: [mem 0x00000000-0x000fffff]
> [    3.784658] pci 0000:00:00.0: supports D1 D2
> [    3.788949] pci 0000:00:00.0: PME# supported from D0 D1 D3hot
> [    3.795770] pci 0000:00:00.0: BAR 0: assigned [mem
> 0xe1000000-0xe10fffff]
> [    3.802596] pci 0000:00:00.0: PCI bridge to [bus 01-ff]
> [    4.473705] pcieport 0000:00:00.0: PME: Signaling with IRQ 40
> [    4.479636] pcieport 0000:00:00.0: AER: enabled with IRQ 40
> [    4.486184] ALSA device list:
> [    4.486870] xenon-sdhci f2780000.sdhci: Got CD GPIO
> [    4.489191]   No soundcards found.
> [    4.525254] mmc1: SDHCI controller on f2780000.sdhci [f2780000.sdhci]
> using ADMA 64-bit
> [    4.533361] md: Waiting for all devices to be available before
> autodetect
> [    4.540186] md: If you don't use raid, use raid=3Dnoautodetect
> [    4.545872] md: Autodetecting RAID arrays.
> [    4.549989] md: autorun ...
> [    4.552796] md: ... autorun DONE.
> [    4.561601] EXT4-fs (sda1): mounted filesystem with ordered data
> mode. Quota mode: none.
> [    4.569778] VFS: Mounted root (ext4 filesystem) on device 8:1.
> [    4.576093] devtmpfs: mounted
> [    4.580673] Freeing unused kernel memory: 6592K
> [    4.585297] Run /sbin/init as init process
> [    4.698838] systemd[1]: systemd 251.4-1-arch running in system mode
> (+PAM +AUDIT -SELINUX -APPARMOR -IMA +SMACK +SECCOMP +GCRYPT +GNUTLS
> +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD
> +LIBCRYPTSETUP +LIBFDISK +PCRE2 -PWQUALITY +P11KIT -QRENCODE +TPM2
> +BZIP2 +LZ4 +XZ +ZLIB +ZSTD -BPF_FRAMEWORK +XKBCOMMON +UTMP -SYSVINIT
> default-hierarchy=3Dunified)
> [    4.731341] systemd[1]: Detected architecture arm64.
> [    4.745135] systemd[1]: Hostname set to <matoro-router>.
> [    4.911352] systemd[1]: Queued start job for default target Graphical
> Interface.
> [    4.920621] systemd[1]: Created slice Slice /system/modprobe.
> [    4.935044] systemd[1]: Created slice Slice /system/serial-getty.
> [    4.949850] systemd[1]: Created slice User and Session Slice.
> [    4.963504] systemd[1]: Started Dispatch Password Requests to Console
> Directory Watch.
> [    4.981467] systemd[1]: Started Forward Password Requests to Wall
> Directory Watch.
> [    4.998687] systemd[1]: Set up automount Arbitrary Executable File
> Formats File System Automount Point.
> [    5.017452] systemd[1]: Reached target Local Encrypted Volumes.
> [    5.031413] systemd[1]: Reached target Local Integrity Protected
> Volumes.
> [    5.047430] systemd[1]: Reached target Path Units.
> [    5.059385] systemd[1]: Reached target Remote File Systems.
> [    5.073382] systemd[1]: Reached target Slice Units.
> [    5.085396] systemd[1]: Reached target Swaps.
> [    5.096396] systemd[1]: Reached target Local Verity Protected
> Volumes.
> [    5.112543] systemd[1]: Listening on Device-mapper event daemon
> FIFOs.
> [    5.130539] systemd[1]: Listening on Process Core Dump Socket.
> [    5.148401] systemd[1]: Journal Audit Socket was skipped because of a
> failed condition check (ConditionSecurity=3Daudit).
> [    5.159616] systemd[1]: Listening on Journal Socket (/dev/log).
> [    5.173655] systemd[1]: Listening on Journal Socket.
> [    5.185669] systemd[1]: Listening on Network Service Netlink Socket.
> [    5.200682] systemd[1]: Listening on udev Control Socket.
> [    5.214543] systemd[1]: Listening on udev Kernel Socket.
> [    5.230249] systemd[1]: Mounting Huge Pages File System...
> [    5.244122] systemd[1]: Mounting POSIX Message Queue File System...
> [    5.260224] systemd[1]: Mounting Kernel Debug File System...
> [    5.272586] systemd[1]: Kernel Trace File System was skipped because
> of a failed condition check (ConditionPathExists=3D/sys/kernel/tracing).
> [    5.287506] systemd[1]: Mounting Temporary Directory /tmp...
> [    5.302363] systemd[1]: Starting Create List of Static Device
> Nodes...
> [    5.319351] systemd[1]: Starting Load Kernel Module configfs...
> [    5.334459] systemd[1]: Starting Load Kernel Module drm...
> [    5.348346] systemd[1]: Starting Load Kernel Module fuse...
> [    5.357927] fuse: init (API version 7.36)
> [    5.365516] systemd[1]: File System Check on Root Device was skipped
> because of a failed condition check (ConditionPathIsReadWrite=3D!/).
> [    5.380864] systemd[1]: Starting Journal Service...
> [    5.393334] systemd[1]: Load Kernel Modules was skipped because all
> trigger condition checks failed.
> [    5.404535] systemd[1]: Starting Generate network units from Kernel
> command line...
> [    5.424415] systemd[1]: Starting Remount Root and Kernel File
> Systems...
> [    5.439545] systemd[1]: Repartition Root Disk was skipped because all
> trigger condition checks failed.
> [    5.451012] systemd[1]: Starting Apply Kernel Variables...
> [    5.466417] systemd[1]: Starting Coldplug All udev Devices...
> [    5.482544] systemd[1]: Started Journal Service.
> [    5.491733] EXT4-fs (sda1): re-mounted. Quota mode: none.
> [    5.652783] systemd-journald[242]: Received client request to flush
> runtime journal.
> [    6.122456] cfg80211: Loading compiled-in X.509 certificates for
> regulatory database
> [    6.189473] cfg80211: Loaded X.509 cert 'sforshee:
> 00b28ddf47aef9cea7'
> [    6.198886] platform regulatory.0: Direct firmware load for
> regulatory.db failed with error -2
> [    6.207830] cfg80211: failed to load regulatory.db
> [    6.347602] sbsa-gwdt f0610000.watchdog: Initialized with 10s timeout
> @ 25000000 Hz, action=3D0.
> [    6.367343] hwmon hwmon0: temp1_input not attached to any thermal
> zone
> [    6.388177] mvpp2 f2000000.ethernet: DT is too old, Flow control not
> supported

Please apply https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
.git/commit/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi?h=3Dv6.0&id=3D605=
23583b07cddc474522cdd94523cad9b80c5a9
onto your baseline, retry and let us know.

Best regards,
Marcin
