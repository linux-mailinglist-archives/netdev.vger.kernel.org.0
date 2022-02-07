Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FEA4AC843
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236707AbiBGSGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242356AbiBGR7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:59:54 -0500
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9A0C0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:59:51 -0800 (PST)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nH8Im-000EZe-R8; Mon, 07 Feb 2022 18:59:48 +0100
Received: from [2001:1620:50ce:1969:7551:c966:b4bb:22e]
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1nH8Im-000N6O-OJ; Mon, 07 Feb 2022 18:59:48 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
Date:   Mon, 7 Feb 2022 18:59:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
Content-Language: en-US
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
In-Reply-To: <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>
> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>> On 2/5/22 12:14, Thomas Kupper wrote:
>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>> On 2/5/22 04:06, Thomas Kupper wrote:
>>>> Reloading the module and specify the dyndbg option to get some
>>>> additional debug output.
>>>>
>>>> I'm adding Shyam to the thread, too, as I'm not familiar with the
>>>> configuration for this chip.
>>>>
>>> Right after boot:
>>>
>>> [    5.352977] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>> [    5.354198] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>> ...
>>> [    5.382185] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>>> [    5.426931] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>> ...
>>> [    9.701637] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>> [    9.701679] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>> [    9.701715] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>> [    9.738191] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>> [    9.738219] amd-xgbe 0000:06:00.2 enp6s0f2: starting I2C
>>> ...
>>> [   10.742622] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox
>>> command did not complete
>>> [   10.742710] amd-xgbe 0000:06:00.2 enp6s0f2: firmware mailbox reset
>>> performed
>>> [   10.750813] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [   10.768366] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [   10.768371] amd-xgbe 0000:06:00.2 enp6s0f2: fixed PHY configuration
>>>
>>> Then after 'ifconfig enp6s0f2 up':
>>>
>>> [  189.184928] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>> [  189.191828] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [  189.191863] amd-xgbe 0000:06:00.2 enp6s0f2: CL73 AN disabled
>>> [  189.191894] amd-xgbe 0000:06:00.2 enp6s0f2: CL37 AN disabled
>>> [  189.196338] amd-xgbe 0000:06:00.2 enp6s0f2: starting PHY
>>> [  189.198792] amd-xgbe 0000:06:00.2 enp6s0f2: 10GbE SFI mode set
>>> [  189.212036] genirq: Flags mismatch irq 69. 00000000 (enp6s0f2-pcs)
>>> vs. 00000000 (enp6s0f2-pcs)
>>> [  189.221700] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>>> [  189.231051] amd-xgbe 0000:06:00.2 enp6s0f2: phy powered off
>>> [  189.231054] amd-xgbe 0000:06:00.2 enp6s0f2: stopping I2C
>>>
>> Please ensure that the ethtool msglvl is on for drv and probe. I was
>> expecting to see some additional debug messages that I don't see here.
>>
>> Also, if you can provide the lspci output for the device (using -nn and
>> -vv) that might be helpful as well.
>>
>> Shyam will be the best one to understand what is going on here.
> On some other platforms, we have seen similar kind of problems getting
> reported. There is a fix sent for validation.
>
> The root cause is that removal of xgbe driver is causing interrupt storm
> on the MP2 device (Sensor Fusion Hub).
>
> Shall submit a fix soon to upstream once the validation is done, you may
> give it a try with that and see if that helps.
>
> Thanks,
> Shyam
>
>> Thanks,
>> Tom

Shyam, I will check the git logs for the relevant commit then from time 
to time.
Looking at the code diff from OPNsense and the latest Linux kernel I 
assumed that there would much more to do then fix a irq strom (but I 
have no idea about the inner working of the kernel).

Nevermind: Setting the 'msglvl 0x3' with ethtool the following info can 
be found in dmesg:

Running : $ ifconfig enp6s0f2 up
SIOCSIFFLAGS: Invalid argument

... and 'dmesg':

