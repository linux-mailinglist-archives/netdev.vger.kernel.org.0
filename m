Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFCE4003BE
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350162AbhICQ5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhICQ5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:57:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627EFC061575;
        Fri,  3 Sep 2021 09:56:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so1427pjq.1;
        Fri, 03 Sep 2021 09:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LfxP/03IybD/tJlQD+16HxciteQHNublykibE1e5LA4=;
        b=k2SpzdacnuuN3UKevgnAnyqN2WRQ4jsl/0+IxXx29DZ4DXWZChBBT/PjmtdeAeNuwO
         V7cJW/ZdUPKNpti016GsoBeAspygUbl0bQe+TJqcz/rx+VdKkmD6MISDFGO3iDeiZPcz
         89YDBHOfRkrZiklZg6miTlkP+7OroZZNI94pzQojUZ4VH6dLwYU3/SABPIDp18nRWutO
         WTvgLhwLsZRmrA0wfvAc0tBmh7kl7nlXobEf81DK2btcm669g329+GMSLb5j/9CoqfTF
         kp2DILGikqbnaR2Njtq3vHfTMT8Gn1dT0o8CrTE0pQjr3XM0vUopXlVivjcEMbd6VzE5
         2R4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LfxP/03IybD/tJlQD+16HxciteQHNublykibE1e5LA4=;
        b=Zy6C3ZIPkHD+rtImcfPRaayvwXf5URQXQTXZxOnPc+JznDmdRd2OtpsHcpDVpGLNGA
         Bu9ql6wRdeP0nKjFfZUfuYOmCgpK3gUIQKadHiO+E/rkGJon672SiJJuXG7DAAefV/lM
         P5EOBWqVaZ1Tvtt3KAZsTDqGkXlaPtVijWZFOdqVaRy7Xtyl/xvlYNUAV5Gh2o5LZEbx
         81zX4wFqSOocdhcdqzthX3OliB9b3odFQw3MLumIxrox0ix3z8VKDn2fDZJvaQVUuiSP
         H5M3slVHHeRdOPlfwKYSTPSGqmFbpwBrHd/CgR6pq4I4cl3nBzF8QUg+lzyo5nYwrWsZ
         4/WQ==
X-Gm-Message-State: AOAM533rmRkYdjnhZvR+1mT0fhX7Pu1oodYFtCOBnb0vsXkAlSTmdXs7
        sUWOslMypP5ttf/Kcs1gGahgwaRzGlQ=
X-Google-Smtp-Source: ABdhPJyKkmOBjbjGSDtWZmxC8JrF3bLDGdwpwxhVnlsvC8eDecBAz1WezZhbN+0bASHZEKq2OOLRBg==
X-Received: by 2002:a17:90a:680c:: with SMTP id p12mr1672673pjj.33.1630688195616;
        Fri, 03 Sep 2021 09:56:35 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u8sm7186815pgc.69.2021.09.03.09.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 09:56:35 -0700 (PDT)
Subject: Re: WARNING in sk_stream_kill_queues
To:     Hao Sun <sunhao.th@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Vasily Averin <vvs@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsYG3O_irFOZqjq5dJVDwW8pSUR_p6oO4BUaabWcx-hQCQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c84b07f8-ab0e-9e0c-c5d7-7d44e4d6f3e5@gmail.com>
Date:   Fri, 3 Sep 2021 09:56:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsYG3O_irFOZqjq5dJVDwW8pSUR_p6oO4BUaabWcx-hQCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/21 12:54 AM, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 9e9fb7655ed58 Merge tag 'net-next-5.15'
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1AXEQDnn7SPgFAMjqbL03_24-X_8YHoAq/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1zgxbwaYkrM26KEmJ-5sUZX57gfXtRrwA/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/1qa4FVNoO-EsJGuDMtGlTxtHW0li-vMSP/view?usp=sharing
> Syzlang reproducer:
> https://drive.google.com/file/d/1pL6atNID5ZGzH4GceqyBCOC5IjFfiaVN/view?usp=sharing


> 
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

This is probably a dup, causes skb_expand_head() changes,
CC  Vasily Averin <vvs@virtuozzo.com> is currently working on a fix.

> 
>  ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 10229 at net/core/stream.c:207
> sk_stream_kill_queues+0x162/0x190 net/core/stream.c:207
> Modules linked in:
> CPU: 1 PID: 10229 Comm: syz-executor Not tainted 5.14.0+ #12
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:sk_stream_kill_queues+0x162/0x190 net/core/stream.c:207
> Code: 41 5c e9 21 3b ce fd e8 1c 3b ce fd 89 de 48 89 ef e8 62 68 fe
> ff e8 0d 3b ce fd 8b 95 68 02 00 00 85 d2 74 ca e8 fe 3a ce fd <0f> 0b
> e8 f7 3a ce fd 8b 85 20 02 00 00 85 c0 74 c3 e8 e8 3a ce fd
> RSP: 0018:ffffc900080b7c98 EFLAGS: 00010202
> RAX: 000000000002a750 RBX: 0000000000000180 RCX: ffffc90002c0d000
> RDX: 0000000000040000 RSI: ffffffff836939f2 RDI: ffff8881031f0b40
> RBP: ffff8881031f0b40 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000000d R11: 000000000004f380 R12: ffff8881031f0c90
> R13: ffff8881031f0bc0 R14: ffff8881031f0cf0 R15: 0000000000000000
> FS:  00007f311adcb700(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000732190 CR3: 000000010ab01000 CR4: 0000000000752ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  inet_csk_destroy_sock+0x6f/0x1a0 net/ipv4/inet_connection_sock.c:1012
>  __tcp_close+0x512/0x610 net/ipv4/tcp.c:2869
>  tcp_close+0x29/0xa0 net/ipv4/tcp.c:2881
>  inet_release+0x58/0xb0 net/ipv4/af_inet.c:431
>  __sock_release+0x47/0xf0 net/socket.c:649
>  sock_close+0x18/0x20 net/socket.c:1314
>  __fput+0xdf/0x380 fs/file_table.c:280
>  task_work_run+0x86/0xd0 kernel/task_work.c:164
>  get_signal+0xde6/0x10b0 kernel/signal.c:2596
>  arch_do_signal_or_restart+0xa9/0x860 arch/x86/kernel/signal.c:865
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0xf2/0x280 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x40/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x46a9a9
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f311adcac58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: 0000000000069340 RBX: 000000000078c0a0 RCX: 000000000046a9a9
> RDX: 0000000000088012 RSI: 0000000020000380 RDI: 0000000000000004
> RBP: 00000000004e4042 R08: 0000000000000000 R09: 0000000000000027
> R10: 000000000020c49a R11: 0000000000000246 R12: 000000000078c0a0
> R13: 0000000000000000 R14: 000000000078c0a0 R15: 00007ffe75b47830
> 
