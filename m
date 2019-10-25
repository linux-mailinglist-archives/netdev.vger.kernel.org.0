Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB31CE5083
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502272AbfJYPwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:52:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36345 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393672AbfJYPwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:52:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id c22so2501624wmd.1
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 08:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MkEnZfsIQrngMILmeAT4dBDXyh5jmqSJ5s+5PTuBqsM=;
        b=qdNod/O2w4N0AO4TBAAlzNesVz2jH4Ja+rL+S91bT2Wrxv0ttR8TgdCP7ez3zmxZJC
         lmdQzNdT3wK9RVtk8oE6TSoJlIBgfemd2cOP3VsQYc2WFNO3XGAGvQbQCu8qcK56wvdD
         reMyfjkG7LJHwgfwqPOuUnPND6tRbiCQ57WiZApUZGYmXOAUyw4Z+DJSbh9R8YTrMiU5
         yiI8+xbhkjdhqAL2e70E4wuMFtwa++MzDnZDRxQXeCPzVswKLnGFk8XpoLc68i0cW8t+
         4YnFjw917jqaGR3NqSb/9AinPmNXLsmLdQMlrqwC7QojjwT1ZkahE/jDwniKk11Daq5q
         wV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MkEnZfsIQrngMILmeAT4dBDXyh5jmqSJ5s+5PTuBqsM=;
        b=ncZMqfkQeHLsQ8xlcFd4V4hUIWWoxByGCfMk0ULOJgrGUiVfaKJ1jUEryvGhaNiE4M
         pQMsmJBP16B2wGEWC/WDdfldeJFpLCNFotH4xzmHyBSdgv+57FZpjcwTQN3H7jzS8/b7
         mYxIh/V8xwPvG9dGhF4CKoLAHWLaR7kOStTHpkOxLFr8lm2TcZD+WVJFAs7AZmKmrAWm
         guadneHSCV50d4qfTDt7gVk0uqUN1euolOvfD2M6SIv0Sk0RFXq1roFslwW6b/y0EwsM
         YEbCQ9K0owmnPhrliD5pBSH3pxXk/wTe3zYV2KxlesaMhs7dN8bo/hN1O6eJUYNeVAJp
         p3bQ==
X-Gm-Message-State: APjAAAV/peyfKrXSY7ciqI6DlKMlNCbM6pd5YHg3e763uSrOkRrW8wzT
        c9A/LbYM+RA2Ri6MtvgL/TZGPqe/Dv9vF9f3sszaaQ==
X-Google-Smtp-Source: APXvYqxy/HlAbbqoIFl0AFE9edsrlK04uLPxr2oS95HzgaGxGf68CswddkRbrhjZd/D3sF+1L/JF++bAcSmjprYT/y4=
X-Received: by 2002:a1c:6641:: with SMTP id a62mr2300413wmc.54.1572018739487;
 Fri, 25 Oct 2019 08:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-4-irogers@google.com> <20191025081046.GG31679@krava>
In-Reply-To: <20191025081046.GG31679@krava>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 25 Oct 2019 08:52:07 -0700
Message-ID: <CAP-5=fW6PV5xYDyNViz_U9Y5Up8B30tUoyCuf_jM0XLj2ESQRA@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] perf tools: ensure config and str in terms are unique
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 24, 2019 at 12:01:56PM -0700, Ian Rogers wrote:
> > Make it easier to release memory associated with parse event terms by
> > duplicating the string for the config name and ensuring the val string
> > is a duplicate.
> >
> > Currently the parser may memory leak terms and this is addressed in a
> > later patch.
>
> please move that patch before this one

Doing that causes a use after free, or freeing of stack or .rodata.
The strings need to be on the heap before they can be cleaned up,
hence the order the patches appear here. There are already memory
leaks here and so while this does make more of them, it is a temporary
state until the later freeing patch is added. I wanted to avoid a
large monolithic patch.

Thanks,
Ian

