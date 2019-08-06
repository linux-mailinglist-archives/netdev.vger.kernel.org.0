Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0D83834
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfHFRtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:49:39 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45401 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfHFRti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:49:38 -0400
Received: by mail-qt1-f195.google.com with SMTP id x22so12028337qtp.12;
        Tue, 06 Aug 2019 10:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jq+wrrNWKhImVMBDOmuK2IUt4EdytOsD9nna1C1Wopk=;
        b=W5GGjA3eKyhvg2K1779EXhT+tXRXO4jdvGlcxIUlmGM+UWoP9O5yTigsxW6F1dPxQr
         4bjvCEg1kc+7Wrxo/VfYXwqqQ0PaV72LeTbZuqz04lGv3ca7eerDU8ILP694Wirhm4VD
         bPedlGswTIw/bx1jdDrXNGaHq9Tp4kx4PAkIOI02373jJYbibHsxJMPiWSybc+tCmtRt
         /FkIivo3FUvQD3fDNlua+GHlaE99LSAi0b2+ue0YISeP9cGmc/1ZzBx6StdZKdKiUBMD
         Nku5zT/LSiCx1v7mJBPpAAzLObLKbpdbOJ+RsR2/Mc3A33+WjR0pCJWtGMpnL0u0ZSFh
         x2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jq+wrrNWKhImVMBDOmuK2IUt4EdytOsD9nna1C1Wopk=;
        b=KgwMrHRkqbAiKcJQPY1/t0FS4gfE6gy0H+szztErzmtbc+JnWYuzxWkB4ydoelpldy
         snUqCDTUrOFlGuOYGBFMMJEtE/S2Vdg+q9vYaqFQ+Accj4ptRiRXDbEW3JpTqk1J1wBl
         Gcb8O9xuJ7C44W+b4JeFsIMr+clZvZ0olP+VRlytveV5ree3IrMQhGNwpAmH7q21p6DK
         B+MrFtjkf+qYZOk1jByeDsT9kk4SeH3AJTXeNk+LSKolZc7Phq856AgU9+TGy2gHOaie
         xXbVD5yOW1awwn515wHknWyRqPtqqbzDlA+Bcmb/cV6J/6lwDNmGt0IS7p2iRUyirJGe
         5TgQ==
X-Gm-Message-State: APjAAAUtkbpSkbxqQmLlnRQ7KCJUTifm27eH4eWJr+hO1cly0cXE5SlS
        mPy6fb1VmrBr4+wGuxwLdLAzZ3YM9cT8VXwYP4o=
X-Google-Smtp-Source: APXvYqzoZ3J6zkSHWyCnAadxPZzcmy0XtnRi6svH7rcrwYfsbsudopBmi+hcz+Hc6Q6ojYqBlVsBxW0CDOs39ub8TW8=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr4262326qta.117.1565113777983;
 Tue, 06 Aug 2019 10:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com> <20190806170901.142264-2-sdf@google.com>
 <CAEf4BzYU6xfcPrHzz0p6dWL3_VM2mD9pKy3T-NfnuDUrd4RMDQ@mail.gmail.com> <20190806174028.GB23939@mini-arch>
In-Reply-To: <20190806174028.GB23939@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Aug 2019 10:49:26 -0700
Message-ID: <CAEf4Bzbt_6Y3bEpsPiHi59KnWoHsk9gQa3XpfRo+gG7-rKqN4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] selftests/bpf: test_progs: switch to open_memstream
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 10:40 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 08/06, Andrii Nakryiko wrote:
> > On Tue, Aug 6, 2019 at 10:19 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Use open_memstream to override stdout during test execution.
> > > The copy of the original stdout is held in env.stdout and used
> > > to print subtest info and dump failed log.
> > >
> > > test_{v,}printf are now simple wrappers around stdout and will be
> > > removed in the next patch.
> > >
> > > v4:
> > > * one field per line for stdout/stderr (Andrii Nakryiko)
> > >
> > > v3:
> > > * don't do strlen over log_buf, log_cnt has it already (Andrii Nakryiko)
> > >
> > > v2:
> > > * add ifdef __GLIBC__ around open_memstream (maybe pointless since
> > >   we already depend on glibc for argp_parse)
> > > * hijack stderr as well (Andrii Nakryiko)
> > > * don't hijack for every test, do it once (Andrii Nakryiko)
> > > * log_cap -> log_size (Andrii Nakryiko)
> > > * do fseeko in a proper place (Andrii Nakryiko)
> > > * check open_memstream returned value (Andrii Nakryiko)
> > >
> > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
> > >  tools/testing/selftests/bpf/test_progs.h |   3 +-
> > >  2 files changed, 62 insertions(+), 56 deletions(-)
> > >

[...]

> > >  void test__printf(const char *fmt, ...)
> > > @@ -477,6 +438,48 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
> > >         return 0;
> > >  }
> > >
> > > +static void stdio_hijack(void)
> > > +{
> > > +#ifdef __GLIBC__
> > > +       if (env.verbose || (env.test && env.test->force_log)) {
> >
> > I just also realized that you don't need `(env.test &&
> > env.test->force_log)` test. We hijack stdout/stderr before env.test is
> > even set, so this does nothing anyways. Plus, force_log can be set in
> > the middle of test/sub-test, yet we hijack stdout just once (or even
> > if per-test), so it's still going to be "racy". Let's buffer output
> > (unless it's env.verbose, which is important to not buffer because
> > some tests will have huge output, when failing, so this allows to
> > bypass using tons of memory for those, when debugging) and dump at the
> > end.
> Makes sense, will drop this test and resubmit along with a fix for '-v'
> that Alexei discovered. Thanks!

Oh, is it because env.stdout and env.stderr is not set in verbose
mode? I'd always set env.stdout/env.stderr at the beginning, next to
env.jit_enabled, to never care about "logging modes".

>
> > > +               /* nothing to do, output to stdout by default */
> > > +               return;
> > > +       }
> > > +

[...]
