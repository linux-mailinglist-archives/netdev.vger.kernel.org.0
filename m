Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B10EAD335
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 08:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbfIIGqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 02:46:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33284 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfIIGqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 02:46:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so15033132qtd.0
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 23:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aArNse2b8Vb6qSqbvpv6BdKnL+SJhQZhCu9HW5eprFg=;
        b=XdqQMjFFEEy2OS5lPf2wk0FMcfAyop0Nfrxp52bZxXf01/f2Y2c7ySSOz4Nh7YW6DZ
         zCy6L+2Zzl+hVfEQculf8iuxoOB3m6vU2pwRND9lrQnmz90rUNnJZpO/ofUpiSGfEDd2
         AmAj2Em69pA071Sn6xFnaG5daPq5OmHFIU7BmqycpzdE/5FgePbzFlv8X17w03gys19g
         VG643VcvF1IRTtvu8h3TZ9qjQkRW7476bhUrs776hJcW45OVpUW18Bpgg9nIkhS2++uR
         LAGvcAJ+QuOheAL2qpFognzRnoaojdV97sla3bavjgwhmmI6Yu2QTvWCqkTLa6qsUvb0
         5tvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aArNse2b8Vb6qSqbvpv6BdKnL+SJhQZhCu9HW5eprFg=;
        b=DYZXiNz1STkbIVuDLyeVYI1x9n1xUumKfTJtKWrSnWh/Nh1XMDOrw8aPxuRVrVRPvy
         fAkgoHYxCEPIPsoTADfze5ws2hBKuaAZIFhgqEEu82td8SvUcjy8sNMBXVjAAXh6IQxH
         GMwyBWHgnbzEmA3h4flQvt28SBN6hLl17k7I+KIc7j3YklfaJqa4wj7Fh4pbRxJAgGVT
         zyj+5sMFYjz9n57UD9hWdIa/NeffmMsM/zrJ2m5986YWijTUgs4J+XxU8r9HxBYwS6xa
         NJiJVEmOd59jEgAV9tp19EcplXlUAD/QMoWyjIsxgpJRYLAIE8Bn+UsoHXdhxIMwmAmD
         nyuA==
X-Gm-Message-State: APjAAAU7Dmz6LVEuo50bkeGTeP0mGukE2dkHW1IW1GzsENZu4KEBZkVG
        LFn0LRL8O7nzW4w38nxBl86niumkhSk2Ntk1Zgdd7w==
X-Google-Smtp-Source: APXvYqyGZJScBE9xWT2qOjjqhZF2pPSBJRJZqAWkZ6GHz1ACUR3z6cIVBPgLQiPEzw80Rs0c7TEl9ecAz41kOtgnSZg=
X-Received: by 2002:a05:6214:2e4:: with SMTP id h4mr5286591qvu.127.1568011564855;
 Sun, 08 Sep 2019 23:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000df42500592047e0a@google.com> <CAHk-=wgZneAegyitz7f+JLjB6=28ewtvT7M4xy_a-wqsTjOX_w@mail.gmail.com>
In-Reply-To: <CAHk-=wgZneAegyitz7f+JLjB6=28ewtvT7M4xy_a-wqsTjOX_w@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 9 Sep 2019 07:45:53 +0100
Message-ID: <CACT4Y+aC9FDNxpiQTQ0KeVr--NT7+qAj989-MDeP87pH88q7Fg@mail.gmail.com>
Subject: Re: general protection fault in qdisc_put
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 8, 2019 at 6:19 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Sep 7, 2019 at 11:08 PM syzbot
> <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com> wrote:
> >
> > The bug was bisected to:
> >
> > commit e41d58185f1444368873d4d7422f7664a68be61d
> > Author: Dmitry Vyukov <dvyukov@google.com>
> > Date:   Wed Jul 12 21:34:35 2017 +0000
> >
> >      fault-inject: support systematic fault injection
>
> That commit does seem a bit questionable, but not the cause of this
> problem (just the trigger).
>
> I think the questionable part is that the new code doesn't honor the
> task filtering, and will fail even for protected tasks. Dmitry?

That commit added a new fault injection mode with a new API that is
used by syzkaller to inject faults. Before that commit the fault
inject is not working for syzkaller at all. I think this bisection
result simply means "the GPF is related to an earlier failure".

> > kasan: GPF could be caused by NULL-ptr deref or user memory access
> > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 9699 Comm: syz-executor169 Not tainted 5.3.0-rc7+ #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:qdisc_put+0x25/0x90 net/sched/sch_generic.c:983
>
> Yes, looks like 'qdisc' is NULL.
>
> This is the
>
>         qdisc_put(q->qdisc);
>
> in sfb_destroy(), called from qdisc_create().
>
> I think what is happening is this (in qdisc_create()):
>
>         if (ops->init) {
>                 err = ops->init(sch, tca[TCA_OPTIONS], extack);
>                 if (err != 0)
>                         goto err_out5;
>         }
>         ...
> err_out5:
>         /* ops->init() failed, we call ->destroy() like qdisc_create_dflt() */
>         if (ops->destroy)
>                 ops->destroy(sch);
>
> and "ops->init" is sfb_init(), which will not initialize q->qdisc if
> tcf_block_get() fails.
>
> I see two solutions:
>
>  (a) move the
>
>         q->qdisc = &noop_qdisc;
>
>      up earlier in sfb_init(), so that qdisc is always initialized
> after sfb_init(), even on failure.
>
>  (b) just make qdisc_put(NULL) just silently work as a no-op.
>
>  (c) change all the semantics to not call ->destroy if ->init failed.
>
> Honestly, (a) seems very fragile - do all the other init routines do
> this? And (c) sounds like a big change, and very fragile too.
>
> So I'd suggest that qdisc_put() be made to just ignore a NULL pointer
> (and maybe an error pointer too?).
>
> But I'll leave it to the maintainers to sort out the proper fix.
> Maybe people prefer (a)?
>
>                    Linus
