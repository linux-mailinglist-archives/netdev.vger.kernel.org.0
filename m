Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9F2675F6
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgIKWef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgIKWe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:34:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4D7C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:34:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x14so12847246wrl.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 15:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s9eD60+EBxHRn5HkCgdAAnDMIN2I4k3svQO2Ym6pIOI=;
        b=Z78DqAELSBmN6zTx1+yWiIR34ifT55bYax3ENgP8PzqJbdMVEV7Ms9HqBG8kUU87Eh
         rhHlPiryVxyhf7JczwI7eCKfN6OYa7IS61mX65Ln0vhj/jVc6hR6L1qKhhBkt27jQ1f1
         Y1AAkT6b36KKhuD8IkOLtNQtcGRX+SaRlLilE7S6R+JLWTZOYplGQ4kI74yuk1EttlWY
         okXOUgkdDo1NZ7Cq54wkP0gtVVN04TdlJd8KQrj8+E+DULEha5NJWz9NeLGYbXz94C08
         FfCoO3SjpzSeUzJLaN+xW8fSuJqq4riQ8mDiTnqTAMwcoes9s2s002Ee7VPaZGNHyAYD
         pp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s9eD60+EBxHRn5HkCgdAAnDMIN2I4k3svQO2Ym6pIOI=;
        b=P3IabY1NuieHxSfcD10S3o0lAFkAsXhEo0NbDmNUc6Be3JhF+R9nnUGbIKJV/gZCiB
         o1uzmqz0YIcDTWpAwdcj1MX2BHOcSkXRvDku1YmkLDj86Ri/TlpNloc6G0Yb9Jpjcj3T
         DERFezo2R2wPFya8SCRPQxtdRmQjpB1A88Vi4SVIprCDwFMV1KKoRrRkvk2Cfv4VAJWM
         ZV7POwx7PB2ClLwbT2GKAAz3NuNs6TtmgEBtBKKhF2XqYPstXlwyFzmPdbfT23WryXPM
         Bm37okeEVNTNDp2l97s9qiXsBnYyip4FO3oPWXv/c1LU3wVWDHJudRatPpfVyOqT6qhp
         dx4A==
X-Gm-Message-State: AOAM533fpnceMiBFyXcPTE423n1GZvXlsioSMiIPkqbe4WW/qEH+lNtE
        Xmelzyf7Ip3O5eOfDD+Uq5lMvWeqxpvcjCrQpEdSPw==
X-Google-Smtp-Source: ABdhPJzpxSXARoJ7MR+weI9o3sCg15ocmJabVb4PObSHAgKEilDM7scfi80eN6kqgsSh6sWhvl2TFQCUCLRLvcXzV48=
X-Received: by 2002:a5d:458a:: with SMTP id p10mr3961913wrq.282.1599863665870;
 Fri, 11 Sep 2020 15:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200728085734.609930-1-irogers@google.com> <20200728085734.609930-3-irogers@google.com>
 <20200728155940.GC1319041@krava> <20200728160954.GD1319041@krava>
 <CAP-5=fVqto0LrwgW6dHQupp7jFA3wToRBonBaXXQW4wwYcTreg@mail.gmail.com>
 <CAP-5=fWNniZuYfYhz_Cz7URQ+2E4T4Kg3DJqGPtDg70i38Er_A@mail.gmail.com>
 <20200904160303.GD939481@krava> <CAP-5=fWOSi4B3g1DARkh6Di-gU4FgmjnhbPYRBdvSdLSy_KC5Q@mail.gmail.com>
 <20200904184803.GA3749996@kernel.org> <20200904185013.GA3752059@kernel.org> <20200904185106.GB3752059@kernel.org>
In-Reply-To: <20200904185106.GB3752059@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Fri, 11 Sep 2020 15:34:11 -0700
Message-ID: <CAP-5=fXn74c-TAzOCLz2O1XZ773dwUz5nCHwQXp5nuQzWBS64A@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 11:51 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Em Fri, Sep 04, 2020 at 03:50:13PM -0300, Arnaldo Carvalho de Melo escrev=
eu:
> > Em Fri, Sep 04, 2020 at 03:48:03PM -0300, Arnaldo Carvalho de Melo escr=
eveu:
> > > Em Fri, Sep 04, 2020 at 09:22:10AM -0700, Ian Rogers escreveu:
> > > > On Fri, Sep 4, 2020 at 9:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > On Thu, Sep 03, 2020 at 10:41:14PM -0700, Ian Rogers wrote:
> > > > > > On Wed, Jul 29, 2020 at 4:24 PM Ian Rogers <irogers@google.com>=
 wrote:
> > > > > > > On Tue, Jul 28, 2020 at 9:10 AM Jiri Olsa <jolsa@redhat.com> =
wrote:
> > > > > > > > On Tue, Jul 28, 2020 at 05:59:46PM +0200, Jiri Olsa wrote:
> > > > > > > > > On Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers wrot=
e:
> > > > > > > > [jolsa@krava perf]$ sudo ./perf test 17 -v
> > > > > > > > 17: Setup struct perf_event_attr                          :
> > >
> > > > > > > > running './tests/attr/test-record-C0'
> > > > > > > > expected sample_period=3D4000, got 3000
> > > > > > > > FAILED './tests/attr/test-record-C0' - match failure
> > >
> > > > > > > I'm not able to reproduce this. Do you have a build configura=
tion or
> > > > > > > something else to look at? The test doesn't seem obviously co=
nnected
> > > > > > > with this patch.
> > >
> > > > > > Jiri, any update? Thanks,
> > >
> > > > > sorry, I rebased and ran it again and it passes for me now,
> > > > > so it got fixed along the way
> > >
> > > > No worries, thanks for the update! It'd be nice to land this and th=
e
> > > > other libpfm fixes.
> > >
> > > I applied it and it generated this regression:
> > >
> > > FAILED '/home/acme/libexec/perf-core/tests/attr/test-record-pfm-perio=
d' - match failure
> > >
> > > I'll look at the other patches that are pending in this regard to see
> > > what needs to be squashed so that we don't break bisect.
> >
> > So, more context:
> >
> > running '/home/acme/libexec/perf-core/tests/attr/test-record-pfm-period=
'
> > expected exclude_hv=3D0, got 1
> > FAILED '/home/acme/libexec/perf-core/tests/attr/test-record-pfm-period'=
 - match failure
> > test child finished with -1
> > ---- end ----
> > Setup struct perf_event_attr: FAILED!
> > [root@five ~]#
> >
> > Ian, can you take a look at this?
>
> Further tests I've performed:
>
>     Committer testing:
>
>     Not linking with libpfm:
>
>       # ldd ~/bin/perf | grep libpfm
>       #
>
>     Before:
>
>       # perf record -c 10000 -e cycles/period=3D12345/,instructions sleep=
 0.0001
>       [ perf record: Woken up 1 times to write data ]
>       [ perf record: Captured and wrote 0.052 MB perf.data (258 samples) =
]
>       # perf evlist -v
>       cycles/period=3D12345/: size: 120, { sample_period, sample_freq }: =
12345, sample_type: IP|TID|TIME|ID, read_format: ID, disabled: 1, inherit: =
1, mmap: 1, comm: 1, enable_on_exec: 1, task: 1, sample_id_all: 1, exclude_=
guest: 1, mmap2: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
>       instructions: size: 120, config: 0x1, { sample_period, sample_freq =
}: 10000, sample_type: IP|TID|TIME|ID, read_format: ID, disabled: 1, inheri=
t: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
>       #
>
>     After:
>
>       #
>       # perf record -c 10000 -e cycles/period=3D12345/,instructions sleep=
 0.0001
>       [ perf record: Woken up 1 times to write data ]
>       [ perf record: Captured and wrote 0.053 MB perf.data (284 samples) =
]
>       # perf evlist -v
>       cycles/period=3D12345/: size: 120, { sample_period, sample_freq }: =
12345, sample_type: IP|TID|TIME|ID, read_format: ID, disabled: 1, inherit: =
1, mmap: 1, comm: 1, enable_on_exec: 1, task: 1, sample_id_all: 1, exclude_=
guest: 1, mmap2: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
>       instructions: size: 120, config: 0x1, { sample_period, sample_freq =
}: 10000, sample_type: IP|TID|TIME|ID, read_format: ID, disabled: 1, inheri=
t: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
>       #
>
>     Linking with libpfm:
>
>       # ldd ~/bin/perf | grep libpfm
>             libpfm.so.4 =3D> /lib64/libpfm.so.4 (0x00007f54c7d75000)
>       #
>
>       # perf record -c 10000 --pfm-events=3Dcycles:period=3D77777 sleep 1
>       [ perf record: Woken up 1 times to write data ]
>       [ perf record: Captured and wrote 0.043 MB perf.data (141 samples) =
]
>       # perf evlist -v
>       cycles:period=3D77777: size: 120, { sample_period, sample_freq }: 1=
0000, sample_type: IP|TID|TIME, read_format: ID, disabled: 1, inherit: 1, e=
xclude_hv: 1, mmap: 1, comm: 1, enable_on_exec: 1, task: 1, sample_id_all: =
1, exclude_guest: 1, mmap2: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
>       #
>
>     After:
>
>       # perf record -c 10000 --pfm-events=3Dcycles:period=3D77777 sleep 1
>       [ perf record: Woken up 1 times to write data ]
>       [ perf record: Captured and wrote 0.039 MB perf.data (19 samples) ]
>       # perf evlist -v
>       cycles:period=3D77777: size: 120, { sample_period, sample_freq }: 7=
7777, sample_type: IP|TID|TIME, read_format: ID, disabled: 1, inherit: 1, e=
xclude_hv: 1, mmap: 1, comm: 1, enable_on_exec: 1, task: 1, sample_id_all: =
1, exclude_guest: 1, mmap2: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
>       #
>
Hi Arnaldo,

I've been trying to reproduce the test failure you mention and I've
not been able to. This follow up e-mail seems to show things working
as intended. Did the issue resolve itself?

Thanks,
Ian