[   55.177447] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0: cpu=0, node=0
[   55.177456] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0: 
dma_regs=00000000d11bf3f1, dma_irq=74, tx=00000000dd57b5c4, 
rx=00000000d73e70f8
[   55.177464] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1: cpu=1, node=0
[   55.177467] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1: 
dma_regs=000000000d972dd7, dma_irq=75, tx=00000000573bcff8, 
rx=000000003d9a6f65
[   55.177473] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2: cpu=2, node=0
[   55.177476] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2: 
dma_regs=0000000046f71179, dma_irq=76, tx=00000000897116c9, 
rx=0000000004ba17e7
[   55.177480] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0 - Tx ring:
[   55.177502] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=00000000794657ba, 
rdesc_dma=0x000000010fad8000, rdata=0000000008ace7d8, node=0
[   55.177507] amd-xgbe 0000:06:00.2 enp6s0f2: channel-0 - Rx ring:
[   55.177523] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=000000009313d9b3, 
rdesc_dma=0x0000000114538000, rdata=00000000510e3b77, node=0
[   55.177527] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1 - Tx ring:
[   55.177543] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=00000000d26d9194, 
rdesc_dma=0x000000010a774000, rdata=00000000b9419829, node=0
[   55.177547] amd-xgbe 0000:06:00.2 enp6s0f2: channel-1 - Rx ring:
[   55.177564] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=0000000007bf60dd, 
rdesc_dma=0x000000010fb84000, rdata=00000000aa48e8c0, node=0
[   55.177568] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2 - Tx ring:
[   55.177584] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=00000000e7e6c52e, 
rdesc_dma=0x000000010fa2a000, rdata=0000000017b5d85c, node=0
[   55.177587] amd-xgbe 0000:06:00.2 enp6s0f2: channel-2 - Rx ring:
[   55.177603] amd-xgbe 0000:06:00.2 enp6s0f2: rdesc=000000000898fbf4, 
rdesc_dma=0x0000000101f08000, rdata=00000000aded7d4c, node=0
[   55.182366] amd-xgbe 0000:06:00.2 enp6s0f2: TXq0 mapped to TC0
[   55.182381] amd-xgbe 0000:06:00.2 enp6s0f2: TXq1 mapped to TC1
[   55.182388] amd-xgbe 0000:06:00.2 enp6s0f2: TXq2 mapped to TC2
[   55.182395] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO0 mapped to RXq0
[   55.182400] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO1 mapped to RXq0
[   55.182405] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO2 mapped to RXq0
[   55.182410] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO3 mapped to RXq1
[   55.182414] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO4 mapped to RXq1
[   55.182418] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO5 mapped to RXq1
[   55.182423] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO6 mapped to RXq2
[   55.182427] amd-xgbe 0000:06:00.2 enp6s0f2: PRIO7 mapped to RXq2
[   55.182473] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Tx hardware queues, 
21760 byte fifo per queue
[   55.182501] amd-xgbe 0000:06:00.2 enp6s0f2: 3 Rx hardware queues, 
21760 byte fifo per queue
[   55.182544] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled for RXq0
[   55.182550] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled for RXq1
[   55.182556] amd-xgbe 0000:06:00.2 enp6s0f2: flow control enabled for RXq2
[   56.178946] amd-xgbe 0000:06:00.2 enp6s0f2: SFP detected:
[   56.178954] amd-xgbe 0000:06:00.2 enp6s0f2:   vendor: MikroTik
[   56.178958] amd-xgbe 0000:06:00.2 enp6s0f2:   part number: S+AO0005
[   56.178961] amd-xgbe 0000:06:00.2 enp6s0f2:   revision level: 1.0
[   56.178963] amd-xgbe 0000:06:00.2 enp6s0f2:   serial number: 
STST050B1900001

Then running '$ rmmod amd_xgbe' produced the following dmesg output:

