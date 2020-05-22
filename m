Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6707A1DEEB1
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbgEVR5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730753AbgEVR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:57:12 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78721C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:57:12 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id l67so1391294ybl.4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4JgBOHCrrlIpp5ulBwC1iusiFKtvJwsskOjbxuRkjhU=;
        b=Nsr6CBlvs3jaqVJKqyoA4j9dfcTp9Gw9Fg8W5x4TSmGSxCKMRfLa0B3CTOh7tZz75i
         x2zBnpAW72alc/u6H1H6eYlIPn9237ct84+sA8AgHUBtd0RdkXWDf3aMyl7gMmU9GK/r
         NLMUK8Fk7EqZQLxsa+XTm+RwWeNSx483qO9SWQpawF3A1bDFd+0JQpr8NZAx1eUUQuHI
         DvlgtbUsVpQL7aa48uWsdMSY4A9oFFIA+YM+Kb0Va8h4J4GlaLylHIaBn61PWD7vkMGE
         lACQ1uMUonEV/+aa4cYm+xLS4HkMfJ75aZzKSc6MjveyzlpvQdQ4nlCXjJPCl07myvWP
         JRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4JgBOHCrrlIpp5ulBwC1iusiFKtvJwsskOjbxuRkjhU=;
        b=dGL680rxRSy57XV6WCqNNqEXJJr/HNZbUOEJEQcoYECKzk8PZGZLvCZUZ+qdySuhVh
         OBbx3yprh6uLyhUnkhXlPcL9tOS/NuhuhrtIbZHL/7dJbFHNLLyCcGQJgbekAFbdIgMa
         D0UXSHdpdYE6ummxoRiMPX1qfJzy4oCB3KoOJXZDmIf5MnBKrB8srK/ZkW5VgmsJh3H4
         DVw6eIEDBo9zjtBotw/zkILNjmnxishBlosCNSg7z1BGmhmXQmuZzpMAuGXrnWtCTaWp
         le/ZFNECZO574JpdoLZkSeQrvMBoIqHNzyPlHinWSJnsXb9cob5VIUuDrdblsUoezQ04
         hDkA==
X-Gm-Message-State: AOAM531b0TAM1usK/MKQ6bo/LH8Rro8Lh5hVCZfBa4J9SQHJLZ0gkQ7S
        O0pmsEEEpHv1TS77DpxoJIWrf4gRGoT8Wvt0fXB27Q==
X-Google-Smtp-Source: ABdhPJyk58h/6x5o1ghDPThLhLKhMrMvIgoTa2LZ1WBg1w7hrSdTb6r5vwzUoF+5xbJh0/GEWEVZ0YVnDT9uc6OtDx8=
X-Received: by 2002:a25:4446:: with SMTP id r67mr24803463yba.41.1590170231345;
 Fri, 22 May 2020 10:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200520182011.32236-1-irogers@google.com> <20200521114325.GT157452@krava>
 <20200521172235.GD14034@kernel.org> <20200522101311.GA404187@krava>
 <20200522144908.GI14034@kernel.org> <CAP-5=fUaaNpi3RZd9-Q-uCaudop0tU5NN8HFek5e2XLoBZqt6w@mail.gmail.com>
In-Reply-To: <CAP-5=fUaaNpi3RZd9-Q-uCaudop0tU5NN8HFek5e2XLoBZqt6w@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 22 May 2020 10:56:59 -0700
Message-ID: <CAP-5=fWZYJ2RXeXGGmFXAW9CNnb2S6cGYKc_M=hUQyCng7KJBQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Share events between metrics
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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

