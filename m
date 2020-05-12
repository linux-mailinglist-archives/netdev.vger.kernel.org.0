Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE71CEBE4
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 06:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgELEWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 00:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725889AbgELEWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 00:22:43 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF4EC061A0C;
        Mon, 11 May 2020 21:22:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id i14so11203159qka.10;
        Mon, 11 May 2020 21:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QIdyJGJDkUzmabK7QgojYQqqYanIjX7RhN563aXXAhU=;
        b=YaZOeclshwGycv46RO8Oi2laGNpi5VjvC1nZadIHha2sOBPy/DnTiMteDFFTvrzWVA
         qmOehG7CTujjQRsR1f3jTXRVJ8EjBmbXuWe8X8wAaw0txPDffjYM4XCgwPI9gQQjuhoJ
         sV0+Id0cEMDj162XyBixwtS6vIEhDkHgDJ5PXcvMsVMW+QR0+b0KWdHQ/JN7ZTdtRJs1
         7vaUzRsScAb5tRXR92xJ0v/Es51DT839ujWeBQrkgq3/mSQ0q5N8j7JPKMPtec49bj9w
         mBxXZk7U5z7T0G8IGF6KJm1fZZAvFRRJKefsJLekN05QfTo/K0AkKnS7bdklv6+pifAu
         EpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QIdyJGJDkUzmabK7QgojYQqqYanIjX7RhN563aXXAhU=;
        b=be0bEMgJ6trrlMkha8lGt104kt7xxQXTNo3DUvXNQk9zrd30aKhGJzAMnriF0wPoI4
         eDTNEwDARfeCbmhvNAJv6ZnWLBarHtKW00/7j8Nch1k0HlGE6j+8a31gMOVEu6b0welg
         0oRXgpZLeNuaGVW9j7v8BY8oYi4JsgYw7Tk6I9AuRtB3Tt38BxM04eNT13SWRAHOzgE5
         xH3ZRfdaQPkk7v6f3KqCPQVGyqowUesd5JmlIUgaBIp7yk2NhxTcRUqQG4qkE7KPposv
         +f6abLDEvPcSuqdjASxEoEgVk6V6SriJX9W3fq3T8y2whrXCqqb/fD9dpOgd1AtNiRQE
         iTsw==
X-Gm-Message-State: AGi0PuZ7oIY1hO8gEkzhmpIKlHeKb4rlkLe2s9THkFldQjgEHuDXexOf
        efS1exjKUV71NBFTqL70Ls9pO/T5Fm4PfObGkYA=
X-Google-Smtp-Source: APiQypLJz3pz+ki8vXPvaUA8CredLUuEkoXnhxrqspTUNpdvkqHeDtR1vZDxdK/mVvBEt9OLRfIqVqjZAFuiYvw0f/0=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr20724395qka.449.1589257360759;
 Mon, 11 May 2020 21:22:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200508232032.1974027-1-andriin@fb.com> <20200508232032.1974027-3-andriin@fb.com>
 <c2fbefd2-6137-712e-47d4-200ef4d74775@fb.com>
In-Reply-To: <c2fbefd2-6137-712e-47d4-200ef4d74775@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 May 2020 21:22:29 -0700
Message-ID: <CAEf4BzaXUwgr70WteC=egTgii=si8OvVLCL9KCs-KwkPRPGQjQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] selftest/bpf: fmod_ret prog and implement
 test_overhead as part of bench
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 10:24 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
> > Add fmod_ret BPF program to existing test_overhead selftest. Also re-im=
plement
> > user-space benchmarking part into benchmark runner to compare results. =
 Results
> > with ./bench are consistently somewhat lower than test_overhead's, but =
relative
> > performance of various types of BPF programs stay consisten (e.g., kret=
probe is
> > noticeably slower).
> >
> > run_bench_rename.sh script (in benchs/ directory) was used to produce t=
he
> > following numbers:
> >
> >    base      :    3.975 =C2=B1 0.065M/s
> >    kprobe    :    3.268 =C2=B1 0.095M/s
> >    kretprobe :    2.496 =C2=B1 0.040M/s
> >    rawtp     :    3.899 =C2=B1 0.078M/s
> >    fentry    :    3.836 =C2=B1 0.049M/s
> >    fexit     :    3.660 =C2=B1 0.082M/s
> >    fmodret   :    3.776 =C2=B1 0.033M/s
> >
> > While running test_overhead gives:
> >
> >    task_rename base        4457K events per sec
> >    task_rename kprobe      3849K events per sec
> >    task_rename kretprobe   2729K events per sec
> >    task_rename raw_tp      4506K events per sec
> >    task_rename fentry      4381K events per sec
> >    task_rename fexit       4349K events per sec
> >    task_rename fmod_ret    4130K events per sec
>
> Do you where the overhead is and how we could provide options in
> bench to reduce the overhead so we can achieve similar numbers?
> For benchmarking, sometimes you really want to see "true"
> potential of a particular implementation.

