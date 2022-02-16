Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2074B8A54
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbiBPNhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:37:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiBPNhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:37:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D396F1A76EA;
        Wed, 16 Feb 2022 05:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 892D4B81EE6;
        Wed, 16 Feb 2022 13:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02594C004E1;
        Wed, 16 Feb 2022 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645018612;
        bh=ZSkVb1slYA4F/pp9dzxY4tduW9grcjLC4TTtHzhDpuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4fYWrQCCOolWCrtXeDOPaIlXIxxB1dSAl1tLxSPrm5HxzV1eqJb0518M0U9tnxn6
         1OGLMcVglnEyWOBv8QVpLFmTt0WGJg/FGRE6dRwuCrmSWOFaeG9QIqK3NCaefC8joj
         aCgDQHnFOjSEdZcE31JQWrOveNtc9bX9WziBEAylLh+HwRK2Z/3EGeMwm1TCnACaIu
         gn3as+6A1gEkF+Db5gfpdtdLZ60n3lpokYvxrMFMXAeZPXdEHSaDoqcASLyXIY6LA1
         KZ5mFQpJ6hbObwDvl+zo1gHpiJa4E6gLXtrfsCb282+L/ae7cLJr3xI6APHI+4aWO4
         /Vn5ZWq4/MW9A==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 229E4400FE; Wed, 16 Feb 2022 10:36:49 -0300 (-03)
Date:   Wed, 16 Feb 2022 10:36:49 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     German Gomez <german.gomez@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        James Clark <james.clark@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexandre Truong <alexandre.truong@arm.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, irogers@google.com
Subject: Re: [PATCH] perf test: update arm64 perf_event_attr tests for
 --call-graph
Message-ID: <Ygz98VJyz418jv55@kernel.org>
References: <20220125104435.2737-1-german.gomez@arm.com>
 <622a42bd-69da-0df4-bbf3-7d21de77c73b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <622a42bd-69da-0df4-bbf3-7d21de77c73b@arm.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Feb 16, 2022 at 01:17:56PM +0000, German Gomez escreveu:
> Hi,
> 
> Friendly ping on this perf-test fix for arm64

> I will include some quick test notes:

Thanks, adding it to the cset, applying.

- Arnaldo

> Before:
 
