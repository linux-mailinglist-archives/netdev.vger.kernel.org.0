Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9CC62BAEC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiKPLHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiKPLGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:06:15 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BDC4D5E2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:38 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id k21-20020a5e8915000000b006de391b332fso2264527ioj.4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yggIWnBkrSgEc1TV4/3CeEkK1BsJZxCxqkdnT7XvUmc=;
        b=ma3ZMG241Exo66Fe3wxpcrBCBbaXpw9LjEJXPIy0hQxvC3Z5ZgIYpzD49mPCJyqUUn
         HwVE2LFVurILTLDIsQq5qxLrl7n61Avj6mumUuzOdRwdqdmcoLu8tp0w5uQlrcmDTcEu
         xawV1mjbwPQoavpOQng3ks5rR+L3yX0BaA5ZPSKo0gJVEW89Z7S/+42azdvOaF46JxIg
         idKrGvo3PVk34VwICXjFtkIPZ8/n/1DYU48TnTVSyJO4gnLz2BEXSZihC34lXXZm21CY
         p0uGInr+ia1qaXqmbSnAjMknbwK6EJCheCtZVbfSBgX0XTk7A68XEpjKr6A8ARe6r3zz
         zP+w==
X-Gm-Message-State: ANoB5plN1XsBXMj2bQJKalyDYwDGArcTUoYqdc0QBVYCSDU4rEkrf9AX
        GeM7y4tdd7TU/woMmbUazOwxwjOTNt7qJDbtQohunwE6Ve/X
X-Google-Smtp-Source: AA0mqf75uVcSehIfVU98/8TD4pzAUjZPT8lQpls1p3DS6EygAguSetymOuAwv1SaVsU8xuWfLw6884517BwYVRMbePuQVomXJqI+
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:120e:b0:2fc:cea6:7d9f with SMTP id
 a14-20020a056e02120e00b002fccea67d9fmr10231418ilq.89.1668595957727; Wed, 16
 Nov 2022 02:52:37 -0800 (PST)
Date:   Wed, 16 Nov 2022 02:52:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055882e05ed9445a2@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_cmd_timer
From:   syzbot <syzbot+10257d01dd285b15170a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    9500fc6e9e60 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16cbf7a5880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b25c9f218686dd5e
dashboard link: https://syzkaller.appspot.com/bug?extid=10257d01dd285b15170a
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1354dce9880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10880a95880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1363e60652f7/disk-9500fc6e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fcc4da811bb6/vmlinux-9500fc6e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b554298f1fa/Image-9500fc6e.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10257d01dd285b15170a@syzkaller.appspotmail.com

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=000000010c75b000
[0000000000000000] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.0-rc5-syzkaller-32269-g9500fc6e9e60 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __queue_work+0x3c4/0x8b4
lr : __queue_work+0x3c4/0x8b4 kernel/workqueue.c:1458
sp : ffff800008003d60
x29: ffff800008003d60 x28: 0000000000000000 x27: ffff80000d3a9000
x26: ffff80000d3ad050 x25: ffff80000d2fe008 x24: ffff80000db54000
x23: 0000000000000000 x22: 0000000000000023 x21: ffff0000c7a95400
x20: 0000000000000008 x19: ffff0000cd0d20f8 x18: ffff80000db78158
x17: ffff80000ddda198 x16: ffff80000dc18158 x15: ffff80000d3cbc80
x14: 0000000000000000 x13: 00000000ffffffff x12: ffff80000d3cbc80
x11: ff8080000c07dfe4 x10: 0000000000000000 x9 : ffff80000c07dfe4
x8 : ffff80000d3cbc80 x7 : ffff80000813bae8 x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000000 x3 : 0000000000000002
x2 : 0000000000000008 x1 : 0000000000000000 x0 : ffff0000c0014c00
Call trace:
 __queue_work+0x3c4/0x8b4 kernel/workqueue.c:1458
 queue_work_on+0xb0/0x15c kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 nci_cmd_timer+0x30/0x40 net/nfc/nci/core.c:615
 call_timer_fn+0x90/0x144 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers+0x280/0x374 kernel/time/timer.c:1790
 run_timer_softirq+0x34/0x5c kernel/time/timer.c:1803
 _stext+0x168/0x37c
 ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:79
 call_on_irq_stack+0x2c/0x54 arch/arm64/kernel/entry.S:892
 do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:84
 invoke_softirq+0x70/0xbc kernel/softirq.c:452
 __irq_exit_rcu+0xf0/0x140 kernel/softirq.c:650
 irq_exit_rcu+0x10/0x40 kernel/softirq.c:662
 __el1_irq arch/arm64/kernel/entry-common.c:472 [inline]
 el1_interrupt+0x38/0x68 arch/arm64/kernel/entry-common.c:486
 el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:491
 el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:580
 arch_local_irq_enable+0xc/0x18 arch/arm64/include/asm/irqflags.h:35
 default_idle_call+0x48/0xb8 kernel/sched/idle.c:109
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x110/0x2d4 kernel/sched/idle.c:303
 cpu_startup_entry+0x24/0x28 kernel/sched/idle.c:400
 kernel_init+0x0/0x290 init/main.c:729
 start_kernel+0x0/0x620 init/main.c:890
 start_kernel+0x450/0x620 init/main.c:1145
 __primary_switched+0xb4/0xbc arch/arm64/kernel/head.S:471
Code: 94001384 aa0003f7 aa1303e0 9400144a (f94002f8) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	94001384 	bl	0x4e10
   4:	aa0003f7 	mov	x23, x0
   8:	aa1303e0 	mov	x0, x19
   c:	9400144a 	bl	0x5134
* 10:	f94002f8 	ldr	x24, [x23] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
