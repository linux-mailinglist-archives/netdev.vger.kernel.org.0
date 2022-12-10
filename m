Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B40648C3E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 02:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLJBMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 20:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLJBMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 20:12:18 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC62F010;
        Fri,  9 Dec 2022 17:12:16 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id fc4so15211590ejc.12;
        Fri, 09 Dec 2022 17:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w4ADGd8gswVi8TomaFcdrrYZPaXY9TBBtkDp4DMvfpE=;
        b=FhYRYTfh2eMILidzjM694/ryObUQPSo+rBTbKNRcEgkG0KoU1Ef+6/M3CdKkb/U0su
         RZMELU22J+MbnsrMTYEg0qlAPIDY/cBWMJiXFQP5ibBCJafyHdu0AHE3VBIbVA7DUOie
         ykA4Szl+o8KGVKp5bjA5uH+9ZNsNfptqfeqBaX8yotccGoLRbnmRqpUyR8mL620ol0QU
         4z6WCPZnhNRRY+PiNpIMtw5CZfZDAJ9uvuV4UXimn0kp7FdPE1QxZKG+/eHM+o8DDm5/
         ctsBABnqrGtVTrRZTwB738FJm/MhrNf+Sgd3scdYTP/qOUW+8/+hvZP+hEid6bMcfMEx
         8FcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4ADGd8gswVi8TomaFcdrrYZPaXY9TBBtkDp4DMvfpE=;
        b=zbDwTbn9+4GuSACfTFtzBZz4VmXLkkw92KtnJL7+v0rYQE3IQ7vE0JYUp7qmDEmcFe
         TdWcRgop+dIuX6HkCTvfC9YkY3U4Ci4LChFrTIfPM9U05fOi2IXh8JivMToWSnj6iECD
         5KNdPNj7dwGLU9weKenLkZvyx/R9xgmmIqPgkzPmxXX11zcTI5UUlUVl6Y7fARWK7Mex
         wkOVN9URIDhBWV0tjO33n1gKB3ZehQYrXKCsLlWXA+QaHwdBMTlSh+DgzZJcRayBLRnt
         SrL7m2cozXf6eP9t04sHXAXMySwYbRujfHp6QlSeUvz9VzzcpDI5b9K/XTk5dKsZl2L6
         8Uww==
X-Gm-Message-State: ANoB5pltXJZ7+Uyc09GGv2EOXcPSqKMdYH9s3TKZjXR3KjDm0iS/54mJ
        L5D2ml2jizfC9qo7WHaOJMk/A71PaCP8ogG4R34=
X-Google-Smtp-Source: AA0mqf5aTKuKb/ygizN4hu5aKxFW2tN/RJZfTxdEPi61WR/NUIe7drXP/RIDZQsLAVsSj3am6WKF+wPcEUwhXbtDmOk=
X-Received: by 2002:a17:906:4351:b0:78d:513d:f447 with SMTP id
 z17-20020a170906435100b0078d513df447mr69635532ejm.708.1670634734892; Fri, 09
 Dec 2022 17:12:14 -0800 (PST)
MIME-Version: 1.0
References: <Y5LfMGbOHpaBfuw4@krava> <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava> <Y5NSStSi7h9Vdo/j@krava> <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava> <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava> <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org> <Y5PNeFYJrC6D4P9p@krava>
In-Reply-To: <Y5PNeFYJrC6D4P9p@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 9 Dec 2022 17:12:03 -0800
Message-ID: <CAADnVQKr9NYektHFq2sUKMxxXJVFHcMPWh=pKa08b-yM9cgAAQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>,
        Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
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

On Fri, Dec 9, 2022 at 4:06 PM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
> > On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> > > fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> > >
> > >    [...] One example of non-obvious pairing is the XDP feature in networking,
> > >    which calls BPF programs from network-driver NAPI (softirq) context. BPF
> > >    relies heavily on RCU protection for its data structures, but because the
> > >    BPF program invocation happens entirely within a single local_bh_disable()
> > >    section in a NAPI poll cycle, this usage is safe. The reason that this usage
> > >    is safe is that readers can use anything that disables BH when updaters use
> > >    call_rcu() or synchronize_rcu(). [...]
> >
> > FWIW I sent a link to the thread to Paul and he confirmed
> > the RCU will wait for just the BH.
>
> so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp side
>
> Paul,
> any thoughts on what we can use in here to synchronize bpf_dispatcher_change_prog
> with bpf_prog_run_xdp callers?
>
> with synchronize_rcu_tasks I'm getting splats like:
>   https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f93404a2744884d922bc96d497ffe8f579f
>
> synchronize_rcu_tasks_rude seems to work (patch below), but it also sounds special ;-)

Jiri,

I haven't tried to repro this yet, but I feel you're on
the wrong path here. The splat has this:
? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
that test_run logic takes rcu_read_lock.
See bpf_test_timer_enter.
I suspect the addition of synchronize_rcu_tasks_rude
only slows down the race.
The synchronize_rcu_tasks_trace also behaves like synchronize_rcu.
See our new and fancy rcu_trace_implies_rcu_gp(),
but I'm not sure it applies to synchronize_rcu_tasks_rude.
Have you tried with just synchronize_rcu() ?
If your theory about the race is correct then
the vanila sync_rcu should help.
If not, the issue is some place else.