On Fri, May 22, 2020 at 7:59 AM Ian Rogers <irogers@google.com> wrote:
>
>
>
> On Fri, May 22, 2020, 7:49 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
>>
>> Em Fri, May 22, 2020 at 12:13:11PM +0200, Jiri Olsa escreveu:
>> > On Thu, May 21, 2020 at 02:22:35PM -0300, Arnaldo Carvalho de Melo wrote:
>> > > Em Thu, May 21, 2020 at 01:43:25PM +0200, Jiri Olsa escreveu:
>> > > > On Wed, May 20, 2020 at 11:20:04AM -0700, Ian Rogers wrote:
>> > > >
>> > > > SNIP
>> > > >
>> > > > > There are 5 out of 12 metric groups where no events are shared, such
>> > > > > as Power, however, disabling grouping of events always reduces the
>> > > > > number of events.
>> > > > >
>> > > > > The result for Memory_BW needs explanation:
>> > > > >
>> > > > > Metric group: Memory_BW
>> > > > >  - No merging (old default, now --metric-no-merge): 9
>> > > > >  - Merging over metrics (new default)             : 5
>> > > > >  - No event groups and merging (--metric-no-group): 11
>> > > > >
>> > > > > Both with and without merging the groups fail to be set up and so the
>> > > > > event counts here are for broken metrics. The --metric-no-group number
>> > > > > is accurate as all the events are scheduled. Ideally a constraint
>> > > > > would be added for these metrics in the json code to avoid grouping.
>> > > > >
>> > > > > v2. rebases on kernel/git/acme/linux.git branch tmp.perf/core, fixes a
>> > > > > missing comma with metric lists (reported-by Jiri Olsa
>> > > > > <jolsa@redhat.com>) and adds early returns to metricgroup__add_metric
>> > > > > (suggested-by Jiri Olsa).
>> > > >
>> > > > Acked-by: Jiri Olsa <jolsa@redhat.com>
>> > >
>> > > Applied and pushed to tmp.perf/core, will move to perf/core as soon as
>> > > testing finishes,
>> >
>> > I checked tmp.perf/core and I'm getting segfault for 'perf test expr'
>>
>> Right, reproduced here and...
>>
>> >        7: Simple expression parser                              :
>> >       Program received signal SIGSEGV, Segmentation fault.
>> >       0x000000000067841e in hashmap_find_entry (map=0x7fffffffd0c0, key=0xc83b30, hash=9893851511679796638, pprev=0x0, entry=0x7fffffffc658) at hashmap.c:131
>> >       131             for (prev_ptr = &map->buckets[hash], cur = *prev_ptr;
>> >       (gdb) bt
>> >       #0  0x000000000067841e in hashmap_find_entry (map=0x7fffffffd0c0, key=0xc83b30, hash=9893851511679796638, pprev=0x0, entry=0x7fffffffc658) at hashmap.c:131
>> >       #1  0x000000000067853a in hashmap__insert (map=0x7fffffffd0c0, key=0xc83b30, value=0x0, strategy=HASHMAP_SET, old_key=0x7fffffffc718,
>> >           old_value=0x7fffffffc710) at hashmap.c:160
>> >       #2  0x00000000005d3209 in hashmap__set (map=0x7fffffffd0c0, key=0xc83b30, value=0x0, old_key=0x7fffffffc718, old_value=0x7fffffffc710)
>> >           at /home/jolsa/kernel/linux-perf/tools/perf/util/hashmap.h:107
>> >       #3  0x00000000005d3386 in expr__add_id (ctx=0x7fffffffd0c0, name=0xc83b30 "FOO", val=0) at util/expr.c:45
>> >       #4  0x00000000005d27ee in expr_parse (final_val=0x0, ctx=0x7fffffffd0c0, scanner=0xc87990) at util/expr.y:63
>> >       #5  0x00000000005d35b7 in __expr__parse (val=0x0, ctx=0x7fffffffd0c0, expr=0x75a84b "FOO + BAR + BAZ + BOZO", start=259, runtime=1) at util/expr.c:102
>> >       #6  0x00000000005d36c6 in expr__find_other (expr=0x75a84b "FOO + BAR + BAZ + BOZO", one=0x75a791 "FOO", ctx=0x7fffffffd0c0, runtime=1) at util/expr.c:121
>> >       #7  0x00000000004e3aaf in test__expr (t=0xa7bd40 <generic_tests+384>, subtest=-1) at tests/expr.c:55
>> >       #8  0x00000000004b5651 in run_test (test=0xa7bd40 <generic_tests+384>, subtest=-1) at tests/builtin-test.c:393
>> >       #9  0x00000000004b5787 in test_and_print (t=0xa7bd40 <generic_tests+384>, force_skip=false, subtest=-1) at tests/builtin-test.c:423
>> >       #10 0x00000000004b61c4 in __cmd_test (argc=1, argv=0x7fffffffd7f0, skiplist=0x0) at tests/builtin-test.c:628
>> >       #11 0x00000000004b6911 in cmd_test (argc=1, argv=0x7fffffffd7f0) at tests/builtin-test.c:772
>> >       #12 0x00000000004e977b in run_builtin (p=0xa7eee8 <commands+552>, argc=3, argv=0x7fffffffd7f0) at perf.c:312
>> >       #13 0x00000000004e99e8 in handle_internal_command (argc=3, argv=0x7fffffffd7f0) at perf.c:364
>> >       #14 0x00000000004e9b2f in run_argv (argcp=0x7fffffffd64c, argv=0x7fffffffd640) at perf.c:408
>> >       #15 0x00000000004e9efb in main (argc=3, argv=0x7fffffffd7f0) at perf.c:538
>> >
>> > attached patch fixes it for me, but I'm not sure this
>> > should be necessary
>>
>> ... applying the patch below makes the segfault go away. Ian, Ack? I can
>> fold it into the patch introducing the problem.
>
>
> I suspect this patch is a memory leak. The underlying issue is likely the outstanding hashmap_clear fix in libbpf. Let me check.
>
> Thanks,
> Ian

Tested:
$ git checkout -b testing acme/tmp.perf/core
$ make ...
$ perf test 7
7: Simple expression parser                              : FAILED!
$ git cherry-pick 6bca339175bf
[acme-perf-expr-testing 4614bd252003] libbpf: Fix memory leak and
possible double-free in hashmap__c
lear
Author: Andrii Nakryiko <andriin@fb.com>
Date: Tue Apr 28 18:21:04 2020 -0700
1 file changed, 7 insertions(+)
$ make ...
$ perf test 7
7: Simple expression parser                              : Ok

I'd prefer we took the libbpf fix as initializing over the top of the
hashmap will leak. This fix is in the tools/perf/util/hashmap.c.

Thanks,
Ian

>> - Arnaldo
>>
>> > jirka
>> >
>> >
>> > ---
>> > diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
>> > index 1cb02ca2b15f..21693fe516c1 100644
>> > --- a/tools/perf/tests/expr.c
>> > +++ b/tools/perf/tests/expr.c
>> > @@ -52,6 +52,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
>> >       TEST_ASSERT_VAL("missing operand", ret == -1);
>> >
>> >       expr__ctx_clear(&ctx);
>> > +     expr__ctx_init(&ctx);
>> >       TEST_ASSERT_VAL("find other",
>> >                       expr__find_other("FOO + BAR + BAZ + BOZO", "FOO",
>> >                                        &ctx, 1) == 0);
>> > @@ -64,6 +65,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
>> >                                                   (void **)&val_ptr));
>> >
>> >       expr__ctx_clear(&ctx);
>> > +     expr__ctx_init(&ctx);
>> >       TEST_ASSERT_VAL("find other",
>> >                       expr__find_other("EVENT1\\,param\\=?@ + EVENT2\\,param\\=?@",
>> >                                        NULL, &ctx, 3) == 0);
>> >
>> >
>>
>> --
>>
>> - Arnaldo
