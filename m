Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B07154FA4
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 01:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgBGAPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 19:15:49 -0500
Received: from mta-out1.inet.fi ([62.71.2.226]:52660 "EHLO julia1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgBGAPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 19:15:49 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2020 19:15:46 EST
Received: from [192.168.1.134] (84.248.30.195) by julia1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E3B5CC70003EA6F; Fri, 7 Feb 2020 02:09:22 +0200
Subject: Re: [PATCH] NET: Realtek depency chain r8169 -> realtec -> libphy
 fixed.
To:     Heiner Kallweit <hkallweit1@gmail.com>, Lauri Jakku <lja@iki.fi>,
        nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
References: <20200206185152.2427-1-lja@iki.fi>
 <a00e09f3-4f79-5ce8-9f45-c0f8717446e2@gmail.com>
 <357bc619-457d-8470-abcc-282641fbe22d@gmail.com>
 <f607cc60-48d7-8b35-41d6-361af163fc8e@gmail.com>
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Message-ID: <65291ea5-bf0e-8408-8f65-0d746ae4048f@pp.inet.fi>
Date:   Fri, 7 Feb 2020 02:09:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <f607cc60-48d7-8b35-41d6-361af163fc8e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-02-07 00:36, Heiner Kallweit wrote:
> On 06.02.2020 23:20, Lauri Jakku wrote:
>> On 2020-02-06 23:56, Heiner Kallweit wrote:
>>> On 06.02.2020 19:51, Lauri Jakku wrote:
>>>>   * Added soft depency from realtec phy to libphy.
>>>>
>>>> [   39.953438] Generic PHY r8169-200:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
>>>> [   39.957413] ------------[ cut here ]------------
>>>> [   39.957414] read_page callback not available, PHY driver not loaded?
>>>> [   39.957458] WARNING: CPU: 3 PID: 3896 at drivers/net/phy/phy-core.c:700 __phy_read_page+0x3f/0x50 [libphy]
>>>> [   39.957459] Modules linked in: cmac algif_hash algif_skcipher af_alg bnep nls_iso8859_1 nls_cp437 vfat fat squashfs loop videobuf2_vmalloc videobuf2_memops snd_usb_audio videobuf2_v4l2 amdgpu videobuf2_common snd_usbmidi_lib videodev snd_rawmidi snd_seq_device mc btusb btrtl btbcm btintel mousedev input_leds joydev
>>>> bluetooth gpu_sched snd_hda_codec_realtek i2c_algo_bit ttm ecdh_generic snd_hda_codec_generic snd_hda_codec_hdmi rfkill ecc drm_kms_helper ledtrig_audio snd_hda_intel drm snd_intel_dspcfg snd_hda_codec agpgart snd_hda_core syscopyarea sysfillrect sysimgblt snd_hwdep fb_sys_fops snd_pcm snd_timer r8169 snd soundcore eda
>>>> c_mce_amd sp5100_tco kvm_amd i2c_piix4 realtek libphy ccp wmi_bmof ppdev rng_core k10temp kvm irqbypass parport_pc evdev parport mac_hid wmi pcspkr acpi_cpufreq uinput crypto_user ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ohci_pci pata_atiixp ata_generic pata_acpi firewire_ohci ahci pata_jmicron
>>>> [   39.957483]  firewire_core libahci crc_itu_t libata scsi_mod ehci_pci ehci_hcd ohci_hcd floppy
>>>> [   39.957488] CPU: 3 PID: 3896 Comm: NetworkManager Not tainted 5.5.0-2-MANJARO-usb-mod-v4 #1
>>>> [   39.957489] Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F8l 07/15/2010
>>>> [   39.957494] RIP: 0010:__phy_read_page+0x3f/0x50 [libphy]
>>>> [   39.957496] Code: c0 74 05 e9 33 77 3d e9 80 3d cd e3 00 00 00 74 06 b8 a1 ff ff ff c3 48 c7 c7 50 0c 63 c0 c6 05 b7 e3 00 00 01 e8 33 70 86 e8 <0f> 0b eb e3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00
>>>> [   39.957497] RSP: 0018:ffffa459ca3fb3b0 EFLAGS: 00010282
>>>> [   39.957498] RAX: 0000000000000000 RBX: 0000000000006662 RCX: 0000000000000000
>>>> [   39.957499] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 00000000ffffffff
>>>> [   39.957499] RBP: ffff9c91b46c3800 R08: 000000000000047a R09: 0000000000000001
>>>> [   39.957500] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9c91b5a8a8c0
>>>> [   39.957500] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
>>>> [   39.957501] FS:  00007ff199d38d80(0000) GS:ffff9c91b7cc0000(0000) knlGS:0000000000000000
>>>> [   39.957502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [   39.957503] CR2: 00007f907f428ff8 CR3: 00000001ed122000 CR4: 00000000000006e0
>>>> [   39.957503] Call Trace:
>>>> [   39.957511]  phy_select_page+0x28/0x50 [libphy]
>>>> [   39.957518]  phy_write_paged+0x18/0x50 [libphy]
>>>> [   39.957523]  rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169]
>>>> [   39.957526]  rtl8169_init_phy+0x2c/0xb0 [r8169]
>>>> [   39.957529]  rtl_open+0x3b2/0x570 [r8169]
>>>> [   39.957533]  __dev_open+0xe0/0x170
>>>> [   39.957535]  __dev_change_flags+0x188/0x1e0
>>>> [   39.957537]  dev_change_flags+0x21/0x60
>>>> [   39.957539]  do_setlink+0x78a/0xf90
>>>> [   39.957544]  ? kernel_init_free_pages+0x6d/0x90
>>>> [   39.957546]  ? prep_new_page+0x46/0xd0
>>>> [   39.957548]  ? cpumask_next+0x16/0x20
>>>> [   39.957550]  ? __snmp6_fill_stats64.isra.0+0x66/0x110
>>>> [   39.957553]  __rtnl_newlink+0x5d1/0x9a0
>>>> [   39.957563]  rtnl_newlink+0x44/0x70
>>>> [   39.957564]  rtnetlink_rcv_msg+0x137/0x3c0
>>>> [   39.957566]  ? rtnl_calcit.isra.0+0x120/0x120
>>>> [   39.957568]  netlink_rcv_skb+0x75/0x140
>>>> [   39.957570]  netlink_unicast+0x199/0x240
>>>> [   39.957572]  netlink_sendmsg+0x243/0x480
>>>> [   39.957575]  sock_sendmsg+0x5e/0x60
>>>> [   39.957576]  ____sys_sendmsg+0x21b/0x290
>>>> [   39.957577]  ? copy_msghdr_from_user+0xe1/0x160
>>>> [   39.957580]  ___sys_sendmsg+0x9e/0xe0
>>>> [   39.957583]  ? addrconf_sysctl_forward+0x12b/0x270
>>>> [   39.957585]  __sys_sendmsg+0x81/0xd0
>>>> [   39.957588]  do_syscall_64+0x4e/0x150
>>>> [   39.957591]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> [   39.957593] RIP: 0033:0x7ff19af247ed
>>>> [   39.957594] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a 53 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 7e 53 f8 ff 48
>>>> [   39.957595] RSP: 002b:00007ffd570ac710 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
>>>> [   39.957596] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007ff19af247ed
>>>> [   39.957596] RDX: 0000000000000000 RSI: 00007ffd570ac750 RDI: 000000000000000c
>>>> [   39.957597] RBP: 0000562f3d390090 R08: 0000000000000000 R09: 0000000000000000
>>>> [   39.957597] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
>>>> [   39.957598] R13: 00007ffd570ac8b0 R14: 00007ffd570ac8ac R15: 0000000000000000
>>>> [   39.957601] ---[ end trace f2cccff3f7fdfb28 ]---
>>>>
>>>> Signed-off-by: Lauri Jakku <lja@iki.fi>
>>> This patch is not correct for several reasons, most important one being that realtek.ko
>>> has a hard dependency on libphy already. In your case supposedly r8169.ko is in
>>> initramfs but realtek.ko is not. This needs to be changed, then the error should be gone.
>> Yeah, I tried to make a depency chain that would load realtek.ko before probing
>>
>> at r8169 driver.
>>
> This soft dependency is included in r8169 already. Just if r8169.ko is in initramfs then it
> can't load realtek.ko if it's not in initramfs.
>> Should i make realtek.ko as build-in to kernel, or how one enforces module to initramfs ?
>>
> Check mkinitcpio.conf. Some distributions may have own tools for configuring initramfs.
> Ubuntu has lsinitramfs for checking what's included in a particular initramfs file.
>
I saw that there is no MODULE_SOFTDEP done, witch I think triggers the mechanism

to load realtek.ko (i put in in initramfs now, hopefully). I'm not sure what does the

code at r8169_main.c:


       /* Some tools for creating an initramfs don't consider softdeps, then

         * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
         * PHY driver is used that doesn't work with most chip versions.
         */
        if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
                dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
                return -ENOENT;
        }

