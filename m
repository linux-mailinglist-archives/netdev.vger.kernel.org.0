Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11B01CFC13
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgELRXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELRXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:23:38 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F73C061A0C;
        Tue, 12 May 2020 10:23:38 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id y22so1808962qki.3;
        Tue, 12 May 2020 10:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jYAwQqCKZY/JEO+42Y6cCIX9mgCJiPaIoAUPgyyKQK4=;
        b=DgpMTRL6lkyuInt+9sKLoC1QipR7zMBQ68YOpWao9aSpzCwiRM75NpCZIL2Y8QyIVk
         3/mKbYzbH+i+sD076N/GY5l++4YFzSoA5rYizCOD/HGg5AWQDDDhaE1/H+mpOfRg4mEO
         7isIV0h/gkqfHquIvCuQ2iHoAJDc8DOmpAxSdb9kuFBiCTXc50JxyADLNX9hQXkcbNOq
         ioLGkvyQjqlpkni0DUa/wNeZU9RVVyGImy5YnhhGlSIHIHeTJijtmV9vjZmfEZnhfE3F
         4iBhmAFTrXOboVRp+HhXF37x82nq2UF+RyrfBkpLIv/tno1fJHU4BDJJTqBRNcgPche0
         hANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jYAwQqCKZY/JEO+42Y6cCIX9mgCJiPaIoAUPgyyKQK4=;
        b=kLqer/TBOcqVmK6ZQcbbASAVM/bB6T2U8g0FuetqzGnUczogjeR6XmFDG2tATmzXMs
         yl8J0GGbFm7nCSTI0GhRfP1i3xBn/86EIJqFbx/YdK4vcEsdZ/4a/ycpfnzIHq43qzTv
         q43ZFtDkRaHOJtoDokZaRbgwEUnzeCa5ziqNHaP+PjMMODlwqfM87M0npgxoW+Ri2Hlq
         kUd6vr1fataTv9dP0TiPlHubyAiIaZpXSzc1diCvOQE6bmWgYPiMbMj9iEJxOWkRD3ZI
         t64Hk7EU3e005XG5quYF1wGgKwSrYAML6GpEDuoU4AWiSTiiSMdttYUXxI1I86d1v3cJ
         Zj0g==
X-Gm-Message-State: AGi0PubG+yPeimsnqGi73ZilYy15ZavWfepE6zphXbMisY5z/N9V4wVQ
        3wGvRLlnmGaNgqm/70jsCOQdtvCjqor8F/YMGNegAg==
X-Google-Smtp-Source: APiQypInae0G69eii23/QdXHd4LmnARdMrh7GG9JqjRqm8m8pVe+f/YOFqF48RqHjH7/o3TDPWuQ8XEwkSwKuoACSqc=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr21475420qkj.92.1589304217693;
 Tue, 12 May 2020 10:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200508232032.1974027-1-andriin@fb.com> <20200508232032.1974027-3-andriin@fb.com>
 <c2fbefd2-6137-712e-47d4-200ef4d74775@fb.com> <CAEf4BzaXUwgr70WteC=egTgii=si8OvVLCL9KCs-KwkPRPGQjQ@mail.gmail.com>
 <b06ff0a8-2f44-522f-f071-141072d6f62b@fb.com>
In-Reply-To: <b06ff0a8-2f44-522f-f071-141072d6f62b@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 10:23:26 -0700
Message-ID: <CAEf4BzY71QEmq74B8y-AmW1LFhFZ35TwO5vLn4AOiJPOSVqtjw@mail.gmail.com>
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

On Tue, May 12, 2020 at 8:11 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/11/20 9:22 PM, Andrii Nakryiko wrote:
> > On Sat, May 9, 2020 at 10:24 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 5/8/20 4:20 PM, Andrii Nakryiko wrote:
> >>> Add fmod_ret BPF program to existing test_overhead selftest. Also re-=
implement
> >>> user-space benchmarking part into benchmark runner to compare results=
.  Results
> >>> with ./bench are consistently somewhat lower than test_overhead's, bu=
t relative
> >>> performance of various types of BPF programs stay consisten (e.g., kr=
etprobe is
> >>> noticeably slower).
> >>>
> >>> run_bench_rename.sh script (in benchs/ directory) was used to produce=
 the
