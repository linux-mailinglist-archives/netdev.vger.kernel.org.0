Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53B418411B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgCMGwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:52:21 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45641 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgCMGwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:52:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id c145so10788994qke.12;
        Thu, 12 Mar 2020 23:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXfzwzuTUKaCEm/xC0r2pLq1q6cidFQU1IMonaCv1J0=;
        b=OL0++InP1Z0QUCIW7zrL755v1AC8CJ9ooYRyzhkM4U591sEpCE2F3grAodK5mBIAIg
         X1nM7yvEpAog1YRybeE7OfqBNTvbHMU/lfP1I6EtVxZItJgOl4wPjA1xClo1Gftsys09
         NFIHR4WBvN3D9wdV4vszJdssY4ZO4VxGK3gZ7ZdEWs8mlH9xzqiYZTB0eN6FmVLfV3t5
         BRHn7uPVt0qRB8HhtklC+nf3xP32NEkzn8iqhrW1X6hP3lttb0NESlzHPzXeNJELXpSa
         Y0RXZ3ySgqeVOuP2085+s9K9WlsJirJw8lPjEfeG9knr3x1xBZFXaskZE5Yan9YP0v8I
         erJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXfzwzuTUKaCEm/xC0r2pLq1q6cidFQU1IMonaCv1J0=;
        b=uDFwBYj5p8nGmBIKsXTGB7HpmaNK07IeMUHXiSOsnyc9cDjHCh6wVT2DQL4Ke8nAc8
         mWeT9wBa788w8LxkkZQzO9O1+wRr4RICijg8jtSVXuwJKdCKvYxO853j0nwa372rW4h2
         mTrFhRiWQvAU7jm7h4FsN+MXtU3EFkAG1oXHm3Ss3z0xgD/wGQ2NxZKBKWVBj9ToX6wg
         ntr2T+cQ3UHyfY27rhv2nmyaDlVYz6ThkGt4bvKliLPxkkmV/M70nQJyfoP4YDRAxQKJ
         whyWt9hdAA5X/XWNvdwoOOpgD8HJv/P/pNJWdvrEA+NYYbWn6oFcesMV3zkU0bE2UO7z
         V91g==
X-Gm-Message-State: ANhLgQ2oQuHWq5zgGJpwbNOEQN6G3EhATKlyel0VL9BL4geLZzVChXEQ
        pPR+wgfCFgVeH9XxyJSkZ8n7yDjWfdlqC+3XHaA=
X-Google-Smtp-Source: ADFU+vvZp3kqWFbJ46iA2ECcE5rqSgO4Y/JDCjzRMKoIXwQb/chqo6MkPaYui/XQ3WXqadic0xyudDWIbGjIdBo1Y6I=
X-Received: by 2002:a37:9104:: with SMTP id t4mr12032448qkd.449.1584082339833;
 Thu, 12 Mar 2020 23:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200313061837.3685572-1-andriin@fb.com> <20200313064521.se2sqpgkpd5ekmfo@ast-mbp>
In-Reply-To: <20200313064521.se2sqpgkpd5ekmfo@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Mar 2020 23:52:08 -0700
Message-ID: <CAEf4BzZDRQ7J5_1RN+wK1aD-LxdWD7FTbZpo+qPm8_yuGQ766Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix usleep() implementation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 11:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 12, 2020 at 11:18:37PM -0700, Andrii Nakryiko wrote:
> > nanosleep syscall expects pointer to struct timespec, not nanoseconds
> > directly. Current implementation fulfills its purpose of invoking nanosleep
> > syscall, but doesn't really provide sleeping capabilities, which can cause
> > flakiness for tests relying on usleep() to wait for something.
> >
> > Fixes: ec12a57b822c ("selftests/bpf: Guarantee that useep() calls nanosleep() syscall")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/testing/selftests/bpf/test_progs.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > index 2b0bc1171c9c..b6201dd82edf 100644
> > --- a/tools/testing/selftests/bpf/test_progs.c
> > +++ b/tools/testing/selftests/bpf/test_progs.c
> > @@ -35,7 +35,16 @@ struct prog_test_def {
> >   */
> >  int usleep(useconds_t usec)
> >  {
> > -     return syscall(__NR_nanosleep, usec * 1000UL);
> > +     struct timespec ts;
> > +
> > +     if (usec > 999999) {
> > +             ts.tv_sec = usec / 1000000;
> > +             ts.tv_nsec = usec % 1000000;
> > +     } else {
> > +             ts.tv_sec = 0;
> > +             ts.tv_nsec = usec;
> > +     }
> > +     return nanosleep(&ts, NULL);
> >  }
>
> Is this a copy-paste from somewhere?

nope, my very own prematurely optimized implementation :)

> Above 'if' looks like premature optimization.
> I applied it anyway, since it fixes flakiness in test_progs -n 24.
> Now pin*tp* tests are stable.
>

Great, I hoped as much.

> But the other one is still flaky:
> server_thread:FAIL:237
> Failed to accept client: Resource temporarily unavailable
> #64 tcp_rtt:FAIL
> Note that if I run the test alone (test_progs -n 64) it is stable.
> It fails only when run as part of bigger test_progs.
> test_progs -n 30-64 sporadically fails (most of the time)
> test_progs -n 40-64 consistently passes
> Haven't bisected further.

Okey, I'll get to it once I'm done fixing a bunch of other problems.
Seems like tcp_rtt needs some more love, sigh... :(