Trigger module loading without this patch ?

I just noticed, that the realtek.ko is loaded, and libphy when this happens. The

   rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169] is the reason


@MinistryOfSillyWalk realtek]$ lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 Host Bridge
00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (external gfx0 port A)
00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RX780/RD790 PCI to PCI bridge (PCI express gpp port D)
00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port E)
00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] RD790 PCI to PCI bridge (PCI express gpp port F)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB OHCI1 Controller
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB OHCI1 Controller
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller (rev 3a)
00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 IDE Controller
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 LPC host controller
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI Bridge
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] (rev e7)
01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590]

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 03)

04:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02)
04:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev 02)
05:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link)

Boot messages:
   13.265943] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[   13.282902] Linux agpgart interface v0.103
[   13.284129] libphy: r8169: probed
[   13.284312] r8169 0000:02:00.0 eth0: RTL8168d/8111d, 00:24:1d:12:e6:4a, XID 281, IRQ 28
[   13.284315] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[   13.284391] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[   13.288945] libphy: r8169: probed
[   13.289340] r8169 0000:03:00.0 eth1: RTL8168d/8111d, 00:24:1d:12:e6:1a, XID 281, IRQ 29
[   13.289346] r8169 0000:03:00.0 eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[   13.799058] r8169 0000:03:00.0 enp3s0: renamed from eth1
[   13.828781] r8169 0000:02:00.0 enp2s0: renamed from eth0
Note, no link status messages at all.
...
...
...
same boot continues:
[   42.549753] Generic PHY r8169-200:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
[   42.555180] ------------[ cut here ]------------
[   42.555184] read_page callback not available, PHY driver not loaded?
[   42.555276] WARNING: CPU: 2 PID: 614 at drivers/net/phy/phy-core.c:700 __phy_read_page+0x3f/0x50 [libphy]
[   42.555279] Modules linked in: cmac algif_hash algif_skcipher af_alg bnep nls_iso8859_1 nls_cp437 vfat fat squashfs loop snd_usb_audio snd_usbmidi_lib amdgpu snd_rawmidi snd_seq_device ses
 enclosure snd_hda_codec_realtek btusb snd_hda_codec_generic snd_hda_codec_hdmi btrtl btbcm scsi_transport_sas btintel ledtrig_audio joydev input_leds mousedev snd_hda_intel bluetooth snd_int
