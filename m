Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B66955932A
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiFXGLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFXGLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:11:49 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDD13466F;
        Thu, 23 Jun 2022 23:11:48 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s185so1505882pgs.3;
        Thu, 23 Jun 2022 23:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=TIDK4MXFLr95IR01KXloXK+FAQ+lixXSdRz+sZpTFFU=;
        b=quPhKpr9UQKwVC3iIXsOX85efQEE1To/DVBz5UbPCMmINlC+qLU5UzBn3D4agpfJWh
         hrQlnRw0wyeClPcZxBkQa34qAcakE2CyWXSv30Ju1jDAnj55gTcs4BhUGwIGaWRbYkI6
         HtxXQHdrPxGWSC6zd3LwCar/i9qTw75KmZn32RiAUmwSdZsI480k0OuOBQxkG3Cj4/9D
         Ke+Br+E/XwJ0y47QJFDCApaw5ilnCZlHhb6P+HkpCjHP5s4Sd+nNIiFi5LIKpGE9Dwbu
         lT80qmBwrwx46WHasP7AWvitxvRWgm01rc9/HWMQABEbXNltbcGPKmT8C21qdqzvYHTk
         ugCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=TIDK4MXFLr95IR01KXloXK+FAQ+lixXSdRz+sZpTFFU=;
        b=nIrAlAXBibA7g66oWHDJ9oTsF71XJKcmXGI7V8i1SF15JtXlyEGcMV8rcRkdg1Dwyd
         EUVnCXf7dIsZWeK9UuS29MKFjQNWE7OIZVsqoYBv1jKYlgW/dBrM0rNqwMHK+NmBXpzX
         VPkeB4nzGp9L1rvez4+eGSIiAT/fKcdAiFgy8bL1IBgSstRPaEw8eqYHn+ZH6uPiV0iy
         K+L8EC86Mq/Sf3Pyv0SPbe3dRI4b5a4iBqOZxKuz/Kv5UQVvH8G0oa+5ac3FFDX2PtSF
         NlIPHjC10HRx+L5z5UFTaR50jV3qfvkF3xaCCyQXeuUWT20vQ9tfhOpfo1UGR3Z6xErK
         ac1A==
X-Gm-Message-State: AJIora+ajp0hTLl/locK3C4Jv5BWRHh227EshrVRfTkYrPGTPytX/C3A
        mX+kFRCMwAeuMBOTY9dT2ZQ=
X-Google-Smtp-Source: AGRyM1twyzc/eb6P44/yHYVd4vGH2CHJP6b9kyWvtwx1Yj1f7eJK1Klf0ID05j9N0MdhpSPSLP6IdQ==
X-Received: by 2002:a05:6a00:1688:b0:517:cf7b:9293 with SMTP id k8-20020a056a00168800b00517cf7b9293mr44715503pfc.7.1656051107509;
        Thu, 23 Jun 2022 23:11:47 -0700 (PDT)
