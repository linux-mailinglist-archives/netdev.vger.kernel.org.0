Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E4E5FBA21
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 20:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiJKSIK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Oct 2022 14:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJKSIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 14:08:09 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD61330561
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 11:08:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 3151214112E;
        Tue, 11 Oct 2022 20:08:05 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id tBkVkymJXjA2; Tue, 11 Oct 2022 20:08:05 +0200 (CEST)
Received: from tglase.lan.tarent.de (tglase.lan.tarent.de [172.26.3.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 17504140694;
        Tue, 11 Oct 2022 20:08:05 +0200 (CEST)
Received: by tglase.lan.tarent.de (Postfix, from userid 2339)
        id D2C2B221395; Tue, 11 Oct 2022 20:08:04 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase.lan.tarent.de (Postfix) with ESMTP id B231A220BDD;
        Tue, 11 Oct 2022 20:08:04 +0200 (CEST)
Date:   Tue, 11 Oct 2022 20:08:04 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Haye.Haehne@telekom.de
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <daddd9a0-eb6c-6b93-8831-ddc45685234f@tarent.de>
Message-ID: <380a7ee-ef4b-8afc-edc0-809b955499c7@tarent.de>
References: <FR2P281MB2959684780DC911876D2465590419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <FR2P281MB2959EBC7E6CE9A1A8D01A01F90419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
 <cd3867e0-b645-c6cd-3464-29ffb142de5e@tarent.de> <FR2P281MB29597303CA232BBEF6E328DF90479@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <d0755144-c038-8332-1084-b62cc9c6499@tarent.de> <FR2P281MB2959289F36EFC955105DD1DF90469@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
 <bd8c8a7f-8a8e-3992-d631-d2f74d38483@tarent.de> <FR2P281MB2959185CA486AB5A5868C4D490529@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <1b62f51-a017-e21-31f3-2ccd72b6c8ad@tarent.de> <FR2P281MB29596B8EA9AC8940C5A95B7690559@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
 <daddd9a0-eb6c-6b93-8831-ddc45685234f@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Oct 2022, Thorsten Glaser wrote:

> I finally managed to reproduce it, and this is the full trace, from virsh console
> output from an emulated serial console. (Took multiple test runs of 10 minutes
> each to crash it still…)

I reduced the queue size and it crashed faster and interestingly enough
with a slightly different message, involving a nōn-canonical address, if
that helps in figuring out the case…

[515605.047121] general protection fault, probably for non-canonical address 0x1e8aad2910e48f51: 0000 [#1] SMP PTI
[515605.052590] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     5.10.0-18-amd64 #1 Debian 5.10.140-1
[515605.057952] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[515605.062691] RIP: 0010:kmem_cache_alloc_node+0xa4/0x220
[515605.065694] Code: 00 48 85 c9 0f 84 63 01 00 00 83 fd ff 74 0f 48 8b 09 48 c1 e9 36 39 cd 0f 85 4f 01 00 00 41 8b 4c 24 28 49 8b 3c 24 48 01 c1 <48> 8b 19 48 89 ce 49 33 9c 24 b8 00 00 00 48 8d 4a 01 48 0f ce 48
[515605.075754] RSP: 0018:ffffab8f40003c88 EFLAGS: 00010202
[515605.078817] RAX: 1e8aad2910e48ee1 RBX: 00000000ffffffff RCX: 1e8aad2910e48f51
[515605.082977] RDX: 0000000000300995 RSI: 0000000000000a20 RDI: 0000000000035af0
[515605.087135] RBP: 00000000ffffffff R08: ffff901e3ac35af0 R09: 0000000000000600
[515605.091288] R10: 0000000000001800 R11: 0000000000000600 R12: ffff901e3ac43900
[515605.095423] R13: ffffffffa2cea3b6 R14: 0000000000000a20 R15: ffff901e3ac43900
[515605.099588] FS:  0000000000000000(0000) GS:ffff901e3ac00000(0000) knlGS:0000000000000000
[515605.104247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[515605.107527] CR2: 00007fbae55d0030 CR3: 00000001039fe000 CR4: 0000000000000ef0
[515605.111697] Call Trace:
[515605.113383]  <IRQ>
[515605.114836]  __alloc_skb+0x46/0x200
[515605.117058]  __napi_alloc_skb+0x3f/0xf0
[515605.119439]  page_to_skb+0x61/0x370 [virtio_net]
[515605.122216]  receive_buf+0xdfe/0x1a20 [virtio_net]
[515605.125057]  ? inet_gro_receive+0x23a/0x300
[515605.127603]  ? gro_normal_one+0x31/0xa0
[515605.129980]  virtnet_poll+0x14e/0x45a [virtio_net]
[515605.132819]  net_rx_action+0x145/0x3e0
[515605.135076]  __do_softirq+0xc5/0x279
[515605.137342]  asm_call_irq_on_stack+0x12/0x20
[515605.139925]  </IRQ>
[515605.141423]  do_softirq_own_stack+0x37/0x50
[515605.143983]  irq_exit_rcu+0x92/0xc0
[515605.146190]  common_interrupt+0x74/0x130
[515605.148609]  asm_common_interrupt+0x1e/0x40
[515605.151137] RIP: 0010:native_safe_halt+0xe/0x20
[515605.153863] Code: 00 f0 80 48 02 20 48 8b 00 a8 08 75 c0 e9 77 ff ff ff cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d a6 39 51 00 fb f4 <c3> cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 e9 07 00 00
[515605.164167] RSP: 0018:ffffffffa3c03eb8 EFLAGS: 00000202
[515605.167227] RAX: ffffffffa2ef6390 RBX: 0000000000000000 RCX: ffff901e3ac30a40
[515605.171395] RDX: 0000000007a1f1c6 RSI: ffffffffa3c03e50 RDI: 0001d4f111e9f981
[515605.175562] RBP: ffffffffa3c13940 R08: 0000000000000001 R09: 0000000000002000
[515605.179763] R10: 0000000000002000 R11: 0000000000000000 R12: 0000000000000000
[515605.183929] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[515605.188125]  ? __sched_text_end+0x6/0x6
[515605.190498]  default_idle+0xa/0x20
[515605.192665]  default_idle_call+0x3c/0xd0
[515605.195103]  do_idle+0x20c/0x2b0
[515605.197165]  cpu_startup_entry+0x19/0x20
[515605.199609]  start_kernel+0x574/0x599
[515605.201920]  secondary_startup_64_no_verify+0xb0/0xbb
[515605.204910] Modules linked in: sch_janz(OE) xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype nft_compat x_tables nf_tables libcrc32c br_netfilter bridge stp llc nfnetlink overlay nfsd auth_rpcgss nfs_acl nfs lockd grace nfs_ssc fscache sunrpc loop kvm_intel kvm drm_kms_helper irqbypass cec drm virtio_balloon joydev virtio_rng rng_core evdev serio_raw pcspkr qemu_fw_cfg button ext4 crc16 mbcache jbd2 crc32c_generic hid_generic usbhid hid virtio_net net_failover virtio_blk failover uhci_hcd ehci_hcd ata_generic usbcore ata_piix libata psmouse crc32c_intel scsi_mod virtio_pci virtio_ring virtio floppy i2c_piix4 usb_common
[515605.239110] ---[ end trace 2913cde92d19dc0b ]---
[515605.241867] RIP: 0010:kmem_cache_alloc_node+0xa4/0x220
[515605.243441] BUG: Bad page state in process tc  pfn:147d98
[515605.244897] Code: 00 48 85 c9 0f 84 63 01 00 00 83 fd ff 74 0f 48 8b 09 48 c1 e9 36 39 cd 0f 85 4f 01 00 00 41 8b 4c 24 28 49 8b 3c 24 48 01 c1 <48> 8b 19 48 89 ce 49 33 9c 24 b8 00 00 00 48 8d 4a 01 48 0f ce 48
[515605.244898] RSP: 0018:ffffab8f40003c88 EFLAGS: 00010202
[515605.244901] RAX: 1e8aad2910e48ee1 RBX: 00000000ffffffff RCX: 1e8aad2910e48f51
[515605.244902] RDX: 0000000000300995 RSI: 0000000000000a20 RDI: 0000000000035af0
[515605.244911] RBP: 00000000ffffffff R08: ffff901e3ac35af0 R09: 0000000000000600
[515605.244913] R10: 0000000000001800 R11: 0000000000000600 R12: ffff901e3ac43900
[515605.244914] R13: ffffffffa2cea3b6 R14: 0000000000000a20 R15: ffff901e3ac43900
[515605.244916] FS:  0000000000000000(0000) GS:ffff901e3ac00000(0000) knlGS:0000000000000000
[515605.244918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[515605.244919] CR2: 00007fbae55d0030 CR3: 00000001039fe000 CR4: 0000000000000ef0
[515605.244925] Kernel panic - not syncing: Fatal exception in interrupt
[515605.343549] page:00000000a7ad6eb8 refcount:-7 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x147d98
[515605.353713] flags: 0x17ffffc0000000()
[515605.356764] raw: 0017ffffc0000000 dead000000000100 dead000000000122 0000000000000000
[515605.361568] raw: 0000000000000000 0000000000000000 fffffff9ffffffff 0000000000000000
[515605.366046] page dumped because: nonzero _refcount
[515605.368910] Modules linked in: sch_janz(OE) xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype nft_compat x_tables nf_tables libcrc32c br_netfilter bridge stp llc nfnetlink overlay nfsd auth_rpcgss nfs_acl nfs lockd grace nfs_ssc fscache sunrpc loop kvm_intel kvm drm_kms_helper irqbypass cec drm virtio_balloon joydev virtio_rng rng_core evdev serio_raw pcspkr qemu_fw_cfg button ext4 crc16 mbcache jbd2 crc32c_generic hid_generic usbhid hid virtio_net net_failover virtio_blk failover uhci_hcd ehci_hcd ata_generic usbcore ata_piix libata psmouse crc32c_intel scsi_mod virtio_pci virtio_ring virtio floppy i2c_piix4 usb_common
[515605.402912] CPU: 2 PID: 6951 Comm: tc Tainted: G      D    OE     5.10.0-18-amd64 #1 Debian 5.10.140-1
[515605.408258] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[515605.413046] Call Trace:
[515605.414753]  dump_stack+0x6b/0x83
[515605.416879]  bad_page.cold+0x63/0x94
[515605.419142]  get_page_from_freelist+0xc0b/0x1330
[515605.421924]  __alloc_pages_nodemask+0x161/0x310
[515605.424638]  kmalloc_large_node+0x3d/0x110
[515605.427157]  __kmalloc_node_track_caller+0x235/0x2a0
[515605.430130]  ? netlink_dump+0x9c/0x350
[515605.432503]  __alloc_skb+0x79/0x200
[515605.434686]  netlink_dump+0x9c/0x350
[515605.436948]  netlink_recvmsg+0x246/0x420
[515605.439424]  ____sys_recvmsg+0x87/0x180
[515605.441844]  ? flush_tlb_func_common.constprop.0+0x10f/0x1e0
[515605.445141]  ? __check_object_size+0x4a/0x160
[515605.447786]  ? _copy_from_user+0x28/0x60
[515605.450219]  ? iovec_from_user+0x5b/0x180
[515605.452693]  ___sys_recvmsg+0x82/0x110
[515605.455017]  ? handle_mm_fault+0x1143/0x1c10
[515605.457608]  __sys_recvmsg+0x56/0xa0
[515605.459853]  do_syscall_64+0x33/0x80
[515605.462087]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[515605.465079] RIP: 0033:0x7f24c51b6e63
[515605.467301] Code: 8b 15 31 10 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2f 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
[515605.477470] RSP: 002b:00007ffd49f7c7f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
[515605.481870] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f24c51b6e63
[515605.486040] RDX: 0000000000000022 RSI: 00007ffd49f7c8e0 RDI: 0000000000000003
[515605.490174] RBP: 0000000000000022 R08: 000000007c9654be R09: 00007f24c5288be0
[515605.494362] R10: 0000000000000076 R11: 0000000000000246 R12: 00007ffd49f7c8e0
[515605.498537] R13: 0000000000000003 R14: 00007ffd49f7c8d0 R15: 0000000000000000
[515605.502778] Kernel Offset: 0x21600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[515605.508847] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

TIA,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
