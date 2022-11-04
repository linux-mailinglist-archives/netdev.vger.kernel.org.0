Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52B7619EEB
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiKDRh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiKDRh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:37:56 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4941632065;
        Fri,  4 Nov 2022 10:37:53 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id t62so5861550oib.12;
        Fri, 04 Nov 2022 10:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CESi/QuyB0+7uMM9ST1dSB2NDWs95NPRxZRMfmdUQF8=;
        b=qRN331Q3lFC/jiJrMMlhDieuNyyRJdSkDn90USd5Zh/1i49Mp/pjlpZAy+R1iGQowD
         Ob3EIUrrYYuobp0mwpfkGBHaMqwkqWfuCoce2nhUE7ZtXDDR6VI1MLkXzAoBMhliVmbW
         IZC47hdI39uFTmHxH+ahF2ALi9SiLzQRiXln4qyU4wtWE1e34IiqEGnRo5kyWYTAKzQ2
         dXoX3yP2qzoTWQ/d86DHNjixR/9GucrW7/09u1snJVHFjbmMjG+cfx6KRcn+FMw2e+qF
         AmsVne9WuzTPi64gVQ4PvbDHY/D427XPdsFC+x8UDH1y4uDA9JfuW1ZCUEJgKHOCyFmS
         kj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CESi/QuyB0+7uMM9ST1dSB2NDWs95NPRxZRMfmdUQF8=;
        b=gJQTwed0X3LIjvY8JAV6untWKhNtZgkAgKQqoyD34EoZWZ39LTXa9jbtEk51m6iVCM
         bdMGTrRxDVTfBWS1HUNIypw9+Puejqz9ypvKqvl62OsNgwKUl5asidXrb9myx4DaQjV+
         uPljfWKI417lwtwvp9cMtyeRXu/gpdV4sfhjzDfF7krdfm0jW2QOroLlqME0lS5Y7BgF
         iGI14PiHez89a59j9YJo1gnpDuKTf6yZuCEiu3vToqRpWdsdsld6vlugVVGudekiOoSF
         GTlHhiZZBQQsJba8H0aaqe0NSSjhs/xxepQ22YRdXwcPxd6Ej7Dv0VlD8qyC5K9HUW87
         fHDw==
X-Gm-Message-State: ACrzQf1lOlAdxeL8YRcCemzwpHAXFM8RlBeBN52MQhsPciTxnBEGam8U
        4d+/6pTcwABTqzgeJcm0kFR6zIARic6wrPXE36gs0oAdl8E=
X-Google-Smtp-Source: AMsMyM6mBqd3NbWQM9nXMToatDmrFvI2ILGgGWse+BgGpeLKISzm+yE63S85OSA+mg1eA40JhsvZiPjcKpEgCQhGVWw=
X-Received: by 2002:a05:6808:1826:b0:35a:573f:c8b5 with SMTP id
 bh38-20020a056808182600b0035a573fc8b5mr4008958oib.190.1667583472536; Fri, 04
 Nov 2022 10:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4mrfeFrYwFEYmULU0DWxG3kOq+M-=uqRJNp8b-RKy6wzvEsw@mail.gmail.com>
In-Reply-To: <CAO4mrfeFrYwFEYmULU0DWxG3kOq+M-=uqRJNp8b-RKy6wzvEsw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 4 Nov 2022 13:37:26 -0400
Message-ID: <CADvbK_ffQx25qkwc94C_vsOjeqv_skcJ+H2Hkdtm6xVXgc4ggw@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in tipc_crypto_key_distr
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, tipc-discussion@lists.sourceforge.net,
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

