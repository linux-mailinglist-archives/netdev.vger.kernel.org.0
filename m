Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8886620A7
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbjAIIyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbjAIIxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:53:46 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67418193F5
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:45:32 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-4a2f8ad29d5so104200067b3.8
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hheRBt3zM1K3Bf+hDuhztrDBY135WTzE4X8NeeW3QKs=;
        b=UM0d0/dTZuueVZjI8mr8VuU4iaB6PVIlvkdwyXJPcSXYaCvnmIiWh45W3IbZvqthH7
         FMb3vhc5tg8kqVB7TVWNfbwS/bZn6uHd/mKJtCMeqAIjrcjwHVHp9u9yU6dnYNX7xgxi
         0hypMh1WX8Qc2Q93iu3+iEBHsng7kTa+25LnPHt1z0LAq1B5YY37D7+8gOpGyW2V1NtV
         nydHklLegE8zK/8u+j6IbRhm85cuVSZhGlncKt/scLla/3bm7XBRFHPYvJFtACVRkN8p
         naWEGBWcG0vXiCypmMymWvt4H1IS6Alo8p49VONWQ6cgcTYlJK8CmCimDPNxNdIyutpO
         PZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hheRBt3zM1K3Bf+hDuhztrDBY135WTzE4X8NeeW3QKs=;
        b=b+Q1l/UwdOb3h1+PEnMkIomrF9IOR4R0m+z5S0Ai0PUWpqAkMPoxcvipN8ZJQI2ECF
         IzFhVvXbZMUebHRXD4gJ65igMi86AGG9ikQpKODtK0oilj7rpIEfpetqHDx6vXqJSX9z
         NKikrFx5PV6nmikm+Wji3xX4QA4MJnQmaeHSiul0m9MZEs9c7On1rmQo3z+YyJjjN6/c
         GiTpWirtLFwqy9gflO0OEkO8Jci8GBYRxNIxeH68OPy6QhHWQN9bcvHAW0d/h7HB/nKM
         MaSbJyN8ejVJAzTx2IEi14mNnkQQ+ixrbwkPGYS9DZIbgMyhPyikAe7AHIaGoQWxXaca
         hDqA==
X-Gm-Message-State: AFqh2kpPc897qy70EuzAjhvMyx2MXgsxc4m0kDFhmU887peIW8A8Ucso
        Kg+r/IWWfj8KUL/GkHpbW1CREUATBypnJH/L6m+AQQ==
X-Google-Smtp-Source: AMrXdXs6SMbEZpUZ6fI8s/YMsJfAAa72NVrRjrmeRe1vyaVzYTbO5upWvfHIvPSwT3pQMKM5vE0RfVhT7NuUq8v10/Y=
X-Received: by 2002:a05:690c:b05:b0:467:2f6:4de5 with SMTP id
 cj5-20020a05690c0b0500b0046702f64de5mr1580595ywb.278.1673253925181; Mon, 09
 Jan 2023 00:45:25 -0800 (PST)
MIME-Version: 1.0
References: <Y7iQeGb2xzkf0iR7@westworld> <20230106145553.6dd014f1@kernel.org> <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
In-Reply-To: <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Jan 2023 09:45:14 +0100
Message-ID: <CANn89iJTtmdT0HsUtVMBdWeuj8pNY-FN6hkv0Z3QYr8_Yt_3Rg@mail.gmail.com>
Subject: Re: net: ipv6: raw: fixes null pointer deference in rawv6_push_pending_frames
To:     Kyle Zeng <zengyhkyle@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 7, 2023 at 12:13 AM Kyle Zeng <zengyhkyle@gmail.com> wrote:
>
> Hi Jakub,
>
> The null dereference can happen if every execution in the loop enters
> the `if (offset >= len) {`branch  and directly `continue` without
> running `csum_skb = skb`.
> A crash report is attached to this email.

OK, but it seems we would be in an error condition, and would need to
purge sk_write_queue ?

