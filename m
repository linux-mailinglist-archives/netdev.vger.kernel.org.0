Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9D4218AF6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgGHPPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgGHPPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:15:37 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5925C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:15:37 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so3620783wml.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xWBTRBhMqunHOj4YJ5dV+lc5++IAMIqO7O5wAwFK16E=;
        b=IBpViC30bmuY0aMeTBgYYE7fYv8dIWFNKFtXOoBOVZX5BvRyQAi9jNc6NcBAS60oXC
         ODphL7JL5RdJ9Zh+bw0fYs5co8ea7v4yQ+vBc1npq3IWX9LmRNlIKgaqX9k9jDMQs21K
         n3T28EBBhxmdsV1nGhW9e4MEIPZ7ZakZhQbe0xmeeGU+SwfEy0ImgL90YFmoAc9Y7oQO
         AiCDDXVRAIsj36X8l6bW72hzJfqB9Ds7zFTf1k8ZzytiETLDcFWj6iUd4qGVVSv+/iFv
         VQnURlTf9VCYvuIJmRGgT9N3kc+sCvx9JxIN+9QM6OACj9X3t645x9wi6r9W/21eC5Ui
         e4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xWBTRBhMqunHOj4YJ5dV+lc5++IAMIqO7O5wAwFK16E=;
        b=Z2qjvpbISiebKSUrxK6HaY4bSoHxR08Dnh9HauR9lJszU2b+smDF4ZYcz7NlPdOWwH
         6zpe5/3FLZb95jAoE7HDp1jR+PSopxoTEhumOyPPSczrYiOvlsjed4RotaAx8P92yCwM
         aN+ME+8C9RuRGjxAUJio9atakEKRe6IHRbgzF+x7omZDzpTNGQOct59yWKYOmHTfDwDI
         eipW66MkVUQ9CF3O0UZgEUrGhC1ilL8M7uar1w7B/T5VhLAixT2crRYik2rIVFHwBLAC
         3+QtolUHPZlR3ZJ9thhiMF7Rdp/eGMiMI6tZMx0ffJfdSJxkKIOIBeYwLEGzLhJjzdZ7
         znXg==
X-Gm-Message-State: AOAM533HhmmQfh6ieB8l9rzFP2byXVDZmlXI17AYB9mp3GXkcRAvuq2y
        ib8g7UZHw5/fcRYHI3g9i14feVwOaAPknetJefHTWw==
X-Google-Smtp-Source: ABdhPJwyogSayFVl8/gyXE4ClQk0n7IxYRyXrGig9XGZYX/+V6UOLYpu3pW1nwtG4w9wbUZO7Rv7Cph2H6Mnhs2szew=
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr9554339wmf.87.1594221336191;
 Wed, 08 Jul 2020 08:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200707211449.3868944-1-irogers@google.com> <20200708111935.GK1320@kernel.org>
In-Reply-To: <20200708111935.GK1320@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 8 Jul 2020 08:15:24 -0700
Message-ID: <CAP-5=fXr2xKbiYaNKOGytnwgNYOKYuGK-qT+GYpJZ4tdPb88eA@mail.gmail.com>
Subject: Re: [PATCH] perf parse-events: report bpf errors
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 4:19 AM Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
>
> Em Tue, Jul 07, 2020 at 02:14:49PM -0700, Ian Rogers escreveu:
> > Setting the parse_events_error directly doesn't increment num_errors
> > causing the error message not to be displayed. Use the
> > parse_events__handle_error function that sets num_errors and handle
> > multiple errors.
>
> What was the command line you used to exercise the error and then the
> fix?

You need something to stand in for the BPF event so:

Before:
```
$ /tmp/perf/perf record -e /tmp/perf/util/parse-events.o
Run 'perf list' for a list of valid events

Usage: perf record [<options>] [<command>]
   or: perf record [<options>] -- <command> [<options>]

   -e, --event <event>   event selector. use 'perf list' to list available event
```
After:
```
$ /tmp/perf/perf record -e /tmp/perf/util/parse-events.o
event syntax error: '/tmp/perf/util/parse-events.o'
                    \___ Failed to load /tmp/perf/util/parse-events.o:
BPF object format invalid

(add -v to see detail)
Run 'perf list' for a list of valid events

Usage: perf record [<options>] [<command>]
   or: perf record [<options>] -- <command> [<options>]

   -e, --event <event>   event selector. use 'perf list' to list
available events
```