Alright, let's make it an official bench-off... :) And the reason for
this discrepancy, turns out to be... not atomics at all! But rather a
single-threaded vs multi-threaded process (well, at least task_rename
happening from non-main thread, I didn't narrow it down further).
Atomics actually make very little difference, which gives me a good
peace of mind :)

So, I've built and ran test_overhead (selftest) and bench both as
multi-threaded and single-threaded apps. Corresponding results match
almost perfectly. And that's while test_overhead doesn't use atomics
at all, while bench still does. Then I also ran test_overhead with
added generics to match bench implementation. There are barely any
differences, see two last sets of results.

BTW, selftest results seems bit lower from the ones in original
commit, probably because I made it run more iterations (like 40 times
more) to have more stable results.

So here are the results:

Single-threaded implementations
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

/* bench: single-threaded, atomics */
base      :    4.622 =C2=B1 0.049M/s
kprobe    :    3.673 =C2=B1 0.052M/s
kretprobe :    2.625 =C2=B1 0.052M/s
rawtp     :    4.369 =C2=B1 0.089M/s
fentry    :    4.201 =C2=B1 0.558M/s
fexit     :    4.309 =C2=B1 0.148M/s
fmodret   :    4.314 =C2=B1 0.203M/s

/* selftest: single-threaded, no atomics */
task_rename base        4555K events per sec
task_rename kprobe      3643K events per sec
task_rename kretprobe   2506K events per sec
task_rename raw_tp      4303K events per sec
task_rename fentry      4307K events per sec
task_rename fexit       4010K events per sec
task_rename fmod_ret    3984K events per sec


Multi-threaded implementations
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

/* bench: multi-threaded w/ atomics */
base      :    3.910 =C2=B1 0.023M/s
kprobe    :    3.048 =C2=B1 0.037M/s
kretprobe :    2.300 =C2=B1 0.015M/s
rawtp     :    3.687 =C2=B1 0.034M/s
fentry    :    3.740 =C2=B1 0.087M/s
fexit     :    3.510 =C2=B1 0.009M/s
fmodret   :    3.485 =C2=B1 0.050M/s

/* selftest: multi-threaded w/ atomics */
task_rename base        3872K events per sec
task_rename kprobe      3068K events per sec
task_rename kretprobe   2350K events per sec
task_rename raw_tp      3731K events per sec
task_rename fentry      3639K events per sec
task_rename fexit       3558K events per sec
task_rename fmod_ret    3511K events per sec

/* selftest: multi-threaded, no atomics */
task_rename base        3945K events per sec
task_rename kprobe      3298K events per sec
task_rename kretprobe   2451K events per sec
task_rename raw_tp      3718K events per sec
task_rename fentry      3782K events per sec
task_rename fexit       3543K events per sec
task_rename fmod_ret    3526K events per sec


>
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   4 +-
> >   tools/testing/selftests/bpf/bench.c           |  14 ++
> >   .../selftests/bpf/benchs/bench_rename.c       | 195 +++++++++++++++++=
+
> >   .../selftests/bpf/benchs/run_bench_rename.sh  |   9 +
> >   .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
> >   .../selftests/bpf/progs/test_overhead.c       |   6 +
> >   6 files changed, 240 insertions(+), 2 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/benchs/bench_rename.c
> >   create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_renam=
e.sh
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index 289fffbf975e..29a02abf81a3 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -409,10 +409,12 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_c=
ore_extern.skel.h $(BPFOBJ)
> >   $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
> >       $(call msg,CC,,$@)
> >       $(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
> > +$(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
> >   $(OUTPUT)/bench.o: bench.h
> >   $(OUTPUT)/bench: LDLIBS +=3D -lm
> >   $(OUTPUT)/bench: $(OUTPUT)/bench.o \
> > -              $(OUTPUT)/bench_count.o
> > +              $(OUTPUT)/bench_count.o \
> > +              $(OUTPUT)/bench_rename.o
> >       $(call msg,BINARY,,$@)
> >       $(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
> >
> [...]
