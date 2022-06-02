Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC053B69C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 12:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiFBKJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 06:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFBKJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 06:09:05 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9A12ACB70;
        Thu,  2 Jun 2022 03:09:04 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id q21so9025397ejm.1;
        Thu, 02 Jun 2022 03:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kgRmH9VKJjW/j4wnj4X8T+BWFFfOyeA48peWtaZAGyE=;
        b=njO5Zb3gP8WYfvPQFZsWU2TFwn7boL4PNpeJ/t4eyqmUjnmp3XxHNHIyM7o3Hi3Qy+
         Jiu7vdAWBugEOZn7XqSIRlNPrULg4ybny2Ib0cDfrYyZW128yoGT6hdkeYe7G5/C/OQu
         80daDC2+6aryWgc/Cmw0jmZS7/GOK+jqlZ0f/Sxgr5uxztxyoXXlheEVzgn/U263nz8b
         pcn2LX+cCDQj7rAPrijHt7TYdGzPnQC2UHwr0I4zCEBVUWGW58hKJqJOk3CzPZyRbvfz
         J7CarS1KNJ+k9+TxuJh+aDvYER+VETvTuLMTSq6dF/Dg2uyPgp8gTbIHojkgkfeRb9bn
         Awow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kgRmH9VKJjW/j4wnj4X8T+BWFFfOyeA48peWtaZAGyE=;
        b=Rwmt/KFi5H2Lwp6s+9+a9tAZwwSh7TRC//PYrc8cG8kNmOZbTA5tKzwvH6JEwO1jTY
         AHsYuhz17qOkR5e6wkHOiM6Nn0xlAnQmfjOw9kH7lpw8F+8Sn2r9f619twzMofSw8d2D
         Bg94gFWQS4mZq054NOunGs+wES5734OSu7vOxMaKpcpS6XHf2KAbBvhzmZH+jc+9eNTv
         1KOYBw8jTmOz9ie46BYvTgCyCGUAeOoMkcbnAwk+bC5rDW7bS8t+6IdDkJwQRtqchQ8E
         Ck+HEGQ8m1HR7wPGvjAyvyUN5VlsbODdEgLwV0gvxN7GFTh+RE2zoT1P7kapLPwjNDmU
         T0rQ==
X-Gm-Message-State: AOAM531HAFadYA8YbJbvlQH03D6wXN6ydN2CyJhm0w1tGFiySQDkyAVY
        LHLg6RqsqZNKgqohywZP494=
X-Google-Smtp-Source: ABdhPJygUBWCM90qaKxHmgDSRW5+Z+Dddj7MiOD8OBbK3u9nrpkyphaIVW2T9r+E7HdCdRWEo42xjw==
X-Received: by 2002:a17:907:971a:b0:6fe:bdf6:b67e with SMTP id jg26-20020a170907971a00b006febdf6b67emr3432634ejc.312.1654164542458;
        Thu, 02 Jun 2022 03:09:02 -0700 (PDT)
Received: from krava ([83.240.62.102])
        by smtp.gmail.com with ESMTPSA id w7-20020a056402070700b0042aa153e73esm2236746edx.12.2022.06.02.03.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 03:09:01 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 2 Jun 2022 12:08:50 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YpiMMr58nuUN9gQE@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <YpAmW/BDq4346OaI@kernel.org>
 <YperyVk8bTVT+s2U@krava>
 <CAEf4BzZrd4mXtGXmiH3VCCYtQacG1n9+3eJbtdAZJi5SW_Mj6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZrd4mXtGXmiH3VCCYtQacG1n9+3eJbtdAZJi5SW_Mj6A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 03:21:06PM -0700, Andrii Nakryiko wrote:
> On Wed, Jun 1, 2022 at 11:11 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Thu, May 26, 2022 at 10:16:11PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Tue, May 10, 2022 at 09:46:56AM +0200, Jiri Olsa escreveu:
> > > > hi,
> > > > sending change we discussed some time ago [1] to get rid of
> > > > some deprecated functions we use in perf prologue code.
> > > >
> > > > Despite the gloomy discussion I think the final code does
> > > > not look that bad ;-)
> > > >
> > > > This patchset removes following libbpf functions from perf:
> > > >   bpf_program__set_prep
> > > >   bpf_program__nth_fd
> > > >   struct bpf_prog_prep_result
> > >
> > > So, the first patch is already in torvalds/master, I tried applying the
> > > other two patches to my local perf/core, that already is merged with
> > > torvalds/master and:
> > >
> > > [root@quaco ~]# perf test 42
> > >  42: BPF filter                                                      :
> > >  42.1: Basic BPF filtering                                           : FAILED!
> > >  42.2: BPF pinning                                                   : FAILED!
> > >  42.3: BPF prologue generation                                       : FAILED!
> > > [root@quaco ~]#
> > >
> > > I'll push my local perf/core to tmp.perf/core and continue tomorrow.
> >
> > hi,
> > I just rebased my changes on top of your perf/core and it seems to work:
> >
> >         [root@krava perf]# ./perf test bpf
> >          40: LLVM search and compile                                         :
> >          40.1: Basic BPF llvm compile                                        : Ok
> >          40.3: Compile source for BPF prologue generation                    : Ok
> >          40.4: Compile source for BPF relocation                             : Ok
> >          42: BPF filter                                                      :
> >          42.1: Basic BPF filtering                                           : Ok
> >          42.2: BPF pinning                                                   : Ok
> >          42.3: BPF prologue generation                                       : Ok
> >
> > is it still a problem?
> >
> 
> Ok, so I checked with Jakub, net-next will be forwarded to
> linus/master tomorrow or so, so after that bpf-next will get forwarded
> as well and we'll have all those patches of yours. So let's go back to
> plan A: send your perf changes based on bpf-next. Thanks and sorry for
> the extra noise with all the back and forth.

ok, np

jirka
