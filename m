Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A281C71DE0
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbfGWRjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:39:03 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32930 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388568AbfGWRjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:39:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id r6so38505693qtt.0;
        Tue, 23 Jul 2019 10:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EuACWTx6/VsexzsqTVb15VQ3sSXyBNMO7OIyxtO9bbA=;
        b=mvXBrzDvijQy+ixZaXTbMDldl8awDToFlznF/XrAtAL1z9lOKTBQVZdbpVnn24BgGN
         m7Br1RXmHB3qWsUfQ2379A7IWEMntsumIF1MhiotXW1galje5Rcn84WxeAY9Qek+m0sv
         zY37GWyQI8701y544+hD8cd4w01sXqOb6nI2nXCAdVCUeqsqdAl9IgEbxduSaO5hv7fk
         Vv8LlxQERLKYgN5X9x+x714PnJI/s3DKlJaIiXDVRWqbIthB9Omm0IRyWOdYcSER1EXl
         eMbPEkqRt6rBTl1vuh3Q7nhQ4wbKEXkejGiIfhuQw5yM1dqIMG1o0d0hOtfJHt2sEkhJ
         xkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EuACWTx6/VsexzsqTVb15VQ3sSXyBNMO7OIyxtO9bbA=;
        b=Rd7PgHN7vAQDwNlhSrH1t9WGNBeksgQYEqrg3BBau309M2n49bn7YF8fYJi7lcVRCH
         9CEqCgpVs/kUGszoF+pbCW+7qsghK0+Exo02r1AMSO+SAEaHIPGZIEBDs0BzkPLN8eNa
         fg3NTc+oRHL6wAphSlvTBu1qZNSvlEIjAdKWC6EutlafDoheeayEB14WtKvlRAvjiWKu
         8tJJd1QYtVL2YkAV1zrWInxRQSRGKacjRhc+i8Wa80Dr/uSVKa0LyZY8wp00ceKMPHGH
         DWtSPyZri2a1SsHVEYl04MouzOwysE5GsCI1VhXGqHkrfHFtU92vImL+MRohje8f/UIh
         kZfw==
X-Gm-Message-State: APjAAAXm+a+Nr6W1QSgufXiAmooJCPbmIuMptAPzdVekJvWKdc/BZHld
        BqOH3cYcCjwM+s0Rz0tonnMT4xR3cq7dLfiZejc=
X-Google-Smtp-Source: APXvYqzC5XlTNHwrs/+7G6QIJdWnkB9m5ioF5tiMZY9dVQ98oJ8agj7U8FIVGPXt++EUv/cNb35lYBIvXQ66rAfqvrI=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr55687828qvh.78.1563903542315;
 Tue, 23 Jul 2019 10:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190723043112.3145810-1-andriin@fb.com> <20190723043112.3145810-2-andriin@fb.com>
 <EBDB05E7-C10F-479F-B2A7-62D59EE4887E@fb.com>
In-Reply-To: <EBDB05E7-C10F-479F-B2A7-62D59EE4887E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jul 2019 10:38:51 -0700
Message-ID: <CAEf4BzYKFTgsf982SEZotZ5+UgP+ErieKXSUoKyj5_gCKrHxTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: convert test_get_stack_raw_tp
 to perf_buffer API
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 2:25 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 22, 2019, at 9:31 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Convert test_get_stack_raw_tp test to new perf_buffer API.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > .../bpf/prog_tests/get_stack_raw_tp.c         | 78 ++++++++++---------
> > .../bpf/progs/test_get_stack_rawtp.c          |  2 +-
> > 2 files changed, 44 insertions(+), 36 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> > index c2a0a9d5591b..473889e1b219 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> > @@ -1,8 +1,15 @@
> > // SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <pthread.h>
> > +#include <sched.h>
> > +#include <sys/socket.h>
> > #include <test_progs.h>
> >
> > #define MAX_CNT_RAWTP 10ull
> > #define MAX_STACK_RAWTP       100
> > +
> > +static int duration = 0;
> > +
>
> Are we using "duration" at all?

Yes, unfortunately in test_progs CHECK macro expects "duration"
variable to be defined. It's very annoying and I'm going to work on
cleaning up and streamlining how we do selftests in bpf, so hopefully
we'll get rid of some of those "artifacts". But for now, yeah,
duration has to be defined somewhere.

>
> > struct get_stack_trace_t {
> >       int pid;
> >       int kern_stack_size;
> > @@ -13,7 +20,7 @@ struct get_stack_trace_t {
> >       struct bpf_stack_build_id user_stack_buildid[MAX_STACK_RAWTP];
> > };
> >
> > -static int get_stack_print_output(void *data, int size)
> > +static void get_stack_print_output(void *ctx, int cpu, void *data, __u32 size)
> > {
> >       bool good_kern_stack = false, good_user_stack = false;
> >       const char *nonjit_func = "___bpf_prog_run";
> > @@ -65,75 +72,76 @@ static int get_stack_print_output(void *data, int size)
> >               if (e->user_stack_size > 0 && e->user_stack_buildid_size > 0)
> >                       good_user_stack = true;
> >       }
> > -     if (!good_kern_stack || !good_user_stack)
> > -             return LIBBPF_PERF_EVENT_ERROR;
> >
> > -     if (cnt == MAX_CNT_RAWTP)
> > -             return LIBBPF_PERF_EVENT_DONE;
> > -
> > -     return LIBBPF_PERF_EVENT_CONT;
> > +     if (!good_kern_stack)
> > +         CHECK(!good_kern_stack, "bad_kern_stack", "bad\n");
>
> Two "bad" is a little weird. How about "kern stack", "bad"?

Heh :) I'll add something more human-readable, like "failed to get
kernel stack".

>
> > +     if (!good_user_stack)
> > +         CHECK(!good_user_stack, "bad_user_stack", "bad\n");
> > }
> >
> > void test_get_stack_raw_tp(void)
> > {

[...]
