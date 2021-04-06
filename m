Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0345D355B34
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbhDFSVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbhDFSVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:21:53 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9139C06174A;
        Tue,  6 Apr 2021 11:21:45 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id e186so16549232iof.7;
        Tue, 06 Apr 2021 11:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=DfWrBOpmRaS1WUDoipSTwJKeubZc4KftRAFyLRqczb8=;
        b=Xifx8A33LzpKOSciTyErZOEBmEYk6qqkAVCUg7mBIAnw/gh0Wll0EmDB5QR5DAB0k6
         Bnb4dr1/j5in4zvLNSnjPextFXCFOk6bv8sXHTo9JSEksX5R98IgLepHdcZhkU2M1XtB
         9KYU95l/E/vMXXyq9T79gk4qcNz7pS2ZUOVtmRmq4Cb9RyhcUu8HM93sZXvpLU8rPjZi
         pBEb6o13aUn8YaO8TvHrI/QwbQzYVr+1J1y5Pdp5zqhX4K7aymaxcZ9/hHEFGIn6QAbq
         BndRClVGf6AkA6Tknzfuzqtg/bABMvY2xeomPs5OyCtm1Gw1PhOwYeOj1wO4m8SbhBIx
         pq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=DfWrBOpmRaS1WUDoipSTwJKeubZc4KftRAFyLRqczb8=;
        b=oZEN1vPaVIlhb2oyTp5O+0HIYHfjOMoCKQNSNhAWOV8sQfPOftK0hUXx1cYoyvWXYs
         JSi2gjrwkAd4VE1sjs8AAHWVFFzE7NqgDCo9msgd/C3z0psvwUWDEqjLlKVSABZ4kYBD
         U6zcUNxpmfwX/KxBAjmc51zSL8Uc/DKKeX0JO1SwoELeUq1XSY0FqLThlwT+bSVemDoq
         sr4HIRHBDcHIle1KPIsUhu7f9y4XAHTw5lcRQe0YXYHXn6Wzrjpb+EXR5JXezcI53tC2
         o469BdrWrCbMJiyCSqdXNWlpNamSE6QEKiF2zqzWPdJltrPDwHnQA4095k8o8Gi6PXSv
         2Hcw==
X-Gm-Message-State: AOAM533HOzl6EGbJQKkWaDM5JXobtb0dfOR/wnNlyliblJQHitE5phT6
        kmvQ12VVJgt2rEYaWtzPa4U=
X-Google-Smtp-Source: ABdhPJzAeknTMWB3XYct3XWv3hqVLr9Ju9UkwadTFcK/A+auXvA1BL0Rh+/kNgdvQP32cbULbQJ2Pg==
X-Received: by 2002:a02:3085:: with SMTP id q127mr29783003jaq.137.1617733305388;
        Tue, 06 Apr 2021 11:21:45 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id e10sm13010549ile.23.2021.04.06.11.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 11:21:44 -0700 (PDT)
Date:   Tue, 06 Apr 2021 11:21:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, andrii@kernel.org, anton@tuxera.com,
        ast@kernel.org, bp@alien8.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hpa@zytor.com,
        jakub@cloudflare.com, jmattson@google.com,
        john.fastabend@gmail.com, joro@8bytes.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lmb@cloudflare.com, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, rkovhaev@gmail.com,
        seanjc@google.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org, yhs@fb.com
Message-ID: <606ca6b12f544_f0242081@john-XPS-13-9370.notmuch>
In-Reply-To: <0000000000008872ff05bf40e4db@google.com>
References: <0000000000008872ff05bf40e4db@google.com>
Subject: RE: [syzbot] WARNING: suspicious RCU usage in tcp_bpf_update_proto
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    514e1150 net: x25: Queue received packets in the drivers i..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=112a8831d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
> dashboard link: https://syzkaller.appspot.com/bug?extid=320a3bc8d80f478c37e4
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1532d711d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f44c5ed00000
> 
> The issue was bisected to:
> 
> commit 4dfe6bd94959222e18d512bdf15f6bf9edb9c27c
> Author: Rustam Kovhaev <rkovhaev@gmail.com>
> Date:   Wed Feb 24 20:00:30 2021 +0000
> 
>     ntfs: check for valid standard information attribute
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16207a81d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15207a81d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11207a81d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com
> Fixes: 4dfe6bd94959 ("ntfs: check for valid standard information attribute")
> 
> =============================
> WARNING: suspicious RCU usage
> 5.12.0-rc4-syzkaller #0 Not tainted
> -----------------------------
> include/linux/skmsg.h:286 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by syz-executor383/8454:
>  #0: ffff888013a99b48 (clock-AF_INET){++..}-{2:2}, at: sk_psock_drop+0x2c/0x460 net/core/skmsg.c:788
> 
> stack backtrace:
> CPU: 1 PID: 8454 Comm: syz-executor383 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  sk_psock include/linux/skmsg.h:286 [inline]
>  tcp_bpf_update_proto+0x530/0x5f0 net/ipv4/tcp_bpf.c:504
>  sk_psock_restore_proto include/linux/skmsg.h:408 [inline]
>  sk_psock_drop+0xdf/0x460 net/core/skmsg.c:789
>  sk_psock_put include/linux/skmsg.h:446 [inline]
>  tcp_bpf_recvmsg+0x42d/0x480 net/ipv4/tcp_bpf.c:208


The bisection is bogus, but we will get a fix for this ASAP. The real commit
is,

commit 8a59f9d1e3d4340659fdfee8879dc09a6f2546e1
Author: Cong Wang <cong.wang@bytedance.com>
Date:   Tue Mar 30 19:32:31 2021 -0700

    sock: Introduce sk->sk_prot->psock_update_sk_prot()

Thanks,
John
