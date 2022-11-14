Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DEB628C07
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 23:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbiKNWUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 17:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiKNWUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 17:20:36 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9461B1CC;
        Mon, 14 Nov 2022 14:20:18 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id b3so21666660lfv.2;
        Mon, 14 Nov 2022 14:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bFqmhXmSSyq2QzmFIRJsVIBN0HL5QQrPnWoLFMuamTI=;
        b=JAxij3zX8stbjUDqWywJX+D7f0SbwDi3FUOUClzzW2YCjVmGUheMuf1hzmpWZ1YQk7
         CAW4Tvpt6PdM46GoEA6o+oEBWuIatMHAanNhjDo/UE6ZFXl9YrSeJ7Y9lmj0uRN9r5qt
         Bgk3+Clf+EWYxUNBDu4Rz4IUynJVTJvJZvkUcLHuTnQyXDKTi/Ll4O0qb/wDoT2r5WDQ
         f5gEKMHLHEVaE8HPIdjz5ha4zNZlXyL1sXHMk+EqZb5mBe+QDNf3ZBJlpU8KWInBS0iE
         LYWGwoJiFK5OJQ7j9KDDnnS0LO3kdiLzbhSbP0mvh2l9ijco5OGdcbaTI+SFlUlZE4Za
         EZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFqmhXmSSyq2QzmFIRJsVIBN0HL5QQrPnWoLFMuamTI=;
        b=4taB5ZiamFSLls8M29h1KLpOxMilPImVbVCF+ZR+/m4ywAFQchpNYjS+lMs449PpDG
         fkjZCbQZa0KzbrlTjeBVPWmETGlwqZ6VSdeiuSPrcOAgXrkx6psNHMY8BZ3I62ES6/V2
         sfIO28CzYmZDOmh17t195SdA7HwIr349uA/K6mly6DISbFZ3HlKqr0jE6ZhTe8dcKzmW
         fw9aDxW3c0NTiLhWnrWNyIrqZX1SUL83WC71w+BU/a9FyZp2aGmoqeylst0FXqpOhfHM
         xHkn+JmT44zmr9tCm736EUPybdmAdhSInvQtcZnzTn+wo41vHdSbVG8bTk2r/Jyywa5G
         LI3g==
X-Gm-Message-State: ANoB5pkhBCO69OydkRx84qVwJAXjS4PHk1GNU8/xTF5oWs/oXwvmbs3c
        ak2y/nfmfkt8uG+lnw0T7RdouHmNAKCd1cVpCvo=
X-Google-Smtp-Source: AA0mqf5Rz8fA7Nxof9pdF2lt5WIqy9omuV8JN12ArICFnrxa2i6yoFzsNDa5yj68KMEABGLRHuwzj8UQ80kBTQlnG+w=
X-Received: by 2002:ac2:4d58:0:b0:4a2:efc:a882 with SMTP id
 24-20020ac24d58000000b004a20efca882mr5382550lfp.198.1668464416100; Mon, 14
 Nov 2022 14:20:16 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrff45MqORA9aKmLqBTU=renMNZRvVg14YAToe9rm1FX_FQ@mail.gmail.com>
In-Reply-To: <CAO4mrff45MqORA9aKmLqBTU=renMNZRvVg14YAToe9rm1FX_FQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 14 Nov 2022 14:20:04 -0800
Message-ID: <CABBYNZLj34j_=S_xoDFwkqCXw_1fBEKWrr7Xw875iXvD+zXfpQ@mail.gmail.com>
Subject: Re: general protection fault in klist_next
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Nov 13, 2022 at 10:34 PM Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developer,
>
> Recently when using our tool to fuzz kernel, the following crash was
> triggered. A similar patch
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=d5ebaa7c5f6f688959e8d40840b2249ede63b8ed
> is applied but kernel persists.
>
> HEAD commit: 4fe89d07d Linux 6.0
> git tree: upstream
> compiler: clang 12.0.0
> console output:
> https://drive.google.com/file/d/1mXSQ5T1XpV7jcrxa8nM3XMchyWuY8i01/view?usp=share_link
> kernel config: https://drive.google.com/file/d/1ZHRxVTXHL9mENdAPmQYS1DtgbflZ9XsD/view?usp=share_link
> C reproducer: https://drive.google.com/file/d/1iaLcMGNX6pL_x0-3Tag_0Qipdr4FrfMN/view?usp=share_link
> Syz reproducer:
> https://drive.google.com/file/d/15pVBa8YaBuinmQZrxkA1Wx5n8yb4xoo8/view?usp=share_link
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
>
> Bluetooth: hci0: hardware error 0x00
> general protection fault, probably for non-canonical address
> 0xdffffc000000000b: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
> CPU: 0 PID: 51 Comm: kworker/u7:0 Not tainted 6.0.0 #35
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Workqueue: hci0 hci_error_reset
> RIP: 0010:klist_next+0x4a/0x330 lib/klist.c:377
> Code: 4c 89 e8 48 c1 e8 03 48 89 44 24 08 42 80 3c 20 00 74 08 4c 89
> ef e8 65 77 7d fd 49 8b 5d 00 48 8d 6b 58 48 89 e8 48 c1 e8 03 <42> 80
> 3c 20 00 74 08 48 89 ef e8 47 77 7d fd 48 8b 6d 00 4d 8d 75
> RSP: 0018:ffffc90000a979c0 EFLAGS: 00010202
> RAX: 000000000000000b RBX: 0000000000000000 RCX: ffff8880428a2440
> RDX: 0000000000000000 RSI: ffffc90000a97a60 RDI: ffffc90000a97a60
> RBP: 0000000000000058 R08: ffffffff89442273 R09: ffffffff893b7dec
> R10: 0000000000000002 R11: ffff8880428a2440 R12: dffffc0000000000
> R13: ffffc90000a97a60 R14: ffff88801f45c000 R15: ffffffff89442390
> FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f16fc4ac000 CR3: 0000000018532000 CR4: 0000000000752ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  next_device drivers/base/core.c:3756 [inline]
>  device_find_child+0xb0/0x1c0 drivers/base/core.c:3899
>  hci_conn_del_sysfs+0x8c/0x180 net/bluetooth/hci_sysfs.c:71

