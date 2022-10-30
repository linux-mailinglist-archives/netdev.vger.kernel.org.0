Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27176129F8
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ3KO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJ3KO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:14:26 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF6325C5;
        Sun, 30 Oct 2022 03:14:25 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id q9so22957524ejd.0;
        Sun, 30 Oct 2022 03:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fLzUW6Q2g0G73bTu/vsBL7pHuGDOT44mWe48IS/4Uiw=;
        b=PsVsr1v+BhXPHyF0yYNOHX/d+i6W1miCIU+8CH8ME61pb8Hl2ic5CzK6rZGznU5Byf
         5Qch0ZsvJyOKyXv/98my5BoAhaYePilQ5aoRp2RPzH/l3YMX5vxTjPGGbtkvKlrP97Lk
         P4HQNSlxPkuPuarBx9QHa02rV5GceEv7DU5l4SMSPtbgQPcQAwb271eegjUWyQzUWTqm
         BM0m6UZAQ7qwndkdJBL/Z+TBgAGwJ6vewlL1SGg3RTQxBGnLnI3GckBMz3yzIwtuBCPX
         PGKnHv0N3SD9emFlcGR0qm4IsBZfSvymdCoep6Nt+Ts2Xn/SUP3k+KlhBTWg3riibx0r
         vTsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fLzUW6Q2g0G73bTu/vsBL7pHuGDOT44mWe48IS/4Uiw=;
        b=4FRwENqWQ/JBvOSSkeeNUc8RkhWFc9mBpXbpOOepMvlJVLGsqDEVtEYkzySoGIJfuD
         J9/xrBdxZgvlBOYccbGCF4QCI0fZXpkRaUfqkUgSs60OGqoA66SuMDcpwG08w/PIZW66
         tdBf0d2OZWiIOISIWNXCy9SbYgyt872cbkjSdhdsSNhOTczU9hnSpQ58+3N4FILTwovR
         xWawcBu2Wz4ynsgRkliIF0qLmrPcttaQuh5bAdo0LP3uGOJlGVviG6KDySGBYKsSeTLq
         JWf/89ba1R2DdojejihzWEFjcggfhHa+kwSNWRqWa8N9LPA3hl3LN+oZnjRYoY2FKIc+
         6F9Q==
X-Gm-Message-State: ACrzQf1U1945uVsN7Ohh63KpSfcTEHBII47LCQJ0ANhz86DSaZgUl4FS
        SIckB5YUt1aC2ME8o7TMnzrB7uOoVXvutEYZqUQ=
X-Google-Smtp-Source: AMsMyM4WtFe09VJbe5pFvwRGYSLUSmLLF06chL3hpMiHyroPcmvXFLL5lrEH9raubmujeBQg897BnaM/+838wNhy51E=
X-Received: by 2002:a17:907:2d06:b0:78d:50db:130e with SMTP id
 gs6-20020a1709072d0600b0078d50db130emr7409715ejc.371.1667124863848; Sun, 30
 Oct 2022 03:14:23 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 18:13:44 +0800
Message-ID: <CAO4mrfcW2NzeigGk26DbuZBs_br86krAMW5Xos_=BuAUBr5OAg@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in tipc_conn_close
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
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

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
compiler: gcc 8.0.1
console output:
https://drive.google.com/file/d/1nDvjcSyhzWncMlR35k1P1dC8rswJ_Zin/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

BUG: kernel NULL pointer dereference, address: 0000000000000018
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 7336 Comm: kworker/u4:4 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:tipc_conn_close+0x12/0x100
Code: 02 01 e8 52 74 20 00 e9 c6 fd ff ff 66 90 66 2e 0f 1f 84 00 00
00 00 00 41 55 41 54 55 53 48 89 fb e8 82 4f c2 fc 48 8b 43 08 <4c> 8b
68 18 4d 8d a5 b0 03 00 00 4c 89 e7 e8 fb 36 44 00 f0 48 0f
RSP: 0018:ffffc90005137d60 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88805a9eea00 RCX: ffff88810b035280
RDX: 0000000000000000 RSI: ffff88810b035280 RDI: 0000000000000002
RBP: ffffc90005137db0 R08: ffffffff847b23de R09: 0000000000000001
R10: 0000000000000005 R11: 0000000000000000 R12: ffff88810bdeed40
R13: 000000000000027b R14: ffff88805a9eea00 R15: ffff88810ebc2058
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 000000010b0e2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_topsrv_exit_net+0x139/0x320
 ops_exit_list.isra.9+0x49/0x80
 cleanup_net+0x31a/0x540
 process_one_work+0x3fa/0x9f0
 worker_thread+0x42/0x5c0
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
Modules linked in:
CR2: 0000000000000018
---[ end trace 1524bb8c4ed3c3b4 ]---
RIP: 0010:tipc_conn_close+0x12/0x100
Code: 02 01 e8 52 74 20 00 e9 c6 fd ff ff 66 90 66 2e 0f 1f 84 00 00
00 00 00 41 55 41 54 55 53 48 89 fb e8 82 4f c2 fc 48 8b 43 08 <4c> 8b
68 18 4d 8d a5 b0 03 00 00 4c 89 e7 e8 fb 36 44 00 f0 48 0f
RSP: 0018:ffffc90005137d60 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88805a9eea00 RCX: ffff88810b035280
RDX: 0000000000000000 RSI: ffff88810b035280 RDI: 0000000000000002
RBP: ffffc90005137db0 R08: ffffffff847b23de R09: 0000000000000001
R10: 0000000000000005 R11: 0000000000000000 R12: ffff88810bdeed40
R13: 000000000000027b R14: ffff88805a9eea00 R15: ffff88810ebc2058
FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 000000010b0e2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: 02 01                add    (%rcx),%al
   2: e8 52 74 20 00        callq  0x207459
   7: e9 c6 fd ff ff        jmpq   0xfffffdd2
   c: 66 90                xchg   %ax,%ax
   e: 66 2e 0f 1f 84 00 00 nopw   %cs:0x0(%rax,%rax,1)
  15: 00 00 00
  18: 41 55                push   %r13
  1a: 41 54                push   %r12
  1c: 55                    push   %rbp
  1d: 53                    push   %rbx
  1e: 48 89 fb              mov    %rdi,%rbx
  21: e8 82 4f c2 fc        callq  0xfcc24fa8
  26: 48 8b 43 08          mov    0x8(%rbx),%rax
* 2a: 4c 8b 68 18          mov    0x18(%rax),%r13 <-- trapping instruction
  2e: 4d 8d a5 b0 03 00 00 lea    0x3b0(%r13),%r12
  35: 4c 89 e7              mov    %r12,%rdi
  38: e8 fb 36 44 00        callq  0x443738
  3d: f0                    lock
  3e: 48                    rex.W
  3f: 0f                    .byte 0xf

Best,
Wei
