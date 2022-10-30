Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FCC612A0D
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJ3KYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJ3KYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:24:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF913CD4;
        Sun, 30 Oct 2022 03:24:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z97so13718332ede.8;
        Sun, 30 Oct 2022 03:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8p/8WjkchVbCQed4zXY7HB/VcJ2xgbVKLLvtzbgDlkE=;
        b=B95hzi3zw61zOcJbz2lsiLm3vKa9RhSae1tAvB6KshsqIboeXTpEBGmb32mBt8hsDa
         ySzGtmOEiB+h6dRVMaPk7BTiIQ8jH4wZZZIU4a0DuecLHZV9lwwLEulLAutG+tfjKxfR
         TaKY0TXtqc7GcknZ6Yaux+ttAVSo/fsrBwrLO0I312bIWva9w1sBGijR1lcGdZSb2e5F
         Kw52nOgHdrfkAu1RVEfwfy6JWKSdQG+h8U+shQXlsEpAk3ZKHtu1UoIul+/X42FifYlf
         9mWu0FVSSNCIvUuoLtFQ5MumP2mXWoAHkzSz8yFqrsSl9Lctk9aNdnVADmWdh3XH3HjE
         rIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8p/8WjkchVbCQed4zXY7HB/VcJ2xgbVKLLvtzbgDlkE=;
        b=CugN37fVtOM6hixoOQ0JRpgxsKshWxMy8KpBq3T9jAf0AwejlW/XxcLOYvuhRSkUN9
         r39MrcP8zEDKv95vqQKD+n3jk+f/0CfVJo8LSFrSme4PeR0b6tLaMqujzgc3odRwY9Cd
         AS7Awq/OPJAzCAzHdwOm/q5/59G5MLs6Jy6/DfWGgS0EBWxhix0Sr1rvOV3vV7JCfjey
         2tZYpMVVlwRN1dIeG0xrilibJZS1LOQiMs2B8YAyb/FXLS5wi0pD6O9HJYswVUJv8IsW
         EymABFV1wT0ZPr06hEI8NpkFRc7X/NLjaVJKV04k08MYHD6O7gsWzgP+BL4qpxm/PTwA
         1JyQ==
X-Gm-Message-State: ACrzQf0GdEMlcs9fCyKdl06r9qcMeLp8bukXCI0q9nP+Edu07LFG4LYb
        nWE4anWJmt+bK91k88cwBpfTeQdcFqwfB4PJIm/4WZMV59I8+g==
X-Google-Smtp-Source: AMsMyM5svCDvEG+F68rVlzfhptxtspwaLj/f+Xtw3xH+nHQ2D3gvlo1KiOt2HzFnFb3PEyZHkixisf0dpd/hkKk9k+s=
X-Received: by 2002:a05:6402:5291:b0:45c:3f6a:d4bc with SMTP id
 en17-20020a056402529100b0045c3f6ad4bcmr8150308edb.285.1667125467183; Sun, 30
 Oct 2022 03:24:27 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 18:23:49 +0800
Message-ID: <CAO4mrfeFrYwFEYmULU0DWxG3kOq+M-=uqRJNp8b-RKy6wzvEsw@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in tipc_crypto_key_distr
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org,
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
https://drive.google.com/file/d/1ZxNXcUkiJiTK6MzVIWCqDpq70QW2-t-b/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

RBP: 0000000000000045 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bfac
R13: 0000000000000000 R14: 000000000119bfa0 R15: 00007fffcffa6fe0
BUG: kernel NULL pointer dereference, address: 0000000000000020
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 2763b067 P4D 2763b067 PUD 27636067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 12346 Comm: syz-executor.0 Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:tipc_crypto_key_distr+0x121/0x6a0
Code: 00 48 8b 13 88 85 60 ff ff ff 41 0f b7 44 24 48 48 89 95 68 ff
ff ff 66 89 85 5c ff ff ff 49 8b 44 24 40 48 89 85 50 ff ff ff <8b> 40
20 83 c0 24 0f b7 c0 83 c0 28 89 c7 89 85 64 ff ff ff e8 96
RSP: 0018:ffffc9000d48f8e0 EFLAGS: 00010212
RAX: 0000000000000000 RBX: ffff888010979a00 RCX: 0000000000040000
RDX: ffff8880163e0000 RSI: 0000000000000a20 RDI: 0000000000000002
RBP: ffffc9000d48f998 R08: ffffffff847c7f3d R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88803189eb00
R13: 0000000000000001 R14: 0000000000000000 R15: 00000000ffffff82
FS:  00007f54fc3f7700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 0000000027638000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_nl_node_set_key+0x760/0x930
 genl_family_rcv_msg_doit.isra.16+0x141/0x190
 genl_rcv_msg+0x172/0x2c0
 netlink_rcv_skb+0x87/0x1d0
 genl_rcv+0x24/0x40
 netlink_unicast+0x2b8/0x3d0
 netlink_sendmsg+0x350/0x680
 sock_sendmsg+0x52/0x70
 ____sys_sendmsg+0x35f/0x390
 ___sys_sendmsg+0x95/0xd0
 __sys_sendmsg+0x87/0x100
 do_syscall_64+0x34/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4692c9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f54fc3f6c38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f54fc3f6c80 RCX: 00000000004692c9
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000003
RBP: 0000000000000045 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bfac
R13: 0000000000000000 R14: 000000000119bfa0 R15: 00007fffcffa6fe0
Modules linked in:
CR2: 0000000000000020
---[ end trace c7813f5e0b2eeeab ]---
RIP: 0010:tipc_crypto_key_distr+0x121/0x6a0
Code: 00 48 8b 13 88 85 60 ff ff ff 41 0f b7 44 24 48 48 89 95 68 ff
ff ff 66 89 85 5c ff ff ff 49 8b 44 24 40 48 89 85 50 ff ff ff <8b> 40
20 83 c0 24 0f b7 c0 83 c0 28 89 c7 89 85 64 ff ff ff e8 96
RSP: 0018:ffffc9000d48f8e0 EFLAGS: 00010212
RAX: 0000000000000000 RBX: ffff888010979a00 RCX: 0000000000040000
RDX: ffff8880163e0000 RSI: 0000000000000a20 RDI: 0000000000000002
RBP: ffffc9000d48f998 R08: ffffffff847c7f3d R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff88803189eb00
R13: 0000000000000001 R14: 0000000000000000 R15: 00000000ffffff82
FS:  00007f54fc3f7700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 0000000027638000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0: 00 48 8b              add    %cl,-0x75(%rax)
   3: 13 88 85 60 ff ff    adc    -0x9f7b(%rax),%ecx
   9: ff 41 0f              incl   0xf(%rcx)
   c: b7 44                mov    $0x44,%bh
   e: 24 48                and    $0x48,%al
  10: 48 89 95 68 ff ff ff mov    %rdx,-0x98(%rbp)
  17: 66 89 85 5c ff ff ff mov    %ax,-0xa4(%rbp)
  1e: 49 8b 44 24 40        mov    0x40(%r12),%rax
  23: 48 89 85 50 ff ff ff mov    %rax,-0xb0(%rbp)
* 2a: 8b 40 20              mov    0x20(%rax),%eax <-- trapping instruction
  2d: 83 c0 24              add    $0x24,%eax
  30: 0f b7 c0              movzwl %ax,%eax
  33: 83 c0 28              add    $0x28,%eax
  36: 89 c7                mov    %eax,%edi
  38: 89 85 64 ff ff ff    mov    %eax,-0x9c(%rbp)
  3e: e8                    .byte 0xe8
  3f: 96                    xchg   %eax,%esi

Best,
We