> thanks,
> jirka
>
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/parse-events.c | 51 ++++++++++++++++++++++++++++------
> >  tools/perf/util/parse-events.y |  4 ++-
> >  2 files changed, 45 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index f0d50f079d2f..dc5862a663b5 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -1430,7 +1430,6 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
> >  int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
> >                              char *str, struct list_head **listp)
> >  {
> > -     struct list_head *head;
> >       struct parse_events_term *term;
> >       struct list_head *list;
> >       struct perf_pmu *pmu = NULL;
> > @@ -1447,19 +1446,30 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
> >
> >               list_for_each_entry(alias, &pmu->aliases, list) {
> >                       if (!strcasecmp(alias->name, str)) {
> > +                             struct list_head *head;
> > +                             char *config;
> > +
> >                               head = malloc(sizeof(struct list_head));
> >                               if (!head)
> >                                       return -1;
> >                               INIT_LIST_HEAD(head);
> > -                             if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> > -                                                        str, 1, false, &str, NULL) < 0)
> > +                             config = strdup(str);
> > +                             if (!config)
> > +                                     return -1;
> > +                             if (parse_events_term__num(&term,
> > +                                                PARSE_EVENTS__TERM_TYPE_USER,
> > +                                                config, 1, false, &config,
> > +                                                NULL) < 0) {
> > +                                     free(list);
> > +                                     free(config);
> >                                       return -1;
> > +                             }
> >                               list_add_tail(&term->list, head);
> >
> >                               if (!parse_events_add_pmu(parse_state, list,
> >                                                         pmu->name, head,
> >                                                         true, true)) {
> > -                                     pr_debug("%s -> %s/%s/\n", str,
> > +                                     pr_debug("%s -> %s/%s/\n", config,
> >                                                pmu->name, alias->str);
> >                                       ok++;
> >                               }
> > @@ -1468,8 +1478,10 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
> >                       }
> >               }
> >       }
> > -     if (!ok)
> > +     if (!ok) {
> > +             free(list);
> >               return -1;
> > +     }
> >       *listp = list;
> >       return 0;
> >  }
> > @@ -2764,30 +2776,51 @@ int parse_events_term__sym_hw(struct parse_events_term **term,
> >                             char *config, unsigned idx)
> >  {
> >       struct event_symbol *sym;
> > +     char *str;
> >       struct parse_events_term temp = {
> >               .type_val  = PARSE_EVENTS__TERM_TYPE_STR,
> >               .type_term = PARSE_EVENTS__TERM_TYPE_USER,
> > -             .config    = config ?: (char *) "event",
> > +             .config    = config,
> >       };
> >
> > +     if (!temp.config) {
> > +             temp.config = strdup("event");
> > +             if (!temp.config)
> > +                     return -ENOMEM;
> > +     }
> >       BUG_ON(idx >= PERF_COUNT_HW_MAX);
> >       sym = &event_symbols_hw[idx];
> >
> > -     return new_term(term, &temp, (char *) sym->symbol, 0);
> > +     str = strdup(sym->symbol);
> > +     if (!str)
> > +             return -ENOMEM;
> > +     return new_term(term, &temp, str, 0);
> >  }
> >
> >  int parse_events_term__clone(struct parse_events_term **new,
> >                            struct parse_events_term *term)
> >  {
> > +     char *str;
> >       struct parse_events_term temp = {
> >               .type_val  = term->type_val,
> >               .type_term = term->type_term,
> > -             .config    = term->config,
> > +             .config    = NULL,
> >               .err_term  = term->err_term,
> >               .err_val   = term->err_val,
> >       };
> >
> > -     return new_term(new, &temp, term->val.str, term->val.num);
> > +     if (term->config) {
> > +             temp.config = strdup(term->config);
> > +             if (!temp.config)
> > +                     return -ENOMEM;
> > +     }
> > +     if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM)
> > +             return new_term(new, &temp, NULL, term->val.num);
> > +
> > +     str = strdup(term->val.str);
> > +     if (!str)
> > +             return -ENOMEM;
> > +     return new_term(new, &temp, str, 0);
> >  }
> >
> >  int parse_events_copy_term_list(struct list_head *old,
> > diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> > index 48126ae4cd13..27d6b187c9b1 100644
> > --- a/tools/perf/util/parse-events.y
> > +++ b/tools/perf/util/parse-events.y
> > @@ -644,9 +644,11 @@ PE_NAME array '=' PE_VALUE
> >  PE_DRV_CFG_TERM
> >  {
> >       struct parse_events_term *term;
> > +     char *config = strdup($1);
> >
> > +     ABORT_ON(!config);
> >       ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CFG,
> > -                                     $1, $1, &@1, NULL));
> > +                                     config, $1, &@1, NULL));
> >       $$ = term;
> >  }
> >
> > --
> > 2.23.0.866.gb869b98d4c-goog
> >
>
