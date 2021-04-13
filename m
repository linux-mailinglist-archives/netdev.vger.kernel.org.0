Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E11535E612
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbhDMSMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345747AbhDMSMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:12:35 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0E5C06175F
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:12:15 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id x27so8555468qvd.2
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8WTSsefZFW62T22lrlwArgXymqZlxvKILjzLWwjgyM=;
        b=NeRrPp3a6n+7xCPvFIEAmJzlaYcK6H2Ep2acNBn2vO1lIoqyEkSFQZPyk844XLkUcC
         CSJ4wdBUDzbf52DdcpLNnQGRK48SbUStn+UP8xsMDxcSeTFIgnZcN2MUl5BnoMKG9LQh
         CRwrNuvqMypoArtY1NI2wEIBJjHMfzn/dEGYOtIVpVNSxQJfLvcXs/TniO/IVJSNSyhv
         byjFIQyzbMN8CJA8WU/zWKL6p05/5EtXDY5NGxWsaT1OECgCIU7I48szlTUHA/rFdAHr
         aVYht9tuKFMGOF6RKe+TsNrsN+bWZdKi44ptjqa39t4suR13LqINKXw2P70leVxBb/BX
         7xGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8WTSsefZFW62T22lrlwArgXymqZlxvKILjzLWwjgyM=;
        b=Lv7LisnkYFn2YQju+9bEP15/zuaTJRBfoVRsVpZBf6OV0jC9uzzvlHwM9Oh7mlKZat
         zz28hKgBGkcDBPkqWGwDa8l5CQP0Q0JewWd4bwpNcgp3yxsbNmmq84HP50V0erisq40S
         A83usWpcrCUKKoHIQMRvLlNs4eXhOhrSS2Ej/evpDAnIhCBpZOnOJPm65R0icpPlYWED
         DJ0lZEHflaZdxYxw0PFO1ZE7xLGBZa0S3oQ4sTFCYYS2TKRYCwZqtV7TfdbQEWOInR9i
         Sc0WwDVE4nTSaNhWfhUp0hXbcmmnF24WHfs+hRx5NbYPkvndqqh2Bi+nJJSrbQRAMkVU
         9uwQ==
X-Gm-Message-State: AOAM530fcwdp0zVQ1KH13T5X/oBAnInwdM4RIFeK5BcXlQErOPEWIUuf
        wp/D5cHleas3N5p6ZkloOJpiPMxaxvjWaRLugJhqa+DXjo0Z0TLs
X-Google-Smtp-Source: ABdhPJweJY/IhHFwcUYvXY9MEhVrrzrSZgJDFZPiTnwI0l+K32/ZohkHIF4ruWRCWlpbp9BjsCSuH+U2BMYtiLDb+SE=
X-Received: by 2002:a05:6214:20e8:: with SMTP id 8mr33453976qvk.13.1618337534807;
 Tue, 13 Apr 2021 11:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000028104905bf0822ce@google.com>
In-Reply-To: <00000000000028104905bf0822ce@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 20:12:03 +0200
Message-ID: <CACT4Y+ZN6ue+qH_5AJ9nFmOaAnAw7tv-TdXxHyJ_TirnChURcw@mail.gmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in find_inlist_lock
To:     syzbot <syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com>
Cc:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>, nikolay@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>, roopa@nvidia.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 3, 2021 at 4:22 AM syzbot
<syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    1e43c377 Merge tag 'xtensa-20210329' of git://github.com/j..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=114cdd4ad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
> dashboard link: https://syzkaller.appspot.com/bug?extid=b221933e5f9ad5b0e2fd
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com

#syz dup: WARNING: suspicious RCU usage in getname_flags

> =============================
> WARNING: suspicious RCU usage
> 5.12.0-rc5-syzkaller #0 Not tainted
> -----------------------------
> kernel/sched/core.c:8294 Illegal context switch in RCU-sched read-side critical section!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 0
> no locks held by syz-executor.1/8425.
>
> stack backtrace:
> CPU: 1 PID: 8425 Comm: syz-executor.1 Not tainted 5.12.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  ___might_sleep+0x266/0x2c0 kernel/sched/core.c:8294
>  __mutex_lock_common kernel/locking/mutex.c:928 [inline]
>  __mutex_lock+0xa9/0x1120 kernel/locking/mutex.c:1096
>  find_inlist_lock_noload net/bridge/netfilter/ebtables.c:316 [inline]
>  find_inlist_lock.constprop.0+0x26/0x220 net/bridge/netfilter/ebtables.c:330
>  find_table_lock net/bridge/netfilter/ebtables.c:339 [inline]
>  do_ebt_get_ctl+0x208/0x790 net/bridge/netfilter/ebtables.c:2329
>  nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
>  ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
>  ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
>  tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4239
>  __sys_getsockopt+0x21f/0x5f0 net/socket.c:2161
>  __do_sys_getsockopt net/socket.c:2176 [inline]
>  __se_sys_getsockopt net/socket.c:2173 [inline]
>  __x64_sys_getsockopt+0xba/0x150 net/socket.c:2173
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x467a6a
> Code: 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe660d82f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 00000000005401a0 RCX: 0000000000467a6a
> RDX: 0000000000000081 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 00007ffe660d831c R09: 00007ffe660d83a0
> R10: 00007ffe660d8320 R11: 0000000000000202 R12: 0000000000000003
> R13: 00007ffe660d8320 R14: 0000000000540128 R15: 00007ffe660d831c
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
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000028104905bf0822ce%40google.com.