Received: from archdragon (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id 71-20020a63034a000000b0040d2d9f15e0sm696995pgd.20.2022.06.23.23.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:11:47 -0700 (PDT)
Date:   Fri, 24 Jun 2022 15:11:41 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: KASAN: use-after-free Read in slcan_receive_buf
Message-ID: <YrVVnaYHtHzJ58L9@archdragon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We observed a crash "KASAN: use-after-free Read in slcan_receive_buf"
during fuzzing.

Unfortunately, we have not found a reproducer for the crash yet. We
will inform you if we have any update on this crash.

Detailed crash information is attached at the end of this email.


Best regards,
Dae R. Jeong.
------

- Kernel commit:
b13baccc3850ca

- Crash report: 
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:87 [inline]
BUG: KASAN: use-after-free in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
BUG: KASAN: use-after-free in netif_running include/linux/netdevice.h:3500 [inline]
BUG: KASAN: use-after-free in slcan_receive_buf+0x15c/0x1930 drivers/net/can/slcan.c:478
Read of size 8 at addr ffff88814e210038 by task syz-executor.0/14712

CPU: 2 PID: 14712 Comm: syz-executor.0 Not tainted 5.19.0-rc2-31838-gef9c98f9637f #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x20a/0x302 lib/dump_stack.c:106
 print_address_description+0x65/0x4f0 mm/kasan/report.c:313
 print_report+0xf4/0x1e0 mm/kasan/report.c:429
 kasan_report+0xe5/0x110 mm/kasan/report.c:491
 kasan_check_range+0x2b5/0x2f0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:87 [inline]
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
 netif_running include/linux/netdevice.h:3500 [inline]
 slcan_receive_buf+0x15c/0x1930 drivers/net/can/slcan.c:478
 tiocsti drivers/tty/tty_io.c:2293 [inline]
 tty_ioctl+0x16be/0x2040 drivers/tty/tty_io.c:2692
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x129/0x1c0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x478dc9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f85b09d4be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000781408 RCX: 0000000000478dc9
RDX: 0000000020000000 RSI: 0000000000005412 RDI: 0000000000000003
RBP: 00000000f477909a R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000007815c0
R13: 0000000000781414 R14: 0000000000781408 R15: 00007ffdd432f550
 </TASK>

The buggy address belongs to the physical page:
page:ffffea0005388400 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14e210
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
raw: 057ff00000000000 ffffea000527d008 ffff88823bc42348 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x446dc0(GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP|__GFP_ZERO), pid 14709, tgid 14708 (syz-executor.0), ts 893919786834, free_ts 894271548507
 prep_new_page mm/page_alloc.c:2456 [inline]
 get_page_from_freelist+0xa7c/0xf50 mm/page_alloc.c:4198
 __alloc_pages+0x30e/0x710 mm/page_alloc.c:5426
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 alloc_pages_node include/linux/gfp.h:610 [inline]
 kmalloc_large_node+0x98/0x1c0 mm/slub.c:4431
 __kmalloc_node+0x655/0x780 mm/slub.c:4447
 kmalloc_node include/linux/slab.h:623 [inline]
 kvmalloc_node+0x6e/0x190 mm/util.c:613
 kvmalloc include/linux/slab.h:750 [inline]
 kvzalloc include/linux/slab.h:758 [inline]
 alloc_netdev_mqs+0x94/0x1 net/core/dev.c:10576
 slc_alloc drivers/net/can/slcan.c:540 [inline]
 slcan_open+0x4eb/0xfc0 drivers/net/can/slcan.c:598
 tty_ldisc_open+0xc6/0x150 drivers/tty/tty_ldisc.c:433
 tty_set_ldisc+0x39f/0xa70 drivers/tty/tty_ldisc.c:558
 tiocsetd drivers/tty/tty_io.c:2433 [inline]
 tty_ioctl+0x1bd0/0x2040 drivers/tty/tty_io.c:2714
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x129/0x1c0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0xa65/0xc90 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page+0x7e/0x740 mm/page_alloc.c:3438
 free_large_kmalloc mm/slub.c:3546 [inline]
 kfree+0x51f/0x7e0 mm/slub.c:4551
 device_release+0xb4/0x2a0
 kobject_cleanup+0x202/0x3f0 lib/kobject.c:673
 netdev_run_todo+0x19c4/0x1c00 net/core/dev.c:10358
 unregister_netdev+0x1e1/0x2d0 net/core/dev.c:10894
 tty_ldisc_hangup+0x24b/0x910 drivers/tty/tty_ldisc.c:700
 __tty_hangup+0x744/0xab0 drivers/tty/tty_io.c:637
 tty_vhangup drivers/tty/tty_io.c:707 [inline]
 tty_ioctl+0xbf1/0x2040 drivers/tty/tty_io.c:2718
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x129/0x1c0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Memory state around the buggy address:
 ffff88814e20ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88814e20ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88814e210000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                        ^
 ffff88814e210080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88814e210100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
