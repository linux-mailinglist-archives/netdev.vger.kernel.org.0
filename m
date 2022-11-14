Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E361A6275F6
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 07:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiKNGe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 01:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiKNGe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 01:34:59 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C8711150;
        Sun, 13 Nov 2022 22:34:57 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l11so15855486edb.4;
        Sun, 13 Nov 2022 22:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/7qP7dwxDh5y8RxAZ1reOMhR1IZbWIotT7X6Hnl0pzM=;
        b=fU6KfdRtqbdJpKPO4Y0gb5xAXBIOxCsCsk2VsqPWm+ExRGdn9htxwFisBsfRv/Hr06
         f+TtkaFWVzhcwCdSzMXUpvOFge8helqjrR81R11mJJbbN51QUEz16qRI7amJP2iqlZjV
         u+BvkX5+HEzgMUtrPxIhoWrSOiDA8+2XGrJISAEeBj5gwVSrM1qR5qmAdys4mV6awAx6
         BE6e1VmIUI6TVa680TGYq39knpGTokRZKwS9IjuCQUtcozYqRsaENoZd3rwhNAb+xc4h
         kP/hLJqc1WFgtBUfe0vZsvdFd1V8992iZfqql1RC1WBZ3DyQHMjtrXdFT86Mw3lwOBB/
         NmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/7qP7dwxDh5y8RxAZ1reOMhR1IZbWIotT7X6Hnl0pzM=;
        b=bANUWJm1L1uVRMYF7i/KXGAozPD9O+/qdF7nenER2d6ir9mI3Irehu/UDvXgCQ0FbT
         1Nklw5RXyX8l9328tWlKXj9+9LL/bP/XmxlCTu7Ud5r51oXznNMerknZOUUWfoggcq38
         FPNOzyVi5LK5E8Cf3BOyg7bkxadOYfFpRz52wzO+ybwpS8qzr/kb0TniYSczT2rpp+LK
         0r76ZhcEVkQPQ5eR7fG54IDD/pWakmyEBG1TdyWKYRk0lOJgTIJjq09cp3daXuFpiPgi
         YaIg/Tyx03beuT3D1Z/vqPlRNJ94h3mukWb3JaL+26KWewYQgO4QWMwyyDkHIt+zapGu
         VEDQ==
X-Gm-Message-State: ANoB5plUArSUteMD5BJC9m8OLvtpaZ+GCGYKFuUUQkW14rfF7Vl6RsH9
        uJt22P6DtvPGT9G73Gvu8L2mzdpPV5BIWH53A38=
X-Google-Smtp-Source: AA0mqf5F5n8n3WobS6RcDh6iIh17AK1lxBK6c8L+ZcIW6mge+Qs1VAcenDiVThyywroci438qz8DhJ+gBt8r5QhO9pI=
X-Received: by 2002:aa7:d3c1:0:b0:467:30ad:c4ca with SMTP id
 o1-20020aa7d3c1000000b0046730adc4camr10015519edr.285.1668407696302; Sun, 13
 Nov 2022 22:34:56 -0800 (PST)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 14 Nov 2022 14:34:20 +0800
Message-ID: <CAO4mrff45MqORA9aKmLqBTU=renMNZRvVg14YAToe9rm1FX_FQ@mail.gmail.com>
Subject: general protection fault in klist_next
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
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

Recently when using our tool to fuzz kernel, the following crash was
triggered. A similar patch
https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=d5ebaa7c5f6f688959e8d40840b2249ede63b8ed
is applied but kernel persists.

HEAD commit: 4fe89d07d Linux 6.0
git tree: upstream
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1mXSQ5T1XpV7jcrxa8nM3XMchyWuY8i01/view?usp=share_link
kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1DtgbflZ9XsD/view?usp=share_link
C reproducer: https://drive.google.com/file/d/1iaLcMGNX6pL_x0-3Tag_0Qipdr4FrfMN/view?usp=share_link
Syz reproducer:
https://drive.google.com/file/d/15pVBa8YaBuinmQZrxkA1Wx5n8yb4xoo8/view?usp=share_link

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

