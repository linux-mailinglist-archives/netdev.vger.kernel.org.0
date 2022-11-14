Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483646273B1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 01:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiKNAFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 19:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235411AbiKNAFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 19:05:49 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A212F590
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 16:05:48 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id j7-20020a056e02154700b003025b3c0ea3so1467902ilu.10
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 16:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hr7wS+pJ69I44GVyM4s7OZmeFSZLRy9SbGypxd6p3yc=;
        b=Zmp9dm4K1ofSLTaoFV9RtLy+p0bwzLTWzLWgwQg22A7C5U/1cCxZyk9FmzlKuKXSWi
         +9KxqsQiwZ2F1yNnP06HH/xvwi488nAjNDOUFpiTMHFPXevK5Ii1zqRQImS6YpaYB9b5
         VkiiZLAkxs0HeE10799xk5Xe1PIpbAsjgUB0LAHZyxEWRi7U1b1Dt1PZk77mRvHkbDON
         rtU72CieVTUO3iDWgscrMKEqIKC16e1dNQcY1WbgNTbIZ904bz2kXYiK1ngBcDrhD96h
         2XPlyduiKzUYm54Yxd19An19XLBVxQzw2d2x5mBIm9T11hqzgFcgOI7NBdcRsMPzsGpu
         uXnw==
X-Gm-Message-State: ANoB5plk2tey3Cr6g1fsBRAutc8lqFIzYXYkQPmK3wi9IHhxh9Tpv+Rv
        4ffJWex4fyOfL1AcNOfJyqCxiCl3J99VGMEsBpAZnpw8MRgk
X-Google-Smtp-Source: AA0mqf5VC9l3lM2/b6X13YxJm5HhrgqaLlkjHm6c7EWMi10KVjfiDZqlulrDwDoJf5kuOjvvN0x/YgAw31Bw5FzcNveKsOPP6o1v
MIME-Version: 1.0
X-Received: by 2002:a6b:b4d2:0:b0:6dd:f70e:dda5 with SMTP id
 d201-20020a6bb4d2000000b006ddf70edda5mr2102788iof.100.1668384347517; Sun, 13
 Nov 2022 16:05:47 -0800 (PST)
Date:   Sun, 13 Nov 2022 16:05:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061fe2205ed6300fa@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in smack_inode_permission
From:   syzbot <syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com>
To:     casey@schaufler-ca.com, jmorris@namei.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, richardcochran@gmail.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    56751c56c2a2 Merge branch 'for-next/fixes' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11fc8b0e880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=606e57fd25c5c6cc
dashboard link: https://syzkaller.appspot.com/bug?extid=0f89bd13eaceccc0e126
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a691fa880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1733c5b9880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cf4668c75dea/disk-56751c56.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1ef82e91ef7/vmlinux-56751c56.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3dabe076170f/Image-56751c56.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000109d98000
[0000000000000028] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 2557 Comm: udevd Not tainted 6.1.0-rc4-syzkaller-31859-g56751c56c2a2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : smack_inode_permission+0x70/0x164 security/smack/smack_lsm.c:1149
lr : smack_inode_permission+0x68/0x164 security/smack/smack_lsm.c:1146
sp : ffff800016a53a30
x29: ffff800016a53a80 x28: fefefefefefefeff
 x27: ffff0000ca5c0025

x26: 0000000000000000
 x25: 0000000000000000
 x24: ffff0000ca5c0025
x23: 0000000000000000 x22: 0000000000000008 x21: 0000000000000001
x20: 0000000000000001 x19: ffff0000c70cf2d8
 x18: 0000000000000000

x17: 0000000000000000
 x16: ffff80000db1a158
 x15: ffff0000c4f39a40
x14: 0000000000000090 x13: 00000000ffffffff x12: ffff0000c4f39a40
x11: ff8080000944189c x10: 0000000000000000 x9 : ffff0000c4f39a40
x8 : ffff80000944189c x7 : ffff8000086feb70 x6 : 0000000000000000
x5 : ffff0000c4f39a40 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : 0000000000000001 x0 : 0000000000000000
Call trace:
 smack_inode_permission+0x70/0x164
 security_inode_permission+0x50/0xa4 security/security.c:1326
 inode_permission+0xa0/0x244 fs/namei.c:533
 may_lookup fs/namei.c:1715 [inline]
 link_path_walk+0x138/0x628 fs/namei.c:2262
 path_lookupat+0x54/0x208 fs/namei.c:2473
 filename_lookup+0xf8/0x264 fs/namei.c:2503
 user_path_at_empty+0x5c/0x114 fs/namei.c:2876
 do_readlinkat+0x84/0x1c8 fs/stat.c:468
 __do_sys_readlinkat fs/stat.c:495 [inline]
 __se_sys_readlinkat fs/stat.c:492 [inline]
 __arm64_sys_readlinkat+0x28/0x3c fs/stat.c:492
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
Code: f90003ff 97b9817f 34000134 8b1602f6 (b94022d7) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f90003ff 	str	xzr, [sp]
   4:	97b9817f 	bl	0xfffffffffee60600
   8:	34000134 	cbz	w20, 0x2c
   c:	8b1602f6 	add	x22, x23, x22
* 10:	b94022d7 	ldr	w23, [x22, #32] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
