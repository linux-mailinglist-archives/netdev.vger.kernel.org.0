Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDDA6007E7
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJQHms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJQHmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:42:46 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF1E49B5A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:42:44 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id y26-20020a5d9b1a000000b006bc71505e97so6506199ion.16
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=huVHFHzZCRegYjTiP+y/6HGGDXj2cO7o1fBi9AQtHVM=;
        b=0oG/6yAG9l7l4+f4gaavyV99WbuLfazFsrlfDNl/Cj4qFPOort4S8Gds8uEW4xacdh
         cNLybvoQZEEK0ArDLkIGnMJ+nszaZUq6DalkqcgvNc4CqJebYoUGr+uR0kUMFDHdaHth
         X8H29mJwdzola/TUp3c8JfG17jFXl97XFtGT81WzUcbS3ijKHTNStPEOu9Epr4wQBTfz
         f8ktMWeFhimyLZ9CFJeV2E8aY5YImF1UsIMxV18KRWVNx7YAkaPRez/fxhgSOKISy5sD
         EmEmdzI4MisOH+E65I6OoZ4t3olHaH5cIh4663mAxIybByR8qTuy7LxleSTIbLDMCcE3
         qKDw==
X-Gm-Message-State: ACrzQf3uIAbe9ZWgLEIkZLwkDxXMiVgDpRvv1K8fDVCMcsQMfSAypGCy
        3gvk/GbFPMMyWI3bE/UTT3w7JVGRMY2LLV4W7cYYVXMHebKt
X-Google-Smtp-Source: AMsMyM6E+4zfWIspeyjs8XHlWSoXPjmb8Z0vkRBP/4/2lyd2FrXZY+5e96ws0C0U0G7Er37n20f3mSG1u/dcgbqYClVF7oR+pZvD
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3145:b0:6b3:d28a:2f4d with SMTP id
 m5-20020a056602314500b006b3d28a2f4dmr3959377ioy.49.1665992563884; Mon, 17 Oct
 2022 00:42:43 -0700 (PDT)
Date:   Mon, 17 Oct 2022 00:42:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f80cbd05eb361e8e@google.com>
Subject: [syzbot] usb-testing boot error: WARNING in __netif_set_xps_queue
From:   syzbot <syzbot+a30f71cf20b71d5950e7@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
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

syzbot found the following issue on:

HEAD commit:    9abf2313adc1 Linux 6.1-rc1
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=15c16c3c880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c62bac73287f46bf
dashboard link: https://syzkaller.appspot.com/bug?extid=a30f71cf20b71d5950e7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f1e5f3ebfe6d/disk-9abf2313.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a75cbc21a548/vmlinux-9abf2313.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a30f71cf20b71d5950e7@syzkaller.appspotmail.com

software IO TLB: mapped [mem 0x00000000bbffd000-0x00000000bfffd000] (64MB)
RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb702bab20, max_idle_ns: 440795313305 ns
clocksource: Switched to clocksource tsc
Initialise system trusted keyrings
workingset: timestamp_bits=40 max_order=21 bucket_order=0
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
9p: Installing v9fs 9p2000 file system support
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
io scheduler mq-deadline registered
io scheduler kyber registered
usbcore: registered new interface driver udlfb
usbcore: registered new interface driver smscufx
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: button: Power Button [PWRF]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
ACPI: button: Sleep Button [SLPF]
ACPI: \_SB_.LNKC: Enabled at IRQ 11
virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKD: Enabled at IRQ 10
virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKB: Enabled at IRQ 10
virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ACPI: bus type drm_connector registered
usbcore: registered new interface driver udl
loop: module loaded
usbcore: registered new interface driver rtsx_usb
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
scsi host0: Virtio SCSI HBA
scsi 0:0:1:0: Direct-Access     Google   PersistentDisk   1    PQ: 0 ANSI: 6
sd 0:0:1:0: Attached scsi generic sg0 type 0
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 netif_attrmask_next_and include/linux/netdevice.h:3689 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x8a1/0x1f50 net/core/dev.c:2592
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
RIP: 0010:netif_attrmask_next_and include/linux/netdevice.h:3689 [inline]
RIP: 0010:__netif_set_xps_queue+0x8a1/0x1f50 net/core/dev.c:2592
Code: fc 48 c7 c2 60 24 f8 86 be 2e 0a 00 00 48 c7 c7 00 23 f8 86 c6 05 d6 8e f0 03 01 e8 14 7c e9 00 e9 ef fd ff ff e8 0f 5f 60 fc <0f> 0b e9 8e fa ff ff 8b 6c 24 38 e8 ff 5e 60 fc 49 8d 7c 24 04 48
RSP: 0000:ffffc9000001f898 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff8881002b0000 RSI: ffffffff84e66611 RDI: 0000000000000004
RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000052041 R12: ffff88810e97bb00
R13: 0000000000000003 R14: ffff88810e97bb18 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 0000000007825000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virtnet_set_affinity+0x4f0/0x750 drivers/net/virtio_net.c:2308
 init_vqs drivers/net/virtio_net.c:3581 [inline]
 init_vqs drivers/net/virtio_net.c:3567 [inline]
 virtnet_probe+0x12ae/0x33a0 drivers/net/virtio_net.c:3884
 virtio_dev_probe+0x577/0x870 drivers/virtio/virtio.c:305
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
 __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
 __driver_attach+0x1d0/0x550 drivers/base/dd.c:1190
 bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
 bus_add_driver+0x4c9/0x640 drivers/base/bus.c:618
 driver_register+0x220/0x3a0 drivers/base/driver.c:246
 virtio_net_driver_init+0x93/0xd2 drivers/net/virtio_net.c:4090
 do_one_initcall+0x13d/0x780 init/main.c:1303
 do_initcall_level init/main.c:1376 [inline]
 do_initcalls init/main.c:1392 [inline]
 do_basic_setup init/main.c:1411 [inline]
 kernel_init_freeable+0x6fa/0x783 init/main.c:1631
 kernel_init+0x1a/0x1d0 init/main.c:1519
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