On Sun, Oct 30, 2022 at 6:32 AM Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developer,
>
> Recently when using our tool to fuzz kernel, the following crash was triggered:
>
> HEAD commit: 64570fbc14f8 Linux 5.15-rc5
> git tree: upstream
> compiler: gcc 8.0.1
> console output:
> https://drive.google.com/file/d/1ZxNXcUkiJiTK6MzVIWCqDpq70QW2-t-b/view?usp=share_link
> kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
>
> RBP: 0000000000000045 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bfac
> R13: 0000000000000000 R14: 000000000119bfa0 R15: 00007fffcffa6fe0
> BUG: kernel NULL pointer dereference, address: 0000000000000020
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 2763b067 P4D 2763b067 PUD 27636067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 0 PID: 12346 Comm: syz-executor.0 Not tainted 5.15.0-rc5 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:tipc_crypto_key_distr+0x121/0x6a0
> Code: 00 48 8b 13 88 85 60 ff ff ff 41 0f b7 44 24 48 48 89 95 68 ff
> ff ff 66 89 85 5c ff ff ff 49 8b 44 24 40 48 89 85 50 ff ff ff <8b> 40
> 20 83 c0 24 0f b7 c0 83 c0 28 89 c7 89 85 64 ff ff ff e8 96
> RSP: 0018:ffffc9000d48f8e0 EFLAGS: 00010212
> RAX: 0000000000000000 RBX: ffff888010979a00 RCX: 0000000000040000
> RDX: ffff8880163e0000 RSI: 0000000000000a20 RDI: 0000000000000002
> RBP: ffffc9000d48f998 R08: ffffffff847c7f3d R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff88803189eb00
> R13: 0000000000000001 R14: 0000000000000000 R15: 00000000ffffff82
> FS:  00007f54fc3f7700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000020 CR3: 0000000027638000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tipc_nl_node_set_key+0x760/0x930
Please check if this fix is in your kernel:

commit 3e6db079751afd527bf3db32314ae938dc571916
Author: Tadeusz Struk <tadeusz.struk@linaro.org>
Date:   Mon Nov 15 08:01:43 2021 -0800

    tipc: check for null after calling kmemdup

Thanks.
>  genl_family_rcv_msg_doit.isra.16+0x141/0x190
>  genl_rcv_msg+0x172/0x2c0
>  netlink_rcv_skb+0x87/0x1d0
>  genl_rcv+0x24/0x40
>  netlink_unicast+0x2b8/0x3d0
>  netlink_sendmsg+0x350/0x680
>  sock_sendmsg+0x52/0x70
>  ____sys_sendmsg+0x35f/0x390
>  ___sys_sendmsg+0x95/0xd0
>  __sys_sendmsg+0x87/0x100
>  do_syscall_64+0x34/0xb0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4692c9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f54fc3f6c38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f54fc3f6c80 RCX: 00000000004692c9
> RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000003
> RBP: 0000000000000045 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bfac
> R13: 0000000000000000 R14: 000000000119bfa0 R15: 00007fffcffa6fe0
> Modules linked in:
> CR2: 0000000000000020
> ---[ end trace c7813f5e0b2eeeab ]---
> RIP: 0010:tipc_crypto_key_distr+0x121/0x6a0
> Code: 00 48 8b 13 88 85 60 ff ff ff 41 0f b7 44 24 48 48 89 95 68 ff
> ff ff 66 89 85 5c ff ff ff 49 8b 44 24 40 48 89 85 50 ff ff ff <8b> 40
> 20 83 c0 24 0f b7 c0 83 c0 28 89 c7 89 85 64 ff ff ff e8 96
> RSP: 0018:ffffc9000d48f8e0 EFLAGS: 00010212
> RAX: 0000000000000000 RBX: ffff888010979a00 RCX: 0000000000040000
> RDX: ffff8880163e0000 RSI: 0000000000000a20 RDI: 0000000000000002
> RBP: ffffc9000d48f998 R08: ffffffff847c7f3d R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff88803189eb00
> R13: 0000000000000001 R14: 0000000000000000 R15: 00000000ffffff82
> FS:  00007f54fc3f7700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000020 CR3: 0000000027638000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0: 00 48 8b              add    %cl,-0x75(%rax)
>    3: 13 88 85 60 ff ff    adc    -0x9f7b(%rax),%ecx
>    9: ff 41 0f              incl   0xf(%rcx)
>    c: b7 44                mov    $0x44,%bh
>    e: 24 48                and    $0x48,%al
>   10: 48 89 95 68 ff ff ff mov    %rdx,-0x98(%rbp)
>   17: 66 89 85 5c ff ff ff mov    %ax,-0xa4(%rbp)
>   1e: 49 8b 44 24 40        mov    0x40(%r12),%rax
>   23: 48 89 85 50 ff ff ff mov    %rax,-0xb0(%rbp)
> * 2a: 8b 40 20              mov    0x20(%rax),%eax <-- trapping instruction
>   2d: 83 c0 24              add    $0x24,%eax
>   30: 0f b7 c0              movzwl %ax,%eax
>   33: 83 c0 28              add    $0x28,%eax
>   36: 89 c7                mov    %eax,%edi
>   38: 89 85 64 ff ff ff    mov    %eax,-0x9c(%rbp)
>   3e: e8                    .byte 0xe8
>   3f: 96                    xchg   %eax,%esi
>
> Best,
> We
