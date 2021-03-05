Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCC332E342
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCEH63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEH62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:58:28 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE61C061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 23:58:26 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id d9so566471qvo.3
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 23:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gvreea8CmmUj01sjgyzNWmbigEe52xVCyC/djZHE6Zk=;
        b=TEJj63h/iFAiFsdXGCSPOChmVTHqQQHeadMwyzmZQkiLaCLYNZ10ZwjnD1JC0qRZEa
         TlsBIxJK8XwRAuPo8h2l+/KgraMbzmNICFLoHzJsfWfuDTJv41RXKQiYQKFFvNZkQFjL
         2zP6/Hgyqe7B0ocJK7TDBa+3Lidnrnt8Y7uHKshC3RABQumU6XzBYF+ONFK/BAuKsea7
         YECPcylxKbM/pZHrCTmlpyJqFU5Hhgx2SLVYyLKivNE8iHzTQLtf8daiGr+XhBZUhIzJ
         gr9hMc4K5Gawbq9Q/tMXxq0xbgBTep6FCbNTBqVHvskyC8UVYW7rer2fBOerDPP0VhMt
         Is3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gvreea8CmmUj01sjgyzNWmbigEe52xVCyC/djZHE6Zk=;
        b=tR/HNU5Nj95n9Tbg2N5XlyM2IsmK498UQNPuJBmPNN5nZYeuCk3KFEFiPTRJMrR1Ia
         +o2Sx5V6/RvI3upR5vNRCnx8Ki9sZ8+Xq3cjL2sA655+CZTqMBHfF402zKG0gYDcifP4
         FYIwZFGz/ZHAN71/PkKUnCDq7h+skParbmK4JK2w/F7+G7XvXYIfhjLH9q4xP3rARrax
         Ks6TjnsnqTUsTb1mSqG3zHdB4slKVJVVVYHWAUBHT0dwEAsbJsoSDmrnkgDR/fHH1AAa
         F6Xg7OTwKT9oHOVApnyuWxLPAiOAJpygvRL8yYGzWZ7ywbeykj/h7y5IEr43hJkmPvFc
         VQAQ==
X-Gm-Message-State: AOAM530LGRPRz4NvXPTmCTTPbwpOuO4FIVimxAEcx/ccgisoBbYR4Yyl
        ds4n3GiySmswJj5xA7aFSomMj5LPq3DF/Ti1wQnroQ==
X-Google-Smtp-Source: ABdhPJwFfrtLVGDVOh0fe2eJmLh02A+UulF/wYEEj7GINZa1+O+OBCwcEfWIcslBSfXw2dEb1G4s6UsTK6mgyl7bPDk=
X-Received: by 2002:a0c:8304:: with SMTP id j4mr7818657qva.18.1614931105277;
 Thu, 04 Mar 2021 23:58:25 -0800 (PST)
MIME-Version: 1.0
References: <000000000000cedbc405ae81531f@google.com>
In-Reply-To: <000000000000cedbc405ae81531f@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 5 Mar 2021 08:58:14 +0100
Message-ID: <CACT4Y+Z1MD2VyjDbz5h7UhPqihSBCnOUjA0E5_DoJqAZEHciAg@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in corrupted (4)
To:     syzbot <syzbot+aa7d098bd6fa788fae8e@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 8:49 PM syzbot
<syzbot+aa7d098bd6fa788fae8e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0f091e43 netlabel: remove unused param from audit_log_form..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14551a71900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=61025c6fd3261bb1
> dashboard link: https://syzkaller.appspot.com/bug?extid=aa7d098bd6fa788fae8e
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14eeda25900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161472f5900000
>
> The issue was bisected to:
>
> commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
> Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Date:   Sat Sep 29 00:59:43 2018 +0000
>
>     tc: Add support for configuring the taprio scheduler

This still happens. The bisection and repro look correct, the repro
also sets up taprio scheduler;
https://syzkaller.appspot.com/bug?id=7349616606afa3c986c377792f7ccbf9daae1142

Vinicius, could you please take a look? Thanks

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13096476900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17096476900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+aa7d098bd6fa788fae8e@syzkaller.appspotmail.com
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
>
> hrtimer: interrupt took 18040217 ns
> rcu: INFO: rcu_preempt self-detected stall on CPU
> rcu:    0-....: (1 ticks this GP) idle=4ae/0/0x1 softirq=7665/7665 fqs=3
>         (t=11294 jiffies g=9289 q=363)
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000cedbc405ae81531f%40google.com.
