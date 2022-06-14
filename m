Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5642554BA75
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 21:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiFNTWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 15:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiFNTWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 15:22:01 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6DE29C83;
        Tue, 14 Jun 2022 12:21:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d14so12990836eda.12;
        Tue, 14 Jun 2022 12:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LQS7VowSx/S+w+iLmTbGWcWoA0CZ0lVjX4LifZSTEZE=;
        b=mkwtIuPkjTinjeBHAd5Uk6q8Vvx8bh0z0iEkAXqqNBw0Y2+CaMFvPqlvGLfXZITELb
         YBuK5VTzTFnmw0pmtEtLqiAnB3BAkGBcOwLfU4IBLEqjdhFAkX4fn1jcqAYCbmpbbe9y
         qIQB3roKngMuYrqLQt6tHVobbxTPTy9wEl872Z//dlchLBqIvw3Af4yqRLFkleyz4OAS
         E4Br6e17PtEpu6UWOBiNRWsMVGLCX50rE/iUnrvfXR5ZDZC3g4f6ef5AIWvMgPJwesgh
         GvBCNQYwantRaRYldKt9Ga3WER1QqMjDTovwiqcGbcXGxrw9I5xBrMSRqI/v8o/HAw0P
         YBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LQS7VowSx/S+w+iLmTbGWcWoA0CZ0lVjX4LifZSTEZE=;
        b=eZUhVstDdf+00VBiB5nwTa45MyIDg7F+b7qRVF7dixsVu9DOgFzOaTQdeEYJJYzPD1
         LYxAI7BDl7xyibURp6L9j5HasELCk/nCNIJ2s3ImWiDLLmFwCVCkwTUoxFhE59CYwAb2
         /Liw79FfKhk/YQG5T3a3FgFFsuH3aGeGJZ0l4FU8mD3WMgh0tGWnhh14uFthPQDhmFfR
         UhFRSlV1VdOi1UXkUkJcPaoHzS29FMDHqbxF8iwAtN96syNlB1R3o+kZ/NKNomfBttkm
         peeEtkbQoYD9S6qbl2vk+Wwf2aufecgGsPUbXuJrUNwnzpUBBKbrxTMDZF8m/6eUdsOC
         7OZg==
X-Gm-Message-State: AOAM530Pq8eJpZ4v0hMhTZvtfgBSQKL3teW//5JJQQWd+HKJJND9MYSK
        j12r69j0DDa+Pf0T1SOmFSs=
X-Google-Smtp-Source: AGRyM1uXyoNKfAQKrnzBo+Kl6QJ1CIMw3KffZh36hLSPIpfuU3sWnM3dANTOgt0/85LMRqh7ljL/yg==
X-Received: by 2002:a05:6402:2548:b0:42d:dd95:5bfe with SMTP id l8-20020a056402254800b0042ddd955bfemr7928262edb.285.1655234516470;
        Tue, 14 Jun 2022 12:21:56 -0700 (PDT)
Received: from krava ([83.240.63.226])
        by smtp.gmail.com with ESMTPSA id s11-20020aa7d78b000000b0042bca34bd15sm7567589edq.95.2022.06.14.12.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 12:21:55 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 14 Jun 2022 21:21:53 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>,
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
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <Yqjf0VWT2k6VizQ3@krava>
References: <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
 <Yp+tTsqPOuVdjpba@krava>
 <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
 <YqBW65t+hlWNok8e@krava>
 <YqBynO64am32z13X@krava>
 <20220608084023.4be8ffe2@gandalf.local.home>
 <CAEf4BzYkHkB60qPxGu0D=x-BidxObX95+1wjEYN8xsK7Dg_4cw@mail.gmail.com>
 <20220608120830.1ff5c5eb@gandalf.local.home>
 <CAEf4BzakYUnM3ZNgRbix=Z4bnPpzGiazAffMVh239476qH_c7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzakYUnM3ZNgRbix=Z4bnPpzGiazAffMVh239476qH_c7A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 11:32:59AM -0700, Andrii Nakryiko wrote:
> On Wed, Jun 8, 2022 at 9:08 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 8 Jun 2022 08:59:50 -0700
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > Would it be possible to preprocess ftrace_pages to remove such invalid
> > > records (so that by the time we have to report
> > > available_filter_functions there are no invalid records)? Or that data
> > > is read-only when kernel is running?
> >
> > It's possible, but will be time consuming (slow down boot up) and racy. In
> > other words, I didn't feel it was worth it.
> >
> > We can add it. How much of an issue is it to have these place holders for
> > you? Currently, I only see it causes issues with tests. Is it really an
> > issue for use cases?
> 
> I have the tool (retsnoop) that uses available_filter_functions, I'll
> have to update it to ignore such entries. It's a small inconvenience,
> once you know about this change, but multiply that for multiple users
> that use available_filter_functions for some sort of generic tooling
> doing kprobes/tracing, and it adds up. So while it's not horrible,
> ideally user-visible data shouldn't have non-usable placeholders.
> 
> How much slowdown would you expect on start up? Not clear what would
> be racy about this start up preprocessing, but I believe you.
> 
> So in summary, it's not the end of the world, but as a user I'd prefer
> not to know about this quirk, of course :)

ok, I'l resend with the test workaround

jirka