Thanks,
Ian

> - Arnaldo
>
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/perf/util/parse-events.c | 38 ++++++++++++++++++----------------
> >  1 file changed, 20 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index c4906a6a9f1a..e88e4c7a2a9a 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -767,8 +767,8 @@ int parse_events_load_bpf_obj(struct parse_events_state *parse_state,
> >
> >       return 0;
> >  errout:
> > -     parse_state->error->help = strdup("(add -v to see detail)");
> > -     parse_state->error->str = strdup(errbuf);
> > +     parse_events__handle_error(parse_state->error, 0,
> > +                             strdup(errbuf), strdup("(add -v to see detail)"));
> >       return err;
> >  }
> >
> > @@ -784,36 +784,38 @@ parse_events_config_bpf(struct parse_events_state *parse_state,
> >               return 0;
> >
> >       list_for_each_entry(term, head_config, list) {
> > -             char errbuf[BUFSIZ];
> >               int err;
> >
> >               if (term->type_term != PARSE_EVENTS__TERM_TYPE_USER) {
> > -                     snprintf(errbuf, sizeof(errbuf),
> > -                              "Invalid config term for BPF object");
> > -                     errbuf[BUFSIZ - 1] = '\0';
> > -
> > -                     parse_state->error->idx = term->err_term;
> > -                     parse_state->error->str = strdup(errbuf);
> > +                     parse_events__handle_error(parse_state->error, term->err_term,
> > +                                             strdup("Invalid config term for BPF object"),
> > +                                             NULL);
> >                       return -EINVAL;
> >               }
> >
> >               err = bpf__config_obj(obj, term, parse_state->evlist, &error_pos);
> >               if (err) {
> > +                     char errbuf[BUFSIZ];
> > +                     int idx;
> > +
> >                       bpf__strerror_config_obj(obj, term, parse_state->evlist,
> >                                                &error_pos, err, errbuf,
> >                                                sizeof(errbuf));
> > -                     parse_state->error->help = strdup(
> > +
> > +                     if (err == -BPF_LOADER_ERRNO__OBJCONF_MAP_VALUE)
> > +                             idx = term->err_val;
> > +                     else
> > +                             idx = term->err_term + error_pos;
> > +
> > +                     parse_events__handle_error(parse_state->error, idx,
> > +                                             strdup(errbuf),
> > +                                             strdup(
> >  "Hint:\tValid config terms:\n"
> >  "     \tmap:[<arraymap>].value<indices>=[value]\n"
> >  "     \tmap:[<eventmap>].event<indices>=[event]\n"
> >  "\n"
> >  "     \twhere <indices> is something like [0,3...5] or [all]\n"
> > -"     \t(add -v to see detail)");
> > -                     parse_state->error->str = strdup(errbuf);
> > -                     if (err == -BPF_LOADER_ERRNO__OBJCONF_MAP_VALUE)
> > -                             parse_state->error->idx = term->err_val;
> > -                     else
> > -                             parse_state->error->idx = term->err_term + error_pos;
> > +"     \t(add -v to see detail)"));
> >                       return err;
> >               }
> >       }
> > @@ -877,8 +879,8 @@ int parse_events_load_bpf(struct parse_events_state *parse_state,
> >                                                  -err, errbuf,
> >                                                  sizeof(errbuf));
> >
> > -             parse_state->error->help = strdup("(add -v to see detail)");
> > -             parse_state->error->str = strdup(errbuf);
> > +             parse_events__handle_error(parse_state->error, 0,
> > +                                     strdup(errbuf), strdup("(add -v to see detail)"));
> >               return err;
> >       }
> >
> > --
> > 2.27.0.383.g050319c2ae-goog
> >
>
> --
>
> - Arnaldo
