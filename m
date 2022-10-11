Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D183F5FBCEB
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiJKV12 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Oct 2022 17:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiJKV1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:27:24 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC38BFD10
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:21 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id x6-20020a056e021bc600b002fc96f780e7so1654815ilv.10
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/oo4r2AbtWeVS75Zv0ff0EvstUdUTXfoQtBAE25lHxY=;
        b=pRsrKQ3EvL3ZR6NVd/zY4ApXIB3HQ5NnVMyRlMYIMT9n+YjnzLaV9hnlyur/aL81tO
         Et4OnVyutPrIf7OZ3nNwRVlZlJFovnzpz5pakKThjfidH5HdNUHgO8tsI2nmOpSv4zF3
         lRD/V/10RjmQadHciTKs8wXfbDQeABq8kmT14oX4u9dJwQoeluscU0Xlkqgy8xEzmljH
         3FClkuHVFlQpFzltzqLJxg7WrAWTWt5vWmW2DBgC39G1KnjSWrmjjIrlMoe0k518N5EZ
         ZXVjZRJpAiatzHLgizDzqjwIfUzLVwKC6SKBWYPHvebi8bveez71Dq0uEB3Hl3ok0pJs
         SQNw==
X-Gm-Message-State: ACrzQf1o/9/VBBBoeRPDlEJqhYflHiIzEAO3OBMQ5Q3IbvQJTRJI79Vi
        ilCWbwjMBxHsKEobomtc/MdfVrtCoXEJf0HYIQ4i/Y5xDE4b
X-Google-Smtp-Source: AMsMyM6bvB1GXpiVtuSe0CrGU7tic/p8jWS8UbpyiBYzCZssERgW70JuP4vCyKTb6d3bm7ELMeJiP5IOPW92MVSCqCnkGya2JZnU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156a:b0:2fc:4266:f56 with SMTP id
 k10-20020a056e02156a00b002fc42660f56mr6329135ilu.140.1665523641047; Tue, 11
 Oct 2022 14:27:21 -0700 (PDT)
Date:   Tue, 11 Oct 2022 14:27:21 -0700
In-Reply-To: <20221011170435-mutt-send-email-mst@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd62ef05eac8f004@google.com>
Subject: Re: [syzbot] upstream boot error: WARNING in cpumask_next_wrap
From:   syzbot <syzbot+51a652e2d24d53e75734@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

