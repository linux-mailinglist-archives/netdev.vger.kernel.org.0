Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41A06935CE
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 04:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBLDU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 22:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBLDU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 22:20:28 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3AF1631B;
        Sat, 11 Feb 2023 19:20:25 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id d13so6352251qvj.8;
        Sat, 11 Feb 2023 19:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676172024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jV1+eUp6/la6bHJXVKZFSm553P2HVk0e+WKQfNoEdNc=;
        b=j8FfzjjffbHe996BSSizWFQR8U1LbnObkHS0KW8Sxe+1TLrVLo8zfGGQInnU6xhzbH
         gMukGPH+cudoOQUyCtBPxH09ZU2QkK/nJH8ttz5+m/XxBZSzTkAF4Ap4BYSEh5CyWXu5
         Oapp+5NFd6/X03kKRS+eEcIGQbsuVSOR0T6TXsKtH1llkFVNF2hbgFGkDXAYC3CUbScz
         uMe/G49BgtdoBhJd/CQtnIiXZwA9o8VLDw6QjV16jK+tWqv8k8XLX8azqyCTZjqVm4rG
         N41ZuE+xIPxbYbnKDnOYkXcT+j/J6svp22SBMNzQA2X2XCNnyzisAN4pmaKROvaZqJ5G
         VvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676172024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jV1+eUp6/la6bHJXVKZFSm553P2HVk0e+WKQfNoEdNc=;
        b=Bt8yVgZsRvxq9R+CaQt7/tCVkxNE/PV6uV0ylvoahU+qXgG8oA2L/RZa1SsA3+Ywf3
         vyQvDRGmH+q0pX+MgcnDkvpXGHEFg4IDFy2jg+oHSNkf+BAb7L4IOo06wiQkDhCp+KBP
         vzozHY5d415FYt55JH0RDwetglfbezbRvK+7qRZh494uFxgi218gobKg5Jm2A4a1uZzU
         deABIG02jjg+JqvHSC4NqjIRUrLAJLrdQf2otCLWeytCO093NdT3JaTy8MATfz+Hrn0u
         ztOwrD/EUURAdkNT/i6XG6FeAwX4HVoGx6geWiEz2CVhff+CgKuSX50xdaUPgDTyIkqA
         HP+A==
X-Gm-Message-State: AO0yUKVeqGsAWsGBEGr5w69cAIIGUaQwQc9nwT/clFZlk/QC1Mc4r1ku
        Vz65ALgO7gXCRTRs6q78K4SNR6NbUKltBk7iXH8=
X-Google-Smtp-Source: AK7set9FOLosm1uHLls6cm+ufXyr97cSU/KvUyJyDOaMrnKJORlpTgb//i4VEJg64RftXvO3KX+HEdzTDo0amEJz+vU=
X-Received: by 2002:a0c:e003:0:b0:56c:f4:989a with SMTP id j3-20020a0ce003000000b0056c00f4989amr2018254qvk.64.1676172024552;
 Sat, 11 Feb 2023 19:20:24 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com> <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
 <08e1c9d0-376f-d669-6fe8-559b2fbc2f2b@efficios.com> <CALOAHbBsmajStJ8TrnqEL_pv=UOt-vv0CH30EqThVq=JYXfi8A@mail.gmail.com>
 <Y+UCxSktKM0CzMlA@e126311.manchester.arm.com> <CALOAHbCdNZ21oBE2ii_XBxecYLSxM7Ws2LRMirdEOpeULiNk4g@mail.gmail.com>
 <20230211165120.byivmbfhwyegiyae@airbuntu>
In-Reply-To: <20230211165120.byivmbfhwyegiyae@airbuntu>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 12 Feb 2023 11:19:48 +0800
Message-ID: <CALOAHbBgTOU5z54GNdzCdKPcJR1Sr0T2XNCzSYOApE1A=MLDkA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Qais Yousef <qyousef@layalina.io>
Cc:     Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>
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

On Sun, Feb 12, 2023 at 12:51 AM Qais Yousef <qyousef@layalina.io> wrote:
>
> On 02/09/23 23:37, Yafang Shao wrote:
> > On Thu, Feb 9, 2023 at 10:28 PM Kajetan Puchalski
> > <kajetan.puchalski@arm.com> wrote:
> > >
> > > On Thu, Feb 09, 2023 at 02:20:36PM +0800, Yafang Shao wrote:
> > >
> > > [...]
> > >
> > > Hi Yafang,
> > >
> > > > Many thanks for the detailed analysis. Seems it can work.
> > > >
> > > > Hi John,
> > > >
> > > > Could you pls. try the attached fix ? I have verified it in my test env.
> > >
> > > I tested the patch on my environment where I found the issue with newer
> > > kernels + older Perfetto. The patch does improve things so that's nice.
> >
> > Thanks for the test. I don't have Perfetto in hand, so I haven't
> > verify Perfetto.
>
> FWIW, perfetto is not android specific and can run on normal linux distro setup
> (which I do but haven't noticed this breakage).
>
> It's easy to download the latest release (including for android though I never
> tried that) from github
>
>         https://github.com/google/perfetto/releases
>

Thanks for the information. I will try to run it on my test env.
I suspect the "systrace_parse_failure" error is caused by the field we
introduced into struct ftrace_event_field in the proposed patch, but I
haven't taken a deep look at the perfetto src code yet.

> Kajetan might try to see if he can pick the latest version which IIUC contains
> a workaround.
>
> If this simple patch can be tweaked to make it work again against older
> versions that'd be nice though.
>
> HTH.
>
>
> Cheers
>
> --
> Qais Yousef



-- 
Regards
Yafang
