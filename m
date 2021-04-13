Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FF835E600
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245699AbhDMSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbhDMSLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:11:12 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DF0C06175F
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:10:52 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id 18so1947301qkl.3
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FGbhF4j/4KvKvgmcMI4tSFrHp3z+B+kvQjIt7JNGVtM=;
        b=DfO/jKlu63SfJMFWbKyUV0bbBZCRd1vz/+G/YmzhTTDH2TksvMdvLPRxbz3c5WeN41
         R44AUBkiZ81oyS2Lj85bwtjNER3XalFky7kL9bC8JR/lyUE29zCFoaBxqknj1X7fInIM
         SE1PDklgLxqM12WgbGtGcGK3AxZYkvZjHrb1FUUrrfQAVuDGJ+xRcHiy/P8RMOuCUJXT
         M68JwzItCLD1ZOmOdHkv/LRa4MH+RrzZCxmaWyybHoDiWwcbbRPzWyJOSZTUlsUS3oZo
         TYqW3UAhV6PcjrG+cIettEB2u7LoXChq3U0cCsRGXUsjHHLiZ7GEVHCZIB5VRPqLB3Sb
         BKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FGbhF4j/4KvKvgmcMI4tSFrHp3z+B+kvQjIt7JNGVtM=;
        b=E5iBJUwkN5LjmFRVAI83FTBaheKwKyTE8scDzg3Unu5mnR1xKhklQ36kxarXkUKglT
         g+cnP1HwboWWRuGylIJsWNqgJhahHrqzLbP0LP1c3uN0yIma0qaoyzoL4rS3E0zTZyZU
         KtxSgWDbonwB5+fULOOflKt4eAxQ49BFDRs4Svcbk0IDB5UIIGqMapCvC0MkoIN2HhB3
         TK70BD8AXcfr3Y+7fCb1/E3EQrpNrQ18ThlFGztgC+HIJ7aP71svEv315Oma4pr7IxMb
         m9yxhoLv+zj1IQYMyF30sf4x2/YT/4J7VPonba3qNnUws4UJikywxRVf+MqbAjhJz+VB
         QSNQ==
X-Gm-Message-State: AOAM531/G0xOswOnX54zDu6NZWotXUscY7XR4OdcNqSvfd9TdHmh/DUO
        GbiGCRHexXLVpCq07x8sZaOspW7mswDR0izTjTyb+g==
X-Google-Smtp-Source: ABdhPJwgMLCFIyBm4ZJyOejRwBNHEomxHGEGdG3AM3IECeJOe3e/Sq3AX/EF9w+bYLlFMQswhzAYa1DyDU2rtW1P9VI=
X-Received: by 2002:ae9:e513:: with SMTP id w19mr35388617qkf.231.1618337451241;
 Tue, 13 Apr 2021 11:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ce66e005bf3b9531@google.com>
In-Reply-To: <000000000000ce66e005bf3b9531@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 20:10:39 +0200
Message-ID: <CACT4Y+asWh+a9snv-V=a=h1i9A-4hWW4fb4=1vnEKH7vgoh-Lw@mail.gmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in lock_sock_nested
To:     syzbot <syzbot+80a4f8091f8d5ba51de9@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, dsahern@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 5, 2021 at 5:45 PM syzbot
<syzbot+80a4f8091f8d5ba51de9@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    d19cc4bf Merge tag 'trace-v5.12-rc5' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14898326d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d1a3d65a48dbd1bc
> dashboard link: https://syzkaller.appspot.com/bug?extid=80a4f8091f8d5ba51de9
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+80a4f8091f8d5ba51de9@syzkaller.appspotmail.com

#syz dup: WARNING: suspicious RCU usage in getname_flags

> =============================
> WARNING: suspicious RCU usage
> 5.12.0-rc5-syzkaller #0 Not tainted
> -----------------------------
> kernel/sched/core.c:8294 Illegal context switch in RCU-bh read-side critical section!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 0
> no locks held by syz-executor.3/8407.
>
> stack backtrace:
> CPU: 0 PID: 8407 Comm: syz-executor.3 Not tainted 5.12.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  ___might_sleep+0x229/0x2c0 kernel/sched/core.c:8294
>  lock_sock_nested+0x25/0x120 net/core/sock.c:3062
>  lock_sock include/net/sock.h:1600 [inline]
>  do_ip_getsockopt+0x227/0x18e0 net/ipv4/ip_sockglue.c:1536
>  ip_getsockopt+0x84/0x1c0 net/ipv4/ip_sockglue.c:1761
>  tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4239
>  __sys_getsockopt+0x21f/0x5f0 net/socket.c:2161
>  __do_sys_getsockopt net/socket.c:2176 [inline]
>  __se_sys_getsockopt net/socket.c:2173 [inline]
>  __x64_sys_getsockopt+0xba/0x150 net/socket.c:2173
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x467a6a
> Code: 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc76a6a848 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 00007ffc76a6a85c RCX: 0000000000467a6a
> RDX: 0000000000000060 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 0000000000000003 R08: 00007ffc76a6a85c R09: 00007ffc76a6a8c0
> R10: 00007ffc76a6a860 R11: 0000000000000246 R12: 00007ffc76a6a860
> R13: 000000000005ecdc R14: 0000000000000000 R15: 00007ffc76a6afd0
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000ce66e005bf3b9531%40google.com.
