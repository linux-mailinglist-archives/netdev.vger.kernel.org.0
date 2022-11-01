Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88503614323
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKACVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKACVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:21:18 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58912B3F;
        Mon, 31 Oct 2022 19:21:17 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13be3ef361dso15439233fac.12;
        Mon, 31 Oct 2022 19:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9nzZpou9nbIrKUSy709rfhGA3WdbL4kkGKzuRffose0=;
        b=QTT8+1pMYVDtrcBUwKd9uoilHn1ltZwoazoNAsUvozNUxoxYnXFZmnSnZ0VM5Sf+K3
         OmYs4+AOSGMZezoYi//absvNDTu64cil8vK7VAPTtIeZGdYdM2q8joRnydFQRf5bneNm
         52nodAncSAlb08xF3fjG4mvDl7WRoon4amp9kTqol4cnApiYFwZsU5ytEDJGH/D681sW
         AvJZPMG7NgPIAWXiS6tByjoTbBaSoNbWdUR+b0UVYLrj0eTNY393uST1/WWtDve5OLg7
         24SBULmG/fy8496TYT6m3Le0ZvhkAgrJc22IHLACtO6xm9kYzBLiwBjY3mmmddmHuIMk
         FuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9nzZpou9nbIrKUSy709rfhGA3WdbL4kkGKzuRffose0=;
        b=qwZaIvJKcb9A3I8Cts9IVIZSGIUEbGDwfuAzqJ04YAk+BaO4z2UWvqq0fISmWcXtw2
         hAs/zMiEDnEN7mpX4bSs+hm9ZSIKAh0ACEBaD7pnMsF95gudQ/6ceEvZu1Q2f8HjMcFV
         FYkI82FtgmGWSeB/CmPZEOhmwcX/3Zl5n8ed+Pfp5ia9Ip/ndm+B2sVqQvj73dkNu+CD
         zXslyq4lxtDuWSdyhaN+Ir7GwwlETVn9xs6aLZ3y9JvgXZnpdDJ/fiUhAAU1iO3RmW4E
         aZC+LU0CTo1ihX6gNSpcFFPKB469Wq6AMhz0NMFuZ0u8IrVptR7m+hqLv4MR8ZB6WurR
         3F6g==
X-Gm-Message-State: ACrzQf2LeUdGHpi9XCCvTAFjn3nJ7jA6mfmp8eTUScqtBdxX80ruGgjA
        zviQKXuJDh2CicERl0jKSJrf7vRPX70snOIc/IZFEKbbtVz+Dg==
X-Google-Smtp-Source: AMsMyM6WnBg540Hfmbri+EkeavZMXeyHbQQPNx+0XI8zQ9WEC16y02jdNF1sEZPdw+j8PDAmsWqvxQaprg1T3O5vDnk=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr19367674oaq.190.1667269276561; Mon, 31
 Oct 2022 19:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4mrfcW2NzeigGk26DbuZBs_br86krAMW5Xos_=BuAUBr5OAg@mail.gmail.com>
In-Reply-To: <CAO4mrfcW2NzeigGk26DbuZBs_br86krAMW5Xos_=BuAUBr5OAg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 31 Oct 2022 22:20:53 -0400
Message-ID: <CADvbK_c8uMouPVx=BqHQ6D4QvL=9H26FNH_nHk89aK-KHFLgMg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in tipc_conn_close
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
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

On Sun, Oct 30, 2022 at 6:20 AM Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developer,
>
> Recently when using our tool to fuzz kernel, the following crash was triggered:
>
> HEAD commit: 64570fbc14f8 Linux 5.15-rc5
> git tree: upstream
> compiler: gcc 8.0.1
> console output:
> https://drive.google.com/file/d/1nDvjcSyhzWncMlR35k1P1dC8rswJ_Zin/view?usp=share_link
> kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
>
> BUG: kernel NULL pointer dereference, address: 0000000000000018
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 1 PID: 7336 Comm: kworker/u4:4 Not tainted 5.15.0-rc5 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> Workqueue: netns cleanup_net
> RIP: 0010:tipc_conn_close+0x12/0x100
con->sock is set only after tipc_topsrv_accept() is called by awork.
We should do the check under a proper lock.