> $ ./perf test 17 -v
> 17: Setup struct perf_event_attr
> [...]
> running './tests/attr/test-record-graph-default'
> expected sample_type=295, got 4391
> expected sample_regs_user=0, got 1073741824
> FAILED './tests/attr/test-record-graph-default' - match failure
> test child finished with -1
> ---- end ----
> 
> After:
> 
> [...]
> running './tests/attr/test-record-graph-default-aarch64'
> test limitation 'aarch64'
> running './tests/attr/test-record-graph-fp-aarch64'
> test limitation 'aarch64'
> running './tests/attr/test-record-graph-default'
> test limitation '!aarch64'
> excluded architecture list ['aarch64']
> skipped [aarch64] './tests/attr/test-record-graph-default'
> running './tests/attr/test-record-graph-fp'
> test limitation '!aarch64'
> excluded architecture list ['aarch64']
> skipped [aarch64] './tests/attr/test-record-graph-fp'
> [...]
> 
> Thanks,
> German
> 
> On 25/01/2022 10:44, German Gomez wrote:
> > The struct perf_event_attr is initialised differently in Arm64 when
> > recording in call-graph fp mode, so update the relevant tests, and add
> > two extra arm64-only tests.
> >
> > Fixes: 7248e308a575 ("perf tools: Record ARM64 LR register automatically")
> > Signed-off-by: German Gomez <german.gomez@arm.com>
> > ---
> >  tools/perf/tests/attr/README                            | 2 ++
> >  tools/perf/tests/attr/test-record-graph-default         | 2 ++
> >  tools/perf/tests/attr/test-record-graph-default-aarch64 | 9 +++++++++
> >  tools/perf/tests/attr/test-record-graph-fp              | 2 ++
> >  tools/perf/tests/attr/test-record-graph-fp-aarch64      | 9 +++++++++
> >  5 files changed, 24 insertions(+)
> >  create mode 100644 tools/perf/tests/attr/test-record-graph-default-aarch64
> >  create mode 100644 tools/perf/tests/attr/test-record-graph-fp-aarch64
> >
> > diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> > index a36f49fb4dbe..1116fc6bf2ac 100644
> > --- a/tools/perf/tests/attr/README
> > +++ b/tools/perf/tests/attr/README
> > @@ -45,8 +45,10 @@ Following tests are defined (with perf commands):
> >    perf record -d kill                           (test-record-data)
> >    perf record -F 100 kill                       (test-record-freq)
> >    perf record -g kill                           (test-record-graph-default)
> > +  perf record -g kill                           (test-record-graph-default-aarch64)
> >    perf record --call-graph dwarf kill		(test-record-graph-dwarf)
> >    perf record --call-graph fp kill              (test-record-graph-fp)
> > +  perf record --call-graph fp kill              (test-record-graph-fp-aarch64)
> >    perf record --group -e cycles,instructions kill (test-record-group)
> >    perf record -e '{cycles,instructions}' kill   (test-record-group1)
> >    perf record -e '{cycles/period=1/,instructions/period=2/}:S' kill (test-record-group2)
> > diff --git a/tools/perf/tests/attr/test-record-graph-default b/tools/perf/tests/attr/test-record-graph-default
> > index 5d8234d50845..f0a18b4ea4f5 100644
> > --- a/tools/perf/tests/attr/test-record-graph-default
> > +++ b/tools/perf/tests/attr/test-record-graph-default
> > @@ -2,6 +2,8 @@
> >  command = record
> >  args    = --no-bpf-event -g kill >/dev/null 2>&1
> >  ret     = 1
> > +# arm64 enables registers in the default mode (fp)
> > +arch    = !aarch64
> >  
> >  [event:base-record]
> >  sample_type=295
> > diff --git a/tools/perf/tests/attr/test-record-graph-default-aarch64 b/tools/perf/tests/attr/test-record-graph-default-aarch64
> > new file mode 100644
> > index 000000000000..e98d62efb6f7
> > --- /dev/null
> > +++ b/tools/perf/tests/attr/test-record-graph-default-aarch64
> > @@ -0,0 +1,9 @@
> > +[config]
> > +command = record
> > +args    = --no-bpf-event -g kill >/dev/null 2>&1
> > +ret     = 1
> > +arch    = aarch64
> > +
> > +[event:base-record]
> > +sample_type=4391
> > +sample_regs_user=1073741824
> > diff --git a/tools/perf/tests/attr/test-record-graph-fp b/tools/perf/tests/attr/test-record-graph-fp
> > index 5630521c0b0f..a6e60e839205 100644
> > --- a/tools/perf/tests/attr/test-record-graph-fp
> > +++ b/tools/perf/tests/attr/test-record-graph-fp
> > @@ -2,6 +2,8 @@
> >  command = record
> >  args    = --no-bpf-event --call-graph fp kill >/dev/null 2>&1
> >  ret     = 1
> > +# arm64 enables registers in fp mode
> > +arch    = !aarch64
> >  
> >  [event:base-record]
> >  sample_type=295
> > diff --git a/tools/perf/tests/attr/test-record-graph-fp-aarch64 b/tools/perf/tests/attr/test-record-graph-fp-aarch64
> > new file mode 100644
> > index 000000000000..cbeea9971285
> > --- /dev/null
> > +++ b/tools/perf/tests/attr/test-record-graph-fp-aarch64
> > @@ -0,0 +1,9 @@
> > +[config]
> > +command = record
> > +args    = --no-bpf-event --call-graph fp kill >/dev/null 2>&1
> > +ret     = 1
> > +arch    = aarch64
> > +
> > +[event:base-record]
> > +sample_type=4391
> > +sample_regs_user=1073741824

-- 

- Arnaldo