> >>> following numbers:
> >>>
> >>>     base      :    3.975 =C2=B1 0.065M/s
> >>>     kprobe    :    3.268 =C2=B1 0.095M/s
> >>>     kretprobe :    2.496 =C2=B1 0.040M/s
> >>>     rawtp     :    3.899 =C2=B1 0.078M/s
> >>>     fentry    :    3.836 =C2=B1 0.049M/s
> >>>     fexit     :    3.660 =C2=B1 0.082M/s
> >>>     fmodret   :    3.776 =C2=B1 0.033M/s
> >>>
> >>> While running test_overhead gives:
> >>>
> >>>     task_rename base        4457K events per sec
> >>>     task_rename kprobe      3849K events per sec
> >>>     task_rename kretprobe   2729K events per sec
> >>>     task_rename raw_tp      4506K events per sec
> >>>     task_rename fentry      4381K events per sec
> >>>     task_rename fexit       4349K events per sec
> >>>     task_rename fmod_ret    4130K events per sec
> >>
> >> Do you where the overhead is and how we could provide options in
> >> bench to reduce the overhead so we can achieve similar numbers?
> >> For benchmarking, sometimes you really want to see "true"
> >> potential of a particular implementation.
> >
> > Alright, let's make it an official bench-off... :) And the reason for
> > this discrepancy, turns out to be... not atomics at all! But rather a
> > single-threaded vs multi-threaded process (well, at least task_rename
> > happening from non-main thread, I didn't narrow it down further).
>
> It would be good to find out why and have a scheme (e.g. some kind
> of affinity binding) to close the gap.

I don't think affinity has anything to do with this. test_overhead
sets affinity for entire process, and that doesn't change results at
all. Same for bench, both with and without setting affinity, results
are pretty much the same. Affinity helps a bit to get a bit more
stable and consistent results, but doesn't hurt or help performance
for this benchmark.

I don't think we need to spend that much time trying to understand
behavior of task renaming for such a particular setup. Benchmarking
has to be multi-threaded in most cases anyways, there is no way around
that.

>
> > Atomics actually make very little difference, which gives me a good
> > peace of mind :)
> >
> > So, I've built and ran test_overhead (selftest) and bench both as
> > multi-threaded and single-threaded apps. Corresponding results match
> > almost perfectly. And that's while test_overhead doesn't use atomics
> > at all, while bench still does. Then I also ran test_overhead with
> > added generics to match bench implementation. There are barely any
> > differences, see two last sets of results.
> >
> > BTW, selftest results seems bit lower from the ones in original
> > commit, probably because I made it run more iterations (like 40 times
> > more) to have more stable results.
> >
> > So here are the results:
> >
> > Single-threaded implementations
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > /* bench: single-threaded, atomics */
> > base      :    4.622 =C2=B1 0.049M/s
> > kprobe    :    3.673 =C2=B1 0.052M/s
> > kretprobe :    2.625 =C2=B1 0.052M/s
> > rawtp     :    4.369 =C2=B1 0.089M/s
> > fentry    :    4.201 =C2=B1 0.558M/s
> > fexit     :    4.309 =C2=B1 0.148M/s
> > fmodret   :    4.314 =C2=B1 0.203M/s
> >
> > /* selftest: single-threaded, no atomics */
> > task_rename base        4555K events per sec
> > task_rename kprobe      3643K events per sec
> > task_rename kretprobe   2506K events per sec
> > task_rename raw_tp      4303K events per sec
> > task_rename fentry      4307K events per sec
> > task_rename fexit       4010K events per sec
> > task_rename fmod_ret    3984K events per sec
> >
> >
> > Multi-threaded implementations
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> >
> > /* bench: multi-threaded w/ atomics */
> > base      :    3.910 =C2=B1 0.023M/s
> > kprobe    :    3.048 =C2=B1 0.037M/s
> > kretprobe :    2.300 =C2=B1 0.015M/s
> > rawtp     :    3.687 =C2=B1 0.034M/s
> > fentry    :    3.740 =C2=B1 0.087M/s
> > fexit     :    3.510 =C2=B1 0.009M/s
> > fmodret   :    3.485 =C2=B1 0.050M/s
> >
> > /* selftest: multi-threaded w/ atomics */
> > task_rename base        3872K events per sec
> > task_rename kprobe      3068K events per sec
> > task_rename kretprobe   2350K events per sec
> > task_rename raw_tp      3731K events per sec
> > task_rename fentry      3639K events per sec
> > task_rename fexit       3558K events per sec
> > task_rename fmod_ret    3511K events per sec
> >
> > /* selftest: multi-threaded, no atomics */
> > task_rename base        3945K events per sec
> > task_rename kprobe      3298K events per sec
> > task_rename kretprobe   2451K events per sec
> > task_rename raw_tp      3718K events per sec
> > task_rename fentry      3782K events per sec
> > task_rename fexit       3543K events per sec
> > task_rename fmod_ret    3526K events per sec
> >
> >
> [...]