Will think about it, thanks.

> Code: 02 01 e8 52 74 20 00 e9 c6 fd ff ff 66 90 66 2e 0f 1f 84 00 00
> 00 00 00 41 55 41 54 55 53 48 89 fb e8 82 4f c2 fc 48 8b 43 08 <4c> 8b
> 68 18 4d 8d a5 b0 03 00 00 4c 89 e7 e8 fb 36 44 00 f0 48 0f
> RSP: 0018:ffffc90005137d60 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88805a9eea00 RCX: ffff88810b035280
> RDX: 0000000000000000 RSI: ffff88810b035280 RDI: 0000000000000002
> RBP: ffffc90005137db0 R08: ffffffff847b23de R09: 0000000000000001
> R10: 0000000000000005 R11: 0000000000000000 R12: ffff88810bdeed40
> R13: 000000000000027b R14: ffff88805a9eea00 R15: ffff88810ebc2058
> FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000018 CR3: 000000010b0e2000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tipc_topsrv_exit_net+0x139/0x320
>  ops_exit_list.isra.9+0x49/0x80
>  cleanup_net+0x31a/0x540
>  process_one_work+0x3fa/0x9f0
>  worker_thread+0x42/0x5c0
>  kthread+0x1a6/0x1e0
>  ret_from_fork+0x1f/0x30
> Modules linked in:
> CR2: 0000000000000018
> ---[ end trace 1524bb8c4ed3c3b4 ]---
> RIP: 0010:tipc_conn_close+0x12/0x100
> Code: 02 01 e8 52 74 20 00 e9 c6 fd ff ff 66 90 66 2e 0f 1f 84 00 00
> 00 00 00 41 55 41 54 55 53 48 89 fb e8 82 4f c2 fc 48 8b 43 08 <4c> 8b
> 68 18 4d 8d a5 b0 03 00 00 4c 89 e7 e8 fb 36 44 00 f0 48 0f
> RSP: 0018:ffffc90005137d60 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88805a9eea00 RCX: ffff88810b035280
> RDX: 0000000000000000 RSI: ffff88810b035280 RDI: 0000000000000002
> RBP: ffffc90005137db0 R08: ffffffff847b23de R09: 0000000000000001
> R10: 0000000000000005 R11: 0000000000000000 R12: ffff88810bdeed40
> R13: 000000000000027b R14: ffff88805a9eea00 R15: ffff88810ebc2058
> FS:  0000000000000000(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000018 CR3: 000000010b0e2000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0: 02 01                add    (%rcx),%al
>    2: e8 52 74 20 00        callq  0x207459
>    7: e9 c6 fd ff ff        jmpq   0xfffffdd2
>    c: 66 90                xchg   %ax,%ax
>    e: 66 2e 0f 1f 84 00 00 nopw   %cs:0x0(%rax,%rax,1)
>   15: 00 00 00
>   18: 41 55                push   %r13
>   1a: 41 54                push   %r12
>   1c: 55                    push   %rbp
>   1d: 53                    push   %rbx
>   1e: 48 89 fb              mov    %rdi,%rbx
>   21: e8 82 4f c2 fc        callq  0xfcc24fa8
>   26: 48 8b 43 08          mov    0x8(%rbx),%rax
> * 2a: 4c 8b 68 18          mov    0x18(%rax),%r13 <-- trapping instruction
>   2e: 4d 8d a5 b0 03 00 00 lea    0x3b0(%r13),%r12
>   35: 4c 89 e7              mov    %r12,%rdi
>   38: e8 fb 36 44 00        callq  0x443738
>   3d: f0                    lock
>   3e: 48                    rex.W
>   3f: 0f                    .byte 0xf
>
> Best,
> Wei
