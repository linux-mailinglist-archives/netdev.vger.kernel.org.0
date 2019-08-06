Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A62883844
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfHFRyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:54:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46670 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbfHFRyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:54:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id c3so18771024pfa.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/8ErMGnuYeEpJafTeKt+7MrdPsKsU8b1Km1b1TisCrY=;
        b=Ivo2uXWwt3POY71IOw50XDWgc7cpO+/+5+Y8MXQPQimLSesy1Eo/S2IlbH7J+ZydoZ
         bibJyIyxJiDtLjfID0nn9w4AnLaisXPIGqmoOcVnpxNDPdNggtcDFPQPIXhqFFz8AzDw
         cJ/i6Jup45MPt4X01E33ubqxvlZQBUhaUWtE9k3uqnni/brqby3zKVbh0a52oY5ikn5t
         MZD/PNmPzDbA+sjbd0smn4IepY9hM/J9UpLJWbmlN43GHdfRx0+gSvZhghBI4Hzit9Ds
         f4398ojZzLosQioVvqUV8Qcyn1KOidhVb9ItbVcyiQ3ZoPvXDEsFl9KPMOIJMJwlhsfT
         u9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/8ErMGnuYeEpJafTeKt+7MrdPsKsU8b1Km1b1TisCrY=;
        b=s24GWIJemZ4zXCWTR6xZpmaRabuCc98F7C5QJmZd5xRtcClxNYCANmY2Cu3YoDGWWV
         HaQoJc8Ultk0jKe4UuUpC0o0s3Nm1UaV7lwmVDcebbLt4AQcgKHnCoKVgSase/zIB7fs
         XHHg13xnUqL5XK1GxKfJ8KLkUuFp74CBAu7su7Kv7Lt6fLEpoSUytUWWY06+9fcHgHLt
         l0yHQ5jkXWAxYy+lr+CgQBAthAkx2D3Z7gBEkHUpt3VL7OUc+cdnklSlIBqHJVxpW2zs
         kir9ZOYN0W3Dg7yO6tqpns7wDALp/fSYtcM2huoz8prgQQlKos77ZuA/SokFUAPvULQg
         Rxkw==
X-Gm-Message-State: APjAAAUzjDPNz3m36AK6Y3izdw4OMLAhKTb9sRJiwU5q1GJxd65eXjbo
        V5WtONE/hAFPsGZUNNAgPexUEw==
X-Google-Smtp-Source: APXvYqwSpRPc9HUD1+po8jJlTZikqy/xUdp6Wf8WkCSOlBQD1ECIvi8QR+qw8v8lBOLE+tJCraLs5w==
X-Received: by 2002:a63:a346:: with SMTP id v6mr4081595pgn.57.1565114052745;
        Tue, 06 Aug 2019 10:54:12 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 23sm91839684pfn.176.2019.08.06.10.54.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 10:54:12 -0700 (PDT)
Date:   Tue, 6 Aug 2019 10:54:11 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v4 1/3] selftests/bpf: test_progs: switch to
 open_memstream
Message-ID: <20190806175411.GC23939@mini-arch>
References: <20190806170901.142264-1-sdf@google.com>
 <20190806170901.142264-2-sdf@google.com>
 <CAEf4BzYU6xfcPrHzz0p6dWL3_VM2mD9pKy3T-NfnuDUrd4RMDQ@mail.gmail.com>
 <20190806174028.GB23939@mini-arch>
 <CAEf4Bzbt_6Y3bEpsPiHi59KnWoHsk9gQa3XpfRo+gG7-rKqN4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbt_6Y3bEpsPiHi59KnWoHsk9gQa3XpfRo+gG7-rKqN4w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06, Andrii Nakryiko wrote:
> On Tue, Aug 6, 2019 at 10:40 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 08/06, Andrii Nakryiko wrote:
> > > On Tue, Aug 6, 2019 at 10:19 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Use open_memstream to override stdout during test execution.
> > > > The copy of the original stdout is held in env.stdout and used
> > > > to print subtest info and dump failed log.
> > > >
> > > > test_{v,}printf are now simple wrappers around stdout and will be
> > > > removed in the next patch.
> > > >
> > > > v4:
> > > > * one field per line for stdout/stderr (Andrii Nakryiko)
> > > >
> > > > v3:
> > > > * don't do strlen over log_buf, log_cnt has it already (Andrii Nakryiko)
> > > >
> > > > v2:
> > > > * add ifdef __GLIBC__ around open_memstream (maybe pointless since
> > > >   we already depend on glibc for argp_parse)
> > > > * hijack stderr as well (Andrii Nakryiko)
> > > > * don't hijack for every test, do it once (Andrii Nakryiko)
> > > > * log_cap -> log_size (Andrii Nakryiko)
> > > > * do fseeko in a proper place (Andrii Nakryiko)
> > > > * check open_memstream returned value (Andrii Nakryiko)
> > > >
> > > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
> > > >  tools/testing/selftests/bpf/test_progs.h |   3 +-
> > > >  2 files changed, 62 insertions(+), 56 deletions(-)
> > > >
> 
> [...]
> 
> > > >  void test__printf(const char *fmt, ...)
> > > > @@ -477,6 +438,48 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static void stdio_hijack(void)
> > > > +{
> > > > +#ifdef __GLIBC__
> > > > +       if (env.verbose || (env.test && env.test->force_log)) {
> > >
> > > I just also realized that you don't need `(env.test &&
> > > env.test->force_log)` test. We hijack stdout/stderr before env.test is
> > > even set, so this does nothing anyways. Plus, force_log can be set in
> > > the middle of test/sub-test, yet we hijack stdout just once (or even
> > > if per-test), so it's still going to be "racy". Let's buffer output
> > > (unless it's env.verbose, which is important to not buffer because
> > > some tests will have huge output, when failing, so this allows to
> > > bypass using tons of memory for those, when debugging) and dump at the
> > > end.
> > Makes sense, will drop this test and resubmit along with a fix for '-v'
> > that Alexei discovered. Thanks!
> 
> Oh, is it because env.stdout and env.stderr is not set in verbose
> mode? I'd always set env.stdout/env.stderr at the beginning, next to
> env.jit_enabled, to never care about "logging modes".
Yeah, I moved it to the beginning of stdio_hijack() to mirror the 'undo'
in stdio_restore(). Let me know if you feel strongly about it and want
it to be near env.jit_enabled instead.

> > > > +               /* nothing to do, output to stdout by default */
> > > > +               return;
> > > > +       }
> > > > +
> 
> [...]
