Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34B2648ECB
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiLJNLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJNLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:11:41 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D852B1A3BD;
        Sat, 10 Dec 2022 05:11:38 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o15so1769086wmr.4;
        Sat, 10 Dec 2022 05:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=soeAXGFT2ZQYuuVPACi9vLFCEHyIv8yl1NiZRasjUVs=;
        b=fYpG86XiYsU00IpqAbpowE7lsTuXN8VyIRHpeneRDwM5A5xZgmV19fZMQBItQ/kzVA
         vGFjc2nlmmIPJSK/OwMoswy8ePZ1Ff1U3bUZ4TaiVoGepATKkDFFUgmJwyXACW5r1FjU
         /2Qp8Mx7sCU9fYvqOW9qOtqrwibxw99Lgxb5akn72SSUBMD2uEIEwfxWTRada5RjgO2Y
         KF8TWBlWLtWC1XPaCEnBjUXxgAY3Se0SEv8nQDMcbEcH79fPorIgESpTjLMqFDpb2tKd
         Rm0IhFFzI03NdUG4SwjbsAV0j57YEkbORfYeQ0FlC9jwsZNmvgngiuUXOohnbjpCN4c5
         Dc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=soeAXGFT2ZQYuuVPACi9vLFCEHyIv8yl1NiZRasjUVs=;
        b=qjJxkeBwt40eCbdGdPmJO6xBf08NNSfEe4D3h68PgGrt4dbbjkB8b3I4CSJOqHkhqA
         qGrsiZEEhFeMaMZNYukSFuUeRWvKeO2jaSx/I+/qjAJ0C6sUo/hmIGzsvmQ1A8axp6yA
         kOpXcjnfQQbzdQawH1tBlxLu015KFqgYneYTmWtS31T7j5uKQ1VNasUDy3wfT7n9m22l
         ej93ADbFTT4HfoK6wezzdcJ+tCL2QgvAik8nuUGmCg9OKFYJAKmZ5ZON/Tg6dsLxixEc
         xUQKlMhX7bEqqZ1AAR+Uw+Bb74sZQgPwjyFi6S3C29NFtXkQAyYibeYXD9bkZ2ANjLRc
         Le0w==
X-Gm-Message-State: ANoB5pnTED12YHLg5Y0juai2nJKf1dRJWMzStQm2crFG/iiKzj0gFb24
        8IP6HwpjmL8MiYnPlJonx3E=
X-Google-Smtp-Source: AA0mqf4D0W/YOSmsXi7oOWRgZ645He4TtLhbnuvTssJL2HumPE1E4ZU6ozupkkai0nQCYOInuSi8mQ==
X-Received: by 2002:a05:600c:384e:b0:3cf:a483:3100 with SMTP id s14-20020a05600c384e00b003cfa4833100mr8130952wmr.3.1670677897137;
        Sat, 10 Dec 2022 05:11:37 -0800 (PST)
Received: from krava ([83.240.60.179])
        by smtp.gmail.com with ESMTPSA id q11-20020a05600c46cb00b003d1cf67460esm3014431wmo.40.2022.12.10.05.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 05:11:36 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 10 Dec 2022 14:11:34 +0100
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y5SFho7ZYXr9ifRn@krava>
References: <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava>
 <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org>
 <Y5PNeFYJrC6D4P9p@krava>
 <CAADnVQKr9NYektHFq2sUKMxxXJVFHcMPWh=pKa08b-yM9cgAAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKr9NYektHFq2sUKMxxXJVFHcMPWh=pKa08b-yM9cgAAQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 05:12:03PM -0800, Alexei Starovoitov wrote:
> On Fri, Dec 9, 2022 at 4:06 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
> > > On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> > > > fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> > > >
> > > >    [...] One example of non-obvious pairing is the XDP feature in networking,
> > > >    which calls BPF programs from network-driver NAPI (softirq) context. BPF
> > > >    relies heavily on RCU protection for its data structures, but because the
> > > >    BPF program invocation happens entirely within a single local_bh_disable()
> > > >    section in a NAPI poll cycle, this usage is safe. The reason that this usage
> > > >    is safe is that readers can use anything that disables BH when updaters use
> > > >    call_rcu() or synchronize_rcu(). [...]
> > >
> > > FWIW I sent a link to the thread to Paul and he confirmed
> > > the RCU will wait for just the BH.
> >
> > so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp side
> >
> > Paul,
> > any thoughts on what we can use in here to synchronize bpf_dispatcher_change_prog
> > with bpf_prog_run_xdp callers?
> >
> > with synchronize_rcu_tasks I'm getting splats like:
> >   https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f93404a2744884d922bc96d497ffe8f579f
> >
> > synchronize_rcu_tasks_rude seems to work (patch below), but it also sounds special ;-)
> 
> Jiri,
> 
> I haven't tried to repro this yet, but I feel you're on
> the wrong path here. The splat has this:
> ? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
> ? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
> that test_run logic takes rcu_read_lock.
> See bpf_test_timer_enter.
> I suspect the addition of synchronize_rcu_tasks_rude
> only slows down the race.
> The synchronize_rcu_tasks_trace also behaves like synchronize_rcu.
> See our new and fancy rcu_trace_implies_rcu_gp(),
> but I'm not sure it applies to synchronize_rcu_tasks_rude.
> Have you tried with just synchronize_rcu() ?
> If your theory about the race is correct then
> the vanila sync_rcu should help.
> If not, the issue is some place else.

synchronize_rcu seems to work as well, I'll keep the test
running for some time

thanks,
jirka