el_dspcfg snd_hda_codec gpu_sched snd_hda_core ecdh_generic rfkill i2c_algo_bit ecc ttm snd_hwdep drm_kms_helper snd_pcm snd_timer snd drm soundcore agpgart r8169 syscopyarea sysfillrect real
tek sysimgblt fb_sys_fops edac_mce_amd libphy kvm_amd sp5100_tco wmi_bmof ccp i2c_piix4 k10temp ppdev rng_core kvm irqbypass parport_pc evdev parport mac_hid pcspkr wmi acpi_cpufreq uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc uinput crypto_user ip_tables x_tables ext4 uas crc32c_generic usb_storage crc16 mbcache jbd2 hid_generic usbhid 
hid sr_mod cdrom sd_mod ohci_pci ata_generic
[   42.555356]  pata_acpi pata_atiixp firewire_ohci ahci libahci firewire_core pata_jmicron crc_itu_t libata ehci_pci ehci_hcd scsi_mod ohci_hcd floppy
[   42.555375] CPU: 2 PID: 614 Comm: NetworkManager Not tainted 5.5.0-2-MANJARO #1
[   42.555378] Hardware name: Gigabyte Technology Co., Ltd. GA-MA790FXT-UD5P/GA-MA790FXT-UD5P, BIOS F8l 07/15/2010
[   42.555400] RIP: 0010:__phy_read_page+0x3f/0x50 [libphy]
[   42.555406] Code: c0 74 05 e9 33 c7 29 d5 80 3d cd e3 00 00 00 74 06 b8 a1 ff ff ff c3 48 c7 c7 50 bc 76 c0 c6 05 b7 e3 00 00 01 e8 33 c0 72 d4 <0f> 0b eb e3 66 66 2e 0f 1f 84 00 00 00 00 
00 66 90 0f 1f 44 00 00
[   42.555409] RSP: 0018:ffffa82d80c4b3b0 EFLAGS: 00010282
[   42.555413] RAX: 0000000000000000 RBX: 0000000000006662 RCX: 0000000000000000
[   42.555416] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 00000000ffffffff
[   42.555419] RBP: ffff8bf8f507b800 R08: 000000000000049c R09: 0000000000000001
[   42.555421] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8bf8f55368c0
[   42.555423] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
[   42.555427] FS:  00007f7ddf021d80(0000) GS:ffff8bf8f7c80000(0000) knlGS:0000000000000000
[   42.555430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.555433] CR2: 00007f04077024f0 CR3: 000000020acaa000 CR4: 00000000000006e0
[   42.555435] Call Trace:
[   42.555460]  phy_select_page+0x28/0x50 [libphy]
[   42.555484]  phy_write_paged+0x18/0x50 [libphy]
[   42.555501]  rtl8168d_1_hw_phy_config+0x1c8/0x1f0 [r8169]
[   42.555512]  rtl8169_init_phy+0x2c/0xb0 [r8169]
[   42.555524]  rtl_open+0x3b2/0x570 [r8169]
[   42.555534]  __dev_open+0xe0/0x170
[   42.555543]  __dev_change_flags+0x188/0x1e0
[   42.555550]  dev_change_flags+0x21/0x60
[   42.555557]  do_setlink+0x78a/0xf90
[   42.555573]  ? get_page_from_freelist+0xf03/0x1170
[   42.555580]  ? cpumask_next+0x16/0x20
[   42.555587]  ? __snmp6_fill_stats64.isra.0+0x66/0x110
[   42.555598]  __rtnl_newlink+0x5d1/0x9a0
[   42.555639]  rtnl_newlink+0x44/0x70
[   42.555646]  rtnetlink_rcv_msg+0x137/0x3c0
[   42.555654]  ? rtnl_calcit.isra.0+0x120/0x120
[   42.555660]  netlink_rcv_skb+0x75/0x140
[   42.555668]  netlink_unicast+0x199/0x240
[   42.555675]  netlink_sendmsg+0x243/0x480
[   42.555684]  sock_sendmsg+0x5e/0x60
[   42.555690]  ____sys_sendmsg+0x21b/0x290
[   42.555695]  ? copy_msghdr_from_user+0xe1/0x160
[   42.555704]  ___sys_sendmsg+0x9e/0xe0
[   42.555715]  ? addrconf_sysctl_forward+0x12b/0x270
[   42.555727]  __sys_sendmsg+0x81/0xd0
[   42.555738]  do_syscall_64+0x4e/0x150
[   42.555746]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   42.555751] RIP: 0033:0x7f7de020d7ed
[   42.555755] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 4a 53 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 7e 53 f8 ff 48
[   42.555758] RSP: 002b:00007ffd5c44eaf0 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
[   42.555762] RAX: ffffffffffffffda RBX: 000000000000000c RCX: 00007f7de020d7ed
[   42.555764] RDX: 0000000000000000 RSI: 00007ffd5c44eb30 RDI: 000000000000000c
[   42.555766] RBP: 000055eb7f0a9070 R08: 0000000000000000 R09: 0000000000000000
[   42.555768] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[   42.555771] R13: 00007ffd5c44ec90 R14: 00007ffd5c44ec8c R15: 0000000000000000
[   42.555782] ---[ end trace 298788e12455aa61 ]---


