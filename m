Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DEE355ADF
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 19:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbhDFR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 13:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhDFR6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 13:58:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78CFC06174A;
        Tue,  6 Apr 2021 10:58:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id ay2so7944299plb.3;
        Tue, 06 Apr 2021 10:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/0Ezdo6TTMIV4q/ibcjxA5ib8Vts+E2/aSfa4Pm8Xlw=;
        b=O2M4esYxVNDD2b0CmxjVzfdmbRa5/2CdJ1KDx7k8gjjImYg1rGy9mtdBS9COtByQP2
         3mSNJxLlvkVS8nWDv5Dom6fskBqP+6FeqAfFnWOrtq7XTzasxJ2gPQSI/S3e3/kQ+QuC
         kUQg/iObwnXMthh5NRinOWCwarrIxVBLh4GslT1WjLcbnwYb7Hk4V9mlCOfoIob/GhnM
         Ydk+iNK/LOedtw2ka9BBGiAS6z73oh6UV5Ua+1ZQZkmbbUzOJsoXm9mfd3lcSvDlL9BS
         5OF2+r57j7YGE0t7atWGAs4VzECMnYK7Lngj91YlG9rCWWyrTKnaSet/7jkRlJLvXIer
         qsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/0Ezdo6TTMIV4q/ibcjxA5ib8Vts+E2/aSfa4Pm8Xlw=;
        b=A8EKwyahpTYLzS/3dmVkiATXWCI8yLDQeUL413JDmtEoI50j8QexcFNnPEc5gQ0RjS
         v1iZrBjzoeJnMVZuWzFBl9KI5LhxVZpoblBUU51h8iSCoMzn7Yr5Ta00UM0oBUfe67cR
         OrfaE6IOwLLhR64UbMMIxByeZk5E/dr91px8KNcud57gcqTHFs2f7Rq+crEJRZWoUwj2
         NiKmDKBSiwPlOS34KENWE4z+s87Eh3tLyKa2bnm1ogNVK4wsQnV1ZzNBUuQX7NnHsudB
         mimuWWPFQCT1gXY81kRwFS7I+BxrViIi2cNDO48sg1H9NyAU9F2k1Tbm05MfwlFLe2Xo
         GzQA==
X-Gm-Message-State: AOAM533XgNtLV+FL7niWozs/ok24w9Nakg895OpTLYJI3zVQFt25r5Aa
        5v2NfnZt5iPFo6R1tjeftyDdGDeNJcxez+VDchc=
X-Google-Smtp-Source: ABdhPJzMKWH4LeMxZBkUQvZXRLpiJ+fJNytEmS2UWHGUQ7xi7GEyQxv2bnGTvcVHT0yX8JODLz4UgamvJPVNzYH7KQw=
X-Received: by 2002:a17:902:8347:b029:e7:4a2d:6589 with SMTP id
 z7-20020a1709028347b02900e74a2d6589mr30609818pln.64.1617731914383; Tue, 06
 Apr 2021 10:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008872ff05bf40e4db@google.com>
In-Reply-To: <0000000000008872ff05bf40e4db@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 6 Apr 2021 10:58:23 -0700
Message-ID: <CAM_iQpU9gSy++6Ba0vfnHz_J4-FcGpAMG7yzFDFk+qTi1DJnwA@mail.gmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in tcp_bpf_update_proto
To:     syzbot <syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>, anton@tuxera.com,
        Alexei Starovoitov <ast@kernel.org>,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, jmattson@google.com,
        John Fastabend <john.fastabend@gmail.com>,
        Joerg Roedel <joro@8bytes.org>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pbonzini@redhat.com, rkovhaev@gmail.com, seanjc@google.com,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        vkuznets@redhat.com, wanpengli@tencent.com, x86 <x86@kernel.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 2:44 AM syzbot
<syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com> wrote:
>
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

This is caused by one of my sockmap patches.

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
>  inet_recvmsg+0x11b/0x5d0 net/ipv4/af_inet.c:852

Oddly, I have all relevant Kconfig enabled but never see this
warning when running selftests for hours....

Anyway, let me see how this should be fixed.

Thanks!