Bluetooth: hci0: hardware error 0x00
general protection fault, probably for non-canonical address
0xdffffc000000000b: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
CPU: 0 PID: 51 Comm: kworker/u7:0 Not tainted 6.0.0 #35
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: hci0 hci_error_reset
RIP: 0010:klist_next+0x4a/0x330 lib/klist.c:377
Code: 4c 89 e8 48 c1 e8 03 48 89 44 24 08 42 80 3c 20 00 74 08 4c 89
ef e8 65 77 7d fd 49 8b 5d 00 48 8d 6b 58 48 89 e8 48 c1 e8 03 <42> 80
3c 20 00 74 08 48 89 ef e8 47 77 7d fd 48 8b 6d 00 4d 8d 75
RSP: 0018:ffffc90000a979c0 EFLAGS: 00010202
RAX: 000000000000000b RBX: 0000000000000000 RCX: ffff8880428a2440
RDX: 0000000000000000 RSI: ffffc90000a97a60 RDI: ffffc90000a97a60
RBP: 0000000000000058 R08: ffffffff89442273 R09: ffffffff893b7dec
R10: 0000000000000002 R11: ffff8880428a2440 R12: dffffc0000000000
R13: ffffc90000a97a60 R14: ffff88801f45c000 R15: ffffffff89442390
FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f16fc4ac000 CR3: 0000000018532000 CR4: 0000000000752ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 next_device drivers/base/core.c:3756 [inline]
 device_find_child+0xb0/0x1c0 drivers/base/core.c:3899
 hci_conn_del_sysfs+0x8c/0x180 net/bluetooth/hci_sysfs.c:71
 hci_conn_cleanup+0x599/0x750 net/bluetooth/hci_conn.c:147
 hci_conn_del+0x2ae/0x3b0 net/bluetooth/hci_conn.c:1022
 hci_conn_hash_flush+0x1bd/0x240 net/bluetooth/hci_conn.c:2367
 hci_dev_close_sync+0x742/0xd30 net/bluetooth/hci_sync.c:4476
 hci_dev_do_close net/bluetooth/hci_core.c:554 [inline]
 hci_error_reset+0xdb/0x1d0 net/bluetooth/hci_core.c:1050
 process_one_work+0x83c/0x11a0 kernel/workqueue.c:2289
 worker_thread+0xa6c/0x1290 kernel/workqueue.c:2436
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:klist_next+0x4a/0x330 lib/klist.c:377
Code: 4c 89 e8 48 c1 e8 03 48 89 44 24 08 42 80 3c 20 00 74 08 4c 89
ef e8 65 77 7d fd 49 8b 5d 00 48 8d 6b 58 48 89 e8 48 c1 e8 03 <42> 80
3c 20 00 74 08 48 89 ef e8 47 77 7d fd 48 8b 6d 00 4d 8d 75
RSP: 0018:ffffc90000a979c0 EFLAGS: 00010202
RAX: 000000000000000b RBX: 0000000000000000 RCX: ffff8880428a2440
RDX: 0000000000000000 RSI: ffffc90000a97a60 RDI: ffffc90000a97a60
RBP: 0000000000000058 R08: ffffffff89442273 R09: ffffffff893b7dec
R10: 0000000000000002 R11: ffff8880428a2440 R12: dffffc0000000000
R13: ffffc90000a97a60 R14: ffff88801f45c000 R15: ffffffff89442390
FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f16fc4ac000 CR3: 0000000018532000 CR4: 0000000000752ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
----------------
Code disassembly (best guess):
   0: 4c 89 e8              mov    %r13,%rax
   3: 48 c1 e8 03           shr    $0x3,%rax
   7: 48 89 44 24 08        mov    %rax,0x8(%rsp)
   c: 42 80 3c 20 00        cmpb   $0x0,(%rax,%r12,1)
  11: 74 08                 je     0x1b
  13: 4c 89 ef              mov    %r13,%rdi
  16: e8 65 77 7d fd        callq  0xfd7d7780
  1b: 49 8b 5d 00           mov    0x0(%r13),%rbx
  1f: 48 8d 6b 58           lea    0x58(%rbx),%rbp
  23: 48 89 e8              mov    %rbp,%rax
  26: 48 c1 e8 03           shr    $0x3,%rax
* 2a: 42 80 3c 20 00        cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f: 74 08                 je     0x39
  31: 48 89 ef              mov    %rbp,%rdi
  34: e8 47 77 7d fd        callq  0xfd7d7780
  39: 48 8b 6d 00           mov    0x0(%rbp),%rbp
  3d: 4d                    rex.WRB
  3e: 8d                    .byte 0x8d
  3f: 75                    .byte 0x75

Best,
Wei
