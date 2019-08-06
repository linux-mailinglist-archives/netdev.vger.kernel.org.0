Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F9283847
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbfHFRzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:55:44 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44896 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFRzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:55:44 -0400
Received: by mail-qt1-f195.google.com with SMTP id 44so54400790qtg.11;
        Tue, 06 Aug 2019 10:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5KkDLPDl9G1MJIr46DPmnf/JfgY8sITbPUFHsx3P0GI=;
        b=DsVjxLtiGkD4iTyfRqzjx0WDZWEgSjNDkQSPEXEhGm+H1TzZvhiw1jut67yM28ugK7
         Ymr26pm4RXIVUMTARz9kIqtJrYvSwvN7WMSo1EL1QdnOIU9vI3OeeR+3w1lEOZpstSGw
         Ut3sElwWxkIrR2B833zja+9RCYuf+95ZMBNKAMIcufGtDZFQIuIblSfL4QtaZjC0PRPA
         YPMhaA5kr3Kh9oOUCEhWb3BE4WxskryEgvo1ezoAbvR13WnjhvtRJMJQKO/liyD4FNTM
         TKenwzcJAyOFqN32MsWIFcgqjps4zhsaay2+9bGghbnnOcIQyDpU/j+dS7rBjtYdnQWR
         zQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5KkDLPDl9G1MJIr46DPmnf/JfgY8sITbPUFHsx3P0GI=;
        b=sF78tnliMa5Sj1KNdd0tYs3o7Uhp3sUty6/gW2t4sC8k/TDFHHu8SpHdBql8KmXnNm
         qG5ix0PVFEptfojTLUHCa2BfjBbL8SyZxVzdAzBwJaXOUa4glSRmuSBMErOyCQ3XUKAs
         GFP3+UYIY5w6rPF5k2LKnCLLy8YdRpE+lDk5kCXVJd5KXwXg/qnWaKoSGcloownMawtR
         8l/6xbgZQ0HTauqk+CJTElYCLNazyWfYi014HtNvmKoivMBcEiaL3gM2AHf9BsOe62e2
         K4VVKpW4qSpBN8jTY0tZJTmUuLobbaQGqKpxKA5PAFJf+AQPHlfbBXV90ubSXbXQcUJ+
         WiIQ==
X-Gm-Message-State: APjAAAWI1MvhajYhWoUraUU3oWn1vSAgf4Mlf4ZWcJCK2vzn9QDIyXPR
        8mLgXJa78ToI7Cr6ORDdQ3VtS2OJsemO76Twbcw=
X-Google-Smtp-Source: APXvYqzu67EzDnXrT9SUOyF7eUpzrlcpxmG5KShObXGLLfyxrvZd1bV5zoSTAdJEaNQsXnUOi2fEDnn2byYVMhkXzOA=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr4206676qvh.150.1565114143064;
 Tue, 06 Aug 2019 10:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com> <20190806170901.142264-2-sdf@google.com>
 <CAEf4BzYU6xfcPrHzz0p6dWL3_VM2mD9pKy3T-NfnuDUrd4RMDQ@mail.gmail.com>
 <20190806174028.GB23939@mini-arch> <CAEf4Bzbt_6Y3bEpsPiHi59KnWoHsk9gQa3XpfRo+gG7-rKqN4w@mail.gmail.com>
 <20190806175411.GC23939@mini-arch>
In-Reply-To: <20190806175411.GC23939@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Aug 2019 10:55:32 -0700
Message-ID: <CAEf4BzYq1Fja-bvT0TTLgGhfBCfi+N1j85bE690ziqD=05RH8w@mail.gmail.com>
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

On Tue, Aug 6, 2019 at 10:54 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 08/06, Andrii Nakryiko wrote:
> > On Tue, Aug 6, 2019 at 10:40 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 08/06, Andrii Nakryiko wrote:
> > > > On Tue, Aug 6, 2019 at 10:19 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > Use open_memstream to override stdout during test execution.
> > > > > The copy of the original stdout is held in env.stdout and used
> > > > > to print subtest info and dump failed log.
> > > > >
> > > > > test_{v,}printf are now simple wrappers around stdout and will be
> > > > > removed in the next patch.
> > > > >
> > > > > v4:
> > > > > * one field per line for stdout/stderr (Andrii Nakryiko)
> > > > >
> > > > > v3:
> > > > > * don't do strlen over log_buf, log_cnt has it already (Andrii Nakryiko)
> > > > >
> > > > > v2:
> > > > > * add ifdef __GLIBC__ around open_memstream (maybe pointless since
> > > > >   we already depend on glibc for argp_parse)
> > > > > * hijack stderr as well (Andrii Nakryiko)
> > > > > * don't hijack for every test, do it once (Andrii Nakryiko)
> > > > > * log_cap -> log_size (Andrii Nakryiko)
> > > > > * do fseeko in a proper place (Andrii Nakryiko)
> > > > > * check open_memstream returned value (Andrii Nakryiko)
> > > > >
> > > > > Cc: Andrii Nakryiko <andriin@fb.com>
> > > > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
> > > > >  tools/testing/selftests/bpf/test_progs.h |   3 +-
> > > > >  2 files changed, 62 insertions(+), 56 deletions(-)
> > > > >
> >
> > [...]
> >
> > > > >  void test__printf(const char *fmt, ...)
> > > > > @@ -477,6 +438,48 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
> > > > >         return 0;
> > > > >  }
> > > > >
> > > > > +static void stdio_hijack(void)
> > > > > +{
> > > > > +#ifdef __GLIBC__
> > > > > +       if (env.verbose || (env.test && env.test->force_log)) {
> > > >
> > > > I just also realized that you don't need `(env.test &&
> > > > env.test->force_log)` test. We hijack stdout/stderr before env.test is
> > > > even set, so this does nothing anyways. Plus, force_log can be set in
> > > > the middle of test/sub-test, yet we hijack stdout just once (or even
> > > > if per-test), so it's still going to be "racy". Let's buffer output
> > > > (unless it's env.verbose, which is important to not buffer because
> > > > some tests will have huge output, when failing, so this allows to
> > > > bypass using tons of memory for those, when debugging) and dump at the
> > > > end.
> > > Makes sense, will drop this test and resubmit along with a fix for '-v'
> > > that Alexei discovered. Thanks!
> >
> > Oh, is it because env.stdout and env.stderr is not set in verbose
> > mode? I'd always set env.stdout/env.stderr at the beginning, next to
> > env.jit_enabled, to never care about "logging modes".
> Yeah, I moved it to the beginning of stdio_hijack() to mirror the 'undo'
> in stdio_restore(). Let me know if you feel strongly about it and want
> it to be near env.jit_enabled instead.

I'm fine with it, no big deal, I wrote email before I saw your v5.

>
> > > > > +               /* nothing to do, output to stdout by default */
> > > > > +               return;
> > > > > +       }
> > > > > +
> >
> > [...]
