Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AEC532538
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiEXI3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiEXI3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:29:01 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DB068999;
        Tue, 24 May 2022 01:29:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so33745549ejj.10;
        Tue, 24 May 2022 01:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J8iMMwvJrOhJib/WJO5AOkA8/W55ndUDelj0bAqrtOY=;
        b=fXEML4H/V5GrBQrh3PHPt8RNeDd8yeZYwgqDIIHQMQdxhZeYcVy6veC7X/t8sSZvJu
         KXQTUV6kQxDcvRZKFlXo79UIx4fzIzzqup6uS4gEVRoHryjE7nU2bWNrudmiJutDLO2F
         A2sExxibinYyWT3BlAo7x6oeQ8DEd0qhsnG/pZOqFvOUD+ROkBxCkoZ2NmlF0WEoQWiB
         slkbhP7kqKL9wt9/nfsrp2T5W7sXBv3IJsfKmtAkH2N0LaDH2h+N5RHittLYkC/gtZn8
         SztrDmtsqRd0VGkbz9CbgVwS1nJnmWPeTYm4eHv48ETnLqo6ABaBPHkHq8k9xRxecBgp
         HV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J8iMMwvJrOhJib/WJO5AOkA8/W55ndUDelj0bAqrtOY=;
        b=6/CfLZvU6hy6Lktih0RMMCvFNgE75h1OEpVOtV/JS2nkHv9m1i4KZBT7NOXeABkbe0
         8ZcEjYN9vTqDD9wK2kd4snHz4CtzV5y1/pHplD+gbs6QR7grBJDdHt8q5zUUPvRGr+v9
         w23QPwgFT0gPKz1u7yWZUKXVOm3jLbvxEtBpzdjN/LfcLM3FrN1W69bolTNhnT8zFKuR
         U8VDQGdWe/65WqpHLqsagk8jvrUI6edrn3ST/DCGJNl+O2GL+TfeW9MmdRlcahNLZ9jO
         VwUy024NOhlEdrlJ0aRccANq0Q1ebF9LPDoWJw5m9a9QBtlGtGs1yWBRzgc/iI0tIYih
         R2+Q==
X-Gm-Message-State: AOAM5338O2PAM/zjELO5mafIBrvZE/yeO8k/KzQGZdarqZaaWOCQ9dPM
        8mVQ5JSP2KxowCuXupmJ1XY=
X-Google-Smtp-Source: ABdhPJxTczwxiPsr8ovX72x6BYU4i9HL5iwVHq/+83cYj9WhBgoaVX33wiNKyOvI5ZSfx2DUHNp3lQ==
X-Received: by 2002:a17:907:7f8e:b0:6ff:1f9:61f5 with SMTP id qk14-20020a1709077f8e00b006ff01f961f5mr2542597ejc.722.1653380938422;
        Tue, 24 May 2022 01:28:58 -0700 (PDT)
Received: from krava (net-93-147-242-253.cust.vodafonedsl.it. [93.147.242.253])
        by smtp.gmail.com with ESMTPSA id d13-20020a05640208cd00b0042617ba639esm9239873edz.40.2022.05.24.01.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 01:28:57 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 24 May 2022 10:28:54 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
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
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YoyXRij2LaxxTicC@krava>
References: <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
 <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava>
 <YoYj6cb0aPNN/olH@krava>
 <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
 <Yokk5XRxBd72fqoW@kernel.org>
 <Yos8hq3NmBwemoJw@krava>
 <CAEf4BzYRJj8sXjYs2ioz6Qq7L2UshZDi4Kt0XLsLtwQSGCpAzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYRJj8sXjYs2ioz6Qq7L2UshZDi4Kt0XLsLtwQSGCpAzg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 03:43:10PM -0700, Andrii Nakryiko wrote:
> On Mon, May 23, 2022 at 12:49 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Sat, May 21, 2022 at 02:44:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Fri, May 20, 2022 at 02:46:49PM -0700, Andrii Nakryiko escreveu:
> > > > On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > > > On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > > > > > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > > > > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> > >
> > > > > > yep, just made new fedora package.. will resend the perf changes soon
> > >
> > > > > fedora package is on the way, but I'll need perf/core to merge
> > > > > the bpf_program__set_insns change.. Arnaldo, any idea when this
> > > > > could happen?
> > >
> > > > Can we land these patches through bpf-next to avoid such complicated
> > > > cross-tree dependencies? As I started removing libbpf APIs I also
> > > > noticed that perf is still using few other deprecated APIs:
> > > >   - bpf_map__next;
> > > >   - bpf_program__next;
> > > >   - bpf_load_program;
> > > >   - btf__get_from_id;
> >
> > these were added just to bypass the time window when they were not
> > available in the package, so can be removed now (in the patch below)
> >
> > >
> > > > It's trivial to fix up, but doing it across few trees will delay
> > > > libbpf work as well.
> > >
> > > > So let's land this through bpf-next, if Arnaldo doesn't mind?
> > >
> > > Yeah, that should be ok, the only consideration is that I'm submitting
> > > this today to Linus:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=tmp.perf/urgent&id=0ae065a5d265bc5ada13e350015458e0c5e5c351
> > >
> > > To address this:
> > >
> > > https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com/
> >
> > ok, we can do that via bpf-next, but of course there's a problem ;-)
> >
> > perf/core already has dependency commit [1]
> >
> > so either we wait for perf/core and bpf-next/master to sync or:
> >
> >   - perf/core reverts [1] and
> >   - bpf-next/master takes [1] and the rest
> >
> > I have the changes ready if you guys are ok with that
> 
> So, if I understand correctly, with merge window open bpf-next/master
> will get code from perf/core soon when we merge tip back in. So we can
> wait for that to happen and not revert anything.
> 
> So please add the below patch to your series and resend once tip is
> merged into bpf-next? Thanks!

ok

jirka