resolver registered
[    5.556576][    T1] Key type id_legacy registered
[    5.557522][    T1] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    5.558640][    T1] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
[    5.567089][    T1] Key type cifs.spnego registered
[    5.567892][    T1] Key type cifs.idmap registered
[    5.569053][    T1] ntfs: driver 2.1.32 [Flags: R/W].
[    5.570912][    T1] ntfs3: Max link count 4000
[    5.571535][    T1] ntfs3: Enabled Linux POSIX ACLs support
[    5.572513][    T1] ntfs3: Read-only LZX/Xpress compression included
[    5.574261][    T1] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    5.575274][    T1] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    5.579930][    T1] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.581216][    T1] QNX4 filesystem 0.2.3 registered.
[    5.582195][    T1] qnx6: QNX6 filesystem 1.0.0 registered.
[    5.583827][    T1] fuse: init (API version 7.37)
[    5.588259][    T1] orangefs_debugfs_init: called with debug mask: :none: :0:
[    5.589705][    T1] orangefs_init: module version upstream loaded
[    5.591366][    T1] JFS: nTxBlock = 8192, nTxLock = 65536
[    5.604957][    T1] SGI XFS with ACLs, security attributes, realtime, quota, fatal assert, debug enabled
[    5.617336][    T1] 9p: Installing v9fs 9p2000 file system support
[    5.619447][    T1] NILFS version 2 loaded
[    5.620043][    T1] befs: version: 0.9.3
[    5.621928][    T1] ocfs2: Registered cluster interface o2cb
[    5.623133][    T1] ocfs2: Registered cluster interface user
[    5.624559][    T1] OCFS2 User DLM kernel interface loaded
[    5.635096][    T1] gfs2: GFS2 installed
[    5.645789][    T1] ceph: loaded (mds proto 32)
[    5.657347][    T1] NET: Registered PF_ALG protocol family
[    5.658194][    T1] xor: automatically using best checksumming function   avx       
[    5.659255][    T1] async_tx: api initialized (async)
[    5.660129][    T1] Key type asymmetric registered
[    5.660836][    T1] Asymmetric key parser 'x509' registered
[    5.661639][    T1] Asymmetric key parser 'pkcs8' registered
[    5.662447][    T1] Key type pkcs7_test registered
[    5.665996][    T1] alg: self-tests for CTR-KDF (hmac(sha256)) passed
[    5.667302][    T1] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 240)
[    5.668986][    T1] io scheduler mq-deadline registered
[    5.669749][    T1] io scheduler kyber registered
[    5.671033][    T1] io scheduler bfq registered
[    5.677855][    T1] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.682131][    T1] ACPI: button: Power Button [PWRF]
[    5.684301][    T1] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    5.685918][  T160] kworker/u4:1 (160) used greatest stack depth: 26672 bytes left
[    5.687126][    T1] ACPI: button: Sleep Button [SLPF]
[    5.710387][    T1] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[    5.711260][    T1] virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
[    5.725631][    T1] ACPI: \_SB_.LNKD: Enabled at IRQ 10
[    5.726543][    T1] virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
[    5.740211][    T1] ACPI: \_SB_.LNKB: Enabled at IRQ 10
[    5.741109][    T1] virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
[    5.751058][  T194] kworker/u4:1 (194) used greatest stack depth: 26624 bytes left
[    6.053979][    T1] N_HDLC line discipline registered with maxframe=4096
[    6.055096][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.058386][    T1] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    6.063373][    T1] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    6.068699][    T1] 00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
[    6.073444][    T1] 00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
[    6.081659][    T1] Non-volatile memory driver v1.3
[    6.098395][    T1] Linux agpgart interface v0.103
[    6.100599][    T1] ACPI: bus type drm_connector registered
[    6.104060][    T1] [drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
[    6.109975][    T1] [drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
[    6.166404][    T1] Console: switching to colour frame buffer device 128x48
[    6.184282][    T1] platform vkms: [drm] fb0: vkmsdrmfb frame buffer device
[    6.185456][    T1] usbcore: registered new interface driver udl
[    6.234876][    T1] brd: module loaded
[    6.287542][    T1] loop: module loaded
[    6.360301][    T1] zram: Added device: zram0
[    6.366643][    T1] null_blk: disk nullb0 created
[    6.367407][    T1] null_blk: module loaded
[    6.368437][    T1] Guest personality initialized and is inactive
[    6.370337][    T1] VMCI host device registered (name=vmci, major=10, minor=119)
[    6.371699][    T1] Initialized host personality
[    6.372849][    T1] usbcore: registered new interface driver rtsx_usb
[    6.374672][    T1] usbcore: registered new interface driver viperboard
[    6.376021][    T1] usbcore: registered new interface driver dln2
[    6.378029][    T1] usbcore: registered new interface driver pn533_usb
[    6.382237][    T1] nfcsim 0.2 initialized
[    6.383289][    T1] usbcore: registered new interface driver port100
[    6.384344][    T1] usbcore: registered new interface driver nfcmrvl
[    6.388305][    T1] Loading iSCSI transport class v2.0-870.
[    6.413355][    T1] scsi host0: Virtio SCSI HBA
[    6.449912][    T1] st: Version 20160209, fixed bufsize 32768, s/g segs 256
[    6.452351][    T9] scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
[    6.476962][    T1] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    6.479627][    T1] db_root: cannot open: /etc/target
[    6.481551][    T1] slram: not enough parameters.
[    6.488103][    T1] ftl_cs: FTL header not found.
[    6.534919][    T1] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
[    6.539139][    T1] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
[    6.540930][    T1] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    6.550498][    T1] MACsec IEEE 802.1AE
[    6.572661][    T1] tun: Universal TUN/TAP device driver, 1.6
[    6.609300][    T1] ------------[ cut here ]------------
[    6.610845][    T1] WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x88e/0x1f30
[    6.612642][    T1] Modules linked in:
[    6.613259][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-11153-gd5c59b2d8ff4 #0
[    6.614532][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
[    6.615891][    T1] RIP: 0010:__netif_set_xps_queue+0x88e/0x1f30
[    6.616957][    T1] Code: fa 48 c7 c2 e0 98 f4 8a be 2e 0a 00 00 48 c7 c7 80 97 f4 8a c6 05 ae d1 74 06 01 e8 f5 d9 f1 01 e9 ef fd ff ff e8 22 32 25 fa <0f> 0b e9 8e fa ff ff 8b 6c 24 38 e8 12 32 25 fa 49 8d 7c 24 04 48
[    6.619667][    T1] RSP: 0018:ffffc900000678a0 EFLAGS: 00010293
[    6.620512][    T1] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[    6.621622][    T1] RDX: ffff888140170000 RSI: ffffffff875733be RDI: 0000000000000004
[    6.622718][    T1] RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
[    6.623845][    T1] R10: 0000000000000002 R11: 000000000008c07e R12: ffff88801c770100
[    6.624960][    T1] R13: 0000000000000003 R14: ffff88801c770118 R15: 0000000000000002
[    6.626041][    T1] FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
[    6.630570][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.631671][    T1] CR2: ffff88823ffff000 CR3: 000000000bc8e000 CR4: 0000000000350ef0
[    6.632794][    T1] Call Trace:
[    6.633365][    T1]  <TASK>
[    6.633824][    T1]  ? vp_bus_name+0xc0/0xc0
[    6.634553][    T1]  virtnet_set_affinity+0x5c2/0x840
[    6.635296][    T1]  ? trace_xdp_exception+0x320/0x320
[    6.636102][    T1]  virtnet_probe+0x12ae/0x31e0
[    6.636943][    T1]  ? virtnet_find_vqs+0xc30/0xc30
[    6.637869][    T1]  virtio_dev_probe+0x577/0x870
[    6.638646][    T1]  ? virtio_features_ok+0x1e0/0x1e0
[    6.639418][    T1]  really_probe+0x249/0xb90
[    6.640084][    T1]  __driver_probe_device+0x1df/0x4d0
[    6.640946][    T1]  driver_probe_device+0x4c/0x1a0
[    6.641736][    T1]  __driver_attach+0x1d0/0x550
[    6.642452][    T1]  ? __device_attach_driver+0x2e0/0x2e0
[    6.643232][    T1]  bus_for_each_dev+0x147/0x1d0
[    6.643950][    T1]  ? subsys_dev_iter_exit+0x20/0x20
[    6.644738][    T1]  bus_add_driver+0x4c9/0x640
[    6.645463][    T1]  driver_register+0x220/0x3a0
[    6.646280][    T1]  ? veth_init+0x11/0x11
[    6.646945][    T1]  virtio_net_driver_init+0x93/0xd2
[    6.647717][    T1]  do_one_initcall+0x13d/0x780
[    6.648438][    T1]  ? trace_event_raw_event_initcall_level+0x1f0/0x1f0
[    6.649399][    T1]  ? parameq+0x100/0x170
[    6.650056][    T1]  kernel_init_freeable+0x6ff/0x788
[    6.650837][    T1]  ? rest_init+0x270/0x270
[    6.651501][    T1]  kernel_init+0x1a/0x1d0
[    6.652116][    T1]  ? rest_init+0x270/0x270
[    6.652801][    T1]  ret_from_fork+0x1f/0x30
[    6.653527][    T1]  </TASK>
[    6.654267][    T1] Kernel panic - not syncing: panic_on_warn set ...
[    6.655330][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-11153-gd5c59b2d8ff4 #0
[    6.656008][    T9] scsi 0:0:1:0: Attached scsi generic sg0 type 0
[    6.657424][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
[    6.657424][    T1] Call Trace:
[    6.659366][    T9] sd 0:0:1:0: [sda] 4194304 512-byte logical blocks: (2.15 GB/2.00 GiB)
[    6.659401][    T9] sd 0:0:1:0: [sda] 4096-byte physical blocks
[    6.659557][    T9] sd 0:0:1:0: [sda] Write Protect is off
[    6.659582][    T9] sd 0:0:1:0: [sda] Mode Sense: 1f 00 00 08
[    6.659777][    T9] sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.657424][    T1]  <TASK>
[    6.657424][    T1]  dump_stack_lvl+0xcd/0x134
[    6.657424][    T1]  panic+0x2c8/0x622
[    6.657424][    T1]  ? panic_print_sys_info.part.0+0x110/0x110
[    6.657424][    T1]  ? __warn.cold+0x24b/0x350
[    6.657424][    T1]  ? __netif_set_xps_queue+0x88e/0x1f30
[    6.657424][    T1]  __warn.cold+0x25c/0x350
[    6.657424][    T1]  ? __netif_set_xps_queue+0x88e/0x1f30
[    6.670084][    T9]  sda: sda1
[    6.671363][    T9] sd 0:0:1:0: [sda] Attached SCSI disk
[    6.672268][    T1]  report_bug+0x1bc/0x210
[    6.672621][    T1]  handle_bug+0x3c/0x70
[    6.672621][    T1]  exc_invalid_op+0x14/0x40
[    6.672621][    T1]  asm_exc_invalid_op+0x16/0x20
[    6.672621][    T1] RIP: 0010:__netif_set_xps_queue+0x88e/0x1f30
[    6.672621][    T1] Code: fa 48 c7 c2 e0 98 f4 8a be 2e 0a 00 00 48 c7 c7 80 97 f4 8a c6 05 ae d1 74 06 01 e8 f5 d9 f1 01 e9 ef fd ff ff e8 22 32 25 fa <0f> 0b e9 8e fa ff ff 8b 6c 24 38 e8 12 32 25 fa 49 8d 7c 24 04 48
[    6.672621][    T1] RSP: 0018:ffffc900000678a0 EFLAGS: 00010293
[    6.672621][    T1] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
[    6.672621][    T1] RDX: ffff888140170000 RSI: ffffffff875733be RDI: 0000000000000004
[    6.672621][    T1] RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
[    6.672621][    T1] R10: 0000000000000002 R11: 000000000008c07e R12: ffff88801c770100
[    6.672621][    T1] R13: 0000000000000003 R14: ffff88801c770118 R15: 0000000000000002
[    6.672621][    T1]  ? __netif_set_xps_queue+0x88e/0x1f30
[    6.672621][    T1]  ? vp_bus_name+0xc0/0xc0
[    6.672621][    T1]  virtnet_set_affinity+0x5c2/0x840
[    6.672621][    T1]  ? trace_xdp_exception+0x320/0x320
[    6.672621][    T1]  virtnet_probe+0x12ae/0x31e0
[    6.672621][    T1]  ? virtnet_find_vqs+0xc30/0xc30
[    6.672621][    T1]  virtio_dev_probe+0x577/0x870
[    6.672621][    T1]  ? virtio_features_ok+0x1e0/0x1e0
[    6.672621][    T1]  really_probe+0x249/0xb90
[    6.672621][    T1]  __driver_probe_device+0x1df/0x4d0
[    6.672621][    T1]  driver_probe_device+0x4c/0x1a0
[    6.672621][    T1]  __driver_attach+0x1d0/0x550
[    6.672621][    T1]  ? __device_attach_driver+0x2e0/0x2e0
[    6.672621][    T1]  bus_for_each_dev+0x147/0x1d0
[    6.672621][    T1]  ? subsys_dev_iter_exit+0x20/0x20
[    6.672621][    T1]  bus_add_driver+0x4c9/0x640
[    6.696608][    T1]  driver_register+0x220/0x3a0
[    6.698110][    T1]  ? veth_init+0x11/0x11
[    6.698520][    T1]  virtio_net_driver_init+0x93/0xd2
[    6.698520][    T1]  do_one_initcall+0x13d/0x780
[    6.698520][    T1]  ? trace_event_raw_event_initcall_level+0x1f0/0x1f0
[    6.698520][    T1]  ? parameq+0x100/0x170
[    6.698520][    T1]  kernel_init_freeable+0x6ff/0x788
[    6.698520][    T1]  ? rest_init+0x270/0x270
[    6.698520][    T1]  kernel_init+0x1a/0x1d0
[    6.698520][    T1]  ? rest_init+0x270/0x270
[    6.698520][    T1]  ret_from_fork+0x1f/0x30
[    6.698520][    T1]  </TASK>
[    6.698520][    T1] Kernel Offset: disabled
[    6.698520][    T1] Rebooting in 86400 seconds..


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
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build1794615944=/tmp/go-build -gno-record-gcc-switches"

git status (err=<nil>)
HEAD detached at 1353c374a
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
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=1353c374a28b0c3b20e5acf59753aceb934c7fd0 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20221011-154314'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer github.com/google/syzkaller/syz-fuzzer
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=1353c374a28b0c3b20e5acf59753aceb934c7fd0 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20221011-154314'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
GOOS=linux GOARCH=amd64 go build "-ldflags=-s -w -X github.com/google/syzkaller/prog.GitRevision=1353c374a28b0c3b20e5acf59753aceb934c7fd0 -X 'github.com/google/syzkaller/prog.gitRevisionDate=20221011-154314'" "-tags=syz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wframe-larger-than=16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-format-overflow -static-pie -fpermissive -w -DGOOS_linux=1 -DGOARCH_amd64=1 \
	-DHOSTGOOS_linux=1 -DGIT_REVISION=\"1353c374a28b0c3b20e5acf59753aceb934c7fd0\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=10140a3a880000


Tested on:

commit:         d5c59b2d lib/cpumask: drop 'new' suffix for cpumask_ne..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=f17bafa7c5d14ecb
dashboard link: https://syzkaller.appspot.com/bug?extid=51a652e2d24d53e75734
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