(ie call ip6_flush_pending_frames(), and return some error, instead of 0

Also please add a
Fixes: 357b40a18b04 ("[IPV6]: IPV6_CHECKSUM socket option can corrupt
kernel memory")
Cc: Herbert Xu <herbert@gondor.apana.org.au>

>
> Best,
> Kyle Zeng
>
> =============================================
> [    7.203616] BUG: kernel NULL pointer dereference, address: 00000000000000b2
> [    7.205204] #PF: supervisor read access in kernel mode
> [    7.206448] #PF: error_code(0x0000) - not-present page
> [    7.207630] PGD 88d0067 P4D 88d0067 PUD 79af067 PMD 0
> [    7.208060] Oops: 0000 [#1] SMP NOPTI
> [    7.208343] CPU: 1 PID: 1846 Comm: poc Not tainted 5.10.133 #39
> [    7.208816] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.15.0-1 04/01/2014
> [    7.209489] RIP: 0010:rawv6_push_pending_frames+0x96/0x1e0
> [    7.209934] Code: 00 00 8d 57 ff 39 d0 0f 8d bc 00 00 00 48 89 7c
> 24 08 41 83 bc 24 d0 01 00 00 01 0f 85 b8 00 00 00 8b a9 88 00 00 00
> 48 89 cb <44> 0f b7 ab b2 00 00 00 44 03 ab c0 00 00 00 44 2b ab c8 00
> 00 00
> [    7.211433] RSP: 0018:ffffc90003487b10 EFLAGS: 00010246
> [    7.211859] RAX: 00000000000000d8 RBX: 0000000000000000 RCX: ffff8880064101c0
> [    7.212410] RDX: 00000000000003c0 RSI: ffff8880064101c0 RDI: 00000000090e5840
> [    7.212992] RBP: 00000000479c45b8 R08: 0000000000000000 R09: ffff8880064101a4
> [    7.213559] R10: ffff8880064103d0 R11: ffff888006524b00 R12: ffff888006410000
> [    7.214106] R13: ffffc90003487c10 R14: ffffc90003487c10 R15: 0000000000000000
> [    7.214653] FS:  00000000017e03c0(0000) GS:ffff88803ec80000(0000)
> knlGS:0000000000000000
> [    7.215272] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    7.215769] CR2: 00000000000000b2 CR3: 0000000009068006 CR4: 0000000000770ee0
> [    7.216318] PKRU: 55555554
> [    7.216532] Call Trace:
> [    7.216744]  rawv6_sendmsg+0x72c/0x7d0
> [    7.217041]  kernel_sendmsg+0x7a/0x90
> [    7.217325]  sock_no_sendpage+0xc1/0xe0
> [    7.217644]  kernel_sendpage+0xa3/0xe0
> [    7.217945]  sock_sendpage+0x23/0x30
> [    7.218224]  pipe_to_sendpage+0x76/0xa0
> [    7.218529]  __splice_from_pipe+0xe5/0x200
> [    7.218870]  ? generic_splice_sendpage+0xa0/0xa0
> [    7.219263]  generic_splice_sendpage+0x72/0xa0
> [    7.219650]  do_splice+0x4ad/0x780
> [    7.219928]  __se_sys_splice+0x162/0x210
> [    7.220231]  do_syscall_64+0x31/0x40
> [    7.220518]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [    7.220944] RIP: 0033:0x47656d
> [    7.221189] Code: c3 e8 47 28 00 00 0f 1f 80 00 00 00 00 f3 0f 1e
> fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
> 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89
> 01 48
> [    7.222645] RSP: 002b:00007ffd36d11668 EFLAGS: 00000216 ORIG_RAX:
> 0000000000000113
> [    7.223266] RAX: ffffffffffffffda RBX: 000000002000102f RCX: 000000000047656d
> [    7.223860] RDX: 0000000000000007 RSI: 0000000000000000 RDI: 0000000000000005
> [    7.224414] RBP: 00007ffd36d116a0 R08: 000000000804ffe2 R09: 0000000000000000
> [    7.224986] R10: 0000000000000000 R11: 0000000000000216 R12: 0000000000000001
> [    7.225546] R13: 00007ffd36d118d8 R14: 00000000005026c0 R15: 0000000000000002
> [    7.226112] Modules linked in:
> [    7.226350] CR2: 00000000000000b2
> [    7.226613] ---[ end trace 5d56aba11d09b665 ]---
> [    7.226993] RIP: 0010:rawv6_push_pending_frames+0x96/0x1e0
> [    7.227442] Code: 00 00 8d 57 ff 39 d0 0f 8d bc 00 00 00 48 89 7c
> 24 08 41 83 bc 24 d0 01 00 00 01 0f 85 b8 00 00 00 8b a9 88 00 00 00
> 48 89 cb <44> 0f b7 ab b2 00 00 00 44 03 ab c0 00 00 00 44 2b ab c8 00
> 00 00
> [    7.228918] RSP: 0018:ffffc90003487b10 EFLAGS: 00010246
> [    7.229322] RAX: 00000000000000d8 RBX: 0000000000000000 RCX: ffff8880064101c0
> [    7.229880] RDX: 00000000000003c0 RSI: ffff8880064101c0 RDI: 00000000090e5840
> [    7.230516] RBP: 00000000479c45b8 R08: 0000000000000000 R09: ffff8880064101a4
> [    7.231112] R10: ffff8880064103d0 R11: ffff888006524b00 R12: ffff888006410000
> [    7.231687] R13: ffffc90003487c10 R14: ffffc90003487c10 R15: 0000000000000000
> [    7.232250] FS:  00000000017e03c0(0000) GS:ffff88803ec80000(0000)
> knlGS:0000000000000000
> [    7.232912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    7.233376] CR2: 00000000000000b2 CR3: 0000000009068006 CR4: 0000000000770ee0
> [    7.233958] PKRU: 55555554
> [    7.234170] Kernel panic - not syncing: Fatal exception
> [    7.234762] Kernel Offset: disabled
> [    7.235062] Rebooting in 1000 seconds..
>
> On Fri, Jan 6, 2023 at 3:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 6 Jan 2023 14:19:52 -0700 Kyle Zeng wrote:
> > > It is posible that the skb_queue_walkloop does not assign csum_skb to a real skb.
> >
> > Not immediately obvious to me how that could happen given prior checks
> > in this function.
