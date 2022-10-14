Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955BD5FECA0
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJNKjZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Oct 2022 06:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJNKjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:39:24 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CD81B94C0
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 03:39:22 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id s3-20020a5eaa03000000b006bbdfc81c6fso2874103ioe.4
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 03:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qvhl7u8YBLBYhFksiSAdetydoOj9lMQaTJGJndUxU4k=;
        b=z598TnIs6Z+TB5R3GmFnRjy5By/fgNodlLPMsXOpAVT7Ryif/tRW4vicj5UUKFLNzl
         3UOh3IChduTREvXfCgCV6Lv0ind8D9vFH9bKvPQIxmLTbzehbhOQyuP5beTDf0+SJaEd
         1EAsHR4njrm1qDEAF7dbo3ImwguSFuUx3td4R/KAD9DqJPdc8qsp4RUdmzFPIsTLV7c6
         WF2iQRVCTAHWv9Eb+mBnGE6UjN+8uv4hSlA9Sz4FQZCfl0986rQ0vjOEHtF0FttlvfW1
         OUbyi+Q5iIegECUfPzFVWV622xx7b/rW0996xWvdSQMZMnELGXvFo+VSaxhPnYXXyONP
         qbqg==
X-Gm-Message-State: ACrzQf0h0kxt0JNBXDwS5abEvNT+rO362OAQXf0SeZMOs1tzs+MXNHVJ
        vbGfzJdFMt8JRSAGeDKBjBgmX+uNrKbsvNHjgtHMzfGCJTnR
X-Google-Smtp-Source: AMsMyM7oiV7U65e/YxqGHhd3e/zMSb17aTODeSjyFV1/Uevu+HghgeOCzKaTB+0gm2b2Nks3x9Edyvwbt1nJA28gCAacA16s2HCm
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1907:b0:2fa:65ec:818b with SMTP id
 w7-20020a056e02190700b002fa65ec818bmr2164882ilu.40.1665743961556; Fri, 14 Oct
 2022 03:39:21 -0700 (PDT)
Date:   Fri, 14 Oct 2022 03:39:21 -0700
In-Reply-To: <20221014054043-mutt-send-email-mst@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d91e205eafc3d01@google.com>
Subject: Re: [syzbot] usb-testing boot error: WARNING in cpumask_next_wrap
From:   syzbot <syzbot+28ec239d5c21a2d91f3d@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

 default
