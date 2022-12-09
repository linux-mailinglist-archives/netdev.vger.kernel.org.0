Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FE9647D66
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 06:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiLIFop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 00:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLIFon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 00:44:43 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCDE18380;
        Thu,  8 Dec 2022 21:44:42 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id kw15so9042921ejc.10;
        Thu, 08 Dec 2022 21:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tlYZR3ZAgmc6hHjlk+8dcH0CytRjrSRYrr/M//mA3ro=;
        b=k4q7hKEUBTqfWGDBcbacsEt48PbWTKqp2BntffDDmq+b6b7zdSvbeTdK3KpuaYBvA6
         y1ptJByCQRPdmf2wKYkFtmvG68QTDe5ndiP1bS1/sfWiYP0QN0Grh/6k8y3D47R6j3oR
         Nb3IcttmXnqdktGSja0rXprnhdQwSz4tJ0U0NurQQMElCI0BjiL26m3dzIWc+eD8kdJE
         GGp99mfrVNzyOwaXGSEaabwReQdLJwtKYVw8j+Mg7vWvAE/tdYhqMbaNNFET7aNuidCw
         XgJE3VZoet+MhDwBO7RXB3/DJBQ6LSjFUAyUEo1Fbe1b9L3T8BqCKAAT4tkYIsRFcADi
         bDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tlYZR3ZAgmc6hHjlk+8dcH0CytRjrSRYrr/M//mA3ro=;
        b=oocZeqt/PQSK9G3cgNodJovD0FUttIxOtXxsMz71ibwC33fkKSmbqHeiFPCiRWauUw
         b5JNFPRjpQluPdcb95HmgTe3c5K5rbWSifmeiP4NjG9iCjjzdNd/p5EYYbOJbd6Ab8LV
         Cj2jTWmlYHLbit3gfdSlhgX7KwwCt7pbugQTrGNhZ1Plh0G1YAERlR341Pi/gzU38DSi
         iDO0IAlRl/hcDebNt0aC64taW5I+pTBdRswFaEobPL1iQVDjbpiddzFUVKbi+sCfizF3
         LkCCG+jcppDX2knwEAg3QScAH7nJ2puBnoQ9vK+fsNXmm7vRt40m0k8iy65gmYVc3wld
         yD8g==
X-Gm-Message-State: ANoB5pnDgsg91fQaxMQJ1HceX3gmfFrMOcb4ua2K4377ltmV+VaYmKaV
        Stz0VUAiNKdA1oLq96TEWExX+WeKmFCsCOQzeg7paHGHDtSvtA==
X-Google-Smtp-Source: AA0mqf6evUxjaUXBXX54VWe9di7lKQ4fZa0LE01gZO3dMxVy82R3aCqx5CWvbZD+2WuDKr2R9XYB68pQSQGNw17xi84=
X-Received: by 2002:a17:906:2851:b0:78d:88c7:c1bf with SMTP id
 s17-20020a170906285100b0078d88c7c1bfmr64041738ejc.299.1670564680562; Thu, 08
 Dec 2022 21:44:40 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Fri, 9 Dec 2022 13:44:04 +0800
Message-ID: <CAO4mrffkMvj87eq1G5toL2nG=VWMPK0qxQ7FJ9WtpXfBzUtWiA@mail.gmail.com>
Subject: general protection fault in phonet_device_notify
To:     courmisch@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developers,

Recently, when using our tool to fuzz kernel, the following crash was triggered.

HEAD commit: 147307c69ba
git tree: linux-next
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1RvsQqnpZcaUm_fww5nuUh5L8IeEDNeSM/view?usp=share_link
kernel config: https://drive.google.com/file/d/1NAf4S43d9VOKD52xbrqw-PUP1Mbj8z-S/view?usp=share_link

Unfortunately, I didn't have a reproducer for this crash. When calling
__phonet_get, some phonet devices are freed when going through
pndevs->list, leading to invalid value of pnd, thus causing general
protection fault when performing dereference. I'm wondering if there
is a data race due to improper usage of lock.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