reloading works with as root from console :

modprobe -r r8169

modprobe r8169


[ 1484.645337] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[ 1484.647936] libphy: r8169: probed
[ 1484.648377] r8169 0000:02:00.0 eth0: RTL8168d/8111d, 00:24:1d:12:e6:4a, XID 281, IRQ 28
[ 1484.648379] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[ 1484.649562] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[ 1484.651141] r8169 0000:02:00.0 enp2s0: renamed from eth0
[ 1484.655018] libphy: r8169: probed
[ 1484.664064] r8169 0000:03:00.0 eth0: RTL8168d/8111d, 00:24:1d:12:e6:1a, XID 281, IRQ 29
[ 1484.664066] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[ 1484.665256] r8169 0000:03:00.0 enp3s0: renamed from eth0
[ 1484.686164] RTL8211B Gigabit Ethernet r8169-200:00: attached PHY driver [RTL8211B Gigabit Ethernet] (mii_bus:phy_addr=r8169-200:00, irq=IGNORE)
[ 1484.834685] r8169 0000:02:00.0 enp2s0: Link is Down
[ 1484.845887] RTL8211B Gigabit Ethernet r8169-300:00: attached PHY driver [RTL8211B Gigabit Ethernet] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
[ 1484.994935] r8169 0000:03:00.0 enp3s0: Link is Down
[ 1487.070753] r8169 0000:03:00.0 enp3s0: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1487.070782] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready


so the first time PHY driver is missing .. the realtek.ko .. but i wonder cause it is on the loaded modules list during boot ?

>>>> ---
>>>>  drivers/net/phy/realtek.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
>>>> index f5fa2fff3ddc..4a1d4342c71e 100644
>>>> --- a/drivers/net/phy/realtek.c
>>>> +++ b/drivers/net/phy/realtek.c
>>>> @@ -54,6 +54,7 @@
>>>>  MODULE_DESCRIPTION("Realtek PHY driver");
>>>>  MODULE_AUTHOR("Johnson Leung");
>>>>  MODULE_LICENSE("GPL");
>>>> +MODULE_SOFTDEP("pre: libphy");
>>>>  
>>>>  static int rtl821x_read_page(struct phy_device *phydev)
>>>>  {
>>>>
-- 
Br,
Lauri J.

