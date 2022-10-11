Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625ED5FAEA0
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJKIoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiJKIoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:44:44 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0A7E61
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:44:37 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id u2-20020a056e021a4200b002f9ecfa353cso10624989ilv.20
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8rAyLwcqhyqbw6qTRq87Ygr7lL5zRM4lvjhTuwKCYi8=;
        b=ryIuBbyYK3NL91hpxhPNynjNOur2mwpX2Hc+BlohO04Yck4pXSRpqZebyUqn2RCNOg
         81xQHQjjrmy0NnQts8OSW/Eb3vUUgu8qYyM3dK9TseECl9eQvUp5kJEnbsbIR4L3YYiC
         4ybrntYi7Sqp3t30SXQwlA3S68ql9nwPCpfrfgn4LNw9vm7xWUl5MWRno/ep6n27/hDq
         YPnmcXtogP6ouNZKUaWugrwr/vulPsCNok3TUm9TFJV6df6WJBghYi+XORtBF9HNm73N
         xbRpHrw4m61XHuR1igsG0bHM3D+PMP+f98fLchBtNq7B+oABle1rAtYo041Z6HgRhpzY
         qTCw==
X-Gm-Message-State: ACrzQf21kmc+YsLCE3fK09unk5e2tzUt9tkk9usrNtTG0LghWjfboD4E
        79rgnWsAzKzyOIYoKceIXz94qchZc0PXAKZwUTybNun7alVU
X-Google-Smtp-Source: AMsMyM54O9dsqiI/JJaOBF3ZjqzA/TDDc3/FQ8DTweNouW7yamqmvv7hjigIiq88S996gzHIs8mqxVi9JO1GqP8Ipb7r9iBDqLlL
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1baa:b0:2f9:9fcd:1f63 with SMTP id
 n10-20020a056e021baa00b002f99fcd1f63mr10926621ili.295.1665477877146; Tue, 11
 Oct 2022 01:44:37 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:44:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fac9905eabe4964@google.com>
Subject: [syzbot] upstream boot error: WARNING in cpumask_next_wrap
From:   syzbot <syzbot+51a652e2d24d53e75734@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    e2302539dd4f Merge tag 'xtensa-20221010' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105b851a880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1370a7ded58197a2
dashboard link: https://syzkaller.appspot.com/bug?extid=51a652e2d24d53e75734
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f6eb85afda26/disk-e2302539.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6091bfed3009/vmlinux-e2302539.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51a652e2d24d53e75734@syzkaller.appspotmail.com

ACPI: button: Sleep Button [SLPF]
ACPI: \_SB_.LNKC: Enabled at IRQ 11
virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKD: Enabled at IRQ 10
virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKB: Enabled at IRQ 10
virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
N_HDLC line discipline registered with maxframe=4096
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ACPI: bus type drm_connector registered
[drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
[drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
Console: switching to colour frame buffer device 128x48
platform vkms: [drm] fb0: vkmsdrmfb frame buffer device
usbcore: registered new interface driver udl
brd: module loaded
loop: module loaded
zram: Added device: zram0
null_blk: disk nullb0 created
null_blk: module loaded
Guest personality initialized and is inactive
VMCI host device registered (name=vmci, major=10, minor=120)
Initialized host personality
usbcore: registered new interface driver rtsx_usb
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
nfcsim 0.2 initialized
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
scsi host0: Virtio SCSI HBA
st: Version 20160209, fixed bufsize 32768, s/g segs 256
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
MACsec IEEE 802.1AE
tun: Universal TUN/TAP device driver, 1.6
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_check include/linux/cpumask.h:117 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next include/linux/cpumask.h:178 [inline]
WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x11c/0x1c0 lib/cpumask.c:27
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-10145-ge2302539dd4f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
RIP: 0010:cpumask_check include/linux/cpumask.h:117 [inline]
RIP: 0010:cpumask_next include/linux/cpumask.h:178 [inline]
RIP: 0010:cpumask_next_wrap+0x11c/0x1c0 lib/cpumask.c:27
Code: a6 00 00 00 e8 b5 34 62 f7 48 8b 04 24 41 bd ff ff ff ff 45 31 e4 48 b9 00 00 00 00 00 fc ff df e9 39 ff ff ff e8 94 34 62 f7 <0f> 0b e9 59 ff ff ff 48 c7 c1 b8 f2 0c 8e 80 e1 07 80 c1 03 38 c1
RSP: 0000:ffffc90000067218 EFLAGS: 00010293
RAX: ffffffff8a255bdc RBX: 0000000000000002 RCX: ffff888012278000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: 0000000000000002 R08: ffffffff8a255b2f R09: fffff5200000ce5d
R10: fffff5200000ce5d R11: 1ffff9200000ce5c R12: 0000000000000001
R13: 0000000000000001 R14: 1ffffffff1c19e57 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000c88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virtnet_set_affinity+0x2be/0x6f0 drivers/net/virtio_net.c:2303
 init_vqs+0x107c/0x11d0 drivers/net/virtio_net.c:3581
 virtnet_probe+0x198d/0x3120 drivers/net/virtio_net.c:3884
 virtio_dev_probe+0x8ca/0xb60 drivers/virtio/virtio.c:305
 call_driver_probe+0x96/0x250
 really_probe+0x24c/0x9f0 drivers/base/dd.c:639
 __driver_probe_device+0x1f4/0x3f0 drivers/base/dd.c:778
 driver_probe_device+0x50/0x240 drivers/base/dd.c:808
 __driver_attach+0x364/0x5b0 drivers/base/dd.c:1190
 bus_for_each_dev+0x168/0x1d0 drivers/base/bus.c:301
 bus_add_driver+0x32f/0x600 drivers/base/bus.c:618
 driver_register+0x2e9/0x3e0 drivers/base/driver.c:246
 virtio_net_driver_init+0x8e/0xcb drivers/net/virtio_net.c:4090
 do_one_initcall+0x1c9/0x400 init/main.c:1295
 do_initcall_level+0x168/0x218 init/main.c:1368
 do_initcalls+0x4b/0x8c init/main.c:1384
 kernel_init_freeable+0x3f1/0x57b init/main.c:1622
 kernel_init+0x19/0x2b0 init/main.c:1511
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
