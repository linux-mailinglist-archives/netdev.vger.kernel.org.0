Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C7543848
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243522AbiFHQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiFHQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:00:07 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70BEB4BE;
        Wed,  8 Jun 2022 09:00:03 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id s6so33875856lfo.13;
        Wed, 08 Jun 2022 09:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVfFcL/p/g9l6zNNgj4xtypcOyIqNfaVEjGSvMr4y54=;
        b=N7MBfuKtagUgEl6p+oPmZKgOjBSalyJpusCN5hjwdigSnU03UfLSDkAOJOZM9QzFUC
         3I/mesO2LyjmsbYPbys34/kmqy+7INcEfD4eYRWJK1mjo05A5D8jLlbtRvGHp8njHTNK
         It9Ht5B59s/MY1bFKv4+0C9F8hF+9ruR0jEip9PEwsH0Aw/tq8QpOdvM3p0JnrAq/3QU
         N35dcZdFM6nLV+s70o2dHDpZWSM6wSYPEmXbIF0REf6ODJppV7uBmCVGvmbTeMld15fN
         I8GUpuW4jbZOK14bDI9NUrqsG8WLuUnWTsVU4t5PAdOKKRV9HDRrfX6lZD3fhW3QfETi
         nTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DVfFcL/p/g9l6zNNgj4xtypcOyIqNfaVEjGSvMr4y54=;
        b=BMouYea0upDDovtWSYLbCZuOFn7FH3OzNdzBlG3rVMjI6pOcG1/msMeS801XKyldMX
         6DPJNL9cCrYcVcPjXa+bMGAnCHAPSlKwPZu7Lc4NEurmLrs/DcW0m8yqVJ1fMBXLNxyv
         5r7JV67X13aGjvrCJGpZ7ljTyMnZhloVhYu6RISiNqg55m16CLVoDVaYjbOSMUe6yiGQ
         97YCGFlfunI9A5L/P4tfhNemLPnpz442DNx4RQ3FS76I0tem3zBVmjr1GYGVqLZMJTK0
         sIKZ1tzpgEX5RSPPQTBr0SkXUfYxse2B6EPgrQu8UDp8K5408CL8/sIcNxoJTGJFLiIS
         L9FA==
X-Gm-Message-State: AOAM532vG9GWWw8NRPE14xJG/ynCwnb7f99VU78T+Ljz211Sm//atQjU
        g+29laIjgVyzeOQWr+jCYTbvwIj1I02yPVm3YRo=
X-Google-Smtp-Source: ABdhPJyFuyVse8MAe0HSSXk8k7kb/ezX4lRiIdXzCPpBrvtMVychmLZo290ShFO1fTgiXAGMSwwYZmcMOzfRLhjcokc=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr68744850lfa.681.1654704001946; Wed, 08
 Jun 2022 09:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220606184731.437300-1-jolsa@kernel.org> <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
 <Yp+tTsqPOuVdjpba@krava> <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
 <YqBW65t+hlWNok8e@krava> <YqBynO64am32z13X@krava> <20220608084023.4be8ffe2@gandalf.local.home>
In-Reply-To: <20220608084023.4be8ffe2@gandalf.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jun 2022 08:59:50 -0700
Message-ID: <CAEf4BzYkHkB60qPxGu0D=x-BidxObX95+1wjEYN8xsK7Dg_4cw@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols sorting
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 5:40 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 8 Jun 2022 11:57:48 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
>
> > Steven,
> > is there a reason to show '__ftrace_invalid_address___*' symbols in
> > available_filter_functions? it seems more like debug message to me
> >
>
> Yes, because set_ftrace_filter may be set by index. That is, if schedule is
> the 43,245th entry in available_filter_functions, then you can do:
>
>   # echo 43245 > set_ftrace_filter
>   # cat set_ftrace_filter
>   schedule
>
> That index must match the array index of the entries in the function list
> internally. The reason for this is that entering a name is an O(n)
> operation, where n is the number of functions in
> available_filter_functions. If you want to enable half of those functions,
> then it takes O(n^2) to do so.
>
> I first implemented this trick to help with bisecting bad functions. That
> is, every so often a function that should be annotated with notrace, isn't
> and if it gets traced it cause the machine to reboot. To bisect this, I
> would enable half the functions at a time and enable tracing to see if it
> reboots or not, and if it does, I know that one of the half I enabled is
> the culprit, if not, it's in the other half. It would take over 5 minutes
> to enable half the functions. Where as the number trick took one second,
> not only was it O(1) per function, but it did not need to do kallsym
> lookups either. It simply enabled the function at the index.
>
> Later, libtracefs (used by trace-cmd and others) would allow regex(3)
> enabling of functions. That is, it would search available_filter_functions
> in user space, match them via normal regex, create an index of the
> functions to know where they are, and then write in those numbers to enable
> them. It's much faster than writing in strings.
>
> My original fix was to simply ignore those functions, but then it would
> make the index no longer match what got set. I noticed this while writing
> my slides for Kernel Recipes, and then fixed it.
>
> The commit you mention above even states this:
>
>       __ftrace_invalid_address___<invalid-offset>
>
>     (showing the offset that caused it to be invalid).
>
>     This is required for tools that use libtracefs (like trace-cmd does) that
>     scan the available_filter_functions and enable set_ftrace_filter and
>     set_ftrace_notrace using indexes of the function listed in the file (this
>     is a speedup, as enabling thousands of files via names is an O(n^2)
>     operation and can take minutes to complete, where the indexing takes less
>     than a second).
>
> In other words, having a placeholder is required to keep from breaking user
> space.

Would it be possible to preprocess ftrace_pages to remove such invalid
records (so that by the time we have to report
available_filter_functions there are no invalid records)? Or that data
is read-only when kernel is running?

>
> -- Steve
>
>