[  504.272482] ------------[ cut here ]------------
[  504.272489] remove_proc_entry: removing non-empty directory 'irq/72', 
leaking at least 'enp6s0f2-i2c'
[  504.272500] WARNING: CPU: 0 PID: 803 at fs/proc/generic.c:715 
remove_proc_entry+0x196/0x1b0
[  504.272525] Modules linked in: nls_iso8859_1 intel_rapl_msr 
intel_rapl_common snd_hda_intel edac_mce_amd snd_intel_dspcfg 
snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_hwdep kvm snd_pcm rapl 
snd_timer snd_rn_pci_acp3x snd k10temp efi_pstore soundcore 
snd_pci_acp3x ccp mac_hid sch_fq_codel msr drm ip_tables x_tables 
autofs4 btrfs blake2b_generic zstd_compress raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
libcrc32c raid1 raid0 multipath linear crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel crypto_simd cryptd amd_xgbe(-) xhci_pci 
igb i2c_piix4 i2c_amd_mp2_pci xhci_pci_renesas nvme dca i2c_algo_bit 
nvme_core video spi_amd
[  504.272603] CPU: 0 PID: 803 Comm: rmmod Not tainted 5.17.0-rc2-tk #8
[  504.272608] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  504.272612] RIP: 0010:remove_proc_entry+0x196/0x1b0
[  504.272619] Code: a8 1d de 92 48 85 c0 48 8d 90 78 ff ff ff 48 0f 45 
c2 49 8b 54 24 78 4c 8b 80 a0 00 00 00 48 8b 92 a0 00 00 00 e8 28 53 81 
00 <0f> 0b e9 44 ff ff ff e8 6e bd 87 00 66 66 2e 0f 1f 84 00 00 00 00
[  504.272623] RSP: 0018:ffffa22a810b7b88 EFLAGS: 00010282
[  504.272627] RAX: 0000000000000000 RBX: ffff8d8c8022ccc0 RCX: 
0000000000000000
[  504.272630] RDX: 0000000000000001 RSI: ffffffff92dbc031 RDI: 
00000000ffffffff
[  504.272632] RBP: ffffa22a810b7bb8 R08: 0000000000000000 R09: 
ffffa22a810b7978
[  504.272635] R10: ffffa22a810b7970 R11: ffffffff93155f48 R12: 
ffff8d8c90dc0540
[  504.272637] R13: ffff8d8c90dc05c0 R14: 0000000000000049 R15: 
0000000000000049
[  504.272639] FS:  00007fb60c99b400(0000) GS:ffff8d8caae00000(0000) 
knlGS:0000000000000000
[  504.272643] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  504.272645] CR2: 00007f86e9192f68 CR3: 0000000111b46000 CR4: 
00000000003506f0
[  504.272648] Call Trace:
[  504.272650]  <TASK>
[  504.272656]  unregister_irq_proc+0xe4/0x110
[  504.272664]  free_desc+0x2e/0x70
[  504.272669]  irq_free_descs+0x50/0x80
[  504.272674]  irq_domain_free_irqs+0x16b/0x1c0
[  504.272678]  __msi_domain_free_irqs+0xf1/0x160
[  504.272683]  msi_domain_free_irqs_descs_locked+0x20/0x50
[  504.272687]  pci_msi_teardown_msi_irqs+0x49/0x50
[  504.272692]  pci_disable_msix.part.0+0xff/0x160
[  504.272695]  pci_free_irq_vectors+0x45/0x60
[  504.272699]  xgbe_pci_remove+0x24/0x40 [amd_xgbe]
[  504.272717]  pci_device_remove+0x39/0xa0
[  504.272724]  __device_release_driver+0x181/0x250
[  504.272731]  driver_detach+0xd3/0x120
[  504.272736]  bus_remove_driver+0x59/0xd0
[  504.272739]  driver_unregister+0x31/0x50
[  504.272743]  pci_unregister_driver+0x40/0x90
[  504.272748]  xgbe_pci_exit+0x15/0x20 [amd_xgbe]
[  504.272766]  xgbe_mod_exit+0x9/0x8b0 [amd_xgbe]
[  504.272784]  __do_sys_delete_module.constprop.0+0x183/0x290
[  504.272791]  ? syscall_exit_to_user_mode+0x27/0x50
[  504.272799]  __x64_sys_delete_module+0x12/0x20
[  504.272804]  do_syscall_64+0x5c/0xc0
[  504.272809]  ? irqentry_exit+0x33/0x40
[  504.272813]  ? exc_page_fault+0x89/0x180
[  504.272818]  ? asm_exc_page_fault+0x8/0x30
[  504.272822]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  504.272828] RIP: 0033:0x7fb60caca8eb
[  504.272833] Code: 73 01 c3 48 8b 0d 45 e5 0e 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 15 e5 0e 00 f7 d8 64 89 01 48
[  504.272836] RSP: 002b:00007ffd82036228 EFLAGS: 00000206 ORIG_RAX: 
00000000000000b0
[  504.272840] RAX: ffffffffffffffda RBX: 00007fb60e79b760 RCX: 
00007fb60caca8eb
[  504.272843] RDX: 000000000000000a RSI: 0000000000000800 RDI: 
00007fb60e79b7c8
[  504.272845] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[  504.272847] R10: 00007fb60cb62ac0 R11: 0000000000000206 R12: 
00007ffd82036480
[  504.272850] R13: 00007ffd820368b6 R14: 00007fb60e79b2a0 R15: 
00007fb60e79b760
[  504.272855]  </TASK>
[  504.272857] ---[ end trace 0000000000000000 ]---
[  504.272917] ------------[ cut here ]------------
[  504.272919] remove_proc_entry: removing non-empty directory 'irq/73', 
leaking at least 'enp6s0f2-pcs'
[  504.272930] WARNING: CPU: 0 PID: 803 at fs/proc/generic.c:715 
remove_proc_entry+0x196/0x1b0
[  504.272938] Modules linked in: nls_iso8859_1 intel_rapl_msr 
intel_rapl_common snd_hda_intel edac_mce_amd snd_intel_dspcfg 
snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_hwdep kvm snd_pcm rapl 
snd_timer snd_rn_pci_acp3x snd k10temp efi_pstore soundcore 
snd_pci_acp3x ccp mac_hid sch_fq_codel msr drm ip_tables x_tables 
autofs4 btrfs blake2b_generic zstd_compress raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
libcrc32c raid1 raid0 multipath linear crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel crypto_simd cryptd amd_xgbe(-) xhci_pci 
igb i2c_piix4 i2c_amd_mp2_pci xhci_pci_renesas nvme dca i2c_algo_bit 
nvme_core video spi_amd
[  504.272998] CPU: 0 PID: 803 Comm: rmmod Tainted: G W         
5.17.0-rc2-tk #8
[  504.273002] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  504.273004] RIP: 0010:remove_proc_entry+0x196/0x1b0
[  504.273009] Code: a8 1d de 92 48 85 c0 48 8d 90 78 ff ff ff 48 0f 45 
c2 49 8b 54 24 78 4c 8b 80 a0 00 00 00 48 8b 92 a0 00 00 00 e8 28 53 81 
00 <0f> 0b e9 44 ff ff ff e8 6e bd 87 00 66 66 2e 0f 1f 84 00 00 00 00
[  504.273012] RSP: 0018:ffffa22a810b7b88 EFLAGS: 00010282
[  504.273015] RAX: 0000000000000000 RBX: ffff8d8c8022ccc0 RCX: 
0000000000000000
[  504.273018] RDX: 0000000000000001 RSI: ffffffff92dbc031 RDI: 
00000000ffffffff
[  504.273020] RBP: ffffa22a810b7bb8 R08: 0000000000000000 R09: 
ffffa22a810b7978
[  504.273022] R10: ffffa22a810b7970 R11: ffffffff93155f48 R12: 
ffff8d8c8b8676c0
[  504.273024] R13: ffff8d8c8b867740 R14: 000000000000004a R15: 
000000000000004a
[  504.273027] FS:  00007fb60c99b400(0000) GS:ffff8d8caae00000(0000) 
knlGS:0000000000000000
[  504.273030] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  504.273032] CR2: 00007f86e9192f68 CR3: 0000000111b46000 CR4: 
00000000003506f0
[  504.273035] Call Trace:
[  504.273036]  <TASK>
[  504.273039]  unregister_irq_proc+0xe4/0x110
[  504.273044]  free_desc+0x2e/0x70
[  504.273049]  irq_free_descs+0x50/0x80
[  504.273053]  irq_domain_free_irqs+0x16b/0x1c0
[  504.273058]  __msi_domain_free_irqs+0xf1/0x160
[  504.273064]  msi_domain_free_irqs_descs_locked+0x20/0x50
[  504.273070]  pci_msi_teardown_msi_irqs+0x49/0x50
[  504.273074]  pci_disable_msix.part.0+0xff/0x160
[  504.273079]  pci_free_irq_vectors+0x45/0x60
[  504.273082]  xgbe_pci_remove+0x24/0x40 [amd_xgbe]
[  504.273098]  pci_device_remove+0x39/0xa0
[  504.273103]  __device_release_driver+0x181/0x250
[  504.273107]  driver_detach+0xd3/0x120
[  504.273110]  bus_remove_driver+0x59/0xd0
[  504.273113]  driver_unregister+0x31/0x50
[  504.273116]  pci_unregister_driver+0x40/0x90
[  504.273121]  xgbe_pci_exit+0x15/0x20 [amd_xgbe]
[  504.273136]  xgbe_mod_exit+0x9/0x8b0 [amd_xgbe]
[  504.273151]  __do_sys_delete_module.constprop.0+0x183/0x290
[  504.273156]  ? syscall_exit_to_user_mode+0x27/0x50
[  504.273161]  __x64_sys_delete_module+0x12/0x20
[  504.273165]  do_syscall_64+0x5c/0xc0
[  504.273168]  ? irqentry_exit+0x33/0x40
[  504.273172]  ? exc_page_fault+0x89/0x180
[  504.273176]  ? asm_exc_page_fault+0x8/0x30
[  504.273179]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  504.273184] RIP: 0033:0x7fb60caca8eb
[  504.273187] Code: 73 01 c3 48 8b 0d 45 e5 0e 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 15 e5 0e 00 f7 d8 64 89 01 48
[  504.273189] RSP: 002b:00007ffd82036228 EFLAGS: 00000206 ORIG_RAX: 
00000000000000b0
[  504.273192] RAX: ffffffffffffffda RBX: 00007fb60e79b760 RCX: 
00007fb60caca8eb
[  504.273194] RDX: 000000000000000a RSI: 0000000000000800 RDI: 
00007fb60e79b7c8
[  504.273196] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000000
[  504.273198] R10: 00007fb60cb62ac0 R11: 0000000000000206 R12: 
00007ffd82036480
[  504.273200] R13: 00007ffd820368b6 R14: 00007fb60e79b2a0 R15: 
00007fb60e79b760
[  504.273204]  </TASK>
[  504.273205] ---[ end trace 0000000000000000 ]---
[  504.925023] irq 31: nobody cared (try booting with the "irqpoll" option)
[  504.932518] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G W         
5.17.0-rc2-tk #8
[  504.932524] Hardware name: Deciso B.V. DEC2700 - OPNsense 
Appliance/Netboard-A10 Gen.3, BIOS 05.32.50.0012-A10.20 11/15/2021
[  504.932526] Call Trace:
[  504.932529]  <IRQ>
[  504.932533]  dump_stack_lvl+0x4c/0x63
[  504.932542]  dump_stack+0x10/0x12
[  504.932545]  __report_bad_irq+0x3a/0xaf
[  504.932550]  note_interrupt.cold+0xb/0x60
[  504.932554]  ? __this_cpu_preempt_check+0x13/0x20
[  504.932560]  handle_irq_event+0x71/0x80
[  504.932567]  handle_fasteoi_irq+0x95/0x1e0
[  504.932572]  __common_interrupt+0x6e/0x110
[  504.932577]  common_interrupt+0xbd/0xe0
[  504.932581]  </IRQ>
[  504.932582]  <TASK>
[  504.932584]  asm_common_interrupt+0x1e/0x40
[  504.932588] RIP: 0010:cpuidle_enter_state+0xdf/0x380
[  504.932595] Code: ff e8 e5 88 73 ff 80 7d d7 00 74 17 9c 58 0f 1f 44 
00 00 f6 c4 02 0f 85 82 02 00 00 31 ff e8 d8 9e 7a ff fb 66 0f 1f 44 00 
00 <45> 85 ff 0f 88 1a 01 00 00 49 63 d7 4c 89 f1 48 2b 4d c8 48 8d 04
[  504.932599] RSP: 0018:ffffa22a800e3e68 EFLAGS: 00000246
[  504.932604] RAX: ffff8d8caaf00000 RBX: 0000000000000002 RCX: 
000000000000001f
[  504.932607] RDX: 0000000000000000 RSI: ffffffff92dbc031 RDI: 
ffffffff92dcab7f
[  504.932609] RBP: ffffa22a800e3ea0 R08: 000000758fe062ac R09: 
000000754b94ae72
[  504.932611] R10: 0000000000000001 R11: ffff8d8caaf2fd84 R12: 
ffff8d8c933f7000
[  504.932613] R13: ffffffff9326e3c0 R14: 000000758fe062ac R15: 
0000000000000002
[  504.932618]  ? cpuidle_enter_state+0xbb/0x380
[  504.932624]  cpuidle_enter+0x2e/0x40
[  504.932628]  do_idle+0x203/0x290
[  504.932633]  cpu_startup_entry+0x20/0x30
[  504.932637]  start_secondary+0x118/0x150
[  504.932642]  secondary_startup_64_no_verify+0xd5/0xdb
[  504.932650]  </TASK>
[  504.932651] handlers:
[  504.935191] [<00000000dbc7353a>] amd_mp2_irq_isr [i2c_amd_mp2_pci]
[  504.942102] Disabling IRQ #31


Cheers
Thomas