Well this trace seems to not match what we have in mainline:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/tree/net/bluetooth/hci_sysfs.c#n71

I suspect it is missing:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/net/bluetooth/hci_sysfs.c?id=448a496f760664d3e2e79466aa1787e6abc922b5

We should probably have it sent to stable though.

>  hci_conn_cleanup+0x599/0x750 net/bluetooth/hci_conn.c:147
>  hci_conn_del+0x2ae/0x3b0 net/bluetooth/hci_conn.c:1022
>  hci_conn_hash_flush+0x1bd/0x240 net/bluetooth/hci_conn.c:2367
>  hci_dev_close_sync+0x742/0xd30 net/bluetooth/hci_sync.c:4476
>  hci_dev_do_close net/bluetooth/hci_core.c:554 [inline]
>  hci_error_reset+0xdb/0x1d0 net/bluetooth/hci_core.c:1050
>  process_one_work+0x83c/0x11a0 kernel/workqueue.c:2289
>  worker_thread+0xa6c/0x1290 kernel/workqueue.c:2436
>  kthread+0x266/0x300 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:klist_next+0x4a/0x330 lib/klist.c:377
> Code: 4c 89 e8 48 c1 e8 03 48 89 44 24 08 42 80 3c 20 00 74 08 4c 89
> ef e8 65 77 7d fd 49 8b 5d 00 48 8d 6b 58 48 89 e8 48 c1 e8 03 <42> 80
> 3c 20 00 74 08 48 89 ef e8 47 77 7d fd 48 8b 6d 00 4d 8d 75
> RSP: 0018:ffffc90000a979c0 EFLAGS: 00010202
> RAX: 000000000000000b RBX: 0000000000000000 RCX: ffff8880428a2440
> RDX: 0000000000000000 RSI: ffffc90000a97a60 RDI: ffffc90000a97a60
> RBP: 0000000000000058 R08: ffffffff89442273 R09: ffffffff893b7dec
> R10: 0000000000000002 R11: ffff8880428a2440 R12: dffffc0000000000
> R13: ffffc90000a97a60 R14: ffff88801f45c000 R15: ffffffff89442390
> FS:  0000000000000000(0000) GS:ffff88802cc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f16fc4ac000 CR3: 0000000018532000 CR4: 0000000000752ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> ----------------
> Code disassembly (best guess):
>    0: 4c 89 e8              mov    %r13,%rax
>    3: 48 c1 e8 03           shr    $0x3,%rax
>    7: 48 89 44 24 08        mov    %rax,0x8(%rsp)
>    c: 42 80 3c 20 00        cmpb   $0x0,(%rax,%r12,1)
>   11: 74 08                 je     0x1b
>   13: 4c 89 ef              mov    %r13,%rdi
>   16: e8 65 77 7d fd        callq  0xfd7d7780
>   1b: 49 8b 5d 00           mov    0x0(%r13),%rbx
>   1f: 48 8d 6b 58           lea    0x58(%rbx),%rbp
>   23: 48 89 e8              mov    %rbp,%rax
>   26: 48 c1 e8 03           shr    $0x3,%rax
> * 2a: 42 80 3c 20 00        cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
>   2f: 74 08                 je     0x39
>   31: 48 89 ef              mov    %rbp,%rdi
>   34: e8 47 77 7d fd        callq  0xfd7d7780
>   39: 48 8b 6d 00           mov    0x0(%rbp),%rbp
>   3d: 4d                    rex.WRB
>   3e: 8d                    .byte 0x8d
>   3f: 75                    .byte 0x75
>
> Best,
> Wei



-- 
Luiz Augusto von Dentz
