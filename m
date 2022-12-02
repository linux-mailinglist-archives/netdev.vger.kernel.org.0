Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC16640E12
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbiLBS7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbiLBS7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:59:06 -0500
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBAC9A4D2
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:59:05 -0800 (PST)
Date:   Fri, 02 Dec 2022 18:58:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1670007543; x=1670266743;
        bh=3UPH6Yo6Bmoq/RT0odvlIBTUu0jV8PlgB7Amt+nGrsg=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=MXOu8N6QwGO3jvM5cETV8AbDyQjxmLcsjX6YHhlHnEvAw0S/XRPy8RbxJubrDCOjM
         qzv7Nyk8JoCJkQjEiA8xNFSO4OlVV3wZOhfgIvj8ynZs8/iGIvGK9lh6vREU64YtRP
         nribk7PjQOZEVlDUzSfDsjTZAfxnWEa+eMsQUOEPI59/CDKslWtk5JZRpNLj21ovbP
         J4nGpboD/nJRUx//DfJIyKYZOEYkLpiuQdIkSbc0cYHRXohcsiyw5i3y9Xg/ff0YZS
         W5FUSsOLonPpbytkX3djtLHe5bcPrVibWHEWQ5/fwjGppQb9jPHLZTWAkIhFx25Ll1
         GAkZwqTd1Jo1A==
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Tim Joneson <tim_joneson@pm.me>
Subject: eth: igb: RTNL assertion failed on igb_resume
Message-ID: <7dHNwI6WnTACGVS6Gl7-ip2gk15x8DePuQBiGIdYJxrTjtS-tEq0zYMcC-3STel7LU-tDewibuZKzOMCo_Yuftwe29JMnqnszgDJ6KVoI58=@pm.me>
Feedback-ID: 62960239:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My igb driver fails on an RTNL assertion when resuming, see below dmesg and=
 lspci excerpts. I searched the lists and the trace seems very similar to a=
n issue in alx that was solved earlier:
https://lore.kernel.org/netdev/20220928181236.1053043-1-kuba@kernel.org/T/

Is this list the correct place to report this or should I file a report in =
BugZilla?

Best regards,
Tim

RTNL: assertion failed at net/core/dev.c (2891)
WARNING: CPU: 1 PID: 277 at net/core/dev.c:2891 netif_set_real_num_tx_queue=
s+0x1a3/0x1c0
Modules linked in: qrtr bluetooth jitterentropy_rng sha512_ssse3 sha512_gen=
eric drbg ansi_cprng ecdh_generic rfkill ecc binfmt_misc nft_nat intel_rapl=
_msr intel_rapl_common nft_masq intel_pmc_core_pltdrv intel_pmc_core nft_ch=
ain_nat nf_nat nls_ascii nls_cp437 vfat nft_limit fat nfnetlink_log x86_pkg=
_temp_thermal i915 nft_log mei_hdcp mei_wdt intel_powerclamp kvm_intel drm_=
buddy drm_display_helper kvm cec irqbypass rc_core rapl intel_cstate intel_=
uncore ttm pcspkr iTCO_wdt mei_me ee1004 intel_pmc_bxt iTCO_vendor_support =
cdc_acm mei drm_kms_helper nft_ct intel_pch_thermal nf_conntrack ie31200_ed=
ac nf_defrag_ipv6 nf_defrag_ipv4 button acpi_pad evdev sg nf_tables ftsteut=
ates watchdog nfnetlink coretemp msr drm fuse efi_pstore configfs ip_tables=
 x_tables autofs4 ext4 crc16 mbcache jbd2 btrfs blake2b_generic zstd_compre=
ss efivarfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xo=
r async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath line=
ar md_mod
 dm_mod hid_generic sd_mod t10_pi usbhid crc64_rocksoft_generic hid crc64_r=
ocksoft crc_t10dif crct10dif_generic crc64 crct10dif_pclmul crct10dif_commo=
n crc32_pclmul crc32c_intel ghash_clmulni_intel ahci libahci e1000e igb xhc=
i_pci xhci_hcd i2c_algo_bit dca aesni_intel crypto_simd libata cryptd i2c_i=
801 i2c_smbus ptp usbcore scsi_mod pps_core scsi_common wmi usb_common vide=
o
CPU: 1 PID: 277 Comm: kworker/1:2 Not tainted 6.0.0-4-amd64 #1  Debian 6.0.=
8-1
Hardware name: FUJITSU /D3644-B1, BIOS V5.0.0.13 R1.26.0 for D3644-B1x     =
               03/08/2021
Workqueue: pm pm_runtime_work
RIP: 0010:netif_set_real_num_tx_queues+0x1a3/0x1c0
Code: 00 b4 25 01 00 0f 85 d9 fe ff ff ba 4b 0b 00 00 48 c7 c6 fc 94 7e a6 =
48 c7 c7 a0 b3 75 a6 c6 05 e0 b3 25 01 01 e8 17 03 1f 00 <0f> 0b e9 b3 fe f=
f ff b8 ea ff ff ff e9 8f fe ff ff 66 66 2e 0f 1f
RSP: 0018:ffffbadc40997cf0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff9fc78894c000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffffa677ed52 RDI: 00000000ffffffff
RBP: 0000000000000004 R08: 0000000000000000 R09: ffffbadc40997b78
R10: 0000000000000003 R11: ffffffffa6ed22a8 R12: 0000000000000001
R13: 0000000000000004 R14: ffff9fc70a32d1f0 R15: ffff9fc78894c000
FS:  0000000000000000(0000) GS:ffff9fca5e480000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdad97641dc CR3: 0000000016810006 CR4: 00000000003706e0
Call Trace:
 <TASK>
 __igb_open+0x3f4/0x660 [igb]
 __igb_resume+0x136/0x240 [igb]
 ? __pci_enable_wake+0x7e/0xb0
 ? pci_pm_restore_noirq+0xc0/0xc0
 __rpm_callback+0x41/0x170
 rpm_callback+0x35/0x70
 ? pci_pm_restore_noirq+0xc0/0xc0
 rpm_resume+0x5e5/0x810
 ? _raw_spin_unlock_irq+0x1b/0x35
 ? pcie_pme_work_fn+0x1c4/0x2b0
 pm_runtime_work+0x6c/0xa0
 process_one_work+0x1c4/0x380
 worker_thread+0x4d/0x380
 ? _raw_spin_lock_irqsave+0x23/0x50
 ? rescuer_thread+0x3a0/0x3a0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>
---[ end trace 0000000000000000 ]---

Device:

02:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connect=
ion (rev 03)
Flags: bus master, fast devsel, latency 0, IRQ 17, IOMMU group 9
Memory at 8f900000 (32-bit, non-prefetchable) [size=3D1M]
Memory at 8fa00000 (32-bit, non-prefetchable) [size=3D16K]
Expansion ROM at 8f800000 [disabled] [size=3D1M]
Capabilities: [40] Power Management version 3
Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
Capabilities: [70] MSI-X: Enable+ Count=3D5 Masked-
Capabilities: [a0] Express Endpoint, MSI 00
Capabilities: [100] Advanced Error Reporting
Capabilities: [140] Device Serial Number 6c-b3-11-ff-ff-52-95-01
Capabilities: [1a0] Transaction Processing Hints
Kernel driver in use: igb
Kernel modules: igb