[    3.179519][    T1] nfc: nfc_init: NFC Core ver 0.1
[    3.181005][    T1] NET: Registered PF_NFC protocol family
[    3.182019][    T1] PCI: Using ACPI for IRQ routing
[    3.183866][    T1] pci 0000:00:05.0: vgaarb: setting as boot VGA device
[    3.185131][    T1] pci 0000:00:05.0: vgaarb: bridge control possible
[    3.186478][    T1] pci 0000:00:05.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    3.188192][    T1] vgaarb: loaded
[    5.441906][    T1] clocksource: Switched to clocksource kvm-clock
[    5.452520][    T1] VFS: Disk quotas dquot_6.6.0
[    5.453494][    T1] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.456285][    T1] TOMOYO: 2.6.0
[    5.456902][    T1] Mandatory Access Control activated.
[    5.461463][    T1] AppArmor: AppArmor Filesystem Enabled
[    5.463304][    T1] pnp: PnP ACPI init
[    5.484586][    T1] pnp: PnP ACPI: found 7 devices
[    5.530162][    T1] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    5.533085][    T1] NET: Registered PF_INET protocol family
[    5.536180][    T1] IP idents hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    5.549729][    T1] tcp_listen_portaddr_hash hash table entries: 4096 (order: 6, 294912 bytes, linear)
[    5.552313][    T1] Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    5.554246][    T1] TCP established hash table entries: 65536 (order: 7, 524288 bytes, linear)
[    5.569965][    T1] TCP bind hash table entries: 65536 (order: 11, 9437184 bytes, vmalloc hugepage)
[    5.581801][    T1] TCP: Hash tables configured (established 65536 bind 65536)
[    5.585057][    T1] UDP hash table entries: 4096 (order: 7, 655360 bytes, linear)
[    5.589494][    T1] UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes, linear)
[    5.592470][    T1] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    5.596666][    T1] RPC: Registered named UNIX socket transport module.
[    5.597969][    T1] RPC: Registered udp transport module.
[    5.598999][    T1] RPC: Registered tcp transport module.
[    5.600079][    T1] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.604512][    T1] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    5.605732][    T1] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    5.606899][    T1] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    5.608458][    T1] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfefff window]
[    5.611241][    T1] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    5.612998][    T1] PCI: CLS 0 bytes, default 64
[    5.620939][    T1] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.622409][    T1] software IO TLB: mapped [mem 0x00000000bbffd000-0x00000000bfffd000] (64MB)
[    5.632006][    T1] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
[    5.633671][    T1] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb6c613963, max_idle_ns: 440795245426 ns
[    5.635448][    T1] clocksource: Switched to clocksource tsc
[    5.640902][   T42] kworker/u4:2 (42) used greatest stack depth: 27944 bytes left
[    5.662007][   T45] kworker/u4:2 (45) used greatest stack depth: 27560 bytes left
[    5.900338][    T1] Initialise system trusted keyrings
[    5.905742][    T1] workingset: timestamp_bits=40 max_order=21 bucket_order=0
[    5.958390][    T1] NFS: Registering the id_resolver key type
[    5.959586][    T1] Key type id_resolver registered
[    5.960449][    T1] Key type id_legacy registered
[    5.962729][    T1] 9p: Installing v9fs 9p2000 file system support
[    5.973978][    T1] Key type asymmetric registered
[    5.975074][    T1] Asymmetric key parser 'x509' registered
[    5.976374][    T1] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    5.978167][    T1] io scheduler mq-deadline registered
[    5.979887][    T1] io scheduler kyber registered
[    5.989159][    T1] usbcore: registered new interface driver udlfb
[    5.991292][    T1] usbcore: registered new interface driver smscufx
[    5.994815][    T1] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.998521][    T1] ACPI: button: Power Button [PWRF]
[    6.000914][    T1] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    6.002903][    T1] ACPI: button: Sleep Button [SLPF]
[    6.026576][    T1] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[    6.027797][    T1] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
[    6.045841][    T1] ACPI: \_SB_.LNKD: Enabled at IRQ 10
[    6.046722][    T1] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
[    6.066890][    T1] ACPI: \_SB_.LNKB: Enabled at IRQ 10
[    6.067882][    T1] virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
[    6.081914][    T1] virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
[    6.091143][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.093039][    T1] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    6.096879][    T1] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    6.101022][    T1] 00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
[    6.104480][    T1] 00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
[    6.116840][    T1] Non-volatile memory driver v1.3
[    6.132870][    T1] Linux agpgart interface v0.103
[    6.137548][    T1] ACPI: bus type drm_connector registered
[    6.144293][    T1] usbcore: registered new interface driver udl
[    6.178918][    T1] loop: module loaded
[    6.180970][    T1] usbcore: registered new interface driver rtsx_usb
[    6.183126][    T1] usbcore: registered new interface driver viperboard
[    6.185069][    T1] usbcore: registered new interface driver dln2
[    6.187547][    T1] usbcore: registered new interface driver pn533_usb
[    6.189306][    T1] usbcore: registered new interface driver port100
[    6.190908][    T1] usbcore: registered new interface driver nfcmrvl
[    6.212849][    T1] scsi host0: Virtio SCSI HBA
[    6.263010][    T1] scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
[    6.400424][   T37] sd 0:0:1:0: [sda] 4194304 512-byte logical blocks: (2.15 GB/2.00 GiB)
[    6.403841][   T37] sd 0:0:1:0: [sda] 4096-byte physical blocks
[    6.405619][   T37] sd 0:0:1:0: [sda] Write Protect is off
[    6.406828][   T37] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.431330][   T37]  sda: sda1
[    6.433423][   T37] sd 0:0:1:0: [sda] Attached SCSI disk
[    6.436461][    T1] sd 0:0:1:0: Attached scsi generic sg0 type 0
[    6.444991][    T1] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    6.446870][    T1] db_root: cannot open: /etc/target
[    6.503369][    T1] ------------[ cut here ]------------
[    6.504495][    T1] WARNING: CPU: 1 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x139/0x1d0
[    6.506166][    T1] Modules linked in:
[    6.506762][    T1] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-00004-gb0d0538b9a8c #0
[    6.508419][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
[    6.509905][    T1] RIP: 0010:cpumask_next_wrap+0x139/0x1d0
[    6.511033][    T1] Code: df e8 6b 9e 80 fb 39 eb 77 64 e8 12 a2 80 fb 41 8d 6c 24 01 89 de 89 ef e8 54 9e 80 fb 39 dd 0f 82 54 ff ff ff e8 f7 a1 80 fb <0f> 0b e9 48 ff ff ff e8 eb a1 80 fb 48 c7 c2 80 dc e3 88 48 b8 00
[    6.516629][    T1] RSP: 0000:ffffc9000001f920 EFLAGS: 00010293
[    6.517464][    T1] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[    6.518599][    T1] RDX: ffff8881002b0000 RSI: ffffffff85c61b89 RDI: 0000000000000004
[    6.519949][    T1] RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
[    6.521419][    T1] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
[    6.522862][    T1] R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff88e3da90
[    6.524038][    T1] FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
[    6.525409][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.526364][    T1] CR2: 0000000000000000 CR3: 0000000007825000 CR4: 00000000003506e0
[    6.527485][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.528604][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    6.529913][    T1] Call Trace:
[    6.530493][    T1]  <TASK>
[    6.531040][    T1]  virtnet_set_affinity+0x35a/0x750
[    6.531872][    T1]  ? skb_recv_done+0x120/0x120
[    6.532615][    T1]  virtnet_probe+0x12ae/0x33a0
[    6.533433][    T1]  ? virtnet_find_vqs+0xc30/0xc30
[    6.534216][    T1]  virtio_dev_probe+0x577/0x870
[    6.534973][    T1]  ? virtio_features_ok+0x1e0/0x1e0
[    6.535821][    T1]  really_probe+0x249/0xb90
[    6.536444][    T1]  __driver_probe_device+0x1df/0x4d0
[    6.537260][    T1]  driver_probe_device+0x4c/0x1a0
[    6.537951][    T1]  __driver_attach+0x1d0/0x550
[    6.538774][    T1]  ? __device_attach_driver+0x2e0/0x2e0
[    6.539593][    T1]  bus_for_each_dev+0x147/0x1d0
[    6.540446][    T1]  ? subsys_dev_iter_exit+0x20/0x20
[    6.541479][    T1]  bus_add_driver+0x4c9/0x640
[    6.542580][    T1]  driver_register+0x220/0x3a0
[    6.543390][    T1]  ? phy_module_init+0x18/0x18
[    6.544088][    T1]  virtio_net_driver_init+0x93/0xd2
[    6.544897][    T1]  do_one_initcall+0x13d/0x780
[    6.545601][    T1]  ? trace_event_raw_event_initcall_level+0x1f0/0x1f0
[    6.546529][    T1]  ? parameq+0x160/0x170
[    6.547122][    T1]  kernel_init_freeable+0x6fa/0x783
[    6.548084][    T1]  ? rest_init+0x270/0x270
[    6.548787][    T1]  kernel_init+0x1a/0x1d0
[    6.549447][    T1]  ? rest_init+0x270/0x270
[    6.550197][    T1]  ret_from_fork+0x1f/0x30
[    6.550853][    T1]  </TASK>
[    6.551354][    T1] Kernel panic - not syncing: panic_on_warn set ...
[    6.552411][    T1] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-00004-gb0d0538b9a8c #0
[    6.553841][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
[    6.555556][    T1] Call Trace:
[    6.556138][    T1]  <TASK>
[    6.556802][    T1]  dump_stack_lvl+0xcd/0x134
[    6.557478][    T1]  panic+0x2c8/0x622
[    6.558160][    T1]  ? panic_print_sys_info.part.0+0x110/0x110
[    6.559193][    T1]  ? __warn.cold+0x24b/0x350
[    6.559859][    T1]  ? cpumask_next_wrap+0x139/0x1d0
[    6.560838][    T1]  __warn.cold+0x25c/0x350
[    6.560838][    T1]  ? cpumask_next_wrap+0x139/0x1d0
[    6.560838][    T1]  report_bug+0x1bc/0x210
[    6.560838][    T1]  handle_bug+0x3c/0x70
[    6.560838][    T1]  exc_invalid_op+0x14/0x40
[    6.560838][    T1]  asm_exc_invalid_op+0x16/0x20
[    6.560838][    T1] RIP: 0010:cpumask_next_wrap+0x139/0x1d0
[    6.560838][    T1] Code: df e8 6b 9e 80 fb 39 eb 77 64 e8 12 a2 80 fb 41 8d 6c 24 01 89 de 89 ef e8 54 9e 80 fb 39 dd 0f 82 54 ff ff ff e8 f7 a1 80 fb <0f> 0b e9 48 ff ff ff e8 eb a1 80 fb 48 c7 c2 80 dc e3 88 48 b8 00
[    6.560838][    T1] RSP: 0000:ffffc9000001f920 EFLAGS: 00010293
[    6.560838][    T1] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[    6.560838][    T1] RDX: ffff8881002b0000 RSI: ffffffff85c61b89 RDI: 0000000000000004
[    6.560838][    T1] RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
[    6.560838][    T1] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
[    6.560838][    T1] R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff88e3da90
[    6.560838][    T1]  ? cpumask_next_wrap+0x139/0x1d0
[    6.560838][    T1]  virtnet_set_affinity+0x35a/0x750
[    6.560838][    T1]  ? skb_recv_done+0x120/0x120
[    6.560838][    T1]  virtnet_probe+0x12ae/0x33a0
[    6.560838][    T1]  ? virtnet_find_vqs+0xc30/0xc30
[    6.560838][    T1]  virtio_dev_probe+0x577/0x870
[    6.560838][    T1]  ? virtio_features_ok+0x1e0/0x1e0
[    6.560838][    T1]  really_probe+0x249/0xb90
[    6.560838][    T1]  __driver_probe_device+0x1df/0x4d0
[    6.560838][    T1]  driver_probe_device+0x4c/0x1a0
[    6.560838][    T1]  __driver_attach+0x1d0/0x550
[    6.560838][    T1]  ? __device_attach_driver+0x2e0/0x2e0
[    6.560838][    T1]  bus_for_each_dev+0x147/0x1d0
[    6.560838][    T1]  ? subsys_dev_iter_exit+0x20/0x20
[    6.560838][    T1]  bus_add_driver+0x4c9/0x640
[    6.560838][    T1]  driver_register+0x220/0x3a0
[    6.560838][    T1]  ? phy_module_init+0x18/0x18
[    6.560838][    T1]  virtio_net_driver_init+0x93/0xd2
[    6.560838][    T1]  do_one_initcall+0x13d/0x780
[    6.560838][    T1]  ? trace_event_raw_event_initcall_level+0x1f0/0x1f0
[    6.560838][    T1]  ? parameq+0x160/0x170
[    6.560838][    T1]  kernel_init_freeable+0x6fa/0x783
[    6.560838][    T1]  ? rest_init+0x270/0x270
[    6.560838][    T1]  kernel_init+0x1a/0x1d0
[    6.560838][    T1]  ? rest_init+0x270/0x270
[    6.560838][    T1]  ret_from_fork+0x1f/0x30
[    6.560838][    T1]  </TASK>
[    6.560838][    T1] Kernel Offset: disabled
[    6.560838][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=<nil>)
GO111MODULE="auto"
GOARCH="amd64"
GOBIN=""
GOCACHE="/syzkaller/.cache/go-build"
GOENV="/syzkaller/.config/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOINSECURE=""
GOMODCACHE="/syzkaller/jobs/linux/gopath/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="linux"
GOPATH="/syzkaller/jobs/linux/gopath"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GOVCS=""
GOVERSION="go1.17"
GCCGO="gccgo"
AR="ar"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD="/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mod"
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build3555849043=/tmp/go-build -gno-record-gcc-switches"

git status (err=<nil>)
HEAD detached at 4954e4b2c
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:32: run command via tools/syz-env for best compatibility, see:
Makefile:33: https://github.com/google/syzkaller/blob/master/docs/contributing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
bin/syz-sysgen
touch .descriptions
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=4954e4b2cf1e777715d52521afd2d9772d96f160 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20221013-124843'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer github.com/google/syzkaller/syz-fuzzer
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=4954e4b2cf1e777715d52521afd2d9772d96f160 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20221013-124843'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=4954e4b2cf1e777715d52521afd2d9772d96f160 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20221013-124843'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-larger-than=16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-format-overflow -static-pie -fpermissive -w -DGOOS_linux=1 -DGOARCH_amd64=1 \
	-DHOSTGOOS_linux=1 -DGIT_REVISION=\"4954e4b2cf1e777715d52521afd2d9772d96f160\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=16e7f342880000


Tested on:

commit:         b0d0538b net: fix opencoded for_each_and_bit() in __ne..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=8be1ac10ff2d4692
dashboard link: https://syzkaller.appspot.com/bug?extid=28ec239d5c21a2d91f3d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