general protection fault, probably for non-canonical address
0x20ce10294000010: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 9714 Comm: syz-executor.0 Not tainted 6.1.0-rc5-next-20221118 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:__phonet_get net/phonet/pn_dev.c:69 [inline]
RIP: 0010:phonet_device_destroy net/phonet/pn_dev.c:95 [inline]
RIP: 0010:phonet_device_notify+0x239/0x6a0 net/phonet/pn_dev.c:289
Code: 04 00 00 4c 89 ef e8 f6 85 f2 fc 49 8b 5d 00 4c 39 eb 74 33 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 8d 7b 10 e8 d7 85 f2 fc <4c> 39
63 10 74 1e 48 89 df e8 c9 85 f2 fc 48 8b 1b 4c 39 eb 74 5e
RSP: 0018:ffffc90004fdfa88 EFLAGS: 00010246
RAX: ffff88800a583a48 RBX: 020ce10294000000 RCX: ffffffff84489989
RDX: 00000000000008c3 RSI: 0000000000000000 RDI: 020ce10294000010
RBP: 0000000000000051 R08: 0000e10294000017 R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff88800a583000 R12: ffff888127d3c000
R13: ffff888106ec8c00 R14: ffff888127d3c530 R15: ffff888106ec8c10
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643fdc4eaa8 CR3: 0000000104b97000 CR4: 00000000003506f0
Call Trace:
 <TASK>
 notifier_call_chain kernel/notifier.c:87 [inline]
 raw_notifier_call_chain+0x53/0xb0 kernel/notifier.c:455
 call_netdevice_notifiers_info net/core/dev.c:1944 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10227 [inline]
 netdev_run_todo+0x4be/0x9a0 net/core/dev.c:10341
 rtnl_unlock+0xa/0x10 net/core/rtnetlink.c:148
 tun_detach drivers/net/tun.c:704 [inline]
 tun_chr_close+0x8f/0xa0 drivers/net/tun.c:3460
 __fput+0x2a2/0x560 fs/file_table.c:320
 ____fput+0x11/0x20 fs/file_table.c:348
 task_work_run+0xde/0x110 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x5a0/0x16c0 kernel/exit.c:820
 do_group_exit+0xfe/0x140 kernel/exit.c:950
 get_signal+0xfd7/0x1100 kernel/signal.c:2858
 arch_do_signal_or_restart+0x85/0x280 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0xb4/0x130 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:296
 do_syscall_64+0x37/0x70 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x418d4e
Code: Unable to access opcode bytes at 0x418d24.
RSP: 002b:00007fca3c11a780 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: 0000000000000004 RBX: 6666666666666667 RCX: 0000000000418d4e
RDX: 0000000000000002 RSI: 00007fca3c11a810 RDI: 00000000ffffff9c
RBP: 00007fca3c11a810 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000077c038
R13: 0000000000000000 R14: 000000000077c038 R15: 00007fffc05f99c0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phonet_get net/phonet/pn_dev.c:69 [inline]
RIP: 0010:phonet_device_destroy net/phonet/pn_dev.c:95 [inline]
RIP: 0010:phonet_device_notify+0x239/0x6a0 net/phonet/pn_dev.c:289
Code: 04 00 00 4c 89 ef e8 f6 85 f2 fc 49 8b 5d 00 4c 39 eb 74 33 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 8d 7b 10 e8 d7 85 f2 fc <4c> 39
63 10 74 1e 48 89 df e8 c9 85 f2 fc 48 8b 1b 4c 39 eb 74 5e
RSP: 0018:ffffc90004fdfa88 EFLAGS: 00010246
RAX: ffff88800a583a48 RBX: 020ce10294000000 RCX: ffffffff84489989
RDX: 00000000000008c3 RSI: 0000000000000000 RDI: 020ce10294000010
RBP: 0000000000000051 R08: 0000e10294000017 R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff88800a583000 R12: ffff888127d3c000
R13: ffff888106ec8c00 R14: ffff888127d3c530 R15: ffff888106ec8c10
FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643fdc4eaa8 CR3: 0000000104b97000 CR4: 00000000003506f0
----------------
Code disassembly (best guess):
   0: 04 00                 add    $0x0,%al
   2: 00 4c 89 ef           add    %cl,-0x11(%rcx,%rcx,4)
   6: e8 f6 85 f2 fc       callq  0xfcf28601
   b: 49 8b 5d 00           mov    0x0(%r13),%rbx
   f: 4c 39 eb             cmp    %r13,%rbx
  12: 74 33                 je     0x47
  14: 66 2e 0f 1f 84 00 00 nopw   %cs:0x0(%rax,%rax,1)
  1b: 00 00 00
  1e: 0f 1f 00             nopl   (%rax)
  21: 48 8d 7b 10           lea    0x10(%rbx),%rdi
  25: e8 d7 85 f2 fc       callq  0xfcf28601
* 2a: 4c 39 63 10           cmp    %r12,0x10(%rbx) <-- trapping instruction
  2e: 74 1e                 je     0x4e
  30: 48 89 df             mov    %rbx,%rdi
  33: e8 c9 85 f2 fc       callq  0xfcf28601
  38: 48 8b 1b             mov    (%rbx),%rbx
  3b: 4c 39 eb             cmp    %r13,%rbx
  3e: 74 5e                 je     0x9e

Best,
Wei
