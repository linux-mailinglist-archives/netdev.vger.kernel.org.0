Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0231DB769
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgETOun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETOun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 10:50:43 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B0AC05BD43
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 07:50:42 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s37so1111662ybe.13
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 07:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajOsEVzBBmvLmCdJ2Fdc///Cfm2T2Xmx2TMwaA04DAo=;
        b=I8m8YrPTQXsy55nnqHyJdwIhm6QdarEOtspEoGcg9nkXM0Ew5AiYBTRIXjdtZxXD6S
         izOaYJYXE9XhaKVivA15X9QwZB3PnP3Qtl7QtzesZcYYMbCOjlRer0BjLRwvbWrr3bKz
         vk+zY7elcJGaeObSkGHGPxyQecLQW8tuncrc2tGZPsmNSar4qJEW9mJ2sKXaBeXLnFb1
         knwneHaygvC8zuiYEbffnkfuYqr7AB8BPsN2D0fzE8BkWD983alvNMTYO3pCTscKsJsU
         UoCgPcIVR5XrlFoUhmm56VsMLBd29uLTatSh8xwvQO3OY7NoruCYGaLLv2KyCDTa7hrJ
         7ZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajOsEVzBBmvLmCdJ2Fdc///Cfm2T2Xmx2TMwaA04DAo=;
        b=BTJuCHQr/7rbwup12AMy7g8/zg80HtygYNsw00Nfg3XdNR2AZsxKO8x71HUIsg+jsx
         HayBJ3bOnajdoOuE6rFiiIAJwFroQJMlnU9rX/QjaqIMrdBulWbOIwZu39t2gbL/7ktY
         TMhL/WsGsYVIWxfH3fLOfSr7WFpeaousdjaPOeFfc0ywEvO4LydgDIuaS432KBDtlh4v
         z9R3gzeG2P8Zcf3YjCnxI6Vd5nt3AQXxxC4LMfwM5CHf4oQtQFFJv7o0MKq0QiC/JhVY
         P3JuWjoFr+m5TZ6bly9vVP5Zib14TQ5YoqKOp+qTq+U+BIkWb9M/MyNP6iKwpXThOUSL
         cGIg==
X-Gm-Message-State: AOAM531+D3Eq9lePUms8yfZ/cqskjaJ02tt1yxk48si9P/EB/XD0vr+b
        7l1MtxPF/UncOvobD7h7lM8r/kCkkqjAaAiPUEzSDg==
X-Google-Smtp-Source: ABdhPJwUG/n0zhdUFbriSJsXmMxGywwDOeEtiLHjve+29uytAAbLo+u0KRAoTbKvizTmfvhGt1A2X7ckmp17h3/0lU0=
X-Received: by 2002:a25:4446:: with SMTP id r67mr7502533yba.41.1589986241692;
 Wed, 20 May 2020 07:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com> <20200520131359.GJ157452@krava>
In-Reply-To: <20200520131359.GJ157452@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 20 May 2020 07:50:30 -0700
Message-ID: <CAP-5=fXZVmjuiGyRsjzjfsBOpN50SeA+Gi66Of_wa61j7f6X5Q@mail.gmail.com>
Subject: Re: [PATCH 0/7] Share events between metrics
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 6:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, May 20, 2020 at 12:28:07AM -0700, Ian Rogers wrote:
> > Metric groups contain metrics. Metrics create groups of events to
> > ideally be scheduled together. Often metrics refer to the same events,
> > for example, a cache hit and cache miss rate. Using separate event
> > groups means these metrics are multiplexed at different times and the
> > counts don't sum to 100%. More multiplexing also decreases the
> > accuracy of the measurement.
> >
> > This change orders metrics from groups or the command line, so that
> > the ones with the most events are set up first. Later metrics see if
> > groups already provide their events, and reuse them if
> > possible. Unnecessary events and groups are eliminated.
> >
> > The option --metric-no-group is added so that metrics aren't placed in
> > groups. This affects multiplexing and may increase sharing.
> >
> > The option --metric-mo-merge is added and with this option the
> > existing grouping behavior is preserved.
> >
> > Using skylakex metrics I ran the following shell code to count the
> > number of events for each metric group (this ignores metric groups
> > with a single metric, and one of the duplicated TopdownL1 and
> > TopDownL1 groups):
>
> hi,
> I'm getting parser error with:
>
> [jolsa@krava perf]$ sudo ./perf stat -M IPC,CPI -a -I 1000
> event syntax error: '..ed.thread}:W{inst_retired.any,cpu_clk_unhalted.thread}:W,{inst_retired.any,cycles}:W'
>                                   \___ parser error
>
> jirka

Ah, looks like an issue introduced by:
https://lore.kernel.org/lkml/20200520072814.128267-8-irogers@google.com/
as there is a missing comma. I'll investigate after some breakfast.

Thanks,
Ian
